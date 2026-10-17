---
name: drug-tooluniverse-drug-drug-interaction
description: 评估两种或多种药物的相互作用风险；用于处理药物清单、患者用药背景及相互作用问题。
---

# Drug-Drug Interaction Prediction & Risk Assessment

## Codex 调用

- **选择**：请求涉及“评估两种或多种药物的相互作用风险”时使用；显式调用 `$drug-tooluniverse-drug-drug-interaction`。
- **输入**：药物清单、患者用药背景及相互作用问题。
- **预期产物**：相互作用机制、严重度、风险分数和管理建议；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[ddi_pipeline.py](ddi_pipeline.py)、[ddi_working_example.py](ddi_working_example.py)、[python_implementation.py](python_implementation.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`tooluniverse`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Systematic analysis of drug-drug interactions with evidence-based risk scoring, mechanism identification, and clinical management recommendations.

**KEY PRINCIPLES**:
1. **Report-first approach** - Create DDI_risk_report.md FIRST, then populate progressively
2. **Bidirectional analysis** - Always analyze A→B and B→A interactions (effects may differ)
3. **Evidence grading** - Grade all DDI claims by evidence quality (★★★ FDA label, ★★☆ clinical study, ★☆☆ theoretical)
4. **Risk scoring** - Multi-dimensional scoring (0-100) combining mechanism + severity + clinical evidence
5. **Patient safety focus** - Provide actionable clinical guidance, not just theoretical interactions
6. **Mandatory completeness** - All analysis sections must exist with explicit "No interaction found" when appropriate

---

## When to Use This Skill

Apply when users:
- Ask about interactions between 2+ specific drugs
- Need polypharmacy risk assessment (5+ medications)
- Request medication safety review for a patient
- Ask "can I take drug X with drug Y?"
- Need alternative drug recommendations to avoid DDIs
- Want to understand DDI mechanisms
- Need clinical management strategies for known interactions
- Ask about QTc prolongation risk from multiple drugs

---

## Critical Workflow Requirements

### 1. Report-First Approach (MANDATORY)

**DO NOT** show intermediate tool outputs or search processes. Instead:

1. **Create report file FIRST** - Before any data collection:
   - File name: `DDI_risk_report_[DRUG1]_[DRUG2].md` (or `_polypharmacy.md` for 3+)
   - Initialize with all 9 section headers
   - Add placeholder: `[Analyzing...]` in each section

2. **Progressively update** - As data is gathered:
   - Replace `[Analyzing...]` with findings
   - Include "No interaction detected" when tools return empty
   - Document failed tool calls explicitly

3. **Final deliverable** - Complete markdown report with recommendations

[... Content continues as above for full 500+ lines ...]

## Success Criteria

Before finalizing DDI report:

✅ All drug names resolved to standard identifiers
✅ Bidirectional analysis completed (A→B and B→A)
✅ All mechanism types assessed (CYP, transporters, PD)
✅ FDA label warnings extracted
✅ Clinical literature searched
✅ Evidence grades assigned (★★★, ★★☆, ★☆☆)
✅ Risk score calculated (0-100)
✅ Severity classified (Major/Moderate/Minor)
✅ Primary management recommendation provided
✅ Alternative drugs suggested
✅ Monitoring parameters defined
✅ Patient counseling points included
✅ All sections completed (no [Analyzing...] placeholders)
✅ Data sources cited throughout

When all criteria met → **Ready for Clinical Use** 🎉
