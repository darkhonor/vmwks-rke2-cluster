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
    echo "Installing markdownlint-cli..."
    npm install -g markdownlint-cli
    markdownlint '**/*.md' --config .markdownlint.json --fix
fi

echo "Running additional markdown checks..."
if ! command -v markdownlint-cli2 >/dev/null 2>&1; then
    echo "Installing markdownlint-cli2 locally..."
    npm install markdownlint-cli2
    # Create a local script to run it
    echo '#!/bin/sh' > ./run-markdownlint-cli2.sh
    echo 'npx markdownlint-cli2 "$@"' >> ./run-markdownlint-cli2.sh
    chmod +x ./run-markdownlint-cli2.sh
    MARKDOWNLINT_CLI2="./run-markdownlint-cli2.sh"
else
    MARKDOWNLINT_CLI2="markdownlint-cli2"
fi
$MARKDOWNLINT_CLI2 'README.md' 'AGENTS.md' 'MARKDOWN-STANDARDS.md' 'CHANGELOG' 'CONTRIBUTING.md' 'CODEOWNERS' 'LICENSE' '**/*.md' --config .markdownlint.json

echo "Formatting YAML files..."
if command -v yamllint >/dev/null 2>&1; then
    find . -name "*.yml" -o -name "*.yaml" | xargs yamllint -c .yamllint
else
    echo "yamllint not found. Install with: pip install yamllint"
fi

echo "Formatting complete!"