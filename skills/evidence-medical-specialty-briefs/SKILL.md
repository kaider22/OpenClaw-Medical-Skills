---
name: evidence-medical-specialty-briefs
description: 提供按专业和时间窗整理近期医学研究简报的方法与调用指南；用于处理医学专业、时间窗和期刊范围。
---

# Medical Specialty Briefs

## Codex 调用

- **选择**：请求涉及“按专业和时间窗整理近期医学研究简报”时使用；显式调用 `$evidence-medical-specialty-briefs`。
- **输入**：医学专业、时间窗和期刊范围。
- **预期产物**：摘要、来源、链接及临床相关性标签；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Generate curated medical research briefs for any medical specialty in a Google News-style format.

## When to Use This Skill

- User asks for "medical news" or "research updates" for a specific specialty
- User wants a "daily brief" for their medical field
- User mentions journal names (NEJM, JAMA, Lancet, etc.) with research queries
- User is a clinician seeking specialty-specific updates

## Output Format

Each brief item should include:

1. **Headline** - Clear, concise title
2. **One-Sentence Summary** - Key takeaway for clinicians
3. **Source** - Journal name + publication date
4. **Image** - Include if available from source
5. **Link** - Direct URL to original article
6. **Clinical Relevance Badge** - One of:
   - 🔴 High Impact (practice-changing)
   - 🟡 Moderate (consider for practice)
   - 🟢 Low (awareness only)

## Search Strategy

### Priority Journals (in order)
1. New England Journal of Medicine (NEJM)
2. The Lancet
3. JAMA (Journal of the American Medical Association)
4. Specialty-specific top journals
5. BMJ (British Medical Journal)
6. Nature / Nature Medicine
7. Journal of Clinical Endocrinology & Metabolism (JCEM)
8. Endocrine Practice
9. Thyroid
10. Specialty-specific top journals

### Search Parameters
- Time window: Last 7 days (configurable)
- Content: Clinical research, guidelines, AI/ML applications, drug approvals, device approvals
- Exclude: Case reports, preprints (unless high impact), non-peer reviewed

## Workflow

1. **Identify Specialty** - Ask if not specified
2. **Set Time Window** - Default 7 days, ask if different needed
3. **Search** - Query priority journals for specialty + date range
4. **Filter** - Remove duplicates, prioritize clinical relevance
5. **Format** - Generate Google News-style cards
6. **Deliver** - Present to user with specialty header

## Example Queries by Specialty

| Specialty | Example Search |
|-----------|----------------|
| Endocrinology | "Weight loss medication" "thyroid nodule ultrasound" |
| Cardiology | "heart failure SGLT2" "AFib catheter ablation" |
| Oncology | "immunotherapy checkpoint inhibitor" "liquid biopsy" |
| Neurology | "Alzheimer lecanemab" "stroke thrombectomy" |

## Usage
User: "Give me today's cardiology brief"
→ Search cardiology journals from last 7 days
→ Return 3-5 formatted brief items
User: "Weekly neurology update"
→ Search neurology journals from last 7 days
→ Return formatted brief


## Notes

- If no new articles found, state: "No new high-impact articles found for [specialty] in the last [time window]."
- Track delivered articles to avoid repeats in subsequent briefs
- Prioritize articles with clinical utility metrics (sensitivity/specificity, AUC, hazard ratios)