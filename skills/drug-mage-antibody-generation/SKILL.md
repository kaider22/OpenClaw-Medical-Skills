---
name: drug-mage-antibody-generation
description: 按抗原序列生成抗体候选并记录模型元数据；用于处理抗原序列、候选数、模型仓库和GPU环境。
license: MIT
metadata:
  author: MAGE Team
  version: 1.0.0
  source_extensions:
    keywords:
    - antibody
    - antigen
    - FASTA
    - generation
    - validation
    measurable_outcome: Generate the requested number of antibody sequences (default ≥5) with metadata (model checkpoint, seed) and deliver FASTA files within 10 minutes.
    compatibility:
    - system: Python 3.9+ / GPU
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


# MAGE (Monoclonal Antibody Generator)

## Codex 调用

- **选择**：请求涉及“按抗原序列生成抗体候选并记录模型元数据”时使用；显式调用 `$drug-mage-antibody-generation`。
- **输入**：抗原序列、候选数、模型仓库和GPU环境。
- **预期产物**：FASTA抗体序列、种子和模型信息；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[repo/generate_antibodies.py](repo/generate_antibodies.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`datasets`、`pandas`、`progen`、`tokenizers`、`torch`、`transformers`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Run the MAGE antibody generation workflow to propose antigen-conditioned antibody sequences for downstream structural validation.

## Workflow
1. **Prep env:** `cd repo` and install dependencies, then point to GPU if available.
2. **Run generator:** `python generate_antibodies.py --antigen_sequence <SEQ> --num_candidates N --output_dir ./results`.
3. **Collect outputs:** Provide FASTA paths + metadata, optionally translate into JSON manifest.
4. **Recommend validation:** Suggest AlphaFold/Rosetta checks and wet-lab follow-up.

## Guardrails
- Never imply binding efficacy without structural/experimental confirmation.
- Track model version + seeds to ensure reproducibility.
- Encourage downstream filtering (liability motifs, developability metrics).

## References
- Source instructions in `README.md` and repo scripts.


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->