$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$configPath = Join-Path $root 'assets\config.js'

if (-not (Test-Path $configPath)) {
  throw 'assets/config.js is required.'
}

$config = Get-Content -Raw $configPath

if ($config -notmatch "SITE_URL:\s*'https://andy19841011\.github\.io/shunli-ai/'") {
  throw 'SITE_URL must target the independent shunli-ai GitHub Pages project site.'
}

if ($config -notmatch "LINE_URL:\s*'https://lin\.ee/Ujvw1gm'") {
  throw 'LINE_URL must use the confirmed official LINE contact link.'
}

if ($config -notmatch "CONSULT_URL:\s*'https://lin\.ee/72VveZO'") {
  throw 'CONSULT_URL must use the confirmed consultation LINE link.'
}

if ($config -notmatch 'WORKS:\s*(?:Object\.freeze\()?\[') {
  throw 'WORKS must be defined in the centralized configuration.'
}

$publishedWorkCount = [regex]::Matches($config, 'placeholder:\s*false').Count
if ($publishedWorkCount -ne 6) {
  throw 'WORKS must provide six published YouTube cases.'
}

foreach ($field in @('thumbnail', 'title', 'industry', 'need', 'solution', 'description', 'services', 'platforms', 'videoId', 'youtubeUrl', 'placeholder')) {
  if ($config -notmatch "(?m)^\s*${field}:") {
    throw "WORKS entries must include $field."
  }
}

foreach ($videoId in @('I3rpcy-ociQ', 'ecoE66EEans', 'YA2uF6QWCwc', 'ijOjpwMHtYk', 'K5b3x7yBO_w', 'HaFmMfV1ScM')) {
  if ($config -notmatch "videoId:\s*'$videoId'") { throw "Missing confirmed YouTube case: $videoId" }
}

if ([regex]::Matches($config, 'description:\s*').Count -ne 6) { throw 'Each published case needs one SEO description.' }
if ([regex]::Matches($config, 'services:\s*\[').Count -ne 6) { throw 'Each published case needs service labels.' }
if ([regex]::Matches($config, 'platforms:\s*\[').Count -ne 6) { throw 'Each published case needs platform labels.' }

$textFiles = @(
  Get-ChildItem -Path (Join-Path $root 'assets') -Recurse -File -Include *.html,*.css,*.js,*.xml,*.txt,*.md
  Get-ChildItem -Path (Join-Path $root 'articles') -Recurse -File -Include *.html,*.css,*.js,*.xml,*.txt,*.md -ErrorAction SilentlyContinue
  Get-Item -LiteralPath (Join-Path $root 'index.html'), (Join-Path $root 'robots.txt'), (Join-Path $root 'sitemap.xml') -ErrorAction SilentlyContinue
)
foreach ($file in $textFiles) {
  if ((Get-Content -Raw $file.FullName) -match '/shunli-fenqi/') {
    throw "Legacy site path found in $($file.FullName)."
  }
}

$indexPath = Join-Path $root 'index.html'
if (-not (Test-Path $indexPath)) { throw 'index.html is required.' }
$index = Get-Content -Raw $indexPath
foreach ($required in @(
  'https://andy19841011.github.io/shunli-ai/',
  'ProfessionalService', 'Service', 'FAQPage',
  'lang="zh-TW"', '<meta name="description"', '<link rel="canonical"',
  'id="pain-points"', 'id="services"', 'id="works"', 'id="industries"',
  'id="comparison"', 'id="process"', 'id="faq"', 'id="consult"'
)) {
  if ($index -notlike "*$required*") { throw "Homepage is missing required content: $required" }
}
if ($index -match '<iframe') { throw 'The initial homepage must not include an iframe.' }
if ([regex]::Matches($index, '<details>').Count -lt 8) { throw 'Homepage must include eight FAQ details.' }
if ($index -notlike '*<h1>高雄 <em>AI 影片<br>製作</em></h1>*') { throw 'Hero heading must preserve a deliberate desktop line break.' }

foreach ($path in @('robots.txt', 'sitemap.xml')) {
  if (-not (Test-Path (Join-Path $root $path))) { throw "$path is required." }
}
if ((Get-Content -Raw (Join-Path $root 'robots.txt')) -notlike '*Sitemap: https://andy19841011.github.io/shunli-ai/sitemap.xml*') { throw 'robots.txt must point to the new sitemap.' }
if ((Get-Content -Raw (Join-Path $root 'sitemap.xml')) -notlike '*https://andy19841011.github.io/shunli-ai/*') { throw 'sitemap.xml must point to the new project site.' }

$appPath = Join-Path $root 'assets\app.js'
$stylePath = Join-Path $root 'assets\styles.css'
if (-not (Test-Path $appPath)) { throw 'assets/app.js is required.' }
if (-not (Test-Path $stylePath)) { throw 'assets/styles.css is required.' }
$app = Get-Content -Raw $appPath
$style = Get-Content -Raw $stylePath
foreach ($required in @('createElement', 'loading', 'lazy', 'placeholder', 'ShunliAIApp', 'removeAttribute', 'CONSULT_URL')) {
  if ($app -notlike "*$required*") { throw "app.js is missing delayed-video behavior: $required" }
}
foreach ($required in @('work.description', 'work.services', 'work.platforms')) {
  if ($app -notlike "*$required*") { throw "app.js must render case SEO semantics: $required" }
}
if ($app -notlike '*document.getElementById(modal.dataset.trigger)?.focus()*') { throw 'Modal close must restore focus to its triggering control.' }
foreach ($width in @('1440px', '1024px', '768px', '430px', '390px', '375px')) {
  if ($style -notlike "*$width*") { throw "styles.css is missing responsive breakpoint: $width" }
}
if ($style -notlike '*overflow-x:hidden*') { throw 'styles.css must prevent horizontal overflow.' }

$readmePath = Join-Path $root 'README.md'
if (-not (Test-Path $readmePath)) { throw 'README.md is required.' }
$readme = Get-Content -Raw $readmePath
foreach ($required in @('assets/config.js', 'LINE_URL', 'GOOGLE_FORM_URL', 'WORKS', 'GitHub Pages', 'https://andy19841011.github.io/shunli-ai/')) {
  if ($readme -notlike "*$required*") { throw "README.md is missing deployment or configuration guidance: $required" }
}

Write-Output 'PASS: centralized independent-site configuration is present.'
