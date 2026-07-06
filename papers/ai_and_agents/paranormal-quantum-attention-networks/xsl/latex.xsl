<?xml version="1.0" encoding="UTF-8"?>
<!--
  DocBook 5.2 -> LaTeX (article class) transform for the PQAN white paper.
  - nested sections -> \section/\subsection/\subsubsection/\paragraph
  - <mathphrase role="tex"> emitted RAW into $..$ / \[..\]
  - prose text() escaped for LaTeX specials (& % # _ $ ~ ^)
  - CALS table -> tabularx; citations -> \textsuperscript{[n,..]}
  XSLT 1.0 (xsltproc). Compile the emitted .tex with pdflatex/lualatex.
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:schema="https://schema.org/"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="d dc schema xlink">

  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:preserve-space elements="d:para d:mathphrase d:entry d:bibliomixed d:listitem"/>

  <xsl:key name="bib" match="d:bibliomixed" use="@xml:id"/>

  <!-- ======================================================= root ==== -->
  <xsl:template match="/d:article">
    <xsl:text>\documentclass[11pt]{article}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage[margin=1in]{geometry}
\usepackage{amsmath,amssymb}
\usepackage{booktabs}
\usepackage{tabularx}
\usepackage{enumitem}
\usepackage{mdframed}
\usepackage[hidelinks]{hyperref}
\setlength{\parskip}{0.5em}
\setlength{\parindent}{0pt}
</xsl:text>
    <xsl:text>\title{</xsl:text>
    <xsl:call-template name="latex-escape"><xsl:with-param name="s" select="normalize-space(d:info/d:title)"/></xsl:call-template>
    <xsl:text>}
</xsl:text>
    <xsl:text>\author{</xsl:text>
    <xsl:call-template name="latex-escape"><xsl:with-param name="s" select="normalize-space(d:info/d:author/d:personname)"/></xsl:call-template>
    <xsl:if test="d:info/d:othercredit">
      <xsl:text> \\ \small (with </xsl:text>
      <xsl:call-template name="latex-escape"><xsl:with-param name="s" select="normalize-space(d:info/d:othercredit/d:orgname)"/></xsl:call-template>
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:text>}
</xsl:text>
    <xsl:text>\date{</xsl:text>
    <xsl:call-template name="latex-escape"><xsl:with-param name="s" select="normalize-space(d:info/d:pubdate)"/></xsl:call-template>
    <xsl:text>}
\begin{document}
\maketitle
</xsl:text>
    <xsl:if test="d:info/d:abstract">
      <xsl:text>\begin{abstract}
</xsl:text>
      <xsl:for-each select="d:info/d:abstract/d:para">
        <xsl:call-template name="latex-escape"><xsl:with-param name="s" select="normalize-space(.)"/></xsl:call-template>
        <xsl:text>
</xsl:text>
      </xsl:for-each>
      <xsl:text>\end{abstract}
</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="d:section"/>
    <xsl:apply-templates select="d:bibliography"/>
    <xsl:text>
\end{document}
</xsl:text>
  </xsl:template>

  <!-- ==================================================== sections ==== -->
  <xsl:template match="d:section">
    <xsl:variable name="level" select="count(ancestor-or-self::d:section)"/>
    <xsl:text>
</xsl:text>
    <xsl:choose>
      <xsl:when test="$level=1">\section{</xsl:when>
      <xsl:when test="$level=2">\subsection{</xsl:when>
      <xsl:when test="$level=3">\subsubsection{</xsl:when>
      <xsl:otherwise>\paragraph{</xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="latex-escape"><xsl:with-param name="s" select="d:title"/></xsl:call-template>
    <xsl:text>}
</xsl:text>
    <xsl:if test="@xml:id">
      <xsl:text>\label{</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>}
</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="node()[not(self::d:title)]"/>
  </xsl:template>

  <!-- ======================================================= blocks ==== -->
  <xsl:template match="d:para">
    <xsl:apply-templates/>
    <xsl:text>

</xsl:text>
  </xsl:template>

  <xsl:template match="d:note">
    <xsl:text>\begin{mdframed}
\textit{Note.} </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{mdframed}
</xsl:text>
  </xsl:template>

  <xsl:template match="d:orderedlist">
    <xsl:text>\begin{enumerate}
</xsl:text>
    <xsl:apply-templates select="d:listitem"/>
    <xsl:text>\end{enumerate}
</xsl:text>
  </xsl:template>
  <xsl:template match="d:itemizedlist">
    <xsl:text>\begin{itemize}
</xsl:text>
    <xsl:apply-templates select="d:listitem"/>
    <xsl:text>\end{itemize}
</xsl:text>
  </xsl:template>
  <xsl:template match="d:listitem">
    <xsl:text>\item </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>
</xsl:text>
  </xsl:template>

  <!-- ======================================================= inline ==== -->
  <xsl:template match="d:emphasis[@role='bold']">
    <xsl:text>\textbf{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="d:emphasis">
    <xsl:text>\emph{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="d:literal|d:code">
    <xsl:text>\texttt{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="d:link">
    <xsl:text>\href{</xsl:text><xsl:value-of select="@xlink:href"/><xsl:text>}{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
  </xsl:template>

  <!-- ========================================================= math ==== -->
  <xsl:template match="d:inlineequation">
    <xsl:text>$</xsl:text><xsl:value-of select="d:mathphrase"/><xsl:text>$</xsl:text>
  </xsl:template>
  <xsl:template match="d:informalequation|d:equation">
    <xsl:text>
\[
</xsl:text>
    <xsl:value-of select="d:mathphrase"/>
    <xsl:text>
\]
</xsl:text>
  </xsl:template>

  <!-- ==================================================== citations ==== -->
  <xsl:template match="d:citation">
    <xsl:text>\textsuperscript{[</xsl:text>
    <xsl:for-each select="d:xref">
      <xsl:if test="position() &gt; 1">,</xsl:if>
      <xsl:variable name="t" select="key('bib', @linkend)"/>
      <xsl:value-of select="count($t/preceding-sibling::d:bibliomixed) + 1"/>
    </xsl:for-each>
    <xsl:text>]}</xsl:text>
  </xsl:template>
  <xsl:template match="d:xref">
    <xsl:variable name="t" select="key('bib', @linkend)"/>
    <xsl:text>[</xsl:text>
    <xsl:value-of select="count($t/preceding-sibling::d:bibliomixed) + 1"/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <!-- ======================================================== tables ==== -->
  <xsl:template match="d:table">
    <xsl:text>
\begin{table}[htbp]
\centering
</xsl:text>
    <xsl:if test="d:title">
      <xsl:text>\caption{</xsl:text>
      <xsl:call-template name="latex-escape"><xsl:with-param name="s" select="d:title"/></xsl:call-template>
      <xsl:text>}
</xsl:text>
    </xsl:if>
    <xsl:text>\begin{tabularx}{\linewidth}{@{}l X X@{}}
\toprule
</xsl:text>
    <xsl:for-each select="d:tgroup/d:thead/d:row">
      <xsl:for-each select="d:entry">
        <xsl:if test="position() &gt; 1"> &amp; </xsl:if>
        <xsl:text>\textbf{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
      </xsl:for-each>
      <xsl:text> \\
\midrule
</xsl:text>
    </xsl:for-each>
    <xsl:for-each select="d:tgroup/d:tbody/d:row">
      <xsl:for-each select="d:entry">
        <xsl:if test="position() &gt; 1"> &amp; </xsl:if>
        <xsl:apply-templates/>
      </xsl:for-each>
      <xsl:text> \\
\addlinespace
</xsl:text>
    </xsl:for-each>
    <xsl:text>\bottomrule
\end{tabularx}
\end{table}
</xsl:text>
  </xsl:template>

  <!-- ================================================== bibliography ==== -->
  <xsl:template match="d:bibliography">
    <xsl:text>
\section*{</xsl:text>
    <xsl:call-template name="latex-escape"><xsl:with-param name="s" select="d:title"/></xsl:call-template>
    <xsl:text>}
\begin{enumerate}[leftmargin=2.2em]
</xsl:text>
    <xsl:for-each select="d:bibliomixed">
      <xsl:text>\item </xsl:text>
      <xsl:apply-templates select="node()[not(self::d:abbrev)]"/>
      <xsl:text>
</xsl:text>
    </xsl:for-each>
    <xsl:text>\end{enumerate}
</xsl:text>
  </xsl:template>
  <xsl:template match="d:bibliomixed//d:title">
    <xsl:text>\emph{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="d:author">
    <xsl:apply-templates select="d:personname"/>
  </xsl:template>
  <xsl:template match="d:personname">
    <xsl:value-of select="d:firstname"/><xsl:text> </xsl:text><xsl:value-of select="d:surname"/>
  </xsl:template>
  <xsl:template match="d:bibliomisc[@role='note']">
    <xsl:text> {\small\itshape </xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
  </xsl:template>

  <!-- suppress standalone titles (handled by parents) -->
  <xsl:template match="d:title"/>

  <!-- ================================================ text escaping ==== -->
  <xsl:template match="text()">
    <xsl:call-template name="latex-escape"><xsl:with-param name="s" select="."/></xsl:call-template>
  </xsl:template>

  <xsl:template name="latex-escape">
    <xsl:param name="s"/>
    <!-- Pre-map non-ASCII math/arrow symbols that pdflatex+inputenc cannot render as
         text (HTML keeps the real glyphs; LaTeX gets \ensuremath commands). em/en dashes,
         curly quotes, and accented letters are handled natively by inputenc utf8. -->
    <xsl:variable name="s1">
      <xsl:call-template name="rep">
        <xsl:with-param name="from" select="'&#8596;'"/>
        <xsl:with-param name="to" select="'\ensuremath{\leftrightarrow}'"/>
        <xsl:with-param name="s">
          <xsl:call-template name="rep">
            <xsl:with-param name="from" select="'&#8594;'"/>
            <xsl:with-param name="to" select="'\ensuremath{\rightarrow}'"/>
            <xsl:with-param name="s" select="$s"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <!-- order matters: backslash first would double-escape, but prose has none;
         we escape the standard LaTeX specials that can appear in prose. -->
    <xsl:call-template name="rep">
      <xsl:with-param name="s">
        <xsl:call-template name="rep">
          <xsl:with-param name="s">
            <xsl:call-template name="rep">
              <xsl:with-param name="s">
                <xsl:call-template name="rep">
                  <xsl:with-param name="s">
                    <xsl:call-template name="rep">
                      <xsl:with-param name="s">
                        <xsl:call-template name="rep">
                          <xsl:with-param name="s">
                            <xsl:call-template name="rep">
                              <xsl:with-param name="s" select="$s1"/>
                              <xsl:with-param name="from" select="'^'"/>
                              <xsl:with-param name="to" select="'\textasciicircum{}'"/>
                            </xsl:call-template>
                          </xsl:with-param>
                          <xsl:with-param name="from" select="'~'"/>
                          <xsl:with-param name="to" select="'\textasciitilde{}'"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="from" select="'$'"/>
                      <xsl:with-param name="to" select="'\$'"/>
                    </xsl:call-template>
                  </xsl:with-param>
                  <xsl:with-param name="from" select="'#'"/>
                  <xsl:with-param name="to" select="'\#'"/>
                </xsl:call-template>
              </xsl:with-param>
              <xsl:with-param name="from" select="'_'"/>
              <xsl:with-param name="to" select="'\_'"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="from" select="'%'"/>
          <xsl:with-param name="to" select="'\%'"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="from" select="'&amp;'"/>
      <xsl:with-param name="to" select="'\&amp;'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- recursive single-substring replace -->
  <xsl:template name="rep">
    <xsl:param name="s"/>
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    <xsl:choose>
      <xsl:when test="contains($s, $from)">
        <xsl:value-of select="substring-before($s, $from)"/>
        <xsl:value-of select="$to"/>
        <xsl:call-template name="rep">
          <xsl:with-param name="s" select="substring-after($s, $from)"/>
          <xsl:with-param name="from" select="$from"/>
          <xsl:with-param name="to" select="$to"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$s"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
