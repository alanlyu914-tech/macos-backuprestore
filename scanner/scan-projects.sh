#!/bin/bash
# ============================================
# 扫描代码项目
# ============================================

scan_projects() {
    echo "⏳ 扫描代码项目..."

    # 扫描目录
    search_dirs=("$HOME/Documents" "$HOME/Desktop" "$HOME/Projects" "$HOME/code" "$HOME/work")

    total_projects=0
    total_size=0
    python_projects=0
    nodejs_projects=0
    env_files=0
    git_repos=0

    # 查找项目
    for dir in "${search_dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            continue
        fi

        # 查找 Python 项目
        while IFS= read -r project; do
            if [ -d "$project" ]; then
                ((total_projects++))
                ((python_projects++))

                # 检查 .env 文件
                if [ -f "$project/.env" ]; then
                    ((env_files++))
                fi

                # 检查 .git
                if [ -d "$project/.git" ]; then
                    ((git_repos++))
                fi

                # 计算大小
                size=$(du -sm "$project" 2>/dev/null | cut -f1)
                total_size=$((total_size + size))
            fi
        done < <(find "$dir" -name "requirements.txt" -type f -exec dirname {} \; 2>/dev/null)

        # 查找 Node.js 项目
        while IFS= read -r project; do
            if [ -d "$project" ]; then
                # 排除已经计算过的 Python 项目
                if [ ! -f "$project/requirements.txt" ]; then
                    ((total_projects++))
                    ((nodejs_projects++))

                    # 检查 .env 文件
                    if [ -f "$project/.env" ]; then
                        ((env_files++))
                    fi

                    # 检查 .git
                    if [ -d "$project/.git" ]; then
                        ((git_repos++))
                    fi

                    # 计算大小
                    size=$(du -sm "$project" 2>/dev/null | cut -f1)
                    total_size=$((total_size + size))
                fi
            fi
        done < <(find "$dir" -name "package.json" -type f -exec dirname {} \; 2>/dev/null)
    done

    echo "PROJECTS_COUNT=$total_projects"
    echo "PROJECTS_SIZE=$total_size"
    echo "PYTHON_PROJECTS=$python_projects"
    echo "NODEJS_PROJECTS=$nodejs_projects"
    echo "ENV_FILES=$env_files"
    echo "GIT_REPOS=$git_repos"

    # 列出主要项目目录
    echo "PROJECT_DIRS=""
    for dir in "${search_dirs[@]}"; do
        if [ -d "$dir" ]; then
            # 检查是否包含项目
            project_count=$(find "$dir" -maxdepth 2 -name "requirements.txt" -o -name "package.json" 2>/dev/null | wc -l | tr -d ' ')
            if [ "$project_count" -gt 0 ]; then
                project_name=$(basename "$dir")
                dir_size=$(du -sh "$dir" 2>/dev/null | cut -f1)
                echo "PROJECT_DIR_$project_count=$dir ($dir_size)"
            fi
        fi
    done

    echo "✅ 代码项目扫描完成"
}

# 如果直接运行此脚本
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    scan_projects
fi
