#!/bin/bash
# ============================================
# AI 项目验证脚本
# 在新电脑上运行此脚本验证所有项目是否配置正确
# ============================================

PROJECTS_DIR="$HOME/Documents/AI build"
BACKUP_DIR="$HOME/migration-backup"

echo "=========================================="
echo "🔍 开始验证 AI 项目配置..."
echo "=========================================="

# 检查项目目录是否存在
if [ ! -d "$PROJECTS_DIR" ]; then
    echo "❌ 错误：找不到项目目录 $PROJECTS_DIR"
    echo "请先复制 ~/Documents/AI build 到新电脑"
    exit 1
fi

# 统计信息
total_projects=0
passed_projects=0
failed_projects=0
skipped_projects=0

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================
# 1. 检查系统依赖
# ============================================
echo -e "\n📦 检查系统依赖..."

check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 已安装"
        return 0
    else
        echo -e "${RED}✗${NC} $1 未安装"
        return 1
    fi
}

check_command "ffmpeg" || echo "  安装: brew install ffmpeg"
check_command "convert" || echo "  安装: brew install imagemagick"
check_command "python3" || echo "  安装: 从 python.org 下载"
check_command "npm" || echo "  安装: brew install node"
check_command "git" || echo "  安装: brew install git"

# ============================================
# 2. 检查 Python 环境
# ============================================
echo -e "\n🐍 检查 Python 环境..."

python3_version=$(python3 --version 2>&1 | awk '{print $2}')
echo "Python 版本: $python3_version"

if command -v pip3 &> /dev/null; then
    echo -e "${GREEN}✓${NC} pip3 已安装"
else
    echo -e "${RED}✗${NC} pip3 未安装"
fi

# ============================================
# 3. 检查每个项目
# ============================================
echo -e "\n📋 检查项目配置..."

# 创建临时文件记录结果
PASSED_FILE=$(mktemp)
FAILED_FILE=$(mktemp)
SKIPPED_FILE=$(mktemp)

check_project() {
    local project_dir="$1"
    local project_name=$(basename "$project_dir")
    ((total_projects++))

    echo -e "\n🔍 检查项目: $project_name"

    # 检查是否是目录
    if [ ! -d "$project_dir" ]; then
        echo -e "  ${YELLOW}⚠${NC}  不是目录，跳过"
        echo "$project_name" >> "$SKIPPED_FILE"
        ((skipped_projects++))
        return
    fi

    local project_passed=true
    local errors=""

    # 检查 Python 项目
    if [ -f "$project_dir/requirements.txt" ]; then
        echo "  类型: Python 项目"

        # 检查是否有虚拟环境
        if [ -d "$project_dir/venv" ]; then
            echo -e "    ${GREEN}✓${NC} 虚拟环境存在"
        elif [ -d "$project_dir/.venv" ]; then
            echo -e "    ${GREEN}✓${NC} 虚拟环境存在 (.venv)"
        else
            echo -e "    ${YELLOW}⚠${NC}  未找到虚拟环境（建议创建）"
        fi

        # 检查主要 Python 文件
        main_py=$(find "$project_dir" -maxdepth 1 -name "main.py" -o -name "app.py" -o -name "run.py" | head -1)
        if [ -n "$main_py" ]; then
            echo -e "    ${GREEN}✓${NC} 找到入口文件: $(basename $main_py)"
        else
            echo -e "    ${YELLOW}⚠${NC}  未找到入口文件 (main.py/app.py/run.py)"
        fi

        # 检查 .env 文件
        if [ -f "$project_dir/.env" ]; then
            echo -e "    ${GREEN}✓${NC} 环境变量文件存在"
        elif [ -f "$project_dir/.env.example" ]; then
            echo -e "    ${YELLOW}⚠${NC}  找到 .env.example 但没有 .env（需要配置）"
            project_passed=false
            errors="$errors\n    - 缺少 .env 文件"
        fi

        # 尝试导入主要依赖（快速检查）
        echo "    检查依赖安装情况..."
        while read -r line; do
            # 跳过注释和空行
            [[ "$line" =~ ^#.*$ ]] && continue
            [[ -z "$line" ]] && continue

            # 提取包名
            package=$(echo "$line" | cut -d'=' -f1 | cut -d'>' -f1 | cut -d'<' -f1 | xargs)

            if [ -n "$package" ]; then
                if python3 -c "import $package" 2>/dev/null; then
                    echo -e "      ${GREEN}✓${NC} $package"
                else
                    echo -e "      ${RED}✗${NC} $package 未安装"
                    project_passed=false
                    errors="$errors\n    - 缺少依赖: $package"
                fi
            fi
        done < "$project_dir/requirements.txt"
    fi

    # 检查 Node.js 项目
    if [ -f "$project_dir/package.json" ]; then
        echo "  类型: Node.js 项目"

        # 检查 node_modules
        if [ -d "$project_dir/node_modules" ]; then
            echo -e "    ${GREEN}✓${NC} 依赖已安装 (node_modules 存在)"
        else
            echo -e "    ${RED}✗${NC} 依赖未安装 (需要运行 npm install)"
            project_passed=false
            errors="$errors\n    - 缺少 node_modules"
        fi

        # 检查 .env 文件
        if [ -f "$project_dir/.env" ]; then
            echo -e "    ${GREEN}✓${NC} 环境变量文件存在"
        elif [ -f "$project_dir/.env.example" ]; then
            echo -e "    ${YELLOW}⚠${NC}  找到 .env.example 但没有 .env（需要配置）"
            project_passed=false
            errors="$errors\n    - 缺少 .env 文件"
        fi
    fi

    # 记录结果
    if [ "$project_passed" = true ]; then
        echo -e "  ${GREEN}✓${NC} 项目配置正常"
        echo "$project_name" >> "$PASSED_FILE"
        ((passed_projects++))
    else
        echo -e "  ${RED}✗${NC} 项目配置存在问题$errors"
        echo "$project_name" >> "$FAILED_FILE"
        ((failed_projects++))
    fi
}

# 遍历所有项目
for project_dir in "$PROJECTS_DIR"/*; do
    if [ -d "$project_dir" ]; then
        check_project "$project_dir"
    fi
done

# ============================================
# 4. 显示总结
# ============================================
echo -e "\n=========================================="
echo "📊 验证结果总结"
echo "=========================================="
echo "总项目数: $total_projects"
echo -e "${GREEN}通过: $passed_projects${NC}"
echo -e "${RED}失败: $failed_projects${NC}"
echo -e "${YELLOW}跳过: $skipped_projects${NC}"

if [ $passed_projects -gt 0 ]; then
    echo -e "\n${GREEN}✓ 通过的项目:${NC}"
    cat "$PASSED_FILE" | while read name; do
        echo "  - $name"
    done
fi

if [ $failed_projects -gt 0 ]; then
    echo -e "\n${RED}✗ 失败的项目:${NC}"
    cat "$FAILED_FILE" | while read name; do
        echo "  - $name"
    done

    echo -e "\n💡 修复建议:"
    echo "  1. 运行项目依赖恢复: cd ~/migration-backup/scripts && ./restore-projects.sh"
    echo "  2. 手动安装缺失依赖: cd 项目目录 && pip3 install -r requirements.txt"
    echo "  3. 配置环境变量: cp .env.example .env（然后编辑 .env 文件）"
fi

# 清理临时文件
rm -f "$PASSED_FILE" "$FAILED_FILE" "$SKIPPED_FILE"

# ============================================
# 5. 下一步建议
# ============================================
echo -e "\n=========================================="
echo "💡 下一步建议"
echo "=========================================="

if [ $failed_projects -eq 0 ]; then
    echo -e "${GREEN}🎉 太棒了！所有项目配置都正常！${NC}"
    echo ""
    echo "现在可以开始测试项目功能："
    echo "  cd ~/Documents/AI\ build/项目名"
    echo "  python3 main.py  # 或 npm start"
else
    echo -e "${YELLOW}⚠️  有些项目需要修复${NC}"
    echo ""
    echo "快速修复命令："
    echo "  1. 重新安装依赖:"
    echo "     cd ~/migration-backup/scripts && ./restore-projects.sh"
    echo ""
    echo "  2. 手动修复单个项目:"
    echo "     cd ~/Documents/AI\ build/项目名"
    echo "     pip3 install -r requirements.txt"
    echo "     cp .env.example .env  # 然后编辑配置"
fi

echo ""
echo "查看详细日志: ~/migration-backup/projects/backup.log"
