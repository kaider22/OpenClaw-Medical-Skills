---
name: omics-genome-intervals-bed-file-basics
description: 提供创建、排序、校验和转换BED区间的方法与调用指南；用于处理BED文本、参考基因组索引及可选序列。
metadata:
  source_extensions:
    tool_type: mixed
    primary_tool: bedtools
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


# BED File Basics

## Codex 调用

- **选择**：请求涉及“创建、排序、校验和转换BED区间”时使用；显式调用 `$omics-genome-intervals-bed-file-basics`。
- **输入**：BED文本、参考基因组索引及可选序列。
- **预期产物**：合法排序BED、FASTA/GFF和校验结果；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`bedtools`、`pandas`、`pybedtools`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

BED (Browser Extensible Data) format stores genomic intervals. Uses 0-based, half-open coordinates.

## BED Format Columns

```
BED3:  chr  start  end
BED4:  chr  start  end  name
BED5:  chr  start  end  name  score
BED6:  chr  start  end  name  score  strand
BED12: chr  start  end  name  score  strand  thickStart  thickEnd  rgb  blockCount  blockSizes  blockStarts
```

## Coordinate System

BED uses 0-based, half-open coordinates:
- Start: 0-based (first base is 0)
- End: exclusive (not included)
- Position 100-200 means bases at positions 100-199

## Create BED Files

### From Text (CLI)

```bash
# Create simple BED3
echo -e "chr1\t100\t200\nchr1\t300\t400" > regions.bed

# Create BED6 with name and strand
echo -e "chr1\t100\t200\tpeak1\t100\t+" > peaks.bed
```

### From Python

```python
import pybedtools

# From string
bed_string = '''chr1\t100\t200\tpeak1\t100\t+
chr1\t300\t400\tpeak2\t200\t-'''
bed = pybedtools.BedTool(bed_string, from_string=True)

# From list of tuples
intervals = [
    ('chr1', 100, 200, 'peak1', 100, '+'),
    ('chr1', 300, 400, 'peak2', 200, '-'),
]
bed = pybedtools.BedTool(intervals)

# From pandas DataFrame
import pandas as pd
df = pd.DataFrame({
    'chrom': ['chr1', 'chr1'],
    'start': [100, 300],
    'end': [200, 400],
    'name': ['peak1', 'peak2'],
    'score': [100, 200],
    'strand': ['+', '-']
})
bed = pybedtools.BedTool.from_dataframe(df)

# Save to file
bed.saveas('output.bed')
```

## Sort BED Files

### CLI

```bash
# Sort by chromosome and position
sort -k1,1 -k2,2n input.bed > sorted.bed

# Using bedtools
bedtools sort -i input.bed > sorted.bed

# Sort by chromosome, start, then end
sort -k1,1 -k2,2n -k3,3n input.bed > sorted.bed
```

### Python

```python
import pybedtools

bed = pybedtools.BedTool('input.bed')
sorted_bed = bed.sort()
sorted_bed.saveas('sorted.bed')
```

## Validate BED Files

### Check Format

```bash
# Check column count
awk -F'\t' '{print NF}' input.bed | sort -u

# Check for invalid coordinates (start >= end)
awk '$2 >= $3' input.bed

# Check for negative coordinates
awk '$2 < 0 || $3 < 0' input.bed

# Validate with bedtools
bedtools sort -i input.bed > /dev/null 2>&1 && echo "Valid" || echo "Invalid"
```

### Python Validation

```python
import pybedtools

def validate_bed(filepath):
    try:
        bed = pybedtools.BedTool(filepath)
        for interval in bed:
            if interval.start < 0 or interval.end < 0:
                return False, 'Negative coordinates'
            if interval.start >= interval.end:
                return False, f'Invalid interval: {interval.start} >= {interval.end}'
        return True, 'Valid'
    except Exception as e:
        return False, str(e)

valid, msg = validate_bed('input.bed')
print(f'{msg}')
```

## Read BED Files

### Python

```python
import pybedtools

# Load BED file
bed = pybedtools.BedTool('input.bed')

# Iterate over intervals
for interval in bed:
    print(f'{interval.chrom}:{interval.start}-{interval.end}')
    print(f'Name: {interval.name}, Score: {interval.score}, Strand: {interval.strand}')

# Count intervals
n_intervals = bed.count()

# Convert to pandas DataFrame
df = bed.to_dataframe()

# Access specific columns
df = bed.to_dataframe(names=['chrom', 'start', 'end', 'name', 'score', 'strand'])
```

## Filter BED Files

### By Chromosome

```bash
# Single chromosome
grep "^chr1\t" input.bed > chr1.bed

# Multiple chromosomes
grep -E "^(chr1|chr2)\t" input.bed > chr1_2.bed

# Exclude chromosome
grep -v "^chrM\t" input.bed > no_chrM.bed
```

### By Size

```bash
# Intervals >= 100bp
awk '($3 - $2) >= 100' input.bed > large.bed

# Intervals between 100-500bp
awk '($3 - $2) >= 100 && ($3 - $2) <= 500' input.bed > medium.bed
```

### Python Filtering

```python
import pybedtools

bed = pybedtools.BedTool('input.bed')

# Filter by chromosome
chr1 = bed.filter(lambda x: x.chrom == 'chr1')

# Filter by size
large = bed.filter(lambda x: len(x) >= 100)

# Filter by strand
plus_strand = bed.filter(lambda x: x.strand == '+')

# Filter by score
high_score = bed.filter(lambda x: float(x.score) >= 500)

# Chain filters
result = bed.filter(lambda x: x.chrom == 'chr1' and len(x) >= 100)
result.saveas('filtered.bed')
```

## Convert Formats

### BED to Other Formats

```bash
# BED to GFF
bedtools bed12togff -i input.bed > output.gff

# BED to FASTA (extract sequences)
bedtools getfasta -fi reference.fa -bed input.bed -fo output.fa

# BED to FASTA with names
bedtools getfasta -fi reference.fa -bed input.bed -name -fo output.fa
```

### From VCF to BED

```bash
# Extract variant positions
bcftools query -f '%CHROM\t%POS0\t%END\n' input.vcf > variants.bed

# Or using awk (simpler for SNPs)
grep -v "^#" input.vcf | awk '{print $1"\t"$2-1"\t"$2}' > snps.bed
```

### From BAM to BED

```bash
# Convert alignments to BED
bedtools bamtobed -i input.bam > alignments.bed

# BED12 for spliced alignments
bedtools bamtobed -i input.bam -split > spliced.bed
```

## Interval Arithmetic Basics

```python
import pybedtools

interval = pybedtools.create_interval_from_list(['chr1', '100', '200', 'peak1', '0', '+'])

# Access fields
print(interval.chrom)   # chr1
print(interval.start)   # 100 (int)
print(interval.end)     # 200 (int)
print(interval.name)    # peak1
print(interval.score)   # 0
print(interval.strand)  # +

# Get length
print(len(interval))    # 100

# Get fields list
print(interval.fields)  # ['chr1', '100', '200', 'peak1', '0', '+']
```

## Make Windows - Create Genomic Intervals

### CLI

```bash
# Fixed-size windows across genome
bedtools makewindows -g genome.txt -w 10000 > windows_10kb.bed

# Windows with step size (sliding windows)
bedtools makewindows -g genome.txt -w 10000 -s 5000 > sliding_10kb.bed

# Fixed number of windows per chromosome
bedtools makewindows -g genome.txt -n 100 > 100_windows_per_chr.bed

# Windows within BED regions
bedtools makewindows -b regions.bed -w 1000 > windows_in_regions.bed

# Add window ID
bedtools makewindows -g genome.txt -w 10000 -i winnum > numbered_windows.bed

# Source chromosome in name
bedtools makewindows -g genome.txt -w 10000 -i srcwinnum > windows_with_source.bed
```

### Python

```python
import pybedtools

# From genome file
windows = pybedtools.BedTool().window_maker(g='genome.txt', w=10000)

# Sliding windows
windows = pybedtools.BedTool().window_maker(g='genome.txt', w=10000, s=5000)

# From BED regions
bed = pybedtools.BedTool('regions.bed')
windows = pybedtools.BedTool().window_maker(b=bed.fn, w=1000)

windows.saveas('windows.bed')
```

## Common BED Extensions

| Format | Description | Columns |
|--------|-------------|---------|
| narrowPeak | ENCODE narrow peaks | BED6 + signalValue, pValue, qValue, peak |
| broadPeak | ENCODE broad peaks | BED6 + signalValue, pValue, qValue |
| bedGraph | Signal track | chr, start, end, value |
| bedpe | Paired intervals | chr1, s1, e1, chr2, s2, e2, name, score, strand1, strand2 |

## Cleanup Temp Files

```python
import pybedtools

# At end of script
pybedtools.cleanup()

# Or use context manager (auto-cleanup)
pybedtools.set_tempdir('/tmp/pybedtools')
```

## Related Skills

- interval-arithmetic - intersect, subtract, merge operations
- gtf-gff-handling - annotation file parsing
- coverage-analysis - depth calculations
- alignment-files/sam-bam-basics - BAM to BED conversion


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->