<?xml version="1.0" standalone="yes"?>

<!-- $Id: output.xsl 199 2011-04-24 22:30:45Z kate $ -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"

	xmlns:common="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"

	extension-element-prefixes="common str"

	exclude-result-prefixes="common str">

	<!-- for HTML5 -->
	<xsl:output method="html" media-type="text/html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="www-base"/>
	<xsl:param name="www-css"/>
	<xsl:param name="www-js"/>
	<xsl:param name="www-ext" select="'xhtml5'"/>

	<xsl:template match="processing-instruction()">
		<xsl:message terminate="yes">
			<xsl:text>Unhandled PI: </xsl:text>
			<xsl:value-of select="name()"/>
		</xsl:message>
	</xsl:template>

	<xsl:template name="output">
		<xsl:param name="title"/>
		<xsl:param name="filename"/>
		<xsl:param name="css"      select="''"/>
		<xsl:param name="js"       select="''"/>
		<xsl:param name="head"     select="/.."/>
		<xsl:param name="body"     select="/.."/>
		<xsl:param name="class"    select="false()"/>

		<xsl:variable name="method">
			<xsl:choose>
				<xsl:when test="$www-ext = 'xhtml'">
					<xsl:value-of select="'xml'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'html'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- TODO: have these as a database of tags in this .xsl file and use document() to get them -->
		<xsl:variable name="media">
			<xsl:choose>
				<xsl:when test="$method = 'xml'">
					<xsl:text>application/xhtml+xml'/xml</xsl:text>
				</xsl:when>
				<xsl:when test="$method = 'html'">
					<xsl:text>text/html</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="doctype-public">
			<xsl:choose>
				<xsl:when test="$method = 'xml'">
					<xsl:text>-//W3C//DTD XHTML 1.0 Strict//EN</xsl:text>
				</xsl:when>
				<xsl:when test="$method = 'html'">
					<xsl:text>TODO</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="doctype-system">
			<xsl:choose>
				<xsl:when test="$method = 'xml'">
					<xsl:text>DTD/xhtml1-strict.dtd</xsl:text>
				</xsl:when>
				<xsl:when test="$method = 'html'">
					<xsl:text>TODO</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="output-file">
			<xsl:choose>
				<xsl:when test="$filename">
 					<xsl:value-of select="concat($filename, '.', $www-ext)"/>
				</xsl:when>

				<xsl:otherwise>
					<xsl:text>/dev/stdout</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:message>
			<xsl:text>Outputting </xsl:text>
			<xsl:value-of select="concat($output-file, ': &quot;', $title, '&quot;')"/>
		</xsl:message>

		<!--
			The idea here is that we never generate output in the default document tree;
			instead, <common:document> is used for all output. This means a filename given
			by xsltproc -o is always ignored. Instead, -o applies as a directory name only.
		-->
		<common:document
			href="{$output-file}"
			method="{$method}"
			encoding="utf-8"
			indent="yes"
			omit-xml-declaration="yes"
			cdata-section-elements="script"
			media-type="{$media}"
			standalone="yes">
<!-- XXX: only for non-HTML5
			doctype-public="{$doctype-public}"
			doctype-system="{$doctype-system}"
-->

			<xsl:if test="$method = 'html'">
				<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;&#xA;</xsl:text>
			</xsl:if>

			<xsl:call-template name="output-content">
				<xsl:with-param name="title"  select="$title"/>
				<xsl:with-param name="method" select="$method"/>
				<xsl:with-param name="css"    select="$css"/>
				<xsl:with-param name="js"     select="$js"/>
				<xsl:with-param name="head"   select="$head"/>
				<xsl:with-param name="body"   select="$body"/>
				<xsl:with-param name="class"  select="$class"/>
			</xsl:call-template>

		</common:document>
	</xsl:template>

	<xsl:template name="output-content">
		<xsl:param name="method" select="'xml'"/>
		<xsl:param name="css"    select="''"/>
		<xsl:param name="js"     select="''"/>
		<xsl:param name="onload" select="''"/>
		<xsl:param name="lang"   select="'en-gb'"/>
		<xsl:param name="class"  select="false()"/>

		<xsl:param name="title"  select="/.."/>
		<xsl:param name="head"   select="/.."/>
		<xsl:param name="body"   select="/.."/>

		<!-- XXX: hack -->
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>

		<!--
			The moznomarginboxes and mozdisallowselectionprint attributes here
			are meaningful to firefox; they elide the browser-supplied header
			and footer for printed content.
			What a horrible way to expose that setting.
		-->
		<html lang="{$lang}"
			moznomarginboxes="moznomarginboxes"
			mozdisallowselectionprint="mozdisallowselectionprint">

			<xsl:if test="$class">
				<xsl:attribute name="class">
					<xsl:value-of select="$class"/>
				</xsl:attribute>
			</xsl:if>

			<head>
				<title>
					<xsl:value-of select="$title"/>
				</title>

				<xsl:if test="$www-base">
					<base href="{$www-base}"/>
				</xsl:if>

				<!-- TODO: maybe a node set is better, after all -->
				<xsl:for-each select="str:tokenize($css)">
					<link rel="stylesheet" type="text/css" media="all" href="{$www-css}/{.}"/>
				</xsl:for-each>

				<xsl:for-each select="str:tokenize($js)">
					<script type="text/javascript" src="{$www-js}/{.}"></script>
				</xsl:for-each>

				<xsl:if test="$method = 'html'">
					<meta http-equiv="Content-Type"
						content="text/html; charset=utf-8"/>
				</xsl:if>

				<xsl:copy-of select="$head"/>
			</head>

			<body onload="var r = document.documentElement; {$onload}">
				<xsl:copy-of select="$body"/>
			</body>
		</html>

	</xsl:template>

</xsl:stylesheet>

