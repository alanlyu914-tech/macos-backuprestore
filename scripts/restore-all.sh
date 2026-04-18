#!/bin/bash
# ============================================
# 🍁 macOS 迁移恢复工具 - 一键恢复脚本
# ============================================
#
# 用法：./restore-all.sh
#
# 功能：
# - 自动检测并安装 Homebrew
# - 自动配置 Homebrew PATH
# - 恢复系统配置
# - 安装所有应用和工具
# - 恢复代码项目
# - 恢复项目依赖
#
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$(dirname "$SCRIPT_DIR")"

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 步骤计数
STEP=0

print_step() {
    ((STEP++))
    echo ""
    echo "=========================================="
    echo -e "${BLUE}第 $STEP 步：$1${NC}"
    echo "=========================================="
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# ============================================
# 欢迎信息
# ============================================
echo "=========================================="
echo "🍁 macOS 迁移恢复工具"
echo "=========================================="
echo ""
echo "备份目录: $BACKUP_DIR"
echo ""

# 检查备份目录是否存在
if [ ! -d "$BACKUP_DIR" ]; then
    print_error "找不到备份目录 $BACKUP_DIR"
    echo ""
    echo "请先从外置硬盘复制备份文件夹："
    echo "  cp -r /Volumes/你的外置硬盘/macos-backuprestore ~/"
    exit 1
fi

print_success "找到备份目录"

# ============================================
# 步骤1：安装 Homebrew
# ============================================
print_step "检查并安装 Homebrew"

if command -v brew &> /dev/null; then
    print_success "Homebrew 已安装"
    brew --version
else
    echo "Homebrew 未安装，正在安装..."
    echo ""
    echo "安装过程中可能需要输入密码..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [ $? -eq 0 ]; then
        print_success "Homebrew 安装完成"
    else
        print_error "Homebrew 安装失败"
        echo ""
        echo "请手动安装 Homebrew："
        echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        exit 1
    fi
fi

# ============================================
# 步骤2：配置 Homebrew PATH
# ============================================
print_step "配置 Homebrew PATH"

if [ -f "$SCRIPT_DIR/ensure-homebrew-in-path.sh" ]; then
    bash "$SCRIPT_DIR/ensure-homebrew-in-path.sh"
else
    # 内联 PATH 配置逻辑
    ARCH=$(uname -m)
    if [ "$ARCH" = "arm64" ]; then
        HOMEBREW_PREFIX="/opt/homebrew"
        PROFILE_FILE="$HOME/.zprofile"
    else
        HOMEBREW_PREFIX="/usr/local"
        PROFILE_FILE="$HOME/.bash_profile"
    fi

    if ! command -v brew &> /dev/null; then
        print_warning "Homebrew 不在 PATH 中，正在配置..."
        eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
        print_success "Homebrew 已添加到 PATH"
    else
        print_success "Homebrew 已在 PATH 中"
    fi
fi

# ============================================
# 步骤3：恢复系统配置
# ============================================
print_step "恢复系统配置"

if [ -f "$SCRIPT_DIR/restore.sh" ]; then
    bash "$SCRIPT_DIR/restore.sh"
else
    print_warning "未找到 restore.sh，跳过配置恢复"
fi

# ============================================
# 步骤4：安装所有应用
# ============================================
print_step "安装应用和工具"

if [ -f "$SCRIPT_DIR/reinstall-everything.sh" ]; then
    bash "$SCRIPT_DIR/reinstall-everything.sh"
else
    print_warning "未找到 reinstall-everything.sh，跳过应用安装"
fi

# ============================================
# 步骤5：恢复代码项目
# ============================================
print_step "恢复代码项目"

if [ -f "$SCRIPT_DIR/restore-code.sh" ]; then
    read -p "是否恢复代码项目？(需要先复制项目文件夹) (y/N): " restore_code
    if [[ $restore_code =~ ^[Yy]$ ]]; then
        bash "$SCRIPT_DIR/restore-code.sh"
    else
        print_warning "跳过代码项目恢复"
    fi
else
    print_warning "未找到 restore-code.sh，跳过代码项目恢复"
fi

# ============================================
# 步骤6：恢复项目依赖
# ============================================
print_step "恢复项目依赖"

if [ -f "$SCRIPT_DIR/restore-projects.sh" ]; then
    read -p "是否恢复项目依赖？(y/N): " restore_deps
    if [[ $restore_deps =~ ^[Yy]$ ]]; then
        bash "$SCRIPT_DIR/restore-projects.sh"
    else
        print_warning "跳过项目依赖恢复"
    fi
else
    print_warning "未找到 restore-projects.sh，跳过项目依赖恢复"
fi

# ============================================
# 步骤7：恢复 GitHub 配置（可选）
# ============================================
print_step "GitHub 配置（可选）"

if [ -f "$SCRIPT_DIR/restore-github.sh" ]; then
    read -p "是否恢复 GitHub 配置？(y/N): " restore_github
    if [[ $restore_github =~ ^[Yy]$ ]]; then
        bash "$SCRIPT_DIR/restore-github.sh"
    else
        print_warning "跳过 GitHub 配置"
    fi
else
    print_warning "未找到 restore-github.sh，跳过 GitHub 配置"
fi

# ============================================
# 完成
# ============================================
echo ""
echo "=========================================="
echo -e "${GREEN}🎉 恢复完成！${NC}"
echo "=========================================="
echo ""

print_success "所有步骤已完成"

echo ""
echo "=========================================="
echo -e "${YELLOW}⚠️  手动操作提醒${NC}"
echo "=========================================="
echo ""
echo "如果之前备份了个人文件，请手动复制："
echo "  cp -r /Volumes/你的外置硬盘/Documents ~/"
echo "  cp -r /Volumes/你的外置硬盘/Pictures ~/"
echo "  cp -r /Volumes/你的外置硬盘/Movies ~/"
echo "  cp -r /Volumes/你的外置硬盘/Desktop ~/"
echo ""
echo "=========================================="
echo -e "${GREEN}💡 接下来${NC}"
echo "=========================================="
echo ""
echo "1. 重新打开终端（确保 PATH 配置生效）"
echo "2. 验证开发环境："
echo "   - python3 --version"
echo "   - node --version"
echo "   - git --version"
echo "   - code --version"
echo "3. 运行项目测试"
echo ""
echo "📚 查看详细文档: $BACKUP_DIR/docs/"
echo ""
