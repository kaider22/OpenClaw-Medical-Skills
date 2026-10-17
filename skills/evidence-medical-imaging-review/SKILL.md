---
name: evidence-medical-imaging-review
description: 提供撰写医学影像AI的系统综述和方法比较的方法与调用指南；用于处理影像主题、检索标准、论文和数据库连接。
metadata:
  author: user
  version: 2.0.0
  source_extensions:
    allowed-tools:
    - Read
    - Write
    - Edit
    - Glob
    - Grep
    - Bash
    - WebSearch
    - WebFetch
    - Task
    - mcp__arxiv-mcp-server__search_papers
    - mcp__arxiv-mcp-server__download_paper
    - mcp__arxiv-mcp-server__read_paper
    - mcp__pubmed-mcp-server__pubmed_search_articles
    - mcp__zotero__zotero_search_items
    - mcp__zotero__zotero_get_item_fulltext
---

# Medical Imaging AI Literature Review Skill

## Codex 调用

- **选择**：请求涉及“撰写医学影像AI的系统综述和方法比较”时使用；显式调用 `$evidence-medical-imaging-review`。
- **输入**：影像主题、检索标准、论文和数据库连接。
- **预期产物**：分阶段综述稿、比较表、引用和质量清单；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **按需阅读**：[references/WORKFLOW.md](references/WORKFLOW.md)、[references/DOMAINS.md](references/DOMAINS.md)；仅加载本次分支需要的说明。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Write comprehensive literature reviews following a systematic 7-phase workflow.

## Quick Start

1. **Initialize project** with three core files:
   - `CLAUDE.md` - Writing guidelines and terminology
   - `IMPLEMENTATION_PLAN.md` - Staged execution plan
   - `manuscript_draft.md` - Main manuscript

2. **Follow the 7-phase workflow** (see [references/WORKFLOW.md](references/WORKFLOW.md))

3. **Use domain-specific templates** (see [references/DOMAINS.md](references/DOMAINS.md))

---

## Core Principles

### Writing Style
- **Hedging language**: "may", "suggests", "appears to", "has shown promising results"
- **Avoid absolutes**: Never say "X is the best method"
- **Citation support**: Every claim needs reference
- **Limitations**: Each method section needs a Limitations paragraph

### Required Elements
- **Key Points box** (3-5 bullets) after title
- **Comparison table** for each major section
- **Performance metrics**: Dice (0.XXX), HD95 (X.XX mm)
- **Figure placeholders** with detailed captions
- **References**: 80-120 typical, organized by topic

### Paragraph Structure
```
Topic sentence (main claim)
  → Supporting evidence (citations + data)
  → Analysis (critical evaluation)
  → Transition to next paragraph
```

---

## Literature Sources

Use multi-source strategy for comprehensive coverage:

| Source | Best For | Tools |
|--------|----------|-------|
| ArXiv | Latest DL methods, preprints | `search_papers`, `read_paper` |
| PubMed | Clinical validation, peer-reviewed | `pubmed_search_articles` |
| Zotero | Existing library, organized refs | `zotero_search_items` |

For MCP configuration details, see [references/MCP_SETUP.md](references/MCP_SETUP.md).

---

## Standard Review Structure

```markdown
# [Title]: State of the Art and Future Directions

## Key Points
- [3-5 bullets summarizing main findings]

## Abstract

## 1. Introduction
### 1.1 Clinical Background
### 1.2 Technical Challenges
### 1.3 Scope and Contributions

## 2. Datasets and Evaluation Metrics
### 2.1 Public Datasets (Table 1)
### 2.2 Evaluation Metrics

## 3. Deep Learning Methods
### 3.1 [Category 1]
### 3.2 [Category 2]
(Table 2: Method Comparison)

## 4. Downstream Applications

## 5. Commercial Products & Clinical Translation (Table 3)

## 6. Discussion
### 6.1 Current Limitations
### 6.2 Future Directions

## 7. Conclusion

## References
```

---

## Method Description Template

```markdown
### 3.X [Method Category]

[1-2 paragraph introduction with motivation]

**[Method Name]:** [Author] et al. [ref] proposed [method], which [innovation]:
- [Key component 1]
- [Key component 2]
Achieves Dice of X.XX on [dataset].

**Limitations:** Despite advantages, [category] methods face:
(1) [limit 1]; (2) [limit 2].
```

---

## Citation Patterns

```markdown
# Data citation
"...achieved Dice of 0.89 [23]"

# Method citation
"Gu et al. [45] proposed..."

# Multi-citation
"Several studies demonstrated... [12, 15, 23]"

# Comparative
"While [12] focused on..., [15] addressed..."
```

---

## Reference Files

| File | Purpose |
|------|---------|
| [references/WORKFLOW.md](references/WORKFLOW.md) | Detailed 7-phase workflow |
| [references/TEMPLATES.md](references/TEMPLATES.md) | CLAUDE.md and IMPLEMENTATION_PLAN.md templates |
| [references/DOMAINS.md](references/DOMAINS.md) | Domain-specific method categories |
| [references/MCP_SETUP.md](references/MCP_SETUP.md) | MCP server configuration |
| [references/QUALITY_CHECKLIST.md](references/QUALITY_CHECKLIST.md) | Pre-submission quality checklist |
