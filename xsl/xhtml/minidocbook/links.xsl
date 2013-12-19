<?xml version="1.0" standalone="yes"?>

<!-- $Id$ -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:mdb="http://xml.elide.org/minidocbook"
	xmlns="http://www.w3.org/1999/xhtml">

	<!--
		Links
	-->

	<xsl:template match="xref">
		<!-- TODO: simplify -->

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

	<xsl:template match="citerefentry" name="citerefentry">
		<xsl:param name="manvolnum"     select="manvolnum"/>
		<xsl:param name="refentrytitle" select="refentrytitle"/>
		<xsl:param name="role"          select="@role"/>

		<xsl:choose>
			<!-- own page -->
			<xsl:when test="not($role = 'index')
				and /refentry/refnamediv/refname[. = $refentrytitle]
				and /refentry/refmeta/manvolnum    = $manvolnum">
				<xsl:call-template name="refentrytitle">
					<xsl:with-param name="refentrytitle" select="$refentrytitle"/>
				</xsl:call-template>
			</xsl:when>

			<xsl:when test="($mdb.url.man or $mdb.url.man = '') and not($role = 'dontlink')">
				<a href="{$mdb.url.man}/{$refentrytitle}.{$manvolnum}/">
					<xsl:call-template name="refentrytitle">
						<xsl:with-param name="manvolnum"     select="$manvolnum"/>
						<xsl:with-param name="refentrytitle" select="$refentrytitle"/>
					</xsl:call-template>
				</a>
			</xsl:when>

			<xsl:otherwise>
				<xsl:call-template name="refentrytitle">
					<xsl:with-param name="manvolnum"     select="$manvolnum"/>
					<xsl:with-param name="refentrytitle" select="$refentrytitle"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ulink">
		<a href="{@url}">
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

