# ============================================
# Dotfiles 任务管理
# 运行 `just` 查看所有可用命令
# ============================================

set shell := ["zsh", "-cu"]

DOTFILES := env_var('HOME') / "dotfiles"

# 默认：显示所有可用命令
default:
    @just --list

# 完整安装（运行 install.sh）
install:
    {{DOTFILES}}/install.sh

# 创建/更新符号链接
link:
    #!/usr/bin/env zsh
    set -e
    mkdir -p ~/.config ~/.config/ghostty ~/.config/lazygit ~/.config/bat

    # Shell
    ln -sf {{DOTFILES}}/configs/.zshrc ~/.zshrc
    ln -sf {{DOTFILES}}/configs/.zshenv ~/.zshenv
    ln -sf {{DOTFILES}}/configs/.curlrc ~/.curlrc
    ln -sf {{DOTFILES}}/configs/.wgetrc ~/.wgetrc
    ln -sf {{DOTFILES}}/configs/.hushlogin ~/.hushlogin

    # Starship
    ln -sf {{DOTFILES}}/configs/starship.toml ~/.config/starship.toml

    # Ghostty
    ln -sf {{DOTFILES}}/configs/ghostty/config ~/.config/ghostty/config

    # Git（仅在不存在时创建）
    [ -f ~/.gitconfig ] || ln -sf {{DOTFILES}}/configs/.gitconfig ~/.gitconfig

    # Lazygit
    [ -f {{DOTFILES}}/configs/lazygit/config.yml ] && \
        ln -sf {{DOTFILES}}/configs/lazygit/config.yml ~/.config/lazygit/config.yml || true

    # Bat
    [ -f {{DOTFILES}}/configs/bat/config ] && \
        ln -sf {{DOTFILES}}/configs/bat/config ~/.config/bat/config || true

    # Zellij
    [ -f {{DOTFILES}}/configs/zellij/config.kdl ] && {
        mkdir -p ~/.config/zellij
        ln -sf {{DOTFILES}}/configs/zellij/config.kdl ~/.config/zellij/config.kdl
    } || true

    # Pi (pi-messenger Crew 配置)
    mkdir -p ~/.pi/agent
    ln -sf {{DOTFILES}}/configs/agents/pi/pi-messenger.json ~/.pi/agent/pi-messenger.json

    echo "✓ 符号链接已更新"

# 从 Git 拉取最新配置
update:
    git -C {{DOTFILES}} pull
    brew bundle --file={{DOTFILES}}/Brewfile --no-lock
    @echo "✓ 更新完成，运行 source ~/.zshrc 重载配置"

# 备份当前配置
backup:
    #!/usr/bin/env zsh
    set -e
    backup_dir="${HOME}/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    for f in ~/.zshrc ~/.zshenv ~/.gitconfig ~/.config/starship.toml; do
        [ -f "$f" ] && cp "$f" "$backup_dir/" || true
    done
    echo "✓ 已备份到 $backup_dir"

# 同步 Homebrew 包
brew:
    brew bundle --file={{DOTFILES}}/Brewfile --no-lock
    brew cleanup

# 应用 macOS 系统偏好设置
macos:
    {{DOTFILES}}/macos.sh

# 安装所有 AI Agent
agents:
    {{DOTFILES}}/bin/ai install

# 检查工具安装状态和符号链接完整性
health:
    #!/usr/bin/env zsh
    echo "=== 工具安装检查 ==="
    tools=(git delta bat lsd fd rg fzf zoxide starship btop dust duf procs lazygit zellij just glow nvim)
    for tool in $tools; do
        if command -v $tool &>/dev/null; then
            printf "  ✓ %-12s %s\n" "$tool" "$(command -v $tool)"
        else
            printf "  ✗ %-12s 未安装\n" "$tool"
        fi
    done

    echo "\n=== 符号链接检查 ==="
    links=(~/.zshrc ~/.zshenv ~/.config/starship.toml ~/.config/ghostty/config)
    for link in $links; do
        if [ -L "$link" ]; then
            printf "  ✓ %s -> %s\n" "$link" "$(readlink $link)"
        elif [ -f "$link" ]; then
            printf "  ⚠ %s (普通文件，非符号链接)\n" "$link"
        else
            printf "  ✗ %s 不存在\n" "$link"
        fi
    done

    echo "\n=== PATH 重复检查 ==="
    dupes=$(echo $PATH | tr ':' '\n' | sort | uniq -d)
    if [ -z "$dupes" ]; then
        echo "  ✓ 无重复 PATH 条目"
    else
        echo "  ⚠ 重复条目:"
        echo "$dupes" | while read p; do echo "    - $p"; done
    fi

# 清理临时文件和缓存
clean:
    @echo "清理 Homebrew 缓存..."
    brew cleanup -s 2>/dev/null || true
    @echo "清理 zsh 编译缓存..."
    rm -f ~/.zcompdump* 2>/dev/null || true
    @echo "✓ 清理完成"

# 编辑 dotfiles（在编辑器中打开）
edit:
    $EDITOR {{DOTFILES}}

# 显示状态
status:
    @echo "Dotfiles: {{DOTFILES}}"
    @echo ""
    @git -C {{DOTFILES}} status -sb
    @echo ""
    @echo "最近提交:"
    @git -C {{DOTFILES}} log --oneline -5
