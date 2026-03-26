# Pi 生态系统完整指南

Pi 有三个核心扩展，分别解决不同层面的问题：

```
┌─────────────────────────────────────────────────────────────────┐
│                         Pi (主控)                                │
└──────────────────────┬──────────────────────────────────────────┘
                       │
       ┌───────────────┼───────────────┐
       │               │               │
       ▼               ▼               ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│pi-subagents │ │pi-messenger │ │pi-web-access│
│  (任务分解)  │ │  (Agent协调)│ │  (网页搜索) │
└─────────────┘ └─────────────┘ └─────────────┘
       │               │               │
       └───────────────┴───────────────┘
                       │
       ┌───────────────┼───────────────┐
       ▼               ▼               ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│   Claude    │ │    Codex    │ │   Hermes    │
│  (子代理)   │ │  (子代理)   │ │  (子代理)   │
└─────────────┘ └─────────────┘ └─────────────┘
```

## 三大扩展对比

| 扩展 | 核心功能 | 使用场景 | 交互方式 |
|------|----------|----------|----------|
| **pi-subagents** | 任务分解、链式/并行执行 | 复杂任务需要分步骤处理 | `/chain`, `/parallel`, `/run` |
| **pi-messenger** | 多 Agent 协调、通信 | 多 Agent 协作开发 | `pi_messenger()`, `/messenger` |
| **pi-web-access** | 网页搜索、内容抓取 | 需要外部信息 | `web_search()`, `fetch_content()` |

## 最佳实践：组合使用

### 场景 1: 开发新功能

```typescript
// Step 1: 使用 subagents 分解任务
// -----------------------------------
/chain scout "分析现有代码" -> 
      planner "设计架构" -> 
      worker "实现核心代码"

// Step 2: 使用 messenger 协调
// -----------------------------------
// 通知其他 Agent 新功能已完成
pi_messenger({ 
  action: "send", 
  to: "all", 
  message: "核心功能实现完成" 
})

// Step 3: 使用 web-access 验证
// -----------------------------------
// 搜索最佳实践进行对比
web_search("best practices for authentication 2024")

// Step 4: 回到 subagents 优化
// -----------------------------------
/run reviewer "根据搜索结果优化实现"
```

### 场景 2: Bug 修复工作流

```typescript
// 并行诊断问题
/parallel scout "查找错误日志" -> 
         scout "查找相关代码" -> 
         researcher "搜索类似 bug 的解决方案"

// 修复问题
/run worker "根据诊断结果修复 bug"

// 验证修复
/run reviewer "验证修复是否正确"

// 通知团队（如果在团队中）
pi_messenger({ 
  action: "send", 
  to: "all", 
  message: "Bug #123 已修复" 
})
```

### 场景 3: 大型重构项目

```typescript
// 异步启动大型重构（不阻塞当前会话）
/chain scout -> planner -> worker -- 重构整个系统 --bg

// 同时处理其他任务...

// 检查进度
subagent_status

// 完成后审查
/run reviewer "审查重构结果"

// 使用 messenger 预订文件进行最终 review
pi_messenger({ 
  action: "reserve", 
  paths: ["src/"],
  reason: "最终代码审查" 
})
```

## 安装所有扩展

```bash
# 1. 安装 pi-subagents（任务分解）
pi install npm:pi-subagents

# 2. 安装 pi-messenger（Agent 协调）
pi install npm:pi-messenger

# 3. 安装 pi-web-access（可选，网页搜索）
pi install npm:pi-web-access

# 4. 安装 pi-mcp-adapter（可选，MCP 支持）
pi install npm:pi-mcp-adapter
```

## 配置推荐

### 创建个人 Agent 模板

```bash
mkdir -p ~/.pi/agent/agents

# 创建你的专属 agents
cat > ~/.pi/agent/agents/my-architect.md << 'EOF'
---
name: my-architect
description: 我的架构设计专家
model: anthropic/claude-opus-4-6
thinking: high
tools: read, grep, find, bash
---

你是资深系统架构师。设计时关注：
1. 可扩展性
2. 可维护性
3. 性能
4. 安全性

输出完整的架构文档和实现步骤。
EOF
```

### 项目级配置

在项目根目录创建 `.pi/agents/project-scout.md`：

```markdown
---
name: project-scout
description: 本项目专用代码探索者
output: project-context.md
---

探索代码库时关注：
- 技术栈和框架版本
- 项目结构约定
- 已有的设计模式

记录发现到 project-context.md 供其他 agent 使用。
```

## 命令速查

### pi-subagents

```bash
/agents                          # Agent 管理器
/run scout "task"                # 单代理
/chain a -> b -> c               # 链式
/parallel a -> b                 # 并行
--bg                             # 异步
--fork                           # Fork 上下文
[output=x.md]                    # 指定输出
[model=x]                        # 指定模型
```

### pi-messenger

```typescript
pi_messenger({ action: "join" })                    // 加入网络
pi_messenger({ action: "plan" })                    // 规划任务
pi_messenger({ action: "work", autonomous: true })  // 自动执行
pi_messenger({ action: "reserve", paths: ["src/"] }) // 预订文件
pi_messenger({ action: "send", to: "all", message: "..." }) // 发消息
/messenger                                           // 聊天界面
```

### pi-web-access

```typescript
web_search("query")                // 搜索
fetch_content("https://...")       // 获取网页
git_repo_search("repo", "query")   // 搜索 GitHub 仓库
```

## 完整工作流示例

### 从零开始一个项目

```bash
# 1. 创建项目目录
mkdir my-new-project && cd my-new-project

# 2. 启动 Pi
pi
```

```typescript
// 3. 研究最佳实践
web_search("best tech stack for SaaS 2024")

// 4. 使用 subagents 设计架构
/run researcher "研究现代 SaaS 架构模式"

// 5. 规划项目
/chain scout -> 
      planner[output=architecture.md] -- 
      设计完整技术架构

// 6. 初始化项目
/run worker "根据架构文档初始化项目"

// 7. 并行开发核心功能
/parallel worker "实现用户系统" -> 
         worker "实现支付系统" -> 
         worker "实现通知系统"

// 8. 代码审查
/parallel reviewer "审查用户系统" -> 
         reviewer "审查支付系统" -> 
         reviewer "审查通知系统"

// 9. 使用 messenger 协调后续工作
pi_messenger({ action: "join" })
pi_messenger({ 
  action: "send", 
  to: "all", 
  message: "MVP 开发完成，准备部署" 
})
```

## 参考文档

| 文档 | 内容 |
|------|------|
| `SUBAGENTS_GUIDE.md` | pi-subagents 完整指南 |
| `MESSENGER_GUIDE.md` | pi-messenger 完整指南 |
| `PI_ACP_SETUP.md` | ACP 架构设计 |
| `PI_MESSENGER_START.md` | 5 分钟快速开始 |

## 下一步

1. **安装扩展**：
   ```bash
   pi install npm:pi-subagents npm:pi-messenger
   ```

2. **查看所有指南**：
   ```bash
   ls ~/dotfiles/configs/agents/pi/*.md
   ```

3. **创建测试项目**：
   ```bash
   mkdir ~/test-pi-ecosystem && cd ~/test-pi-ecosystem
   pi
   ```

4. **在 Pi 中尝试**：
   ```typescript
   /chain scout -> planner -> worker -- 创建一个 TODO list 应用
   ```
