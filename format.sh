#!/bin/sh
#
# Format All Configuration Files and Documentation
#

echo "Formatting HCL files..."
if command -v packer >/dev/null 2>&1; then
    echo "Formatting Packer HCL templates..."
    packer fmt .
    echo "Checking HCL formatting..."
    if packer fmt -check .; then
        echo "✓ All HCL files are properly formatted"
    else
        echo "⚠ Some HCL files need formatting. Running auto-format..."
        packer fmt .
    fi
else
    echo "Packer not found. Install with: https://developer.hashicorp.com/packer/install"
fi

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

echo "Formatting complete!"