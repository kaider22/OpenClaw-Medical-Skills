---
name: drug-chemical-property-lookup
description: 从SMILES计算分子描述符并做Lipinski筛选；用于处理有效SMILES字符串及可选立体化学信息。
metadata:
  source_extensions:
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


## At-a-Glance

## Codex 调用

- **选择**：请求涉及“从SMILES计算分子描述符并做Lipinski筛选”时使用；显式调用 `$drug-chemical-property-lookup`。
- **输入**：有效SMILES字符串及可选立体化学信息。
- **预期产物**：MW、logP、TPSA、HBD/HBA、QED和判定；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[molecular_tools.py](molecular_tools.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`rdkit`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

- **description (10-20 chars):** RDKit stats
- **keywords:** SMILES, RDKit, Lipinski, QED, ADMET
- **measurable_outcome:** Return a validated property summary (JSON + Lipinski verdict) for each SMILES within 60 seconds of request.

## Workflow
1. Validate SMILES input; raise explicit errors for invalid syntax.
2. Call helpers from `molecular_tools.py` (`summarize_properties`, `check_lipinski`, etc.).
3. Report MW, logP, TPSA, HBD/HBA, QED, and Lipinski pass/fail with violations.
4. Surface any calculation warnings (e.g., aromaticity perception issues).

## Guardrails
- Never infer stereochemistry; report as "not provided".
- Log invalid SMILES for manual follow-up.
- Communicate that results are screening heuristics, not definitive ADMET outcomes.

## References
- `README.md` plus `molecular_tools.py` for function signatures and dependencies.


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->