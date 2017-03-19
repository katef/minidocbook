<?xml version="1.0"?>

<!--
	Copyright 2009-2017 Katherine Flavel

	See LICENCE for the full copyright terms.
-->

<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:common="http://exslt.org/common"
	xmlns:mi="http://xml.elide.org/manindex"

	extension-element-prefixes="str common"

	exclude-result-prefixes="str common mi">

	<xsl:import href="fallback.xsl"/>
	<xsl:import href="manvolnum.xsl"/>

	<xsl:output
		method="xml"
		indent="yes"/>

	<xsl:param name="src"/>
	<xsl:param name="title" select="false()"/>
	<xsl:param name="productname" select="false()"/>
	<xsl:param name="mdb.url.man" select="false()"/> <!-- e.g. 'http://man.example.com' -->

	<xsl:variable name="root">
		<xsl:for-each select="str:tokenize($src, ':')">
			<xsl:if test="not($productname) or document(.)/refentry/refentryinfo/productname = $productname">
				<xsl:copy-of select="document(.)/refentry"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<!-- TODO: also other things, not just refenry -->
	<xsl:template match="refentry">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template name="section">
		<xsl:param name="manvolnum"/>
		<xsl:param name="productrole"/>

		<xsl:choose>
			<xsl:when test="$productrole">
				<reference>
					<title>
						<xsl:value-of select="$productrole"/>
					</title>

					<!-- TODO: also other things -->
					<xsl:apply-templates select="common:node-set($root)/refentry
						[refmeta/manvolnum = $manvolnum]
						[not($productrole) or refentryinfo/productname/@role = $productrole]">
						<xsl:sort select="concat('lib', refmeta/refentrytitle) != $productrole"/>
						<xsl:sort select="refnamediv/refclass"/>
						<xsl:sort select="refmeta/refentrytitle"/>
					</xsl:apply-templates>
				</reference>
			</xsl:when>

			<xsl:otherwise>
				<!-- TODO: also other things -->
				<xsl:apply-templates select="common:node-set($root)/refentry
					[refmeta/manvolnum = $manvolnum]
					[not($productrole) or refentryinfo/productname/@role = $productrole]">
					<xsl:sort select="concat('lib', refmeta/refentrytitle) != $productrole"/>
					<xsl:sort select="refnamediv/refclass"/>
					<xsl:sort select="refmeta/refentrytitle"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="manvolnum" mode="section">
		<xsl:variable name="manvolnum" select="."/>

		<part id="{$manvolnum}">
			<title>
				<xsl:value-of select="mi:title($manvolnum)"/>
			</title>

			<xsl:if test="common:node-set($root)/refentry
				[refmeta/manvolnum = current()]
				[not(refentryinfo/productname/@role)]">
				<xsl:call-template name="section">
					<xsl:with-param name="manvolnum" select="$manvolnum"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:for-each select="common:node-set($root)/refentry
				[refmeta/manvolnum = current()]/refentryinfo/productname/@role
				[not(. = ../../../preceding-sibling::refentry
					[refmeta/manvolnum = current()]/refentryinfo/productname/@role)]">
				<xsl:sort select="."/>

				<xsl:call-template name="section">
					<xsl:with-param name="manvolnum"   select="$manvolnum"/>
					<xsl:with-param name="productrole" select="."/>
				</xsl:call-template>
			</xsl:for-each>
		</part>
	</xsl:template>

	<xsl:template match="/">
		<book>
			<!-- TODO: bookinfo -->
			<xsl:if test="$title">
				<title>
					<xsl:value-of select="$title"/>
				</title>
			</xsl:if>

			<xsl:apply-templates select="common:node-set($root)/refentry/refmeta/manvolnum
				[not(. = ../../preceding-sibling::refentry/refmeta/manvolnum)]" mode="section">
				<xsl:sort select="."/>
			</xsl:apply-templates>
		</book>
	</xsl:template>

</xsl:stylesheet>

