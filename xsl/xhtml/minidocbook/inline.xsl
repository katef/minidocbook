<?xml version="1.0" standalone="yes"?>

<!-- $Id$ -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">

	<xsl:template match="acronym">
		<xsl:choose>
			<xsl:when test="not(@role)">
				<abbr>
					<xsl:apply-templates/>
				</abbr>
			</xsl:when>

			<xsl:when test="ancestor::refnamediv">
				<abbr>
					<xsl:apply-templates/>
				</abbr>
			</xsl:when>

			<!-- first (non-refnamediv) occurance -->
			<xsl:when test="not(preceding::acronym
					[not(ancestor::refnamediv)]
					[. = current()])">
				<abbr class="title" title="{@role}">
					<xsl:apply-templates/>
				</abbr>
			</xsl:when>

			<xsl:otherwise>
				<abbr title="{@role}">
					<xsl:apply-templates/>
				</abbr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="command">
		<span class="{name()}">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="userinput|computeroutput">	<!-- TODO: dissallow -->
		<tt class="{name()}">
			<xsl:apply-templates/>
		</tt>
	</xsl:template>

	<xsl:template match="application">	<!-- TODO: dissalow? or use it to link to a project page? -->
		<span class="{name()}">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="code">
		<code>
			<xsl:apply-templates/>
		</code>
	</xsl:template>

	<xsl:template match="varname|type|token|parameter|constant|function|literal">	<!-- TODO: dissallow -->
		<code class="{name()}">
			<xsl:apply-templates/>
		</code>
	</xsl:template>

	<xsl:template match="emphasis">
		<em>
			<xsl:apply-templates/>
		</em>
	</xsl:template>

	<xsl:template match="superscript">	<!-- TODO: dissallow -->
		<sup>
			<xsl:apply-templates/>
		</sup>
	</xsl:template>

	<xsl:template match="subscript">	<!-- TODO: dissallow -->
		<sub>
			<xsl:apply-templates/>
		</sub>
	</xsl:template>

	<xsl:template match="option">
		<tt class="{name()}">
			<xsl:apply-templates/>
		</tt>
	</xsl:template>

	<xsl:template match="filename">
		<tt class="{name()}">
			<xsl:apply-templates/>
		</tt>
	</xsl:template>

	<xsl:template match="replaceable|citetitle|firstterm">
		<i class="{name()}">
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="quote">
		<q>
			<xsl:apply-templates/>
		</q>
	</xsl:template>

</xsl:stylesheet>

