# 安装与兼容指南

本项目是一个纯 Markdown 的 DeepSeek Harness（DSH）原生 skill：`math-selfstudy-tutor`。安装本质是把 `skills/math-selfstudy-tutor` 目录暴露给宿主 agent。

目录结构：

```
math-selfstudy-tutor/
├── SKILL.md              # 入口：frontmatter（name/description）+ 陪练守则正文
├── references/           # 随用随取的分册
│   ├── constitution.md
│   ├── ladder.md
│   ├── grading.md
│   ├── exploration.md
│   ├── hints.md
│   ├── parameters.md
│   ├── sourcing.md
│   └── preflight.md
└── examples/
    └── dialogue.md
```

`SKILL.md` 的 YAML frontmatter 里 `name` 与 `description` 决定 DSH 何时加载它。DSH 扫描 skill 根目录，把符合格式的条目收进 session catalog；对话命中 `description` 中的意图时加载正文，再按当前信号只读取 `references/` 里对应的分册，不一次性把全部内容灌进上下文。

占位符约定：

- `<PROJECT>` → 本仓库根目录，例如 `D:\dsh-111\skill_analysis\math-selfstudy-tutor-skill`
- `<DSH_SKILLS_DIR>` → DSH 的 skill 根目录（本机 DSH 扫描的那一级目录）
- `<AGENT_INSTRUCTIONS_FILE>` → agent 的项目级指令文件

## 一、DSH 原生安装（软链，首选）

软链让仓库保持单一副本，`git pull` 后立刻生效。目标路径须尚不存在。

Linux / macOS：

```bash
ln -s <PROJECT>/skills/math-selfstudy-tutor <DSH_SKILLS_DIR>/math-selfstudy-tutor
```

Windows（cmd）：

```cmd
mklink /D "<DSH_SKILLS_DIR>\math-selfstudy-tutor" "<PROJECT>\skills\math-selfstudy-tutor"
```

Windows（PowerShell，另一条路）：

```powershell
New-Item -ItemType SymbolicLink -Path "<DSH_SKILLS_DIR>\math-selfstudy-tutor" -Target "<PROJECT>\skills\math-selfstudy-tutor"
```

装好后 DSH 扫描 `<DSH_SKILLS_DIR>`，把该目录 `SKILL.md` 的 frontmatter 收进 session catalog。命中数学陪练意图时加载，按信号再取分册。

## 二、复制式安装（备选）

宿主处理符号链接有障碍时，整目录复制。

Linux / macOS：

```bash
cp -r <PROJECT>/skills/math-selfstudy-tutor <DSH_SKILLS_DIR>/math-selfstudy-tutor
```

Windows：

```cmd
xcopy /E /I "<PROJECT>\skills\math-selfstudy-tutor" "<DSH_SKILLS_DIR>\math-selfstudy-tutor"
```

复制式是独立副本，仓库更新后重新覆盖目标目录。

## 三、更新

软链式：在仓库根目录拉取更新即可，软链指向同一份内容。

```bash
git -C <PROJECT> pull
```

复制式：`git pull` 后按第二节命令重新复制覆盖。

重建软链：先删旧链再建新链。

```bash
rm <DSH_SKILLS_DIR>/math-selfstudy-tutor
ln -s <PROJECT>/skills/math-selfstudy-tutor <DSH_SKILLS_DIR>/math-selfstudy-tutor
```

Windows 删链接用 `rmdir "<DSH_SKILLS_DIR>\math-selfstudy-tutor"`，删的是链接本身，目标目录内容保留。

## 四、验证

1. 目标位置存在、入口文件可读：

```bash
ls -l <DSH_SKILLS_DIR>/math-selfstudy-tutor/SKILL.md
head -n 14 <DSH_SKILLS_DIR>/math-selfstudy-tutor/SKILL.md
```

软链式 `ls -l` 显示指向 `<PROJECT>` 的箭头，复制式显示普通文件。`head` 应看到 `name: math-selfstudy-tutor` 与 `description` 字段，DSH 据此登记 catalog。

2. 行为验证（进会话说一句）：

- "这道题我不会，帮我讲" → 应以闭环台起步、布置任务，先不主动给提示，不直接给解析。直接开讲或给完整推导即为加载失败。
- "帮我批改这段推导" → 应进核验台、按 5 维查说理链条，不打√×。
- "这定理前提是什么，会变形吗" → 应进探究台，先让他自己预判说理再验证。

3. 触发后回答里不应出现守则条目、版本、文件或协议名——行为即导师，不亮工具。出现即为加载异常。

## 五、Codex / Claude Code style agent

这类 agent 没有 DSH 的 skill catalog，走「指令文件 + 同目录 references」的路子：

- 把 `SKILL.md` frontmatter 之下的正文注入 agent 的项目级指令文件 `<AGENT_INSTRUCTIONS_FILE>`（例如 `AGENTS.md`、`CLAUDE.md`，文件名按该 agent 的约定）。
- 保留 `references/` 与 `examples/` 的相对路径结构，让正文里 `references/ladder.md` 这类引用在 agent 工作区可达；agent 按信号自行打开对应分册。
- agent 提供自定义 skill / command 目录时，把整个 `skills/math-selfstudy-tutor` 放进该目录，以 `SKILL.md` 作触发入口。

指令文件名与扫描目录随 agent 版本变化，以该 agent 的文档为准。本 skill 的全部要求是：能读到 `SKILL.md` 正文，能按相对路径打开 `references/`。

## 六、三个 DeepSeek 使用面

| 使用面 | 原生 skill | 装载方式 | 本 skill 交付形态 | 按需加载 |
| --- | --- | --- | --- | --- |
| DeepSeek Chat | 否 | 对话里粘贴 Lite Prompt | 一段可直接粘贴的精简提示词 | 无，全量放进单次粘贴 |
| DeepSeek API | 否 | 放进 `system` 消息字段发送 | 系统提示词文本 | 无，随请求全量发送 |
| DeepSeek Harness（DSH） | 是 | 软链或复制进 skill 根目录，扫入 session catalog | 完整目录：`SKILL.md` + `references/` + `examples/` | 有，按信号只取对应分册 |

Chat 与 API 两个面的精简形态，其能力取舍见 [PORTABILITY.md](PORTABILITY.md)。
