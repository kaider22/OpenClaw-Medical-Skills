---
name: research-bayesian-optimization
description: 基于历史实验用高斯过程提出下一组参数；用于处理参数-结果历史、搜索边界和目标指标。
metadata:
  source_extensions:
    measurable_outcome: Execute skill workflow successfully with valid output within 15 minutes.
    allowed-tools:
    - read_file
    - run_shell_command
---
<!--
# COPYRIGHT NOTICE
# This file is part of the "Universal Biomedical Skills" project.
# Copyright (c) 2026 MD BABU MIA, PhD <md.babu.mia@mssm.edu>
# All Rights Reserved.
#
# This code is proprietary and confidential.
# Unauthorized copying of this file, via any medium is strictly prohibited.
#
# Provenance: Authenticated by MD BABU MIA

-->



# Bayesian Optimization (Self-Driving Lab)

## Codex 调用

- **选择**：请求涉及“基于历史实验用高斯过程提出下一组参数”时使用；显式调用 `$research-bayesian-optimization`。
- **输入**：参数-结果历史、搜索边界和目标指标。
- **预期产物**：下一实验参数及代理模型预测；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[bayesian_optimization.py](bayesian_optimization.py)、[stats_essentials.py](stats_essentials.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`ast`、`numpy`、`scipy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Bayesian Optimizer** allows agents to efficiently explore a parameter space to maximize a target metric (yield, purity, binding affinity) with minimal experiments. It uses Gaussian Processes to model uncertainty and the Upper Confidence Bound (UCB) acquisition function.

## When to Use This Skill

*   When experiments are expensive or time-consuming.
*   To autonomously tune hyperparameters for a machine learning model.
*   To optimize reaction conditions (temperature, pH, concentration).

## Core Capabilities

1.  **Next Step Proposal**: Suggests the next best experiment parameters.
2.  **Surrogate Modeling**: Predicts outcomes for untested parameters.
3.  **Exploration/Exploitation**: Balances trying new things vs. refining known good results.

## Workflow

1.  **Input**: History of past experiments (params -> results) and bounds.
2.  **Process**: Fits a Gaussian Process to the data.
3.  **Output**: Returns the parameters for the next experiment.

## Example Usage

**User**: "Given these past results, what temperature and pH should I try next?"

**Agent Action**:
```bash
python3 bayesian_optimization.py \
    --history "[[20, 7.0, 0.5], [25, 6.5, 0.6]]" \
    --bounds "[[10, 40], [5, 9]]" \
    --output next_experiment.json
```



<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->