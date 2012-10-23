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

import java.util.ArrayList;

/**
 * This singleton class contains list of SWFApp instance.
 * Use this class to get currently connected SWF applications. 
 */
public class SWFList<E> extends ArrayList<E>{
	 /**
	  * Generated Serial version UID
	  */
	  private static final long serialVersionUID = 3339392176301528238L;
	
	  private static SWFList<?> instance = null;
	
	 /**
	  * Return instance of SWFList
	  */
	  @SuppressWarnings("unchecked")
	  public static SWFList getInstance(){
	     if(instance == null) {
	        instance = new SWFList();
	     }
	     return instance;
	  }
	
	 /**
	  * Disconnect all SWF currently present in SWF List
	  */
	  public void disconnectAllSWFS(){
		  for(int i =0; i <this.size(); ++i){
			  E app = get(i);
			  if( app instanceof SWFApp){
				  SWFApp newApp = (SWFApp) app;
					  newApp.disconnect();
			  }
		  }
	  }
	  
	 /**
	  * Call connect method of all currently connected SWF
	  * This will again call the getAPPXML method on each SWF
	  */
	  public void refreshConnectedSWFs(){
		  for(int i =0; i <size(); ++i){
			  E app = get(i);
			  if( app instanceof SWFApp){
				  SWFApp newApp = (SWFApp) app;
				  if(newApp.isConnected){
					  newApp.connect();
				  }
			  }
		  }
	  }
	
	 /**
	  * Disconnect a particular SWF
	  * 
	  * @param appName
	  * 		name of SWF to be disconnected
	  */
	  public void disconnectSWF(String appName){
		for(int i =0; i <size(); ++i){
			E app = get(i);
			if( app instanceof SWFApp){
				SWFApp newApp = (SWFApp) app;
				if(newApp.name.equalsIgnoreCase(appName)){
					if(newApp.isConnected){
						newApp.disconnect();
					}
				}
			}
		}
	  }
	
	 /**
	  * Get a SWF object of a SWF based on its name from the SWFList
	  * 
	  * @param appName
	  * 		Name of SWF
	  * @return
	  * 		SWFApp Object
	  */
	  public E getSWF(String appName){
		for(int i =0; i <size(); ++i){
			E app = get(i);
			if( app instanceof SWFApp){
				SWFApp newApp = (SWFApp) app;
				if(newApp.name.equals(appName)){
					return app;
				}
			}
		}
		return null;
	  }
}
