package com.lhyx.utils.convert.java
{
	import com.lhyx.utils.FileUtils;
	import com.lhyx.utils.convert.ConverterBase;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	
	import mx.utils.StringUtil;
	
	import org.as3commons.lang.ArrayUtils;
	import org.as3commons.lang.IllegalArgumentError;
	import org.as3commons.lang.StringUtils;
	
	public class GenerateJavaPOJO extends ConverterBase
	{
		public function GenerateJavaPOJO()
		{
			super();
		}
		
		override public function generateAsFile(file:File, packageName:String = null, directory:String = null):Boolean
		{
			var flg:Boolean = false;
			
			var fileString:String = null;
			var className:String = null;
			var attributes:Array = null;
			
			try
			{
				if (file) 
				{
					fileString = FileUtils.readFile(file);
					
					if (fileString) 
					{
						// Get package name.
						if (!packageName) 
						{
							packageName = StringUtils.trim(StringUtils.substringBetween(fileString,"package",";"));
							trace("Package name: " + packageName);
						}
						
						// Get class name.
						className = StringUtils.trim(StringUtils.substringBetween(fileString,"public class ","{"));
						trace("Class name: " + className);
						
						// Need to implements how to get object attribute.
					}
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
				
			}
			return flg;
		}
	}
}