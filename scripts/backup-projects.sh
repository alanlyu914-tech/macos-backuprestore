#!/bin/bash
# ============================================
# AI 项目依赖备份脚本
# 备份所有项目的依赖文件和环境变量
# ============================================

BACKUP_DIR="$HOME/migration-backup"
PROJECTS_DIR="$HOME/Documents/AI build"
PROJECTS_BACKUP="$BACKUP_DIR/projects"

echo "=========================================="
echo "📦 开始备份 AI 项目依赖..."
echo "=========================================="

# 创建项目备份目录
mkdir -p "$PROJECTS_BACKUP"

# ============================================
# 1. 扫描所有 Python 项目的依赖
# ============================================
echo -e "\n🔍 扫描 Python 项目..."

PYTHON_REQUIREMENTS="$PROJECTS_BACKUP/python-requirements.txt"
echo "# Python 项目依赖列表 - $(date)" > "$PYTHON_REQUIREMENTS"
echo "# 使用此命令批量安装: pip3 install -r $PYTHON_REQUIREMENTS" >> "$PYTHON_REQUIREMENTS"

find "$PROJECTS_DIR" -name "requirements.txt" -type f | while read req_file; do
    project_dir=$(dirname "$req_file")
    project_name=$(basename "$project_dir")

    echo "  找到: $project_name" | tee -a "$PROJECTS_BACKUP/backup.log"
    echo "" >> "$PYTHON_REQUIREMENTS"
    echo "# === $project_name ===" >> "$PYTHON_REQUIREMENTS"
    echo "# 路径: $project_dir" >> "$PYTHON_REQUIREMENTS"
    cat "$req_file" >> "$PYTHON_REQUIREMENTS"
done

echo "✅ Python 依赖已保存到: $PYTHON_REQUIREMENTS" | tee -a "$PROJECTS_BACKUP/backup.log"

# ============================================
# 2. 扫描所有 Node.js 项目的依赖
# ============================================
echo -e "\n🔍 扫描 Node.js 项目..."

NODE_PACKAGES="$PROJECTS_BACKUP/node-packages.txt"
echo "# Node.js 项目依赖列表 - $(date)" > "$NODE_PACKAGES"

find "$PROJECTS_DIR" -name "package.json" -type f | while read pkg_file; do
    project_dir=$(dirname "$pkg_file")
    project_name=$(basename "$project_dir")

    echo "  找到: $project_name" | tee -a "$PROJECTS_BACKUP/backup.log"
    echo "" >> "$NODE_PACKAGES"
    echo "# === $project_name ===" >> "$NODE_PACKAGES"
    echo "# 路径: $project_dir" >> "$NODE_PACKAGES"
    echo "# 安装命令: cd '$project_dir' && npm install" >> "$NODE_PACKAGES"
done

echo "✅ Node.js 项目已记录到: $NODE_PACKAGES" | tee -a "$PROJECTS_BACKUP/backup.log"

# ============================================
# 3. 备份环境变量文件（重要！）
# ============================================
echo -e "\n🔍 备份环境变量文件..."

ENV_BACKUP="$PROJECTS_BACKUP/env-files"
mkdir -p "$ENV_BACKUP"

find "$PROJECTS_DIR" -name ".env" -type f | while read env_file; do
    project_name=$(basename "$(dirname "$env_file")")
    echo "  备份: $project_name/.env" | tee -a "$PROJECTS_BACKUP/backup.log"
    cp "$env_file" "$ENV_BACKUP/$project_name.env"
done

# 同时备份 .env.example 文件
find "$PROJECTS_DIR" -name ".env.example" -type f | while read env_example; do
    project_name=$(basename "$(dirname "$env_example")")
    echo "  备份: $project_name/.env.example" | tee -a "$PROJECTS_BACKUP/backup.log"
    cp "$env_example" "$ENV_BACKUP/$project_name.env.example"
done

if [ -d "$ENV_BACKUP" ] && [ "$(ls -A $ENV_BACKUP)" ]; then
    echo "✅ 环境变量文件已保存到: $ENV_BACKUP" | tee -a "$PROJECTS_BACKUP/backup.log"
    echo "  ⚠️  注意：.env 文件包含敏感信息，请妥善保管！" | tee -a "$PROJECTS_BACKUP/backup.log"
else
    echo "ℹ️  未找到 .env 文件" | tee -a "$PROJECTS_BACKUP/backup.log"
fi

# ============================================
# 4. 记录项目列表
# ============================================
echo -e "\n📋 记录项目列表..."

PROJECTS_LIST="$PROJECTS_BACKUP/projects-list.txt"
echo "# AI 项目列表 - $(date)" > "$PROJECTS_LIST"
echo "# 项目根目录: $PROJECTS_DIR" >> "$PROJECTS_LIST"
echo "" >> "$PROJECTS_LIST"

ls -1 "$PROJECTS_DIR" | while read project; do
    project_path="$PROJECTS_DIR/$project"
    if [ -d "$project_path" ]; then
        # 检测项目类型
        if [ -f "$project_path/requirements.txt" ]; then
            type="Python"
        elif [ -f "$project_path/package.json" ]; then
            type="Node.js"
        elif [ -f "$project_path/go.mod" ]; then
            type="Go"
        else
            type="未知"
        fi

        echo "- $project ($type)" >> "$PROJECTS_LIST"
    fi
done

echo "✅ 项目列表已保存到: $PROJECTS_LIST" | tee -a "$PROJECTS_BACKUP/backup.log"

# ============================================
# 5. 记录系统依赖
# ============================================
echo -e "\n🔍 记录系统依赖..."

SYSTEM_DEPS="$PROJECTS_BACKUP/system-dependencies.txt"
cat > "$SYSTEM_DEPS" << 'EOF'
# 系统依赖安装指南

## FFmpeg（视频处理）
brew install ffmpeg

## ImageMagick（图像处理）
brew install imagemagick

## Pillow 依赖（Python 图像库）
brew install libtiff libjpeg webp little-cms

## 其他可能需要的工具
# brew install youtube-dl  # 视频下载
# brew install ghostscript  # PDF 处理
# brew install poppler      # PDF 处理
EOF

echo "✅ 系统依赖说明已保存到: $SYSTEM_DEPS" | tee -a "$PROJECTS_BACKUP/backup.log"

# ============================================
# 6. 生成项目恢复脚本
# ============================================
echo -e "\n📝 生成项目恢复脚本..."

cat > "$PROJECTS_BACKUP/../scripts/restore-projects.sh" << 'EOFSCRIPT'
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
EOFSCRIPT

chmod +x "$PROJECTS_BACKUP/../scripts/restore-projects.sh"

echo "✅ 项目恢复脚本已生成" | tee -a "$PROJECTS_BACKUP/backup.log"

# ============================================
# 完成
# ============================================
echo -e "\n==========================================" | tee -a "$PROJECTS_BACKUP/backup.log"
echo "✅ AI 项目依赖备份完成！" | tee -a "$PROJECTS_BACKUP/backup.log"
echo "==========================================" | tee -a "$PROJECTS_BACKUP/backup.log"

echo -e "\n📊 备份摘要：" | tee -a "$PROJECTS_BACKUP/backup.log"
echo "  Python 项目依赖: $(grep -c "===" "$PYTHON_REQUIREMENTS" 2>/dev/null || echo 0) 个" | tee -a "$PROJECTS_BACKUP/backup.log"
echo "  Node.js 项目: $(grep -c "===" "$NODE_PACKAGES" 2>/dev/null || echo 0) 个" | tee -a "$PROJECTS_BACKUP/backup.log"
echo "  环境变量文件: $(ls -1 "$ENV_BACKUP" 2>/dev/null | wc -l | tr -d ' ') 个" | tee -a "$PROJECTS_BACKUP/backup.log"

echo -e "\n💡 在新电脑上，运行恢复脚本：" | tee -a "$PROJECTS_BACKUP/backup.log"
echo "   cd ~/migration-backup/scripts && ./restore-projects.sh" | tee -a "$PROJECTS_BACKUP/backup.log"

echo -e "\n⚠️  重要提醒：" | tee -a "$PROJECTS_BACKUP/backup.log"
echo "   1. 请将 ~/Documents/AI build 复制到外置硬盘" | tee -a "$PROJECTS_BACKUP/backup.log"
echo "   2. .env 文件包含 API 密钥，请妥善保管" | tee -a "$PROJECTS_BACKUP/backup.log"
echo "   3. 在新电脑上需要先复制项目文件夹，再运行恢复脚本" | tee -a "$PROJECTS_BACKUP/backup.log"
