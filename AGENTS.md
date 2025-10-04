## Working with this repository

This is a LaTeX thesis repository.

### Directory Structure

- `thesis/`: Main thesis files. The main file is `thesis/main.tex`.
- `papers/`: Standalone papers and other documents, converted to `.tex` format.
- `assets/`: Images, diagrams, and other assets.
- `originals/`: The original, unconverted `.docx`, `.odt`, and `.txt` files.

### LaTeX

- When adding new `.tex` files, please place them in the appropriate directory.
- Ensure that the main thesis file (`thesis/main.tex`) is updated to include any new chapters or sections.
- Keep the repository clean by adding LaTeX auxiliary file extensions to the `.gitignore` file.
- Before submitting, ensure the entire thesis compiles without errors. You can do this by running `pdflatex thesis/main.tex`. You may need to run it multiple times to resolve all cross-references.