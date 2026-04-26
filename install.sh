#!/usr/bin/env bash
# marketing-writer installer

set -e

SKILLS_DIR="${HOME}/.claude/skills"
REPO="https://github.com/yboolez/marketing-writer.git"
TARGET="$SKILLS_DIR/marketing-writer"

mkdir -p "$SKILLS_DIR"

echo "marketing-writer installer"
echo "─────────────────────────────"

if [ -d "$TARGET" ]; then
    echo "✓ marketing-writer already installed → $TARGET"
    echo "  to update:  cd $TARGET && git pull"
else
    echo "↓ Installing marketing-writer..."
    git clone --depth 1 "$REPO" "$TARGET"
    echo "✓ Installed → $TARGET"
fi

echo "─────────────────────────────"
echo "Done. Restart Claude Code to pick up the skill."
echo ""
echo "Trigger with:  /marketing-writer   /说人话   或自然语言「帮我写 pitch deck」"
