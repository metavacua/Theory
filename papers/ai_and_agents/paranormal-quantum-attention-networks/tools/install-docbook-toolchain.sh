#!/bin/bash
# Install the DocBook -> HTML5/LaTeX build toolchain for this paper.
#
# Core tools (small, ~a few MB) are REQUIRED to run `make validate html latex`:
#   - xmllint  (package: libxml2-utils)  -- XML well-formedness + XInclude + RELAX NG validation
#   - xsltproc (package: xsltproc)       -- XSLT 1.0 transforms (DocBook -> HTML5, DocBook -> LaTeX)
#
# Optional tools:
#   - jing     -- validates the RELAX NG *Compact* schema (schema/custom.rnc) directly
#   - trang    -- converts .rnc <-> .rng
#   - pdflatex -- only needed to render generated/*.tex to PDF (LARGE: texlive; see note below)
#
# This script installs only the small core (and optional jing/trang). It does NOT pull
# texlive-full -- that is an "absurd disk" download. For PDF, install a minimal LaTeX
# separately (e.g. `sudo apt-get install texlive-latex-recommended texlive-latex-extra`)
# or use the repo-level setup.sh.
#
# Intended for Debian/Ubuntu. Idempotent: safe to re-run.
set -e

CORE="libxml2-utils xsltproc"
OPTIONAL="jing trang"

echo ">> Updating package lists..."
sudo apt-get update -qq

echo ">> Installing core DocBook toolchain: $CORE"
sudo apt-get install -y -qq $CORE

echo ">> Installing optional RELAX NG tooling: $OPTIONAL (non-fatal if unavailable)"
sudo apt-get install -y -qq $OPTIONAL || echo "   (jing/trang unavailable; validate against .rng via xmllint instead)"

echo
echo ">> Verifying:"
for t in xmllint xsltproc; do
  if command -v "$t" >/dev/null 2>&1; then
    echo "   OK  $t -> $("$t" --version 2>&1 | head -1)"
  else
    echo "   MISSING  $t"; exit 1
  fi
done
for t in jing trang pdflatex; do
  command -v "$t" >/dev/null 2>&1 && echo "   OK  $t (optional)" || echo "   --  $t not installed (optional)"
done
echo
echo ">> Done. Run 'make validate html latex' in the paper directory."
