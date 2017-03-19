<?xml version="1.0" standalone="yes"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!--
		Print the auxilliary refnames for a refentry.
	-->

	<xsl:output method="text"/>

	<xsl:template match="refname">
		<xsl:if test="position() &gt; 1">
			<xsl:value-of select="."/>
			<xsl:text>.</xsl:text>
			<xsl:apply-templates select="../../refmeta/manvolnum"/>
			<xsl:text>&#10;</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="/refentry">
		<xsl:apply-templates select="refnamediv/refname"/>
	</xsl:template>

</xsl:stylesheet>

