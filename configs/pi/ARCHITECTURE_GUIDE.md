# Pi 主控架构设计指南

## 你的需求分析

- **Pi 作为主控** (Master)
- **团队成员**：其他 Agent (Claude, Codex, Droid, 或其他开发者)
- **通信方式**：？

## 关键问题：团队成员是什么？

### 情况 1: 团队成员是 "其他 Pi 实例"（多个开发者）

```
终端 1: Pi (你，主控)
终端 2: Pi (同事 A)
终端 3: Pi (同事 B)
```

**解决方案：用 pi-messenger** ✅

```typescript
// 终端 1 (你)
pi_messenger({ action: "join" })  // 成为 "SwiftRaven"
pi_messenger({ action: "send", to: "BlueWhale", message: "帮我 review 代码" })

// 终端 2 (同事)
pi_messenger({ action: "join" })  // 成为 "BlueWhale"
// 收到消息："帮我 review 代码"
```

**优点**：
- 实时通信
- 文件预订避免冲突
- 真正的团队协作

**缺点**：
- 所有成员必须是 Pi
- 不能和 Claude/Codex 直接通信

---

### 情况 2: 团队成员是 "外部 AI 工具" (Claude, Codex, Droid)

```
Pi (主控)
  ↓
外部工具：Claude Code CLI, Codex CLI, Droid CLI
```

**解决方案：用 Orchestrator（调用外部命令）** ✅

```typescript
// Pi 作为主控，调用外部工具
!pi-orchestrator simple claude "设计架构"
!pi-orchestrator simple codex "实现代码"
!pi-orchestrator simple droid "部署"

// 或直接用
!claude "设计"
!codex "编码"
```

**优点**：
- 使用真正的 Claude/Codex/Droid
- 不依赖对方支持任何协议

**缺点**：
- 不是实时协作
- 是"调用-返回"模式，不是"对话"模式

---

### 情况 3: 混合架构（推荐）

```
┌─────────────────────────────────────────────────────┐
│                  你 (用户)                           │
└─────────────────────┬───────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────┐
│              Pi (主控 Master)                        │
│  ┌──────────────┬──────────────┬─────────────────┐  │
│  │ pi-messenger │ orchestrator │ pi-subagents    │  │
│  └──────────────┴──────────────┴─────────────────┘  │
└──────────┬──────────────┬───────────────────────────┘
           │              │
    ┌──────┴──────┐      └──────┬────────┬────────┐
    ↓             ↓             ↓        ↓        ↓
其他 Pi 实例   其他 Pi 实例   Claude   Codex   Droid
(开发者 A)    (开发者 B)     CLI      CLI     CLI
```

**团队协作矩阵**：

| 对方是谁 | 用什么方式 | 命令示例 |
|---------|-----------|---------|
| 其他开发者运行 Pi | pi-messenger | `pi_messenger({ action: "send", to: "BlueWhale", message: "..." })` |
| Claude Code | orchestrator | `!pi-orchestrator simple claude "..."` |
| Codex | orchestrator | `!pi-orchestrator simple codex "..."` |
| Droid | orchestrator | `!pi-orchestrator simple droid "..."` |
| Pi 子代理 | pi-subagents | `/run scout "..."` |

---

## 回答你的问题

### 问题 1: pi-messenger 配置好了吗？

✅ **已安装和配置好**

```bash
# 检查
pi list | grep messenger  # 应该显示已安装
```

使用方式：
```typescript
pi_messenger({ action: "join" })
```

但注意：**pi-messenger 只能和 Pi 通信**，不能和 Claude/Codex/Droid 通信！

### 问题 2: 用 pi-messenger 还是 ACP？

**pi-messenger 就是 Pi 自己的 ACP-like 实现**：

| ACP 概念 | pi-messenger 实现 |
|---------|------------------|
| Agent Discovery | `pi_messenger({ action: "join" })` |
| Messaging | `pi_messenger({ action: "send" })` |
| File Locking | `pi_messenger({ action: "reserve" })` |
| Task Orchestration | `pi_messenger({ action: "plan/work" })` |

**但是**：pi-messenger 只能在 Pi 之间通信。

**Claude/Codex/Droid 不支持 pi-messenger**，因为它们不是 Pi。

---

## 推荐架构

基于你的需求（Pi 主控 + 团队协作），推荐：

### 架构：分层主从

```
Layer 1: 用户 (你)
    ↓
Layer 2: Pi (主控 Master)
    ├── 决策：分析任务，决定分配给哪个 Agent
    ├── 协调：管理执行顺序
    └── 整合：汇总结果
    ↓
Layer 3: 执行层
    ├── 其他 Pi 实例 (pi-messenger) ← 人-人协作
    ├── Claude CLI (orchestrator)    ← 调用 AI 工具
    ├── Codex CLI (orchestrator)     ← 调用 AI 工具
    └── Droid CLI (orchestrator)     ← 调用 AI 工具
```

### 实际工作流程

**场景：开发新功能**

```typescript
// 1. Pi 分析任务
"用户要我开发登录功能"

// 2. Pi 决策：先让 Claude 设计架构
!pi-orchestrator simple claude "设计用户认证架构，包括：\n1. 数据库表\n2. API 接口\n3. JWT 实现"

// 3. Pi 等待结果，读取输出
read claude_20240115_120000.md

// 4. Pi 决策：架构 OK，让 Codex 实现
!pi-orchestrator simple codex "基于以下架构实现代码：\n$(cat claude_20240115_120000.md)"

// 5. Pi 审查代码
/run reviewer "检查刚实现的认证代码"

// 6. 如果有多人协作，通知团队
pi_messenger({ action: "send", to: "all", message: "登录功能开发完成，等待 review" })
```

---

## 配置检查清单

### 如果你想用 pi-messenger（和其他 Pi 协作）

```bash
# 1. 确认安装
pi list | grep messenger

# 2. 在 Pi 中测试
pi_messenger({ action: "join" })

# 3. 打开另一个终端，同一目录
pi
pi_messenger({ action: "join" })

# 4. 发送消息测试
pi_messenger({ action: "send", to: "all", message: "测试" })
```

### 如果你想用 orchestrator（调用 Claude/Codex）

```bash
# 1. 确认 Claude/Codex 已安装
which claude
which codex

# 2. 在 Pi 中测试
!claude --version
!pi-orchestrator list
```

---

## 总结

| 场景 | 推荐方案 | 原因 |
|-----|---------|------|
| 和其他开发者协作 | pi-messenger | 实时通信，文件锁定 |
| 调用 Claude/Codex | orchestrator | 它们不支持 pi-messenger |
| Pi 内部任务分解 | pi-subagents | /run scout/planner/worker |

**pi-messenger ≠ 标准 ACP**，它是 Pi 自己的协议，只能在 Pi 之间用。

**真正的 ACP 协议**还在发展中，Claude/Codex 目前不支持。

所以你的架构应该是：
- **人-人协作**：pi-messenger
- **人-AI 工具**：orchestrator（调用 CLI）

需要我帮你配置哪种场景？
