#!/bin/bash
# ============================================
# 🔧 自动确保 Homebrew 在 PATH 中
# 检测系统架构并自动添加到相应配置文件
# ============================================

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 检测系统架构
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    HOMEBREW_PREFIX="/opt/homebrew"
    PROFILE_FILE="$HOME/.zprofile"
    SHELL_CONFIG="~/.zprofile"
else
    HOMEBREW_PREFIX="/usr/local"
    PROFILE_FILE="$HOME/.bash_profile"
    SHELL_CONFIG="~/.bash_profile"
fi

echo "=========================================="
echo "🔧 Homebrew PATH 配置工具"
echo "=========================================="
echo -e "检测到系统架构: ${BLUE}$ARCH${NC}"
echo -e "Homebrew 路径: ${BLUE}$HOMEBREW_PREFIX${NC}"
echo -e "配置文件: ${BLUE}$SHELL_CONFIG${NC}"
echo ""

# 检查 Homebrew 是否已安装
if [ ! -d "$HOMEBREW_PREFIX/bin/brew" ]; then
    echo -e "${YELLOW}⚠️  未检测到 Homebrew 安装${NC}"
    echo ""
    echo "请先安装 Homebrew："
    echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    echo ""
    echo "安装完成后，请再次运行此脚本。"
    exit 1
fi

echo -e "${GREEN}✓ 检测到 Homebrew 已安装${NC}"
echo ""

# 检查是否已在 PATH 中
if command -v brew &> /dev/null; then
    echo -e "${GREEN}✓ Homebrew 已在 PATH 中${NC}"
    echo ""
    brew --version
    echo ""
    echo "无需额外配置。"
    exit 0
fi

echo -e "${YELLOW}⚠️  Homebrew 未在 PATH 中，正在添加...${NC}"
echo ""

# 检查配置文件是否存在
if [ ! -f "$PROFILE_FILE" ]; then
    echo "创建配置文件: $SHELL_CONFIG"
    touch "$PROFILE_FILE"
fi

# 检查是否已经添加过（即使当前不在 PATH）
if grep -q "eval \"\$($HOMEBREW_PREFIX/bin/brew shellenv)\"" "$PROFILE_FILE" 2>/dev/null; then
    echo -e "${GREEN}✓ 配置已存在于 $SHELL_CONFIG 中${NC}"
    echo ""
    echo "尝试加载配置..."
    eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

    if command -v brew &> /dev/null; then
        echo -e "${GREEN}✓ Homebrew 现在可用！${NC}"
        echo ""
        brew --version
        echo ""
        echo -e "${YELLOW}💡 提示：${NC}请运行以下命令使配置在当前会话中生效："
        echo "  source $SHELL_CONFIG"
        echo ""
        echo "或重新打开终端。"
    fi
    exit 0
fi

# 添加 Homebrew 到配置文件
echo "添加 Homebrew 到 $SHELL_CONFIG..."

cat >> "$PROFILE_FILE" << 'EOF'

# ============================================
# Homebrew 配置（由 macOS 迁移工具自动添加）
# ============================================
eval "$(/opt/homebrew/bin/brew shellenv)"
EOF

# 根据架构替换路径
if [ "$ARCH" != "arm64" ]; then
    sed -i '' "s|/opt/homebrew|/usr/local|g" "$PROFILE_FILE"
fi

echo -e "${GREEN}✓ 已添加到 $SHELL_CONFIG${NC}"
echo ""

# 立即加载
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

if command -v brew &> /dev/null; then
    echo -e "${GREEN}==========================================${NC}"
    echo -e "${GREEN}✓ Homebrew 配置完成！${NC}"
    echo -e "${GREEN}==========================================${NC}"
    echo ""
    brew --version
    echo ""
    echo -e "${BLUE}📝 下一步：${NC}"
    echo "  1. 运行: source $SHELL_CONFIG"
    echo "  2. 或重新打开终端"
    echo "  3. 然后继续恢复流程"
else
    echo -e "${YELLOW}==========================================${NC}"
    echo -e "${YELLOW}⚠️  配置已添加，请执行以下操作：${NC}"
    echo -e "${YELLOW}==========================================${NC}"
    echo ""
    echo "  source $SHELL_CONFIG"
    echo ""
    echo "然后重新运行此脚本验证。"
fi
