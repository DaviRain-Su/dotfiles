# .zshenv - 环境变量配置
# 这个文件在 .zshrc 之前加载，用于设置环境变量

# ============================================
# 基础路径
# ============================================
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# ============================================
# 编辑器设置
# ============================================
export EDITOR="nvim"
export VISUAL="nvim"

# ============================================
# 语言环境
# ============================================
export LANG="zh_CN.UTF-8"
export LC_ALL="zh_CN.UTF-8"

# ============================================
# Homebrew
# ============================================
export HOMEBREW_NO_AUTO_UPDATE=1  # 禁用自动更新
export HOMEBREW_BUNDLE_FILE="$HOME/.Brewfile"

# ============================================
# 开发工具
# ============================================

# Rust
export RUST_BACKTRACE=1

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Node.js
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"

# Python
export PYTHONDONTWRITEBYTECODE=1  # 不生成 .pyc 文件

# ============================================
# 工具配置
# ============================================

# fzf
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# bat
export BAT_THEME="TwoDark"

# less
export LESS="-R -F -X"

# ============================================
# 其他
# ============================================
export XDG_CONFIG_HOME="$HOME/.config"
