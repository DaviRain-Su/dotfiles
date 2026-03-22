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
