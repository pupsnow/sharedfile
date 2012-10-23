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
package com.genie.data;

import java.util.ArrayList;
import java.util.Map;

public class TestSuite {

	private String name = "";
	private String isDisabled = "false";
	
	private ArrayList<Map<String, String> > scripts = null;
	
	public TestSuite()
	{
	}
	
	public void addTestCaseAttr(Map<String, String> mapArg)
	{
		if (this.scripts == null)
			this.scripts = new ArrayList<Map<String,String>>();
		
		this.scripts.add(mapArg);
	}
	public void setName(String nameArg)
	{
		this.name = nameArg;
	}
	public void setDisabled(String isDisabledArg)
	{
		this.isDisabled = isDisabledArg;
	}
	
	public ArrayList<Map<String, String> > getScripts()
	{
		return this.scripts;
	}
	public String isDisabled()
	{
		return this.isDisabled;
	}
	public String getSuiteName()
	{
		return this.name;
	}
}
