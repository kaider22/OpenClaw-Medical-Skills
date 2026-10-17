---
name: omics-ctdna-mutation-detection
description: 提供从低VAF cfDNA中调用并追踪体细胞突变的方法与调用指南；用于处理UMI共识BAM、参考、靶区及已知突变列表。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: VarDict
---

## Version Compatibility

Reference examples tested with: Ensembl VEP 111+, SnpEff 5.2+, VarDict 1.8+, pandas 2.2+, pysam 0.22+

Before using code patterns, verify installed versions match. If versions differ:
- Python: `pip show <package>` then `help(module.function)` to check signatures
- CLI: `<tool> --version` then `<tool> --help` to confirm flags

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# ctDNA Mutation Detection

## Codex 调用

- **选择**：请求涉及“从低VAF cfDNA中调用并追踪体细胞突变”时使用；显式调用 `$omics-ctdna-mutation-detection`。
- **输入**：UMI共识BAM、参考、靶区及已知突变列表。
- **预期产物**：低VAF VCF、VEP注释、CHIP过滤和VAF表；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`VarDict`、`pandas`、`pysam`、`vcfpy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Detect mutations in my cfDNA sample"** → Identify somatic variants at low allele fractions (0.1-1%) from cell-free DNA using error-suppressed consensus calling and specialized callers.
- CLI: `vardict-java` for low-VAF variant calling from cfDNA

Detect somatic mutations in cfDNA at low variant allele fractions.

## Input Requirements

| Requirement | Specification |
|-------------|---------------|
| Data type | Targeted panel or WES (NOT sWGS) |
| Depth | >= 1000x for low VAF detection |
| UMIs | Highly recommended for < 1% VAF |
| Input | Preprocessed BAM (UMI consensus if available) |

## VAF Detection Limits

| VAF Range | Reliability | Notes |
|-----------|-------------|-------|
| > 1% | Reliable | Standard callers work |
| 0.5-1% | Good with UMIs | Requires error suppression |
| 0.1-0.5% | Challenging | Needs deep UMI consensus |
| < 0.1% | Unreliable | Near noise floor |

## VarDict for High Sensitivity (Ensembl VEP 111+)

```bash
# VarDict is highly sensitive for low VAF
# Use on UMI-consensus BAM for best results

vardict-java \
    -G reference.fa \
    -f 0.005 \      # Min VAF 0.5%
    -N sample_id \
    -b sample.bam \
    -c 1 -S 2 -E 3 -g 4 \
    regions.bed | \
teststrandbias.R | \
var2vcf_valid.pl \
    -N sample_id \
    -E \
    -f 0.005 \
    > sample.vcf
```

## Python Implementation

```python
import subprocess
import pandas as pd
import pysam


def call_variants_vardict(bam_file, reference, bed_file, output_vcf, min_vaf=0.005, min_depth=100):
    '''
    Call variants with VarDict.

    Args:
        bam_file: UMI-consensus BAM preferred
        reference: Reference FASTA
        bed_file: Target regions BED
        output_vcf: Output VCF path
        min_vaf: Minimum VAF (0.005 = 0.5%)
        min_depth: Minimum read depth
    '''
    sample_id = bam_file.split('/')[-1].replace('.bam', '')

    cmd = f'''
    vardict-java \
        -G {reference} \
        -f {min_vaf} \
        -N {sample_id} \
        -b {bam_file} \
        -c 1 -S 2 -E 3 -g 4 \
        {bed_file} | \
    teststrandbias.R | \
    var2vcf_valid.pl \
        -N {sample_id} \
        -E \
        -f {min_vaf} \
        > {output_vcf}
    '''

    subprocess.run(cmd, shell=True, check=True)
    return output_vcf


def filter_ctdna_variants(vcf_file, chip_genes=None):
    '''
    Filter ctDNA variants, removing CHIP.

    CHIP genes commonly mutated in elderly:
    DNMT3A, TET2, ASXL1, PPM1D, TP53, SF3B1, etc.
    '''
    if chip_genes is None:
        chip_genes = ['DNMT3A', 'TET2', 'ASXL1', 'PPM1D', 'JAK2',
                      'SF3B1', 'SRSF2', 'TP53', 'CBL', 'BCOR']

    import vcfpy
    reader = vcfpy.Reader.from_path(vcf_file)

    somatic = []
    chip = []

    for record in reader:
        gene = record.INFO.get('GENE', [''])[0]

        if gene in chip_genes:
            chip.append(record)
        else:
            somatic.append(record)

    print(f'Somatic variants: {len(somatic)}')
    print(f'Potential CHIP variants: {len(chip)}')

    return somatic, chip
```

## UMI-VarCal for Best Specificity (Ensembl VEP 111+)

```python
def call_with_umi_varcal(bam_file, reference, bed_file, output_vcf, min_vaf=0.005):
    '''
    UMI-VarCal: Best specificity with UMI data.
    '''
    subprocess.run([
        'umi-varcal',
        '--bam', bam_file,
        '--ref', reference,
        '--bed', bed_file,
        '--out', output_vcf,
        '--min-vaf', str(min_vaf),
        '--min-alt-reads', '3',
        '--min-depth', '100'
    ], check=True)
```

## Variant Annotation (Ensembl VEP 111+)

```python
def annotate_ctdna_variants(vcf_file, output_vcf):
    '''Annotate variants with clinically relevant information.'''
    # Use VEP or snpEff for annotation
    subprocess.run([
        'vep',
        '--input_file', vcf_file,
        '--output_file', output_vcf,
        '--format', 'vcf',
        '--vcf',
        '--cache',
        '--canonical',
        '--protein',
        '--sift', 'b',
        '--polyphen', 'b',
        '--af_gnomad'
    ], check=True)
```

## Tracking Known Mutations

**Goal:** Quantify the variant allele fraction of specific known mutations across serial liquid biopsy samples for minimal residual disease monitoring.

**Approach:** For each target mutation, pileup reads at the variant position, count reference and alternative alleles, and compute VAF with depth statistics.

```python
def track_specific_mutations(bam_file, mutations, min_depth=100):
    '''
    Track specific known mutations across samples.
    Useful for MRD monitoring.

    Args:
        bam_file: Aligned BAM
        mutations: List of (chrom, pos, ref, alt) tuples
    '''
    import pysam

    bam = pysam.AlignmentFile(bam_file, 'rb')
    results = []

    for chrom, pos, ref, alt in mutations:
        counts = {'ref': 0, 'alt': 0, 'other': 0}

        for pileupcolumn in bam.pileup(chrom, pos-1, pos):
            if pileupcolumn.pos != pos - 1:
                continue

            for read in pileupcolumn.pileups:
                if read.is_del or read.is_refskip:
                    continue
                base = read.alignment.query_sequence[read.query_position]
                if base == ref:
                    counts['ref'] += 1
                elif base == alt:
                    counts['alt'] += 1
                else:
                    counts['other'] += 1

        total = counts['ref'] + counts['alt'] + counts['other']
        vaf = counts['alt'] / total if total > 0 else 0

        results.append({
            'chrom': chrom, 'pos': pos, 'ref': ref, 'alt': alt,
            'depth': total, 'alt_count': counts['alt'], 'vaf': vaf
        })

    bam.close()
    return pd.DataFrame(results)
```

## Related Skills

- cfdna-preprocessing - Preprocess with UMI consensus
- tumor-fraction-estimation - Estimate overall tumor burden
- longitudinal-monitoring - Track mutations over time
- variant-calling/variant-calling - General variant calling concepts
