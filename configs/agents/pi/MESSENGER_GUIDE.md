# Pi Messenger 多 Agent 协调指南

Pi Messenger 是 Pi 的多 Agent 通信扩展，实现类似 ACP 协议的 Agent 间协作。

## 核心概念

```
┌─────────────────────────────────────────────────────────┐
│  Pi (主控) + pi-messenger                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐ │
│  │ 文件预订    │  │ 消息传递    │  │ 任务编排 (Crew) │ │
│  │ (reserve)   │  │ (send)      │  │ (plan/work)     │ │
│  └─────────────┘  └─────────────┘  └─────────────────┘ │
└────────────────────────┬────────────────────────────────┘
         │ ACP-like Protocol
    ┌────┴────┬─────────┬─────────┐
    ▼         ▼         ▼         ▼
┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐
│Claude │ │ Codex │ │Hermes │ │ Droid │
│(Agent)│ │(Agent)│ │(Agent)│ │(Agent)│
└───────┘ └───────┘ └───────┘ └───────┘
```

## 基础命令

### 1. 加入网络

```typescript
// 加入多 Agent 通信网络
pi_messenger({ action: "join" })
```

### 2. 文件预订 (避免冲突)

```typescript
// 预订文件/目录
pi_messenger({ 
  action: "reserve", 
  paths: ["src/auth/"], 
  reason: "重构认证模块" 
})

// 释放预订
pi_messenger({ action: "release" })
```

### 3. 发送消息

```typescript
// 给特定 Agent 发消息
pi_messenger({ 
  action: "send", 
  to: "SwiftRaven", 
  message: "认证模块已完成" 
})

// 广播给所有人
pi_messenger({ 
  action: "send", 
  to: "all", 
  message: "开始部署" 
})
```

## Crew 任务编排

### 从 PRD 自动规划任务

```typescript
// 1. 分析 PRD 并创建任务图
pi_messenger({ action: "plan" })

// 2. 自动执行所有任务（直到完成）
pi_messenger({ action: "work", autonomous: true })

// 3. 审查特定任务
pi_messenger({ action: "review", target: "task-1" })
```

### 手动创建任务

```typescript
// 不依赖 PRD，直接规划
pi_messenger({ 
  action: "plan", 
  prompt: "扫描代码库中的安全漏洞" 
})
```

## 使用场景

### 场景 1: 多 Agent 协作开发

```typescript
// Pi 作为主控，协调多个 Agent
pi_messenger({ action: "join" })

// 分配任务给 Claude (架构设计)
pi_messenger({ 
  action: "send", 
  to: "ClaudeAgent", 
  message: "请设计用户认证架构" 
})

// 等待完成后，分配给 Codex (代码实现)
pi_messenger({ 
  action: "send", 
  to: "CodexAgent", 
  message: "基于 Claude 的设计实现代码" 
})

// 最后分配给 Droid (部署)
pi_messenger({ 
  action: "send", 
  to: "DroidAgent", 
  message: "部署到生产环境" 
})
```

### 场景 2: 文件冲突避免

```typescript
// 开始工作前预订文件
pi_messenger({ 
  action: "reserve", 
  paths: ["src/auth/login.ts", "src/auth/register.ts"],
  reason: "重构登录注册逻辑"
})

// 其他 Agent 尝试修改这些文件时会收到警告：
// "文件已被 SwiftRaven 预订 (重构登录注册逻辑)"

// 完成后释放
pi_messenger({ action: "release" })
```

### 场景 3: 自动化工作流

```typescript
// 完整的多 Agent 工作流

// 1. 规划阶段
pi_messenger({ action: "plan" })

// 2. 并行执行（自动分配）
pi_messenger({ action: "work", autonomous: true })

// 3. 审查结果
pi_messenger({ action: "review", target: "task-auth" })
```

## 聊天界面

在 Pi 中输入：

```
/messenger
```

打开交互式聊天界面：

| 快捷键 | 功能 |
|--------|------|
| `Tab` / `←` `→` | 切换标签页 |
| `↑` `↓` | 滚动历史 |
| `@AgentName msg` | 私信 |
| `@all msg` | 广播 |
| `Enter` | 发送 |
| `Esc` | 关闭 |

## Crew Skills (领域知识)

Workers 可以动态加载领域知识：

### 项目级 Skill

创建 `.pi/messenger/crew/skills/api-patterns.md`:

```markdown
---
name: api-patterns
description: 本项目的 REST API 规范
---

# API 规范

- 认证: Bearer Token
- 分页: cursor-based `?after=`
- 错误格式: `{ error: { code, message } }`
```

### 用户级 Skill

创建 `~/.pi/agent/skills/rust-async/SKILL.md`:

```markdown
# Rust 异步编程

## 最佳实践
- 使用 tokio::spawn 创建任务
- 避免在 async 中阻塞
```

## 状态查看

```typescript
// 查看活跃 Agent 列表
pi_messenger({ action: "list" })

// 查看活动日志
pi_messenger({ action: "feed", limit: 20 })

// 查看谁在预订文件
pi_messenger({ action: "whois", name: "SwiftRaven" })

// 设置状态
pi_messenger({ action: "set_status", message: "正在重构..." })
```

## 快捷命令

我们已经为你添加了别名：

```bash
# 在 Pi 外查看 Messenger 状态
msg-status    # 显示活跃 Agent
msg-crew      # 显示 Crew 任务状态

# 在 Pi 内使用
/messenger    # 打开聊天界面
```

## 完整示例

### 微服务项目开发

```typescript
// 1. 加入网络并规划
pi_messenger({ action: "join" })
pi_messenger({ action: "plan" })  // 自动发现 PRD.md

// 2. 查看任务分配
// 系统会自动分配:
// - Claude: 设计微服务架构
// - Codex: 实现用户服务
// - Codex: 实现订单服务
// - Droid: 编写 K8s 配置

// 3. 开始自动执行
pi_messenger({ action: "work", autonomous: true })

// 4. 审查关键任务
pi_messenger({ action: "review", target: "task-auth-service" })

// 5. 完成后广播
pi_messenger({ 
  action: "send", 
  to: "all", 
  message: "微服务开发完成，准备部署" 
})
```

## 注意事项

1. **自动注册**: pi-messenger 会自动加入同一目录下的 Agent
2. **持久化**: 会话数据保存在 `.pi/messenger/` 目录
3. **无服务器**: 纯文件通信，无需额外服务器
4. **安全**: 只在本地文件系统通信，不经过网络

## 参考

- [pi-messenger GitHub](https://github.com/nicobailon/pi-messenger)
- [Crew 文档](https://github.com/nicobailon/pi-messenger#crew-task-orchestration)
