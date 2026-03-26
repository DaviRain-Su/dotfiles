# pi-orchestrator 的真实实现（无 ACP）

## 重要澄清

**pi-orchestrator 完全没有使用 ACP 协议！**

它只是一个简单的 **Bash 脚本**，通过最原始的方式调用外部命令。

## 实际实现方式

```bash
# pi-orchestrator 的核心代码（简化）：

run_agent() {
    local agent=$1      # "claude" 或 "codex"
    local task=$2       # 任务描述
    local output_file=$3 # 输出文件
    
    # 创建临时脚本
    cat > "$temp_script" << 'SCRIPT'
#!/bin/bash
cd "$PWD"
echo "$TASK" | claude   # ← 就是这里！
SCRIPT
    
    # 执行并捕获输出
    "$temp_script" | tee "$output_file"
}
```

**仅此而已！**

## 与 ACP 的对比

| 特性 | pi-orchestrator | 真正的 ACP |
|------|-----------------|-----------|
| **实现方式** | Bash 脚本调用系统命令 | 标准化通信协议 |
| **Agent 发现** | 无（直接调用命令） | 服务发现机制 |
| **消息格式** | 无（直接传字符串） | 标准化的 ACP 消息格式 |
| **状态管理** | 无（一次调用） | 会话状态管理 |
| **能力协商** | 无 | Agent 能力声明与协商 |
| **安全性** | 无 | 身份验证、加密 |
| **互操作性** | 仅限本地 CLI | 跨平台、跨语言 |

## 实际流程

```
你 → Pi → pi-orchestrator
              ↓
         创建临时脚本
              ↓
         echo "任务" | claude   ← 直接管道调用
              ↓
         捕获输出到文件
              ↓
         Pi 读取文件
```

**没有协议，没有网络，就是简单的命令调用！**

## 为什么不用 ACP？

### 现状

**ACP 协议目前的状态**：
- Anthropic 提出了 ACP 概念（https://agentcommunicationprotocol.dev/）
- 但 **Claude Code 目前不支持 ACP**
- **Codex 目前不支持 ACP**
- 没有可用的 ACP 实现库
- 没有 ACP Server/Client SDK

###  Claude/Codex 实际支持的接口

| 工具 | 实际接口 | 说明 |
|------|---------|------|
| **Claude Code** | CLI 命令行 | `claude "prompt"` |
| **Codex** | CLI 命令行 | `codex "prompt"` |
| **Droid** | CLI 命令行 | `droid "prompt"` |
| **Pi** | CLI + 扩展 | `pi` + extensions |

**它们之间没有标准的协议通信方式！**

## pi-messenger vs ACP vs Orchestrator

| 方案 | 协议/方式 | 通信对象 | 复杂度 |
|------|----------|---------|--------|
| **pi-messenger** | Pi 自己的协议（类 ACP）| Pi ↔ Pi | 中等 |
| **pi-orchestrator** | 无协议，直接调用 CLI | Pi → CLI 工具 | 简单 |
| **真正的 ACP** | 标准 ACP 协议 | 任何 ACP Agent | 复杂（不可用） |

## 当前可行的方案

### 方案 1: 简单调用（pi-orchestrator）✅ 可用

```typescript
// Pi 调用外部 CLI
!claude "设计架构"
!codex "写代码"

// 或包装一下
!pi-orchestrator simple claude "设计架构"
```

**优点**：简单，直接，可用
**缺点**：无状态，无协商，单向调用

### 方案 2: pi-messenger ✅ 可用

```typescript
// Pi 和 Pi 通信
pi_messenger({ action: "join" })
pi_messenger({ action: "send", to: "BlueWhale", message: "..." })
```

**优点**：状态管理，文件锁定，实时通信
**缺点**：只能 Pi 和 Pi 通信

### 方案 3: 真正的 ACP ❌ 不可用

```typescript
// 理想状态（目前不存在）
acp_client.send({
  to: "claude-agent",
  capability: "code-review",
  payload: { code: "..." }
})
```

**状态**：协议草案阶段，无实际实现

## 诚实的建议

### 如果你想要"协议"级别的控制

**目前不可用**，因为：
1. Claude/Codex 不支持 ACP
2. 没有 ACP SDK
3. 标准还在制定中

### 如果你现在要工作

使用 **pi-orchestrator** 或 **直接调用 CLI**：

```typescript
// 简单直接的方式
!claude "设计用户认证系统"
!codex "实现登录功能"

// Pi 作为主控整合结果
/run scout "分析代码结构"
!claude "基于以上分析设计架构"
/run reviewer "检查 Claude 的设计"
```

### 如果你要团队协作

**人-人协作**：用 pi-messenger
**人-AI 协作**：用 CLI 调用

## 未来展望

当 ACP 真正落地时，架构会是：

```
Pi (ACP Client)
  ↓ ACP 协议
ACP Router/Hub
  ↓ ACP 协议
  ├── Claude (ACP Server)
  ├── Codex (ACP Server)
  └── Custom Agent (ACP Server)
```

**但目前（2025年）**：
- 没有 ACP Server 实现
- Claude/Codex 不是 ACP Server
- 只能用 CLI 调用

## 总结

| 问题 | 答案 |
|------|------|
| pi-orchestrator 用 ACP 吗？ | **否！** 只是 Bash 脚本调用 CLI |
| 有真正的 ACP 实现吗？ | **目前无**，还在草案阶段 |
| Claude/Codex 支持 ACP 吗？ | **不支持**，只有 CLI |
| 现在怎么办？ | 用 CLI 调用（pi-orchestrator 或直接 `!claude`） |

**pi-orchestrator 就是一个简单的包装器，让你更方便地调用外部 CLI 并捕获输出。**

没有协议，没有魔法，就是 `echo "任务" | claude` 这么简单！
