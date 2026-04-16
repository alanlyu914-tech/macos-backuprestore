#!/bin/bash
# ============================================
# 🐙 恢复 GitHub 配置
# 在新电脑上运行，快速恢复 GitHub 开发环境
# ============================================

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "=========================================="
echo "🐙 GitHub 配置恢复"
echo "=========================================="
echo ""

# ============================================
# 1. 配置 Git 用户信息
# ============================================
echo -e "${BLUE}📝 配置 Git 用户信息...${NC}"
echo ""

GIT_NAME="大东"
GIT_EMAIL="alanlyu914@gmail.com"

# 检查是否已配置
CURRENT_NAME=$(git config --global user.name)
CURRENT_EMAIL=$(git config --global user.email)

if [ "$CURRENT_NAME" = "$GIT_NAME" ] && [ "$CURRENT_EMAIL" = "$GIT_EMAIL" ]; then
    echo -e "${GREEN}✅ Git 用户信息已配置${NC}"
else
    echo "配置全局 Git 用户信息："
    echo "  用户名: $GIT_NAME"
    echo "  邮箱: $GIT_EMAIL"
    echo ""

    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"

    echo -e "${GREEN}✅ Git 用户信息配置完成${NC}"
fi

echo ""
echo "───────────────────────────────────────────────────"
echo ""

# ============================================
# 2. 验证 SSH 密钥
# ============================================
echo -e "${BLUE}🔑 验证 SSH 密钥...${NC}"
echo ""

SSH_KEY="$HOME/.ssh/id_ed25519"

if [ -f "$SSH_KEY" ]; then
    echo -e "${GREEN}✅ SSH 密钥已存在${NC}"

    # 验证权限
    if [ "$(stat -f %Lp "$SSH_KEY" 2>/dev/null || stat -c %a "$SSH_KEY" 2>/dev/null)" != "600" ]; then
        echo "  修复 SSH 密钥权限..."
        chmod 600 "$SSH_KEY"
        chmod 644 "${SSH_KEY}.pub"
        echo -e "${GREEN}  ✅ 权限已修复${NC}"
    fi

    # 测试 GitHub 连接
    echo ""
    echo "测试 GitHub SSH 连接..."
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo -e "${GREEN}✅ GitHub SSH 连接成功${NC}"
    else
        echo -e "${YELLOW}⚠️  SSH 连接测试失败，但密钥存在${NC}"
        echo "  可能是首次连接，请手动验证："
        echo "  ${GREEN}ssh -T git@github.com${NC}"
    fi
else
    echo -e "${RED}❌ SSH 密钥不存在${NC}"
    echo ""
    echo "需要生成新的 SSH 密钥："
    echo ""
    echo "  1️⃣ 生成密钥："
    echo "     ${GREEN}ssh-keygen -t ed25519 -C \"alanlyu914@gmail.com\" -f ~/.ssh/id_ed25519 -N \"\"${NC}"
    echo ""
    echo "  2️⃣ 添加到 GitHub："
    echo "     - 复制公钥: ${GREEN}cat ~/.ssh/id_ed25519.pub${NC}"
    echo "     - 访问: https://github.com/settings/ssh/new"
    echo "     - 粘贴公钥，标题填写: macOS备份电脑"
    echo ""
    echo "  3️⃣ 验证连接："
    echo "     ${GREEN}ssh -T git@github.com${NC}"
fi

echo ""
echo "───────────────────────────────────────────────────"
echo ""

# ============================================
# 3. 配置主仓库（如果不存在）
# ============================================
echo -e "${BLUE}📦 配置主仓库...${NC}"
echo ""

MAIN_REPO="$HOME/macos-backuprestore"
GITHUB_REPO="git@github.com:alanlyu914-tech/macos-backuprestore.git"

if [ -d "$MAIN_REPO" ]; then
    echo "主仓库目录存在: $MAIN_REPO"

    cd "$MAIN_REPO" 2>/dev/null

    if [ $? -eq 0 ]; then
        # 检查是否已有远程仓库
        if git remote get-url origin &>/dev/null; then
            REMOTE_URL=$(git remote get-url origin)
            echo "  远程仓库: $REMOTE_URL"
            echo -e "${GREEN}✅ 主仓库已配置${NC}"
        else
            echo "  添加 GitHub 远程仓库..."
            git remote add origin "$GITHUB_REPO"
            echo -e "${GREEN}✅ 远程仓库已添加${NC}"
        fi
    fi
else
    echo "主仓库目录不存在"
    echo ""
    echo "如需克隆主仓库："
    echo "  ${GREEN}git clone $GITHUB_REPO ~/macos-backuprestore${NC}"
fi

echo ""
echo "───────────────────────────────────────────────────"
echo ""

# ============================================
# 4. 显示配置摘要
# ============================================
echo "=========================================="
echo "📋 GitHub 配置摘要"
echo "=========================================="
echo ""
echo "👤 用户信息:"
echo "  名称: $GIT_NAME"
echo "  邮箱: $GIT_EMAIL"
echo "  GitHub: @alanlyu914-tech"
echo ""
echo "🔑 SSH 状态:"
if [ -f "$SSH_KEY" ]; then
    echo "  ✅ 密钥已配置"
else
    echo "  ⚠️  需要生成密钥"
fi
echo ""
echo "📦 主仓库:"
echo "  https://github.com/alanlyu914-tech/macos-backuprestore"
echo ""
echo "=========================================="
echo ""
echo -e "${GREEN}✅ GitHub 配置恢复完成！${NC}"
echo ""
echo "📖 查看详细文档: docs/GitHub配置说明.md"
echo ""
echo "🚀 现在可以："
echo "  1. ${GREEN}cd ~/macos-backuprestore${NC}"
echo "  2. ${GREEN}git pull origin main${NC}"
echo "  3. 开始你的工作！"
echo ""
