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

## 配置

1. 从订阅邮件获取 API Key
2. 添加到 `~/.extra`:
   ```bash
   export FACTORY_API_KEY="your-api-key"
   ```
3. 重新加载: `source ~/.zshrc`

## 使用

```bash
droid login
droid init
droid deploy
```

## 文档

- https://docs.factory.ai
- https://factory.ai/settings/api
