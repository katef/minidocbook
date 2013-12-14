<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:common="http://exslt.org/common"
	xmlns:mi="http://xml.elide.org/manindex"

	extension-element-prefixes="str common"

	exclude-result-prefixes="str common mi">

	<xsl:import href="output.xsl"/>

	<xsl:param name="src"/>
	<xsl:param name="title" select="false()"/>

	<mi:sections>
		<mi:section manvolnum="1" name="User programs"/>
		<mi:section manvolnum="2" name="System calls"/>
		<mi:section manvolnum="3" name="Library interfaces"/>
		<mi:section manvolnum="4" name="Device drivers"/>
		<mi:section manvolnum="5" name="File formats"/>
		<mi:section manvolnum="6" name="Games"/>
		<mi:section manvolnum="7" name="Miscellaneous"/>
		<mi:section manvolnum="8" name="System utilities"/>
		<mi:section manvolnum="9" name="Kernel internals"/>
	</mi:sections>

	<xsl:variable name="root">
		<xsl:for-each select="str:tokenize($src, ':')">
			<xsl:copy-of select="document(.)/refentry"/>
		</xsl:for-each>
	</xsl:variable>

	 <xsl:template name="section-title">
		<xsl:param name="manvolnum"/>

			<xsl:choose>
				<xsl:when test="document('')//mi:section[@manvolnum = $manvolnum]">
					<xsl:value-of select="document('')//mi:section
						[@manvolnum = $manvolnum]/@name"/>
				</xsl:when>

				<xsl:otherwise>
					<xsl:text>Section </xsl:text>
					<xsl:value-of select="$manvolnum"/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>

	<xsl:template match="refentry">
		<tr>
			<th>
				<xsl:for-each select="refnamediv/refname">
					<xsl:sort select="."/>

					<a href="{concat(../../refmeta/refentrytitle,
						'.', ../../refmeta/manvolnum)}">	<!-- canonical page name -->
						<!-- TODO: apply-templates for proper XHTML output -->
						<span class="command" data-manvolnum="{../../refmeta/manvolnum}">
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
				<xsl:value-of select="refnamediv/refpurpose"/>
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
				<xsl:apply-templates select="common:node-set($root)/refentry
					[refmeta/manvolnum = $manvolnum]
					[not($productname) or refentryinfo/productname = $productname]">
					<xsl:sort select="."/>
				</xsl:apply-templates>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="manvolnum" mode="section">
		<xsl:variable name="manvolnum" select="."/>

		<section>
			<h1>
				<a id="{.}"/>
				<xsl:call-template name="section-title">
					<xsl:with-param name="manvolnum" select="$manvolnum"/>
				</xsl:call-template>
			</h1>

			<xsl:if test="common:node-set($root)/refentry
				[refmeta/manvolnum = current()]
				[not(refentryinfo/productname)]">
				<xsl:call-template name="section">
					<xsl:with-param name="manvolnum" select="$manvolnum"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:for-each select="common:node-set($root)/refentry
				[refmeta/manvolnum = current()]/refentryinfo/productname
				[not(. = ../../preceding-sibling::refentry
					[refmeta/manvolnum = current()]/refentryinfo/productname)]">
				<xsl:sort select="."/>
				<xsl:call-template name="section">
					<xsl:with-param name="manvolnum"   select="$manvolnum"/>
					<xsl:with-param name="productname" select="."/>
				</xsl:call-template>
			</xsl:for-each>
		</section>
	</xsl:template>

	<xsl:template match="/">
		<xsl:call-template name="output">
			<xsl:with-param name="class"  select="'minidocbook manindex'"/>

			<xsl:with-param name="title">
				<xsl:if test="$title">
					<xsl:value-of select="$title"/>
				</xsl:if>
			</xsl:with-param>

			<xsl:with-param name="body">
				<xsl:apply-templates select="common:node-set($root)/refentry/refmeta/manvolnum
					[not(. = ../../preceding-sibling::refentry/refmeta/manvolnum)]" mode="section">
					<xsl:sort select="."/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>

