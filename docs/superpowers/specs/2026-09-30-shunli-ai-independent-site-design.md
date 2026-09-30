# 順利 AI 製作｜獨立 GitHub Pages 網站設計

**日期：** 2026-09-30
**狀態：** 使用者已提供並確認需求，待實作計畫核可

## 範圍與隔離

- 新網站是獨立本機 Git repository：`C:\Users\Admin\Desktop\順利AI製作團隊\shunli-ai`。
- 預計 GitHub repository 為 `andy19841011/shunli-ai`，正式 project-site URL 為 `https://andy19841011.github.io/shunli-ai/`。
- `shunli-fenqi` 完全維持現況：不修改首頁、金融 SEO 子頁、robots、sitemap、canonical、remote 或 GitHub Pages 設定。
- 在 GitHub CLI 未登入的目前狀態，只建立與驗證本機版本；遠端建立與推送留待使用者明確執行登入後的下一步。

## 技術架構

- HTML5、CSS、Vanilla JavaScript 的純靜態 GitHub Pages 專案；不引入 Node、框架、後端、資料庫、CMS、登入或建置程序。
- `index.html` 只負責語意內容、metadata 與 JSON-LD；`assets/styles.css` 負責 mobile-first 視覺；`assets/config.js` 集中所有可替換資料；`assets/app.js` 負責渲染作品、選單、延遲影片 modal 與互動。
- `assets/config.js` 是唯一聯絡與作品資料來源：`SITE_URL`、`BRAND_NAME`、`LINE_URL`、`GOOGLE_FORM_URL`、`CONTACT`、社群連結、六筆案例資料。所有未知聯絡資料維持空值或明確 placeholder，不能補造地址、電話、星等或評價。
- HTML 以相對路徑引用 CSS、JS、圖片；JS 以 `SITE_URL` 組合分享／結構化網址。禁止 AI 網站內出現 `/shunli-fenqi/`。

## 首頁資訊架構

1. Hero：H1「高雄 AI 影片製作」、指定副標與「用更低的製作門檻、更彈性的方式…」文案，CTA「查看作品／立即詢價」。
2. 客戶痛點：六個指定情境的短句卡片。
3. 六項服務：AI 口播、房仲短影音、商品廣告、品牌形象、AI 人物建模、真人影片 AI 延伸。
4. 六格作品案例：每筆都有 `thumbnail`、`title`、`industry`、`need`、`solution`、`videoId`、`youtubeUrl`、`placeholder`；未知資料使用清楚的 placeholder，且不宣稱客戶、公司、評價、業績、營收或成效。
5. 適合產業：房仲、保險、中小企業、電商、餐飲、個人品牌、在地商家。
6. 傳統影片 vs AI 影片：拍攝需求、人物出鏡、修改彈性、內容產量、製作流程的中性比較；不寫價格、節省比例、速度或成效倍率。
7. 流程：提供需求 → 確認腳本 → 視覺規劃 → AI 影片製作 → 修改 → 成品交付。
8. FAQ：完整涵蓋指定的八個問題。
9. 最終 CTA：「你的產業適合使用 AI 影片嗎？」與「立即諮詢／加入 LINE」。
10. Footer：品牌、定位「高雄 AI 影片製作」及由設定檔驅動的聯絡方式。

## 影片載入與可用性

- 首頁初始 DOM 不得有 YouTube iframe，且不自動播放任何案例。
- 僅當使用者點擊有效案例的「查看影片」時，才以 `videoId` 動態建立一個 iframe；關閉 modal 時移除其 `src` 和 iframe。
- placeholder 案例沒有播放按鈕，不建立 iframe。
- 縮圖全部使用 `loading="lazy"`；保留鍵盤焦點、Escape 關閉 modal、焦點回復與 `prefers-reduced-motion`。

## SEO

- 首頁 title：`高雄 AI 影片製作｜AI口播・房仲短影音・商品廣告｜順利 AI 製作`。
- meta description：`順利 AI 製作提供高雄 AI 影片製作、AI 口播、房仲短影音、商品廣告、品牌影片與 AI 人物建模服務，協助中小企業與個人品牌降低影片製作門檻並持續產出內容。`
- canonical、Open Graph 與 Twitter Card 均使用 `https://andy19841011.github.io/shunli-ai/`；另提供使用者指定的十個繁中關鍵字。
- 新 repo 根目錄建立 robots.txt 與 sitemap.xml，僅列新首頁；在實際文章建立前不建立或索引薄內容。
- JSON-LD 用 `@graph`，含 `ProfessionalService`、六筆 `Service`、`FAQPage`。地區可使用高雄／台灣合作，無正式資料不得輸出地址、電話、rating、review 或虛構客戶資料。
- 只建立 `articles/README.md`，說明未來文章建立後要補 metadata、canonical、JSON-LD 和 sitemap。

## 視覺與驗證

- 深色、灰銀、少量高亮、留白充足，案例卡成為首頁視覺主角；避免金融網站樣式及過量文字。
- 檢查 1440、1024、768、430、390、375px，無水平溢出；檢查 console、anchors、各資源路徑、robots、sitemap、canonical 與 JSON-LD。
- 執行 `node --check assets/app.js`、`git diff --check`、適用的 PowerShell 靜態測試，並以本機 HTTP server 在 `/shunli-ai/` path 下驗證首頁與點擊後才建立 iframe。

## 非目標

- 不建立遠端 GitHub repository、不 push、不變更 Pages，直到本機版完成且使用者執行 GitHub 登入／授權下一步。
- 不在此階段建立空白文章頁、虛構作品、價格或任何第三方追蹤。
