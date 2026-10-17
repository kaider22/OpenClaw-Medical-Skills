---
name: omics-clinical-databases-clinvar-lookup
description: 查询ClinVar变异临床意义和疾病关联；用于处理Variation ID、HGVS或本地ClinVar VCF。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: requests
---

## Version Compatibility

Reference examples tested with: Entrez Direct 21.0+, bcftools 1.19+

Before using code patterns, verify installed versions match. If versions differ:
- Python: `pip show <package>` then `help(module.function)` to check signatures
- CLI: `<tool> --version` then `<tool> --help` to confirm flags

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# ClinVar Lookup

## Codex 调用

- **选择**：请求涉及“查询ClinVar变异临床意义和疾病关联”时使用；显式调用 `$omics-clinical-databases-clinvar-lookup`。
- **输入**：Variation ID、HGVS或本地ClinVar VCF。
- **预期产物**：致病性、审查状态、疾病名和批量注释VCF；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：使用正文明确的 API/服务协议，通过当前可用的 HTTP、终端或已配置连接器执行。先确认端点、凭据和访问范围；不假定存在专用 MCP 工具。
- **环境核对**：`cyvcf2`、`requests`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## REST API Queries

**Goal:** Retrieve ClinVar pathogenicity classifications and disease associations for variants via REST API.

**Approach:** Query NCBI E-utilities endpoints with variant IDs, gene symbols, or HGVS notation and parse JSON responses.

**"Look up this variant in ClinVar"** → Query ClinVar database for clinical significance, review status, and disease associations.
- Python: `requests.get()` against NCBI E-utilities (requests)
- CLI: `esearch`/`efetch` (Entrez Direct)

### Query by Variant ID

```python
import requests

def query_clinvar_by_id(variation_id):
    '''Query ClinVar by variation ID'''
    url = f'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi'
    params = {
        'db': 'clinvar',
        'id': variation_id,
        'retmode': 'json'
    }
    response = requests.get(url, params=params)
    return response.json()

result = query_clinvar_by_id('16609')
```

### Search by Gene

```python
def search_clinvar_gene(gene_symbol, pathogenic_only=False):
    '''Search ClinVar for variants in a gene'''
    url = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi'

    term = f'{gene_symbol}[gene]'
    if pathogenic_only:
        term += ' AND pathogenic[clinical_significance]'

    params = {
        'db': 'clinvar',
        'term': term,
        'retmax': 500,
        'retmode': 'json'
    }
    response = requests.get(url, params=params)
    return response.json()
```

### Search by HGVS

```python
def search_clinvar_hgvs(hgvs):
    '''Search ClinVar by HGVS notation'''
    url = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi'
    params = {
        'db': 'clinvar',
        'term': f'{hgvs}[variant name]',
        'retmode': 'json'
    }
    response = requests.get(url, params=params)
    return response.json()
```

## Local ClinVar VCF

**Goal:** Query variants against a local ClinVar VCF for fast, offline pathogenicity lookups.

**Approach:** Download the ClinVar VCF from NCBI FTP, then query by genomic coordinates using cyvcf2 or bcftools.

### Download ClinVar VCF

```bash
# GRCh38
wget https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/clinvar.vcf.gz
wget https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/clinvar.vcf.gz.tbi

# GRCh37
wget https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh37/clinvar.vcf.gz
```

### Query Local ClinVar with cyvcf2

```python
from cyvcf2 import VCF

clinvar = VCF('clinvar.vcf.gz')

def lookup_variant(chrom, pos, ref, alt):
    '''Look up variant in local ClinVar VCF'''
    region = f'{chrom}:{pos}-{pos}'
    for variant in clinvar(region):
        if variant.REF == ref and alt in variant.ALT:
            return {
                'clnsig': variant.INFO.get('CLNSIG'),
                'clnrevstat': variant.INFO.get('CLNREVSTAT'),
                'clndn': variant.INFO.get('CLNDN'),
                'clnvc': variant.INFO.get('CLNVC')
            }
    return None

result = lookup_variant('7', 140453136, 'A', 'T')
```

## Clinical Significance Categories

| Value | Interpretation |
|-------|----------------|
| Pathogenic | Disease-causing |
| Likely_pathogenic | Probably disease-causing |
| Uncertain_significance | VUS - unknown |
| Likely_benign | Probably not disease-causing |
| Benign | Not disease-causing |
| Conflicting_interpretations | Multiple labs disagree |

## Review Status Stars

| Stars | Review Status |
|-------|---------------|
| 4 | Practice guideline |
| 3 | Expert panel reviewed |
| 2 | Multiple submitters, criteria provided |
| 1 | Single submitter, criteria provided |
| 0 | No assertion criteria |

## Parse ClinVar INFO Fields

**Goal:** Classify variants into actionable pathogenicity categories from raw ClinVar CLNSIG values.

**Approach:** Map ClinVar significance terms to simplified categories (pathogenic, benign, conflicting, VUS).

```python
def parse_clinvar_significance(clnsig):
    '''Parse ClinVar CLNSIG field'''
    pathogenic_terms = ['Pathogenic', 'Likely_pathogenic']
    benign_terms = ['Benign', 'Likely_benign']

    if any(term in clnsig for term in pathogenic_terms):
        return 'pathogenic'
    elif any(term in clnsig for term in benign_terms):
        return 'benign'
    elif 'Conflicting' in clnsig:
        return 'conflicting'
    else:
        return 'vus'
```

## Batch Annotation with bcftools

**Goal:** Annotate an entire VCF with ClinVar significance, review status, and disease names in one pass.

**Approach:** Use bcftools annotate to transfer ClinVar INFO fields from the ClinVar VCF to the input VCF.

```bash
# Annotate VCF with ClinVar
bcftools annotate \
    -a clinvar.vcf.gz \
    -c INFO/CLNSIG,INFO/CLNREVSTAT,INFO/CLNDN \
    input.vcf.gz \
    -o annotated.vcf.gz
```

## Related Skills

- myvariant-queries - Aggregated queries including ClinVar
- variant-prioritization - Filter by ClinVar significance
- variant-calling/clinical-interpretation - ACMG guidelines
