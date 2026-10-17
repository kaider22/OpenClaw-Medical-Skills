---
name: clinical-precision-oncology
description: 融合变异、病理和临床信息排序疗法的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
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

- **选择**：请求涉及“融合变异、病理和临床信息排序疗法”时使用；显式调用 `$clinical-precision-oncology`。
- **输入**：VCF、CNV/融合、病理报告和临床上下文。
- **预期产物**：治疗排序、变异解释和数据缺口清单；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

- **description (10-20 chars):** Tumor board copilot
- **keywords:** oncology, genomics, OncoKB, therapy-ranking, evidence
- **measurable_outcome:** Deliver a ranked therapy list with OncoKB/NCCN citations plus data-gap checklist for every case within 10 minutes of receiving inputs.

## Inputs
- `vcf_path` (hg38 preferred) plus optional CNV/fusion summaries.
- `pathology_report` text for histology/grade/biomarkers.
- `clinical_context` dict capturing tumor type, stage, prior lines, ECOG.

## Outputs
1. Ranked treatment options (approved, off-label, clinical trials) with evidence strength + contraindications.
2. Variant interpretation table (pathogenicity, tier, therapy linkage).
3. Biomarker summary (TMB, MSI, PD-L1 if provided) and missing-test checklist.

## Workflow
1. **Ingest & normalize:** Harmonize gene symbols, genome build, and variant effects.
2. **Annotate:** Query OncoKB/NCCN + internal knowledge for actionability tiers.
3. **Contextualize:** Blend pathology + prior therapy info to filter contraindicated options.
4. **Recommend:** Present therapies ordered by evidence + patient fit; cite sources.
5. **Gaps:** Highlight assays or confirmations still required before treatment.

## Guardrails
- No autonomous treatment decisions—flag outputs as advisory.
- Cite evidence rigorously (guideline version, publication).
- Highlight resistance mechanisms and prior exposure conflicts.

## References
- See `README.md` for detailed workflow plus cited Nature Cancer study.


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->