---
name: health-wearable-trend-analysis
description: 解析可穿戴心率、活动和睡眠的纵向异常与趋势；用于处理Apple Health、Fitbit或Oura的XML、JSON或CSV。
license: MIT
metadata:
  author: Biomedical AI Team
  version: 1.0.0
  source_extensions:
    keywords:
    - wearable
    - sensor-data
    - health-monitoring
    - anomaly-detection
    - longitudinal-analysis
    measurable_outcome: Detects atrial fibrillation and sleep anomalies with >90% accuracy using continuous PPG and accelerometer data.
    compatibility:
    - system: Python 3.9+
    allowed-tools:
    - run_shell_command
    - read_file
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


# Wearable Analysis Agent

## Codex 调用

- **选择**：请求涉及“解析可穿戴心率、活动和睡眠的纵向异常与趋势”时使用；显式调用 `$health-wearable-trend-analysis`。
- **输入**：Apple Health、Fitbit或Oura的XML、JSON或CSV。
- **预期产物**：清洗指标、异常检测和纵向趋势摘要；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[arrhythmia_detector.py](arrhythmia_detector.py)、[health_copilot.py](health_copilot.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`adapters`、`numpy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Wearable Analysis Agent** processes data from consumer health devices (Apple Watch, Fitbit, Oura) to monitor vital signs, detect arrhythmias, and analyze lifestyle patterns.

## When to Use This Skill

*   When analyzing raw export data from wearables (XML, JSON, CSV).
*   To detect irregular heart rhythms (AFib) from PPG data.
*   For longitudinal sleep quality and circadian rhythm analysis.
*   To correlate activity levels with biomarkers or symptom logs.

## Core Capabilities

1.  **Arrhythmia Detection**: Algorithms to identify Atrial Fibrillation burdens from irregular tachograms.
2.  **Sleep Staging**: classifying wake/REM/deep sleep from movement and heart rate variability.
3.  **Activity Recognition**: Categorizing physical activities and calculating intensity (METs).
4.  **Trend Analysis**: Detecting significant deviations in resting heart rate or HRV over weeks/months.

## Workflow

1.  **Ingest**: Parse standardized health exports (e.g., Apple Health XML).
2.  **Preprocess**: Clean noise, handle missing data, align timestamps.
3.  **Analyze**: Apply specific detection algorithms (e.g., `arrhythmia_detector.py`).
4.  **Report**: Generate summary of anomalies and trends.

## Example Usage

**User**: "Analyze my Apple Health export for signs of irregular heart rhythm last month."

**Agent Action**:
```bash
python3 arrhythmia_detector.py --input apple_health_export.xml --window "last_month"
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->