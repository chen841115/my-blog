#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "用法：./new-post.sh <post-name>"
    echo "例如：./new-post.sh first-peaks-3"
    exit 1
fi

POST_NAME="$1"
POST_PATH="post/${POST_NAME}/index.md"
FULL_PATH="content/${POST_PATH}"

if [ -e "$FULL_PATH" ]; then
    echo "❌ 文章已經存在："
    echo "$FULL_PATH"
    exit 1
fi

echo "建立新文章：$FULL_PATH"

docker compose run --rm \
    --user "$(id -u):$(id -g)" \
    hugo new content "$POST_PATH"

echo
echo "✅ 建立完成：$FULL_PATH"