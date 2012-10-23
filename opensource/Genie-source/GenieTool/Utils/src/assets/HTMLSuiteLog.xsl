<?xml version="1.0"?>
<!DOCTYPE some_name [
<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!--
	//========================================================================================
	//  
	//  ADOBE CONFIDENTIAL
	//   
	//  $File: //depot/Genie/PrivateBranch/Piyush/GenieTool/Utils/src/assets/HTMLSuiteLog.xsl $
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
				<title>Genie (Code Name) Suite Log : <xsl:value-of select="TestSuiteLog/@name"/></title>
			</head>
			<body bgcolor="#FFFFCC">
				<table border="0" width="100%">
					<tr width="100%" height="90%">
						<td width="15%" align="center" valign="top">
							<br/>
							<font face="times" size="5">
								<b>
									<xsl:text>Suite Log</xsl:text>
								</b>
							</font>
							<br/>
							<br/>
							<!--<style type="text/css">body 
									{
										background-image:url('GenieImage.png');
										background-repeat:no-repeat;
										background-attachment:fixed;
									}
							</style>-->
							<img src="GenieImage.png" alt="Genie" align="center"/>
						</td>

						<td width="85%" valign="top" align="left">
							<xsl:if test="TestSuiteLog/SuiteSettings">
								<br/>
								<xsl:call-template name="SuiteSettings">
									<xsl:with-param name="Environment" select="TestSuiteLog/SuiteSettings"/>
								</xsl:call-template>
							</xsl:if>

							<xsl:if test="TestSuiteLog/Suite">
								<font face="times" size="3">
									<b>
										<xsl:text>Test Suite Result :</xsl:text>
									</b>
								</font>
								<table border="2" width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td>
											<table border="2" width="100%" cellpadding="0" cellspacing="0">
												<th>Suite Name</th>
												<th>Script level details</th>
												<th>Suite result</th>

												<xsl:apply-templates select="TestSuiteLog/Suite"/>
											</table>
										</td>
										<td>
											<xsl:call-template name="ShowSuiteResults">
												<xsl:with-param name="SuiteResults" select="TestSuiteLog/SuiteResult"/>
											</xsl:call-template>
										</td>
									</tr>
								</table>
							</xsl:if>

							<xsl:if test="TestSuiteLog/Messages">
								<br/>
								<font face="times" size="3">
									<b>
										<xsl:text>Messages :</xsl:text>
									</b>
								</font>
								<table border="2" width="100%">
									<xsl:call-template name="DisplayChildrenAndAttributes">
										<xsl:with-param name="Parent" select="TestSuiteLog/Messages"/>
									</xsl:call-template>
								</table>
							</xsl:if>

							<xsl:if test="TestSuiteLog/Suite/TestNode">
								<br/>
								<font face="times" size="3">
									<b>
										<xsl:text>Script level Execution Details :</xsl:text>
									</b>
								</font>

								<xsl:for-each select="TestSuiteLog/Suite/TestNode/self::*">
									<br/>
									<br/>
									<font face="times" size="3">
										<b>
											<xsl:text>Test Script: </xsl:text>
											<a>
												<xsl:attribute name="id">
													<xsl:value-of select="@name"/>
												</xsl:attribute>
												<xsl:value-of select="@name"/>
											</a>
										</b>
									</font>
									<br/>
									<br/>
									<table border="2" width="100%">

										<xsl:if test="TestSettings">
											<tr align="left" valign="middle">
												<td>
													<br/>
													<xsl:call-template name="TestSettings">
														<xsl:with-param name="Environment" select="TestSettings"/>
													</xsl:call-template>
												</td>
											</tr>
										</xsl:if>



										<xsl:if test="TestCase">
											<tr align="left" valign="middle">
												<td>
													<font face="times" size="3">
														<b>
															<xsl:text>Test Case Result :</xsl:text>
														</b>
													</font>
													<table border="2" width="100%">
														<xsl:apply-templates select="TestCase"/>
													</table>
												</td>
											</tr>
										</xsl:if>


										<xsl:if test="Messages">
											<tr align="left" valign="middle">
												<td>
													<br/>
													<font face="times" size="3">
														<b>
															<xsl:text>Messages :</xsl:text>
														</b>
													</font>

													<xsl:call-template name="DisplayChildrenAndAttributes">
														<xsl:with-param name="Parent" select="Messages"/>
													</xsl:call-template>
												</td>
											</tr>
										</xsl:if>
									</table>
								</xsl:for-each>
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

	<!-- Display Suite Settings/Environment -->
	<xsl:template name="SuiteSettings">
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
					<td align="center" valign="middle">
						<xsl:call-template name="DisplayAttributes">
							<xsl:with-param name="Parent" select="$Environment/SuiteEnvironment/TestMachine"/>
						</xsl:call-template>
					</td>
					<td align="center" valign="middle">
						<xsl:call-template name="DisplayAttributes">
							<xsl:with-param name="Parent" select="$Environment/SuiteEnvironment/TestMachine/TestSetup"/>
						</xsl:call-template>
					</td>
					<td align="center" valign="middle">
						<xsl:call-template name="DisplayAttributes">
							<xsl:with-param name="Parent" select="$Environment/SuiteEnvironment/TestMachine/JavaSetup"/>
						</xsl:call-template>
					</td>
				</tr>
			</table>
		</div>
		<br/>
		<br/>
	</xsl:template>

	<!-- Show individual Suite Summary -->
	<xsl:template match="Suite">
		<tr align="left" valign="middle">
			<td align="center" valign="middle">
				<b>
					<font face="times" size="3">
						<xsl:value-of select="@name"/>
					</font>
				</b>
				<br/>
				<br/>
			</td>
			<td>
				<table border="2" width="100%" cellpadding="0" cellspacing="0">
					<!--<th>Script Name</th>
					<th>Link to Details</th>
					<th>Script result</th>-->

					<xsl:for-each select="ScriptResult/self::*">
						<tr align="left" valign="middle">
							<td width="33%" border="2">
								<font face="times" size="3">
									<xsl:value-of select="@name"/>
								</font>
							</td>
							<td width="34%">
								<xsl:for-each select="@link">
									<xsl:if test="not(string-length()='0')">
										<font face="times" size="3">See Execution details
											<a href="#{.}">here</a>
										</font>
									</xsl:if>
									<xsl:if test="string-length()='0'">
										&nbsp;
									</xsl:if>
								</xsl:for-each>
							</td>
							<xsl:call-template name="ShowSuiteResults">
								<xsl:with-param name="SuiteResults" select="@status/parent::*"/>
							</xsl:call-template>
						</tr>
					</xsl:for-each>
				</table>
			</td>
			<xsl:call-template name="ShowSuiteResults">
				<xsl:with-param name="SuiteResults" select="SuiteResult"/>
			</xsl:call-template>
		</tr>
	</xsl:template>

	<!-- Show Suite Results color coded as per there status -->
	<xsl:template name="ShowSuiteResults">
		<xsl:param name="SuiteResults"/>
		<xsl:choose>
			<xsl:when test="$SuiteResults[contains(@status, 'Failed')]">
				<td bgcolor="#FF0000" valign="middle" align="center">
					<font face="times" size="3">
						<b>
							<i>
								<xsl:value-of select="$SuiteResults/@status"/>
							</i>
						</b>
					</font>
				</td>
			</xsl:when>
			<xsl:when test="$SuiteResults[contains(@status, 'Disabled')]">
				<td bgcolor="#000000" valign="middle" align="center">
					<font face="times" size="3" color="#FFFFFF">
						<b>
							<i>
								<xsl:value-of select="$SuiteResults/@status"/>
							</i>
						</b>
					</font>
				</td>
			</xsl:when>
			<xsl:when test="$SuiteResults[contains(@status, 'Not Executed')]">
				<td bgcolor="#CCCCCC" valign="middle" align="center">
					<font face="times" size="3">
						<b>
							<i>
								<xsl:value-of select="$SuiteResults/@status"/>
							</i>
						</b>
					</font>
				</td>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$SuiteResults[contains(@status, 'Passed')]">
						<td bgcolor="#008B00" valign="middle" align="center">
							<font face="times" size="3">
								<b>
									<i>
										<xsl:value-of select="$SuiteResults/@status"/>
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

	<!-- Display Test Script Settings/Environment -->
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
					<u>Show/Hide Script Execution Environment</u>
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
				<!-- There's Special Handling for TestResults in the ShowResults template -->
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