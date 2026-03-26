#!/bin/bash

# ============================================
# macOS 终端环境一键配置脚本
# 参考: mathiasbynens/dotfiles, holman/dotfiles, keith/dotfiles
# ============================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "此脚本仅支持 macOS"
        exit 1
    fi
    print_success "检测到 macOS 系统 ($(uname -m))"
}

install_homebrew() {
    if command -v brew &> /dev/null; then
        print_info "Homebrew 已安装，更新中..."
        brew update
    else
        print_info "安装 Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi
    print_success "Homebrew 就绪"
}

install_base_tools() {
    print_info "安装基础工具..."
    
    local tools=(
        git curl wget jq tree openssl gnupg nmap
        starship lsd eza bat fzf zoxide ripgrep fd
        delta lazygit btop tlrc thefuck xh zellij
        dust duf procs sd choose
        just
        node python go zig
        docker kubectl
        postgresql redis sqlite
        neovim
        ffmpeg
    )
    
    for tool in "${tools[@]}"; do
        if brew list "$tool" &>/dev/null; then
            print_warning "$tool 已安装"
        else
            print_info "安装 $tool..."
            brew install "$tool" 2>/dev/null || print_warning "$tool 安装失败"
        fi
    done
    
    print_success "基础工具安装完成"
}

install_fonts() {
    print_info "安装 Nerd Fonts..."
    brew tap homebrew/cask-fonts 2>/dev/null || true
    
    local fonts=(
        font-meslo-lg-nerd-font
        font-jetbrains-mono-nerd-font
        font-fira-code-nerd-font
    )
    
    for font in "${fonts[@]}"; do
        if brew list --cask "$font" &>/dev/null; then
            print_warning "$font 已安装"
        else
            brew install --cask "$font" 2>/dev/null || print_warning "$font 安装失败"
        fi
    done
    
    print_success "字体安装完成"
}

install_ohmyzsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_warning "Oh My Zsh 已安装"
        return
    fi
    
    print_info "安装 Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh 安装完成"
}

install_zsh_plugins() {
    print_info "安装 Zsh 插件..."
    
    local plugins=(
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting"
        "zsh-users/zsh-completions"
    )
    
    for plugin in "${plugins[@]}"; do
        local name=$(basename "$plugin")
        if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$name" ]; then
            git clone "https://github.com/$plugin" \
                "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$name" 2>/dev/null || true
        fi
    done
    
    print_success "Zsh 插件安装完成"
}

setup_fzf() {
    print_info "配置 fzf..."
    if [ ! -f ~/.fzf.zsh ]; then
        $(brew --prefix)/opt/fzf/install --all --no-bash --no-fish 2>/dev/null || true
    fi
    print_success "fzf 配置完成"
}

# mathias 风格的 rsync 安装
install_dotfiles_rsync() {
    print_info "使用 rsync 安装 dotfiles..."
    
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # 使用 rsync 同步文件（mathias 风格）
    rsync --exclude ".git/" \
          --exclude ".DS_Store" \
          --exclude "*.md" \
          --exclude "install.sh" \
          --exclude "setup.sh" \
          --exclude "macos.sh" \
          --exclude "Brewfile" \
          --exclude "MATHIAS_ANALYSIS.md" \
          --exclude "script/" \
          --exclude "bin/" \
          --exclude "zsh/" \
          --exclude "configs/" \
          -avh --no-perms "${SCRIPT_DIR}/configs/" ~
    
    # 链接 zsh 配置
    ln -sf "${SCRIPT_DIR}/zsh/zshrc" ~/.zshrc
    
    # 链接 starship 配置
    mkdir -p ~/.config
    ln -sf "${SCRIPT_DIR}/configs/starship.toml" ~/.config/starship.toml
    
    # 链接 Ghostty 配置
    mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
    ln -sf "${SCRIPT_DIR}/configs/ghostty/config" ~/Library/Application\ Support/com.mitchellh.ghostty/config
    
    print_success "dotfiles 安装完成"
}

# 符号链接安装（holman 风格）
install_dotfiles_symlink() {
    print_info "使用符号链接安装 dotfiles..."
    
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # 创建符号链接
    mkdir -p ~/.config
    
    # .zshenv
    if [ -f "$HOME/.zshenv" ] && [ ! -L "$HOME/.zshenv" ]; then
        mv "$HOME/.zshenv" "$HOME/.zshenv.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    ln -sf "${SCRIPT_DIR}/configs/.zshenv" "$HOME/.zshenv"
    
    # .zshrc
    if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
        mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    ln -sf "${SCRIPT_DIR}/zsh/zshrc" "$HOME/.zshrc"
    
    # starship.toml
    ln -sf "${SCRIPT_DIR}/configs/starship.toml" "$HOME/.config/starship.toml"
    
    # Ghostty 配置
    mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
    ln -sf "${SCRIPT_DIR}/configs/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
    
    # Tmux 配置
    ln -sf "${SCRIPT_DIR}/configs/tmux/tmux.conf" "$HOME/.tmux.conf"
    
    # AI Agent 配置
    print_info "配置 AI Agent..."
    mkdir -p "$HOME/.claude" "$HOME/.codex" "$HOME/.hermes"
    
    # Claude Code 配置
    if [ -f "${SCRIPT_DIR}/configs/agents/claude/settings.json" ]; then
        ln -sf "${SCRIPT_DIR}/configs/agents/claude/settings.json" "$HOME/.claude/settings.json"
    fi
    if [ -f "${SCRIPT_DIR}/configs/agents/claude/CLAUDE.md" ]; then
        ln -sf "${SCRIPT_DIR}/configs/agents/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
    fi
    
    # Codex 配置
    if [ -f "${SCRIPT_DIR}/configs/agents/codex/config.toml" ]; then
        ln -sf "${SCRIPT_DIR}/configs/agents/codex/config.toml" "$HOME/.codex/config.toml"
    fi
    
    # Hermes 配置
    if [ -f "${SCRIPT_DIR}/configs/agents/hermes/config.yaml" ]; then
        ln -sf "${SCRIPT_DIR}/configs/agents/hermes/config.yaml" "$HOME/.hermes/config.yaml"
    fi
    
    # 其他配置文件
    for file in .path .exports .aliases .functions .extra .curlrc .wgetrc .hushlogin; do
        if [ -f "${SCRIPT_DIR}/configs/$file" ]; then
            ln -sf "${SCRIPT_DIR}/configs/$file" "$HOME/$file"
        fi
    done
    
    print_success "dotfiles 安装完成"
}

git_config() {
    print_info "配置 Git..."
    
    git config --global core.pager delta 2>/dev/null || true
    git config --global interactive.diffFilter 'delta --color-only' 2>/dev/null || true
    git config --global delta.navigate true 2>/dev/null || true
    git config --global delta.light false 2>/dev/null || true
    git config --global delta.side-by-side true 2>/dev/null || true
    git config --global init.defaultBranch main 2>/dev/null || true
    git config --global push.default simple 2>/dev/null || true
    
    print_success "Git 配置完成"
    print_warning "请记得配置 Git 用户名和邮箱（可以编辑 ~/.extra）："
    echo "  export GIT_AUTHOR_NAME='Your Name'"
    echo "  export GIT_AUTHOR_EMAIL='your.email@example.com'"
}

setup_macos() {
    read -p "是否配置 macOS 系统设置? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "配置 macOS 系统设置..."
        if [ -f "${SCRIPT_DIR}/macos.sh" ]; then
            bash "${SCRIPT_DIR}/macos.sh"
        else
            print_warning "macos.sh 不存在，跳过"
        fi
    fi
}

main() {
    echo ""
    echo "============================================================"
    echo "  macOS 终端环境一键配置脚本"
    echo "  参考: mathiasbynens/dotfiles"
    echo "============================================================"
    echo ""
    
    check_macos
    
    read -p "此脚本将修改你的终端配置，是否继续? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "已取消"
        exit 1
    fi
    
    # 选择安装方式
    echo ""
    echo "选择安装方式:"
    echo "  1) rsync - 复制文件（推荐，mathias 风格）"
    echo "  2) symlink - 符号链接（holman 风格）"
    read -p "请选择 (1/2): " install_method
    
    install_homebrew
    install_base_tools
    install_fonts
    install_ohmyzsh
    install_zsh_plugins
    setup_fzf
    
    case "$install_method" in
        2)
            install_dotfiles_symlink
            ;;
        *)
            install_dotfiles_rsync
            ;;
    esac
    
    git_config
    setup_macos
    
    echo ""
    echo "============================================================"
    print_success "配置完成!"
    echo "============================================================"
    echo ""
    echo "请执行: source ~/.zshrc"
    echo ""
    echo "提示:"
    echo "  - 编辑 ~/.extra 添加你的 Git 用户名和 API Keys"
    echo "  - 运行 'dot' 命令管理 dotfiles"
    echo "  - 运行 'c <project>' 快速进入项目"
    echo "  - Ghostty 配置已链接到 ~/Library/Application Support/com.mitchellh.ghostty/config"
    echo ""
}

main "$@"
