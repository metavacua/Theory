# Principled Agent Architectures: Critical Review and Repository Audit

Adversarially verified critical review of "Principled Agent Architectures: A Neuro-Symbolic
Blueprint Beyond Large Language Models," with a 7-repository relevance audit across the
metavacua GitHub portfolio.

**Deep research provenance:** 105 agents · 1,307 tool uses · 2,247,194 subagent tokens · 2026-06-23

## Contents

```
src/
  00-metadata.xml         Dublin Core + Schema.org metadata (XIncluded by articles)
  01-original-paper.xml   Full NSAM paper encoded as DocBook 5.2 XML
  02-critical-review.xml  6 verified findings, 11 refuted claims, 4 open questions
  03-repository-audit.xml 7-repo relevance audit with cross-repo synthesis
  bibliography.bib        23 BibTeX sources

xsl/
  html5.xsl               DocBook → HTML5 with DC meta tags + Schema.org JSON-LD
  latex.xsl               DocBook → LaTeX (article class, longtable, booktabs)

schema/
  critical-review.rnc     RELAX NG Compact schema extending DocBook 5.2

scratch/
  formulas.md             Curry-Howard table, NSAM typing judgments, benchmark tables
  notes.md                Session notes, citation gaps, open questions, portfolio diagram

generated/                (git-ignored) HTML5 and LaTeX outputs
```

## Building

```bash
# Validate XML against DocBook 5.2 RELAX NG
make validate

# Generate HTML5
make html

# Generate LaTeX
make latex

# Both
make all
```

Requirements: `xsltproc` (libxslt), `xmllint` (libxml2), `pdflatex` (optional, for PDF).

## Key Findings

| Finding | Verdict |
|---------|---------|
| Logic-LM 39.2% figure lacks dataset/model context | Confirmed with caveats |
| Mamba linear scaling valid; 5x throughput unsupported | Split |
| FNet 80% speedup accurate; 92–97% GLUE retention contested | Split |
| Curry-Howard for agent planning anticipated by Proof-Carrying Plans (PPDP 2020) | Confirmed |
| Scallop/A-NeSI claims accurate but require qualification | Confirmed with caveats |
| PyReason features confirmed; "exact yet scalable" vs. peers unsupported | Split |

## Repository Audit Summary

| Repository | Relevance | Role in NSAM Architecture |
|------------|-----------|--------------------------|
| metavacua/Theory | HIGH | Primary placement |
| metavacua/verumorphism | HIGH | **Symbolic reasoning core** (HDL calculus + REST API) |
| metavacua/CategoricalReasoner | MEDIUM-HIGH | Curry-Howard theory chapters |
| metavacua/drstrangegoo | MEDIUM-HIGH | Proof-search oracle candidate (sequoia_engine PR#4) |
| metavacua/subclass | MEDIUM-HIGH | Live Curry-Howard implementation (Proof\<L,R\> phantom types) |
| metavacua/larql-to-sparql | MEDIUM | **Neural substrate** (vindex + knowledge/ semantic grounding) |
| metavacua/GeodesicLangModel | LOW | Adjacent framework (footnote only) |

**Key insight:** verumorphism (symbolic half) + larql-to-sparql (neural half) already implement
both sides of the NSAM architecture — they simply are not yet wired together. The NSAM blueprint
motivates building that integration.

## License

AGPL-3.0-or-later

## Standards

- [DocBook 5.2](https://docbook.org/specs/docbook-v5.2-csprd01.html) — canonical XML source
- [Dublin Core Terms](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/) — metadata
- [Schema.org ScholarlyArticle](https://schema.org/ScholarlyArticle) — JSON-LD structured data
- [RELAX NG Compact](https://relaxng.org/compact-tutorial-20030326.html) — schema validation
