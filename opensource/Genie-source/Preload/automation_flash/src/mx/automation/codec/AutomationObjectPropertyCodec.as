//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================

package mx.automation.codec
{
	
	import mx.automation.AutomationClass;
	import mx.automation.AutomationIDPart;
	import mx.automation.Automation;
	import mx.automation.Genie.IGeniePropertyDescriptor;
	import mx.automation.IAutomationManager;
	import mx.automation.IAutomationObject;
	
	//[ResourceBundle("automation_agent")]
	
	/**
	 * Translates between internal Flex component and automation-friendly version
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class AutomationObjectPropertyCodec extends DefaultPropertyCodec
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function AutomationObjectPropertyCodec()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override public function encode(automationManager:IAutomationManager,
										obj:Object, 
										pd:IGeniePropertyDescriptor,
										relativeParent:Object):Object
		{
			var val:Object = getMemberFromObject(automationManager, obj, pd);
			
			var delegate:Object = val as Object;
			if (delegate)
			{
				//only use automationName
				//val = automationManager.createIDPart(delegate).automationName;
				
				//the following is if we decide to support "automationObject"'s that are not direct
				//decendents of the interaction replayer
				/*
				var id:ReproducibleID = automationManager.createID(val, 
				IAutomationObject(relativeParent));
				
				if (id.length == 0)
				return "";
				
				var nameChain:String = id.removeFirst().automationName;
				
				while (id.length)
				{
				//should escape seperator
				var an:String = id.removeFirst().automationName;
				nameChain += "^" + an;
				}
				
				val =  nameChain;
				*/
			}
			
			if (!val && !(val is int))
				val = "";
			
			return val;
		}
		
		/**
		 * @private
		 */
		override public function decode(automationManager:IAutomationManager,
										obj:Object, 
										value:Object,
										pd:IGeniePropertyDescriptor,
										relativeParent:Object):void
		{
			if (value == null || value.length == 0)
			{
				obj[pd.name] = null;
			}
			else
			{
				var aoc:Object = (relativeParent != null ? relativeParent : obj as Object);
				
				var part:AutomationIDPart = new AutomationIDPart();
				// If we have any descriptive programming element
				// in the value string use that property.
				// If it is a normal string assume it to be automationName
				var text:String = String(value);
				var separatorPos:int = text.indexOf(":=");
				var items:Array = [];
				if (separatorPos != -1)
					items = text.split(":=");
				
				if (items.length == 2)
					part[items[0]] = items[1]; 
				else
					part.automationName = text;
				
				var ao:Array = automationManager.resolveIDPart(aoc, part);
				var delegate:Object = (ao[0] as Object);
				if (delegate)
					obj[pd.name] = delegate;
				else
					obj[pd.name] = ao[0];
				
				if (ao.length > 1)
				{
					var message:String = resourceManager.getString(
						"automation_agent", "matchesMsg",[ ao.length,
							part.toString().replace(/\n/, ' ')]) + ":\n";
					
					var n:int = ao.length;
					for (var i:int = 0; i < n ; i++)
					{
						message += AutomationClass.getClassName(ao[i]) + 
							"(" + ao[i].automationName + ")\n";
					}
					
					trace(message);
				}
			}
			
			//the following is if we decide to support "automationObject"'s that are not direct
			//decendents of the interaction replayer
			/*        
			var automationNameArray:Array = automationNames.split("^");
			var rid:ReproducibleID = new ReproducibleID();
			
			while (automationNameArray.length)
			{
			rid.addFirst({automationName: automationNameArray.pop()});
			}
			
			return automationManager.resolveIDToSingleObject(rid, IAutomationObject(target));
			*/
		}
	}
	
}
