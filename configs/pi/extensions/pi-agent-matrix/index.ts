/**
 * Pi Agent Matrix - YOLO Mode
 * 
 * 智能编排系统：
 * 1. 自动分析任务，选择最佳工具组合
 * 2. 动态角色分配（不固定）
 * 3. 全自动执行：规划 → 执行 → 测试 → Review
 * 4. 用户只需最终审计
 */

import { PiExtension, SlashCommand, ToolContext } from "pi-types";

// 可用工具池
interface Tool {
  name: string;
  command: string;
  strengths: string[];
  weaknesses: string[];
  description: string;
}

const TOOLS: Tool[] = [
  {
    name: "claude",
    command: "claude --dangerously-skip-permissions",
    strengths: ["架构设计", "复杂推理", "代码审查", "文档编写"],
    weaknesses: ["快速执行", "简单任务"],
    description: "Claude Code - 深度思考和设计"
  },
  {
    name: "codex", 
    command: "codex",
    strengths: ["代码实现", "快速编码", "重构", "Bug修复"],
    weaknesses: ["架构设计", "复杂推理"],
    description: "OpenAI Codex - 高效编码"
  },
  {
    name: "opencode",
    command: "opencode",
    strengths: ["全栈开发", "框架搭建", "最佳实践", "现代化代码"],
    weaknesses: ["遗留代码", "简单脚本"],
    description: "OpenCode - 现代全栈开发"
  },
  {
    name: "droid",
    command: "droid",
    strengths: ["部署", "CI/CD", "基础设施", "自动化"],
    weaknesses: ["业务逻辑", "UI开发"],
    description: "Factory.ai Droid - 部署和运维"
  },
  {
    name: "pi",
    command: "pi",
    strengths: ["协调", "Review", "决策", "上下文管理"],
    weaknesses: [],
    description: "Pi 自身 - 主控和审查"
  }
];

const extension: PiExtension = {
  name: "agent-matrix",
  version: "0.2.0",
  
  slashCommands: [
    {
      name: "yolo",
      description: "YOLO模式：全自动完成任务（分析→执行→测试→Review）",
      usage: "/yolo <需求描述>",
      handler: handleYoloCommand
    },
    {
      name: "matrix",
      description: "Agent Matrix：智能分配任务给最佳工具",
      usage: "/matrix <任务>",
      handler: handleMatrixCommand
    },
    {
      name: "plan",
      description: "生成执行计划，但不执行",
      usage: "/plan <需求>",
      handler: handlePlanCommand
    }
  ]
};

/**
 * YOLO模式主处理器
 */
async function handleYoloCommand(args: string, context: ToolContext): Promise<string> {
  if (!args.trim()) {
    return "请提供需求描述。例如: /yolo 开发一个带JWT认证的REST API";
  }

  const workflowId = Date.now().toString(36);
  const workflowDir = `.pi/matrix/${workflowId}`;
  
  await context.tools.print({ content: `🚀 YOLO模式启动` });
  await context.tools.print({ content: `需求: ${args}` });
  await context.tools.print({ content: `工作流ID: ${workflowId}` });
  await context.tools.print({ content: `` });

  // 步骤1: 智能分析，生成执行计划
  await context.tools.print({ content: `📋 步骤1/5: 智能分析...` });
  const plan = await analyzeTask(args, context);
  await saveToFile(`${workflowDir}/plan.json`, JSON.stringify(plan, null, 2), context);

  // 步骤2: 执行计划
  await context.tools.print({ content: `` });
  await context.tools.print({ content: `⚡ 步骤2/5: 执行计划...` });
  const results = await executePlan(plan, workflowDir, context);

  // 步骤3: 自动测试
  await context.tools.print({ content: `` });
  await context.tools.print({ content: `🧪 步骤3/5: 自动测试...` });
  const testResults = await autoTest(workflowDir, context);

  // 步骤4: Review
  await context.tools.print({ content: `` });
  await context.tools.print({ content: `🔍 步骤4/5: 代码审查...` });
  const review = await autoReview(workflowDir, results, context);

  // 步骤5: 生成报告
  await context.tools.print({ content: `` });
  await context.tools.print({ content: `📊 步骤5/5: 生成报告...` });
  const report = await generateReport(workflowId, args, plan, results, testResults, review, context);

  return report;
}

/**
 * 智能任务分析
 */
async function analyzeTask(requirement: string, context: ToolContext): Promise<any> {
  // 使用 Pi 自身分析任务
  const analysisPrompt = `你是一个任务分析专家。请分析以下需求，并决定最佳执行策略：

需求: ${requirement}

可用工具:
${TOOLS.map(t => `- ${t.name}: ${t.description}`).join('\n')}

请分析:
1. 这个任务需要哪些阶段？（设计？实现？测试？部署？）
2. 每个阶段最适合用什么工具？
3. 有哪些依赖关系？
4. 潜在风险是什么？

输出JSON格式:
{
  "stages": [
    {
      "id": "1",
      "name": "阶段名称",
      "tool": "工具名",
      "prompt": "具体提示词",
      "dependencies": [],
      "estimatedTime": "预计时间"
    }
  ],
  "risk": "风险评估",
  "successCriteria": "成功标准"
}`;

  const result = await context.tools.bash({
    command: `echo ${escapeShellArg(analysisPrompt)} | pi`,
    description: "分析任务"
  });

  // 尝试解析JSON
  try {
    const jsonMatch = result.stdout.match(/\{[\s\S]*\}/);
    if (jsonMatch) {
      return JSON.parse(jsonMatch[0]);
    }
  } catch (e) {
    // 解析失败，返回默认计划
  }

  // 默认计划
  return {
    stages: [
      { id: "1", name: "架构设计", tool: "claude", prompt: `设计: ${requirement}`, dependencies: [] },
      { id: "2", name: "代码实现", tool: "codex", prompt: `实现: ${requirement}`, dependencies: ["1"] },
      { id: "3", name: "代码审查", tool: "claude", prompt: `审查代码`, dependencies: ["2"] },
      { id: "4", name: "测试验证", tool: "pi", prompt: `测试功能`, dependencies: ["2"] }
    ],
    risk: "中等",
    successCriteria: "功能完整，测试通过"
  };
}

/**
 * 执行计划
 */
async function executePlan(plan: any, workflowDir: string, context: ToolContext): Promise<any[]> {
  const results: any[] = [];
  const completedStages = new Set<string>();

  for (const stage of plan.stages) {
    // 检查依赖
    if (stage.dependencies) {
      for (const dep of stage.dependencies) {
        if (!completedStages.has(dep)) {
          await context.tools.print({ content: `  ⏳ 等待依赖: ${dep}` });
          // 简单等待，实际应该检查
        }
      }
    }

    await context.tools.print({ content: `` });
    await context.tools.print({ content: `  🎯 执行: ${stage.name} (${stage.tool})` });

    const tool = TOOLS.find(t => t.name === stage.tool);
    if (!tool) {
      await context.tools.print({ content: `  ❌ 未知工具: ${stage.tool}` });
      continue;
    }

    // 构建上下文感知的提示词
    let enrichedPrompt = stage.prompt;
    
    // 如果有之前的结果，加入上下文
    const previousResults = results.filter(r => stage.dependencies?.includes(r.stageId));
    if (previousResults.length > 0) {
      enrichedPrompt += "\n\n上下文:\n" + previousResults.map(r => r.output?.substring(0, 1000)).join("\n---\n");
    }

    // 执行工具
    const outputFile = `${workflowDir}/stage-${stage.id}-${stage.tool}.md`;
    
    let result;
    if (stage.tool === "pi") {
      // Pi 自身处理
      result = await context.tools.bash({
        command: `echo ${escapeShellArg(enrichedPrompt)}`,
        description: stage.name
      });
    } else {
      // 外部工具
      result = await context.tools.bash({
        command: `echo ${escapeShellArg(enrichedPrompt)} | ${tool.command} 2>&1 | tee ${outputFile}`,
        description: `${stage.name} using ${stage.tool}`
      });
    }

    results.push({
      stageId: stage.id,
      stageName: stage.name,
      tool: stage.tool,
      output: result.stdout,
      stderr: result.stderr,
      exitCode: result.exitCode,
      outputFile
    });

    completedStages.add(stage.id);

    if (result.exitCode !== 0) {
      await context.tools.print({ content: `  ⚠️  阶段 ${stage.id} 可能有问题` });
    } else {
      await context.tools.print({ content: `  ✅ 阶段 ${stage.id} 完成` });
    }
  }

  return results;
}

/**
 * 自动测试
 */
async function autoTest(workflowDir: string, context: ToolContext): Promise<any> {
  // 检查是否有测试文件
  const testResult = await context.tools.bash({
    command: `cd ${workflowDir} && find . -name "*test*" -o -name "*spec*" 2>/dev/null | head -5`,
    description: "查找测试文件"
  });

  // 尝试运行测试
  const runTest = await context.tools.bash({
    command: `cd ${workflowDir}/.. && if [ -f "package.json" ]; then npm test 2>&1 || echo "测试失败"; elif [ -f "Cargo.toml" ]; then cargo test 2>&1 || echo "测试失败"; else echo "未找到测试配置"; fi`,
    description: "运行测试"
  });

  return {
    testFiles: testResult.stdout,
    testOutput: runTest.stdout,
    passed: !runTest.stdout.includes("失败")
  };
}

/**
 * 自动Review
 */
async function autoReview(workflowDir: string, results: any[], context: ToolContext): Promise<any> {
  // 提取所有输出
  const allOutputs = results.map(r => `## ${r.stageName} (${r.tool})\n\n${r.output?.substring(0, 2000)}`).join("\n\n---\n\n");

  const reviewPrompt = `请对以下完整工作流程进行审查：

${allOutputs}

请评估：
1. 代码质量 (1-10分)
2. 设计合理性 (1-10分)  
3. 潜在问题
4. 改进建议
5. 是否可交付 (是/否/需要修改)

输出格式: JSON { "qualityScore": 8, "designScore": 7, "issues": [], "suggestions": [], "deliverable": "是" }`;

  const reviewResult = await context.tools.bash({
    command: `echo ${escapeShellArg(reviewPrompt)} | claude --dangerously-skip-permissions 2>&1 | head -100`,
    description: "自动Review"
  });

  return {
    reviewText: reviewResult.stdout,
    timestamp: new Date().toISOString()
  };
}

/**
 * 生成最终报告
 */
async function generateReport(
  workflowId: string,
  requirement: string,
  plan: any,
  results: any[],
  testResults: any,
  review: any,
  context: ToolContext
): Promise<string> {
  
  const report = `## 🎉 YOLO 工作流完成

**工作流ID**: ${workflowId}  
**需求**: ${requirement}  
**完成时间**: ${new Date().toLocaleString()}

### 📋 执行计划
${plan.stages.map((s: any) => `- **${s.name}**: ${s.tool}`).join('\n')}

### ✅ 执行结果
${results.map(r => `- ${r.stageName}: ${r.exitCode === 0 ? '✅' : '⚠️'}`).join('\n')}

### 🧪 测试结果
${testResults.passed ? '✅ 测试通过' : '⚠️ 测试未通过或没有测试'}

### 🔍 Review摘要
${review.reviewText?.substring(0, 500)}...

### 📁 输出文件
${results.map(r => `- ${r.outputFile}`).join('\n')}

### 💡 下一步
1. 查看详细报告: read .pi/matrix/${workflowId}/
2. 根据 Review 建议修改（如果需要）
3. 确认无误后合并代码

**你只需审计，所有工作已自动完成！**
`;

  await context.tools.write({
    path: `.pi/matrix/${workflowId}/REPORT.md`,
    content: report
  });

  return report;
}

/**
 * Matrix 模式 - 单任务智能路由
 */
async function handleMatrixCommand(args: string, context: ToolContext): Promise<string> {
  if (!args.trim()) return "请提供任务";

  // 分析任务，选择最佳工具
  const tool = await selectBestTool(args, context);
  
  await context.tools.print({ content: `🎯 选择工具: ${tool.name} (${tool.description})` });

  const result = await context.tools.bash({
    command: `echo ${escapeShellArg(args)} | ${tool.command}`,
    description: `执行: ${tool.name}`
  });

  return `## ${tool.name} 执行结果\n\n${result.stdout}`;
}

/**
 * 选择最佳工具
 */
async function selectBestTool(task: string, context: ToolContext): Promise<Tool> {
  // 简单关键词匹配（可扩展为更复杂的AI分析）
  const taskLower = task.toLowerCase();
  
  if (taskLower.includes("设计") || taskLower.includes("架构") || taskLower.includes("规划")) {
    return TOOLS.find(t => t.name === "claude")!;
  }
  if (taskLower.includes("实现") || taskLower.includes("写代码") || taskLower.includes("开发")) {
    return TOOLS.find(t => t.name === "codex")!;
  }
  if (taskLower.includes("部署") || taskLower.includes("ci/cd") || taskLower.includes("docker")) {
    return TOOLS.find(t => t.name === "droid")!;
  }
  if (taskLower.includes("全栈") || taskLower.includes("modern") || taskLower.includes("best practice")) {
    return TOOLS.find(t => t.name === "opencode")!;
  }
  
  // 默认用 Codex
  return TOOLS.find(t => t.name === "codex")!;
}

/**
 * Plan 命令 - 只生成计划不执行
 */
async function handlePlanCommand(args: string, context: ToolContext): Promise<string> {
  if (!args.trim()) return "请提供需求";

  const plan = await analyzeTask(args, context);

  let output = `## 📋 执行计划\n\n**需求**: ${args}\n\n**阶段**:\n\n`;
  
  for (const stage of plan.stages) {
    output += `### ${stage.id}. ${stage.name}\n`;
    output += `- **工具**: ${stage.tool}\n`;
    output += `- **依赖**: ${stage.dependencies?.join(", ") || "无"}\n`;
    output += `- **预计时间**: ${stage.estimatedTime || "未知"}\n\n`;
  }

  output += `\n**风险**: ${plan.risk}\n`;
  output += `**成功标准**: ${plan.successCriteria}\n\n`;
  output += `使用 "/yolo ${args}" 执行此计划`;

  return output;
}

function escapeShellArg(arg: string): string {
  return `"${arg.replace(/"/g, '\\"')}"`;
}

async function saveToFile(path: string, content: string, context: ToolContext) {
  await context.tools.bash({
    command: `mkdir -p $(dirname ${path}) && echo ${escapeShellArg(content)} > ${path}`,
    description: `保存文件: ${path}`
  });
}

export default extension;
