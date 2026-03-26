# 🚀 快捷键速查表 (Cheat Sheet)

> 所有常用工具的快速参考，忘记命令时随时查看

---

## 👻 Ghostty 终端

### 基础操作
| 快捷键 | 功能 |
|--------|------|
| `Cmd+T` | 新建标签页 |
| `Cmd+W` | 关闭当前分屏/标签页 |
| `Cmd+N` | 新建窗口 |
| `Cmd+Q` | 完全退出 Ghostty |
| `Cmd+Shift+Enter` | **最大化当前分屏** |
| `Cmd+Shift+R` | 重命名标签页 |

### 分屏操作 (Splits)
| 快捷键 | 功能 |
|--------|------|
| `Cmd+D` | **垂直分屏** (左右) |
| `Cmd+Shift+D` | **水平分屏** (上下) |
| `Cmd+Shift+W` | **关闭当前分屏** |
| `Cmd+[` | 切换到左侧/上侧分屏 |
| `Cmd+]` | 切换到右侧/下侧分屏 |

### 字体调整
| 快捷键 | 功能 |
|--------|------|
| `Cmd++` | 放大字体 |
| `Cmd+-` | 缩小字体 |
| `Cmd+0` | 重置字体 |
| `Cmd+1~9` | 切换到第 N 个标签页 |

### 快速命令
```bash
# 查看所有主题
ghostty +list-themes

# 验证配置
ghostty +validate-config
```

---

## 🖥️ Tmux（终端复用器）

> **前缀键**: `Ctrl+A` (按住 Ctrl，按 A，然后松手，再按其他键)

### 会话管理
```bash
tmux ls                          # 列出所有会话
tmux new -s myproject            # 创建新会话
tmux attach -t myproject         # 连接到会话
tmux kill-session -t myproject   # 关闭会话

# 快捷脚本
tmux-ai myproject                # 一键创建并附加
```

### 窗口操作（前缀键 + 以下按键）
| 按键 | 功能 |
|------|------|
| `c` | **新建窗口** |
| `n` | 下一个窗口 |
| `p` | 上一个窗口 |
| `1~9` | 切换到窗口 1-9 |
| `,` | 重命名窗口 |
| `w` | 列出所有窗口 |
| `&` | 关闭当前窗口 |
| `d` | **detach（后台运行）** |
| `s` | 选择会话 |
| `r` | 重命名会话 |

### 分屏操作（前缀键 + 以下按键）
| 按键 | 功能 |
|------|------|
| `\|` | **垂直分屏** (左右) |
| `-` | **水平分屏** (上下) |
| `h/j/k/l` | 切换到左/下/上/右分屏 |
| `q` | 关闭当前分屏 |
| `z` | 最大化/恢复分屏 |

### 示例工作流
```bash
# 1. 创建会话并启动 pi
tmux new -s myproject
pi

# 2. 创建分屏查看日志
Ctrl+A |          # 垂直分屏

# 3. 切换到右侧分屏
Ctrl+A l

# 4. 运行日志
npm run dev

# 5. 回到左侧继续和 pi 对话
Ctrl+A h

# 6.  detach 让会话在后台运行
Ctrl+A d

# 7. 重新连接
tmux attach -t myproject
```

---

## 🤖 pi / pi Messenger

### 启动和基础
```bash
pi                               # 启动 pi
pi-messenger join                # 加入 mesh（在 pi 内）
```

### 快捷别名（已配置）
```bash
p                                # pi 的简写
pm                               # pi-messenger 的简写
pm-plan                          # pi-messenger plan
pm-work                          # pi-messenger work autonomous
pm-tasks                         # pi-messenger task list
```

### 核心命令（在 pi 内使用 `/messenger` 或 `pm`）

#### 规划任务
```bash
/messenger plan                          # 从 PRD 自动规划
/messenger plan prompt:"实现登录功能"    # 直接描述需求
```

#### 执行任务
```bash
/messenger work                          # 单波执行
/messenger work autonomous             # **自动模式（推荐）**
```

#### 查看任务
```bash
/messenger task list                     # 列出所有任务
/messenger task show task-1              # 查看任务详情
/messenger task ready                    # 查看可执行的任务
/messenger status                        # 整体状态
/messenger feed                          # 活动日志
```

#### 任务管理
```bash
/messenger task start task-1             # 开始任务
/messenger task done task-1 summary:"完成了 xxx"   # 标记完成
/messenger task reset task-1             # 重置任务
/messenger task block task-1 reason:"依赖未完成"   # 标记阻塞
```

### 工作流程示例
```bash
# 完整开发流程
$ cd ~/my-project
$ pi

> 帮我实现用户认证系统

# pi 自动规划...

> /messenger task list        # 查看生成的任务

> /messenger work autonomous  # 自动执行所有任务

> /messenger status           # 查看完成状态
```

---

## 🛠️ 常用命令行工具

### fzf（模糊查找）
| 快捷键 | 功能 |
|--------|------|
| `Ctrl+T` | **查找文件** |
| `Ctrl+R` | **查找历史命令** |
| `Alt+C` | **查找目录** |

```bash
# 示例
cat **<Ctrl+T>                    # 选择文件
cd **<Alt+C>                     # 选择目录
vim **<Ctrl+T>                   # 打开文件
```

### zoxide（智能跳转）
```bash
z foo                            # 跳转到包含 foo 的目录
z foo bar                        # 跳转到包含 foo 和 bar 的目录
zi                               # **交互式选择目录**（推荐）
z -                              # 回到上一个目录
zoxide query -l foo              # 列出匹配的目录
```

### lsd（带图标的 ls）
```bash
ls                               # 普通列表（已别名）
ls -la                           # 详细列表
lt                               # 树形显示（别名）
lsd --tree --depth 2             # 限制深度的树
```

### bat（语法高亮的 cat）
```bash
bat file.ts                      # 带语法高亮
bat file.ts --line-range 10:20   # 只显示 10-20 行
bat file.ts --diff               # 显示 diff
```

### lazygit（TUI Git 客户端）
```bash
lg                               # 启动 lazygit（已别名）
# 快捷键:
#   c = commit
#   p = push
#   P = pull
#   space = stage/unstage
#   d = discard
```

### btop（系统监控）
```bash
btop                             # 启动
# 快捷键:
#   1 = CPU
#   2 = Memory
#   3 = Network
#   4 = Disk
#   q = quit
```

---

## 📝 常用 Git 别名

```bash
gs                               # git status -sb
ga                               # git add
gaa                              # git add --all
gc "message"                     # git commit -m
gcm "message"                    # git commit -m
gca                              # git commit --amend
gp                               # git push
gpf                              # git push --force-with-lease
gl                               # git log --oneline --graph --all
gd                               # git diff
gds                              # git diff --staged
```

---

## 🔍 快速查找

### 在当前目录搜索
```bash
rg "pattern"                     # ripgrep 快速搜索
fd "*.ts"                        # fd 快速查找文件
```

### 文件内容替换
```bash
sd "old" "new" file.txt          # sd 替换（比 sed 简单）
```

### 进程管理
```bash
procs                            # 好看的 ps 替代
procs python                     # 查找 python 进程
```

---

## 💡 记忆技巧

### Ghostty
- **D** = **D**ivide（分屏）
- **W** = **W**ipe（关闭）
- `[` `]` = 左右箭头（切换分屏）

### Tmux
- **前缀 `Ctrl+A`** 后：
  - `|` = 竖线 = 垂直分屏
  - `-` = 横线 = 水平分屏
  - `c` = **c**reate（创建窗口）
  - `d` = **d**etach（分离）
  - `h/j/k/l` = vim 方向键（切换分屏）

### pi Messenger
- `plan` = 规划
- `work` = 执行
- `list` = 查看
- `status` = 状态

---

## 🆘 忘记命令时

1. **查看本文档**
   ```bash
   cat ~/dotfiles/CHEATSHEET.md
   ```

2. **工具自带帮助**
   ```bash
   ghostty +help                    # Ghostty 帮助
   tmux list-keys                   # Tmux 所有快捷键
   pi --help                        # pi 帮助
   ```

3. **模糊查找**
   ```bash
   # 按 Ctrl+R 查找历史命令
   # 输入关键词，自动匹配
   ```

---

**提示**：把这个文档放在手边，忘记时随时查看。用多了自然就记住了！
