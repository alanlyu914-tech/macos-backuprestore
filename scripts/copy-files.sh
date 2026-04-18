#!/bin/bash
# ============================================
# 📁 文件复制辅助脚本
# ============================================
#
# 用法：
#   ./copy-files.sh backup   - 复制文件到外置硬盘
#   ./copy-files.sh restore  - 从外置硬盘恢复文件
#   ./copy-files.sh list     - 列出可用的外置硬盘
#   ./copy-files.sh verify   - 验证文件完整性
#
# ============================================

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 要复制的目录
DIRS_TO_COPY=(
    "Documents"
    "Pictures"
    "Movies"
    "Desktop"
    "Downloads"
    "Music"
)

# ============================================
# 函数定义
# ============================================

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header() {
    echo ""
    echo "=========================================="
    echo "$1"
    echo "=========================================="
}

# 列出可用的外置硬盘
list_volumes() {
    print_header "📱 可用的外置硬盘"

    local found=false
    for volume in /Volumes/*; do
        if [ -d "$volume" ] && [ "$(dirname "$volume")" = "/Volumes" ]; then
            local name=$(basename "$volume")
            # 排除系统盘
            if [ "$name" != "Macintosh HD" ] && [ "$name" != "MacHD" ] && [[ ! "$name" =~ ^.*\.*$ ]]; then
                print_success "$name"
                echo "  路径: $volume"
                echo "  可用空间: $(df -h "$volume" 2>/dev/null | tail -1 | awk '{print $4}')"
                echo ""
                found=true
            fi
        fi
    done

    if [ "$found" = false ]; then
        print_warning "未找到外置硬盘"
        echo ""
        echo "请插入外置硬盘后重试"
        return 1
    fi
}

# 检查目录大小
check_dir_size() {
    local dir="$1"
    if [ -d "$HOME/$dir" ]; then
        local size=$(du -sh "$HOME/$dir" 2>/dev/null | cut -f1)
        echo "$size"
    else
        echo "不存在"
    fi
}

# 复制到外置硬盘
backup_to_volume() {
    print_header "💾 复制文件到外置硬盘"

    # 列出可用硬盘
    list_volumes
    if [ $? -ne 0 ]; then
        return 1
    fi

    # 选择硬盘
    echo ""
    read -p "请输入外置硬盘名称: " volume_name
    local volume_path="/Volumes/$volume_name"

    if [ ! -d "$volume_path" ]; then
        print_error "找不到硬盘: $volume_name"
        return 1
    fi

    echo ""
    print_success "使用硬盘: $volume_name"

    # 显示将要复制的目录
    echo ""
    echo "将要复制的目录："
    echo "----------------------------------------"
    local total_size=0
    for dir in "${DIRS_TO_COPY[@]}"; do
        local size=$(check_dir_size "$dir")
        printf "  %-15s %s\n" "$dir:" "$size"
    done
    echo "----------------------------------------"
    echo ""

    read -p "确认开始复制？(y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        print_warning "已取消"
        return 0
    fi

    # 使用 rsync 复制
    echo ""
    print_header "🚀 开始复制"

    for dir in "${DIRS_TO_COPY[@]}"; do
        local source_dir="$HOME/$dir"

        if [ ! -d "$source_dir" ]; then
            print_warning "$dir 不存在，跳过"
            continue
        fi

        echo ""
        echo "正在复制 $dir ..."
        echo "源目录: $source_dir"
        echo "目标目录: $volume_path/$dir"

        # 使用 rsync 复制（显示进度）
        if rsync -avh --progress "$source_dir/" "$volume_path/$dir/" 2>&1 | tee -a /tmp/copy-files.log; then
            print_success "$dir 复制完成"
        else
            print_error "$dir 复制失败"
            echo "请查看日志: /tmp/copy-files.log"
        fi
    done

    echo ""
    print_header "✅ 复制完成"

    # 显示目标位置
    echo ""
    echo "文件已复制到: $volume_path"
    echo ""
    ls -lh "$volume_path" 2>/dev/null | tail -n +2 | awk '{printf "  %s  %s\n", $5, $9}'
}

# 从外置硬盘恢复
restore_from_volume() {
    print_header "📥 从外置硬盘恢复文件"

    # 列出可用硬盘
    list_volumes
    if [ $? -ne 0 ]; then
        return 1
    fi

    # 选择硬盘
    echo ""
    read -p "请输入外置硬盘名称: " volume_name
    local volume_path="/Volumes/$volume_name"

    if [ ! -d "$volume_path" ]; then
        print_error "找不到硬盘: $volume_name"
        return 1
    fi

    echo ""
    print_success "使用硬盘: $volume_name"

    # 检查硬盘上有哪些目录
    echo ""
    echo "硬盘上找到的目录："
    echo "----------------------------------------"
    local found_dirs=()
    for dir in "${DIRS_TO_COPY[@]}"; do
        if [ -d "$volume_path/$dir" ]; then
            local size=$(du -sh "$volume_path/$dir" 2>/dev/null | cut -f1)
            printf "  %-15s %s\n" "$dir:" "$size"
            found_dirs+=("$dir")
        fi
    done
    echo "----------------------------------------"

    if [ ${#found_dirs[@]} -eq 0 ]; then
        print_warning "未找到可恢复的目录"
        return 1
    fi

    echo ""
    read -p "确认开始恢复？这会覆盖本地文件 (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        print_warning "已取消"
        return 0
    fi

    # 使用 rsync 恢复
    echo ""
    print_header "🚀 开始恢复"

    for dir in "${found_dirs[@]}"; do
        local source_dir="$volume_path/$dir"
        local target_dir="$HOME/$dir"

        echo ""
        echo "正在恢复 $dir ..."
        echo "源目录: $source_dir"
        echo "目标目录: $target_dir"

        # 创建目标目录（如果不存在）
        mkdir -p "$target_dir"

        # 使用 rsync 恢复（显示进度）
        if rsync -avh --progress "$source_dir/" "$target_dir/" 2>&1 | tee -a /tmp/copy-files.log; then
            print_success "$dir 恢复完成"
        else
            print_error "$dir 恢复失败"
            echo "请查看日志: /tmp/copy-files.log"
        fi
    done

    echo ""
    print_header "✅ 恢复完成"
}

# 验证文件完整性
verify_files() {
    print_header "🔍 验证文件完整性"

    # 列出可用硬盘
    list_volumes
    if [ $? -ne 0 ]; then
        return 1
    fi

    # 选择硬盘
    echo ""
    read -p "请输入外置硬盘名称: " volume_name
    local volume_path="/Volumes/$volume_name"

    if [ ! -d "$volume_path" ]; then
        print_error "找不到硬盘: $volume_name"
        return 1
    fi

    echo ""
    print_success "使用硬盘: $volume_name"

    echo ""
    echo "比较本地和硬盘上的文件："
    echo "----------------------------------------"

    for dir in "${DIRS_TO_COPY[@]}"; do
        local local_dir="$HOME/$dir"
        local remote_dir="$volume_path/$dir"

        if [ ! -d "$local_dir" ] && [ ! -d "$remote_dir" ]; then
            continue
        fi

        if [ ! -d "$remote_dir" ]; then
            printf "  %-15s %s\n" "$dir:" "硬盘上不存在"
            continue
        fi

        if [ ! -d "$local_dir" ]; then
            printf "  %-15s %s\n" "$dir:" "本地不存在"
            continue
        fi

        # 比较文件数量
        local local_count=$(find "$local_dir" -type f 2>/dev/null | wc -l | tr -d ' ')
        local remote_count=$(find "$remote_dir" -type f 2>/dev/null | wc -l | tr -d ' ')

        if [ "$local_count" -eq "$remote_count" ]; then
            printf "  %-15s %s\n" "$dir:" "一致 ($local_count 个文件)"
        else
            printf "  %-15s %s\n" "$dir:" "不一致 (本地:$local_count, 硬盘:$remote_count)"
        fi
    done
    echo "----------------------------------------"
}

# 生成一键复制命令
generate_commands() {
    print_header "📝 一键复制命令"

    echo ""
    echo "选择你要执行的操作："
    echo "  1) 备份到外置硬盘"
    echo "  2) 从外置硬盘恢复"
    echo ""
    read -p "请选择 (1/2): " choice

    echo ""
    echo "=========================================="
    echo "请按照以下步骤操作："
    echo "=========================================="
    echo ""

    if [ "$choice" = "1" ]; then
        echo "# 步骤1：插入外置硬盘"
        echo ""
        echo "# 步骤2：替换下面命令中的【你的外置硬盘】为实际名称"
        echo ""
        echo "# 步骤3：复制并运行以下命令："
        echo ""
        echo "# 备份 Documents"
        echo "rsync -avh --progress ~/Documents/ /Volumes/【你的外置硬盘】/Documents/"
        echo ""
        echo "# 备份 Pictures"
        echo "rsync -avh --progress ~/Pictures/ /Volumes/【你的外置硬盘】/Pictures/"
        echo ""
        echo "# 备份 Movies"
        echo "rsync -avh --progress ~/Movies/ /Volumes/【你的外置硬盘】/Movies/"
        echo ""
        echo "# 备份 Desktop"
        echo "rsync -avh --progress ~/Desktop/ /Volumes/【你的外置硬盘】/Desktop/"
        echo ""
    else
        echo "# 步骤1：插入外置硬盘"
        echo ""
        echo "# 步骤2：替换下面命令中的【你的外置硬盘】为实际名称"
        echo ""
        echo "# 步骤3：复制并运行以下命令："
        echo ""
        echo "# 恢复 Documents"
        echo "rsync -avh --progress /Volumes/【你的外置硬盘】/Documents/ ~/Documents/"
        echo ""
        echo "# 恢复 Pictures"
        echo "rsync -avh --progress /Volumes/【你的外置硬盘】/Pictures/ ~/Pictures/"
        echo ""
        echo "# 恢复 Movies"
        echo "rsync -avh --progress /Volumes/【你的外置硬盘】/Movies/ ~/Movies/"
        echo ""
        echo "# 恢复 Desktop"
        echo "rsync -avh --progress /Volumes/【你的外置硬盘】/Desktop/ ~/Desktop/"
        echo ""
    fi
}

# ============================================
# 主程序
# ============================================

case "${1:-}" in
    list)
        list_volumes
        ;;
    backup)
        backup_to_volume
        ;;
    restore)
        restore_from_volume
        ;;
    verify)
        verify_files
        ;;
    commands)
        generate_commands
        ;;
    *)
        echo "=========================================="
        echo "📁 文件复制辅助工具"
        echo "=========================================="
        echo ""
        echo "用法："
        echo "  $0 list     - 列出可用的外置硬盘"
        echo "  $0 backup   - 复制文件到外置硬盘"
        echo "  $0 restore  - 从外置硬盘恢复文件"
        echo "  $0 verify   - 验证文件完整性"
        echo "  $0 commands - 生成一键复制命令"
        echo ""
        echo "示例："
        echo "  $0 list      # 查看可用硬盘"
        echo "  $0 backup    # 备份文件"
        echo "  $0 restore   # 恢复文件"
        echo ""
        ;;
esac
