<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:str="http://exslt.org/strings"

	extension-element-prefixes="str">

	<xsl:output method="text" encoding="utf-8"/>

	<xsl:variable name="command" select="/refentry/refsynopsisdiv/cmdsynopsis[1]/command"/>

	<xsl:template name="indent">
		<xsl:value-of select="str:padding(string-length($command), ' ')"/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template name="line">
		<xsl:param name="last" select="false()"/>
		<xsl:param name="text"/>

		<xsl:text>    "</xsl:text>
		<xsl:copy-of select="$text"/>
		<xsl:text>"</xsl:text>
		<xsl:if test="not($last)">
			<xsl:text>,</xsl:text>
		</xsl:if>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="/">
		<xsl:text>/* generated from </xsl:text>
		<xsl:value-of select="/refentry/refmeta/refentrytitle"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="/refentry/refmeta/manvolnum"/>
		<xsl:text>) by refentry-usage.xsl */ &#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>

		<xsl:text>static const char *usage[] = {&#10;</xsl:text>
		<xsl:apply-templates select="/refentry/refsynopsisdiv"/>
		<xsl:text>};&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="refsynopsisdiv">
		<xsl:for-each select="cmdsynopsis|synopsis|para">
			<xsl:call-template name="line">
				<xsl:with-param name="last" select="position() = last()"/>
				<xsl:with-param name="text">
					<xsl:apply-templates select="."/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="para">
		<xsl:call-template name="br"/>
		<xsl:value-of select="normalize-space(.)"/>
		<!-- TODO: output br for embedded newlines -->
		<xsl:call-template name="br"/>
	</xsl:template>

	<xsl:template name="cmd-opt">
		<xsl:param name="content"/>

		<xsl:choose>
			<xsl:when test="not(@choice) or @choice = 'opt'">
				<xsl:text>[</xsl:text>
			</xsl:when>
			<xsl:when test="@choice = 'req'">
				<xsl:text>{</xsl:text>
			</xsl:when>
		</xsl:choose>

		<xsl:copy-of select="$content"/>

		<xsl:if test="@rep = 'repeat'">
			<xsl:text>...</xsl:text>
		</xsl:if>

		<xsl:choose>
			<xsl:when test="not(@choice) or @choice = 'opt'">
				<xsl:text>] </xsl:text>
			</xsl:when>
			<xsl:when test="@choice = 'req'">
				<xsl:text>} </xsl:text>
			</xsl:when>
			<xsl:when test="position() != last()">
				<xsl:text> </xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="cmdsynopsis">
		<xsl:apply-templates select="command"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="arg|group|sbr"/>
	</xsl:template>

	<xsl:template match="arg">
		<xsl:call-template name="cmd-opt">
			<xsl:with-param name="content">
				<xsl:apply-templates/>
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

	<xsl:template name="br">
		<xsl:text>",&#10;</xsl:text>
		<xsl:text>    "</xsl:text>
	</xsl:template>

	<xsl:template name="sbr" match="sbr">
		<xsl:call-template name="br"/>
		<xsl:call-template name="indent"/>
	</xsl:template>

</xsl:stylesheet>

