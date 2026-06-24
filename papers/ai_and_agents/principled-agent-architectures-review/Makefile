# Build pipeline: DocBook 5.2 XML → HTML5 and LaTeX
# TeX/PDF are derived outputs; XML is the canonical source.
#
# Requirements:
#   xsltproc    (libxslt)
#   xmllint     (libxml2)
#   pdflatex    (texlive)
#   jing        (RELAX NG validator, optional)

SRCS     := $(wildcard src/0*.xml)
HTML_OUTS := $(patsubst src/%.xml,generated/%.html,$(SRCS))
TEX_OUTS  := $(patsubst src/%.xml,generated/%.tex,$(SRCS))

.PHONY: all html latex validate validate-rnc clean

all: validate html latex

# ---------------------------------------------------------------
# Validation against DocBook 5.2 RELAX NG

validate: $(SRCS)
	@for f in $(SRCS); do \
	  echo "Validating $$f ..."; \
	  xmllint --noout --xinclude \
	    --relaxng https://docbook.org/xml/5.2/rng/docbook.rng "$$f" && \
	  echo "  OK: $$f"; \
	done

# Optional: validate finding sections against custom RNC schema (requires jing)
validate-rnc: src/02-critical-review.xml schema/critical-review.rnc
	jing -c schema/critical-review.rnc src/02-critical-review.xml

# ---------------------------------------------------------------
# HTML5 generation

html: $(HTML_OUTS)

generated/%.html: src/%.xml xsl/html5.xsl | generated
	xsltproc --xinclude xsl/html5.xsl $< > $@

# ---------------------------------------------------------------
# LaTeX generation

latex: $(TEX_OUTS)

generated/%.tex: src/%.xml xsl/latex.xsl | generated
	xsltproc --xinclude xsl/latex.xsl $< > $@

# ---------------------------------------------------------------
# PDF from LaTeX (two-pass for TOC and references)

generated/%.pdf: generated/%.tex | generated
	cd generated && pdflatex -interaction=nonstopmode $(notdir $<)
	cd generated && pdflatex -interaction=nonstopmode $(notdir $<)

# ---------------------------------------------------------------
# Utility

generated:
	mkdir -p generated

clean:
	rm -f generated/*.html generated/*.tex generated/*.pdf
	rm -f generated/*.aux generated/*.log generated/*.out generated/*.toc
