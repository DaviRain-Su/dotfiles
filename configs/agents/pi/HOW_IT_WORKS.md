# Pi 扩展工作原理 - 澄清误解

## 重要澄清

### ❌ 错误理解
```
你 → Pi → pi-subagents → 调用系统 Claude/Codex 命令
```

### ✅ 正确理解
```
你 → Pi → pi-subagents → 启动 Pi 子代理（还是 Pi！）
                              ↓
                    使用特定模型（如 Haiku）
                    使用特定工具（如只有 read/grep）
                    使用特定提示词（如 "You are a scout"）
```

## pi-subagents 到底是什么？

**pi-subagents 在 Pi 内部创建"角色"**，让 Pi 扮演不同的专家：

| 子代理 | Pi 扮演的角色 | 配置 |
|--------|--------------|------|
| **scout** | 代码探索专家 | 轻量级模型 (Haiku)，工具: read/grep/find |
| **planner** | 架构设计专家 | 强模型 (Opus)，工具: read/write/bash |
| **worker** | 代码实现专家 | 中等模型 (Sonnet)，工具: 全套工具 |
| **reviewer** | 代码审查专家 | 强模型 (Opus)，专注找问题 |

**都是 Pi 在运行，只是配置不同！**

## 对比

| 方式 | 调用什么 | 例子 |
|------|---------|------|
| **pi-subagents** | Pi 自己的子会话 | `/run scout` = Pi 用 Haiku 模型扫描代码 |
| **系统命令** | 外部程序 | `!claude` 或 `!codex` = 调用系统安装的 CLI |
| **pi-messenger** | 其他 Pi 实例 | `pi_messenger({ action: "send" })` = 发给另一个终端的 Pi |

## 实际流程

### 当你输入 `/run scout "分析代码"`

```
1. Pi 主会话：你输入命令
   ↓
2. pi-subagents 插件：解析命令，加载 scout 配置
   ↓
3. Pi 创建子会话：
   - 模型切换到 claude-haiku-4-5（轻量级）
   - 工具限制为 read/grep/find/ls/bash/write
   - 系统提示词设为 "You are a scout..."
   ↓
4. 子会话运行：分析代码，生成结果
   ↓
5. 结果返回：显示在你的主会话中
```

**整个过程都在 Pi 内部，没有调用外部程序！**

## 那怎么调用真正的 Claude/Codex？

如果你要调用系统安装的 Claude 或 Codex，用：

```typescript
// 方法 1: 直接运行系统命令（在 Pi 中）
!claude "设计架构"
!codex "实现代码"

// 方法 2: 使用我创建的 orchestrator
!pi-orchestrator simple claude "设计架构"

// 方法 3: 使用 sesh 分屏
!ai sesh claude  # 左边 Claude，右边 lazygit
```

## pi-messenger 又是什么？

pi-messenger 让**多个 Pi 实例**互相通信：

```
终端 1: pi → pi_messenger({ action: "join" }) → 成为 "SwiftRaven"
                              ↓
终端 2: pi → pi_messenger({ action: "join" }) → 成为 "BlueWhale"
                              ↓
SwiftRaven 可以发消息给 BlueWhale
```

**是两个独立的 Pi 进程在聊天！**

## 总结

| 工具 | 是什么 | 用来干嘛 |
|------|--------|----------|
| **pi-subagents** | Pi 内部的角色扮演 | 让 Pi 用不同配置做不同任务 |
| **pi-messenger** | Pi 实例间的通信 | 多终端 Pi 协作 |
| **!claude/!codex** | 调用外部 CLI | 使用真正的 Claude/Codex |

## 推荐工作流

### 方案 1: 纯 Pi 生态（pi-subagents）

```typescript
// 用 Pi 的子代理完成整个任务
/chain scout -> planner -> worker

优点：流畅，Pi 自己协调
缺点：都是 Pi 在跑，没有真正的 Claude/Codex 参与
```

### 方案 2: 混合使用（推荐）

```typescript
// 1. 用 Pi 的 scout 快速探索
/run scout "分析代码库结构"

// 2. 用真正的 Claude 做设计
!claude "基于以上分析，设计系统架构"

// 3. 用真正的 Codex 写代码
!codex "基于设计实现代码"

// 4. 用 Pi 的 reviewer 检查
/run reviewer "检查刚写的代码"
```

### 方案 3: 用我的 orchestrator

```typescript
// Pi 做主控，调用外部 Agent
!pi-orchestrator simple claude "设计架构"
!pi-orchestrator simple codex "实现代码"

优点：Pi 完全掌控，明确知道哪个 Agent 在跑
```

## 你现在明白了吗？

- `/run scout` = **Pi 自己**扮演唱代码探索专家
- `!claude` = **调用外部**的 Claude Code CLI
- `pi_messenger` = **另一个终端**的 Pi 实例

想用什么方式？
