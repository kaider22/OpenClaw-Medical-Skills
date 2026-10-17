---
name: omics-isoform-switching
description: 提供检测条件间主导转录本切换并评估NMD、ORF和结构后果的方法与调用指南；用于处理Salmon定量、设计矩阵、GTF和转录本FASTA。
metadata:
  source_extensions:
    tool_type: r
    primary_tool: IsoformSwitchAnalyzeR
---

## Version Compatibility

Reference examples tested with: Salmon 1.10+

Before using code patterns, verify installed versions match. If versions differ:
- R: `packageVersion('<pkg>')` then `?function_name` to verify parameters

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Isoform Switching Analysis

## Codex 调用

- **选择**：请求涉及“检测条件间主导转录本切换并评估NMD、ORF和结构后果”时使用；显式调用 `$omics-isoform-switching`。
- **输入**：Salmon定量、设计矩阵、GTF和转录本FASTA。
- **预期产物**：显著切换表、后果注释、富集结果和图；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`IsoformSwitchAnalyzeR`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Identify isoform switches and predict their functional consequences on protein structure and function.

## IsoformSwitchAnalyzeR Workflow

**Goal:** Identify genes where the dominant isoform switches between conditions.

**Approach:** Import Salmon quantification, filter low-expression isoforms, and test for isoform usage changes with DEXSeq-based statistics.

**"Analyze isoform switching"** -> Import transcript quantification, test for dominant isoform changes, and assess functional consequences.
- R: `IsoformSwitchAnalyzeR` (importRdata + isoformSwitchTestDEXSeq)

```r
library(IsoformSwitchAnalyzeR)

# Import transcript quantification from Salmon
salmonQuant <- importIsoformExpression(
    parentDir = 'salmon_quant/',
    addIsofomIdAsColumn = TRUE
)

# Create switch analysis object
switchAnalyzeRlist <- importRdata(
    isoformCountMatrix = salmonQuant$counts,
    isoformRepExpression = salmonQuant$abundance,
    designMatrix = data.frame(
        sampleID = colnames(salmonQuant$counts),
        condition = c('control', 'control', 'control', 'treatment', 'treatment', 'treatment')
    ),
    isoformExonAnnoation = 'annotation.gtf',
    isoformNtFasta = 'transcripts.fa'
)

# Filter lowly expressed isoforms
switchAnalyzeRlist <- preFilter(
    switchAnalyzeRlist,
    geneExpressionCutoff = 1,  # Minimum TPM
    isoformExpressionCutoff = 0,
    removeSingleIsoformGenes = TRUE
)

# Test for isoform switches
switchAnalyzeRlist <- isoformSwitchTestDEXSeq(
    switchAnalyzeRlist,
    reduceToSwitchingGenes = TRUE
)
```

## Functional Annotation

**Goal:** Predict how isoform switches alter protein domains, coding potential, and localization.

**Approach:** Extract isoform sequences, run external annotation tools (CPC2, Pfam, SignalP, IUPred2), and import results back into the switch analysis object.

```r
# Extract sequences for external analysis
switchAnalyzeRlist <- extractSequence(
    switchAnalyzeRlist,
    pathToOutput = 'sequences/',
    writeToFile = TRUE
)

# Run external tools and import results:
# - CPC2 for coding potential
# - Pfam for protein domains
# - SignalP for signal peptides
# - IUPred2 for intrinsic disorder

# After running external tools, import results
switchAnalyzeRlist <- analyzeCPC2(
    switchAnalyzeRlist,
    pathToCPC2resultFile = 'cpc2_results.txt',
    removeNoncodinORFs = TRUE
)

switchAnalyzeRlist <- analyzePFAM(
    switchAnalyzeRlist,
    pathToPFAMresultFile = 'pfam_results.txt'
)

switchAnalyzeRlist <- analyzeSignalP(
    switchAnalyzeRlist,
    pathToSignalPresultFile = 'signalp_results.txt'
)

switchAnalyzeRlist <- analyzeIUPred2A(
    switchAnalyzeRlist,
    pathToIUPred2AresultFile = 'iupred2_results.txt'
)
```

## Consequence Analysis

**Goal:** Determine which isoform switches cause functional changes (NMD, domain loss, coding potential shifts).

**Approach:** Run analyzeSwitchConsequences across multiple consequence types and extract switches with confirmed functional impact.

```r
# Analyze functional consequences of switches
switchAnalyzeRlist <- analyzeSwitchConsequences(
    switchAnalyzeRlist,
    consequencesToAnalyze = c(
        'intron_retention',
        'coding_potential',
        'ORF_seq_similarity',
        'NMD_status',
        'domains_identified',
        'signal_peptide_identified'
    ),
    dIFcutoff = 0.1,  # Minimum isoform fraction change
    showProgress = TRUE
)

# Extract significant switches
significantSwitches <- extractSwitchSummary(
    switchAnalyzeRlist,
    filterForConsequences = TRUE
)

print(significantSwitches)
```

## Visualization

**Goal:** Visualize isoform switch events and summarize functional consequence patterns.

**Approach:** Generate per-gene switch plots showing isoform usage changes, and create global summaries of consequence enrichment.

```r
# Plot individual gene switches
switchPlot(
    switchAnalyzeRlist,
    gene = 'GENE_OF_INTEREST',
    condition1 = 'control',
    condition2 = 'treatment'
)

# Summary of consequence types
extractConsequenceSummary(
    switchAnalyzeRlist,
    consequencesToAnalyze = 'all',
    plotGenes = FALSE
)

# Enrichment of consequences
extractConsequenceEnrichment(
    switchAnalyzeRlist,
    consequencesToAnalyze = 'all'
)
```

## Significance Thresholds

| Parameter | Default | Description |
|-----------|---------|-------------|
| Switch q-value | < 0.05 | Significance of isoform switch |
| dIF (delta isoform fraction) | > 0.1 | Minimum usage change |
| Consequence q-value | < 0.05 | Significance of consequence |

## Consequence Types

| Consequence | Impact |
|-------------|--------|
| NMD sensitive | Transcript targeted for degradation |
| Domain loss/gain | Altered protein function |
| ORF disruption | Truncated/altered protein |
| Signal peptide loss | Changed localization |
| Coding potential loss | Switch to non-coding |

## Related Skills

- differential-splicing - Identify differential events first
- splicing-quantification - PSI-level analysis
- pathway-analysis/go-enrichment - Pathway enrichment of switching genes
