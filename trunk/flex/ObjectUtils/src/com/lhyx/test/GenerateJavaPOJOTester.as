package com.lhyx.test
{
	import com.lhyx.utils.FilePathEnum;
	import com.lhyx.utils.convert.IConverter;
	import com.lhyx.utils.convert.java.GenerateJavaPOJO;
	
	import flash.filesystem.File;
	
	import flexunit.framework.Assert;
	
	public class GenerateJavaPOJOTester
	{
		private const TEST_FILE_PATH:String = "Tick(No Comments).java";
		
		private var _converter:IConverter;
		private var _testFile:File;
		
		[Before]
		public function setUp():void
		{
			try
			{
				this._converter = new GenerateJavaPOJO(FilePathEnum.JAVA_ATTR_MAPPER_PATH);
				this._testFile = File.desktopDirectory.resolvePath(this.TEST_FILE_PATH);
			} 
			catch(error:Error) 
			{
				Assert.fail(error.toString());
			}
		}
		
		/*[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}*/
		
		[Test]
		public function testGenerateAsFile():void
		{
			try
			{
				trace("Current test file path is '" + this._testFile.url + "'.\n");
				Assert.assertTrue(this._converter.generateAsFile(this._testFile));
			} 
			catch(error:Error) 
			{
				Assert.fail(error.toString());
			}
		}
	}
}