---
name: research-ginkgo-experiment-submission
description: 提交云实验做无细胞蛋白表达验证或优化；用于处理≤1800bp FASTA、优化参数、样本数及账户。
---

# Ginkgo Cloud Lab

## Codex 调用

- **选择**：请求涉及“提交云实验做无细胞蛋白表达验证或优化”时使用；显式调用 `$research-ginkgo-experiment-submission`。
- **输入**：≤1800bp FASTA、优化参数、样本数及账户。
- **预期产物**：表达确认、滴度、纯度、凝胶图或报价；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：使用正文明确的 API/服务协议，通过当前可用的 HTTP、终端或已配置连接器执行。先确认端点、凭据和访问范围；不假定存在专用 MCP 工具。
- **按需阅读**：[references/cell-free-protein-expression-validation.md](references/cell-free-protein-expression-validation.md)、[references/cell-free-protein-expression-optimization.md](references/cell-free-protein-expression-optimization.md)；仅加载本次分支需要的说明。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Overview

Ginkgo Cloud Lab (https://cloud.ginkgo.bio) provides remote access to Ginkgo Bioworks' autonomous lab infrastructure. Protocols are executed on Reconfigurable Automation Carts (RACs) -- modular units with robotic arms, maglev sample transport, and industrial-grade software spanning 70+ instruments.

The platform also includes **EstiMate**, an AI agent that accepts human-language protocol descriptions and returns feasibility assessments and pricing for custom workflows beyond the listed protocols.

## Available Protocols

### 1. Cell Free Protein Expression Validation

Rapid go/no-go expression screening using reconstituted E. coli CFPS. Submit a FASTA sequence (up to 1800 bp) and receive expression confirmation, baseline titer (mg/L), and initial purity with virtual gel images.

- **Price:** $39/sample | **Turnaround:** 5-10 days | **Status:** Certified
- **Details:** See [references/cell-free-protein-expression-validation.md](references/cell-free-protein-expression-validation.md)

### 2. Cell Free Protein Expression Optimization

DoE-based optimization across up to 24 conditions per protein (lysates, temperatures, chaperones, disulfide enhancers, cofactors). Designed for difficult-to-express and membrane proteins.

- **Price:** $199/sample | **Turnaround:** 6-11 days | **Status:** Certified
- **Details:** See [references/cell-free-protein-expression-optimization.md](references/cell-free-protein-expression-optimization.md)

### 3. Fluorescent Pixel Art Generation

Transform a pixel art image (48x48 to 96x96 px, PNG/SVG) into fluorescent bacterial artwork using up to 11 E. coli strains via acoustic dispensing. Delivered as high-res UV photographs.

- **Price:** $25/plate | **Turnaround:** 5-7 days | **Status:** Beta
- **Details:** See [references/fluorescent-pixel-art-generation.md](references/fluorescent-pixel-art-generation.md)

## General Ordering Workflow

1. Select a protocol at https://cloud.ginkgo.bio/protocols
2. Configure parameters (number of samples/proteins, replicates, plates)
3. Upload input files (FASTA for protein protocols, PNG/SVG for pixel art)
4. Add any special requirements in the Additional Details field
5. Submit and receive a feasibility report and price quote

For protocols not listed above, use the **EstiMate** chat to describe a custom protocol in plain language and receive compatibility assessment and pricing.

## Authentication

Access Ginkgo Cloud Lab at https://cloud.ginkgo.bio. Account creation or institutional access may be required. Contact Ginkgo at cloud@ginkgo.bio for access questions.

## Key Infrastructure

- **RACs (Reconfigurable Automation Carts):** Modular robotic units with high-precision arms and maglev transport
- **Catalyst Software:** Protocol orchestration, scheduling, parameterization, and real-time monitoring
- **70+ integrated instruments:** Sample prep, liquid handling, analytical readouts, storage, incubation
- **Nebula:** Ginkgo's autonomous lab facility in Boston, MA
