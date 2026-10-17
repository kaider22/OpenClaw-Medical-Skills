---
name: evidence-arxiv-search
description: 提供语义检索arXiv预印本并返回全文与图像的方法与调用指南；用于处理自然语言查询、结果数和Valyu API密钥。
license: MIT
metadata:
  source_extensions:
    keywords:
    - arxiv
    - preprints
    - physics
    - mathematics
    - computer-science
    - ai-research
    - semantic-search
---


# arXiv Search

## Codex 调用

- **选择**：请求涉及“语义检索arXiv预印本并返回全文与图像”时使用；显式调用 `$evidence-arxiv-search`。
- **输入**：自然语言查询、结果数和Valyu API密钥。
- **预期产物**：论文标题、全文、URL、相关度和图片；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`valyu`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Search the complete arXiv database of preprints across physics, mathematics, computer science, and quantitative biology using natural language queries powered by Valyu's semantic search API.

## Why This Skill is Powerful

- **No API Parameter Parsing**: Just pass natural language queries directly - no need to construct complex search parameters
- **Semantic Search**: Understands the meaning of your query, not just keyword matching
- **Full-Text Access**: Returns complete article content, not just abstracts
- **Image Links**: Includes figures and images from papers
- **Comprehensive Coverage**: Access to all of arXiv's preprint archive across multiple disciplines

## Requirements

1. Node.js 18+ (uses built-in fetch)
2. Valyu API key from https://platform.valyu.ai ($10 free credits)

## CRITICAL: Script Path Resolution

The `scripts/search` commands in this documentation are relative to this skill's installation directory.

Before running any command, locate the script using:

```bash
ARXIV_SCRIPT=$(find ~/.claude/plugins/cache -name "search" -path "*/arxiv-search/*/scripts/*" -type f 2>/dev/null | head -1)
```

Then use the full path for all commands:
```bash
$ARXIV_SCRIPT "quantum entanglement" 15
```

## API Key Setup Flow

When you run a search and receive `"setup_required": true`, follow this flow:

1. **Ask the user for their API key:**
   "To search arXiv, I need your Valyu API key. Get one free ($10 credits) at https://platform.valyu.ai"

2. **Once the user provides the key, run:**
   ```bash
   scripts/search setup <api-key>
   ```

3. **Retry the original search.**

### Example Flow:
```
User: Search arXiv for transformer architecture papers
→ Response: {"success": false, "setup_required": true, ...}
→ Claude asks: "Please provide your Valyu API key from https://platform.valyu.ai"
→ User: "val_abc123..."
→ Claude runs: scripts/search setup val_abc123...
→ Response: {"success": true, "type": "setup", ...}
→ Claude retries: scripts/search "transformer architecture papers" 10
→ Success!
```

## When to Use This Skill

- Searching preprints across physics, mathematics, and computer science
- Finding research before peer review publication
- Cross-disciplinary research combining fields
- Staying current with rapid developments in AI and theoretical physics
- Prior art searching for new ideas
- Tracking emerging research trends
## Output Format

```json
{
  "success": true,
  "type": "arxiv_search",
  "query": "quantum entanglement",
  "result_count": 10,
  "results": [
    {
      "title": "Article Title",
      "url": "https://arxiv.org/abs/...",
      "content": "Full article text with figures...",
      "source": "arxiv",
      "relevance_score": 0.95,
      "images": ["https://example.com/figure1.jpg"]
    }
  ],
  "cost": 0.025
}
```

## Processing Results

### With jq

```bash
# Get article titles
scripts/search "query" 10 | jq -r '.results[].title'

# Get URLs
scripts/search "query" 10 | jq -r '.results[].url'

# Extract full content
scripts/search "query" 10 | jq -r '.results[].content'
```

## Common Use Cases

### AI/ML Research

```bash
# Find recent machine learning papers
scripts/search "large language model architectures" 50
```

### Physics Research

```bash
# Search for quantum physics papers
scripts/search "topological quantum computation" 20
```

### Mathematics

```bash
# Find math papers
scripts/search "representation theory and Lie algebras" 15
```

### Computer Science

```bash
# Search for CS theory papers
scripts/search "distributed systems consensus algorithms" 25
```


## Error Handling

All commands return JSON with `success` field:

```json
{
  "success": false,
  "error": "Error message"
}
```

Exit codes:
- `0` - Success
- `1` - Error (check JSON for details)

## API Endpoint

- Base URL: `https://api.valyu.ai/v1`
- Endpoint: `/search`
- Authentication: X-API-Key header

## Architecture

```
scripts/
├── search          # Bash wrapper
└── search.mjs      # Node.js CLI
```

Direct API calls using Node.js built-in `fetch()`, zero external dependencies.

## Adding to Your Project

If you're building an AI project and want to integrate arXiv Search directly into your application, use the Valyu SDK:

### Python Integration

```python
from valyu import Valyu

client = Valyu(api_key="your-api-key")

response = client.search(
    query="your search query here",
    included_sources=["valyu/valyu-arxiv"],
    max_results=20
)

for result in response["results"]:
    print(f"Title: {result['title']}")
    print(f"URL: {result['url']}")
    print(f"Content: {result['content'][:500]}...")
```

### TypeScript Integration

```typescript
import { Valyu } from "valyu-js";

const client = new Valyu("your-api-key");

const response = await client.search({
  query: "your search query here",
  includedSources: ["valyu/valyu-arxiv"],
  maxResults: 20
});

response.results.forEach((result) => {
  console.log(`Title: ${result.title}`);
  console.log(`URL: ${result.url}`);
  console.log(`Content: ${result.content.substring(0, 500)}...`);
});
```

See the [Valyu docs](https://docs.valyu.ai) for full integration examples and SDK reference.
