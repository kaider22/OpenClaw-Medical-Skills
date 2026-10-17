---
name: evidence-multisource-research
description: 提供分解问题、多源检索并综合医学证据的方法与调用指南；用于处理研究问题、主题范围和所需证据深度。
---

# Deep Research

## Codex 调用

- **选择**：请求涉及“分解问题、多源检索并综合医学证据”时使用；显式调用 `$evidence-multisource-research`。
- **输入**：研究问题、主题范围和所需证据深度。
- **预期产物**：带来源、证据等级和争议的结构化报告；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Autonomous multi-step research that searches multiple sources, reads full content, synthesizes findings, and produces a structured report.

## When to Use

- User wants a thorough understanding of a topic (medical condition, drug, treatment, technology)
- User asks for a literature review or evidence summary
- User wants competitive or landscape analysis
- User wants to investigate an open question with multiple angles
- User asks "what does the research say about X"

## Research Strategy

### Step 1: Query Decomposition
Break the research question into 3–5 sub-questions covering:
- Core definition / mechanism
- Current evidence / state of the art
- Debates, limitations, or contradictions
- Clinical / practical implications (if medical)
- Recent developments (last 1–2 years)

### Step 2: Multi-Source Search
Run searches across complementary sources using the available search tools:

```python
# Use multi-search-engine for broad web coverage
# Use pubmed-search for peer-reviewed medical literature
# Use agent-browser to read full-text articles and retrieve content blocked by snippets
```

**Search order:**
1. PubMed (if medical/biomedical topic) — for peer-reviewed evidence
2. Multi-search-engine (Bing, Google, DuckDuckGo) — for guidelines, reviews, news
3. Wikipedia — for background and structured overviews
4. agent-browser — for reading full articles, PDFs, clinical guidelines

### Step 3: Source Evaluation
For each source note:
- Publication type (RCT, meta-analysis, guideline, review, news)
- Date (prefer sources within 5 years for medical topics)
- Authority (journal impact, organization credibility)
- Relevance to the specific sub-question

### Step 4: Synthesis
Synthesize across sources into a coherent narrative. Do NOT just concatenate summaries — identify:
- Points of consensus
- Contradictions or conflicting evidence
- Knowledge gaps
- Strongest evidence vs. weak/preliminary evidence

### Step 5: Structured Report
Produce a well-formatted Markdown report with:

```markdown
# [Topic] — Deep Research Report

## Summary
2–3 sentence executive summary of the key finding.

## Background
What is this? Core definitions, mechanisms, or context.

## Current Evidence
What does the research show? Organized by sub-question or theme.

## Key Debates / Open Questions
Where do experts disagree? What is still unknown?

## Clinical / Practical Implications
(For medical topics) What should clinicians or patients know?

## Recent Developments
Anything notable from the past 12–24 months.

## Sources
Numbered list of all sources with titles, URLs/DOIs, and dates.
```

## Medical Research Guidelines

When researching medical topics:
- **Prioritize evidence hierarchy**: Systematic reviews > RCTs > Cohort studies > Case reports > Expert opinion
- **Include safety information**: Drug interactions, contraindications, adverse effects
- **Note population specifics**: Pediatric vs. adult, special populations, comorbidities
- **Flag regulatory status**: FDA/EMA approval status, off-label use
- **Cite clinical guidelines**: NICE, AHA, ACC, IDSA, WHO guidelines where relevant
- **Distinguish mechanistic from clinical evidence**: Lab/animal data ≠ human evidence

## Depth Levels

Adapt depth to user request:
- **Quick overview** (user asks briefly): 3–5 sources, 1-page summary
- **Standard research** (default): 8–15 sources, full structured report
- **Comprehensive review** (user asks explicitly): 20+ sources, deep synthesis with evidence grading

## Example Execution

**User:** "Research the evidence for metformin use in longevity/anti-aging"

1. Decompose: mechanism of action → RCT evidence → observational data → safety profile → current trials
2. Search PubMed for "metformin longevity aging", "TAME trial metformin"
3. Search web for "metformin anti-aging clinical trials 2024"
4. Read key papers with agent-browser
5. Synthesize: strong mechanistic evidence, TAME trial ongoing, limited long-term human RCT data
6. Produce structured report with citations
