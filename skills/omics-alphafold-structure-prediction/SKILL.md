---
name: omics-alphafold-structure-prediction
description: 提供预测蛋白及复合物结构并提取置信度指标的方法与调用指南；用于处理FASTA序列、模型预设和GPU/数据库环境。
license: MIT
metadata:
  source_extensions:
    category: design-tools
    tags:
    - structure-prediction
    - validation
    - reference
    biomodals_script: modal_alphafold.py
---

# AlphaFold2 Structure Validation

## Codex 调用

- **选择**：请求涉及“预测蛋白及复合物结构并提取置信度指标”时使用；显式调用 `$omics-alphafold-structure-prediction`。
- **输入**：FASTA序列、模型预设和GPU/数据库环境。
- **预期产物**：PDB结构、pLDDT、pTM、ipTM和PAE；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **外部/示例入口**：`run_alphafold.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Prerequisites

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| Python | 3.8+ | 3.10 |
| CUDA | 11.0+ | 12.0+ |
| GPU VRAM | 32GB | 40GB (A100) |
| RAM | 32GB | 64GB |
| Disk | 100GB | 500GB (for databases) |

## How to run

> **First time?** See Installation Guide（上游资源未随附：`../../docs/installation.md`） to set up Modal and biomodals.

### Option 1: ColabFold (recommended for multimer)
```bash
cd biomodals
modal run modal_colabfold.py \
  --input-faa sequences.fasta \
  --out-dir output/
```

**GPU**: A100 (40GB) | **Timeout**: 3600s default

### Option 2: Local installation
```bash
git clone https://github.com/deepmind/alphafold.git
cd alphafold

python run_alphafold.py \
  --fasta_paths=query.fasta \
  --output_dir=output/ \
  --model_preset=monomer \
  --max_template_date=2026-01-01
```

### Option 3: ESMFold (fast single-chain)
```bash
modal run modal_esmfold.py \
  --sequence "MKTAYIAKQRQISFVK..."
```

## Key parameters

| Parameter | Default | Options | Description |
|-----------|---------|---------|-------------|
| `--model_preset` | monomer | monomer/multimer | Model type |
| `--num_recycle` | 3 | 1-20 | Recycling iterations |
| `--max_template_date` | - | YYYY-MM-DD | Template cutoff |
| `--use_templates` | True | True/False | Use template search |

## Output format

```
output/
├── ranked_0.pdb           # Best model
├── ranked_1.pdb           # Second best
├── ranking_debug.json     # Confidence scores
├── result_model_1.pkl     # Full results
├── msas/                  # MSA files
└── features.pkl           # Input features
```

### Extracting metrics
```python
import pickle

with open('result_model_1.pkl', 'rb') as f:
    result = pickle.load(f)

plddt = result['plddt']
ptm = result['ptm']
iptm = result.get('iptm', None)  # Multimer only
pae = result['predicted_aligned_error']
```

## Sample output

### Successful run
```
$ python run_alphafold.py --fasta_paths complex.fasta --model_preset multimer
[INFO] Running MSA search...
[INFO] Running model 1/5...
[INFO] Running model 5/5...
[INFO] Relaxing structures...

Results:
  ranked_0.pdb:
    pLDDT: 87.3 (mean)
    pTM: 0.78
    ipTM: 0.62
    PAE (interface): 8.5

Saved to output/
```

**What good output looks like:**
- pLDDT: > 85 (mean, on 0-100 scale) or > 0.85 (normalized)
- pTM: > 0.70
- ipTM: > 0.50 for complexes
- PAE_interface: < 10

## Decision tree

```
Should I use AlphaFold?
│
├─ What are you predicting?
│  ├─ Single protein → ESMFold (faster)
│  ├─ Protein-protein complex → AlphaFold/ColabFold ✓
│  ├─ Protein + ligand → Chai or Boltz
│  └─ Batch of sequences → ColabFold ✓
│
├─ What do you need?
│  ├─ Highest accuracy → AlphaFold/ColabFold ✓
│  ├─ Fast screening → ESMFold
│  └─ MSA-free prediction → Chai or ESMFold
│
└─ Which AF2 option?
   ├─ Local installation → Full control, slow setup
   ├─ ColabFold → Easier, MSA server
   └─ Modal → Recommended for batch
```

## Typical performance

| Campaign Size | Time (A100) | Cost (Modal) | Notes |
|---------------|-------------|--------------|-------|
| 100 complexes | 1-2h | ~$8 | With MSA server |
| 500 complexes | 5-10h | ~$40 | Standard campaign |
| 1000 complexes | 10-20h | ~$80 | Large campaign |

**Per-complex**: ~30-60s with MSA server.

---

## Verify

```bash
find output -name "ranked_0.pdb" | wc -l  # Should match input count
```

---

## Troubleshooting

**Low pLDDT regions**: May indicate disorder or poor design
**Low ipTM**: Interface not confident, check hotspots
**High PAE off-diagonal**: Chains may not interact
**OOM errors**: Use ColabFold with MSA server instead

### Error interpretation

| Error | Cause | Fix |
|-------|-------|-----|
| `RuntimeError: CUDA out of memory` | Sequence too long | Use A100 or split prediction |
| `KeyError: 'iptm'` | Running monomer on complex | Use multimer preset |
| `FileNotFoundError: database` | Missing MSA databases | Use ColabFold MSA server |
| `TimeoutError` | MSA search slow | Reduce num_recycles |

---

**Next**: `protein-qc` for filtering and ranking.
