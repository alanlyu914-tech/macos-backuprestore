#!/bin/bash
# ============================================
# 🚀 完整一键重装所有应用（增强版）
# 在新电脑上运行（需先安装 Homebrew）
# ============================================

BACKUP_DIR="$HOME/migration-backup"

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=========================================="
echo "🚀 开始批量重装所有应用（增强版）"
echo "=========================================="

# 检查备份目录是否存在
if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${RED}❌ 错误：找不到备份目录 $BACKUP_DIR${NC}"
    echo "请先运行 backup.sh 并将备份复制到新电脑"
    exit 1
fi

# 检查 Homebrew 是否已安装
if ! command -v brew &> /dev/null; then
    echo -e "${RED}❌ 错误：Homebrew 未安装${NC}"
    echo "请先安装 Homebrew："
    echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    exit 1
fi

# 更新 Homebrew
echo -e "\n📦 更新 Homebrew..."
brew update

# ============================================
# 1. Homebrew 命令行工具包
# ============================================
echo -e "\n=========================================="
echo "📦 [1/6] 安装 Homebrew 命令行工具"
echo "=========================================="

if [ -f "$BACKUP_DIR/app-lists/brew-packages.txt" ]; then
    package_count=$(wc -l < "$BACKUP_DIR/app-lists/brew-packages.txt" | tr -d ' ')
    echo "准备安装 $package_count 个命令行工具..."
    echo "包括：FFmpeg、Python、Pillow、Tesseract 等"
    echo ""

    while IFS= read -r package; do
        # 跳过空行
        [[ -z "$package" ]] && continue

        echo -n "  安装 $package..."
        if brew list "$package" &> /dev/null; then
            echo -e " ${GREEN}已安装${NC}"
        else
            if brew install "$package" &> /dev/null; then
                echo -e " ${GREEN}✓${NC}"
            else
                echo -e " ${RED}✗${NC}"
            fi
        fi
    done < "$BACKUP_DIR/app-lists/brew-packages.txt"

    echo -e "${GREEN}✅ 命令行工具安装完成${NC}"
else
    echo -e "${YELLOW}⚠️  未找到 brew-packages.txt${NC}"
fi

# ============================================
# 2. GUI 应用（新增！）
# ============================================
echo -e "\n=========================================="
echo "🖥️  [2/6] 安装 GUI 应用"
echo "=========================================="

# 定义应用列表
declare -A gui_apps=(
    ["google-chrome"]="Google Chrome"
    ["wechat"]="微信"
    ["visual-studio-code"]="Visual Studio Code"
    ["cursor"]="Cursor 编辑器"
    ["tencent-meeting"]="腾讯会议"
    ["audacity"]="Audacity"
    ["baidunetdisk"]="百度网盘"
    ["lark"]="飞书"
    ["pastenow"]="PasteNow"
    ["sunloginclient"]="向日葵远程控制"
    ["wpsoffice"]="WPS Office"
    ["cleanmymac"]="CleanMyMac"
    ["permute"]="Permute"
    ["screen-studio"]="ScreenStudio"
    ["videofusion"]="万兴优转"
    ["xlplayer"]="迅雷播放器"
    ["clash-verge-rev"]="Clash Verge"
)

total_gui_apps=${#gui_apps[@]}
installed_gui_apps=0

echo "准备安装 $total_gui_apps 个 GUI 应用..."
echo ""

for cask_name in "${!gui_apps[@]}"; do
    app_name="${gui_apps[$cask_name]}"

    echo -n "  安装 $app_name..."

    # 检查是否已安装
    if brew list --cask "$cask_name" &> /dev/null; then
        echo -e " ${GREEN}已安装${NC}"
        ((installed_gui_apps++))
    else
        # 尝试安装
        if brew install --cask "$cask_name" &> /dev/null; then
            echo -e " ${GREEN}✓${NC}"
            ((installed_gui_apps++))
        else
            echo -e " ${YELLOW}⚠ (可能需要手动安装)${NC}"
        fi
    fi
done

echo -e "${GREEN}✅ GUI 应用安装完成（$installed_gui_apps/$total_gui_apps）${NC}"

# ============================================
# 3. VS Code 扩展
# ============================================
echo -e "\n=========================================="
echo "🧩 [3/6] 安装 VS Code 扩展"
echo "=========================================="

if [ -f "$BACKUP_DIR/app-lists/vscode-extensions.txt" ]; then
    # 检查 VS Code 是否已安装
    if ! command -v code &> /dev/null; then
        echo -e "${YELLOW}⚠️  VS Code 未安装，跳过扩展安装${NC}"
    else
        ext_count=$(wc -l < "$BACKUP_DIR/app-lists/vscode-extensions.txt" | tr -d ' ')
        echo "准备安装 $ext_count 个 VS Code 扩展..."
        echo ""

        installed_extensions=0
        while IFS= read -r extension; do
            [[ -z "$extension" ]] && continue

            echo -n "  安装 $extension..."
            if code --install-extension "$extension" &> /dev/null; then
                echo -e " ${GREEN}✓${NC}"
                ((installed_extensions++))
            else
                echo -e " ${YELLOW}可能已安装${NC}"
                ((installed_extensions++))
            fi
        done < "$BACKUP_DIR/app-lists/vscode-extensions.txt"

        echo -e "${GREEN}✅ VS Code 扩展安装完成（$installed_extensions/$ext_count）${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  未找到 vscode-extensions.txt${NC}"
fi

# ============================================
# 4. npm 全局包
# ============================================
echo -e "\n=========================================="
echo "📦 [4/6] 安装 npm 全局包"
echo "=========================================="

if [ -f "$BACKUP_DIR/app-lists/npm-global.json" ]; then
    echo "准备安装 npm 全局包..."
    echo ""

    # 使用 npm install -g 直接从 json 安装
    if npm install -g $(cat "$BACKUP_DIR/app-lists/npm-global.json" | grep -o '"name":"[^"]*"' | cut -d'"' -f4 | tr '\n' ' ') 2>/dev/null; then
        echo -e "${GREEN}✅ npm 全局包安装完成${NC}"
    else
        echo -e "${YELLOW}⚠️  npm 全局包安装遇到问题（可能已经安装）${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  未找到 npm-global.json${NC}"
fi

# ============================================
# 5. Python 包
# ============================================
echo -e "\n=========================================="
echo "🐍 [5/6] 安装 Python 包"
echo "=========================================="

if [ -f "$BACKUP_DIR/app-lists/pip-packages.txt" ]; then
    pip_count=$(wc -l < "$BACKUP_DIR/app-lists/pip-packages.txt" | tr -d ' ')
    echo "准备安装 $pip_count 个 Python 包..."
    echo ""

    if pip3 install -r "$BACKUP_DIR/app-lists/pip-packages.txt" &> /dev/null; then
        echo -e "${GREEN}✅ Python 包安装完成${NC}"
    else
        echo -e "${YELLOW}⚠️  Python 包安装遇到问题（可能已经安装）${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  未找到 pip-packages.txt${NC}"
fi

# ============================================
# 6. AI 项目依赖
# ============================================
echo -e "\n=========================================="
echo "🤖 [6/6] 安装 AI 项目依赖"
echo "=========================================="

# 检查项目目录是否存在
if [ -d "$HOME/Documents/AI build" ]; then
    echo "发现 AI 项目目录，开始安装项目依赖..."
    echo ""

    # 安装 Python 项目依赖
    python_projects=0
    find "$HOME/Documents/AI build" -name "requirements.txt" -type f | while read req_file; do
        project_dir=$(dirname "$req_file")
        project_name=$(basename "$project_dir")

        echo -n "  安装 $project_name 依赖..."

        if pip3 install -r "$req_file" &> /dev/null; then
            echo -e " ${GREEN}✓${NC}"
        else
            echo -e " ${YELLOW}⚠ (可能已安装)${NC}"
        fi
        ((python_projects++))
    done

    # 安装 Node.js 项目依赖
    find "$HOME/Documents/AI build" -name "package.json" -type f | while read pkg_file; do
        project_dir=$(dirname "$pkg_file")
        project_name=$(basename "$project_dir")

        echo -n "  安装 $project_name 依赖..."

        cd "$project_dir" 2>/dev/null
        if npm install &> /dev/null; then
            echo -e " ${GREEN}✓${NC}"
        else
            echo -e " ${YELLOW}⚠ (可能已安装)${NC}"
        fi
    done

    echo -e "${GREEN}✅ AI 项目依赖安装完成${NC}"
else
    echo -e "${YELLOW}⚠️  未找到 AI 项目目录，跳过项目依赖安装${NC}"
    echo "如需安装项目依赖，请先复制项目文件夹，然后运行："
    echo "  cd ~/migration-backup/scripts && ./restore-projects.sh"
fi

# ============================================
# 完成
# ============================================
echo -e "\n=========================================="
echo -e "${GREEN}🎉 所有应用安装完成！${NC}"
echo "=========================================="

echo -e "\n📊 安装摘要："
echo "  ✅ 命令行工具：$(wc -l < "$BACKUP_DIR/app-lists/brew-packages.txt" 2>/dev/null | tr -d ' ') 个"
echo "  ✅ GUI 应用：$installed_gui_apps/$total_gui_apps"
echo "  ✅ VS Code 扩展：$(wc -l < "$BACKUP_DIR/app-lists/vscode-extensions.txt" 2>/dev/null | tr -d ' ') 个"
echo "  ✅ Python 包：$(wc -l < "$BACKUP_DIR/app-lists/pip-packages.txt" 2>/dev/null | tr -d ' ') 个"

echo -e "\n💡 接下来可以："
echo "  1. 恢复系统配置: cd ~/migration-backup/scripts && ./restore.sh"
echo "  2. 恢复环境变量: ./quick-copy-env.sh"
echo "  3. 验证项目配置: ./verify-projects.sh"

echo -e "\n⚠️  需要手动安装的应用："
cat << 'EOF'
  - Antigravity Tools
  - CC Switch
  - COCODUCK
  - Codex.app
  - Dia.app
  - LetsVPN
  - Quark
  - ZipMasterMac
  - cursor-agent.app
  - flomo
  - 蚁小二4.0.app
  - 迅捷图片转换器.app
EOF

echo ""
echo "=========================================="
