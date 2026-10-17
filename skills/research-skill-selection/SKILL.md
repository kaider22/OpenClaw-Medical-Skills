---
name: research-skill-selection
description: 用于用户要求定位技能、比较相似技能，或任务的技能选择存在实际歧义时。
---
# 本仓库技能选择

用于用户要求定位技能、比较相似技能，或任务的技能选择存在实际歧义时。

## Codex 调用

显式调用 `$research-skill-selection`。

1. 按用户目标、输入格式和预期产物，在 ../../skill-migration.csv 中筛选当前 ID。
2. 读取候选技能的 name、description；只对相关候选加载完整 SKILL.md。
3. Codex CLI 可用 $技能ID 或技能选择器显式选择；不需要虚构 Skill 工具。
4. 对选中的技能检查实际执行条件。技能清单中存在某项能力不代表依赖已安装或科研流程已经验证。
5. 没有必要的专用技能时直接完成当前任务，不强制加载额外流程技能。
