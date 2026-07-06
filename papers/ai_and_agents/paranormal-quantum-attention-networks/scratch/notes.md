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

## Verdict table (COMPLETED — deep-research pass `wf_cd182d34-5bc`, 104 agents, 1.81M tokens)

25 claims verified by unanimous 3-vote adversarial check (25 confirmed, 0 refuted).
Five clusters (1–5) confirmed with real primary sources; four clusters (6,7,9 + crypto)
had real sources located in the search phase but were not run through the 3-vote check.

| Report [n] | DocBook key → final source | Verdict |
| --- | --- | --- |
| [1] | `bib-qtransformer-survey` → Zhang et al., arXiv:2504.03192 (2025) | **verified 3-0** |
| [2] | `bib-quantum-attention-pqc` → Li, Zhao & Wang (QSANN), arXiv:2205.05625, Sci China Inf Sci | **verified 3-0** |
| [3] | `bib-density-matrix-qnlp` → Meyer & **Lewis**, CoNLL 2020, arXiv:2010.05670 | **verified 3-0**; specifics corrected |
| [4] | `bib-tn-supervised` → Stoudenmire & Schwab, NeurIPS 2016, arXiv:1605.05775 | **verified 3-0** |
| [5] | `bib-tn-ml` → Han et al., PRX 8 031012 (2018) | **verified 3-0** |
| [6] | `bib-quantum-metalanguage` → Zizzi, arXiv:1003.5976 (2010) + quant-ph/0611119 (2006) | **verified 3-0** (metalanguage/Basic-logic half) |
| [8],[17] | `bib-schrodinger-logics` → da Costa & Krause, Studia Logica 53 (1994); `bib-identity-physics` → French & Krause, OUP 2006 | **verified 3-0** (1994); 2006 book consistent extension |
| [9] | `bib-object-metalanguage` → Hodges, SEP "Tarski's Truth Definitions" | located in search |
| [10] | `bib-qpca` → Lloyd, Mohseni, Rebentrost, Nat. Phys. 10 (2014); `bib-nisq` → Preskill, Quantum 2 (2018); `bib-barren-plateaus` → McClean et al., Nat. Commun. 9 (2018) | located in search (canonical) |
| [11] | `bib-qnlp-density` → Chen & Kuo (QASA), arXiv:2504.05336 (2025) | **verified 3-0** |
| [12] | `bib-mps-training` → Tang, Khoo & Ying, arXiv:2505.06419 (2025) | **verified 3-0** |
| [15] | `bib-tn-sequence` → Glasser et al., NeurIPS 2019, arXiv:1907.03741 | **verified 3-0** |
| [16] | `bib-tn-gene-regulatory` → arXiv:2509.06891 (2025) | located in search |
| [7]  | — omitted (cited nowhere in the report body) | dangling marker |

### Corrections applied to the prose (policy: ELIMINATE contradicted claims — owner's decision 2026-07-05)

- **CLUSTER 2 (density-matrix QNLP)** — CONFIRMED specifics error. The report said the
  density-matrix embeddings are learned "via variational quantum circuits"; the anchor
  source (Meyer & Lewis 2020) learns them via classical **neural** models. Prose in
  `§density-matrix-nlp` rewritten to state this accurately and to frame VQC-learning of
  density operators as PQAN's aspiration, not established practice. Author name corrected
  (Lewis, not Sadrzadeh).
- **CLUSTER 8 (Bitcoin/ECC quantum threat, marker [14])** — ELIMINATED. The report's
  "<500,000 physical qubits / minutes" figures were not substantiated and, per owner
  policy, both the figures and the surrounding Google-Quantum-AI claim were removed from
  `§other-modalities`; the section now makes only the generic (author-proposed) point
  that security/threat-modeling is a candidate modality. (Note: arXiv:2505.15917, which
  the search surfaced under the genomics/crypto angle, is actually Gidney's RSA-factoring
  paper — not a genomics source — so it was not used.)
- **CLUSTER 7 (quantum genomics / human health, marker [13])** — ELIMINATED. No real
  source was located for "quantum computing is already being explored in genomics / may
  be essential for human health." That factual sentence was removed from `§genomics`; the
  section retains the *gene-regulatory* tensor-network claim, which IS sourced
  (`bib-tn-gene-regulatory`, arXiv:2509.06891).
- **CLUSTER 4 (paranormal quantum logic)** — the Zizzi anchors confirm the quantum
  metalanguage and the Basic-logic ↔ no-cloning/no-deleting correspondence, but NOT the
  specifically paraconsistent-AND-paracomplete "paranormal" quantum logic with
  amplitude-valued assertion degrees. That synthesis is the author's own; the `<note>` in
  `§architecture` and the bibliography note on `bib-quantum-metalanguage` record this.

## Open questions / follow-up
- Clusters 6, 9, [16], SEP were sourced in the search phase but not run through the
  3-vote adversarial check; a follow-up verification pass could upgrade them. The sources
  are canonical/authoritative, so confidence is nonetheless high.
- Is there a real source for a genuinely *paranormal* (paraconsistent AND paracomplete)
  quantum logic beyond the Zizzi metalanguage/Basic-logic anchors?
- HTML renders math via MathJax CDN (fine for standalone / GitHub Pages, blocked under
  strict-CSP Artifact hosting). PDF path needs a LaTeX install (optional).
- `[7]` marker: omitted (nothing to cite).

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
