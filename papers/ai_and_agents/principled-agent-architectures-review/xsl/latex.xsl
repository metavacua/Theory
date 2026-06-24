<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:db="http://docbook.org/ns/docbook"
  xmlns:dc="http://purl.org/dc/terms/"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="db dc xlink">

  <xsl:output method="text" encoding="UTF-8"/>

  <!-- Root: article → LaTeX article class -->
  <xsl:template match="/db:article">
    <xsl:text>\documentclass[12pt,a4paper]{article}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage{hyperref}
\usepackage{booktabs}
\usepackage{longtable}
\usepackage{enumitem}
\usepackage{xcolor}
\definecolor{confirmed}{RGB}{0,140,70}
\definecolor{split}{RGB}{180,100,0}
\definecolor{caveats}{RGB}{40,80,180}

</xsl:text>
    <!-- Title from info/dc:title or article title -->
    <xsl:text>\title{</xsl:text>
    <xsl:choose>
      <xsl:when test="db:info/dc:title">
        <xsl:call-template name="latex-escape">
          <xsl:with-param name="text" select="db:info/dc:title"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="latex-escape">
          <xsl:with-param name="text" select="db:title"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}
</xsl:text>
    <!-- Author -->
    <xsl:if test="db:info/dc:creator">
      <xsl:text>\author{</xsl:text>
      <xsl:call-template name="latex-escape">
        <xsl:with-param name="text" select="db:info/dc:creator"/>
      </xsl:call-template>
      <xsl:text>}
</xsl:text>
    </xsl:if>
    <!-- Date -->
    <xsl:if test="db:info/dc:date">
      <xsl:text>\date{</xsl:text>
      <xsl:value-of select="db:info/dc:date"/>
      <xsl:text>}
</xsl:text>
    </xsl:if>
    <xsl:text>
\begin{document}
\maketitle
\tableofcontents
\newpage

</xsl:text>
    <xsl:apply-templates select="db:section"/>
    <xsl:text>
\bibliographystyle{plain}
\bibliography{../src/bibliography}

\end{document}
</xsl:text>
  </xsl:template>

  <!-- Sections at various depths -->
  <xsl:template match="db:section">
    <xsl:variable name="depth" select="count(ancestor::db:section)"/>
    <!-- Finding sections: color box -->
    <xsl:if test="@condition">
      <xsl:text>
\noindent{\color{</xsl:text>
      <xsl:choose>
        <xsl:when test="@condition='confirmed'">confirmed</xsl:when>
        <xsl:when test="@condition='split'">split</xsl:when>
        <xsl:otherwise>caveats</xsl:otherwise>
      </xsl:choose>
      <xsl:text>}\rule{\linewidth}{1.5pt}}
</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$depth = 0">
        <xsl:text>\section{</xsl:text>
        <xsl:call-template name="latex-escape">
          <xsl:with-param name="text" select="db:title"/>
        </xsl:call-template>
        <xsl:text>}
</xsl:text>
      </xsl:when>
      <xsl:when test="$depth = 1">
        <xsl:text>\subsection{</xsl:text>
        <xsl:call-template name="latex-escape">
          <xsl:with-param name="text" select="db:title"/>
        </xsl:call-template>
        <xsl:text>}
</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\subsubsection{</xsl:text>
        <xsl:call-template name="latex-escape">
          <xsl:with-param name="text" select="db:title"/>
        </xsl:call-template>
        <xsl:text>}
</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="db:*[not(self::db:title)]"/>
  </xsl:template>

  <!-- Paragraphs -->
  <xsl:template match="db:para">
    <xsl:text>
</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>

</xsl:text>
  </xsl:template>

  <!-- Emphasis -->
  <xsl:template match="db:emphasis[@role='bold']">
    <xsl:text>\textbf{</xsl:text>
    <xsl:call-template name="latex-escape">
      <xsl:with-param name="text" select="."/>
    </xsl:call-template>
    <xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="db:emphasis">
    <xsl:text>\textit{</xsl:text>
    <xsl:call-template name="latex-escape">
      <xsl:with-param name="text" select="."/>
    </xsl:call-template>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- Links -->
  <xsl:template match="db:link[@xlink:href]">
    <xsl:text>\href{</xsl:text>
    <xsl:value-of select="@xlink:href"/>
    <xsl:text>}{</xsl:text>
    <xsl:call-template name="latex-escape">
      <xsl:with-param name="text" select="."/>
    </xsl:call-template>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- Tables -->
  <xsl:template match="db:informaltable|db:table">
    <xsl:text>
\begin{longtable}{</xsl:text>
    <xsl:for-each select="db:tgroup/db:colspec">
      <xsl:text>l</xsl:text>
    </xsl:for-each>
    <xsl:if test="not(db:tgroup/db:colspec)">
      <xsl:for-each select="db:tgroup/db:tbody/db:row[1]/db:entry">
        <xsl:text>l</xsl:text>
      </xsl:for-each>
    </xsl:if>
    <xsl:text>}
\toprule
</xsl:text>
    <xsl:apply-templates select="db:tgroup/db:thead"/>
    <xsl:apply-templates select="db:tgroup/db:tbody"/>
    <xsl:text>\bottomrule
\end{longtable}

</xsl:text>
  </xsl:template>

  <xsl:template match="db:thead">
    <xsl:apply-templates/>
    <xsl:text>\midrule
</xsl:text>
  </xsl:template>

  <xsl:template match="db:tbody">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="db:tgroup">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="db:colspec"/>

  <xsl:template match="db:row">
    <xsl:for-each select="db:entry">
      <xsl:if test="position() > 1">
        <xsl:text> &amp; </xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:for-each>
    <xsl:text> \\
</xsl:text>
  </xsl:template>

  <!-- Lists -->
  <xsl:template match="db:itemizedlist">
    <xsl:text>
\begin{itemize}
</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{itemize}

</xsl:text>
  </xsl:template>

  <xsl:template match="db:orderedlist">
    <xsl:text>
\begin{enumerate}
</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{enumerate}

</xsl:text>
  </xsl:template>

  <xsl:template match="db:listitem">
    <xsl:text>\item </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Code -->
  <xsl:template match="db:code">
    <xsl:text>\texttt{</xsl:text>
    <xsl:call-template name="latex-escape">
      <xsl:with-param name="text" select="."/>
    </xsl:call-template>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="db:programlisting|db:screen">
    <xsl:text>
\begin{verbatim}
</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>
\end{verbatim}

</xsl:text>
  </xsl:template>

  <!-- Skip info block -->
  <xsl:template match="db:info"/>

  <!-- LaTeX character escaping -->
  <xsl:template name="latex-escape">
    <xsl:param name="text"/>
    <xsl:value-of select="$text"/>
  </xsl:template>

  <!-- Text nodes -->
  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>

</xsl:stylesheet>
