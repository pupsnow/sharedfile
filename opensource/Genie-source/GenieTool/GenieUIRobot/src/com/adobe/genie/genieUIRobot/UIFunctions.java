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
package com.adobe.genie.genieUIRobot;

import java.awt.AWTException;
import java.awt.Dimension;
import java.awt.GraphicsConfiguration;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.awt.MouseInfo;
import java.awt.Point;
import java.awt.PointerInfo;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.Transparency;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;
import java.awt.im.InputContext;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeSet;
import javax.imageio.ImageIO;
import org.apache.sanselan.ImageReadException;
import org.apache.sanselan.Sanselan;
import org.apache.sanselan.SanselanConstants;
import org.apache.sanselan.common.IBufferedImageFactory;
import org.apache.sanselan.common.IImageMetadata;
import com.adobe.genie.utils.Utils;

/**
 * This will provide the native UI functions for mouse and keyboard options
 * 
 */
public class UIFunctions {

	public static final int DELAY = 50;
	private static boolean isRobotInitialized = false;
	private Robot robot;
	private TreeSet<Integer> keysPressed;
	private int mouseButtonMask;
	private int lastMouseButtonMask;
	private Point mousePos;
	private boolean isDebugMode = false;
	Boolean shift_pressed = false,ctrl_pressed = false,alt_pressed = false;

	public UIFunctions(boolean debugMode) {
		try {
			isDebugMode = debugMode;
			robot = new Robot();
			robot.setAutoWaitForIdle(true);
			robot.setAutoDelay(DELAY);
			keysPressed = new TreeSet<Integer>();
			mouseButtonMask = 0;
			mousePos = new Point();
			//Suman: Fixed bug#3003551
			if(!isRobotInitialized)
			{
				pressAltTabKeyOnlyForMac();
				isRobotInitialized = true;
			}
				
		} catch (AWTException e) {
			Utils.printErrorOnConsole("Unable to create AWT Robot for input events.");
			if (isDebugMode){
				e.printStackTrace();
			}
		}
	}
	/**
	 * Need for this is MAC specific.
	 * When user perform UI operations on mac, robot initializes, and it focus out the application.
	 * And, when UI operation occurs, it just focus the application, 
	 * and actual operation does not happen
	 * 
	 * So, this action is being performed just before script is about to executed
	 */
	private void pressAltTabKeyOnlyForMac()
	{
		if (System.getProperty("os.name").toLowerCase().startsWith("mac"))
		{
			try
			{
				pressKey("VK_META");
				pressKey("VK_TAB");
				releaseKey("VK_TAB");
				releaseKey("VK_META");
			}
			catch(Exception e){
				//StaticFlags sf = StaticFlags.getInstance();					
				//sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
			}
		}
	}
	
	//========================================================================================
	// Some Functions related to Clicking at coordinates 
	//========================================================================================

	
	/**
     * Clicks at (x, y) on the host screen.
     *
     * @param x
     *            x coordinate
     * @param y
     *            y coordinate
     */
    public void click(int x, int y,int... key_Modifier) throws Exception {
        if (x < 0 || x > getDesktopSize().width || y < 0 || y > getDesktopSize().height) {
            throw new Exception("Mouse coordinates off screen");
        }
        //If key modifiers need to be pressed, then press the corresponding key.
    	
        if(key_Modifier.length != 0){
        	if(key_Modifier[0] == 0){
        		pressKey(KeyEvent.VK_SHIFT);
        		shift_pressed = true;
        	}
        	if(key_Modifier[0] == 1){
        		pressKey(KeyEvent.VK_CONTROL);
        		ctrl_pressed = true;
        	}
        	if(key_Modifier[0] == 2){
        		pressKey(KeyEvent.VK_ALT);
        		alt_pressed = true;
        	}
        }
        //Click at the specified location
        leftClick(x, y);
        
        //Release the modifier keys..
        if(shift_pressed)
        	releaseKey(KeyEvent.VK_SHIFT);
        if(ctrl_pressed)
        	releaseKey(KeyEvent.VK_CONTROL);
        if(alt_pressed)
        	releaseKey(KeyEvent.VK_ALT);
    }
    
    /**
	 * Produces a left click at the given screen coordinates.
	 * 
	 * @param x
	 *            the x coordinate to click on
	 * @param y
	 *            the y coordinate to click on
	 */
	 private void leftClick(int x, int y) {
		robot.mouseMove(x, y);
		robot.mousePress(InputEvent.BUTTON1_MASK);
		robot.mouseRelease(InputEvent.BUTTON1_MASK);
	}

	/**
	 * Presses and holds the left mouse button.
	 * 
	 */
	 void leftDown() {
		robot.mousePress(InputEvent.BUTTON1_MASK);
	}

	/**
	 * Releases the left mouse button.
	 * 
	 */
	 void leftUp() {
		robot.mouseRelease(InputEvent.BUTTON1_MASK);
	} 
	 
	/**
	 * Right clicks at (x, y) on the screen.
	 *
	 * @param x
	 *            x coordinate
	 * @param y
	 *            y coordinate
	 */
	  public void rightClick(int x, int y, int... key_Modifier ) throws Exception {
	    if (x < 0 || x > getDesktopSize().width || y < 0 || y > getDesktopSize().height) {
	        throw new Exception("Mouse coordinates off screen");
	    }
	    //If key modifiers need to be pressed, then press the corresponding key.
	    if(key_Modifier.length != 0){
	    	if(key_Modifier[0] == 0){
	    		pressKey(KeyEvent.VK_SHIFT);
	    		shift_pressed = true;
	    	}
	    	if(key_Modifier[0] == 1){
	    		pressKey(KeyEvent.VK_CONTROL);
	    		ctrl_pressed = true;
	    	}
	    	if(key_Modifier[0] == 2){
	    		pressKey(KeyEvent.VK_ALT);
	    		alt_pressed = true;
	    	}
	    }
	    	this.rightclick(x, y);
	    	
	    //Release the modifier keys..
	    if(shift_pressed)
	      	releaseKey(KeyEvent.VK_SHIFT);
	    if(ctrl_pressed)
	       	releaseKey(KeyEvent.VK_CONTROL);
	    if(alt_pressed)
	       	releaseKey(KeyEvent.VK_ALT);
	  }

	 /**
	  * Produces a right click at the given screen coordinates.
	  * 
	  * @param x
	  *            the x coordinate to click on
	  * @param y
	  *            the y coordinate to click on
	  */
	  private void rightclick(int x, int y) {
		robot.mouseMove(x, y);
		robot.mousePress(InputEvent.BUTTON3_MASK);
		robot.mouseRelease(InputEvent.BUTTON3_MASK);
	  } 
	  /**
	   * Presses and holds the left mouse button.
	   * 
	   */
	   void rightDown() {
		  robot.mousePress(InputEvent.BUTTON3_MASK);
	  }

	  /**
	   * Releases the left mouse button.
	   * 
	   */
	   void rightUp() {
		  robot.mouseRelease(InputEvent.BUTTON3_MASK);
	  }	 
	   
	   /**
	    * Double clicks at (x, y) on the screen.
	    *
	    * @param x
	    *            x coordinate
	    * @param y
	    *            y coordinate
	    */
	   	public void doubleClick(int x, int y, int...key_Modifier) throws Exception {
	   		if (x < 0 || x > getDesktopSize().width || y < 0 || y > getDesktopSize().height) {
	   			throw new Exception("Mouse coordinates off screen");
	   		}
	   	//If key modifiers need to be pressed, then press the corresponding key.
	   		if(key_Modifier.length != 0){
	   			if(key_Modifier[0] == 0){
	   				pressKey(KeyEvent.VK_SHIFT);
	   				shift_pressed = true;
	   			}
	   			if(key_Modifier[0] == 1){
	   				pressKey(KeyEvent.VK_CONTROL);
	   				ctrl_pressed = true;
	   			}
	   			if(key_Modifier[0] == 2){
	   				pressKey(KeyEvent.VK_ALT);
	   				alt_pressed = true;
	   			}
	   		}
	   		leftClick(x, y);
	   		leftClick(x, y);
	   
	   		//Release the modifier keys..
		    if(shift_pressed)
		      	releaseKey(KeyEvent.VK_SHIFT);
		    if(ctrl_pressed)
		       	releaseKey(KeyEvent.VK_CONTROL);
		    if(alt_pressed)
		       	releaseKey(KeyEvent.VK_ALT);
	    }

	   /**
	   * Moves the mouse to (x, y) on the screen.
	   * 
	   * @param x
	   *            horizontal screen component
	   * @param y
	   *            vertical screen component
	   */
	   public void moveMouse(int x, int y) throws Exception{
		   robot.mouseMove(x, y);
	   }	 
	  
	   /**
		* Scrolls the wheel the given amount. Positive means down, negative means
		* up.
		* 
		* @param amount
		*            the amount to scroll (in notches)
		*/
	   void scrollMouse(int amount) {
		   robot.mouseWheel(amount);
	   }	 

	   /**
		 *
		 * Gets the mouse co-ordinates.
		 *
		 */
		Point getMousePoint() {
			PointerInfo p = null;
			p = MouseInfo.getPointerInfo();
			if(p == null)
				return null;
			else
				return p.getLocation();
		}	   
	   
	   /**
		 * Returns the desktop resolution.
		 *
		 * @return the resolution of the desktop in pixels
		 */
		private Dimension getDesktopSize() {
		    return Toolkit.getDefaultToolkit().getScreenSize();
		}
	   
		
	//========================================================================================
	// Some Functions related to keyboard type text or char 
	//========================================================================================

	/**
	 * Types a string on the host system.
	 *
	 * @param text
	 *            the string to type
	 */
	public void typeText(String text)throws Exception {
	    for (int i = 0; i < text.length(); i++) {
	        typeChar(text.charAt(i));
	    }
	}		
	
	 /**
	  * Releases the key referred to by the name passed in (e.g. VK_SHIFT). If
	  * the key was not previously pressed (see pressKey), the result is
	  * undefined.
	  *
	  * @param name
	  *            the name of the virtual key to press
	  * @throws Exception
	  *             if the key code is invalid
	  */
	 public void releaseKey(String name) throws Exception {
		 try {
			 int code = getKeyCode(name);
	         releaseKey(code);
	         keysPressed.remove(code);
		 } catch (IllegalAccessException e) {
			 Utils.printErrorOnConsole("Exception while attempting to retrieve value of field");
	         Utils.printErrorOnConsole("Invalid KeyCode");
				if (isDebugMode){
					e.printStackTrace();
				}
	       }
	 }

	/**
     * Releases all previously pressed keys.
     * @throws Exception
     */
    public void releaseAllKeys() throws Exception {
        for (int key : keysPressed) {
	        /*
	         * Note that you can't simply call releaseKey() here because that
	         * would try to change the Set (keysPressed) from under this
	         * (implicit) iterator, resulting in a race condition.
	         */
            releaseKey(key);
        }
        keysPressed.clear();
    }
	 
	 /**
	  * Presses the key referred to by the name passed in (e.g. VK_SHIFT). You
	  * must release it yourself through the releaseKey or releaseAllKeys
	  * methods, or it may stay pressed at least until you log off.
	  *
	  * @param name
	  *            the name of the virtual key to press
	  * @throws Exception
	  *             if the key code is invalid
	  */
	 public void pressKey(String name) throws Exception{
		 try {
			 int code = getKeyCode(name);
	         pressKey(code);
	         keysPressed.add(code);
		 } catch (IllegalAccessException e) {
			 Utils.printErrorOnConsole("Exception while attempting to retrieve value of field");
			 Utils.printErrorOnConsole("Invalid KeyCode");
				if (isDebugMode){
					e.printStackTrace();
				}
	       }
	 }

	 /**
	  * Types (presses and releases) the key referred to by the name passed in
	  * (e.g. VK_SHIFT).
	  *
	  * @param name
	  *            the name of the virtual key to press
	  * @throws Exception
	  *             if the key code is invalid
	  */
	 public void typeKey(String name) throws Exception {
	   try {
		   int code = -1;
		   try{
			   code = getKeyCode(name);
		   }catch(Exception e)
		   {
			   throw e;
		   }
		   typeKey(code);
	   	} catch (IllegalAccessException e) {
	   		if (isDebugMode){
				e.printStackTrace();
			}
	      }
	 }
	
	 /**
	 * Presses the key designated by the java.awt.event.KeyEvent virtual key
	 * code (but does not release it).
	 * 
	 * @param code
	 *            the java.awt.event.KeyEvent virtual key code
	 */
	private void pressKey(int code) {
		robot.keyPress(code);
	}

	/**
	 * Releases the key designated by the java.awt.event.KeyEvent virtual key
	 * code. The result is undefined if the key was not actually pressed.
	 * 
	 * @param code
	 *            the java.awt.event.KeyEvent virtual key code
	 */
	private void releaseKey(int code) {
		robot.keyRelease(code);
	}
	
	/**
	 * Types the key designated by the java.awt.event.KeyEvent virtual key code.
	 * 
	 * @param code
	 *            the java.awt.event.KeyEvent virtual key code
	 */
	private void typeKey(int code) throws Exception{
		boolean pressShift = false;
		if((code >= 150 && code <= 152) || (code >= 512 && code <= 524))
		{
			code = findActualKey(code);
			pressShift = true;
		}
		if(pressShift)
			pressKey(KeyEvent.VK_SHIFT);
		pressKey(code);
		releaseKey(code);
		if(pressShift)
			releaseKey(KeyEvent.VK_SHIFT);
	}

	/**
	 * Types the character on the host machine. Note that this method simply
	 * passed character codes directly to the system. For example, if you pass
	 * it 'a', it will do the correct thing because the ASCII codes for
	 * alphanumerics tend to line up with the virtual key codes. Don't count on
	 * this being the case for other keys, like '!' or F12, because it almost
	 * certainly won't be.
	 * 
	 * @param code
	 *            the character to type
	 */
	 private void typeChar(int code) throws Exception {
		
		//Press any key, if already pressed by user and not released.
		for(int key : keysPressed)
			pressKey(key);
				
		if(Character.isLetterOrDigit((char) code))
		{
			if (Character.isUpperCase((char) code)) {
				pressKey(KeyEvent.VK_SHIFT);
				typeKey(code);
				releaseKey(KeyEvent.VK_SHIFT);
			} else {
				char ch = Character.toUpperCase((char) code);
				typeKey(ch);
			}
		}
		else // we need to find the key code for the character, it's in ASCII
		{
			if((code >= 33 && code <= 43) || (code == 58) || (code == 60)
					|| (code >= 62 && code <= 64) || (code == 94) || (code == 95)
					|| (code >= 123 && code <= 126))
			{ // it requires shift, and a key mapping
				int actualKey = findActualKey(code);
				pressKey(KeyEvent.VK_SHIFT);
				typeKey(actualKey);
				releaseKey(KeyEvent.VK_SHIFT);
			}
			else
			{
				typeKey(code);
			}
		}
	}
	
	/**
	 * Returns the key code as an int that is associated with the key code name
	 * (as a String). Since this method simply looks through the fields of
	 * java.awt.event.KeyEvent, you can simply look there on whatever system or
	 * platform or version you're running to find exactly what this method
	 * should find.
	 * 
	 * @param name
	 *            the name of the key code (the name of the field whose value
	 *            you want)
	 * @return the key code as an int
	 */
	@SuppressWarnings("null")
	private int getKeyCode(String name) throws IllegalAccessException , NoSuchFieldException {
		Class<?> ke = null;
		Field fld = null;
		try {
			ke = Class.forName("java.awt.event.KeyEvent");
			fld = ke.getField(name);
			return (fld.getInt(ke));
		} catch (ClassNotFoundException e) {
			Utils.printErrorOnConsole("Unable to find a class associated with the "
					+ "name KeyEvent");
			if (isDebugMode){
				e.printStackTrace();
			}
		} catch (NoSuchFieldException e) {
				throw new NoSuchFieldException("Unable to find a field associated with the name "
							+ name + " in class KeyEvent");
			}
		return (fld.getInt(ke));
	}
	
	/**
	 * Returns the key code as an int that is the actual key that needs to be
	 * pressed, in conjunction with shift, to get the key represented by the
	 * code passed in.  Works for English keyboards only.
	 * 
	 * @param code
	 *            the code of the key you want, but need a shift-modifier for
	 * @return the key code as an int
	 */
	private int findActualKey(int code) throws Exception{
		InputContext context = InputContext.getInstance();  
		if(context.getLocale().toString().equalsIgnoreCase("en_US"))
		{ // these key mappings are valid for the US English keyboard.  Possibly not for other keyboard layouts.
			switch(code){
			case 150:
			case 38:
				return KeyEvent.VK_7; // &
			case 151:
			case 42:
				return KeyEvent.VK_8; // *
			case 152:
			case 34:
				return KeyEvent.VK_QUOTE; // "
			case 512:
			case 64:
				return KeyEvent.VK_2; // @
			case 513:
			case 58:
				return KeyEvent.VK_SEMICOLON; // :
			case 514:
			case 94:
				return KeyEvent.VK_6; // ^
			case 515:
			case 36:
				return KeyEvent.VK_4; // $
			case 517:
			case 33:
				return KeyEvent.VK_1; // !
			case 519:
			case 40:
				return KeyEvent.VK_9; // (
			case 520:
			case 35:
				return KeyEvent.VK_3; // #
			case 521:
			case 43:
				return KeyEvent.VK_EQUALS; // +
			case 522:
			case 41:
				return KeyEvent.VK_0; // )
			case 523:
			case 95:
				return KeyEvent.VK_MINUS; // _
			case 37:
				return KeyEvent.VK_5; // %
			case 123:
				return KeyEvent.VK_OPEN_BRACKET; // {
			case 124:
				return KeyEvent.VK_BACK_SLASH; // |
			case 125:
				return KeyEvent.VK_CLOSE_BRACKET; // }
			case 126:
				return KeyEvent.VK_BACK_QUOTE; // ~
			case 63:
				 return KeyEvent.VK_SLASH;
			case 62:
			     return KeyEvent.VK_PERIOD;
			case 60:
				return KeyEvent.VK_COMMA;
			
			default:
				return 0;
			}
		}
		return code;
	}
	

    /**
     * Types a shortcut by pressing the system dependent modifier key (Control
     * on Windows, Command (aka Open Apple or Flower) on Mac), typing the
     * command key and releasing the modifier key.
     *
     * @param key
     *            the shortcut key to type
     * @throws Exception
     */
    void typeCommand(String key) throws Exception {
        int iControl;
        if (System.getProperty("os.name").toLowerCase().contains("windows")) {
            iControl = getKeyCode("VK_CONTROL");
        } else if (System.getProperty("os.name").toLowerCase().contains("mac")) {
            iControl = getKeyCode("VK_META");
        } else {
            throw new IllegalArgumentException(
                    "Platform for typeCommand() invalid");
        }
        if(key.indexOf("+")!=-1){
            String[] strKeys = key.split("+");
            for(int i=0;i<strKeys.length;i++){
                if(strKeys[i].startsWith("VK_")){
                    int iCode = getKeyCode(strKeys[i]);
                    pressKey(iCode);
                }else{
                    typeText(strKeys[i]);
                }
            }
        }else{
        	pressKey(iControl);
        	typeText(key);
        	releaseKey(iControl);
        }
    }
    

	//========================================================================================
	// Some Functions related to getting image coordinates on screen 
	//========================================================================================

	
    /**
     * Finds the fixed UIEnable image on screen
     *
     * @return the coordinates of Genie image on screen (Start coordinates of the Application)
     */
    public Point getUIGenieCoordinates() throws IOException{
		BufferedImage capturedImage = null;
		
		InputStream is = null;
		is = getClass().getClassLoader().getResourceAsStream("icons/UIEnable.png");
		capturedImage = ImageIO.read(is);
        if(capturedImage != null){
        	PicFinder PF = new PicFinder(isDebugMode);
        	return PF.findFirst(capturedImage, 4);
        }
        else{
        	Utils.printErrorOnConsole("Image UIEnable.png Read Error");
			return new Point(-1,-1);
        }
        	
	}
    
    /**
     * Finds any passed image on screen
     *
     * @return the center coordinates of image passed as parameter on screen
     */
    public Point getImageCoordinates(String imagePath, int tolerance) throws Exception{
		BufferedImage capturedImage = null;
		boolean isReaderAvailable = false;
		
		File imageFile = new File(imagePath);
		
		
		//Check if the specified image format can be parsed
		String imageExtension = imageFile.getName().substring(imageFile.getName().lastIndexOf('.')+1);
		Iterator<?> iter = ImageIO.getImageReadersByFormatName(imageExtension);
		if (iter.hasNext()){
			isReaderAvailable = true;
		}
		//If specified image format cannot be processed, return an error
		if (!isReaderAvailable){
			throw new Exception("The specified image format cannot be processed");
			//Utils.printErrorOnConsole("The specified image format cannot be processed");
		}

		if (!imageFile.exists()){
			throw new Exception("The Specified image file does not exists on Disk");
		}
		
		capturedImage = ImageIO.read(imageFile);
        	
		if(capturedImage != null){
			PicFinder PF = new PicFinder(isDebugMode);
			Point imageStart = PF.findFirst(capturedImage, tolerance);
			
			//if PicFinder is unable to find image read from java then we try to read image through Sanselan library 
			//and then use PicFinder again to find image . 
			if(imageStart.x == -1 && imageStart.y == -1)
			{
				capturedImage = imageReadFromSanselan(imageFile);
				imageStart = PF.findFirst(capturedImage, tolerance);
			}
			if(imageStart.x != -1 && imageStart.y != -1){
				//	Return the center point of the image
				return new Point(imageStart.x+capturedImage.getWidth()/2,imageStart.y+capturedImage.getHeight()/2);
			}
			else
				return new Point(-1,-1);
		}
		else{
			throw new Exception("Error Reading Image from Disk");
		}
		
	}
    
    /**
     * Finds any passed image on screen
     *
     * @return the hot spot coordinates of image passed as parameter on screen
     */
    public Point getImageHotSpotCoordinates(String imagePath,int tolerance) throws Exception{
		BufferedImage capturedImage = null;
		boolean isReaderAvailable = false;
		Point hotSpotPoint = new Point();
		File imageFile = new File(imagePath);
		
		
		//Check if the specified image format can be parsed
		String imageExtension = imageFile.getName().substring(imageFile.getName().lastIndexOf('.')+1);
		Iterator<?> iter = ImageIO.getImageReadersByFormatName(imageExtension);
		if (iter.hasNext()){
			isReaderAvailable = true;
		}
		//If specified image format cannot be processed, return an error
		if (!isReaderAvailable){
			throw new Exception("The specified image format cannot be processed");
			//Utils.printErrorOnConsole("The specified image format cannot be processed");
		}

		if (!imageFile.exists()){
			throw new Exception("The Specified image file does not exists on Disk");
		}
		
		capturedImage = ImageIO.read(imageFile);
		
		if(capturedImage != null){
			PicFinder PF = new PicFinder(isDebugMode);
			Point imageStart = PF.findFirst(capturedImage, tolerance);
			
			//if PicFinder is unable to find image read from java then we try to read image through Sanselan library 
			 //and then use PicFinder again to find image  
			if(imageStart.x == -1 && imageStart.y == -1)
			{
				capturedImage = imageReadFromSanselan(imageFile);
				imageStart = PF.findFirst(capturedImage, tolerance);
			}
			
			if(imageStart.x != -1 && imageStart.y != -1)
			{
				hotSpotPoint = readHotSpotInformation(new File(imagePath));
				if( hotSpotPoint.x != -1 && hotSpotPoint.y != -1)
				{
					return new Point(imageStart.x+hotSpotPoint.x,imageStart.y+hotSpotPoint.y);
				}
				else
				{
					return new Point(imageStart.x+capturedImage.getWidth()/2,imageStart.y+capturedImage.getHeight()/2);
				}
			 }
			 else
				return new Point(-1,-1);
		}
		else{
			throw new Exception("Error Reading Image from Disk");
		}
		
	}
    /**
     * Captures the full Screen Snapshot and stores it in a file at specified Folder
     * The format of image is JPG
     *  
     * @param folder
     * @param fileName
     * @throws Exception
     */
    public void captureScreenAsJPG(String folder, String fileName) throws Exception {

    	//Append Extension to fileName if not provided
    	String imageExtension = fileName.substring(fileName.lastIndexOf('.')+1);
    	if (!(imageExtension.trim().equalsIgnoreCase("jpg"))){
    		fileName = fileName + ".jpg";
    	}

    	//Append file separator to folder name if not existing already
    	String lastExtension = folder.substring(folder.lastIndexOf(System.getProperty("file.separator"))+1);
    	String filePath = "";
    	if (!(lastExtension.trim().equalsIgnoreCase("")))
    		folder = folder + System.getProperty("file.separator");

    	// Checks if the specified folder exists on disk
    	File tempFile = new File(folder);
    	if (!tempFile.exists()){
    		Utils.printMessageOnConsole("The specified folder hierarchy where ScreenShot needs to be stored does not Exists... Creating Folder!!!");
    		tempFile.mkdirs();
    	}
    	
    	// If it still do not exists throw an Exception
    	if (!tempFile.exists())
    		throw new Exception("Unable to create the specified folder hierarchy where ScreenShot needs to be stored");
    	
    	//Compose full file path
    	filePath = folder +  fileName;
    	
    	//Now lets capture screen and write it in a file
    	PicFinder PF = new PicFinder(isDebugMode);
    	BufferedImage screenShot = PF.captureScreenPixelsAsBufferedImage();
    	ImageIO.write(screenShot, "JPG", new File(filePath));
    }
    
	//========================================================================================
	// Some Functions related performing Drag Operation 
	//========================================================================================
   
    /**
	 * Presses left mouse button on (x1, y2), moves mouse to (x2,y2) and releases mouse button.
	 * 
	 * @param x1 x coordinate to start dragging
	 * @param y1 y coordinate to start dragging
	 * @param x2 x coordinate to stop dragging
	 * @param y2 y coordinate to stop dragging
	 * @param time time to hold mouse before drag
	 */
	public void holdAnddrag(int x1, int y1, int x2, int y2, int time) throws Exception {
		int xRange = x2 - x1;
		int yRange = y2 - y1;
		int segments = (Math.abs(xRange) > Math.abs(yRange) ? Math.abs(xRange) : Math.abs(yRange)) / 10;
		
		pressMouseButton(1);
		Thread.sleep(200);
		writePointer(x1, y1);
		Thread.sleep(200);
		Thread.sleep(time);
		for (int i = 0; i < segments; i++) {
			Thread.sleep(30);
			int nx = (x1 + (int) ((float) xRange / segments * i));
			int ny = (y1 + (int) ((float) yRange / segments * i));
			writePointer(nx, ny);
		}
		Thread.sleep(30);
		writePointer(x2, y2);
		releaseMouseButton(1);
		Thread.sleep(200);
		writePointer(x2, y2);
	} 

    /**
	 * Presses left mouse button on (x1, y2), moves mouse to (x2,y2) and releases mouse button.
	 * 
	 * @param x1 x coordinate to start dragging
	 * @param y1 y coordinate to start dragging
	 * @param x2 x coordinate to stop dragging
	 * @param y2 y coordinate to stop dragging
	 */
	public void drag(int x1, int y1, int x2, int y2) throws Exception {
		holdAnddrag(x1,y1,x2,y2,0);
	} 
	
	 /**
	 * Drags from Current Mouse position to specified x,y co-ordinate
	 * 
	 * @param x x coordinate to stop dragging
	 * @param y y coordinate to stop dragging
	 */
	public void drag(int x, int y) throws Exception {
		drag(MouseInfo.getPointerInfo().getLocation().x,MouseInfo.getPointerInfo().getLocation().y,x,y);
	} 

	 /**
	 * Drags from Current Mouse position to specified x,y co-ordinate
	 * 
	 * @param x x coordinate to stop dragging
	 * @param y y coordinate to stop dragging
	 * @param time time to hold mouse before drag
	 */
	public void holdAnddrag(int x, int y, int time) throws Exception {
		holdAnddrag(MouseInfo.getPointerInfo().getLocation().x,MouseInfo.getPointerInfo().getLocation().y,x,y,time);
	} 

	
	//Private method to support Drag
    private synchronized void pressMouseButton(int button) {
		if (button > 8 || button < 1) {
			throw new IllegalArgumentException("Invalid button number!");
		}
		mouseButtonMask = mouseButtonMask | (1 << (button - 1));
	}

    //Private method to support Drag
	private synchronized void releaseMouseButton(int button) {
		if (button > 8 || button < 1) {
			throw new IllegalArgumentException("Invalid button number!");
		}
		mouseButtonMask = mouseButtonMask | (1 << (button - 1));
		mouseButtonMask = mouseButtonMask ^ (1 << (button - 1));
	}
	
	//Private method to support Drag
	private synchronized void writePointer(int x, int y) throws IOException {
			robot.mouseMove(x, y);
			if ((mouseButtonMask & (1 << 4)) > 0) {
				robot.mouseWheel(1);
			}
			else if ((mouseButtonMask & (1 << 3)) > 0) {
				robot.mouseWheel(-1);
			}
			else {
				if (mouseButtonMask != lastMouseButtonMask) {
					int press = (mouseButtonMask ^ lastMouseButtonMask) & mouseButtonMask;
					int release = (mouseButtonMask ^ lastMouseButtonMask) & lastMouseButtonMask;
					Utils.printMessageOnConsole("Press: " + Integer.toBinaryString(press) + " (reverse: " + Integer.toBinaryString(Integer.reverse(press) >>> 27) + ")");
					Utils.printMessageOnConsole("Release: " + Integer.toBinaryString(release) + " (reverse: " + Integer.toBinaryString(Integer.reverse(release) >>> 27) + ")");
					for (int i = 1; i < 8; i *= 2) {
						if ((press & i) > 0) {
							robot.mousePress(Integer.reverse(i) >>> 27);
						}
						if ((release & i) > 0) {
							robot.mouseRelease(Integer.reverse(i) >>> 27);
						}
					}
					lastMouseButtonMask = mouseButtonMask;
				}
			}
		mousePos.setLocation(x, y);
	}
	
	
	//This function is used to find hotspot data in an image using Sanselan.jar functionality to get exif data of an image
	// We get hot spot information from Comment tag of image as a string and then parse that string to get actual hot spot integer coordinates
	 private Point readHotSpotInformation(File file)
	  {
		  IImageMetadata imageMetadata = null;
		  String item = new String();
		  Point hotSpotPoint = new Point(-1,-1);
		  try {
			    imageMetadata = Sanselan.getMetadata(file);
			    if(imageMetadata != null)
			    {
				    item = imageMetadata.getItems().get(0).toString();
				    String x = item.substring(item.indexOf("x")+2,item.indexOf(","));
				    String y = item.substring(item.indexOf("y")+2,item.length());
				   
				    try
				    {
				      hotSpotPoint.x = Integer.parseInt(x);
				      hotSpotPoint.y = Integer.parseInt(y);
				    }
				    catch (NumberFormatException nfe)
				    {
				    	Utils.printMessageOnConsole("NumberFormatException: " + nfe.getMessage());
				    }
			    }
			    else
			    {
			    	  hotSpotPoint.x = -1;
				      hotSpotPoint.y = -1;
			    }
		  }
		  catch (ImageReadException e) {
			  Utils.printMessageOnConsole("Unable to read metadata information from Image: " + e.getMessage());
			  hotSpotPoint.x = -1;
		      hotSpotPoint.y = -1;
			} catch (IOException e) {
				e.printStackTrace();
			}
		 return hotSpotPoint; 
	  }
	
	 //This method is added to read image through Sanselan library
	 public static BufferedImage imageReadFromSanselan(File file) throws ImageReadException, IOException
	{
			 Map<String, ManagedImageBufferedImageFactory> params = new HashMap<String, ManagedImageBufferedImageFactory>();
			
			 // set optional parameters if you like
			 params.put(SanselanConstants.BUFFERED_IMAGE_FACTORY,
			         new ManagedImageBufferedImageFactory());
			
			 BufferedImage image = Sanselan.getBufferedImage(file, params);
			
			 return image;
			}
		
	 //This class helps Sanselan in reading an image
	 public static class ManagedImageBufferedImageFactory implements IBufferedImageFactory
	 {
		 public BufferedImage getColorBufferedImage(int width, int height, boolean hasAlpha)
		 {
		     GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
		     GraphicsDevice gd = ge.getDefaultScreenDevice();
		     GraphicsConfiguration gc = gd.getDefaultConfiguration();
		     return gc.createCompatibleImage(width, height,Transparency.TRANSLUCENT);
		 }
	
		 public BufferedImage getGrayscaleBufferedImage(int width, int height,boolean hasAlpha)
		 {
		     return getColorBufferedImage(width, height, hasAlpha);
		 }
	}
}
