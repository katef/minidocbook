<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:h="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:set="http://exslt.org/sets"
	xmlns:common="http://exslt.org/common"
	xmlns:mi="http://xml.elide.org/docindex"

	extension-element-prefixes="str set common"

	exclude-result-prefixes="str set common mi h">

	<xsl:import href="../minidocbook/refentry.xsl"/>
	<xsl:import href="../minidocbook/links.xsl"/>
	<xsl:import href="../minidocbook/inline.xsl"/>

	<xsl:import href="fallback.xsl"/>
	<xsl:import href="manvolnum.xsl"/>
	<xsl:import href="output.xsl"/>

	<xsl:param name="src"/>
	<xsl:param name="filename" select="'/index.xhtml5'"/>
	<xsl:param name="prefix"   select="''"/>
	<xsl:param name="title"    select="false()"/>

	<xsl:variable name="root">
		<xsl:for-each select="str:tokenize($src, ':')">
			<xsl:variable name="doc"  select="document(.)"/>
			<xsl:variable name="dir"  select="substring-before(., $filename)"/>
			<xsl:variable name="path" select="substring-after ($dir, $prefix)"/>

			<head data-path="{$path}">
				<xsl:copy-of select="$doc/h:html/h:head/@*"/>
				<xsl:copy-of select="$doc/h:html/h:head/*"/>
			</head>
		</xsl:for-each>
	</xsl:variable>

	<xsl:template match="h:head" mode="doc">
		<li>
			<a class="single" href="{@data-path}">
				<xsl:value-of select="h:title"/> <!-- TODO: apply-templates -->
			</a>

			<!-- TODO: links to other formats -->
		</li>
	</xsl:template>

	<xsl:template match="h:head" mode="refentry">
		<xsl:variable name="manvolnum"   select="h:meta[@name = 'refmeta-manvolnum'  ]/@content"/>
		<xsl:variable name="refname"     select="h:meta[@name = 'refmeta-refname'    ]/@content"/>
		<xsl:variable name="refpurpose"  select="h:meta[@name = 'refmeta-refpurpose' ]/@content"/>
		<!-- TODO: also h:meta[@name = 'refmeta-title']" -->

		<li>
			<a href="{@data-path}">
				<span class="command donthyphenate" data-manvolnum="{$manvolnum}">
					<xsl:for-each select="str:tokenize($refname, ' ')">
						<xsl:value-of select="."/>
						<xsl:if test="position() != last()">
							<xsl:text>/</xsl:text>
						</xsl:if>
					</xsl:for-each>
				</span>
			</a>

			<xsl:value-of select="$refpurpose"/>

			<!-- TODO: links to other formats -->
		</li>
	</xsl:template>

	<xsl:template match="h:head">
		<ul>
			<xsl:choose>
				<xsl:when test="h:meta[@name = 'refmeta-manvolnum']">
					<xsl:apply-templates select="." mode="refentry"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="doc"/>
				</xsl:otherwise>
			</xsl:choose>
		</ul>
	</xsl:template>

	<xsl:template name="section">
		<xsl:param name="productname"/>

		<dl>
			<xsl:if test="$productname">
				<dt>
					<xsl:value-of select="$productname"/>
				</dt>
			</xsl:if>

			<dd>
				<xsl:apply-templates select="common:node-set($root)/h:head
					[h:meta[@name = 'refmeta-productname']/@content = $productname]">
					<xsl:sort select="h:meta[@name = 'refmeta-manvolnum'  ]/@content"/>
				</xsl:apply-templates>
			</dd>
		</dl>
	</xsl:template>

	<xsl:template match="/">
		<xsl:call-template name="output">
			<xsl:with-param name="class"  select="'minidocbook docindex'"/>

			<xsl:with-param name="title">
				<xsl:if test="$title">
					<xsl:value-of select="$title"/>
				</xsl:if>
			</xsl:with-param>

			<xsl:with-param name="body">
				<xsl:if test="$title">
					<h1>
						<xsl:value-of select="$title"/>
					</h1>
				</xsl:if>

				<xsl:call-template name="section">
					<xsl:with-param name="productname" select="false()"/>
				</xsl:call-template>

				<xsl:for-each select="set:distinct(common:node-set($root)/h:head
					/h:meta[@name = 'refmeta-productname']/@content)">
					<xsl:sort select="."/>

					<xsl:call-template name="section">
						<xsl:with-param name="productname" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>

