#!/bin/bash
# ============================================
# 一键安装所有 GUI 应用
# 在新电脑上运行此脚本安装所有应用
# ============================================

echo "=========================================="
echo "🚀 开始安装所有 GUI 应用..."
echo "=========================================="

# 检查 Homebrew 是否已安装
if ! command -v brew &> /dev/null; then
    echo "❌ 错误：Homebrew 未安装"
    echo "请先安装 Homebrew："
    echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    exit 1
fi

# 更新 Homebrew
echo -e "\n📦 更新 Homebrew..."
brew update

# ============================================
# 可以通过 Homebrew 安装的应用
# ============================================

echo -e "\n=========================================="
echo "📦 安装通过 Homebrew 管理的应用"
echo "=========================================="

# 定义应用列表（cask 名称 : 中文名称）
declare -A apps=(
    ["google-chrome"]="Google Chrome 浏览器"
    ["wechat"]="微信"
    ["cursor"]="Cursor 编辑器"
    ["tencent-meeting"]="腾讯会议"
    ["audacity"]="Audacity 音频编辑"
    ["baidunetdisk"]="百度网盘"
    ["lark"]="飞书"
    ["pastenow"]="PasteNow 剪贴板管理"
    ["sunloginclient"]="向日葵远程控制"
    ["wpsoffice"]="WPS Office"
    ["cleanmymac"]="CleanMyMac 清理工具"
    ["permute"]="Permute 视频转换"
    ["screen-studio"]="ScreenStudio 录屏工具"
    ["videofusion"]="万兴优转"
    ["xlplayer"]="迅雷播放器"
)

# 计数器
total_apps=${#apps[@]}
installed_apps=0
failed_apps=0

echo "准备安装 $total_apps 个应用..."
echo ""

# 遍历应用列表
for cask_name in "${!apps[@]}"; do
    app_name="${apps[$cask_name]}"

    echo "🔍 检查 $app_name ($cask_name)..."

    # 检查应用是否已安装
    if brew list --cask "$cask_name" &> /dev/null; then
        echo "  ✅ $app_name 已安装，跳过"
        ((installed_apps++))
        continue
    fi

    # 尝试安装应用
    echo "  📦 正在安装 $app_name..."
    if brew install --cask "$cask_name" 2>/dev/null; then
        echo "  ✅ $app_name 安装成功"
        ((installed_apps++))
    else
        echo "  ⚠️  $app_name 安装失败（可能需要手动安装）"
        ((failed_apps++))
    fi

    echo ""
done

# ============================================
# 特殊应用处理
# ============================================

echo -e "\n=========================================="
echo "📦 安装特殊应用"
echo "=========================================="

# Visual Studio Code
echo "🔍 检查 Visual Studio Code..."
if brew list --cask "visual-studio-code" &> /dev/null; then
    echo "  ✅ Visual Studio Code 已安装"
    ((installed_apps++))
else
    echo "  📦 正在安装 Visual Studio Code..."
    if brew install --cask visual-studio-code 2>/dev/null; then
        echo "  ✅ Visual Studio Code 安装成功"
        ((installed_apps++))
    else
        echo "  ⚠️  Visual Studio Code 安装失败"
        ((failed_apps++))
    fi
fi

echo ""

# Clash Verge (可能需要特殊版本)
echo "🔍 检查 Clash Verge..."
if brew list --cask "clash-verge-rev" &> /dev/null; then
    echo "  ✅ Clash Verge 已安装"
    ((installed_apps++))
else
    echo "  📦 正在安装 Clash Verge..."
    if brew install --cask clash-verge-rev 2>/dev/null; then
        echo "  ✅ Clash Verge 安装成功"
        ((installed_apps++))
    else
        echo "  ⚠️  Clash Verge 安装失败（可能需要从官网下载）"
        ((failed_apps++))
    fi
fi

echo ""

# Warp (检查是否是正确的应用)
echo "🔍 检查 Warp Terminal..."
if brew list --cask "warp" &> /dev/null 2>&1; then
    echo "  ✅ Warp 已安装"
    ((installed_apps++))
else
    echo "  ⚠️  Warp 未在 Homebrew 中找到（请从官网下载：warp.dev）"
    ((failed_apps++))
fi

echo ""

# Python (通过 brew 安装)
echo "🔍 检查 Python..."
if command -v python3 &> /dev/null; then
    echo "  ✅ Python 已安装 ($(python3 --version))"
else
    echo "  📦 正在安装 Python..."
    if brew install python 2>/dev/null; then
        echo "  ✅ Python 安装成功"
        ((installed_apps++))
    else
        echo "  ⚠️  Python 安装失败"
        ((failed_apps++))
    fi
fi

# ============================================
# 安装总结
# ============================================

echo -e "\n=========================================="
echo "📊 安装总结"
echo "=========================================="
echo "总应用数: $((total_apps + 4))"  # +4 是特殊应用
echo "✅ 成功安装: $installed_apps"
if [ $failed_apps -gt 0 ]; then
    echo "⚠️  安装失败/需要手动安装: $failed_apps"
fi

# ============================================
# 需要手动安装的应用列表
# ============================================

echo -e "\n=========================================="
echo "📋 需要手动安装的应用"
echo "=========================================="

cat << 'EOF'
以下应用无法通过 Homebrew 安装，请手动下载：

1. Antigravity Tools
   - 请访问应用官网或 App Store

2. CC Switch
   - 请访问应用官网

3. COCODUCK
   - 请访问应用官网

4. Codex.app
   - 请访问应用官网

5. Dia.app
   - 请访问应用官网

6. LetsVPN
   - 请访问 LetsVPN 官网下载

7. Quark
   - 请访问 quark.cn 下载

8. ZipMasterMac
   - 请访问应用官网

9. cursor-agent.app
   - 如果已安装 Cursor，可能不需要

10. flomo
    - 请访问 flomoapp.com 下载

11. 蚁小二4.0.app
    - 请访问应用官网

12. 迅捷图片转换器
    - 请访问应用官网
EOF

# ============================================
# 下一步建议
# ============================================

echo -e "\n=========================================="
echo "💡 下一步建议"
echo "=========================================="

if [ $failed_apps -eq 0 ]; then
    echo -e "${GREEN}🎉 太棒了！所有应用都已成功安装！${NC}"
    echo ""
    echo "接下来可以："
    echo "  1. 恢复系统配置: cd ~/migration-backup/scripts && ./restore.sh"
    echo "  2. 恢复项目依赖: ./restore-projects.sh"
    echo "  3. 验证项目配置: ./verify-projects.sh"
else
    echo "部分应用需要手动安装，请按照上面的说明下载安装。"
    echo ""
    echo "安装完成后，可以继续："
    echo "  1. 恢复系统配置: cd ~/migration-backup/scripts && ./restore.sh"
    echo "  2. 恢复项目依赖: ./restore-projects.sh"
fi

echo ""
echo "=========================================="
echo "✅ GUI 应用安装完成！"
echo "=========================================="
