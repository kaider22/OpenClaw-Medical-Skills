---
name: omics-epitranscriptomics-m6anet-analysis
description: 提供从ONT direct RNA信号推断转录本m6A修饰位点的方法与调用指南；用于处理ONT FAST5、basecall reads和转录组参考序列。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: m6Anet
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


# m6Anet Analysis

## Codex 调用

- **选择**：请求涉及“从ONT direct RNA信号推断转录本m6A修饰位点”时使用；显式调用 `$omics-epitranscriptomics-m6anet-analysis`。
- **输入**：ONT FAST5、basecall reads和转录组参考序列。
- **预期产物**：位点修饰概率表及高置信m6A位点；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`m6Anet`、`m6anet`、`pandas`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Documentation: https://m6anet.readthedocs.io/

## Data Preparation

```bash
# Basecall with Guppy (requires FAST5 files)
guppy_basecaller \
    -i fast5_dir \
    -s basecalled \
    --flowcell FLO-MIN106 \
    --kit SQK-RNA002

# Align to transcriptome
minimap2 -ax map-ont -uf transcriptome.fa reads.fastq > aligned.sam
```

## Run m6Anet

```python
from m6anet.utils import preprocess
from m6anet import run_inference

# Preprocess: extract features from FAST5
preprocess.run(
    fast5_dir='fast5_pass',
    out_dir='m6anet_data',
    reference='transcriptome.fa',
    n_processes=8
)

# Run m6A inference
run_inference.run(
    input_dir='m6anet_data',
    out_dir='m6anet_results',
    n_processes=4
)
```

## CLI Workflow

```bash
# Preprocess
m6anet dataprep \
    --input_dir fast5_pass \
    --output_dir m6anet_data \
    --reference transcriptome.fa \
    --n_processes 8

# Inference
m6anet inference \
    --input_dir m6anet_data \
    --output_dir m6anet_results \
    --n_processes 4
```

## Interpret Results

```python
import pandas as pd

results = pd.read_csv('m6anet_results/data.site_proba.csv')

# Filter high-confidence m6A sites
# probability > 0.9: High confidence threshold
m6a_sites = results[results['probability_modified'] > 0.9]
```

## Related Skills

- long-read-sequencing - ONT data processing
- m6a-peak-calling - MeRIP-seq alternative
- modification-visualization - Plot m6A sites


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->