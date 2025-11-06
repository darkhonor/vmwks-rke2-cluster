#!/bin/sh
#
# Format Markdown Files for GitHub/GitLab CE Publication
#

echo "Formatting Markdown files..."

# Check if markdownlint is available
if ! command -v markdownlint >/dev/null 2>&1; then
    echo "Installing markdownlint-cli..."
    npm install -g markdownlint-cli
fi

# Check if markdownlint-cli2 is available
if ! command -v markdownlint-cli2 >/dev/null 2>&1; then
    echo "Installing markdownlint-cli2..."
    pip install markdownlint-cli2
fi

# Run markdownlint with auto-fix
echo "Running markdownlint with auto-fix..."
markdownlint '**/*.md' --config .markdownlint.json --fix

# Run markdownlint-cli2 for additional checks
echo "Running markdownlint-cli2..."
markdownlint-cli2 '**/*.md' --config .markdownlint.json

echo "Markdown formatting complete!"