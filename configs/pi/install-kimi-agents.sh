#!/bin/bash
# 安装 Kimi 版本的 Pi Agents

set -e

DOTFILES="${HOME}/dotfiles"
PI_AGENTS_DIR="${HOME}/.pi/agent/agents"

echo "==================================="
echo "安装 Kimi Agents for Pi"
echo "==================================="
echo ""

# 创建目录
mkdir -p "$PI_AGENTS_DIR"

echo "✓ 创建目录: $PI_AGENTS_DIR"

# 复制 agents
cp "$DOTFILES/configs/pi/agents/"*.md "$PI_AGENTS_DIR/"

echo "✓ 复制 agent 配置:"
ls -1 "$DOTFILES/configs/pi/agents/"*.md | xargs -n1 basename | sed 's/^/  - /'

echo ""
echo "==================================="
echo "安装完成！"
echo "==================================="
echo ""
echo "现在你可以在 Pi 中使用:"
echo "  /run scout \"分析代码\""
echo "  /chain scout -> planner -> worker"
echo ""
echo "这些 agent 会使用 Kimi k2.5 模型。"
echo ""
