<?xml version="1.0" standalone="yes"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!--
		TODO: stuff
	-->

	<xsl:import href="fallback.xsl"/>

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

</xsl:stylesheet>

