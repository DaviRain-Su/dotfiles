# Pi 主控工作流设计：Claude → Codex → Pi Review

## 你的需求分析

```
用户（你）
  ↓
Pi（主控）
  ├─ 阶段1: Claude（设计文档）
  ├─ 阶段2: Codex（代码实现）
  └─ 阶段3: Pi（审查）
```

**痛点**：朋友用 TUTUMS 需要开多个窗口切换，你想在一个 Pi 会话中完成。

## 方案：Pi 主控 + 顺序调用

### 核心思想

**Pi 作为主控**，顺序调用外部工具，自动传递上下文：

```typescript
// 你在 Pi 中输入一次
!pi-workflow "开发用户认证系统"

// Pi 自动执行：
// 1. 调用 Claude 设计
// 2. 调用 Codex 实现
// 3. Pi 自己审查
```

## 实现方案

### 方案 A: 改进版 Orchestrator（推荐）

创建一个真正的工作流脚本：

```bash
# 用法
pi-workflow "开发任务描述"
```

实际流程：
```
用户输入任务
  ↓
Stage 1: Claude 设计
  - 输入: 任务描述
  - 输出: design.md
  - 自动保存到 .pi/workflow/{timestamp}/
  ↓
Stage 2: Codex 实现
  - 输入: design.md + 任务描述
  - 输出: implementation/
  - 自动保存代码文件
  ↓
Stage 3: Pi Review
  - 输入: design.md + implementation/
  - 输出: review.md
  - Pi 生成审查报告
  ↓
汇总报告
```

### 方案 B: 使用 sesh 分屏（可视化）

```
┌─────────────────────────────────────────┐
│              Pi (主控)                   │
│  "启动工作流：开发认证系统"              │
└─────────────────────────────────────────┘
                    ↓
┌──────────────────┬─────────────────────┐
│   Claude Code    │      Codex          │
│   (设计阶段)     │     (实现阶段)      │
│                  │                     │
│   输出: design   │   输出: code        │
│   .md            │                     │
└──────────────────┴─────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│           Pi Review (审查)               │
│  "设计符合需求，代码有 X 个问题..."      │
└─────────────────────────────────────────┘
```

## 实际代码实现

让我为你创建 `pi-workflow` 命令：

```bash
#!/bin/bash
# pi-workflow - 三阶段工作流：Claude → Codex → Pi Review

WORKFLOW_DIR=".pi/workflow/$(date +%Y%m%d_%H%M%S)"
TASK="$1"

# Stage 1: Claude 设计
mkdir -p "$WORKFLOW_DIR"
echo "$TASK" | claude > "$WORKFLOW_DIR/01_design.md"
echo "✓ Stage 1 完成: Claude 设计"

# Stage 2: Codex 实现
cat "$WORKFLOW_DIR/01_design.md" | codex > "$WORKFLOW_DIR/02_implementation.md"
echo "✓ Stage 2 完成: Codex 实现"

# Stage 3: Pi Review (通过 pi-subagents 的 reviewer)
echo "基于以下设计和实现进行审查：
设计: $WORKFLOW_DIR/01_design.md
实现: $WORKFLOW_DIR/02_implementation.md" | pi > "$WORKFLOW_DIR/03_review.md"
echo "✓ Stage 3 完成: Pi 审查"

# 生成汇总报告
cat > "$WORKFLOW_DIR/README.md" << EOF
# 工作流执行报告

## 任务
$TASK

## 阶段 1: 设计
文件: 01_design.md
状态: ✓ 完成

## 阶段 2: 实现
文件: 02_implementation.md
状态: ✓ 完成

## 阶段 3: 审查
文件: 03_review.md
状态: ✓ 完成

## 建议
查看 review.md 了解需要修改的地方。
EOF

echo ""
echo "工作流完成！查看: $WORKFLOW_DIR/"
```

## 使用方式

### 方式 1: 全自动（推荐）

```typescript
// 在 Pi 中输入
!pi-workflow "开发用户认证系统，包含登录注册和 JWT"

// 等待完成...
// 自动执行 Claude → Codex → Pi Review

// 查看结果
read .pi/workflow/20240115_120000/README.md
```

### 方式 2: 分步执行（可控）

```typescript
// 步骤1: 设计
!pi-stage1 claude "设计用户认证系统" design.md

// Pi 自动:
// - 调用 Claude
// - 保存到 design.md
// - 显示结果

// 你检查设计
read design.md
// 你: "设计 OK，继续实现"

// 步骤2: 实现
!pi-stage2 codex "基于 design.md 实现代码" implementation/

// Pi 自动:
// - 调用 Codex
// - 保存代码到 implementation/

// 步骤3: 审查
!pi-stage3 review design.md implementation/ review.md

// Pi 自动:
// - 使用 reviewer agent 审查
// - 生成 review.md
```

### 方式 3: 分屏监控（可视化）

```bash
# 使用 ai sesh 创建分屏
ai sesh workflow

# 左屏: Pi 主控
# 右屏: lazygit（查看生成的文件）
```

## 对比 TUTUMS

| 特性 | TUTUMS（朋友用的） | 你的方案（Pi 主控） |
|------|-------------------|-------------------|
| 窗口数量 | 多个（Claude窗口 + Codex窗口 + 编辑器） | 1个（只有 Pi） |
| 上下文传递 | 手动复制粘贴 | 自动（文件传递） |
| 流程控制 | 手动切换 | 自动顺序执行 |
| 审查 | 人工审查 | Pi 自动审查 + 人工确认 |
| 结果保存 | 分散在各窗口 | 统一在 .pi/workflow/ |

## 完善建议

### 1. 添加工状态保存

```bash
# 如果中断了，可以恢复
pi-workflow --resume 20240115_120000
```

### 2. 添加人机确认点

```bash
# Stage 1 完成后暂停，等待确认
pi-workflow --confirm "开发认证系统"
# 输出: "Stage 1 完成，按 Enter 继续 Stage 2，或 Ctrl+C 停止"
```

### 3. 添加循环优化

```typescript
// 如果审查不通过，自动修复
pi-workflow --iterate "开发认证系统"
// 自动: 设计 → 实现 → 审查 → (有问题) → 修复 → 审查 → ...直到通过
```

### 4. 集成 pi-messenger

如果有其他开发者：
```typescript
// Stage 1 完成后通知团队
pi_messenger({ action: "send", to: "all", message: "设计完成，等待 review" })

// 等待其他人确认后再继续
```

## 实施步骤

1. **创建 pi-workflow 脚本**（我现在就做）
2. **测试简单任务**（如 "写一个排序函数"）
3. **完善错误处理**（某个 stage 失败怎么办）
4. **添加交互确认**（让用户在每个 stage 后确认）

你想先实现哪种方案？
- A: 全自动（一次命令，等待完成）
- B: 分步可控（每个 stage 后暂停，你确认后再继续）
- C: 混合（自动执行，但关键节点通知你）
