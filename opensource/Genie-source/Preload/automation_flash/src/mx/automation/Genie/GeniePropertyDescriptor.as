//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================

package mx.automation.Genie
{
	import mx.automation.AutomationPropertyDescriptor;
	import mx.core.mx_internal;

	use namespace mx_internal;
	public class GeniePropertyDescriptor extends AutomationPropertyDescriptor implements IGeniePropertyDescriptor
	{
		private var _type:String;
		private var _codecName:String;
		private var _enums:Array;
		private var _description:String;
		
		public function GeniePropertyDescriptor(name:String, forDescription:Boolean, forVerification:Boolean, 
												type:String, codecName:String, defaultValue:String=null, 
												enums:Array=null, description:String=null)
		{
			super(name, forDescription, forVerification, defaultValue);
			this._type = type;
			this._codecName = codecName;
			this._enums = enums;
			this._description = description;
		}
		
		public function get type():String {
			return _type;
		}
		
		public function get codecName():String {
			return _codecName;
		}	
		
		public function get enums():Array {
			return _enums;
		}
		
		public function get description():String {
			return _description;
		}
	}
}