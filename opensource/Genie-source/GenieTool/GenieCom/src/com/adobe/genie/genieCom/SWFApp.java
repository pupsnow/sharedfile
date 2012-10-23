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
package com.adobe.genie.genieCom;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

import com.adobe.genie.utils.Utils;

/**
 * Class to hold SWF application properties. This Class should never be initialized directly
 * It is primarily a return object after a successful connection and should be used accordingly
 * <p>
 * The Properties gets filled up after a successful Connection and can be used in Genie Scripts
 * 
 * @since Genie 0.4
 */
public class SWFApp {
	
	
	/**
	 * String representation of name of Application.
	 * This is same name which is also available in
	 * Genie plugin which making a connection OR while using
	 * the ConnectToApp API
	 * 
	 * @since Genie 0.4
	 */
	public String name;
	
	/**
	 * This is the real Name as provide by the application
	 * <p>
	 * Please note that name can be manipulated depending on 
	 * number of instance of an application but real name will always remain
	 * same
	 * 
	 * @since Genie 0.4
	 */
	public String realName;
	
	/**
	 * The Version of Genie Preload which is currently
	 * loaded on Application under test
	 * 
	 * @since Genie 0.6
	 */
	public String genieVersion;
	
	/**
	 * The ActionScript Version using which the Application under
	 * test is compiled with
	 * 
	 * @since Genie 0.6
	 */
	public String asVersion;
	
	/**
	 * The version of Flash player on which Application 
	 * is running
	 * 
	 * @since Genie 0.4
	 */
	public String playerVersion;
	
	/**
	 * The Type of Flash player associated with this application
	 * <p>
	 * Flash Player type is a generic String returned by Player
	 * itself.
	 * <p>
	 * Possible Values are
	 * <p>
	 * Desktop, PlugIn, ActiveX, StandAlone, External
	 * 
	 * @since Genie 0.4
	 */
	public String playerType;
	
	/**
	 * The String representation of name of preload currently
	 * loaded on this application
	 * 
	 * @since Genie 1.0
	 */
	public String preloadName;
	
	/**
	 * The Version of Flex SDK using which the preload currently
	 * loaded on this application is compiled
	 * 
	 * @since Genie 1.0
	 */
	public String preloadSdkVersion;
	
	/**
	 * Boolean indicating if SWF is connected to Server
	 * For usage in Scripts isSwfConnected() method of this
	 * class is more reliable.
	 * 
	 * @since Genie 0.4
	 */
	public boolean isConnected;

	
	//========================================================================================
	// Constructor
	//========================================================================================

	/**
	 * Default Constructor, No Parameters Required
	 */
	public SWFApp(){}

	//========================================================================================
	// Some public exposed methods used here
	//========================================================================================

	/**
	 * Gets the Application XML for SWF to be connected
	 * <p>
	 * <font color="#FF0000"> This method is for internal use only.
	 * Wrong usage may lead to inconsistencies. To connect an application 
	 * use the GenieScript ConnectToApp method</font>
	 * 
	 * @return 
	 * 			The XML representation of Application Object as String
	 * 
	 * @see com.adobe.genie.executor.GenieScript#connectToApp(String)
	 * 
	 * @since Genie 0.4
	 */
	public String connect(){
		isConnected = true;
		return SynchronizedSocket.getInstance().getAppXML(name);
	}
	
	/**
	 * Checks is the SWF represented by SWFApp object is currently connected
	 * 
	 * @return
	 * 		Boolean value indicating the result. True if connected else False
	 * 
	 * @since Genie 0.11
	 */
	public boolean isSwfConnected()
	{
		SWFList<SWFApp> swfList = SynchronizedSocket.getInstance().getSWFList();
		
		SWFApp app = swfList.getSWF(name);
		if (app != null)
			return true;
		return false;
		//SWFAppUI app = (SWFAppUI) list.getSWF(tabName);
	}
	
	/**
	 * Actual method which saves the XML representation of Application
	 * in a file. 
	 * <p>
	 * It is not recommended to use this method directly as it is not properly error
	 * handled. The Method exposed to users for Saving XML is in GenieScript.saveAppXml
	 * 
	 * @param filepath
	 * 	 	Complete Filepath where the XML needs to be saved
	 * 
	 * @throws Exception
	 * 
	 * @see com.adobe.genie.executor.GenieScript#saveAppXml(com.adobe.genie.genieCom.SWFApp, String)
	 * 
	 * @since Genie 0.11
	 */
	public void saveAppXml(String filepath) throws Exception
	{
		File f = new File(filepath);
		Utils.printMessageOnConsole("Saving App Xml to path: " + f.getAbsolutePath());
		
		if (f.isAbsolute())
		{
			Utils.createParentDirRecursivelyIfNotExist(f.getParentFile());
		}
		
		BufferedWriter out = new BufferedWriter(
				new OutputStreamWriter(new FileOutputStream(filepath), "UTF-8")
			);
	
		String appXmlGeneric = SynchronizedSocket.getInstance().getAppXMLGeneric(name);
		
		out.write(appXmlGeneric);
		out.newLine();
		out.flush();
		out.close();				
	}

	//========================================================================================
	// Some Private/Protected methods used here
	//========================================================================================

	/**
	 * Disconnect a SWF and send disconnect call
	 * 
	 * For Internal use Only
	 */
	protected void disconnect(){
		isConnected = false;
		SocketClient sc = SocketClient.getInstance();
		sc.disconnectSWF(name, "");
	}
}
