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
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.Enumeration;
import java.util.Properties;
import java.util.StringTokenizer;
import java.util.Vector;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

/**
 * A custom class loader which enables the reloading of classes for each test run. The class loader
 * can be configured with a list of package paths that should be excluded from loading. The loading
 * of these packages is delegated to the system class loader. They will be shared across test runs.
 * <p>
 * The list of excluded package paths is specified in a properties file "excluded.properties" that
 * is located in the same place as the TestCaseClassLoader class.
 * <p>
 * <b>Known limitation:</b> the TestCaseClassLoader cannot load classes from jar files.
 */
class TestCaseClassLoader extends ClassLoader {
	/** scanned class path */
	private Vector<String> fPathItems;
	/** default excluded paths */
	private String[] defaultExclusions = {"com.adobe.genie", "framework.", "sun.", "com.sun.", "org.omg.", "javax.", "sunw.", "java.", "org.w3c.dom.", "org.xml.sax.", "net.jini." };
	/** name of excluded properties file */
	static final String EXCLUDED_FILE = "excluded.properties";
	/** excluded paths */
	private Vector<String> fExcluded;
	private boolean isFromJar = false;
	private static TestCaseClassLoader instance = null;
	
	//Singleton class so that custom component delegates can be loaded in the same class loader
	public static TestCaseClassLoader getInstance(String classPath)
	{
		if(instance == null)
			instance = new TestCaseClassLoader(classPath);
		else
			//Suman: scan paths even if we are returning existing instance, so that correct class path is set
			//Fixed bug#3005997
			instance.scanPath(classPath);
		return instance;
	}
	
	/**
	 * Constructs a TestCaseLoader. It scans the class path and the excluded package paths
	 */
	public TestCaseClassLoader() {
		this(System.getProperty("java.class.path"));
	}

	/**
	 * Constructs a TestCaseLoader. It scans the class path and the excluded package paths
	 */
	public TestCaseClassLoader(String classPath) {
		scanPath(classPath);
		readExcludedPackages();
	}

	private void scanPath(String classPath) {
		fPathItems = new Vector<String>();
		StringTokenizer st = new StringTokenizer(classPath, File.pathSeparator);
		while (st.hasMoreTokens()) {
			fPathItems.addElement(st.nextToken());
		}
	}

	public URL getResource(String name) {
		return ClassLoader.getSystemResource(name);
	}

	public InputStream getResourceAsStream(String name) {
		return ClassLoader.getSystemResourceAsStream(name);
	}

	public boolean isExcluded(String name) {
		for (int i = 0; i < fExcluded.size(); i++) {
			if (name.startsWith(fExcluded.elementAt(i))) {
				return true;
			}
		}
		return false;
	}
	
	public synchronized Class<?> loadClass(File classFile, String className) {
		//SCA
		byte[] data;
		//byte[] data = null;
		data = loadFileData(classFile.getPath(), className.replace(".", "/") + ".class");
		if (data != null) {
			return defineClass(className, data, 0, data.length);
		}
		throw new NoClassDefFoundError(className);
	}

	public synchronized Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
		Class<?> c = findLoadedClass(name);
		if (c != null) {
			return c;
		}
		//
		// Delegate the loading of excluded classes to the
		// standard class loader.
		//
		if (isExcluded(name)) {
			try {
				c = findSystemClass(name);
				return c;
			}
			catch (ClassNotFoundException e) {
				// keep searching
			}
		}
		if (c == null) {
			byte[] data = lookupClassData(name);
			if (data == null) {
				throw new ClassNotFoundException();
			}
			if (isFromJar) {
				c = getSystemClassLoader().loadClass(name);
			}
			else {
				c = defineClass(name, data, 0, data.length);
			}
		}
		if (resolve) {
			resolveClass(c);
		}
		return c;
	}

	private byte[] lookupClassData(String className) throws ClassNotFoundException {
		//SCA
		byte[] data;
		//byte[] data = null;
		for (int i = 0; i < fPathItems.size(); i++) {
			String path = fPathItems.elementAt(i);
			String fileName = className.replace('.', '/') + ".class";
			if (isJar(path)) {
				data = loadJarData(path, fileName);
				isFromJar = true;
			}
			else {
				data = loadFileData(path, fileName);
				isFromJar = false;
			}
			if (data != null) {
				return data;
			}
		}
		throw new ClassNotFoundException(className);
	}

	boolean isJar(String pathEntry) {
		return pathEntry.endsWith(".jar") || pathEntry.endsWith(".zip");
	}

	private byte[] loadFileData(String path, String fileName) {
		File file = new File(path, fileName);
		if (file.exists()) {
			return getClassData(file);
		}
		return null;
	}

	private byte[] getClassData(File f) {
		FileInputStream stream = null;
		try {
			stream = new FileInputStream(f);
			byte[] bytes = new byte[stream.available()];
			stream.read(bytes);			
			return bytes;
		}
		catch (IOException e) {}
		finally{
				try{
					stream.close();
				}
				catch (Exception e){
						StaticFlags sf=StaticFlags.getInstance();
						sf.printErrorOnConsoleDebugMode("Exception occured:"+e.getMessage());
				}
		  }
		
		return null;
	}

	private byte[] loadJarData(String path, String fileName) {
		ZipFile zipFile = null;
		InputStream stream = null;
		File archive = new File(path);
		if (!archive.exists()) {
			return null;
		}
		try {
			zipFile = new ZipFile(archive);
		}
		catch (IOException io) {
			return null;
		}
		ZipEntry entry = zipFile.getEntry(fileName);
		if (entry == null) {
			return null;
		}
		int size = (int) entry.getSize();
		try {
			stream = zipFile.getInputStream(entry);
			byte[] data = new byte[size];
			int pos = 0;
			while (pos < size) {
				int n = stream.read(data, pos, data.length - pos);
				pos += n;
			}
			zipFile.close();
			return data;
		}
		catch (IOException e) {
		}
		finally {
			try {
				if (stream != null) {
					stream.close();
				}
			}
			catch (IOException e) {
			}
		}
		return null;
	}

	private void readExcludedPackages() {
		fExcluded = new Vector<String>(10);
		for (int i = 0; i < defaultExclusions.length; i++) {
			fExcluded.addElement(defaultExclusions[i]);
		}
		InputStream is = getClass().getResourceAsStream(EXCLUDED_FILE);
		if (is == null) {
			return;
		}
		Properties p = new Properties();
		try {
			p.load(is);
		}
		catch (IOException e) {
			return;
		}
		finally {
			try {
				is.close();
			}
			catch (IOException e) {
			}
		}
		for (Enumeration<?> e = p.propertyNames(); e.hasMoreElements();) {
			String key = (String) e.nextElement();
			if (key.startsWith("excluded.")) {
				String path = p.getProperty(key);
				path = path.trim();
				if (path.endsWith("*")) {
					path = path.substring(0, path.length() - 1);
				}
				if (path.length() > 0) {
					fExcluded.addElement(path);
				}
			}
		}
	}

	public void setExcluded(String name) {
		if (!fExcluded.contains(name)) {
			fExcluded.addElement(name);
		}
	}
	
	public void dispose()
	{
		instance = null;
	}
}