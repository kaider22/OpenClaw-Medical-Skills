---
name: omics-flow-cytometry-compensation-transformation
description: 提供计算并应用流式补偿矩阵及logicle/arcsinh变换的方法与调用指南；用于处理FCS、单染/未染对照或spillover矩阵、通道面板。
metadata:
  source_extensions:
    tool_type: r
    primary_tool: flowCore
---

## Version Compatibility

Reference examples tested with: flowCore 2.14+, scanpy 1.10+

Before using code patterns, verify installed versions match. If versions differ:
- R: `packageVersion('<pkg>')` then `?function_name` to verify parameters

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Compensation and Transformation

## Codex 调用

- **选择**：请求涉及“计算并应用流式补偿矩阵及logicle/arcsinh变换”时使用；显式调用 `$omics-flow-cytometry-compensation-transformation`。
- **输入**：FCS、单染/未染对照或spillover矩阵、通道面板。
- **预期产物**：补偿变换后的FCS/SCE及可复现参数；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`flowCore`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Compensate and transform my flow cytometry data"** → Correct spectral overlap between fluorophores using a compensation matrix and apply biexponential/arcsinh transforms for visualization and analysis.
- R: `flowCore::compensate()` then `flowCore::transform()` with `estimateLogicle()`

## Load Compensation Matrix

```r
library(flowCore)

# From FCS file keywords
fcs <- read.FCS('sample.fcs', transformation = FALSE)
comp_matrix <- keyword(fcs)$`$SPILLOVER`

# Or from CSV file
comp_matrix <- as.matrix(read.csv('compensation.csv', row.names = 1))
```

## Apply Compensation

```r
# Create compensation object
comp <- compensation(comp_matrix)

# Apply to flowFrame
fcs_comp <- compensate(fcs, comp)

# Apply to flowSet
fs_comp <- compensate(fs, comp)
```

## Calculate Compensation from Controls

```r
library(flowStats)

# Single-stained controls
controls <- read.flowSet(list.files('controls', pattern = '\\.fcs$', full.names = TRUE))

# Calculate spillover matrix
spillover <- spillover(controls,
                        unstained = 'Unstained.fcs',
                        fsc = 'FSC-A', ssc = 'SSC-A',
                        patt = '-A$',  # Channel pattern
                        stain_match = 'regexpr')

# The result is a list; extract matrix
comp_matrix <- spillover$comp
```

## Transformation: Biexponential (Logicle)

```r
# Logicle transformation (standard for flow)
library(flowWorkspace)

# Auto-estimate parameters
lgcl <- estimateLogicle(fcs, colnames(fcs)[3:10])

# Apply
fcs_trans <- transform(fcs, lgcl)

# Manual logicle parameters
lgcl_manual <- logicleTransform(
    w = 0.5,      # Linearization width
    t = 262144,   # Top of scale
    m = 4.5,      # Decades of data
    a = 0         # Additional negative range
)
```

## Transformation: Arcsinh (CyTOF)

```r
# Arcsinh transformation for CyTOF
arcsinh_transform <- function(x, cofactor = 5) {
    asinh(x / cofactor)
}

# Apply to expression matrix
expr <- exprs(fcs)
expr_trans <- apply(expr[, marker_channels], 2, arcsinh_transform, cofactor = 5)

# Or using transformList
asinhTrans <- arcsinhTransform(transformationId = 'arcsinh', a = 0, b = 1/5)
trans_list <- transformList(marker_channels, asinhTrans)
fcs_trans <- transform(fcs, trans_list)
```

## Transformation: Log

```r
# Simple log transformation
logTrans <- logTransform(transformationId = 'log10', logbase = 10, r = 1, d = 1)
trans_list <- transformList(marker_channels, logTrans)
fcs_trans <- transform(fcs, trans_list)
```

## View Before/After Compensation

```r
library(ggcyto)

# Before compensation
p1 <- autoplot(fcs, 'FITC-A', 'PE-A') + ggtitle('Before Compensation')

# After compensation
p2 <- autoplot(fcs_comp, 'FITC-A', 'PE-A') + ggtitle('After Compensation')

library(patchwork)
p1 + p2
```

## Complete Preprocessing Pipeline

**Goal:** Apply a standard compensation-then-transformation workflow to all samples in a flowSet.

**Approach:** Define a reusable preprocessing function that first applies the spillover compensation matrix, then auto-estimates and applies logicle transformation on marker channels, and map it across all samples with fsApply.

```r
preprocess_flow <- function(fcs, comp_matrix, marker_channels) {
    # 1. Compensation
    comp <- compensation(comp_matrix)
    fcs <- compensate(fcs, comp)

    # 2. Transformation (logicle for flow, arcsinh for CyTOF)
    lgcl <- estimateLogicle(fcs, marker_channels)
    fcs <- transform(fcs, lgcl)

    return(fcs)
}

# Apply to flowSet
fs_processed <- fsApply(fs, function(f) {
    preprocess_flow(f, comp_matrix, marker_channels)
})
```

## CATALYST Preprocessing (CyTOF)

```r
library(CATALYST)
library(SingleCellExperiment)

# Create SingleCellExperiment from flowSet
sce <- prepData(fs,
                panel = panel,      # data.frame with columns: fcs_colname, antigen, marker_class
                md = sample_info,   # sample metadata
                transform = TRUE,   # Apply arcsinh
                cofactor = 5,
                FACS = FALSE)       # TRUE for flow, FALSE for CyTOF
```

## Panel File Format (CATALYST)

```r
# panel.csv
panel <- data.frame(
    fcs_colname = c('Yb176Di', 'Er168Di', 'Nd142Di'),
    antigen = c('CD45', 'CD3', 'CD4'),
    marker_class = c('type', 'type', 'type')  # 'type' for phenotyping, 'state' for functional
)
```

## Save Preprocessed Data

```r
# Write transformed FCS
write.FCS(fcs_trans, 'sample_preprocessed.fcs')

# Save transformation for reproducibility
saveRDS(list(comp = comp_matrix, transform = lgcl), 'preprocessing_params.rds')
```

## Related Skills

- fcs-handling - Load FCS files first
- gating-analysis - Gate after preprocessing
- clustering-phenotyping - Cluster transformed data
