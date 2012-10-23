//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================

package
{
	import fl.automation.delegates.controls.FlashBaseButtonAutomationImpl;
	import fl.automation.delegates.controls.FlashButtonAutomationImpl;
	import fl.automation.delegates.controls.FlashCellRendererAutomationImpl;
	import fl.automation.delegates.controls.FlashCheckBoxAutomationImpl;
	import fl.automation.delegates.controls.FlashComboBoxAutomationImpl;
	import fl.automation.delegates.controls.FlashLabelButtonAutomationImpl;
	import fl.automation.delegates.controls.FlashMovieClipAutomationImpl;
	import fl.automation.delegates.controls.FlashNumericStepperAutomationImpl;
	import fl.automation.delegates.controls.FlashRadioButtonAutomationImpl;
	import fl.automation.delegates.controls.FlashTextInputAutomationImpl;
	
	import flash.net.XMLSocket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import gn.adobe.com.GenieCom;
	import gn.adobe.com.IGenieCom;
	import gn.adobe.genie.ArraySocketClass;
	import gn.adobe.genie.CommandsMain;
	import gn.adobe.genie.GamesGenieIDFunctions;
	import gn.adobe.genie.GenericAutomationImpl;
	import gn.adobe.genie.GenieAdapter;
	import gn.adobe.genie.GenieEnvironment;
	import gn.adobe.genie.LoadCustomContent;
	import gn.adobe.logging.GenieLog;
	import gn.adobe.logging.GenieLogConst;
	import gn.adobe.logging.IGenieLog;
	
	import mx.automation.Automation;
	import mx.automation.AutomationManager;
	import mx.automation.IAutomationClass;
	import mx.automation.IAutomationEnvironment;
	import mx.automation.IAutomationManager;
	import mx.automation.IAutomationManager2;
	import mx.automation.delegates.TextFieldAutomationHelper;
	import mx.automation.delegates.containers.AccordionAutomationImpl;
	import mx.automation.delegates.containers.ApplicationAutomationImpl;
	import mx.automation.delegates.containers.BoxAutomationImpl;
	import mx.automation.delegates.containers.CanvasAutomationImpl;
	import mx.automation.delegates.containers.DividedBoxAutomationImpl;
	import mx.automation.delegates.containers.FormAutomationImpl;
	import mx.automation.delegates.containers.FormItemAutomationImpl;
	import mx.automation.delegates.containers.PanelAutomationImpl;
	import mx.automation.delegates.containers.TabNavigatorAutomationImpl;
	import mx.automation.delegates.containers.ViewStackAutomationImpl;
	import mx.automation.delegates.controls.ButtonAutomationImpl;
	import mx.automation.delegates.controls.CheckBoxAutomationImpl;
	import mx.automation.delegates.controls.NumericStepperAutomationImpl;
	import mx.automation.delegates.controls.RadioButtonAutomationImpl;
	import mx.automation.delegates.controls.TextAreaAutomationImpl;
	import mx.automation.delegates.controls.TextInputAutomationImpl;
	import mx.automation.delegates.controls.ToolTipAutomationImpl;
	import mx.automation.delegates.core.ContainerAutomationImpl;
	import mx.automation.delegates.core.ScrollControlBaseAutomationImpl;
	import mx.automation.delegates.core.UIComponentAutomationImpl;
	import mx.automation.delegates.core.UITextFieldAutomationImpl;
	import mx.automation.delegates.flashflexkit.FlexContentHolderAutomationImpl;
	import mx.automation.delegates.flashflexkit.UIMovieClipAutomationImpl;
	import mx.collections.ArrayList;
	import mx.core.Singleton;
	import mx.flash.ContainerMovieClip;
	import mx.managers.DragManager;
	import mx.managers.ISystemManager;
	import mx.managers.SystemManager;
	import mx.managers.SystemManagerGlobals;
	import mx.utils.StringUtil;
	
	import spark.effects.animation.RepeatBehavior;
	
	public class GenieMix
	{
			
		[Embed(source="version.xml", mimeType="application/octet-stream")]
		private static var EmbeddedVersion:Class;
		[Embed(source="GenieEnv.xml", mimeType="application/octet-stream")]
		private static var GenieEnv:Class;
		private static var _genieCom:IGenieCom;
		private static var _genieLog:IGenieLog;
		private static var am:IAutomationManager;
		private static var genieAdapter:GenieAdapter;
		private static var _gnDisplay:DisplayManager;
		private static var objCommands:CommandsMain;
		private static var strVersion:String = "";
		private static var serverMinVersion:String = "";
		private static var currMainSprite:Object;
		private static var objGames:GamesGenieIDFunctions;
		
		// Constants for Genie Component plugin
		public static var PLUGIN_NAME_STR:String = "GENIE_COMPONENT_ECLIPSE_PLUGIN__64357";
		public static var EXECUTOR_NAME_STR:String = "GENIE_COMPONENT_EXECUTOR_PLAYBACK__64357";
		public static var GET_APP_XML_STR:String = "GetAppXML";
		public static var startDTForAppTree:Date = null;
		public static var endDTForAppTree:Date = null;
		public static var isPerformanceTrackingEnabled:Boolean = false;
		public static var currSocket:XMLSocket;
		public static var strApplicationName:String = "";
		public static var strASVersion:String = "";
		public static var customComponentSWFArray:ArrayList = new ArrayList();
		public static var ge:GenieEnvironment;
		public static var highPerformanceMode:Boolean = true;
		public static var subAppArray:Dictionary = new Dictionary();

		public static function init(rootObject:Object,strAppName:String):void
		{
			if(rootObject != null)
			{
				genieLog = GenieLog.getInstance(); 
				strApplicationName = strAppName;
				objCommands = new CommandsMain(rootObject, strApplicationName);		
					
				GenieCom.init();

				objGames = new GamesGenieIDFunctions(rootObject, strApplicationName);
				objCommands.objGames = objGames;
				
				var byteArray:ByteArray = new EmbeddedVersion() as ByteArray;
				var myXML:XML = new XML(byteArray.readUTFBytes(byteArray.length));
				
				serverMinVersion = myXML.child("ServerMinVersion").attribute("Value");
				strVersion = myXML.child("PreloadVersion").attribute("Value");
				
				genieAdapter = new GenieAdapter();

				var EnvByteArray:ByteArray = new GenieEnv() as ByteArray;
				var geEnv:XML = new XML(EnvByteArray.readUTFBytes(EnvByteArray.length));
				ge = new GenieEnvironment(geEnv); 
				
			}
		}
		
		public static function subsequentInitialization(rootObject:Object):void
		{
			Automation.MainApplication = rootObject;
			
			AutomationManager.init(rootObject);
			Automation.automationManager = new AutomationManager();
			am = Automation.automationManager;
			am.automationEnvironment = ge;
			
			//Call the init function of all the AutomationImpls
			callInits(rootObject);
		}
		private static function callInits(rootObject:Object):void
		{
			GenericAutomationImpl.init(rootObject);
			
			FlashLabelButtonAutomationImpl.init(rootObject);
			FlashBaseButtonAutomationImpl.init(rootObject);
			FlashButtonAutomationImpl.init(rootObject);
			FlashTextInputAutomationImpl.init(rootObject);
			FlashCellRendererAutomationImpl.init(rootObject);
			FlashComboBoxAutomationImpl.init(rootObject);
			FlashRadioButtonAutomationImpl.init(rootObject);
			FlashCheckBoxAutomationImpl.init(rootObject);
			FlashMovieClipAutomationImpl.init(rootObject);		
			FlashNumericStepperAutomationImpl.init(rootObject);
			
			Automation.extendedComponentDelegateList["flash.display::Sprite"] = GenericAutomationImpl;
			Automation.extendedComponentDelegateList["flash.display::Shape"] = GenericAutomationImpl;
			Automation.extendedComponentDelegateList["flash.display::MovieClip"] = GenericAutomationImpl;
			
			Automation.extendedComponentDelegateList["FlashButton"] = FlashButtonAutomationImpl;
			Automation.extendedComponentDelegateList["FlashLabelButton"] = FlashLabelButtonAutomationImpl;
			Automation.extendedComponentDelegateList["FlashBaseButton"] = FlashBaseButtonAutomationImpl;
			Automation.extendedComponentDelegateList["FlashTextArea"] = FlashTextInputAutomationImpl;
			Automation.extendedComponentDelegateList["FlashListLabel"] = FlashCellRendererAutomationImpl;
			Automation.extendedComponentDelegateList["FlashComboBox"] = FlashComboBoxAutomationImpl;
			Automation.extendedComponentDelegateList["FlashRadioButton"] = FlashRadioButtonAutomationImpl;
			Automation.extendedComponentDelegateList["FlashCheckBox"] = FlashCheckBoxAutomationImpl;
			Automation.extendedComponentDelegateList["fl.controls::CheckBox"] = FlashCheckBoxAutomationImpl;
			Automation.extendedComponentDelegateList["FlashMovieClip"] = FlashMovieClipAutomationImpl;
			Automation.extendedComponentDelegateList["FlashNumericStepper"] = FlashNumericStepperAutomationImpl;		
			
			Automation.extendedComponentDelegateList["FlexApplication"] = ApplicationAutomationImpl;
			Automation.extendedComponentDelegateList["FlexAccordion"] = AccordionAutomationImpl;
			Automation.extendedComponentDelegateList["FlexBox"] = BoxAutomationImpl;
			Automation.extendedComponentDelegateList["FlexButton"] = ButtonAutomationImpl;
			Automation.extendedComponentDelegateList["FlexCanvas"] = CanvasAutomationImpl;
			Automation.extendedComponentDelegateList["FlexContainer"] = ContainerAutomationImpl;
			Automation.extendedComponentDelegateList["FlexCheckBox"] = CheckBoxAutomationImpl;
			Automation.extendedComponentDelegateList["FlexDisplayObject"] = UIComponentAutomationImpl;
			Automation.extendedComponentDelegateList["FlexDividedBox"] = DividedBoxAutomationImpl;
			Automation.extendedComponentDelegateList["FlexForm"] = FormAutomationImpl;
			Automation.extendedComponentDelegateList["FlexFormItem"] = FormItemAutomationImpl;
			Automation.extendedComponentDelegateList["FlexNumericStepper"] = NumericStepperAutomationImpl;
			Automation.extendedComponentDelegateList["FlexListLabel"] = UIComponentAutomationImpl;
			Automation.extendedComponentDelegateList["FlexObject"] = UIComponentAutomationImpl;
			Automation.extendedComponentDelegateList["FlexPanel"] = PanelAutomationImpl;
			Automation.extendedComponentDelegateList["FlexTabNavigator"] = TabNavigatorAutomationImpl;
			Automation.extendedComponentDelegateList["FlexTextArea"] = TextAreaAutomationImpl;
			Automation.extendedComponentDelegateList["FlexTextArea"] = TextInputAutomationImpl;
			Automation.extendedComponentDelegateList["FlexTile"] = ContainerAutomationImpl;
			Automation.extendedComponentDelegateList["FlexTitleWindow"] = PanelAutomationImpl;
			Automation.extendedComponentDelegateList["FlexViewStack"] = ViewStackAutomationImpl;
		}
		
		public static function getASVersion():String
		{
			return strASVersion;
		}
		public static function getUniqueApplicationName(rootObject:Object):String
		{
			//Parse the rootObject and gets the application name 
			try
			{
				try
				{
					strApplicationName = rootObject.currentLabel.toString();
				}
				catch(e:Error)
				{
					strApplicationName = rootObject.currentLabel.toString();
				}
				
			}
			catch (e:Error)
			{
				strApplicationName = rootObject.toString();
			}

			if( (strApplicationName.length > 1) && (strApplicationName.indexOf("_mx_managers_SystemManager") > 1))
			{
				strApplicationName = strApplicationName.substring(1,strApplicationName.indexOf("_mx_managers_SystemManager"))
				
			}
			return strApplicationName;
		}
		
		public static function getGenieAdapter():GenieAdapter
		{
			return genieAdapter;
		}
		
		public static function getLatestVersion():String
		{
			return strVersion;
		}
		
		public static function getCurrentDTStr(dt:Date):String
		{
			return (dt.hours.toString()+":"+dt.minutes.toString()+":"+
				dt.seconds.toString());
		}
		
		public static function getHidedQuotesFromString(str:String):String
		{
			if (str == null)
				return str;
			var strReturn:String = str;
			strReturn = strReturn.split("\"").join("&quot;");
			
			return strReturn;
		}
		
		/**
		 * Converts string having characters '&', '<', '>' to make them compatible to XML
		 */ 
		public static function getCleanStringForXML(str:String):String
		{
			if (str == null)
				return str;
			var strReturn:String = str;
			strReturn = strReturn.split("&").join("&amp;");
			strReturn = strReturn.split("<").join("&lt;");
			strReturn = strReturn.split(">").join("&gt;");
			
			return strReturn;
		}
		/**
		 * Converts string having characters '&', '<', '>' to make them compatible to XML
		 */ 
		public static function getCleanXMLFromStr(str:String):String
		{
			if (str == null)
				return str;
			var strReturn:String = str;
			strReturn = strReturn.split("&amp;").join("&");
			strReturn = strReturn.split("&lt;").join("<");
			strReturn = strReturn.split("&gt;").join(">");
			
			return strReturn;
		}
		
		public static function getDateDiff():String
		{
			if ((startDTForAppTree == null) || (endDTForAppTree == null))
				return "";
			var tDiff:Date = new Date(null, null, null, null, null, null,
				endDTForAppTree.getTime() - startDTForAppTree.getTime());
						
			var diffStr:String = tDiff.hours.toString() + "H:" + tDiff.minutes.toString() + "M:" +
				tDiff.seconds.toString() + "s:" + tDiff.milliseconds.toString() + "ms";
			return diffStr;
		}
		public static function getServerMinVersion():String
		{
			return serverMinVersion;
		}
		
		public static function get genieCom():IGenieCom
		{
			return _genieCom;
		}
		
		public static function set genieCom(com:IGenieCom):void
		{
			_genieCom = com;
		}
		
		public static function get genieLog():IGenieLog
		{
			return _genieLog;
		}
		
		public static function set genieLog(log:IGenieLog):void
		{
			_genieLog = log;
		}
		
		public static function get command():CommandsMain
		{
			return objCommands;
		}
		
		public static function get gamesObject():GamesGenieIDFunctions
		{
			return objGames;
		}
		
		public static function set setcurrentMainSprite(value:Object):void
		{
			currMainSprite = value;
		}
		
		public static function set setcurrentSocket(value:XMLSocket):void
		{
			currSocket = value;
		}
		
		public static function get currentMainSprite():Object
		{
			return currMainSprite;
		}
		
		public static function get currentSocket():XMLSocket
		{
			return currSocket;
		}
		
		public static function get automationManager():IAutomationManager
		{
			if(am)
			{
				return am;
			}
			else
			{
				Automation.automationManager = new AutomationManager;
				am = Automation.automationManager;
				return am;
			}
		}
		
		public static function set gnDisplay(value:DisplayManager):void
		{
			_gnDisplay = value;
		}
		
		public static function get gnDisplay():DisplayManager
		{
			return _gnDisplay;
		}
		
		public static function get getDisplay():DisplayManager
		{
			return _gnDisplay;
		}
		
		public static function confirmConnectedToPlugin():void
		{
			var dm:DisplayManager = DisplayManager.getInstance();
			dm.bConnectedToGenieUI = true;
			dm.showRecordIcon();
		}
	}
}
