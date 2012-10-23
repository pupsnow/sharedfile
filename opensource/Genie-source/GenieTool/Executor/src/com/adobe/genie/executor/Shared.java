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

import java.io.File;
import java.io.IOException;
import java.lang.management.ManagementFactory;
import com.adobe.genie.genieCom.SynchronizedSocket;

/**
 * A Shared class used across Executor Project
 * 
 */
class Shared {
	
	private static TestCaseClassLoader classLoader;
	private static String CLASSPATH = ManagementFactory.getRuntimeMXBean().getClassPath() + File.pathSeparator + ManagementFactory.getRuntimeMXBean().getBootClassPath() + File.pathSeparator + ManagementFactory.getRuntimeMXBean().getLibraryPath();
	
	/**
	 * Reloads a previously loaded class.
	 * 
	 * @param name name of the class
	 * @param classPath the path where the class loader shall look for the class
	 * @param applicationRoot the path to the applications package
	 * @return a class object
	 * @throws ClassNotFoundException
	 */
	public static Class<?> reloadClass(File classFile, String name, String classPath) throws ClassNotFoundException {
		//classLoader = new TestCaseClassLoader(classPath + File.pathSeparator + CLASSPATH + File.pathSeparator + "bin" + File.pathSeparator + "scr");
		classLoader = TestCaseClassLoader.getInstance(classPath + File.pathSeparator + CLASSPATH + File.pathSeparator + "bin" + File.pathSeparator + "scr");
		try {
			Class<?> c = classLoader.loadClass(classFile, name);
			return c;
		}
		catch (Exception e) {
			//e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * Creates a class object from a class file.
	 * 
	 * @param file a class file
	 * @param classPath additional class path
	 * @return a class object
	 */
	public static Class<?> getClassFromFile(File file, String classPath) {
		Class<?> cl = null;
		String name = file.getName().replace(".class", "");
		
		do {
			try {
				try {
					cl = reloadClass(file.getParentFile(), name, file.getParentFile() == null ? "" : file.getParentFile().getCanonicalPath() + File.pathSeparator + classPath);
				}
				catch (IOException e) {
					cl = reloadClass(file.getParentFile(), name, file.getParentFile() == null ? "" : file.getParentFile().getPath() + File.pathSeparator + classPath);
				}
				break;
			}
			catch (ClassNotFoundException e) {
				file = file.getParentFile();
				if (file != null) {
					name = file.getName() + "." + name;
				}
			}
			catch (NoClassDefFoundError e) {
				file = file.getParentFile();
				if (file != null) {
					name = file.getName() + "." + name;
				}
			}
		}
		while (file != null);
		return cl;
	}
	/**
	 * A request to Server to get Environment XML, if user has supplied
	 * @return XML
	 */
	public static String getUserEnvXML()
	{
		SynchronizedSocket sc = SynchronizedSocket.getInstance();
		if (sc == null)
			return "";
		
		String envXml = sc.getUserEnvXML();
		
		return envXml;
	}
}
