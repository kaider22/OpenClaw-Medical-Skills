---
name: imaging-multimodal-medical-imaging
description: 对X光、CT或MRI图像做初步异常识别的本地原型指南；代码含模拟或替代分支，真实计算与服务结果需分别核验。
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



# Multimodal Medical Imaging Analysis

## Codex 调用

- **选择**：请求涉及“对X光、CT或MRI图像做初步异常识别”时使用；显式调用 `$imaging-multimodal-medical-imaging`。
- **输入**：JPG/PNG图像及临床问题或报告要求。
- **预期产物**：JSON影像发现、置信度和推理说明；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[multimodal_agent.py](multimodal_agent.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **原型边界**：随附代码含模拟、mock 或替代分支。运行时明确记录实际走到的分支；模拟结果不能标作真实查询、模型预测或实验验证。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Multimodal Medical Imaging Analysis Skill** leverages state-of-the-art Vision-Language Models (VLMs) like Gemini 1.5 Pro and GPT-4o to interpret medical imagery alongside clinical text.

## When to Use This Skill

*   When you need a preliminary screening of medical images.
*   When correlating visual findings with textual clinical notes.
*   To generate structured reports (DICOM-SR-like) from raw images.

## Core Capabilities

1.  **Anomaly Detection**: Identify potential pathologies in X-rays, CTs, etc.
2.  **Report Generation**: Draft radiology reports in standard formats.
3.  **VQA (Visual Question Answering)**: Answer specific questions about an image (e.g., "Is there a fracture in the left femur?").

## Workflow

1.  **Input**: Provide an image file path (JPG, PNG) and a specific clinical question or "generate report" instruction.
2.  **Analyze**: The agent sends the image and prompt to the VLM.
3.  **Output**: Returns a JSON object with findings, confidence scores, and reasoning.

## Example Usage

**User**: "Analyze this chest X-ray for pneumonia."

**Agent Action**:
```bash
python3 multimodal_agent.py \
    --image "/path/to/cxr.jpg" \
    --prompt "Check for signs of pneumonia and consolidation."
```



<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->