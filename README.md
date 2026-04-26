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
5. 要 slides 就渲染 HTML 并打开；要 PDF / 长图 / 朋友圈 9 图 / 小红书多图，按需勾选导出

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
```

装好后重启 Claude Code。

---

## 输出格式

一份 HTML 设计稿，按目标场景导出对应格式：

| 格式 | 命令 | 用途 |
|------|------|------|
| PDF (16:9 横版) | `export.sh <html> pdf` | 正式外发、PPT 风格 |
| 长图 (单张拼接) | `export.sh <html> long` | 微信群、文章内嵌 |
| 朋友圈 9 图 (9:16) | `export.sh <html> moments` | 朋友圈 9 宫格 |
| 小红书多图 (3:4) | `export.sh <html> xhs` | 小红书笔记（≤18 张） |

> 不同 format 不是简单的导出尺寸切换——是不同的内容设计。横屏一页能放下的 33 行表，竖屏要拆 4 页或换成卡片。skill 会根据目标格式重新决定每页放多少。

---

## 最短触发：「说人话」

- `/marketing-writer`
- `/营销文案`
- `/说人话`
- 自然语言：「帮我写 pitch deck」「做个落地页」「把这个写成对外宣传」

---

## 理论参考

部分原则借鉴自：

- **[dbs](https://github.com/dontbesilent2025/dbskill)**（dontbesilent 的内容工具箱）—— 标题张力检查、素材 5 维度、Hero 公式（话题 + Hook + 可信度）等
- **[frontend-slides](https://github.com/zarazhangrui/frontend-slides)** —— viewport fitting、信息密度上限、反 AI slop 美学

只挑了对营销 slides 场景通用的部分吸收进来，平台/媒介专用的没拿。

---

## License

MIT
