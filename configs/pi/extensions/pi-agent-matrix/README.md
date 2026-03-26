# Pi Agent Matrix - YOLO 模式

智能编排系统：一次输入，全自动完成。

## 核心理念

**不固定角色，智能选择最佳工具**：
- 需要设计？→ 可能选 Claude 或 OpenCode
- 需要实现？→ 可能选 Codex 或 OpenCode  
- 需要部署？→ 选 Droid
- Pi 全程协调

## 斜杠命令

### /yolo - YOLO模式（全自动）

```
/yolo 开发一个带JWT认证的REST API
```

自动执行：
1. **分析** - Pi 分析需求，生成执行计划
2. **执行** - 按顺序调用最佳工具
3. **测试** - 自动运行测试
4. **Review** - 自动代码审查
5. **报告** - 生成完整报告

**你只需最终审计！**

### /matrix - 智能单任务

```
/matrix 设计数据库架构        # 自动选择 Claude
/matrix 实现登录API           # 自动选择 Codex
/matrix 全栈开发              # 自动选择 OpenCode
/matrix 部署到生产环境        # 自动选择 Droid
```

### /plan - 生成计划（不执行）

```
/plan 开发微服务系统

输出：
- 阶段1: 架构设计 (Claude)
- 阶段2: 代码实现 (Codex)
- 阶段3: 部署配置 (Droid)
```

## 工具池

| 工具 | 擅长 | 不擅长 |
|------|------|--------|
| **Claude** | 架构设计、复杂推理、审查 | 快速执行 |
| **Codex** | 代码实现、重构、Bug修复 | 系统设计 |
| **OpenCode** | 全栈开发、现代最佳实践 | 遗留代码 |
| **Droid** | 部署、CI/CD、基础设施 | 业务逻辑 |
| **Pi** | 协调、Review、决策 | - |

## YOLO 工作流程

```
用户: /yolo 开发用户认证系统

Agent Matrix:
  ↓ 分析: "需要设计+实现+测试"
  ↓ 规划: 
     阶段1: Claude - 设计架构
     阶段2: Codex - 实现代码
     阶段3: Pi - 运行测试
     阶段4: Claude - 代码审查
  ↓ 执行（全自动）
  ↓ 生成报告

用户: 查看报告 → 审计 → 确认/修改
```

## 对比固定角色

| 传统 | Agent Matrix |
|------|-------------|
| Claude = 设计 | Claude = 设计 **或** 审查 **或** 复杂任务 |
| Codex = 实现 | Codex = 快速编码 **或** OpenCode = 现代全栈 |
| 人工选择工具 | 智能自动选择 |
| 多步骤人工操作 | /yolo 一键完成 |

## 安装

```bash
pi install ~/.pi/extensions/pi-agent-matrix
```

重启 Pi 后使用。

## 示例

### 示例 1: 全栈开发

```
/yolo 开发一个带用户认证的 Todo List 应用，使用 React + Node.js + PostgreSQL
```

可能的执行链：
- OpenCode: 项目初始化 + 前端框架搭建
- Claude: API 设计
- Codex: 后端实现
- OpenCode: 前后端联调
- Pi: 测试
- Claude: 最终审查

### 示例 2: 快速原型

```
/yolo 快速实现一个排序算法可视化页面
```

可能的执行链：
- Codex: 快速实现单文件
- Pi: 本地测试
- Claude: 优化建议

### 示例 3: 企业级部署

```
/yolo 设计并部署微服务架构，包含 CI/CD、监控、日志
```

可能的执行链：
- Claude: 架构设计
- OpenCode: 服务实现
- Droid: Docker + K8s 配置
- Droid: CI/CD 流水线
- Claude: 审查和优化

## 配置

可以自定义工具偏好：

```json
{
  "preferences": {
    "defaultForDesign": "claude",
    "defaultForCoding": "opencode",
    "parallelExecution": true
  }
}
```

## 特点

- ✅ **YOLO模式**: 一次输入，全自动
- ✅ **智能路由**: 不固定角色，按需选择
- ✅ **全流程**: 规划→执行→测试→Review
- ✅ **包含 OpenCode**: 现代全栈开发
- ✅ **可追溯**: 完整日志和报告
- ✅ **可审计**: 用户最终确认
