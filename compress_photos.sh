#!/usr/bin/env bash

set -euo pipefail

# 使用方式：
# ./compress_photos.sh /path/to/photos
#
# 如果沒有傳入資料夾，預設處理目前資料夾
INPUT_DIR="${1:-.}"

# 轉成絕對路徑
INPUT_DIR="$(realpath "$INPUT_DIR")"

OUTPUT_DIR="$INPUT_DIR/comp"

# 檢查 ImageMagick
if ! command -v magick >/dev/null 2>&1; then
    echo "錯誤：找不到 ImageMagick 的 magick 指令。"
    echo "Ubuntu / WSL 可執行："
    echo "sudo apt install imagemagick"
    exit 1
fi

# 檢查輸入資料夾
if [[ ! -d "$INPUT_DIR" ]]; then
    echo "錯誤：資料夾不存在：$INPUT_DIR"
    exit 1
fi

# 建立輸出資料夾
mkdir -p "$OUTPUT_DIR"

echo "來源資料夾：$INPUT_DIR"
echo "輸出資料夾：$OUTPUT_DIR"
echo

count=0

# 只搜尋目前這一層，不進子資料夾
while IFS= read -r -d '' file; do

    filename="$(basename "$file")"

    output="$OUTPUT_DIR/$filename"

    echo "處理：$filename"

    magick "$file" \
        -auto-orient \
        -resize "2400x2400>" \
        -strip \
        -quality 85 \
        "$output"

    ((count+=1))

done < <(
    find "$INPUT_DIR" \
        -maxdepth 1 \
        -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" \) \
        -print0
)

echo
echo "完成，共處理 $count 張照片。"
echo "輸出位置：$OUTPUT_DIR"