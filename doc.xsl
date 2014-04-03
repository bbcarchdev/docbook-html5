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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:db="http://docbook.org/ns" xmlns:xi="http://www.w3.org/2001/XInclude">

	<!-- Root element switch -->
	<xsl:template match="/*">
		<xsl:variable name="doc.title">
			<xsl:choose>
				<xsl:when test="/db:refentry">
					<xsl:copy-of select="db:refmeta/db:refentrytitle" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="db:title" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="doc.subtitle"><xsl:copy-of select="/*/db:subtitle" /></xsl:variable>
		<xsl:call-template name="html.doctype" />
		<xsl:text disable-output-escaping="yes"><![CDATA[
<html>
	<head>
]]></xsl:text>
		<xsl:call-template name="html.meta" />
		<title><xsl:value-of select="$doc.title" /></title>
		<xsl:call-template name="html.links" />
		<xsl:call-template name="html.scripts" />
		<xsl:text disable-output-escaping="yes"><![CDATA[
	</head>
]]></xsl:text>
		<xsl:choose>
			<xsl:when test="/db:book">
				<xsl:message><xsl:text>Processing a DocBook &lt;book&gt;</xsl:text></xsl:message>
				<xsl:call-template name="html.body">
					<xsl:with-param name="kind">book</xsl:with-param>
					<xsl:with-param name="title" select="$doc.title" />
					<xsl:with-param name="subtitle" select="$doc.subtitle" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="/db:refentry">
				<xsl:message><xsl:text>Processing a DocBook &lt;refentry&gt;</xsl:text></xsl:message>
				<xsl:call-template name="html.body">
					<xsl:with-param name="kind">refentry</xsl:with-param>
					<xsl:with-param name="title" select="$doc.title" />
					<xsl:with-param name="subtitle" select="$doc.subtitle" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">
					<xsl:text>Unsupported root element</xsl:text>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text disable-output-escaping="yes"><![CDATA[
</html>
]]></xsl:text>
	</xsl:template>
	
	<!-- Generate the HTML <body> -->
	<xsl:template name="html.body">
		<xsl:param name="kind" />
		<xsl:param name="title" />
		<xsl:param name="subtitle" />
		<body class="{$kind}">
			<xsl:call-template name="html.frontmatter">
				<xsl:with-param name="title" select="$title" />
				<xsl:with-param name="subtitle" select="$subtitle" />
			</xsl:call-template>
			<article>
				<xsl:apply-templates select="node()" mode="body" />
			</article>
			<xsl:call-template name="html.backmatter" />
		</body>
	</xsl:template>
	
	<!-- Generate any frontmatter -->
	<xsl:template name="html.frontmatter">
		<xsl:param name="title" />
		<xsl:param name="subtitle" />
		<header>
			<xsl:call-template name="html.globalnav" />
			<xsl:call-template name="html.masthead" />
			<h1><xsl:value-of select="$title" /></h1>
			<xsl:if test="normalize-space($subtitle) != ''">
				<h2><xsl:value-of select="$subtitle" /></h2>
			</xsl:if>
			<xsl:for-each select="db:info/db:edition"><p class="edition"><xsl:apply-templates select="node()" mode="body" /></p></xsl:for-each>
			<xsl:if test="db:info/db:editor">
				<p class="editor">
					<xsl:text>Edited by </xsl:text>
					<xsl:for-each select="db:info/db:editor">
						<xsl:if test="position() != 1"><xsl:text>, </xsl:text></xsl:if>
						<xsl:call-template name="html.person" />
					</xsl:for-each>
					<xsl:text>.</xsl:text>
				</p>
			</xsl:if>
		</header>
		<!-- Use a series of xsl:for-each stanzas to output in a specific order -->
		<xsl:for-each select="db:info/db:legalnotice"><xsl:call-template name="html.titleblock" /></xsl:for-each>
		<xsl:for-each select="db:preface"><xsl:call-template name="html.titleblock" /></xsl:for-each>
		<xsl:for-each select="db:acknowledgements"><xsl:call-template name="html.titleblock" /></xsl:for-each>
		<xsl:call-template name="html.toc" />
	</xsl:template>
	
	<!-- Emit a person's name -->
	<xsl:template name="html.person">
		<xsl:if test="db:personname">
			<xsl:apply-templates select="db:personname" mode="body" />
		</xsl:if>
	</xsl:template>
	
	<!-- Generate any backmatter -->
	<xsl:template name="html.backmatter">
		<!-- Use a series of xsl:for-each stanzas to output in a specific order -->
		<xsl:for-each select="db:glossary"><xsl:call-template name="html.titleblock" /></xsl:for-each>
		<xsl:for-each select="db:bibliography"><xsl:call-template name="html.titleblock" /></xsl:for-each>
		<xsl:for-each select="db:index"><xsl:call-template name="html.titleblock" /></xsl:for-each>
		<xsl:for-each select="db:colophon"><xsl:call-template name="html.titleblock" /></xsl:for-each>
	</xsl:template>		
		
	<!-- Don't emit certain elements -->
	<xsl:template match="//db:title" mode="body" />
	<xsl:template match="//db:subtitle" mode="body" />
	<xsl:template match="//db:info" mode="body" />
	<xsl:template match="//db:refmeta" mode="body" />
	<xsl:template match="//db:legalnotice|//db:preface|//db:acknowledgements|//db:toc|//db:dedication" mode="body" />
	<xsl:template match="//db:appendix|//db:bibliography|//db:colophon|//db:glossary|//db:index" mode="body" />
	
</xsl:stylesheet>
