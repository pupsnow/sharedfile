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

package com.adobe.genie.genieSocketServer;

import com.adobe.genie.utils.Utils;

import sun.misc.Signal;
import sun.misc.SignalHandler;

/**
 * Handles Signal passed on Parser Object which is Server's main object
 */
public class ServerSignalHandler implements SignalHandler
{

	private SignalHandler signalHandler = null;
	private Parser serverSocket = null;
	
	public ServerSignalHandler(Parser parserObj)
	{
		serverSocket = parserObj;
	}
	
	public void install(String signalName)
	{
		Signal serverSignal = new Signal(signalName);
		this.signalHandler = Signal.handle(serverSignal, this);
	}
	
	public void handle(Signal signal)
	{
		Utils.printMessageOnConsole("Closing Genie Server...");
		try
		{
			serverSocket.finalize();
			
			// Chain back to previous handler, if one exists
            if ( signalHandler != SIG_DFL && signalHandler != SIG_IGN ) {
                signalHandler.handle(signal);
            }
		}
		catch(Exception e)
		{
			Utils.printErrorOnConsole("Exception while handling signal: " + e.getMessage());
		}
	}
}
