#!/bin/bash

# ============================================================
# macOS 终端环境一键配置脚本
# ============================================================

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
    print_success "检测到 macOS 系统"
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
    brew install git curl wget jq tree ripgrep fd fzf bat lsd zoxide delta btop lazygit tlrc thefuck xh starship 2>/dev/null || true
    print_success "基础工具安装完成"
}

install_fonts() {
    print_info "安装 Nerd Fonts..."
    brew tap homebrew/cask-fonts 2>/dev/null || true
    brew install --cask font-meslo-lg-nerd-font 2>/dev/null || true
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
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" 2>/dev/null || true
    fi
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" 2>/dev/null || true
    fi
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions" ]; then
        git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions" 2>/dev/null || true
    fi
    print_success "Zsh 插件安装完成"
}

setup_fzf() {
    print_info "配置 fzf..."
    if [ ! -f ~/.fzf.zsh ]; then
        $(brew --prefix)/opt/fzf/install --all --no-bash --no-fish 2>/dev/null || true
    fi
    print_success "fzf 配置完成"
}

backup_configs() {
    print_info "备份现有配置..."
    BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    [ -f ~/.zshrc ] && cp ~/.zshrc "$BACKUP_DIR/"
    [ -f ~/.config/starship.toml ] && cp ~/.config/starship.toml "$BACKUP_DIR/"
    print_success "配置已备份到 $BACKUP_DIR"
}

install_configs() {
    print_info "安装配置文件..."
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$SCRIPT_DIR/configs/.zshrc" ~/.zshrc
    mkdir -p ~/.config
    cp "$SCRIPT_DIR/configs/starship.toml" ~/.config/starship.toml
    print_success "配置文件安装完成"
}

git_config() {
    print_info "配置 Git..."
    git config --global core.pager delta 2>/dev/null || true
    git config --global interactive.diffFilter 'delta --color-only' 2>/dev/null || true
    git config --global delta.navigate true 2>/dev/null || true
    git config --global delta.light false 2>/dev/null || true
    git config --global delta.side-by-side true 2>/dev/null || true
    print_success "Git 配置完成"
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
    backup_configs
    install_configs
    git_config
    
    echo ""
    echo "============================================================"
    print_success "配置完成!"
    echo "============================================================"
    echo ""
    echo "请执行: source ~/.zshrc"
    echo ""
}

main "$@"
