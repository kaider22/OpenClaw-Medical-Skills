---
name: omics-clinical-databases-somatic-signatures
description: 提供从体细胞VCF提取并拟合癌症突变特征的方法与调用指南；用于处理体细胞VCF目录、参考基因组和COSMIC库。
metadata:
  source_extensions:
    tool_type: mixed
    primary_tool: SigProfilerExtractor
---

## Version Compatibility

Reference examples tested with: MutationalPatterns 3.12+, SigProfilerExtractor 1.1+, numpy 1.26+

Before using code patterns, verify installed versions match. If versions differ:
- Python: `pip show <package>` then `help(module.function)` to check signatures
- R: `packageVersion('<pkg>')` then `?function_name` to verify parameters

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Somatic Mutational Signatures

## Codex 调用

- **选择**：请求涉及“从体细胞VCF提取并拟合癌症突变特征”时使用；显式调用 `$omics-clinical-databases-somatic-signatures`。
- **输入**：体细胞VCF目录、参考基因组和COSMIC库。
- **预期产物**：SBS/DBS/ID矩阵、de novo及COSMIC贡献；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`SigProfilerAssignment`、`SigProfilerExtractor`、`SigProfilerMatrixGenerator`、`numpy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Extract mutational signatures from my tumor samples"** → Decompose somatic mutation catalogs into mutational signatures (SBS, DBS, ID) to identify DNA damage mechanisms and mutagenic processes in cancer genomes.
- Python: `SigProfilerExtractor.sigpro()` for de novo signature extraction
- R: `MutationalPatterns::fit_to_signatures()` for fitting to COSMIC signatures

## SigProfiler Workflow

**Goal:** Extract de novo mutational signatures and decompose to COSMIC reference signatures from somatic VCFs.

**Approach:** Generate a 96-trinucleotide-context mutation matrix with SigProfilerMatrixGenerator, extract signatures via NMF with SigProfilerExtractor, and fit to COSMIC with SigProfilerAssignment.

### Install and Generate Matrix

```python
from SigProfilerMatrixGenerator import install as genInstall
from SigProfilerMatrixGenerator.scripts import SigProfilerMatrixGeneratorFunc as matGen

# Install reference genome (one-time)
genInstall.install('GRCh38')

# Generate mutational matrix from VCF
# Input: Directory containing VCF files
# Output: SBS96 matrix (96 trinucleotide contexts)
matrices = matGen.SigProfilerMatrixGeneratorFunc(
    project='my_project',
    genome='GRCh38',
    vcfFiles='/path/to/vcf_directory',
    plot=True,
    exome=False  # Set True for WES
)
```

### Extract Signatures

```python
from SigProfilerExtractor import sigpro as sig

# De novo signature extraction
# Determines optimal number of signatures automatically
sig.sigProfilerExtractor(
    input_type='matrix',
    output='extraction_output',
    input_data='my_project/output/SBS/my_project.SBS96.all',
    reference_genome='GRCh38',
    minimum_signatures=1,
    maximum_signatures=10,
    nmf_replicates=100,
    cpu=-1  # Use all cores
)
```

### Decompose to COSMIC Signatures

```python
from SigProfilerAssignment import Analyzer as Analyze

# Fit to known COSMIC signatures
Analyze.cosmic_fit(
    samples='my_project/output/SBS/my_project.SBS96.all',
    output='assignment_output',
    input_type='matrix',
    genome_build='GRCh38',
    signature_database='SBS_GRCh38_GRCh38'
)
```

## MutationalPatterns (R)

**Goal:** Analyze mutational spectra and fit to COSMIC signatures using the MutationalPatterns R package.

**Approach:** Load VCFs as GRanges, generate a 96-context mutation matrix against the reference genome, then fit to known COSMIC signatures or extract de novo via NMF.

### Load and Analyze

```r
library(MutationalPatterns)
library(BSgenome.Hsapiens.UCSC.hg38)

# Load VCF files
vcf_files <- list.files('vcf_dir', pattern = '\\.vcf$', full.names = TRUE)
sample_names <- gsub('.vcf', '', basename(vcf_files))

vcfs <- read_vcfs_as_granges(
    vcf_files,
    sample_names,
    ref_genome = 'BSgenome.Hsapiens.UCSC.hg38'
)

# Generate 96-context mutation matrix
mut_mat <- mut_matrix(vcf_list = vcfs, ref_genome = 'BSgenome.Hsapiens.UCSC.hg38')

# Visualize spectrum
plot_96_profile(mut_mat)
```

### Fit to COSMIC Signatures

```r
# Load COSMIC signatures (v3.2)
cosmic_sigs <- get_known_signatures(muttype = 'snv')

# Fit samples to signatures
fit_result <- fit_to_signatures(mut_mat, cosmic_sigs)

# Plot contribution
plot_contribution(fit_result$contribution, cosmic_sigs, mode = 'absolute')

# Relative contribution
plot_contribution(fit_result$contribution, cosmic_sigs, mode = 'relative')
```

### De Novo Extraction

```r
# Extract de novo signatures using NMF
# Determine optimal rank
estimate <- estimate_rank(mut_mat, rank_range = 2:8, nrun = 50)
plot(estimate)

# Extract signatures
nmf_res <- extract_signatures(mut_mat, rank = 4, nrun = 100)

# Compare to COSMIC
cos_sim <- cos_sim_matrix(nmf_res$signatures, cosmic_sigs)
plot_cosine_heatmap(cos_sim)
```

## COSMIC Signature Etiology

**Goal:** Interpret extracted signatures by mapping them to known mutagenic processes (e.g., UV, smoking, MMR deficiency).

**Approach:** Look up each dominant signature in a COSMIC etiology reference table and filter by contribution threshold.

```python
# Common COSMIC signatures and their etiologies
SIGNATURE_ETIOLOGY = {
    'SBS1': 'Spontaneous deamination (age-related)',
    'SBS2': 'APOBEC activity',
    'SBS3': 'Defective HR/BRCA1/2',
    'SBS4': 'Tobacco smoking',
    'SBS5': 'Unknown (age-related)',
    'SBS6': 'MMR deficiency',
    'SBS7a': 'UV exposure',
    'SBS7b': 'UV exposure',
    'SBS10a': 'POLE mutation',
    'SBS10b': 'POLE mutation',
    'SBS13': 'APOBEC activity',
    'SBS15': 'MMR deficiency',
    'SBS17a': 'Unknown',
    'SBS17b': 'Unknown',
    'SBS18': 'ROS damage',
    'SBS22': 'Aristolochic acid',
    'SBS26': 'MMR deficiency',
    'SBS44': 'MMR deficiency',
}

def interpret_signatures(contributions):
    '''Interpret signature contributions'''
    interpretations = []
    for sig, contrib in contributions.items():
        if contrib > 0.05:  # >5% contribution threshold
            etiology = SIGNATURE_ETIOLOGY.get(sig, 'Unknown')
            interpretations.append({
                'signature': sig,
                'contribution': contrib,
                'etiology': etiology
            })
    return sorted(interpretations, key=lambda x: x['contribution'], reverse=True)
```

## Signature Categories

| Category | Signatures | Mechanism |
|----------|------------|-----------|
| Age-related | SBS1, SBS5 | Spontaneous deamination, clock-like |
| APOBEC | SBS2, SBS13 | Cytidine deaminase activity |
| MMR deficiency | SBS6, SBS15, SBS26, SBS44 | Mismatch repair defects |
| HR deficiency | SBS3 | BRCA1/2, homologous recombination |
| POLE mutation | SBS10a, SBS10b | Proofreading defects |
| UV damage | SBS7a, SBS7b | Pyrimidine dimers |
| Smoking | SBS4 | Tobacco carcinogens |
| Platinum therapy | SBS31, SBS35 | Treatment-related |

## Cosine Similarity

**Goal:** Quantify how closely an extracted signature matches a COSMIC reference signature.

**Approach:** Compute cosine similarity between the two 96-dimensional signature vectors.

```python
import numpy as np

def cosine_similarity(sig1, sig2):
    '''Calculate cosine similarity between two signatures'''
    dot_product = np.dot(sig1, sig2)
    norm1 = np.linalg.norm(sig1)
    norm2 = np.linalg.norm(sig2)
    return dot_product / (norm1 * norm2)

# Threshold: >0.8 considered similar
# >0.9 considered same signature
```

## Clinical Applications

**Goal:** Translate dominant mutational signatures into actionable clinical recommendations (e.g., PARP inhibitor eligibility).

**Approach:** Map signature identities to therapy implications and recommended confirmatory tests.

```python
def signature_clinical_implications(dominant_signatures):
    '''Clinical implications of mutational signatures'''
    implications = []

    for sig in dominant_signatures:
        if sig == 'SBS3':
            implications.append({
                'signature': 'SBS3',
                'implication': 'HR deficiency - may respond to PARP inhibitors',
                'testing': 'Consider BRCA1/2 testing'
            })
        elif sig in ['SBS6', 'SBS15', 'SBS26', 'SBS44']:
            implications.append({
                'signature': sig,
                'implication': 'MMR deficiency - may respond to immunotherapy',
                'testing': 'Consider MSI testing'
            })
        elif sig in ['SBS2', 'SBS13']:
            implications.append({
                'signature': sig,
                'implication': 'APOBEC activity - associated with high TMB',
                'testing': 'Consider TMB assessment'
            })

    return implications
```

## Related Skills

- clinical-databases/tumor-mutational-burden - TMB calculation
- variant-calling/somatic-variant-calling - Input variants
- data-visualization/heatmaps-clustering - Signature visualization
