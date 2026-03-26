# Ghostty + AI Code Agent 协作工作流

## 推荐的窗口布局

### 布局 1: 左右分屏 (标准开发)

```
┌─────────────────────────┬─────────────────────────┐
│  Split 1: Code Agent    │  Split 2: Terminal      │
│  (pi / Claude)          │  (git, npm, docker)     │
│                         │                         │
│  ~/project $ pi         │  ~/project $ git diff   │
│  > 编辑文件             │  > 运行测试             │
│                         │                         │
│  特点:                  │  特点:                  │
│  - 保持对话上下文       │  - 不干扰 Agent         │
│  - 专注编码             │  - 随时执行命令         │
└─────────────────────────┴─────────────────────────┘
```

快捷键:
- `Cmd+D` - 垂直分屏
- `Cmd+[` / `Cmd+]` - 切换分屏

### 布局 2: 三窗格 (高级)

```
┌───────────────────┬───────────────────┐
│   Split 1         │   Split 2         │
│   Claude Code     │   Files/Logs      │
│   (主要工作)      │   (ls, tail)      │
│                   │                   │
├───────────────────┴───────────────────┤
│   Split 3                             │
│   Build/Deploy                        │
│   (npm run build, git push)           │
└───────────────────────────────────────┘
```

创建方式:
1. `Cmd+D` - 左右分屏
2. 在右侧按 `Cmd+Shift+D` - 下方再分

## 多 Agent 实例管理

### 问题
同时运行多个 pi/Claude 会导致:
- 重复编辑同一个文件
- 上下文混乱
- API 费用增加

### 解决方案

#### 方案 A: 单 Agent + 多辅助终端

```bash
# Split 1: 唯一的 Agent 实例
$ pi

# Split 2: 普通终端 - 运行命令
$ npm test
$ docker ps
$ curl localhost:3000

# Split 3: 文件浏览
$ ls -la
$ bat src/main.ts
```

#### 方案 B: 不同 Agent 负责不同模块

```bash
# Split 1: 后端开发
$ cd backend && pi

# Split 2: 前端开发  
$ cd frontend && pi

# 注意：两个 pi 独立工作，不共享上下文
# 适合前后端分离的项目
```

#### 方案 C: 使用 Aider (多文件协作)

```bash
# 所有分屏共享同一个 Aider 会话
# 因为 Aider 使用文件作为状态存储

# Split 1
$ aider

# Split 2 (同一目录)
$ aider
# Aider 会读取 .aider.chat.history.md
# 基本同步状态
```

## 实用 Ghostty 配置

添加到 `~/.config/ghostty/config.local`:

```
# 编码专用快捷键
# 快速打开当前项目的 pi
keybind = cmd+shift+p=text:cd $(pwd) && pi\r

# 快速分屏并进入相同目录
keybind = cmd+shift+d=new_split:right,cwd=current

# 切换分屏焦点
keybind = cmd+h=goto_split:left
keybind = cmd+l=goto_split:right
keybind = cmd+j=goto_split:down
keybind = cmd+k=goto_split:up
```

## 工具组合推荐

| 任务 | 主分屏 | 辅助分屏 | 工具 |
|-----|-------|---------|-----|
| Web 开发 | pi/Claude | npm/vite | `npm run dev` |
| Docker 开发 | pi | docker logs | `docker-compose logs -f` |
| API 调试 | pi | httpie | `xh :3000/api` |
| 数据库 | pi | pgcli | `pgcli postgresql://...` |
| 代码审查 | pi | lazygit | `lg` |

## 避免冲突的最佳实践

1. **一个 Agent 负责一个文件** - 避免多 Agent 同时编辑
2. **Split 2 只做只读操作** - git status, cat, ls, 测试
3. **使用 tmux 共享会话** - 如果需要完全同步
4. **定期 commit** - 让 Agent 能看到最新代码状态

## 快速启动工作区

创建一个脚本 `~/bin/coding`:

```bash
#!/bin/bash
# 启动 Ghostty 编码工作区

PROJECT=${1:-.}
cd "$PROJECT" || exit 1

# 启动 Ghostty 并自动分屏
ghostty \
  --window-width=160 \
  --window-height=45 \
  --command="zsh -c 'pi; zsh'" &

sleep 1

# 分屏并启动辅助终端
# 注意: Ghostty 目前不支持 CLI 分屏，需要手动 Cmd+D
```

然后:
```bash
chmod +x ~/bin/coding
coding ~/my-project
```
