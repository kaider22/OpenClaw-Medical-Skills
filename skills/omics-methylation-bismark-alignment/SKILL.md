---
name: omics-methylation-bismark-alignment
description: 提供将WGBS/RRBS读段比对到亚硫酸氢盐参考基因组的方法与调用指南；用于处理WGBS/RRBS FASTQ、参考基因组和文库类型。
metadata:
  source_extensions:
    tool_type: cli
    primary_tool: bismark
---

## Version Compatibility

Reference examples tested with: Bowtie2 2.5.3+, HISAT2 2.2.1+, Trim Galore 0.6.10+, samtools 1.19+

Before using code patterns, verify installed versions match. If versions differ:
- CLI: `<tool> --version` then `<tool> --help` to confirm flags

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Bismark Alignment

## Codex 调用

- **选择**：请求涉及“将WGBS/RRBS读段比对到亚硫酸氢盐参考基因组”时使用；显式调用 `$omics-methylation-bismark-alignment`。
- **输入**：WGBS/RRBS FASTQ、参考基因组和文库类型。
- **预期产物**：Bismark BAM、比对报告和可选覆盖报告；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`bismark`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Align my bisulfite sequencing reads"** → Map WGBS/RRBS reads to an in-silico bisulfite-converted reference genome, producing BAM files with methylation context tags.
- CLI: `bismark_genome_preparation genome/` then `bismark --genome genome/ reads.fq.gz`

## Prepare Genome Index

```bash
# One-time genome preparation (creates bisulfite-converted index)
bismark_genome_preparation --bowtie2 /path/to/genome_folder/

# Genome folder should contain FASTA files (e.g., hg38.fa, chr1.fa, etc.)
# Creates Bisulfite_Genome/ subdirectory with CT and GA converted indices
```

## Basic Single-End Alignment

```bash
bismark --genome /path/to/genome_folder/ reads.fastq.gz -o output_dir/
```

## Paired-End Alignment

```bash
bismark --genome /path/to/genome_folder/ \
    -1 reads_R1.fastq.gz \
    -2 reads_R2.fastq.gz \
    -o output_dir/
```

## Common Options

```bash
bismark --genome /path/to/genome_folder/ \
    --bowtie2 \                    # Use bowtie2 (default)
    --parallel 4 \                 # Number of parallel instances
    --temp_dir /tmp/ \             # Temporary directory
    --non_directional \            # For non-directional libraries
    --nucleotide_coverage \        # Generate nucleotide coverage report
    -o output_dir/ \
    reads.fastq.gz
```

## RRBS Mode

```bash
# Reduced Representation Bisulfite Sequencing
bismark --genome /path/to/genome_folder/ \
    --pbat \                       # For PBAT libraries (post-bisulfite adapter tagging)
    reads.fastq.gz

# MspI digestion (RRBS standard)
# Bismark handles MspI-digested libraries automatically
```

## PBAT Libraries

```bash
# Post-Bisulfite Adapter Tagging (e.g., scBS-seq)
bismark --genome /path/to/genome_folder/ --pbat reads.fastq.gz
```

## Non-Directional Libraries

```bash
# For libraries where all 4 strands are present
bismark --genome /path/to/genome_folder/ --non_directional reads.fastq.gz
```

## With Quality/Adapter Trimming (Pre-alignment)

```bash
# Trim adapters first with Trim Galore (recommended)
trim_galore --illumina --paired reads_R1.fastq.gz reads_R2.fastq.gz

# Then align
bismark --genome /path/to/genome_folder/ \
    -1 reads_R1_val_1.fq.gz \
    -2 reads_R2_val_2.fq.gz
```

## Multicore Processing

```bash
# --parallel sets instances per alignment direction
# Total threads = parallel * 2 (for directional) or parallel * 4 (non-directional)
bismark --genome /path/to/genome_folder/ \
    --parallel 4 \
    reads.fastq.gz
```

## Output Files

```bash
# Bismark produces:
# - reads_bismark_bt2.bam          # Aligned reads
# - reads_bismark_bt2_SE_report.txt # Alignment report

# View alignment report
cat output_dir/reads_bismark_bt2_SE_report.txt
```

## Sort and Index BAM

```bash
# Bismark output is unsorted
samtools sort output.bam -o output.sorted.bam
samtools index output.sorted.bam
```

## Deduplicate (Optional)

```bash
# Remove PCR duplicates (recommended for WGBS, not RRBS)
deduplicate_bismark --bam output_bismark_bt2.bam

# For paired-end
deduplicate_bismark --paired --bam output_bismark_bt2_pe.bam
```

## Check Alignment Statistics

```bash
# Bismark generates detailed report
cat *_SE_report.txt

# Key metrics:
# - Sequences analyzed
# - Unique alignments
# - Mapping efficiency
# - C methylated in CpG context
```

## Genome Preparation with HISAT2 (Recommended for Large Genomes)

```bash
# HISAT2 is faster and uses less memory for large mammalian genomes
bismark_genome_preparation --hisat2 /path/to/genome_folder/

# Align with HISAT2
bismark --genome /path/to/genome_folder/ --hisat2 reads.fastq.gz

# HISAT2 paired-end
bismark --genome /path/to/genome_folder/ --hisat2 \
    -1 reads_R1.fastq.gz \
    -2 reads_R2.fastq.gz
```

## Key Parameters

| Parameter | Description |
|-----------|-------------|
| --genome | Path to genome folder |
| --bowtie2 | Use Bowtie2 aligner (default) |
| --hisat2 | Use HISAT2 aligner |
| --parallel | Parallel alignment instances |
| --non_directional | Non-directional library |
| --pbat | PBAT library protocol |
| -o | Output directory |
| --temp_dir | Temporary file directory |
| --nucleotide_coverage | Generate nuc coverage report |
| -N | Mismatches in seed (0 or 1, default 0) |
| -L | Seed length (default 20) |

## Library Types

| Type | Parameter | Description |
|------|-----------|-------------|
| Directional | (default) | Standard WGBS/RRBS |
| Non-directional | --non_directional | All 4 strands |
| PBAT | --pbat | Post-bisulfite adapter tagging |

## Related Skills

- methylation-calling - Extract methylation from Bismark BAM
- methylkit-analysis - Import Bismark output to R
- sequence-io/read-sequences - FASTQ handling
- alignment-files/sam-bam-basics - BAM manipulation
