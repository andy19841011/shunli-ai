# 順利 AI 製作

純靜態 GitHub Pages 網站，預計網址為 https://andy19841011.github.io/shunli-ai/。

## 日常修改

所有可替換設定都在 `assets/config.js`：

- `LINE_URL`：填入正式 LINE 連結。
- `GOOGLE_FORM_URL`：填入正式詢價表單連結。
- `CONTACT` 與 `SOCIAL_LINKS`：填入已確認的聯絡與社群資料；請勿放入假資料。
- `WORKS`：新增或更新六格案例。每筆都要有 `thumbnail`、`title`、`industry`、`need`、`solution`、`videoId`、`youtubeUrl`、`placeholder`。正式 YouTube 案例設為 `placeholder: false`，並填入影片 ID 和完整 YouTube URL；未有正式作品時維持 `placeholder: true` 與空白影片欄位。

首頁 title、description、canonical、Open Graph、Twitter Card 和 JSON-LD 位於 `index.html`。日後更換網域時，同步更新 `assets/config.js` 的 `SITE_URL` 與 `index.html` 的 SEO URL。

## 本機檢查

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\site-static.test.ps1
node --check .\assets\app.js
git diff --check
python -m http.server 8787 --directory ..
```

之後開啟 `http://127.0.0.1:8787/shunli-ai/`。首頁初始不應有 YouTube iframe；只有正式案例的「查看影片」才會動態建立播放器。

## 發布到 GitHub Pages

1. 先執行 `gh auth login`，登入擁有 `andy19841011` 的 GitHub 帳號。
2. 建立獨立 repository `shunli-ai`，將本專案的 `main` branch 推送至該 remote。
3. 到該 repository 的 Settings → Pages，選擇 **Deploy from a branch**、`main`、`/(root)`。
4. 等待 Pages 部署完成後，驗證 https://andy19841011.github.io/shunli-ai/ 的 title、CSS、JS、robots.txt、sitemap.xml 與 canonical。

請勿把本專案檔案複製回順利分期網站；兩個 repository 應持續分離。
