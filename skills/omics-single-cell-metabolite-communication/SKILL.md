---
name: omics-single-cell-metabolite-communication
description: 提供从酶和受体表达推断代谢物通信的方法与调用指南；用于处理带细胞类型的log标准化AnnData和物种。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: MeboCost
---

## Version Compatibility

Reference examples tested with: matplotlib 3.8+, scanpy 1.10+

Before using code patterns, verify installed versions match. If versions differ:
- Python: `pip show <package>` then `help(module.function)` to check signatures

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Metabolite-Mediated Cell Communication

## Codex 调用

- **选择**：请求涉及“从酶和受体表达推断代谢物通信”时使用；显式调用 `$omics-single-cell-metabolite-communication`。
- **输入**：带细胞类型的log标准化AnnData和物种。
- **预期产物**：代谢物发送者/受体互作及置换p值；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`MeboCost`、`matplotlib`、`mebocost`、`scanpy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Analyze metabolic crosstalk between cell types"** → Predict metabolite secretion-sensing interactions between cell populations based on enzyme and transporter expression patterns.
- Python: `mebocost.MeboCost(adata, groupby='cell_type')` → `run_mebocost()`

## MeboCost Overview

MeboCost infers metabolite-mediated communication by:
1. Predicting metabolite secretion from enzyme expression
2. Identifying metabolite-sensing receptors
3. Computing communication scores between cell types

## Basic Workflow

**Goal:** Infer metabolite-mediated cell-cell communication from scRNA-seq data by predicting which cell types secrete and sense specific metabolites.

**Approach:** Initialize a MeboCost object from an AnnData with cell type annotations, run permutation-based communication inference to score metabolite secretion-sensing interactions, then filter for statistically significant pairs.

```python
import mebocost as mbc
import scanpy as sc

# Load scRNA-seq data
adata = sc.read_h5ad('adata.h5ad')

# Initialize MeboCost
mebo = mbc.create_obj(
    adata=adata,
    group_col='cell_type',  # Cell type annotation column
    species='human'  # 'human' or 'mouse'
)

# Infer metabolite communication
mebo.infer_commu(
    n_permutations=1000,  # Permutations for significance testing
    seed=42
)

# Get significant interactions
sig_interactions = mebo.commu_res[mebo.commu_res['pval'] < 0.05]
```

## Prepare Data

```python
import scanpy as sc

def prepare_for_mebocost(adata, cell_type_col='cell_type', min_cells=50):
    '''Prepare AnnData for MeboCost analysis

    Requirements:
    - Log-normalized expression (sc.pp.normalize_total, sc.pp.log1p)
    - Cell type annotations
    - Gene symbols (not Ensembl IDs)
    '''
    # Check normalization
    if adata.X.max() > 50:
        print('Warning: Data may not be log-normalized')

    # Filter rare cell types
    cell_counts = adata.obs[cell_type_col].value_counts()
    valid_types = cell_counts[cell_counts >= min_cells].index
    adata = adata[adata.obs[cell_type_col].isin(valid_types)].copy()

    print(f'Cell types: {len(valid_types)}')
    print(f'Cells: {adata.n_obs}')

    return adata
```

## Run Communication Analysis

```python
def run_mebocost(adata, cell_type_col='cell_type', species='human'):
    '''Run MeboCost metabolite communication analysis

    Args:
        adata: AnnData with log-normalized expression
        cell_type_col: Column with cell type annotations
        species: 'human' or 'mouse'

    Returns:
        MeboCost object with communication results
    '''
    import mebocost as mbc

    # Create MeboCost object
    mebo = mbc.create_obj(
        adata=adata,
        group_col=cell_type_col,
        species=species
    )

    # Infer enzyme-metabolite-receptor communication
    # n_permutations: Higher = more accurate p-values but slower
    # 1000 is standard; use 100 for quick exploration
    mebo.infer_commu(n_permutations=1000, seed=42)

    return mebo
```

## Analyze Results

```python
def analyze_metabolite_communication(mebo, pval_threshold=0.05):
    '''Extract and summarize significant communications

    Communication flow:
    Sender cell -> Enzyme -> Metabolite -> Receptor -> Receiver cell
    '''
    results = mebo.commu_res.copy()

    # Filter significant interactions
    sig = results[results['pval'] < pval_threshold]

    # Summary statistics
    summary = {
        'total_interactions': len(results),
        'significant_interactions': len(sig),
        'unique_metabolites': sig['metabolite'].nunique(),
        'unique_sender_types': sig['sender'].nunique(),
        'unique_receiver_types': sig['receiver'].nunique()
    }

    # Top metabolites by frequency
    top_metabolites = sig['metabolite'].value_counts().head(10)

    # Top sender-receiver pairs
    sig['pair'] = sig['sender'] + ' -> ' + sig['receiver']
    top_pairs = sig['pair'].value_counts().head(10)

    return {
        'summary': summary,
        'top_metabolites': top_metabolites,
        'top_pairs': top_pairs,
        'significant_interactions': sig
    }
```

## Visualization

```python
def plot_communication_network(mebo, pval_threshold=0.05):
    '''Plot metabolite communication network'''
    import matplotlib.pyplot as plt

    # Filter significant
    sig = mebo.commu_res[mebo.commu_res['pval'] < pval_threshold]

    # Aggregate by cell type pair
    pair_counts = sig.groupby(['sender', 'receiver']).size().reset_index(name='count')

    # Create chord diagram or heatmap
    pivot = pair_counts.pivot(index='sender', columns='receiver', values='count')
    pivot = pivot.fillna(0)

    plt.figure(figsize=(10, 8))
    plt.imshow(pivot.values, cmap='Reds')
    plt.xticks(range(len(pivot.columns)), pivot.columns, rotation=45, ha='right')
    plt.yticks(range(len(pivot.index)), pivot.index)
    plt.colorbar(label='Number of interactions')
    plt.xlabel('Receiver')
    plt.ylabel('Sender')
    plt.title('Metabolite Communication Network')
    plt.tight_layout()

    return plt.gcf()


def plot_metabolite_flow(mebo, metabolite, pval_threshold=0.05):
    '''Visualize communication flow for specific metabolite'''
    sig = mebo.commu_res[
        (mebo.commu_res['metabolite'] == metabolite) &
        (mebo.commu_res['pval'] < pval_threshold)
    ]

    print(f'\n{metabolite} communication:')
    for _, row in sig.iterrows():
        print(f"  {row['sender']} ({row['enzyme']}) -> "
              f"{row['receiver']} ({row['receptor']})")
        print(f"    Score: {row['commu_score']:.3f}, p-value: {row['pval']:.4f}")
```

## Compare Conditions

```python
def compare_conditions(adata, condition_col, cell_type_col, species='human'):
    '''Compare metabolite communication between conditions

    Useful for:
    - Tumor vs normal
    - Treatment vs control
    - Disease vs healthy
    '''
    import mebocost as mbc

    conditions = adata.obs[condition_col].unique()
    results = {}

    for condition in conditions:
        adata_subset = adata[adata.obs[condition_col] == condition].copy()

        mebo = mbc.create_obj(
            adata=adata_subset,
            group_col=cell_type_col,
            species=species
        )
        mebo.infer_commu(n_permutations=1000, seed=42)

        results[condition] = mebo.commu_res

    # Find differential communications
    # Interactions significant in one condition but not another
    return results
```

## Metabolite Categories

```python
# MeboCost includes curated metabolite-receptor pairs
# Major categories:

METABOLITE_CATEGORIES = {
    'amino_acids': ['Glutamine', 'Glutamate', 'Tryptophan', 'Arginine'],
    'lipids': ['Prostaglandin E2', 'Leukotriene B4', 'Sphingosine-1-phosphate'],
    'nucleotides': ['ATP', 'Adenosine', 'UDP'],
    'vitamins': ['Retinoic acid', 'Vitamin D'],
    'other': ['Lactate', 'Succinate', 'Itaconate']
}

def filter_by_category(results, category):
    '''Filter results to specific metabolite category'''
    metabolites = METABOLITE_CATEGORIES.get(category, [])
    return results[results['metabolite'].isin(metabolites)]
```

## Related Skills

- single-cell/cell-communication - Ligand-receptor communication analysis
- metabolomics/pathway-mapping - Metabolic pathway context
- systems-biology/flux-balance-analysis - Metabolic flux predictions
