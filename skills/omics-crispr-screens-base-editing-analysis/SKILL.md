---
name: omics-crispr-screens-base-editing-analysis
description: 提供量化碱基编辑、旁观者编辑和indel频率的方法与调用指南；用于处理扩增子FASTQ、扩增子序列、guide和预期编辑。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: CRISPResso2
---

## Version Compatibility

Reference examples tested with: CRISPResso2 2.2+, pandas 2.2+

Before using code patterns, verify installed versions match. If versions differ:
- Python: `pip show <package>` then `help(module.function)` to check signatures
- CLI: `<tool> --version` then `<tool> --help` to confirm flags

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Base Editing Analysis

## Codex 调用

- **选择**：请求涉及“量化碱基编辑、旁观者编辑和indel频率”时使用；显式调用 `$omics-crispr-screens-base-editing-analysis`。
- **输入**：扩增子FASTQ、扩增子序列、guide和预期编辑。
- **预期产物**：编辑效率、旁观者谱、indel率和窗口统计；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`CRISPResso2`、`pandas`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Analyze my base editing outcomes"** → Quantify base editing efficiency, bystander edits, and indel frequencies from amplicon sequencing data for CBE, ABE, and prime editing experiments.
- CLI: `CRISPResso --fastq_r1 reads.fq --amplicon_seq ATGC --base_editor_output`

## CRISPResso2 for Base Editing

**Goal:** Quantify base editing efficiency and bystander edits from amplicon sequencing.

**Approach:** Run CRISPResso with --base_editor_output and the expected edited amplicon sequence to measure target base conversion, bystander edits, and indel frequencies.

```bash
# Analyze base editing with expected outcome
CRISPResso --fastq_r1 reads.fq.gz \
    --amplicon_seq ATGCGATCGATCGATCGATCGATCG \
    --guide_seq TCGATCGATCGATCGAT \
    --expected_hdr_amplicon_seq ATGCGATCGATCGTTCGATCGATCG \
    --base_editor_output \
    -o results/
```

## Key Metrics

| Metric | Description |
|--------|-------------|
| Editing efficiency | % reads with target base change |
| Bystander edits | Unintended edits in editing window |
| Indel frequency | Insertions/deletions (should be low) |
| Purity | Target edit without bystanders |

## Base Editor Types

### Cytosine Base Editors (CBE)

```bash
# C->T conversion (or G->A on opposite strand)
CRISPResso --fastq_r1 reads.fq.gz \
    --amplicon_seq $AMPLICON \
    --guide_seq $GUIDE \
    --base_editor_output \
    --conversion_nuc_from C \
    --conversion_nuc_to T
```

### Adenine Base Editors (ABE)

```bash
# A->G conversion (or T->C on opposite strand)
CRISPResso --fastq_r1 reads.fq.gz \
    --amplicon_seq $AMPLICON \
    --guide_seq $GUIDE \
    --base_editor_output \
    --conversion_nuc_from A \
    --conversion_nuc_to G
```

## Prime Editing Analysis

```bash
# Prime editing with pegRNA
CRISPResso --fastq_r1 reads.fq.gz \
    --amplicon_seq $AMPLICON \
    --guide_seq $SPACER \
    --expected_hdr_amplicon_seq $EDITED_AMPLICON \
    --prime_editing_pegRNA_extension_seq $EXTENSION \
    -o prime_edit_results/
```

## Editing Window Analysis

```python
import pandas as pd

# Load CRISPResso quantification
quant = pd.read_csv('CRISPResso_output/Quantification_window_nucleotide_percentage_table.txt',
                    sep='\t')

# Calculate per-position editing
editing_window = quant[(quant['Position'] >= -5) & (quant['Position'] <= 5)]
```

## Quality Thresholds

- Editing efficiency: >30% considered good for most applications
- Indel rate: <5% ideal for base editors
- Bystander rate: depends on application; <10% often acceptable

## Related Skills

- crispr-screens/crispresso-editing - General editing QC
- crispr-screens/library-design - Guide design considerations
- variant-calling/vcf-basics - Downstream variant analysis
