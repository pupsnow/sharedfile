//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the 
//	documentation and/or other materials provided with the distribution.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE 
//  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
//  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//========================================================================================
package com.adobe.genie.iexecutor.uiEvents;

public interface IUIKeyboard {
	 /**
	  * Releases the key referred to by the name passed in (example: VK_SHIFT), 
	  * if the key was not previously pressed (see pressKey), the result is
	  * undefined.
	  *             
      * @since Genie 0.5
	  */
	public void releaseKey(String name) throws Exception;
	 /**
	  * Presses the key referred to by the name passed in (example: VK_SHIFT), also you
	  * must release it yourself through the releaseKey or releaseAllKeys
	  * methods, or it may stay pressed at least until you log off.
	  * 	 
      * @since Genie 0.5
	  */
	public void pressKey(String name) throws Exception;
	/**
	  * Types (presses and releases) the key referred to by the name passed in
	  * (example: VK_SHIFT).
	  * 
      * @since Genie 0.5
	  */
	public void typeKey(String name) throws Exception;
	/**
	 * Releases all previously pressed keys.
	 *      
     * @since Genie 0.5
	 */
	public void releaseAllKeys() throws Exception;
	   /**
	    * Types a string on the host Screen at the current mouse position.
	    * 	   
	    * @since Genie 0.5
	    */  
	public void typeText(String text) throws Exception;
	
	
	 /**
	    * Paste a string on the host Screen at the current mouse position.
	    *
	    * @param text
	    *            the string to paste
	    * 
	    * @throws Exception
	    * 
	    * @since Genie 1.2
	    */
	public void pasteText(String text) throws Exception;

	
	
	
	
	
}
