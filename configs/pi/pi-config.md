# Pi-Centric AI 开发工作流

> 核心理念：**所有操作通过 pi 完成，pi 协调所有 Agent**

## 架构对比

### ❌ 旧方式（多窗口混乱）
```
PyCharm ──► pi (Planner)
     │
     └──► 手动复制 plan ──► Ghostty ──► Codex 执行
                              │
                              └──► 结果手动同步回 PyCharm
```

问题：
- 多窗口切换
- 状态手动同步
- 容易出错

### ✅ 新方式（Pi-Centric）
```
Ghostty ──► pi ──► pi Messenger ──► crew-planner (规划)
                     │
                     ├──► crew-worker + Claude (执行 A)
                     ├──► crew-worker + Codex (执行 B)
                     └──► opencode-agent (执行 C)
                     │
                     └──► 结果汇总返回给你
```

优势：
- 单一入口
- 自动协调
- 状态统一

## 快速开始

### 1. 启动 pi 并加入 mesh

```bash
# 在项目目录
cd ~/my-project
pi

# 在 pi 内部
/messenger join
```

### 2. 让 pi 规划任务

```bash
# 方式 1: 从 PRD 规划
/messenger plan

# 方式 2: 直接描述需求
/messenger plan prompt:"实现用户认证系统，包括登录、注册、JWT"
```

### 3. 自动执行

```bash
# 自动模式（推荐）
/messenger work autonomous

# pi 会自动：
# - 创建 planner agent 分析需求
# - 创建多个 worker agents 并行执行
# - 协调依赖关系
# - 汇总结果
```

### 4. 查看进度

```bash
/messenger task list      # 查看所有任务
/messenger status         # 查看整体状态
/messenger feed           # 查看活动日志
```

## 核心工作流程

### 场景 1：复杂功能开发

```bash
$ pi

# 你输入
> 帮我实现一个支持 OAuth2 的用户系统

# pi 自动处理：
# 1. crew-planner 分析需求，拆解任务
# 2. 创建 subtasks:
#    - task-1: 数据库模型设计 (crew-worker + Claude)
#    - task-2: OAuth2 集成 (crew-worker + Codex)
#    - task-3: 前端登录界面 (opencode-agent)
# 3. 按依赖顺序执行
# 4. 返回完整实现
```

### 场景 2：多 Agent 并行执行

```bash
# 配置多模型
~/.pi/agent/pi-messenger.json:
{
  "crew": {
    "concurrency": { "workers": 4 },
    "models": {
      "worker": "claude-haiku-4-5",      // 快速任务
      "claude": "claude-sonnet-4-6",     // 复杂逻辑
      "codex": "codex-latest"            // 代码生成
    }
  }
}

# pi 会根据任务类型自动选择 Agent
```

### 场景 3：人在回路中

```bash
# 自动执行，但关键步骤需要确认
/messenger work autonomous

# 当遇到：
# - 破坏性操作
# - 需要 API Key
# - 不明确的需求
# pi 会暂停并询问你

# 你在同一个 pi 会话中回复
> 确认执行 / 修改需求 / 跳过这个任务
```

## 为什么不需要 tmux/多窗口了？

| 需求 | 旧方案 | 新方案 |
|------|--------|--------|
| 看任务列表 | 打开另一个终端 | `/messenger task list` |
| 查看执行日志 | 切换到分屏 | `/messenger feed` |
| 多个 Agent 并行 | 开多个窗口 | pi 自动并行调度 |
| 状态同步 | 手动复制 | pi 自动协调 |

## 可选：保留 tmux 作为备选

虽然主要工作流不需要 tmux，但可以保留用于：

```bash
# 场景：你需要在后台跑长时间任务，同时做其他事

# 窗口 1: pi 主会话（主要工作）
tmux new -s main
pi
> 开始一个长任务

# detach (Ctrl+a d)，任务在后台继续

# 窗口 2: 快速命令
# 直接在 Ghostty 新建标签页做其他事
```

## 实际配置

### 1. 配置 pi 使用多 Agent

```bash
# 创建配置文件
mkdir -p ~/.pi/agent

cat > ~/.pi/agent/pi-messenger.json << 'EOF'
{
  "crew": {
    "concurrency": {
      "workers": 3,
      "max": 6
    },
    "coordination": "chatty",
    "models": {
      "planner": "claude-opus-4-6",
      "worker": "claude-haiku-4-5",
      "reviewer": "claude-opus-4-6"
    }
  }
}
EOF
```

### 2. 创建快捷别名

```bash
# 添加到 ~/.zshrc.local
alias p='pi'
alias pm='pi-messenger'
alias pm-plan='pi-messenger plan'
alias pm-work='pi-messenger work autonomous'
alias pm-tasks='pi-messenger task list'
alias pm-status='pi-messenger status'
```

### 3. Ghostty 配置优化（单窗口模式）

```bash
# ~/.config/ghostty/config.local
# 简化配置，主要用 pi

# 大字体，专注编码
font-size = 15

# 不需要复杂分屏快捷键
# 保留基本的 Cmd+T 新建标签页

# 快速打开 pi
keybind = cmd+shift+p=text:pi\r
```

## 工作流程示例

### 完整开发流程

```bash
# 1. 进入项目
cd ~/my-project

# 2. 启动 pi（唯一入口）
pi

# 3. 规划需求
> /messenger plan prompt:"实现购物车功能"

# 4. 查看生成的任务
> /messenger task list

# 5. 开始自动执行
> /messenger work autonomous

# 6. pi 自动协调多个 Agent 完成所有任务

# 7. 查看结果
> /messenger task list
# 所有任务完成 ✓
```

### 调试流程

```bash
# 如果某个任务失败
> /messenger task show task-3
# 查看错误详情

# 手动修复后标记完成
> /messenger task done task-3 summary:"手动修复了数据库连接问题"

# 继续执行剩余任务
> /messenger work autonomous
```

## 总结

**核心转变**：
- 从「人管理多个 Agent」→「pi 管理多个 Agent」
- 从「多窗口操作」→「单入口对话」
- 从「手动同步状态」→「自动协调」

**你的新工作流**：
```
Ghostty (单窗口)
    └── pi (统一入口)
         └── pi Messenger (协调层)
              ├── crew-planner (规划)
              ├── crew-worker + Claude (执行)
              ├── crew-worker + Codex (执行)
              └── opencode-agent (执行)
```

**只需要记住的命令**：
- `pi` - 启动
- `/messenger plan` - 规划
- `/messenger work autonomous` - 执行
- `/messenger task list` - 查看状态
