---
name: omics-chai-complex-prediction
description: 提供预测蛋白、核酸和配体复合物并提取置信度的方法与调用指南；用于处理多实体FASTA、SMILES、GPU和预测参数。
license: MIT
metadata:
  source_extensions:
    category: design-tools
    tags:
    - structure-prediction
    - validation
    - foundation-model
    biomodals_script: modal_chai1.py
---

# Chai-1 Structure Prediction

## Codex 调用

- **选择**：请求涉及“预测蛋白、核酸和配体复合物并提取置信度”时使用；显式调用 `$omics-chai-complex-prediction`。
- **输入**：多实体FASTA、SMILES、GPU和预测参数。
- **预期产物**：CIF模型、scores、PAE和pLDDT数组；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`Bio`、`chai_lab`、`numpy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Prerequisites

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| Python | 3.10+ | 3.11 |
| CUDA | 12.0+ | 12.1+ |
| GPU VRAM | 24GB | 40GB (A100) |
| RAM | 32GB | 64GB |

## How to run

> **First time?** See Installation Guide（上游资源未随附：`../../docs/installation.md`） to set up Modal and biomodals.

### Option 1: Modal
```bash
cd biomodals
modal run modal_chai1.py \
  --input-faa complex.fasta \
  --out-dir predictions/
```

**GPU**: A100 (40GB) | **Timeout**: 30min default

### Option 2: Chai API (recommended)
```bash
pip install chai_lab

python -c "
import chai_lab
from chai_lab.chai1 import run_inference

# Run prediction
run_inference(
    fasta_file='complex.fasta',
    output_dir='predictions/',
    num_trunk_recycles=3
)
"
```

### Option 3: Local installation
```bash
git clone https://github.com/chaidiscovery/chai-lab.git
cd chai-lab
pip install -e .

chai-lab predict \
  --fasta complex.fasta \
  --output predictions/
```

## FASTA Format

### Protein complex
```
>binder
MKTAYIAKQRQISFVKSHFSRQLE...
>target
MVLSPADKTNVKAAWGKVGAHAGE...
```

### Protein + ligand
```
>protein
MKTAYIAKQRQISFVKSHFSRQLE...
>ligand|smiles
CCO
```

### Protein + DNA/RNA
```
>protein
MKTAYIAKQRQISFVKSHFSRQLE...
>dna
ATCGATCGATCG
```

## Key parameters

| Parameter | Default | Range | Description |
|-----------|---------|-------|-------------|
| `num_trunk_recycles` | 3 | 1-10 | Recycles (more = better) |
| `num_diffn_timesteps` | 200 | 50-500 | Diffusion steps |
| `seed` | 0 | int | Random seed |

## Output format

```
predictions/
├── pred.model_idx_0.cif    # Best model (CIF format)
├── pred.model_idx_1.cif    # Second model
├── scores.json             # Confidence scores
├── pae.npy                 # PAE matrix
└── plddt.npy               # pLDDT values
```

**Note**: Chai-1 outputs CIF format. Convert to PDB if needed:
```python
from Bio.PDB import MMCIFParser, PDBIO
parser = MMCIFParser()
structure = parser.get_structure("pred", "pred.model_idx_0.cif")
io = PDBIO()
io.set_structure(structure)
io.save("pred.model_idx_0.pdb")
```

### Extracting metrics
```python
import numpy as np
import json

# Load scores
with open('predictions/scores.json') as f:
    scores = json.load(f)

plddt = np.load('predictions/plddt.npy')
pae = np.load('predictions/pae.npy')

print(f"pLDDT: {plddt.mean():.3f}")
print(f"pTM: {scores['ptm']:.3f}")
print(f"ipTM: {scores.get('iptm', 'N/A')}")
```

## Use cases

### Binder validation
```python
# Predict complex with Chai
chai-lab predict --fasta binder_target.fasta --output val/

# Check ipTM > 0.5
scores = json.load(open('val/scores.json'))
if scores['iptm'] > 0.5:
    print("Design passes validation")
```

### Protein-ligand complex
```python
# FASTA with SMILES
fasta = """
>protein
MKTA...
>ligand|smiles
CCO
"""

# Chai handles both protein and small molecules
```

### Batch prediction
```bash
# Multiple sequences
for fasta in sequences/*.fasta; do
    chai-lab predict \
        --fasta "$fasta" \
        --output "predictions/$(basename $fasta .fasta)"
done
```

## Comparison with AF2

| Aspect | Chai-1 | AlphaFold2 |
|--------|--------|------------|
| MSA required | No | Yes |
| Small molecules | Yes | No |
| DNA/RNA | Yes | Limited |
| Speed | Faster | Slower |
| Accuracy | Comparable | Reference |

## Sample output

### Successful run
```
$ chai-lab predict --fasta complex.fasta --output predictions/
[INFO] Loading Chai-1 model...
[INFO] Running inference...
[INFO] Saved 5 models to predictions/

predictions/scores.json:
{
  "ptm": 0.82,
  "iptm": 0.71,
  "ranking_score": 0.76
}
```

**What good output looks like:**
- pTM: > 0.7 (confident global structure)
- ipTM: > 0.5 (confident interface, > 0.7 for high confidence)
- CIF files with reasonable atom positions

## Decision tree

```
Should I use Chai?
│
├─ What are you predicting?
│  ├─ Protein-protein complex → Chai ✓ or ColabFold
│  ├─ Protein + small molecule → Chai ✓
│  ├─ Protein + DNA/RNA → Chai ✓
│  └─ Single protein only → Use ESMFold (faster)
│
├─ Need MSA?
│  ├─ No / want speed → Chai ✓
│  └─ Yes / want accuracy → ColabFold
│
└─ Priority?
   ├─ Highest accuracy → ColabFold with MSA
   ├─ Speed / no MSA → Chai ✓
   └─ Ligand binding → Chai ✓
```

## Typical performance

| Campaign Size | Time (A100) | Cost (Modal) | Notes |
|---------------|-------------|--------------|-------|
| 100 complexes | 30-60 min | ~$10 | Standard validation |
| 500 complexes | 2-4h | ~$45 | Large campaign |
| 1000 complexes | 5-8h | ~$90 | Comprehensive |

**Per-complex**: ~20-40s for typical binder-target complex.

---

## Verify

```bash
find predictions -name "*.cif" | wc -l  # Should match input count
```

---

## Troubleshooting

**Low pLDDT**: Increase num_trunk_recycles
**Low ipTM**: Check chain order, interface region
**OOM errors**: Use A100-80GB or reduce batch
**Slow prediction**: Reduce num_diffn_timesteps

### Error interpretation

| Error | Cause | Fix |
|-------|-------|-----|
| `RuntimeError: CUDA out of memory` | Complex too large | Use A100-80GB or split prediction |
| `KeyError: 'iptm'` | Single chain predicted | Ensure FASTA has multiple chains |
| `ValueError: invalid SMILES` | Malformed ligand | Validate SMILES with RDKit |
| `torch.cuda.OutOfMemoryError` | GPU exhausted | Reduce num_diffn_timesteps to 100 |

---

**Next**: `protein-qc` for filtering and ranking.
