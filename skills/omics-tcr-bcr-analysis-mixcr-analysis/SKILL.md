---
name: omics-tcr-bcr-analysis-mixcr-analysis
description: 提供从TCR/BCR FASTQ完成V(D)J比对和克隆组装的方法与调用指南；用于处理配对FASTQ、物种、协议和MiXCR预设。
metadata:
  source_extensions:
    tool_type: cli
    primary_tool: MiXCR
---

## Version Compatibility

Reference examples tested with: MiXCR 4.6+, pandas 2.2+

Before using code patterns, verify installed versions match. If versions differ:
- Python: `pip show <package>` then `help(module.function)` to check signatures
- CLI: `<tool> --version` then `<tool> --help` to confirm flags

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# MiXCR Analysis

## Codex 调用

- **选择**：请求涉及“从TCR/BCR FASTQ完成V(D)J比对和克隆组装”时使用；显式调用 `$omics-tcr-bcr-analysis-mixcr-analysis`。
- **输入**：配对FASTQ、物种、协议和MiXCR预设。
- **预期产物**：clonotypes表、CDR3及V-D-J注释、质量报告；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`MiXCR`、`pandas`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Extract TCR/BCR clonotypes from my sequencing data"** → Assemble immune receptor sequences from raw reads, identify V(D)J gene segments, and generate clonotype tables for repertoire analysis.
- CLI: `mixcr analyze` for end-to-end TCR/BCR extraction and clonotype assembly

## Complete Workflow (Recommended)

**Goal:** Run end-to-end V(D)J alignment and clonotype assembly from raw FASTQ files in a single command.

**Approach:** Use MiXCR's preset-based `analyze` command which chains alignment, assembly, and export steps automatically.

```bash
mixcr analyze generic-tcr-amplicon \
    --species human \
    --rna \
    --rigid-left-alignment-boundary \
    --floating-right-alignment-boundary C \
    input_R1.fastq.gz input_R2.fastq.gz \
    output_prefix

mixcr analyze 10x-vdj-tcr \
    input_R1.fastq.gz input_R2.fastq.gz \
    output_prefix
```

## Step-by-Step Workflow

**Goal:** Process immune repertoire data through individual alignment, refinement, assembly, and export stages for fine-grained control.

**Approach:** Chain MiXCR CLI steps sequentially: align reads to V(D)J references, refine UMIs and sort, assemble clonotypes, then export results.

### Step 1: Align Reads

```bash
mixcr align \
    --species human \
    --preset generic-tcr-amplicon-umi \
    input_R1.fastq.gz input_R2.fastq.gz \
    alignments.vdjca

mixcr align \
    --species human \
    --rna \
    -OallowPartialAlignments=true \
    input_R1.fastq.gz input_R2.fastq.gz \
    alignments.vdjca
```

### Step 2: Refine and Assemble

```bash
mixcr refineTagsAndSort alignments.vdjca alignments_refined.vdjca

mixcr assemble alignments_refined.vdjca clones.clns
```

### Step 3: Export Results

```bash
mixcr exportClones \
    --chains TRB \
    --preset full \
    clones.clns \
    clones.tsv

mixcr exportClones \
    --chains TRB \
    -cloneId -readCount -readFraction \
    -nFeature CDR3 -aaFeature CDR3 \
    -vGene -dGene -jGene \
    clones.clns \
    clones_custom.tsv
```

## Preset Protocols

| Protocol | Use Case |
|----------|----------|
| `generic-tcr-amplicon` | TCR amplicon sequencing |
| `generic-bcr-amplicon` | BCR amplicon sequencing |
| `generic-tcr-amplicon-umi` | TCR amplicon with UMIs |
| `rnaseq-tcr` | TCR extraction from bulk RNA-seq |
| `rnaseq-bcr` | BCR extraction from bulk RNA-seq |
| `10x-vdj-tcr` | 10x Genomics TCR enrichment |
| `10x-vdj-bcr` | 10x Genomics BCR enrichment |
| `takara-human-tcr-v2` | Takara SMARTer kit |

## Species Support

```bash
mixcr align --species human ...
mixcr align --species mmu ...

# Available: human, mmu, rat, rhesus, dog, pig, rabbit, chicken
```

## Output Format

| Column | Description |
|--------|-------------|
| cloneId | Unique clone identifier |
| readCount | Number of reads |
| cloneFraction | Proportion of repertoire |
| nSeqCDR3 | Nucleotide CDR3 sequence |
| aaSeqCDR3 | Amino acid CDR3 sequence |
| allVHitsWithScore | V gene assignments |
| allDHitsWithScore | D gene assignments |
| allJHitsWithScore | J gene assignments |

## Quality Metrics

**Goal:** Assess alignment and assembly quality to identify problematic samples.

**Approach:** Export MiXCR alignment reports and check key success rate metrics.

```bash
mixcr exportReports alignments.vdjca

# Key metrics:
# - Successfully aligned reads (>80% is good)
# - CDR3 found (>70% of aligned)
# - Clonotype count (varies by sample type)
```

## Parse MiXCR Output in Python

**Goal:** Load MiXCR clonotype tables into pandas for downstream analysis and integration.

**Approach:** Read tab-delimited export files and rename columns to standardized names.

```python
import pandas as pd

def load_mixcr_clones(filepath):
    df = pd.read_csv(filepath, sep='\t')
    df = df.rename(columns={
        'readCount': 'count',
        'cloneFraction': 'frequency',
        'aaSeqCDR3': 'cdr3_aa',
        'nSeqCDR3': 'cdr3_nt'
    })
    return df
```

## Related Skills

- vdjtools-analysis - Downstream diversity analysis
- scirpy-analysis - Single-cell VDJ integration
- repertoire-visualization - Visualize MiXCR output
