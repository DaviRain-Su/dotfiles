# 🚀 macOS 终端环境配置

一键配置美观、高效的 macOS 终端开发环境。

![Terminal Preview](https://user-images.githubusercontent.com/placeholder/terminal-preview.png)

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

## 📦 包含工具

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

## 🚀 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/DaviRain-Su/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. 运行安装脚本

```bash
chmod +x install.sh
./install.sh
```

### 3. 重启终端或执行

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

| 别名 | 命令 | 说明 |
|------|------|------|
| `ls` | `lsd --icon=always --icon-theme=unicode` | 带图标的文件列表 |
| `l` | `lsd --icon=always --icon-theme=unicode -lF` | 详细列表 |
| `la` | `lsd --icon=always --icon-theme=unicode -a` | 显示隐藏文件 |
| `ll` | `lsd --icon=always --icon-theme=unicode -lh` | 长格式 |
| `lt` | `lsd --icon=always --icon-theme=unicode --tree` | 树形显示 |
| `cat` | `bat --paging=never --style=plain` | 语法高亮 |
| `catl` | `bat` | 带行号和分页 |
| `cd` | `z` | 智能目录跳转 |
| `zi` | `z -i` | 交互式选择目录 |
| `grep` | `rg` | 快速搜索 |
| `find` | `fd` | 快速查找 |
| `top` | `btop` | 系统监控 |
| `htop` | `btop` | 系统监控 |
| `lg` | `lazygit` | TUI Git 客户端 |
| `help` | `tldr` | 简化帮助 |
| `http` | `xh` | HTTP 请求 |

### Git 别名

| 别名 | 命令 |
|------|------|
| `gs` | `git status` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gp` | `git push` |
| `gl` | `git log --oneline --graph` |
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `fbr` | `git branch \| fzf \| xargs git checkout` |
| `fco` | `git log --oneline \| fzf ...` |

### 目录导航

| 别名 | 命令 |
|------|------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |

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

## ⚙️ 自定义配置

### 修改提示符

编辑 `~/.config/starship.toml`：

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

编辑 `~/.zshrc`：

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

导入方法：
1. iTerm2 → Preferences → Profiles → Colors
2. Color Presets → Import
3. 选择下载的 `.itermcolors` 文件

### 3. 窗口设置

Preferences → Profiles → Window:
- Transparency: **10-15**（轻微透明）
- Blur: **10-20**（毛玻璃效果）

## 🔄 更新

### 更新本仓库

```bash
cd ~/dotfiles
git pull
./install.sh
```

### 更新工具

```bash
# 更新所有 Homebrew 包
brew update && brew upgrade

# 更新 Oh My Zsh
omz update
```

## 📝 手动安装（如果不想用脚本）

```bash
# 安装 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装工具
brew install starship lsd bat fzf zoxide ripgrep fd delta lazygit btop tlrc thefuck xh

# 安装字体
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font

# 安装 Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 安装插件
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

# 配置 fzf
$(brew --prefix)/opt/fzf/install

# 复制配置
cp configs/.zshrc ~/
cp configs/starship.toml ~/.config/

# 生效
source ~/.zshrc
```

## 📄 文件结构

```
dotfiles/
├── README.md              # 本文件
├── install.sh             # 一键安装脚本
├── configs/
│   ├── .zshrc            # Zsh 配置（别名、工具初始化）
│   └── starship.toml     # Starship 提示符配置
└── .gitignore            # Git 忽略规则
```

### 配置文件说明

#### `.zshrc`

- Oh My Zsh 配置
- 插件列表（git, zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions）
- 工具初始化（zoxide, fzf, thefuck, starship）
- 36+ 个别名
- API Keys 环境变量

#### `starship.toml`

- 紧凑的提示符布局
- Emoji 图标（🏠, ⏱️, 🕐）
- Git 状态显示
- 命令执行时间
- 禁用不需要的模块

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
# 安装脚本会自动备份到 ~/.config_backup_日期/
# 手动恢复
cp ~/.config_backup_xxxx/.zshrc ~/
cp ~/.config_backup_xxxx/starship.toml ~/.config/
```

## 🤝 贡献

欢迎提交 Issue 和 PR！

## 📜 许可证

MIT License

## 🙏 致谢

- [Oh My Zsh](https://ohmyz.sh/)
- [Starship](https://starship.rs/)
- [Homebrew](https://brew.sh/)
- 所有开源工具的作者们

---

**Enjoy your new terminal!** 🎉
