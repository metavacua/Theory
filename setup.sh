#!/bin/bash
set -e

# This script installs the necessary dependencies for building the thesis.
# It is intended for Debian-based systems (e.g., Ubuntu).

# Update package lists
sudo apt-get update

# Install a full TeX Live distribution and LaTeXML
# This is a large download, but ensures all necessary packages are available.
sudo apt-get install -y texlive-full latexml