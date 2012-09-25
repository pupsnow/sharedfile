package com.lhyx.utils.convert.java
{
	import com.lhyx.utils.FileUtils;
	import com.lhyx.utils.convert.ConverterBase;
	
	import flash.filesystem.File;
	
	import mx.utils.StringUtil;
	
	import org.as3commons.lang.StringUtils;
	
	public class GenerateJavaPOJO extends ConverterBase
	{
		public function GenerateJavaPOJO()
		{
			super();
		}
		
		override public function generateAsFile(file:File, packageName:String = null, directory:String = File.desktopDirectory.url):Boolean
		{
			var flg:Boolean = false;
			var fileString:String = null;
			var className:String = null;
			
			try
			{
				if (file) 
				{
					fileString = FileUtils.readFile(file);
					
					if (fileString) 
					{
					}
				}
			} 
			catch(error:Error) 
			{
				throw error;
			}
			return flg;
		}
	}
}