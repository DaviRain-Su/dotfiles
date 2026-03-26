/**
 * Pi Extension: Claude/Codex Bridge
 * 
 * 提供 /claude 和 /codex 斜杠命令，在 Pi 中直接调用外部 AI 工具
 */

import { PiExtension, SlashCommand, ToolContext } from "pi-types";

const extension: PiExtension = {
  name: "claude-codex-bridge",
  version: "0.1.0",
  
  // 注册斜杠命令
  slashCommands: [
    {
      name: "claude",
      description: "调用 Claude Code 进行设计或分析",
      usage: "/claude <任务描述>",
      handler: handleClaudeCommand
    },
    {
      name: "codex", 
      description: "调用 Codex 进行代码实现",
      usage: "/codex <任务描述>",
      handler: handleCodexCommand
    },
    {
      name: "workflow",
      description: "执行完整工作流: Claude设计 -> Codex实现",
      usage: "/workflow <任务描述>",
      handler: handleWorkflowCommand
    }
  ]
};

/**
 * /claude 命令处理器
 */
async function handleClaudeCommand(
  args: string,
  context: ToolContext
): Promise<string> {
  if (!args.trim()) {
    return "请提供任务描述。例如: /claude 设计用户认证系统";
  }
  
  // 使用 Pi 的 bash tool 调用 Claude
  const result = await context.tools.bash({
    command: `echo ${escapeShellArg(args)} | claude --dangerously-skip-permissions`,
    description: "调用 Claude Code"
  });
  
  if (result.exitCode !== 0) {
    return `Claude 执行失败: ${result.stderr}`;
  }
  
  // 保存到工作目录
  await context.tools.write({
    path: ".pi/claude-output.md",
    content: result.stdout
  });
  
  return `## Claude 输出\n\n${result.stdout}\n\n---\n输出已保存到 .pi/claude-output.md`;
}

/**
 * /codex 命令处理器
 */
async function handleCodexCommand(
  args: string,
  context: ToolContext
): Promise<string> {
  if (!args.trim()) {
    return "请提供任务描述。例如: /codex 实现登录功能";
  }
  
  // 使用 Pi 的 bash tool 调用 Codex
  const result = await context.tools.bash({
    command: `echo ${escapeShellArg(args)} | codex`,
    description: "调用 Codex"
  });
  
  if (result.exitCode !== 0) {
    return `Codex 执行失败: ${result.stderr}`;
  }
  
  // 保存到工作目录
  await context.tools.write({
    path: ".pi/codex-output.md",
    content: result.stdout
  });
  
  return `## Codex 输出\n\n${result.stdout}\n\n---\n输出已保存到 .pi/codex-output.md`;
}

/**
 * /workflow 命令处理器
 * 执行完整工作流: Claude设计 -> Codex实现
 */
async function handleWorkflowCommand(
  args: string,
  context: ToolContext
): Promise<string> {
  if (!args.trim()) {
    return "请提供任务描述。例如: /workflow 开发用户认证系统";
  }
  
  const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
  const workflowDir = `.pi/workflow/${timestamp}`;
  
  await context.tools.bash({
    command: `mkdir -p ${workflowDir}`,
    description: "创建工作流目录"
  });
  
  // Stage 1: Claude 设计
  await context.tools.print({
    content: "🎨 Stage 1/3: Claude 设计..."
  });
  
  const designPrompt = `你是一个系统架构师。请为以下任务设计详细的技术方案：\n\n任务: ${args}\n\n请提供:\n1. 系统架构设计\n2. 核心组件和接口\n3. 数据模型\n4. 实现步骤\n5. 技术选型建议`;
  
  const designResult = await context.tools.bash({
    command: `echo ${escapeShellArg(designPrompt)} | claude --dangerously-skip-permissions | tee ${workflowDir}/01-design.md`,
    description: "Claude 设计阶段"
  });
  
  if (designResult.exitCode !== 0) {
    return `设计阶段失败: ${designResult.stderr}`;
  }
  
  // Stage 2: Codex 实现
  await context.tools.print({
    content: "💻 Stage 2/3: Codex 实现..."
  });
  
  const implPrompt = `你是一个代码实现专家。请基于以下设计实现代码：\n\n设计文档:\n${designResult.stdout}\n\n请实现完整的可运行代码。`;
  
  const implResult = await context.tools.bash({
    command: `echo ${escapeShellArg(implPrompt)} | codex | tee ${workflowDir}/02-implementation.md`,
    description: "Codex 实现阶段"
  });
  
  if (implResult.exitCode !== 0) {
    return `实现阶段失败: ${implResult.stderr}`;
  }
  
  // Stage 3: 准备 Review
  await context.tools.print({
    content: "🔍 Stage 3/3: 准备 Review..."
  });
  
  const reviewPrompt = `请审查以下设计和实现：\n\n## 设计\n${designResult.stdout}\n\n## 实现\n${implResult.stdout}\n\n请评估：\n1. 设计是否完整？\n2. 实现是否符合设计？\n3. 代码质量如何？\n4. 改进建议`;
  
  await context.tools.write({
    path: `${workflowDir}/03-review-prompt.md`,
    content: reviewPrompt
  });
  
  // 生成报告
  const report = `## 工作流完成报告\n\n**任务**: ${args}\n**时间**: ${timestamp}\n**目录**: ${workflowDir}\n\n### 阶段 1: Claude 设计 ✅\n- 输出: ${workflowDir}/01-design.md\n- 大小: ${designResult.stdout.length} 字符\n\n### 阶段 2: Codex 实现 ✅\n- 输出: ${workflowDir}/02-implementation.md\n- 大小: ${implResult.stdout.length} 字符\n\n### 阶段 3: Review 准备 ✅\n- 提示: ${workflowDir}/03-review-prompt.md\n\n### 下一步\n请在 Pi 中查看输出文件，进行人工 review。`;
  
  await context.tools.write({
    path: `${workflowDir}/README.md`,
    content: report
  });
  
  return report;
}

/**
 * Shell 参数转义
 */
function escapeShellArg(arg: string): string {
  return `"${arg.replace(/"/g, '\\"')}"`;
}

export default extension;
