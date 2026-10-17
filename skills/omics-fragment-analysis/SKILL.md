---
name: omics-fragment-analysis
description: 提供从cfDNA BAM提取片段长度、核小体和DELFI特征的方法与调用指南；用于处理成对比对BAM、参考区域及样本分组。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: FinaleToolkit
---

## Version Compatibility

Reference examples tested with: numpy 1.26+, pandas 2.2+, pysam 0.22+

Before using code patterns, verify installed versions match. If versions differ:
- Python: `pip show <package>` then `help(module.function)` to check signatures

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Fragment Analysis

## Codex 调用

- **选择**：请求涉及“从cfDNA BAM提取片段长度、核小体和DELFI特征”时使用；显式调用 `$omics-fragment-analysis`。
- **输入**：成对比对BAM、参考区域及样本分组。
- **预期产物**：片段指标、分箱短长比和核小体结果；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`FinaleToolkit`、`finaletoolkit`、`numpy`、`pandas`、`pysam`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Analyze cfDNA fragment patterns for cancer detection"** → Extract fragmentomics features (size distributions, nucleosome positioning, DELFI profiles) from cfDNA for tumor detection and tissue-of-origin analysis.
- Python: `FinaleToolkit` or `Griffin` for fragment feature extraction
- Python: `pysam` for custom fragmentomics analysis

Analyze cfDNA fragmentomics for cancer detection and characterization.

## Tool Selection

| Tool | Description | Use Case |
|------|-------------|----------|
| FinaleToolkit | DELFI-style patterns, MIT license | General fragmentomics |
| Griffin | Nucleosome profiling | Tissue deconvolution |

Note: DELFI is a commercial company, NOT software. Use FinaleToolkit (MIT license) which replicates DELFI patterns and is 50x faster.

## Fragment Size Metrics

```python
import pysam
import numpy as np
import pandas as pd


def calculate_fragment_metrics(bam_path):
    '''
    Calculate cfDNA fragment metrics.

    Key ratios for cancer detection:
    - Short (100-150 bp) vs Long (151-220 bp)
    - ctDNA tends to be shorter than normal cfDNA
    '''
    bam = pysam.AlignmentFile(bam_path, 'rb')
    sizes = []

    for read in bam.fetch():
        if read.is_proper_pair and not read.is_secondary and read.template_length > 0:
            sizes.append(read.template_length)

    bam.close()
    sizes = np.array(sizes)

    # DELFI-style ratios
    short = np.sum((sizes >= 100) & (sizes <= 150))
    long = np.sum((sizes >= 151) & (sizes <= 220))

    metrics = {
        'total_fragments': len(sizes),
        'median_size': np.median(sizes),
        'mean_size': np.mean(sizes),
        'short_fragments': short,
        'long_fragments': long,
        'short_long_ratio': short / long if long > 0 else np.nan,
        # Mononucleosome peak
        'mono_peak_fraction': np.sum((sizes >= 150) & (sizes <= 180)) / len(sizes)
    }

    return metrics
```

## FinaleToolkit Analysis

```python
import finaletoolkit as ft
import pandas as pd


def run_finaletoolkit(bam_path, output_prefix):
    '''
    Run FinaleToolkit for DELFI-style fragmentomics.
    FinaleToolkit 0.7.1+ required.
    '''
    # Extract fragment sizes
    fragments = ft.read_fragments(bam_path)

    # Calculate genome-wide fragmentation profile
    # 5Mb bins as in DELFI
    profile = ft.calculate_fragmentation_profile(
        fragments,
        bin_size=5_000_000,
        short_range=(100, 150),
        long_range=(151, 220)
    )

    profile.to_csv(f'{output_prefix}_frag_profile.csv')

    # Calculate coverage-corrected ratios
    ratios = ft.calculate_short_long_ratios(
        fragments,
        bin_size=5_000_000,
        gc_correct=True
    )

    return profile, ratios
```

## Griffin Nucleosome Profiling

```python
import subprocess


def run_griffin(bam_path, sites_bed, output_dir):
    '''
    Run Griffin for nucleosome positioning analysis.
    Griffin 0.2.0+ required.
    '''
    # Griffin analyzes nucleosome accessibility around regulatory sites
    subprocess.run([
        'griffin',
        '--bam', bam_path,
        '--sites', sites_bed,  # TSS, CTCF, etc.
        '--output', output_dir,
        '--window', '2000',  # bp around site
        '--fragment_length', '120-180'
    ], check=True)
```

## Genome-Wide Fragmentation Profile

**Goal:** Generate a genome-wide map of short-to-long fragment ratios across fixed-size bins, replicating the DELFI approach for cancer detection from cfDNA fragmentomics.

**Approach:** Iterate over proper-pair fragments in each genomic bin, classify each as short (100-150 bp) or long (151-220 bp), and compute the short/long ratio per bin as the fragmentation feature vector.

```python
import pysam
import numpy as np


def calculate_binned_profile(bam_path, bin_size=5_000_000, chromosomes=None):
    '''
    Calculate fragment profiles in genomic bins.
    Similar to DELFI approach.
    '''
    if chromosomes is None:
        chromosomes = [f'chr{i}' for i in range(1, 23)]

    bam = pysam.AlignmentFile(bam_path, 'rb')

    profiles = {}

    for chrom in chromosomes:
        try:
            chrom_len = bam.get_reference_length(chrom)
        except Exception:
            continue

        n_bins = (chrom_len // bin_size) + 1
        short_counts = np.zeros(n_bins)
        long_counts = np.zeros(n_bins)

        for read in bam.fetch(chrom):
            if not read.is_proper_pair or read.is_secondary:
                continue
            if read.template_length <= 0:
                continue

            bin_idx = read.reference_start // bin_size
            if bin_idx >= n_bins:
                continue

            size = read.template_length
            if 100 <= size <= 150:
                short_counts[bin_idx] += 1
            elif 151 <= size <= 220:
                long_counts[bin_idx] += 1

        # Calculate ratio per bin
        with np.errstate(divide='ignore', invalid='ignore'):
            ratios = short_counts / long_counts
            ratios[~np.isfinite(ratios)] = np.nan

        profiles[chrom] = {
            'short': short_counts,
            'long': long_counts,
            'ratio': ratios
        }

    bam.close()
    return profiles
```

## Interpretation

| Pattern | Interpretation |
|---------|----------------|
| Higher short/long ratio | Possible tumor signal |
| Altered nucleosome positioning | Epigenetic changes |
| Tissue-specific patterns | Tissue of origin |
| Modal peak shift | cfDNA quality issue or biology |

## Related Skills

- cfdna-preprocessing - Preprocess before fragment analysis
- tumor-fraction-estimation - Complement with CNV-based estimation
- methylation-based-detection - Alternative detection approach
