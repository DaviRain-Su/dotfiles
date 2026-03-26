# AI Agent 统一管理

## 支持的 Agent

| Agent | 命令 | 安装方式 |
|-------|------|---------|
| Claude Code | `ai claude` | npm |
| Codex | `ai codex` | npm |
| OpenCode | `ai opencode` | npm/bun |
| Pi | `ai pi` | npm |
| Hermes | `ai hermes` | pip |

## 快速开始

### 查看已安装的 agent
```bash
ai list
```

### 安装所有 agent
```bash
ai install
```

### 启动特定 agent
```bash
ai claude    # 启动 Claude Code
ai pi        # 启动 Pi
ai codex     # 启动 Codex
```

## 配置

每个 agent 的配置在 `configs/agents/<agent>/` 目录中：

```
configs/agents/
├── claude/
│   └── config.sh      # Claude Code 配置
├── codex/
│   └── config.sh      # Codex 配置
├── opencode/
│   └── config.sh      # OpenCode 配置
├── pi/
│   └── config.sh      # Pi 配置
└── hermes/
    └── config.sh      # Hermes 配置
```

## 添加 API Key

不要在 config.sh 中直接写 API Key，建议添加到 `~/.extra`：

```bash
# ~/.extra
export ANTHROPIC_API_KEY="your-key"
export OPENAI_API_KEY="your-key"
```
