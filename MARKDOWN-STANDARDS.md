# Markdown Formatting and Linting Guide

This document outlines the Markdown formatting and linting standards
for the VMware Workstation RKE2 Cluster project to ensure consistent,
publication-ready documentation for GitHub and GitLab CE.

## Configuration Files

### `.markdownlint.json`

Main configuration file that defines Markdown linting rules:

- Line length: 120 characters (to accommodate hyperlinks)
- ATX heading style (`#` vs `##`)
- Dash list style (`-` vs `*`)
- Fenced code blocks
- Proper heading spacing

### `.github/workflows/format-check.yml`

GitHub Actions workflow that validates all file formatting:

- HCL formatting using `packer fmt -check`
- Packer template validation
- Markdown formatting validation
- YAML formatting validation

### `.github/workflows/hcl-format.yml`

GitHub Actions workflow specifically for HCL files:

- Runs on changes to `.hcl`, `.pkr.hcl`, `.pkrvars.hcl` files
- Validates HCL formatting with HashiCorp standards
- Validates Packer template syntax

### `.github/workflows/markdown-lint.yml`

GitHub Actions workflow that automatically:

- Runs on pushes/PRs affecting Markdown files
- Installs required linting tools
- Validates all Markdown files against the configuration

## Tools Used

1. **Packer**: HashiCorp Packer for HCL formatting and validation
2. **markdownlint-cli**: Node.js-based linter with auto-fix
   capability
3. **markdownlint-cli2**: Python-based alternative for additional
   validation
4. **yamllint**: Python-based YAML linter for configuration files
5. **GitHub Actions**: Automated CI/CD pipeline integration

## Usage

### Manual Formatting

```bash
# Format all files (HCL, Markdown, YAML)
./format.sh

# Format only Markdown files
./format-markdown.sh

# Format only HCL files
packer fmt .

# Check HCL formatting without modifying
packer fmt -check .

# Manual linting check
markdownlint '**/*.md' --config .markdownlint.json

# Auto-fix Markdown issues
markdownlint '**/*.md' --config .markdownlint.json --fix
```

### Automated Validation

The GitHub Actions workflows automatically validate all file formats
when:

- Pushing to main/master/develop branches
- Creating pull requests targeting these branches
- Any relevant files are modified (`.hcl`, `.md`, `.yml`, `.yaml`)

**Format Check Workflow**: Validates HCL, Markdown, and YAML formatting
**HCL Format Workflow**: Specifically validates HCL/Packer files
**Markdown Lint Workflow**: Specifically validates Markdown files

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

- Maximum line length: 120 characters (except code blocks/tables)
  to accommodate hyperlinks without breaking URLs
- No trailing whitespace
- Consistent punctuation usage
- Proper HTML element usage (limited set allowed)

## Integration with Development Workflow

1. **Before Committing**: Run `./format.sh` to auto-fix all formatting
   issues (HCL, Markdown, YAML)
2. **During Development**: Use editor extensions for real-time
   feedback
3. **Before PR**: Ensure CI pipeline passes all formatting checks
4. **Publication Ready**: Files passing all checks are ready for
   GitHub/GitLab CE

### HCL-Specific Workflow

1. **After editing HCL files**: Run `packer fmt .` to format
2. **Before commits**: Run `packer fmt -check .` to verify formatting
3. **CI validation**: GitHub Actions automatically validates HCL formatting
4. **HashiCorp standards**: All HCL follows official HashiCorp formatting

## Troubleshooting

### Common Issues

- **Line length violations**: Break long lines at 120 characters,
  except for hyperlinks which may be longer
- **Heading spacing**: Add blank lines before/after headings
- **List formatting**: Use consistent dash style and indentation
- **Code blocks**: Specify language and use fenced style
- **HCL formatting**: Run `packer fmt .` to fix HCL formatting issues
- **YAML indentation**: Use 2 spaces for YAML file indentation

### Fixing Issues

Most issues can be auto-fixed using:

```bash
# Fix all formatting issues
./format.sh

# Fix only Markdown issues
markdownlint '**/*.md' --config .markdownlint.json --fix

# Fix only HCL issues
packer fmt .
```

For manual fixes, refer to the specific rule documentation in the
markdownlint documentation and HashiCorp HCL style guide.
