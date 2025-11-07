#!/bin/sh
# File: format.sh (Enhanced)
# Copyright 2022-2025 Korea Battle Simulation Center. All rights reserved.
# SPDX-License-Identifier: MIT
# 
# Cleanup Shell Script to format Packer HCL files
#

packer fmt common/
packer fmt rhel9/

echo "Formatting Markdown files..."
if command -v markdownlint >/dev/null 2>&1; then
    markdownlint '**/*.md' --config ../.markdownlint.json --fix
else
    echo "markdownlint not found. Install with: npm install -g markdownlint-cli"
fi

echo "Formatting YAML files..."
if command -v yamllint >/dev/null 2>&1; then
    find . -name "*.yml" -o -name "*.yaml" | xargs yamllint -c ../.yamllint
else
    echo "yamllint not found. Install with: pip install yamllint"
fi