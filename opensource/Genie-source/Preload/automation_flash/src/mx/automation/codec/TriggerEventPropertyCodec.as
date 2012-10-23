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
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import mx.automation.Genie.IGeniePropertyDescriptor;
	import mx.automation.IAutomationManager;
	import mx.automation.IAutomationObject;
	
	/**
	 * Translates between internal Flex triggerEvent property and automation-friendly version
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class TriggerEventPropertyCodec extends DefaultPropertyCodec
	{
		public function TriggerEventPropertyCodec()
		{
			super();
		}
		
		override public function encode(automationManager:IAutomationManager,
										obj:Object, 
										propertyDescriptor:IGeniePropertyDescriptor,
										relativeParent:Object):Object
		{
			var val:Object = getMemberFromObject(automationManager, obj, propertyDescriptor);
			
			/* return (val is MouseEvent ? "mouse" :
			val is KeyboardEvent ? "keyboard" : null); */
			return (val is MouseEvent ? 1 :
				val is KeyboardEvent ? 2 : null); 
		}
		
		override public function decode(automationManager:IAutomationManager,
										obj:Object, 
										value:Object,
										propertyDescriptor:IGeniePropertyDescriptor,
										relativeParent:Object):void
		{
			obj[propertyDescriptor.name] = 
				(value == 1 ? new MouseEvent(MouseEvent.CLICK) :
					value == 2 ? new KeyboardEvent(KeyboardEvent.KEY_UP) : null);
		}
	}
	
}
