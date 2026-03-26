# ============================================
# 别名配置
# ============================================

# 配置编辑
alias zshconfig="$EDITOR ~/.zshrc"
alias zenv="$EDITOR ~/.zshenv"
alias reload="source ~/.zshrc"

# 目录导航
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# ls 增强
alias ls='lsd --icon=always --icon-theme=unicode'
alias l='lsd --icon=always --icon-theme=unicode -lF'
alias la='lsd --icon=always --icon-theme=unicode -a'
alias ll='lsd --icon=always --icon-theme=unicode -lh'
alias lla='lsd --icon=always --icon-theme=unicode -lha'
alias lt='lsd --icon=always --icon-theme=unicode --tree'
alias lta='lsd --icon=always --icon-theme=unicode --tree -a'
alias l.='ls -d .*'

# cat 增强
alias cat='bat --paging=never --style=plain'
alias catl='bat'

# cd 增强
alias cd='z'
alias zi='z -i'
alias za='z -a'

# grep 增强
alias grep='rg'
alias rg='rg --smart-case --hidden --follow --glob "!.git"'

# find 增强
alias find='fd'

# 系统工具增强
alias du='dust'
alias df='duf'
alias ps='procs'
alias sed='sd'
alias man='tldr'
alias help='tldr'
alias top='btop'
alias htop='btop'

# HTTP 客户端
alias http='xh'
alias https='xh --https'

# 实用别名
alias mkdir='mkdir -p'
alias cp='cp -r'
alias rm='rm -i'
alias mv='mv -i'
alias cls='clear'
alias c='clear'
alias q='exit'
alias h='history'
alias j='just'
alias serve='python3 -m http.server'
alias ip='curl -s https://ipinfo.io/ip'
alias localip='ipconfig getifaddr en0'
alias ports='lsof -i -P | grep LISTEN'
alias week='date +%V'
alias timer='echo "Timer started. Stop with Ctrl+D." && date && time cat && date'

# macOS 特定
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias safari='open -a Safari'
alias finder='open -a Finder'
alias flush='dscacheutil -flushcache && sudo killall -HUP mDNSResponder'

# ============================================
# AI Agent 快捷别名
# ============================================
alias ai='${DOTFILES}/bin/ai'
alias aic='ai claude'
alias aip='ai pi'
alias aico='ai codex'
alias aio='ai opencode'
alias aih='ai hermes'
alias aid='ai droid'
alias ail='ai list'

# AI 分屏会话 (类似 sesh - AI + lazygit)
alias ais='ai sesh'                    # 默认 Claude + lazygit
alias aisc='ai sesh claude'            # Claude + lazygit
alias aisp='ai sesh pi'                # Pi + lazygit
alias aisco='ai sesh codex'            # Codex + lazygit
alias aish='ai sesh hermes'            # Hermes + lazygit
alias aisd='ai sesh droid'             # Factory.ai + lazygit
alias aispick='ai sesh pickup'         # 恢复最近会话
alias aisls='ai sesh list'             # 列出活跃会话


# ============================================
# 快捷键速查表别名 (使用 glow 渲染 Markdown)
# ============================================
# 如果没有 glow，使用 bat 作为回退
if command -v glow &> /dev/null; then
    alias cheat='glow ~/dotfiles/CHEATSHEET.md'
    alias quick='glow ~/dotfiles/QUICKREF.md'
    alias keys='glow ~/dotfiles/CHEATSHEET.md -p | grep -A 20 "## 👻 Ghostty" | glow -'
    alias tmux-help='glow ~/dotfiles/CHEATSHEET.md -p | grep -A 30 "## 🖥️ Tmux" | glow -'
    alias pi-help='glow ~/dotfiles/CHEATSHEET.md -p | grep -A 40 "## 🤖 pi" | glow -'
else
    # 回退到 bat（带语法高亮）
    alias cheat='bat ~/dotfiles/CHEATSHEET.md'
    alias quick='bat ~/dotfiles/QUICKREF.md'
    alias keys='bat ~/dotfiles/CHEATSHEET.md | grep -A 20 "## 👻 Ghostty"'
    alias tmux-help='bat ~/dotfiles/CHEATSHEET.md | grep -A 30 "## 🖥️ Tmux"'
    alias pi-help='bat ~/dotfiles/CHEATSHEET.md | grep -A 40 "## 🤖 pi"'
fi
