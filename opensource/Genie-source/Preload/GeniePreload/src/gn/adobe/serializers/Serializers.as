//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================

package gn.adobe.serializers {
	import flash.display.DisplayObject;
	import flash.utils.escapeMultiByte;
	import flash.utils.getQualifiedClassName;
	import flash.utils.unescapeMultiByte;
	
	
	[Mixin]
	public class Serializers {
		
		private var serializerList:Array;
		
		private static var instance:Serializers;
		
		public static function init(obj:DisplayObject):void {
			instance = new Serializers();
		}
		
		public static function getInstance():Serializers {
			if(!instance){
				instance = new Serializers();
			}
			return instance;
		}
		
		public function Serializers() {
			serializerList = new Array();
			serializerList["String"] = StringSerializer;
			serializerList["Boolean"] = BooleanSerializer;
			serializerList["int"] = IntSerializer;
			serializerList["Number"] = NumberSerializer;
			serializerList["XML"] = XMLSerializer;
			serializerList["Array"] = ArraySerializer;
			serializerList["Object"] = ObjectSerializer;
			serializerList["Point"]= PointSerializer;
		}
		
		public function getSerializer(name:String):Class {
			if(serializerList[name]!=null)
				return serializerList[name];
			else
				return serializerList["Object"];
		}
		
		private static function getSimpleClassName(obj:Object):String {
			var className:String = getQualifiedClassName(obj);
			var i:int = className.lastIndexOf("::");
			if(i >=0) {
				return className.substring(i + 2);
			}
			return className;
		}
		
		public static function serialize(obj:Object,escape:Boolean=false):String 
		{
			var ret:String;
			if(obj!=null)
				ret = Serializers.getInstance().getSerializer(getSimpleClassName(obj)).serialize(obj);
			else
				ret = "<null/>";
			if(escape)
				return escapeMultiByte(ret);
			else
				return ret;
		}
		
		public static function deserialize(obj:Object, escape:Boolean=false):*
		{
			if(obj is String && escape)
				obj = new XML(unescapeMultiByte(String(obj)));
			if(obj is XML) {
				if(obj!=null && String(obj.localName()).toLowerCase()!="null")
				{
					var strLocalName:String = obj.localName().toString();	
					if(String(obj.localName()).toLowerCase()=="xml")
						return getInstance().getSerializer(strLocalName).deserialize("<XML>"+obj.children().toXMLString()+"</XML>");
					else
						return getInstance().getSerializer(strLocalName).deserialize(obj.children().toXMLString());
				}
				else
					return null;
			} else
				return null;
		}

	}
}