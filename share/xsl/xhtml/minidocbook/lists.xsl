<?xml version="1.0" standalone="yes"?>

<!--
	Copyright 2009-2017 Katherine Flavel

	See LICENCE for the full copyright terms.
-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">

	<xsl:template match="orderedlist">
		<ol>
			<xsl:apply-templates/>
		</ol>
	</xsl:template>

	<xsl:template match="itemizedlist">
		<ul>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match="listitem">
		<li>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="variablelist">
		<dl>
			<xsl:apply-templates>
				<xsl:sort select="varlistentry/term"/>
			</xsl:apply-templates>
		</dl>
	</xsl:template>

	<xsl:template match="varlistentry">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="varlistentry/term">
		<dt>
			<xsl:if test="string-length(.) &lt;= 2">
				<xsl:attribute name="class">
					<xsl:text>narrow</xsl:text>
				</xsl:attribute>
			</xsl:if>

			<xsl:if test="option">
				<xsl:attribute name="id">
					<xsl:value-of select="concat('arg', option)"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates/>
		</dt>
	</xsl:template>

	<xsl:template match="varlistentry/listitem">
		<dd>
			<xsl:apply-templates/>
		</dd>
	</xsl:template>

</xsl:stylesheet>

