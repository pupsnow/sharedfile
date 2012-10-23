<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!--
	//========================================================================================
	//  
	//  ADOBE CONFIDENTIAL
	//   
	//  $File: //depot/Genie/PrivateBranch/Piyush/GenieTool/Utils/src/assets/HTMLLog.xsl $
	// 
	//  Owner: Piyush Singhal
	//  
	//  $Author: psinghal $
	//  
	//  $DateTime: 2012/03/30 14:22:17 $
	//  
	//  $Revision: #1 $
	//  
	//  $Change: 5952 $
	//  
	//  Copyright 2010 Adobe Systems Incorporated
	//  All Rights Reserved.
	//  
	//  NOTICE:  All information contained herein is, and remains
	//  the property of Adobe Systems Incorporated and its suppliers,
	//  if any.  The intellectual and technical concepts contained
	//  herein are proprietary to Adobe Systems Incorporated and its
	//  suppliers and are protected by trade secret or copyright law.
	//  Dissemination of this information or reproduction of this material
	//  is strictly forbidden unless prior written permission is obtained
	//  from Adobe Systems Incorporated.
	//  
	//========================================================================================
	-->
	
	<xsl:template match="/">
		<html>
			<head>
				<title>Genie (Code Name) Log : <xsl:value-of select="TestLog/TestCase/TestScript/@name"/></title>
			</head>
			<STYLE type="text/css">P.mypar { text-align: center}</STYLE>
			<body bgcolor="#EBDDE2">
				<table border="0" width="100%">
					<tr width="100%" height="90%">
						<td width="15%" align="center" valign="top">
							<br/>
							<font face="times" size="4">
								<b>
									<xsl:text>Result Log</xsl:text>
								</b>
							</font>
							<br/>
							<br/>
							<img src="GenieImage.png" alt="Genie"/>
						</td>

						<td width="85%" valign="top" align="left">
							<xsl:if test="TestLog/TestSettings">
								<br/>
								<xsl:call-template name="TestSettings">
									<xsl:with-param name="Environment" select="TestLog/TestSettings"/>
								</xsl:call-template>
							</xsl:if>

							<xsl:if test="TestLog/TestCase">
								<font face="times" size="3">
									<b>
										<xsl:text>Test Case Result :</xsl:text>
									</b>
								</font>
								<table border="2" width="100%">
									<xsl:apply-templates select="TestLog/TestCase"/>
								</table>
							</xsl:if>

							<xsl:if test="TestLog/Messages">
								<br/>
								<font face="times" size="3">
									<b>
										<xsl:text>Messages :</xsl:text>
									</b>
								</font>
								<xsl:call-template name="DisplayChildrenAndAttributes">
									<xsl:with-param name="Parent" select="TestLog/Messages"/>
								</xsl:call-template>
							</xsl:if>
						</td>
					</tr>
					<tr width="100%" height="10%" align="center" valign="middle">
						<td align="center" valign="middle">
							<font face="times" size="3">&#xA9; 2011 Adobe Systems Inc.</font>
						</td>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="TestSettings">
		<xsl:param name="Environment"/>
		<font face="times" size="3">
			<b>
				<xsl:text>Environment of Execution :</xsl:text>
			</b>
		</font>
		<a onclick="javascript:document.getElementById('{generate-id($Environment)}').style.display=(document.getElementById('{generate-id($Environment)}').style.display== 'block')?'none':'block';"
		   onmouseover="javascript:document.body.style.cursor = 'hand'" onmouseout="javascript:document.body.style.cursor = 'default'">

			<font size="2" color="#0000FF" face="times">
				<i>
					<u>Show/Hide Execution Environment</u>
				</i>
			</font>
		</a>
		<div id="{generate-id($Environment)}" style="display:none">

			<table border="2" width="100%" cellpadding="0" cellspacing="0">
				<tr align="center" valign="middle">
					<td align="center" valign="middle" width="25%">
						<xsl:call-template name="DisplayAttributes">
							<xsl:with-param name="Parent" select="$Environment/TestEnvironment/TestMachine"/>
						</xsl:call-template>
					</td>
					<td align="center" valign="middle" width="25%">
						<xsl:call-template name="DisplayAttributes">
							<xsl:with-param name="Parent" select="$Environment/TestEnvironment/TestMachine/TestSetup"/>
						</xsl:call-template>
					</td>
					<td align="center" valign="middle" width="25%">
						<xsl:call-template name="DisplayChilds">
							<xsl:with-param name="Parent" select="$Environment/TestEnvironment/GenieVersionInfo"/>
						</xsl:call-template>
					</td>

					<td align="center" valign="middle" width="25%">
						<xsl:call-template name="DisplayAttributes">
							<xsl:with-param name="Parent" select="$Environment/TestEnvironment/TestMachine/JavaSetup"/>
						</xsl:call-template>
					</td>
				</tr>
			</table>
			<xsl:if test="$Environment/TestTarget/TestApplication">
				<xsl:for-each select="$Environment/TestTarget/TestApplication/self::*">
					<table border="2" width="100%" cellpadding="0" cellspacing="0">
						<tr align="center" valign="middle">
							<td align="center" valign="middle" width="25%">
								<xsl:call-template name="DisplayAttributes">
									<xsl:with-param name="Parent" select="self::*/Product"/>
								</xsl:call-template>
							</td>
							<td align="center" valign="middle" width="25%">
								<xsl:call-template name="DisplayAttributes">
									<xsl:with-param name="Parent" select="self::*/FlashPlayer"/>
								</xsl:call-template>
							</td>
							<xsl:if test="self::*/DeviceAttributes">
								<td align="center" valign="middle" width="25%">
									<xsl:call-template name="DisplayAttributes">
										<xsl:with-param name="Parent" select="self::*/DeviceAttributes"/>
									</xsl:call-template>
								</td>
							</xsl:if>
							<xsl:if test="self::*/DeviceIdentifiers">
								<td align="center" valign="middle" width="25%">
									<xsl:call-template name="DisplayAttributes">
										<xsl:with-param name="Parent" select="self::*/DeviceIdentifiers"/>
									</xsl:call-template>
								</td>
							</xsl:if>
						</tr>
					</table>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="$Environment/TestTarget/TestDevice">
				<xsl:for-each select="$Environment/TestTarget/TestDevice/self::*">
					<table border="2" width="100%" cellpadding="0" cellspacing="0">
						<tr align="center" valign="middle">
							<xsl:if test="self::*/DeviceAttributes">
								<td align="center" valign="middle" width="50%">
									<xsl:call-template name="DisplayAttributes">
										<xsl:with-param name="Parent" select="self::*/DeviceAttributes"/>
									</xsl:call-template>
								</td>
							</xsl:if>
							<xsl:if test="self::*/DeviceIdentifiers">
								<td align="center" valign="middle" width="50%">
									<xsl:call-template name="DisplayAttributes">
										<xsl:with-param name="Parent" select="self::*/DeviceIdentifiers"/>
									</xsl:call-template>
								</td>
							</xsl:if>
						</tr>
					</table>
				</xsl:for-each>
			</xsl:if>
		</div>
		<br/>
		<br/>
	</xsl:template>

	<xsl:template match="TestCase">
		<xsl:apply-templates select="TestScript"/>
	</xsl:template>


	<xsl:template match="TestScript">
		<tr align="left" valign="middle">
			<td align="center" valign="middle">
				<b>
					<font face="times" size="3">
						<xsl:value-of select="@name"/>
					</font>
				</b>
				<br/>
				<br/>
				<xsl:call-template name="ShowChildrenAndAttributes">
					<xsl:with-param name="Parent" select="TestResults"/>
				</xsl:call-template>
			</td>

			<td align="center" valign="middle">
				<table border="1" width="100%" cellpadding="1%" cellspacing="1%">
					<xsl:apply-templates select="TestStep"/>
				</table>
			</td>

			<xsl:call-template name="ShowResults">
				<xsl:with-param name="TestResults" select="TestResults"/>
			</xsl:call-template>
		</tr>
	</xsl:template>

	<xsl:template match="TestStep">
		<tr align="center" valign="middle" width="100%">
			<xsl:if test="count(TestScript)=0">
				<td align="center" valign="middle">
					<font face="times" size="3">
						<b>
							<i>
								<xsl:value-of select="@name"/>
							</i>
						</b>
					</font>
				</td>
				<td align="center" valign="middle">
					<font face="times" size="2">
						<i>Step Type:
							<xsl:value-of select="@type"/>
						</i>
					</font>
				</td>
				<td align="center" valign="middle">
					<xsl:call-template name="ShowChildrenAndAttributes">
						<xsl:with-param name="Parent" select="."/>
					</xsl:call-template>
				</td>
				<td align="center" valign="middle">
					<xsl:call-template name="ShowResults">
						<xsl:with-param name="TestResults" select="TestResults"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>


	<xsl:template name="ShowResults">
		<xsl:param name="TestResults"/>
		<xsl:choose>
			<xsl:when test="$TestResults[contains(@status, 'Failed')]">
				<td bgcolor="#FF0000" valign="middle" align="center">
					<font face="times" size="3">
						<b>
							<i>
								<xsl:value-of select="$TestResults/@status"/>
							</i>
						</b>
					</font>
				</td>
			</xsl:when>

			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$TestResults[contains(@status, 'Passed')]">
						<td bgcolor="#008B00" valign="middle" align="center">
							<font face="times" size="3">
								<b>
									<i>
										<xsl:value-of select="$TestResults/@status"/>
									</i>
								</b>
							</font>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td bgcolor="#92C7C7" valign="middle" align="center">
							<font face="times" size="3">
								<b>
									<i>No Result</i>
								</b>
							</font>
						</td>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="ShowChildrenAndAttributes">
		<xsl:param name="Parent"/>

		<xsl:variable name="hasElements">
			<xsl:for-each select="$Parent/descendant::*">
				<xsl:if test="not(name()='TestResults')">
					<xsl:copy-of select="name()"/>
					<xsl:for-each select="attribute::*">
						<xsl:if test="(name()='message')">
							<xsl:value-of select="."/>
						</xsl:if>
						<xsl:if test="not(name()='message')">
							<xsl:copy-of select="name()"/>
							<xsl:value-of select="."/>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>


		<xsl:if test="not(string-length($hasElements)='0')">
			<a onclick="javascript:document.getElementById('{generate-id($Parent)}').style.display=(document.getElementById('{generate-id($Parent)}').style.display== 'block')?'none':'block';" onmouseover="javascript:document.body.style.cursor = 'hand'"
			   onmouseout="javascript:document.body.style.cursor = 'default'">
				<font size="2" color="#0000FF" face="times">
					<i>
						<u>Show/Hide Details</u>
					</i>
				</font>
			</a>
			<div id="{generate-id($Parent)}" style="display:none">
				<table cellspacing="3%" border="0" cellpadding="3%" width="100%">
					<xsl:for-each select="$Parent/descendant::*">
						<!-- There's Special Handling for TestResults in the ShowResults template -->
						<xsl:if test="not(name()='TestResults')">
							<tr align="center" valign="middle">
								<td align="center" valign="middle" width="30%">
									<font face="times" size="2">
										<b>
											<xsl:copy-of select="name()"/>
										</b>
									</font>
								</td>

								<td align="left" valign="middle" width="70%">
									<font size="2" face="times">
										<xsl:for-each select="attribute::*">
											<xsl:if test="(name()='message')">
												<xsl:value-of select="."/>
											</xsl:if>
											<xsl:if test="not(name()='message')">
												<i>
													<xsl:copy-of select="name()"/>:</i>
												<xsl:value-of select="."/>
											</xsl:if>
											<br/>
										</xsl:for-each>
									</font>
								</td>
							</tr>
						</xsl:if>
					</xsl:for-each>
				</table>
			</div>
		</xsl:if>
		<xsl:if test="(string-length($hasElements)='0')">
			<font face="times" size="2">No Details Available</font>
		</xsl:if>
	</xsl:template>

	<xsl:template name="DisplayChildrenAndAttributes">
		<xsl:param name="Parent"/>
		<table cellspacing="3%" border="0" cellpadding="3%" width="100%">
			<xsl:for-each select="$Parent/descendant::*">
				<!-- There's Special Handling for TestResults in the ShowResults template -->
				<xsl:if test="not(name()='TestResults')">
					<tr align="center" valign="middle">
						<td align="center" valign="middle" width="30%">
							<font face="times" size="2">
								<b>
									<xsl:copy-of select="name()"/>
								</b>
							</font>
						</td>

						<td align="left" valign="middle" width="70%">
							<font size="2" face="times" color="#7E2217">
								<xsl:for-each select="attribute::*">
									<xsl:if test="(name()='message')">
										<xsl:value-of select="."/>
									</xsl:if>
									<xsl:if test="not(name()='message')">
										<i>
											<xsl:copy-of select="name()"/>:</i>
										<xsl:value-of select="."/>
									</xsl:if>
									<br/>
								</xsl:for-each>
							</font>
						</td>
					</tr>
				</xsl:if>
			</xsl:for-each>
		</table>
	</xsl:template>

	<xsl:template name="DisplayAttributes">
		<xsl:param name="Parent"/>
		<table cellspacing="3%" border="0" cellpadding="3%" width="100%">
			<xsl:for-each select="$Parent/self::*">
				<tr align="center" valign="middle">
					<td align="center">
						<font face="times" size="2">
							<b>
								<xsl:copy-of select="name()"/>
							</b>
						</font>
					</td>
					<td align="left">
						<font face="times" size="2">
							<xsl:for-each select="attribute::*">
								<i>
									<xsl:copy-of select="name()"/>:</i>
								<xsl:value-of select="."/>
								<br/>
								<br/>
							</xsl:for-each>
						</font>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>

	<xsl:template name="DisplayChilds">
		<xsl:param name="Parent"/>
		<table cellspacing="3%" border="0" cellpadding="3%" width="100%">
			<tr align="center" valign="middle">
				<td align="center">
					<font face="times" size="2">
						<b>GenieVersion</b>
					</font>
				</td>
				<td align="left">
					<xsl:for-each select="$Parent/descendant::*">
						<font face="times" size="2">
							<i>
								<xsl:copy-of select="name()"/>:</i>
							<xsl:value-of select="."/>
						</font>
						<br/>
						<br/>
					</xsl:for-each>
				</td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>