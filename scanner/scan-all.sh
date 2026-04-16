#!/bin/bash
# ============================================
# 主扫描脚本
# 扫描整个电脑并生成扫描报告
# ============================================

SCANNER_DIR="$(dirname "$0")"
BACKUP_DIR="$(dirname "$SCANNER_DIR")"

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "=========================================="
echo "🔍 正在扫描你的电脑..."
echo "=========================================="
echo ""
echo "这可能需要几分钟，请稍候..."
echo ""

# 创建扫描结果文件
SCAN_RESULT="$BACKUP_DIR/scan-result.txt"

# 直接运行各个扫描脚本并捕获输出
echo "⏳ 扫描应用软件..."
bash "$SCANNER_DIR/scan-apps.sh" 2>/dev/null > "$SCAN_RESULT.apps"
source "$SCAN_RESULT.apps"
echo "✅ 发现 $BREW_APPS_COUNT 个工具，$CASK_APPS_COUNT 个应用"

echo "⏳ 扫描开发环境..."
bash "$SCANNER_DIR/scan-dev-env.sh" 2>/dev/null > "$SCAN_RESULT.dev"
source "$SCAN_RESULT.dev"
echo "✅ Python $PYTHON_VERSION，Node $NODE_VERSION"

echo "⏳ 扫描代码项目..."
bash "$SCANNER_DIR/scan-projects.sh" 2>/dev/null > "$SCAN_RESULT.projects"
source "$SCAN_RESULT.projects"
echo "✅ 发现 $PROJECTS_COUNT 个项目（${PROJECTS_SIZE}MB）"

echo "⏳ 扫描配置文件..."
bash "$SCANNER_DIR/scan-configs.sh" 2>/dev/null > "$SCAN_RESULT.configs"
source "$SCAN_RESULT.configs"
echo "✅ 发现 $CONFIGS_COUNT 个配置"

echo "⏳ 扫描个人文件..."
bash "$SCANNER_DIR/scan-files.sh" 2>/dev/null > "$SCAN_RESULT.files"
source "$SCAN_RESULT.files"
echo "✅ 已扫描常见文件夹"

echo "⏳ 扫描特殊应用..."
bash "$SCANNER_DIR/scan-special.sh" 2>/dev/null > "$SCAN_RESULT.special"
source "$SCAN_RESULT.special"
echo "✅ 发现 $SPECIAL_COUNT 个特殊应用"

echo ""
echo "=========================================="
echo -e "${GREEN}✅ 扫描完成！${NC}"
echo "=========================================="

# 合并所有扫描结果
cat "$SCAN_RESULT.apps" > "$SCAN_RESULT"
cat "$SCAN_RESULT.dev" >> "$SCAN_RESULT"
cat "$SCAN_RESULT.projects" >> "$SCAN_RESULT"
cat "$SCAN_RESULT.configs" >> "$SCAN_RESULT"
cat "$SCAN_RESULT.files" >> "$SCAN_RESULT"
cat "$SCAN_RESULT.special" >> "$SCAN_RESULT"

# 清理临时文件
rm -f "$SCAN_RESULT.apps" "$SCAN_RESULT.dev" "$SCAN_RESULT.projects" "$SCAN_RESULT.configs" "$SCAN_RESULT.files" "$SCAN_RESULT.special"

echo ""
echo "💡 即将进入交互式选择界面..."
sleep 1
