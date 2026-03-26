# Pi Claude/Codex Bridge

在 Pi 中直接调用 Claude Code 和 Codex 的扩展。

## 安装

```bash
# 方法 1: 安装到全局
pi install /Users/davirian/.pi/extensions/pi-claude-codex-bridge

# 方法 2: 链接到项目
mkdir -p .pi/extensions
ln -s /Users/davirian/.pi/extensions/pi-claude-codex-bridge .pi/extensions/
```

## 使用方法

安装后重启 Pi，即可使用以下斜杠命令：

### /claude - 调用 Claude Code

```
/claude 设计用户认证系统
```

Claude 会返回设计方案，并保存到 `.pi/claude-output.md`

### /codex - 调用 Codex

```
/codex 实现登录功能
```

Codex 会返回代码实现，并保存到 `.pi/codex-output.md`

### /workflow - 完整工作流

```
/workflow 开发用户认证系统
```

自动执行：
1. Claude 设计 → 保存到 `01-design.md`
2. Codex 实现 → 保存到 `02-implementation.md`
3. 准备 Review → 保存到 `03-review-prompt.md`

## 工作流程示例

```
# 1. 让 Claude 设计
/claude 设计一个支持 JWT 的用户认证系统

# 2. 查看设计
read .pi/claude-output.md

# 3. 让 Codex 实现
/codex 基于上述设计实现代码

# 4. 查看实现
read .pi/codex-output.md

# 5. Pi 进行 review
# Pi 自动分析设计和实现
```

或者一键完成：

```
/workflow 开发完整的用户认证系统

# 查看工作流结果
read .pi/workflow/2024-01-15/01-design.md
read .pi/workflow/2024-01-15/02-implementation.md
```

## 特点

- ✅ 完全在 Pi 内部运行
- ✅ 使用 Pi 原生的斜杠命令
- ✅ 自动保存所有输出
- ✅ 符合 Pi 的设计哲学
- ✅ 无需离开 Pi 环境
