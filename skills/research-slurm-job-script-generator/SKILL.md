---
name: research-slurm-job-script-generator
description: 生成SLURM提交脚本并检查资源布局和内存参数；用于处理作业名、时限、节点、CPU/GPU、内存和运行命令。
metadata:
  source_extensions:
    allowed-tools: Read, Bash, Write, Grep, Glob
---

# SLURM Job Script Generator

## Codex 调用

- **选择**：请求涉及“生成SLURM提交脚本并检查资源布局和内存参数”时使用；显式调用 `$research-slurm-job-script-generator`。
- **输入**：作业名、时限、节点、CPU/GPU、内存和运行命令。
- **预期产物**：sbatch脚本、结构化资源字段与配置警告；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[scripts/slurm_script_generator.py](scripts/slurm_script_generator.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`shlex`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Goal

Generate a correct, copy-pasteable SLURM job script (`.sbatch`) for running a simulation, and surface common configuration mistakes (bad walltime format, conflicting memory flags, oversubscription hints).

## Requirements

- Python 3.8+
- No external dependencies (Python standard library only)
- Works on Linux, macOS, and Windows (script generation only)

## Inputs to Gather

| Input | Description | Example |
|-------|-------------|---------|
| Job name | Short identifier for the job | `phasefield-strong-scaling` |
| Walltime | SLURM time limit | `00:30:00` |
| Partition | Cluster partition/queue (if required) | `compute` |
| Account | Project/account (if required) | `matsim` |
| Nodes | Number of nodes to allocate | `2` |
| MPI tasks | Total tasks, or tasks per node | `128` or `64` per node |
| Threads | CPUs per task (OpenMP threads) | `2` |
| Memory | `--mem` or `--mem-per-cpu` (cluster policy dependent) | `32G` |
| GPUs | GPUs per node (optional) | `4` |
| Working directory | Where the run should execute | `$SLURM_SUBMIT_DIR` |
| Modules | Environment modules to load (optional) | `gcc/12`, `openmpi/4.1` |
| Run command | The command to launch under SLURM | `./simulate --config cfg.json` |

## Decision Guidance

### MPI vs MPI+OpenMP layout

```
Does the code use OpenMP / threading?
├── NO  → Use MPI-only: cpus-per-task=1
└── YES → Use hybrid: set cpus-per-task = threads per MPI rank
          and export OMP_NUM_THREADS = cpus-per-task
```

**Rule of thumb:** if you see diminishing strong-scaling efficiency at high MPI ranks, try fewer ranks with more threads per rank (and measure).

### Memory flag selection

- Use **either** `--mem` (per node) **or** `--mem-per-cpu` (per CPU), not both.
- Follow your cluster’s documentation; some sites enforce one style.
- SLURM `--mem` units are integer MB by default, or an integer with suffix `K/M/G/T` (and `--mem=0` commonly means “all memory on node”).

## Script Outputs (JSON Fields)

| Script | Key Outputs |
|--------|-------------|
| `scripts/slurm_script_generator.py` | `results.script`, `results.directives`, `results.derived`, `results.warnings` |

## Workflow

1. Gather cluster constraints (partition/account, GPU policy, memory policy).
2. Choose a process layout (MPI-only vs hybrid MPI+OpenMP).
3. Generate the script with `slurm_script_generator.py`.
4. Inspect warnings (conflicts, suspicious layouts).
5. Save the generated script as `job.sbatch`.
6. Submit with `sbatch job.sbatch` and monitor with `squeue`.

## CLI Examples

```bash
# Preview a job script (prints to stdout)
python3 scripts/slurm_script_generator.py \
  --job-name phasefield \
  --time 00:10:00 \
  --partition compute \
  --nodes 1 \
  --ntasks-per-node 8 \
  --cpus-per-task 2 \
  --mem 16G \
  --module gcc/12 \
  --module openmpi/4.1 \
  -- \
  ./simulate --config config.json

# Write to a file and also emit structured JSON
python3 scripts/slurm_script_generator.py \
  --job-name phasefield \
  --time 00:10:00 \
  --nodes 1 \
  --ntasks 16 \
  --cpus-per-task 1 \
  --out job.sbatch \
  --json \
  -- \
  /bin/echo hello
```

## Conversational Workflow Example

**User**: I need an `sbatch` script for my MPI simulation. I want 2 nodes, 64 ranks per node, 2 OpenMP threads per rank, and 2 hours.

**Agent workflow**:
1. Confirm partition/account and whether GPUs are needed.
2. Generate a hybrid job script:
   ```bash
   python3 scripts/slurm_script_generator.py --job-name run --time 02:00:00 --nodes 2 --ntasks-per-node 64 --cpus-per-task 2 -- -- ./simulate
   ```
3. Explain the mapping:
   - Total ranks = 128
   - Threads per rank = 2 (`OMP_NUM_THREADS=2`)
4. If the user provides node core counts, sanity-check oversubscription using `--cores-per-node`.

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| `time must be HH:MM:SS or D-HH:MM:SS` | Bad walltime format | Use `00:30:00` or `1-00:00:00` |
| `nodes must be positive` | Non-positive nodes | Provide `--nodes >= 1` |
| `Provide either --mem or --mem-per-cpu, not both` | Conflicting memory directives | Choose one memory style |
| `Provide a run command after --` | Missing launch command | Add `-- ./simulate ...` |

## Limitations

- Does not query cluster hardware or site policies; it can only validate internal consistency.
- SLURM installations vary (GPU directives, QoS rules, partitions). Adjust directives for your site.

## References

- `references/slurm_directives.md` - Common `#SBATCH` directives and mapping tips

## Version History

- **v1.0.0** (2026-02-25): Initial SLURM job script generator
