# Pi Subagents 子代理委托指南

**pi-subagents** 是 Pi 的任务委托扩展，支持链式、并行、异步子代理执行。

## 与 pi-messenger 的区别

| 特性 | pi-messenger | pi-subagents |
|------|-------------|--------------|
| **定位** | 多 Agent 之间协调 | Pi 委托给子代理 |
| **通信** | Agent ↔ Agent | Pi → Subagent |
| **执行** | 并行任务编排 | 链式/并行/异步 |
| **场景** | 团队协作 | 任务分解 |

**最佳组合**: pi-subagents 处理复杂任务分解，pi-messenger 协调多 Agent 结果。

## 安装

```bash
pi install npm:pi-subagents
```

如需 MCP 工具支持（可选）：
```bash
pi install npm:pi-mcp-adapter
```

如需网页搜索（可选）：
```bash
pi install npm:pi-web-access
```

## 核心概念

```
Pi (主控)
    │
    ├── /run scout "扫描代码"              # 单代理执行
    │
    ├── /chain scout -> planner -> coder   # 链式执行
    │       (输出1 → 输入2 → 输出2 → 输入3)
    │
    ├── /parallel scout1 -> scout2         # 并行执行
    │       (同时启动，各自独立)
    │
    └── --bg                               # 异步执行
            (后台运行，完成后通知)
```

## 快速开始

### 1. 查看内置 Agents

```bash
/agents
```

打开 Agents Manager 界面，显示：
- **scout** - 快速代码库扫描
- **planner** - 任务规划
- **worker** - 代码实现
- **reviewer** - 代码审查
- **context-builder** - 上下文构建
- **researcher** - 网页搜索研究
- **delegate** - 通用委托

### 2. 单代理执行

```bash
# 基础语法
/run scout "扫描代码库，找出所有 API 端点"

# 指定输出文件
/run scout[output=endpoints.md] "找出所有 API 端点"

# 使用特定模型
/run scout[model=anthropic/claude-sonnet-4] "扫描代码"
```

### 3. 链式执行

```bash
# 基础链式
/chain scout "扫描认证模块" -> planner "设计重构方案" -> worker "实现代码"

# 简写（只给第一个任务，后续自动传递）
/chain scout -> planner -> worker -- 重构认证系统

# 每步自定义
/chain scout[output=context.md] -> planner[reads=context.md,model=claude-opus-4] -> worker
```

### 4. 并行执行

```bash
# 同时扫描前后端
/parallel scout "扫描前端代码" -> scout "扫描后端代码"

# 并行审查
/parallel reviewer "检查安全性" -> reviewer "检查性能" -> reviewer "检查风格"
```

### 5. 异步执行

```bash
# 后台运行大型任务
/run scout "完整安全审计" --bg

# 后台链式
/chain scout -> planner -> worker -- 重构整个系统 --bg

# 查看状态
subagent_status
```

## Agent 配置

### Agent 文件位置

```
~/.pi/agent/agents/
├── scout.md          # 用户级 (最高优先级)
├── planner.md
└── worker.md

.pi/agents/           # 项目级 (更高优先级)
└── custom-worker.md

~/.pi/agent/extensions/subagent/agents/  # 内置 (最低优先级)
├── scout.md
├── planner.md
└── ...
```

### 创建自定义 Agent

创建 `~/.pi/agent/agents/rust-expert.md`:

```markdown
---
name: rust-expert
description: Rust 代码审查专家
tools: read, grep, find, bash
model: anthropic/claude-sonnet-4
skill: rust-async, rust-unsafe
output: rust-review.md
---

你是一个 Rust 专家。审查代码时关注：
1. 内存安全（所有权、生命周期）
2. 并发安全（Send/Sync）
3. 性能优化机会
4. 错误处理完整性

输出格式：
- [安全] 发现的安全问题
- [性能] 优化建议
- [风格] 代码风格问题
```

### Agent Frontmatter 详解

```yaml
---
name: agent-name              # Agent 标识
description: 描述              # 显示在列表中

# 工具配置
tools: read, grep, bash       # 可用工具
                               # mcp:server-name 添加 MCP 工具

# 扩展控制
extensions:                   # 不指定 = 加载所有
extensions:                   # 空 = 不加载任何
extensions: /path/to/ext.ts   # 指定加载

# 模型配置
model: claude-sonnet-4-6      # 默认模型
thinking: high                # 思考级别: off/minimal/low/medium/high/xhigh

# 技能注入
skill: skill-a, skill-b       # 加载的技能

# 输出配置
output: result.md             # 自动写入文件
defaultReads: context.md      # 启动时读取的文件
defaultProgress: true         # 维护 progress.md

# 交互配置
interactive: true             # 允许交互
---
```

## 实际工作流示例

### 示例 1: 新功能开发

```typescript
// 用户：添加用户认证功能

// 1. 并行探索代码库
/parallel scout "分析现有用户模型" -> scout "查找认证中间件"

// 2. 设计阶段
/run planner[output=auth-plan.md] "基于探索结果设计认证架构"

// 3. 实现阶段（链式）
/chain worker "实现登录 API" -> worker "实现注册 API" -> worker "实现 JWT 中间件"

// 4. 审查阶段（并行）
/parallel reviewer "检查安全性" -> reviewer "检查代码风格"
```

### 示例 2: Bug 修复

```typescript
// 用户：修复登录 bug

// 快速诊断
/run scout "查找登录相关的所有代码和错误处理"

// 修复
/run worker "根据 scout 的输出修复 bug"

// 验证
/run reviewer "检查修复是否正确"
```

### 示例 3: 代码重构

```typescript
// 用户：重构整个模块

// 异步执行大型重构
/chain scout -> planner -> worker[output=refactor-plan.md] -- 重构认证模块 --bg

// 继续其他工作...

// 稍后检查结果
subagent_status
```

### 示例 4: 技术研究

```typescript
// 使用 researcher（需要 pi-web-access）
/run researcher "研究最新的 React Server Components 最佳实践"

// 整理成文档
/run context-builder "将研究结果整理成技术文档"
```

## 高级技巧

### 1. 上下文传递

```bash
# 显式传递文件
/chain scout[output=a.md] -> planner[reads=a.md,output=b.md] -> worker[reads=b.md]

# 隐式传递（使用 {previous}）
/chain scout -> planner -> worker
# scout 输出 → planner 输入 → planner 输出 → worker 输入
```

### 2. Fork 上下文

```bash
# 不污染主会话的上下文
/run reviewer "审查这个 PR" --fork
```

### 3. 模型切换

```bash
# 某步使用更强的模型
/chain scout -> planner[model=claude-opus-4-6] -> worker
```

### 4. 组合使用 pi-messenger

```typescript
// 1. 使用 subagents 完成任务
/chain scout -> planner -> worker -- 实现功能

// 2. 使用 messenger 通知团队
pi_messenger({ 
  action: "send", 
  to: "all", 
  message: "功能实现完成，等待 review" 
})

// 3. 预订文件进行 review
pi_messenger({ action: "reserve", paths: ["src/feature/"] })
```

## 快捷命令汇总

| 命令 | 说明 |
|------|------|
| `/agents` | 打开 Agent 管理器 |
| `/run agent "task"` | 单代理执行 |
| `/chain a -> b -> c` | 链式执行 |
| `/parallel a -> b` | 并行执行 |
| `--bg` | 后台执行 |
| `--fork` | Fork 上下文 |
| `[output=x.md]` | 指定输出 |
| `[reads=x.md]` | 指定输入 |
| `[model=x]` | 指定模型 |
| `subagent_status` | 查看状态 |

## 参考

- [pi-subagents GitHub](https://github.com/nicobailon/pi-subagents)
- [pi-mcp-adapter](https://github.com/nicobailon/pi-mcp-adapter) - MCP 支持
- [pi-web-access](https://github.com/nicobailon/pi-web-access) - 网页搜索
