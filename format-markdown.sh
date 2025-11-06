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

# Run markdownlint with auto-fix
echo "Running markdownlint with auto-fix..."
markdownlint '**/*.md' --config .markdownlint.json --fix

# Run markdownlint-cli2 for additional checks
echo "Running markdownlint-cli2..."
$MARKDOWNLINT_CLI2 '**/*.md' --config .markdownlint.json --ignore node_modules

echo "Markdown formatting complete!"