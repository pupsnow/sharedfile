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
	
	import gn.adobe.logging.GenieLog;
	import gn.adobe.logging.GenieLogConst;
	
	import mx.automation.Automation;
	import mx.automation.Genie.GeniePropertyDescriptor;
	import mx.automation.IAutomationClass;
	import mx.automation.IAutomationEnvironment;
	import mx.automation.IAutomationEventDescriptor;
	import mx.automation.IAutomationManager;
	import mx.automation.codec.AutomationObjectPropertyCodec;
	import mx.automation.codec.DefaultPropertyCodec;
	import mx.automation.codec.IAutomationPropertyCodec;
	import mx.automation.codec.KeyCodePropertyCodec;
	import mx.automation.codec.KeyModifierPropertyCodec;
	import mx.automation.codec.RendererPropertyCodec;
	import mx.automation.codec.TriggerEventPropertyCodec;
	import mx.automation.events.AutomationRecordEvent;
	import mx.core.mx_internal;

	use namespace mx_internal;
	[ResourceBundle("automation_agent")]
	
	public class GenieAdapter
	{
		private var propertyCodecMap:Object = [];
		
		public function GenieAdapter()
		{
			try
			{
				addPropertyCodec(
					"object", new DefaultPropertyCodec());
				
				addPropertyCodec(
					"keyCode", new KeyCodePropertyCodec());
				
				addPropertyCodec(
					"keyModifier", new KeyModifierPropertyCodec());
				
				addPropertyCodec(
					"automationObject", new AutomationObjectPropertyCodec());
				
				addPropertyCodec(
					"rendererObject", new RendererPropertyCodec());
			
				addPropertyCodec(
					"event", new TriggerEventPropertyCodec());
			}
			catch(e:Error)
			{
				GenieMix.genieLog.traceLog(GenieLogConst.ERROR,"Eror in GenieAdapter::" + e.message);
			}
		}
		
		private function addPropertyCodec(codecName:String, codec:IAutomationPropertyCodec):void
		{
			propertyCodecMap[codecName] = codec;
		}
		
		public function replay(target:Object, method:String, args:Array, strGuid:String, strGenieId:String):Object
		{   
			var o:Object = { result:null, error:0,id:strGuid, GenieId:strGenieId};
			try 
			{
				o.result = replayEvent(target,method,args);
			} 
			catch(e:Error) 
			{
				if(e.message.toString().indexOf("not Visible") > -1)
				{
					o.error = "COMPONENT_OF_GIVEN_GENIEID_NOT_VISIBLE";
				}
				else
				{
					if(e.message.toString().indexOf("Type Coercion failed: cannot convert") > -1)
						o.error = "Failed to playback the step due to conversion failure";
					else if(e.message.toString().indexOf("Cannot access a property or method of a null object reference") > -1)
						o.error = "Failed to playback as the passed argument was not found in the object";
					else
						o.error = e.message.toString();
				}
			}
			
			return o;
		}
		
		private function getEnvironment():IAutomationEnvironment{
			return IAutomationEnvironment(GenieMix.automationManager.automationEnvironment);
		}
		
		public function replayEvent(target:Object, eventName:String, args:Array):Object
		{
			var automationClass:IAutomationClass = getEnvironment().getAutomationClassByInstance(target);
			
			var message:String;
			
			// try to find the automation class
			if (!automationClass)
			{
				//KeyBoardSupport
				if(eventName.indexOf("AtLocation") > -1 || eventName == "performKeyAction")
					automationClass = getEnvironment().getAutomationClassByName("com.adobe.genie::DisplayObject");
				
				if (!automationClass && Automation.getDelegate(target).toString().indexOf("GenericAutomationImpl") > -1)
					automationClass = getEnvironment().getAutomationClassByName("com.adobe.genie::DisplayObject");
				else
					GenieLog.getInstance().detailedTrace(GenieLogConst.ERROR , "Automation class not found in replay event");
			}
			else
			{
				if(eventName.indexOf("AtLocation") > -1)
				{
					automationClass = getEnvironment().getAutomationClassByName("com.adobe.genie::DisplayObject");
				}
				if (!automationClass)
					GenieLog.getInstance().detailedTrace(GenieLogConst.ERROR , "Automation class not found in replay event");
			}
			
			var objectClass:String = "";
			if(automationClass.name.indexOf("Flex") > -1)
			{
				objectClass = "mx";
			}
			else if(automationClass.name.indexOf("Flash") > -1)
			{
				objectClass = "fl";
			}else
			{
				objectClass = "spark";
			}
			
			var eventDescriptor:IAutomationEventDescriptor = automationClass.getDescriptorForEventByName(eventName, objectClass);
			
			if (!eventDescriptor)
			{
				eventDescriptor = automationClass.getDescriptorForEventName(eventName);
			}
			
			//var retValue:Object = eventDescriptor.replay(target, args, scarf, mouseCoords, cont);
			var retValue:Object = eventDescriptor.replay(target, args);
			//trace("This Should NEVER be used");
			return {value:retValue, type:null};
		}
		
		public function encodeProperties(obj:Object,
										 propertyDescriptors:Array,
										 interactionReplayer:Object):Array
		{
			var result:Array = [];
			var consecutiveDefaultValueCount:Number = 0;
			for (var i:int = 0; i < propertyDescriptors.length; i++)
			{
				var val:Object = getPropertyValue(obj, 
					propertyDescriptors[i],
					interactionReplayer);
				
				var isDefaultValueNull:Boolean = propertyDescriptors[i].defaultValue == "null";
				
				consecutiveDefaultValueCount = (!(val == null && isDefaultValueNull) &&
					(propertyDescriptors[i].defaultValue == null || 
						val == null ||
						propertyDescriptors[i].defaultValue != val.toString())
					? 0
					: consecutiveDefaultValueCount + 1);
				if(val != null)
				result.push(val);
			}
			
			result.splice(result.length - consecutiveDefaultValueCount, 
				consecutiveDefaultValueCount);
			
			return result;
		}
		
		public function decodeProperties(obj:Object, args:Array, propertyDescriptors:Array, interactionReplayer:Object):void
		{	
			for (var i:int = 0; i < propertyDescriptors.length; i++)
			{
				var value:String = null;
				if (args != null && 
					i < args.length && 
					args[i] == "null" && 
					propertyDescriptors[i].defaultValue == "null")
					args[i] = null;
				if (args != null && 
					i < args.length && 
					((args[i] != null  && args[i] != "")  || propertyDescriptors[i].defaultValue == null))
					setPropertyValue(obj, 
						args[i],
						propertyDescriptors[i],
						interactionReplayer);
				else if (propertyDescriptors[i].defaultValue != null)
					setPropertyValue(obj, 
						(propertyDescriptors[i].defaultValue == "null" 
							? null 
							: propertyDescriptors[i].defaultValue), 
						propertyDescriptors[i], 
						interactionReplayer);
				else
				{
					//Do Nothing
				} 
			}
		}
		
		public function setPropertyValue(obj:Object,  value:Object, pd:GeniePropertyDescriptor,
										 relativeParent:Object = null):void
		{
			var codec:IAutomationPropertyCodec = propertyCodecMap[pd.codecName];
			
			if (codec == null)
				codec = propertyCodecMap["object"];
			
			if (relativeParent == null)
				relativeParent = obj as Object;
			
			codec.decode(GenieMix.automationManager, obj, value, pd, relativeParent);
		}
		
		public function getPropertyValue(obj:Object, 
										 pd:GeniePropertyDescriptor,
										 relativeParent:Object = null):Object
		{
			var coder:IAutomationPropertyCodec = propertyCodecMap[pd.codecName];
			
			if (coder == null)
				coder = propertyCodecMap["object"];
			
			if (relativeParent == null)
				relativeParent = obj as Object;
			
			return coder.encode(GenieMix.automationManager, obj, pd, relativeParent);
		}
		
		public function encodeValue(value:Object, testingToolType:String, codecName:String, relativeParent:Object):Object
		{
			//setup a fake descriptor and object to send to the codec
			var pd:GeniePropertyDescriptor = new GeniePropertyDescriptor("value",
					false, 
					false, 
					testingToolType, 
					codecName);
			var obj:Object = {value:value};
			return getPropertyValue(obj, pd, relativeParent);
		}
		
		public function encodeValues(obj:Object, values:Array, descriptors:Array):Array
		{
			var result:Array = [];
			for (var i:int = 0; i < values.length; ++i)
			{
				var descriptor:GeniePropertyDescriptor = descriptors[i];
				var coder:IAutomationPropertyCodec = propertyCodecMap[descriptor.codecName];
				
				if (coder == null)
					coder = propertyCodecMap["object"];
				
				var relativeParent:Object = obj;
				
				var retValue:Object = coder.encode(GenieMix.automationManager, obj, descriptor, relativeParent);
				result.push({value:retValue, descriptor:descriptor});
			}
			
			return result;
		}
	}
}