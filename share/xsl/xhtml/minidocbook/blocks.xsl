<?xml version="1.0" standalone="yes"?>

<!--
	Copyright 2009-2017 Katherine Flavel

	See LICENCE for the full copyright terms.
-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">

	<xsl:template match="preface|chapter|appendix">
		<section class="chapter">
			<xsl:apply-templates select="title"/>

			<xsl:call-template name="toc">
				<xsl:with-param name="depth" select="2"/>
			</xsl:call-template>

			<xsl:apply-templates select="*[name() != 'title']"/>

			<xsl:call-template name="footnotes">
				<xsl:with-param name="predicate" select="'[not(ancestor::table)]'"/>
			</xsl:call-template>
		</section>
	</xsl:template>

	<xsl:template match="section|bibliography">
		<section class="section">
			<xsl:apply-templates/>
		</section>
	</xsl:template>

	<xsl:template match="graphic">
		<xsl:copy-of select="document(@fileref)"/>
	</xsl:template>

	<xsl:template match="figure">
		<figure>
			<xsl:apply-templates select="title" mode="id"/>

			<xsl:apply-templates select="graphic|literallayout"/>

			<xsl:apply-templates select="title"/>
		</figure>
	</xsl:template>

	<xsl:template match="informalfigure">
		<figure>
			<xsl:apply-templates select="graphic|literallayout"/>
		</figure>
	</xsl:template>

	<xsl:template match="para">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="programlisting|synopsis">
		<pre class="{name()} {@language}">
			<xsl:apply-templates/>
		</pre>
	</xsl:template>

	<xsl:template match="screen">
		<pre class="screen">
			<xsl:apply-templates/>
		</pre>
	</xsl:template>

	<xsl:template match="blockquote">
		<blockquote>
			<xsl:apply-templates/>
		</blockquote>
	</xsl:template>

	<xsl:template match="literallayout">
		<blockquote class="literallayout">
			<xsl:apply-templates/>
		</blockquote>
	</xsl:template>

	<!-- TODO: i don't like these much. they look tacky, and are too easy to overuse -->
	<xsl:template match="warning">
		<div class="{name()}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

</xsl:stylesheet>

