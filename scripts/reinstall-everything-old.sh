#!/bin/bash
# ============================================
# 一键重装所有应用
# 在新电脑上运行（需先安装 Homebrew）
# ============================================

BACKUP_DIR="$HOME/migration-backup"

echo "=========================================="
echo "开始批量重装应用..."
echo "=========================================="

# 检查备份目录是否存在
if [ ! -d "$BACKUP_DIR" ]; then
    echo "❌ 错误：找不到备份目录 $BACKUP_DIR"
    echo "请先运行 backup.sh 并将备份复制到新电脑"
    exit 1
fi

# ============================================
# 1. Homebrew 包
# ============================================
echo -e "\n📦 安装 Homebrew 包..."

if [ -f "$BACKUP_DIR/app-lists/brew-packages.txt" ]; then
    echo "正在安装："
    cat "$BACKUP_DIR/app-lists/brew-packages.txt" | head -5
    echo "... (共 $(wc -l < "$BACKUP_DIR/app-lists/brew-packages.txt" | tr -d ' ') 个)"

    read -p "是否继续安装? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        while IFS= read -r package; do
            echo "安装 $package..."
            brew install "$package" 2>/dev/null && echo "  ✓ $package" || echo "  ✗ $package 安装失败"
        done < "$BACKUP_DIR/app-lists/brew-packages.txt"
    fi
else
    echo "⚠️  未找到 brew-packages.txt"
fi

# ============================================
# 2. Homebrew Cask 应用
# ============================================
echo -e "\n📦 安装 GUI 应用..."

if [ -f "$BACKUP_DIR/app-lists/brew-casks.txt" ]; then
    echo "正在安装："
    cat "$BACKUP_DIR/app-lists/brew-casks.txt" | head -5
    echo "... (共 $(wc -l < "$BACKUP_DIR/app-lists/brew-casks.txt" | tr -d ' ') 个)"

    read -p "是否继续安装? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        while IFS= read -r cask; do
            echo "安装 $cask..."
            brew install --cask "$cask" 2>/dev/null && echo "  ✓ $cask" || echo "  ✗ $cask 安装失败"
        done < "$BACKUP_DIR/app-lists/brew-casks.txt"
    fi
else
    echo "⚠️  未找到 brew-casks.txt"
fi

# ============================================
# 3. VS Code 扩展
# ============================================
echo -e "\n📦 安装 VS Code 扩展..."

if [ -f "$BACKUP_DIR/app-lists/vscode-extensions.txt" ]; then
    echo "正在安装："
    cat "$BACKUP_DIR/app-lists/vscode-extensions.txt" | head -5
    echo "... (共 $(wc -l < "$BACKUP_DIR/app-lists/vscode-extensions.txt" | tr -d ' ') 个)"

    read -p "是否继续安装? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        while IFS= read -r extension; do
            echo "安装 $extension..."
            code --install-extension "$extension" 2>/dev/null && echo "  ✓ $extension" || echo "  ✗ $extension 安装失败"
        done < "$BACKUP_DIR/app-lists/vscode-extensions.txt"
    fi
else
    echo "⚠️  未找到 vscode-extensions.txt"
fi

# ============================================
# 4. npm 全局包
# ============================================
echo -e "\n📦 安装 npm 全局包..."

if [ -f "$BACKUP_DIR/app-lists/npm-packages.txt" ]; then
    echo "正在安装："
    cat "$BACKUP_DIR/app-lists/npm-packages.txt" | head -5
    echo "... (共 $(wc -l < "$BACKUP_DIR/app-lists/npm-packages.txt" | tr -d ' ') 个)"

    read -p "是否继续安装? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        while IFS= read -r package; do
            # 跳过空行和以 + 开头的行（npm list 输出格式）
            if [[ -n "$package" && ! "$package" =~ ^[+] ]]; then
                echo "安装 $package..."
                npm install -g "$package" 2>/dev/null && echo "  ✓ $package" || echo "  ✗ $package 安装失败"
            fi
        done < "$BACKUP_DIR/app-lists/npm-packages.txt"
    fi
else
    echo "⚠️  未找到 npm-packages.txt"
fi

# ============================================
# 5. Python 包
# ============================================
echo -e "\n📦 安装 Python 包..."

if [ -f "$BACKUP_DIR/app-lists/pip-packages.txt" ]; then
    echo "正在安装："
    cat "$BACKUP_DIR/app-lists/pip-packages.txt" | head -5
    echo "... (共 $(wc -l < "$BACKUP_DIR/app-lists/pip-packages.txt" | tr -d ' ') 个)"

    read -p "是否继续安装? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        pip3 install -r "$BACKUP_DIR/app-lists/pip-packages.txt" && echo "  ✓ Python 包安装完成" || echo "  ✗ Python 包安装失败"
    fi
else
    echo "⚠️  未找到 pip-packages.txt"
fi

# ============================================
# 完成
# ============================================
echo -e "\n=========================================="
echo "✅ 应用重装完成！"
echo "=========================================="

echo -e "\n💡 提示："
echo "  - 某些应用可能需要手动登录"
echo "  - 检查 Application 文件夹确认安装成功"
echo "  - 运行 restore.sh 恢复配置文件"
