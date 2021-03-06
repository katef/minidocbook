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

	<xsl:import href="../minidocbook/refentry.xsl"/>
	<xsl:import href="../minidocbook/links.xsl"/>
	<xsl:import href="../minidocbook/inline.xsl"/>

	<xsl:import href="fallback.xsl"/>
	<xsl:import href="manvolnum.xsl"/>
	<xsl:import href="output.xsl"/>

	<xsl:param name="src"/>
	<xsl:param name="title" select="false()"/>

	<xsl:variable name="root">
		<xsl:for-each select="str:tokenize($src, ':')">
			<xsl:copy-of select="document(.)/refentry"/>
		</xsl:for-each>
	</xsl:variable>

	<!-- XXX: I don't see why the template from refentry.xsl isn't matching for this -->
	<xsl:template match="refpurpose">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="refentry">
		<xsl:variable name="productname" select="refentryinfo/productname"/>

		<xsl:for-each select="refnamediv/refname">
			<dt>
				<xsl:if test="$productname">
					<xsl:attribute name="data-productname">
						<xsl:value-of select="$productname"/>
					</xsl:attribute>
				</xsl:if>

				<xsl:call-template name="reflink">
					<xsl:with-param name="manvolnum"     select="../../refmeta/manvolnum"/>
					<xsl:with-param name="refentrytitle" select="."/>
					<xsl:with-param name="role"          select="'index'"/>
					<xsl:with-param name="refclass"      select="../refclass"/>
				</xsl:call-template>
			</dt>
		</xsl:for-each>

		<dd>
			<xsl:if test="$productname">
				<xsl:attribute name="data-productname">
					<xsl:value-of select="$productname"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="refnamediv/refpurpose"/>
		</dd>
	</xsl:template>

	<xsl:template name="section">
		<xsl:param name="manvolnum"/>
		<xsl:param name="productrole"/>

		<xsl:if test="$productrole">
			<h2>
				<span class="product">
					<xsl:value-of select="$productrole"/>
				</span>
			</h2>
		</xsl:if>

		<dl>
			<xsl:apply-templates select="common:node-set($root)/refentry
				[refmeta/manvolnum = $manvolnum]
				[not($productrole) or refentryinfo/productname/@role = $productrole]">
				<xsl:sort select="concat('lib', refmeta/refentrytitle) != $productrole"/>
				<xsl:sort select="refnamediv/refclass"/>
				<xsl:sort select="refmeta/refentrytitle"/>
			</xsl:apply-templates>
		</dl>
	</xsl:template>

	<xsl:template match="manvolnum" mode="section">
		<xsl:variable name="manvolnum" select="."/>

		<section data-manvolnum="{$manvolnum}">
			<h1>
				<a id="{.}"/>
				<xsl:value-of select="mi:title($manvolnum)"/>
			</h1>

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

				<section data-productrole="{.}">
					<xsl:call-template name="section">
						<xsl:with-param name="manvolnum"   select="$manvolnum"/>
						<xsl:with-param name="productrole" select="."/>
					</xsl:call-template>
				</section>
			</xsl:for-each>
		</section>
	</xsl:template>

	<xsl:template match="/">
		<xsl:call-template name="output">
			<xsl:with-param name="class"  select="'minidocbook manindex'"/>

			<xsl:with-param name="title">
				<xsl:if test="$title">
					<xsl:value-of select="$title"/>
				</xsl:if>
			</xsl:with-param>

			<xsl:with-param name="body">
				<xsl:apply-templates select="common:node-set($root)/refentry/refmeta/manvolnum
					[not(. = ../../preceding-sibling::refentry/refmeta/manvolnum)]" mode="section">
					<xsl:sort select="."/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>

