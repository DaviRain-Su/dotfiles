#!/bin/bash

# ============================================
# macOS 终端环境一键配置脚本
# 作者: davirian
# 用途: 在新 Mac 上快速配置完整的终端开发环境
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

install_dotfiles() {
    print_info "安装 dotfiles..."
    
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # 创建符号链接
    mkdir -p ~/.config
    
    # .zshenv
    if [ -f "$HOME/.zshenv" ]; then
        mv "$HOME/.zshenv" "$HOME/.zshenv.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    ln -sf "${SCRIPT_DIR}/configs/.zshenv" "$HOME/.zshenv"
    
    # .zshrc
    if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
        mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    ln -sf "${SCRIPT_DIR}/configs/.zshrc" "$HOME/.zshrc"
    
    # starship.toml
    ln -sf "${SCRIPT_DIR}/configs/starship.toml" "$HOME/.config/starship.toml"
    
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
    print_warning "请记得配置 Git 用户名和邮箱:"
    echo "  git config --global user.name 'Your Name'"
    echo "  git config --global user.email 'your.email@example.com'"
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
    echo "============================================================"
    echo ""
    
    check_macos
    
    read -p "此脚本将修改你的终端配置，是否继续? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "已取消"
        exit 1
    fi
    
    install_homebrew
    install_base_tools
    install_fonts
    install_ohmyzsh
    install_zsh_plugins
    setup_fzf
    install_dotfiles
    git_config
    setup_macos
    
    echo ""
    echo "============================================================"
    print_success "配置完成!"
    echo "============================================================"
    echo ""
    echo "请执行: source ~/.zshrc"
    echo ""
    echo "快捷键:"
    echo "  Ctrl+T  - 查找文件"
    echo "  Ctrl+R  - 查找历史命令"
    echo "  Alt+C   - 查找目录"
    echo "  lg      - 打开 lazygit"
    echo "  btop    - 系统监控"
    echo ""
}

main "$@"
