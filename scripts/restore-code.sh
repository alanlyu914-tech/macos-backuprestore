#!/bin/bash
# ============================================
# 代码恢复脚本
# 在新电脑上运行此脚本恢复所有代码文件
# ============================================

BACKUP_DIR="$HOME/migration-backup"
CODE_BACKUP="$BACKUP_DIR/code"

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=========================================="
echo "💾 代码恢复脚本"
echo "=========================================="

# 检查备份目录是否存在
if [ ! -d "$CODE_BACKUP" ]; then
    echo -e "${RED}❌ 错误：找不到代码备份目录 $CODE_BACKUP${NC}"
    echo "请先运行 backup.sh 备份代码文件"
    exit 1
fi

echo ""
echo "检测到以下代码备份："
echo ""

# 显示备份内容
if [ -d "$CODE_BACKUP/AI-build" ]; then
    size=$(du -sh "$CODE_BACKUP/AI-build" | cut -f1)
    echo -e "  📁 AI-build ${GREEN}($size)${NC}"
    echo "     └─ $(ls -1 "$CODE_BACKUP/AI-build" | wc -l | tr -d ' ') 个项目"
fi

if [ -d "$CODE_BACKUP/codex" ]; then
    size=$(du -sh "$CODE_BACKUP/codex" | cut -f1)
    echo -e "  📁 codex ${GREEN}($size)${NC}"
fi

echo ""
read -p "是否恢复这些代码文件？ [Y/n] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ ! -z "$REPLY" ]]; then
    echo "已取消恢复"
    exit 0
fi

# 创建目标目录
echo ""
echo "创建目标目录..."
mkdir -p ~/Documents

# 恢复 AI build
if [ -d "$CODE_BACKUP/AI-build" ]; then
    echo ""
    echo "=========================================="
    echo "📦 恢复 AI build..."
    echo "=========================================="

    target="$HOME/Documents/AI build"

    # 检查目标是否已存在
    if [ -d "$target" ]; then
        echo -e "${YELLOW}⚠️  目标目录已存在：$target${NC}"
        echo "选择操作："
        echo "  1. 备份现有文件并覆盖"
        echo "  2. 跳过 AI build"
        echo "  3. 取消"
        read -p "请选择 [1-3]: " -n 1 -r
        echo

        case $REPLY in
            1)
                # 备份现有文件
                backup_name="AI-build-backup-$(date +%Y%m%d_%H%M%S)"
                echo "备份现有文件到 ~/Documents/$backup_name"
                mv "$target" "$HOME/Documents/$backup_name"
                ;;
            2)
                echo "跳过 AI build"
                ;;
            3)
                echo "已取消恢复"
                exit 0
                ;;
        esac
    fi

    if [ ! -d "$target" ]; then
        echo "正在复制..."
        cp -r "$CODE_BACKUP/AI-build" "$target"
        echo -e "${GREEN}✅ AI build 恢复完成${NC}"
    fi
fi

# 恢复 codex
if [ -d "$CODE_BACKUP/codex" ]; then
    echo ""
    echo "=========================================="
    echo "📦 恢复 codex..."
    echo "=========================================="

    target="$HOME/Documents/codex"

    # 检查目标是否已存在
    if [ -d "$target" ]; then
        echo -e "${YELLOW}⚠️  目标目录已存在：$target${NC}"
        echo "选择操作："
        echo "  1. 备份现有文件并覆盖"
        echo "  2. 跳过 codex"
        echo "  3. 取消"
        read -p "请选择 [1-3]: " -n 1 -r
        echo

        case $REPLY in
            1)
                # 备份现有文件
                backup_name="codex-backup-$(date +%Y%m%d_%H%M%S)"
                echo "备份现有文件到 ~/Documents/$backup_name"
                mv "$target" "$HOME/Documents/$backup_name"
                ;;
            2)
                echo "跳过 codex"
                ;;
            3)
                echo "已取消恢复"
                exit 0
                ;;
        esac
    fi

    if [ ! -d "$target" ]; then
        echo "正在复制..."
        cp -r "$CODE_BACKUP/codex" "$target"
        echo -e "${GREEN}✅ codex 恢复完成${NC}"
    fi
fi

# 完成
echo ""
echo "=========================================="
echo -e "${GREEN}✅ 代码恢复完成！${NC}"
echo "=========================================="

echo ""
echo "📋 恢复摘要："
if [ -d "$HOME/Documents/AI build" ]; then
    echo -e "  ${GREEN}✅${NC} ~/Documents/AI build"
fi
if [ -d "$HOME/Documents/codex" ]; then
    echo -e "  ${GREEN}✅${NC} ~/Documents/codex"
fi

echo ""
echo "💡 接下来需要："
echo "  1. 安装项目依赖: cd ~/migration-backup/scripts && ./restore-projects.sh"
echo "  2. 恢复环境变量: ./quick-copy-env.sh"
echo "  3. 验证项目配置: ./verify-projects.sh"

echo ""
echo "📖 查看代码备份清单:"
echo "  cat ~/migration-backup/code/代码备份清单.md"

echo ""
echo "=========================================="
