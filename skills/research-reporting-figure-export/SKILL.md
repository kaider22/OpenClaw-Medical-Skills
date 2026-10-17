---
name: research-reporting-figure-export
description: 提供按期刊规格导出统一科研图件的方法与调用指南；用于处理Matplotlib/ggplot2图对象和版式要求。
metadata:
  source_extensions:
    tool_type: mixed
    primary_tool: matplotlib
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


# Publication-Ready Figure Export

## Codex 调用

- **选择**：请求涉及“按期刊规格导出统一科研图件”时使用；显式调用 `$research-reporting-figure-export`。
- **输入**：Matplotlib/ggplot2图对象和版式要求。
- **预期产物**：PDF、PNG、SVG或TIFF图件；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`matplotlib`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Python (matplotlib)

```python
import matplotlib.pyplot as plt

# Set publication defaults
plt.rcParams.update({
    'font.size': 8,
    'font.family': 'Arial',
    'axes.linewidth': 0.5,
    'lines.linewidth': 1,
    'figure.dpi': 300
})

fig, ax = plt.subplots(figsize=(3.5, 3))  # Single column width
# ... create plot ...

# Save in multiple formats
fig.savefig('figure1.pdf', bbox_inches='tight', dpi=300)
fig.savefig('figure1.png', bbox_inches='tight', dpi=300)
fig.savefig('figure1.svg', bbox_inches='tight')
```

## R (ggplot2)

```r
library(ggplot2)

p <- ggplot(data, aes(x, y)) + geom_point() +
  theme_classic(base_size = 8) +
  theme(text = element_text(family = 'Arial'))

# PDF for vector graphics
ggsave('figure1.pdf', p, width = 3.5, height = 3, units = 'in')

# High-res PNG
ggsave('figure1.png', p, width = 3.5, height = 3, units = 'in', dpi = 300)

# TIFF (some journals require)
ggsave('figure1.tiff', p, width = 3.5, height = 3, units = 'in',
       dpi = 300, compression = 'lzw')
```

## Journal Requirements

| Journal Type | Format | Resolution | Width |
|--------------|--------|------------|-------|
| Most journals | PDF/EPS | Vector | 3.5" (1-col), 7" (2-col) |
| Online-only | PNG | 300 DPI | Variable |
| Print | TIFF | 300-600 DPI | Column width |

## Multi-panel Figures

```python
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec

fig = plt.figure(figsize=(7, 5))  # Two-column width
gs = GridSpec(2, 3, figure=fig)

ax1 = fig.add_subplot(gs[0, 0])
ax2 = fig.add_subplot(gs[0, 1:])
ax3 = fig.add_subplot(gs[1, :])

# Add panel labels
for ax, label in zip([ax1, ax2, ax3], ['A', 'B', 'C']):
    ax.text(-0.1, 1.1, label, transform=ax.transAxes,
            fontsize=10, fontweight='bold')

fig.savefig('figure_multipanel.pdf', bbox_inches='tight')
```

## Color Considerations

- Use colorblind-friendly palettes (viridis, cividis)
- Ensure sufficient contrast for grayscale printing
- Maintain consistency across all figures

## Related Skills

- data-visualization/ggplot2-fundamentals - Creating plots in R
- data-visualization/heatmaps-clustering - Complex visualizations
- data-visualization/multipanel-figures - Figure composition


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->