---
name: omics-flow-cytometry-fcs-handling
description: 提供读取、检查并整理流式FCS事件数据的方法与调用指南；用于处理FCS文件、样本注释和通道元数据。
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

# FCS File Handling

## Codex 调用

- **选择**：请求涉及“读取、检查并整理流式FCS事件数据”时使用；显式调用 `$omics-flow-cytometry-fcs-handling`。
- **输入**：FCS文件、样本注释和通道元数据。
- **预期产物**：flowFrame/flowSet、表达矩阵和可写回FCS；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`flowCore`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Load my FCS files into R or Python"** → Read Flow Cytometry Standard (FCS) files, access channel parameters and metadata, and explore event data for downstream analysis.
- R: `flowCore::read.FCS()` or `flowCore::read.flowSet()` for multiple files
- Python: `fcsparser.parse()` or `FlowCal.io.FCSData()`

## Load FCS Files

**Goal:** Read a single FCS file and inspect its parameters and metadata.

**Approach:** Use flowCore's read.FCS with transformation disabled to load raw data, then examine parameter names and descriptions.

```r
library(flowCore)

# Read single FCS file
fcs <- read.FCS('sample.fcs', transformation = FALSE, truncate_max_range = FALSE)

# File info
print(fcs)

# Parameter names
colnames(fcs)  # Short names
pData(parameters(fcs))  # Full metadata including descriptions
```

## Load Multiple Files

**Goal:** Read a batch of FCS files into a single flowSet container for uniform processing.

**Approach:** List FCS files from a directory and load them into a flowSet with read.flowSet.

```r
# Read multiple files into flowSet
files <- list.files('data', pattern = '\\.fcs$', full.names = TRUE)
fs <- read.flowSet(files, transformation = FALSE, truncate_max_range = FALSE)

# Sample names
sampleNames(fs)

# Access individual samples
fcs1 <- fs[[1]]
```

## Access Expression Data

**Goal:** Extract the expression matrix from a flowFrame for numeric analysis.

**Approach:** Call exprs() to get the cells-by-channels matrix, then subset or summarize as needed.

```r
# Get expression matrix
expr <- exprs(fcs)
head(expr)

# Dimensions
dim(expr)  # cells x channels

# Channel statistics
summary(expr)

# Get specific channels
cd4_expr <- expr[, 'CD4']
```

## Channel Metadata

**Goal:** Retrieve channel names, descriptions, and ranges from the FCS parameter table.

**Approach:** Access the parameters slot via pData(parameters(fcs)) and build a short-name to description mapping.

```r
# Parameter information
params <- pData(parameters(fcs))
print(params)

# Parameter columns:
# - name: short name (e.g., "FL1-A")
# - desc: description (e.g., "CD4")
# - range: max value
# - minRange: min value

# Get channel mapping
channel_map <- setNames(params$desc, params$name)
```

## Rename Channels

```r
# Rename using descriptions
rename_channels <- function(fcs) {
    params <- pData(parameters(fcs))
    new_names <- ifelse(is.na(params$desc) | params$desc == '',
                        params$name, params$desc)
    colnames(fcs) <- new_names
    return(fcs)
}

fcs_renamed <- rename_channels(fcs)
```

## Subsetting Data

```r
# Subset by cells (rows)
fcs_subset <- fcs[1:1000, ]

# Subset by channels (columns)
fcs_markers <- fcs[, c('CD4', 'CD8', 'CD3')]

# Subset by expression values
high_cd4 <- fcs[exprs(fcs)[, 'CD4'] > 1000, ]
```

## Merge flowSets

```r
# Combine multiple flowSets
fs_combined <- rbind2(fs1, fs2)

# Or concatenate into single flowFrame
all_data <- fsApply(fs, exprs)
all_data <- do.call(rbind, all_data)
```

## Write FCS Files

```r
# Write single file
write.FCS(fcs, 'output.fcs')

# Write flowSet
write.flowSet(fs, outdir = 'output_dir')
```

## Sample Metadata

```r
# Add sample annotations
pData(fs) <- data.frame(
    name = sampleNames(fs),
    condition = c('Control', 'Control', 'Treatment', 'Treatment'),
    patient = c('P1', 'P2', 'P1', 'P2')
)

# Access
pData(fs)
```

## Basic Visualization

```r
library(ggcyto)

# Density plot
autoplot(fcs, 'FSC-A')

# Bivariate plot
autoplot(fcs, 'CD4', 'CD8')

# Multiple samples
autoplot(fs, 'CD4', 'CD8')
```

## Check Data Quality

```r
# Time parameter check
if ('Time' %in% colnames(fcs)) {
    time <- exprs(fcs)[, 'Time']
    plot(time, type = 'l', main = 'Acquisition Time')
}

# Event count per file
fsApply(fs, nrow)

# Check for saturated events
saturation <- apply(exprs(fcs), 2, function(x) mean(x == max(x)) * 100)
print(saturation)
```

## Convert to Data Frame

```r
# For use with tidyverse
library(tidyverse)

df <- as.data.frame(exprs(fcs))
df$sample <- 'sample1'

# From flowSet
df_all <- fsApply(fs, function(f) {
    d <- as.data.frame(exprs(f))
    d$sample <- identifier(f)
    d
}, simplify = FALSE)
df_all <- bind_rows(df_all)
```

## Related Skills

- compensation-transformation - Apply compensation and transforms
- gating-analysis - Define cell populations
- clustering-phenotyping - Unsupervised analysis
