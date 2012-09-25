package com.lhyx.utils.convert
{
	import flash.filesystem.File;

	public interface IConverter
	{
		/**
		 * Repeated a certain number of times specified string.
		 * @param repeatString The need for repeat string.
		 * @param count The need for repeat count.
		 * @return Result string.
		 * 
		 */		
		function repeat(repeatString:String,count:int):String;
		
		/**
		 * Generate ActionScript file.
		 * @param file Need to generated file.
		 * @param packageName ActionScript class package name.
		 * @param directory Output file directory.
		 * @return Whether to generate success.
		 * 
		 */		
		function generateAsFile(file:File,packageName:String = null,directory:String = null):Boolean;
	}
}