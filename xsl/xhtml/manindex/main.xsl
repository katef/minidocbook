<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:mi="http://xml.elide.org/manindex"

	exclude-result-prefixes="mi">

	<xsl:import href="copy.xsl"/>
	<xsl:import href="output.xsl"/>

	<xsl:template match="mi:refentry">
		<tr>
			<th>
				<xsl:for-each select="mi:refnamediv/mi:refname">
					<xsl:sort select="."/>

					<a href="{concat(../../mi:refmeta/mi:refentrytitle,
						'.', ../../mi:refmeta/mi:manvolnum)}">	<!-- canonical page name -->
						<!-- TODO: apply-templates for proper XHTML output -->
						<span class="command" data-manvolnum="{../../mi:refmeta/mi:manvolnum}">
							<xsl:value-of select="."/>
						</span>
					</a>

					<!-- I would rather do this in CSS, but I can't see how wrt. floats -->
					<xsl:if test="position() != last()">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</th>

			<td>
				<xsl:value-of select="mi:refnamediv/mi:refpurpose"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template name="section">
		<xsl:param name="manvolnum"/>
		<xsl:param name="productname"/>

		<xsl:if test="$productname">
			<h2>
				<span class="product">
					<xsl:value-of select="$productname"/>
				</span>
			</h2>
		</xsl:if>

		<table>
			<tbody>
				<xsl:apply-templates select="//mi:refentry
					[mi:refmeta/mi:manvolnum = $manvolnum]
					[not($productname) or mi:refentryinfo/mi:productname = $productname]">
					<xsl:sort select="."/>
				</xsl:apply-templates>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="mi:manvolnum" mode="section">
		<xsl:variable name="manvolnum" select="."/>

		<section class="manindex">
			<h1>
				<a id="{.}"/>
				<xsl:text>Section </xsl:text>
				<xsl:value-of select="$manvolnum"/>
			</h1>

			<xsl:if test="//mi:refentry
				[mi:refmeta/mi:manvolnum = current()]
				[not(mi:refentryinfo/mi:productname)]">
				<xsl:call-template name="section">
					<xsl:with-param name="manvolnum" select="$manvolnum"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:for-each select="//mi:refentry
				[mi:refmeta/mi:manvolnum = current()]/mi:refentryinfo/mi:productname
				[not(. = ../../preceding-sibling::mi:refentry
					[mi:refmeta/mi:manvolnum = current()]/mi:refentryinfo/mi:productname)]">
				<xsl:sort select="."/>
				<xsl:call-template name="section">
					<xsl:with-param name="manvolnum"   select="$manvolnum"/>
					<xsl:with-param name="productname" select="."/>
				</xsl:call-template>
			</xsl:for-each>
		</section>
	</xsl:template>

	<xsl:template match="/mi:manindex">

		<xsl:call-template name="output-content">
			<xsl:with-param name="method" select="'xml'"/>

			<xsl:with-param name="title">
<!-- TODO -->
			</xsl:with-param>

			<xsl:with-param name="body">
				<xsl:apply-templates select="mi:refentry/mi:refmeta/mi:manvolnum
					[not(. = ../../preceding-sibling::mi:refentry/mi:refmeta/mi:manvolnum)]" mode="section">
					<xsl:sort select="."/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:call-template>

	</xsl:template>

</xsl:stylesheet>

