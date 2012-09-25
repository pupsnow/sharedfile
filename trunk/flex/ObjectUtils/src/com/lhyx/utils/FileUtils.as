package com.lhyx.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.as3commons.lang.IllegalArgumentError;

	public class FileUtils
	{
		public function FileUtils()
		{
		}
		
		public static function readFile(file:File):String
		{
			var fileStream:FileStream = null;
			var resultStr:String = null;
			
			try
			{
				if (file) 
				{
					fileStream = new FileStream();
					fileStream.open(file,FileMode.READ);
					resultStr = fileStream.readMultiByte(file.size,File.systemCharset);
				}
				else
				{
					throw new IllegalArgumentError("The argument 'file' can't is null.");
				}
			} 
			catch(error:Error) 
			{
				throw error;
			}
			finally
			{
				if (fileStream) 
				{
					fileStream.close();
				}
			}
			return resultStr;
		}
		
		public static function writeFile(file:File,content:String):Boolean
		{
			var fileStream:FileStream = null;
			var flg:Boolean = false;
			
			try
			{
				if (file) 
				{
					fileStream = new FileStream();
					fileStream.open(file,FileMode.WRITE);
					fileStream.writeMultiByte(content,File.systemCharset);
					flg = true;
				}
				else
				{
					throw new IllegalArgumentError("The argument 'file' can't is null.");
				}
			} 
			catch(error:Error) 
			{
				throw error;
			}
			finally
			{
				if (fileStream) 
				{
					fileStream.close();
				}
			}
			return flg;
		}
	}
}