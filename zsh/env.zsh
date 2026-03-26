# ============================================
# 环境变量配置
# PATH 统一在 .zshenv 中管理，此处只放非 PATH 环境变量
# ============================================

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
export PYTHONDONTWRITEBYTECODE=1

# 工具配置
export BAT_THEME="TwoDark"
export LESS="-R -F -X"
export XDG_CONFIG_HOME="${HOME}/.config"
