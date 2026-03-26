# 使用 Kimi 模型的 Pi Agents 配置

## 问题

默认的 pi-subagents 使用 Claude 模型：
- `scout`: claude-haiku-4-5
- `planner`: claude-opus-4-6
- `worker`: claude-sonnet-4-6
- `reviewer`: openai-codex/gpt-5.3-codex

**如果你只有 Kimi API Key，这些模型无法使用！**

## 解决方案

已为你创建使用 **Kimi k2.5** 的自定义 agents：

```
~/.pi/agent/agents/
├── scout.md      # 代码探索（Kimi k2.5）
├── planner.md    # 架构设计（Kimi k2.5）
├── worker.md     # 代码实现（Kimi k2.5）
└── reviewer.md   # 代码审查（Kimi k2.5）
```

## 配置方法

### 方法 1: 使用 Kimi Agents（推荐）

已自动配置，直接使用：

```typescript
// 在 Pi 中输入
/run scout "分析代码"
/chain scout -> planner -> worker
```

这些 agent 会自动使用 Kimi k2.5 模型。

### 方法 2: 添加其他 API Keys

如果你想使用 Claude/Codex，编辑 `~/.extra`：

```bash
# 编辑 ~/.extra
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."
```

然后 `source ~/.zshrc`

### 方法 3: 使用外部 CLI（最简单）

不配置模型，直接调用外部程序：

```typescript
// 调用系统安装的 Claude/Codex
!claude "设计架构"
!codex "写代码"

// 或使用 orchestrator
!pi-orchestrator simple claude "设计架构"
```

这些 CLI 自己管理 API Key，不需要在 Pi 中配置。

## 对比

| 方式 | 需要 API Key | 说明 |
|------|-------------|------|
| **Kimi Agents** | 只需 KIMI_API_KEY | Pi 内使用 Kimi 模型运行子代理 |
| **添加多 Key** | ANTHROPIC_API_KEY + OPENAI_API_KEY + KIMI_API_KEY | 使用官方 Claude/Codex 模型 |
| **外部 CLI** | CLI 自己管理 | 调用系统命令，Pi 不负责模型 |

## 推荐配置

### 如果你只有 Kimi

1. **使用自定义的 Kimi agents**（已配置好）
2. **或者使用 pi-orchestrator 调用外部 CLI**

```typescript
// 方案 A: Pi 内使用 Kimi agents
/run scout "分析代码"

// 方案 B: 调用外部（如果安装了 claude/codex）
!pi-orchestrator simple claude "设计架构"
```

### 如果你有多家 API Key

编辑 `~/.extra`，添加所有 Key：

```bash
# Kimi
export KIMI_API_KEY="..."

# Anthropic (Claude)
export ANTHROPIC_API_KEY="..."

# OpenAI (Codex)
export OPENAI_API_KEY="..."
```

然后 pi-subagents 的默认配置就能工作了。

## 验证

测试配置是否正确：

```typescript
// 1. 检查 agent 列表
/agents

// 应该看到你的自定义 agents（带 user 标签）

// 2. 运行测试
/run scout "分析当前目录"

// 应该能正常运行，使用 Kimi 模型
```

## 故障排除

### 问题："Model not found" 或类似错误

**原因**：Pi 尝试使用 Claude 模型，但你没有 ANTHROPIC_API_KEY

**解决**：
- 使用上面创建的 Kimi agents（它们会覆盖默认配置）
- 或者添加 ANTHROPIC_API_KEY

### 问题："API key not configured"

**原因**：KIMI_API_KEY 未设置或 Pi 无法识别

**解决**：
```bash
# 检查环境变量
echo $KIMI_API_KEY

# 如果不显示，添加到 ~/.extra
export KIMI_API_KEY="your-key"
source ~/.zshrc
```

### 问题：Agent 运行但没有输出

**原因**：可能是模型响应问题

**解决**：
```typescript
// 尝试简化任务
/run scout "列出当前目录的文件"

// 或者查看日志
!cat ~/.pi/logs/latest.log
```

## 总结

| 你的情况 | 推荐做法 |
|---------|---------|
| 只有 Kimi API Key | 使用已配置的 Kimi agents，或调用外部 CLI |
| 有多家 API Key | 添加到 ~/.extra，使用默认配置 |
| 不想配置 | 使用 `!claude` 或 `!codex` 直接调用外部 CLI |

Kimi k2.5 能力足够强，完全可以胜任 scout/planner/worker/reviewer 的角色！
