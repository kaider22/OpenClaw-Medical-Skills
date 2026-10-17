---
name: omics-epitranscriptomics-m6a-peak-calling
description: 提供从MeRIP-seq IP/Input比对结果识别m6A峰的方法与调用指南；用于处理IP/Input BAM、生物重复、GTF、基因组版本。
metadata:
  source_extensions:
    tool_type: mixed
    primary_tool: exomePeak2
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


# m6A Peak Calling

## Codex 调用

- **选择**：请求涉及“从MeRIP-seq IP/Input比对结果识别m6A峰”时使用；显式调用 `$omics-epitranscriptomics-m6a-peak-calling`。
- **输入**：IP/Input BAM、生物重复、GTF、基因组版本。
- **预期产物**：BED格式峰集及富集/显著性筛选结果；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`exomePeak2`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## exomePeak2 (Recommended)

```r
library(exomePeak2)

# Peak calling with biological replicates
result <- exomePeak2(
    bam_ip = c('IP_rep1.bam', 'IP_rep2.bam'),
    bam_input = c('Input_rep1.bam', 'Input_rep2.bam'),
    gff = 'genes.gtf',
    genome = 'hg38',
    paired_end = TRUE
)

# Export peaks
exportResults(result, format = 'BED')
```

## MACS3 Alternative

```bash
# Call peaks treating input as control
macs3 callpeak \
    -t IP_rep1.bam IP_rep2.bam \
    -c Input_rep1.bam Input_rep2.bam \
    -f BAMPE \
    -g hs \
    -n m6a_peaks \
    --nomodel \
    --extsize 150 \
    -q 0.05
```

## MeTPeak

```r
library(MeTPeak)

# GTF-aware peak calling
metpeak(
    IP_BAM = c('IP_rep1.bam', 'IP_rep2.bam'),
    INPUT_BAM = c('Input_rep1.bam', 'Input_rep2.bam'),
    GENE_ANNO_GTF = 'genes.gtf',
    OUTPUT_DIR = 'metpeak_output'
)
```

## Peak Filtering

```bash
# Filter by fold enrichment and q-value
# FC > 2, q < 0.05 typical thresholds
awk '$7 > 2 && $9 < 0.05' peaks.xls > filtered_peaks.bed
```

## Related Skills

- merip-preprocessing - Prepare data for peak calling
- m6a-differential - Compare peaks between conditions
- chip-seq/peak-calling - Similar concepts


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->