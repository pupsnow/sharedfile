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
package com.adobe.genie.executor;

import java.util.ArrayList;
import java.util.Arrays;

import com.adobe.genie.genieUIRobot.UIFunctions;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.executor.internalLog.ScriptLog;

/**
 * This is an Helper class which provide utility functions to enable some very common
 * tasks to be accomplished easily
 * <p>
 * All are methods provided here are static methods and to be used directly with Class name.
 * This class is not for any instantiation. Primary intention is help users provide a 
 * comprehensive set of helper methods which can be used writing a complete test script 
 * <p>
 * All these methods used basic Java calls and these tasks can also be done directly by users
 * 
 * @since Genie 0.7
 * 
 */
public class GenieHelper {
	//========================================================================================
	// Helper methods related to Navigating to an URL in the Browser
	//========================================================================================
	
	static final String[] browsers = { "google-chrome", "firefox", "opera",
	      "epiphany", "konqueror", "conkeror", "midori", "kazehakase", "mozilla" };
	static final String errMsg = "Error attempting to launch web browser";

	/**
	 * Opens the specified web page in the user's default browser
	 * 
	 * @param url 
	 * 		A web address (URL) of a web page (ex: "http://www.google.com/")
	 * 
	 * @since Genie 0.7
	 */
	public static boolean openURL(String url){
		//SCA Cleanup
		url=url.toLowerCase();		
		if (!(url.startsWith("http")||url.startsWith("https")||url.startsWith("www") || url.startsWith("ftp") || url.startsWith("file")))
			return false ;
		else{
			try {  //attempt to use Desktop library from JDK 1.6+
					Class<?> d = Class.forName("java.awt.Desktop");
					d.getDeclaredMethod("browse", new Class[] {java.net.URI.class}).invoke(
					d.getDeclaredMethod("getDesktop").invoke(null),
					new Object[] {java.net.URI.create(url)});
					return true;
					//above code mimicks:  java.awt.Desktop.getDesktop().browse()
			}
			
			catch (Exception ignore) 
			{  //library not available or failed
					
				String osName = System.getProperty("os.name");
				try {
					if (osName.startsWith("Mac OS")) 
				    {
				    	Class.forName("com.apple.eio.FileManager").getDeclaredMethod("openURL", new Class[] {String.class}).invoke(null,new Object[] {url});
				    	return true;
				    }
				    else if (osName.startsWith("Windows"))
				    {
				    	Runtime.getRuntime().exec("rundll32 url.dll,FileProtocolHandler " + url);
				    	return true;
				    }
				    else { //assume Unix or Linux
				    	String browser = null;
				    	for (String b : browsers)
				    		if (/*browser == null &&*/ Runtime.getRuntime().exec(new String[]{"which", b}).getInputStream().read() != -1)
				    		{
				    			Runtime.getRuntime().exec(new String[] {browser = b, url});
				    			return true;
				    		}
				    		if (browser == null)
				    		{
				    			throw new Exception(Arrays.toString(browsers));
				    		}
			         }
			    }
				catch (RuntimeException e) 
				{
					Utils.printErrorOnConsole("Runtime Exception occured in GenieHelper.openURL"+e.getMessage());
					return false ;
				}
				catch (Exception e) 
				{
					Utils.printErrorOnConsole(errMsg + "\n" + e.toString());
					return false ;
				}
		    }		
			return false ;
		}
	}
	
	/**
	 * Capture the Current Screenshot and store it in Scriptlog folder in JPEG format
	 * 
	 * @param fileName
	 * 		The file name of captured Screenshot. File format is JPEG and captured
	 * 	screenshot will be stored in Same location as the ScriptLog of this script
	 * 
	 * @since Genie 0.8
	 */
	public static void captureScreenShot(String fileName){
		StaticFlags sf = StaticFlags.getInstance();
		ScriptLog scriptLog = ScriptLog.getInstance();
		try {
			new UIFunctions(sf.isdebugMode()).captureScreenAsJPG(scriptLog.getLogFolderPath(), fileName);
		} catch (Exception e) {
			Utils.printErrorOnConsole("Error occurred while trying to save captured screenshot");
			if (sf.isdebugMode())
				e.printStackTrace();
			else
				Utils.printErrorOnConsole(e.getMessage());
		}
	}
	
	/**
	 * Capture the Current Screenshot and store it in specified folder in JPEG format
	 * 
	 * @param folderName
	 * 		The path of Folder where the captured Snapshot needs to be stored.
	 * 
	 * @param fileName
	 * 		The file name of captured Screenshot. File format is JPEG and captured
	 * 	screenshot will be stored in foldername specified.
	 * 
	 * @since Genie 0.8
	 */
	public static void captureScreenShot(String folderName, String fileName){
		StaticFlags sf = StaticFlags.getInstance();
		try {
			new UIFunctions(sf.isdebugMode()).captureScreenAsJPG(folderName, fileName);
		} catch (Exception e) {
			Utils.printErrorOnConsole("Error occurred while trying to save captured screenshot");
			if (sf.isdebugMode())
				e.printStackTrace();
			else
				Utils.printErrorOnConsole(e.getMessage());
		}
	}
	
	/**
	 * Returns a ArrayList<String> of passed arguments
	 * 
	 * @param args
	 * 		All the strings that needs to be bundled as ArrayList
	 * 
	 * @return
	 * 		An ArrayList comprising of all the passed arguments
	 * 
	 * @since Genie 0.8
	 */
	public static ArrayList<String> getArrayListFromStringParams(String...args)
	{
		ArrayList<String> arrayList = new ArrayList<String>();
		for(int i = 0; i<args.length; i++)
		{
			arrayList.add(args[i]);
		}
		
		return arrayList;
	}
	
	/**
	 * Executes a System Command. This is Better way to Execute a command
	 * than Runtime.getRuntime().exec method provided by Java timeout needs to 
	 * be associated with a process
	 * 
	 * @param cmd
	 * 		A String Array containing a command to execute. Please note that a single
	 * command needs to be broken up in String Array before execution.
	 * <p>
	 * Example: "ps -ax" should be passed as String Array like {"ps", "-ax"} 
	 * 
	 * @param bBlockCall
	 * 		Boolean indicating if process is launched as a Blocking call. In this case execution will not proceed
	 * till the launched process is closed (or time out happens which is specified as timeOut parameter)
	 * <p>
	 * If bBlockCall is false then process will be launched and execution will proceed further and process will keep running.
	 * Also if it is set to false then timeout has no meaning;
	 * 
	 * @param timeOut
	 * 		Timeout in miliSeconds for which the command will wait for output. If bBlockCall is set 
	 * to false then timeOut has no meaning
	 * 
	 * @return
	 * 		The result of Command Execution as String
	 * 
	 * @since Genie 1.0
	 */
	public static String executeSystemCommand(String[] cmd, boolean bBlockCall, int timeOut)
	{
		if (timeOut < 1)
			timeOut = 1;
		return Utils.executeCommand(cmd, true, timeOut,bBlockCall);
	}
	
	/**
	 * Close all instance of a process.
	 * <p>
	 * Works only on Windows and Mac. For other platforms False will be returned
	 * 
	 * @param pName
	 * 		Name of Process to close. Need not be a perfect match for a process name.
	 * Partial match will also do. Also it is NOT case sensitive 
	 * <p>
	 * Example: firefox.exe can also be passed as firefox.
	 * <p>
	 * Caution should be taken while passing substrings as all substring matched processes will be closed 
	 * 
	 * @param bForce
	 * 		Boolean indicating that whether the process should be forcefully closed
	 * 
	 * @return
	 * 		Boolean indicating if process are indeed closed
	 * 
	 * @since Genie 1.0
	 */
	public static boolean closeProcess(String pName, boolean bForce)
	{
		return Utils.closeProcess(pName, bForce);
	}
	
	/**
	 * Kills all the Java Process which are involved in executing a particular Jar
	 * <p>
	 * Since the Jars are executed through a Java Process, it is difficult to find the 
	 * exact java process which are involved in executing a Jar, so using this method
	 * just the processes of Java involved in running a jar can be killed
	 * <p>
	 * Works only on Windows and Mac. For other platforms False will be returned
	 * 
	 * @param jarName
	 * 		Name of the Jar file
	 * 
	 * @return
	 * 		Boolean indicating if process are identified and process kill is issued.
	 * 	In case a process is not found or it is not a supported platform then false will be 
	 * 	returned.
	 * 
	 * @since Genie 1.0
	 */
	public static boolean forceKillJavaProcessRunningAJar(String jarName)
	{
		if (jarName.toLowerCase().contains(".jar")){
			return Utils.forceKillJavaProcessRunningAJar(jarName);
		}
		else
			return false;
	}
}
