---
name: omics-immunoinformatics-tcr-epitope-binding
description: 通过ERGO-II或数据库匹配推断TCR-表位特异性的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: ERGO-II
---

## Version Compatibility

Reference examples tested with: MiXCR 4.6+, numpy 1.26+, pandas 2.2+, scikit-learn 1.4+, scipy 1.12+

Before using code patterns, verify installed versions match. If versions differ:
- Python: `pip show <package>` then `help(module.function)` to check signatures

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# TCR-Epitope Binding

## Codex 调用

- **选择**：请求涉及“通过ERGO-II或数据库匹配推断TCR-表位特异性”时使用；显式调用 `$omics-immunoinformatics-tcr-epitope-binding`。
- **输入**：CDR3序列、VDJdb数据和候选表位。
- **预期产物**：匹配表、相似性簇和启发式兼容分数；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **环境核对**：`ERGO-II`、`difflib`、`numpy`、`pandas`、`scipy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Predict which epitopes my TCRs recognize"** → Match T-cell receptors to their cognate epitopes using deep learning models for TCR antigen specificity prediction.
- Python: ERGO-II model for TCR-epitope binding prediction

## ERGO-II Model

```python
# ERGO-II uses deep learning to predict TCR-epitope binding
# GitHub: https://github.com/IdoSpringer/ERGO-II

def setup_ergo():
    '''Setup ERGO-II for TCR-epitope prediction

    Requirements:
    - PyTorch
    - Pre-trained models from ERGO-II repository

    ERGO-II features:
    - Uses both CDR3 alpha and beta chains
    - Incorporates MHC context
    - Trained on VDJdb and IEDB data
    '''
    print('ERGO-II setup:')
    print('1. Clone: git clone https://github.com/IdoSpringer/ERGO-II')
    print('2. Install: pip install torch pandas scikit-learn')
    print('3. Download models from repository')
```

## TCR Input Format

```python
def parse_tcr_data(tcr_file):
    '''Parse TCR sequence data

    Required columns:
    - cdr3_beta: CDR3 beta chain sequence (most informative)
    - cdr3_alpha: CDR3 alpha chain (optional, improves accuracy)
    - v_beta: V gene usage (optional)
    - j_beta: J gene usage (optional)

    CDR3 is the primary determinant of antigen specificity.
    Alpha chain provides ~20% additional specificity.
    '''
    import pandas as pd

    df = pd.read_csv(tcr_file, sep='\t')

    # Validate CDR3 sequences
    valid_aa = set('ACDEFGHIKLMNPQRSTVWY')

    def is_valid_cdr3(seq):
        if pd.isna(seq):
            return False
        return all(aa in valid_aa for aa in seq.upper())

    df['valid_beta'] = df['cdr3_beta'].apply(is_valid_cdr3)

    return df[df['valid_beta']]
```

## Predict TCR-Epitope Binding

```python
def predict_binding_simple(cdr3_beta, epitope):
    '''Simple TCR-epitope compatibility score

    This is a simplified heuristic. For accurate predictions,
    use ERGO-II or other deep learning models.

    Features considered:
    - CDR3 length compatibility
    - Amino acid composition
    - Hydrophobicity matching
    '''
    # Length compatibility
    # TCRs recognizing similar epitopes often have similar CDR3 lengths
    optimal_length = len(epitope) + 5  # Rough heuristic
    length_score = 1 - abs(len(cdr3_beta) - optimal_length) / 10

    # Charge complementarity
    positive = set('RKH')
    negative = set('DE')

    tcr_charge = sum(1 if aa in positive else -1 if aa in negative else 0
                    for aa in cdr3_beta)
    epitope_charge = sum(1 if aa in positive else -1 if aa in negative else 0
                        for aa in epitope)

    # Opposite charges suggest complementarity
    charge_score = 0.5 + (tcr_charge * -epitope_charge) / 20

    return {
        'cdr3_beta': cdr3_beta,
        'epitope': epitope,
        'length_score': max(0, min(1, length_score)),
        'charge_score': max(0, min(1, charge_score)),
        'combined': (length_score + charge_score) / 2
    }
```

## Match TCRs to Known Epitopes

```python
def match_to_vdjdb(tcr_sequences, vdjdb_path='vdjdb.tsv'):
    '''Match TCRs to known epitopes in VDJdb

    VDJdb is a curated database of TCR-epitope pairs.
    Download from: https://vdjdb.cdr3.net/

    Matching approaches:
    - Exact CDR3 match
    - Similar CDR3 (edit distance ≤1)
    - Cluster-based (group similar TCRs)
    '''
    import pandas as pd
    from difflib import SequenceMatcher

    vdjdb = pd.read_csv(vdjdb_path, sep='\t')

    matches = []
    for tcr in tcr_sequences:
        # Exact match
        exact = vdjdb[vdjdb['cdr3'] == tcr]
        if len(exact) > 0:
            matches.append({
                'query_tcr': tcr,
                'match_type': 'exact',
                'epitopes': exact['antigen.epitope'].tolist(),
                'species': exact['antigen.species'].tolist()
            })
            continue

        # Fuzzy match (1 mismatch)
        for _, row in vdjdb.iterrows():
            similarity = SequenceMatcher(None, tcr, row['cdr3']).ratio()
            if similarity > 0.9:  # >90% similar
                matches.append({
                    'query_tcr': tcr,
                    'match_type': 'similar',
                    'similarity': similarity,
                    'db_tcr': row['cdr3'],
                    'epitope': row['antigen.epitope'],
                    'species': row['antigen.species']
                })

    return pd.DataFrame(matches)
```

## TCR Clustering

**Goal:** Group TCRs that likely recognize the same epitope based on CDR3 sequence similarity, enabling specificity group discovery from large repertoire datasets.

**Approach:** Compute pairwise Levenshtein distances between CDR3 sequences, apply hierarchical clustering with average linkage, and cut the dendrogram at a maximum edit distance threshold to define specificity groups.

```python
def cluster_tcrs_by_specificity(tcr_sequences, method='levenshtein'):
    '''Cluster TCRs likely to share specificity

    TCRs recognizing the same epitope often have:
    - Similar CDR3 length
    - Shared motifs
    - Similar V gene usage

    Methods:
    - levenshtein: Edit distance clustering
    - tcrdist: TCRdist3 distance metric
    - deep: Deep learning embeddings
    '''
    from scipy.cluster.hierarchy import linkage, fcluster
    from scipy.spatial.distance import pdist, squareform
    import numpy as np

    def levenshtein_distance(s1, s2):
        if len(s1) < len(s2):
            return levenshtein_distance(s2, s1)
        if len(s2) == 0:
            return len(s1)

        previous_row = range(len(s2) + 1)
        for i, c1 in enumerate(s1):
            current_row = [i + 1]
            for j, c2 in enumerate(s2):
                insertions = previous_row[j + 1] + 1
                deletions = current_row[j] + 1
                substitutions = previous_row[j] + (c1 != c2)
                current_row.append(min(insertions, deletions, substitutions))
            previous_row = current_row

        return previous_row[-1]

    # Calculate pairwise distances
    n = len(tcr_sequences)
    distances = np.zeros((n, n))
    for i in range(n):
        for j in range(i + 1, n):
            d = levenshtein_distance(tcr_sequences[i], tcr_sequences[j])
            distances[i, j] = distances[j, i] = d

    # Cluster
    condensed = squareform(distances)
    Z = linkage(condensed, method='average')
    clusters = fcluster(Z, t=3, criterion='distance')  # Max 3 edits

    return dict(zip(tcr_sequences, clusters))
```

## Analyze Repertoire Specificity

```python
def analyze_repertoire_specificity(tcr_df, epitope_db):
    '''Analyze antigen specificity of TCR repertoire

    Reports:
    - Fraction matching known epitopes
    - Epitope diversity
    - Potential public TCRs (shared across individuals)
    '''
    results = {
        'total_tcrs': len(tcr_df),
        'unique_cdr3': tcr_df['cdr3_beta'].nunique(),
        'matched_epitopes': 0,
        'epitope_distribution': {}
    }

    # Match to database
    matched = match_to_vdjdb(tcr_df['cdr3_beta'].unique(), epitope_db)

    if len(matched) > 0:
        results['matched_epitopes'] = len(matched['query_tcr'].unique())
        results['epitope_distribution'] = matched['epitope'].value_counts().to_dict()

    return results
```

## Related Skills

- tcr-bcr-analysis/mixcr-analysis - TCR repertoire sequencing analysis
- immunoinformatics/mhc-binding-prediction - Epitope context
- single-cell/clustering - Single-cell TCR analysis
