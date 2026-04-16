#!/bin/bash
# ============================================
# 简化的扫描脚本
# 只输出变量定义，不包含其他内容
# ============================================

# 扫描应用
brew_count=$(brew list 2>/dev/null | wc -l | tr -d ' ')
echo "BREW_APPS_COUNT=$brew_count"

cask_count=$(brew list --cask 2>/dev/null | wc -l | tr -d ' ')
echo "CASK_APPS_COUNT=$cask_count"

all_count=$(ls /Applications 2>/dev/null | wc -l | tr -d ' ')
echo "OTHER_APPS_COUNT=$((all_count - cask_count))"

# 扫描开发环境
echo "PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}' || echo '未安装')"
echo "NODE_VERSION=$(node --version 2>&1 || echo '未安装')"

# 扫描代码项目（简化版）
python_count=$(find ~/Documents -name "requirements.txt" 2>/dev/null | wc -l | tr -d ' ')
node_count=$(find ~/Documents -name "package.json" 2>/dev/null | wc -l | tr -d ' ')
echo "PYTHON_PROJECTS=$python_count"
echo "NODEJS_PROJECTS=$node_count"
echo "PROJECTS_COUNT=$((python_count + node_count))"

# 估算代码大小
if [ -d ~/Documents/AI\ build ]; then
    size=$(du -sm ~/Documents/AI\ build 2>/dev/null | cut -f1)
else
    size=0
fi
echo "PROJECTS_SIZE=$size"

# 扫描配置文件
config_count=0
[ -f ~/.zshrc ] && ((config_count++))
[ -f ~/.gitconfig ] && ((config_count++))
[ -d ~/.ssh ] && ((config_count++))
[ -d ~/.claude ] && ((config_count++))
echo "CONFIGS_COUNT=$config_count"

# SSH 密钥
ssh_count=$(find ~/.ssh -name "id_*" -type f ! -name "*.pub" 2>/dev/null | wc -l | tr -d ' ')
echo "SSH_KEY_FOUND=$([ "$ssh_count" -gt 0 ] && echo true || echo false)"

# 扫描个人文件
echo "DOCUMENTS_SIZE=$(du -sh ~/Documents 2>/dev/null | cut -f1 || echo '0M')"
echo "PICTURES_SIZE=$(du -sh ~/Pictures 2>/dev/null | cut -f1 || echo '0M')"
echo "MOVIES_SIZE=$(du -sh ~/Movies 2>/dev/null | cut -f1 || echo '0M')"
echo "DESKTOP_SIZE=$(du -sh ~/Desktop 2>/dev/null | cut -f1 || echo '0M')"

# 扫描特殊应用
special_count=0
pgrep -x "WeChat" > /dev/null && ((special_count++))
[ -d "/Applications/Lark.app" ] && ((special_count++))
echo "SPECIAL_COUNT=$special_count"
