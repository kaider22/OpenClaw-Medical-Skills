---
name: omics-primer-design-qpcr-primers
description: 提供设计qPCR引物及TaqMan内部探针的方法与调用指南；用于处理模板序列、目标区和qPCR参数。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: primer3-py
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


# qPCR Primer and Probe Design

## Codex 调用

- **选择**：请求涉及“设计qPCR引物及TaqMan内部探针”时使用；显式调用 `$omics-primer-design-qpcr-primers`。
- **输入**：模板序列、目标区和qPCR参数。
- **预期产物**：引物探针组合、Tm/GC和扩增子大小；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`Bio`、`pandas`、`primer3`、`primer3-py`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Design primers and internal probes for quantitative PCR using primer3-py.

## Required Imports

```python
import primer3
from Bio import SeqIO
```

## Design Primers with TaqMan Probe

```python
sequence = 'ATGCGTACGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCG' * 3

result = primer3.design_primers(
    seq_args={'SEQUENCE_TEMPLATE': sequence},
    global_args={
        'PRIMER_PICK_LEFT_PRIMER': 1,
        'PRIMER_PICK_RIGHT_PRIMER': 1,
        'PRIMER_PICK_INTERNAL_OLIGO': 1,  # Design internal probe
        'PRIMER_PRODUCT_SIZE_RANGE': [[70, 150]],  # Short amplicons for qPCR
        'PRIMER_OPT_TM': 60.0,
        'PRIMER_MIN_TM': 58.0,
        'PRIMER_MAX_TM': 62.0,
        'PRIMER_INTERNAL_OPT_TM': 70.0,  # Probe Tm ~10C higher
        'PRIMER_INTERNAL_MIN_TM': 68.0,
        'PRIMER_INTERNAL_MAX_TM': 72.0,
        'PRIMER_INTERNAL_MIN_SIZE': 18,
        'PRIMER_INTERNAL_OPT_SIZE': 25,
        'PRIMER_INTERNAL_MAX_SIZE': 30,
    }
)
```

## Extract Probe Results

```python
num_returned = result['PRIMER_PAIR_NUM_RETURNED']
print(f'Found {num_returned} primer/probe sets')

for i in range(num_returned):
    left = result[f'PRIMER_LEFT_{i}_SEQUENCE']
    right = result[f'PRIMER_RIGHT_{i}_SEQUENCE']
    probe = result[f'PRIMER_INTERNAL_{i}_SEQUENCE']
    probe_tm = result[f'PRIMER_INTERNAL_{i}_TM']
    left_tm = result[f'PRIMER_LEFT_{i}_TM']
    right_tm = result[f'PRIMER_RIGHT_{i}_TM']
    product_size = result[f'PRIMER_PAIR_{i}_PRODUCT_SIZE']

    print(f'Set {i}:')
    print(f'  Forward: {left} (Tm: {left_tm:.1f}C)')
    print(f'  Reverse: {right} (Tm: {right_tm:.1f}C)')
    print(f'  Probe:   {probe} (Tm: {probe_tm:.1f}C)')
    print(f'  Product: {product_size}bp')
```

## qPCR-Optimized Parameters

```python
result = primer3.design_primers(
    seq_args={
        'SEQUENCE_TEMPLATE': sequence,
        'SEQUENCE_TARGET': [100, 30],  # Target region for probe
    },
    global_args={
        'PRIMER_PICK_INTERNAL_OLIGO': 1,
        'PRIMER_PRODUCT_SIZE_RANGE': [[60, 100], [100, 150]],  # Prefer short
        'PRIMER_NUM_RETURN': 5,
        # Primer parameters
        'PRIMER_OPT_SIZE': 20,
        'PRIMER_MIN_SIZE': 18,
        'PRIMER_MAX_SIZE': 25,
        'PRIMER_OPT_TM': 60.0,
        'PRIMER_MIN_TM': 58.0,
        'PRIMER_MAX_TM': 62.0,
        'PRIMER_OPT_GC_PERCENT': 50.0,
        'PRIMER_MIN_GC': 35.0,
        'PRIMER_MAX_GC': 65.0,
        # Probe parameters (TaqMan: Tm 8-10C higher than primers)
        'PRIMER_INTERNAL_OPT_SIZE': 25,
        'PRIMER_INTERNAL_MIN_SIZE': 18,
        'PRIMER_INTERNAL_MAX_SIZE': 30,
        'PRIMER_INTERNAL_OPT_TM': 70.0,
        'PRIMER_INTERNAL_MIN_TM': 68.0,
        'PRIMER_INTERNAL_MAX_TM': 72.0,
        'PRIMER_INTERNAL_MIN_GC': 30.0,
        'PRIMER_INTERNAL_MAX_GC': 70.0,
        # Avoid G at 5' end of probe (quenches FAM)
        'PRIMER_INTERNAL_MAX_SELF_ANY': 8,
    }
)
```

## TaqMan Probe Constraints

```python
# Additional considerations for TaqMan probes
global_args = {
    'PRIMER_PICK_INTERNAL_OLIGO': 1,
    'PRIMER_PRODUCT_SIZE_RANGE': [[70, 150]],
    # Probe Tm should be 8-10C higher than primers
    'PRIMER_OPT_TM': 60.0,
    'PRIMER_INTERNAL_OPT_TM': 70.0,
    # Probe should be closer to forward primer
    'PRIMER_INTERNAL_MIN_SIZE': 18,
    'PRIMER_INTERNAL_MAX_SIZE': 30,
    # Avoid long poly-X runs in probe
    'PRIMER_INTERNAL_MAX_POLY_X': 3,
}
```

## SYBR Green Primers (No Probe)

```python
# For SYBR Green, design primers without probe
result = primer3.design_primers(
    seq_args={'SEQUENCE_TEMPLATE': sequence},
    global_args={
        'PRIMER_PICK_LEFT_PRIMER': 1,
        'PRIMER_PICK_RIGHT_PRIMER': 1,
        'PRIMER_PICK_INTERNAL_OLIGO': 0,  # No probe
        'PRIMER_PRODUCT_SIZE_RANGE': [[70, 200]],  # Short for qPCR
        'PRIMER_OPT_TM': 60.0,
        'PRIMER_MIN_TM': 58.0,
        'PRIMER_MAX_TM': 62.0,
        'PRIMER_MAX_SELF_ANY': 4,  # Strict for SYBR specificity
        'PRIMER_MAX_SELF_END': 2,
        'PRIMER_PAIR_MAX_COMPL_ANY': 4,
        'PRIMER_PAIR_MAX_COMPL_END': 2,
    }
)
```

## Design for Exon-Spanning (Avoid Genomic DNA)

```python
# For cDNA-specific amplification, target exon junction
# Mark the exon junction position
exon_junction = 150  # Position where exons meet

result = primer3.design_primers(
    seq_args={
        'SEQUENCE_TEMPLATE': sequence,
        'SEQUENCE_OVERLAP_JUNCTION_LIST': [exon_junction],  # Primer must span
    },
    global_args={
        'PRIMER_PRODUCT_SIZE_RANGE': [[70, 150]],
        'PRIMER_OPT_TM': 60.0,
        'PRIMER_MIN_3_PRIME_OVERLAP_OF_JUNCTION': 4,  # Min bases on each side
    }
)
```

## Multiplex Primer Design

```python
# Design primers for multiple targets with compatible Tms
targets = [
    {'name': 'gene1', 'seq': sequence1, 'target': [100, 30]},
    {'name': 'gene2', 'seq': sequence2, 'target': [150, 30]},
]

results = []
for target in targets:
    result = primer3.design_primers(
        seq_args={
            'SEQUENCE_TEMPLATE': target['seq'],
            'SEQUENCE_ID': target['name'],
            'SEQUENCE_TARGET': target['target'],
        },
        global_args={
            'PRIMER_PICK_INTERNAL_OLIGO': 1,
            'PRIMER_PRODUCT_SIZE_RANGE': [[70, 150]],
            'PRIMER_OPT_TM': 60.0,  # Same Tm for all
            'PRIMER_MAX_TM': 61.0,
            'PRIMER_MIN_TM': 59.0,
            'PRIMER_INTERNAL_OPT_TM': 70.0,
        }
    )
    results.append(result)
```

## Validate Tm Calculations

```python
# Verify Tm with primer3's thermodynamic calculations
primer_seq = 'ATGCGATCGATCGATCGATC'

# Standard Tm
tm = primer3.calc_tm(primer_seq)
print(f'Standard Tm: {tm:.1f}C')

# Tm with specific salt conditions (match your qPCR master mix)
tm_adjusted = primer3.calc_tm(
    primer_seq,
    mv_conc=50.0,    # Monovalent cation (K+, Na+) mM
    dv_conc=3.0,     # Divalent cation (Mg2+) mM
    dntp_conc=0.8,   # dNTP mM (reduces free Mg2+)
    dna_conc=250.0,  # Primer concentration nM
)
print(f'Adjusted Tm: {tm_adjusted:.1f}C')
```

## Format qPCR Results

```python
import pandas as pd

def qpcr_results_to_df(result):
    rows = []
    for i in range(result['PRIMER_PAIR_NUM_RETURNED']):
        row = {
            'pair': i,
            'forward': result[f'PRIMER_LEFT_{i}_SEQUENCE'],
            'reverse': result[f'PRIMER_RIGHT_{i}_SEQUENCE'],
            'fwd_tm': result[f'PRIMER_LEFT_{i}_TM'],
            'rev_tm': result[f'PRIMER_RIGHT_{i}_TM'],
            'product_size': result[f'PRIMER_PAIR_{i}_PRODUCT_SIZE'],
        }
        if f'PRIMER_INTERNAL_{i}_SEQUENCE' in result:
            row['probe'] = result[f'PRIMER_INTERNAL_{i}_SEQUENCE']
            row['probe_tm'] = result[f'PRIMER_INTERNAL_{i}_TM']
        rows.append(row)
    return pd.DataFrame(rows)

df = qpcr_results_to_df(result)
print(df)
```

## qPCR Design Guidelines

| Parameter | Primers | TaqMan Probe |
|-----------|---------|--------------|
| Length | 18-25 bp | 18-30 bp |
| Tm | 58-62C | 68-72C |
| GC% | 35-65% | 30-70% |
| Amplicon | 70-150 bp | - |
| 5' base | Any | Avoid G (quenches FAM) |

## Related Skills

- primer-basics - General PCR primer design
- primer-validation - Check primers for dimers and specificity
- sequence-manipulation - Work with cDNA sequences


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->