---
name: drug-medea-target-planning
description: 根据多组学和文献提出治疗靶点的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
license: MIT
metadata:
  author: Artificial Intelligence Group (Adapted from openscientist.ai)
  version: 1.0.0
  source_extensions:
    compatibility:
    - system: Python 3.10+
    allowed-tools:
    - run_shell_command
    - read_file
    - web_fetch
---

# Medea Therapeutic Discovery Agent

## Codex 调用

- **选择**：请求涉及“根据多组学和文献提出治疗靶点”时使用；显式调用 `$drug-medea-target-planning`。
- **输入**：疾病问题、多组学数据集和研究目标。
- **预期产物**：分析计划、执行脚本、文献综合和候选靶点；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Medea is a multi-stage AI agent designed for therapeutic discovery, modeled after 2026 state-of-the-art open source architectures. It executes transparent, multi-step omics analyses.

## When to Use This Skill

*   "Run multi-omics therapeutic discovery pipeline"
*   "Analyze omics data for novel drug targets using Medea"
*   "Perform literature reasoning and consensus reconciliation for target X"

## Core Capabilities

1.  **Research Planning**: Formulates step-by-step omics analysis plans.
2.  **Code Execution**: Generates and executes Python/R scripts for data processing.
3.  **Literature Reasoning**: Retrieves and synthesizes current literature.
4.  **Consensus Stage**: Reconciles experimental evidence with literature to propose high-confidence targets.

## Workflow

1.  **Step 1**: Initialize Medea agent with target disease or omics dataset.
2.  **Step 2**: Execute the multi-stage pipeline across planning, coding, literature review, and consensus validation.

## Example Usage

**User**: "Run Medea analysis on the provided breast cancer multi-omics dataset."

**Agent Action**:
```bash
python3 -m medea.agent --dataset breast_cancer_omics.h5ad --mode full_discovery
```
