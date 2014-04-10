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

	<!-- <para> -->
	<xsl:template match="//db:para" mode="body">
		<xsl:call-template name="html.block">
			<xsl:with-param name="kind" />
			<xsl:with-param name="element">p</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<!-- <formalpara> -->
	<xsl:template match="//db:formalpara" mode="body">
		<xsl:call-template name="html.titleblock">
			<xsl:with-param name="kind" />
			<xsl:with-param name="element">p</xsl:with-param>
			<xsl:with-param name="title.element">h2</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- <blockquote> -->
	<xsl:template match="//db:blockquote" mode="body">
		<xsl:variable name="attribution"><xsl:copy-of select="db:attribution" /></xsl:variable>
		<blockquote>
			<xsl:apply-templates select="node()" mode="body" />
			<footer><cite><xsl:value-of select="$attribution" /></cite></footer>
		</blockquote>
	</xsl:template>
	<xsl:template match="//db:blockquote/db:attribution" />

	<!-- Admonition elements -->

	<!-- <note> -->
	<xsl:template match="//db:note" mode="body">
		<xsl:call-template name="html.block">
			<xsl:with-param name="kind">info</xsl:with-param>
			<xsl:with-param name="element">aside</xsl:with-param>
		</xsl:call-template>
	</xsl:template>			
	
	<!-- <tip>, <warning>, <important>, <caution> -->
	<xsl:template match="//db:tip|//db:warning|//db:important|//db:caution" mode="body">
		<xsl:call-template name="html.block">
			<xsl:with-param name="element">aside</xsl:with-param>
		</xsl:call-template>
	</xsl:template>			

	<!-- List elements -->

	<!-- <itemizedlist> -->
	<xsl:template match="//db:itemizedlist" mode="body">
	  <ul>
		  <xsl:apply-templates mode="list" />
	  </ul>
	</xsl:template>

	<!-- <orderedlist> -->
	<xsl:template match="//db:orderedlist" mode="body">
	  <ol>
		  <xsl:apply-templates mode="list" />
	  </ol>
	</xsl:template>

	<!-- <variablelist> -->
	<xsl:template match="//db:variablelist" mode="body">
		<dl>
			<xsl:for-each select="db:varlistentry">
				<xsl:apply-templates select="node()" mode="dl" />
			</xsl:for-each>
		</dl>
	</xsl:template>
	
	<xsl:template match="//db:term" mode="dl">
		<dt><xsl:apply-templates select="node()" mode="body" /></dt>
	</xsl:template>
	
	<!-- <listitem> -->
	<xsl:template match="//db:listitem" mode="list">
	  <xsl:choose>
		<xsl:when test="count(*)=1 and count(db:para)=1">
		  <li><xsl:apply-templates select="db:para/node()" mode="body" /></li>
		</xsl:when>
		<xsl:otherwise>
		  <li><xsl:apply-templates select="node()" mode="body" /></li>
		</xsl:otherwise>
	  </xsl:choose>
	</xsl:template>

	<xsl:template match="//db:listitem" mode="dl">
	  <xsl:choose>
		<xsl:when test="count(*)=1 and count(db:para)=1">
		  <dd><xsl:apply-templates select="db:para/node()" mode="body" /></dd>
		</xsl:when>
		<xsl:otherwise>
		  <dd><xsl:apply-templates select="node()" mode="body" /></dd>
		</xsl:otherwise>
	  </xsl:choose>
	</xsl:template>
	
	<!-- <segmentedlist> -->
	<xsl:template match="//db:segmentedlist" mode="body">
		<div class="table">
			<table>
				<thead>
					<tr>
						<xsl:for-each select="db:segtitle">
							<th scope="col">
								<xsl:apply-templates select="node()" mode="body" />
							</th>
						</xsl:for-each>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="db:seglistitem">
						<tr>
							<xsl:for-each select="db:seg">
								<td>
									<xsl:apply-templates select="node()" mode="body" />
								</td>
							</xsl:for-each>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</div>
	</xsl:template>

	<!-- <section>, <chapter>, <part> -->
	<xsl:template match="//db:section|//db:chapter|//db:part|//db:refsection|//db:refsect1|//db:refsect2|//db:refsect3|//db:refsect4|//db:reference|//db:refsynopsisdiv|//db:refentry" mode="body">
		<xsl:call-template name="html.titleblock" />
	</xsl:template>
	
	<!-- <simplesect>, <sectN> -->
	<xsl:template match="//db:simplesect|//db:sect1|//db:sect2|//db:sect3|//db:sect4|//db:sect5" mode="body">
		<xsl:call-template name="html.titleblock">
			<xsl:with-param name="kind">section</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<!-- <refnamediv> -->
	<xsl:template match="//db:refnamediv" mode="body">
	</xsl:template>

	<!-- <example> -->
	<xsl:template match="//db:example" mode="body">
	  <xsl:call-template name="html.titleblock">
		<xsl:with-param name="element">aside</xsl:with-param>
		<xsl:with-param name="kind">example</xsl:with-param>
	  </xsl:call-template>
	</xsl:template>

	<!-- <programlisting> -->
	<xsl:template match="//db:programlisting" mode="body">
	  <xsl:variable name="classes" select="normalize-space(concat('code ', @language, ' ', @role))" />
	  <pre>
		<xsl:attribute name="class"><xsl:value-of select="$classes" /></xsl:attribute>
		<code><xsl:apply-templates select="node()" mode="body" /></code>
	  </pre>
	</xsl:template>

	<!-- <screen> -->
	<xsl:template match="//db:screen" mode="body">
	  <xsl:variable name="classes" select="normalize-space(concat('output ', @role))" />
	  <pre>
		<xsl:attribute name="class"><xsl:value-of select="$classes" /></xsl:attribute>
		<samp><xsl:apply-templates select="node()" mode="body" /></samp>
	  </pre>
	</xsl:template>

	<!-- Titled block output -->
	<xsl:template name="html.titleblock">
		<xsl:param name="element" select="'section'" />
		<xsl:param name="class" />
		<xsl:param name="role" select="@role" />
		<xsl:param name="id" select="normalize-space(@xml:id)" />
		<xsl:param name="kind" select="local-name()" />
		<xsl:param name="title.element" select="'h1'" />
		<xsl:param name="subtitle.element" select="'h2'" />
		<xsl:variable name="classes" select="normalize-space(concat($class, ' ', $role, ' ', $kind))" />
		<xsl:variable name="title">
			<xsl:choose>
				<xsl:when test="db:title">
					<xsl:copy-of select="db:title" />
				</xsl:when>
				<xsl:when test="db:refmeta/db:refentrytitle">
					<xsl:copy-of select="db:refmeta/db:refentrytitle" />
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="subtitle"><xsl:copy-of select="db:subtitle" /></xsl:variable>
		<xsl:element name="{$element}">
			<xsl:if test="$id != ''"><xsl:attribute name="id"><xsl:value-of select="$id" /></xsl:attribute></xsl:if>
			<xsl:if test="$classes != ''"><xsl:attribute name="class"><xsl:value-of select="$classes" /></xsl:attribute></xsl:if>
			<xsl:if test="normalize-space($title) != ''">
				<xsl:element name="{$title.element}">
					<xsl:for-each select="db:title">
						<xsl:apply-templates select="node()" mode="body" />
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
			<xsl:if test="normalize-space($subtitle) != ''">
				<xsl:element name="{$subtitle.element}">
					<xsl:for-each select="db:subtitle">
						<xsl:apply-templates select="node()" mode="body" />
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="body" />
		</xsl:element>
	</xsl:template>

	<!-- Un-titled block output -->
	<xsl:template name="html.block">
		<xsl:param name="element" select="'div'" />
		<xsl:param name="class" />
		<xsl:param name="role" select="@role" />
		<xsl:param name="id" select="normalize-space(@xml:id)" />		
		<xsl:param name="kind" select="local-name()" />
		<xsl:variable name="classes" select="normalize-space(concat($class, ' ', $role, ' ', $kind))" />
		<xsl:element name="{$element}">
			<xsl:if test="$id != ''"><xsl:attribute name="id"><xsl:value-of select="$id" /></xsl:attribute></xsl:if>			
			<xsl:if test="$classes != ''"><xsl:attribute name="class"><xsl:value-of select="$classes" /></xsl:attribute></xsl:if> 
			<xsl:apply-templates select="node()" mode="body" />
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>