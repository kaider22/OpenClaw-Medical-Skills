---
name: omics-sam-bam-basics
description: 提供查看、转换并理解SAM/BAM/CRAM对齐文件的方法与调用指南；用于处理SAM/BAM/CRAM及CRAM参考FASTA。
metadata:
  source_extensions:
    tool_type: cli
    primary_tool: samtools
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


# SAM/BAM/CRAM Basics

## Codex 调用

- **选择**：请求涉及“查看、转换并理解SAM/BAM/CRAM对齐文件”时使用；显式调用 `$omics-sam-bam-basics`。
- **输入**：SAM/BAM/CRAM及CRAM参考FASTA。
- **预期产物**：区域记录、统计、SAM/BAM/CRAM转换结果；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`pysam`、`samtools`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

View and convert alignment files using samtools and pysam.

## Format Overview

| Format | Description | Use Case |
|--------|-------------|----------|
| SAM | Text format, human-readable | Debugging, small files |
| BAM | Binary compressed SAM | Standard storage format |
| CRAM | Reference-based compression | Long-term archival, smaller than BAM |

## SAM Format Structure

```
@HD VN:1.6 SO:coordinate
@SQ SN:chr1 LN:248956422
@RG ID:sample1 SM:sample1
@PG ID:bwa PN:bwa VN:0.7.17
read1  0   chr1  100  60  50M  *  0  0  ACGT...  FFFF...  NM:i:0
```

Header lines start with `@`:
- `@HD` - Header metadata (version, sort order)
- `@SQ` - Reference sequence dictionary
- `@RG` - Read group information
- `@PG` - Program used to create file

Alignment fields (tab-separated):
1. QNAME - Read name
2. FLAG - Bitwise flag
3. RNAME - Reference name
4. POS - 1-based position
5. MAPQ - Mapping quality
6. CIGAR - Alignment description
7. RNEXT - Mate reference
8. PNEXT - Mate position
9. TLEN - Template length
10. SEQ - Read sequence
11. QUAL - Base qualities
12. Optional tags (NM:i:0, MD:Z:50, etc.)

## samtools view

### View BAM as SAM
```bash
samtools view input.bam | head
```

### View with Header
```bash
samtools view -h input.bam | head -100
```

### View Header Only
```bash
samtools view -H input.bam
```

### View Specific Region
```bash
samtools view input.bam chr1:1000-2000
```

### Count Alignments
```bash
samtools view -c input.bam
```

## Format Conversion

### BAM to SAM
```bash
samtools view -h -o output.sam input.bam
```

### SAM to BAM
```bash
samtools view -b -o output.bam input.sam
```

### BAM to CRAM
```bash
samtools view -C -T reference.fa -o output.cram input.bam
```

### CRAM to BAM
```bash
samtools view -b -T reference.fa -o output.bam input.cram
```

### Pipe Conversion
```bash
samtools view -b input.sam > output.bam
```

## Common Flags

| Flag | Decimal | Meaning |
|------|---------|---------|
| 0x1 | 1 | Paired |
| 0x2 | 2 | Proper pair |
| 0x4 | 4 | Unmapped |
| 0x8 | 8 | Mate unmapped |
| 0x10 | 16 | Reverse strand |
| 0x20 | 32 | Mate reverse strand |
| 0x40 | 64 | First in pair |
| 0x80 | 128 | Second in pair |
| 0x100 | 256 | Secondary alignment |
| 0x200 | 512 | Failed QC |
| 0x400 | 1024 | PCR duplicate |
| 0x800 | 2048 | Supplementary |

### Decode Flags
```bash
samtools flags 147
# 0x93 147 PAIRED,PROPER_PAIR,REVERSE,READ2
```

## CIGAR Operations

| Op | Description |
|----|-------------|
| M | Alignment match (can be mismatch) |
| I | Insertion to reference |
| D | Deletion from reference |
| N | Skipped region (introns in RNA-seq) |
| S | Soft clipping |
| H | Hard clipping |
| = | Sequence match |
| X | Sequence mismatch |

Example: `50M2I30M` = 50 bases match, 2 base insertion, 30 bases match

## pysam Python Alternative

### Open and Iterate
```python
import pysam

with pysam.AlignmentFile('input.bam', 'rb') as bam:
    for read in bam:
        print(f'{read.query_name}\t{read.reference_name}:{read.reference_start}')
```

### Access Header
```python
with pysam.AlignmentFile('input.bam', 'rb') as bam:
    for sq in bam.header['SQ']:
        print(f'{sq["SN"]}: {sq["LN"]} bp')
```

### Read Alignment Properties
```python
with pysam.AlignmentFile('input.bam', 'rb') as bam:
    for read in bam:
        print(f'Name: {read.query_name}')
        print(f'Flag: {read.flag}')
        print(f'Chrom: {read.reference_name}')
        print(f'Pos: {read.reference_start}')  # 0-based
        print(f'MAPQ: {read.mapping_quality}')
        print(f'CIGAR: {read.cigarstring}')
        print(f'Seq: {read.query_sequence}')
        print(f'Qual: {read.query_qualities}')
        break
```

### Check Flag Properties
```python
with pysam.AlignmentFile('input.bam', 'rb') as bam:
    for read in bam:
        if read.is_paired and read.is_proper_pair:
            if read.is_reverse:
                strand = '-'
            else:
                strand = '+'
            print(f'{read.query_name} on {strand} strand')
```

### Fetch Region
```python
with pysam.AlignmentFile('input.bam', 'rb') as bam:
    for read in bam.fetch('chr1', 1000, 2000):
        print(read.query_name)
```

### Convert BAM to SAM
```python
with pysam.AlignmentFile('input.bam', 'rb') as infile:
    with pysam.AlignmentFile('output.sam', 'w', header=infile.header) as outfile:
        for read in infile:
            outfile.write(read)
```

### Convert to CRAM
```python
with pysam.AlignmentFile('input.bam', 'rb') as infile:
    with pysam.AlignmentFile('output.cram', 'wc', reference_filename='reference.fa', header=infile.header) as outfile:
        for read in infile:
            outfile.write(read)
```

## Quick Reference

| Task | samtools | pysam |
|------|----------|-------|
| View BAM | `samtools view file.bam` | `AlignmentFile('file.bam', 'rb')` |
| View header | `samtools view -H file.bam` | `bam.header` |
| Count reads | `samtools view -c file.bam` | `sum(1 for _ in bam)` |
| Get region | `samtools view file.bam chr1:1-1000` | `bam.fetch('chr1', 0, 1000)` |
| BAM to SAM | `samtools view -h -o out.sam in.bam` | Open with 'w' mode |
| SAM to BAM | `samtools view -b -o out.bam in.sam` | Open with 'wb' mode |
| BAM to CRAM | `samtools view -C -T ref.fa -o out.cram in.bam` | Open with 'wc' mode |

## Related Skills

- alignment-indexing - Create indices for random access (required for fetch/region queries)
- alignment-sorting - Sort alignments by coordinate or name
- alignment-filtering - Filter alignments by flags, quality, regions
- bam-statistics - Generate statistics from alignment files
- sequence-io/read-sequences - Parse FASTA/FASTQ input files


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->