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
	import mx.automation.IAutomationManager;
	import mx.automation.IAutomationObject;
	
	/**
	 * Defines the interface for codecs, which translate between internal Flex properties 
	 * and automation-friendly ones.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public interface IAutomationPropertyCodec
	{
		/**
		 * Encodes the value into a form readable by the user.
		 * 
		 * @param automationManager The automationManager object
		 * 
		 * @param obj The object having the property which requires encoding.
		 * 
		 * @param propertyDescriptor The property descriptor object describing the 
		 * 							 property which needs to be encoded.
		 * 
		 * @param relativeParent The parent or automationParent of the component
		 * 					    recording the event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		function encode(automationManager:IAutomationManager,
						obj:Object, 
						propertyDescriptor:IGeniePropertyDescriptor,
						relativeParent:Object):Object;
		
		/**
		 * Decodes the value into a form required for the framework to do operations.
		 *  This may involve searching for some data in the dataProvider or a particualr
		 *  child of the container.
		 * 
		 * @param automationManager The automationManager object
		 * 
		 * @param obj The object having the property which needs to be 
		 * 						updated with the new value.
		 * 
		 * @param value The input value for the decoding process.
		 * 
		 * @param propertyDescriptor The property descriptor object describing the 
		 * 							 property which needs to be decoded.
		 * 
		 * @param relativeParent The parent or automationParent of the component
		 * 					    recording the event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		function decode(automationManager:IAutomationManager,
						obj:Object, 
						value:Object,
						propertyDescriptor:IGeniePropertyDescriptor,
						relativeParent:Object):void;
		
	}
	
}
