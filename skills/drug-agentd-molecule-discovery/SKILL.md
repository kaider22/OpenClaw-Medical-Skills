---
name: drug-agentd-molecule-discovery
description: 从靶点证据生成并排序候选药物分子的本地原型指南；代码含模拟或替代分支，真实计算与服务结果需分别核验。
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

- **选择**：请求涉及“从靶点证据生成并排序候选药物分子”时使用；显式调用 `$drug-agentd-molecule-discovery`。
- **输入**：靶蛋白、参考分子、约束和候选数量。
- **预期产物**：SMILES、性质评分、ADMET警示和排序；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[agent_d.py](agent_d.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **原型边界**：随附代码含模拟、mock 或替代分支。运行时明确记录实际走到的分支；模拟结果不能标作真实查询、模型预测或实验验证。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

- **description (10-20 chars):** Hypothesis foundry
- **keywords:** ligand-design, SAR, ADMET, docking, ranking
- **measurable_outcome:** Generate ≥10 candidate molecules (or requested count) with SMILES, key properties, and rationales per run, all delivered within 15 minutes.

## Inputs
- `target_protein`, optional `reference_compound`, disease `indication`.
- `constraints` dict (LogP, MW, TPSA, etc.) and `num_candidates`.

## Outputs
1. Ranked candidate list with SMILES + property scores + novelty metrics.
2. ADMET/toxicity alerts and SAR rationale per molecule.
3. Reproducibility manifest (data source versions, model checkpoints).

## Workflow
1. **Evidence retrieval:** Mine literature + databases for known ligands and liabilities.
2. **Generate candidates:** Run AgentD generative step (scaffold hopping/fragment growth) aligned to constraints.
3. **Score & filter:** Apply Lipinski/QED/ADMET heuristics; include docking setup when requested.
4. **Rank & explain:** Combine efficacy, developability, novelty; summarize SAR learnings.
5. **Deliver outputs:** Emit JSON/CSV plus narrative recommendations; mark as in silico.

## Guardrails
- Clearly state outputs are hypothetical and need wet-lab validation.
- Flag PAINS/reactive motifs automatically.
- Record data/model versions for audit trails.

## References
- Detailed parameter tables and dependencies listed in `README.md`.


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->