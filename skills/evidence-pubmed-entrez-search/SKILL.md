---
name: evidence-pubmed-entrez-search
description: 使用 Biopython Entrez 检索与整理 PubMed 文献。用于已有 Python/Entrez 工作流中的查询与抓取。
---

# PubMed Search

## Codex 调用

- **选择**：请求涉及“用Entrez检索、抓取并整理PubMed文献”时使用；显式调用 `$evidence-pubmed-entrez-search`。
- **输入**：PubMed检索式、返回数量和排序条件。
- **预期产物**：PMID、题名、作者、期刊、摘要和链接；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`Bio`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Search NCBI PubMed for scientific literature using BioPython's Entrez module.

## When to Use

- User asks to find papers on a topic
- User wants recent publications in a field
- User asks for references or citations
- User wants to know the state of research on a topic

## How to Execute

### 1. Set up Entrez

```python
from Bio import Entrez
Entrez.email = "medclaw@freedomai.com"
```

### 2. Search PubMed

```python
# Search
handle = Entrez.esearch(db="pubmed", term="CRISPR delivery methods", retmax=20, sort="date")
record = Entrez.read(handle)
handle.close()

id_list = record["IdList"]
print(f"Found {record['Count']} results, showing top {len(id_list)}")
```

### 3. Fetch article details

```python
# Fetch details
handle = Entrez.efetch(db="pubmed", id=id_list, rettype="xml")
records = Entrez.read(handle)
handle.close()

for article in records['PubmedArticle']:
    medline = article['MedlineCitation']
    pmid = str(medline['PMID'])
    title = medline['Article']['ArticleTitle']
    
    # Get authors
    authors = medline['Article'].get('AuthorList', [])
    first_author = f"{authors[0].get('LastName', '')} {authors[0].get('Initials', '')}" if authors else "Unknown"
    
    # Get journal and year
    journal = medline['Article']['Journal']['Title']
    pub_date = medline['Article']['Journal']['JournalIssue'].get('PubDate', {})
    year = pub_date.get('Year', 'N/A')
    
    # Get abstract
    abstract_parts = medline['Article'].get('Abstract', {}).get('AbstractText', [])
    abstract = ' '.join(str(a) for a in abstract_parts)[:300]
    
    print(f"PMID: {pmid}")
    print(f"Title: {title}")
    print(f"Authors: {first_author} et al.")
    print(f"Journal: {journal} ({year})")
    print(f"Abstract: {abstract}...")
    print(f"Link: https://pubmed.ncbi.nlm.nih.gov/{pmid}/")
    print()
```

### 4. Output format for WhatsApp

```
*PubMed Search: "CRISPR delivery methods"*
_Found 1,234 results. Top 5:_

*1.* Lipid nanoparticle-mediated CRISPR delivery...
   _Smith J et al. — Nature (2026)_
   PMID: 12345678
   pubmed.ncbi.nlm.nih.gov/12345678

*2.* AAV-based CRISPR therapeutics: advances and challenges
   _Chen L et al. — Cell (2026)_
   PMID: 12345679
   pubmed.ncbi.nlm.nih.gov/12345679
```

### 5. Advanced searches

Support these query patterns:
- `"CRISPR"[Title] AND "delivery"[Title]` — title-specific
- `"2026"[Date - Publication]` — date filter
- `"Nature"[Journal]` — journal filter
- `review[Publication Type]` — type filter

### 6. Follow-up suggestions

After showing results, suggest:
- "Want me to summarize any of these papers?"
- "Should I search with different keywords?"
- "Want me to find related papers to any of these?"
