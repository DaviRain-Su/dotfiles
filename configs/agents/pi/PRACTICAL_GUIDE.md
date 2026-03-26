# Pi 扩展实战指南 - 真正能用

## 第一步：安装扩展

在**终端**（不是 Pi 里）运行：

```bash
# 安装 pi-subagents（任务分解）
pi install npm:pi-subagents

# 安装 pi-messenger（Agent协调）  
pi install npm:pi-messenger

# 安装 pi-web-access（网页搜索，可选）
pi install npm:pi-web-access
```

## 第二步：启动 Pi

```bash
pi
```

## 第三步：使用 pi-subagents（最简单）

### 场景：你有一个复杂任务，想让多个"小助手"分工完成

**例子：写一个完整的登录功能**

在 Pi 中输入：

```typescript
/chain scout "分析项目结构，看看怎么加登录功能" -> planner "设计登录功能的代码结构" -> worker "实现登录代码"
```

按回车，你会看到：
1. **scout** 先运行，扫描你的代码库
2. 完成后 **planner** 自动开始，基于 scout 的结果设计方案
3. 然后 **worker** 自动开始，根据设计写代码

**这就是 `/chain` 的意思：链式执行，一步接一步**

---

### 另一个例子：并行执行

**场景：同时让两个人审查代码**

```typescript
/parallel scout "扫描安全漏洞" -> scout "扫描性能问题"
```

这两个 scout **同时运行**，互不影响。

---

### 最简单的：单任务

```typescript
/run scout "分析这个文件的作用"
```

直接运行一个 agent，完成后结果会显示在对话里。

---

## 第四步：使用 pi-messenger（团队协作）

### 场景：你开多个终端，每个终端一个 Pi，它们可以互相"聊天"

**终端 1：**
```bash
mkdir ~/project && cd ~/project
pi
```

在 Pi 中：
```typescript
pi_messenger({ action: "join" })
```

你会看到：
```
✓ Joined as "SwiftRaven" (0 peers)
```

**终端 2：**
```bash
cd ~/project  # 同一个目录！
pi
```

在 Pi 中：
```typescript
pi_messenger({ action: "join" })
```

你会看到：
```
✓ Joined as "BlueWhale" (1 peer: SwiftRaven)
```

**现在两个 Pi 可以互相发消息！**

在终端 1 的 Pi 中：
```typescript
pi_messenger({ action: "send", to: "BlueWhale", message: "帮我看看 auth.js 文件" })
```

在终端 2 的 Pi 中，会立即看到：
```
📨 来自 SwiftRaven: 帮我看看 auth.js 文件
```

---

### 打开聊天界面

在任意 Pi 中输入：
```
/messenger
```

会打开一个分屏界面：
- 左边：在线的 Pi 列表
- 右边：聊天记录
- 底部：输入框

按 `Tab` 切换标签页，按 `Esc` 退出。

---

### 预订文件（避免冲突）

**场景：你在修改 auth.js，不想让别人同时修改**

```typescript
pi_messenger({ action: "reserve", paths: ["auth.js"], reason: "重构登录逻辑" })
```

其他 Pi 如果尝试修改 auth.js，会收到警告：
```
⚠️ auth.js 已被 SwiftRaven 预订 (重构登录逻辑)
```

你改完后：
```typescript
pi_messenger({ action: "release" })
```

---

## 第五步：Crew 自动任务（最高级）

### 场景：你有 PRD 文档，想让 Pi 自动拆解任务并执行

**1. 创建 PRD 文件**

```bash
cat > PRD.md << 'EOF'
# 用户认证功能

## 需求
- 用户注册（邮箱验证）
- 用户登录（JWT Token）
- 密码重置

## 技术栈
- Node.js + Express
- PostgreSQL
- JWT
EOF
```

**2. 在 Pi 中自动规划**

```typescript
pi_messenger({ action: "plan" })
```

Pi 会自动：
1. 读取 PRD.md
2. 分析代码库
3. 创建任务列表

你会看到类似：
```
📋 任务规划完成：
- task-1: 设计数据库表（无依赖）
- task-2: 实现注册 API（依赖 task-1）
- task-3: 实现登录 API（依赖 task-1）
- task-4: 实现 JWT 中间件（依赖 task-2, task-3）
```

**3. 自动执行所有任务**

```typescript
pi_messenger({ action: "work", autonomous: true })
```

Pi 会自动：
1. 并行执行无依赖的任务（task-1）
2. 等待依赖完成后执行后续任务（task-2, task-3 并行）
3. 最后执行 task-4
4. 每个任务完成后自动 review

**你就等着，它会一直跑到全部完成！**

---

## 常用命令速查

### pi-subagents（任务分解）

```typescript
// 单任务
/run scout "分析代码"

// 链式（一个接一个）
/chain scout -> planner -> worker

// 并行（同时）
/parallel scout -> scout

// 后台运行（不阻塞）
/run scout "大任务" --bg
```

### pi-messenger（团队协作）

```typescript
// 加入网络
pi_messenger({ action: "join" })

// 发消息
pi_messenger({ action: "send", to: "AgentName", message: "内容" })

// 广播
pi_messenger({ action: "send", to: "all", message: "大家好" })

// 预订文件
pi_messenger({ action: "reserve", paths: ["file.js"] })

// 释放文件
pi_messenger({ action: "release" })

// 自动规划任务
pi_messenger({ action: "plan" })

// 自动执行
pi_messenger({ action: "work", autonomous: true })

// 打开聊天界面
/messenger
```

---

## 实际工作流程示例

### 单人工作流（只用 pi-subagents）

```typescript
// 1. 探索代码
/run scout "了解这个项目的架构"

// 2. 设计功能
/chain scout -> planner "设计用户系统"

// 3. 实现代码
/chain planner -> worker "实现设计"

// 4. 审查代码
/run reviewer "检查刚写的代码"
```

### 多人协作（pi-messenger）

**你（终端1）：**
```typescript
pi_messenger({ action: "join" })
pi_messenger({ action: "reserve", paths: ["auth/"], reason: "做登录功能" })
// 开始工作...
```

**同事（终端2）：**
```typescript
pi_messenger({ action: "join" })
// 看到：auth/ 已被预订，做其他功能
```

**你完成后：**
```typescript
pi_messenger({ action: "send", to: "all", message: "登录功能完成了，可以review了" })
pi_messenger({ action: "release" })
```

### 全自动（Crew）

```typescript
// 一键完成整个功能开发
pi_messenger({ action: "join" })
pi_messenger({ action: "plan" })  // 读取 PRD.md
pi_messenger({ action: "work", autonomous: true })  // 自动执行
// 等着它完成...
```

---

## 常见问题

**Q: 我按了回车没反应？**
A: 等待一下，agent 需要时间运行。大任务可能需要几分钟。

**Q: 怎么知道任务完成了？**
A: 看输出，会显示 "[✓] 完成" 或 "[✗] 失败"。

**Q: 可以中途停止吗？**
A: 按 `Ctrl+C`。

**Q: 结果保存在哪里？**
A: 在对话里直接显示。Crew 的任务结果保存在 `.pi/messenger/crew/`。

**Q: 没有 PRD 文件能用 Crew 吗？**
A: 可以！
```typescript
pi_messenger({ action: "plan", prompt: "实现一个 TODO list" })
```

---

## 最简单的开始

1. **安装**：`pi install npm:pi-subagents`
2. **启动 Pi**：`pi`
3. **运行**：`/run scout "分析当前目录"`

看到输出就是成功了！
