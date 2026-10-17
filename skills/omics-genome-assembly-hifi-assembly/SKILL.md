---
name: omics-genome-assembly-hifi-assembly
description: 提供用hifiasm组装PacBio HiFi并进行单倍型分相的方法与调用指南；用于处理HiFi FASTQ及可选亲本k-mer库或Hi-C FASTQ。
metadata:
  source_extensions:
    tool_type: cli
    primary_tool: hifiasm
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


# HiFi Assembly

## Codex 调用

- **选择**：请求涉及“用hifiasm组装PacBio HiFi并进行单倍型分相”时使用；显式调用 `$omics-genome-assembly-hifi-assembly`。
- **输入**：HiFi FASTQ及可选亲本k-mer库或Hi-C FASTQ。
- **预期产物**：主组装、交替组装和分相单倍型FASTA；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`hifiasm`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Basic Assembly

```bash
# Primary assembly (single haplotype consensus)
hifiasm -o output_prefix -t 32 reads.hifi.fastq.gz

# Output files:
# output_prefix.bp.p_ctg.gfa  - Primary contigs
# output_prefix.bp.a_ctg.gfa  - Alternate contigs
# output_prefix.bp.hap1.p_ctg.gfa - Haplotype 1 (if phased)
# output_prefix.bp.hap2.p_ctg.gfa - Haplotype 2 (if phased)

# Convert GFA to FASTA
awk '/^S/{print ">"$2;print $3}' output_prefix.bp.p_ctg.gfa > assembly.fasta
```

## Trio-Binned Phasing

```bash
# With parental short reads for trio binning
hifiasm -o trio_asm -t 32 \
    -1 paternal.yak \
    -2 maternal.yak \
    child.hifi.fastq.gz

# Create yak databases from parental Illumina reads first
yak count -b37 -t16 -o paternal.yak paternal_R1.fq.gz paternal_R2.fq.gz
yak count -b37 -t16 -o maternal.yak maternal_R1.fq.gz maternal_R2.fq.gz
```

## Hi-C Phasing

```bash
# Use Hi-C reads for phasing (no parents needed)
hifiasm -o hic_asm -t 32 \
    --h1 hic_R1.fastq.gz \
    --h2 hic_R2.fastq.gz \
    reads.hifi.fastq.gz

# Produces fully phased hap1 and hap2 assemblies
```

## Key Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| -t | 1 | Threads |
| -l | 0 | Purge level (0=none, 1=light, 2=aggressive) |
| -s | 0.55 | Similarity threshold for duplicate detection |
| --primary | - | Output primary contigs only (no alternates) |
| --n-hap | 2 | Expected number of haplotypes |
| -D | 5.0 | Drop reads with depth > D*average |
| -N | 100 | Consider up to N overlaps for each read |

## Purge Duplicates

```bash
# Aggressive purging for high heterozygosity
hifiasm -o asm -t 32 -l 2 reads.hifi.fastq.gz

# Minimal purging for inbred samples
hifiasm -o asm -t 32 -l 0 reads.hifi.fastq.gz
```

## Ultra-Long ONT Integration

```bash
# Combine HiFi accuracy with ONT length
hifiasm -o hybrid_asm -t 32 \
    --ul ont_ultralong.fastq.gz \
    hifi_reads.fastq.gz

# UL reads help span complex repeats
```

## Assembly Stats

```bash
# Quick stats with seqkit
seqkit stats assembly.fasta

# Detailed with assembly-stats
assembly-stats assembly.fasta

# QUAST assessment
quast.py -o quast_output assembly.fasta

# BUSCO completeness
busco -i assembly.fasta -l mammalia_odb10 -o busco_out -m genome
```

## Memory and Runtime

| Genome Size | HiFi Coverage | RAM | Time (32 cores) |
|-------------|---------------|-----|-----------------|
| 3 Gb | 30x | ~200 GB | 12-24 hours |
| 3 Gb | 60x | ~400 GB | 24-48 hours |
| 500 Mb | 40x | ~64 GB | 2-4 hours |

## Python Wrapper

```python
import subprocess
from pathlib import Path

def run_hifiasm(hifi_reads, output_prefix, threads=32, purge_level=0,
                hic_r1=None, hic_r2=None, ul_reads=None):
    cmd = ['hifiasm', '-o', output_prefix, '-t', str(threads), '-l', str(purge_level)]

    if hic_r1 and hic_r2:
        cmd.extend(['--h1', hic_r1, '--h2', hic_r2])

    if ul_reads:
        cmd.extend(['--ul', ul_reads])

    cmd.append(hifi_reads)
    subprocess.run(cmd, check=True)

    gfa = Path(f'{output_prefix}.bp.p_ctg.gfa')
    fasta = Path(f'{output_prefix}.fasta')

    with open(fasta, 'w') as out:
        with open(gfa) as f:
            for line in f:
                if line.startswith('S'):
                    parts = line.strip().split('\t')
                    out.write(f'>{parts[1]}\n{parts[2]}\n')

    return fasta

# Example
assembly = run_hifiasm('sample.hifi.fq.gz', 'sample_asm', threads=48, hic_r1='hic_R1.fq.gz', hic_r2='hic_R2.fq.gz')
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| High duplication | Increase purge level (-l 2) |
| Missing haplotypes | Add Hi-C or trio data for phasing |
| Memory errors | Reduce -D parameter or downsample reads |
| Fragmented assembly | Check read quality; consider UL ONT addition |

## Related Skills

- genome-assembly/assembly-qc - QUAST and BUSCO
- genome-assembly/scaffolding - YaHS Hi-C scaffolding
- genome-assembly/contamination-detection - CheckM2 decontamination
- long-read-sequencing/read-qc - HiFi quality control


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->