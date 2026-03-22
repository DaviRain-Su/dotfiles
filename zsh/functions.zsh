# ============================================
# 函数配置
# ============================================

# 创建目录并进入
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# 备份文件
backup() {
  cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
}

# 解压任何格式
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.tar.xz)    tar xJf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# 查看文件/目录大小
fs() {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh
  else
    local arg=-sh
  fi
  if [[ -n "$@" ]]; then
    du $arg -- "$@"
  else
    du $arg .[^.]* ./*
  fi
}

# 搜索并替换
replace() {
  rg -l "$1" | xargs sd "$1" "$2"
}

# 查看端口占用
port() {
  lsof -i :"$1" 2>/dev/null || echo "Port $1 is not in use"
}

# 杀死端口进程
killport() {
  lsof -ti :"$1" | xargs kill -9 2>/dev/null || echo "No process found on port $1"
}

# 生成随机密码
genpass() {
  local length=${1:-16}
  openssl rand -base64 48 | cut -c1-"$length"
}

# 创建临时目录并进入
tmp() {
  local dir=$(mktemp -d)
  echo "Created temp directory: $dir"
  cd "$dir"
}

# 下载并解压
download() {
  local url="$1"
  local filename=$(basename "$url")
  curl -LO "$url" && extract "$filename"
}

# 创建数据 URL
dataurl() {
  local mimeType=$(file -b --mime-type "$1")
  if [[ $mimeType == text/* ]]; then
    mimeType="${mimeType};charset=utf-8"
  fi
  echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# 启动 HTTP 服务器
server() {
  local port="${1:-8000}"
  python3 -m http.server "$port"
}

# 使用 Git 的 diff
diff() {
  git diff --no-index --color-words "$@"
}

# 创建 tar.gz 压缩包
targz() {
  local tmpFile="${@%/}.tar"
  tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1
  gzip -v "${tmpFile}" || return 1
  echo "${tmpFile}.gz created successfully"
}
