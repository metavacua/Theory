<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:db="http://docbook.org/ns/docbook"
  xmlns:dc="http://purl.org/dc/terms/"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="db dc xlink">

  <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes"
              doctype-system="about:legacy-compat"/>

  <!-- Root: article -->
  <xsl:template match="/db:article">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title><xsl:value-of select="db:title"/></title>
        <!-- Dublin Core meta tags from info/dc:* -->
        <xsl:apply-templates select="db:info/dc:title" mode="meta"/>
        <xsl:apply-templates select="db:info/dc:creator" mode="meta"/>
        <xsl:apply-templates select="db:info/dc:subject" mode="meta"/>
        <xsl:apply-templates select="db:info/dc:description" mode="meta"/>
        <xsl:apply-templates select="db:info/dc:date" mode="meta"/>
        <xsl:apply-templates select="db:info/dc:rights" mode="meta"/>
        <xsl:apply-templates select="db:info/dc:source" mode="meta"/>
        <!-- Schema.org JSON-LD -->
        <xsl:if test="db:info/db:bibliomisc[@role='schema-org-jsonld']">
          <script type="application/ld+json">
            <xsl:value-of select="db:info/db:bibliomisc[@role='schema-org-jsonld']"/>
          </script>
        </xsl:if>
        <style>
body { font-family: Georgia, serif; max-width: 900px; margin: 2em auto; padding: 0 1em; line-height: 1.6; color: #222; }
h1 { font-size: 1.8em; border-bottom: 2px solid #333; padding-bottom: 0.3em; }
h2 { font-size: 1.4em; margin-top: 2em; border-bottom: 1px solid #ccc; }
h3 { font-size: 1.1em; margin-top: 1.5em; }
section.finding { padding: 0.8em 1em; margin: 1em 0; border-left: 4px solid #999; }
section[data-condition="confirmed"] { border-color: #2a7; background: #f0faf4; }
section[data-condition="split"] { border-color: #c80; background: #fffdf0; }
section[data-condition="confirmed-with-caveats"] { border-color: #59b; background: #f0f6ff; }
table { border-collapse: collapse; width: 100%; margin: 1em 0; }
th, td { border: 1px solid #ccc; padding: 0.4em 0.7em; text-align: left; }
th { background: #f5f5f5; }
a { color: #1a5296; }
code { background: #f5f5f5; padding: 0.1em 0.3em; border-radius: 3px; font-family: monospace; }
pre { background: #f5f5f5; padding: 1em; overflow-x: auto; border-radius: 4px; }
.meta-box { background: #f9f9f9; border: 1px solid #ddd; padding: 0.8em 1em; margin-bottom: 1.5em; font-size: 0.9em; }
        </style>
      </head>
      <body>
        <article>
          <header>
            <h1><xsl:value-of select="db:title"/></h1>
            <div class="meta-box">
              <xsl:if test="db:info/dc:creator">
                <div><strong>Author:</strong> <xsl:value-of select="db:info/dc:creator"/></div>
              </xsl:if>
              <xsl:if test="db:info/dc:date">
                <div><strong>Date:</strong> <xsl:value-of select="db:info/dc:date"/></div>
              </xsl:if>
              <xsl:if test="db:info/dc:rights">
                <div><strong>License:</strong> <xsl:value-of select="db:info/dc:rights"/></div>
              </xsl:if>
            </div>
          </header>
          <xsl:apply-templates select="db:section"/>
        </article>
      </body>
    </html>
  </xsl:template>

  <!-- Dublin Core meta tags -->
  <xsl:template match="dc:title" mode="meta">
    <meta name="DC.title"><xsl:attribute name="content"><xsl:value-of select="."/></xsl:attribute></meta>
  </xsl:template>
  <xsl:template match="dc:creator" mode="meta">
    <meta name="DC.creator"><xsl:attribute name="content"><xsl:value-of select="."/></xsl:attribute></meta>
  </xsl:template>
  <xsl:template match="dc:subject" mode="meta">
    <meta name="DC.subject"><xsl:attribute name="content"><xsl:value-of select="."/></xsl:attribute></meta>
  </xsl:template>
  <xsl:template match="dc:description" mode="meta">
    <meta name="DC.description"><xsl:attribute name="content"><xsl:value-of select="."/></xsl:attribute></meta>
  </xsl:template>
  <xsl:template match="dc:date" mode="meta">
    <meta name="DC.date"><xsl:attribute name="content"><xsl:value-of select="."/></xsl:attribute></meta>
  </xsl:template>
  <xsl:template match="dc:rights" mode="meta">
    <meta name="DC.rights"><xsl:attribute name="content"><xsl:value-of select="."/></xsl:attribute></meta>
  </xsl:template>
  <xsl:template match="dc:source" mode="meta">
    <meta name="DC.source"><xsl:attribute name="content"><xsl:value-of select="."/></xsl:attribute></meta>
  </xsl:template>

  <!-- Sections with optional condition styling -->
  <xsl:template match="db:section">
    <section>
      <xsl:if test="@xml:id">
        <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="@role">
        <xsl:attribute name="class"><xsl:value-of select="@role"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="@condition">
        <xsl:attribute name="data-condition"><xsl:value-of select="@condition"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </section>
  </xsl:template>

  <!-- Titles at various heading levels -->
  <xsl:template match="db:article/db:title"/>
  <xsl:template match="db:section/db:title">
    <xsl:variable name="depth" select="count(ancestor::db:section)"/>
    <xsl:choose>
      <xsl:when test="$depth = 1"><h2><xsl:apply-templates/></h2></xsl:when>
      <xsl:when test="$depth = 2"><h3><xsl:apply-templates/></h3></xsl:when>
      <xsl:otherwise><h4><xsl:apply-templates/></h4></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Paragraphs -->
  <xsl:template match="db:para">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <!-- Emphasis -->
  <xsl:template match="db:emphasis[@role='bold']">
    <strong><xsl:apply-templates/></strong>
  </xsl:template>
  <xsl:template match="db:emphasis">
    <em><xsl:apply-templates/></em>
  </xsl:template>

  <!-- Links -->
  <xsl:template match="db:link[@xlink:href]">
    <a><xsl:attribute name="href"><xsl:value-of select="@xlink:href"/></xsl:attribute>
    <xsl:apply-templates/></a>
  </xsl:template>

  <!-- Tables -->
  <xsl:template match="db:informaltable|db:table">
    <table>
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  <xsl:template match="db:thead">
    <thead><xsl:apply-templates/></thead>
  </xsl:template>
  <xsl:template match="db:tbody">
    <tbody><xsl:apply-templates/></tbody>
  </xsl:template>
  <xsl:template match="db:tgroup">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="db:colspec"/>
  <xsl:template match="db:row">
    <tr><xsl:apply-templates/></tr>
  </xsl:template>
  <xsl:template match="db:thead/db:row/db:entry">
    <th><xsl:apply-templates/></th>
  </xsl:template>
  <xsl:template match="db:entry">
    <td><xsl:apply-templates/></td>
  </xsl:template>

  <!-- Lists -->
  <xsl:template match="db:itemizedlist">
    <ul><xsl:apply-templates/></ul>
  </xsl:template>
  <xsl:template match="db:orderedlist">
    <ol><xsl:apply-templates/></ol>
  </xsl:template>
  <xsl:template match="db:listitem">
    <li><xsl:apply-templates/></li>
  </xsl:template>

  <!-- Code -->
  <xsl:template match="db:code">
    <code><xsl:apply-templates/></code>
  </xsl:template>
  <xsl:template match="db:programlisting|db:screen">
    <pre><code><xsl:apply-templates/></code></pre>
  </xsl:template>

  <!-- Skip info block (already processed above) -->
  <xsl:template match="db:info"/>

  <!-- Default: pass through text -->
  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>

</xsl:stylesheet>
