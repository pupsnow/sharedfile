package com.lhyx.utils.convert
{
	import com.lhyx.utils.FilePathEnum;
	import com.lhyx.utils.convert.java.GenerateJavaPOJO;

	public class ConverterFactory
	{
		/**
		 * This const value is 'javaPOJOType'.
		 */		
		public static const PRODUCT_TYPE_JAVA_POJO:String = "javaPOJOType.";
		
		public function ConverterFactory()
		{
		}
		
		public static function produce(productType:String):IConverter
		{
			var converter:IConverter = null;
			
			try
			{
				switch(productType)
				{
					case PRODUCT_TYPE_JAVA_POJO:
					{
						converter = new GenerateJavaPOJO(FilePathEnum.JAVA_ATTR_MAPPER_PATH);
						break;
					}
						
					default:
					{
						converter = null;
						break;
					}
				}
			} 
			catch(error:Error) 
			{
				throw error;
			}
			return converter;
		}
	}
}