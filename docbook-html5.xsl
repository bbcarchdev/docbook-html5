<?xml version="1.0" encoding="utf-8"?>
<!--

 Author: Mo McRoberts <mo.mcroberts@bbc.co.uk>

 Copyright (c) 2014 BBC

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:db="http://docbook.org/ns" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xhtml db xi xlink">

  	<xsl:output omit-xml-declaration="yes" encoding="utf-8" indent="no" />

	<xsl:include href="block.xsl" />	
	<xsl:include href="inline.xsl" />
	<xsl:include href="doc.xsl" />	
	<xsl:include href="toc.xsl" />	

	<!-- HTML5 doctype -->
	<xsl:template name="html.doctype">
		<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE html>]]></xsl:text>
	</xsl:template>
	
	<!-- HTML5 meta elements -->
	<xsl:template name="html.meta">
		<xsl:text disable-output-escaping="yes"><![CDATA[
			<meta charset="utf-8" />
			<meta http-equiv="X-UA-Compatible" content="IE=edge" />
			<!--[if lt IE 9]><script>document.createElement('header');document.createElement('nav');document.createElement('section');document.createElement('article');document.createElement('aside');document.createElement('footer');</script><![endif]-->
		]]></xsl:text>
	</xsl:template>

	<!-- HTML5 stylesheets -->
	<xsl:param name="html.linksfile" select="''" />
	<xsl:template name="html.links">
	  <xsl:if test="normalize-space($html.linksfile) != ''">
		<xsl:call-template name="include-xml">
		  <xsl:with-param name="uri" select="$html.linksfile" />
		</xsl:call-template>
	  </xsl:if>
	</xsl:template>

	<!-- HTML5 scripts -->
	<xsl:template name="html.scripts" />

	<!-- Global navigation -->
	<xsl:param name="html.navfile" select="''" />
	<xsl:template name="html.globalnav">
		<xsl:if test="normalize-space($html.navfile) != ''">
			<nav class="global"><div class="inner">
				<xsl:call-template name="include-xml">
					<xsl:with-param name="uri" select="$html.navfile" />
				</xsl:call-template>
			</div></nav>			
		</xsl:if>
	</xsl:template>

	<!-- Masthead -->
	<xsl:template name="html.masthead">
		<xsl:text disable-output-escaping="yes"><![CDATA[
		<div class="masthead"></div>
		]]></xsl:text>
	</xsl:template>

	<!-- Utilities -->
	<xsl:template name="include-xml">
	  <xsl:param name="uri" />
	  <xsl:message>Including source file <xsl:value-of select="$uri" /></xsl:message>
	  <xsl:copy-of select="document($uri)/include/*" disable-output-escaping="yes" />
	</xsl:template>
	
</xsl:stylesheet>
