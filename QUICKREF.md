# ⚡ 快速参考 - 最常用的 10 个命令

## 🎯 每日必用（先记住这些）

### 1. Ghostty 分屏
```bash
Cmd+D          # 垂直分屏（左右）
Cmd+Shift+D    # 水平分屏（上下）
Cmd+W          # 关闭分屏
Cmd+[          # 左
Cmd+]          # 右
```

### 2. Tmux（如果使用）
```bash
Ctrl+A |       # 垂直分屏
Ctrl+A -       # 水平分屏
Ctrl+A d       # 后台运行（detach）
tmux attach -t myproject   # 重新连接
```

### 3. pi 工作流
```bash
pi                              # 启动
/messenger plan prompt:"需求"   # 规划
/messenger work autonomous      # 自动执行
/messenger task list            # 查看任务
```

### 4. 目录跳转
```bash
zi             # 交互式选择目录（最常用）
z foo          # 跳转到包含 foo 的目录
```

### 5. 文件查找
```bash
Ctrl+T         # 查找文件（在命令行中）
Ctrl+R         # 查找历史命令
```

### 6. Git
```bash
gs             # git status
gaa            # git add --all
gcm "msg"      # git commit -m
gp             # git push
lg             # lazygit（图形界面）
```

### 7. 文件查看
```bash
bat file.ts    # 带语法高亮
lsd            # 带图标的 ls
lt             # 树形显示
```

### 8. 搜索
```bash
rg "pattern"   # 快速搜索文件内容
fd "*.ts"      # 快速查找文件
```

### 9. 系统
```bash
btop           # 系统监控
procs          # 进程查看
```

### 10. 快速帮助
```bash
cat ~/dotfiles/QUICKREF.md      # 查看本文档
cat ~/dotfiles/CHEATSHEET.md    # 查看完整文档
```

---

## 💡 一个完整的开发流程

```bash
# 1. 进入项目
cd ~/my-project

# 2. 启动 pi
pi

# 3. 规划任务
> 帮我实现 xxx 功能

# 4. 查看并执行
> /messenger task list
> /messenger work autonomous

# 5. 查看结果
> /messenger status

# 6. 提交代码
> Ctrl+D 分屏
> gs
> gaa
> gcm "实现 xxx"
> gp
```

---

**只需记住这 10 个，其他的需要时再查 CHEATSHEET.md**
