---
name: omics-read-alignment-star-alignment
description: 提供用STAR进行RNA-seq剪接比对和基因计数的方法与调用指南；用于处理参考FASTA、GTF、STAR索引和RNA FASTQ。
metadata:
  source_extensions:
    tool_type: cli
    primary_tool: STAR
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


# STAR RNA-seq Alignment

## Codex 调用

- **选择**：请求涉及“用STAR进行RNA-seq剪接比对和基因计数”时使用；显式调用 `$omics-read-alignment-star-alignment`。
- **输入**：参考FASTA、GTF、STAR索引和RNA FASTQ。
- **预期产物**：排序BAM、SJ表、计数和融合候选；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`STAR`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Generate Genome Index

```bash
# Basic index generation
STAR --runMode genomeGenerate \
    --runThreadN 8 \
    --genomeDir star_index/ \
    --genomeFastaFiles reference.fa \
    --sjdbGTFfile annotation.gtf \
    --sjdbOverhang 100    # Read length - 1
```

## Index with Specific Read Length

```bash
# For 150bp reads, use sjdbOverhang=149
STAR --runMode genomeGenerate \
    --runThreadN 8 \
    --genomeDir star_index_150/ \
    --genomeFastaFiles reference.fa \
    --sjdbGTFfile annotation.gtf \
    --sjdbOverhang 149
```

## Basic Alignment

```bash
# Paired-end alignment
STAR --runThreadN 8 \
    --genomeDir star_index/ \
    --readFilesIn reads_1.fq.gz reads_2.fq.gz \
    --readFilesCommand zcat \
    --outFileNamePrefix sample_ \
    --outSAMtype BAM SortedByCoordinate
```

## Single-End Alignment

```bash
STAR --runThreadN 8 \
    --genomeDir star_index/ \
    --readFilesIn reads.fq.gz \
    --readFilesCommand zcat \
    --outFileNamePrefix sample_ \
    --outSAMtype BAM SortedByCoordinate
```

## Two-Pass Mode

```bash
# Two-pass mode for better novel junction detection
STAR --runThreadN 8 \
    --genomeDir star_index/ \
    --readFilesIn r1.fq.gz r2.fq.gz \
    --readFilesCommand zcat \
    --outFileNamePrefix sample_ \
    --outSAMtype BAM SortedByCoordinate \
    --twopassMode Basic
```

## Quantification Mode

```bash
# Output gene counts (like featureCounts)
STAR --runThreadN 8 \
    --genomeDir star_index/ \
    --readFilesIn r1.fq.gz r2.fq.gz \
    --readFilesCommand zcat \
    --outFileNamePrefix sample_ \
    --outSAMtype BAM SortedByCoordinate \
    --quantMode GeneCounts
```

Output: `sample_ReadsPerGene.out.tab` with columns:
1. Gene ID
2. Unstranded counts
3. Forward strand counts
4. Reverse strand counts

## ENCODE Options

```bash
# ENCODE recommended settings
STAR --runThreadN 8 \
    --genomeDir star_index/ \
    --readFilesIn r1.fq.gz r2.fq.gz \
    --readFilesCommand zcat \
    --outFileNamePrefix sample_ \
    --outSAMtype BAM SortedByCoordinate \
    --outSAMunmapped Within \
    --outSAMattributes NH HI AS NM MD \
    --outFilterType BySJout \
    --outFilterMultimapNmax 20 \
    --outFilterMismatchNmax 999 \
    --outFilterMismatchNoverReadLmax 0.04 \
    --alignIntronMin 20 \
    --alignIntronMax 1000000 \
    --alignMatesGapMax 1000000 \
    --alignSJoverhangMin 8 \
    --alignSJDBoverhangMin 1
```

## Fusion Detection

```bash
# For chimeric/fusion detection
STAR --runThreadN 8 \
    --genomeDir star_index/ \
    --readFilesIn r1.fq.gz r2.fq.gz \
    --readFilesCommand zcat \
    --outFileNamePrefix sample_ \
    --outSAMtype BAM SortedByCoordinate \
    --chimSegmentMin 12 \
    --chimJunctionOverhangMin 8 \
    --chimOutType Junctions WithinBAM SoftClip \
    --chimMainSegmentMultNmax 1
```

## Output Files

| File | Description |
|------|-------------|
| *Aligned.sortedByCoord.out.bam | Sorted BAM file |
| *Log.final.out | Alignment summary statistics |
| *Log.out | Detailed log |
| *SJ.out.tab | Splice junctions |
| *ReadsPerGene.out.tab | Gene counts (if --quantMode) |
| *Chimeric.out.junction | Fusion candidates (if chimeric) |

## Memory Requirements

```bash
# Reduce memory for limited systems
STAR --genomeLoad NoSharedMemory \
    --limitBAMsortRAM 10000000000 \  # 10GB for sorting
    ...

# For very large genomes, limit during index generation
STAR --runMode genomeGenerate \
    --limitGenomeGenerateRAM 31000000000 \  # 31GB
    ...
```

## Shared Memory Mode

```bash
# Load genome into shared memory (for multiple samples)
STAR --genomeLoad LoadAndExit --genomeDir star_index/

# Run alignments (faster startup)
STAR --genomeLoad LoadAndKeep --genomeDir star_index/ ...

# Remove from memory when done
STAR --genomeLoad Remove --genomeDir star_index/
```

## Key Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| --runThreadN | 1 | Number of threads |
| --sjdbOverhang | 100 | Read length - 1 |
| --outFilterMultimapNmax | 10 | Max multi-mapping |
| --alignIntronMax | 0 | Max intron size |
| --outFilterMismatchNmax | 10 | Max mismatches |
| --outSAMtype | SAM | Output format |
| --quantMode | - | GeneCounts for counting |
| --twopassMode | None | Basic for two-pass |

## Related Skills

- rna-quantification/featurecounts-counting - Alternative counting
- rna-quantification/alignment-free-quant - Salmon/kallisto alternative
- differential-expression/deseq2-basics - Downstream DE analysis
- read-qc/fastp-workflow - Preprocess reads


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->