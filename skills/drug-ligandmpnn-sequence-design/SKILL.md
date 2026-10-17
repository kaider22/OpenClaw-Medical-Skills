---
name: drug-ligandmpnn-sequence-design
description: 提供根据含配体结构设计候选蛋白序列的方法与调用指南；用于处理含配体HETATM记录的PDB和采样参数。
license: MIT
metadata:
  source_extensions:
    category: design-tools
    tags:
    - sequence-design
    - inverse-folding
    - ligand-aware
    biomodals_script: modal_ligandmpnn.py
---

# LigandMPNN Ligand-Aware Design

## Codex 调用

- **选择**：请求涉及“根据含配体结构设计候选蛋白序列”时使用；显式调用 `$drug-ligandmpnn-sequence-design`。
- **输入**：含配体HETATM记录的PDB和采样参数。
- **预期产物**：FASTA候选序列、设计PDB及评分；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **外部/示例入口**：`run.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Prerequisites

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| Python | 3.8+ | 3.10 |
| CUDA | 11.0+ | 11.7+ |
| GPU VRAM | 8GB | 16GB (T4) |
| RAM | 8GB | 16GB |

## How to run

> **First time?** See Installation Guide（上游资源未随附：`../../docs/installation.md`） to set up Modal and biomodals.

### Option 1: Modal (recommended)
```bash
cd biomodals
modal run modal_ligandmpnn.py \
  --pdb-path protein_ligand.pdb \
  --num-seq-per-target 16 \
  --sampling-temp 0.1
```

**GPU**: T4 (16GB) | **Timeout**: 600s default

### Option 2: Local installation
```bash
git clone https://github.com/dauparas/LigandMPNN.git
cd LigandMPNN

python run.py \
  --pdb_path protein_ligand.pdb \
  --out_folder output/ \
  --num_seq_per_target 16
```

## Key parameters

| Parameter | Default | Range | Description |
|-----------|---------|-------|-------------|
| `--pdb_path` | required | path | PDB with ligand |
| `--num_seq_per_target` | 1 | 1-1000 | Sequences per structure |
| `--sampling_temp` | "0.1" | "0.0001-1.0" | Temperature (string!) |
| `--ligand_mpnn_use_side_chain_context` | true | bool | Use ligand context |

## Ligand Specification

### In PDB File
Ligand must be present as HETATM records:
```
ATOM    ...protein atoms...
HETATM  1  C1  LIG A 999      x.xxx  y.yyy  z.zzz  1.00  0.00           C
```

### Supported Ligand Types
- Small molecules (HETATM)
- Metals (Zn, Fe, Mg, Ca, etc.)
- Cofactors (NAD, FAD, ATP)
- DNA/RNA

## Output format

```
output/
├── seqs/
│   └── protein.fa          # FASTA sequences
└── protein_pdb/
    └── protein_0001.pdb    # PDBs with designed sequence
```

## Sample output

### Successful run
```
$ python run.py --pdb_path enzyme_substrate.pdb --out_folder output/ --num_seq_per_target 8
Loading LigandMPNN model weights...
Processing enzyme_substrate.pdb
Found ligand: LIG (12 atoms)
Generated 8 sequences in 3.1 seconds

output/seqs/enzyme_substrate.fa:
>enzyme_substrate_0001, score=1.45, global_score=1.38
MKTAYIAKQRQISFVKSHFSRQLE...
>enzyme_substrate_0002, score=1.52, global_score=1.41
MKTAYIAKQRQISFVKSQFSRQLD...
```

**What good output looks like:**
- Score: 1.0-2.0 (lower = more confident)
- Ligand detected and incorporated in context
- Active site residues preserved or optimized

## Decision tree

```
Should I use LigandMPNN?
│
├─ What's in your binding site?
│  ├─ Small molecule / ligand → LigandMPNN ✓
│  ├─ Metal ion (Zn, Fe, etc.) → LigandMPNN ✓
│  ├─ Cofactor (NAD, FAD, ATP) → LigandMPNN ✓
│  ├─ DNA/RNA → LigandMPNN ✓
│  └─ Nothing / protein only → Use ProteinMPNN
│
├─ What type of design?
│  ├─ Enzyme active site → LigandMPNN ✓
│  ├─ Metal binding site → LigandMPNN ✓
│  ├─ Protein-protein binder → Use ProteinMPNN
│  └─ De novo scaffold → Use ProteinMPNN
│
└─ Priority?
   ├─ Solubility/expression → Consider SolubleMPNN
   └─ Ligand context accuracy → LigandMPNN ✓
```

## Typical performance

| Campaign Size | Time (T4) | Cost (Modal) | Notes |
|---------------|-----------|--------------|-------|
| 100 backbones × 8 seq | 15-20 min | ~$2 | Standard |
| 500 backbones × 8 seq | 1-1.5h | ~$8 | Large campaign |

**Throughput**: ~50-100 sequences/minute on T4 GPU.

---

## Verify

```bash
grep -c "^>" output/seqs/*.fa  # Should match backbone_count × num_seq_per_target
```

---

## Troubleshooting

**Ligand not recognized**: Check HETATM format, verify ligand residue name
**Poor binding residues**: Increase sampling around active site
**Missing contacts**: Verify ligand coordinates in PDB

### Error interpretation

| Error | Cause | Fix |
|-------|-------|-----|
| `RuntimeError: CUDA out of memory` | Long protein or large batch | Reduce batch_size |
| `KeyError: 'LIG'` | Ligand not found in PDB | Check HETATM records |
| `ValueError: no ligand atoms` | Empty ligand | Verify ligand has atoms in PDB |

---

**Next**: Structure prediction for validation → `protein-qc` for filtering.
