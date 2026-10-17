---
name: sop-omics-longread-sv-pipeline
description: 从ONT或PacBio长读长检测结构变异；用于处理长读长FASTQ、参考基因组和重复注释。
metadata:
  source_extensions:
    tool_type: cli
    primary_tool: Sniffles
    workflow: true
    depends_on:
    - omics-longread-alignment
    - omics-longread-qc
    - omics-longread-structural-variants
    qc_checkpoints:
    - after_qc: Read N50 >10kb, quality score >Q10
    - after_alignment: Mapping rate >90%, coverage sufficient
    - after_calling: SV count reasonable, genotypes concordant
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


# Long-Read SV Pipeline

## Codex 调用

- **选择**：请求涉及“从ONT或PacBio长读长检测结构变异”时使用；显式调用 `$sop-omics-longread-sv-pipeline`。
- **输入**：长读长FASTQ、参考基因组和重复注释。
- **预期产物**：过滤SV VCF、类型统计和可选基因注释；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文 SOP 顺序调用所列软件，逐阶段核对输入、输出和质量检查；有分支时按当前数据选择，不把流程文档当作已完成的运行。
- **环境核对**：`Sniffles`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **流程依赖**：[omics-longread-alignment](../omics-longread-alignment/SKILL.md) → [omics-longread-qc](../omics-longread-qc/SKILL.md) → [omics-longread-structural-variants](../omics-longread-structural-variants/SKILL.md)。依赖所需数据或环境缺失时停止对应阶段，不把后续阶段标为通过。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Complete workflow for detecting structural variants from ONT or PacBio long-read data.

## Workflow Overview

```
Long reads (ONT/PacBio)
    |
    v
[1. QC] ----------------> NanoPlot
    |
    v
[2. Alignment] ---------> minimap2
    |
    v
[3. SV Calling] --------> Sniffles / cuteSV
    |
    v
[4. Filtering] ---------> bcftools
    |
    v
[5. Annotation] --------> AnnotSV (optional)
    |
    v
Filtered SV VCF
```

## Primary Path: minimap2 + Sniffles

### Step 1: Quality Control

```bash
# ONT reads QC
NanoPlot --fastq reads.fastq.gz \
    --outdir nanoplot_output \
    --threads 8

# Check key metrics
# - Read N50 should be >10kb
# - Mean quality >Q10
# - Total bases sufficient for coverage
```

### Step 2: Alignment with minimap2

```bash
# ONT reads
minimap2 -ax map-ont \
    -t 16 \
    --MD \
    -Y \
    reference.fa \
    reads.fastq.gz | \
    samtools sort -@ 4 -o aligned.bam

samtools index aligned.bam

# PacBio HiFi
minimap2 -ax map-hifi \
    -t 16 \
    --MD \
    -Y \
    reference.fa \
    reads.fastq.gz | \
    samtools sort -@ 4 -o aligned.bam

# PacBio CLR
minimap2 -ax map-pb \
    -t 16 \
    --MD \
    -Y \
    reference.fa \
    reads.fastq.gz | \
    samtools sort -@ 4 -o aligned.bam
```

**QC Checkpoint:** Check alignment stats
```bash
samtools flagstat aligned.bam
samtools depth -a aligned.bam | awk '{sum+=$3} END {print "Average coverage:",sum/NR}'
```
- Mapping rate >90%
- Average coverage >10x for SV calling (>20x preferred)

### Step 3: SV Calling with Sniffles

```bash
# Sniffles2 (recommended)
sniffles \
    --input aligned.bam \
    --vcf svs.vcf.gz \
    --reference reference.fa \
    --threads 8 \
    --minsvlen 50

# With tandem repeat annotations (recommended)
sniffles \
    --input aligned.bam \
    --vcf svs.vcf.gz \
    --reference reference.fa \
    --tandem-repeats tandem_repeats.bed \
    --threads 8
```

### Alternative: cuteSV

```bash
# cuteSV (faster, good for ONT)
cuteSV \
    aligned.bam \
    reference.fa \
    svs.vcf \
    work_dir/ \
    --threads 8 \
    --min_size 50 \
    --genotype

bgzip svs.vcf
tabix svs.vcf.gz
```

### Step 4: Filtering

```bash
# Filter by quality and size
bcftools view -i 'QUAL>=20 && ABS(SVLEN)>=50' svs.vcf.gz -Oz -o svs.filtered.vcf.gz

# Filter by SV type
bcftools view -i 'SVTYPE="DEL" || SVTYPE="INS"' svs.filtered.vcf.gz -Oz -o del_ins.vcf.gz

# Filter by genotype
bcftools view -i 'GT="1/1" || GT="0/1"' svs.filtered.vcf.gz -Oz -o genotyped.vcf.gz

# Stats
bcftools stats svs.filtered.vcf.gz > sv_stats.txt
```

### Step 5: Annotation (Optional)

```bash
# AnnotSV for gene/clinical annotations
AnnotSV -SVinputFile svs.filtered.vcf.gz \
    -outputFile annotated_svs \
    -genomeBuild GRCh38
```

## Multi-Sample SV Calling

```bash
# Call SVs per sample
for sample in sample1 sample2 sample3; do
    sniffles --input ${sample}.bam \
        --snf ${sample}.snf \
        --reference reference.fa
done

# Merge and joint genotype
sniffles --input sample1.snf sample2.snf sample3.snf \
    --vcf merged_svs.vcf.gz \
    --reference reference.fa
```

## Parameter Recommendations

| Tool | Parameter | ONT | PacBio HiFi |
|------|-----------|-----|-------------|
| minimap2 | -ax | map-ont | map-hifi |
| Sniffles | --minsvlen | 50 | 50 |
| Sniffles | --minsupport | auto | auto |
| cuteSV | --min_size | 50 | 50 |
| cuteSV | --min_support | 3 | 3 |

## SV Types Detected

| Type | Abbreviation | Description |
|------|--------------|-------------|
| Deletion | DEL | Sequence removed |
| Insertion | INS | Sequence added |
| Duplication | DUP | Sequence copied |
| Inversion | INV | Sequence reversed |
| Translocation | BND | Breakend (interchromosomal) |

## Troubleshooting

| Issue | Likely Cause | Solution |
|-------|--------------|----------|
| Few SVs | Low coverage | Increase sequencing depth |
| Many false positives | Low quality reads | Filter by QUAL, increase min support |
| Missing known SV | Repeat region | Use tandem repeat annotations |
| High breakend count | Mapping artifacts | Check alignment quality |

## Complete Pipeline Script

```bash
#!/bin/bash
set -e

THREADS=16
READS="reads.fastq.gz"
REF="reference.fa"
SAMPLE="sample1"
OUTDIR="sv_results"

mkdir -p ${OUTDIR}/{qc,aligned,sv}

# Step 1: QC
echo "=== QC ==="
NanoPlot --fastq ${READS} --outdir ${OUTDIR}/qc -t ${THREADS}

# Step 2: Alignment
echo "=== Alignment ==="
minimap2 -ax map-ont -t ${THREADS} --MD -Y ${REF} ${READS} | \
    samtools sort -@ 4 -o ${OUTDIR}/aligned/${SAMPLE}.bam
samtools index ${OUTDIR}/aligned/${SAMPLE}.bam

echo "Alignment stats:"
samtools flagstat ${OUTDIR}/aligned/${SAMPLE}.bam

# Step 3: SV calling
echo "=== SV Calling ==="
sniffles --input ${OUTDIR}/aligned/${SAMPLE}.bam \
    --vcf ${OUTDIR}/sv/${SAMPLE}.vcf.gz \
    --reference ${REF} \
    --threads ${THREADS}

# Step 4: Filter
echo "=== Filtering ==="
bcftools view -i 'QUAL>=20' ${OUTDIR}/sv/${SAMPLE}.vcf.gz \
    -Oz -o ${OUTDIR}/sv/${SAMPLE}.filtered.vcf.gz
bcftools index ${OUTDIR}/sv/${SAMPLE}.filtered.vcf.gz

# Stats
bcftools stats ${OUTDIR}/sv/${SAMPLE}.filtered.vcf.gz > ${OUTDIR}/sv/stats.txt

echo "=== Complete ==="
echo "SVs: $(bcftools view -H ${OUTDIR}/sv/${SAMPLE}.filtered.vcf.gz | wc -l)"
```

## Related Skills

- long-read-sequencing/long-read-alignment - minimap2 details
- long-read-sequencing/structural-variants - Sniffles, cuteSV options
- long-read-sequencing/long-read-qc - NanoPlot metrics
- variant-calling/structural-variant-calling - Short-read SV methods


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->