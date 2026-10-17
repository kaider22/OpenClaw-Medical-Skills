---
name: omics-alignment-pairwise
description: 提供用动态规划完成DNA/RNA/蛋白全局或局部比对的方法与调用指南；用于处理两条序列、模式、评分参数或替换矩阵。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: Bio.Align
---

## Version Compatibility

Reference examples tested with: BioPython 1.83+

Before using code patterns, verify installed versions match. If versions differ:
- Python: `pip show <package>` then `help(module.function)` to check signatures

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Pairwise Sequence Alignment

## Codex 调用

- **选择**：请求涉及“用动态规划完成DNA/RNA/蛋白全局或局部比对”时使用；显式调用 `$omics-alignment-pairwise`。
- **输入**：两条序列、模式、评分参数或替换矩阵。
- **预期产物**：最优比对、得分、身份和坐标映射；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`Bio`、`Bio.Align`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Align two sequences"** → Compute an optimal alignment between a pair of sequences using dynamic programming.
- Python: `PairwiseAligner()` (BioPython Bio.Align)
- CLI: `needle` (global) or `water` (local) from EMBOSS
- R: `pairwiseAlignment()` (Biostrings)

Align two sequences using dynamic programming algorithms (Needleman-Wunsch for global, Smith-Waterman for local).

## Required Import

**Goal:** Load modules needed for pairwise alignment operations.

**Approach:** Import the PairwiseAligner class along with sequence and I/O utilities from Biopython.

```python
from Bio.Align import PairwiseAligner
from Bio.Seq import Seq
from Bio import SeqIO
```

## Core Concepts

| Mode | Algorithm | Use Case |
|------|-----------|----------|
| `global` | Needleman-Wunsch | Full-length alignment, similar-length sequences |
| `local` | Smith-Waterman | Find best matching regions, different-length sequences |

## Creating an Aligner

**Goal:** Configure a PairwiseAligner with appropriate scoring for the sequence type.

**Approach:** Instantiate PairwiseAligner with mode, scoring parameters, or a substitution matrix depending on DNA vs protein input.

```python
# Basic aligner with defaults
aligner = PairwiseAligner()

# Configure mode and scoring
aligner = PairwiseAligner(mode='global', match_score=2, mismatch_score=-1, open_gap_score=-10, extend_gap_score=-0.5)

# For protein alignment with substitution matrix
from Bio.Align import substitution_matrices
aligner = PairwiseAligner(mode='global', substitution_matrix=substitution_matrices.load('BLOSUM62'))
```

## Performing Alignments

**"Align two sequences"** → Compute optimal alignment(s) between a pair of sequences, returning alignment objects or a score.

**Goal:** Align two sequences and retrieve the optimal alignment(s) or score.

**Approach:** Call `aligner.align()` for full alignment objects or `aligner.score()` for score-only (faster for large sequences).

```python
seq1 = Seq('ACCGGTAACGTAG')
seq2 = Seq('ACCGTTAACGAAG')

# Get all optimal alignments
alignments = aligner.align(seq1, seq2)
print(f'Found {len(alignments)} optimal alignments')
print(alignments[0])  # Print first alignment

# Get score only (faster for large sequences)
score = aligner.score(seq1, seq2)
```

## Alignment Output Format

```
target            0 ACCGGTAACGTAG 13
                  0 |||||.||||.|| 13
query             0 ACCGTTAACGAAG 13
```

## Accessing Alignment Data

**Goal:** Extract alignment properties including score, shape, aligned sequences, and coordinate mappings.

**Approach:** Access alignment object attributes and indexing to retrieve per-sequence aligned strings and coordinate arrays.

```python
alignment = alignments[0]

# Basic properties
print(alignment.score)                    # Alignment score
print(alignment.shape)                    # (num_seqs, alignment_length)
print(len(alignment))                     # Alignment length

# Get aligned sequences with gaps
target_aligned = alignment[0, :]          # First sequence (target) with gaps
query_aligned = alignment[1, :]           # Second sequence (query) with gaps

# Get coordinate mapping
print(alignment.aligned)                  # Array of aligned segment coordinates
print(alignment.coordinates)              # Full coordinate array
```

## Alignment Counts (Identities, Mismatches, Gaps)

**Goal:** Quantify identities, mismatches, and gaps in an alignment to calculate percent identity.

**Approach:** Use the `.counts()` method on the alignment object and derive percent identity from identity and mismatch totals.

```python
alignment = alignments[0]
counts = alignment.counts()

print(f'Identities: {counts.identities}')
print(f'Mismatches: {counts.mismatches}')
print(f'Gaps: {counts.gaps}')

# Calculate percent identity
total_aligned = counts.identities + counts.mismatches
percent_identity = counts.identities / total_aligned * 100
print(f'Percent identity: {percent_identity:.1f}%')
```

## Common Scoring Configurations

### DNA/RNA Alignment
```python
aligner = PairwiseAligner(mode='global', match_score=2, mismatch_score=-1, open_gap_score=-10, extend_gap_score=-0.5)
```

### Protein Alignment
```python
from Bio.Align import substitution_matrices
blosum62 = substitution_matrices.load('BLOSUM62')
aligner = PairwiseAligner(mode='global', substitution_matrix=blosum62, open_gap_score=-11, extend_gap_score=-1)
```

### Local Alignment (Find Best Region)
```python
aligner = PairwiseAligner(mode='local', match_score=2, mismatch_score=-1, open_gap_score=-10, extend_gap_score=-0.5)
```

### Semiglobal (Overlap/Extension)
```python
# Allow free end gaps on query (useful for primer alignment)
aligner = PairwiseAligner(mode='global')
aligner.query_left_open_gap_score = 0
aligner.query_left_extend_gap_score = 0
aligner.query_right_open_gap_score = 0
aligner.query_right_extend_gap_score = 0
```

## Available Substitution Matrices

**Goal:** Load and select substitution matrices for protein alignment scoring.

**Approach:** List available matrices with `substitution_matrices.load()` and load specific ones (BLOSUM62 for general, BLOSUM80 for close homologs, PAM250 for distant).

```python
from Bio.Align import substitution_matrices
print(substitution_matrices.load())  # List all available matrices

# Common matrices
blosum62 = substitution_matrices.load('BLOSUM62')  # General protein
blosum80 = substitution_matrices.load('BLOSUM80')  # Closely related proteins
pam250 = substitution_matrices.load('PAM250')      # Distantly related proteins
```

## Working with SeqRecord Objects

**Goal:** Align sequences loaded from FASTA files rather than hardcoded strings.

**Approach:** Parse SeqRecord objects from a FASTA file and pass their `.seq` attributes to the aligner.

```python
from Bio import SeqIO

records = list(SeqIO.parse('sequences.fasta', 'fasta'))
seq1, seq2 = records[0].seq, records[1].seq

aligner = PairwiseAligner(mode='global', match_score=1, mismatch_score=-1)
alignments = aligner.align(seq1, seq2)
```

## Iterating Over Multiple Alignments

```python
# Limit number of alignments returned (memory efficient)
aligner.max_alignments = 100

for i, alignment in enumerate(alignments):
    print(f'Alignment {i+1}: score={alignment.score}')
    if i >= 4:
        break
```

## Substitution Matrix from Alignment

**Goal:** Extract observed substitution frequencies from a completed alignment.

**Approach:** Access the `.substitutions` property to get a matrix of observed base/residue substitution counts.

```python
alignment = alignments[0]
substitutions = alignment.substitutions

# View as array (rows=target, cols=query)
print(substitutions)

# Access specific substitution counts
# substitutions['A', 'T'] gives count of A aligned to T
```

## Export Alignment to Different Formats

**Goal:** Convert an alignment to standard bioinformatics file formats for downstream tools.

**Approach:** Use Python's `format()` function with format specifiers (fasta, clustal, psl, sam) on the alignment object.

```python
alignment = alignments[0]

# Various output formats
print(format(alignment, 'fasta'))     # FASTA format
print(format(alignment, 'clustal'))   # Clustal format
print(format(alignment, 'psl'))       # PSL format (BLAT)
print(format(alignment, 'sam'))       # SAM format
```

## Quick Reference: Scoring Parameters

| Parameter | Description | Typical DNA | Typical Protein |
|-----------|-------------|-------------|-----------------|
| `match_score` | Score for identical bases | 1-2 | Use matrix |
| `mismatch_score` | Penalty for mismatches | -1 to -3 | Use matrix |
| `open_gap_score` | Cost to start a gap | -5 to -15 | -10 to -12 |
| `extend_gap_score` | Cost per gap extension | -0.5 to -2 | -0.5 to -1 |
| `substitution_matrix` | Scoring matrix | N/A | BLOSUM62 |

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `OverflowError` | Too many optimal alignments | Set `aligner.max_alignments` |
| Low scores | Wrong scoring scheme | Use substitution matrix for proteins |
| No alignments in local mode | Scores all negative | Ensure `match_score` > 0 |

## Decision Tree: Choosing Alignment Mode

```
Need full-length comparison?
├── Yes → Use mode='global'
│   └── Sequences similar length?
│       ├── Yes → Standard global
│       └── No → Consider semiglobal (free end gaps)
└── No → Use mode='local'
    └── Find best matching regions only
```

## Related Skills

- alignment-io - Save alignments to files in various formats
- msa-parsing - Work with multiple sequence alignments
- msa-statistics - Calculate identity, similarity metrics
- sequence-manipulation/motif-search - Pattern matching in sequences
