<?xml version="1.0" standalone="yes"?>

<!-- $Id$ -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns="http://www.w3.org/1999/xhtml"

	xmlns:common="http://exslt.org/common"

	extension-element-prefixes="common">

	<xsl:template name="footer">
		<xsl:param name="bottomright"/>

		<div class="footer">
			<xsl:if test="$bottomright">
				<div class="bottomright">
					<xsl:copy-of select="$bottomright"/>
				</div>
			</xsl:if>

			<!-- TODO: add generation date and document date -->
			<!-- TODO: leave copyrights to the frontmatter, instead -->
		</div>
	</xsl:template>


	<xsl:template name="output">
		<xsl:param name="filename"/>
		<xsl:param name="title"/>
		<xsl:param name="bottomright" select="/.."/>

		<xsl:param name="content"    select="false"/>

		<xsl:message>
			<xsl:text>Outputting </xsl:text>
			<xsl:value-of select="concat($filename, '.xhtml: &quot;', $title, '&quot;')"/>
		</xsl:message>

		<common:document
			href="{$filename}.xhtml"
			method="xml"
			encoding="utf-8"
			indent="yes"
			omit-xml-declaration="no"
			cdata-section-elements="script"
			media-type="application/xhtml+xml"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
			doctype-system="DTD/xhtml1-strict.dtd"
			standalone="yes">

			<html>
				<head>
					<title>
						<xsl:value-of select="$title"/>
					</title>

					<!-- TODO: meta headers for prev/next links -->
				</head>

				<body onload="var r = document.documentElement;
					Linenumbers.init(r);
					Colalign.init(r);
					Table.init(r)">

					<xsl:copy-of select="$content"/>

					<xsl:call-template name="footer">
						<xsl:with-param name="bottomright" select="$bottomright"/>
					</xsl:call-template>
				</body>
			</html>

		</common:document>
	</xsl:template>

</xsl:stylesheet>

