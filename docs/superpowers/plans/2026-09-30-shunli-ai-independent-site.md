# 順利 AI 製作獨立網站 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 建立可部署到 GitHub Pages project site 的「順利 AI 製作」獨立、轉換導向靜態網站。

**Architecture:** 以 `config.js` 做網站資料的單一來源，HTML 提供靜態結構、SEO 與結構化資料，Vanilla JS 依設定安全渲染案例與延遲建立影片播放器。所有站內檔案使用相對 URL，可由 `/shunli-ai/` 提供而不依賴舊站。

**Tech Stack:** HTML5、CSS custom properties、Vanilla JavaScript、PowerShell 靜態檢查、Node.js syntax check。

**Spec:** `docs/superpowers/specs/2026-09-30-shunli-ai-independent-site-design.md`

## Global Constraints

- 僅修改 `C:\Users\Admin\Desktop\順利AI製作團隊\shunli-ai`；不得讀寫或引用 `shunli-fenqi` 的網站檔案。
- 使用純靜態 HTML5、CSS、Vanilla JavaScript；不導入框架、Node build system、後端、資料庫、CMS 或登入。
- `SITE_URL` 固定為 `https://andy19841011.github.io/shunli-ai/`，所有 SEO URL 必須指向此站。
- 不虛構客戶、公司、評價、地址、電話、星等、價格、成效或營收；未知聯絡與案例資料維持 placeholder。
- 首頁初始 DOM 不得存在 YouTube iframe；只在點擊有效案例後建立，關閉時清除。
- 所有圖片 lazy loading，並通過 1440、1024、768、430、390、375px 的無水平溢出驗證。

## Review Focus

- 空白 LINE／Google Form 設定時，CTA 應顯示明確待設定狀態且不導向假網址。
- `placeholder: true` 或不含有效 videoId 的案例不得產生播放按鈕或 iframe。
- 案例標題與需求文字含 HTML 字元時，必須以 textContent 渲染，不能插入未轉義 HTML。
- Base URL 為 `/shunli-ai/` 時，CSS、JS、logo、sitemap、canonical 與結構化資料都不得指向舊站。
- 行動版選單、modal、焦點與 Escape 關閉在鍵盤使用時可正常運作。

---

### Task 1: 靜態測試基線與集中設定

**Files:**
- Create: `tests/site-static.test.ps1`
- Create: `assets/config.js`

**Interfaces:**
- Produces: `window.SHUNLI_AI_CONFIG` with `SITE_URL`, `BRAND_NAME`, `LINE_URL`, `GOOGLE_FORM_URL`, `CONTACT`, `SOCIAL_LINKS`, `WORKS`.
- Consumes: no earlier code.

- [ ] **Step 1: 寫入失敗的 PowerShell 靜態測試**

檢查設定檔存在，`SITE_URL` 等於新站 URL，六筆 `WORKS` 都具有指定八個欄位，並且專案任何文字檔沒有 `/shunli-fenqi/`。

- [ ] **Step 2: 執行基線測試確認失敗**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\site-static.test.ps1`

Expected: FAIL because `assets/config.js` does not exist.

- [ ] **Step 3: 建立 `assets/config.js`**

建立唯讀常數物件。`LINE_URL`、`GOOGLE_FORM_URL` 與各 `CONTACT` 欄位使用空字串；`WORKS` 提供六個完整 placeholder 物件，`placeholder: true`，不放虛構案例、影片 ID 或連結。

- [ ] **Step 4: 執行基線測試確認通過**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\site-static.test.ps1`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add assets/config.js tests/site-static.test.ps1
git commit -m "feat: add site configuration and static checks"
```

### Task 2: 建立首頁、SEO 與可擴充文章說明

**Files:**
- Create: `index.html`
- Create: `robots.txt`
- Create: `sitemap.xml`
- Create: `articles/README.md`
- Modify: `tests/site-static.test.ps1`

**Interfaces:**
- Consumes: `window.SHUNLI_AI_CONFIG` loaded before `assets/app.js`.
- Produces: all specified section IDs, `#works-grid`, `#work-modal-root`, and contact CTA nodes marked with `data-contact-action`.

- [ ] **Step 1: 擴寫失敗測試**

加入 title、description、canonical、OG、Twitter、指定關鍵字、六個首頁區塊、八筆 FAQ、`ProfessionalService`／`Service`／`FAQPage` JSON-LD、robots sitemap 指向與 sitemap URL 的文字斷言；確保初始 HTML 沒有 `<iframe` 與舊站路徑。

- [ ] **Step 2: 執行測試確認失敗**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\site-static.test.ps1`

Expected: FAIL because homepage and SEO files do not exist.

- [ ] **Step 3: 建立語意首頁與 SEO 檔案**

在 `index.html` 寫入指定 Hero、痛點、服務、案例容器、產業、比較、流程、FAQ、CTA、Footer；連入 `assets/styles.css`、`assets/config.js`、`assets/app.js`。JSON-LD 的網站 URL 必須使用新 URL，聯絡資訊不寫假資料。建立只列首頁的 sitemap 和根目錄 robots；`articles/README.md` 只說明真實文章日後的新增步驟。

- [ ] **Step 4: 執行測試確認通過**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\site-static.test.ps1`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add index.html robots.txt sitemap.xml articles/README.md tests/site-static.test.ps1
git commit -m "feat: add SEO-ready landing page structure"
```

### Task 3: 完成 mobile-first 視覺與案例互動

**Files:**
- Create: `assets/styles.css`
- Create: `assets/app.js`
- Modify: `tests/site-static.test.ps1`

**Interfaces:**
- Consumes: `window.SHUNLI_AI_CONFIG.WORKS`, `#works-grid`, `#work-modal-root`, `[data-contact-action]`.
- Produces: `window.ShunliAIApp.renderWorks(works)`, `openWorkModal(work)`, `closeWorkModal()` and no iframe before valid play action.

- [ ] **Step 1: 擴寫失敗測試**

加入 `node --check assets/app.js` 子程序斷言，檢查 `loading="lazy"`、placeholder 判斷、以 DOM API 建立 iframe、關閉時移除 iframe／src，以及所有六個斷點 CSS 規則和 `overflow-x: hidden`。

- [ ] **Step 2: 執行測試確認失敗**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\site-static.test.ps1`

Expected: FAIL because JS and CSS do not exist.

- [ ] **Step 3: 實作 `assets/app.js`**

以 DOM API 與 `textContent` 渲染六格案例，並公開唯讀測試入口 `window.ShunliAIApp.renderWorks(works)`。只有 `placeholder === false` 且具有效 `videoId`／`youtubeUrl` 才渲染「查看影片」按鈕；按鈕建立可關閉的 modal 和一個 YouTube iframe。空聯絡連結顯示設定提示，並實作行動選單、Escape、焦點回復。

- [ ] **Step 4: 實作 `assets/styles.css`**

用深灰、銀色與小範圍亮色建立案例優先、mobile-first 版面；實作所有 1440、1024、768、430、390、375px 需要的斷點、可見焦點與 reduced-motion。

- [ ] **Step 5: 執行靜態與語法測試確認通過**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\site-static.test.ps1; node --check .\assets\app.js; git diff --check`

Expected: all commands exit 0.

- [ ] **Step 6: Commit**

```bash
git add assets/app.js assets/styles.css tests/site-static.test.ps1
git commit -m "feat: add responsive works-first interaction"
```

### Task 4: 瀏覽器、GitHub Pages 子路徑與發佈前驗證

**Files:**
- Modify: `tests/site-static.test.ps1` only if an observed regression requires an assertion.

**Interfaces:**
- Consumes: finished static site.
- Produces: a verification record; no remote side effects.

- [ ] **Step 1: 在 `/shunli-ai/` base path 開啟本機 HTTP server**

Run a local static server whose URL contains `/shunli-ai/`, then load its homepage.

- [ ] **Step 2: 完成桌面與行動版瀏覽器檢查**

At 1440, 1024, 768, 430, 390, and 375px check console errors, document horizontal overflow, all anchors, CSS/JS paths, visible content, mobile menu, placeholder cases, and focus behavior.

- [ ] **Step 3: 驗證延遲影片載入**

Before interaction assert zero YouTube iframe; verify each placeholder has no play control; invoke `window.ShunliAIApp.renderWorks([{ thumbnail: '', title: '測試案例', industry: '測試', need: '測試', solution: '測試', videoId: 'dQw4w9WgXcQ', youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', placeholder: false }])`, click play and assert one iframe appears, then close and assert zero remain. Restore the six configured placeholders before ending the check.

- [ ] **Step 4: 執行最終檢查**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\site-static.test.ps1; node --check .\assets\app.js; git diff --check; git status --short`

Expected: all validation commands exit 0; only intentionally uncommitted verification fixes, if any, may be present.

- [ ] **Step 5: Commit verification fixes if required**

```bash
git add tests/site-static.test.ps1 assets index.html robots.txt sitemap.xml articles
git commit -m "test: verify GitHub Pages static site"
```

### Task 5: 本機交付與 GitHub Pages 發佈指引

**Files:**
- Create: `README.md`

**Interfaces:**
- Consumes: `assets/config.js` and project structure.
- Produces: exact location for LINE, Form, SEO, YouTube cases, and GitHub Pages publication instructions.

- [ ] **Step 1: 寫入失敗測試**

加入 README 存在、含 config 修改位置、獨立 repo、GitHub Pages `main`／root 發佈與預計正式網址的斷言。

- [ ] **Step 2: 執行測試確認失敗**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\site-static.test.ps1`

Expected: FAIL because README does not exist.

- [ ] **Step 3: 建立 `README.md`**

說明 `assets/config.js` 如何替換 LINE／Google Form／聯絡與六格作品；說明 SEO metadata 位於 `index.html`；說明 `gh auth login` 後建立 private/public `shunli-ai`、push `main`、GitHub Pages 設為 Deploy from branch / main / root、再確認預計 URL。

- [ ] **Step 4: 執行完整驗證確認通過**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\site-static.test.ps1; node --check .\assets\app.js; git diff --check`

Expected: all commands exit 0.

- [ ] **Step 5: Commit**

```bash
git add README.md tests/site-static.test.ps1
git commit -m "docs: add configuration and deployment guide"
```
