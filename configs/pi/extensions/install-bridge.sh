#!/bin/bash
# 安装 pi-claude-codex-bridge 扩展到 Pi

set -e

EXTENSION_DIR="${HOME}/.pi/extensions/pi-claude-codex-bridge"
DOTFILES_DIR="${HOME}/dotfiles"

echo "==================================="
echo "安装 Pi Claude/Codex Bridge 扩展"
echo "==================================="
echo ""

# 创建目录
mkdir -p "${HOME}/.pi/extensions"

# 复制扩展
if [ -d "${DOTFILES_DIR}/configs/pi/extensions/pi-claude-codex-bridge" ]; then
    cp -r "${DOTFILES_DIR}/configs/pi/extensions/pi-claude-codex-bridge" "${HOME}/.pi/extensions/"
    echo "✓ 扩展已复制到 ${EXTENSION_DIR}"
else
    echo "✗ 扩展文件不存在"
    exit 1
fi

echo ""
echo "==================================="
echo "安装完成！"
echo "==================================="
echo ""
echo "使用方法:"
echo "  1. 重启 Pi"
echo "  2. 使用 /claude, /codex, /workflow 命令"
echo ""
echo "示例:"
echo "    /claude 设计用户认证系统"
echo "    /codex 实现登录功能"
echo "    /workflow 开发完整功能"
echo ""
