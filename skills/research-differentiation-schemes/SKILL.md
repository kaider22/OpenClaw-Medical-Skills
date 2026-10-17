---
name: research-differentiation-schemes
description: 选择PDE/ODE差分格式并生成离散模板；用于处理导数阶数、目标精度、网格和边界类型。
metadata:
  source_extensions:
    allowed-tools: Read, Bash, Write, Grep, Glob
---

# Differentiation Schemes

## Codex 调用

- **选择**：请求涉及“选择PDE/ODE差分格式并生成离散模板”时使用；显式调用 `$research-differentiation-schemes`。
- **输入**：导数阶数、目标精度、网格和边界类型。
- **预期产物**：方案建议、模板系数和截断误差估计；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[scripts/scheme_selector.py](scripts/scheme_selector.py)、[scripts/truncation_error.py](scripts/truncation_error.py)、[scripts/stencil_generator.py](scripts/stencil_generator.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Goal

Provide a reliable workflow to select a differentiation scheme, generate stencils, and assess accuracy for simulation discretization.

## Requirements

- Python 3.8+
- NumPy (for stencil computations)
- No heavy dependencies

## Inputs to Gather

| Input | Description | Example |
|-------|-------------|---------|
| Derivative order | First, second, etc. | `1` or `2` |
| Target accuracy | Order of truncation error | `2` or `4` |
| Grid type | Uniform, nonuniform | `uniform` |
| Boundary type | Periodic, Dirichlet, Neumann | `periodic` |
| Smoothness | Smooth or discontinuous | `smooth` |

## Decision Guidance

### Scheme Selection Flowchart

```
Is the field smooth?
├── YES → Is domain periodic?
│   ├── YES → Use central differences or spectral
│   └── NO → Use central interior + one-sided at boundaries
└── NO → Are there shocks/discontinuities?
    ├── YES → Use upwind, TVD, or WENO
    └── NO → Use central with limiters
```

### Quick Reference

| Situation | Recommended Scheme |
|-----------|-------------------|
| Smooth, periodic | Central, spectral |
| Smooth, bounded | Central + one-sided BCs |
| Advection-dominated | Upwind |
| Shocks/fronts | TVD, WENO |
| High accuracy needed | Compact (Padé), spectral |

## Script Outputs (JSON Fields)

| Script | Key Outputs |
|--------|-------------|
| `scripts/stencil_generator.py` | `offsets`, `coefficients`, `order`, `accuracy` |
| `scripts/scheme_selector.py` | `recommended`, `alternatives`, `notes` |
| `scripts/truncation_error.py` | `error_scale`, `order`, `notes` |

## Workflow

1. **Identify requirements** - derivative order, accuracy, smoothness
2. **Select scheme** - Run `scripts/scheme_selector.py`
3. **Generate stencils** - Run `scripts/stencil_generator.py`
4. **Estimate error** - Run `scripts/truncation_error.py`
5. **Validate** - Test with manufactured solutions or grid refinement

## Conversational Workflow Example

**User**: I need to discretize a second derivative for a diffusion equation on a uniform grid. I want 4th-order accuracy.

**Agent workflow**:
1. Select appropriate scheme:
   ```bash
   python3 scripts/scheme_selector.py --smooth --periodic --order 2 --accuracy 4 --json
   ```
2. Generate the stencil:
   ```bash
   python3 scripts/stencil_generator.py --order 2 --accuracy 4 --scheme central --json
   ```
3. Result: 5-point stencil with coefficients `[-1/12, 4/3, -5/2, 4/3, -1/12]` / dx².

## Pre-Discretization Checklist

- [ ] Confirm derivative order and target accuracy
- [ ] Choose scheme appropriate to smoothness and boundaries
- [ ] Generate and inspect stencils at boundaries
- [ ] Estimate truncation error vs physics scales
- [ ] Verify with grid refinement study

## CLI Examples

```bash
# Select scheme for smooth periodic problem
python3 scripts/scheme_selector.py --smooth --periodic --order 1 --accuracy 4 --json

# Generate central difference stencil for first derivative
python3 scripts/stencil_generator.py --order 1 --accuracy 2 --scheme central --json

# Generate 4th-order second derivative stencil
python3 scripts/stencil_generator.py --order 2 --accuracy 4 --scheme central --json

# Estimate truncation error
python3 scripts/truncation_error.py --dx 0.01 --order 2 --accuracy 2 --scale 1.0 --json
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| `order must be positive` | Invalid derivative order | Use 1, 2, 3, ... |
| `accuracy must be even for central` | Odd accuracy requested | Use 2, 4, 6, ... |
| `Unknown scheme` | Invalid scheme type | Use central, upwind, compact |

## Interpretation Guidance

### Stencil Properties

| Property | Meaning |
|----------|---------|
| Symmetric offsets | Central scheme (no directional bias) |
| Asymmetric offsets | One-sided or upwind scheme |
| More points | Higher accuracy but wider stencil |

### Truncation Error Scaling

| Accuracy Order | Error Scales As | Refinement Factor |
|----------------|-----------------|-------------------|
| 2nd order | O(dx²) | 2× refinement → 4× error reduction |
| 4th order | O(dx⁴) | 2× refinement → 16× error reduction |
| 6th order | O(dx⁶) | 2× refinement → 64× error reduction |

### Common Stencils

| Derivative | Accuracy | Points | Coefficients (× 1/dx or 1/dx²) |
|------------|----------|--------|-------------------------------|
| 1st | 2 | 3 | [-1/2, 0, 1/2] |
| 1st | 4 | 5 | [1/12, -2/3, 0, 2/3, -1/12] |
| 2nd | 2 | 3 | [1, -2, 1] |
| 2nd | 4 | 5 | [-1/12, 4/3, -5/2, 4/3, -1/12] |

## Limitations

- **Boundary handling**: Stencil generator provides interior stencils; boundaries need special treatment
- **Nonuniform grids**: Standard stencils assume uniform spacing
- **Spectral**: Not covered by stencil generator

## References

- `references/stencil_catalog.md` - Common stencils
- `references/boundary_handling.md` - One-sided schemes
- `references/scheme_selection.md` - FD/FV/spectral comparison
- `references/error_guidance.md` - Truncation error scaling

## Version History

- **v1.1.0** (2024-12-24): Enhanced documentation, decision guidance, examples
- **v1.0.0**: Initial release with 3 differentiation scripts
