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
	import flash.events.MouseEvent;
	
	import gn.adobe.genie.GenieAdapter;
	
	import mx.automation.AutomationEventDescriptor;
	import mx.automation.events.AutomationReplayEvent;
	
	public class GenieEventDescriptor extends AutomationEventDescriptor implements IGenieAutomationDescriptor
	{
		private var _eventArgASTypesInitialized:Boolean = false;
		private var strResult:Boolean = false;
		public function GenieEventDescriptor(name:String, eventClassName:String, eventType:String, args:Array)
		{
			super(name, eventClassName, eventType, args);
		}
		
		override public function record(target:Object, event:Event):Array
		{
			var args:Array = getArgDescriptors(target);
			
			var helper:GenieAdapter = GenieMix.getGenieAdapter();
			return helper.encodeProperties(event, args, target);
		}
		
		override public function replay(target:Object, args:Array):Object {
			var event:Event = createEvent(target);
			var argDescriptors:Array = getArgDescriptors(target);
			var helper:GenieAdapter = GenieMix.getGenieAdapter();
			helper.decodeProperties(event, args, argDescriptors,target);
			
			if(event.type.toLowerCase() == "clickatlocation" && args.length == 3)
				(event as MouseEvent).delta = args[2];
			
			var riEvent:AutomationReplayEvent = new AutomationReplayEvent();
			riEvent.automationObject = target;
			riEvent.replayableEvent = event;
			replayAutomatableEvent(riEvent);
			return strResult;

		}
		
		private function replayAutomatableEvent(event:AutomationReplayEvent):Boolean{
			strResult = GenieMix.automationManager.replayAutomatableEvent(event);
			return strResult;
		}
	}
}