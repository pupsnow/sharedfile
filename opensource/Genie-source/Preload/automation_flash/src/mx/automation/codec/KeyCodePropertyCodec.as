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
	
	import flash.ui.Keyboard;
	import mx.automation.Genie.IGeniePropertyDescriptor;
	import mx.automation.IAutomationManager;
	import mx.automation.IAutomationObject; 
	
	/**
	 * Translates between internal Flex keyCodes and automation-friendly ones
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class KeyCodePropertyCodec extends DefaultPropertyCodec
	{
		/**
		 *  Constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */ 
		public function KeyCodePropertyCodec()
		{
			super();
			init();
		}
		
		/**
		 *  @private
		 */ 
		override public function encode(automationManager:IAutomationManager,
										obj:Object, 
										pd:IGeniePropertyDescriptor,
										relativeParent:Object):Object
		{
			var val:Object = getMemberFromObject(automationManager, obj, pd);
			
			if (val)
				val = fromKeyCode(int(val));
			
			return val;
		}
		
		/**
		 *  @private
		 */ 
		override public function decode(automationManager:IAutomationManager,
										obj:Object, 
										value:Object,
										pd:IGeniePropertyDescriptor,
										relativeParent:Object):void
		{
			if (value is String)
				obj[pd.name] = fromKeyName(String(value));
		}
		
		private static var KEY_CODE_TO_STRING:Object;
		
		/**
		 *  Documentation is not currently available.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function fromKeyName(name:String):int
		{
			if (name.length == 1)
				return name.charCodeAt(0);
			
			for (var i:Object in KEY_CODE_TO_STRING)
			{
				if (KEY_CODE_TO_STRING[i] == name)
					return uint(i);
			}
			return 0;
		}
		
		/**
		 *  Documentation is not currently available.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function fromKeyCode(code:int):String
		{
			//work around for player bug 155528
			if (code == 0)
				return "";
			return (code in KEY_CODE_TO_STRING
				? KEY_CODE_TO_STRING[code]
				: String.fromCharCode(code));
		}
		
		/**
		 *  @private
		 */ 
		private static function init():void
		{
			KEY_CODE_TO_STRING = {};
			KEY_CODE_TO_STRING[Keyboard.BACKSPACE] = "BACKSPACE";
			KEY_CODE_TO_STRING[Keyboard.CAPS_LOCK] = "CAPS_LOCK";
			KEY_CODE_TO_STRING[Keyboard.CONTROL] = "CONTROL";
			KEY_CODE_TO_STRING[Keyboard.DELETE] = "DELETE";
			KEY_CODE_TO_STRING[Keyboard.DOWN] = "DOWN";
			KEY_CODE_TO_STRING[Keyboard.END] = "END";
			KEY_CODE_TO_STRING[Keyboard.ENTER] = "ENTER";
			KEY_CODE_TO_STRING[Keyboard.ESCAPE] = "ESCAPE";
			KEY_CODE_TO_STRING[Keyboard.F1] = "F1";
			KEY_CODE_TO_STRING[Keyboard.F2] = "F2";
			KEY_CODE_TO_STRING[Keyboard.F3] = "F3";
			KEY_CODE_TO_STRING[Keyboard.F4] = "F4";
			KEY_CODE_TO_STRING[Keyboard.F5] = "F5";
			KEY_CODE_TO_STRING[Keyboard.F6] = "F6";
			KEY_CODE_TO_STRING[Keyboard.F7] = "F7";
			KEY_CODE_TO_STRING[Keyboard.F8] = "F8";
			KEY_CODE_TO_STRING[Keyboard.F9] = "F9";
			KEY_CODE_TO_STRING[Keyboard.F10] = "F10";
			KEY_CODE_TO_STRING[Keyboard.F11] = "F11";
			KEY_CODE_TO_STRING[Keyboard.F12] = "F12";
			KEY_CODE_TO_STRING[Keyboard.F13] = "F13";
			KEY_CODE_TO_STRING[Keyboard.F14] = "F14";
			KEY_CODE_TO_STRING[Keyboard.F15] = "F15";
			KEY_CODE_TO_STRING[Keyboard.HOME] = "HOME";
			KEY_CODE_TO_STRING[Keyboard.INSERT] = "INSERT";
			KEY_CODE_TO_STRING[Keyboard.LEFT] = "LEFT";
			KEY_CODE_TO_STRING[Keyboard.NUMPAD_0] = "NUMPAD_0";
			KEY_CODE_TO_STRING[Keyboard.NUMPAD_1] = "NUMPAD_1";
			KEY_CODE_TO_STRING[Keyboard.NUMPAD_2] = "NUMPAD_2";
			KEY_CODE_TO_STRING[Keyboard.NUMPAD_3] = "NUMPAD_3";
			KEY_CODE_TO_STRING[Keyboard.NUMPAD_4] = "NUMPAD_4";
			KEY_CODE_TO_STRING[Keyboard.NUMPAD_5] = "NUMPAD_5";
			KEY_CODE_TO_STRING[Keyboard.NUMPAD_6] = "NUMPAD_6";
			KEY_CODE_TO_STRING[Keyboard.NUMPAD_7] = "NUMPAD_7";
			KEY_CODE_TO_STRING[Keyboard.NUMPAD_8] = "NUMPAD_8";
			KEY_CODE_TO_STRING[Keyboard.NUMPAD_9] = "NUMPAD_9";
			KEY_CODE_TO_STRING[Keyboard.NUMPAD_ADD] = "NUMPAD_ADD";
			KEY_CODE_TO_STRING[Keyboard.NUMPAD_DECIMAL] = "NUMPAD_DECIMAL";
			KEY_CODE_TO_STRING[Keyboard.NUMPAD_DIVIDE] = "NUMPAD_DIVIDE";
			KEY_CODE_TO_STRING[Keyboard.NUMPAD_ENTER] = "NUMPAD_ENTER";
			KEY_CODE_TO_STRING[Keyboard.NUMPAD_MULTIPLY] = "NUMPAD_MULTIPLY";
			KEY_CODE_TO_STRING[Keyboard.NUMPAD_SUBTRACT] = "NUMPAD_SUBTRACT";
			KEY_CODE_TO_STRING[Keyboard.PAGE_DOWN] = "PAGE_DOWN";
			KEY_CODE_TO_STRING[Keyboard.PAGE_UP] = "PAGE_UP";
			KEY_CODE_TO_STRING[Keyboard.RIGHT] = "RIGHT";
			KEY_CODE_TO_STRING[Keyboard.SHIFT] = "SHIFT";
			KEY_CODE_TO_STRING[Keyboard.SPACE] = "SPACE";
			KEY_CODE_TO_STRING[Keyboard.TAB] = "TAB";
			KEY_CODE_TO_STRING[Keyboard.UP] = "UP";
			KEY_CODE_TO_STRING[144 /* not available in Keyboard */] = "NUM_LOCK";
		}
	}
	
}
