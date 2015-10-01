<?xml version="1.0" standalone="yes"?>

<!-- $Id$ -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns="http://www.w3.org/1999/xhtml"

	extension-element-prefixes="str"

	exclude-result-prefixes="str">

	<!--
		This is an XSLT transformation to produce XHTML from the subset of Docbook
		which is actually used. This has two goals: two reduce dependencies (which
		often seem complex to users, especially with respect to XML catalogues),
		and to produce simple and clean XHTML output without requiring overriding
		templates.
	-->

	<xsl:import href="fallback.xsl"/>
	<xsl:import href="output.xsl"/>
	<xsl:import href="page.xsl"/>

	<xsl:import href="blocks.xsl"/>
	<xsl:import href="inline.xsl"/>
	<xsl:import href="links.xsl"/>
	<xsl:import href="lists.xsl"/>
	<xsl:import href="title.xsl"/>
	<xsl:import href="toc.xsl"/>
	<xsl:import href="frontmatter.xsl"/>
	<xsl:import href="table.xsl"/>
	<xsl:import href="footnotes.xsl"/>
	<xsl:import href="refentry.xsl"/>


	<xsl:template match="node()" mode="refmeta">
		<meta name="refmeta-{name()}" content="{.}"/>
	</xsl:template>

	<xsl:template match="refentryinfo/productname/@role" mode="refmeta">
		<meta name="refmeta-productrole" content="{.}"/>
	</xsl:template>

	<xsl:template match="refnamediv" mode="refmeta">
		<meta name="refmeta-refname">
			<xsl:attribute name="content">
				<xsl:for-each select="refname">
					<xsl:if test="position() != 1">
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:value-of select="."/>
				</xsl:for-each>
			</xsl:attribute>
		</meta>
	</xsl:template>

	<xsl:template match="/refentry">
		<xsl:variable name="title">
			<xsl:value-of select="concat(refmeta/refentrytitle, '(', refmeta/manvolnum, ')')"/>
		</xsl:variable>

		<xsl:call-template name="page-single">
			<xsl:with-param name="title"     select="$title"/>
			<xsl:with-param name="filename"  select="$file-index"/>
			<xsl:with-param name="chunklink" select="false()"/>
			<xsl:with-param name="class"     select="'refentry'"/>

			<xsl:with-param name="head">
				<xsl:apply-templates select="refentryinfo/productname"       mode="refmeta"/>
				<xsl:apply-templates select="refentryinfo/productname/@role" mode="refmeta"/>
				<xsl:apply-templates select="refentryinfo/title"             mode="refmeta"/>
				<xsl:apply-templates select="refmeta/manvolnum"              mode="refmeta"/>
				<xsl:apply-templates select="refnamediv"                     mode="refmeta"/>

				<xsl:if test="refsection[title = 'Description']">
					<meta name="description"
						content="{normalize-space(refsection[title = 'Description']/para[1])}"/>
				</xsl:if>

				<meta name="keywords">
					<xsl:attribute name="content">
						<xsl:for-each select="refsection[title = 'See Also']/para/citerefentry">
							<xsl:value-of select="refentrytitle"/>
							<xsl:text>(</xsl:text>
							<xsl:value-of select="manvolnum"/>
							<xsl:text>)</xsl:text>
							<xsl:text>, </xsl:text>
						</xsl:for-each>
						<xsl:for-each select="str:tokenize(refnamediv/refpurpose)">
							<xsl:value-of select="."/>
							<xsl:text>, </xsl:text>
						</xsl:for-each>
						<xsl:if test="refentryinfo/productname">
							<xsl:value-of select="refentryinfo/productname"/>
							<xsl:text>, </xsl:text>
						</xsl:if>
						<xsl:text>docs, </xsl:text>
						<xsl:text>man</xsl:text>
					</xsl:attribute>
				</meta>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/article">
		<xsl:variable name="title">
			<xsl:apply-templates select="articleinfo/title" mode="title"/>
		</xsl:variable>

		<xsl:call-template name="page-single">
			<xsl:with-param name="title"     select="$title"/>
			<xsl:with-param name="filename"  select="$file-index"/>
			<xsl:with-param name="chunklink" select="false()"/>
			<xsl:with-param name="class"     select="'article'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/book">
		<xsl:variable name="title">
			<xsl:apply-templates select="bookinfo/title" mode="title"/>
		</xsl:variable>

		<xsl:call-template name="page-single">
			<xsl:with-param name="title"     select="$title"/>
			<xsl:with-param name="filename"  select="$file-single"/>
			<xsl:with-param name="chunklink" select="true()"/>
			<xsl:with-param name="class"     select="'book'"/>
		</xsl:call-template>

		<xsl:call-template name="page-toc">
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="class" select="'book'"/>
		</xsl:call-template>

		<xsl:call-template name="page-frontmatter">
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="class" select="'book'"/>
		</xsl:call-template>

		<xsl:for-each select="preface|chapter|appendix">
			<xsl:call-template name="page-chunk">
				<xsl:with-param name="title" select="$title"/>
				<xsl:with-param name="class" select="'book'"/>
				<xsl:with-param name="filename">
					<xsl:apply-templates select="." mode="page-filename"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="text()">
		<!-- TODO: normalise spaces without trimming -->
		<xsl:copy-of select="."/>
	</xsl:template>

</xsl:stylesheet>

