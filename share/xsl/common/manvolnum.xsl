<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:mi="http://xml.elide.org/manindex"
	xmlns:func="http://exslt.org/functions"

	extension-element-prefixes="func"

	exclude-result-prefixes="mi func">

	<mi:sections>
		<mi:section manvolnum="1" name="Programs"/>
		<mi:section manvolnum="2" name="System calls"/>
		<mi:section manvolnum="3" name="Libraries"/>
		<mi:section manvolnum="4" name="Devices"/>
		<mi:section manvolnum="5" name="File formats"/>
		<mi:section manvolnum="6" name="Games"/>
		<mi:section manvolnum="7" name="Miscellaneous"/>
		<mi:section manvolnum="8" name="System utilities"/>
		<mi:section manvolnum="9" name="Kernel internals"/>
	</mi:sections>

	 <func:function name="mi:title">
		<xsl:param name="manvolnum"/>

		<func:result>
			<xsl:choose>
				<xsl:when test="document('')//mi:section[starts-with($manvolnum, @manvolnum)]">
					<xsl:value-of select="document('')//mi:section
						[starts-with($manvolnum, @manvolnum)]/@name"/>
				</xsl:when>

				<xsl:otherwise>
					<xsl:text>Section </xsl:text>
					<xsl:value-of select="$manvolnum"/>
				</xsl:otherwise>
			</xsl:choose>
		</func:result>
	</func:function>

</xsl:stylesheet>

