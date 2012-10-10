package com.lhyx.utils.convert.java
{
	import com.lhyx.utils.FileUtils;
	import com.lhyx.utils.convert.ConverterBase;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	
	import mx.utils.StringUtil;
	
	import org.as3commons.lang.ArrayUtils;
	import org.as3commons.lang.IllegalArgumentError;
	import org.as3commons.lang.StringBuffer;
	import org.as3commons.lang.StringUtils;
	
	public class GenerateJavaPOJO extends ConverterBase
	{
		public function GenerateJavaPOJO(path:String)
		{
			super(path);
		}
		
		override public function generateAsFile(file:File, packageName:String = null, directory:String = null):Boolean
		{
			var flg:Boolean = false;
			
			var asClassStr:StringBuffer = null;
			var asFile:File = null;
			
			var fileString:String = null;
			var className:String = null;
			var attributes:Array = null;
			var attrTempStr:String = null;
			var packageNameStr:String = null;
			
			try
			{
				if (file) 
				{
					fileString = FileUtils.readFileByMultiByte(file);
					
					if (fileString) 
					{
						// Get package name.
						packageNameStr = StringUtils.trim(StringUtils.substringBetween(fileString,"package",";"));
						
						if (!packageName) 
						{
							packageName = packageNameStr;
							trace("Package name: " + packageName);
						}
						
						// Get class name.
						className = StringUtils.trim(StringUtils.substringBetween(fileString,"public class ","{"));
						trace("Class name: " + className);
						
						// Need to implements how to get object attribute.
						attrTempStr = StringUtils.substringBetween(fileString,("public class " + className + " {"),("public " + className));
						trace("Attribute temp string: \n" + attrTempStr);
						
						if (attrTempStr) 
						{
							attributes = attrTempStr.split(";");
							
							if (attributes) 
							{
								for (var i:int = 0; i < attributes.length; i++) 
								{
									if (StringUtils.trim(attributes[i])) 
									{
										attributes[i] = StringUtils.trim(attributes[i]);
									}
									else
									{
										ArrayUtils.removeLastOccurance(attributes,attributes[i]);
									}
									trace("Attribute" + (i + 1) + ": " + attributes[i]);
									trace("Attribute array length: " + attributes.length);
								}
								
								
							}
						}
						
						if (!directory) 
						{
							directory = File.desktopDirectory.resolvePath((className + ".as")).url;
						}
						else
						{
							directory += File.separator + className + ".as";
						}
						
						if (className && packageName && attributes) 
						{
							asFile = new File(directory);
							asClassStr = new StringBuffer();
							
							// Write packge name.
							asClassStr.append("package " + packageName + "\n{\n");
							
							// Write RemoteClass metadata
							asClassStr.append(super.repeat(" ",4) + "[RemoteClass(alias=\"" + packageNameStr + "." + className + "\")]\n");
							
							// Write Bindable metadata.
							asClassStr.append(super.repeat(" ",4) + "[Bindable]\n");
							
							// Write class.
							asClassStr.append(super.repeat(" ",4) + "public class " + className + "\n");
							asClassStr.append(super.repeat(" ",4) + "{\n");
							
							// Write attribute.
							for (var j:int = 0; j < attributes.length; j++) 
							{
								var attr:String = attributes[j];
								var temp:Array = attr.split(" ");
								var typeName:String = super._mapperMap.getValue(temp[1]);
								
								if ("Logger" !== typeName) 
								{
									asClassStr.append(super.repeat(" ",8) + "private var _" + temp[2] + ":" + typeName + ";\n");
								}
							}
							asClassStr.append("\n");
							
							// Write empty constructor.
							asClassStr.append(super.repeat(" ",8) + "public function " + className + "()\n" + super.repeat(" ",8) +"{\n" + super.repeat(" ",8) + "}\n\n");
							
							// Write setter/getter method.
							for (var k:int = 0; k < attributes.length; k++) 
							{
								var attrM:String = attributes[k];
								var tempM:Array = attrM.split(" ");
								var typeNameM:String = super._mapperMap.getValue(tempM[1]);
								
								if ("Logger" !== typeName) 
								{
									// setter
									asClassStr.append(super.repeat(" ",8) + "public function set " + tempM[2] + "(value:" + typeNameM + "):void\n" + super.repeat(" ",8) + "{\n");
									asClassStr.append(super.repeat(" ",12) + "this._" + tempM[2] + " = value;\n");
									asClassStr.append(super.repeat(" ",8) + "}\n\n");
									// getter
									asClassStr.append(super.repeat(" ",8) + "public function get " + tempM[2] + "(value:" + typeNameM + "):void\n" + super.repeat(" ",8) + "{\n");
									asClassStr.append(super.repeat(" ",12) + "return this._" + tempM[2] + ";\n");
									asClassStr.append(super.repeat(" ",8) + "}\n\n");
								}
							}
							asClassStr.append(super.repeat(" ",4) + "}\n");
							asClassStr.append("}");
							
							FileUtils.writeFileByMultiByte(asFile,asClassStr.toString());
						}
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
			return flg;
		}
	}
}