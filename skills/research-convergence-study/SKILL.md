---
name: research-convergence-study
description: 验证网格或时间步收敛并估计离散误差；用于处理至少3级细化尺度及对应的定量结果。
metadata:
  source_extensions:
    allowed-tools:
    - Bash
    - Read
---

# Convergence Study

## Codex 调用

- **选择**：请求涉及“验证网格或时间步收敛并估计离散误差”时使用；显式调用 `$research-convergence-study`。
- **输入**：至少3级细化尺度及对应的定量结果。
- **预期产物**：收敛阶、Richardson外推、GCI和JSON评估；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[scripts/h_refinement.py](scripts/h_refinement.py)、[scripts/dt_refinement.py](scripts/dt_refinement.py)、[scripts/gci_calculator.py](scripts/gci_calculator.py)、[scripts/richardson_extrapolation.py](scripts/richardson_extrapolation.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Goal

Provide script-driven convergence analysis for verifying that numerical solutions converge at the expected rate as the mesh or timestep is refined.

## Requirements

- Python 3.8+
- NumPy (not required; scripts use only math stdlib)

## Inputs to Gather

| Input | Description | Example |
|-------|-------------|---------|
| Grid spacings | Sequence of mesh sizes (coarse to fine) | `0.4,0.2,0.1,0.05` |
| Timestep sizes | Sequence of dt values | `0.04,0.02,0.01` |
| Solution values | QoI at each refinement level | `1.16,1.04,1.01,1.0025` |
| Expected order | Formal order of the numerical scheme | `2.0` |
| Safety factor | GCI safety factor (1.25 default) | `1.25` |

## Script Outputs (JSON Fields)

| Script | Key Outputs |
|--------|-------------|
| `scripts/h_refinement.py` | `results.observed_orders`, `results.mean_order`, `results.richardson_extrapolated_value`, `results.convergence_assessment` |
| `scripts/dt_refinement.py` | Same as h_refinement but for temporal convergence |
| `scripts/richardson_extrapolation.py` | `results.extrapolated_value`, `results.error_estimate`, `results.observed_order` |
| `scripts/gci_calculator.py` | `results.observed_order`, `results.gci_fine`, `results.gci_coarse`, `results.asymptotic_ratio`, `results.in_asymptotic_range` |

## Workflow

1. **Run grid/timestep refinement study** with at least 3 levels
2. **Compute observed convergence order** with `h_refinement.py` or `dt_refinement.py`
3. **Compare** observed order to expected order of the scheme
4. **Estimate discretization error** via Richardson extrapolation
5. **Report GCI** for formal solution verification using `gci_calculator.py`
6. **Document** convergence results and any anomalies

## Decision Guidance

```
Do you have 3+ refinement levels?
+-- YES --> Run h_refinement.py or dt_refinement.py
|           +-- Observed order matches expected? --> Solution verified
|           +-- Order too low? --> Check: pre-asymptotic, coding error, insufficient resolution
|           +-- Order too high? --> Check: superconvergence or cancellation effects
+-- NO (only 2 levels) --> Use richardson_extrapolation.py with assumed order
                           (less reliable without order verification)
```

## CLI Examples

```bash
# Spatial convergence with 4 grid levels
python3 scripts/h_refinement.py --spacings 0.4,0.2,0.1,0.05 --values 1.16,1.04,1.01,1.0025 --expected-order 2.0 --json

# Temporal convergence with 3 timestep levels
python3 scripts/dt_refinement.py --timesteps 0.04,0.02,0.01 --values 2.12,2.03,2.0075 --expected-order 2.0 --json

# Richardson extrapolation with assumed 2nd-order
python3 scripts/richardson_extrapolation.py --spacings 0.02,0.01 --values 1.0032,1.0008 --order 2.0 --json

# GCI for 3-mesh verification
python3 scripts/gci_calculator.py --spacings 0.04,0.02,0.01 --values 1.0128,1.0032,1.0008 --json
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| `spacings and values must have the same length` | Mismatched input arrays | Provide equal-length lists |
| `At least 2 refinement levels required` | Too few data points | Add more refinement levels |
| `Exactly 3 refinement levels required` | GCI needs 3 levels | Provide fine/medium/coarse |
| `Oscillatory convergence detected` | Non-monotone convergence | Check mesh quality or scheme |

## Interpretation Guidance

| Scenario | Meaning | Action |
|----------|---------|--------|
| Observed order matches expected | Solution in asymptotic range | Report GCI, extrapolate |
| Observed order < expected | Pre-asymptotic or coding bug | Refine further or debug |
| Negative observed order | Solution diverging | Check implementation |
| GCI asymptotic ratio near 1.0 | Grids in asymptotic range | Results are reliable |
| GCI asymptotic ratio far from 1.0 | Not in asymptotic range | Refine further |

## References

- `references/convergence_theory.md` - Formal convergence order, log-log analysis, asymptotic range
- `references/gci_guidelines.md` - Roache's GCI method, ASME V&V 20, safety factors
