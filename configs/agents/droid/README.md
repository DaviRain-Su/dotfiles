# Factory.ai Droid CLI 配置

Factory.ai 是一个 AI 驱动的软件开发平台。

## 安装

```bash
# 官方安装脚本
curl -fsSL https://app.factory.ai/cli | sh

# 或通过 ai 命令安装
ai install
```

安装完成后，CLI 命令为 `droid`。

## 登录

Factory.ai 使用浏览器登录（类似 Claude Code 和 Codex）：

```bash
droid login
```

会自动打开浏览器完成授权，无需配置 API Key。

## 使用

```bash
droid init      # 初始化项目
droid deploy    # 部署
droid --help    # 查看所有命令
```

## 文档

- https://docs.factory.ai
- https://factory.ai
