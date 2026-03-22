# ============================================
# fzf 配置
# ============================================

# 默认选项
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --preview "echo {}"
  --preview-window down:3:wrap
  --bind "ctrl-/:toggle-preview"
  --bind "ctrl-y:preview-up"
  --bind "ctrl-e:preview-down"
  --bind "ctrl-b:preview-page-up"
  --bind "ctrl-f:preview-page-down"
'

# 使用 fd 查找文件
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# fzf + git 集成
alias fbr='git branch -a | fzf | sed "s/^[* ]*//" | xargs git checkout'
alias fco='git log --oneline | fzf | cut -d" " -f1 | xargs git checkout'
alias fshow='git log --oneline | fzf --preview "git show {1}" | cut -d" " -f1 | xargs git show'
alias fadd='git status -s | fzf -m | awk "{print \$2}" | xargs git add'
