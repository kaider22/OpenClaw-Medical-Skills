---
name: research-data-visualization-color-palettes
description: 提供为科研图选择色盲友好配色的方法与调用指南；用于处理数据类型、分组数量及绘图对象。
metadata:
  source_extensions:
    tool_type: mixed
    primary_tool: viridis
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


# Color Palettes

## Codex 调用

- **选择**：请求涉及“为科研图选择色盲友好配色”时使用；显式调用 `$research-data-visualization-color-palettes`。
- **输入**：数据类型、分组数量及绘图对象。
- **预期产物**：调色板、渐变色和色觉模拟结果；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`matplotlib`、`seaborn`、`viridis`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Palette Types

| Type | Use Case | Example |
|------|----------|---------|
| Sequential | Continuous data (expression, coverage) | viridis, Blues |
| Diverging | Centered data (fold change, z-score) | RdBu, coolwarm |
| Qualitative | Categories (clusters, conditions) | Set1, tab10 |

## viridis (Colorblind-Safe)

```r
library(viridis)

# Continuous scale
ggplot(df, aes(x, y, color = value)) +
    geom_point() +
    scale_color_viridis_c()

# Discrete scale
ggplot(df, aes(x, y, color = group)) +
    geom_point() +
    scale_color_viridis_d()

# Options: viridis, magma, plasma, inferno, cividis, turbo
scale_color_viridis_c(option = 'magma')
```

```python
import matplotlib.pyplot as plt

plt.scatter(x, y, c=values, cmap='viridis')
# Options: viridis, magma, plasma, inferno, cividis
```

## RColorBrewer (R)

```r
library(RColorBrewer)

# View all palettes
display.brewer.all()

# Sequential
scale_fill_brewer(palette = 'Blues')
scale_color_distiller(palette = 'YlOrRd', direction = 1)

# Diverging
scale_fill_brewer(palette = 'RdBu')
scale_color_gradient2(low = '#4DBBD5', mid = 'white', high = '#E64B35', midpoint = 0)

# Qualitative
scale_color_brewer(palette = 'Set1')
scale_fill_brewer(palette = 'Dark2')

# Get colors directly
brewer.pal(n = 5, name = 'Set1')
```

## matplotlib/seaborn (Python)

```python
import matplotlib.pyplot as plt
import seaborn as sns

# Sequential
plt.scatter(x, y, c=values, cmap='Blues')

# Diverging
plt.scatter(x, y, c=values, cmap='RdBu_r', vmin=-2, vmax=2)

# Qualitative
palette = sns.color_palette('Set1', n_colors=5)
sns.scatterplot(x=x, y=y, hue=group, palette='Set1')

# Custom palette
custom_palette = {'Control': '#4DBBD5', 'Treatment': '#E64B35'}
sns.scatterplot(x=x, y=y, hue=group, palette=custom_palette)
```

## Scientific Journal Palettes

```r
library(ggsci)

# Nature Publishing Group
scale_color_npg()
scale_fill_npg()

# AAAS Science
scale_color_aaas()

# Lancet
scale_color_lancet()

# JAMA
scale_color_jama()

# JCO
scale_color_jco()
```

## Custom Palettes

```r
# Define custom colors
my_colors <- c(
    'Control' = '#4DBBD5',
    'Treatment' = '#E64B35',
    'Vehicle' = '#00A087'
)

scale_color_manual(values = my_colors)
scale_fill_manual(values = my_colors)

# Create gradient
colorRampPalette(c('blue', 'white', 'red'))(100)
```

```python
from matplotlib.colors import LinearSegmentedColormap

colors = ['#4DBBD5', 'white', '#E64B35']
cmap = LinearSegmentedColormap.from_list('custom_diverging', colors)
plt.imshow(data, cmap=cmap)
```

## Heatmap Colors

```r
library(circlize)

# For ComplexHeatmap
col_fun <- colorRamp2(c(-2, 0, 2), c('#4DBBD5', 'white', '#E64B35'))

# For pheatmap
pheatmap(mat, color = colorRampPalette(rev(brewer.pal(9, 'RdBu')))(100))
```

```python
import seaborn as sns

sns.heatmap(data, cmap='RdBu_r', center=0, vmin=-2, vmax=2)
```

## Colorblind Simulation

```r
library(colorspace)

# Check if palette is colorblind safe
demoplot(rainbow(5), type = 'map')
demoplot(viridis(5), type = 'map')

# Simulate colorblindness
cvd_colors <- deutan(c('#E64B35', '#4DBBD5', '#00A087'))  # deuteranopia
cvd_colors <- protan(c('#E64B35', '#4DBBD5', '#00A087'))  # protanopia
```

## Recommended Palettes

| Data Type | Recommended | Avoid |
|-----------|-------------|-------|
| Expression heatmap | RdBu (diverging) | Rainbow |
| Categories (<8) | Set1, Dark2, npg | Too many colors |
| Categories (>8) | tab20, Paired | Qualitative sets |
| Continuous | viridis, plasma | Jet, rainbow |
| p-values | viridis (reversed) | Red-green |

## Transparency

```r
# Add alpha
scale_color_manual(values = alpha(c('#E64B35', '#4DBBD5'), 0.7))

# In geom
geom_point(alpha = 0.6)
```

```python
# Add alpha to hex
def add_alpha(hex_color, alpha):
    return hex_color + format(int(alpha * 255), '02x')

color_with_alpha = add_alpha('#E64B35', 0.7)

# In scatter
plt.scatter(x, y, c='#E64B35', alpha=0.7)
```

## Extract Colors from Palette

```r
# Get discrete colors
pal <- brewer.pal(8, 'Set1')
pal[1:3]  # First 3 colors

# Interpolate more colors
colorRampPalette(brewer.pal(8, 'Set1'))(20)
```

```python
import seaborn as sns

palette = sns.color_palette('Set1', n_colors=8)
palette[:3]  # First 3 colors

# As hex
palette.as_hex()
```

## Related Skills

- data-visualization/ggplot2-fundamentals - Apply colors
- data-visualization/heatmaps-clustering - Heatmap colors
- data-visualization/specialized-omics-plots - Plot styling


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->