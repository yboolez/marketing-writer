#!/usr/bin/env bash
# marketing-writer installer
# Installs marketing-writer and (if missing) its companion frontend-slides.

set -e

SKILLS_DIR="${HOME}/.claude/skills"
MAIN_REPO="https://github.com/yboolez/marketing-writer.git"
COMPANION_REPO="https://github.com/zarazhangrui/frontend-slides.git"

mkdir -p "$SKILLS_DIR"

install_or_skip() {
    local name="$1"
    local url="$2"
    local target="$SKILLS_DIR/$name"

    if [ -d "$target" ]; then
        echo "✓ $name already installed → $target"
    else
        echo "↓ Installing $name..."
        git clone --depth 1 "$url" "$target"
        echo "✓ Installed $name → $target"
    fi
}

echo "marketing-writer installer"
echo "─────────────────────────────"
install_or_skip "marketing-writer" "$MAIN_REPO"
install_or_skip "frontend-slides"  "$COMPANION_REPO"
echo "─────────────────────────────"
echo "Done. Restart Claude Code to pick up the skills."
echo ""
echo "Trigger with:  /marketing-writer   /说人话   或自然语言「帮我写 pitch deck」"
