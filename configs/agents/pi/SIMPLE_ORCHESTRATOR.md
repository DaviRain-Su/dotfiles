# Pi 简单 Orchestrator - 主控模式

**核心理念**: Pi 做主控，直接调用其他 Agent，然后 Review。不需要复杂协议！

## 架构

```
你 (用户)
  │
  ▼
Pi (主控 Agent) ──→ 调用 Orchestrator ──→ 运行 Claude/Codex/Hermes
  │                                           │
  │◄────────────────── 输出文件 ◄─────────────┘
  │
  ▼
Pi Review 结果
  │
  ├── ✅ 满意 → 接受
  ├── ❌ 不满意 → 重新运行
  └── 🔧 需要修改 → 调整任务描述
```

## 三步工作流

### 第 1 步：Pi 委派任务

在 Pi 中直接运行：

```typescript
// 让 Claude 设计架构
!pi-orchestrator simple claude "设计一个用户认证系统，包含登录注册和 JWT"

// 或者让 Codex 写代码
!pi-orchestrator simple codex "实现一个 React 登录表单组件"

// 或者让 Hermes 查询 API
!pi-orchestrator simple hermes "查询 GitHub API 获取这个仓库的信息"
```

### 第 2 步：等待完成

Orchestrator 会自动：
1. 启动指定的 Agent (Claude/Codex/Hermes/Droid)
2. 传递任务
3. 捕获完整输出
4. 保存到文件

你会看到：
```
═══════════════════════════════════════════════════════════════
  Stage 1: 委派给 Claude Code
═══════════════════════════════════════════════════════════════

[Pi] 任务: 设计一个用户认证系统，包含登录注册和 JWT
[Pi] 输出: /Users/davirian/.pi/orchestrator/results/claude_20240115_120000.md

[Claude Code] 开始执行任务...

... (Claude 的输出) ...

[✓] Claude Code 任务完成

═══════════════════════════════════════════════════════════════
  Stage 2: Pi Review
═══════════════════════════════════════════════════════════════

[Pi] 正在审查 Claude Code 的输出...
[Pi] 文件: /Users/davirian/.pi/orchestrator/results/claude_20240115_120000.md

[Pi] 输出统计:
  - 行数: 156
  - 字符数: 4523
  - 文件: /Users/davirian/.pi/orchestrator/results/claude_20240115_120000.md

[!] ⚠️  检测到 TODO 标记

[✓] Review 准备完成

[Pi] 你可以在 Pi 中运行:
  read claude_20240115_120000.md
  然后进行人工 Review
```

### 第 3 步：Pi Review

在 Pi 中：

```typescript
// 读取结果文件
read claude_20240115_120000.md

// Pi 现在可以看到完整的 Agent 输出
// 你可以：
// - 要求修改："这个设计缺少密码重置功能，请补充"
// - 要求实现："基于这个设计，用 Codex 实现代码"
// - 直接接受："很好，继续下一步"
```

## 工作流模式

### 模式 1: 简单工作流 (最常用)

```typescript
// Pi → Agent → Review

!pi-orchestrator simple claude "设计系统架构"
// (等待完成)
read claude_20240115_120000.md
// Pi: "这个设计很好，但缺少缓存策略"

// 重新运行，补充要求
!pi-orchestrator simple claude "设计系统架构，包含 Redis 缓存策略"
```

### 模式 2: 并行工作流

```typescript
// Pi → [多个 Agent 同时] → Review

!pi-orchestrator parallel "分析这段代码的安全问题" claude codex
// Claude 和 Codex 同时分析
// 得到两份报告，Pi 综合 Review

read claude_20240115_120001.md
read codex_20240115_120002.md
// Pi: "Claude 发现了 SQL 注入，Codex 发现了 XSS，都要修复"
```

### 模式 3: 链式工作流

```typescript
// Pi → Agent1 → Agent2 → Review

!pi-orchestrator chain claude codex "创建一个电商网站"
// Step 1: Claude 设计架构
// Step 2: Codex 基于设计实现代码

read codex_20240115_120003.md
// Pi: "代码实现了设计，但缺少测试"
```

## 实际示例

### 示例 1: 从零开发功能

```typescript
// 1. 设计阶段
!pi-orchestrator simple claude "设计一个用户认证系统，包含：
  - 用户注册（邮箱验证）
  - 用户登录（JWT）
  - 密码重置
  - 使用 Node.js + Express + PostgreSQL"

// 2. Pi Review 设计
read claude_20240115_120000.md
// Pi: "设计很好，但缺少错误处理，我补充一下要求"

// 3. 重新设计（更详细）
!pi-orchestrator simple claude "设计用户认证系统，必须包含：
  - 详细的错误处理（400, 401, 403, 500）
  - 输入验证（email, password 强度）
  - 数据库表结构
  - API 端点文档"

// 4. 代码实现
!pi-orchestrator simple codex "基于以下设计实现代码：
$(cat claude_20240115_120001.md)"

// 5. Pi Review 代码
read codex_20240115_120002.md
// Pi: "代码实现了功能，但缺少单元测试"

// 6. 添加测试
!pi-orchestrator simple codex "为以下代码添加 Jest 单元测试：
$(cat codex_20240115_120002.md)"
```

### 示例 2: 代码审查

```typescript
// 让两个 Agent 同时审查代码
!pi-orchestrator parallel "审查 src/auth.js 的安全性和代码质量" claude codex

// 读取两份审查报告
read claude_20240115_120003.md
read codex_20240115_120004.md

// Pi 综合两份报告
// Pi: "Claude 发现了 SQL 注入风险，Codex 建议优化性能，
//      我决定先修复安全问题，再优化性能"

// 修复问题
!pi-orchestrator simple codex "修复以下代码的 SQL 注入问题：
$(cat src/auth.js)"
```

### 示例 3: 技术调研

```typescript
// 调研不同方案
!pi-orchestrator parallel "对比 REST 和 GraphQL 的优缺点" claude hermes

read claude_20240115_120005.md
read hermes_20240115_120006.md

// Pi: "Claude 从架构角度分析，Hermes 搜索了最新趋势，
//      结合来看，我们的项目更适合 REST"
```

## 对比 pi-messenger

| 特性 | pi-orchestrator | pi-messenger |
|------|-----------------|--------------|
| **复杂度** | ⭐ 简单 | ⭐⭐⭐ 复杂 |
| **Pi 角色** | 主控 (Master) | 协调者 (Coordinator) |
| **Agent 关系** | 主从 (Master-Slave) | 对等 (Peer-to-Peer) |
| **配置** | 零配置 | 需要配置网络 |
| **学习曲线** | 低 | 高 |
| **适用场景** | 个人工作流 | 团队协作 |

## 使用建议

### 什么时候用 pi-orchestrator？

✅ **适合**:
- 你一个人工作，Pi 做主控
- 想要简单直接的工作流
- 不需要复杂的 Agent 间通信
- 你来做最终 Review 和决策

❌ **不适合**:
- 多人协作（多个开发者同时）
- 需要 Agent 之间直接通信
- 复杂的任务依赖图

## 快捷命令

```bash
# 已经添加到你的 dotfiles
alias orch='pi-orchestrator'
alias orch-list='pi-orchestrator list'

# 使用
orch simple claude "设计架构"
orch parallel "分析代码" claude codex
orch chain claude codex "开发功能"
```

## 文件位置

```
~/.pi/orchestrator/
├── results/          # Agent 输出文件
│   ├── claude_20240115_120000.md
│   ├── codex_20240115_120001.md
│   └── ...
└── logs/            # 运行日志
```

## 总结

**核心思想**: 保持简单！

1. Pi 做主控
2. Orchestrator 帮忙调用其他 Agent
3. Agent 输出到文件
4. Pi 读取文件 Review
5. Pi 决定下一步

没有复杂的协议，没有网络配置，就是简单的文件交换！
