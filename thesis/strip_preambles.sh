#!/bin/bash
find papers -type f -name "*.tex" | while read file; do
    # Anonymize the author and title
    sed -i "/\\author/c\\author{}" "$file"
    sed -i "/\\title/c\\title{}" "$file"
    sed -i "/\\maketitle/d" "$file"
    # Remove everything from \documentclass to \begin{document}
    sed -i "/\\documentclass/,/\\begin{document}/d" "$file"
    # Remove \end{document}
    sed -i "/\\end{document}/d" "$file"
done
