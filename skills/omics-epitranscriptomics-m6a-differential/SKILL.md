---
name: omics-epitranscriptomics-m6a-differential
description: 提供比较MeRIP-seq条件间m6A差异位点/峰的方法与调用指南；用于处理IP/Input BAM、GTF、基因组版本和条件设计。
metadata:
  source_extensions:
    tool_type: r
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


# Differential m6A Analysis

## Codex 调用

- **选择**：请求涉及“比较MeRIP-seq条件间m6A差异位点/峰”时使用；显式调用 `$omics-epitranscriptomics-m6a-differential`。
- **输入**：IP/Input BAM、GTF、基因组版本和条件设计。
- **预期产物**：差异m6A位点、log2FC、padj及显著集合；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`exomePeak2`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## exomePeak2 Differential Analysis

```r
library(exomePeak2)

# Define sample design
# condition: factor for comparison
design <- data.frame(
    condition = factor(c('ctrl', 'ctrl', 'treat', 'treat'))
)

# Differential peak calling
result <- exomePeak2(
    bam_ip = c('ctrl_IP1.bam', 'ctrl_IP2.bam', 'treat_IP1.bam', 'treat_IP2.bam'),
    bam_input = c('ctrl_Input1.bam', 'ctrl_Input2.bam', 'treat_Input1.bam', 'treat_Input2.bam'),
    gff = 'genes.gtf',
    genome = 'hg38',
    experiment_design = design
)

# Get differential sites
diff_sites <- results(result, contrast = c('condition', 'treat', 'ctrl'))
```

## QNB for Differential Methylation

```r
library(QNB)

# Requires count matrices from peak regions
# IP and input counts per sample
qnb_result <- qnbtest(
    IP_count_matrix,
    Input_count_matrix,
    group = c(1, 1, 2, 2)  # 1=ctrl, 2=treat
)

# Filter significant
# padj < 0.05, |log2FC| > 1
sig <- qnb_result[qnb_result$padj < 0.05 & abs(qnb_result$log2FC) > 1, ]
```

## Visualization

```r
library(ggplot2)

# Volcano plot
ggplot(diff_sites, aes(x = log2FoldChange, y = -log10(padj))) +
    geom_point(aes(color = padj < 0.05 & abs(log2FoldChange) > 1)) +
    geom_hline(yintercept = -log10(0.05), linetype = 'dashed') +
    geom_vline(xintercept = c(-1, 1), linetype = 'dashed')
```

## Related Skills

- m6a-peak-calling - Identify peaks first
- differential-expression/de-results - Similar statistical concepts
- modification-visualization - Plot differential sites


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->