# Markdown Formatting and Linting Guide

This document outlines the Markdown formatting and linting standards
for the VMware Workstation RKE2 Cluster project to ensure consistent,
publication-ready documentation for GitHub and GitLab CE.

## Configuration Files

### `.markdownlint.json`

Main configuration file that defines Markdown linting rules:

- Line length: 80 characters
- ATX heading style (`#` vs `##`)
- Dash list style (`-` vs `*`)
- Fenced code blocks
- Proper heading spacing

### `.github/workflows/markdown-lint.yml`

GitHub Actions workflow that automatically:

- Runs on pushes/PRs affecting Markdown files
- Installs required linting tools
- Validates all Markdown files against the configuration

## Tools Used

1. **markdownlint-cli**: Node.js-based linter with auto-fix
   capability
2. **markdownlint-cli2**: Python-based alternative for additional
   validation
3. **GitHub Actions**: Automated CI/CD pipeline integration

## Usage

### Manual Formatting

```bash
# Format all Markdown files
./format-markdown.sh

# Manual linting check
markdownlint '**/*.md' --config .markdownlint.json

# Auto-fix issues
markdownlint '**/*.md' --config .markdownlint.json --fix
```

### Automated Validation

The GitHub Actions workflow automatically validates Markdown files
when:

- Pushing to main/master/develop branches
- Creating pull requests targeting these branches
- Any `.md` file is modified

## Standards Enforced

### Headings

- ATX style (`# Heading` vs `Heading ======`)
- Proper spacing (1 line above, 1 line below)
- No duplicate headings at different nesting levels

### Lists

- Dash style for unordered lists (`- item`)
- Ordered style for numbered lists
- Consistent indentation (4 spaces for nested items)

### Code Blocks

- Fenced style with language specification
- Proper spacing around blocks
- No line length limits for code blocks

### Links and Images

- Proper formatting for all links
- Alt text required for images
- No bare URLs

### General Formatting

- Maximum line length: 80 characters (except code blocks/tables)
- No trailing whitespace
- Consistent punctuation usage
- Proper HTML element usage (limited set allowed)

## Integration with Development Workflow

1. **Before Committing**: Run `./format-markdown.sh` to auto-fix
   issues
2. **During Development**: Use editor extensions for real-time
   feedback
3. **Before PR**: Ensure CI pipeline passes all Markdown checks
4. **Publication Ready**: Files passing all checks are ready for
   GitHub/GitLab CE

## Troubleshooting

### Common Issues

- **Line length violations**: Break long lines at 80 characters
- **Heading spacing**: Add blank lines before/after headings
- **List formatting**: Use consistent dash style and indentation
- **Code blocks**: Specify language and use fenced style

### Fixing Issues

Most issues can be auto-fixed using:

```bash
markdownlint '**/*.md' --config .markdownlint.json --fix
```

For manual fixes, refer to the specific rule documentation in the
markdownlint documentation.
