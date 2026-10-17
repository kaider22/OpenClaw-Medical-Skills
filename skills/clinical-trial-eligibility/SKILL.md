---
name: clinical-trial-eligibility
description: 提供把试验入排标准拆成逐条可追溯筛选结论的方法与调用指南；用于处理试验编号/方案、患者摘要或FHIR及数据来源。
metadata:
  source_extensions:
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


## At-a-Glance

## Codex 调用

- **选择**：请求涉及“把试验入排标准拆成逐条可追溯筛选结论”时使用；显式调用 `$clinical-trial-eligibility`。
- **输入**：试验编号/方案、患者摘要或FHIR及数据来源。
- **预期产物**：MET/NOT/UNKNOWN矩阵、总建议和数据缺口；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

- **description (10-20 chars):** Trial triage hub
- **keywords:** eligibility, ClinicalTrials, FHIR, evidence, gaps
- **measurable_outcome:** Produce a MET/NOT/UNKNOWN matrix with supporting citations for ≥90% of inclusion/exclusion criteria within 5 minutes per trial request.

## Inputs
- `trial_id` (NCT or sponsor ID) plus protocol text if not public.
- `patient_summary` narrative and optional `patient_structured` FHIR bundle.
- Declare data sources used (notes, labs, imaging, meds) to show provenance.

## Outputs
1. Structured table (JSON recommended) listing each criterion id/text with status, evidence snippet, and confidence.
2. Overall recommendation (`potentially_eligible`, `not_eligible`, `needs_more_information`).
3. Data gap checklist covering missing labs/imaging/biomarkers.

## Workflow
1. **Acquire protocol:** Pull eligibility text from ClinicalTrials.gov or sponsor PDF.
2. **Normalize criteria:** Break into atomic checks with AND/OR logic and thresholds.
3. **Extract patient facts:** Map narrative + FHIR data into canonical features (age, labs, ECOG, biomarkers).
4. **Evaluate:** Assign MET/NOT/UNKNOWN with cited evidence for each criterion, flag missing context explicitly.
5. **Summarize:** Present recommendation and highlight gating unknowns plus next-best actions.

## Guardrails
- Never claim enrollment decisions; mark outputs as advisory.
- Cite direct patient evidence for every MET/NOT call; default to UNKNOWN rather than guessing.
- Respect PHI handling expectations—avoid storing raw notes outside secure paths.

## Tooling & References
- Use `README.md` for API snippets (FHIR parsing, JSON schema) and dependency versions.
- Pair with `Clinical/Trial_Matching/TrialGPT` when retrieval/ranking is also needed.


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->