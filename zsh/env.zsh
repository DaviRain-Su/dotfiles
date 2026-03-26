# ============================================
# 环境变量配置
# ============================================

# 基础路径
export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${HOME}/.cargo/bin:${PATH}"
export PATH="${HOME}/.bun/bin:${PATH}"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"

# Bun
export BUN_INSTALL="${HOME}/.bun"

# 编辑器
export EDITOR="nvim"
export VISUAL="nvim"

# 语言环境
export LANG="zh_CN.UTF-8"
export LC_ALL="zh_CN.UTF-8"

# Homebrew
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_BUNDLE_FILE="${HOME}/.Brewfile"

# 开发工具
export RUST_BACKTRACE=1
export GOPATH="${HOME}/go"
export PATH="${GOPATH}/bin:${PATH}"
export PYTHONDONTWRITEBYTECODE=1

# 工具配置
export BAT_THEME="TwoDark"
export LESS="-R -F -X"
export XDG_CONFIG_HOME="${HOME}/.config"
