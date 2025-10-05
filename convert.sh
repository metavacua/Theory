#!/bin/bash
set -e

# USAGE: ./convert.sh papers/logic_and_language/somepaper.tex
#
# This script converts a single LaTeX paper file to HTML using LaTeXML.
# It uses a template file (thesis/standalone.tex) to provide the necessary
# document preamble for compilation.

# --- Configuration ---
TEMPLATE_FILE="thesis/standalone.tex"
PAPERS_DIR="papers"
HTML_DIR="docs"
THESIS_DIR="thesis"
# ---

# --- Argument validation ---
if [ -z "$1" ]; then
    echo "Error: No input file specified."
    echo "Usage: $0 <path_to_tex_file>"
    exit 1
fi

INPUT_FILE=$1

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file not found at '$INPUT_FILE'"
    exit 1
fi
# ---

# --- Path setup ---
# Get the absolute path to the input file to avoid issues with relative paths
INPUT_FILE_ABS=$(realpath "$INPUT_FILE")
INPUT_DIR=$(dirname "$INPUT_FILE")

# Determine the output path by removing the 'papers/' prefix
# and adding the 'html/' prefix.
# e.g., papers/logic_and_language/foo.tex -> html/logic_and_language/foo.html
RELATIVE_PATH=${INPUT_DIR#"$PAPERS_DIR/"}
OUTPUT_DIR="$HTML_DIR/$RELATIVE_PATH"
BASE_NAME=$(basename "$INPUT_FILE" .tex)
OUTPUT_FILE="$OUTPUT_DIR/$BASE_NAME.html"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"
# ---

# --- Temporary compilation file ---
# Create a temporary directory to store the combined .tex file
TMP_DIR=$(mktemp -d)
# Ensure the temporary directory is cleaned up on script exit
trap 'rm -rf -- "$TMP_DIR"' EXIT

# Create a temporary .tex file by replacing the placeholder in the template
# with the absolute path to the paper we want to compile.
TMP_TEX_FILE="$TMP_DIR/$BASE_NAME.tex"
sed "s|PAPER_PATH|$INPUT_FILE_ABS|" "$TEMPLATE_FILE" > "$TMP_TEX_FILE"
# ---

# --- LaTeXML conversion ---
echo "Starting conversion..."
echo "  Input:  $INPUT_FILE"
echo "  Output: $OUTPUT_FILE"

# Run the LaTeXML conversion command
# The --path option tells LaTeXML where to find included files (like images)
# and also our custom .sty.ltxml binding files.
latexml --dest="$OUTPUT_FILE" --path="$INPUT_DIR" --path="$THESIS_DIR" "$TMP_TEX_FILE"

echo "Conversion successful."
# ---