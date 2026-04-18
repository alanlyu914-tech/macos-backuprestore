#!/bin/bash
# ============================================
# 🍁 macOS 迁移备份工具 - 一键备份脚本
# ============================================
#
# 用法：./backup.sh
#
# 功能：
# - 自动扫描开发环境、应用、配置、代码项目
# - 逐项显示并让你确认要备份的内容
# - 自动备份到 ~/macos-backuprestore/
# - 生成恢复脚本
#
# ============================================

set -e

# 项目目录
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_BASE="$HOME/macos-backuprestore"
SCANNER_DIR="$PROJECT_DIR/scanner"

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 创建备份目录
mkdir -p "$BACKUP_BASE"

echo "=========================================="
echo "🍁 macOS 迁移备份工具"
echo "=========================================="
echo ""
echo "备份目录: $BACKUP_BASE"
echo ""

# ============================================
# 步骤1：扫描系统
# ============================================
echo -e "${BLUE}第 1 步：扫描你的电脑${NC}"
echo "=========================================="

if [ -f "$SCANNER_DIR/scan-all.sh" ]; then
    bash "$SCANNER_DIR/scan-all.sh"
else
    echo -e "${RED}❌ 找不到扫描脚本${NC}"
    exit 1
fi

# 读取扫描结果
SCAN_RESULT="$BACKUP_BASE/scan-result.txt"
if [ ! -f "$SCAN_RESULT" ]; then
    echo -e "${RED}❌ 扫描失败${NC}"
    exit 1
fi

source "$SCAN_RESULT"

# 创建必要的目录
mkdir -p "$BACKUP_BASE/config"
mkdir -p "$BACKUP_BASE/app-lists"
mkdir -p "$BACKUP_BASE/ssh"
mkdir -p "$BACKUP_BASE/projects"

echo ""
echo "=========================================="
echo -e "${BLUE}第 2 步：选择要备份的内容${NC}"
echo "=========================================="
echo ""

# ============================================
# 显示应用软件
# ============================================
echo -e "${GREEN}📱 发现的应用软件：${NC}"
echo "  • Homebrew 工具: $BREW_APPS_COUNT 个"
if [ -n "$BREW_APPS_SAMPLE" ]; then
    echo "    示例: $BREW_APPS_SAMPLE"
fi
echo "  • GUI 应用: $CASK_APPS_COUNT 个"
if [ -n "$CASK_APPS_SAMPLE" ]; then
    echo "    示例: $CASK_APPS_SAMPLE"
fi
echo "  • 其他应用: $OTHER_APPS_COUNT 个"
echo ""

# ============================================
# 显示开发环境
# ============================================
echo -e "${GREEN}🔧 开发环境：${NC}"
echo "  • Python: $PYTHON_VERSION"
echo "  • Node.js: $NODE_VERSION"
echo "  • Git: $GIT_VERSION"
echo "  • Docker: $DOCKER_VERSION"
echo ""

# ============================================
# 显示代码项目
# ============================================
echo -e "${GREEN}💻 代码项目：${NC}"
echo "  • 项目总数: $PROJECTS_COUNT 个"
echo "  • Python 项目: $PYTHON_PROJECTS 个"
echo "  • Node.js 项目: $NODEJS_PROJECTS 个"
echo "  • Git 仓库: $GIT_REPOS 个"
echo "  • 项目大小: ${PROJECTS_SIZE}MB"
echo ""

# ============================================
# 显示配置文件
# ============================================
echo -e "${GREEN}⚙️  配置文件：${NC}"
echo "  • 发现 $CONFIGS_COUNT 个配置"
echo "  • SSH 密钥: $SSH_KEY_FOUND"
echo ""

# ============================================
# 交互式选择
# ============================================
echo "=========================================="
echo "现在选择要备份的内容："
echo "=========================================="
echo ""

# 应用软件
read -p "是否备份应用列表？(y/N): " backup_apps
if [[ $backup_apps =~ ^[Yy]$ ]]; then
    BACKUP_APPS=true
else
    BACKUP_APPS=false
fi

# 代码项目
read -p "是否备份代码项目列表？(y/N): " backup_projects
if [[ $backup_projects =~ ^[Yy]$ ]]; then
    BACKUP_PROJECTS=true
else
    BACKUP_PROJECTS=false
fi

# 配置文件
read -p "是否备份系统配置？(包括 Shell、Git、SSH、VS Code) (y/N): " backup_configs
if [[ $backup_configs =~ ^[Yy]$ ]]; then
    BACKUP_CONFIGS=true
else
    BACKUP_CONFIGS=false
fi

echo ""
echo "=========================================="
echo -e "${BLUE}第 3 步：开始备份${NC}"
echo "=========================================="
echo ""

# ============================================
# 备份应用列表
# ============================================
if [ "$BACKUP_APPS" = true ]; then
    echo "📱 备份应用列表..."

    # Homebrew 工具
    if command -v brew &> /dev/null; then
        brew list > "$BACKUP_BASE/app-lists/brew-packages.txt" 2>/dev/null
        echo "  ✓ Homebrew 工具: $(wc -l < "$BACKUP_BASE/app-lists/brew-packages.txt" | tr -d ' ') 个"

        # Cask 应用
        brew list --cask > "$BACKUP_BASE/app-lists/brew-casks.txt" 2>/dev/null
        echo "  ✓ GUI 应用: $(wc -l < "$BACKUP_BASE/app-lists/brew-casks.txt" | tr -d ' ') 个"
    fi

    # VS Code 扩展
    if command -v code &> /dev/null; then
        code --list-extensions > "$BACKUP_BASE/app-lists/vscode-extensions.txt" 2>/dev/null
        echo "  ✓ VS Code 扩展: $(wc -l < "$BACKUP_BASE/app-lists/vscode-extensions.txt" | tr -d ' ') 个"
    fi

    # npm 全局包
    if command -v npm &> /dev/null; then
        npm list -g --depth=0 --json > "$BACKUP_BASE/app-lists/npm-global.json" 2>/dev/null
        echo "  ✓ npm 全局包"
    fi

    # Python 包
    if command -v pip3 &> /dev/null; then
        pip3 list --format=freeze > "$BACKUP_BASE/app-lists/pip-packages.txt" 2>/dev/null
        echo "  ✓ Python 包: $(wc -l < "$BACKUP_BASE/app-lists/pip-packages.txt" | tr -d ' ') 个"
    fi
fi

# ============================================
# 备份配置文件
# ============================================
if [ "$BACKUP_CONFIGS" = true ]; then
    echo "⚙️  备份系统配置..."

    # Shell 配置
    for file in .zshrc .bashrc .bash_profile .bash_aliases .zprofile; do
        if [ -f "$HOME/$file" ]; then
            cp "$HOME/$file" "$BACKUP_BASE/config/$file" 2>/dev/null
            echo "  ✓ $file"
        fi
    done

    # Git 配置
    if [ -f "$HOME/.gitconfig" ]; then
        cp "$HOME/.gitconfig" "$BACKUP_BASE/config/.gitconfig" 2>/dev/null
        echo "  ✓ .gitconfig"
    fi
    if [ -f "$HOME/.gitignore_global" ]; then
        cp "$HOME/.gitignore_global" "$BACKUP_BASE/config/.gitignore_global" 2>/dev/null
        echo "  ✓ .gitignore_global"
    fi

    # SSH 密钥
    if [ -d "$HOME/.ssh" ]; then
        cp -r "$HOME/.ssh" "$BACKUP_BASE/ssh/" 2>/dev/null
        echo "  ✓ SSH 密钥"
    fi

    # VS Code 配置
    VSC_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
    if [ -f "$VSC_SETTINGS" ]; then
        cp "$VSC_SETTINGS" "$BACKUP_BASE/config/vscode-settings.json" 2>/dev/null
        echo "  ✓ VS Code settings"
    fi

    VSC_KEYBINDINGS="$HOME/Library/Application Support/Code/User/keybindings.json"
    if [ -f "$VSC_KEYBINDINGS" ]; then
        cp "$VSC_KEYBINDINGS" "$BACKUP_BASE/config/vscode-keybindings.json" 2>/dev/null
        echo "  ✓ VS Code keybindings"
    fi

    # Claude Code 配置
    if [ -d "$HOME/.claude" ]; then
        cp -r "$HOME/.claude" "$BACKUP_BASE/config/claude-code" 2>/dev/null
        echo "  ✓ Claude Code 配置"
    fi
fi

# ============================================
# 备份代码项目列表
# ============================================
if [ "$BACKUP_PROJECTS" = true ]; then
    echo "💻 备份代码项目列表..."

    # 记录项目目录
    for dir in "$HOME/Documents" "$HOME/Desktop" "$HOME/Projects" "$HOME/code" "$HOME/work"; do
        if [ -d "$dir" ]; then
            echo "$dir" >> "$BACKUP_BASE/projects/project-dirs.txt"
        fi
    done

    # 查找所有项目
    PROJECTS_FILE="$BACKUP_BASE/projects/projects-list.txt"
    echo "# 代码项目列表 - $(date)" > "$PROJECTS_FILE"
    echo "# 扫描目录: Documents, Desktop, Projects, code, work" >> "$PROJECTS_FILE"
    echo "" >> "$PROJECTS_FILE"

    for dir in "$HOME/Documents" "$HOME/Desktop" "$HOME/Projects" "$HOME/code" "$HOME/work"; do
        if [ ! -d "$dir" ]; then
            continue
        fi

        # 查找 Python 项目
        find "$dir" -name "requirements.txt" -type f -exec dirname {} \; 2>/dev/null | while read project; do
            if [ -d "$project" ]; then
                name=$(basename "$project")
                echo "[Python] $name - $project" >> "$PROJECTS_FILE"
            fi
        done

        # 查找 Node.js 项目
        find "$dir" -name "package.json" -type f -exec dirname {} \; 2>/dev/null | while read project; do
            if [ -d "$project" ]; then
                # 排除 Python 项目
                if [ ! -f "$project/requirements.txt" ]; then
                    name=$(basename "$project")
                    echo "[Node.js] $name - $project" >> "$PROJECTS_FILE"
                fi
            done
        done
    done

    echo "  ✓ 项目列表已保存"
fi

# ============================================
# 复制脚本到备份目录
# ============================================
echo "📝 准备恢复脚本..."
mkdir -p "$BACKUP_BASE/scripts"
cp -r "$PROJECT_DIR/scripts"/* "$BACKUP_BASE/scripts/" 2>/dev/null
echo "  ✓ 恢复脚本已复制"

# ============================================
# 完成
# ============================================
echo ""
echo "=========================================="
echo -e "${GREEN}✅ 备份完成！${NC}"
echo "=========================================="
echo ""

# 显示备份摘要
echo "📊 备份摘要："
echo "  备份位置: $BACKUP_BASE"
echo ""

if [ "$BACKUP_APPS" = true ]; then
    echo "  应用列表:"
    [ -f "$BACKUP_BASE/app-lists/brew-packages.txt" ] && echo "    • Homebrew 工具: $(wc -l < "$BACKUP_BASE/app-lists/brew-packages.txt" | tr -d ' ') 个"
    [ -f "$BACKUP_BASE/app-lists/brew-casks.txt" ] && echo "    • GUI 应用: $(wc -l < "$BACKUP_BASE/app-lists/brew-casks.txt" | tr -d ' ') 个"
    [ -f "$BACKUP_BASE/app-lists/vscode-extensions.txt" ] && echo "    • VS Code 扩展: $(wc -l < "$BACKUP_BASE/app-lists/vscode-extensions.txt" | tr -d ' ') 个"
fi

if [ "$BACKUP_CONFIGS" = true ]; then
    echo "  系统配置: 已备份"
fi

if [ "$BACKUP_PROJECTS" = true ]; then
    echo "  项目列表: 已记录"
fi

echo ""
echo "=========================================="
echo -e "${YELLOW}⚠️  下一步操作${NC}"
echo "=========================================="
echo ""
echo "1. 将备份文件夹复制到外置硬盘："
echo "   cp -r $BACKUP_BASE /Volumes/你的外置硬盘/"
echo ""
echo "2. 手动复制大文件到外置硬盘："
echo "   cp -r ~/Documents /Volumes/你的外置硬盘/"
echo "   cp -r ~/Pictures /Volumes/你的外置硬盘/"
echo "   cp -r ~/Movies /Volumes/你的外置硬盘/"
echo "   cp -r ~/Desktop /Volumes/你的外置硬盘/"
echo ""
echo "3. 在新电脑上恢复："
echo "   cp -r /Volumes/你的外置硬盘/macos-backuprestore ~/"
echo "   cd ~/macos-backuprestore/scripts"
echo "   ./restore-all.sh"
echo ""
