---
name: omics-clip-seq-clip-motif-analysis
description: 提供在CLIP峰中寻找RBP序列偏好和富集motif的方法与调用指南；用于处理峰BED、参考序列、背景和motif参数。
metadata:
  source_extensions:
    tool_type: cli
    primary_tool: HOMER
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


# CLIP Motif Analysis

## Codex 调用

- **选择**：请求涉及“在CLIP峰中寻找RBP序列偏好和富集motif”时使用；显式调用 `$omics-clip-seq-clip-motif-analysis`。
- **输入**：峰BED、参考序列、背景和motif参数。
- **预期产物**：de novo/已知motif及富集结果；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`HOMER`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## HOMER De Novo Motifs

```bash
# Extract sequences from peaks
bedtools getfasta -fi genome.fa -bed peaks.bed -fo peaks.fa

# Find enriched motifs
findMotifs.pl peaks.fa fasta output_dir \
    -len 6,7,8 \
    -rna
```

## MEME-ChIP

```bash
meme-chip -oc output_dir \
    -dna \
    peaks.fa
```

## Known Motif Enrichment

```bash
# HOMER known motif scan
findMotifs.pl peaks.fa fasta output_dir \
    -rna \
    -known
```

## Related Skills

- clip-peak-calling - Get peaks
- chip-seq/motif-analysis - General motif concepts


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->