<?xml version="1.0" standalone="yes"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:mdb="http://xml.elide.org/minidocbook"
	xmlns="http://www.w3.org/1999/xhtml"

	xmlns:func="http://exslt.org/functions"

	extension-element-prefixes="func"

	exclude-result-prefixes="mdb">

	<!--
		TODO: when the dust settles, fold this all into output.xsl
	-->

	<xsl:template match="preface|chapter|appendix" mode="page-relname">
		<!-- relies on these element names being valid rel="" names -->
		<xsl:value-of select="name()"/>
	</xsl:template>

	<xsl:template match="preface|chapter|appendix" mode="page-filename">
		<xsl:value-of select="name()"/>
		<xsl:value-of select="count(preceding-sibling::*[name() = name(current())]) + 1"/>
	</xsl:template>

	<xsl:template name="navlink">
		<xsl:param name="filename"/>
		<xsl:param name="name"/>
		<xsl:param name="rel"/>

		<xsl:param name="predicate" select="$filename != ''"/>

		<xsl:choose>
			<xsl:when test="$predicate">
				<!-- TODO: @title. same for all <a> links. centralise that? -->
				<a href="{mdb:fileext($filename, $www-ext)}">
					<xsl:if test="$rel">
						<xsl:attribute name="rel">
							<xsl:value-of select="$rel"/>
						</xsl:attribute>
					</xsl:if>

					<xsl:value-of select="$name"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="edition">
		<span class="edition">
			<xsl:text> &#8211;&#xA0;</xsl:text>
			<xsl:value-of select="."/>
		</span>
	</xsl:template>

	<func:function name="mdb:prev">
		<xsl:param name="this"/>

		<!-- TODO: i don't like that this requires chunking and filename knowledge.
			it should be done in the root xsl file -->
		<xsl:choose>
			<xsl:when test="$this = 'toc'"/>
			<xsl:when test="$this = 'frontmatter'">
				<func:result select="$www-toc"/>
			</xsl:when>
			<xsl:when test="preceding-sibling::preface
				|preceding-sibling::chapter
				|preceding-sibling::appendix">
				<func:result>
					<xsl:apply-templates select="(preceding-sibling::preface
						|preceding-sibling::chapter
						|preceding-sibling::appendix)[position() = last()]" mode="page-filename"/>
				</func:result>
			</xsl:when>
			<xsl:otherwise>
				<func:result select="$www-front"/>
			</xsl:otherwise>
		</xsl:choose>
	</func:function>

	<func:function name="mdb:next">
		<xsl:param name="this"/>

		<!-- TODO: i don't like that this requires chunking and filename knowledge.
			it should be done in the root xsl file -->
		<xsl:choose>
			<xsl:when test="$this = 'toc'">
				<func:result select="$www-front"/>
			</xsl:when>
			<xsl:when test="$this = 'frontmatter'">
				<func:result>
					<xsl:apply-templates select="(preface|chapter|appendix)
						[position() = 1]" mode="page-filename"/>
				</func:result>
			</xsl:when>
			<xsl:when test="following-sibling::preface
				|following-sibling::chapter
				|following-sibling::appendix">
				<func:result>
					<xsl:apply-templates select="(following-sibling::preface
						|following-sibling::chapter
						|following-sibling::appendix)[position() = 1]" mode="page-filename"/>
				</func:result>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</func:function>

	<xsl:template name="navigation">
		<xsl:param name="this"/>

		<ul class="pages">
			<li>
				<xsl:call-template name="navlink">
					<xsl:with-param name="filename"  select="mdb:prev($this)"/>
					<xsl:with-param name="name"      select="'Prev'"/>
					<xsl:with-param name="rel"       select="'prev'"/>
				</xsl:call-template>
			</li>
			<li>
				<xsl:call-template name="navlink">
					<xsl:with-param name="filename"  select="$www-toc"/>
					<xsl:with-param name="name"      select="'Home'"/>
					<xsl:with-param name="predicate" select="$this != 'toc'"/>
					<xsl:with-param name="rel"       select="'contents'"/>
				</xsl:call-template>
			</li>
			<li>
				<xsl:call-template name="navlink">
					<xsl:with-param name="filename"  select="mdb:next($this)"/>
					<xsl:with-param name="name"      select="'Next'"/>
					<xsl:with-param name="rel"       select="'next'"/>
				</xsl:call-template>
			</li>
		</ul>
	</xsl:template>

	<xsl:template name="page-single">
		<xsl:param name="title"/>
		<xsl:param name="filename"/>
		<xsl:param name="chunklink"/>
		<xsl:param name="class" select="''"/>

		<xsl:param name="head" select="/.."/>

		<xsl:call-template name="output">
			<xsl:with-param name="class"    select="concat('minidocbook single ', $class)"/>
			<xsl:with-param name="filename" select="$filename"/>
			<xsl:with-param name="title"    select="$title"/>
			<xsl:with-param name="head"     select="$head"/>

			<xsl:with-param name="body">
				<xsl:if test="$chunklink">
					<nav class="top">
						<!-- TODO: call navlink instead -->
						<a href="{mdb:fileext($www-toc, $www-ext)}" rel="contents">
							<xsl:text>Multiple pages</xsl:text>
						</a>
					</nav>
				</xsl:if>

				<xsl:if test="name() != 'refentry'">
					<h1>
						<xsl:copy-of select="$title"/>
						<xsl:apply-templates select="bookinfo/edition|articleinfo/edition"/>
					</h1>

					<xsl:call-template name="toc">
						<xsl:with-param name="depth"  select="1"/>
					</xsl:call-template>

					<xsl:call-template name="frontmatter"/>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="name() = 'refentry'">
						<xsl:apply-templates select="refnamediv|refsynopsisdiv|refsection"/>
						<xsl:call-template name="refentryauthor"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="preface|chapter|section|appendix"/>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:if test="name() = 'article'">
					<xsl:call-template name="footnotes">
						<xsl:with-param name="predicate" select="'[not(ancestor::table)]'"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="page-toc">
		<xsl:param name="title"/>
		<xsl:param name="class" select="''"/>

		<xsl:param name="head" select="/.."/>

		<xsl:call-template name="output">
			<xsl:with-param name="class"    select="concat('minidocbook toc ', $class)"/>
			<xsl:with-param name="filename" select="$file-toc"/>
			<xsl:with-param name="title"    select="$title"/>
			<xsl:with-param name="head"     select="$head"/>

			<xsl:with-param name="prev" select="mdb:prev('toc')"/>
			<xsl:with-param name="next" select="mdb:next('toc')"/>

			<xsl:with-param name="body">
				<nav class="top">
					<a href="{mdb:fileext($www-single, $www-ext)}" rel="canonical">
						<xsl:text>Single page</xsl:text>
					</a>

					<xsl:call-template name="navigation">
						<xsl:with-param name="this" select="'toc'"/>
					</xsl:call-template>
				</nav>

				<h1>
					<xsl:copy-of select="$title"/>
					<xsl:apply-templates select="bookinfo/edition|articleinfo/edition"/>
				</h1>

				<xsl:call-template name="toc">
					<xsl:with-param name="depth"  select="1"/>
					<xsl:with-param name="single" select="false()"/>
				</xsl:call-template>

				<nav class="bottom">
					<xsl:call-template name="navigation">
						<xsl:with-param name="this" select="'toc'"/>
					</xsl:call-template>
				</nav>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="page-frontmatter">
		<xsl:param name="title"/>
		<xsl:param name="class" select="''"/>

		<xsl:param name="head" select="/.."/>

		<xsl:call-template name="output">
			<xsl:with-param name="class"    select="concat('minidocbook frontmatter ', $class)"/>
			<xsl:with-param name="filename" select="$file-front"/>
			<xsl:with-param name="title"    select="$title"/>
			<xsl:with-param name="head"     select="$head"/>

			<xsl:with-param name="prev" select="mdb:prev('frontmatter')"/>
			<xsl:with-param name="next" select="mdb:next('frontmatter')"/>

			<xsl:with-param name="body">
				<nav class="top">
					<a href="{mdb:fileext($www-single, $www-ext)}" rel="canonical">
						<xsl:text>Single page</xsl:text>
					</a>

					<xsl:call-template name="navigation">
						<xsl:with-param name="this" select="'frontmatter'"/>
					</xsl:call-template>
				</nav>

				<xsl:call-template name="frontmatter"/>

				<nav class="bottom">
					<xsl:call-template name="navigation">
						<xsl:with-param name="this" select="'frontmatter'"/>
					</xsl:call-template>
				</nav>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="page-chunk">
		<xsl:param name="title"/>
		<xsl:param name="filename"/>
		<xsl:param name="class" select="''"/>

		<xsl:param name="head" select="/.."/>

		<xsl:call-template name="output">
			<xsl:with-param name="class"    select="concat('minidocbook chunk ', $class)"/>
			<xsl:with-param name="filename" select="$filename"/>
			<xsl:with-param name="head"     select="$head"/>

			<xsl:with-param name="prev" select="mdb:prev('chunk')"/>
			<xsl:with-param name="next" select="mdb:next('chunk')"/>

			<xsl:with-param name="title">
				<xsl:apply-templates select="title" mode="title"/>
			</xsl:with-param>

			<xsl:with-param name="body">
				<nav class="top">
					<a href="{mdb:fileext($www-single, $www-ext)}" rel="canonical">
						<xsl:text>Single page</xsl:text>
					</a>

					<xsl:call-template name="navigation">
						<xsl:with-param name="this" select="'chunk'"/>
					</xsl:call-template>
				</nav>

				<xsl:apply-templates select="."/>

				<nav class="bottom">
					<xsl:call-template name="navigation">
						<xsl:with-param name="this" select="'chunk'"/>
					</xsl:call-template>
				</nav>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>

