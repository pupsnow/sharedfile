//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================

package gn.adobe.genie
{
	import flash.utils.getQualifiedClassName;
	
	import gn.adobe.logging.GenieLogConst;
	import gn.adobe.logging.IGenieLog;

	public class GamesGenieIDFunctions extends CommandsMain
	{
		protected var objCommands:CommandsMain;
		private var objLog:IGenieLog;
		
		public function GamesGenieIDFunctions(rootObject:Object, strApplicationName:String)
		{
			super(rootObject, strApplicationName); 
			objLog = GenieMix.genieLog;
		}
		
		public function helpCreateIDPartForSpecialComponents(parent:Object,child:Object, strGameParentGenieID:String):String
		{
			var strClassName:String = "";
			var strParentClassName:String = "";
			var strCreateGenieID:String = "";
			var strChildID:String = "";
			var nRecursive:int = 0;
			var iIndex:int = 0;
			var pattern:RegExp = /\d+/;
			var pattern2:RegExp = /[0-9]+[_]/;			
			var objGameParent:Object = parent;

			if(child == null)
				return "";
			else
			{
				strClassName = getQualifiedClassName(child);
				strParentClassName = getQualifiedClassName(objGameParent);
			}
			
			//Changes done for Sprite and MovieClip GenieID handling
			var strTempSpecialGenieID:String = "";
			var arrParSplit:Array = new Array();
			var arrIndexSplit:Array = new Array();
			var i:int = 0;
			var bGenieIDExists:Boolean = false;
			
			try
			{
					strTempSpecialGenieID = getGenieIDForSpecialComponents(objGameParent, child);
					strTempSpecialGenieID = strTempSpecialGenieID.replace(pattern2, "");
					strTempSpecialGenieID = strTempSpecialGenieID.replace(pattern, "");
					
					if(strGameParentGenieID != null && strGameParentGenieID != "")
					{
						//Check for Index for parent first
						if(strGameParentGenieID.indexOf("IX^") > -1)
						{
							arrParSplit = strGameParentGenieID.split("IX^");
							arrIndexSplit = arrParSplit[1].toString().split("::");
							strTempSpecialGenieID = strTempSpecialGenieID + "::PX^" + arrIndexSplit[0].toString();
						}
						
						//Check for ITR of parent now
						arrParSplit = strGameParentGenieID.split("ITR^");
						strTempSpecialGenieID = strTempSpecialGenieID + "::PTR^" + arrParSplit[1].toString();
					}
					//get the index of the child within the parent
					try
					{
						iIndex = getChildIndex(objGameParent, child);
						
						//create the GenieID with static ITR of 0 and if that exists than keep on increasing the ITR
						strTempSpecialGenieID = strTempSpecialGenieID + "::IX^" + iIndex.toString();
					}
					catch(e:Error)
					{
						objLog.detailedTrace(GenieLogConst.ERROR, "function helpCreateIDPartForSpecialComponents: "+e.message);
					}
					
					strCreateGenieID = strTempSpecialGenieID;
					strTempSpecialGenieID = strTempSpecialGenieID + "::ITR^0";
					
					if(objectArray[strTempSpecialGenieID])
					{
						i = 1;
						bGenieIDExists = true;
						while(bGenieIDExists)
						{
							strTempSpecialGenieID = strCreateGenieID;
							strTempSpecialGenieID = strTempSpecialGenieID + "::ITR^" + i.toString();
							if(objectArray[strTempSpecialGenieID] == null)
								bGenieIDExists = false;
							i++;
						}
					}
					
					strCreateGenieID = strTempSpecialGenieID;
			}
			catch(e:Error)
			{
				objLog.detailedTrace(GenieLogConst.ERROR, "function helpCreateIDPartForSpecialComponents: "+e.message);
			}

			return strCreateGenieID;
		}

		override public function getChildIndex(parent:Object,child:Object):int
		{
			var childNumber:int = 0;
			if (parent != null)
			{
				try{
					childNumber = parent.getChildIndex(child);
					if(childNumber > -1)
						return childNumber;
				}
				catch(e:Error)
				{
					objLog.traceLog(GenieLogConst.ERROR, "function getChildIndex: "+e.message);	
				}
				if(childNumber == -1)
				{
					var parentsChildren:Array = getChildren(parent); 
				
					for (var childNo:int = 0; childNo < parentsChildren.length; ++childNo)
					{
						var obj:Object = parentsChildren[childNo];
						if(getChildEligibility(obj))
						{
							childNumber ++;
							if (child == parentsChildren[childNo])
								return childNumber;
						}
					}
				}
				
			}
			
			return -1;
		}
	}
}