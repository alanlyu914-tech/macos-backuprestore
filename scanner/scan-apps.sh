#!/bin/bash
# ============================================
# 扫描应用软件
# ============================================

scan_apps() {
    # 1. Homebrew 命令行工具
    if command -v brew &> /dev/null; then
        brew_count=$(brew list 2>/dev/null | wc -l | tr -d ' ')
        brew_list=$(brew list 2>/dev/null | head -5 | tr '\n' ' ')
        echo "BREW_APPS_COUNT=$brew_count"
        echo "BREW_APPS_SAMPLE=$brew_list"
    else
        echo "BREW_APPS_COUNT=0"
        echo "BREW_APPS_SAMPLE="
    fi

    # 2. Homebrew Cask GUI 应用
    if command -v brew &> /dev/null; then
        cask_count=$(brew list --cask 2>/dev/null | wc -l | tr -d ' ')
        cask_list=$(brew list --cask 2>/dev/null | head -5 | tr '\n' ' ')
        echo "CASK_APPS_COUNT=$cask_count"
        echo "CASK_APPS_SAMPLE=$cask_list"
    else
        echo "CASK_APPS_COUNT=0"
        echo "CASK_APPS_SAMPLE="
    fi

    # 3. 所有 GUI 应用
    all_apps_count=$(ls /Applications 2>/dev/null | wc -l | tr -d ' ')
    cask_count=$(grep "CASK_APPS_COUNT=" "$1" 2>/dev/null | cut -d'=' -f2)
    if [ -z "$cask_count" ]; then
        cask_count=0
    fi
    other_apps_count=$((all_apps_count - cask_count))
    echo "OTHER_APPS_COUNT=$other_apps_count"
}

# 如果直接运行此脚本
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    scan_apps
fi
