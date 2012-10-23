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
	import flash.events.Event;
	
	import gn.adobe.genie.GenieAdapter;
	
	import mx.automation.AutomationMethodDescriptor;
	import mx.automation.Genie.GeniePropertyDescriptor;
	import mx.core.mx_internal;

	use namespace mx_internal;
	
	public class GenieMethodDescriptor extends AutomationMethodDescriptor implements IGenieAutomationDescriptor
	{
		private var _return:GeniePropertyDescriptor;
		private var _codecName:String;
		
		public function GenieMethodDescriptor(name:String, asMethodName:String, returnType:GeniePropertyDescriptor, 
											  codecName:String, args:Array)
		{
			super(name, asMethodName, returnType.type, args);
			_codecName = codecName;
			_return = returnType;
		}
		

		public function get codecName():String
		{
			return _codecName;
		}
		
		override public function record(target:Object, event:Event):Array
		{
			// Unsupported to record a method.
			throw new Error();
			return null;
		}
		
		/**
		 *
		 */
		override public function replay(target:Object, args:Array):Object
		{
			var delegate:Object = target;
			var argDescriptors:Array = getArgDescriptors(delegate);
			var asArgs:Object = {};
			
			var helper:GenieAdapter = GenieMix.getGenieAdapter();
			helper.decodeProperties(asArgs, args, argDescriptors, delegate);
			
			// Convert args into an ordered array.
			var asArgsOrdered:Array = [];
			for (var argNo:int = 0; argNo < argDescriptors.length; ++argNo)
				asArgsOrdered.push(asArgs[argDescriptors[argNo].name]);
			
			var retVal:Object = super.replay(target, asArgsOrdered);
			
			return helper.encodeValue(retVal, returnType, _codecName, delegate);
		}
		
		public function get returnDescriptor():GeniePropertyDescriptor {
			return _return;
		}
	}
}