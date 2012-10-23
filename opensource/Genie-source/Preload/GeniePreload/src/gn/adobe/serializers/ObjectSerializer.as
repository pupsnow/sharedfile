//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================

package gn.adobe.serializers {
	import flash.utils.describeType;
	
	
	public class ObjectSerializer {
		
		public static function serialize(obj:Object):String {
			var ret:String = "<Object>";
			//Get Properties of Pre-Defined Objects
			var props:XMLList = describeType(obj).variable;
			for(var i:int=0; i<props.length(); i++) {
				var name:String = String(props[i].@name);
				ret += "<"+name+">"+Serializers.serialize(obj[name])+"</"+name+">";
			}
			//Get Dynamic Properties
			for(var s:String in obj) {
				ret += "<"+s+">"+Serializers.serialize(obj[s])+"</"+s+">";
			}
			ret += "</Object>";
			return ret;
		}
		
		public static function deserialize(obj:String):Object {
			if(obj!="") {
				var ret:Object = new Object();
				obj = "<Object>"+obj+"</Object>";
				var obj_xml:XML = new XML(obj);
				var objItems:XMLList = obj_xml.children();
				for(var i:int=0; i<objItems.length(); i++) {
					var prop:String = String((objItems[i] as XML).localName());
					var children:XMLList = objItems[i].children();
					ret.setPropertyIsEnumerable(prop,true);
					ret[prop] = Serializers.deserialize((children[0] as XML));
				}
				return ret;
			} else {
				return null;
			}
		}
		
		public static function serializeProperties(obj:Object):String {
			var ret:String = " ";
			var classInfo:XML = describeType(obj);
			for each (var a:XML in classInfo..accessor) 
			{
				ret +="Property " + a.@name + "=" +	obj[a.@name] +  " (" + a.@type +") ";
			} 
			ret += " ";
			return ret;
		}
	}
}