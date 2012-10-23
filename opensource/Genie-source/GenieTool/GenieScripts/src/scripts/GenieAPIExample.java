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

package scripts;

import com.adobe.genie.executor.Genie;
import com.adobe.genie.executor.LogConfig;
import com.adobe.genie.executor.components.GenieButton;
import com.adobe.genie.executor.components.GenieTextInput;
import com.adobe.genie.genieCom.SWFApp;

/**
 * This example shows how to invoke Genie methods without 
 * extending from GenieScript class.
 *  
 */

public class GenieAPIExample {

	//Main method
	public static void main(String[] args) {
		//Instantiate LogConfig class.
		LogConfig l = new LogConfig();
		//Set log folder
		l.setLogFolder("C\\GenieLogs\\");
		//Create a Genie class object.
		Genie g = null;
		try{
		
			Genie.EXIT_ON_FAILURE = true;
			//Initialize Genie class.
			g = Genie.init(l);
			
			//connect to app
			SWFApp app1=g.connectToApp("Kuler");
			
			//sign in to kuler
			(new GenieButton("ID^container::ITR^0:::ID^signInCancelBtn::ITR^0",app1)).click();

			//Type your user name below
			(new GenieTextInput("CN^KVBox::IX^0::ITR^0:::ID^userNameTxt::ITR^0",app1)).selectText(0,0);
			(new GenieTextInput("CN^KVBox::IX^0::ITR^0:::ID^userNameTxt::ITR^0",app1)).input("username@gmail.com"); //Replace with your user name
			
			//Type your password
			(new GenieTextInput("CN^KVBox::IX^0::ITR^0:::ID^passwordTxt::ITR^0",app1)).selectText(0,0);
			(new GenieTextInput("CN^KVBox::IX^0::ITR^0:::ID^passwordTxt::ITR^0",app1)).input("XXXXXXXX"); //Replaec with your password

			(new GenieButton("CN^KHBox::IX^5::ITR^0:::ID^goBtn::ITR^0",app1)).click();
			
			
		}catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		finally
		{
			//Invoke stop() method to perform clean up steps. 
			// If stop() does not run then socket connections do not close and JVM does not exit.
			g.stop();
		}

	}
}
