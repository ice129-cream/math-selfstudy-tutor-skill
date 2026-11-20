# 在 DeepSeek Harness（DSH）中使用本 skill

## 这是体验最完整的平台

DeepSeek Harness（DSH）是本项目的一等公民平台，也是唯一能把 `math-selfstudy-tutor` 的完整形态跑起来的载体。前面那些平台——GPTs、ChatGPT Project、扣子 / 豆包、Gemini Gem——都只能收一段精简提示词，把 `references/` 的颗粒度压平；API 的 system prompt 也只是随请求全量发一段文本。DSH 不同：它有**原生 skill 机制**，会扫描 skill 根目录、把 `SKILL.md` 的 frontmatter 收进 session catalog，对话命中 `description` 里的意图时加载正文，再按当前信号**只读取需要的那一份 `references/` 分册**，不一次把全部内容灌进上下文。

这一条"按需加载"是分水岭。本 skill 的全部设计——宪法十二问链、三张互斥工作台、四层闭环、自检六项、真题为母、Level 0–4 刻度盘——拆成了一个主文件加八份随用随取的分册。只有在 DSH 上，这八份分册才真正按信号被打开：进闭环台取 `ladder.md`，进核验台取 `grading.md`，进探究台取 `exploration.md`，学生卡住取 `hints.md`，要裁决具体动作取 `constitution.md`，调学情取 `parameters.md`，主动出题则 `sourcing.md` + `preflight.md` 成对加载，模仿语气节奏时才看 `examples/dialogue.md`。到了别的平台，这套结构只能被压成一段文本，颗粒度下降。所以：**要用这个 skill，DSH 是首选，也是保真度最高的落点。**

## 安装：软链，首选

安装本质是把 `skills/math-selfstudy-tutor` 目录暴露给 DSH。占位符：`<PROJECT>` 为本仓库根目录（本机为 `D:\dsh-111\skill_analysis\math-selfstudy-tutor-skill`），`<DSH_SKILLS_DIR>` 为 DSH 扫描的 skill 根目录。

软链让仓库保持单一副本，仓库更新后立刻生效，目标路径须尚不存在。

Linux / macOS：

```bash
ln -s <PROJECT>/skills/math-selfstudy-tutor <DSH_SKILLS_DIR>/math-selfstudy-tutor
```

Windows（cmd）：

```cmd
mklink /D "<DSH_SKILLS_DIR>\math-selfstudy-tutor" "<PROJECT>\skills\math-selfstudy-tutor"
```

Windows（PowerShell）：

```powershell
New-Item -ItemType SymbolicLink -Path "<DSH_SKILLS_DIR>\math-selfstudy-tutor" -Target "<PROJECT>\skills\math-selfstudy-tutor"
```

宿主处理符号链接有障碍时，退到复制式：`cp -r` / `xcopy /E /I` 把整目录复制过去。复制式是独立副本，仓库更新后需重新覆盖目标目录。

更新：软链式在仓库根目录 `git pull` 即可；复制式拉取后重新复制。重建软链先删旧链再建新链，Windows 删链用 `rmdir "<DSH_SKILLS_DIR>\math-selfstudy-tutor"`，删的是链接本身，目标内容保留。

## 装载机制：frontmatter 决定何时加载

`SKILL.md` 开头的 YAML frontmatter 里，`name: math-selfstudy-tutor` 和 `description` 是给 DSH 的 catalog 用的。`description` 里写满了触发意图：学生说"这题不会""帮我讲""我讲给你听""批改我的推导""给道变式""换条件会怎样""这定理前提是什么""举反例""一题多解""卡住了"都会命中。DSH 扫描 `<DSH_SKILLS_DIR>`，把符合格式的条目收进 session catalog；命中这些意图时加载正文，再按信号取分册。

`/出题` `/讲题` `/批改` `/变式` `/自检` 这类斜杠文本在这里也**只当意图信号**，不是真正的 shell 命令——DSH 不会去执行它们，不要把它们在文档里宣传成命令。

## 自然语言触发：大白话就够

不用记任何命令，直接说需求：

- "这道题我不会，帮我讲" → 命中 catalog，进闭环台：布置任务、先不主动给提示、不给解析，加载 `ladder.md`。
- "我讲给你听这道中值定理题" → 闭环台第三层：倾听不打断，讲完再集中拷问。
- "帮我批改这段推导" → 进核验台，按五维查说理链条，不打√×，加载 `grading.md`。
- "这定理前提是什么、会变形吗" → 进探究台，先让他自己预判说理再验证，加载 `exploration.md`。
- "卡住了" → 按四层提示梯度放提示，加载 `hints.md`，永不给完整推导。
- "我要出一道综合题" → `sourcing.md` + `preflight.md` 成对加载，命题后先自检再发。
- "把难度调到 Level 4" → 加载 `parameters.md`，只调提问深度、变式复杂度、冷门密度，不动宪法与自检闸门。

## 验证装载成功

1. 目标位置存在、入口文件可读：`ls -l <DSH_SKILLS_DIR>/math-selfstudy-tutor/SKILL.md`；软链式显示指向 `<PROJECT>` 的箭头，复制式显示普通文件。
2. 行为验证：说"这道题我不会，帮我讲"应进闭环台、布置任务、不直接开讲；说"帮我批改这段推导"应进核验台按五维查说理；说"这定理前提是什么"应进探究台先让他自己预判。
3. 回答里杜绝出现守则条目、版本、文件或协议名——行为即导师，不亮工具。出现即为加载异常。
4. 按需加载验证：进核验台时它读的是 `grading.md` 而不是把八份分册全灌进来；主动出题时 `sourcing.md` 与 `preflight.md` 成对出现。单轮只读需要的分册，是这个 skill 在 DSH 上的正常运转方式。

## DSH 上如何把完整模式用足

DSH 保住了 references 按需加载，就该把它用足，而不是只当一段提示词用：

- **一次一道题**：闭环台走完四层再往下，学生没交出本层输出物就不进下一层。别让它在学生讲题中切成逐句打勾的核验口吻，也别在核验台里发新题。
- **自检闸门成对加载**：凡它主动出题，`sourcing.md` 与 `preflight.md` 必须成对取用；六项判据全过才发，任一不过改参数调条件，绝不发错题。学生自带的真题不触发闸门，直接进闭环台。
- **宪法裁决**：判定某个动作该不该做时取 `constitution.md`，按十二问链裁决——冲突时更靠近"求真 / 独立思考"的一端胜出，学生没有产出说理 / 主讲 / 修正 / 质疑，这一轮就是空转。
- **无隐藏记忆**：本 skill 每轮只凭当前对话判断，不偷偷积累学生画像。别指望它跨会话记住"这个学生上次卡在哪一层"。

## 核心模式不可削弱

DSH 是唯一能完整保留 references 按需加载的平台，正因如此，这里没有任何理由削弱核心。下列五条是身份本身，任何改动都不许让步：

- **三张工作台互斥**：闭环台（默认）、核验台、探究台，按信号进唯一一张，进场明说"现在进 X 模式"，一张台内不混入另一张台的动作。
- **四层闭环以学生输出通关**：独立做题 → 做懂题 → 讲懂题 → 举一反三，层层以学生交出的结果 / 论证 / 完整主讲 / 变式说理放行，终点是"脱离导师也能讲清楚"，不是听懂或算出答案。
- **自检闸门**：主动出的题发出前独立完整验算，六项全过才发，不发错题；学生自带真题不触发。
- **不给答案、不泄底**：四层提示梯度（本质锚点 → 结构 → 缺口 → 极小片段示范），永不泄漏完整推导，不替学生写讲稿。
- **真题为母**：官方真题优先、结构性改编，不凭空造题、不拿来源不明的模拟卷当主素材。

在 DSH 上，这五条加上按需加载的八份分册、14 条红线，构成这个 skill 的完整交付形态——这是其他平台压缩后剩下的东西替代不了的。
