# Pi-Workflow 在 Pi 中的使用方法

## 问题说明

**在 Pi 中使用 `!命令` 时**，Pi 会启动一个**新的 shell**，不会自动加载你的 `.zshrc` 配置。

所以 `!pflow` 或 `!pi-workflow` 会提示 "command not found"。

## 解决方案

### 方法 1: 使用完整路径（最简单，立即可用）

在 Pi 中输入：

```typescript
!~/dotfiles/bin/pi-workflow "写一个快速排序算法使用 zig 语言实现支持泛型"
```

### 方法 2: 使用 bash 加载配置

```typescript
!bash -c "source ~/.zshrc && pflow '写一个快速排序算法'"
```

### 方法 3: 创建一个 Pi 工具函数

在 Pi 中定义一个辅助函数（只需一次）：

```typescript
# 在 Pi 中输入，创建 workflow 快捷命令
workflow() {
  local task="$1"
  ~/dotfiles/bin/pi-workflow "$task"
}

# 然后就可以使用
workflow "写一个快速排序算法"
```

## 实际使用示例

### 完整工作流程

```typescript
// 1. 启动工作流（使用完整路径）
!~/dotfiles/bin/pi-workflow "开发用户认证系统，包含登录注册和 JWT"

// 2. 等待完成（可能需要几分钟）
// 你会看到 Stage 1/2/3 的执行过程

// 3. 查看结果
read .pi/workflow/20240115_120000/README.md

// 4. 查看设计
read .pi/workflow/20240115_120000/01_design.md

// 5. 查看实现
read .pi/workflow/20240115_120000/02_implementation.md

// 6. 进行 Review
read .pi/workflow/20240115_120000/03_review_prompt.md
```

### 推荐：使用辅助函数

在 Pi 的 `~/.pi/config.yaml` 中添加自定义命令，或者每次启动 Pi 时输入：

```typescript
# 定义快捷命令
pflow() {
  ~/dotfiles/bin/pi-workflow "$@"
}

# 之后就可以使用
pflow "实现一个 REST API"
pflow "重构登录模块"
```

## 常见问题

### Q: 为什么在 Pi 中 `!pflow` 不行，终端中可以？

**A**: 
- **终端中**：加载了 `.zshrc`，有 PATH 和别名配置
- **Pi 中**：`!命令` 启动新 shell，**不加载** `.zshrc`

### Q: 每次都输完整路径太麻烦了？

**A**: 使用上述的辅助函数方法，在 Pi 中定义一次 `pflow()` 函数，之后就能简写。

### Q: 可以做成 Pi 扩展吗？

**A**: 可以，创建一个 Pi 扩展让调用更简单。但这是额外工作，先用完整路径验证流程是否满足需求。

## 验证测试

请现在试试：

```typescript
// 在 Pi 中输入：
!~/dotfiles/bin/pi-workflow "写一个 hello world"

// 应该能看到工作流开始执行
// Stage 1/3: Claude 设计
// ...
```

如果这一步成功了，说明配置正确，只是需要适应 Pi 的特殊环境。
