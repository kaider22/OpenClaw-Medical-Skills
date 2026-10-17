---
name: research-biomedical-data-analysis
description: 提供指导生物医学数据清洗、统计建模和可视化的方法与调用指南；用于处理CSV、Parquet、SQL表及分析目标。
license: MIT
metadata:
  author: BioSkills Team
  version: 1.0.0
  source_extensions:
    keywords:
    - pandas
    - R-tidyverse
    - SQL
    - visualization
    - reproducible
    measurable_outcome: Deliver a cleaned dataset + statistical summary + at least one visualization or dashboard spec for each request within 1 working session (≤30 minutes).
    compatibility:
    - system: Python 3.9+ / R 4.0+
    allowed-tools:
    - run_shell_command
    - read_file
    - python_repl
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


# Biomedical Data Analysis

## Codex 调用

- **选择**：请求涉及“指导生物医学数据清洗、统计建模和可视化”时使用；显式调用 `$research-biomedical-data-analysis`。
- **输入**：CSV、Parquet、SQL表及分析目标。
- **预期产物**：清洗数据、统计摘要、图形或仪表板规范；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Run the cross-language data analysis workflows (Python, R, SQL, Tableau/Power BI) described in this module to clean, analyze, and visualize biomedical datasets end-to-end.

## Workflow
1. **Scope request:** Identify analysis_type (`exploratory`, `statistical`, `predictive`, `visualization`) and required language/tooling.
2. **Acquire data:** Load from CSV/Parquet/SQL using pandas, tidyverse, or connectors described in `README.md`.
3. **Process:** Apply wrangling, descriptive stats, modeling, or SQL aggregations as listed in the capability tables.
4. **Visualize:** Choose Matplotlib/Seaborn/Plotly for inline plots or emit Tableau/Power BI specs per need.
5. **Document:** Provide code snippets + outputs, noting package versions and any assumptions.

## Guardrails
- Use reproducible scripts or notebooks—avoid manual spreadsheet edits.
- Keep PHI secure; when touching EHR-level SQL list filters minimizing data exposure.
- Clearly separate exploratory findings from validated statistical conclusions.

## References
- Capability tables, code samples, and parameter definitions live in `README.md` (plus `tutorials/README.md` for step-by-step lessons).


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->