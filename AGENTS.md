## Working with this repository

This is a LaTeX thesis repository.

### Directory Structure

- `thesis/`: Main thesis files. The main file is `thesis/main.tex`.
- `papers/`: Standalone papers and other documents, converted to `.tex` format.
  - `papers/physics/`: Papers related to physics.
  - `papers/logic_and_language/`: Papers related to logic and language.
- `assets/`: Images, diagrams, and other assets.
- `originals/`: The original, unconverted `.docx`, `.odt`, and `.txt` files.

### File Naming Conventions
- All filenames should be lowercase.
- Use hyphens (`-`) instead of spaces or underscores (`_`).

### LaTeX

- When adding new `.tex` files, please place them in the appropriate directory.
- Ensure that the main thesis file (`thesis/main.tex`) is updated to include any new chapters or sections.
- Keep the repository clean by adding LaTeX auxiliary file extensions to the `.gitignore` file.
- Before submitting, ensure the entire thesis compiles without errors. You can do this by running `pdflatex thesis/main.tex`. You may need to run it multiple times to resolve all cross-references.

### Git LFS
This repository uses Git LFS to manage large binary files. The following file types are tracked:
- `*.docx`
- `*.odt`
- `*.webp`