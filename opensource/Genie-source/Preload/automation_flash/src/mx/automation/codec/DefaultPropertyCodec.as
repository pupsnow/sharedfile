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
	
	import mx.automation.Genie.IGeniePropertyDescriptor;
	import mx.automation.Automation;
	import mx.automation.IAutomationManager;
	import mx.automation.IAutomationObject;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.styles.IStyleClient;
	
	//[ResourceBundle("automation_agent")]
	
	/**
	 * Base class for codecs, which translate between internal Flex properties 
	 * and automation-friendly ones.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class DefaultPropertyCodec implements IAutomationPropertyCodec
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DefaultPropertyCodec()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		protected var resourceManager:IResourceManager =
			ResourceManager.getInstance();
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */ 
		public function encode(automationManager:IAutomationManager,
							   obj:Object, 
							   pd:IGeniePropertyDescriptor,
							   relativeParent:Object):Object
		{
			var val:Object = getMemberFromObject(automationManager, obj, pd);			
			return getValue(automationManager, obj, val, pd);
		}
		
		/**
		 *  @private
		 */ 
		public function decode(automationManager:IAutomationManager,
							   obj:Object, 
							   value:Object,
							   pd:IGeniePropertyDescriptor,
							   relativeParent:Object):void
		{
			//Try/catch is added because with addition of capturing stageX, stageY along with other params/
			//for clickAtLocation event for Gaming world, we need to set those params along with other while playing back
			//Which throws exception because of read-only property.
			
			try
			{
				obj[pd.name] = getValue(automationManager, obj, value, pd, true);
			}
			catch(e:Error)
			{}
		}
		
		/**
		 *  @private
		 */ 
		public function getMemberFromObject(automationManager:IAutomationManager,
											obj:Object, 
											pd:IGeniePropertyDescriptor):Object
		{
			var part:Object;
			var component:Object;
			
			component = obj;
			var result:Object = null;
			
			if (part  && pd.name in part)
			{
				result = part[pd.name];
			}
			else if (pd.name in obj)
			{
				result = obj[pd.name];
			}
			else if (component != null)
			{
				if (pd.name in component)
					result = component[pd.name];
				else if (component is IStyleClient)
					result = IStyleClient(component).getStyle(pd.name);
			}
			
			return result;
		}
		
		/**
		 *  @private
		 */ 
		private function getValue(automationManager:IAutomationManager,
								  obj:Object, 
								  val:Object,
								  pd:IGeniePropertyDescriptor,
								  useASType:Boolean = false):Object
		{
			if (val == null)
				return null;
			
			var type:String = useASType && pd.asType ? pd.asType : pd.type;
			
			switch (type)
			{
				case "Boolean":
				case "boolean":
				{
					if (val is Boolean)
						return val;
					val = val ? val.toString().toLowerCase() : "false";
					return val == "true";
				}
				case "String":
				case "string":
				{
					if (val is String)
						return val;
					return val.toString();
				}
				case "int":
				case "uint":
				case "integer":
				{
					
					if (val is int || val is uint)
						return val;
					if (val is Date)
						return val.time;
					if (val is Number)
					{
						return int(val);
					}
					return parseInt(val.toString());
				}
				case "Number":
				case "decimal":
				{
					if (val is Number)
						return val;
					if (val is Date)
						return val.time;
					return parseFloat(val.toString());
				}
				case "Date":
				case "date":
				{
					if (val is Date)
						return val;
					var num:Number = Date.parse(val.toString());
					return new Date(num);
				}
				default:
				{
					return val;
				}
			}
		}
	}
	
}
