---
name: research-time-stepping
description: 规划数值模拟的步长、输出时刻和检查点策略；用于处理稳定性上限、目标步长、运行时长和写盘成本。
metadata:
  source_extensions:
    allowed-tools: Read, Bash, Write, Grep, Glob
---

# Time Stepping

## Codex 调用

- **选择**：请求涉及“规划数值模拟的步长、输出时刻和检查点策略”时使用；显式调用 `$research-time-stepping`。
- **输入**：稳定性上限、目标步长、运行时长和写盘成本。
- **预期产物**：推荐步长、渐增计划、输出时间表和检查点间隔；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[scripts/output_schedule.py](scripts/output_schedule.py)、[scripts/timestep_planner.py](scripts/timestep_planner.py)、[scripts/checkpoint_planner.py](scripts/checkpoint_planner.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Goal

Provide a reliable workflow for choosing, ramping, and monitoring time steps plus output/checkpoint cadence.

## Requirements

- Python 3.8+
- No external dependencies (uses stdlib)

## Inputs to Gather

| Input | Description | Example |
|-------|-------------|---------|
| Stability limits | CFL/Fourier/reaction limits | `dt_max = 1e-4` |
| Target dt | Desired time step | `1e-5` |
| Total run time | Simulation duration | `10 s` |
| Output interval | Time between outputs | `0.1 s` |
| Checkpoint cost | Time to write checkpoint | `120 s` |

## Decision Guidance

### Time Step Selection

```
Is stability limit known?
├── YES → Use min(dt_target, dt_limit × safety)
└── NO → Start conservative, increase adaptively

Need ramping for startup?
├── YES → Start at dt_init, ramp to dt_target over N steps
└── NO → Use dt_target from start
```

### Ramping Strategy

| Problem Type | Ramp Steps | Initial dt |
|--------------|------------|------------|
| Smooth IC | None needed | Full dt |
| Sharp gradients | 5-10 | 0.1 × dt |
| Phase change | 10-20 | 0.01 × dt |
| Cold start | 10-50 | 0.001 × dt |

## Script Outputs (JSON Fields)

| Script | Key Outputs |
|--------|-------------|
| `scripts/timestep_planner.py` | `dt_limit`, `dt_recommended`, `ramp_schedule` |
| `scripts/output_schedule.py` | `output_times`, `interval`, `count` |
| `scripts/checkpoint_planner.py` | `checkpoint_interval`, `checkpoints`, `overhead_fraction` |

## Workflow

1. **Get stability limits** - Use numerical-stability skill
2. **Plan time stepping** - Run `scripts/timestep_planner.py`
3. **Schedule outputs** - Run `scripts/output_schedule.py`
4. **Plan checkpoints** - Run `scripts/checkpoint_planner.py`
5. **Monitor during run** - Adjust dt if limits change

## Conversational Workflow Example

**User**: I'm running a 10-hour phase-field simulation. How often should I checkpoint?

**Agent workflow**:
1. Plan checkpoints based on acceptable lost work:
   ```bash
   python3 scripts/checkpoint_planner.py --run-time 36000 --checkpoint-cost 120 --max-lost-time 1800 --json
   ```
2. Interpret: Checkpoint every 30 minutes, overhead ~0.7%, max 30 min lost work on crash.

## Pre-Run Checklist

- [ ] Confirm dt limits from stability analysis
- [ ] Define ramping strategy for transient startup
- [ ] Choose output interval consistent with physics time scales
- [ ] Plan checkpoints based on restart risk
- [ ] Re-evaluate dt after parameter changes

## CLI Examples

```bash
# Plan time stepping with ramping
python3 scripts/timestep_planner.py --dt-target 1e-4 --dt-limit 2e-4 --safety 0.8 --ramp-steps 10 --json

# Schedule output times
python3 scripts/output_schedule.py --t-start 0 --t-end 10 --interval 0.1 --json

# Plan checkpoints for long run
python3 scripts/checkpoint_planner.py --run-time 36000 --checkpoint-cost 120 --max-lost-time 1800 --json
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| `dt-target must be positive` | Invalid time step | Use positive value |
| `t-end must be > t-start` | Invalid time range | Check time bounds |
| `checkpoint-cost must be < run-time` | Checkpoint too expensive | Reduce checkpoint size |

## Interpretation Guidance

### dt Behavior

| Observation | Meaning | Action |
|-------------|---------|--------|
| dt stable at target | Good | Continue |
| dt shrinking | Stability issue | Check CFL, reduce target |
| dt oscillating | Borderline stability | Add safety factor |

### Checkpoint Overhead

| Overhead | Acceptability |
|----------|---------------|
| < 1% | Excellent |
| 1-5% | Good |
| 5-10% | Acceptable |
| > 10% | Too frequent, increase interval |

## Limitations

- **Not adaptive control**: Plans static schedules, not runtime adaptation
- **Assumes constant physics**: If parameters change, re-plan

## References

- `references/cfl_coupling.md` - Combining multiple stability limits
- `references/ramping_strategies.md` - Startup policies
- `references/output_checkpoint_guidelines.md` - Cadence rules

## Version History

- **v1.1.0** (2024-12-24): Enhanced documentation, decision guidance, examples
- **v1.0.0**: Initial release with 3 planning scripts
