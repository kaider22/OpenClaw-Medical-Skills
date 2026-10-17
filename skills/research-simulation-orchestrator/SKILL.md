---
name: research-simulation-orchestrator
description: 管理仿真参数扫描、批次状态和结果汇总；用于处理基础配置、参数范围、仿真命令和输出目录。
metadata:
  source_extensions:
    allowed-tools: Read, Bash, Write, Grep, Glob
---

# Simulation Orchestrator

## Codex 调用

- **选择**：请求涉及“管理仿真参数扫描、批次状态和结果汇总”时使用；显式调用 `$research-simulation-orchestrator`。
- **输入**：基础配置、参数范围、仿真命令和输出目录。
- **预期产物**：配置文件、作业状态、统计摘要和失败列表；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[scripts/job_tracker.py](scripts/job_tracker.py)、[scripts/sweep_generator.py](scripts/sweep_generator.py)、[scripts/campaign_manager.py](scripts/campaign_manager.py)、[scripts/result_aggregator.py](scripts/result_aggregator.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`uuid`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **外部/示例入口**：`phase_field.py`、`sim.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Goal

Provide tools to manage multi-simulation campaigns: generate parameter sweeps, track job execution status, and aggregate results from completed runs.

## Requirements

- Python 3.10+
- No external dependencies (uses Python standard library only)
- Works on Linux, macOS, and Windows

## Inputs to Gather

Before running orchestration scripts, collect from the user:

| Input | Description | Example |
|-------|-------------|---------|
| Base config | Template simulation configuration | `base_config.json` |
| Parameter ranges | Parameters to sweep with bounds | `dt:[1e-4,1e-2],kappa:[0.1,1.0]` |
| Sweep method | How to sample parameter space | `grid`, `lhs`, `linspace` |
| Output directory | Where to store campaign files | `./campaign_001` |
| Simulation command | Command to run each simulation | `python sim.py --config {config}` |

## Decision Guidance

### Choosing a Sweep Method

```
Need every combination (full factorial)?
├── YES → Use grid (warning: exponential growth with parameters)
└── NO → Is space-filling coverage needed?
    ├── YES → Use lhs (Latin Hypercube Sampling)
    └── NO → Use linspace for uniform sampling per parameter
```

| Method | Best For | Sample Count |
|--------|----------|--------------|
| `grid` | Low dimensions (1-3), need exact corners | n^d (exponential) |
| `linspace` | 1D sweeps, uniform spacing | n per parameter |
| `lhs` | High dimensions, space-filling | user-specified budget |

### Campaign Size Guidelines

| Parameters | Grid Points Each | Total Runs | Recommendation |
|------------|------------------|------------|----------------|
| 1 | 10 | 10 | Grid is fine |
| 2 | 10 | 100 | Grid acceptable |
| 3 | 10 | 1,000 | Consider LHS |
| 4+ | 10 | 10,000+ | Use LHS or DOE |

## Script Outputs (JSON Fields)

| Script | Output Fields |
|--------|---------------|
| `scripts/sweep_generator.py` | `configs`, `parameter_space`, `sweep_method`, `total_runs` |
| `scripts/campaign_manager.py` | `campaign_id`, `status`, `jobs`, `progress` |
| `scripts/job_tracker.py` | `job_id`, `status`, `start_time`, `end_time`, `exit_code` |
| `scripts/result_aggregator.py` | `summary`, `statistics`, `best_run`, `failed_runs` |

## Workflow

### Step 1: Generate Parameter Sweep

Create configurations for all parameter combinations:

```bash
python3 scripts/sweep_generator.py \
    --base-config base_config.json \
    --params "dt:1e-4:1e-2:5,kappa:0.1:1.0:3" \
    --method linspace \
    --output-dir ./campaign_001 \
    --json
```

### Step 2: Initialize Campaign

Create campaign tracking structure:

```bash
python3 scripts/campaign_manager.py \
    --action init \
    --config-dir ./campaign_001 \
    --command "python sim.py --config {config}" \
    --json
```

### Step 3: Track Job Status

Monitor running jobs:

```bash
python3 scripts/job_tracker.py \
    --campaign-dir ./campaign_001 \
    --update \
    --json
```

### Step 4: Aggregate Results

Combine results from completed runs:

```bash
python3 scripts/result_aggregator.py \
    --campaign-dir ./campaign_001 \
    --metric objective_value \
    --json
```

## CLI Examples

```bash
# Generate 5x3=15 runs varying dt (5 values) and kappa (3 values)
python3 scripts/sweep_generator.py \
    --base-config sim.json \
    --params "dt:1e-4:1e-2:5,kappa:0.1:1.0:3" \
    --method linspace \
    --output-dir ./sweep_001 \
    --json

# Generate LHS samples for 4 parameters with budget of 20 runs
python3 scripts/sweep_generator.py \
    --base-config sim.json \
    --params "dt:1e-4:1e-2,kappa:0.1:1.0,M:1e-6:1e-4,W:0.5:2.0" \
    --method lhs \
    --samples 20 \
    --output-dir ./lhs_001 \
    --json

# Check campaign status
python3 scripts/campaign_manager.py \
    --action status \
    --config-dir ./sweep_001 \
    --json

# Get summary statistics from completed runs
python3 scripts/result_aggregator.py \
    --campaign-dir ./sweep_001 \
    --metric final_energy \
    --json
```

## Conversational Workflow Example

**User**: I want to run a parameter sweep on dt and kappa for my phase-field simulation. I want to try 5 values of dt between 1e-4 and 1e-2, and 4 values of kappa between 0.1 and 1.0.

**Agent workflow**:
1. Calculate total runs: 5 x 4 = 20 runs
2. Generate sweep configurations:
   ```bash
   python3 scripts/sweep_generator.py \
       --base-config simulation.json \
       --params "dt:1e-4:1e-2:5,kappa:0.1:1.0:4" \
       --method linspace \
       --output-dir ./dt_kappa_sweep \
       --json
   ```
3. Initialize campaign:
   ```bash
   python3 scripts/campaign_manager.py \
       --action init \
       --config-dir ./dt_kappa_sweep \
       --command "python phase_field.py --config {config}" \
       --json
   ```
4. After user runs simulations, aggregate results:
   ```bash
   python3 scripts/result_aggregator.py \
       --campaign-dir ./dt_kappa_sweep \
       --metric interface_width \
       --json
   ```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| `Base config not found` | Invalid file path | Verify base config file exists |
| `Invalid parameter format` | Malformed param string | Use format `name:min:max:count` or `name:min:max` |
| `Output directory exists` | Would overwrite | Use `--force` or choose new directory |
| `No completed jobs` | No results to aggregate | Wait for jobs to complete or check for failures |
| `Metric not found` | Result files missing field | Verify metric name in result JSON |

## Integration with Other Skills

The research-simulation-orchestrator works with other simulation-workflow skills:

```
parameter-optimization          simulation-orchestrator
        │                              │
        │ DOE samples ────────────────>│ Generate configs
        │                              │
        │                              │ Run simulations
        │                              │
        │<──────────────────────────── │ Aggregate results
        │                              │
        │ Sensitivity analysis         │
        │ Optimizer selection          │
```

### Typical Combined Workflow

1. Use `research-parameter-optimization/doe_generator.py` to get sample points
2. Use `research-simulation-orchestrator/sweep_generator.py` to create configs
3. Run simulations (user's responsibility)
4. Use `research-simulation-orchestrator/result_aggregator.py` to collect results
5. Use `research-parameter-optimization/sensitivity_summary.py` to analyze

## Limitations

- **Not a job scheduler**: Does not submit jobs to SLURM/PBS; generates configs and tracks status
- **No parallel execution**: User must run simulations externally (can use GNU parallel, SLURM, etc.)
- **File-based tracking**: Status tracked via files; no database or real-time monitoring
- **Local filesystem**: Assumes all files accessible from local machine

## References

- `references/campaign_patterns.md` - Common campaign structures
- `references/sweep_strategies.md` - Parameter sweep design guidance
- `references/aggregation_methods.md` - Result aggregation techniques

## Version History

- **v1.0.0** (2024-12-24): Initial release with sweep, campaign, tracking, and aggregation
