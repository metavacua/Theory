# LaTeX to HTML Conversion Workflow (LaTeXML)

This document outlines the process for converting LaTeX documents, specifically those using complex or custom packages, into HTML using LaTeXML. It is based on a previous project involving a thesis with multiple papers.

## Key Scripts and Commands

*   **Dependency Installation:** The `setup.sh` script should be run to install necessary LaTeX packages required for the project.
*   **Main PDF Compilation:** To compile the entire thesis into a single PDF, use the command:
    ```bash
    pdflatex thesis/main.tex
    ```
    This should be run from the root of the repository.
*   **Single Paper HTML Conversion:** The `convert.sh` script is used to convert an individual LaTeX paper into a standalone HTML file.
    *   **Usage:** `bash convert.sh <path_to_paper.tex>`
    *   **Mechanism:** This script uses `thesis/standalone.tex` as a template, which provides the necessary preamble for a single paper. It then runs LaTeXML and places the output in the `docs/` directory, making it available for the GitHub Pages site.

## LaTeXML Custom Bindings (`.ltxml`)

LaTeXML may not support all LaTeX packages out-of-the-box. For unsupported packages, custom bindings are required.

*   **Location:** Custom binding files have a `.ltxml` extension and are typically stored alongside the LaTeX source files (e.g., in the `thesis/` directory).
*   **File Format:** `.ltxml` files are **Perl modules**, not XML files. They must begin with a valid Perl package declaration, like `package LaTeXML::Package::mypackage;`.
*   **Purpose:** They provide definitions for custom commands and environments from the unsupported LaTeX package, telling LaTeXML how to translate them into semantic HTML.
*   **Example:** For the `bussproofs.sty` package, a `bussproofs.sty.ltxml` binding was created to handle the `prooftree` environment.

## Common Pitfalls and Best Practices

1.  **Math Delimiters:** Do not wrap structural LaTeX environments (like `prooftree`) in math delimiters (`\[ ... \]`). This can lead to malformed or incorrect HTML output from LaTeXML. The environment itself should handle the math context if needed.
2.  **Command Naming in Bindings:** When defining custom commands in `.ltxml` files, avoid using numbers in the command names (e.g., `\infer0`, `\infer1`). This can cause parsing issues. Use spelled-out names instead (e.g., `\inferzero`, `\inferone`).
3.  **File Structure:**
    *   The main thesis file (`thesis/main.tex`) contains the preamble and uses `\input{}` to include individual papers.
    *   Individual paper files (e.g., in `papers/logic_and_language/`) should **not** contain their own preambles. They are meant to be included in a larger document.
4.  **Entry Point:** The `docs/index.html` file is the main entry point for the published GitHub Pages site. The `convert.sh` script populates this directory.