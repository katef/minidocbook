<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:common="http://exslt.org/common"

	extension-element-prefixes="str common"

	exclude-result-prefixes="str common">

	<xsl:output
		method="xml"
		indent="yes"/>

	<xsl:param name="src"/> <!-- e.g. 'a/b/c.xhtml:a/b/d.xhtml:a/x.xhtml' -->
	<xsl:param name="prefix" select="'.'"/>
	<xsl:param name="title" select="false()"/>

	<xsl:template name="doc">
		<xsl:param name="doc"/>

		<article data-title="{document($doc)/html/head/title}">
			<xsl:copy-of select="document($doc)/html/body/*"/>
		</article>
	</xsl:template>

	<xsl:template name="thing">
		<xsl:param name="src"/>
		<xsl:param name="cwd" select="$prefix"/>

		<xsl:for-each select="$src">
			<xsl:sort select="."/>

			<xsl:variable name="dir" select="substring-before(., '/')"/>

			<xsl:choose>
				<xsl:when test="not($dir)">
					<xsl:call-template name="doc">
						<xsl:with-param name="doc" select="concat($cwd, '/', .)"/>
					</xsl:call-template>
				</xsl:when>

				<xsl:when test="count(preceding-sibling::*[$dir = substring-before(node(), '/')]) = 0">
					<section>
						<title>
							<xsl:value-of select="$dir"/>
						</title>

						<xsl:variable name="next">
							<xsl:for-each select="$src">
								<xsl:if test="starts-with(., concat($dir, '/'))">
									<xsl:element name="{name()}" namespace="{namespace-uri()}">
										<xsl:value-of select="substring-after(., '/')"/>
									</xsl:element>
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>

						<xsl:if test="count(common:node-set($next)/*) != 0">
							<xsl:call-template name="thing">
								<xsl:with-param name="src" select="common:node-set($next)/*"/>
								<xsl:with-param name="cwd" select="concat($cwd, '/', $dir)"/>
							</xsl:call-template>
						</xsl:if>
					</section>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="/">
		<html>
			<xsl:if test="$title">
				<head>
					<title>
						<xsl:value-of select="$title"/>
					</title>
				</head>
			</xsl:if>

			<body>
				<xsl:call-template name="thing">
					<xsl:with-param name="src" select="str:tokenize($src, ':')"/>
				</xsl:call-template>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>

