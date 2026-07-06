<?xml version="1.0" encoding="UTF-8"?>
<!--
  DocBook 5.2 -> HTML5 transform for the PQAN white paper.
  Emits a self-contained HTML5 document with:
    - Dublin Core <meta> tags (from the dc: metadata block)
    - Schema.org JSON-LD (from bibliomisc[@role='schema-org-jsonld'])
    - MathJax rendering for <mathphrase role="tex"> (inline \(..\), display \[..\])
    - sequential, hyperlinked citation numbering
    - CSS color-coding for finding sections (role='finding' + @condition)
  XSLT 1.0 (xsltproc).
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:schema="https://schema.org/"
    exclude-result-prefixes="d dc schema">

  <xsl:output method="html" encoding="UTF-8" indent="yes"
              doctype-system="about:legacy-compat"/>

  <xsl:key name="bib" match="d:bibliomixed" use="@xml:id"/>

  <!-- ======================================================= root ==== -->
  <xsl:template match="/d:article">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="d:info/d:title"/></title>

        <!-- Dublin Core meta tags, derived from native DocBook <info> elements -->
        <meta name="DC.title" content="{normalize-space(d:info/d:title)}"/>
        <xsl:if test="d:info/d:author">
          <meta name="DC.creator" content="{normalize-space(d:info/d:author/d:personname)}"/>
        </xsl:if>
        <xsl:if test="d:info/d:keywordset">
          <meta name="DC.subject">
            <xsl:attribute name="content">
              <xsl:for-each select="d:info/d:keywordset/d:keyword">
                <xsl:if test="position() &gt; 1">; </xsl:if>
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:for-each>
            </xsl:attribute>
          </meta>
        </xsl:if>
        <xsl:if test="d:info/d:abstract">
          <meta name="DC.description" content="{normalize-space(d:info/d:abstract/d:para[1])}"/>
        </xsl:if>
        <xsl:if test="d:info/d:publisher">
          <meta name="DC.publisher" content="{normalize-space(d:info/d:publisher/d:publishername)}"/>
        </xsl:if>
        <xsl:if test="d:info/d:pubdate">
          <meta name="DC.date" content="{normalize-space(d:info/d:pubdate)}"/>
        </xsl:if>
        <meta name="DC.type" content="{normalize-space(d:info/d:bibliomisc[@role='dc-type'])}"/>
        <meta name="DC.language" content="{normalize-space(d:info/d:bibliomisc[@role='dc-language'])}"/>
        <meta name="DC.rights" content="AGPL-3.0-or-later"/>

        <!-- Schema.org JSON-LD (carried verbatim as text in a bibliomisc) -->
        <xsl:for-each select="d:info/d:bibliomisc[@role='schema-org-jsonld']">
          <script type="application/ld+json"><xsl:value-of select="."/></script>
        </xsl:for-each>

        <style><xsl:call-template name="css"/></style>

        <!-- MathJax -->
        <script>
          window.MathJax = {
            tex: { inlineMath: [['\\(','\\)']], displayMath: [['\\[','\\]']] },
            svg: { fontCache: 'global' }
          };
        </script>
        <script async="async" src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
      </head>
      <body>
        <main>
          <article>
            <header>
              <h1><xsl:value-of select="d:info/d:title"/></h1>
              <xsl:if test="d:info/d:author">
                <p class="byline">
                  <xsl:value-of select="normalize-space(d:info/d:author/d:personname)"/>
                  <xsl:if test="d:info/d:othercredit">
                    <xsl:text> (with </xsl:text>
                    <xsl:value-of select="normalize-space(d:info/d:othercredit/d:orgname)"/>
                    <xsl:text>)</xsl:text>
                  </xsl:if>
                </p>
              </xsl:if>
              <xsl:if test="d:info/d:pubdate">
                <p class="pubdate"><time datetime="{d:info/d:pubdate}"><xsl:value-of select="d:info/d:pubdate"/></time></p>
              </xsl:if>
              <xsl:if test="d:info/d:abstract">
                <section class="abstract">
                  <h2>Abstract</h2>
                  <xsl:for-each select="d:info/d:abstract/d:para">
                    <p><xsl:apply-templates/></p>
                  </xsl:for-each>
                </section>
              </xsl:if>
            </header>
            <xsl:apply-templates select="d:section"/>
            <xsl:apply-templates select="d:bibliography"/>
          </article>
        </main>
      </body>
    </html>
  </xsl:template>

  <!-- ==================================================== sections ==== -->
  <xsl:template match="d:section">
    <xsl:variable name="level" select="count(ancestor-or-self::d:section)"/>
    <xsl:variable name="hn">
      <xsl:choose>
        <xsl:when test="$level + 1 &gt; 6">6</xsl:when>
        <xsl:otherwise><xsl:value-of select="$level + 1"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <section>
      <xsl:if test="@xml:id"><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute></xsl:if>
      <xsl:if test="@role='finding'">
        <xsl:attribute name="class">finding finding-<xsl:value-of select="@condition"/></xsl:attribute>
      </xsl:if>
      <xsl:element name="h{$hn}">
        <xsl:value-of select="d:title"/>
      </xsl:element>
      <xsl:apply-templates select="node()[not(self::d:title)]"/>
    </section>
  </xsl:template>

  <!-- ======================================================= blocks ==== -->
  <xsl:template match="d:para">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="d:note">
    <aside class="note">
      <xsl:apply-templates/>
    </aside>
  </xsl:template>

  <xsl:template match="d:orderedlist">
    <ol><xsl:apply-templates select="d:listitem"/></ol>
  </xsl:template>
  <xsl:template match="d:itemizedlist">
    <ul><xsl:apply-templates select="d:listitem"/></ul>
  </xsl:template>
  <xsl:template match="d:listitem">
    <li><xsl:apply-templates/></li>
  </xsl:template>

  <!-- ======================================================= inline ==== -->
  <xsl:template match="d:emphasis[@role='bold']">
    <strong><xsl:apply-templates/></strong>
  </xsl:template>
  <xsl:template match="d:emphasis">
    <em><xsl:apply-templates/></em>
  </xsl:template>
  <xsl:template match="d:literal|d:code">
    <code><xsl:apply-templates/></code>
  </xsl:template>
  <xsl:template match="d:link">
    <a href="{@xlink:href}" xmlns:xlink="http://www.w3.org/1999/xlink"><xsl:apply-templates/></a>
  </xsl:template>

  <!-- ========================================================= math ==== -->
  <xsl:template match="d:inlineequation">
    <xsl:text>\(</xsl:text>
    <xsl:value-of select="d:mathphrase"/>
    <xsl:text>\)</xsl:text>
  </xsl:template>
  <xsl:template match="d:informalequation|d:equation">
    <div class="equation">
      <xsl:text>\[</xsl:text>
      <xsl:value-of select="d:mathphrase"/>
      <xsl:text>\]</xsl:text>
    </div>
  </xsl:template>

  <!-- ==================================================== citations ==== -->
  <xsl:template match="d:citation">
    <sup class="cite">
      <xsl:text>[</xsl:text>
      <xsl:for-each select="d:xref">
        <xsl:if test="position() &gt; 1">,</xsl:if>
        <xsl:variable name="t" select="key('bib', @linkend)"/>
        <xsl:variable name="n" select="count($t/preceding-sibling::d:bibliomixed) + 1"/>
        <a href="#{@linkend}"><xsl:value-of select="$n"/></a>
      </xsl:for-each>
      <xsl:text>]</xsl:text>
    </sup>
  </xsl:template>
  <!-- a bare xref outside a citation: render its bib number as a link -->
  <xsl:template match="d:xref">
    <xsl:variable name="t" select="key('bib', @linkend)"/>
    <xsl:variable name="n" select="count($t/preceding-sibling::d:bibliomixed) + 1"/>
    <a href="#{@linkend}">[<xsl:value-of select="$n"/>]</a>
  </xsl:template>

  <!-- ======================================================== tables ==== -->
  <xsl:template match="d:table">
    <figure class="table">
      <xsl:if test="d:title"><figcaption><xsl:apply-templates select="d:title/node()"/></figcaption></xsl:if>
      <table>
        <xsl:apply-templates select="d:tgroup/d:thead"/>
        <xsl:apply-templates select="d:tgroup/d:tbody"/>
      </table>
    </figure>
  </xsl:template>
  <xsl:template match="d:thead">
    <thead><xsl:apply-templates select="d:row"/></thead>
  </xsl:template>
  <xsl:template match="d:tbody">
    <tbody><xsl:apply-templates select="d:row"/></tbody>
  </xsl:template>
  <xsl:template match="d:thead/d:row">
    <tr><xsl:for-each select="d:entry"><th><xsl:apply-templates/></th></xsl:for-each></tr>
  </xsl:template>
  <xsl:template match="d:tbody/d:row">
    <tr><xsl:for-each select="d:entry"><td><xsl:apply-templates/></td></xsl:for-each></tr>
  </xsl:template>

  <!-- ================================================== bibliography ==== -->
  <xsl:template match="d:bibliography">
    <section id="bibliography" class="bibliography">
      <h2><xsl:value-of select="d:title"/></h2>
      <ol>
        <xsl:for-each select="d:bibliomixed">
          <li id="{@xml:id}">
            <xsl:if test="@role='provisional'">
              <xsl:attribute name="class">provisional</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="node()[not(self::d:abbrev)]"/>
          </li>
        </xsl:for-each>
      </ol>
    </section>
  </xsl:template>
  <xsl:template match="d:bibliomixed//d:title">
    <cite><xsl:apply-templates/></cite>
  </xsl:template>
  <xsl:template match="d:author">
    <xsl:apply-templates select="d:personname"/>
  </xsl:template>
  <xsl:template match="d:personname">
    <xsl:value-of select="d:firstname"/><xsl:text> </xsl:text><xsl:value-of select="d:surname"/>
  </xsl:template>
  <xsl:template match="d:bibliomisc[@role='note']">
    <span class="bibnote"><xsl:apply-templates/></span>
  </xsl:template>

  <!-- ===================================================== fallback ==== -->
  <xsl:template match="d:title"/>  <!-- titles handled by their parents -->

  <!-- ========================================================== CSS ==== -->
  <xsl:template name="css">
    :root { color-scheme: light dark; }
    body { max-width: 46rem; margin: 2rem auto; padding: 0 1.2rem;
           font: 1rem/1.65 Georgia, 'Times New Roman', serif; color: #1a1a1a; }
    main { }
    h1 { font-size: 1.9rem; line-height: 1.2; margin: 0 0 .3rem; }
    h2 { font-size: 1.4rem; margin: 2.2rem 0 .6rem; border-bottom: 1px solid #ddd; padding-bottom: .2rem; }
    h3 { font-size: 1.15rem; margin: 1.6rem 0 .4rem; }
    h4 { font-size: 1.02rem; margin: 1.2rem 0 .3rem; font-style: italic; }
    p { margin: .6rem 0; }
    .byline { font-style: italic; color: #555; margin: .2rem 0; }
    .pubdate { color: #777; font-size: .85rem; margin: 0 0 1rem; }
    .abstract { background: #f6f6f6; border-left: 4px solid #999; padding: .6rem 1rem; margin: 1rem 0 2rem; }
    .abstract h2 { border: 0; font-size: 1rem; margin: 0 0 .3rem; text-transform: uppercase; letter-spacing: .05em; }
    .note { background: #eef4fb; border-left: 4px solid #4a78b5; padding: .5rem 1rem; margin: 1rem 0; font-size: .95rem; }
    sup.cite { font-size: .7em; }
    sup.cite a { text-decoration: none; color: #2a6; }
    .equation { overflow-x: auto; text-align: center; margin: 1rem 0; }
    figure.table { margin: 1.4rem 0; overflow-x: auto; }
    figure.table figcaption { font-style: italic; font-size: .9rem; margin-bottom: .4rem; color: #555; }
    table { border-collapse: collapse; width: 100%; font-size: .9rem; }
    th, td { border: 1px solid #bbb; padding: .4rem .6rem; text-align: left; vertical-align: top; }
    thead th { background: #f0f0f0; }
    .bibliography ol { padding-left: 1.4rem; }
    .bibliography li { margin: .5rem 0; font-size: .92rem; }
    .bibliography li.provisional { color: #8a6d00; }
    .bibnote { color: #999; font-size: .85em; font-style: italic; }
    cite { font-style: italic; }
    .finding { border-left-width: 5px; border-left-style: solid; padding-left: 1rem; }
    .finding-confirmed { border-left-color: #2e8b57; }
    .finding-split { border-left-color: #d99a00; }
    .finding-confirmed-with-caveats { border-left-color: #4a78b5; }
    @media (prefers-color-scheme: dark) {
      body { background: #16181c; color: #d6d6d6; }
      h2 { border-color: #333; }
      .abstract { background: #202329; border-left-color: #666; }
      .note { background: #1b2530; border-left-color: #4a78b5; }
      th, td { border-color: #444; }
      thead th { background: #23262c; }
      sup.cite a { color: #6c9; }
    }
  </xsl:template>

</xsl:stylesheet>
