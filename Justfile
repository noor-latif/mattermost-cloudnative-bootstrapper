# Justfile for mattermost-cloudnative-bootstrapper
# A handy way to save and run project-specific commands
# Usage: just <recipe>

# Default recipe - lists all available recipes
default:
    @just --list

# Set default shell and variables
set shell := ["bash", "-cu"]

# Environment variables
export GOBIN := env_var_or_default("GOBIN", justfile_directory() + "/bin")

# List available recipes with descriptions
list:
    @just --list

# Show project structure
tree:
    @echo "📁 Project structure:"
    @if command -v tree >/dev/null 2>&1; then \
        tree -L 2 -I 'node_modules|.git|build'; \
    else \
        find . -maxdepth 2 -type d | grep -v node_modules | grep -v .git | grep -v build | sort; \
    fi

# List all Go files
ls-go:
    @echo "🐹 Go files:"
    find . -name "*.go" -type f | grep -v node_modules | sort

# Build desktop binary for Windows
build-desktop-windows:
    @echo "🏗️  Building Windows desktop binary..."
    GOOS=windows GOARCH=amd64 go build -o build/mmbs.exe ./cmd/mcnb
    @echo "✅ Built: build/mmbs.exe"

# Build desktop binary for Linux
build-desktop-linux:
    @echo "🏗️  Building Linux desktop binary..."
    GOOS=linux GOARCH=amd64 go build -o build/mmbs-linux ./cmd/mcnb
    @echo "✅ Built: build/mmbs-linux"

# Build desktop binary for macOS (ARM64)
build-desktop-macos:
    @echo "🏗️  Building macOS ARM64 desktop binary..."
    GOOS=darwin GOARCH=arm64 go build -o build/mmbs-mac_arm64 ./cmd/mcnb
    @echo "✅ Built: build/mmbs-mac_arm64"

# Build desktop binary for macOS (AMD64/Intel)
build-desktop-macos-amd64:
    @echo "🏗️  Building macOS AMD64 desktop binary..."
    GOOS=darwin GOARCH=amd64 go build -o build/mmbs-mac_amd64 ./cmd/mcnb
    @echo "✅ Built: build/mmbs-mac_amd64"

# Build desktop binary for macOS (convenience alias)
build-desktop-desktop: build-desktop-macos

# Build for all platforms
build-all: build-desktop-linux build-desktop-windows build-desktop-macos build-desktop-macos-amd64
    @echo "✅ All builds complete"

# Run Go linter (golint)
lint-server:
    @echo "🔍 Running golint..."
    @echo "GOBIN: {{GOBIN}}"
    GOBIN={{GOBIN}} go install golang.org/x/lint/golint@latest
    {{GOBIN}}/golint -set_exit_status ./...
    @echo "✅ Lint passed"

# Run go vet
govet:
    @echo "🔍 Running go vet..."
    go vet ./...
    @echo "✅ Govet passed"

# Install Node.js dependencies
node_modules:
    @echo "📦 Installing Node.js dependencies..."
    git --version
    cd webapp && npm install

# Run ESLint on webapp
lint-webapp: node_modules
    @echo "🔍 Running ESLint..."
    cd webapp && npm run lint

# Run all style checks
check-style: lint-server govet lint-webapp
    @echo "✅ All style checks passed"

# Clean build artifacts
clean:
    @echo "🧹 Cleaning build artifacts..."
    rm -rf build/
    @echo "✅ Clean complete"

# Create build directory
init:
    @mkdir -p build

# Run the application locally (requires environment setup)
run: init
    @echo "🚀 Running application..."
    go run ./cmd/mcnb

# Flox environment management recipes
# ====================================

# Activate the Flox environment
flox-activate:
    flox activate

# Show Flox environment status
flox-status:
    @echo "🌊 Flox environment status:"
    flox activate -- echo "Environment is ready"

# Install a package using Flox
flox-install package:
    flox install {{package}}

# Search for packages in Flox
flox-search query:
    flox search {{query}}

# Show installed packages
flox-list:
    @echo "📦 Installed Flox packages:"
    flox list

# Update Flox environment
flox-update:
    flox update

# Clean Flox cache
flox-clean:
    flox clean

# Development workflow recipes
# ============================

# Quick development build (current platform)
dev-build: init
    @echo "🏗️  Building for current platform..."
    go build -o build/mmbs-dev ./cmd/mcnb
    @echo "✅ Built: build/mmbs-dev"

# Watch mode for Go development (requires entr or similar)
watch:
    @echo "👀 Watching for changes..."
    @echo "Install entr to enable watch mode: flox install entr"
    find . -name '*.go' | entr -r just dev-build

# Full CI check - runs all validations
ci: check-style build-all
    @echo "✅ CI checks complete"

# Help - show usage information
help:
    @echo "Mattermost CloudNative Bootstrapper - Justfile Commands"
    @echo "========================================================"
    @echo ""
    @echo "Build Commands:"
    @echo "  just build-desktop-linux       - Build for Linux"
    @echo "  just build-desktop-windows     - Build for Windows"
    @echo "  just build-desktop-macos       - Build for macOS (ARM64)"
    @echo "  just build-desktop-macos-amd64 - Build for macOS (Intel)"
    @echo "  just build-all                 - Build for all platforms"
    @echo "  just dev-build                 - Quick dev build"
    @echo ""
    @echo "Lint/Quality Commands:"
    @echo "  just lint-server               - Run Go linter"
    @echo "  just govet                     - Run go vet"
    @echo "  just lint-webapp               - Run ESLint"
    @echo "  just check-style               - Run all checks"
    @echo "  just ci                        - Full CI pipeline"
    @echo ""
    @echo "Flox Environment Commands:"
    @echo "  just flox-activate             - Activate Flox environment"
    @echo "  just flox-list                 - List installed packages"
    @echo "  just flox-install <pkg>        - Install a package"
    @echo "  just flox-search <query>       - Search for packages"
    @echo ""
    @echo "Utility Commands:"
    @echo "  just tree                      - Show project tree"
    @echo "  just ls-go                     - List Go files"
    @echo "  just clean                     - Clean build artifacts"
    @echo "  just run                       - Run the application"
    @echo "  just list                      - List all recipes"
    @echo ""
    @echo "For more information, see: just --list"
