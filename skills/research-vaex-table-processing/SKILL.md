---
name: research-vaex-table-processing
description: 提供对超内存表格做懒加载、聚合、筛选和导出的方法与调用指南；用于处理CSV、HDF5、Arrow或Parquet等大表。
license: MIT license
metadata:
  skill-author: K-Dense Inc.
---

# Vaex

## Codex 调用

- **选择**：请求涉及“对超内存表格做懒加载、聚合、筛选和导出”时使用；显式调用 `$research-vaex-table-processing`。
- **输入**：CSV、HDF5、Arrow或Parquet等大表。
- **预期产物**：分组统计、筛选数据、可视化或转换文件；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`vaex`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Overview

Vaex is a high-performance Python library designed for lazy, out-of-core DataFrames to process and visualize tabular datasets that are too large to fit into RAM. Vaex can process over a billion rows per second, enabling interactive data exploration and analysis on datasets with billions of rows.

## When to Use This Skill

Use Vaex when:
- Processing tabular datasets larger than available RAM (gigabytes to terabytes)
- Performing fast statistical aggregations on massive datasets
- Creating visualizations and heatmaps of large datasets
- Building machine learning pipelines on big data
- Converting between data formats (CSV, HDF5, Arrow, Parquet)
- Needing lazy evaluation and virtual columns to avoid memory overhead
- Working with astronomical data, financial time series, or other large-scale scientific datasets

## Core Capabilities

Vaex provides six primary capability areas, each documented in detail in the references directory:

### 1. DataFrames and Data Loading

Load and create Vaex DataFrames from various sources including files (HDF5, CSV, Arrow, Parquet), pandas DataFrames, NumPy arrays, and dictionaries. Reference `references/core_dataframes.md` for:
- Opening large files efficiently
- Converting from pandas/NumPy/Arrow
- Working with example datasets
- Understanding DataFrame structure

### 2. Data Processing and Manipulation

Perform filtering, create virtual columns, use expressions, and aggregate data without loading everything into memory. Reference `references/data_processing.md` for:
- Filtering and selections
- Virtual columns and expressions
- Groupby operations and aggregations
- String operations and datetime handling
- Working with missing data

### 3. Performance and Optimization

Leverage Vaex's lazy evaluation, caching strategies, and memory-efficient operations. Reference `references/performance.md` for:
- Understanding lazy evaluation
- Using `delay=True` for batching operations
- Materializing columns when needed
- Caching strategies
- Asynchronous operations

### 4. Data Visualization

Create interactive visualizations of large datasets including heatmaps, histograms, and scatter plots. Reference `references/visualization.md` for:
- Creating 1D and 2D plots
- Heatmap visualizations
- Working with selections
- Customizing plots and subplots

### 5. Machine Learning Integration

Build ML pipelines with transformers, encoders, and integration with scikit-learn, XGBoost, and other frameworks. Reference `references/machine_learning.md` for:
- Feature scaling and encoding
- PCA and dimensionality reduction
- K-means clustering
- Integration with scikit-learn/XGBoost/CatBoost
- Model serialization and deployment

### 6. I/O Operations

Efficiently read and write data in various formats with optimal performance. Reference `references/io_operations.md` for:
- File format recommendations
- Export strategies
- Working with Apache Arrow
- CSV handling for large files
- Server and remote data access

## Quick Start Pattern

For most Vaex tasks, follow this pattern:

```python
import vaex

# 1. Open or create DataFrame
df = vaex.open('large_file.hdf5')  # or .csv, .arrow, .parquet
# OR
df = vaex.from_pandas(pandas_df)

# 2. Explore the data
print(df)  # Shows first/last rows and column info
df.describe()  # Statistical summary

# 3. Create virtual columns (no memory overhead)
df['new_column'] = df.x ** 2 + df.y

# 4. Filter with selections
df_filtered = df[df.age > 25]

# 5. Compute statistics (fast, lazy evaluation)
mean_val = df.x.mean()
stats = df.groupby('category').agg({'value': 'sum'})

# 6. Visualize
df.plot1d(df.x, limits=[0, 100])
df.plot(df.x, df.y, limits='99.7%')

# 7. Export if needed
df.export_hdf5('output.hdf5')
```

## Working with References

The reference files contain detailed information about each capability area. Load references into context based on the specific task:

- **Basic operations**: Start with `references/core_dataframes.md` and `references/data_processing.md`
- **Performance issues**: Check `references/performance.md`
- **Visualization tasks**: Use `references/visualization.md`
- **ML pipelines**: Reference `references/machine_learning.md`
- **File I/O**: Consult `references/io_operations.md`

## Best Practices

1. **Use HDF5 or Apache Arrow formats** for optimal performance with large datasets
2. **Leverage virtual columns** instead of materializing data to save memory
3. **Batch operations** using `delay=True` when performing multiple calculations
4. **Export to efficient formats** rather than keeping data in CSV
5. **Use expressions** for complex calculations without intermediate storage
6. **Profile with `df.stat()`** to understand memory usage and optimize operations

## Common Patterns

### Pattern: Converting Large CSV to HDF5
```python
import vaex

# Open large CSV (processes in chunks automatically)
df = vaex.from_csv('large_file.csv')

# Export to HDF5 for faster future access
df.export_hdf5('large_file.hdf5')

# Future loads are instant
df = vaex.open('large_file.hdf5')
```

### Pattern: Efficient Aggregations
```python
# Use delay=True to batch multiple operations
mean_x = df.x.mean(delay=True)
std_y = df.y.std(delay=True)
sum_z = df.z.sum(delay=True)

# Execute all at once
results = vaex.execute([mean_x, std_y, sum_z])
```

### Pattern: Virtual Columns for Feature Engineering
```python
# No memory overhead - computed on the fly
df['age_squared'] = df.age ** 2
df['full_name'] = df.first_name + ' ' + df.last_name
df['is_adult'] = df.age >= 18
```

## Resources

This skill includes reference documentation in the `references/` directory:

- `core_dataframes.md` - DataFrame creation, loading, and basic structure
- `data_processing.md` - Filtering, expressions, aggregations, and transformations
- `performance.md` - Optimization strategies and lazy evaluation
- `visualization.md` - Plotting and interactive visualizations
- `machine_learning.md` - ML pipelines and model integration
- `io_operations.md` - File formats and data import/export

