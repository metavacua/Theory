# PQAN Codification — Session Notes

## Provenance

- **Source**: a single AI-generated research report ("Paranormal Quantum Attention
  Networks: Discrete Graph Logics, Quantum Metalanguages, and Practical Architectures
  Beyond the Transformer"), pasted by the repository owner.
- **Codified**: 2026-07-05, via the `scholarly-white-paper` skill, into DocBook 5.2 XML
  (canonical) with XSLT-derived HTML5 + LaTeX.
- **Toolchain**: installed `libxml2-utils` (xmllint) + `xsltproc` persistently on the
  dev host; see `tools/install-docbook-toolchain.sh`. `pdflatex` intentionally NOT
  installed (texlive-full is an "absurd disk" download; PDF is optional, not in the
  default `all` target).

## The citation problem (why the deep-research pass exists)

The source report cites markers **[1]–[17] but ships NO reference list**. The markers
almost certainly trace to a 17-entry list generated alongside the report but never
pasted. Diagnostic: **marker [7] is cited NOWHERE in the body** — a dangling marker,
consistent with the list being confabulated or partially dropped.

**Correction strategy** (per advisor): do NOT reverse-engineer "what paper did [n]
mean." For each *claim* at a citation site, find a real source that actually supports
it; where none exists, flag it unsupported. Separate **background claims** (need a real
citation) from **the PQAN architecture itself** (the owner's novel proposal — labelled
as proposed in a `<note>` in §"The PQAN Architecture"; no citation hunted to "prove" it).

## Provisional citation-key map (report marker → DocBook bib key)

Numbering in the rendered outputs is by DocBook bibliography order (self-consistent),
NOT the report's original [n]. Keys are stable; entries get finalized from research.

| Report [n] | DocBook key | Claim cluster | Anchor hypothesis (to verify) |
| --- | --- | --- | --- |
| [1] | `bib-qtransformer-survey` | quantum transformer survey | a QT survey (2024–25) |
| [2] | `bib-quantum-attention-pqc` | PQC-based quantum attention | hybrid QC transformer paper |
| [3] | `bib-density-matrix-qnlp` | density-matrix QNLP embeddings | Meyer & Sadrzadeh / DisCoCat |
| [4] | `bib-tn-supervised` | TN supervised learning | Stoudenmire & Schwab 2016 |
| [5] | `bib-tn-ml` | TN for images/text | (TN-ML application) |
| [6] | `bib-quantum-metalanguage` | quantum metalanguage / Basic logic / paranormal | Zizzi &/or Sambin |
| [7] | — | **DANGLING — cited nowhere** | (n/a) |
| [8] | `bib-schrodinger-logics` | non-reflexive / Schrödinger logics | da Costa & Krause 1994 |
| [9] | `bib-object-metalanguage` | object/metalanguage distinction | Tarski / standard logic |
| [10] | `bib-qpca` + `bib-nisq` | qPCA; NISQ hybrid | Lloyd–Mohseni–Rebentrost 2014; Preskill 2018 |
| [11] | `bib-qnlp-density` | QNLP density-matrix / quantum transformers | (QNLP) |
| [12] | `bib-mps-training` | MPS training difficulty | Han et al. 2018 / trainability study |
| [13] | `bib-quantum-genomics` | quantum computing in genomics | (genomics) |
| [14] | `bib-gidney-ecc` | ECC/Bitcoin quantum threat | Gidney / Google Quantum AI 2025 |
| [15] | `bib-tn-sequence` | TN sequence models / PGM | (TN sequence) |
| [16] | `bib-tn-gene-regulatory` | TN gene regulatory inference | (TN GRN) |
| [17] | `bib-identity-physics` | non-individuality | French & Krause 2006 |
| —   | `bib-barren-plateaus` | barren plateaus (support for [2]/[10]) | McClean et al. 2018 |

## Verdict table (FILLED FROM deep-research pass — TO BE COMPLETED)

Format per claim: `supported` / `partial` / `unsupported`, with the real citation.

> _Pending: deep-research workflow `wf_cd182d34-5bc` running. On completion, replace each
> provisional `<bibliomixed role="provisional">` entry in `src/03-bibliography.xml` with
> the verified source (drop `role="provisional"`), and record the verdict here._

### Claims flagged for specific-fact verification
- **[14] ECC/Bitcoin**: report asserts "fewer than 500,000 physical qubits" and
  "runtimes on the order of minutes." These specific numbers are SUSPECT and must be
  checked against the actual 2025 Gidney/Google estimate. The prose in
  `§other-modalities` was already softened to "substantially smaller than previously
  estimated" pending the verified figure. **Correction policy decision still needed from
  owner**: correct the prose to the verified numbers, or footnote the discrepancy.

## Open questions / follow-up
- Correction policy for report-vs-source factual discrepancies (see [14]).
- Whether the owner has the original 17-entry list (would become hypotheses to verify).
- HTML renders math via MathJax CDN (fine for standalone / GitHub Pages, blocked under
  strict-CSP Artifact hosting). PDF path needs a LaTeX install (optional).
- `[7]` marker: left out of the bibliography entirely (nothing to cite).

## Build verification status
- `make wf` — PASS (well-formed + XInclude resolves)
- `make check-refs` — PASS (all 18 citation linkends resolve; guard added to catch regressions)
- `make html` — PASS (18 bib entries; JSON-LD + 9 DC meta tags emitted; MathJax delimiters correct)
- `make latex` — PASS (escaping correct; tabularx table; superscript citations)
- `make validate` (DocBook 5.2 RNG) — **PASS**. NOTE: the skill's templated metadata
  pattern (foreign `dc:`/`schema:` elements inside `<info>`) does NOT validate against
  stock DocBook. Fixed by expressing metadata in NATIVE DocBook `<info>` elements
  (title, author, othercredit, pubdate, publisher, abstract, keywordset, legalnotice,
  bibliomisc) and DERIVING the DC `<meta>` tags + Schema.org JSON-LD from those in XSLT.
  Correct RNG URL is `https://cdn.docbook.org/schema/5.2/rng/docbook.rng` (the skill's
  `docbook.org/xml/5.2/...` URL 404s). Vendor locally with `make fetch-schema`.
- `make pdf` — not run (pdflatex not installed by choice; texlive-full is too large)
