# ============================================
# Oh My Zsh 配置
# ============================================

export ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME=""

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  command-not-found
  colored-man-pages
  sudo
  history
  web-search
  copypath
  copyfile
  extract
  encode64
)

source $ZSH/oh-my-zsh.sh
