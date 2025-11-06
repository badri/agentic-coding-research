#!/bin/bash
# Quick installer for organic pattern capture tools

echo "🚀 Installing Organic Agentic Coding Research Tools"
echo ""

# Detect shell
SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
  SHELL_CONFIG="$HOME/.zshrc"
  SHELL_NAME="zsh"
elif [ -f "$HOME/.bashrc" ]; then
  SHELL_CONFIG="$HOME/.bashrc"
  SHELL_NAME="bash"
else
  echo "⚠️  Could not detect shell config (.zshrc or .bashrc)"
  echo "   Please add manually:"
  echo ""
  echo "   export PATH=\"\$HOME/agentic-coding-research/tools:\$PATH\""
  echo ""
  exit 1
fi

echo "📝 Detected shell: $SHELL_NAME"
echo "   Config file: $SHELL_CONFIG"
echo ""

# Check if already installed
if grep -q "agentic-coding-research/tools" "$SHELL_CONFIG"; then
  echo "✅ Already installed in $SHELL_CONFIG"
else
  echo "📦 Adding to PATH in $SHELL_CONFIG..."
  echo "" >> "$SHELL_CONFIG"
  echo "# Organic Agentic Coding Research Tools" >> "$SHELL_CONFIG"
  echo "export PATH=\"\$HOME/agentic-coding-research/tools:\$PATH\"" >> "$SHELL_CONFIG"
  echo "✅ Added to $SHELL_CONFIG"
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "Next steps:"
echo "1. Reload your shell: source $SHELL_CONFIG"
echo "2. Go to a project: cd your-project"
echo "3. Start capturing: claude-session"
echo ""
echo "Read more: ~/agentic-coding-research/README.md"
echo ""
