---
name: omics-genome-assembly-assembly-qc
description: 提供用QUAST和BUSCO评估组装连续性与完整性的方法与调用指南；用于处理组装FASTA、可选参考基因组和BUSCO谱系。
metadata:
  source_extensions:
    tool_type: cli
    primary_tool: QUAST
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


# Assembly QC

## Codex 调用

- **选择**：请求涉及“用QUAST和BUSCO评估组装连续性与完整性”时使用；显式调用 `$omics-genome-assembly-assembly-qc`。
- **输入**：组装FASTA、可选参考基因组和BUSCO谱系。
- **预期产物**：N50/错配报告、BUSCO汇总和比较表；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`QUAST`、`pandas`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **外部/示例入口**：`metaquast.py`、`quast.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Evaluate genome assembly quality with contiguity metrics (QUAST) and gene completeness (BUSCO).

## Key Metrics

| Metric | Good Assembly |
|--------|---------------|
| N50 | High (relative to genome) |
| L50 | Low |
| Contigs | Few |
| Misassemblies | 0 (with reference) |
| BUSCO Complete | >95% |
| BUSCO Duplicated | <5% (unless polyploid) |

## QUAST

### Installation

```bash
conda install -c bioconda quast
```

### Basic Usage

```bash
quast.py assembly.fasta -o quast_output
```

### With Reference Genome

```bash
quast.py assembly.fasta -r reference.fasta -o quast_output
```

### Compare Multiple Assemblies

```bash
quast.py assembly1.fa assembly2.fa assembly3.fa -o comparison
```

### Key Options

| Option | Description |
|--------|-------------|
| `-o` | Output directory |
| `-r` | Reference genome |
| `-g` | Gene annotations (GFF) |
| `-t` | Threads |
| `-m` | Min contig length (default: 500) |
| `--large` | For large genomes (>100Mb) |
| `--fragmented` | For highly fragmented assemblies |
| `--scaffolds` | Input is scaffolds (includes N-gaps) |

### With Gene Annotations

```bash
quast.py assembly.fasta -r reference.fasta -g genes.gff -o quast_output
```

### For Large Genomes

```bash
quast.py --large assembly.fasta -o quast_output -t 16
```

### Output Files

```
quast_output/
├── report.txt        # Summary statistics
├── report.html       # Interactive report
├── report.tsv        # Tab-separated stats
├── icarus.html       # Contig viewer
└── aligned_stats/    # If reference provided
```

### Key Output Metrics

| Metric | Description |
|--------|-------------|
| Total length | Sum of contig lengths |
| # contigs | Number of contigs (>= min length) |
| Largest contig | Length of largest contig |
| N50 | 50% of assembly in contigs >= this length |
| N90 | 90% of assembly in contigs >= this length |
| L50 | Number of contigs comprising N50 |
| GC % | GC content |
| # misassemblies | With reference: structural errors |
| Genome fraction | With reference: % of reference covered |

## BUSCO

### Installation

```bash
conda install -c bioconda busco
```

### Basic Usage

```bash
busco -i assembly.fasta -m genome -l bacteria_odb10 -o busco_output
```

### Key Options

| Option | Description |
|--------|-------------|
| `-i` | Input assembly |
| `-m` | Mode: genome, proteins, transcriptome |
| `-l` | Lineage dataset |
| `-o` | Output name |
| `-c` | CPU threads |
| `--auto-lineage` | Auto-detect lineage |
| `--offline` | Use downloaded datasets only |
| `--list-datasets` | List available lineages |

### List Available Lineages

```bash
busco --list-datasets
```

### Common Lineages

| Lineage | Use For |
|---------|---------|
| bacteria_odb10 | Bacteria |
| archaea_odb10 | Archaea |
| eukaryota_odb10 | General eukaryote |
| fungi_odb10 | Fungi |
| metazoa_odb10 | Animals |
| vertebrata_odb10 | Vertebrates |
| mammalia_odb10 | Mammals |
| viridiplantae_odb10 | Plants |
| saccharomycetes_odb10 | Yeasts |

### Auto-Lineage Detection

```bash
busco -i assembly.fasta -m genome --auto-lineage -o busco_output
```

### Output Files

```
busco_output/
├── short_summary.txt           # Quick summary
├── full_table.tsv              # All BUSCO results
├── missing_busco_list.tsv      # Missing genes
└── busco_sequences/            # BUSCO gene sequences
```

### Interpret Results

```
C:98.5%[S:97.0%,D:1.5%],F:0.5%,M:1.0%,n:4085

C - Complete (total)
S - Single-copy
D - Duplicated
F - Fragmented
M - Missing
n - Total BUSCO groups
```

### Quality Thresholds

| Quality | Complete | Missing |
|---------|----------|---------|
| Excellent | >95% | <2% |
| Good | >90% | <5% |
| Acceptable | >80% | <10% |
| Poor | <80% | >10% |

## Complete QC Workflow

```bash
#!/bin/bash
set -euo pipefail

ASSEMBLY=$1
REFERENCE=${2:-}
LINEAGE=${3:-bacteria_odb10}
OUTDIR=${4:-assembly_qc}

mkdir -p $OUTDIR

echo "=== Assembly QC ==="

# QUAST
echo "Running QUAST..."
if [ -n "$REFERENCE" ]; then
    quast.py $ASSEMBLY -r $REFERENCE -o ${OUTDIR}/quast -t 8
else
    quast.py $ASSEMBLY -o ${OUTDIR}/quast -t 8
fi

# BUSCO
echo "Running BUSCO..."
busco -i $ASSEMBLY -m genome -l $LINEAGE -o busco_run -c 8
mv busco_run ${OUTDIR}/busco

# Summary
echo ""
echo "=== QUAST Summary ==="
cat ${OUTDIR}/quast/report.txt

echo ""
echo "=== BUSCO Summary ==="
cat ${OUTDIR}/busco/short_summary*.txt

echo ""
echo "Reports saved to $OUTDIR"
```

## Compare Assemblies

### QUAST Comparison

```bash
quast.py \
    spades_assembly.fa \
    flye_assembly.fa \
    canu_assembly.fa \
    -r reference.fa \
    -l "SPAdes,Flye,Canu" \
    -o assembly_comparison
```

### BUSCO Comparison

```bash
# Run BUSCO on each assembly
for asm in spades.fa flye.fa canu.fa; do
    name=$(basename $asm .fa)
    busco -i $asm -m genome -l bacteria_odb10 -o busco_${name}
done

# Generate comparison plot
generate_plot.py -wd . busco_spades busco_flye busco_canu
```

## Python: Parse QUAST Output

```python
import pandas as pd

def parse_quast(report_tsv):
    '''Parse QUAST report.tsv file.'''
    df = pd.read_csv(report_tsv, sep='\t', index_col=0)
    return df.T

stats = parse_quast('quast_output/report.tsv')
print(f"N50: {stats['N50'].values[0]}")
print(f"Total length: {stats['Total length'].values[0]}")
print(f"# contigs: {stats['# contigs'].values[0]}")
```

## Python: Parse BUSCO Output

```python
import re

def parse_busco_summary(summary_file):
    '''Parse BUSCO short summary.'''
    with open(summary_file) as f:
        text = f.read()

    pattern = r'C:(\d+\.\d+)%\[S:(\d+\.\d+)%,D:(\d+\.\d+)%\],F:(\d+\.\d+)%,M:(\d+\.\d+)%,n:(\d+)'
    match = re.search(pattern, text)

    if match:
        return {
            'complete': float(match.group(1)),
            'single': float(match.group(2)),
            'duplicated': float(match.group(3)),
            'fragmented': float(match.group(4)),
            'missing': float(match.group(5)),
            'total': int(match.group(6))
        }
    return None

result = parse_busco_summary('busco_output/short_summary.txt')
print(f"Complete: {result['complete']}%")
```

## MetaQUAST (Metagenomes)

```bash
metaquast.py metagenome_assembly.fa -o metaquast_output -t 16
```

## Troubleshooting

### Low N50
- Check coverage depth
- Consider longer reads
- Try different assembler

### Low BUSCO Completeness
- Check input read quality
- Verify correct lineage dataset
- May indicate real gene loss (compare to relatives)

### High Duplication in BUSCO
- Normal for polyploids
- May indicate contamination
- Check for collapsed haplotypes

## Related Skills

- short-read-assembly - SPAdes assembly
- long-read-assembly - Flye/Canu assembly
- assembly-polishing - Improve accuracy
- metagenomics - Metagenome analysis


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->