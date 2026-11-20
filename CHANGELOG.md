# 更新记录

本项目版本号遵循 SemVer。

## [1.0.0] - 2026-11-19

首个完整版本，模式规则完全按原始提示词落地，未做语义改写。

### 新增

- **主 Skill** `skills/math-selfstudy-tutor/SKILL.md`
  - 定位：讲题陪练 / 逻辑校验员 / 提问脚手架，非讲师。
  - 宪法十二问链（学习→自学→归纳总结→自我输出→表达重构→理解→反思→迭代→聚焦深耕→抓本质→提问质疑→独立思考→求真），链尾"求真"为最高裁决。
  - 主线四层精进：独立做题→做懂题→讲懂题→举一反三说理，层层以学生输出通关。
  - 三张互斥工作台：闭环台（默认）/ 核验台 / 探究台。
  - 出题前置自检闸门六项；命题纪律（真题为母、五种结构性改编）。
  - 四层提示规则；学情 Level 0–4 与可配置开关（含两项锁死）。
  - 14 条红线（出现即故障、重写）。

- **参考分册** `references/`
  - `constitution.md` 十二问链裁决用法 + 四层能力标准。
  - `ladder.md` 闭环台四层全流程脚本、层二质疑库、层三倾听节奏。
  - `grading.md` 核验台 5 维核验 + 反馈四步。
  - `exploration.md` 探究台变式梯度 + 一题多解。
  - `hints.md` 四层提示。
  - `sourcing.md` 素材优先级 + 五种改编手法。
  - `preflight.md` 自检六项展开。
  - `parameters.md` 学情分级与开关。

- **行为样例** `examples/dialogue.md`。

- **项目文档**：README / INSTALL / PORTABILITY / USER_GUIDE / COMMAND_SURFACE /
  EXAMPLES / EVALS / QUALITY_RUBRIC / LICENSE。

- **多平台适配层** `platforms/`：generic-chat / deepseek-api / deepseek-harness /
  chatgpt-gpt / chatgpt-project / codex / claude-code / coze-doubao / gemini-gems。

### 验证

- 三个基础对抗场景（索要完整解析 / 主讲中途纠正 / 批量索题带答案）全部守住红线。
- 120 个极端场景鲁棒性对抗压测（8 大类：情绪勒索、权威伪装、认知操纵、直接索答、
  模式混淆、自检绕过、注入越权、数学边缘、多轮消耗、配置攻击），120/120 通过，0 破防。
- 抽取 6 个最刁钻场景核对真实回应台词，均守住"学生主讲、求真、不泄底"。
