# Paranormal Quantum Attention Networks (PQAN)

A scholarly white paper codifying a research report on **Paranormal Quantum Attention
Networks**: neural architectures whose *object language* is a discrete propositional
graph and whose *metalanguage* is a continuous, quantum-inspired system of
amplitude-valued assertion degrees.

The report situates PQAN against contemporary work on quantum transformers,
density-matrix quantum NLP, tensor-network machine learning, hybrid quantum–classical
(NISQ) computing, and paraconsistent / paracomplete / substructural / non-reflexive
logics for quantum theory, and argues a near-term implementation strategy:
**prioritise tensor-network approximation, add parameterized-quantum-circuit (PQC)
attention modules where quantum hardware allows, and use natural language as the first
testbed.**

## Canonical source & derived outputs

DocBook 5.2 XML is the **single canonical source**; HTML5 and LaTeX are derived by XSLT
and are never edited directly.

```
src/00-metadata.xml     DocBook <info> (native elements; DC + Schema.org derived from these)
src/01-pqan-report.xml  the article (primary content) — XIncludes 00 and 03
src/03-bibliography.xml  the reference list (<bibliomixed> entries)
xsl/html5.xsl           DocBook -> HTML5 (DC <meta> + Schema.org JSON-LD + MathJax)
xsl/latex.xsl           DocBook -> LaTeX (article class)
schema/custom.rnc       RELAX NG Compact: project conventions (math + finding + provisional)
scratch/formulas.md     math & correspondence quick-reference
scratch/notes.md        provenance, citation-verification tracking, open questions
tools/install-docbook-toolchain.sh   installs xmllint + xsltproc
Makefile                build pipeline
```

## Building

Install the toolchain (small; ~a few MB — NOT texlive):

```bash
./tools/install-docbook-toolchain.sh   # libxml2-utils (xmllint) + xsltproc
```

Then:

```bash
make wf          # XML well-formedness + XInclude resolution (offline)
make check-refs  # every citation linkend resolves to a bibliography entry
make html        # -> generated/01-pqan-report.html
make latex       # -> generated/01-pqan-report.tex
make all         # wf + check-refs + html + latex

make fetch-schema && make validate   # full DocBook 5.2 RNG validation (needs network once)
make pdf         # -> generated/01-pqan-report.pdf   (requires a LaTeX install)
```

The document **validates against the stock DocBook 5.2 RELAX NG grammar** (`make validate`).
Math is authored once as raw LaTeX in `<mathphrase role="tex">` and rendered via MathJax
(HTML) or native math mode (LaTeX). Citations are numbered sequentially and hyperlinked
to the bibliography; a `check-refs` guard fails the build on any dangling `linkend`.

## Status of the references (IMPORTANT)

The source report cited markers **[1]–[17] but shipped no reference list** (and marker
**[7] was cited nowhere** — a dangling marker). Rather than reverse-engineer confabulated
pointers, the citations are being **independently re-researched**: for each claim, a real
supporting source is sought; unsupported claims are flagged. Until that pass is fully
reconciled, bibliography entries carry `role="provisional"` (shown amber in HTML) and the
per-claim verdict table lives in `scratch/notes.md`.

One specific figure is under verification: the report's claim that breaking Bitcoin's
elliptic-curve cryptography needs "fewer than 500,000 physical qubits" in "minutes" — the
prose has been softened to "substantially smaller than previously estimated" pending the
verified 2025 Google Quantum AI estimate.

## License

AGPL-3.0-or-later. See the repository `LICENSE`.
