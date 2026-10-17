---
name: research-reporting-jupyter-reports
description: 提供用Papermill参数化执行并批量生成分析笔记本的方法与调用指南；用于处理参数化Jupyter模板及样本参数。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: papermill
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


# Jupyter Reports with Papermill

## Codex 调用

- **选择**：请求涉及“用Papermill参数化执行并批量生成分析笔记本”时使用；显式调用 `$research-reporting-jupyter-reports`。
- **输入**：参数化Jupyter模板及样本参数。
- **预期产物**：执行后的笔记本和HTML/PDF报告；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`papermill`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Parameterized Notebooks

```python
import papermill as pm

# Execute notebook with parameters
pm.execute_notebook(
    'analysis_template.ipynb',
    'output_report.ipynb',
    parameters={
        'input_file': 'data/counts.csv',
        'condition_col': 'treatment',
        'fdr_threshold': 0.05
    }
)
```

## Creating Parameterized Templates

Mark a cell with the `parameters` tag in Jupyter:

```python
# Parameters (tag this cell as "parameters")
input_file = 'default.csv'
output_dir = 'results/'
fdr_threshold = 0.05
```

## Batch Processing

```python
import papermill as pm
from pathlib import Path

samples = ['sample1', 'sample2', 'sample3']

for sample in samples:
    pm.execute_notebook(
        'qc_template.ipynb',
        f'reports/{sample}_qc.ipynb',
        parameters={'sample_id': sample}
    )
```

## Converting to HTML/PDF

```bash
# Single notebook
jupyter nbconvert --to html report.ipynb

# With execution
jupyter nbconvert --execute --to html report.ipynb

# PDF (requires pandoc + LaTeX)
jupyter nbconvert --to pdf report.ipynb
```

## Best Practices

- Keep analysis code in cells, explanatory text in markdown
- Use parameters for all configurable values
- Include version information and timestamps
- Clear outputs before committing to version control

## Related Skills

- reporting/quarto-reports - Alternative report format
- reporting/rmarkdown-reports - R-based reports
- workflows/rnaseq-to-de - Embed in workflows


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->