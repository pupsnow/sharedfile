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

import java.net.ServerSocket;
import java.net.SocketException;

import com.adobe.genie.utils.Utils;
import com.adobe.genie.utils.log.LogData;

/**
 * Parser class Actually opens socket and accept client requests
 */
public class Parser {
	
	public ClientList clientList;
	private ServerSocket serverSocket;
	private LogData log;
	
	public Parser() {
		clientList = new ClientList();
		log = LogData.getInstance();
	}
	
	// Open the SocketServer on a provided port
	public void listen(int port) {
		serverSocket = null;
		try {
			/*
			 * If you want Genie Server to listen for requests from outside the local
			 * machine, remove the last argument.
			 */
			serverSocket = new ServerSocket(port, 1, null);
			Utils.printMessageOnConsole("Launching Server and opened socket for Communication.");
			log.trace(LogData.INFO, "Launching Server and opened socket for Communication.");
		} catch (Exception e) {
			Shared.displayExecptionInfo(e,"Exception occurred while starting Server... Aborting!!!");
			System.exit(1);
		}
		
		//Accept new client requests
		log.trace(LogData.INFO, "Ready for Accepting Client requests");
		while(true) {
			try {
				new Client(serverSocket.accept(), clientList);
			}
			catch(SocketException se)
			{
				Utils.printMessageOnConsole("Server Socket Closed...");
				break;								
			}
			catch(Exception e) {
				Shared.displayExecptionInfo(e,"Exception occurred while adding a client to ClientList");
			}
		}
	}
	
	//Teardown
	public void finalize() {
		try {
			serverSocket.close();
		} catch(Exception e) {
			Shared.displayExecptionInfo(e,"Exception occurred while closing down Server...");
			System.exit(-1);
		}
	}
}
