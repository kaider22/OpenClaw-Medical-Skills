---
name: research-adaptyv-protein-testing
description: 提交蛋白序列并追踪自动化验证实验；用于处理蛋白序列、实验类型和API凭据。
license: Unknown
metadata:
  skill-author: K-Dense Inc.
---

# Adaptyv

## Codex 调用

- **选择**：请求涉及“提交蛋白序列并追踪自动化验证实验”时使用；显式调用 `$research-adaptyv-protein-testing`。
- **输入**：蛋白序列、实验类型和API凭据。
- **预期产物**：结合、表达、热稳定性或酶活结果；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：使用正文明确的 API/服务协议，通过当前可用的 HTTP、终端或已配置连接器执行。先确认端点、凭据和访问范围；不假定存在专用 MCP 工具。
- **环境核对**：`dotenv`、`requests`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **服务条件**：正文涉及 `ADAPTYV_API_KEY`；只读取任务已配置的值，不输出或提交凭据。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Adaptyv is a cloud laboratory platform that provides automated protein testing and validation services. Submit protein sequences via API or web interface and receive experimental results in approximately 21 days.

## Quick Start

### Authentication Setup

Adaptyv requires API authentication. Set up your credentials:

1. Contact support@adaptyvbio.com to request API access (platform is in alpha/beta)
2. Receive your API access token
3. Set environment variable:

```bash
export ADAPTYV_API_KEY="your_api_key_here"
```

Or create a `.env` file:

```
ADAPTYV_API_KEY=your_api_key_here
```

### Installation

Install the required package using uv:

```bash
uv pip install requests python-dotenv
```

### Basic Usage

Submit protein sequences for testing:

```python
import os
import requests
from dotenv import load_dotenv

load_dotenv()

api_key = os.getenv("ADAPTYV_API_KEY")
base_url = "https://kq5jp7qj7wdqklhsxmovkzn4l40obksv.lambda-url.eu-central-1.on.aws"

headers = {
    "Authorization": f"Bearer {api_key}",
    "Content-Type": "application/json"
}

# Submit experiment
response = requests.post(
    f"{base_url}/experiments",
    headers=headers,
    json={
        "sequences": ">protein1\nMKVLWALLGLLGAA...",
        "experiment_type": "binding",
        "webhook_url": "https://your-webhook.com/callback"
    }
)

experiment_id = response.json()["experiment_id"]
```

## Available Experiment Types
Adaptyv supports multiple assay types:
- **Binding assays** - Test protein-target interactions using biolayer interferometry
- **Expression testing** - Measure protein expression levels
- **Thermostability** - Characterize protein thermal stability
- **Enzyme activity** - Assess enzymatic function

See `reference/experiments.md` for detailed information on each experiment type and workflows.

## Protein Sequence Optimization
Before submitting sequences, optimize them for better expression and stability:

**Common issues to address:**
- Unpaired cysteines that create unwanted disulfides
- Excessive hydrophobic regions causing aggregation
- Poor solubility predictions

**Recommended tools:**
- NetSolP / SoluProt - Initial solubility filtering
- SolubleMPNN - Sequence redesign for improved solubility
- ESM - Sequence likelihood scoring
- ipTM - Interface stability assessment
- pSAE - Hydrophobic exposure quantification

See `reference/protein_optimization.md` for detailed optimization workflows and tool usage.

## API Reference
For complete API documentation including all endpoints, request/response formats, and authentication details, see `reference/api_reference.md`.

## Examples
For concrete code examples covering common use cases (experiment submission, status tracking, result retrieval, batch processing), see `reference/examples.md`.

## Important Notes
- Platform is currently in alpha/beta phase with features subject to change
- Not all platform features are available via API yet
- Results typically delivered in ~21 days
- Contact support@adaptyvbio.com for access requests or questions
- Suitable for high-throughput AI-driven protein design workflows

