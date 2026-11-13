# 英文简历优化专家 · 固定链接发布目录

## 已上线的固定链接

```
https://github.com/boluke1/english-resume-optimizer-releases/raw/main/english-resume-optimizer-latest.zip
```

仓库：https://github.com/boluke1/english-resume-optimizer-releases （公开）
这条链接只依赖「账号 + 仓库 + 分支 + 路径」，每次覆盖 `english-resume-optimizer-latest.zip` 并 push 后，
**同一个链接就返回新内容**。发给别人的文案见 `分享文案.md`。

## 这个目录解决什么问题

专家分享链接（`?sharecode=...`）绑定的是**分享那一刻上传的 zip 快照**，专家更新后旧链接拿不到新版。本目录用「**固定文件名 + 固定位置 + 覆盖上传**」绕开这个限制：

- 接收者的链接永远不变
- 你每次发版只需覆盖同一个文件
- 靠 `VERSION.txt` 里的 SHA256 让双方确认拿到的是不是最新

## 文件说明

| 文件 | 作用 |
|------|------|
| `english-resume-optimizer-latest.zip` | **唯一对外分发的包**，文件名恒定，每次发版覆盖它 |
| `VERSION.txt` | 版本号、构建时间、文件数、SHA256 |
| `build.sh` | 发布者用：校验 → 注册 → 打包 → 覆盖 latest.zip → 写 VERSION.txt |
| `install.sh` | 接收者用：校验 SHA256 → 备份旧版 → 解压 → 注册，一条命令装好 |


> 目录里的 `english-resume-optimizer.zip` 是打包脚本的中转产物，**不要分发这个**。

## 我（发布者）如何更新

```bash
cd /Users/cuihang/WorkBuddy/2026-11-12-21-03-51/dist-latest
./build.sh
```

跑完会打印新版本号与 SHA256，`english-resume-optimizer-latest.zip` 已被覆盖。然后二选一上传到固定位置：

**方式一：Git 仓库（推荐，链接最稳定）**

```bash
git add -A && git commit -m "release v1.1.0" && git push
```

发给别人这个地址（把仓库换成你的）：

```
https://github.com/<你的账号>/<仓库>/raw/main/dist-latest/english-resume-optimizer-latest.zip
```

这个 URL 只依赖「账号 + 仓库 + 分支 + 路径」，你推新提交后**同一个 URL 就返回新文件**，链接永不改变。

**方式二：网盘 / 腾讯文档**

把 `english-resume-optimizer-latest.zip` 上传一次，拿到分享链接；以后每次都**对同一个文件做覆盖上传**（不要新建文件），分享链接保持不变。

## 接收者如何安装

一句话版（macOS/Linux，下载完整个目录或至少这三个文件：zip + VERSION.txt + install.sh）：

```bash
./install.sh
```

脚本会先比对 SHA256（不一致直接拒绝，防止拿到旧缓存），再把 `english-resume-optimizer/` 解压到
`~/.workbuddy/plugins/marketplaces/my-experts/plugins/` 并自动注册。**旧版本不会被删除**，会被改名为
`english-resume-optimizer.bak-<时间戳>` 保留，出问题可回滚。

手动版：

1. 打开你给的固定链接，下载 `english-resume-optimizer-latest.zip`
2. 解压，把 `english-resume-optimizer/` 整个目录放到：
   - macOS/Linux：`~/.workbuddy/plugins/marketplaces/my-experts/plugins/`
   - Windows：`%USERPROFILE%\.workbuddy\plugins\marketplaces\my-experts\plugins\`
3. 重启 WorkBuddy，在「专家中心 → 我的专家」里即可看到「伊莲娜 · 英文简历优化专家」
4. 若未出现，在该目录下执行注册（需本机有 expert-manager 技能）：
   ```bash
   python3 <expert-manager>/scripts/register_expert.py ./english-resume-optimizer
   ```

## 如何确认自己拿到的是最新版

对照 `VERSION.txt`：

```bash
shasum -a 256 english-resume-optimizer-latest.zip
```

与你发布页上的 `sha256` 一致，即为最新。不一致说明拿到的是旧缓存，重新下载一次。

## 当前版本

见同目录 `VERSION.txt`。
