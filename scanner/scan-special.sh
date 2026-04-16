#!/bin/bash
# ============================================
# 扫描特殊应用
# ============================================

scan_special() {
    # echo "⏳ 扫描特殊应用..." >&2

    special_found=()

    # 1. 微信
    if pgrep -x "WeChat" > /dev/null; then
        special_found+=("wechat:微信（正在运行）")
    elif [ -d "/Applications/WeChat.app" ]; then
        special_found+=("wechat:微信（已安装）")
    fi

    # 2. 钉钉
    if pgrep -x "DingTalk" > /dev/null || pgrep -x "DingTalkLauncher" > /dev/null; then
        special_found+=("dingtalk:钉钉（正在运行）")
    elif [ -d "/Applications/DingTalk.app" ]; then
        special_found+=("dingtalk:钉钉（已安装）")
    fi

    # 3. 飞书
    if pgrep -x "Lark" > /dev/null; then
        special_found+=("lark:飞书（正在运行）")
    elif [ -d "/Applications/Lark.app" ]; then
        special_found+=("lark:飞书（已安装）")
    fi

    # 4. Adobe 系列
    adobe_count=0
    if [ -d "/Applications/Adobe Photoshop" ] || [ -d "/Applications/Adobe Photoshop 2024" ] || [ -d "/Applications/Adobe Photoshop 2025" ]; then
        ((adobe_count++))
    fi
    if [ -d "/Applications/Adobe Lightroom" ] || [ -d "/Applications/Adobe Lightroom Classic" ]; then
        ((adobe_count++))
    fi
    if [ -d "/Applications/Adobe Premiere Pro" ]; then
        ((adobe_count++))
    fi
    if [ $adobe_count -gt 0 ]; then
        special_found+=("adobe:Adobe 系列 ($adobe_count 个)")
    fi

    # 5. Final Cut Pro
    if [ -d "/Applications/Final Cut Pro.app" ]; then
        special_found+=("finalcut:Final Cut Pro")
    fi

    # 6. Logic Pro
    if [ -d "/Applications/Logic Pro.app" ]; then
        special_found+=("logic:Logic Pro")
    fi

    # 7. 虚拟机
    if [ -d "/Applications/VirtualBox.app" ] || [ -d "/Applications/VMware Fusion.app" ] || [ -d "/Applications/Parallels Desktop.app" ]; then
        special_found+=("vm:虚拟机软件")
    fi

    # 输出结果
    echo "SPECIAL_COUNT=${#special_found[@]}"
    echo "SPECIAL_FOUND=${special_found[@]}"

    # echo "✅ 特殊应用扫描完成" >&2
}

# 如果直接运行此脚本
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    scan_special
fi
