# ============================================
# .zshenv - 环境变量配置
# 这个文件在 .zshrc 之前加载，适合放 PATH 等全局设置
# ============================================

export DOTFILES="${HOME}/dotfiles"

# Go
export GOPATH="${HOME}/go"

# Bun
export BUN_INSTALL="${HOME}/.bun"

# ============================================
# PATH 配置（统一在此管理，避免多处重复）
# ============================================
export PATH="${DOTFILES}/bin:${PATH}"
export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${HOME}/.cargo/bin:${PATH}"
export PATH="${BUN_INSTALL}/bin:${PATH}"
export PATH="${GOPATH}/bin:${PATH}"
export PATH="${HOME}/.npm-global/bin:${PATH}"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"

# 自动去重（zsh 内置功能）
typeset -U path
