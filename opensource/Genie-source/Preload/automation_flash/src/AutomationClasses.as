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

	/**
	 *  @private
	 *  In some projects, this class is used to link additional classes
	 *  into the SWC beyond those that are found by dependency analysis
	 *  starting from the classes specified in manifest.xml.
	 *  This project has no manifest file (because there are no MXML tags
	 *  corresponding to any classes in it) so all the classes linked into
	 *  the SWC are found by a dependency analysis starting from the classes
	 *  listed here.
	 */
	internal class AutomationClasses
	{
		import fl.automation.delegates.controls.FlashButtonAutomationImpl; FlashButtonAutomationImpl; 
		import fl.automation.delegates.controls.FlashBaseButtonAutomationImpl; FlashBaseButtonAutomationImpl;
		import fl.automation.delegates.controls.FlashLabelButtonAutomationImpl; FlashLabelButtonAutomationImpl;
		import fl.automation.delegates.controls.FlashTextInputAutomationImpl; FlashTextInputAutomationImpl;
		import fl.automation.delegates.controls.FlashComboBoxAutomationImpl; FlashComboBoxAutomationImpl;
		import fl.automation.delegates.controls.FlashCellRendererAutomationImpl; FlashCellRendererAutomationImpl;
		import fl.automation.delegates.controls.FlashCheckBoxAutomationImpl; FlashCheckBoxAutomationImpl;
		import fl.automation.delegates.controls.FlashRadioButtonAutomationImpl; FlashRadioButtonAutomationImpl;
		import fl.automation.delegates.controls.FlashMovieClipAutomationImpl;FlashMovieClipAutomationImpl;
		import fl.automation.delegates.controls.FlashNumericStepperAutomationImpl; FlashNumericStepperAutomationImpl;
		import fl.automation.delegates.core.FlashUIComponentAutomationImpl;FlashUIComponentAutomationImpl;
		
		
		import mx.automation.delegates.containers.AccordionAutomationImpl; AccordionAutomationImpl;
		import mx.automation.delegates.containers.ApplicationAutomationImpl; ApplicationAutomationImpl;
		import mx.automation.delegates.containers.BoxAutomationImpl; BoxAutomationImpl;
		import mx.automation.delegates.containers.CanvasAutomationImpl; CanvasAutomationImpl;
		import mx.automation.delegates.containers.DividedBoxAutomationImpl; DividedBoxAutomationImpl;
		import mx.automation.delegates.containers.FormAutomationImpl; FormAutomationImpl;
		import mx.automation.delegates.containers.FormItemAutomationImpl; FormItemAutomationImpl;
		import mx.automation.delegates.containers.PanelAutomationImpl; PanelAutomationImpl;
		import mx.automation.delegates.containers.TabNavigatorAutomationImpl; TabNavigatorAutomationImpl;
		import mx.automation.delegates.containers.ViewStackAutomationImpl; ViewStackAutomationImpl;
		
		
		import mx.automation.delegates.controls.ButtonAutomationImpl; ButtonAutomationImpl;
		import mx.automation.delegates.controls.CheckBoxAutomationImpl; CheckBoxAutomationImpl;
		import mx.automation.delegates.controls.RadioButtonAutomationImpl; RadioButtonAutomationImpl;
		import mx.automation.delegates.controls.TextAreaAutomationImpl; TextAreaAutomationImpl;
		import mx.automation.delegates.controls.TextInputAutomationImpl;TextInputAutomationImpl;
		import mx.automation.delegates.controls.ToolTipAutomationImpl; ToolTipAutomationImpl;
		
		import mx.automation.delegates.core.ContainerAutomationImpl; ContainerAutomationImpl;
		import mx.automation.delegates.core.UIComponentAutomationImpl; UIComponentAutomationImpl; 
		import mx.automation.delegates.core.UITextFieldAutomationImpl; UITextFieldAutomationImpl;
		
		import mx.automation.delegates.flashflexkit.FlexContentHolderAutomationImpl; FlexContentHolderAutomationImpl;
		import mx.automation.delegates.flashflexkit.UIMovieClipAutomationImpl; UIMovieClipAutomationImpl;
		
		import mx.automation.delegates.TextFieldAutomationHelper; TextFieldAutomationHelper;
		
		import mx.automation.codec.AutomationObjectPropertyCodec;
		import mx.automation.codec.DefaultPropertyCodec;
		import mx.automation.codec.IAutomationPropertyCodec;
		import mx.automation.codec.KeyCodePropertyCodec;
		import mx.automation.codec.KeyModifierPropertyCodec;
		import mx.automation.codec.RendererPropertyCodec;
		import mx.automation.codec.TriggerEventPropertyCodec;
		
		import mx.automation.events.AutomationEvent;
		import mx.automation.events.AutomationRecordEvent;
		import mx.automation.events.AutomationReplayEvent;
		import mx.automation.events.EventDetails;
		import mx.automation.events.ListItemSelectEvent;
		import mx.automation.events.MarshalledAutomationEvent;
		import mx.automation.events.TextSelectionEvent;
	}
}
