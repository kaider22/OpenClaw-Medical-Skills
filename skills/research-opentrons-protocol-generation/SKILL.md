---
name: research-opentrons-protocol-generation
description: 把文字实验步骤生成Opentrons Python协议的本地原型指南；代码含模拟或替代分支，真实计算与服务结果需分别核验。
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



# Opentrons Protocol Agent

## Codex 调用

- **选择**：请求涉及“把文字实验步骤生成Opentrons Python协议”时使用；显式调用 `$research-opentrons-protocol-generation`。
- **输入**：来源、目的地、体积、耗材和机器人型号。
- **预期产物**：可供仿真的Opentrons Python协议文件；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[opentrons_generator.py](opentrons_generator.py)、[opentrons_protocol_template.py](opentrons_protocol_template.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`opentrons`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **原型边界**：随附代码含模拟、mock 或替代分支。运行时明确记录实际走到的分支；模拟结果不能标作真实查询、模型预测或实验验证。
- **原项目模块**：代码仍引用 `optimizer.meta_prompter`；选择旧代码路径前检查该分支是否有真实实现。Codex 文档工作流不自称执行了这些模块。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Opentrons Protocol Agent** bridges the gap between experimental design and physical execution by translating instructions into Opentrons Python API scripts.

## When to Use This Skill

*   When you need to automate a liquid handling task (PCR prep, ELISA, serial dilution).
*   When you have a text description of a lab protocol and need code for the robot.
*   To validate if a requested protocol is feasible with available labware.

## Core Capabilities

1.  **Protocol Generation**: Creates valid `.py` files for OT-2/Flex.
2.  **Labware Validation**: Checks compatibility of plates and tipracks.
3.  **Volume Calculation**: Automates liquid transfer math (e.g., dilution factors).

## Workflow

1.  **Describe**: Provide the experiment details (source, destination, volumes).
2.  **Generate**: The agent uses the `opentrons_protocol_template.py` or internal logic to draft the script.
3.  **Review**: The user (or a simulator agent) reviews the code for safety.

## Example Usage

**User**: "Create a protocol for 1:2 serial dilution in a 96-well plate."

**Agent Action**:
(Uses an LLM to fill in the template or generate code)
```bash
# Agent writes the file to disk
python3 -m opentrons.simulate generated_protocol.py
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->