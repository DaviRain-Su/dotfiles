# ============================================
# fzf 配置
# ============================================

# 默认选项 — 智能预览：文件用 bat，目录用 lsd
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --preview "if [ -d {} ]; then lsd --tree --depth 2 --color always {}; elif [ -f {} ]; then bat --style=numbers --color=always --line-range :100 {}; else echo {}; fi"
  --preview-window right:50%:wrap
  --bind "ctrl-/:toggle-preview"
  --bind "ctrl-y:preview-up"
  --bind "ctrl-e:preview-down"
  --bind "ctrl-b:preview-page-up"
  --bind "ctrl-f:preview-page-down"
'

# 使用 fd 查找文件
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Ctrl+T: 文件搜索 + bat 预览
export FZF_CTRL_T_COMMAND="fd --hidden --follow --exclude .git"
export FZF_CTRL_T_OPTS='
  --preview "if [ -d {} ]; then lsd --tree --depth 2 --color always {}; else bat --style=numbers --color=always --line-range :100 {} 2>/dev/null || echo {}; fi"
'

# Alt+C: 目录跳转 + 目录树预览
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS='
  --preview "lsd --tree --depth 2 --color always {}"
'

# fzf + git 集成
alias fbr='git branch -a | fzf --preview "git log --oneline --graph -20 {1}" | sed "s/^[* ]*//" | xargs git checkout'
alias fco='git log --oneline | fzf --preview "git show --stat --color {1}" | cut -d" " -f1 | xargs git checkout'
alias fshow='git log --oneline | fzf --preview "git show --color {1}" | cut -d" " -f1 | xargs git show'
alias fadd='git status -s | fzf -m --preview "git diff --color {2}" | awk "{print \$2}" | xargs git add'
