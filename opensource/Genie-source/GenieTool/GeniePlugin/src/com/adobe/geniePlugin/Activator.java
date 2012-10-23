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

package com.adobe.geniePlugin;

import java.io.File;

import org.eclipse.jface.resource.ImageDescriptor;
import org.eclipse.ui.IStartup;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.IWorkbenchWindow;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.osgi.framework.BundleContext;

import com.adobe.genie.genieCom.SWFList;
import com.adobe.genie.genieCom.SocketClient;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.geniePlugin.comunication.ServerHandler;
import com.adobe.geniePlugin.comunication.StaticFlags;
import com.adobe.geniePlugin.ui.SWFAppUI;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.utils.log.*;
/**
 * The activator class controls the plug-in life cycle
 * <p>
 *  Owner: Suman Mehta
 *  $Author: suman $
 * 
 */
public class Activator extends AbstractUIPlugin implements IStartup
{

	// The plug-in ID
	public static final String PLUGIN_ID = "GeniePlugin";

	// The shared instance
	private static Activator plugin;
	
	/**
	 * The constructor
	 */
	public Activator() {
		
	}

	/**
	 * Implementation from interface IStartup
	 */
	public void earlyStartup()
	{
		//Nothing to do
	}
	
	/*
	 * (non-Javadoc)
	 * @see org.eclipse.ui.plugin.AbstractUIPlugin#start(org.osgi.framework.BundleContext)
	 */
	public void start(BundleContext context) throws Exception {
		
		String debugString = "Activator::start";
		
		String propertyChangesTrackerFile = System.getProperty("java.io.tmpdir") + File.separator + "propertyChangesTracker.txt";
		File outputFile = new File(propertyChangesTrackerFile);
		if(outputFile.exists())
		{
			outputFile.delete();
		}
		outputFile.createNewFile();
		
		super.start(context);
		plugin = this;
		
		String logFileName = System.getProperty("user.home") + File.separator + "GenieLogs" + 
			File.separator + "GeniePlugin" + File.separator + "PluginLog_" + 
			LogData.getCurrentTimeStamp() + ".log";
		LogData log = LogData.getInstance(logFileName);
		
		try
		{
			 log.trace(LogData.INFO, debugString + " Activator started");
			 
			 VersionHandler versionHandler = VersionHandler.getInstance();
			 
			 ServerHandler sr = new ServerHandler();
			 SocketClient sc = SocketClient.getInstance(Utils.PLUGIN_NAME_STR, sr);
			 sc.setPluginVersion(versionHandler.getPluginVersion());
			 
			 SynchronizedSocket socket = SynchronizedSocket.getInstance(sc);
			 
		}catch(Exception e)
		{
			Utils.printErrorOnConsole(e.getMessage());
		}		
	}

	/*
	 * (non-Javadoc)
	 * @see org.eclipse.ui.plugin.AbstractUIPlugin#stop(org.osgi.framework.BundleContext)
	 */
	public void stop(BundleContext context) throws Exception {
		String debugString = "Activator::stop";
		//disconnect all the swfs
		SWFList<SWFAppUI> list = SWFList.getInstance();
		list.disconnectAllSWFS();
		list.clear();
		
		plugin = null;
		super.stop(context);
		
		//Bug fix by gsingal
		//Closing socket explicitly. Bug #2794515
		SynchronizedSocket socket = SynchronizedSocket.getInstance();
		socket.close();
		
		LogData.getInstance().trace(LogData.INFO, debugString);
	}

	/**
	 * Returns the shared instance
	 *
	 * @return the shared instance
	 */
	public static Activator getDefault() {
		return plugin;
	}

	/**
	 * Returns an image descriptor for the image file at the given
	 * plug-in relative path
	 *
	 * @param path the path
	 * @return the image descriptor
	 */
	public static ImageDescriptor getImageDescriptor(String path) {
		return imageDescriptorFromPlugin(PLUGIN_ID, path);
	}
}
