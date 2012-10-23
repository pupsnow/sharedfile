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

/**
 * Provides the classes necessary for invoking system level UI events on 
 * Flex/Flash components in the target SWF application. 
 * These Operations require the component to be visible in Screen Area
 * <p>
 * The UI Event framework consists of following entities:
 * <ul> 
 * <li> Mouse UI Events based on coordinate w.r.t starting position of component whose Genie-ID is specified as parameter </li>
 * <li> Mouse UI Events based on coordinate w.r.t starting position of SWF file</li>
 * <li> Mouse UI Events based on coordinate w.r.t starting position of Screen</li>
 * <li> Mouse UI Events based on image</li>
 * <li> Keyboard based UI events on the current component in Focus</li>
 * </ul>
 * <p>
 * The classes which provide methods with respect to starting position of component (or SWF) calculate the actual position of 
 * Object on Run time and are lot more reliable then one which are based on screen coordinates. These usually will not change
 * with screen resolution or with component reflow or on different platforms 
 * <p>
 * 
 * @since Genie 0.5
 * 
 * New Addition to these set of classes is enablement of UI actions on devices. Some new classes have been introduced that
 * work only on devices and some classes become common for both Desktop and device
 * <p>
 * The new set of classes for device only workflow primarily contains 
 * <ul> 
 * <li> Mouse UI Events based on coordinate w.r.t starting position of Screen</li>
 * <li> Mouse UI Events based on image</li>
 * <li> Keyboard based UI events on the current component in Focus</li>
 * </ul>
 * <p>
 * Classes which are now acting as common interface for both device and desktop workflows consist of
 * <ul> 
 * <li> Mouse UI Events based on coordinate w.r.t starting position of component whose Genie-ID is specified as parameter </li>
 * <li> Mouse UI Events based on coordinate w.r.t starting position of SWF file</li>
 * </ul>
 * 
 * @since Genie 1.1
 */

package com.adobe.genie.executor.uiEvents;
