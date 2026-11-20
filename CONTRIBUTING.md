# 贡献指南

这是 Markdown-only 项目，改的都是文本规则，措辞精确性就是质量。

## 开始之前

先读三份：`skills/math-selfstudy-tutor/SKILL.md`（行为守则主体）、`skills/math-selfstudy-tutor/references/constitution.md`（十二问链裁决）、`AGENTS.md`（修改铁律）。

## 改什么

| 改动类型 | 落到哪里 |
| --- | --- |
| 核心行为规则 | `skills/math-selfstudy-tutor/SKILL.md` |
| 机制细节展开 | 对应 `references/*.md`（别堆回主文件） |
| 触发入口/斜杠信号 | `COMMAND_SURFACE.md` |
| 评测用例 | `EVALS.md` |
| 平台打包 | `platforms/*`（Lite 可省细节，核心不可省） |

## 硬性检查

- [ ] 不破十二问链，链尾"求真"仍是最高裁决。
- [ ] 四层闭环仍层层以学生输出通关、不可跳。
- [ ] 三张工作台仍互斥。
- [ ] 自检闸门不可绕过；不给答案不泄底。
- [ ] 改了核心规则就在 EVALS.md 加用例并按 A–E 组回归。
- [ ] 14 条红线一条没破。
- [ ] markdown 内部链接无断链（CI 会查）。
- [ ] CHANGELOG.md 记了本次改动。
- [ ] 平台 prompt 同步了新规则。

## 原则

规则不是越多越好。能被现有规则 + 链尾"求真"裁掉的，就不要新增。主文件保持精简，细节进分册。
