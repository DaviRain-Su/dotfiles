# Pi 开发环境配置完成清单

## ✅ 已完成的配置

### 1. Pi 核心扩展（已安装）

| 扩展 | 用途 | 状态 |
|------|------|------|
| **pi-messenger** | 多 Agent 协调、通信 | ✅ 已安装 |
| **pi-subagents** | 子代理任务分解 | ✅ 已安装 |
| **pi-web-access** | 网页搜索（可选） | ⬜ 未安装 |

### 2. Kimi 模型配置（已完成）

```yaml
# ~/.config/pi/config.yaml
model: kimi-k2.5
provider: kimi-coding
base_url: https://api.kimi.com/coding
```

**环境变量**: `KIMI_API_KEY` 已设置 ✅

### 3. 子代理 Agents（已配置）

```
~/.pi/agent/agents/
├── scout.md      ✅ 代码探索（Kimi k2.5）
├── planner.md    ✅ 架构设计（Kimi k2.5）
├── worker.md     ✅ 代码实现（Kimi k2.5）
└── reviewer.md   ✅ 代码审查（Kimi k2.5）
```

覆盖默认的 Claude 模型 agents。

## 🚀 使用方法

### 启动 Pi

```bash
pi
```

### 基础命令

```typescript
// 查看帮助
/help

// 查看已安装扩展
/extensions

// 查看可用 agents
/agents
```

### pi-subagents（任务分解）

```typescript
// 单任务 - 代码探索
/run scout "分析当前项目的结构"

// 链式任务 - 探索 → 设计 → 实现
/chain scout "分析代码" -> planner "设计方案" -> worker "实现代码"

// 并行任务 - 同时检查安全和性能
/parallel reviewer "检查安全性" -> reviewer "检查性能"

// 后台运行（不阻塞）
/run scout "大型分析任务" --bg
```

### pi-messenger（团队协作）

```typescript
// 加入网络（同一目录下的多个 Pi 可以互相通信）
pi_messenger({ action: "join" })

// 发送消息给其他 Agent
pi_messenger({ action: "send", to: "BlueWhale", message: "帮我看看这个代码" })

// 广播给所有人
pi_messenger({ action: "send", to: "all", message: "登录功能完成了" })

// 预订文件（避免冲突）
pi_messenger({ action: "reserve", paths: ["src/auth/"], reason: "重构登录" })

// 释放文件
pi_messenger({ action: "release" })

// 打开聊天界面
/messenger
```

### Crew 自动任务编排

```typescript
// 1. 创建 PRD.md 文件
// 2. 自动规划任务
pi_messenger({ action: "plan" })

// 3. 自动执行所有任务
pi_messenger({ action: "work", autonomous: true })
```

## 📁 配置文件位置

| 文件 | 路径 | 说明 |
|------|------|------|
| Pi 主配置 | `~/.config/pi/config.yaml` | 默认模型、扩展 |
| Agents | `~/.pi/agent/agents/*.md` | 子代理配置 |
| Messenger | `.pi/messenger/`（项目目录） | 会话数据 |
| 日志 | `~/.pi/logs/` | 运行日志 |

## 🔄 快速工作流示例

### 场景 1：开发新功能

```typescript
// 1. 探索现有代码
/run scout "分析当前认证系统的实现"

// 2. 设计方案
/run planner "基于现有代码，设计密码重置功能"

// 3. 实现代码
/run worker "实现密码重置功能"

// 4. 代码审查
/run reviewer "检查密码重置实现的安全性"
```

### 场景 2：团队协作

终端 1：
```typescript
pi_messenger({ action: "join" })
pi_messenger({ action: "reserve", paths: ["src/auth/"], reason: "添加 OAuth" })
// 开始工作...
```

终端 2：
```typescript
pi_messenger({ action: "join" })
// 看到：src/auth/ 已被预订，做其他工作
```

终端 1 完成后：
```typescript
pi_messenger({ action: "send", to: "all", message: "OAuth 添加完成，可以 review 了" })
pi_messenger({ action: "release" })
```

### 场景 3：自动化工作流（有 PRD）

```bash
# 1. 创建 PRD.md
cat > PRD.md << 'EOF'
# 用户系统功能

## 需求
- 用户注册（邮箱验证）
- 用户登录（JWT）
- 密码重置

## 技术栈
- Node.js + Express
- PostgreSQL
EOF
```

```typescript
// 2. 在 Pi 中执行
pi_messenger({ action: "join" })
pi_messenger({ action: "plan" })              // 自动分析 PRD
pi_messenger({ action: "work", autonomous: true })  // 自动执行
```

## 🛠️ 故障排除

### 问题："Model not found" 或 API 错误

**原因**：KIMI_API_KEY 可能未正确设置

**解决**：
```bash
# 检查环境变量
echo $KIMI_API_KEY

# 如果为空，添加到 ~/.extra
export KIMI_API_KEY="your-key"
source ~/.zshrc

# 重启 Pi
```

### 问题：Agents 不工作

**检查**：
```bash
# 查看 agents 是否正确安装
ls ~/.pi/agent/agents/

# 应该看到：scout.md, planner.md, worker.md, reviewer.md
```

### 问题：Messenger 无法加入

**原因**：可能已经在网络中，或目录权限问题

**解决**：
```typescript
// 检查状态
pi_messenger({ action: "status" })

// 如果卡住，重新加入
pi_messenger({ action: "leave" })
pi_messenger({ action: "join" })
```

## 📝 扩展安装（可选）

如果需要网页搜索功能：

```bash
pi install npm:pi-web-access
```

然后可以在 Pi 中使用：
```typescript
web_search("最新 React 最佳实践")
fetch_content("https://example.com/docs")
```

## ✅ 配置验证清单

运行以下命令验证配置：

```bash
# 1. 检查扩展
pi list | grep -E "messenger|subagent"

# 2. 检查 agents
ls ~/.pi/agent/agents/

# 3. 检查环境变量
echo $KIMI_API_KEY | head -c 20

# 4. 检查配置文件
cat ~/.config/pi/config.yaml
```

## 🎯 下一步建议

1. **测试基本功能**：
   ```bash
   pi
   # 然后输入: /run scout "分析当前目录"
   ```

2. **测试 Messenger**：
   ```bash
   # 开两个终端，都进入同一目录
   # 终端1: pi -> pi_messenger({ action: "join" })
   # 终端2: pi -> pi_messenger({ action: "join" })
   # 终端1: pi_messenger({ action: "send", to: "all", message: "测试" })
   ```

3. **熟悉命令**：参考 `PRACTICAL_GUIDE.md`

## 📚 参考文档

| 文档 | 内容 |
|------|------|
| `PRACTICAL_GUIDE.md` | 一步一步实战教程 |
| `HOW_IT_WORKS.md` | 工作原理说明 |
| `KIMI_AGENTS_SETUP.md` | Kimi 模型配置说明 |
| `PI_ECOSYSTEM.md` | 所有扩展对比 |

---

**状态**: ✅ Pi 开发环境配置完成！

- 默认模型: Kimi k2.5
- 扩展: pi-messenger, pi-subagents
- Agents: scout, planner, worker, reviewer (Kimi 版本)
- 所有配置使用 Kimi 模型
