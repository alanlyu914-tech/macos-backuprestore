#!/bin/bash
# ============================================
# 扫描开发环境
# ============================================

scan_dev_env() {
    # 1. Python 环境
    if command -v python3 &> /dev/null; then
        python_version=$(python3 --version 2>&1 | awk '{print $2}')
        pip_count=$(pip3 list 2>/dev/null | wc -l | tr -d ' ')
        echo "PYTHON_VERSION=$python_version"
        echo "PIP_PACKAGES_COUNT=$pip_count"
    else
        echo "PYTHON_VERSION=未安装"
        echo "PIP_PACKAGES_COUNT=0"
    fi

    # 2. Node.js 环境
    if command -v node &> /dev/null; then
        node_version=$(node --version 2>&1)
        npm_count=$(npm list -g --depth=0 2>/dev/null | wc -l | tr -d ' ')
        echo "NODE_VERSION=$node_version"
        echo "NPM_PACKAGES_COUNT=$npm_count"
    else
        echo "NODE_VERSION=未安装"
        echo "NPM_PACKAGES_COUNT=0"
    fi

    # 3. Git 环境
    if command -v git &> /dev/null; then
        git_version=$(git --version 2>&1 | awk '{print $3}')
        git_name=$(git config user.name 2>/dev/null)
        if [ -n "$git_name" ]; then
            git_configured="是"
        else
            git_configured="否"
        fi
        echo "GIT_VERSION=$git_version"
        echo "GIT_CONFIGURED=$git_configured"
    else
        echo "GIT_VERSION=未安装"
        echo "GIT_CONFIGURED=否"
    fi

    # 4. Docker 环境
    if command -v docker &> /dev/null; then
        docker_version=$(docker --version 2>&1 | awk '{print $3}' | tr -d ',')
        docker_images=$(docker images 2>/dev/null | wc -l | tr -d ' ')
        echo "DOCKER_VERSION=$docker_version"
        echo "DOCKER_IMAGES=$docker_images"
    else
        echo "DOCKER_VERSION=未安装"
        echo "DOCKER_IMAGES=0"
    fi
}

# 如果直接运行此脚本
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    scan_dev_env
fi
