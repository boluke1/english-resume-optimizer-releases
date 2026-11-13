#!/bin/bash
# 英文简历优化专家 - 发布构建脚本
# 用法: ./build.sh [专家目录]
# 作用: 校验 → 注册 → 打包 → 覆盖 english-resume-optimizer-latest.zip（文件名恒定）
#       → 写入 VERSION.txt（版本 / 时间 / 文件数 / SHA256）
set -euo pipefail

EXPERT_DIR="${1:-$HOME/.workbuddy/plugins/marketplaces/my-experts/plugins/english-resume-optimizer}"
OUT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="/Applications/WorkBuddy.app/Contents/Resources/app.asar.unpacked/resources/plugins/workbuddy-builtin/skills/expert-manager"

ZIP_SRC="$OUT_DIR/english-resume-optimizer.zip"
ZIP_FIXED="$OUT_DIR/english-resume-optimizer-latest.zip"

echo "==> 专家目录: $EXPERT_DIR"
[ -d "$EXPERT_DIR" ] || { echo "✗ 专家目录不存在"; exit 1; }

echo "==> 1/4 校验"
python3 "$SKILL_DIR/scripts/validate_expert.py" "$EXPERT_DIR"

echo "==> 2/4 注册"
python3 "$SKILL_DIR/scripts/register_expert.py" "$EXPERT_DIR"

echo "==> 3/4 打包"
python3 "$SKILL_DIR/scripts/package_expert.py" "$EXPERT_DIR" "$OUT_DIR"

echo "==> 4/4 覆盖固定文件名"
cp "$ZIP_SRC" "$ZIP_FIXED"

VER=$(python3 -c "import json,sys;print(json.load(open('$EXPERT_DIR/.codebuddy-plugin/plugin.json'))['version'])")
SHA=$(shasum -a 256 "$ZIP_FIXED" | cut -d' ' -f1)
FILES=$(unzip -Z1 "$ZIP_FIXED" | grep -c -v '/$')
BUILT=$(date '+%Y-%m-%dT%H:%M:%S%z')
SIZE=$(python3 -c "import os;print('%.1fMB' % (os.path.getsize('$ZIP_FIXED')/1048576))")

cat > "$OUT_DIR/VERSION.txt" <<EOF
version: $VER
built_at: $BUILT
files: $FILES
size: $SIZE
sha256: $SHA
zip: english-resume-optimizer-latest.zip

# 接收者核对方式（macOS/Linux）:
#   shasum -a 256 english-resume-optimizer-latest.zip
# 两者一致即为你拿到的是最新版。
EOF

echo
echo "✅ 完成"
echo "   文件: $ZIP_FIXED"
echo "   版本: $VER  文件数: $FILES  大小: $SIZE"
echo "   SHA256: $SHA"
echo
echo "下一步：把这个文件（连同 VERSION.txt）覆盖上传到固定的分享位置。"
echo "  Git : git add -A && git commit -m \"release v$VER\" && git push   → raw 链接不变"
echo "  网盘: 对同一文件覆盖上传                                          → 分享链接不变"
