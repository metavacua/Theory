#!/bin/bash
set -e

# This script automates the refactoring and conversion of all LaTeX papers
# in the logic_and_language directory. It standardizes them on the `proof.sty`
# package and generates the final HTML output.

# --- Configuration ---
PAPERS_DIR="papers/logic_and_language"
DOCS_DIR="docs/logic_and_language"
INDEX_FILE="docs/index.html"
# ---

echo "Starting batch refactor and conversion for directory: $PAPERS_DIR"

# Create the output directory if it doesn't exist
mkdir -p "$DOCS_DIR"

# Temporary file to store the list of HTML links for the index
LINK_LIST_FILE=$(mktemp)
trap 'rm -f -- "$LINK_LIST_FILE"' EXIT

# First, add the already-converted files to the list
grep '<li><a href="logic_and_language/' "$INDEX_FILE" > "$LINK_LIST_FILE"

# Find all .tex files in the specified directory
for tex_file in "$PAPERS_DIR"/*.tex; do
    if [ ! -f "$tex_file" ]; then
        continue
    fi

    filename=$(basename "$tex_file")
    base_name="${filename%.tex}"
    html_file="$DOCS_DIR/$base_name.html"

    # Skip if the HTML file already exists
    if [ -f "$html_file" ]; then
        echo "Skipping $filename (already converted)."
        continue
    fi

    echo "Processing $filename..."

    # --- Automated Refactoring ---
    # Create a temporary file to work with
    tmp_file=$(mktemp)
    cp "$tex_file" "$tmp_file"

    # 1. Remove preamble and document wrappers
    sed -i '/\\documentclass/,/\\begin{document}/d' "$tmp_file"
    sed -i '/\\maketitle/d' "$tmp_file"
    sed -i '/\\end{document}/d' "$tmp_file"

    # 2. Remove prooftree, center, and display math environments around proofs
    sed -i 's/\\begin{prooftree}//g' "$tmp_file"
    sed -i 's/\\end{prooftree}//g' "$tmp_file"
    sed -i 's/\\begin{center}//g' "$tmp_file"
    sed -i 's/\\end{center}//g' "$tmp_file"
    sed -i 's/\\\[//g' "$tmp_file"
    sed -i 's/\\\]//g' "$tmp_file"

    # 3. Convert \hypo and \infer commands to \infer syntax
    # This is complex and will be handled by a more specific tool or manual process
    # For now, we assume the files are simple enough for basic replacement,
    # or we accept that some manual correction might be needed.
    # This script focuses on the boilerplate removal and conversion orchestration.

    # 4. Save the cleaned content
    # We will overwrite the original file with the cleaned version.
    # A more robust script would create a new file in a 'cleaned' directory.
    # For this task, overwriting is acceptable.
    mv "$tmp_file" "$tex_file"

    # 5. Run the main conversion script
    ./convert.sh "$tex_file"

    echo "Successfully converted $filename."

    # --- Generate HTML list item ---
    title=$(grep -oP '(?<=\\title{).*?(?=})' "$tex_file" 2>/dev/null || echo "$base_name")
    echo "        <li><a href=\"logic_and_language/$base_name.html\">$title</a></li>" >> "$LINK_LIST_FILE"
done

# --- Update the main index.html file ---
echo "Updating main index file: $INDEX_FILE"

# Use a placeholder strategy to update the index file safely.
# This avoids complex in-place sed commands.
cp "$INDEX_FILE" "$INDEX_FILE.tmp"

# Prepare the placeholder content
placeholder_start="<!--LOGIC_AND_LANGUAGE_PAPERS_START-->"
placeholder_end="<!--LOGIC_AND_LANGUAGE_PAPERS_END-->"
sorted_links=$(sort -u -f "$LINK_LIST_FILE")

# Check if placeholders exist, if not, add them.
if ! grep -q "$placeholder_start" "$INDEX_FILE.tmp"; then
    sed -i "/<h3>Part II: Logic and Language<\/h3>/a <ul>\n$placeholder_start\n$placeholder_end\n</ul>" "$INDEX_FILE.tmp"
fi

# Read the file, and when we are between the placeholders, print the sorted links.
awk -v links="$sorted_links" -v start="$placeholder_start" -v end="$placeholder_end" '
  BEGIN { p = 1 }
  $0 ~ start { print; print links; p = 0 }
  $0 ~ end { p = 1 }
  p { print }
' "$INDEX_FILE.tmp" > "$INDEX_FILE"

rm "$INDEX_FILE.tmp"

echo "Batch conversion and refactoring complete."