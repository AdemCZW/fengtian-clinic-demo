# 豐田之山診所｜豐田精誠診所 — 首頁 Demo

單一 HTML 檔的首頁設計提案（暖色調、細膩捲動動效、RWD）。

- 線上預覽：https://ademczw.github.io/fengtian-clinic-demo/
- 本機預覽：直接用瀏覽器開啟 `index.html`，或 `npx http-server . -p 4321`
- 靜態截圖模式：在網址後加 `?snap=1&y=2400`（關閉動效、跳到指定捲動位置）

## 內容來源
文字與圖片取自 fthealthy3.com 首頁；圖片已下載至 `assets/`，不再外連。
醫療團隊區為版面示意，姓名／照片／學經歷待院方提供。
健檢專案的說明文字為依專案名稱撰寫的示意稿，項目明細以院方為準。

## 檔案
- `index.html` — 全部程式碼（CSS / JS 內嵌）
- `assets/` — 圖片
- `fetch-assets.sh` — 若日後 index.html 內又引用外站圖片，可再執行把圖片抓回本地
