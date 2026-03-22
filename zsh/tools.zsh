# ============================================
# 工具初始化
# ============================================

# zoxide
eval "$(zoxide init zsh)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# thefuck
eval $(thefuck --alias)

# Starship
eval "$(starship init zsh)"
