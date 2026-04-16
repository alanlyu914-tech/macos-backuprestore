#!/bin/bash
# ============================================
# AI 项目依赖恢复脚本
# 在新电脑上运行此脚本恢复所有项目依赖
# ============================================

BACKUP_DIR="$HOME/migration-backup"
PROJECTS_DIR="$HOME/Documents/AI build"
PROJECTS_BACKUP="$BACKUP_DIR/projects"

echo "=========================================="
echo "🔄 开始恢复 AI 项目依赖..."
echo "=========================================="

# 检查项目目录是否存在
if [ ! -d "$PROJECTS_DIR" ]; then
    echo "❌ 错误：找不到项目目录 $PROJECTS_DIR"
    echo "请先复制 ~/Documents/AI build 到新电脑"
    exit 1
fi

# ============================================
# 1. 安装系统依赖
# ============================================
echo -e "\n📦 安装系统依赖..."

if command -v brew &> /dev/null; then
    echo "安装 FFmpeg..."
    brew install ffmpeg 2>/dev/null && echo "  ✓ FFmpeg 安装成功" || echo "  ⚠️  FFmpeg 安装失败"

    echo "安装 ImageMagick..."
    brew install imagemagick 2>/dev/null && echo "  ✓ ImageMagick 安装成功" || echo "  ⚠️  ImageMagick 安装失败"

    echo "安装 Pillow 依赖..."
    brew install libtiff libjpeg webp little-cms 2>/dev/null && echo "  ✓ 图像库安装成功" || echo "  ⚠️  图像库安装失败"
else
    echo "⚠️  Homebrew 未安装，请先安装 Homebrew"
fi

# ============================================
# 2. 恢复 Python 依赖
# ============================================
echo -e "\n📦 恢复 Python 项目依赖..."

PYTHON_REQUIREMENTS="$PROJECTS_BACKUP/python-requirements.txt"

if [ -f "$PYTHON_REQUIREMENTS" ]; then
    echo "正在批量安装 Python 依赖..."
    echo "这可能需要几分钟，请耐心等待..."

    # 创建虚拟环境并安装（推荐）
    # pip3 install -r "$PYTHON_REQUIREMENTS" 2>&1 | grep -E "(Successfully|ERROR|Requirement already satisfied)"

    # 或者逐个项目安装（更安全）
    find "$PROJECTS_DIR" -name "requirements.txt" -type f | while read req_file; do
        project_dir=$(dirname "$req_file")
        project_name=$(basename "$project_dir")

        echo "  安装 $project_name 依赖..."
        cd "$project_dir" 2>/dev/null

        # 检查是否有虚拟环境
        if [ -f "venv/bin/activate" ]; then
            source venv/bin/activate
            pip install -r requirements.txt 2>/dev/null && echo "    ✓ $project_name" || echo "    ✗ $project_name 失败"
            deactivate
        elif [ -f ".venv/bin/activate" ]; then
            source .venv/bin/activate
            pip install -r requirements.txt 2>/dev/null && echo "    ✓ $project_name" || echo "    ✗ $project_name 失败"
            deactivate
        else
            # 使用系统 Python
            pip3 install -r requirements.txt 2>/dev/null && echo "    ✓ $project_name" || echo "    ✗ $project_name 失败"
        fi
    done

    echo "✅ Python 依赖安装完成"
else
    echo "⚠️  未找到 Python 依赖文件"
fi

# ============================================
# 3. 恢复 Node.js 依赖
# ============================================
echo -e "\n📦 恢复 Node.js 项目依赖..."

find "$PROJECTS_DIR" -name "package.json" -type f | while read pkg_file; do
    project_dir=$(dirname "$pkg_file")
    project_name=$(basename "$project_dir")

    echo "  安装 $project_name 依赖..."
    cd "$project_dir" 2>/dev/null

    if [ -f "package.json" ]; then
        npm install 2>/dev/null && echo "    ✓ $project_name" || echo "    ✗ $project_name 失败"
    fi
done

echo "✅ Node.js 依赖安装完成"

# ============================================
# 4. 恢复环境变量文件
# ============================================
echo -e "\n📦 恢复环境变量文件..."

ENV_BACKUP="$PROJECTS_BACKUP/env-files"

if [ -d "$ENV_BACKUP" ] && [ "$(ls -A $ENV_BACKUP 2>/dev/null)" ]; then
    for env_file in "$ENV_BACKUP"/*.env; do
        if [ -f "$env_file" ]; then
            filename=$(basename "$env_file")
            project_name=${filename%.env}

            # 找到对应的项目目录
            target_dir="$PROJECTS_DIR/$project_name"

            if [ -d "$target_dir" ]; then
                echo "  恢复 $project_name/.env"
                cp "$env_file" "$target_dir/.env"
                echo "    ✓ $project_name"
            else
                echo "  ⚠️  找不到项目: $project_name"
            fi
        fi
    done

    echo "✅ 环境变量文件恢复完成"
else
    echo "ℹ️  未找到环境变量备份文件"
fi

# ============================================
# 完成
# ============================================
echo -e "\n=========================================="
echo "✅ 项目依赖恢复完成！"
echo "=========================================="

echo -e "\n💡 接下来："
echo "  1. 检查每个项目是否能正常运行"
echo "  2. 运行项目测试：cd ~/Documents/AI\ build/项目名 && python3 main.py"
echo "  3. 如果遇到问题，检查 $PROJECTS_BACKUP/ 目录"
echo -e "\n📋 项目列表："
ls -1 "$PROJECTS_DIR" | head -10
