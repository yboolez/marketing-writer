# GTM-deck-writer

一个很会说人话的写手。写文案、做slides、做落地页。

> A Claude Code skill that makes your slide titles read like a sales pitch, not a corporate table of contents.

---

## AI 写的 deck 标题全是名词短语，像目录

`我们的解决方案 / 核心优势 / 客户案例 / 联系我们`——所有标题连读像一张目录，不像有人在说话。真实的销售不是这么讲的。

---

## 这个 skill 让你的标题连读像一段销售话术

每页标题是**一句完整的话**，连起来读是一段连贯的故事：

> 「我们做的这件事，市场上还没人做好 / 因为大家都在用错误的方式解决它 / 我们试了 3 条路才找到现在这个方案 / 它和同类产品最大的区别是 X / 已经有 Y 家客户在用并拿到了 Z 结果 / 现在合作你能拿到的是...」

每页正文只是把标题展开。

---

## 看它给 [Orze](https://orze.ai) 写的落地页

9 个 section 的 H2 标题，按顺序连读：

> "你的专有数据，值得一个永不停歇的研究团队。你有数据、有 GPU，却很难把它们变成竞争壁垒。Orze 替你 24/7 跑实验，让每次失败自动变成下次的养料。闭环四步，不停直到第一。我们已经帮两家公司做到了各自赛道全球第一。不只是跑更多实验，Orze 能自主转换研究路线。数据永不外发，合规无忧。三种部署选项。你的下一个赛道第一，从这里开始。"

每一句都能独立成立，连起来是一段完整的销售推介——这就是 skill 的默认输出。

---

## 先写标题串，读顺了再展开正文

skill 启动后会主动问 7 件事（产品 / 受众 / 目标格式 / 品牌 / 视觉素材 / 源文件 / 风格偏好），然后：

1. 按 5 维度（数据 / 故事 / 金句 / 权威 / 痛点）检查素材够不够撑叙事
2. **只写标题，不写正文**，一页一个
3. 连读自查——标题串像不像一段话术？Hero 那句有没有金句感？
4. 展开正文 + 视觉建议
5. 渲染 HTML 并打开；按需导出 PDF / 长图 / 朋友圈 9 图 / 小红书多图

---

## 一份内容能给你 4 种格式

不同的目标场景需要不同的页数、密度、长宽比——skill 在 Phase 1 就问清楚，按目标设计：

| 场景 | 格式 | 典型页数 |
|------|------|---------|
| 投资 pitch / 商务介绍 | 16:9 横版 | 10-15 页 |
| 朋友圈 9 宫格 | 9:16 竖版 | 9 张 |
| 小红书笔记 | 3:4 竖版 | ≤18 张 |
| 公众号长文 / 博客 | Markdown 段落 | 不限 |

> 同一张 33 行型号表，横版一页装得下，竖版要拆成 4 页或换成卡片堆叠。**换格式不是简单的尺寸切换，是重排重组。** skill 会帮你判断该怎么拆。

---

## 一行命令即刻安装

```bash
git clone https://github.com/yboolez/marketing-writer ~/.claude/skills/marketing-writer
```

装好后重启 Claude Code。触发：`/说人话`、`/GTM-deck-writer`、或自然语言「帮我写 pitch deck」「做个落地页」。

---

## 下次做 deck，不用从空白开始

```bash
git clone https://github.com/yboolez/marketing-writer ~/.claude/skills/marketing-writer
```

MIT License.

部分原则借鉴自 **[dbs](https://github.com/dontbesilent2025/dbskill)**（标题张力、素材 5 维度、Hero 公式）和 **[frontend-slides](https://github.com/zarazhangrui/frontend-slides)**（viewport fitting、信息密度、反 AI slop 美学）。
