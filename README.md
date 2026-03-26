# 🚀 macOS 终端环境配置

一键配置美观、高效的 macOS 终端开发环境。

参考了 [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles) 和 [keith/dotfiles](https://github.com/keith/dotfiles) 的优秀实践。

## ✨ 特性

- **🎨 美观的提示符** - Starship + Emoji 图标
- **⚡ 智能补全** - zsh-autosuggestions + syntax-highlighting
- **🔍 模糊查找** - fzf 快速搜索文件/命令/历史
- **📁 文件图标** - lsd 带 Unicode 图标的文件列表
- **🚀 智能跳转** - zoxide 快速目录切换
- **📝 语法高亮** - bat 替代 cat
- **🔎 快速搜索** - ripgrep 替代 grep
- **⚙️ Git 增强** - delta + lazygit
- **📊 系统监控** - btop 美观的资源监控
- **🌐 HTTP 客户端** - xh 现代化的 curl 替代品
- **🔧 模块化配置** - 参考 keith/dotfiles 的模块化结构
- **🍎 macOS 优化** - 系统设置脚本
- **👻 [Ghostty](https://ghostty.org)** - 极速 GPU 加速终端
- **🖥️ [Tmux](https://github.com/tmux/tmux)** - 会话持久化，多编辑器共享 Agent

## 📦 包含工具

### 核心工具

| 工具 | 用途 | 替代 |
|------|------|------|
| [Starship](https://starship.rs) | 终端提示符 | Powerlevel10k |
| [lsd](https://github.com/lsd-rs/lsd) | 带图标的 ls | ls |
| [bat](https://github.com/sharkdp/bat) | 语法高亮的 cat | cat |
| [fzf](https://github.com/junegunn/fzf) | 模糊查找器 | - |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | 智能目录跳转 | cd |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | 快速文本搜索 | grep |
| [fd](https://github.com/sharkdp/fd) | 快速文件查找 | find |
| [delta](https://github.com/dandavison/delta) | Git diff 美化 | - |
| [lazygit](https://github.com/jesseduffield/lazygit) | TUI Git 客户端 | - |
| [btop](https://github.com/aristocratos/btop) | 系统监控 | htop |
| [tldr](https://tldr.sh) | 简化版 man | man |
| [thefuck](https://github.com/nvbn/thefuck) | 命令纠错 | - |
| [xh](https://github.com/ducaale/xh) | HTTP 客户端 | curl |

### 额外现代工具

| 工具 | 用途 | 替代 |
|------|------|------|
| [dust](https://github.com/bootandy/dust) | 磁盘使用分析 | du |
| [duf](https://github.com/muesli/duf) | 磁盘空间查看 | df |
| [procs](https://github.com/dalance/procs) | 进程查看 | ps |
| [sd](https://github.com/chmln/sd) | 搜索替换 | sed |
| [choose](https://github.com/theryangeary/choose) | 字段提取 | cut |
| [just](https://github.com/casey/just) | 命令运行器 | make |
| [zellij](https://github.com/zellij-org/zellij) | 终端复用器 | tmux |

## 🚀 快速开始

### 方式一：使用 install.sh（推荐）

```bash
git clone https://github.com/DaviRain-Su/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### 方式二：使用 setup.sh（符号链接方式）

```bash
git clone https://github.com/DaviRain-Su/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh install
```

### 方式三：使用 Brewfile

```bash
# 只安装 Homebrew 包
brew bundle

# 然后手动链接配置
ln -s ~/dotfiles/configs/.zshrc ~/.zshrc
ln -s ~/dotfiles/configs/.zshenv ~/.zshenv
ln -s ~/dotfiles/configs/starship.toml ~/.config/starship.toml
```

### 生效

```bash
source ~/.zshrc
```

## ⌨️ 快捷键

### fzf 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+T` | 模糊查找文件 |
| `Ctrl+R` | 模糊查找历史命令 |
| `Alt+C` | 模糊查找目录 |

### 常用别名

#### 文件操作

| 别名 | 命令 | 说明 |
|------|------|------|
| `ls` | `lsd --icon=always --icon-theme=unicode` | 带图标的文件列表 |
| `l` | `lsd -lF` | 详细列表 |
| `la` | `lsd -a` | 显示隐藏文件 |
| `ll` | `lsd -lh` | 长格式 |
| `lt` | `lsd --tree` | 树形显示 |
| `cat` | `bat --paging=never` | 语法高亮 |
| `catl` | `bat` | 带行号和分页 |

#### 目录导航

| 别名 | 命令 | 说明 |
|------|------|------|
| `cd` | `z` | 智能目录跳转 |
| `zi` | `z -i` | 交互式选择目录 |
| `za` | `z -a` | 添加目录到数据库 |
| `..` | `cd ..` | 上级目录 |
| `...` | `cd ../..` | 上两级目录 |

#### 搜索工具

| 别名 | 命令 | 说明 |
|------|------|------|
| `grep` | `rg` | 快速搜索 |
| `find` | `fd` | 快速查找 |
| `sed` | `sd` | 搜索替换 |

#### 系统工具

| 别名 | 命令 | 说明 |
|------|------|------|
| `top` | `btop` | 系统监控 |
| `htop` | `btop` | 系统监控 |
| `du` | `dust` | 磁盘使用 |
| `df` | `duf` | 磁盘空间 |
| `ps` | `procs` | 进程查看 |
| `man` | `tldr` | 简化帮助 |
| `help` | `tldr` | 简化帮助 |

#### HTTP 客户端

| 别名 | 命令 | 说明 |
|------|------|------|
| `http` | `xh` | HTTP 请求 |
| `https` | `xh --https` | HTTPS 请求 |

### Git 别名

| 别名 | 命令 |
|------|------|
| `gs` | `git status -sb` |
| `ga` | `git add` |
| `gaa` | `git add --all` |
| `gc` | `git commit` |
| `gcm` | `git commit -m` |
| `gca` | `git commit --amend` |
| `gp` | `git push` |
| `gpf` | `git push --force-with-lease` |
| `gl` | `git log --oneline --graph --all --decorate` |
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `lg` | `lazygit` |

### Docker 别名

| 别名 | 命令 |
|------|------|
| `d` | `docker` |
| `dc` | `docker-compose` |
| `dps` | `docker ps` |
| `dcup` | `docker-compose up -d` |
| `dcdown` | `docker-compose down` |

### K8s 别名

| 别名 | 命令 |
|------|------|
| `k` | `kubectl` |
| `kg` | `kubectl get` |
| `kd` | `kubectl describe` |
| `kgp` | `kubectl get pods` |
| `kl` | `kubectl logs` |

## 🎨 提示符预览

```bash
# 家目录
🏠 ~  🕐 14:32 ❯

# 普通目录
🏠 ~/dev  🕐 14:32 ❯

# Git 仓库
…/web3mcp main✗1!2 🕐 14:32 ❯
```

### 提示符元素

- `🏠 ~` - 当前目录（家目录显示 🏠）
- `main` - Git 分支名
- `✗1` - 1 个删除的文件
- `!2` - 2 个修改的文件
- `⏱️ 2s` - 命令执行时间（超过 2 秒显示）
- `🕐 14:32` - 当前时间
- `❯` - 提示符（错误时变红）

## 🛠️ 函数

### mkcd - 创建目录并进入

```bash
mkcd new-project
# 创建 new-project 目录并进入
```

### backup - 备份文件

```bash
backup important.txt
# 创建 important.txt.bak.20240322_143200
```

### extract - 解压任何格式

```bash
extract archive.zip
extract file.tar.gz
extract package.7z
```

### port - 查看端口占用

```bash
port 8080
# 显示占用 8080 端口的进程
```

### killport - 杀死端口进程

```bash
killport 8080
# 杀死占用 8080 端口的进程
```

### genpass - 生成随机密码

```bash
genpass      # 生成 16 位密码
genpass 32   # 生成 32 位密码
```

### tmp - 创建临时目录

```bash
tmp
# 创建并进入临时目录
```

## ⚙️ 自定义配置

### 修改提示符

编辑 `~/dotfiles/configs/starship.toml`：

```toml
# 修改家目录图标
[directory]
home_symbol = "🏠 ~"

# 修改时间格式
[time]
time_format = "%H:%M"

# 禁用某个模块
[time]
disabled = true
```

### 修改别名

编辑 `~/dotfiles/zsh/aliases.zsh` 或创建 `~/.zshrc.local`：

```bash
# 添加自己的别名
alias myalias='mycommand'
```

然后执行 `source ~/.zshrc`

### 修改 Git 配置

```bash
# 设置用户名和邮箱
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## 🍎 macOS 系统配置

运行 macOS 系统优化脚本：

```bash
./macos.sh
```

这会配置：
- 禁用启动音效
- 设置键盘重复速率
- 启用触控板轻触点击
- 配置 Finder 显示隐藏文件
- 配置 Dock 自动隐藏
- 启用 Safari 开发者菜单
- 等等...

## 🖥️ iTerm2 推荐设置

### 1. 字体设置

1. 打开 iTerm2 → `Cmd + ,` → Profiles → Default → Text
2. Font: **MesloLGL Nerd Font** 或 **MesloLGS Nerd Font**
3. Size: **13**
4. ✅ 勾选 "Use a different font for non-ASCII text"

### 2. 颜色主题

推荐主题：
- [Dracula](https://draculatheme.com/iterm) - 紫色调，护眼
- [Snazzy](https://github.com/sindresorhus/iterm2-snazzy) - 高对比度
- [Tokyo Night](https://github.com/enkia/tokyo-night-vscode-theme) - 深蓝色调

下载地址：https://iterm2colorschemes.com/

### 3. 窗口设置

Preferences → Profiles → Window:
- Transparency: **10-15**（轻微透明）
- Blur: **10-20**（毛玻璃效果）

## 👻 Ghostty 配置

[Ghostty](https://ghostty.org) 是一个由 Zig 编写的高性能 GPU 加速终端模拟器。

### 安装

```bash
brew install --cask ghostty
```

### 配置位置

本 dotfiles 已将 Ghostty 配置链接到：

```
~/Library/Application Support/com.mitchellh.ghostty/config
```

### 配置文件

- **主配置**: `~/dotfiles/configs/ghostty/config`
- **本地覆盖**: `~/.config/ghostty/config.local`（不会被 git 追踪）

### 主题切换

查看所有可用主题：

```bash
ghostty +list-themes
```

编辑 `~/dotfiles/configs/ghostty/config` 修改主题：

```
# 使用单一主题
theme = Tokyo Night

# 根据系统外观自动切换
theme = light:"GruvboxLight",dark:"Tokyo Night"
```

### 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Cmd + T` | 新建标签页 |
| `Cmd + W` | 关闭当前 |
| `Cmd + D` | 垂直分屏 |
| `Cmd + Shift + D` | 水平分屏 |
| `Cmd + [` / `Cmd + ]` | 切换分屏 |
| `Cmd + Plus` | 放大字体 |
| `Cmd + Minus` | 缩小字体 |
| `Cmd + 0` | 重置字体 |
| `Cmd + Shift + Enter` | 最大化当前分屏 |

### 字体设置

默认使用 **Hack Nerd Font Mono**，确保已安装 Nerd Font：

```bash
brew install --cask font-hack-nerd-font
```

## 🖥️ Tmux 配置（AI 开发专用）

[Tmux](https://github.com/tmux/tmux) 是终端复用器，核心功能是**会话持久化**和**多终端共享**。

### 为什么 AI 开发需要 Tmux？

**场景：PyCharm + Ghostty 共享同一个 pi 实例**

```
PyCharm 终端 ──tmux attach──┐
                             ├──► 同一个 pi 进程
Ghostty ───────tmux attach──┘    (记忆自动同步!)
```

### 安装

```bash
brew install tmux
```

### 快速开始

```bash
# 创建新的 AI 开发会话
tmux-ai myproject

# 或者手动
# 在 Ghostty 中:
tmux new-session -s myproject
pi

# 在 PyCharm 终端中:
tmux attach -t myproject
# 现在两边看到的是同一个 pi！
```

### 核心快捷键

Tmux 使用 `Ctrl+a` 作为前缀键（比默认 `Ctrl+b` 更好按）：

#### 会话管理
| 快捷键 | 功能 |
|--------|------|
| `Ctrl+a c` | 新建窗口 |
| `Ctrl+a d` | detach（后台运行）|
| `Ctrl+a s` | 选择会话 |
| `Ctrl+a r` | 重命名会话 |

#### 分屏导航（类似 Ghostty）
| 快捷键 | 功能 |
|--------|------|
| `Ctrl+a \|` | 垂直分屏 |
| `Ctrl+a -` | 水平分屏 |
| `Ctrl+a h/j/k/l` | 切换分屏 |
| `Ctrl+a q` | 关闭分屏 |

#### 窗口切换（类似 Cmd+1..9）
| 快捷键 | 功能 |
|--------|------|
| `Ctrl+a 1-9` | 切换到窗口 1-9 |
| `Ctrl+a n` | 下一个窗口 |
| `Ctrl+a p` | 上一个窗口 |

### 常用命令

```bash
# 列出所有会话
tmux ls

# attach 到现有会话
tmux attach -t myproject

# 强制杀掉会话
tmux kill-session -t myproject

# 在 PyCharm 中查看共享的 pi 对话
tmux attach -t myproject
```

### 会话持久化示例

```bash
# 1. 在办公室 Ghostty 中
tmux new -s work
pi
> 正在帮我重构 auth 模块...
Ctrl+a d  # detach，pi 继续在后台运行

# 2. 回家后在 PyCharm 中
tmux attach -t work
> 继续之前的对话，pi 记得上下文！
```

### 配置文件

- **主配置**: `~/dotfiles/configs/tmux/tmux.conf`
- **快捷键**: 使用 `Ctrl+a` 代替 `Ctrl+b`
- **鼠标**: 已启用
- **颜色**: Tokyo Night 主题

## 🔄 更新

### 使用 setup.sh 更新

```bash
cd ~/dotfiles
./setup.sh update
./setup.sh install
```

### 手动更新

```bash
cd ~/dotfiles
git pull
source ~/.zshrc
```

### 更新工具

```bash
# 更新所有 Homebrew 包
brew update && brew upgrade

# 更新 Oh My Zsh
omz update
```

## 📄 文件结构

```
dotfiles/
├── README.md              # 本文件
├── install.sh             # 一键安装脚本 ⭐
├── setup.sh               # 配置管理脚本（符号链接方式）
├── macos.sh               # macOS 系统配置脚本
├── Brewfile               # Homebrew 依赖清单
├── configs/               # 配置文件
│   ├── .zshenv           # 环境变量
│   ├── .zshrc            # 主 zshrc（加载模块化配置）
│   ├── starship.toml     # Starship 提示符配置
│   ├── ghostty/          # Ghostty 终端配置
│   │   ├── config        # 主配置文件
│   │   └── themes/       # 自定义主题
│   ├── tmux/             # Tmux 配置
│   │   └── tmux.conf     # Tmux 主配置
│   └── .gitconfig        # Git 配置模板
├── zsh/                   # 模块化 zsh 配置 ⭐
│   ├── zshrc             # 主入口
│   ├── env.zsh           # 环境变量
│   ├── omz.zsh           # Oh My Zsh 配置
│   ├── tools.zsh         # 工具初始化
│   ├── aliases.zsh       # 别名
│   ├── functions.zsh     # 函数
│   ├── fzf.zsh           # fzf 配置
│   └── git.zsh           # Git 别名
├── scripts/               # 辅助脚本
└── .gitignore            # Git 忽略规则
```

### 使用 Brewfile

```bash
# 安装 Brewfile 中所有工具
brew bundle

# 检查哪些包需要安装
brew bundle check

# 清理不需要的包
brew bundle cleanup
```

## 🐛 常见问题

### 图标显示为方块或问号？

**原因**: 字体未正确设置

**解决**:
1. 确保安装了 Meslo Nerd Font
2. iTerm2 中设置字体为 MesloLGL Nerd Font
3. 勾选 "Use a different font for non-ASCII text"

### fzf 快捷键不起作用？

**原因**: fzf 未正确初始化

**解决**:
```bash
$(brew --prefix)/opt/fzf/install
source ~/.zshrc
```

### zoxide 不工作？

**原因**: 数据库为空

**解决**:
```bash
# 多使用 cd 命令，zoxide 会学习你的习惯
cd ~/some-directory
z some  # 之后可以用 z some 快速跳转
```

### 如何恢复原始配置？

```bash
# 安装脚本会自动备份到 ~/.dotfiles_backup_日期/
# 手动恢复
cp ~/.dotfiles_backup_xxxx/.zshrc ~/
cp ~/.dotfiles_backup_xxxx/.zshenv ~/
```

## 🤝 贡献

欢迎提交 Issue 和 PR！

## 📜 许可证

MIT License

## 🙏 致谢

- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles) - 优秀的 macOS 配置
- [keith/dotfiles](https://github.com/keith/dotfiles) - 模块化配置结构
- [Oh My Zsh](https://ohmyz.sh/)
- [Starship](https://starship.rs/)
- [Homebrew](https://brew.sh/)
- 所有开源工具的作者们

---

**Enjoy your new terminal!** 🎉
