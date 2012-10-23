//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================

package gn.adobe.genie
{
	import flash.display.BitmapData;
	import flash.display.ColorCorrection;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.net.XMLSocket;
	import flash.net.getClassByAlias;
	import flash.system.ApplicationDomain;
	import flash.ui.*;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import gn.adobe.com.GenieCom;
	import gn.adobe.com.IGenieCom;
	import gn.adobe.logging.GenieLog;
	import gn.adobe.logging.GenieLogConst;
	import gn.adobe.logging.IGenieLog;
	import gn.adobe.shared.SharedFunctions;
	
	import mx.automation.Automation;
	import mx.automation.AutomationManager;
	import mx.automation.IAutomationClass;
	import mx.automation.IAutomationEnvironment;
	import mx.automation.IAutomationManager;
	import mx.automation.IAutomationObject;
	import mx.automation.delegates.core.ScrollControlBaseAutomationImpl;
	import mx.automation.events.AutomationRecordEvent;
	import mx.automation.events.AutomationReplayEvent;
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.core.EventPriority;
	import mx.core.IChildList;
	import mx.core.IFlexModuleFactory;
	import mx.core.IRawChildrenContainer;
	import mx.core.Singleton;
	import mx.events.*;
	import mx.formatters.DateFormatter;
	import mx.graphics.ImageSnapshot;
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	import mx.managers.DragManager;
	import mx.managers.SystemManager;
	import mx.modules.ModuleManager;
	import mx.rpc.xml.SimpleXMLEncoder;
	import mx.utils.Base64Encoder;
	import mx.utils.ObjectProxy;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	
	public class CommandsMain
	{
		//Declarations
		
		//private vars
		private var lastGlow:Object;
		private var bExists:Boolean = false;
		private var bDelta:Boolean = false;
		private var am:IAutomationManager;
		private var bRecordUIEvents:Boolean = true;
		private var previousColorCorrection:String = ColorCorrection.DEFAULT;
		private var bAppLoaded:Boolean = false;
		private var dictPlayback:Dictionary = new Dictionary();
		private var bForceRegister:Boolean = false;
		private var strLastStep:String = "";
		private var lastObjectRemoved:Object = null;
		private var genieIDLastObjectRemoved:String = null;
		private var strPreviousEvent:String = "";
		private var bCreateNewXMLTag:Boolean = true;
		private var strGenieIDForHighlight:String = null;
		private var eventDictionary:Dictionary = new Dictionary();
		public  var bStepRecorded:Boolean = false;
		public var deltaReady:Boolean = false;
		private static var bEnableFinder:Boolean = false;
		
		protected var objLogs:IGenieLog;
		protected var rootObject:Object;
		protected var strGenieID:String;
		protected var strApplicationName:String = "";
		protected var objGetGenieIdFromObject:Dictionary = new Dictionary(true);
		protected var objDeletedObject:Dictionary = new Dictionary(true);
		protected var strlastClicked:String;
		protected var arrProperty:Array = new Array();
		protected var dictIdentifiers:Dictionary = new Dictionary();
		protected var arrStaticIdentifiers:Array = new Array();
		protected static var objCom:IGenieCom;
		
		public var appXML:XML;
		public var isDebugTrue:Boolean = false;
		private var dontPropagateActionPerformed:Boolean = false;
		public var isRecording:Boolean = false;
		public var strExtendedClassName:String = "";
		public var arrGenieId:Array = new Array();
		public var topGenieID:String = null;
		public var objectArray:Dictionary = new Dictionary(true);
		public var removeObjectList:ArrayList = new ArrayList();
		
		public var bDisplayObjectRecorded:Boolean = false;
		
		public static var strLastUIStep:String = "";
		
		protected var arrPropertiesToIgnore:Array = new Array();
		
		//Handles the property changeevent
		private static var initialXML:XML;
		private static var finalXML:XML;
		private static var nTimerCount:int = 0;
		private static var objVerboseTarget:Object = new Object();
		private static var strDifference:String = "";
		private var timerApp:Timer;
		public var objGames:GamesGenieIDFunctions;
				
		public function CommandsMain(rootObject:Object, strApplicationName:String):void
		{
			//If clause is introduced because GamesGenieId class the super ans we dont want to instantiate it again and again
			if(!GenieMix.command)
			{
				this.rootObject = rootObject;
				
				this.objLogs = GenieMix.genieLog;
				this.strApplicationName = strApplicationName;			
				
				objLogs.traceLog(GenieLogConst.INFO," Commands object initialized");
				arrProperty = SharedFunctions.getPropertyArray();
								
				dictIdentifiers["ID"] = "id";
				dictIdentifiers["AN"] = "automationName";
				dictIdentifiers["CN"] = "name";
				dictIdentifiers["IX"] = "index";
				dictIdentifiers["ITR"] = "Iterative Index";
				
				dictIdentifiers["SP"] = "Second Level Valid Parent";
				dictIdentifiers["FP"] = "First Level Valid Parent";
				dictIdentifiers["CH"] = "First Valid Child";
				dictIdentifiers["SE"] = "Self";
				
				arrStaticIdentifiers.push("ID");
				arrStaticIdentifiers.push("AN");
				arrStaticIdentifiers.push("CN");
				arrStaticIdentifiers.push("IX");
				arrStaticIdentifiers.push("ITR");
				
				arrStaticIdentifiers.push("SP");
				arrStaticIdentifiers.push("FP");
				arrStaticIdentifiers.push("CH");
				arrStaticIdentifiers.push("SE");
				
				arrPropertiesToIgnore.push("root");
				arrPropertiesToIgnore.push("mask");
				arrPropertiesToIgnore.push("scaleZ");
				arrPropertiesToIgnore.push("mouseX");
				arrPropertiesToIgnore.push("mouseY");
				arrPropertiesToIgnore.push("rotationX");
				arrPropertiesToIgnore.push("rotationY");
				arrPropertiesToIgnore.push("rotationZ");
				arrPropertiesToIgnore.push("cacheAsBitmap");
				arrPropertiesToIgnore.push("scrollRect");
				arrPropertiesToIgnore.push("filters");
				arrPropertiesToIgnore.push("opaqueBackground");
				arrPropertiesToIgnore.push("blendMode");
				arrPropertiesToIgnore.push("transform");
				arrPropertiesToIgnore.push("scale9Grid");
				arrPropertiesToIgnore.push("loaderInfo");
				arrPropertiesToIgnore.push("accessibilityProperties");
				arrPropertiesToIgnore.push("parentDocument");
				arrPropertiesToIgnore.push("moduleFactory");
				arrPropertiesToIgnore.push("flexContextMenu");
				arrPropertiesToIgnore.push("initialized");
				arrPropertiesToIgnore.push("scaleY");
				arrPropertiesToIgnore.push("scaleX");
				arrPropertiesToIgnore.push("systemManager");
				arrPropertiesToIgnore.push("instanceIndices");
				arrPropertiesToIgnore.push("isDocument");
				arrPropertiesToIgnore.push("repeaterIndices");
				arrPropertiesToIgnore.push("styleName");
				arrPropertiesToIgnore.push("numAutomationChildren");
				arrPropertiesToIgnore.push("document");
				arrPropertiesToIgnore.push("inheritingStyles");
				arrPropertiesToIgnore.push("nonInheritingStyles");
				arrPropertiesToIgnore.push("styleDeclaration");
				arrPropertiesToIgnore.push("automationTabularData");
				arrPropertiesToIgnore.push("repeater");
				arrPropertiesToIgnore.push("focusRect");
				arrPropertiesToIgnore.push("accessibilityImplementation");
				arrPropertiesToIgnore.push("softKeyboardInputAreaOfInterest");
				arrPropertiesToIgnore.push("needsSoftKeyboard");
				arrPropertiesToIgnore.push("contextMenu");
				arrPropertiesToIgnore.push("graphics");
				arrPropertiesToIgnore.push("style");
				arrPropertiesToIgnore.push("textSnapshot");
				arrPropertiesToIgnore.push("mouseChildren");
				arrPropertiesToIgnore.push("focusManager");
				arrPropertiesToIgnore.push("nestLevel");
				arrPropertiesToIgnore.push("processedDescriptors");
				arrPropertiesToIgnore.push("descriptor");
				arrPropertiesToIgnore.push("y");
				arrPropertiesToIgnore.push("x");
				arrPropertiesToIgnore.push("z");
				arrPropertiesToIgnore.push("contentMouseX");
				arrPropertiesToIgnore.push("contentMouseY");
				arrPropertiesToIgnore.push("contentMouseZ");
				arrPropertiesToIgnore.push("parentApplication");
				arrPropertiesToIgnore.push("focusEnabled");
				arrPropertiesToIgnore.push("mouseFocusEnabled");
				arrPropertiesToIgnore.push("repeaterIndex");
				arrPropertiesToIgnore.push("dropTarget");
				arrPropertiesToIgnore.push("hitArea");
				arrPropertiesToIgnore.push("activeEffects");
				arrPropertiesToIgnore.push("soundTransform");
				arrPropertiesToIgnore.push("measuredWidth");
				arrPropertiesToIgnore.push("measuredHeight");
				arrPropertiesToIgnore.push("equipmentType");
				arrPropertiesToIgnore.push("explicitHeight");
				arrPropertiesToIgnore.push("explicitMaxHeight");
				arrPropertiesToIgnore.push("explicitMinWidth");
				arrPropertiesToIgnore.push("includeInLayout");
				arrPropertiesToIgnore.push("explicitMaxWidth");
				arrPropertiesToIgnore.push("focusPane");
				arrPropertiesToIgnore.push("explicitMinHeight");
				arrPropertiesToIgnore.push("maxHeight");
				arrPropertiesToIgnore.push("maxWidth");
				arrPropertiesToIgnore.push("measuredMinHeight");
				arrPropertiesToIgnore.push("minWidth");
				arrPropertiesToIgnore.push("percentWidth");
				arrPropertiesToIgnore.push("minHeight");
				arrPropertiesToIgnore.push("baselinePosition");
				arrPropertiesToIgnore.push("percentHeight");
				arrPropertiesToIgnore.push("tweeningProperties");
				arrPropertiesToIgnore.push("alpha");
				arrPropertiesToIgnore.push("content");
				arrPropertiesToIgnore.push("screen");
				arrPropertiesToIgnore.push("explicitWidth");
				arrPropertiesToIgnore.push("cachePolicy");
				arrPropertiesToIgnore.push("automationDelegate");
				arrPropertiesToIgnore.push("repeaters");
				
				arrPropertiesToIgnore.push("width");
				arrPropertiesToIgnore.push("height");
				arrPropertiesToIgnore.push("name");
			}
		}
		
		public function updateRootObject():void
		{
			rootObject.colorCorrection = ColorCorrection.OFF;
		}
		
		public static function init():void
		{
			objCom = GenieMix.genieCom;			
		}
		
		public function returnApplicationHierarchy(strAppName:String):void
		{
			try
			{
				objLogs.detailedTrace(GenieLogConst.INFO,"in returnApplicationHierarchy");
				if(appXML == null)
				{
					getAppXML(strAppName);
				}
				objCom.sendCommand(GenieMix.PLUGIN_NAME_STR,"getApplicationHierarchy", appXML.toXMLString(),null);
			}
			catch(e:Error)
			{
				objLogs.traceLog(GenieLogConst.ERROR,e.message+ ":function returnApplicationHierarchy");
			}
		}
		
		private function getStageAsParentObject(rootObject:Object):Object
		{
			if(rootObject == null)
				return rootObject;
			
			if(getQualifiedClassName(rootObject).indexOf("flash.display::Stage") > -1)
				return rootObject;
			else
			{
				try
				{
					if(rootObject.parent != null)
					{
						rootObject = rootObject.parent;
						return getStageAsParentObject(rootObject);		
					}
					else
						return rootObject;
				}
				catch(e:Error)
				{
					return rootObject;
				}
				return rootObject;
			}
		}
		
		protected function getChildEligibility(objChild:Object):Boolean
		{
			var bEligible:Boolean = true;
			try
			{
				try
				{
					if(objChild.id.toString().indexOf("hidden") > -1)
					{
						bEligible = false;
						return bEligible;
					}
				}
				catch(e:Error)
				{
					bEligible = true;
				}
				
				try
				{
					if(objChild.name.toString().indexOf("hidden") > -1)
					{
						bEligible = false;
						return bEligible;
					}
				}
				catch(e:Error)
				{
					bEligible = true;
				}
				
				try
				{
					if(objChild.text.toString().indexOf("hidden") > -1)
					{
						bEligible = false;
						return bEligible;
					}
				}
				catch(e:Error)
				{
					bEligible = true;
				}
				
				try
				{
					if(objChild.label.toString().indexOf("hidden") > -1)
					{
						bEligible = false;
						return bEligible;
					}
				}
				catch(e:Error)
				{
					bEligible = true;
				}
				
			}
			catch(e:Error)
			{
				bEligible = true;
			}
			return bEligible
		}
		private function sendDeltaXML(e:TimerEvent):void
		{
			if(!deltaReady || !isDebugTrue)
				return;
			deltaReady = false;
			try{
				//First send command to remove objects
			
				var list:ArrayList = GenieMix.command.removeObjectList;
				var strToSend:String = "";
				for (var j:int = 0; i<list.length ; ++i)
				{
					strToSend = strToSend + ";"  + list.getItemAt(i);
				}
				if(strToSend.length > 0)
				{
					objCom.sendCommand(GenieMix.PLUGIN_NAME_STR,"removeObjects", strToSend,"");
					objLogs.detailedTrace(GenieLogConst.INFO, "Removed Objects "+strToSend);
					GenieMix.command.removeObjectList = new ArrayList();
				}
			}catch(deleteError:Error)
			{
				objLogs.detailedTrace(GenieLogConst.ERROR, "In exception while sending removeObjects" + deleteError.message);
			}
			try{
				var xmllist:XMLList = appXML.children();
				
				var start:Number = (new Date()).time;
				for(var i:int = 0 ; i<xmllist.length(); ++i)
				{
					processChildren(xmllist[i]);
				}
				var end:Number = (new Date()).time;
				//objLogs.traceLog("Performannce of ", "processChildren::" + (end-start));
					
			}catch(deltaError:Error)
			{
				objLogs.detailedTrace(GenieLogConst.ERROR,"In exception while sending deltaXML" + deltaError.message);
			}
				
		}
		
		private function updateFlag(currentXML:XML):void
		{
			try{
				var parentGenieID:String = currentXML.@genieID;
				var parentObject:HierarchyDictionary = objectArray[parentGenieID];
				parentObject.updated = true;
				var childXMLList:XMLList = currentXML.children();
				for(var i:int ; i<childXMLList.length(); ++i)
				{
					var childID:String  = childXMLList[i].@genieID;
					var childObject:Object = objectArray[childID];
					if(childObject != null)
					{
						childObject.updated = true;
						updateFlag(childXMLList[i]);
					}
				}
			}catch(e:Error)
			{
				objLogs.detailedTrace(GenieLogConst.ERROR,"Exception ocurred in  updateFlag" + e.message);
			}
		}
		
		private function processChildren(currentXML:XML):void
		{
			try{
				var parentGenieID:String = currentXML.@genieID;
				var childXMLList:XMLList = currentXML.children();
				for(var i:int ; i<childXMLList.length(); ++i)
				{
					var childID:String  = childXMLList[i].@genieID;
					var childObject:HierarchyDictionary = objectArray[childID];
					if(childObject != null && childObject.updated == false)
					{
						//send delta XML
						var strData:String = "<GenieID>"+parentGenieID+"</GenieID><Delta>"+childXMLList[i].toXMLString()+"</Delta>";
						objCom.sendCommand(GenieMix.PLUGIN_NAME_STR,"DeltaXML",	strData,"");
						objLogs.detailedTrace(GenieLogConst.INFO, "Delta Data: "+strData);
						updateFlag(childXMLList[i]);
					}
					else
					{
						processChildren(childXMLList[i]);
					}
				}
			}catch(e:Error)
			{
				objLogs.detailedTrace(GenieLogConst.ERROR,"Exception ocurred in  processChildren" + e.message);
			}
		}
			
		public function getAppXML(strAppName:String, strGuid:String="" , from:String = ""):XML
		{
			try{
				var strApplicationClass:String = "";
				var automationClass:IAutomationClass;
				var superClass:String = getQualifiedSuperclassName(rootObject.application);
				automationClass = IAutomationEnvironment(GenieMix.automationManager.automationEnvironment).getAutomationClassByInstance(rootObject.application);
				if(automationClass)				
					strApplicationClass = automationClass.objExtendedClassName;
			}catch(e:Error){
				
			}
			
			var xml:XML = createAppXML(strAppName);
			sendAppXML(strAppName,from,strGuid);
			
			return appXML;
		}
		
		public function getAppXmlGeneric(strAppName:String, strGuid:String, from:String):void
		{
			createAppXML(strAppName);
			
			//objLogs.detailedTrace(GenieLogConst.INFO,"application xml: "+appXML.toXMLString());
			objLogs.traceLog(GenieLogConst.INFO, "sending appXML to " + from);
			
			objCom.sendCommandWithId(from,strGuid, "appXML",appXML.toXMLString(),"");
		}
		
		protected function createAppXML(strAppName:String):XML
		{
			var t1:Date = new Date();
			if (GenieMix.isPerformanceTrackingEnabled == true)
			{
				GenieMix.startDTForAppTree = new Date();
			}
			if(appXML != null)
			{
				return appXML;
			}
			
			timerApp = new Timer(2 * 1000,0);
			
			if(strAppName == "")
			{
				objLogs.traceLog(GenieLogConst.ERROR, "AppName passed was blank. Returning back from function getAppXML");
				return null;
			}
			try
			{
				objLogs.detailedTrace(GenieLogConst.INFO,"Calling function getCurrentObject for strAppName: "+strAppName);
			}
			catch(e:Error)
			{
				objLogs.traceLog(GenieLogConst.ERROR, e.message.toString()+": in function getAppXML while calling getCurrentObject");
				return null;
			}
			
			
			objLogs.detailedTrace(GenieLogConst.INFO,"Enabling the enableGenie");
			
			var strAppXML:String = "";
			appXML = new XML;
			appXML = <GenieTree></GenieTree>;
			
			var childXML:XML = new XML();
			
			try
			{
				objLogs.detailedTrace(GenieLogConst.INFO,"adding event listeners");
				
				//Capture AutomationRecordEvent sent by AutomationManager
				Automation.automationManager.addEventListener(AutomationRecordEvent.RECORD, recordHandler, false, 0, true);
				rootObject.addEventListener(MouseEvent.MOUSE_DOWN,captureIDFromMouseDownEvent, true, 0, true);
				rootObject.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,captureIDFromMouseDownEvent, true, 0, true);
			}
			catch(e:Error)
			{
				objLogs.traceLog(GenieLogConst.ERROR, e.message.toString()+": in function getAppXML while adding event listeners. Returning.");
				return null;
			}
			
			if(strAppName != "")
			{
				strAppName = SharedFunctions.validateXMLTag(strAppName);
				objLogs.detailedTrace(GenieLogConst.INFO,"Root's qualified name " +getQualifiedClassName(rootObject.parent));
				objLogs.traceLog(GenieLogConst.INFO, "calling parseRootObject to fetch application XML.");
				rootObject = getStageAsParentObject(rootObject);
				rootObject.addEventListener(Event.ADDED,stageCapture,false, 0, true);
				rootObject.addEventListener(Event.REMOVED,deleteCapture,false, 0, true);
				
				childXML = addChildToParentXML(rootObject,rootObject.parent);
			}
			else
			{
				childXML = <GenieTree></GenieTree>;
			}
			
			try
			{
				//childXML = parseRootObject(rootObject, childXML);
				appXML.appendChild(childXML);
				objLogs.traceLog(GenieLogConst.INFO, "application XML fetched successfully.");	
			}
			catch(e:Error)
			{
				objLogs.traceLog(GenieLogConst.ERROR, "function getAppXML: "+e.message);
				return null;
			}
			
			if(strAppName.indexOf("NHFLLoader") > -1)
			{
				if(rootObject.hasOwnProperty("numChildren"))
				{
					var n:int = rootObject.numChildren;
					var objChild:DisplayObject = null;
					var objGenie:DisplayObject = null;
					for(var ab:int = 0; ab < n; ab++)
					{
						var argChild:DisplayObject = rootObject.getChildAt(ab);
						if(getQualifiedClassName(argChild).toLowerCase().indexOf("preload") == -1)
						{
							objChild = argChild;
							//Fetch the GeniePreload instance from stage using the name with which it is loaded on stage i.e. root2
							objGenie = objChild.stage.getChildByName("root1");
							objChild.stage.swapChildren(objChild, objGenie);
						}
					}
				}
			}
			
			return appXML;
		}
		public function refreshPluginAppXML():void
		{
			if(GenieMix.highPerformanceMode && isDebugTrue && appXML != null)
			{
				objCom.sendCommand(GenieMix.PLUGIN_NAME_STR, "appXML",appXML.toXMLString(),"");
			}
			
		}
		protected function sendAppXML(strAppName:String, from:String, strGuid:String):void
		{
			var xmlStr:String = "";
			if (GenieMix.isPerformanceTrackingEnabled == true)
			{
				GenieMix.endDTForAppTree = new Date();
				xmlStr = new String();
				xmlStr = "<FeatureName>GetAppXML</FeatureName>";
				xmlStr += "<AppName>" + strAppName + "</AppName>";
				xmlStr += "<StartTime>" + GenieMix.getCurrentDTStr(GenieMix.startDTForAppTree) + "</StartTime>";
				xmlStr += "<EndTime>" + GenieMix.getCurrentDTStr(GenieMix.endDTForAppTree) + "</EndTime>";
				xmlStr += "<TotalTimeTaken>"+GenieMix.getDateDiff()+"</TotalTimeTaken>";
				
				objCom.sendCommand("Server", "writePerformanceData", xmlStr, "");
			}
			
			bAppLoaded = true;
			objLogs.detailedTrace(GenieLogConst.INFO,"application xml: "+appXML.toXMLString());
			objLogs.traceLog(GenieLogConst.INFO, "sending appXML to " + from);
			
			
			
			if(from == GenieMix.EXECUTOR_NAME_STR)
			{
				objCom.sendCommandWithId(from,strGuid, "appXML","<GenieTree></GenieTree>","");
			}
			else
			{
				objCom.sendCommandWithId(from,strGuid, "appXML",appXML.toXMLString(),"");				
			}
		}
		
		/*===============================================================================
		Application Hierarchy calling  Function Ends here
		===============================================================================*/		
		
		/*===============================================================================
		Delete Objects from ObjectArray and Tree Function Begins here
		===============================================================================*/
		
		public function DeleteObjectFromTree(strTmpGenieID:String, tmpObject:Object):void
		{
			try
			{
				if(strTmpGenieID != null)
				{
					var tmpHierarchy:HierarchyDictionary = new HierarchyDictionary();
					tmpHierarchy = objectArray[strTmpGenieID];
					var output:XML = tmpHierarchy.xmlTree;

					var outputList:XMLList = new XMLList(tmpHierarchy.xmlTree);
					
					for each(var abc:XML in outputList)
					{
						if(abc.children().length() > 0)
						{
							for(var x:int = 0; x < abc.children().length(); x++)
							{
								deleteChildren(abc.children()[x]);
							}
						}
					}
			
									
					if(objectArray[strTmpGenieID] != null)
					{
						objDeletedObject[tmpObject] = strTmpGenieID;
						delete objectArray[strTmpGenieID];
					}
					
					if(objGetGenieIdFromObject[tmpObject] != null)
					{
						delete objGetGenieIdFromObject[tmpObject];
					}
					
					for(var i:int = 0; i < outputList.length(); ++i)
					{
						delete outputList[i];
					}
				}
			}
			catch(e:Error)
			{
				objLogs.detailedTrace(GenieLogConst.ERROR, e.message.toString());
			}
		}
		
		private function deleteChildren(delXML:XML):void
		{
			try
			{
				var tmpGenieID:String = "";
				var tmpObject:Object = null;
				
				if(delXML.children().length() > 0)
				{
					for(var y:int = 0; y < delXML.children().length(); y++)
					{
						deleteChildren(delXML.children()[y]);
					}
				}
				
				tmpGenieID = delXML.@genieID.toString();
				
				if(objectArray[tmpGenieID] != null)
				{
					
					tmpObject = objectArray[tmpGenieID];
					objDeletedObject[tmpObject.child] = tmpGenieID;
					delete objectArray[tmpGenieID];
				}
				
				if(objGetGenieIdFromObject[tmpObject.child] != null)
				{
					delete objGetGenieIdFromObject[tmpObject.child];
				}	
			}
			catch(e:Error)
			{
				objLogs.detailedTrace(GenieLogConst.ERROR, e.message.toString());
			}
		}
		
		protected function deleteCapture(event:Event):void
		{
			try
			{
				strlastClicked = "";
				var child:Object = event.target;
				var strTmpGenieID:String = objGetGenieIdFromObject[child];
				
				//Store last object removed and it's genie id, it is useful in cases when object is removed from array and then record event for the same is dispatched
				lastObjectRemoved = child;
				genieIDLastObjectRemoved = strTmpGenieID;			
				DeleteObjectFromTree(strTmpGenieID, child);
				if(strTmpGenieID!= null && objectArray[strTmpGenieID] == null && isDebugTrue == true)
				{
					objCom.sendCommand(GenieMix.PLUGIN_NAME_STR , "removeObject",  strTmpGenieID, "");
				}
			}
			catch(e:Error)
			{
				objLogs.traceLog(GenieLogConst.ERROR, "Error: "+e.message.toString() +" in function deleteCapture");
			}
		}
		/*===============================================================================
		Delete Objects from ObjectArray and Tree Function ends here
		===============================================================================*/	
		
		
		/*===============================================================================
		Create object hierarchy Function begins here
		===============================================================================*/			
		
		protected function createNewGenieID(tmpParent:Object):void
		{
			var tmpGenieID:String = "";
			var bParent:Boolean = true;
			var nRecursive:int = 1;
			var nGenieCounter:int = 0;
			var strSplit:Array = strGenieID.split(":::");
			var tmpArray:Array = strSplit;
			
			var strParentGenieID:String = strSplit[0].toString();
			var strChildGenieID:String = "";
			
			//This if block is added to make sure that the GenieID gets splitted
			//as per the GenieID for games/sprites and normal apps
			if(strSplit.length == 3)
				strChildGenieID = strSplit[2].toString();
			else
				strChildGenieID = strSplit[1].toString();
			
			strSplit = strChildGenieID.split("ITR^");
			strChildGenieID = strSplit[0].toString();
			nGenieCounter = strSplit[0];
			
			//trace("OldGenie: "+strGenieID);
			
			while(bParent)
			{
				if(tmpParent)
				{
					if(showInHierarchy(tmpParent))
					{
						nGenieCounter = nRecursive;
						if(tmpArray.length == 3)
							tmpGenieID = strParentGenieID + ":::" + tmpArray[1].toString() + ":::" + strChildGenieID + "ITR^" + nGenieCounter.toString();
						else
							tmpGenieID = strParentGenieID + ":::" + strChildGenieID + "ITR^" + nGenieCounter.toString();
						
						nRecursive += 1;
						
						if(objectArray[tmpGenieID] != null)
							tmpParent = tmpParent.parent;
						else
						{
							strGenieID = tmpGenieID;
							//trace("NewGenie: "+strGenieID);
							break;
						}
					}
					else
						tmpParent = tmpParent.parent;
				}
				else
				{
					//nGenieCounter = nGenieCounter + nRecursive;
					nGenieCounter = nRecursive;
					
					if(tmpArray.length == 3)
						tmpGenieID = strParentGenieID + ":::" + tmpArray[1].toString() + ":::" + strChildGenieID + "ITR^" + nGenieCounter.toString();
					else
						tmpGenieID = strParentGenieID + ":::" + strChildGenieID + "ITR^" + nGenieCounter.toString();
					
					nRecursive += 1;
					
					if(objectArray[tmpGenieID] == null)
					{
						strGenieID = tmpGenieID;
						//trace("NewGenie: "+strGenieID);
						break;
					}
				}
			}
		}
		
		//Called by addChildToParentXML to invoke recurssion on children
		protected function parseRootObject(parent:Object, parentXML:XML, bConsiderCustom:Boolean = false):XML
		{
			try
			{
				var del:Object = new Object();
				var tmpClassName:String = getQualifiedClassName(parent);
				
				del = Automation.getDelegate(parent);
				var child:* = null;
				var objXML:XML = null;
				if(del == null)
				{
					for(var j:int = 0; j < parent.numChildren; j++)
					{
						child = parent.getChildAt(j);
						if(child)
						{
							if(getChildEligibility(child))
							{
								objXML = addChildToParentXML(child,parent);
								if(parent == null)
								{
									parentXML = objXML;	
								}
								else
								{
									parentXML.appendChild(objXML);
								}
							}
						}
					}
				}
				else
				{
					if(!bConsiderCustom)
					{
						var n:int = del.numGenieAutomationChildren();
						for(var k:int = 0; k < n; k++)
						{
							//Commenting the code written for performance for time being
							//del.uiComponent = parent;
							child = del.getGenieAutomationChildAt(k);
							
							if(child)
							{
								if(getChildEligibility(child))
								{
									objXML = addChildToParentXML(child,parent);
									if(parent == null)
									{
										parentXML = objXML;	
									}
									else
									{
										parentXML.appendChild(objXML);
									}
								}
							}
						}
					}
					else
					{
						var arrChildren:Array = getNumCustomChild(parent);
						for(k = 0; k < arrChildren.length; k++)
						{
							child = arrChildren[k];
							if(child)
							{
								if(getChildEligibility(child))
								{
									objXML = addChildToParentXML(child,parent);
									if(parent == null)
									{
										parentXML = objXML;	
									}
									else
									{
										parentXML.appendChild(objXML);
									}
								}
							}
						}
					}
				}
			}
			catch(e:Error)
			{
				objLogs.traceLog(GenieLogConst.ERROR, "function parseRootObject: "+e.message);
			}
			return parentXML;
		}
		
		//called by getAPPXML to fetch app XML for root object
		public function addChildToParentXML(child:Object, parent:Object):XML
		{
			var strChildName:String = null;
			var objXML:XML;
			var tmpClass:HierarchyDictionary;
			var strParent:String = "";
			var obj:Object = new Object();
			var className:String = getQualifiedClassName(child);
			
			if(className.toLowerCase().indexOf("geniepreload") == -1)
			{
				objLogs.detailedTrace(GenieLogConst.INFO, "in addChildToParentXML for child: "+ strChildName);
				try{
					if(getChildEligibility(child))
					{				
						objXML = new XML();
						objXML = getObjectXML(parent, child);

						var del:Object = new Object();					
						
						del = Automation.getDelegate(child);
						if((objectArray[strGenieID] != null) && (objectArray[strGenieID].child != child))
						{
							createNewGenieID(parent);
							objXML.@genieID = strGenieID;
						}
						
						tmpClass = new HierarchyDictionary();
						tmpClass.childObject = child;
						tmpClass.xmlTree = objXML;
						
						objectArray[strGenieID] = tmpClass;
						objGetGenieIdFromObject[child] = strGenieID;
						
						var hasChildren:Boolean = false;
						var isCustomUsed:Boolean = false;
						
						if(del != null)
						{
							del = Automation.getDelegate(child);
							if(del.numGenieAutomationChildren() == 0)
							{
								if(getAllCustomChild(child))
								{
									hasChildren = true;
									isCustomUsed = true;
								}
								else
									hasChildren = false;
							}
							else
								hasChildren = true;
						}
						else
						{
							if( className != "flash.display::Stage") 
							{
								if(className.toString().indexOf("Genie") == -1)
								{
									GenericAutomationImpl.init(child);
									GenericAutomationImpl.registerObject(child);
									del = Automation.getDelegate(child);
									Automation.delGenericImpl = del;
								}
							} 
							hasChildren = (child.hasOwnProperty("numChildren") && child.numChildren > 0);	
						}

						if(hasChildren)
						{
							try
							{
								//Check if GenieID already present or not
								parseRootObject(child,objXML, isCustomUsed);
							}
							catch(e:Error)
							{
								objLogs.traceLog(GenieLogConst.ERROR,"Error: function addChildToParentXML "+e.message.toString());
							}
						}
						else
						{
							
							strParent = objGetGenieIdFromObject[parent];
							obj = objectArray[strParent];
							if(obj)
								tmpClass.xmlTree = objXML;
							
							objectArray[strGenieID] = tmpClass;
							objGetGenieIdFromObject[child] = strGenieID;
						}
					}
				}catch(e:Error){}
			}
			return objXML;
		}
		
		/*===============================================================================
		Create object hierarchy Function ends here
		===============================================================================*/	
		
		/*===============================================================================
		XML Difference and verbose hinting fucntions starts here
		===============================================================================*/	
		private static var bGetHierarchicalView:Boolean = false;
		
		public function saveComponentXML(strData:String="", strGuid:String="", from:String = ""):void
		{
			var result:XML = <Output></Output>;
			var compXML:XML;
			try
			{
				bGetHierarchicalView = true;
				var xmlData:XML = new XML(strData);
				var genieID:String = xmlData.Input.GenieID;
				var arrUserArgs:Array = new Array();
				var obj:HierarchyDictionary = new HierarchyDictionary();
				obj = objectArray[genieID];
				if(genieID.indexOf("$") > -1)
				{
					var arrTempSplit:Array = new Array();
					arrTempSplit = genieID.split("$");
					arrUserArgs = arrTempSplit[1].toString().split(",");
					genieID = arrTempSplit[0];
				}
				compXML = getComponentXML(genieID);
				bGetHierarchicalView = false;
				result.Result = true;
				result.Message = compXML.toXMLString();
			}
			catch(e:Error)
			{
				result.Result = false;
				result.Message = e.message.toString();
				objLogs.detailedTrace(GenieLogConst.ERROR, e.message.toString());
			}
			
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "saveComponentXML",result,"");
			
		}
		
		private function getComponentXML(tmpGenieID:String):XML
		{
			var treeXML: XML = <GenieComponentTree></GenieComponentTree>;
			var compXML:XML;
			var childXmlTree:XML; 
			var xmlPropertyData : XML;
			
			var genieID:String = tmpGenieID;
			var arrUserArgs:Array = new Array();
			var obj:HierarchyDictionary = new HierarchyDictionary();
			obj = objectArray[genieID];
			
			var compnentPropertyXML:XML = getPropertiesOfGenieComponent(genieID);
			treeXML.appendChild(compnentPropertyXML);
			getComponentXMLRecursively(obj.xmlTree,treeXML);
			
			return treeXML;
		}	
		
		private function getComponentXMLRecursively(xmlChild:XML,parentXML:XML):XML
		{
			try
			{
				var obj:HierarchyDictionary = new HierarchyDictionary();
				var outputList:XMLList = new XMLList(xmlChild.children());
				var childCompXML:XML;
				
				for each(var abc:XML in outputList)
				{
					if(abc.children().length() == 0)
					{
						childCompXML = new XML();
						childCompXML = getPropertiesOfGenieComponent(abc.attribute("genieID"));
						parentXML.appendChild(childCompXML);
					}	
					else 
					{
						childCompXML = new XML();
						childCompXML = getPropertiesOfGenieComponent(abc.attribute("genieID"));
						parentXML.appendChild(childCompXML);
						var genieID:String = abc.attribute("genieID");
						obj = objectArray[genieID];
						if(bGetHierarchicalView)
							getComponentXMLRecursively(obj.xmlTree, childCompXML);
						else
							getComponentXMLRecursively(obj.xmlTree, parentXML);
					}
				}
			}
			catch(e:Error)
			{
				objLogs.traceLog(GenieLogConst.ERROR, e.message.toString());
			}
			return parentXML;
		}
		
		private function getPropertiesOfGenieComponent(argGenieID:String):XML
		{
			var objXML:XML = <Object></Object>;
			var propValPairXml:String = "<GenieId value =\"" + argGenieID + "\"  >";
			var tmpHierarchy:HierarchyDictionary = new HierarchyDictionary();
			tmpHierarchy = objectArray[argGenieID];
			var object:Object = tmpHierarchy.child;
			var objectInfo:XML = describeType(object);
			
			try
			{
				var typeStr:String = objectInfo.@name;
				if (typeStr == null)
				{
					typeStr = "";
				}
				objXML.@genieID = argGenieID;
				objXML.@type = objectInfo.@name;
			}catch(e:Error)
			{}
			
			//parse properties
			for each (var a:XML in objectInfo..accessor) 
			{
				if(a.@access != 'writeonly')
				{
					var prop:String = a.@name;
					if(arrPropertiesToIgnore.indexOf(prop) == -1)
					{
						var value:String = "";
						try{
							//Skipping byteArray since it would not return any meaningful data for user
							if(object[prop] is ByteArray)
								value = "[object ByteArray]";
							else
							{
								value = object[prop];
								value = GenieMix.getCleanStringForXML(value);
								value = GenieMix.getHidedQuotesFromString(value);
							}
							
						}catch(e:Error)
						{
							value = "";
						}
						objXML.@[prop] = value;
						propValPairXml += "<accessor property=\"" + prop + "\" value=\"" + value + "\" />";
					}
				}
			}
			
			propValPairXml += "</GenieId>";
			return XML(propValPairXml);
		}		
		
		/*===============================================================================
		XML Difference fucntions starts here
		===============================================================================*/
		
		/*===============================================================================
		Recording/Playback Function Begins here
		===============================================================================*/		
		
		public function recordHandler(event:AutomationRecordEvent):void
		{
			if(isRecording == true)
			{
				var strObjectGenieID:String = "";
				var strError:String = "";
				var strEventName:String = "";
				trace("recordHandler has come");
				var bRecord:Boolean = true;
				try
				{
					strObjectGenieID = objGetGenieIdFromObject[event.automationObject];
					objLogs.detailedTrace(GenieLogConst.INFO, "In recordHandler() for genieid: " + strObjectGenieID);
					//use stored genie id if automationObject has been removed from array
					if(strObjectGenieID == null)
					{
						if(lastObjectRemoved == event.automationObject && genieIDLastObjectRemoved != null)
							strObjectGenieID = genieIDLastObjectRemoved;
						else if(objDeletedObject[event.automationObject])
						{
							strObjectGenieID = objDeletedObject[event.automationObject];
							delete objDeletedObject[event.automationObject];
						}
					}
					objDeletedObject = new Dictionary();
					objLogs.detailedTrace(GenieLogConst.INFO, "in recordHandler for GenieID: "+ strObjectGenieID +" for automationObject: "+event.automationObject.toString());
				}
				catch(e:Error)
				{
					strError = e.message.toString() + " in function recordHandler";
					objLogs.traceLog(GenieLogConst.ERROR, "function recordHandler: "+e.message);	
				}
				
				try
				{
					if(StringUtil.trim(strObjectGenieID) != "" && strError == "")
					{
						objLogs.detailedTrace(GenieLogConst.INFO, "in recordHandler for GenieID: "+ strObjectGenieID +" creating step");
						
						var strStep:String  = "";
						var strTmpClassName:String = "";
						
						strTmpClassName = getQualifiedClassName(event.automationObject);
						strEventName = event.name.toString();

						getCorrectClassName(event.automationObject);
						strTmpClassName = strExtendedClassName;
						
						strStep = "<GenieID>"+strObjectGenieID+"</GenieID>";
						strStep += "<ClassName>"+strTmpClassName+"</ClassName>";
						strStep += "<Event>"+strEventName+"</Event>";
						strStep += "<Arguments>";
						
						getCorrectClassName(event.automationObject);
							
						//Below are some case hanling because as of now the way we get the arguments while recording
						//is not generic for all components. Hence had made some case handling for special cases.
						var argChild:*;							
						if(event.args.length > 0)
						{
							for (var i:int = 0; i < event.args.length; i++)
							{
								strStep += "<Argument>"+GenieMix.getCleanStringForXML(event.args[i].toString())+"</Argument>";
							}
							strStep += "</Arguments>";
						}
						else
						{
							strStep += "</Arguments>";
						}

						if(bRecord)
						{
							strLastStep = strStep;
							var crEnter:String = String.fromCharCode(13);
							var crLineFeed:String = String.fromCharCode(10);
							var regExEnter:RegExp = new RegExp(crEnter, "g");
							var regExLineFeed:RegExp = new RegExp(crLineFeed, "g");
							
							strStep = strStep.replace(regExEnter,"$GENIE_ENTER$");
							strStep = strStep.replace(regExLineFeed,"$GENIE_LINEFEED$");
							bStepRecorded = true;
							objLogs.detailedTrace(GenieLogConst.INFO, "Step created: "+strStep);
							objCom.sendCommand(GenieMix.PLUGIN_NAME_STR, "record",strStep,"");
						}
					}
					else
					{
						objCom.sendCommand(GenieMix.PLUGIN_NAME_STR, "errorRecording",strError,"");
					}
				}
				catch(e:Error)
				{
					objLogs.traceLog(GenieLogConst.ERROR, "function recordHandler after GenieId: "+e.message);	
				}
			}
		}
		
		private function getGenieIDForITR(strOriginalGenieId:String, arrUserArgs:Array):Array
		{
			var arrGenieId:Array = new Array();
			var arrTemp:Array = new Array();
			var arrID:Array = new Array();
			var strSmallGenieID:String = "";
			try
			{
				//First split on the basis of parent and child id as parent also might contain ITR^
				arrGenieId = strOriginalGenieId.split(":::");
				arrTemp = arrGenieId;
				if(arrGenieId.length == 2)
				{
					arrGenieId = arrTemp[1].split("ITR^");
					if(arrGenieId != null && arrGenieId.length > 0)
					{
						strSmallGenieID = arrTemp[0] + ":::" + arrGenieId[0];
						for (var key:Object in objectArray)
						{
							if(key.indexOf(strSmallGenieID) > -1 && key != strOriginalGenieId)
							{
								var bAdd:Boolean = true;
								if(bAdd)
								{
									var obj:Object = objectArray[key].child;
									if(getUserArgsValidation(arrUserArgs, obj))
										arrID.push(objectArray[key]);
								}
							}
						}
						return arrID;
					}
				}
				else if(arrGenieId.length == 3)
				{
					arrGenieId = arrTemp[2].split("ITR^");
					if(arrGenieId != null && arrGenieId.length > 0)
					{
						strSmallGenieID = arrTemp[0] + ":::" + arrTemp[1] + ":::" + arrGenieId[0];
						for (key in objectArray)
						{
							if(key.indexOf(strSmallGenieID) > -1 && key != strOriginalGenieId)
							{
								bAdd = true;
								if(bAdd)
								{
									obj = objectArray[key].child;
									if(getUserArgsValidation(arrUserArgs, obj))
										arrID.push(objectArray[key]);
								}
							}
						}
						return arrID;
					}
				}
			}
			catch(e:Error)
			{
				arrID = null;
			}
			return arrID;
		}
		
		
		private function getGenieIDForPTR(strOriginalGenieId:String, arrUserArgs:Array):Array
		{
			var arrGenieId:Array = new Array();
			var arrTemp:Array = new Array();
			var arrID:Array = new Array();
			var strSmallGenieID:String = "";
			try
			{
				//First split on the basis of parent and child id as parent also might contain ITR^
				arrGenieId = strOriginalGenieId.split(":::");
				arrTemp = arrGenieId;
				strSmallGenieID = arrGenieId[0] + ":::" + arrGenieId[1];
				if(arrGenieId.length == 3)
				{
					var bAdd:Boolean = false;
					arrGenieId = arrTemp[2].split("PTR^");
					if(arrGenieId != null && arrGenieId.length > 0)
					{
						strSmallGenieID = arrTemp[0] + ":::" + arrTemp[1] + ":::" + arrGenieId[0];
						for (var key:Object in objectArray)
						{
							if(key.indexOf(strSmallGenieID) > -1 && key != strOriginalGenieId)
							{
								bAdd = true;
								if(bAdd)
								{
									var obj:Object = objectArray[key].child;
									if(getUserArgsValidation(arrUserArgs, obj))
										arrID.push(objectArray[key]);
								}
							}
						}
						return arrID;
					}
				}
			}
			catch(e:Error)
			{
				arrID = null;
			}
			return arrID;
		}
		
		
		private function getUserArgsValidation(arrUserArgs:Array, obj:Object):Boolean
		{
			try
			{
				var bMatched:Boolean = false;
				if(arrUserArgs != null && arrUserArgs.length > 0)
				{
					for(var i:int = 0; i < arrUserArgs.length; i++)
					{
						var arrSplit:Array = new Array();
						arrSplit = arrUserArgs[i].toString().split("=");
						if(obj.hasOwnProperty(arrSplit[0].toString()))
						{
							if(obj[arrSplit[0].toString()] == arrSplit[1])
								bMatched = true;
							else
							{
								bMatched = false;
								break;
							}
						}
					}
					
					if(!bMatched)
					{
						if(obj.hasOwnProperty("numChildren") && obj.numChildren > 0)
						{
							for(var k:int = 0; k < obj.numChildren; k++)
							{
								var argChild:* = obj.getChildAt(k);
								bMatched = getUserArgsValidation(arrUserArgs, argChild);
								if(bMatched)
									break;
							}
						}
					}
				}
				else
					bMatched = true;
			}
			catch(e:Error)
			{
				bMatched = false;
			}
			
			return bMatched;
		}
		
		private function getGenieIDForIndex(strOriginalGenieId:String, arrUserArgs:Array):Array
		{
			var arrGenieId:Array = new Array();
			var arrTemp:Array = new Array();
			var arrID:Array = new Array();
			try
			{
				//First split on the basis of parent and child id as parent also might contain IX^
				arrGenieId = strOriginalGenieId.split(":::");
				arrTemp = arrGenieId;
				if(arrGenieId.length == 2)
				{
					arrGenieId = arrTemp[1].split("IX^");
					if(arrGenieId != null && arrGenieId.length > 0)
					{
						var strSmallGenieID:String = arrTemp[0] + ":::" + arrGenieId[0];
						for (var key:Object in objectArray)
						{
							if(key.indexOf(strSmallGenieID) > -1 && key != strOriginalGenieId)
							{
								var bAdd:Boolean = true;
								if(bAdd)
								{
									var obj:Object = objectArray[key].child;
									if(getUserArgsValidation(arrUserArgs, obj))
										arrID.push(objectArray[key]);
								}
							}
						}
						return arrID;
					}
				}
				else if(arrGenieId.length == 3)
				{
					arrGenieId = arrTemp[2].split("IX^");
					if(arrGenieId != null && arrGenieId.length > 0)
					{
						strSmallGenieID = arrTemp[0] + ":::" + arrTemp[1] + ":::" + arrGenieId[0];
						for (key in objectArray)
						{
							if(key.indexOf(strSmallGenieID) > -1 && key != strOriginalGenieId)
							{
								bAdd = true;
								if(bAdd)
								{
									obj = objectArray[key].child;
									if(getUserArgsValidation(arrUserArgs, obj))
										arrID.push(objectArray[key]);
								}
							}
						}
						return arrID;
					}
				}
			}
			catch(e:Error)
			{
				arrID = null;
			}
			return arrID;
		}
		
		private function getGenieIDForParent(strOriginalGenieId:String, arrUserArgs:Array):Array
		{
			var arrGenieId:Array = new Array();
			var arrTemp:Array = new Array();
			var arrID:Array = new Array();
			var strParentPart:String = "";
			var strChildPart:String = "";
			try
			{
				//First split on the basis of parent and child id as parent also might contain IX^
				arrGenieId = strOriginalGenieId.split(":::");
				
				if(arrGenieId.length == 2)
				{
					strParentPart = arrGenieId[0].toString();
					strChildPart = arrGenieId[1].toString();
				}
				else if(arrGenieId.length == 3)
				{
					strParentPart = arrGenieId[0].toString() + ":::" + arrGenieId[1].toString();
					strChildPart = arrGenieId[2].toString();
				}
				//first get all the keys for which child part remains same but parent changes
				for (var strKey:Object in objectArray)
				{
					if(strKey.toString().indexOf(strChildPart) > -1)
					{
						arrID.push(strKey);	
					}
				}
				
				arrGenieId = new Array();
				//if returned array is not empty than try splitting the parent part
				if(arrID != null)
				{
					//first try ignoring the ITR from parent part
					if(strParentPart.indexOf("ITR^") > -1)
					{
						arrTemp = strParentPart.split("ITR^");
						
						for each(strKey in arrID)
						{
							if(strKey != strOriginalGenieId)
							{
								if(strKey.indexOf(arrTemp[0]) > -1)
								{
									arrGenieId.push(objectArray[strKey]);
								}
							}
						}
					}
					
					// try ignoring the IX from parent part
					if(arrGenieId == null || arrGenieId.length == 0)
					{
						if(strParentPart.indexOf("IX^") > -1)
						{
							arrTemp = strParentPart.split("IX^");
							
							for each(strKey in arrID)
							{
								if(strKey != strOriginalGenieId)
								{
									if(strKey.indexOf(arrTemp[0]) > -1)
									{
										arrGenieId.push(objectArray[strKey]);
									}
								}
							}
						}
					}
				}
				
				return arrGenieId;
				
			}
			catch(e:Error)
			{
				arrGenieId = null;
			}
			return arrGenieId;
		}
		
		protected function getNewGenieID(strOldGenieID:String, arrUserArgs:Array):Object
		{
			var objToReturn:Object = new Object();
			//Split parent and child GenieId
			var arrSplit:Array = strOldGenieID.split(":::");
			//Split GenieIdchild to various values having identifiers
			var arrIdentifiers:Array = arrSplit[1].split("::");
			var arrIdentifiersPresent:Array = new Array();
			//Will hold the Identifiers value that are not present in old genie id
			var arrIdentifiersNotPresent:Array = new Array();
			var dictKeyValue:Dictionary = new Dictionary();
			var arrTemp:Array = new Array();
			var arrFinal:Array = new Array();
			
			//Get the identifiers that are not present in the new genie id
			for(var x:int = 0; x < arrIdentifiers.length; x++)
			{
				var arrTempSplit:Array = arrIdentifiers[x].split("^");
				if(arrStaticIdentifiers.indexOf(arrTempSplit[0].toString()) == -1)
				{
					arrIdentifiersPresent.push(arrTempSplit[0]);
					dictKeyValue[arrTempSplit[0]] = arrTempSplit[1];
				}
			}
			
			//To get all the identifiers which are are present in static array
			//but not present in genie id
			if(arrIdentifiersPresent.length == 0)
			{
				for(i = 0; i < arrIdentifiers.length; i++)
				{
					
					arrTempSplit = arrIdentifiers[i].split("^");
					arrIdentifiersPresent.push(arrTempSplit[0]);
					dictKeyValue[arrTempSplit[0]] = arrTempSplit[1];
				}
			}
			
			//get the object from the dictionary after matching the values of the properties present in the old genie id
			for (var key:Object in objectArray)
			{
				var objTemp:HierarchyDictionary = new HierarchyDictionary();
				objTemp = objectArray[key];
				var bAllValuesMatched:Boolean = false;
				for(x = 0; x < arrIdentifiersPresent.length; x++)
				{
					if(arrIdentifiersPresent[x].toString().indexOf("ITR") == -1)
					{
						var strActualIdentifierValue:String = "";
						var strActualValue:String = "";
						
						strActualIdentifierValue = dictIdentifiers[arrIdentifiersPresent[x]];
						strActualValue = dictKeyValue[arrIdentifiersPresent[x]];
						if(objTemp.child.hasOwnProperty(strActualIdentifierValue) && arrIdentifiersPresent[x] != "IX")
						{
							if(objTemp.child[strActualIdentifierValue] == strActualValue)
								bAllValuesMatched = true;
							else
								bAllValuesMatched = false
						}
						else
						{
							var iIndex:int = getChildIndex(objTemp.child.parent, objTemp.child);
							if(iIndex.toString() == strActualValue)
								bAllValuesMatched = true;
							else
								bAllValuesMatched = false
						}
					}
				}
				
				if(bAllValuesMatched)
					arrTemp.push(objTemp.child);
			}
			
			//Check for parent genie id validation
			for(var i:int = 0; i < arrTemp.length; i++)
			{
				var obj:Object = arrTemp[i];
				var objParent:Object = null;
				var bParent:Boolean = true;
				
				if(obj.hasOwnProperty("parent"))
				{
					if(obj.parent)
					{
						objParent = obj.parent;
						while(bParent)
						{
							if(objParent)
							{
								if(showInHierarchy(objParent))
								{
									var strParentOldGenieID:String = arrSplit[0].toString();
									var arrParentIdentifiers:Array = new Array();
									
									arrParentIdentifiers = strParentOldGenieID.split("::");
									for(x = 0; x < arrParentIdentifiers.length; x++)
									{
										if(arrParentIdentifiers[x].toString().indexOf("ITR") == -1)
										{
											strActualIdentifierValue = "";
											strActualValue = "";
											
											arrTempSplit = arrParentIdentifiers[x].split("^");
											strActualIdentifierValue = dictIdentifiers[arrTempSplit[0]];
											strActualValue = arrTempSplit[1];
											if(objParent.hasOwnProperty(strActualIdentifierValue))
											{
												if(objParent[strActualIdentifierValue] == strActualValue)
												{
													if(shouldPlayback(obj))
														arrFinal.push(obj);
												}
											}
										}
									}
									bParent = false;
								}
								else
									objParent = objParent.parent;
							}
							else
								break;
						}
					}
				}
			}
			
			if(arrFinal.length > 1)
			{
				var arrID:Array = new Array();
				for(x = 0; x < arrFinal.length; x++)
				{
					obj = arrFinal[x];
					if(getUserArgsValidation(arrUserArgs, obj))
						arrID.push(obj);
				}
				arrFinal = arrID;
			}
			
			return arrFinal[0];
		}
		
		public function getTrimmedGenieID(strGenieID:String, strGuid:String="", from:String = ""):void
		{
			//Added to trim down the genbieId if original genieID passed is not present in object hierarchy 
			var bVisible:Boolean = true;
			var saveGenieId:String = strGenieID;
			var propValue:String = null;
			var result:XML = <Output></Output>;
			result.Result = false;
			var glowHierarchy:HierarchyDictionary = new HierarchyDictionary();
			var arrGenieID:Array = new Array();
			var strTrimmedGenieId:String = strGenieID;
			var objClassName:String = null;
			
			var arrSplit:Array = new Array();
			var arrUserArgs:Array = new Array();
			var obj:Object = null;
			
			arrSplit = strGenieID.split("$");
			strGenieID = arrSplit[0];
			
			if(arrSplit.length > 1)
				arrUserArgs = arrSplit[1].toString().split(",");
			
			glowHierarchy = objectArray[strGenieID];
			
			try
			{
				while(glowHierarchy == null)
				{
					obj = getObjectAfterTrim(strTrimmedGenieId, arrUserArgs);
					
					if(obj)
					{
						bVisible = true;
						result.Result = true;
						propValue = objGetGenieIdFromObject[obj];
						result.PropertyValue = propValue;
						result.Message = "";
						break;
					}
					else
					{
						bVisible = false;
						break;
					}
				}
				
				if(glowHierarchy)
				{
					obj = glowHierarchy.child;
					bVisible = shouldPlayback(obj);	
					objClassName = getQualifiedClassName(obj);	
				}
				if(!bVisible)
				{
					strTrimmedGenieId = strGenieID;
					while(!bVisible)
					{
						obj = getObjectAfterTrim(strTrimmedGenieId, arrUserArgs);
						
						if(obj)
						{
							bVisible = true;
							result.Result = true;
							propValue = objGetGenieIdFromObject[obj];
							result.PropertyValue = propValue;
							result.Message = "";
							break;
						}
						else
							break;
					}
				}
				
				if(!bVisible)
				{
					arrGenieID = getGenieIDForParent(strTrimmedGenieId, arrUserArgs);
					if(arrGenieID != null && arrGenieID.length > 0)
					{
						for(var i:int = 0; i < arrGenieID.length; i++)
						{
							glowHierarchy = arrGenieID[i];
							if(glowHierarchy)
							{
								obj = glowHierarchy.child;
								bVisible = Automation.automationManager.isVisible(obj as DisplayObject);
								if(bVisible)
								{
									bVisible = true;
									result.Result = true;
									propValue = objGetGenieIdFromObject[obj];
									result.PropertyValue = propValue;
									result.Message = "";
									break;
								}
							}
						}
					}
					
					if(!bVisible)
					{
						if(strGenieID.indexOf("PTR^") > -1)
						{
							arrGenieID = getGenieIDForPTR(strTrimmedGenieId, arrUserArgs);
							if(arrGenieID != null && arrGenieID.length > 0)
							{
								for(i = 0; i < arrGenieID.length; i++)
								{
									glowHierarchy = arrGenieID[i];
									if(glowHierarchy)
									{
										obj = glowHierarchy.child;
										bVisible = Automation.automationManager.isVisible(obj as DisplayObject);
										if(bVisible)
										{
											bVisible = true;
											result.Result = true;
											propValue = objGetGenieIdFromObject[obj];
											result.PropertyValue = propValue;
											result.Message = "";
											break;
										}
									}
								}
							}
							else
								result.Message = "COMPONENT_OF_GIVEN_GENIEID_NOT_AVAILABLE_ON_STAGE";
						}
						else
							result.Message = "COMPONENT_OF_GIVEN_GENIEID_NOT_AVAILABLE_ON_STAGE";
					}
					else
						result.Message = "COMPONENT_OF_GIVEN_GENIEID_NOT_VISIBLE";
				}
			}
			catch(e:Error)
			{
				result.Message = "COMPONENT_OF_GIVEN_GENIEID_NOT_AVAILABLE_ON_STAGE";
			}
			
			if(bVisible)
			{
				result.Result = true;
				propValue = objGetGenieIdFromObject[obj];
				result.PropertyValue = propValue;
				result.Message = "";
			}
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "getValueOf",result,"");
		}
		
		private function shouldPlayback(obj:Object):Boolean
		{
			var bVisible:Boolean = true;
			if(Automation.automationManager.isVisible(obj as DisplayObject))
				bVisible = true;
			else
				bVisible = false;
			
			return bVisible;
		}
		
		private function getMatchedGenieIDsFromDictionary(strSmallGenieID:String):Array
		{
			var arrGenieID:Array = new Array();
			for (var key:Object in objectArray)
			{
				if(key.indexOf(strSmallGenieID) > -1)
				{
					arrGenieID.push(key);
				}
			}
			
			return arrGenieID;
		}
		
		private function decodeFromHex(str:String):String
		{
			var r:String="";
			var e:int=str.length;
			var s:int;
			while(e>=0){
				s=e-3;
				r=String.fromCharCode("0x"+str.substring(s,e))+r;
				e=s;
			}
			return r;
		}
		
		private function getObjectAfterTrim(strTrimmedGenieId:String, arrUserArgs:Array):Object
		{
			
			var arrGenieID:Array = new Array();
			var bVisible:Boolean = false;
			var glowHierarchy:HierarchyDictionary = new HierarchyDictionary();
			var obj:Object = null;
			
			var objHierarchy:HierarchyDictionary = new HierarchyDictionary();
			objHierarchy = objectArray[strTrimmedGenieId];
			if(objHierarchy)
			{
				obj = objHierarchy.child;
				if(shouldPlayback(obj))
					return obj;
			}
			
			//First break on the basis of Iterative index(ITR) of the child
			arrGenieID = getGenieIDForITR(strTrimmedGenieId, arrUserArgs);
			if(arrGenieID != null && arrGenieID.length > 0)
			{
				for(var i:int = 0; i < arrGenieID.length; i++)
				{
					glowHierarchy = arrGenieID[i];
					if(glowHierarchy)
					{
						bVisible = shouldPlayback(glowHierarchy.child);
						if(bVisible)
						{
							obj = glowHierarchy.child;
							break;
						}
					}
				}
				
				// If still object is not found break on the basis of the index (if present) of child
				if(!bVisible)
				{
					arrGenieID = getGenieIDForIndex(strTrimmedGenieId, arrUserArgs);
					if(arrGenieID != null && arrGenieID.length > 0)
					{
						for(i = 0; i < arrGenieID.length; i++)
						{
							glowHierarchy = arrGenieID[i];
							if(glowHierarchy)
							{
								bVisible = shouldPlayback(glowHierarchy.child);
								if(bVisible)
								{
									obj = glowHierarchy.child;
									break;
								}
							}
						}
					}
				}
				
				if(!bVisible)
				{
					arrGenieID = getGenieIDForParent(strTrimmedGenieId, arrUserArgs);
					if(arrGenieID != null && arrGenieID.length > 0)
					{
						for(i = 0; i < arrGenieID.length; i++)
						{
							glowHierarchy = arrGenieID[i];
							if(glowHierarchy)
							{
								bVisible = shouldPlayback(glowHierarchy.child);
								if(bVisible)
								{
									obj = glowHierarchy.child;
									break;
								}
							}
						}
					}
				}
			}
			else
			{
				arrGenieID = getGenieIDForIndex(strTrimmedGenieId, arrUserArgs);
				if(arrGenieID != null && arrGenieID.length > 0)
				{
					for(i = 0; i < arrGenieID.length; i++)
					{
						glowHierarchy = arrGenieID[i];
						if(glowHierarchy)
						{
							bVisible = shouldPlayback(glowHierarchy.child);
							if(bVisible)
							{
								obj = glowHierarchy.child;
								break;
							}
						}
					}
				}
				
				if(!bVisible)
				{
					arrGenieID = getGenieIDForParent(strTrimmedGenieId, arrUserArgs);
					if(arrGenieID != null && arrGenieID.length > 0)
					{
						for(i = 0; i < arrGenieID.length; i++)
						{
							glowHierarchy = arrGenieID[i];
							if(glowHierarchy)
							{
								bVisible = shouldPlayback(glowHierarchy.child);
								if(bVisible)
								{
									obj = glowHierarchy.child;
									break;
								}
							}
						}
					}
				}
			}
			
			return obj;
		}
		
		
		public function playback(objectStr:String,strGuid:String ,from:String = ""):void
		{
			if(from.length == 0)
				from = GenieMix.EXECUTOR_NAME_STR;
			
			var tmpXML:String = "";
			
			XML.ignoreProcessingInstructions = false;
			XML.ignoreWhitespace = false;
			XML.prettyPrinting=false;
			var dataXML:XML = new XML();
			var obj:Object = null;
			var strGenieID:String = "";
			var arrUserArgs:Array = new Array();
			var strEventName:String = "";
			var xmlArguments:XMLList;
			var xmlPreloadArgs:XMLList;
			var glowHierarchy:HierarchyDictionary = new HierarchyDictionary();
			var ga:GenieAdapter = GenieMix.getGenieAdapter();
			var arrArgs:Array;
			var arrPreloadArgs:Array;
			var strResult:String = "";
			var strError:String = "";
			var bCheckForVisibility:Boolean = true;
			var i:int = 0;
			var objResult:Object = new Object();
			
			objLogs.traceLog(GenieLogConst.INFO, "function playback");	
			
			if(objectStr)
			{
				dataXML = <Data>{objectStr}</Data>;
				tmpXML = dataXML.toXMLString();
				tmpXML = tmpXML.replace(/&lt;/g,"<");
				tmpXML = tmpXML.replace(/&gt;/g,">");
				
				XML.ignoreProcessingInstructions = false;
				XML.ignoreWhitespace = false;
				XML.prettyPrinting=false;
				dataXML = XML(tmpXML);
				
				try
				{
					if(dataXML.child("XML") != null && dataXML.child("XML") != "" && dataXML.child("XML").length() > 0)
					{
						dataXML = XML(dataXML.child("XML"));
					}

					strGenieID = dataXML.child("GenieID").text().toString();
					strEventName = dataXML.child("Event").text().toString();
					xmlArguments = dataXML.child("Arguments");

					try
					{
						xmlPreloadArgs = dataXML.child("PreloadArguments");
					}
					catch(e:Error)
					{}
					
					//Split for user args
					if(strGenieID.indexOf("$") > -1)
					{
						var arrTempSplit:Array = new Array();
						arrTempSplit = strGenieID.split("$");
						
						try
						{
							var arrParentSplit:Array = new Array();
							arrParentSplit = arrTempSplit[0].toString().split(":::");
							var strSplitGenieID:String = "";
							
							if(arrParentSplit.length == 3)
								strSplitGenieID = arrParentSplit[2].toString();
							else
								strSplitGenieID = arrParentSplit[1].toString();
							
							var nUserIndex:int = strSplitGenieID.lastIndexOf("::");
							if(nUserIndex > 0)
							{
								var strUserIndex:String = strSplitGenieID.substr(nUserIndex, (strSplitGenieID.length - nUserIndex + 1));
								if(strUserIndex.indexOf("ITR^") > -1 || strUserIndex.indexOf("IX^") > -1)
								{
									arrUserArgs = arrTempSplit[1].toString().split(",");
									strGenieID = arrTempSplit[0];
								}
							}
						}
						catch(e:Error)
						{}
					}
					
					dictPlayback[strGenieID] = strGuid;
					
					objLogs.detailedTrace(GenieLogConst.INFO, "in playback for strGenieID: "+ strGenieID +", strEventName: " + strEventName + 
						", arguments: " + xmlArguments.toXMLString() + " and Guid: "+strGuid);
				}
				catch(e:Error)
				{
					objLogs.traceLog(GenieLogConst.ERROR, "function playback: "+e.message);	
					objCom.sendCommandWithId(from ,strGuid, "playback","Not valid XML: "+ e.message.toString(),"");
				}
				if(xmlArguments.children().length() == 0)
				{
					arrArgs = new Array();
				}
				else
				{
					arrArgs = new Array();
					var strStepArgument:String = "";
					
					for(var iChild:int = 0; iChild < xmlArguments.children().length(); iChild++)
					{
						strStepArgument = xmlArguments.children()[iChild].toString();
						//Added to handle the UTF16 character
						if(strStepArgument.indexOf("$GENIE_UTF$") > -1)
						{
							var strUTFArgument:String = strStepArgument;
							var nMatch:Number = strUTFArgument.indexOf("$GENIE_UTF$");
							var bFirst:Boolean = true;
							var nOldMatch:Number = 0;
							var arrItems:Array = new Array();
							var strItem:String = "";
							i = 0;
							while(nMatch != -1) {
								if(bFirst)
								{
									strItem = strUTFArgument.substr(0,nMatch);
									arrItems.push(strItem);
									bFirst = false;
									i += 1;
								}
								else
								{
									if(i == 1)
									{
										nOldMatch = nMatch;
										nMatch = strUTFArgument.indexOf("$GENIE_UTF$", nMatch + 1);
										strItem = decodeFromHex(strUTFArgument.substr((nOldMatch + 11), (nMatch - (nOldMatch + 11))));
										arrItems.push(strItem);
										i = 0;
									}
									else
									{
										nOldMatch = nMatch;
										nMatch = strUTFArgument.indexOf("$GENIE_UTF$", nMatch + 1);
										if(nMatch == -1)
											strItem = strUTFArgument.substr((nOldMatch + 11), strUTFArgument.length - (nOldMatch + 11));
										else
											strItem = strUTFArgument.substr((nOldMatch + 11), (nMatch - (nOldMatch + 11)));
										arrItems.push(strItem);
										i += 1;
									}
								}
							}
							
							for(i = 0; i < arrItems.length; i++)
							{
								if(i == 0)
									strStepArgument = arrItems[i];
								else
									strStepArgument += arrItems[i];
							}
							
						}
						arrArgs.push(GenieMix.getCleanXMLFromStr(strStepArgument));
					}
				}
				
				if(xmlPreloadArgs.children().length() == 0)
				{
					arrPreloadArgs = new Array();
				}
				else
				{
					arrPreloadArgs = new Array();
					strStepArgument = "";
					
					for(iChild = 0; iChild < xmlPreloadArgs.children().length(); iChild++)
					{
						strStepArgument = xmlPreloadArgs.children()[iChild].toString();	
						bCheckForVisibility = false;
						arrPreloadArgs.push(GenieMix.getCleanXMLFromStr(strStepArgument));
					}
				}
				
				try
				{
					if(strEventName == "ClickAtLocation" || strEventName == "performKeyAction")
					{
						//Some times for displayObject delegate was coming as null while playing back hence made a check so that if object is 
						// recorded which event clickAtLocation and failing to find the delegate than register it afresh so that playback could happen successfully.
						var objHierarchy:HierarchyDictionary = new HierarchyDictionary();
						objHierarchy = objectArray[strGenieID];
						if(objHierarchy)
						{
							obj = objHierarchy.child;
							var bPlayback:Boolean = true;
							
							if(arrUserArgs.length > 0)
							{
								bPlayback = getUserArgsValidation(arrUserArgs, obj);
							}
							
							if(bPlayback)
							{
								var delegate:Object = Automation.getDelegate(obj);
								if((delegate == null || delegate.toString().indexOf("GenericAutomationImpl") == -1) && strEventName == "ClickAtLocation")
								{
									GenericAutomationImpl.registerObject(obj);
									Automation.getDelegate(obj);
								}
								else if(strEventName == "performKeyAction")
								{
									if(delegate == null)
									{
										GenericAutomationImpl.registerObject(obj);
										Automation.getDelegate(obj);
									}
									
									if(arrArgs.length == 2)
										Automation.keyDownForDuration = arrArgs[1];
									else if(arrArgs.length == 3)
										Automation.keyDownForDuration = arrArgs[2];
								}
								
								objResult = new Object();
								objResult.GenieId = strGenieID;
								
								//Set the visibility factor to false for DisplayObjects
								AutomationManager.bCheckForVisibility = false;
								
								objResult = ga.replay(obj,strEventName,arrArgs, strGuid,objResult.GenieId);
								
								if(objResult.result != null)
									strResult = objResult.result.value.toString();
								else
									strResult = objResult.error.toString();
								
								objLogs.traceLog(GenieLogConst.INFO, "result in playback: " + strResult);	
								objCom.sendCommandWithId(from ,dictPlayback[strGenieID], "playback",strResult,"");
							}
							else
							{
								strError = "COMPONENT_OF_GIVEN_GENIEID_NOT_AVAILABLE_ON_STAGE";	
								objCom.sendCommandWithId(from ,dictPlayback[strGenieID], "playback",strError,"");
							}
						}
						else
						{
							strError = "COMPONENT_OF_GIVEN_GENIEID_NOT_AVAILABLE_ON_STAGE";							
							objLogs.traceLog(GenieLogConst.ERROR, "result in playback: " + strError);	
							objCom.sendCommandWithId(from ,dictPlayback[strGenieID], "playback",strError,"");
						}
					}
					else
					{
						
						objResult = new Object();
						var bVisible:Boolean = true;
						var result:Object = new Object();
						var strNewGenieId:String  = "";
						
						glowHierarchy = objectArray[strGenieID];
						objResult.GenieId = strGenieID;
						
						if(glowHierarchy)
							obj = glowHierarchy.child;
						
						if(bCheckForVisibility)
						{
							//Added to trim down the genbieId if original genieID passed is not present in object hierarchy 
							var arrGenieID:Array = new Array();
							var strTrimmedGenieId:String = strGenieID;
							
							while(obj == null)
							{
								obj = getObjectAfterTrim(strTrimmedGenieId, arrUserArgs);
								if(obj == null)
								{
									bVisible = false;
									break;
								}
								else
								{
									bVisible = true;
									break;
								}
							}
						}
						
						if(obj != null)
						{
							if(bCheckForVisibility)
							{
								//obj = glowHierarchy.child;
								bVisible = shouldPlayback(obj);
								
								//Trimming down the GenieID and checking its visibility factor on stage before playback
								if(!bVisible)
								{
									bVisible = false;
									strTrimmedGenieId = strGenieID;
									while(!bVisible)
									{
										obj = getObjectAfterTrim(strTrimmedGenieId, arrUserArgs);
										if(obj == null)
										{
											bVisible = false;
											break;
										}
										else
										{
											bVisible = true;
											break;
										}
									}
								}
							}
							else
							{
								obj = glowHierarchy.child;
								AutomationManager.bCheckForVisibility = false;
							}
						}
						else
						{
							//Construct new genie id assuming that its an old genie id
							obj = getNewGenieID(strGenieID, arrUserArgs)	
							bVisible = true;
						}
						
						if(obj != null)
						{
							
							//Check for user defined properties in genie ID
							if(getUserArgsValidation(arrUserArgs, obj))
							{
								if(bVisible)
								{
									var bEnabled:Boolean = true;
									try
									{
										if(obj.hasOwnProperty("enabled"))
										{
											if(obj.enabled == false)
												bEnabled = false;
											else
												bEnabled = true;
										}
									}
									catch(e:Error)
									{
										bEnabled = true;
									}
									
									if(bEnabled)
									{
										strNewGenieId = strGenieID;
										strNewGenieId = objGetGenieIdFromObject[obj];
										strPreviousEvent = strEventName;
										
										if(strGenieID != strNewGenieId)
											objCom.sendCommand(from ,"updateGenieID", strGenieID + "__SEP__" + strNewGenieId, "");

										objResult = ga.replay(obj,strEventName,arrArgs, strGuid,objResult.GenieId);
									}
									else
									{
										result = new Object();
										objResult.GenieId = strGenieID;
										dictPlayback[strGenieID] = strGuid;
										objResult.error = "COMPONENT_OF_GIVEN_GENIEID_NOT_ENABLED";
									}
									
									if(objResult.result != null)
										strResult = objResult.result.value.toString();
									else
										strResult = objResult.error.toString();
									
									if(strGenieID == objResult.GenieId)
									{
										objLogs.traceLog(GenieLogConst.INFO, "result in playback: " + strResult);	
										objCom.sendCommandWithId(from ,dictPlayback[strGenieID], "playback",strResult,"");
									}
									else
									{
										strError = "GENIEID_DOES_NOT_MATCH_WITH_THE_GENIEID_OF_THE_EXECUTED_STEP";
										objLogs.traceLog(GenieLogConst.ERROR, "result in playback: " + strError);	
										objCom.sendCommandWithId(from ,dictPlayback[strGenieID], "playback",strError,"");
									}
								}
								else
								{
									strError = "COMPONENT_OF_GIVEN_GENIEID_NOT_VISIBLE";
									objLogs.traceLog(GenieLogConst.ERROR, "result in playback: " + strError);	
									objCom.sendCommandWithId(from ,dictPlayback[strGenieID], "playback",strError,"");
								}
							}
							else
							{
								strError = "Object was found for the given genie id but the user defined property does not match with the found object. Please verify the property name or value.";
								objLogs.traceLog(GenieLogConst.ERROR, "result in playback: " + strError);	
								objCom.sendCommandWithId(from ,dictPlayback[strGenieID], "playback",strError,"");
							}
						}
						else
						{
							if(!bVisible)
								strError = "COMPONENT_OF_GIVEN_GENIEID_NOT_VISIBLE";
							else
								strError = "COMPONENT_OF_GIVEN_GENIEID_NOT_AVAILABLE_ON_STAGE";
							
							objLogs.traceLog(GenieLogConst.ERROR, "result in playback: " + strError);	
							objCom.sendCommandWithId(from ,dictPlayback[strGenieID], "playback",strError,"");
						}
					}
				}
				catch(e:Error)
				{
					objLogs.traceLog(GenieLogConst.ERROR, "function playback: "+e.message);	
					objCom.sendCommandWithId(from ,strGuid, "playback",e.message.toString(),"");
				}
			}
		}
		
		/*===============================================================================
		Recording/Playback Function ends here
		===============================================================================*/
		
		/*===============================================================================
		GenieID Construction Function Begins here
		===============================================================================*/
		//creates the Object xml with classified properties.
		public function getObjectXML(parent:Object, child:Object,tmpArray:Array=null):XML
		{
			var startTime:Number = (new Date()).time;
			var t1:Date = new Date();
			objLogs.detailedTrace(GenieLogConst.INFO, "in getObjectXML");
			
			var rowValue:XML = new XML();
			var objXML:XML = new XML();
			
			try
			{
				objXML = <Object></Object>;

				if(objGetGenieIdFromObject[child] == null)
					strGenieID = helpCreateIDPart(parent,child);
				else
					strGenieID = objGetGenieIdFromObject[child];
				
				objLogs.detailedTrace(GenieLogConst.INFO, "GenieID created: "+ strGenieID);
				
				objXML.@genieID = strGenieID;
				objXML.@type = getQualifiedClassName(child);
				
				objXML = SharedFunctions.getObjectProperty(child, objXML); 
				
				//If data is present get it and add attribute data in the tag
				if(tmpArray != null)
				{
					var arrSplit:Array = strGenieID.split(":");
					var nIndex:int = int(arrSplit[arrSplit.length - 1]);
					
					var arrData:Array = tmpArray[nIndex];
					rowValue = arrData[0].data;
					objXML.@data = rowValue.toXMLString();
				}
			}
			catch(e:Error)
			{
				objLogs.traceLog(GenieLogConst.ERROR, "function getObjectXML: "+e.message);
			}
			var endTime:Number = (new Date()).time;
			objLogs.detailedTrace(GenieLogConst.INFO,"Time in getObjectXML = " + (endTime - startTime)); 
			
			return objXML
		}
		
		//Below block calculates the GenieID on following params
		//1. It calculates the index of the child in the given parent
		//==> Initially it used to take automationName returned from the delegetae into consideration
		//Due to localization and toggle button text change issue it was commented out
		//2. If paremt is null that means its the systemManager and its parent is stage. append root + child name and return
		//3. if child is list, menu or ListBaseContentHolder than there indexes keeps on changing depending on the activity of the user
		//Hence get the already created genieID from the array of the owner of the child and append the className of the child
		//4. If parent is list, menu or ListBaseContentHolder than get the genieId of the
		//else create the genieID of parent on the basis of its id or name. If name is used that apply the regex to replace the
		//integers in name with the index and append the child if or name applying the same logic.
		// Hence the genieID is consisting of parent(with or without regex)+ child(with or without regex)+index
		
		
		//Function to return true or false based on the property showInAutomationHierarchy
		protected function showInHierarchy(obj:Object):Boolean
		{
			if(obj.hasOwnProperty("showInAutomationHierarchy"))
			{
				if(obj.showInAutomationHierarchy)
					return true;
				else
					return false;
			}
			else
				return false;
		}
		
		//Function to string value based on the property found along with the identifier
		protected function getID(obj:Object):String
		{
			var strID:String = "";
			var superClassName:String = getQualifiedSuperclassName(obj);
			var strParentClassName:String = "";
			
			
			if(obj.hasOwnProperty("parent"))
				if(obj.parent)
					strParentClassName = getQualifiedClassName(obj.parent);
			
			if(superClassName == "mx.core::Application" || superClassName == "spark.components::Application")
			{
				if(obj.hasOwnProperty("className"))
				{
					if(obj.className != null && obj.className.toString() != "")
					{
						strID = "CN^" + obj.className.toString();
						return strID;
					}		
				}	
			}
			
			
			if(strParentClassName == "mx.controls::List" || strParentClassName == "mx.controls::Menu" || strParentClassName == "mx.controls.listClasses::ListBaseContentHolder")
			{
				if(obj.hasOwnProperty("id"))
				{
					if(obj.id != null && obj.id.toString() != "")
					{
						strID = "ID^" + obj.id.toString();
					}
				}
				
				if(strID == "")
				{
					if(obj.hasOwnProperty("name"))
					{
						if(obj.name != null && obj.name.toString() != "")
						{
							strID = "CN^" + obj.name.toString();
						}		
					}
					
					if(strID == "")
					{
						if(obj.hasOwnProperty("className"))
						{
							if(obj.className != null && obj.className.toString() != "")
							{
								strID = "CN^" + obj.className.toString();
								return strID;
							}		
						}
					}
				}
				
				if(strID != "")
					return strID;
			}
			else
			{
				var automationClass:IAutomationClass= IAutomationEnvironment(Automation.automationManager.automationEnvironment).getAutomationClassByInstance(obj);
				try
				{
					if(getQualifiedClassName(obj).indexOf("container") > -1 || automationClass.objExtendedClassName.indexOf("container") > -1)
					{
						if(obj.hasOwnProperty("id"))
						{
							if(obj.id != null && obj.id.toString() != "")
							{
								strID = "ID^" + obj.id.toString();
							}
						}
						
						if(strID == "")
						{
							if(obj.hasOwnProperty("name"))
							{
								if(obj.name != null && obj.name.toString() != "")
								{
									strID = "CN^" + obj.name.toString();
								}		
							}
							
							if(strID == "")
							{
								if(obj.hasOwnProperty("className"))
								{
									if(obj.className != null && obj.className.toString() != "")
									{
										strID = "CN^" + obj.className.toString();
										return strID;
									}		
								}
							}
						}
						
						if(strID != "")
							return strID;
					}
				}
				catch(e:Error)
				{}
			}
			
			if(obj.hasOwnProperty("id"))
			{
				if(obj.id != null && obj.id.toString() != "")
				{
					strID = "ID^" + obj.id.toString();
				}
			}
			
			if(strID == "")
			{				
				if(strID == "")
				{
					if(obj.hasOwnProperty("automationName"))
					{
						if(obj.automationName != null && obj.automationName.toString() != "")
						{							
							strID = "AN^" + obj.automationName.toString();
						}		
					}
				}
				
				if(strID == "")
				{
					if(obj.hasOwnProperty("name"))
					{
						if(obj.name != null && obj.name.toString() != "")
						{
							strID = "CN^" + obj.name.toString();
						}		
					}					
					
					if(strID == "")
					{
						if(getQualifiedClassName(obj).indexOf("NativeMenu") > -1)
						{
							strID = "CN^NativeMenu";
						}
						else
							strID = "CN^" + obj.getChildAt(0).name.toString();
					}
				}
			}
			return strID;
		}
		
		//Function to genieID of the automatable parent of the object (parent whose showInAutomationHierarchy is true)
		protected function getGenieIDForAutomatableParent(obj:Object):String
		{
			var strParentID:String = "";
			var objParent:Object = null;
			var bParent:Boolean = true;
			
			if(obj.hasOwnProperty("parent"))
			{
				if(obj.parent)
				{
					objParent = obj.parent;
					while(bParent)
					{
						if(objParent)
						{
							if(showInHierarchy(objParent))
							{
								strParentID = objGetGenieIdFromObject[objParent];
								bParent = false;
							}
							else
								objParent = objParent.parent;
						}
						else
							break;
					}
				}
			}
			return strParentID;
		}
		
		//Function to return the recursive integer value
		protected function getRecursiveIndex(obj:Object, strID:String):int
		{
			var iRecursive:int = 0;
			var bUnique:Boolean = true;
			var objParent:Object = obj.parent;
			
			try
			{
				while(bUnique)
				{
					if(objectArray[strID])
					{
						objParent = objParent.parent;
						if(showInHierarchy(objParent))
						{
							strID = objGetGenieIdFromObject[objParent] +"::" + strID;
							iRecursive += 1;
						}
					}
					else
						return iRecursive;
				}
			}
			catch(e:Error)
			{
				//objLogs.traceLog(GenieLogConst.ERROR, "function getRecursiveIndex: "+e.message);
			}
			return iRecursive;
		}
		
		
		//Handle for Sprite, MovieClip and Shape starts here
		private var objFirstLevelParent:Object;
		protected function getGenieIDForSpecialComponents(parent:Object, child:Object):String
		{
			//Check for self for name, if name is valid than take it 
			var strSpecialGenieID:String = "";
			var strSelf:String = "";
			var strChild:String = "";
			var strFirstLevelParent:String = "";
			var strSecondLevelParent:String = "";
			var objChild:Object = new Object();
			var pattern:RegExp = /\d+/;
			var pattern2:RegExp = /[0-9]+[_]/;
			
			if(checkForName(child))
				strSelf = child["name"].toString();
			else
			{
				strSelf = getQualifiedClassName(child).split("::")[1];
				if(strSelf == null || strSelf == "null")
					strSelf = getQualifiedClassName(child).split("::")[0];
			}
			
			strSelf = strSelf.replace(pattern2, "");
			strSelf = strSelf.replace(pattern, "");
			//This will get the first parent which meets following criterion:
			//1. If parent is sprite/movieClip than if name is other than instance take it
			//2. If parent is sprite/movieClip than if name is = instance ignore it
			//3. If type is other than sprite/movieClip but if name is = instance take it
			strFirstLevelParent = getFirstLevelParent(parent);
			strFirstLevelParent = strFirstLevelParent.replace(pattern2, "");
			strFirstLevelParent = strFirstLevelParent.replace(pattern, "");
			
			//go for valid child
			//if no child is found valid than take the name as instance and look for second level parent
			objChild = getRecursiveValidChild(child);
			if(objChild && objChild != null)
			{
				if(checkForName(objChild))
					strChild = objChild["name"].toString();
				else
				{
					strChild = getQualifiedClassName(objChild).split("::")[1];
					if(strChild == null || strChild == "null")
						strChild = getQualifiedClassName(child).split("::")[0];
				}
				
				strChild = strChild.replace(pattern2, "");
				strChild = strChild.replace(pattern, "");
				
				strSpecialGenieID = "FP^" + strFirstLevelParent + ":::SE^" + strSelf + ":::CH^" + strChild; 
			}
			else
			{
				strSecondLevelParent = getSecondLevelParent();
				
				strSecondLevelParent = strSecondLevelParent.replace(pattern2, "");
				strSecondLevelParent = strSecondLevelParent.replace(pattern, "");
				
				strSpecialGenieID = "SP^" + strSecondLevelParent + ":::FP^" + strFirstLevelParent + ":::SE^" + strSelf;
			}
			
			return strSpecialGenieID;
		}
		
		private function checkForName(obj:Object):Boolean
		{
			if(obj.hasOwnProperty("name"))
			{
				if(obj["name"] != null && obj["name"].toString().toLowerCase().indexOf("instance") == -1 &&
					obj["name"].toString() != "")
				{
					return true;
				}
				else
					return false;
			}
			else
				return false;
		}
		
		private function getRecursiveValidChild(obj:Object):Object
		{
			var strClassName:String = "";
			var bNumChildren:Boolean = false;
			var objToReturn:Object = new Object();
			
			if(obj.hasOwnProperty("numChildren") && obj.numChildren > 0)
			{
				bNumChildren = true;
				for(var i:int = 0; i < obj.numChildren; i++)
				{
					var argChild:* = obj.getChildAt(i);
					strClassName = getQualifiedClassName(argChild);
					if(strClassName == "flash.display::Sprite" || strClassName == "flash.display::MovieClip" || strClassName == "flash.display::Shape")
					{
						if(checkForName(argChild))
							return argChild;
					}
					else
						return argChild;
				}
			}
			
			if(bNumChildren)
			{
				for(i = 0; i < obj.numChildren; i++)
				{
					argChild = obj.getChildAt(i);
					objToReturn = getRecursiveValidChild(argChild);
				}
			}
			return null;
		}
		
		private function getFirstLevelParent(parent:Object):String
		{
			//get qualified classname
			var strToReturn:String = "";
			var strClassName:String = getQualifiedClassName(parent);
			if(strClassName == "flash.display::Sprite" || strClassName == "flash.display::MovieClip" || strClassName == "flash.display::Shape")
			{
				//if parent is special comp, check for name
				if(checkForName(parent))
				{
					objFirstLevelParent = parent;
					return parent["name"].toString();
				}
					// go recursively for type or name
				else
				{
					var objParent:Object = parent.parent;
					strClassName = getQualifiedClassName(objParent);
					if(strClassName == "flash.display::Sprite" || strClassName == "flash.display::MovieClip" || strClassName == "flash.display::Shape")
					{
						while(strClassName == "flash.display::Sprite" || strClassName == "flash.display::MovieClip" || strClassName == "flash.display::Shape")
						{
							if(checkForName(objParent))
							{
								return objParent["name"].toString();
							}
							objParent = objParent.parent;
							strClassName = getQualifiedClassName(objParent);
							objFirstLevelParent = objParent;
						}
						if(checkForName(objParent))
							return objParent["name"].toString();
						else
						{
							strToReturn = getQualifiedClassName(objParent).split("::")[1];
							if(strToReturn == null || strToReturn == "null")
								strToReturn = getQualifiedClassName(objParent).split("::")[0];
							
							return strToReturn;
						}
						
						
					}
					else
					{
						objFirstLevelParent = objParent;
						if(checkForName(objParent))
							return objParent["name"].toString();
						else
						{
							strToReturn = getQualifiedClassName(objParent).split("::")[1];
							if(strToReturn == null || strToReturn == "null")
								strToReturn = getQualifiedClassName(objParent).split("::")[0];
							
							return strToReturn;
						}
					}
				}
			}
			else
			{
				objFirstLevelParent = parent;
				if(checkForName(parent))
					return parent["name"].toString();
				else
				{
					strToReturn = getQualifiedClassName(parent).split("::")[1];
					if(strToReturn == null || strToReturn == "null")
						strToReturn = getQualifiedClassName(parent).split("::")[0];
					
					return strToReturn;
				}
			}
			return "";
		}
		
		private function getSecondLevelParent():String
		{
			if(objFirstLevelParent.parent)
				return getFirstLevelParent(objFirstLevelParent.parent);
			else
				return getFirstLevelParent(objFirstLevelParent);
		}
		
		private function isNameInstance(obj:Object):Boolean
		{
			if(obj.hasOwnProperty("name"))
			{
				if(obj["name"] != null && obj["name"].toString().toLowerCase().indexOf("instance") > -1)
					return true;
				else
					return false;
			}
			else
				return false;
		}
		
		//Handle for Sprite, MovieClip and Shape ends here
		
		public function helpCreateIDPart(parent:Object,child:Object):String
		{
			var strClassName:String = "";
			var strParentClassName:String = "";
			var strCreateGenieID:String = "";
			var strParentGenieID:String = "";
			var strChildID:String = "";
			var nRecursive:int = 0;
			var iIndex:int = 0;
			var pattern:RegExp = /\d+/;
			var pattern2:RegExp = /[0-9]+[_]/;
			
			if(child == null)
				return "";
			else
			{
				strClassName = getQualifiedClassName(child);
				strParentClassName = getQualifiedClassName(parent);
			}

			var flexComponent:Class = null;
			var bFlexComponent:Boolean = true;
						
			try
			{
				if(child.hasOwnProperty("loaderInfo") && child.loaderInfo)
					flexComponent = child.loaderInfo.applicationDomain.getDefinition("mx.core::UIComponent") as Class;
				else if(child.hasOwnProperty("parent") && child.parent)
					flexComponent = child.parent.loaderInfo.applicationDomain.getDefinition("mx.core::UIComponent") as Class;
				else if(child.hasOwnProperty("owner") && child.owner)
					flexComponent = child.owner.loaderInfo.applicationDomain.getDefinition("mx.core::UIComponent") as Class;
				
				if(flexComponent == null || !(child is flexComponent))
					bFlexComponent = false;
			}
			catch(e:Error)
			{
				bFlexComponent = false;
			}
			
			try
			{
				if(!bFlexComponent)
				{
					flexComponent = child.moduleFactory.loaderInfo.applicationDomain.getDefinition("mx.core::UIComponent") as Class;
					if(flexComponent == null || !(child is flexComponent))
						bFlexComponent = false;
					else
						bFlexComponent = true;
				}
			}
			catch(e:Error)
			{
				bFlexComponent = false;
			}
			
			//If component is not mx, spark, hero component (which we believe extends from UIComponent
			//or the component is unknown register it as sprite algo else normal algo
			if(!bFlexComponent && strClassName != "flash.display::Stage" && strClassName != "flash.display::NativeMenu")
			{
				var strGameParentGenieId:String = objGetGenieIdFromObject[parent];
				strCreateGenieID = objGames.helpCreateIDPartForSpecialComponents(parent, child, strGameParentGenieId);
				return strCreateGenieID;
			}
			else
			{
				if(parent == null)
				{
					strParentGenieID = "root0";
				}
				else
				{
					strParentGenieID = getGenieIDForAutomatableParent(child);
					
					if(strParentGenieID != null && strParentGenieID != "")
					{
						var strSplit:Array = strParentGenieID.split(":::");
						strParentGenieID = strSplit[1].toString();
					}
					else
						strParentGenieID = "root0";
				}
				
				arrGenieId = new Array();
				getCorrectClassName(child);
				
				strChildID = getID(child);
				
				if(strChildID.indexOf("CN^") > -1)
				{
					if(strClassName == "mx.controls::List" || strExtendedClassName == "mx.controls::List" || 
						strClassName == "mx.controls::Menu" || strExtendedClassName == "mx.controls::Menu" ||
						strClassName == "mx.controls.listClasses::ListBaseContentHolder" || strExtendedClassName == "mx.controls.listClasses::ListBaseContentHolder")
					{
						iIndex = getChildIndex(parent, child);
						
						strChildID = strChildID.replace(pattern2, iIndex.toString());
						strChildID = strChildID.replace(pattern, "");
						arrGenieId.push(strChildID);
					}
					else
					{
						iIndex = getChildIndex(parent, child);
						var superClassName:String = getQualifiedSuperclassName(child);
						if(!(strChildID.indexOf(GenieMix.strApplicationName) > -1 && (superClassName == "mx.core::Application" || superClassName == "spark.components::Application")))
						{
							strChildID = strChildID.replace(pattern2, iIndex.toString());
							strChildID = strChildID.replace(pattern, "");
						}
						
						arrGenieId.push(strChildID);
						arrGenieId.push("IX^" + iIndex.toString());
					}
				}
				else
					arrGenieId.push(strChildID);
				
				if(objectArray[strCreateGenieID])
				{
					nRecursive = getRecursiveIndex(child, strCreateGenieID);
				}
				
				arrGenieId.push("ITR^" + nRecursive.toString());
				//strCreateGenieID = strCreateGenieID + ":" + "ITR^" + nRecursive.toString();
				strCreateGenieID = constructGenieID(arrGenieId);
				strCreateGenieID = strParentGenieID + ":::" + strCreateGenieID;
			}
			return strCreateGenieID;
		}
		
		public function constructGenieID(arrGenieId:Array):String
		{
			var strTempGenieID:String = "";
			for each(var str:String in arrGenieId)
			{
				if(strTempGenieID == "")
					strTempGenieID = str + "::";
				else
				{
					strTempGenieID = strTempGenieID + str + "::";
				}
			}
			
			if(strTempGenieID != "")
				strTempGenieID = strTempGenieID.substring(0, strTempGenieID.length - 2);
			
			return strTempGenieID;
		}
		
		public function getChildIndex(parent:Object,child:Object):int
		{
			var childNumber:int = 0;
			if (parent != null)
			{
				var parentsChildren:Array = getChildren(parent); 
				
				for (var childNo:int = 0; childNo < parentsChildren.length; ++childNo)
				{
					var obj:Object = parentsChildren[childNo];
					if(getChildEligibility(obj))
					{
						childNumber ++;
						if (child == parentsChildren[childNo])
							return childNumber;
					}
				}
			}
			
			return -1;
		}
		
		protected function getChildren(parent:Object):Array
		{
			var arrChildren:Array = new Array();
			try
			{
				var delegate:Object = new Object();
				delegate = Automation.getDelegate(parent);
				return delegate.getAutomationChildren();
			}
			catch(e:Error)
			{}
			return arrChildren;
		}
		
		public function getCorrectClassName(child:Object, bToRegister:Boolean = false):void
		{
			var t1:Date = new Date();
			try
			{
				strExtendedClassName = "";
				var automationClass:IAutomationClass;
				
				automationClass = IAutomationEnvironment(GenieMix.automationManager.automationEnvironment).getAutomationClassByInstance(child);
				if(automationClass)				
					strExtendedClassName = automationClass.objExtendedClassName;
			}
			catch(e:Error)
			{
				objLogs.traceLog(GenieLogConst.ERROR, " Error: "+e.message.toString()+" in function getCorrectClassName");
			}
			
		}
		
		public function customComponentInfo(data:String, strGuid:String = "", from:String = ""):void
		{
			var customData:XML = new XML("<Data>" + data+ "</Data>");
			var pathList:XMLList = customData.Path;
			for(var i:int =0; i<pathList.length(); ++i)
			{
				GenieMix.customComponentSWFArray.addItem(pathList[i].toString());
				//Load Custom Component
				var objLoad:LoadCustomContent = new LoadCustomContent();
				objLoad.LoadCustomSwf(pathList[i].toString());
			}
		}
		
		public function customComponentEnvFile(data:String, strGuid:String = "", from:String = ""):void
		{
			//trace(data);
			if(data != null && data.toString().length > 0 && data.toString() != "")
			{
				var customEnv:XML = new XML(data);
				GenieMix.ge.addCustom(customEnv);
			}
		}
		
		public function dontPropagateActions(doPerform:Boolean, strGuid:String = "", from:String=""):void
		{
			dontPropagateActionPerformed = doPerform;
		}
		
		public function SetDebugFlag(bDebug:Boolean, strGuid:String = "", from:String = ""):void
		{
			isDebugTrue = bDebug;
			if(bDebug == false)
			{
				
				if(timerApp!= null && timerApp.hasEventListener(TimerEvent.TIMER))
				{
					timerApp.removeEventListener(TimerEvent.TIMER,sendDeltaXML);
				}
				
				if (GenieMix.getDisplay.currentState == "Playing")
				{
					GenieMix.getDisplay.setPreviousIconAsEnabled();
				}
				GenieMix.getDisplay.enableGenie();
			}
			else
			{
				if(!timerApp.hasEventListener(TimerEvent.TIMER))
				{
					timerApp.addEventListener(TimerEvent.TIMER, sendDeltaXML);
					timerApp.start();
				}
				
				GenieMix.getDisplay.resetPreviousIcon();
			}
		}
		
		public function setHighPerformanceMode(bDebug:Boolean, strGuid:String = "", from:String = ""):void
		{
			GenieMix.highPerformanceMode = bDebug;
		}
		
		public function traceDebug(bTrace:Boolean, strGuid:String = "", from:String = ""):void
		{
			GenieLog.isTraceEnabled = bTrace;
		}
		/*===============================================================================
		Automation Delegates Related Function ends here
		===============================================================================*/	
		
		/*===============================================================================
		EVENT HANDLING Function Begins here
		===============================================================================*/		
		
		//This is function to send GenieID to plugin for finding component in Plugin tree.
		protected function eventClickHandler(e:MouseEvent):void
		{
			var object:Object = findObjectForSelection(e.target);
			var objectName:String = objGetGenieIdFromObject[object];
			
			if(objectName != null)
			{
				//If a mode is on than only stop the propagation
				//Commented for Sprint 1.4 release and will then need to check for the flag
				
				if (dontPropagateActionPerformed)
				{
					e.preventDefault();
					e.stopPropagation();
					e.stopImmediatePropagation();
				}
				
				if(objectName != strlastClicked)
				{
					objCom.sendCommand(GenieMix.PLUGIN_NAME_STR,"SelectElement" , objectName,"");
					strlastClicked = objectName;	
				}
			}
		}
		
		private function findObjectForSelection(object:Object):Object
		{
			var objectName:String = objGetGenieIdFromObject[object];
			
			if(objectName != null)
				return object;
			else
			{
				if(object.parent != null)
					return findObjectForSelection(object.parent);	
			}
			return null;
		}
		
		//This is to capture the mouseDown event on the application
		public function captureIDFromMouseDownEvent(event:Event):void
		{
			var compClass:Class;
			var delegateClass:Class;
			var c:Class;
			var delegate:Object;
			var className:String = "";
			var targetObj:Object = null;
			
			if(event.currentTarget.toString().indexOf("StageManager") == -1)
				AutomationManager.system1 = event.currentTarget; 
			
			try
			{
				if(getQualifiedClassName(event.target) == "mx.controls.tabBarClasses::Tab" || 
					getQualifiedClassName(event.target) == "mx.controls.scrollClasses::ScrollThumb" ||
					getQualifiedClassName(event.target.parent) == "mx.controls.scrollClasses::ScrollBar" ||
					getQualifiedClassName(event.target.parent) == "mx.controls::VScrollBar" ||
					getQualifiedClassName(event.target.parent) == "mx.controls::HScrollBar" 
				)
				{
					try
					{
						className = getQualifiedClassName(event.target.automationOwner);
						targetObj = event.target.automationOwner;
					}
					catch(e:Error)
					{
						className = getQualifiedClassName(event.target.parent);
						targetObj = event.target.parent;
					}
				}
				else
				{
					try
					{
						className = getQualifiedClassName(event.target.automationOwner);
						targetObj = event.target.automationOwner;
					}
					catch(e:Error)
					{
						className = getQualifiedClassName(event.target.parent);
						targetObj = event.target.parent;
					}
				}
				addChildToAppXML(targetObj,"added");
			}
			catch(e:Error)
			{}
			
		}
		
		//Below function to capture the delta happening at the rootObject
		public static var nCount:int = 0;
		private var totalTime:Number = 0;
		protected function stageCapture(event:Event):void
		{
			var child:Object = new Object();
			
			child = event.target;
			var t1:Date = new Date();
			if(getChildEligibility(child))
			{
				if(bEnableFinder)
				{
					rootObject.addEventListener(MouseEvent.MOUSE_DOWN,eventClickHandler,true);
					rootObject.addEventListener(MouseEvent.CLICK,eventClickHandler,true);
				}					
				
				//For some components update_Complete Event is not triggerred and hence they are not added to the tree xml
				//To get them timer functionality is implemented.
				var timer:Timer = new Timer(100 * 1, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, 
					function(e:Event):void
					{
						addChildToAppXML(child, event.type, e);
					}	
				);
				timer.start();
				
			}
			
		}
		
		//For CustomComponent easy
		public function customComponentClassNames(data:String, strGuid:String, from:String):void			
		{
			var data_xml:XML = new XML(data);
			var arrClass:Array = new Array();
			
			var xmlArguments:XMLList = data_xml.children();
			for(var iChild:int = 0; iChild < xmlArguments.children().length(); iChild++)
			{
				var className:String = xmlArguments.children()[iChild].toString();
				if (className != "")
					arrClass.push(className);
			}
			
			if (arrClass.length > 0)
				Automation.arrCustomClasses = arrClass;
			
			objCom.sendCommand("Server", "NowSendCustomComponentData", "", "");
		}
		
		private function getAllCustomChild(child:Object):Boolean
		{
			var arrClass:Array = new Array();
			var strParentClassName:String = "";
			
			strParentClassName = getQualifiedClassName(child);
			arrClass = Automation.arrCustomClasses;
			
			if(arrClass.indexOf(strParentClassName) > -1)
			{
				if(child.hasOwnProperty("numChildren"))
				{					
					return true;
				}
				
				
				if(child.hasOwnProperty("contentGroup"))
				{
					return true;
				}
				
				
				if(child.hasOwnProperty("rawChildren"))
				{
					return true;
				}
				
			}
			return false;
		}
		
		private function getNumCustomChild(child:Object):Array
		{
			var arrClass:Array = new Array();
			var arrChilds:Array = new Array();
			var strParentClassName:String = "";
			
			strParentClassName = getQualifiedClassName(child);
			arrClass = Automation.arrCustomClasses;
			
			if(arrClass.indexOf(strParentClassName) > -1)
			{
				if(child.hasOwnProperty("numChildren"))
				{					
					for(var x:int = 0; x < child.numChildren; x++)
					{
						var objArg:* = child.getChildAt(x);
						arrChilds.push(objArg);
					}
				}
				
				
				if(child.hasOwnProperty("contentGroup"))
				{
					for(x = 0; x < child.contentGroup.numChildren; x++)
					{
						objArg = child.contentGroup.getChildAt(x);
						arrChilds.push(objArg);
					}
				}
				
				
				if(child.hasOwnProperty("rawChildren"))
				{
					for(x = 0; x < child.rawChildren.numChildren; x++)
					{
						objArg = child.rawChildren.getChildAt(x);
						arrChilds.push(objArg);
					}
				}
				
			}
			return arrChilds;
		}
		
		private function getCustomChildValidation(child:Object, bConsiderChild:Object = false):Boolean
		{		
			var arrClass:Array = new Array();
			var parent:Object = child.parent;
			var strParentClassName:String = "";
			
			if(bConsiderChild)
				parent = child;
			
			strParentClassName = getQualifiedClassName(parent);
			arrClass = Automation.arrCustomClasses;
			
			if(arrClass.indexOf(strParentClassName) > -1)
			{
				if(parent.hasOwnProperty("numChildren"))
				{
					for(var x:int = 0; x < parent.numChildren; x++)
					{
						var objArg:* = parent.getChildAt(x);
						if(objArg == child)
						{
							return true;
						}
					}
				}
				
				
				if(parent.hasOwnProperty("contentGroup"))
				{
					for(x = 0; x < parent.contentGroup.numChildren; x++)
					{
						objArg = parent.contentGroup.getChildAt(x);
						if(objArg == child)
						{
							return true;
						}
					}
				}
				
				
				if(parent.hasOwnProperty("rawChildren"))
				{
					for(x = 0; x < parent.rawChildren.numChildren; x++)
					{
						objArg = parent.rawChildren.getChildAt(x);
						if(objArg == child)
						{
							return true;
						}
					}
				}
				
			}
			return false;
		}

		public function addChildToAppXML(child:Object, eventType:String, e:Event = null, parent:Object = null):Boolean
		{
			
			var t1:Date = new Date();
			var bShouldAppend:Boolean = true;
			var parentParent:Object = new Object();
			var grandParent:Object = new Object();
			var delegate:Object = null;
			var flag:Boolean = true; 
			var childClassName:String = getQualifiedClassName(child);
			//var bAppend:Boolean = true;
			//Check if the object already exists in dictionary, return if it exists
			
			if(objGetGenieIdFromObject[child] != null)
				return true;
			if(e != null)
			{
				if(e.type == TimerEvent.TIMER_COMPLETE)
				{
					if(objGetGenieIdFromObject[child] != null)
						return true;
				}
			}
			
			if(parent == null)
				parent = child.parent;
			else
				flag = false;
			
			delegate = Automation.getDelegate(parent);
			
			if(delegate && flag)
				if(child.hasOwnProperty("owner") && getQualifiedClassName(parent).indexOf("ListBaseContentHolder") == -1)
				{
					if(child.owner != child.parent)
					{
						parent = child.owner;
						if(parent)
							delegate = Automation.getDelegate(parent);
						else
							return false;
					}
				}

				else
				{
					if(getQualifiedClassName(parent).indexOf("ListBaseContentHolder") > -1)
					{
						var o:Object = parent.owner;
						while(o)
						{
							if(getQualifiedClassName(o).indexOf("ListBaseContentHolder") > -1 || !showInHierarchy(o))
								o = o.owner;
							else
							{
								parent = o;
								delegate = Automation.getDelegate(o);
								break;
							}
						}
					}
				}
			
			if(parent == null)
				return false;
			
			if(delegate)
			{
				try
				{
					if(delegate.isGenieAutomationChild(child) == false)
					{
						var bTrue:Boolean = false;
						try
						{
							bTrue = getCustomChildValidation(child);	
						}
						catch(e:Error)
						{
							return false;
						}
						
						if(!bTrue)
							return false;
					}
				}
				catch(e:Error)
				{	}
			}
			
			try
			{
				if(bShouldAppend == true)
				{
					
					var strParentGenieId:String = objGetGenieIdFromObject[parent];
					var tmpHierarchy:HierarchyDictionary = new HierarchyDictionary();
					var myXML:XML = new XML();
					var objXML:XML = new XML();
					
					tmpHierarchy = objectArray[strParentGenieId];
					
					
					if( strParentGenieId == null && (tmpHierarchy == null || tmpHierarchy.xmlTree == null) )
					{
						if(parent == null)
							return false;
						objLogs.detailedTrace(GenieLogConst.INFO, "Parent " + strParentGenieId + "  was not found in tree");
						//child's parent does not exist in object array so call this function to add child'parent in tree
						if(!addChildToAppXML(parent,eventType))
						{
							while(parent)
							{
								parent = parent.parent;
								if( parent!= null && showInHierarchy(parent))
								{
									strParentGenieId = objGetGenieIdFromObject[parent];
									tmpHierarchy = objectArray[strParentGenieId];
									if(tmpHierarchy != null && tmpHierarchy.xmlTree != null)
									{
										if(addChildToAppXML(child,eventType,e,parent))
											break;
									}
								}								
							}
						}
					}
					else
					{
						myXML = tmpHierarchy.xmlTree;
						//if due to whatever reason parent XML is null then also call addChildToAppXML() to add parent.
						if(myXML == null && isDebugTrue == true)
						{
							addChildToAppXML(parent,eventType);
						}
						else
						{
							var xmlList:Array = new Array();
							
							//Add to the appXML no matter if its debug mode or not.
							objXML = getObjectXML(parent, child);
							
							try
							{
								if((objectArray[strGenieID] != null) && (objectArray[strGenieID].child != child)) //&& objGetGenieIdFromObject[child] == null)
								{
									createNewGenieID(parent);
									objXML.@genieID = strGenieID;
								}
							}
							catch(e:Error)
							{}
							
							if(strGenieID == strGenieIDForHighlight)
							{
								if(lastGlow)
									lastGlow.filters = new Array();
								var f:GlowFilter = new GlowFilter();
								var myFilters:Array = new Array();
								myFilters.push(f);
								
								child.filters = myFilters;
								lastGlow = child;
							}
							//if(objGetGenieIdFromObject[child] == null)
							var bChildExists:Boolean = false;
							try
							{
								if(objectArray[strGenieID].child)
									bChildExists = true;
							}
							catch(e:Error)
							{
								bChildExists = false;
							}
							if(!bChildExists)
							{
								myXML.appendChild(objXML);
								
								var tmpClass:HierarchyDictionary = new HierarchyDictionary();
								tmpClass.childObject = child;
								
								tmpClass.xmlTree = objXML;
								
								objectArray[strGenieID] = tmpClass;
								objGetGenieIdFromObject[child] = strGenieID;
								
								//if(isDebugTrue == true && bAppend)
								if(isDebugTrue == true)
								{
									var strData:String = "<GenieID>"+strParentGenieId+"</GenieID><Delta>"+objXML.toXMLString()+"</Delta>";
									tmpClass.updated = false;
									deltaReady = true;
									//objCom.sendCommand(GenieMix.PLUGIN_NAME_STR,"DeltaXML",	strData,"");
									//objLogs.detailedTrace(GenieLogConst.INFO, "Delta Data: "+strData);
								}

								delegate = Automation.getDelegate(child);
								if(delegate == null)
								{
									GenericAutomationImpl.registerObject(child);
									if(child.hasOwnProperty("numChildren"))
									{
										if(child.numChildren > 0)
										{
											for(var i:int = 0; i < child.numChildren; i++)
											{
												addChildToAppXML(child.getChildAt(i), eventType);
											}
										}
									}
								}
								else
								{
									if(child.hasOwnProperty("numChildren"))
									{
										var count:int = delegate.numGenieAutomationChildren();
										//delegate.uiComponent = child;
										if( count > 0)
										{
											for(i = 0; i < count; i++)
											{
												addChildToAppXML(delegate.getGenieAutomationChildAt(i), eventType, null, child);
											}										
										}
										
									}	
								}
							}
							else if(eventType == "updateComplete" || eventType == "valueCommit")
							{
								tmpClass = new HierarchyDictionary();
								tmpClass.childObject = child;
								
								var obj:Object = objectArray[strParentGenieId];
								tmpHierarchy.xmlTree = objXML;
								
								if(isDebugTrue == true)
								{
									strData = "<GenieID>"+strParentGenieId+"</GenieID><Delta>"+objXML.toXMLString()+"</Delta>";
									tmpClass.updated = false;
									deltaReady = true
									//objCom.sendCommand(GenieMix.PLUGIN_NAME_STR,"DeltaXML",	strData,"");
									//objLogs.detailedTrace(GenieLogConst.INFO, "Delta Data: "+strData);
								}
							}
						}
					}
				}
			}
			catch(e1:Error)
			{
				objLogs.detailedTrace(GenieLogConst.INFO, e1.message + " function stageCapture");
				return false;
			}
			return true;
		}
		
		/*===============================================================================
		Event Handling Function Ends here
		===============================================================================*/
		
		/*===============================================================================
		General Functions Function Begins here
		===============================================================================*/		
		
		
		//To remove all the highlighed objects
		public function unGlow(strData:String = "", strGuid:String = "", from:String = ""):void
		{
			if(lastGlow)
				lastGlow.filters = new Array();
			strGenieIDForHighlight = null;
		}
		
		//Highlight an item in AUT
		public function Glow(objectStr:String,strGuid:String ,from:String = ""):void
		{
			try
			{
				objLogs.traceLog(GenieLogConst.INFO, "in Glow for objectStr: "+objectStr);
				var obj:Object = new Object();
				var glowHierarchy:HierarchyDictionary = new HierarchyDictionary();
				
				glowHierarchy = objectArray[objectStr];

				strGenieIDForHighlight = objectStr;
				
				obj = glowHierarchy.child;
				if(lastGlow)
					lastGlow.filters = new Array();
				if(objectStr != null && objectStr.length > 0)
				{
					var f:GlowFilter = new GlowFilter();
					var myFilters:Array = new Array();
					myFilters.push(f);
					
					obj.filters = myFilters;
					lastGlow = obj;	
				}	
			}
			catch(e:Error)
			{
				objLogs.traceLog(GenieLogConst.ERROR, "function Glow: "+e.message);	
			}
		}
		
		private function convertArrayFromStringToAs(a:String):Array
		{
			var result:Array = a.split("_ARG_SEP_");
			for (var i:uint = 0; i < result.length; i++)
			{
				if (result[i] == "__NULL__")
					result[i] = null;
			}
			return result;
		}
		//Add MouseEvent.Click event listerner on all the objects to do the inverse og Glow.
		public function EnableFinder(strGuid:String = "", from:String = ""):void
		{
			try
			{
				bEnableFinder = true;
				rootObject.addEventListener(MouseEvent.MOUSE_DOWN,eventClickHandler,true);
				rootObject.addEventListener(MouseEvent.CLICK,eventClickHandler,true);
			}
			catch(e:Error)
			{
				objLogs.traceLog(GenieLogConst.ERROR, "function EnableFinder: "+e.message);	
			}
		}
		
		private function mouseCursorChangeHandler(e:FocusEvent):void
		{
			Mouse.cursor = MouseCursor.HAND;
		}
		//remove the event listeners once the object is traced in plugin tree
		public function DisableFinder(strGuid:String = "", from:String = ""):void
		{
			try
			{
				bEnableFinder = false;
				rootObject.removeEventListener(MouseEvent.MOUSE_DOWN,eventClickHandler,true);
				rootObject.removeEventListener(MouseEvent.CLICK,eventClickHandler,true);
				Mouse.cursor = MouseCursor.AUTO;	
			}
			catch(e:Error)
			{
				objLogs.traceLog(GenieLogConst.ERROR, "function DisableFinder: "+e.message);	
			}
		}
		
		private function getVersion():String
		{
			return GenieMix.getLatestVersion();	
		}
		
		//This function is added to record the Keyboard actions# KeyBoardSupport
		public function performKeyboardAutoSwitching(child:Object, strEventName:String, strObjClassName:String, arrArgs:Array, nDuration:int = 0):void
		{
			if(bRecordUIEvents && !bStepRecorded)
			{
				var strStep:String = "";			
				var strTmpGenieID:String = objGetGenieIdFromObject[child];
				
				if(strTmpGenieID == null || strTmpGenieID == "")
				{
					if(lastObjectRemoved == child && genieIDLastObjectRemoved != null)
						strTmpGenieID = genieIDLastObjectRemoved;
					else if(objDeletedObject[child])
					{
						strTmpGenieID = objDeletedObject[child];
						delete objDeletedObject[child];
					}
				}
				
				if(strTmpGenieID != "" && strTmpGenieID != null)
				{					
					strStep = "<GenieID>" + strTmpGenieID + "</GenieID>";
					strStep += "<ClassName>" + strObjClassName + "</ClassName>";
					strStep += "<Event>" + strEventName + "</Event>";
					strStep += "<Arguments>";
					
					for(var i:int = 0; i < arrArgs.length; i++)
					{
						strStep += "<Argument>" + arrArgs[i].toString() + "</Argument>";
					}
					strStep += "<Argument>" + nDuration + "</Argument>";			
					strStep += "</Arguments>";
					
					//This is done to make sure that step is recorded single time
					//Since if an object is registered to GenericAutomationImpl, its parent also falls in the same mouseClickHandler function
					//with same target but different CurrentTarget. To handle this this is done.
					if(strLastUIStep != strStep)
					{
						strLastUIStep = strStep;
						objCom.sendCommand(GenieMix.PLUGIN_NAME_STR, "record",strStep,"");
						bDisplayObjectRecorded = true;
						trace("strStep: "+strStep);
					}
				}
			}
		}
		
		
		public function performAutoSwitching(child:Object, strEventName:String, strObjClassName:String, mouseX:int, mouseY:int, stageX:int, stageY:int, stageWidth:int, stageHeight:int, eventPhase:int = 0):void
		{
			if(bRecordUIEvents && !bStepRecorded)
			{
				var childX:int = child.mouseX;
				var childY:int = child.mouseY;
				var strStep:String = "";
				
				var strTmpGenieID:String = objGetGenieIdFromObject[child];
				
				if(strTmpGenieID == null || strTmpGenieID == "")
				{
					if(lastObjectRemoved == child && genieIDLastObjectRemoved != null)
						strTmpGenieID = genieIDLastObjectRemoved;
					else if(objDeletedObject[child])
					{
						strTmpGenieID = objDeletedObject[child];
						delete objDeletedObject[child];
					}
				}
				
				if(strTmpGenieID != "" && strTmpGenieID != null)
				{		
					var nMoveMouse:Boolean = false;
					
					if(strObjClassName == "flash.display::Sprite" || strObjClassName == "flash.display::MovieClip")
						nMoveMouse = true;
					else
						nMoveMouse = false;
					
					strStep = "<GenieID>"+strTmpGenieID+"</GenieID>";
					strStep += "<ClassName>"+strObjClassName+"</ClassName>";
					strStep += "<Event>"+strEventName+"</Event>";
					strStep += "<Arguments>";
					strStep += "<Argument>"+mouseX+"</Argument>";			
					strStep += "<Argument>"+mouseY+"</Argument>";
					strStep += "<Argument>"+stageX+"</Argument>";			
					strStep += "<Argument>"+stageY+"</Argument>";
					strStep += "<Argument>"+stageWidth+"</Argument>";			
					strStep += "<Argument>"+stageHeight+"</Argument>";
					strStep += "<Argument>"+eventPhase+"</Argument>";
					strStep += "<Argument>"+nMoveMouse.toString()+"</Argument>";
					strStep += "</Arguments>";
					
					//This is done to make sure that step is recorded single time
					//Since if an object is registered to GenericAutomationImpl, its parent also falls in the same mouseClickHandler function
					//with same target but different CurrentTarget. To handle this this is done.
					if(strLastUIStep != strStep)
					{
						strLastUIStep = strStep;
						objCom.sendCommand(GenieMix.PLUGIN_NAME_STR, "record",strStep,"");
						bDisplayObjectRecorded = true;
						trace("strStep: "+strStep);
					}
				}
			}
		}
		
		//Will get parent for the child found on the basis of given GenieID
		public function getParent(objectStr:String,strGuid:String ,from:String = ""):void
		{
			try
			{
				var dataXML:XML = new XML();
				var tmpXML:String = "";
				var strGenieID:String = "";
				var object:Object = null;
				var propValue:String = null;
				var result:XML = <Output></Output>;
				result.Result = false;
				
				if(objectStr)
				{
					dataXML = <Data>{objectStr}</Data>;
					tmpXML = dataXML.toXMLString();
					tmpXML = tmpXML.replace(/&lt;/g,"<");
					tmpXML = tmpXML.replace(/&gt;/g,">");
					
					XML.ignoreProcessingInstructions = false;
					XML.ignoreWhitespace = false;
					XML.prettyPrinting=false;
					dataXML = XML(tmpXML);
					
					
					if(dataXML.child("XML") != null && dataXML.child("XML") != "" && dataXML.child("XML").length() > 0)
					{
						dataXML = XML(dataXML.child("XML"));
					}
					
					strGenieID = dataXML.child("GenieID").text().toString();
					var objHierarchy:HierarchyDictionary = new HierarchyDictionary();
					objHierarchy = objectArray[strGenieID];
					if(objHierarchy)
						object = objHierarchy.child;
					else
						object = getObjectAfterTrim(strGenieID,null);
					
					if(object)
					{
						result.Result = true;
						propValue = objGetGenieIdFromObject[object.parent];
						result.Parent = propValue;
						result.Message = "";
					}
					else
					{
						result.Result = false;
						result.Parent = "";
						result.Message = "Object was not found for the given GenieID";
					}
				}
			}
			catch(e:Error)
			{
				result.Result = false;
				result.Parent = "";
				propValue = e.message.toString();
				result.Message = propValue;
				objLogs.traceLog(GenieLogConst.ERROR, e.message.toString() + " in function getParent"); 	
			}
			
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "getParent",result,"");
		}
		
		//Will get all child's genieID for the parent found on the basis of given GenieID
		//and properties of the child specified by the user
		public function getChild(objectStr:String,strGuid:String ,from:String = ""):void
		{
			var dataXML:XML = new XML();
			var tmpXML:String = "";
			var strGenieID:String = "";
			var obj:Object = null;
			var xmlArgs:XMLList;
			var arrListProperties:Array = new Array();
			var nProperties:int = 0;
			var arrProperties:Array = new Array();
			var propValue:String = "";
			var result:XML = <Output></Output>;
			var bContainsStar:Boolean = false;
			var i:int = 0;
			var arrStarValues:Array;
			result.Result = false;
			
			try
			{
				if(objectStr)
				{
					dataXML = <Data>{objectStr}</Data>;
					tmpXML = dataXML.toXMLString();
					tmpXML = tmpXML.replace(/&lt;/g,"<");
					tmpXML = tmpXML.replace(/&gt;/g,">");
					
					XML.ignoreProcessingInstructions = false;
					XML.ignoreWhitespace = false;
					XML.prettyPrinting=false;
					dataXML = XML(tmpXML);
					
					
					if(dataXML.child("XML") != null && dataXML.child("XML") != "" && dataXML.child("XML").length() > 0)
					{
						dataXML = XML(dataXML.child("XML"));
					}
					
					try
					{
						xmlArgs = dataXML.children();
						for(i = 0; i < xmlArgs.length(); i++)
						{
							try
							{
								var arrXML:XML = xmlArgs[i];
								
								if(arrXML.name().toString().toLowerCase() == "genieid")
									strGenieID = arrXML.text().toString();
								else
								{
									if(arrXML.name().toString() == "Properties")
									{
										for(var y:int = 0; y < arrXML.children().length(); y++)
										{
											arrListProperties.push(arrXML.children()[y]);
										}
									}
								}
							}
							catch(e:Error){}
						}
					}
					catch(e:Error)
					{
						arrListProperties = null;
					}
					
					if(arrListProperties == null || arrListProperties.length == 0)
					{
						result.Result = false;
						result.Children = "";
						result.Message = "No child property specified for the given GenieID";
						
						if(from.length > 0)
							objCom.sendCommandWithId(from,strGuid, "getChild",result,"");
						
						return;
					}
					else
					{
						arrProperties = new Array();
						var strStepArgument:String = "";
						for(x = 0; x < arrListProperties.length; x++)
						{
							arrProperties.push(arrListProperties[x]);
						}
					}
					
					var objHierarchy:HierarchyDictionary = new HierarchyDictionary();
					objHierarchy = objectArray[strGenieID];
					if(objHierarchy)
						obj = objHierarchy.child;
					else
						obj = getObjectAfterTrim(strGenieID, null);				
					
					if(obj)
					{
						var objDelegate:Object = Automation.getDelegate(obj);
						var nChildren:int = 0;
						
						try
						{	
							if(objDelegate)
								nChildren = objDelegate.numGenieAutomationChildren();
							else
								nChildren = obj.numChildren;
						}
						catch(e:Error)
						{
							objLogs.traceLog(GenieLogConst.ERROR, e.message.toString() + " in function findComponentHelper");
						}
						
						if(nChildren > 0)
						{
							for(i = 0; i < nChildren; i++)
							{
								var argChild:*;
								if(objDelegate)
									argChild = objDelegate.getGenieAutomationChildAt(i);
								else
									argChild = obj.getChildAt(i);
								var bMatched:Boolean = true;
								
								if(argChild)
								{
									for(var x:int = 0; x < arrProperties.length; x++)
									{
										var xmlTmp:XML = XML(arrProperties[x]);
										var strProperty:String = "";
										var strValue:String = "";
										if(xmlTmp.attributes().length() > 0)
										{
											strProperty = xmlTmp.name().toString();
											strValue = xmlTmp.attributes().toString();
											if(strValue.indexOf("*") > -1)
											{
												arrStarValues = new Array();
												arrStarValues = strValue.split("*");
												bContainsStar = true;
											}
											else
												bContainsStar = false;
										}
										
										//Note, index is not a property
										if (strProperty == "index")
										{
											var tempI:int = getChildIndex(obj,argChild);
											if (strValue == tempI.toString())
											{
												bMatched = true;
											}
											else
											{
												bMatched = false;
											}
										}else
											if (strProperty == "qualifiedClassName")
											{
												var strClassName:String = getQualifiedClassName(argChild);
												
												if (strValue == strClassName)
												{
													bMatched = true;
												}
												else
												{
													bMatched = false;
												}
											}
											else if(argChild.hasOwnProperty(strProperty))
											{
												if(argChild[strProperty])
												{
													if(!bContainsStar)
													{
														if(argChild[strProperty].toString() == strValue)
															bMatched = true && bMatched;
														else
														{
															bMatched = false;
															break;
														}
													}
													else
													{
														var strTempObjPropertyValue:String = argChild[strProperty].toString();
														for(var r:int = 0; r < arrStarValues.length; r++)
														{
															if(strTempObjPropertyValue.indexOf(arrStarValues[r].toString()) > -1)
																bMatched = true && bMatched;
															else
															{
																bMatched = false;
																break;
															}	
														}
													}
												}
												else
												{
													bMatched = false;
													break;
												}		
											}
											else
											{
												bMatched = false;
												break;
											}
									}
								}
								if(bMatched)
								{
									if(propValue == null)
										propValue = objGetGenieIdFromObject[argChild] + "|";
									else
									{
										if(propValue.indexOf(objGetGenieIdFromObject[argChild]+"|") == -1)
											propValue += objGetGenieIdFromObject[argChild] + "|";
									}
								}
							}
							result.Result = true;
							result.Children = "";
							if(propValue != null && propValue != "")
							{
								propValue = propValue.substr(0, propValue.length - 1);
								result.Children = propValue;
								result.Message = "";
							}
						}
						else if(nChildren == 0) 
						{
							result.Result = true;
							result.Children = "";
							result.Message = "";
						}
						else
						{
							result.Result = false;
							result.Children = "";
							result.Message = "Given genieID object does not have any automatable children.";
						}	
					}
					else
					{
						result.Result = false;
						result.Children = "";
						if(strGenieID != "")
							result.Message = "No Object found for the given GenieID";
						else
							result.Message = "GenieID was BLANK and for recursion value = false, GenieID is mandatory.";
						
					}
				}
				else
				{
					result.Result = false;
					result.Children = "";
					result.Message = "XML sent was not having any data inside it.";
				}
			}
			
			catch(e:Error)
			{
				result.Result = false;
				result.Children = "";
				propValue = e.message.toString();
				result.Message = propValue;
				objLogs.traceLog(GenieLogConst.ERROR, e.message.toString() + " in function getParent"); 	
			}
			
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "getChild",result,"");
		}
		
		/**
		 * @brief: Helper recursive function for findComponent
		 */ 
		private function findComponentHelper(obj:Object, propertiesArray:Array, resultPropValue:String):String
		{
			try
			{
				var dataXML:XML = new XML();
				var tmpXML:String = "";
				var xmlArgs:XMLList;
				var nProperties:int = 0;
				var propValue:String = null;
				var result:XML = <Output></Output>;
				var bContainsStar:Boolean = false;
				var arrStarValues:Array;
				result.Result = false;
				
				if(propertiesArray)
				{
					if(propertiesArray == null || propertiesArray.length == 0)
					{
						return resultPropValue;
					}
					
					if(obj)
					{
						var objDelegate:Object = Automation.getDelegate(obj);
						var nChildren:int = 0;
						try
						{	
							if(objDelegate)
								nChildren = objDelegate.numGenieAutomationChildren();
							else
								nChildren = obj.numChildren;
						}
						catch(e:Error)
						{
							objLogs.traceLog(GenieLogConst.ERROR, e.message.toString() + " in function findComponentHelper");
						}
						if(nChildren > 0)
						{
							for(var i:int = 0; i < nChildren; i++)
							{
								var argChild:*;
								if(objDelegate)
									argChild = objDelegate.getGenieAutomationChildAt(i);
								else
									argChild = obj.getChildAt(i);
								
								var bMatched:Boolean = true;
								if(argChild)
								{
									for(var x:int = 0; x < propertiesArray.length; x++)
									{
										var xmlTmp:XML = XML(propertiesArray[x]);
										var strProperty:String = "";
										var strValue:String = "";
										if(xmlTmp.attributes().length() > 0)
										{
											strProperty = xmlTmp.name().toString();
											strValue = xmlTmp.attributes().toString();
											if(strValue.indexOf("*") > -1)
											{
												arrStarValues = new Array();
												arrStarValues = strValue.split("*");
												bContainsStar = true;
											}
											else
												bContainsStar = false;
										}
										
										//Note, index is not a property
										if (strProperty == "index")
										{
											var tempI:int = getChildIndex(obj,argChild);
											
											if (strValue == tempI.toString())
											{
												bMatched = true;
											}
											else
											{
												bMatched = false;
											}
										}
										//isHierarchyVisible is not a property. Check for the visibility till stage
										else if(strProperty == "isHierarchyVisible")
										{
											bMatched = shouldPlayback(argChild);
										}
										else
										{
											if (strProperty == "qualifiedClassName")
											{
												var strClassName:String = getQualifiedClassName(argChild);
												
												if (strValue == strClassName)
												{
													bMatched = true;
												}
												else
												{
													bMatched = false;
												}
											}
											else if(argChild.hasOwnProperty(strProperty))
											{
												if(argChild[strProperty] != null)
												{
													if(!bContainsStar)
													{
														if(argChild[strProperty].toString() == strValue)
															bMatched = true && bMatched;
														else
														{
															bMatched = false;
															break;
														}
													}
													else
													{
														var strTempObjPropertyValue:String = argChild[strProperty].toString();
														for(var r:int = 0; r < arrStarValues.length; r++)
														{
															if(strTempObjPropertyValue.indexOf(arrStarValues[r].toString()) > -1)
																bMatched = true && bMatched;
															else
															{
																bMatched = false;
																break;
															}	
														}
													}
												}
												else
												{
													bMatched = false;
													break;
												}
												
											}
											else
											{
												bMatched = false;
												break;
											}
										}
									}
									if(bMatched)
									{
										if(resultPropValue == null)
											resultPropValue = objGetGenieIdFromObject[argChild] + "|";
										else
											if(resultPropValue.indexOf(objGetGenieIdFromObject[argChild]+"|") == -1)
												resultPropValue += objGetGenieIdFromObject[argChild] + "|";
									}
									
									//Going recursive for current GenieID as parent
									var genieIDChild:String = objGetGenieIdFromObject[argChild];
									if (genieIDChild != null)
									{
										resultPropValue = findComponentHelper(argChild, propertiesArray, resultPropValue);
									}
								}
							}
						}
					}					
				}				
			}
			catch(e:Error)
			{
				objLogs.traceLog(GenieLogConst.ERROR, e.message.toString() + " in function findComponentHelper");				
			}
			
			return resultPropValue;
		}
		
		//Will get all objects on the basis of the properties specified by the user
		public function findComponent(objectStr:String,strGuid:String ,from:String = ""):void
		{
			var dataXML:XML = new XML();
			var obj:Object = null;
			var tmpXML:String = "";
			var arrProperties:Array = new Array();
			var propValue:String = "";
			var result:XML = <Output></Output>;
			result.Result = false;
			
			try
			{
				if(objectStr)
				{
					dataXML = <Data>{objectStr}</Data>;
					tmpXML = dataXML.toXMLString();
					tmpXML = tmpXML.replace(/&lt;/g,"<");
					tmpXML = tmpXML.replace(/&gt;/g,">");
					
					XML.ignoreProcessingInstructions = false;
					XML.ignoreWhitespace = false;
					XML.prettyPrinting=false;
					dataXML = XML(tmpXML);
					
					if(dataXML.child("XML") != null && dataXML.child("XML") != "" && dataXML.child("XML").length() > 0)
					{
						dataXML = XML(dataXML.child("XML"));
					}
					var childNodes:XMLList = dataXML.children();
					if(childNodes.length() > 0)
					{
						var propertiesArr:Array = new Array();
						
						var objectGenieID:String = "";
						var l:int = childNodes.length();
						for(var i:int = 0; i < l; i++)
						{
							try
							{
								var arrXML:XML = childNodes[i];
								var tpS:String = arrXML.name().toString();
								
								if(tpS.toLowerCase() == "genieid")
									objectGenieID = arrXML.text().toString();
								else
								{
									if(tpS == "Properties")
									{
										for(var y:int = 0; y < arrXML.children().length(); y++)
										{
											propertiesArr.push(arrXML.children()[y]);
										}
									}
								}
							}
							catch(e:Error)
							{}
						}
						
						var objHierarchy:HierarchyDictionary = new HierarchyDictionary();
						objHierarchy = objectArray[objectGenieID];
						if(objHierarchy)
							obj = objHierarchy.child;
						else
							obj = getObjectAfterTrim(objectGenieID ,null);
						
						if(obj)
						{
							//Calling main helper function
							propValue = findComponentHelper(obj, propertiesArr, propValue);
							result.Result = true;
							if(propValue != null && propValue != "")
							{
								result.Children = propValue.substr(0, propValue.length - 1);
								result.Message = "";
							}
						}
						else
						{
							result.Result = false;
							result.Message = "COMPONENT_OF_GIVEN_GENIEID_NOT_AVAILABLE_ON_STAGE";
							
						}
					}					
				}					
			}
			catch(e:Error)
			{
				result.Result = false;
				result.Children = "";
				result.Message = e.message.toString();;
				objLogs.traceLog(GenieLogConst.ERROR, e.message.toString() + " in function getParent"); 	
			}
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "findComponent",result,"");
			
		}
		
		//Will get all objects on the basis of the properties specified by the user
		public function findComponentInDictionary(objectStr:String,strGuid:String ,from:String = ""):void
		{
			var dataXML:XML = new XML();
			var tmpXML:String = "";
			var arrProperties:Array = new Array();
			var propValue:String = null;
			var result:XML = <Output></Output>;
			var bContainsStar:Boolean = false;
			var arrStarValues:Array;
			result.Result = false;
			
			try
			{
				if(objectStr)
				{
					dataXML = <Data>{objectStr}</Data>;
					tmpXML = dataXML.toXMLString();
					tmpXML = tmpXML.replace(/&lt;/g,"<");
					tmpXML = tmpXML.replace(/&gt;/g,">");
					
					XML.ignoreProcessingInstructions = false;
					XML.ignoreWhitespace = false;
					XML.prettyPrinting=false;
					dataXML = XML(tmpXML);
					
					if(dataXML.child("XML") != null && dataXML.child("XML") != "" && dataXML.child("XML").length() > 0)
					{
						dataXML = XML(dataXML.child("XML"));
					}
					var childNodes:XMLList = dataXML.children();
					if(childNodes.length() > 0)
					{
						for(var i:int = 0; i < childNodes.length(); i++)
						{
							try
							{
								var arrXML:XML = childNodes[i];
								if(arrXML.name().toString() == "Properties")
								{
									for(var y:int = 0; y < arrXML.children().length(); y++)
									{
										arrProperties.push(arrXML.children()[y]);
									}
								}
							}
							catch(e:Error)
							{}
						}
						
						for (var key:Object in objectArray)
						{
							var argChild:* = objectArray[key].child;
							var bMatched:Boolean = true;
							if(argChild)
							{
								for(var x:int = 0; x < arrProperties.length; x++)
								{
									var xmlTmp:XML = XML(arrProperties[x]);
									var strProperty:String = "";
									var strValue:String = "";
									if(xmlTmp.attributes().length() > 0)
									{
										strProperty = xmlTmp.name().toString();
										strValue = xmlTmp.attributes().toString();
										if(strValue.indexOf("*") > -1)
										{
											arrStarValues = new Array();
											arrStarValues = strValue.split("*");
											bContainsStar = true;
										}
										else
											bContainsStar = false;
									}
									
									
									if (strProperty == "qualifiedClassName")
									{
										var strClassName:String = getQualifiedClassName(argChild);
										
										if (strValue == strClassName)
										{
											bMatched = true;
										}
										else
										{
											bMatched = false;
										}
									}
									//isHierarchyVisible is not a property. Check for the visibility till stage
									else if(strProperty == "isHierarchyVisible")
									{
										bMatched = shouldPlayback(argChild);
									}
									else
									{
										if(argChild.hasOwnProperty(strProperty))
										{
											if(argChild[strProperty])
											{
												if(!bContainsStar)
												{
													if(argChild[strProperty].toString() == strValue)
														bMatched = true && bMatched;
													else
													{
														bMatched = false;
														break;
													}
												}
												else
												{
													var strTempObjPropertyValue:String = argChild[strProperty].toString();
													for(var r:int = 0; r < arrStarValues.length; r++)
													{
														if(strTempObjPropertyValue.indexOf(arrStarValues[r].toString()) > -1)
															bMatched = true && bMatched;
														else
														{
															bMatched = false;
															break;
														}	
													}
												}
											}
											else
											{
												bMatched = false;
												break;
											}
										}
										else
										{
											bMatched = false;
											break;
										}
									}
								}
							}	
							if(bMatched)
							{
								if(propValue == null)
									propValue = objGetGenieIdFromObject[argChild] + "|";
								else
									if(propValue.indexOf(objGetGenieIdFromObject[argChild]+"|") == -1)
										propValue += objGetGenieIdFromObject[argChild] + "|";
							}
							
						}
						result.Result = true;
						result.Children = "";
						if(propValue != null && propValue != "")
						{
							result.Children = propValue.substr(0, propValue.length - 1);
							result.Message = "";
						}
					}
					else
					{
						result.Result = false;
						result.Children = "";
						result.Message = "No child property specified for the given GenieID";
					}
				}
				else
				{
					result.Result = false;
					result.Children = "";
					result.Message = "XML sent was not having any data inside it.";
				}	
			}
			catch(e:Error)
			{
				result.Result = false;
				result.Children = "";
				propValue = e.message.toString();
				result.Message = propValue;
				objLogs.traceLog(GenieLogConst.ERROR, e.message.toString() + " in function getParent"); 	
			}
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "findComponent",result,"");
			
		}
		
		/*===============================================================================
		General Functions Function ends here
		===============================================================================*/		
		
		/*===============================================================================
		The following function gets the number of Automation children of a componenet
		===============================================================================*/	
		public function getNumAutomatableChildren(strData:String="", strGuid:String="", from:String = ""):void
		{
			var result:XML = <Output></Output>;
			result.Result = false;
			try
			{
				var xmlData:XML = new XML(strData);
				var genieID:String = xmlData.Input.GenieID;				
				var arrUserArgs:Array = new Array();
				var strTrimmedGenieId:String = genieID;
				var obj:HierarchyDictionary = new HierarchyDictionary();
				var child:Object = null;
				var compObj:Object=null;
				//Split for user args
				if(genieID.indexOf("$") > -1)
				{
					var arrTempSplit:Array = new Array();
					arrTempSplit = genieID.split("$");
					arrUserArgs = arrTempSplit[1].toString().split(",");
					genieID = arrTempSplit[0];
				}
				if(objectArray[genieID] != null)
				{
					obj = objectArray[genieID];
					child = obj.child;
					compObj=Automation.getDelegate(child);					
					result.Result = true;
					result.numAutomationChildren =compObj.numGenieAutomationChildren().toString() ;
					result.Message = "";
					
					
				}
				else
				{
					child = getObjectAfterTrim(strTrimmedGenieId, arrUserArgs);
					if(child)
					{
						compObj=Automation.getDelegate(child);					
						result.Result = true;
						result.numAutomationChildren =compObj.numGenieAutomationChildren().toString() ;
						result.Message = "";
					}
					else
						result.Message = "Object not found for genie id " +  genieID ;
				}
				
			}
			catch(e:Error)
			{
				result.Message = "Error occurred while fetching numAutomatable Children for genie id " +  genieID ;
				objLogs.detailedTrace(GenieLogConst.ERROR, e.message.toString());
			}
			
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "getNumAutomatableChildren",result,"");
		}
		/*===============================================================================
		The following function gets the child of a componenet at a particular index
		===============================================================================*/	
		public function getChildAt(strData:String="", strGuid:String="", from:String = ""):void
		{
			var result:XML = <Output></Output>;
			result.Result = false;
			try
			{
				var xmlData:XML = new XML(strData);
				var genieID:String = xmlData.Input.GenieID;				
				var arrUserArgs:Array = new Array();
				var strTrimmedGenieId:String = genieID;
				var obj:HierarchyDictionary = new HierarchyDictionary();
				var child:Object = null;
				var compObj:Object=null;				
				var index:Number=0;		
				var tempchild:Object=null
				var tempIchild:IAutomationObject=null;
				var genieId:String ="";
				//Split for user args
				if(genieID.indexOf("$") > -1)
				{
					var arrTempSplit:Array = new Array();
					arrTempSplit = genieID.split("$");
					arrUserArgs = arrTempSplit[1].toString().split(",");
					genieID = arrTempSplit[0];
				}
				
				
				
				if(objectArray[genieID] != null)
				{
					obj = objectArray[genieID];
					child = obj.child;
					compObj=Automation.getDelegate(child);						
					index=parseInt(xmlData.Input.PropertyName);			
					tempchild=compObj.getGenieAutomationChildAt(index);
					if (tempchild){
						genieId=objGetGenieIdFromObject[tempchild];
						result.ChildGenieId=genieId;
						result.Result = true;
						result.Message = "";
					}
					else
					{
						tempIchild=compObj.getAutomationChildAt(index);
						genieId=objGetGenieIdFromObject[tempIchild];
						if (genieId!=null){
							result.Result = true;
							bFound=true;
							result.ChildGenieId=genieId;		
							result.Message = "";
						}
						else{
							result.ChildGenieId="";
							result.Message = "Given index not found in the objects children"
						}
						
					}
					
					
					
				}
				else
				{
					var bFound:Boolean = false;					
					child = getObjectAfterTrim(genieID ,null);					
					compObj=Automation.getDelegate(child);	
					index=parseInt(xmlData.Input.PropertyName);			
					tempchild=compObj.getGenieAutomationChildAt(index);
					if (tempchild){
						genieId=objGetGenieIdFromObject[tempchild];
						result.ChildGenieId=genieId;
						result.Result = true;
						bFound=true;
						result.Message = "";
					}
					else
					{
						tempIchild=compObj.getAutomationChildAt(index);
						genieId=objGetGenieIdFromObject[tempIchild];
						if (genieId!=null){
							result.Result = true;
							bFound=true;
							result.ChildGenieId=genieId;		
							result.Message = "";
						}
						else{
							result.ChildGenieId="";
							result.Message = "Given index not found in the objects children"
						}
					}
					
					
					
					if(!bFound)
						result.Message = "Object not found for genie id " +  genieID ;
				}
				
			}
			catch(e:Error)
			{
				objLogs.detailedTrace(GenieLogConst.ERROR, e.message.toString());
			}
			
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "getChildAt",result,"");
		}
		
		
		public function attachEventListener(strData:String="", strGuid:String="", from:String = ""):void
		{
			try
			{
				var objResult:Object = new Object();
				var xmlData:XML = new XML(strData);
				var genieID:String = xmlData.Input.GenieID;
				var eventName:String = xmlData.Input.EventName;
				var eventGUID:String = xmlData.Input.EventGUID;
				var propertyName:String = xmlData.Input.PropertyName;
				
				var arrUserArgs:Array = new Array();
				var strTrimmedGenieId:String = genieID;
				var obj:Object = null;
				
				var result:String = "true";
				obj = getObjectForGenieID(genieID);
				
				if(obj)
				{
					if(propertyName.length > 0)
					{
						try{
						
							if(obj.hasOwnProperty(propertyName) && obj[propertyName] != null)
							{
								var propObject:Object = obj[propertyName];
								propObject.addEventListener(eventName,userEventHandler);
							}
						}catch(e:Error)
						{
							result = "Failed to attach event listener." + e.message;
						}	
					}
					else
					{
						obj.addEventListener(eventName,userEventHandler);
					}
					var userEvent:UserEventInfo = new UserEventInfo();
					
					userEvent.eventName = eventName;
					userEvent.eventGuid = eventGUID;
					userEvent.genieID = genieID;
					userEvent.object = obj;
					eventDictionary[eventGUID] = userEvent;
					
				}
				else
				{
					result = "COMPONENT_OF_GIVEN_GENIEID_NOT_AVAILABLE_ON_STAGE";
				}
			}
			catch(e:Error)
			{
				result = "false";
				objLogs.detailedTrace(GenieLogConst.ERROR, e.message.toString());
			}
			
			objResult.result = true;
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "attachEventListener", result,"");
		}
		
		public function returnEventData(strData:String="", strGuid:String="", from:String = ""):void
		{
			var result:String = "<Output>";
			try
			{
				var xmlData:XML = new XML(strData);
				var genieID:String = xmlData.Input.GenieID;
				var eventGUID:String = xmlData.Input.EventGUID;
				var arrUserArgs:Array = new Array();
				var strTrimmedGenieId:String = genieID;
				var obj:HierarchyDictionary = new HierarchyDictionary();
				var child:Object = null;
				
				if(genieID.indexOf("$") > -1)
				{
					var arrTempSplit:Array = new Array();
					arrTempSplit = genieID.split("$");
					arrUserArgs = arrTempSplit[1].toString().split(",");
					genieID = arrTempSplit[0];
				}
				
				
				if(eventDictionary[eventGUID] != null)
				{
					var userEvent:UserEventInfo = eventDictionary[eventGUID];
					if(userEvent != null)
					{
						for(var key:Object in userEvent.eventData)
						{
							result = result + "<EventProperty key=\"" + key.toString() + "\" value=\"" + userEvent.eventData[key] + "\" />";
						}
					}
				}
				result = result + "</Output>";
			}
			catch(e:Error)
			{
				objLogs.detailedTrace(GenieLogConst.ERROR, e.message.toString());
			}
			
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "returnEventData",result,"");
		}
		
		private function getObjectForGenieID(genieID:String):Object
		{
			//var arrUserArgs:Array = new Array();
			var glowHierarchy:HierarchyDictionary = new HierarchyDictionary();
			var obj:Object;
			var bVisible:Boolean = false;
			if(objectArray[genieID] != null)
			{
				obj = objectArray[genieID].child;
			}
			else
			{
				//Split for user args
				if(genieID.indexOf("$") > -1)
				{
					var arrTempSplit:Array = new Array();
					arrTempSplit = genieID.split("$");
					//arrUserArgs = arrTempSplit[1].toString().split(",");
					genieID = arrTempSplit[0];
				}
				//Commented below statement because we dont want to pass the user defined argumnts in getValueOf function
				//rather use GenieLocatorInfo for these purposes
				//obj = getVisibleObject(genieID,arrUserArgs);
				obj = getVisibleObject(genieID,null);
				
			}
			return obj;
		}
		
		private function getVisibleObject(genieID:String,arrUserArgs:Array):Object
		{
			var arrGenieID:Array = new Array();
			
			var glowHierarchy:HierarchyDictionary = new HierarchyDictionary();
			var bVisible:Boolean = false;
			var obj:Object;
			arrGenieID = getGenieIDForITR(genieID, arrUserArgs);
			
			if(arrGenieID != null && arrGenieID.length > 0)
			{
				for(var i:int = 0; i < arrGenieID.length; i++)
				{
					glowHierarchy = arrGenieID[i];
					if(glowHierarchy)
					{
						bVisible = shouldPlayback(glowHierarchy.child);
						if(bVisible)
						{
							obj = glowHierarchy.child;
							break;
						}
					}
				}
				
				// If still object is not found break on the basis of the index (if present) of child
				if(!bVisible)
				{
					arrGenieID = getGenieIDForIndex(genieID, arrUserArgs);
					if(arrGenieID != null && arrGenieID.length > 0)
					{
						for(i = 0; i < arrGenieID.length; i++)
						{
							glowHierarchy = arrGenieID[i];
							if(glowHierarchy)
							{
								bVisible = shouldPlayback(glowHierarchy.child);
								if(bVisible)
								{
									obj = glowHierarchy.child;
									break;
								}
							}
						}
					}
				}
			}
			return obj;
		}
		public function cleanEventArray():void
		{
			for (var key:Object in eventDictionary)
			{
				try{
					var userEventData:UserEventInfo = eventDictionary[key];
					userEventData.object.removeEventListener(userEventData.eventName);
				}catch(e:Error){}
			}
			//reset eventDictionary
			eventDictionary = new Dictionary();
		}
		private function userEventHandler(e:Event):void
		{
			var child:Object = e.target;
			var objGenieID:String = objGetGenieIdFromObject[child];
			for (var key:Object in eventDictionary)
			{
				var userEventData:UserEventInfo = eventDictionary[key];
				userEventData.eventObject = e;
				var classInfo:XML = describeType(e);
				userEventData.eventData = new Dictionary();
				// List the object's variables, their values, and their types.
				
				var prop:String = "";
				var value:String = "";
						
				for each (var a:XML in classInfo..accessor) 
				{
					if(a.@access != 'writeonly')
					{
						prop = a.@name;
						value = "";
						try
						{
							value = e[prop];
							value = GenieMix.getCleanStringForXML(value);
							value = GenieMix.getHidedQuotesFromString(value);
							
						}
						catch(e:Error)
						{
							value = "";
						}
						userEventData.eventData[prop] = value;
					}
				}
				for each (a in classInfo..variable) 
				{
					prop = a.@name;
					value = "";
					
					try
					{
						value = e[prop];
						value = GenieMix.getCleanStringForXML(value);
						value = GenieMix.getHidedQuotesFromString(value);
						
					}
					catch(e:Error)
					{
						value = "";
					}
					userEventData.eventData[prop] = value;
				}
			}
		}
		
		public function getEventValue(strData:String="", strGuid:String="", from:String = ""):void
		{
			var propValue:String = null;
			var result:String = "<Output>";
			
			try
			{
				var xmlData:XML = new XML(strData);
				var genieID:String = xmlData.Input.GenieID;
				var eventName:String = xmlData.Input.EventName;
				var arrUserArgs:Array = new Array();
				var strTrimmedGenieId:String = genieID;
				var obj:HierarchyDictionary = new HierarchyDictionary();
				var child:Object = null;
				//Split for user args
				if(genieID.indexOf("$") > -1)
				{
					var arrTempSplit:Array = new Array();
					arrTempSplit = genieID.split("$");
					arrUserArgs = arrTempSplit[1].toString().split(",");
					genieID = arrTempSplit[0];
				}
				
				for (var key:Object in eventDictionary)
				{
					
				}
				if(objectArray[genieID] != null)
				{
					obj = objectArray[genieID];
					var userEventData:UserEventInfo = eventDictionary[key];
					if(userEventData.genieID == genieID)
					{
						//result = result + "<Variable property=\"" + "prop" + "\" value=\"" + "value" + "\" />";
						
					}
				}
				
			}
			catch(e:Error)
			{
				objLogs.detailedTrace(GenieLogConst.ERROR, e.message.toString());
			}
			
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "getEventValue",result,"");
		}
		
		private function objectToXML(obj:Object):XML 
		{ 
			var qName:QName = new QName("root");
			var xmlDocument:XMLDocument = new XMLDocument();
			var simpleXMLEncoder:SimpleXMLEncoder = new SimpleXMLEncoder(xmlDocument);
			var xmlNode:XMLNode = simpleXMLEncoder.encodeValue(obj, qName, xmlDocument); 
			var xml:XML = new XML(xmlDocument.toString());
			return xml;
		} 
		
		/*===============================================================================
		DataGrid Related Function Begins here
		===============================================================================*/
		
		private function getChildForGenieID(genieID:String):Object
		{
			
			var arrUserArgs:Array = new Array();
			var obj:Object = null;
			var child:Object = null;
			var strTrimmedGenieId:String = genieID;
			//Split for user args
			if(genieID.indexOf("$") > -1)
			{
				var arrTempSplit:Array = new Array();
				arrTempSplit = genieID.split("$");
				arrUserArgs = arrTempSplit[1].toString().split(",");
				genieID = arrTempSplit[0];
			}
			
			if(objectArray[genieID] != null)
			{
				obj = objectArray[genieID];
				child = obj.child;
				bFound = true;
			}
			else
			{
				var bFound:Boolean = false;
				var arrGenieID:Array = new Array();
				//First break on the basis of Iterative index(ITR) of the child
				arrGenieID = getGenieIDForITR(strTrimmedGenieId, arrUserArgs);
				if(arrGenieID != null && arrGenieID.length > 0)
				{
					for(var i:int = 0; i < arrGenieID.length; i++)
					{
						obj = arrGenieID[i];
						if(obj)
						{
							child = obj.child;
							bFound = true;
						}
					}
				}
				// If still object is not found break on the basis of the index (if present) of child
				if(!bFound)
				{
					arrGenieID = getGenieIDForIndex(strTrimmedGenieId, arrUserArgs);
					if(arrGenieID != null && arrGenieID.length > 0)
					{
						for(i = 0; i < arrGenieID.length; i++)
						{
							obj = arrGenieID[i];
							if(obj)
							{
								child = obj.child;
								bFound = true;
							}
						}
					}
				}
			}
			return child;
		}
		
		//This function is implemented basically for DisplayObjects in which properties for invisible components can be fetched.
		public function getValueOfDisplayObjects(strData:String="", strGuid:String="", from:String = ""):void
		{
			var propValue:String = null;
			var result:XML = <Output></Output>;
			result.Result = false;
			
			try
			{
				var xmlData:XML = new XML(strData);
				var genieID:String = xmlData.Input.GenieID;
				var propName:String = xmlData.Input.PropertyName;
				
				//Split for user args
				if(genieID.indexOf("$") > -1)
				{
					var arrTempSplit:Array = new Array();
					arrTempSplit = genieID.split("$");
					genieID = arrTempSplit[0];
				}
				
				var child:Object = null;
				child = objectArray[genieID].child;
				if(child == null)
				{
					result.Message = "Object not found for genie id " +  genieID ;
				}
				else
				{
					result = getValueOfInternal(child,propName);
				}
			}
			catch(e:Error)
			{
				result.Message = "Exception occurred " +  e.message.toString() ;
			}
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "getValueOf",result,"");
		}
		
		public function getValueOfObject(strData:String="", strGuid:String="", from:String = ""):void
		{
			var propValue:String = null;
			var result:XML = <Output></Output>;
			result.Result = false;
			
			try
			{
				var xmlData:XML = new XML(strData);
				var genieID:String = xmlData.Input.GenieID;
				var propName:String = xmlData.Input.PropertyName;
				
				var strTrimmedGenieId:String = genieID;
				var obj:HierarchyDictionary = new HierarchyDictionary();
				var child:Object = null;
				child = getObjectForGenieID(genieID);
				result = getValueOfInternal(child,propName,true);
				if(child == null)
				{
					result.Message = "Object not found for genie id " +  genieID ;
				}
				
			}
			catch(e:Error)
			{
				objLogs.detailedTrace(GenieLogConst.ERROR, e.message.toString());
			}
			
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "getValueOf",result,"");
		}
		
		public function getValueOf(strData:String="", strGuid:String="", from:String = ""):void
		{
			var result:XML = <Output></Output>;
			result.Result = false;
			
			try
			{
				var xmlData:XML = new XML(strData);
				var genieID:String = xmlData.Input.GenieID;
				var propName:String = xmlData.Input.PropertyName;
				
				var strTrimmedGenieId:String = genieID;
				var obj:HierarchyDictionary = new HierarchyDictionary();
				var child:Object = null;
				child = getObjectForGenieID(genieID);
				result = getValueOfInternal(child,propName);
				if(child == null)
				{
					result.Message = "Object not found for genie id " +  genieID ;
				}
			}
			catch(e:Error)
			{
				objLogs.detailedTrace(GenieLogConst.ERROR, e.message.toString());
			}
			
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "getValueOf",result,"");
		}
		
		private function getValueOfInternal(child:Object, propName:String, objectType:Boolean = false):XML
		{
			var result:XML = <Output></Output>;
			var tempObj:Object = child;
			var arrayOfProps:Array = propName.split(".");
			var bFound:Boolean = false;
			try{
				for(var i:int=0; i<arrayOfProps.length ;++i)
				{
					if(tempObj!=null)
					{
						if(tempObj.hasOwnProperty(arrayOfProps[i]))
						{
							tempObj = tempObj[arrayOfProps[i]];
							bFound = true;
						}
						else
						{
							result.Result = false;
							result.Message = "Object " +  objGetGenieIdFromObject[child] +" does not have " + propName +" property";
							bFound = false;
							break;
						}
					}else
					{
						result.Result = false;
						result.Message = "Null exception while retrieving property";
						bFound = false;
						break;
					}
				}
				
				if((bFound == false) && (child != null))
				{
					if(propName == "type")
					{
						tempObj = getQualifiedClassName(child);
						bFound = true;
					}
				}
				if(bFound == true)
				{
					result.Result = true;
					if(objectType)
						result.PropertyValue = objectToXML(tempObj).toXMLString();
					else
						result.PropertyValue = tempObj.toString();
					result.Message = "";
				}
			}catch(e:Error)
			{
				objLogs.traceLog(GenieLogConst.ERROR,e.message+ ":function getValueOfInternal");
				result.Result = false;
				result.Message = e.message;
			}
			return result;
		}
		
		
		public function captureComponentImage(strData:String="", strGuid:String="", from:String = ""):void
		{
			var result:XML = <Output></Output>;
			result.Result = false;
			try
			{
				var xmlData:XML = new XML(strData);
				var genieID:String = xmlData.Input.GenieID;
				var arrUserArgs:Array = new Array();
				var strTrimmedGenieId:String = genieID;
				var obj:HierarchyDictionary = new HierarchyDictionary();
				var child:Object = null;
				
				if(genieID.indexOf("$") > -1)
				{
					var arrTempSplit:Array = new Array();
					arrTempSplit = genieID.split("$");
					arrUserArgs = arrTempSplit[1].toString().split(",");
					genieID = arrTempSplit[0];
				}
				
				if(objectArray[genieID] != null)
				{
					obj = objectArray[genieID];
					child = obj.child;
					
					result = getImageData(child);
					bFound = true;
				}
				else
				{
					var bFound:Boolean = false;
					var arrGenieID:Array = new Array();
					//First break on the basis of Iterative index(ITR) of the child
					arrGenieID = getGenieIDForITR(strTrimmedGenieId, arrUserArgs);
					if(arrGenieID != null && arrGenieID.length > 0)
					{
						for(var i:int = 0; i < arrGenieID.length; i++)
						{
							obj = arrGenieID[i];
							if(obj)
							{
								child = obj.child;
								result = getImageData(child);
								bFound = true;
							}
						}
					}
					// If still object is not found break on the basis of the index (if present) of child
					if(!bFound)
					{
						arrGenieID = getGenieIDForIndex(strTrimmedGenieId, arrUserArgs);
						if(arrGenieID != null && arrGenieID.length > 0)
						{
							for(i = 0; i < arrGenieID.length; i++)
							{
								obj = arrGenieID[i];
								if(obj)
								{
									child = obj.child;
									result = getImageData(child);
									bFound = true;
								}
							}
						}
					}
					if(!bFound)
					{
						result.Message = "Object not found for genie id " +  genieID ;
						result.Result = false;
					}
				}
			}
			catch(e:Error)
			{
				result.Result = false;
				result.Message = e.message.toString();
				objLogs.detailedTrace(GenieLogConst.ERROR, e.message.toString());
			}
			
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "captureComponentImage",result,"");
		}
		
		public function captureApplicationImage(strData:String="", strGuid:String="", from:String = ""):void
		{
			try
			{
				var result:XML = <Output></Output>;
				var className:String = getQualifiedClassName(rootObject);
				var objTemp:Object = new Object();
				var objApplication:Object = null;
				
				if(className == "flash.display::Stage")
				{
					objTemp = rootObject.getChildAt(0);
					
					if(objTemp != null)
					{
						if(getQualifiedClassName(objTemp).toLowerCase().indexOf("systemmanager") == -1)
							objApplication = objTemp;
						else
						{
							objApplication = objTemp;
							objTemp = objApplication.getChildAt(0);
							if(getQualifiedClassName(objTemp).toLowerCase().indexOf("systemmanager") == -1)
								objApplication = objTemp;
							else
							{
								result.Message = "Unable to fetch application object from stage.";
								result.Result = false;
							}
						}
					}
					else
					{
						result.Message = "Unable to fetch application object from stage.";
						result.Result = false;
					}
				}
				else
				{
					if(className.toLowerCase().indexOf("systemmanager") > -1)
						objApplication = rootObject.getChildAt(0);
					else
					{
						result.Message = "Unable to fetch application object.";
						result.Result = false;
					}
				}
				
				if(objApplication != null)
				{
					result = getImageData(objApplication);
				}
				else
				{
					result.Message = "Fetched application object is null, hence cannot capture image.";
					result.Result = false;
				}
			}
			catch(e:Error)
			{
				result.Result = false;
				result.Message = e.message.toString();
				objLogs.detailedTrace(GenieLogConst.ERROR, e.message.toString());
			}
			
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "captureComponentImage",result,"");
		}
		
		
		private function getImageData(object:Object):XML
		{
			var componentBinaryData:String = "";
			var result:XML = <Output></Output>;
			try
			{
				var pngEnc:PNGEncoder = new PNGEncoder();
				var componentName:IBitmapDrawable = object as IBitmapDrawable;
				var imageSnapshot:ImageSnapshot = ImageSnapshot.captureImage(componentName, 0, pngEnc);
				componentBinaryData = ImageSnapshot.encodeImageAsBase64(imageSnapshot);
				result.Result = true;
			}
			catch(e:Error)
			{
				result.Result = false;
				componentBinaryData = "Unable to create bitmap image of a component due to zero height and width of component";
				objLogs.detailedTrace(GenieLogConst.ERROR, e.message.toString());
			}
			result.Message = componentBinaryData;
			
			return result;
		}
		
		public function getFocusStatus(strData:String="", strGuid:String="", from:String = ""):void
		{
			var propValue:String = null;
			var result:XML = <Output></Output>;
			result.Result = false;
			
			try
			{
				var xmlData:XML = new XML(strData);
				var genieID:String = xmlData.Input.GenieID;
				if(objectArray[genieID] != null)
				{
					var obj:HierarchyDictionary = objectArray[genieID];
					var dg:Object = obj.child;
					var delegate:Object = Automation.getDelegate(dg);
					result.Result = delegate.checkFocus();
					result.Message = "";
				}
				else
				{
					result.Result = false;
					result.Message = "Object not found for genie id " +  genieID ;
				}
			}
			catch(e:Error)
			{
				result.Result = false;
				result.Message = "Either object is not text box or error occurred while fetching the focus property";
				objLogs.detailedTrace(GenieLogConst.ERROR, e.message.toString());
			}
			
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "getFocusStatus",result,"");						
		}
		
		public function existsOnStage(strGenieID:String, strGuid:String="", from:String = ""):void
		{
			var found:Boolean = false;
			
			if(strGenieID.indexOf("$") > -1)
			{
				var arrTempSplit:Array = new Array();
				arrTempSplit = strGenieID.split("$");
				strGenieID = arrTempSplit[0];
			}
			
			if(objectArray[strGenieID] != null)
			{
				var glowHierarchy:HierarchyDictionary = new HierarchyDictionary();
				glowHierarchy = objectArray[strGenieID];
				
				var obj:Object = glowHierarchy.child;
				if(obj)
					found = true;
				else
					found = false;
			}
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "existsOnStage",found.toString(),"");
		}
		
		public function exists(strGenieID:String, strGuid:String="", from:String = ""):void
		{
			var found:Boolean = false;
			
			if(strGenieID.indexOf("$") > -1)
			{
				var arrTempSplit:Array = new Array();
				arrTempSplit = strGenieID.split("$");
				strGenieID = arrTempSplit[0];
			}
			
			if(objectArray[strGenieID] != null)
			{
				var glowHierarchy:HierarchyDictionary = new HierarchyDictionary();
				glowHierarchy = objectArray[strGenieID];
				
				var obj:Object = glowHierarchy.child;
				if(Automation.automationManager.isVisible(obj as DisplayObject))
				{
					if(getQualifiedClassName(obj) == "flash.display::NativeMenu")
					{
						found = true;
					}
					else
					{
						if(obj.hasOwnProperty("visible"))
						{
							if(obj.visible == true)
							{
								found = true;
							}
						}
						else
						{
							found = false;
						}
					}
				}
			}
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "exists",found.toString(),"");
		}
		
		/*===============================================================================
		DataGrid Related Function Ends here
		===============================================================================*/	
		
		/*===============================================================================
		UI Related Function Begins here
		===============================================================================*/		
		public function disableRecordingUIActions(strGuid:String="", from:String = ""):void
		{
			try{
				bRecordUIEvents = false;
				if(from.length == 0)
					from = GenieMix.EXECUTOR_NAME_STR; 
				objCom.sendCommandWithId(from , strGuid, "disableRecordingUIActions","true","");
			}catch(e:Error){}
		}
		
		public function enableRecordingUIActions(strGuid:String="", from:String = ""):void
		{
			try{
				bRecordUIEvents = true;
				if(from.length == 0)
					from = GenieMix.EXECUTOR_NAME_STR; 
				objCom.sendCommandWithId(from, strGuid, "enableRecordingUIActions","true","");
			}catch(e:Error){}
		}	
		
		public function getLocalCoordinates(strGenieID:String, strGuid:String="", from:String = ""):void
		{
			var data:String = "";
			var p : Point = new Point(-1,-1);
			if(from.length == 0)
				from = GenieMix.EXECUTOR_NAME_STR; 
			if(objectArray[strGenieID] != null)
			{
				var child:Object = objectArray[strGenieID].child;
				p = getInternalLocalCoordinates(child);
			}
			
			data = "<x>" + p.x + "</x>" + "<y>" + p.y + "</y>";
			
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "localCoordinates",data,"");
		}
		
		public function getInternalLocalCoordinates(child:Object):Point
		{
			var p : Point = new Point(-1,-1);
			var x:Number = child.x;
			var y:Number = child.y;
			
			//deducting the local co-ordinates from X and Y once they are converted globally in order to click them corrdctly.
			if(!getAlignmentFactor(child))
			{
				try
				{
					p = child.contentToGlobal(new Point(x,y));
				}
				catch(e:Error)
				{
					p = child.localToGlobal(new Point(x,y));
				}
				
				p = new Point((p.x -x), (p.y -y));
			}
			else
			{
				try
				{
					p = child.parent.localToGlobal(new Point(x,y));
				}
				catch(e:Error)
				{
					p = child.localToGlobal(new Point(x,y));
				}
			}
			
			return p;
		}
		
		
		private function getAlignmentFactor(child:Object):Boolean
		{
			var bAlignment:Boolean = false;
			var objAlign:Object = null;
			objAlign = child;
			while(!bAlignment)
			{
				if(objAlign.hasOwnProperty("alignment") && objAlign.alignment)
				{
					if(objAlign.alignment == "C")
						bAlignment = true;
				}
				if(objAlign.hasOwnProperty("parent") && objAlign.parent)
					objAlign = objAlign.parent;
				else
					break;
			}
			return bAlignment;
		}
		
		public function getRelativeCoordinates(strData:String="", strGuid:String="", from:String = ""):void
		{
			var result:XML = <Output></Output>;
			result.Result = false;
			
			try
			{
				var xmlData:XML = new XML(strData);
				var genieID:String = xmlData.Input.GenieID;
				var parentGenieId:String = xmlData.Input.PropertyName;
				
				var strTrimmedGenieId:String = genieID;
				var obj:HierarchyDictionary = new HierarchyDictionary();
				var child:Object = null;
				var parent:Object = null;
				var pLocal:Point = new Point(0,0);
				if(objectArray[genieID] != null)
					child = objectArray[genieID].child;
				else
					result.message = "Object not found for genie id " +  genieID ;
				
				pLocal = getInternalLocalCoordinates(child);
				
				parent = objectArray[parentGenieId].child;
				
				var p:Point = new Point(0,0);
				p = parent.globalToLocal(new Point(pLocal.x, pLocal.y));
				result.message = "<x>" + p.x.toString() + "</x><y>" + p.y.toString() + "</y>";
			}
			catch(e:Error)
			{
				objLogs.detailedTrace(GenieLogConst.ERROR, e.message.toString());
			}
			
			if(from.length > 0)
				objCom.sendCommandWithId(from,strGuid, "getRelativeCoordinates",result,"");
		}
		
		protected function enterMouseMove(e:MouseEvent):void
		{
			//convert decimal x,y coordinates to int
			var x:int = e.stageX
			var y:int = e.stageY;
			GenieMix.gnDisplay.updateCoordinatesLabel(x , y);
		}
		
		public function hideGenieIcon(strGuid:String="", from:String = ""):void
		{
			if(from.length == 0)
				from = GenieMix.EXECUTOR_NAME_STR; 
			try{
				GenieMix.gnDisplay.hideGenieIcon();
				objCom.sendCommandWithId(from , strGuid, "temp","true","");
			}catch(e:Error){}
		}
		
		public function showGenieIcon(strGuid:String="", from:String = ""):void
		{
			try{
				if(from.length == 0)
					from = GenieMix.EXECUTOR_NAME_STR; 
				
				GenieMix.gnDisplay.showIcon();
				objCom.sendCommandWithId(from , strGuid, "temp","true","");
			}catch(e:Error){}
		}
		
		
		public function enableUIActions(strGuid:String="", from:String = ""):void
		{
			try{
				if(from.length == 0)
					from = GenieMix.EXECUTOR_NAME_STR; 
				GenieMix.gnDisplay.enableUIIcon();
				objCom.sendCommandWithId(from , strGuid, "temp","true","");
			}catch(e:Error){}
		}
		
		public function disableUIActions(strGuid:String="", from:String = ""):void
		{
			if(from.length == 0)
				from = GenieMix.EXECUTOR_NAME_STR; 
			try
			{
				GenieMix.gnDisplay.disableUIIcon();
				objCom.sendCommandWithId(from , strGuid, "temp","true","");
			}
			catch(e:Error)
			{}
		}
		public function showPlayIcon(strGuid:String="", from:String = ""):void
		{
			try{
				if(from.length == 0)
					from = GenieMix.EXECUTOR_NAME_STR;
				
				//Added check, Do not enable play icon if it is alreday enabled.
				if(from == GenieMix.EXECUTOR_NAME_STR && GenieMix.gnDisplay.currentState != "Playing")
				{
					GenieMix.gnDisplay.enablePlayIcon();
				}
				objCom.sendCommandWithId(from , strGuid, "temp","true","");
			}catch(e:Error){}
		}
		
		public function hidePlayIcon(strGuid:String="", from:String = ""):void
		{
			if(from.length == 0)
				from = GenieMix.EXECUTOR_NAME_STR; 
			try{
				GenieMix.gnDisplay.disablePlayIcon();
				objCom.sendCommandWithId(from , strGuid, "temp","true","");
			}catch(e:Error){}
		}
		
		public function enableShowCoordinates(strGuid:String="", from:String = ""):void
		{ 
			try
			{
				try
				{
					GenieMix.currentMainSprite.stage.addEventListener(MouseEvent.MOUSE_MOVE , enterMouseMove, true, EventPriority.DEFAULT+1, true);
					GenieMix.currentMainSprite.addEventListener(MouseEvent.MOUSE_MOVE , enterMouseMove, true, EventPriority.DEFAULT+1, true);
				}
				catch(e:Error)
				{
					GenieMix.currentMainSprite.addEventListener(MouseEvent.MOUSE_MOVE , enterMouseMove);
				}
				GenieMix.gnDisplay.addCoordinatesLabel();
			}catch(e:Error){}
			
		}
		public function getGenieProperties(argGenieID:String, strGuid:String="" , from:String = ""):void//XML
		{
			try{
				var propValPairXml:String = "<Result>";
				var tmpHierarchy:HierarchyDictionary = new HierarchyDictionary();
				tmpHierarchy = objectArray[argGenieID];
				if (tmpHierarchy == null)
				{
					propValPairXml += "</Result>";
					if (strGuid == "")
					{
						objCom.sendCommand(from, "gotGenieObjectProperties", "","");
					}
					else
						objCom.sendCommandWithId(from,strGuid, "temp", propValPairXml,"");
					return;
				}
				var object:Object = tmpHierarchy.child;
				var objectInfo:XML = describeType(object);
				
				try
				{
					var typeStr:String = objectInfo.@name;
					if (typeStr == null)
					{
						typeStr = "";
					}
					propValPairXml += "<accessor property=\"type\" value=\"" + typeStr + "\" />";
				}catch(e:Error)
				{}
				
				//parse properties
				for each (var a:XML in objectInfo..accessor) 
				{
					if(a.@access != 'writeonly')
					{
						var prop:String = a.@name;
						var value:String = "";
						try{
							value = object[prop];
							value = GenieMix.getCleanStringForXML(value);
							value = GenieMix.getHidedQuotesFromString(value);
							
						}catch(e:Error)
						{
							value = "";
						}
						
						propValPairXml += "<accessor property=\"" + prop + "\" value=\"" + value + "\" />";
					}
				}
				//Also add public variables to the array
				for each (a in objectInfo..variable) 
				{
					if(a.@access != 'writeonly')
					{
						prop = a.@name;
						value = "";
						try{
							value = object[prop];
							value = GenieMix.getCleanStringForXML(value);
							value = GenieMix.getHidedQuotesFromString(value);
							
						}catch(e:Error)
						{
							value = "";
						}
						
						propValPairXml += "<accessor property=\"" + prop + "\" value=\"" + value + "\" />";
					}
				}
				propValPairXml += "</Result>";
				
				if (strGuid == "")
				{
					propValPairXml = "<GenieId>" + argGenieID +"</GenieId>" + propValPairXml;
					objCom.sendCommand(from, "gotGenieObjectProperties", propValPairXml,"");
				}
				else
					objCom.sendCommandWithId(from,strGuid, "temp", propValPairXml,"");
			}catch(err:Error){
				if (strGuid == "")
				{
					objCom.sendCommand(from, "gotGenieObjectProperties", "","");
				}
				else
					objCom.sendCommandWithId(from,strGuid, "temp", "","");
			}
		}
		public function disableShowCoordinates(strGuid:String="", from:String = ""):void
		{
			try{
				GenieMix.currentMainSprite.removeEventListener(MouseEvent.MOUSE_MOVE , enterMouseMove);
				GenieMix.gnDisplay.removeCoordinatesLabel();
			}catch(e:Error){}
		}		
		
		public function switchOffColorCorrection():void
		{
			try{
				previousColorCorrection = rootObject.colorCorrection; 
				rootObject.colorCorrection = ColorCorrection.OFF;
			}catch(e:Error){}
		}
		
		public function setPreviousColorCorrection():void
		{
			try{
				rootObject.colorCorrection = previousColorCorrection;
			}catch(e:Error){}
		}
		
		/*===============================================================================
		UI Related Function ends here
		===============================================================================*/
	}
}
