#!/usr/bin/env bash
# 把 index.html 內所有外連到 fthealthy3.com 的圖片下載到 assets/，
# 並把 index.html 的引用改成本地路徑；之後 demo 就不再依賴原站是否在線。
# 用法：bash fetch-assets.sh
# 註：首輪已執行完畢並把檔案改成可讀檔名（見 assets/）；此腳本保留供日後新增圖片時使用。
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p assets

urls=$(grep -oE 'https://fthealthy3\.com/wp-content/uploads/[^"'"'"' )]+' index.html | sort -u)
total=$(echo "$urls" | grep -c . || true)
ok=0; fail=0
echo "found $total image url(s)"

for u in $urls; do
  # 檔名：路徑最後一段，URL 解碼後移除空白，避免中文編碼問題再加上短雜湊
  base=$(printf '%s' "${u##*/}" | python3 -c 'import sys,urllib.parse;print(urllib.parse.unquote(sys.stdin.read().strip()))')
  ext="${base##*.}"
  hash=$(printf '%s' "$u" | shasum | cut -c1-8)
  safe=$(printf '%s' "${base%.*}" | tr -c 'A-Za-z0-9._-\n' '_' | cut -c1-40)
  out="assets/${safe}-${hash}.${ext}"
  if [ -s "$out" ]; then
    ok=$((ok+1))
  elif curl -fsSL --max-time 60 --retry 2 -A "Mozilla/5.0" "$u" -o "$out"; then
    ok=$((ok+1)); echo "  ✓ $out"
  else
    fail=$((fail+1)); rm -f "$out"; echo "  ✗ $u"; continue
  fi
  # 改寫引用（用 python 做精確字串替換）
  python3 - "$u" "$out" <<'PY'
import sys
u,out=sys.argv[1],sys.argv[2]
p='index.html'; s=open(p,encoding='utf-8').read()
if u in s:
    open(p,'w',encoding='utf-8').write(s.replace(u,out))
PY
done

echo "done: $ok downloaded/rewritten, $fail failed"
[ "$fail" -eq 0 ] || exit 1
