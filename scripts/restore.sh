#!/bin/bash
# ============================================
# macOS 迁移恢复脚本
# 在新电脑上运行此脚本来恢复配置
# ============================================

BACKUP_DIR="$(dirname "$0")/.."

echo "=========================================="
echo "开始恢复配置..."
echo "=========================================="

# 1. 恢复 Shell 配置
echo -e "\n🔄 恢复 Shell 配置..."
for file in .zshrc .bashrc .bash_profile .bash_aliases .zprofile; do
    if [ -f "$BACKUP_DIR/config/$file" ]; then
        cp "$BACKUP_DIR/config/$file" "$HOME/$file" && echo "  ✓ $file"
    fi
done

# 2. 恢复 Git 配置
echo -e "\n🔄 恢复 Git 配置..."
[ -f "$BACKUP_DIR/config/.gitconfig" ] && cp "$BACKUP_DIR/config/.gitconfig" "$HOME/.gitconfig" && echo "  ✓ .gitconfig"
[ -f "$BACKUP_DIR/config/.gitignore_global" ] && cp "$BACKUP_DIR/config/.gitignore_global" "$HOME/.gitignore_global" && echo "  ✓ .gitignore_global"

# 3. 恢复 SSH 密钥
echo -e "\n🔄 恢复 SSH 密钥..."
if [ -d "$BACKUP_DIR/ssh/.ssh" ]; then
    cp -r "$BACKUP_DIR/ssh/.ssh" "$HOME/" && echo "  ✓ SSH 密钥已恢复"
    chmod 600 ~/.ssh/id_* 2>/dev/null
    chmod 644 ~/.ssh/id_*.pub 2>/dev/null
fi

# 4. 恢复 Claude Code 配置
echo -e "\n🔄 恢复 Claude Code 配置..."
if [ -d "$BACKUP_DIR/config/claude-code" ]; then
    cp -r "$BACKUP_DIR/config/claude-code" "$HOME/.claude" && echo "  ✓ Claude Code 配置已恢复"
fi

# 5. 恢复 VS Code 配置
echo -e "\n🔄 恢复 VS Code 配置..."
VSC_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSC_DIR"

if [ -f "$BACKUP_DIR/config/vscode-settings.json" ]; then
    cp "$BACKUP_DIR/config/vscode-settings.json" "$VSC_DIR/settings.json" && echo "  ✓ VS Code settings"
fi

if [ -f "$BACKUP_DIR/config/vscode-keybindings.json" ]; then
    cp "$BACKUP_DIR/config/vscode-keybindings.json" "$VSC_DIR/keybindings.json" && echo "  ✓ VS Code keybindings"
fi

echo -e "\n=========================================="
echo "配置恢复完成！"
echo "=========================================="
echo -e "\n接下来需要手动操作："
echo "  1. 安装 Homebrew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
echo "  2. 运行: brew install \$(cat $BACKUP_DIR/app-lists/brew-packages.txt)"
echo "  3. 运行: brew install --cask \$(cat $BACKUP_DIR/app-lists/brew-casks.txt)"
echo "  4. 运行: code --install-extension \$(cat $BACKUP_DIR/app-lists/vscode-extensions.txt)"
echo "  5. 运行: npm install -g \$(cat $BACKUP_DIR/app-lists/npm-packages.txt)"
