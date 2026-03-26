# Pi Messenger 快速开始

Pi Messenger 已安装！这是一个多 Agent 协调系统。

## 架构

```
Pi (主控) + pi-messenger
    │
    ├── Crew Planner (规划者) → 分析 PRD，创建任务图
    ├── Crew Worker (工作者) → 并行执行任务
    └── Crew Reviewer (审查者) → 审查任务完成质量
```

## 5 分钟快速开始

### 步骤 1: 在项目目录启动 Pi

```bash
cd ~/your-project
pi
```

### 步骤 2: 加入 Messenger 网络

在 Pi 中输入：

```typescript
pi_messenger({ action: "join" })
```

你会看到类似：
```
✓ Joined as "SwiftRaven" (2 peers online)
```

### 步骤 3: 打开聊天界面

```
/messenger
```

看到分屏界面，显示：
- Agents 标签：在线 Agent 列表
- Crew 标签：任务列表
- 聊天输入框

### 步骤 4: 开始任务编排

有 PRD 文件时：

```typescript
// 自动发现并分析 PRD.md
pi_messenger({ action: "plan" })
```

没有 PRD 时：

```typescript
// 直接描述任务
pi_messenger({ 
  action: "plan", 
  prompt: "重构认证模块，添加 JWT 支持" 
})
```

### 步骤 5: 自动执行

```typescript
// 自动执行所有任务，直到完成
pi_messenger({ action: "work", autonomous: true })
```

## 实际示例

### 示例 1: 完整的开发工作流

```typescript
// 用户：帮我开发一个用户认证系统

// 1. Pi 作为主控加入网络
pi_messenger({ action: "join" })

// 2. 自动规划任务
pi_messenger({ action: "plan" })
// 输出:
// - task-1: 设计数据库模型 (依赖: 无)
// - task-2: 实现登录 API (依赖: task-1)
// - task-3: 实现注册 API (依赖: task-1)
// - task-4: 添加 JWT 中间件 (依赖: task-2, task-3)

// 3. 并行执行 (自动协调依赖)
pi_messenger({ action: "work", autonomous: true })
// Wave 1: task-1 (并行启动)
// Wave 2: task-2, task-3 (task-1 完成后并行)
// Wave 3: task-4 (task-2, task-3 完成后)

// 4. 审查关键任务
pi_messenger({ action: "review", target: "task-4" })
```

### 示例 2: 多 Agent 协作

```typescript
// 预订文件避免冲突
pi_messenger({ 
  action: "reserve", 
  paths: ["src/auth/"],
  reason: "重构认证模块" 
})

// 通知其他 Agent
pi_messenger({ 
  action: "send", 
  to: "all", 
  message: "开始重构认证模块，预计 30 分钟" 
})

// ... 工作完成后 ...

pi_messenger({ action: "release" })
pi_messenger({ 
  action: "send", 
  to: "all", 
  message: "认证模块重构完成，可以 review 了" 
})
```

## 关键命令速查

| 命令 | 作用 |
|------|------|
| `pi_messenger({ action: "join" })` | 加入网络 |
| `pi_messenger({ action: "list" })` | 查看在线 Agent |
| `pi_messenger({ action: "plan" })` | 规划任务 |
| `pi_messenger({ action: "work", autonomous: true })` | 自动执行 |
| `pi_messenger({ action: "review", target: "task-1" })` | 审查任务 |
| `pi_messenger({ action: "reserve", paths: ["src/"] })` | 预订文件 |
| `pi_messenger({ action: "release" })` | 释放预订 |
| `pi_messenger({ action: "send", to: "AgentName", message: "..." })` | 发消息 |
| `/messenger` | 打开聊天界面 |

## Crew Agents 说明

### 1. Planner (规划者)
- **模型**: Claude Opus
- **作用**: 分析代码库和 PRD，创建任务依赖图
- **输出**: 任务列表，含依赖关系

### 2. Worker (工作者)
- **模型**: Claude Opus / 配置
- **作用**: 并行执行无依赖的任务
- **特点**: 自动协调，等待依赖完成

### 3. Reviewer (审查者)
- **模型**: Claude Opus
- **作用**: 审查任务完成质量
- **输出**: SHIP / NEEDS_WORK / MAJOR_RETHINK

## 与 ACP 的关系

Pi Messenger 实现了类似 ACP 的概念：

| ACP 概念 | Pi Messenger 实现 |
|----------|-------------------|
| Agent Discovery | `pi_messenger({ action: "join" })` |
| Task Routing | Crew Planner 自动分配 |
| File Locking | `pi_messenger({ action: "reserve" })` |
| Messaging | `pi_messenger({ action: "send" })` |
| Status/Heartbeat | 自动在线状态显示 |

## 下一步

1. **创建测试项目**：
   ```bash
   mkdir ~/test-messenger && cd ~/test-messenger
   echo "# Test Project" > README.md
   pi
   ```

2. **在 Pi 中测试**：
   ```typescript
   pi_messenger({ action: "join" })
   pi_messenger({ action: "plan", prompt: "创建一个简单的 HTTP 服务器" })
   pi_messenger({ action: "work", autonomous: true })
   ```

3. **查看详细文档**：
   - `configs/agents/pi/MESSENGER_GUIDE.md` - 完整指南
   - `configs/agents/pi/PI_ACP_SETUP.md` - ACP 架构说明
