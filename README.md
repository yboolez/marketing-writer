# marketing-writer

一个很会说人话的写手。写文案、做 PPT、做落地页。

> A Claude Code skill that makes your slide titles read like a sales pitch, not a corporate table of contents.

---

## 让 slides 标题读起来像一段销售话术

AI 生成的 deck 标题长得都一样：`我们的解决方案 / 核心优势 / 客户案例 / 联系我们`。每一页都是名词短语，所有标题连读像一张目录，不像有人在说话。真实的销售不是这么讲的。

---

## 每页标题是说给客户听的一句话

换成这样：

> 「我们做的这件事，市场上还没人做好 / 因为大家都在用错误的方式解决它 / 我们试了 3 条路才找到现在这个方案 / ...」

每页标题是一句完整的话，连起来读是一段连贯的故事。每页正文只是把标题展开。

---

## 先写标题串，连读顺了再展开正文

流程 5 步：

1. 接素材，按 5 维度（数据 / 故事 / 金句 / 权威 / 痛点）检查够不够写
2. 只写标题，不写正文，一页一个
3. 连读自查——标题串像不像一段话术？Hero 那句有没有金句感？
4. 展开正文 + 视觉建议
5. 要 slides 就直接调 `frontend-slides` 渲染并打开，不再问你

---

## 看它给 [Orze](https://orze.ai) 写的落地页

9 个 section 的 H2 标题，按顺序连读：

> "你的专有数据，值得一个永不停歇的研究团队。你有数据、有 GPU，却很难把它们变成竞争壁垒。Orze 替你 24/7 跑实验，让每次失败自动变成下次的养料。闭环四步，不停直到第一。我们已经帮两家公司做到了各自赛道全球第一。不只是跑更多实验，Orze 能自主转换研究路线。数据永不外发，合规无忧。三种部署选项。你的下一个赛道第一，从这里开始。"

每一句都是一句话，连起来是一段完整的销售推介——这就是 marketing-writer 的默认输出。

---

## 一行命令装好

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

## 一个决定说什么，一个负责怎么呈现

| 技能 | 负责 |
|------|------|
| `marketing-writer` | 标题串、叙事结构、销售话术 |
| `frontend-slides` | HTML 渲染、动画、排版 |

`marketing-writer` Phase 5 会直接调 `frontend-slides`，你不用手动接。没装 `frontend-slides` 也能出纯 Markdown 文案。

---

## 最短触发：「说人话」

- `/marketing-writer`
- `/营销文案`
- `/说人话`
- 自然语言：「帮我写 pitch deck」「做个落地页」「把这个写成对外宣传」

---

## 理论借自 [dbs](https://github.com/dontbesilent2025/dbskill)，不适用 slides 的已挑掉

dbs 是 dontbesilent 的商业/内容工具箱，原本针对小红书、短视频。`marketing-writer` 只留了 slides 场景通用的：

- ✅ 击中真实痛点
- ✅ 标题张力 6 选 2
- ✅ 开头公式：话题 + Hook + 可信度
- ✅ 素材 5 维度 + 金句 3 标准
- ⚠️ 口播友好——只对 pitch deck 适用（落地页没人念）
- ❌ feed 算法相关的铁律（slides 没有推送算法）

---

## 下次做 deck，不用从空白开始

```bash
bash <(curl -sSL https://raw.githubusercontent.com/yboolez/marketing-writer/main/install.sh)
```

---

## License

MIT
