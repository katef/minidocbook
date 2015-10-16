<?xml version="1.0" standalone="yes"?>

<!-- $Id: main.xsl 576 2015-10-11 13:53:25Z kate $ -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:func="http://exslt.org/functions"
	xmlns:mdb="http://xml.elide.org/minidocbook"

	extension-element-prefixes="func"

	exclude-result-prefixes="func mdb">

	<!--
		TODO: stuff
	-->

	<xsl:import href="fallback.xsl"/>

	<!-- TODO: centralise -->
	<func:function name="mdb:ends-with">
		<xsl:param name="str"/>
		<xsl:param name="suffix"/>

		<func:result select="substring($str, string-length($str) - string-length($suffix) + 1) = $suffix"/>
	</func:function>

	<xsl:template match="manvolnum" mode="text">
		<xsl:text>(</xsl:text>
		<xsl:apply-templates mode="text"/>
		<xsl:text>)</xsl:text>
	</xsl:template>

	<xsl:template match="citerefentry" mode="text">
		<xsl:apply-templates select="refentrytitle" mode="text"/>
		<xsl:apply-templates select="manvolnum"     mode="text"/>
	</xsl:template>

	<xsl:template match="node()" mode="text">
		<xsl:apply-templates mode="text"/>
	</xsl:template>

	<!-- TODO: centralise; use this for xhtml, too -->
	<xsl:template match="text()" mode="text">
		<xsl:variable name="white" select="'&#x9;&#x20;&#xA;&#xD;'"/>
		<xsl:variable name="s" select="translate(., $white, '    ')"/>

		<xsl:if test="starts-with($s, ' ')">
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:copy-of select="normalize-space(.)"/>
		<xsl:if test="mdb:ends-with($s, ' ')">
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>

