#!/bin/bash
# ============================================
# 扫描配置文件
# ============================================

scan_configs() {
    # echo "⏳ 扫描配置文件..." >&2

    configs_found=()

    # 1. Shell 配置
    if [ -f "$HOME/.zshrc" ]; then
        configs_found+=("zshrc:Zsh 配置")
    fi
    if [ -f "$HOME/.bashrc" ] || [ -f "$HOME/.bash_profile" ]; then
        configs_found+=("bash:Bash 配置")
    fi

    # 2. Git 配置
    if [ -f "$HOME/.gitconfig" ]; then
        configs_found+=("gitconfig:Git 配置")
    fi

    # 3. SSH 密钥
    ssh_key_found=false
    if [ -d "$HOME/.ssh" ]; then
        ssh_count=$(find "$HOME/.ssh" -name "id_*" -type f ! -name "*.pub" | wc -l | tr -d ' ')
        if [ "$ssh_count" -gt 0 ]; then
            configs_found+=("ssh:SSH 密钥 ($ssh_count 个)")
            ssh_key_found=true
        fi
    fi

    # 4. VS Code 配置
    if [ -f "$HOME/Library/Application Support/Code/User/settings.json" ]; then
        # 检查扩展数量
        if command -v code &> /dev/null; then
            ext_count=$(code --list-extensions 2>/dev/null | wc -l | tr -d ' ')
            configs_found+=("vscode:VS Code 配置 ($ext_count 个扩展)")
        else
            configs_found+=("vscode:VS Code 配置")
        fi
    fi

    # 5. Claude Code 配置
    if [ -d "$HOME/.claude" ]; then
        configs_found+=("claude:Claude Code 配置")
    fi

    # 6. npm 配置
    if [ -f "$HOME/.npmrc" ]; then
        configs_found+=("npm:npm 配置")
    fi

    # 7. Docker 配置
    if [ -d "$HOME/.docker" ]; then
        configs_found+=("docker:Docker 配置")
    fi

    # 输出结果
    echo "CONFIGS_COUNT=${#configs_found[@]}"
    echo "CONFIGS_FOUND=${configs_found[@]}"
    echo "SSH_KEY_FOUND=$ssh_key_found"

    # echo "✅ 配置文件扫描完成" >&2
}

# 如果直接运行此脚本
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    scan_configs
fi
