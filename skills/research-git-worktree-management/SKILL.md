---
name: research-git-worktree-management
description: 用于任务确实需要隔离检出，或用户要求工作树时。
---
# Git 工作树管理

用于任务确实需要隔离检出，或用户要求工作树时。

## Codex 调用

显式调用 `$research-git-worktree-management`。

1. 先查看当前工作树、分支和未提交改动，优先复用适用的已有工作树。
2. 当前 Codex 环境提供管理工具时按其返回路径操作，否则使用本机真实 Git 能力。
3. 创建后核对路径、起点和分支，保持原工作区改动可恢复。
4. 不默认改全局配置或长期规则；归档、删除与清理按现行授权边界执行。
