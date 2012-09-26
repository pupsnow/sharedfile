package com.lhyx.utils.convert
{
	import com.common.utils.HashMap;
	import com.lhyx.utils.FileUtils;
	
	import flash.errors.EOFError;
	import flash.errors.IOError;
	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	
	import org.as3commons.lang.IllegalArgumentError;
	
	public class ConverterBase implements IConverter
	{
		protected var _mapperMap:HashMap;
		
		public function ConverterBase(path:String)
		{
			this.getClassType(File.applicationDirectory.resolvePath(path));
		}
		
		public function repeat(repeatString:String, count:int):String
		{
			var result:String = "";
			
			try
			{
				for (var i:int = 0; i < count; i++) 
				{
					result += repeatString;
				}
			} 
			catch(error:Error) 
			{
				throw error;
			}
			return result;
		}
		
		public function generateAsFile(file:File, packageName:String = null, directory:String = null):Boolean
		{
			throw new IllegalOperationError("Abstract method can not be called directly.");
		}
		
		private function getClassType(file:File):String
		{
			var resultStr:String = null;
			var mapperString:String = null;
			var dateArray:Array = null;
			
			try
			{
				if (file) 
				{
					mapperString = FileUtils.readFileByMultiByte(file);
					
					if (mapperString) 
					{
						_mapperMap = new HashMap();
						
						dateArray = mapperString.split("\r\n");
						
						for (var i:uint = 0;i < dateArray.length;i++)
						{
							var str:String = dateArray[i];
							var index:uint = dateArray[i].indexOf("=");
							_mapperMap.put(str.substring(0,index),str.substring(index + 1,str.length));
						}
//						var keys:Array = mapFunction.keys;
						
//						for (var j:uint = 0;j < keys.length;j++)
//						{
//							var myfunction:Function = mapFunction.getValue(keys[j])as Function;
//							myfunction(map.getValue(keys[j]));
//						}
					}
				}
				else
				{
					throw new IllegalArgumentError("The argument 'file' can't is null.");
				}
			}
			catch(ioError:IOError)
			{
				throw ioError;
			}
			catch(eofError:EOFError)
			{
				throw eofError;
			}
			catch(error:Error) 
			{
				throw error;
			}
			return resultStr;
		}
		
	}
}