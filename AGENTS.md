# Agent Instructions and Notes

This document contains notes and instructions for AI agents working on this repository.

## LaTeX Thesis Compilation

The main thesis is located in `thesis/main.tex`. Compiling this file has proven to be a significant challenge due to a large number of errors across the included paper files.

### Initial State and Cleanup

The `papers/` directory contains numerous `.tex` files that were originally standalone documents. Many of them included their own preambles (`\documentclass`, `\usepackage`, etc.), which caused conflicts when `\input` into the main `thesis/main.tex` file.

An initial attempt was made to automatically clean these files using shell scripts (`cleanup_papers.sh`). This involved:
1.  Stripping preamble commands.
2.  Replacing common Unicode characters with their LaTeX equivalents.

However, this automated cleanup was not perfect and left behind numerous errors.

### Debugging Log and Key Findings

The primary method for debugging has been an iterative process of:
1.  Attempting to compile with `pdflatex main.tex` from the `thesis/` directory.
2.  Identifying the first fatal error in the log.
3.  Fixing the error in the corresponding file.
4.  Repeating the process.

This has been a slow and arduous process. Key errors encountered and their resolutions include:

*   **`! LaTeX Error: Can be used only in preamble.`**: This error occurred repeatedly. It was caused by leftover preamble commands in the individual paper files. The fix was to manually remove these commands (e.g., `\documentclass`, `\usepackage`).
*   **`! Undefined control sequence.`**: This error occurred for various commands (`\observation`, `\SystemState`, `\ket`, `\Tr`, `\nmodels`, `\tightlist`, `\parr`). The cause was that the definitions for these commands were in the preambles that were stripped. The fix was to move these definitions into the preamble of the main `thesis/main.tex` file, making them globally available.
*   **`! Too many }'s.`**: This was caused by artifacts from the automated cleanup script, which left extra closing braces in some files. The fix was to manually remove them.
*   **`! Missing $ inserted.` in `dmalc.tex`**: This has been the most persistent error. It occurs within a `prooftree` environment from the `bussproofs` package.
    *   **Hypothesis 1:** Missing math mode. **Action:** Wrapped all `\hypo` and `\infer` contents in `$ ... $`. **Result:** Failed.
    *   **Hypothesis 2:** Incorrect command for conjunction (`\&`). **Action:** Replaced `\&` with `\land`. **Result:** Failed.
    *   **Hypothesis 3:** Incorrect nesting. The `prooftree` environment was nested inside `\[...\]` and `<center>`. **Next Action:** Test compilation with this nesting removed.

### Current Strategy

The current strategy is to debug methodically by isolating each file:
1.  Comment out all `\input` commands in `thesis/main.tex`.
2.  Uncomment one file at a time, starting with the most recently problematic ones.
3.  Compile and fix any errors in that specific file before proceeding to the next.

This should prevent the cascading failures and error-masking that have made debugging difficult so far.