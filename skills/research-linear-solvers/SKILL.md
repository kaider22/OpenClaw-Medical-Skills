---
name: research-linear-solvers
description: 为线性方程组选择求解器并诊断收敛；用于处理矩阵结构、残差序列、右端项和规模。
metadata:
  source_extensions:
    allowed-tools: Read, Bash, Write, Grep, Glob
---

# Linear Solvers

## Codex 调用

- **选择**：请求涉及“为线性方程组选择求解器并诊断收敛”时使用；显式调用 `$research-linear-solvers`。
- **输入**：矩阵结构、残差序列、右端项和规模。
- **预期产物**：求解器建议、预条件器和收敛JSON；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[scripts/residual_norms.py](scripts/residual_norms.py)、[scripts/sparsity_stats.py](scripts/sparsity_stats.py)、[scripts/solver_selector.py](scripts/solver_selector.py)、[scripts/scaling_equilibration.py](scripts/scaling_equilibration.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`numpy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Goal

Provide a universal workflow to select a solver, assess conditioning, and diagnose convergence for linear systems arising in numerical simulations.

## Requirements

- Python 3.8+
- NumPy, SciPy (for matrix operations)
- See individual scripts for dependencies

## Inputs to Gather

| Input | Description | Example |
|-------|-------------|---------|
| Matrix size | Dimension of system | `n = 1000000` |
| Sparsity | Fraction of nonzeros | `0.01%` |
| Symmetry | Is A = Aᵀ? | `yes` |
| Definiteness | Is A positive definite? | `yes (SPD)` |
| Conditioning | Estimated condition number | `10⁶` |

## Decision Guidance

### Solver Selection Flowchart

```
Is matrix small (n < 5000) and dense?
├── YES → Use direct solver (LU, Cholesky)
└── NO → Is matrix symmetric?
    ├── YES → Is it positive definite?
    │   ├── YES → Use CG with AMG/IC preconditioner
    │   └── NO → Use MINRES
    └── NO → Is it nearly symmetric?
        ├── YES → Use BiCGSTAB
        └── NO → Use GMRES with ILU/AMG
```

### Quick Reference

| Matrix Type | Solver | Preconditioner |
|-------------|--------|----------------|
| SPD, sparse | CG | AMG, IC |
| Symmetric indefinite | MINRES | ILU |
| Nonsymmetric | GMRES, BiCGSTAB | ILU, AMG |
| Dense | LU, Cholesky | None |
| Saddle point | Schur complement, Uzawa | Block preconditioner |

## Script Outputs (JSON Fields)

| Script | Key Outputs |
|--------|-------------|
| `scripts/solver_selector.py` | `recommended`, `alternatives`, `notes` |
| `scripts/convergence_diagnostics.py` | `rate`, `stagnation`, `recommended_action` |
| `scripts/sparsity_stats.py` | `nnz`, `density`, `bandwidth`, `symmetry` |
| `scripts/preconditioner_advisor.py` | `suggested`, `notes` |
| `scripts/scaling_equilibration.py` | `row_scale`, `col_scale`, `notes` |
| `scripts/residual_norms.py` | `residual_norms`, `relative_norms`, `converged` |

## Workflow

1. **Characterize matrix** - symmetry, definiteness, sparsity
2. **Analyze sparsity** - Run `scripts/sparsity_stats.py`
3. **Select solver** - Run `scripts/solver_selector.py`
4. **Choose preconditioner** - Run `scripts/preconditioner_advisor.py`
5. **Apply scaling** - If ill-conditioned, use `scripts/scaling_equilibration.py`
6. **Monitor convergence** - Use `scripts/convergence_diagnostics.py`
7. **Diagnose issues** - Check residual history with `scripts/residual_norms.py`

## Conversational Workflow Example

**User**: My GMRES solver is stagnating after 50 iterations. The residual drops to 1e-3 then stops improving.

**Agent workflow**:
1. Diagnose convergence:
   ```bash
   python3 scripts/convergence_diagnostics.py --residuals 1,0.1,0.01,0.005,0.003,0.002,0.002,0.002 --json
   ```
2. Check for preconditioning advice:
   ```bash
   python3 scripts/preconditioner_advisor.py --matrix-type nonsymmetric --sparse --stagnation --json
   ```
3. Recommend: Increase restart parameter, try ILU(k) with higher k, or switch to AMG.

## Pre-Solve Checklist

- [ ] Confirm matrix symmetry/definiteness
- [ ] Decide direct vs iterative based on size and sparsity
- [ ] Set residual tolerance relative to physics scale
- [ ] Choose preconditioner appropriate to matrix structure
- [ ] Apply scaling/equilibration if needed
- [ ] Track convergence and adjust if stagnation occurs

## CLI Examples

```bash
# Analyze sparsity pattern
python3 scripts/sparsity_stats.py --matrix A.npy --json

# Select solver for SPD sparse system
python3 scripts/solver_selector.py --symmetric --positive-definite --sparse --size 1000000 --json

# Get preconditioner recommendation
python3 scripts/preconditioner_advisor.py --matrix-type spd --sparse --json

# Diagnose convergence from residual history
python3 scripts/convergence_diagnostics.py --residuals 1,0.2,0.05,0.01 --json

# Apply scaling
python3 scripts/scaling_equilibration.py --matrix A.npy --symmetric --json

# Compute residual norms
python3 scripts/residual_norms.py --residual 1,0.1,0.01 --rhs 1,0,0 --json
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| `Matrix file not found` | Invalid path | Check file exists |
| `Matrix must be square` | Non-square input | Verify matrix dimensions |
| `Residuals must be positive` | Invalid residual data | Check input format |

## Interpretation Guidance

### Convergence Rate

| Rate | Meaning | Action |
|------|---------|--------|
| < 0.1 | Excellent | Current setup optimal |
| 0.1 - 0.5 | Good | Acceptable for most problems |
| 0.5 - 0.9 | Slow | Consider better preconditioner |
| > 0.9 | Stagnation | Change solver or preconditioner |

### Stagnation Diagnosis

| Pattern | Likely Cause | Fix |
|---------|--------------|-----|
| Flat residual | Poor preconditioner | Improve preconditioner |
| Oscillating | Near-singular or indefinite | Check matrix, try different solver |
| Very slow decay | Ill-conditioned | Apply scaling, use AMG |

## Limitations

- **Large dense matrices**: Direct solvers may run out of memory
- **Highly indefinite**: Standard preconditioners may fail
- **Saddle-point**: Requires specialized block preconditioners

## References

- `references/solver_decision_tree.md` - Selection logic
- `references/preconditioner_catalog.md` - Preconditioner options
- `references/convergence_patterns.md` - Diagnosing failures
- `references/scaling_guidelines.md` - Equilibration guidance

## Version History

- **v1.1.0** (2024-12-24): Enhanced documentation, decision guidance, examples
- **v1.0.0**: Initial release with 6 solver analysis scripts
