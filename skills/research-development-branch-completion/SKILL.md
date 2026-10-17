---
name: research-development-branch-completion
description: 用于当前开发任务已实现，需要检查提交边界和交付结果时。
---
# 开发分支收尾

用于当前开发任务已实现，需要检查提交边界和交付结果时。

## Codex 调用

显式调用 `$research-development-branch-completion`。

1. 查看实际 diff 和当前任务的相关验证，排除无关文件与生成产物。
2. 按用户已有授权提交或推送；只有获准创建 PR 时才创建，并核对远端结果。
3. 说明分支、提交和未解决条件，不把测试通过等同于已合并或已上线。
4. 清理工作树、删除分支或其他不可逆动作遵守工作区现行确认规则。
