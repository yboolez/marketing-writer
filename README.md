# marketing-writer

> A Claude Code skill that forces your slide titles to read like a sales pitch, not a corporate table of contents.

---

## 你做的 slides 标题全是名词短语，像目录——这个 skill 让它们读起来像一段销售话术

一个很会说人话的写手。写文案、做 PPT、做落地页。

---

## AI 生成的 deck 长得都一样：`我们的解决方案 / 核心优势 / 客户案例 / 联系我们`

每一页都是名词短语。所有标题连读，像一张目录，不像有人在说话。真实的销售不是这么讲的。

---

## 它只要求一件事：每页标题都是说给客户听的完整一句话，所有标题连读是一段完整话术

换成这样：

> 「我们做的这件事，市场上还没人做好 / 因为大家都在用错误的方式解决它 / 我们试了 3 条路才找到现在这个方案 / 它和同类产品最大的区别是 X / 已经有 Y 家客户在用并拿到了 Z 结果 / 现在合作你能拿到的是...」

每一页的标题是一句完整的话，连起来读是一段连贯的故事。每一页的正文，只是把标题展开。

---

## 你给它素材，它先只写标题串让你连读一遍，读顺了再展开正文

工作流程只有 5 步：

1. 接素材——先用 dbs-hook 的 5 维度（数据/故事/金句/权威/痛点）检查素材够不够。不够就停。
2. 只写标题——不写正文，一页一个标题，从头到尾。
3. 连读自查——两条硬规则：标题串听起来像不像销售话术？Hero 那句有没有金句感？
4. 展开正文——每页最少必要的文字 + 视觉建议。
5. 交付——要 slides 就直接调 `frontend-slides` 渲染出 HTML 并在浏览器打开，不再问你。

---

## 同一篇行业新闻，它能把 13 页 slides 的标题写成一段能念出来的故事

比如 Google Cloud Next 2026 的发布会报道，它会写成：

> "Google 憋了一整年的话，昨晚说了一句：试验阶段结束了。过去一年行业都在追 Harness 这个概念，Google 一句没说——不是它没本事，是它根本瞧不上。它掏出的是一整套 Agent 全家桶，五层通吃。为了证明能打，它搬出了一个你绝对想不到的客户——下一代 Siri 就是基于 Google 的 AI 在训练。这事对你我意味着什么？AI 不再是'要不要用'，而是'怎么管'。"

这 13 句话就是那 13 页 slides 的标题。

---

## 一行命令把它和搭档 `frontend-slides` 都装好

```bash
bash <(curl -sSL https://raw.githubusercontent.com/yboolez/marketing-writer/main/install.sh)
```

或手动：

```bash
mkdir -p ~/.claude/skills
git clone https://github.com/yboolez/marketing-writer ~/.claude/skills/marketing-writer
[ -d ~/.claude/skills/frontend-slides ] || \
  git clone https://github.com/zarazhangrui/frontend-slides ~/.claude/skills/frontend-slides
```

装好后重启 Claude Code。

---

## `marketing-writer` 决定说什么，`frontend-slides` 负责把它渲染成好看的 HTML

两个 skill 正交，分工很清楚：

| 技能 | 负责 |
|------|------|
| `marketing-writer` | 标题串、叙事结构、销售话术、每页内容分层 |
| `frontend-slides` | HTML 视觉渲染、动画、排版、配色 |

`marketing-writer` Phase 5 会直接调 `frontend-slides` 渲染——你不用手动接。没装 `frontend-slides` 照样能出纯文案 Markdown，但视觉那部分会降级。

---

## 唤起它最短的一句话是「说人话」

触发方式：

- `/marketing-writer`
- `/营销文案`
- `/说人话` ← 最短
- 自然语言：「帮我写 pitch deck」「做个落地页」「写个营销 slides」「把这个写成对外宣传」

---

## 标题张力、素材维度、金句标准借自 [dbs](https://github.com/dontbesilent2025/dbskill)——slides 场景不适用的部分已经挑出去了

dbs 是 dontbesilent 的商业/内容工具箱，针对小红书、短视频场景。`marketing-writer` 只保留了在 slides/落地页上同样适用的部分：

- ✅ 击中真实痛点（铁律 3）
- ✅ 张力 6 选 2（铁律 4）
- ✅ 话题 + Hook + 可信度（Hero 公式）
- ✅ 素材 5 维度 + 金句 3 标准
- ⚠️ 口播友好——只保留给 pitch deck（会被念出来的场景）
- ❌ "留悬念=不让观众知道答案"——slides 是顺序展示不是 feed 流，已经换成「展示 vs 悬念」表按页面角色判断
- ❌ "扩大话题=扩大算法流量池"——slides 没有推送算法，本 skill 信条 4（说人话）已经覆盖了底层原则

---

## 装起来，下次做 deck 就不用从空白开始

```bash
bash <(curl -sSL https://raw.githubusercontent.com/yboolez/marketing-writer/main/install.sh)
```

---

## License

MIT
