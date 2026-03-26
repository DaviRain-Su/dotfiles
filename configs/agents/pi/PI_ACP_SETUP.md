# Pi + ACP 多 Agent 协调架构

基于 ACP (Agent Communication Protocol) 的分布式 AI Agent 系统。

## 架构设计

```
┌─────────────────────────────────────────────────────────────┐
│                      Pi (主控 Agent)                         │
│                    ACP Server / Hub                         │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ 任务解析器   │  │ 路由决策器   │  │ 结果聚合器          │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└────────────────────┬────────────────────────────────────────┘
                     │ ACP Protocol
        ┌────────────┼────────────┬────────────┐
        │            │            │            │
        ▼            ▼            ▼            ▼
┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐
│   Claude  │ │   Codex   │ │  Hermes   │ │   Droid   │
│  (架构/    │ │  (代码    │ │  (API/    │ │  (部署/   │
│   设计)    │ │   生成)   │ │   工具)   │ │   运维)   │
└───────────┘ └───────────┘ └───────────┘ └───────────┘
   ACP Client   ACP Client   ACP Client   ACP Client
```

## 工作流程

### 1. 任务路由规则

| 任务类型 | 目标 Agent | 触发关键词 |
|----------|-----------|-----------|
| 系统架构设计 | Claude | "设计架构", "重构", "模式" |
| 代码生成/修改 | Codex | "写代码", "实现", "修复bug" |
| API 调用/工具使用 | Hermes | "调用API", "查询", "工具" |
| 部署/CI/CD | Droid | "部署", "发布", "CI" |

### 2. 通信流程

```
1. 用户向 Pi 输入任务
   ↓
2. Pi 分析任务类型
   ↓
3. Pi 通过 ACP 发送任务到对应 Agent
   ↓
4. 子 Agent 执行任务
   ↓
5. 子 Agent 返回结果给 Pi
   ↓
6. Pi 整合结果并回复用户
```

## 实现方案

### 方案 A: 使用 pi-messenger (推荐)

pi-messenger 已经内置了多 Agent 协调功能：

```bash
# 1. 启动 Crew 模式
pi crew:start

# 2. Pi 自动分配任务给其他 Agent
# 在对话中使用 @agent 语法
```

### 方案 B: 自定义 ACP 路由脚本

创建一个 ACP 路由器脚本：

```bash
#!/bin/bash
# ~/.local/bin/acp-router

# ACP 消息格式
# {
#   "from": "pi",
#   "to": "claude|codex|hermes|droid",
#   "task": "...",
#   "context": {...}
# }

route_task() {
    local task="$1"
    local context="$2"
    
    # 关键词路由
    if echo "$task" | grep -qiE "(架构|设计|重构|模式)"; then
        echo "claude"
    elif echo "$task" | grep -qiE "(写代码|实现|修复|bug)"; then
        echo "codex"
    elif echo "$task" | grep -qiE "(API|调用|查询|工具)"; then
        echo "hermes"
    elif echo "$task" | grep -qiE "(部署|发布|CI|CD)"; then
        echo "droid"
    else
        echo "pi"  # 自己处理
    fi
}
```

### 方案 C: 使用 OpenClaw 工作流

OpenClaw 支持多 Agent 链式调用：

```yaml
# workflow.yml
name: multi-agent-dev
steps:
  - agent: pi
    task: analyze_requirements
    
  - agent: claude
    task: design_architecture
    input: ${steps.pi.output}
    
  - agent: codex
    task: implement_code
    input: ${steps.claude.output}
    
  - agent: droid
    task: deploy
    input: ${steps.codex.output}
```

## 快速开始

### 步骤 1: 配置 Pi 为 ACP Hub

在 `~/.pi/config.yaml` 中添加：

```yaml
acp:
  enabled: true
  mode: hub
  agents:
    - name: claude
      command: claude
      socket: /tmp/acp-claude.sock
    - name: codex
      command: codex
      socket: /tmp/acp-codex.sock
    - name: hermes
      command: hermes
      socket: /tmp/acp-hermes.sock
    - name: droid
      command: droid
      socket: /tmp/acp-droid.sock
```

### 步骤 2: 启动 ACP 服务

```bash
# 启动所有 Agent 作为 ACP Client
ai acp:start

# 或者单独启动
ai acp:start claude
ai acp:start codex
```

### 步骤 3: 使用多 Agent 对话

在 Pi 中：

```
> 帮我设计一个微服务架构，然后用 Python 实现用户服务，最后部署到 Kubernetes

Pi: 检测到多阶段任务，启动 ACP 协调...

[Claude] 正在设计架构...
  └─ 输出: 架构设计文档

[Codex] 正在实现代码...
  └─ 基于架构生成: user_service.py

[Droid] 正在准备部署...
  └─ 生成: k8s-deployment.yaml

Pi: 所有任务完成！已生成：
  - docs/architecture.md
  - src/user_service.py
  - deploy/k8s-deployment.yaml
```

## 在 dotfiles 中的集成

### 添加 ACP 管理命令

```bash
# ai acp 子命令
ai acp start       # 启动 ACP Hub
ai acp stop        # 停止所有 Agent
ai acp status      # 查看连接状态
ai acp route       # 手动路由任务
```

### 快捷别名

```bash
alias aacp='ai acp'
alias aacps='ai acp start'
alias aacpst='ai acp status'
```

## 下一步

你想先尝试哪种方案？

1. **使用 pi-messenger 的 Crew 模式** (最简单，已内置)
2. **创建自定义 ACP 路由脚本** (最灵活，完全可控)
3. **使用 OpenClaw 工作流** (最强大，支持复杂流程)
