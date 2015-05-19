<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:set="http://exslt.org/sets"
	xmlns:common="http://exslt.org/common"

	extension-element-prefixes="str common"

	exclude-result-prefixes="str common">

	<xsl:output method="text"/>

	<xsl:param name="src"/>

	<xsl:variable name="root">
		<xsl:for-each select="str:tokenize($src, ':')">
			<xsl:copy-of select="document(.)/refentry"/>
		</xsl:for-each>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:for-each select="set:distinct(common:node-set($root)/refentry/refentryinfo/productname)">
			<xsl:value-of select="."/>
			<xsl:text>&#10;</xsl:text>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>

