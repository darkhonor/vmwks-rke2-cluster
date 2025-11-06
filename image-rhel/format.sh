#!/bin/sh
#
# Format Packer Configuration Templates and Markdown Files
#

echo "Formatting Packer templates..."
packer fmt rhel9/

echo "Formatting Markdown files..."
if command -v markdownlint >/dev/null 2>&1; then
    markdownlint '**/*.md' --config .markdownlint.json --fix
else
    echo "markdownlint not found. Install with: npm install -g markdownlint-cli"
fi

echo "Formatting YAML files..."
if command -v yamllint >/dev/null 2>&1; then
    find . -name "*.yml" -o -name "*.yaml" | xargs yamllint -c .yamllint
else
    echo "yamllint not found. Install with: pip install yamllint"
fi