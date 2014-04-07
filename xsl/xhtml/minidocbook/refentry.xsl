<?xml version="1.0" standalone="yes"?>

<!-- $Id$ -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">

	<xsl:template name="refentrytitle">
		<xsl:param name="manvolnum" select="false()"/>
		<xsl:param name="refentrytitle"/>

		<span class="command donthyphenate">
			<xsl:if test="$manvolnum">
				<xsl:attribute name="data-manvolnum">
					<xsl:value-of select="$manvolnum"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="$refentrytitle"/>
		</span>
	</xsl:template>

	<xsl:template name="refentryauthor">
XXX:
	</xsl:template>

	<xsl:template match="refsection">
		<xsl:variable name="u" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ '"/>
		<xsl:variable name="l" select="'abcdefghijklmnopqrstuvwxyz_'"/>

		<section class="refsection {translate(title, $u, $l)}">
			<xsl:apply-templates select="title">
				<xsl:with-param name="number" select="false()"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="*[name() != 'title']"/>

			<xsl:call-template name="footnotes">
				<xsl:with-param name="predicate" select="'[not(ancestor::table)]'"/>
			</xsl:call-template>
		</section>
	</xsl:template>

	<xsl:template match="refname|refpurpose|refentrytitle">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="refnamediv">
		<section class="refsection refnamediv">
			<xsl:call-template name="title-output">
				<xsl:with-param name="number" select="false()"/>
				<xsl:with-param name="title"  select="'Name'"/>
			</xsl:call-template>

			<p>
				<xsl:for-each select="refname">
					<xsl:call-template name="reflink">
						<xsl:with-param name="manvolnum"     select="../../refmeta/manvolnum"/>
						<xsl:with-param name="refentrytitle" select="."/>
					</xsl:call-template>

					<xsl:if test="position() != last()">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
				<xsl:text>&#x2009;&#x2014;&#x2009;</xsl:text>
				<xsl:apply-templates select="refpurpose"/>
			</p>
		</section>
	</xsl:template>

	<xsl:template match="refsynopsisdiv">
		<section class="refsection synopsis">
			<xsl:call-template name="title-output">
				<xsl:with-param name="number" select="false()"/>
				<xsl:with-param name="title"  select="'Synopsis'"/>
			</xsl:call-template>

			<xsl:apply-templates select="cmdsynopsis|synopsis|para"/>
		</section>
	</xsl:template>

	<xsl:template name="cmd-opt">
		<xsl:param name="content"/>

		<xsl:choose>
			<xsl:when test="not(@choice) or @choice = 'opt'">
				<xsl:text>[&#x202F;</xsl:text>
			</xsl:when>
			<xsl:when test="@choice = 'req'">
				<xsl:text>{&#x202F;</xsl:text>
			</xsl:when>
		</xsl:choose>

		<xsl:copy-of select="$content"/>

		<xsl:if test="@rep = 'repeat'">
			<xsl:text>&#8230;</xsl:text>
		</xsl:if>

		<xsl:choose>
			<xsl:when test="not(@choice) or @choice = 'opt'">
				<xsl:text>&#x202F;] </xsl:text>
			</xsl:when>
			<xsl:when test="@choice = 'req'">
				<xsl:text>&#x202F;} </xsl:text>
			</xsl:when>
			<xsl:when test="position() != last()">
				<xsl:text>&#160;</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="cmdsynopsis">
		<p class="cmdsynopsis">
			<span class="cmd">
				<xsl:apply-templates select="command"/>
			</span>

			<xsl:text>&#160;</xsl:text>

			<div class="args">
				<xsl:apply-templates select="arg|group|sbr"/>
			</div>
		</p>
	</xsl:template>

	<xsl:template match="arg">
		<xsl:call-template name="cmd-opt">
			<xsl:with-param name="content">
				<!-- TODO: only link if the ancestor axis contains refsynopsisdiv -->
				<!-- TODO: this is a bit hacky; make it more unique somehow -->
				<a href="#arg{option}">
					<xsl:apply-templates/>
				</a>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="group">
		<xsl:call-template name="cmd-opt">
			<xsl:with-param name="content">
				<!-- TODO: considering sorting lexographically -->
				<xsl:for-each select="arg|group|option|replaceable">
					<xsl:if test="position() != 1">
						<xsl:text> | </xsl:text>
					</xsl:if>

					<xsl:apply-templates select="."/>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="sbr">
		<br/>
	</xsl:template>

</xsl:stylesheet>

