# marketing-writer

一个很会说人话的写手。会写文案、做 PPT、做 HTML 落地页。

核心原则只有一条：**所有页面标题按顺序连读，必须是一段完整、顺畅、能打动客户的销售话术**——不是目录、不是名词短语。

> Turn product/project info into marketing copy — slides, landing pages, single-page nav sites, or plain text.
> Core rule: every page title reads as a sentence spoken TO the customer, and all titles connected form one coherent sales pitch.

---

## 触发方式 / Triggers

- `/marketing-writer`
- `/营销文案`
- `/说人话`
- 自然语言：「帮我写 pitch deck」「做个落地页」「写个营销 slides」「把这个写成对外宣传」「说人话」

---

## 安装 / Installation

### 一键安装脚本（推荐）

会自动把 `marketing-writer` 和配套的 `frontend-slides` 一起装好：

```bash
bash <(curl -sSL https://raw.githubusercontent.com/yboolez/marketing-writer/main/install.sh)
```

### 手动安装

```bash
mkdir -p ~/.claude/skills

# 主 skill
git clone https://github.com/yboolez/marketing-writer ~/.claude/skills/marketing-writer

# 配套 skill（如果还没装）
[ -d ~/.claude/skills/frontend-slides ] || \
  git clone https://github.com/zarazhangrui/frontend-slides ~/.claude/skills/frontend-slides
```

装好后重启 Claude Code 即可。

---

## 配套技能 / Companion Skill

**强烈建议同时安装** [`frontend-slides`](https://github.com/zarazhangrui/frontend-slides)。

两者分工：

| 技能 | 职责 |
|------|------|
| `marketing-writer` | 写**什么**——标题串、叙事结构、销售话术、内容层级 |
| `frontend-slides` | 写**成什么样**——HTML slides/落地页的视觉渲染、动画、排版 |

当用户让做 slides 或落地页时，`marketing-writer` 定完文案和结构后会直接调 `frontend-slides` 渲染成 HTML。没装 `frontend-slides` 依然能出纯文案 Markdown，但视觉部分会降级。

---

## 它在干什么 / What it does

输入：产品/项目/文章/任何想对外讲的东西
输出：能打的营销物料（slides / 落地页 / 纯文案）

流程：

1. **接素材、判形式**——slides？单页站？纯文案？素材够不够撑叙事？
2. **先写标题串**（不写正文）——一页一个标题，每个是**说给受众听的一句完整的话**
3. **自查金句感**——唯一硬性自查：标题连读是不是一段好话术？Hero 那句有没有金句感？
4. **展开每页正文**——最少必要的文字 + 视觉建议（视频 > 动画 > 图 > 无）
5. **交付**——要 slides/落地页就直接调 `frontend-slides` 渲染并打开，不停下来问

### 核心信条

1. **标题串 = 一段完整销售话术**——不是 `产品介绍 / 核心功能 / 客户案例`，而是 `我们做的这件事市场上还没人做好 / 因为大家都在用错的方式解决它 / ...`
2. **每页标题是完整一句话**，不是名词短语
3. **每页正文只是展开标题**，很多页配张图就够
4. **说人话不说黑话**——目标是客户或用户，不是行业同行
5. **Hero 页 = 一句话说清做什么 + 产品工作中的视频/演示**

借鉴自 [dbs-xhs-title](https://github.com/warlockee/dbs-skills) 的标题铁律（留悬念 / 话题扩大 / 击中真痛点 / 张力 6 选 2）和 [dbs-hook](https://github.com/warlockee/dbs-skills) 的开头公式（话题 + Hook + 可信度）。

---

## License

MIT
