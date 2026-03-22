#!/bin/bash

# ============================================
# Dotfiles 管理脚本
# 用于安装、更新和管理配置
# ============================================

set -e

DOTFILES="${HOME}/dotfiles"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 创建符号链接
link_file() {
    local src="$1"
    local dst="$2"
    
    if [ -f "$dst" ] || [ -d "$dst" ]; then
        if [ -L "$dst" ]; then
            print_warning "更新符号链接: $dst"
            rm "$dst"
        else
            print_warning "备份现有文件: $dst"
            mv "$dst" "$dst.backup.$(date +%Y%m%d_%H%M%S)"
        fi
    fi
    
    ln -s "$src" "$dst"
    print_success "已链接: $dst -> $src"
}

# 安装配置
install() {
    print_info "开始安装 dotfiles..."
    
    # 创建必要的目录
    mkdir -p ~/.config
    
    # 链接主配置文件
    link_file "${DOTFILES}/configs/.zshrc" "${HOME}/.zshrc"
    link_file "${DOTFILES}/configs/.zshenv" "${HOME}/.zshenv"
    link_file "${DOTFILES}/configs/starship.toml" "${HOME}/.config/starship.toml"
    
    # 可选：链接 Git 配置（如果用户想使用模板）
    if [ ! -f "${HOME}/.gitconfig" ]; then
        link_file "${DOTFILES}/configs/.gitconfig" "${HOME}/.gitconfig"
        print_warning "请编辑 ~/.gitconfig 添加你的用户名和邮箱"
    fi
    
    print_success "安装完成！"
    print_info "请运行: source ~/.zshrc"
}

# 更新仓库
update() {
    print_info "更新 dotfiles..."
    cd "$DOTFILES"
    git pull
    print_success "更新完成！"
}

# 备份当前配置
backup() {
    local backup_dir="${HOME}/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    print_info "备份配置到: $backup_dir"
    
    mkdir -p "$backup_dir"
    
    [ -f "${HOME}/.zshrc" ] && cp "${HOME}/.zshrc" "$backup_dir/"
    [ -f "${HOME}/.zshenv" ] && cp "${HOME}/.zshenv" "$backup_dir/"
    [ -f "${HOME}/.config/starship.toml" ] && cp "${HOME}/.config/starship.toml" "$backup_dir/"
    
    print_success "备份完成！"
}

# 显示帮助
help() {
    cat << EOF
Dotfiles 管理脚本

用法: ./setup.sh [命令]

命令:
    install     安装/更新符号链接
    update      从 GitHub 拉取最新配置
    backup      备份当前配置
    help        显示此帮助信息

示例:
    ./setup.sh install    # 首次安装
    ./setup.sh update     # 更新配置
    ./setup.sh backup     # 备份当前配置

EOF
}

# 主函数
case "${1:-install}" in
    install)
        install
        ;;
    update)
        update
        ;;
    backup)
        backup
        ;;
    help|--help|-h)
        help
        ;;
    *)
        print_error "未知命令: $1"
        help
        exit 1
        ;;
esac
