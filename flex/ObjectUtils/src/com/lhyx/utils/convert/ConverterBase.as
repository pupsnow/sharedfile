package com.lhyx.utils.convert
{
	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	
	public class ConverterBase implements IConverter
	{
		public function ConverterBase()
		{
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
	}
}