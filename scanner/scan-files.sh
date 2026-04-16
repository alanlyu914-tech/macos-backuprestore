#!/bin/bash
# ============================================
# 扫描个人文件
# ============================================

scan_files() {
    echo "⏳ 扫描个人文件..."

    # 扫描常见目录
    declare -A file_dirs
    file_dirs["Documents"]="~/Documents 文档"
    file_dirs["Pictures"]="~/Pictures 照片"
    file_dirs["Movies"]="~/Movies 视频"
    file_dirs["Desktop"]="~/Desktop 桌面"
    file_dirs["Downloads"]="~/Downloads 下载"

    for dir in "${!file_dirs[@]}"; do
        target_dir="$HOME/$dir"

        if [ -d "$target_dir" ]; then
            # 计算大小
            dir_size=$(du -sh "$target_dir" 2>/dev/null | cut -f1)

            # 计算文件数量（不包括隐藏文件）
            file_count=$(find "$target_dir" -maxdepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')

            # 计算文件夹数量
            folder_count=$(find "$target_dir" -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
            folder_count=$((folder_count - 1))  # 减去自己

            echo "FILE_DIR_$dir=$dir_size ($file_count 个文件, $folder_count 个文件夹)"
        else
            echo "FILE_DIR_$dir=不存在"
        fi
    done

    echo "✅ 个人文件扫描完成"
}

# 如果直接运行此脚本
if [ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    scan_files
fi
