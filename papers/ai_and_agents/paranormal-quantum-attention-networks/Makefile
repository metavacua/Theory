# Build pipeline: DocBook 5.2 XML (canonical) -> HTML5 + LaTeX (derived).
#
# Requirements: xmllint (libxml2-utils), xsltproc (libxslt). Optional: jing,
# pdflatex. Run tools/install-docbook-toolchain.sh to install the core tools.
#
# Only ARTICLE files are transformed; 00-metadata.xml and 03-bibliography.xml
# are XInclude fragments pulled in by the article.

SHELL := /bin/bash

ARTICLES  := src/01-pqan-report.xml
FRAGMENTS := src/00-metadata.xml src/03-bibliography.xml
HTML_OUTS := $(patsubst src/%.xml,generated/%.html,$(ARTICLES))
TEX_OUTS  := $(patsubst src/%.xml,generated/%.tex,$(ARTICLES))
PDF_OUTS  := $(patsubst src/%.xml,generated/%.pdf,$(ARTICLES))

# Prefer a vendored local copy (offline); fall back to the CDN if absent.
DOCBOOK_RNG_URL   := https://cdn.docbook.org/schema/5.2/rng/docbook.rng
DOCBOOK_RNG_LOCAL := schema/docbook.rng
DOCBOOK_RNG := $(if $(wildcard $(DOCBOOK_RNG_LOCAL)),$(DOCBOOK_RNG_LOCAL),$(DOCBOOK_RNG_URL))

.PHONY: all wf check-refs validate fetch-schema html latex pdf publish clean

all: wf check-refs html latex

## publish — copy the rendered HTML into the repository's GitHub Pages tree (docs/).
## Legacy Pages serves main/docs, so a merge to main publishes this file.
DOCS_DIR ?= ../../../docs/ai_and_agents
publish: html
	mkdir -p $(DOCS_DIR)
	cp generated/01-pqan-report.html $(DOCS_DIR)/paranormal-quantum-attention-networks.html
	@echo "published -> $(DOCS_DIR)/paranormal-quantum-attention-networks.html"

## fetch-schema — vendor the DocBook 5.2 RNG locally for offline `make validate`
fetch-schema:
	curl -fsSL -o $(DOCBOOK_RNG_LOCAL) $(DOCBOOK_RNG_URL) && echo "vendored $(DOCBOOK_RNG_LOCAL)"

## wf — XML well-formedness + XInclude resolution (no network needed)
wf: $(ARTICLES)
	@for f in $(ARTICLES); do \
	  echo "xmllint (well-formed + xinclude): $$f"; \
	  xmllint --noout --xinclude "$$f" || exit 1; \
	done
	@echo "OK: all articles are well-formed and XIncludes resolve."

## check-refs — every citation linkend must resolve to a defined bibliomixed
check-refs: $(ARTICLES) $(FRAGMENTS)
	@used=$$(grep -ho 'linkend="[^"]*"' $(ARTICLES) | sed 's/linkend="//;s/"//' | sort -u); \
	 def=$$(grep -ho 'xml:id="bib-[^"]*"' $(FRAGMENTS) | sed 's/xml:id="//;s/"//' | sort -u); \
	 dangling=$$(comm -23 <(echo "$$used") <(echo "$$def")); \
	 if [ -n "$$dangling" ]; then \
	   echo "!! dangling citation linkend(s) with no bibliography entry:"; echo "$$dangling"; exit 1; \
	 else echo "OK: all citation linkends resolve to bibliography entries."; fi

## validate — structural validation against the official DocBook 5.2 grammar
## (requires network to fetch the RNG; falls back to wf if unavailable)
validate: $(ARTICLES)
	@for f in $(ARTICLES); do \
	  echo "xmllint (RELAX NG DocBook 5.2): $$f"; \
	  xmllint --noout --xinclude --relaxng $(DOCBOOK_RNG) "$$f" \
	    || { echo "!! DocBook RNG validation failed or network unavailable; run 'make wf' for offline well-formedness."; exit 1; }; \
	done

html: $(HTML_OUTS)
generated/%.html: src/%.xml xsl/html5.xsl $(FRAGMENTS) | generated
	xsltproc --xinclude xsl/html5.xsl $< > $@
	@echo "wrote $@"

latex: $(TEX_OUTS)
generated/%.tex: src/%.xml xsl/latex.xsl $(FRAGMENTS) | generated
	xsltproc --xinclude xsl/latex.xsl $< > $@
	@echo "wrote $@"

pdf: $(PDF_OUTS)
generated/%.pdf: generated/%.tex | generated
	cd generated && pdflatex -interaction=nonstopmode -halt-on-error $(notdir $<)
	cd generated && pdflatex -interaction=nonstopmode -halt-on-error $(notdir $<)
	@echo "wrote $@"

generated:
	mkdir -p generated

clean:
	rm -f generated/*.html generated/*.tex generated/*.pdf
	rm -f generated/*.aux generated/*.log generated/*.out generated/*.toc
