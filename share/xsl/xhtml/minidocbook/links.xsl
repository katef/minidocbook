<?xml version="1.0" standalone="yes"?>

<!--
	Copyright 2009-2017 Katherine Flavel

	See LICENCE for the full copyright terms.
-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:mdb="http://xml.elide.org/minidocbook"
	xmlns="http://www.w3.org/1999/xhtml"

	exclude-result-prefixes="mdb">

	<!--
		Links
	-->

	<xsl:template name="reflink">
		<xsl:param name="manvolnum"/>
		<xsl:param name="refentrytitle"/>
		<xsl:param name="role"     select="false()"/>
		<xsl:param name="refclass" select="false()"/>

		<!-- TODO: have callers apply-templates for refentrytitle and manvolnum first -->

		<xsl:choose>
			<!-- own page -->
			<xsl:when test="not($role = 'index')
				and /refentry/refnamediv/refname[. = $refentrytitle]
				and /refentry/refmeta/manvolnum    = $manvolnum">
				<xsl:call-template name="refentrytitle">
					<xsl:with-param name="refentrytitle" select="$refentrytitle"/>
					<xsl:with-param name="refclass"      select="$refclass"/>
				</xsl:call-template>
			</xsl:when>

			<xsl:when test="($www-man or $www-man = '') and not($role = 'dontlink')">
				<a href="{$www-man}/{$refentrytitle}.{$manvolnum}/">
					<xsl:call-template name="refentrytitle">
						<xsl:with-param name="manvolnum"     select="$manvolnum"/>
						<xsl:with-param name="refentrytitle" select="$refentrytitle"/>
						<xsl:with-param name="refclass"      select="$refclass"/>
					</xsl:call-template>
				</a>
			</xsl:when>

			<xsl:otherwise>
				<xsl:call-template name="refentrytitle">
					<xsl:with-param name="manvolnum"     select="$manvolnum"/>
					<xsl:with-param name="refentrytitle" select="$refentrytitle"/>
					<xsl:with-param name="refclass"      select="$refclass"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="xref">
		<!-- TODO: simplify, or possibly merge into reflink as a different $role -->

		<xsl:if test="count(
			 //preface [@id = current()/@linkend]
			|//chapter [@id = current()/@linkend]
			|//section [@id = current()/@linkend]
			|//appendix[@id = current()/@linkend]) = 0">
			<xsl:message>
				<xsl:text>Linkend </xsl:text>
				<xsl:value-of select="@linkend"/>
				<xsl:text> not found</xsl:text>
			</xsl:message>
		</xsl:if>

		<xsl:for-each select="
			 //preface [@id = current()/@linkend]
			|//chapter [@id = current()/@linkend]
			|//section [@id = current()/@linkend]
			|//appendix[@id = current()/@linkend]" mode="linkend">

			<!-- TODO: multi-page links -->
			<a href="#{mdb:sectionnumber-link()}">
				<xsl:text>&#167;</xsl:text>
				<xsl:value-of select="mdb:sectionnumber()"/>
			</a>

			<xsl:if test="position() > 0">
				<xsl:message>
					<xsl:text>Linkend </xsl:text>
					<xsl:value-of select="@linkend"/>
					<xsl:text> found multiple times</xsl:text>
				</xsl:message>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="citerefentry">
		<xsl:call-template name="reflink">
			<xsl:with-param name="manvolnum"     select="manvolnum"/>
			<xsl:with-param name="refentrytitle" select="refentrytitle"/>
			<xsl:with-param name="role"          select="@role"/>
			<xsl:with-param name="refclass"      select="substring(manvolnum, 2)"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="ulink">
		<a rel="external" href="{@url}">
			<xsl:apply-templates/>
		</a>
	</xsl:template>

	<xsl:template match="link">
		<!-- TODO: unimplemented -->
		<a href="#TODO">
			<xsl:apply-templates/>
		</a>
	</xsl:template>

</xsl:stylesheet>

