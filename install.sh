#!/bin/bash
# 英文简历优化专家 - 接收者安装脚本
# 用法: ./install.sh [zip 路径]
# 作用: 校验 SHA256 → 备份旧版本目录 → 解压安装 → 注册
# 特点: 不删除任何已有文件，旧版本一律改名备份
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ZIP="${1:-$HERE/english-resume-optimizer-latest.zip}"
PLUGINS_DIR="$HOME/.workbuddy/plugins/marketplaces/my-experts/plugins"
TARGET="$PLUGINS_DIR/english-resume-optimizer"
SKILL_DIR="/Applications/WorkBuddy.app/Contents/Resources/app.asar.unpacked/resources/plugins/workbuddy-builtin/skills/expert-manager"

[ -f "$ZIP" ] || { echo "✗ 找不到压缩包: $ZIP"; exit 1; }

echo "==> 1/4 校验压缩包"
EXPECTED=$(awk -F': ' '/^sha256:/{print $2}' "$HERE/VERSION.txt" 2>/dev/null || true)
ACTUAL=$(shasum -a 256 "$ZIP" | cut -d' ' -f1)
if [ -n "$EXPECTED" ] && [ "$EXPECTED" != "$ACTUAL" ]; then
  echo "✗ SHA256 不一致，可能是旧缓存或文件损坏"
  echo "  期望: $EXPECTED"
  echo "  实际: $ACTUAL"
  echo "  请重新下载后再试"
  exit 1
fi
[ -n "$EXPECTED" ] && echo "    SHA256 一致 ✓" || echo "    未找到 VERSION.txt，跳过比对"

echo "==> 2/4 准备安装目录"
mkdir -p "$PLUGINS_DIR"
if [ -d "$TARGET" ]; then
  BAK="$TARGET.bak-$(date '+%Y%m%d%H%M%S')"
  mv "$TARGET" "$BAK"
  echo "    已把旧版本移到: $BAK（未删除，可自行清理）"
fi

echo "==> 3/4 解压（直接解到插件目录，包内顶层即为 english-resume-optimizer/）"
unzip -q "$ZIP" -d "$PLUGINS_DIR"
[ -d "$TARGET/.codebuddy-plugin" ] || { echo "✗ 解压后结构异常，未找到 .codebuddy-plugin"; exit 1; }
echo "    已安装到: $TARGET"

echo "==> 4/4 注册"
if [ -f "$SKILL_DIR/scripts/register_expert.py" ]; then
  python3 "$SKILL_DIR/scripts/register_expert.py" "$TARGET"
else
  echo "    未找到 expert-manager 技能，跳过自动注册"
  echo "    请手动在 WorkBuddy 中重启后查看「专家中心 → 我的专家」"
fi

echo
echo "✅ 安装完成，重启 WorkBuddy 后在「专家中心 → 我的专家」查看「伊莲娜 · 英文简历优化专家」"
