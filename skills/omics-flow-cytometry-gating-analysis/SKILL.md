---
name: omics-flow-cytometry-gating-analysis
description: 提供用层级门控定义流式细胞群体的方法与调用指南；用于处理FCS/flowSet、标记通道和父子门控策略。
metadata:
  source_extensions:
    tool_type: r
    primary_tool: flowWorkspace
---

## Version Compatibility

Reference examples tested with: flowCore 2.14+

Before using code patterns, verify installed versions match. If versions differ:
- R: `packageVersion('<pkg>')` then `?function_name` to verify parameters

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Gating Analysis

## Codex 调用

- **选择**：请求涉及“用层级门控定义流式细胞群体”时使用；显式调用 `$omics-flow-cytometry-gating-analysis`。
- **输入**：FCS/flowSet、标记通道和父子门控策略。
- **预期产物**：GatingSet群体、计数统计和FlowJo工作区；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`flowWorkspace`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Gate my flow cytometry data to identify cell populations"** → Define cell populations through manual or automated gating strategies using rectangular, polygon, or data-driven gates in a hierarchical framework.
- R: `flowWorkspace::gs_add_gating_method()`, `openCyto::gating()` for automated gating

## Manual Rectangular Gates

```r
library(flowCore)

# Create rectangular gate
cd4_gate <- rectangleGate(filterId = 'CD4+',
                           'CD4' = c(500, Inf),
                           'CD3' = c(200, Inf))

# Apply gate
cd4_result <- filter(fcs, cd4_gate)
summary(cd4_result)

# Get cells in gate
cd4_cells <- Subset(fcs, cd4_gate)
```

## Polygon Gates

```r
# Define polygon vertices
vertices <- matrix(c(100, 100,    # x1, y1
                      1000, 100,   # x2, y2
                      1000, 1000,  # x3, y3
                      100, 1000),  # x4, y4
                    ncol = 2, byrow = TRUE)
colnames(vertices) <- c('FSC-A', 'SSC-A')

# Create polygon gate
poly_gate <- polygonGate(filterId = 'Lymphocytes', .gate = vertices)

# Apply
lymph <- Subset(fcs, poly_gate)
```

## Gating Hierarchy (flowWorkspace)

```r
library(flowWorkspace)

# Create GatingSet from flowSet
gs <- GatingSet(fs)

# Add gates to hierarchy
gs_pop_add(gs, cd4_gate, parent = 'root')

# Add child gate
cd4_cd8_gate <- rectangleGate(filterId = 'CD8+', 'CD8' = c(500, Inf))
gs_pop_add(gs, cd4_cd8_gate, parent = 'CD4+')

# View hierarchy
gs_get_pop_paths(gs)

# Recompute statistics
recompute(gs)

# Get population statistics
gs_pop_get_stats(gs)
```

## Automated Gating: flowDensity

```r
library(flowDensity)

# Data-driven gate based on density
cd4_gate <- deGate(fcs, channel = 'CD4', use.upper = TRUE)

# Get threshold
cd4_threshold <- cd4_gate@min

# Apply
cd4_pos <- flowDensity(fcs, channels = 'CD4', position = c(TRUE))
cd4_cells <- getflowFrame(cd4_pos)
```

## Automated Gating: openCyto

**Goal:** Apply a reproducible, template-driven gating strategy that automatically identifies cell populations across all samples.

**Approach:** Define a CSV gating template specifying parent-child hierarchy, channel combinations, and gating algorithms (flowClust, singletGate, mindensity, quadrantGate), then apply the template to a GatingSet for batch processing.

```r
library(openCyto)

# Define gating template
gating_template <- fread('
alias,pop,parent,dims,gating_method,gating_args
nonDebris,+,root,FSC-A,flowClust,K=2
singlets,+,nonDebris,"FSC-A,FSC-H",singletGate,
lymph,+,singlets,"FSC-A,SSC-A",flowClust,K=3
cd3,+,lymph,CD3,mindensity,
cd4,+,cd3,"CD4,CD8",quadrantGate,
')

# Apply template
gt <- gatingTemplate(gating_template)
gs <- GatingSet(fs)
gating(gt, gs)
```

## Quadrant Gates

```r
# Create quadrant gate
quad_gate <- quadGate(filterId = 'CD4_CD8_quad',
                       'CD4' = 500,
                       'CD8' = 500)

# Results in 4 populations:
# CD4+CD8-, CD4-CD8+, CD4+CD8+, CD4-CD8-
```

## Boolean Gates

```r
# Combine gates with logic
cd4_not_cd8 <- cd4_gate & !cd8_gate

# Alternative using GatingSet
gs_pop_add(gs,
           booleanFilter(CD4+CD8- = CD4+ & !CD8+),
           parent = 'lymph')
```

## Extract Gated Populations

```r
# Get data for specific population
cd4_data <- gh_pop_get_data(gs[[1]], 'CD4+')

# Get indices
cd4_indices <- gh_pop_get_indices(gs[[1]], 'CD4+')

# Counts
gs_pop_get_count_fast(gs)
```

## Visualization

```r
library(ggcyto)

# Plot with gates
autoplot(gs[[1]], 'CD4+')

# Multiple populations
autoplot(gs[[1]], c('CD4+', 'CD8+'))

# Gate overlay
autoplot(fcs, 'CD4', 'CD8') +
    geom_gate(cd4_gate)
```

## Export Gating Strategy

```r
# Save GatingSet
save_gs(gs, 'gating_set')

# Export to FlowJo workspace
library(CytoML)
gatingset_to_flowjo(gs, 'analysis.wsp')
```

## Related Skills

- compensation-transformation - Preprocess before gating
- clustering-phenotyping - Unsupervised alternative
- differential-analysis - Compare gated populations
