#!/bin/bash
# ============================================
# 快速复制 .env 文件脚本
# 用于在新电脑上快速恢复环境变量配置
# ============================================

BACKUP_DIR="$HOME/migration-backup"
PROJECTS_DIR="$HOME/Documents/AI build"

echo "=========================================="
echo "📋 快速复制 .env 文件"
echo "=========================================="

# 检查备份目录
if [ ! -d "$BACKUP_DIR/projects/env-files" ]; then
    echo "❌ 错误：找不到环境变量备份目录"
    echo "请先运行 backup.sh 备份项目配置"
    exit 1
fi

# 检查项目目录
if [ ! -d "$PROJECTS_DIR" ]; then
    echo "❌ 错误：找不到项目目录 $PROJECTS_DIR"
    echo "请先复制 AI build 文件夹到新电脑"
    exit 1
fi

echo -e "\n📁 可用的环境变量文件："
ls -1 "$BACKUP_DIR/projects/env-files/"

echo -e "\n🔄 开始复制..."

success_count=0
failed_count=0

# 遍历所有 .env 备份文件
for env_backup in "$BACKUP_DIR/projects/env-files"/*.env; do
    if [ -f "$env_backup" ]; then
        filename=$(basename "$env_backup")

        # 提取项目名称（去掉 .env 后缀）
        project_name="${filename%.env}"

        # 确定目标路径
        if [ "$project_name" = "image-auto-produce" ]; then
            # 处理带空格的项目名
            target_dir="$PROJECTS_DIR/image-auto- produce"
        else
            target_dir="$PROJECTS_DIR/$project_name"
        fi

        # 检查目标目录是否存在
        if [ -d "$target_dir" ]; then
            # 复制文件
            cp "$env_backup" "$target_dir/.env"
            if [ $? -eq 0 ]; then
                echo "  ✓ $project_name → .env"
                ((success_count++))
            else
                echo "  ✗ $project_name 复制失败"
                ((failed_count++))
            fi
        else
            echo "  ⚠️  $project_name（目标目录不存在：$target_dir）"
            ((failed_count++))
        fi
    fi
done

echo -e "\n=========================================="
if [ $success_count -gt 0 ]; then
    echo "✅ 成功复制 $success_count 个 .env 文件"
else
    echo "❌ 没有成功复制任何文件"
fi

if [ $failed_count -gt 0 ]; then
    echo "⚠️  $failed_count 个文件复制失败"
fi
echo "=========================================="

if [ $success_count -gt 0 ]; then
    echo -e "\n💡 接下来："
    echo "  1. 验证配置: cd ~/migration-backup/scripts && ./verify-projects.sh"
    echo "  2. 测试项目: cd ~/Documents/AI\ build/项目名 && python3 main.py"
fi
