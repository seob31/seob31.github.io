$ErrorActionPreference = 'Stop'

function To-FileUri([string]$path) {
    return ([System.Uri]::new($path)).AbsoluteUri
}

function HtmlEncode([string]$text) {
    return [System.Net.WebUtility]::HtmlEncode($text)
}

function Convert-Inline([string]$text, [string]$baseDir, [string]$workspace) {
    if ($null -eq $text) { return '' }
    $encoded = [System.Net.WebUtility]::HtmlEncode($text)
    $encoded = [System.Text.RegularExpressions.Regex]::Replace($encoded, '!?\[(.*?)\]\((.*?)\)', {
        param($m)
        $label = $m.Groups[1].Value
        $target = $m.Groups[2].Value
        if ($m.Value.StartsWith('!')) {
            $resolved = $target
            if ($target.StartsWith('/')) {
                $resolved = Join-Path $workspace $target.TrimStart('/')
            } elseif (-not [System.IO.Path]::IsPathRooted($target)) {
                $resolved = Join-Path $baseDir $target
            }
            $uri = To-FileUri((Resolve-Path $resolved).Path)
            return "<figure><img src='$uri' alt='$label' /><figcaption>$label</figcaption></figure>"
        }
        return "<span class='link-text'>$label</span>"
    })
    $encoded = [System.Text.RegularExpressions.Regex]::Replace($encoded, '\*\*(.+?)\*\*', '<strong>$1</strong>')
    $encoded = $encoded -replace '&lt;br&gt;', '<br>'
    return $encoded
}

function Parse-MarkdownToHtml([string]$path, [string]$workspace) {
    $content = Get-Content $path -Encoding UTF8
    $front = @{}
    $bodyStart = 0
    if ($content[0] -eq '---') {
        for ($i = 1; $i -lt $content.Count; $i++) {
            if ($content[$i] -eq '---') { $bodyStart = $i + 1; break }
            if ($content[$i] -match '^([A-Za-z_]+):\s*(.*)$') { $front[$Matches[1]] = $Matches[2].Trim('"') }
        }
    }
    $title = $front['title']
    $hero = $front['image']
    $lines = $content[$bodyStart..($content.Count-1)]
    $baseDir = Split-Path -Parent $path
    $html = New-Object System.Collections.Generic.List[string]
    $html.Add("<div class='doc project'>")
    $html.Add("<h1>$([System.Net.WebUtility]::HtmlEncode($title))</h1>")
    if ($hero) {
        $heroPath = Join-Path $workspace $hero
        if (Test-Path $heroPath) {
            $html.Add("<div class='hero'><img src='$(To-FileUri((Resolve-Path $heroPath).Path))' alt='hero' /></div>")
        }
    }

    $inList = $false; $inCode = $false; $inTable = $false; $tableHeaderDone = $false
    foreach ($raw in $lines) {
        $line = $raw.TrimEnd()
        if ($line -match '^```') {
            if (-not $inCode) { if ($inList) { $html.Add('</ul>'); $inList = $false }; if ($inTable) { $html.Add('</table>'); $inTable = $false; $tableHeaderDone = $false }; $html.Add('<pre><code>'); $inCode = $true }
            else { $html.Add('</code></pre>'); $inCode = $false }
            continue
        }
        if ($inCode) { $html.Add((HtmlEncode $line)); continue }

        if ([string]::IsNullOrWhiteSpace($line)) {
            if ($inList) { $html.Add('</ul>'); $inList = $false }
            if ($inTable) { $html.Add('</table>'); $inTable = $false; $tableHeaderDone = $false }
            continue
        }

        if ($line -match '^\|') {
            if ($inList) { $html.Add('</ul>'); $inList = $false }
            $cells = @($line.Trim('|').Split('|') | ForEach-Object { $_.Trim() })
            if (-not $inTable) { $html.Add('<table>'); $inTable = $true; $tableHeaderDone = $false }
            if (-not $tableHeaderDone -and $cells -notmatch '^-+$') {
                $html.Add('<tr>' + (($cells | ForEach-Object { '<th>' + (Convert-Inline $_ $baseDir $workspace) + '</th>' }) -join '') + '</tr>')
                $tableHeaderDone = $true
            } elseif (($cells -join '') -match '^-+$') {
                continue
            } else {
                $html.Add('<tr>' + (($cells | ForEach-Object { '<td>' + (Convert-Inline $_ $baseDir $workspace) + '</td>' }) -join '') + '</tr>')
            }
            continue
        } elseif ($inTable) { $html.Add('</table>'); $inTable = $false; $tableHeaderDone = $false }

        if ($line -match '^##\s+(.*)$') {
            if ($inList) { $html.Add('</ul>'); $inList = $false }
            $html.Add('<h2>' + (Convert-Inline $Matches[1] $baseDir $workspace) + '</h2>')
            continue
        }
        if ($line -match '^###\s+(.*)$') {
            if ($inList) { $html.Add('</ul>'); $inList = $false }
            $html.Add('<h3>' + (Convert-Inline $Matches[1] $baseDir $workspace) + '</h3>')
            continue
        }
        if ($line -match '^>>\s*\*\*(.*?)\*\*') {
            if ($inList) { $html.Add('</ul>'); $inList = $false }
            $html.Add('<h3>' + (Convert-Inline $Matches[1] $baseDir $workspace) + '</h3>')
            continue
        }
        if ($line -match '^-\s+(.*)$') {
            if (-not $inList) { $html.Add('<ul>'); $inList = $true }
            $html.Add('<li>' + (Convert-Inline $Matches[1] $baseDir $workspace) + '</li>')
            continue
        }

        $html.Add('<p>' + (Convert-Inline $line $baseDir $workspace) + '</p>')
    }

    if ($inList) { $html.Add('</ul>') }
    if ($inCode) { $html.Add('</code></pre>') }
    if ($inTable) { $html.Add('</table>') }
    $html.Add('</div>')
    return @{ Title = $title; Html = ($html -join "`n") }
}

function Parse-AboutToHtml([string]$path) {
    $content = Get-Content $path -Encoding UTF8 -Raw
    $body = [System.Text.RegularExpressions.Regex]::Replace($content, '(?s)^---.*?---\s*', '')
    return @"
<div class='doc about'>
  <div class='about-hero'>
    <div class='about-title'>
      <h1>About Me</h1>
      <p>사진은 추후 삽입할 수 있도록 공간만 남겨두었습니다.</p>
    </div>
    <div class='photo-placeholder'>PHOTO</div>
  </div>
  <div class='about-content'>
    $body
  </div>
</div>
"@
}

$workspace = (Get-Location).Path
$outPpt = Join-Path $workspace 'site_vertical_portfolio_all.pptx'
$tempRoot = Join-Path $workspace 'temp_vertical_portfolio'
$htmlDir = Join-Path $tempRoot 'html'
$shotDir = Join-Path $tempRoot 'shots'
$cropDir = Join-Path $tempRoot 'crops'
foreach ($dir in @($tempRoot, $htmlDir, $shotDir, $cropDir)) { if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null } }

$style = @"
<!doctype html>
<html><head><meta charset='utf-8'>
<style>
body { margin:0; background:#f6f3ee; font-family:'Malgun Gothic', sans-serif; color:#1f2937; }
.page { width:860px; margin:0 auto; background:#fff; padding:44px 52px 54px; box-sizing:border-box; min-height:100px; }
h1 { font-size:34px; line-height:1.25; margin:0 0 24px; color:#14213d; }
h2 { font-size:24px; margin:32px 0 14px; color:#9a5d38; border-bottom:1px solid #e6ddd1; padding-bottom:6px; }
h3 { font-size:18px; margin:22px 0 10px; color:#31435f; }
p, li, td, th { font-size:15px; line-height:1.72; }
p { margin:10px 0; }
ul { margin:8px 0 14px 18px; padding:0; }
li { margin:6px 0; }
table { width:100%; border-collapse:collapse; margin:14px 0 20px; }
th, td { border:1px solid #ddd3c6; padding:10px 12px; vertical-align:top; }
th { background:#f6f1ea; text-align:left; }
pre { background:#faf7f2; border:1px solid #e4dbcf; padding:14px; font-size:12px; line-height:1.5; overflow:hidden; white-space:pre-wrap; }
figure { margin:18px 0 24px; }
figure img, .hero img { width:100%; height:auto; border:1px solid #e4dbcf; display:block; }
figcaption { margin-top:8px; font-size:12px; color:#6b7280; }
.link-text { color:#9a5d38; font-weight:600; }
.about-hero { display:flex; justify-content:space-between; align-items:flex-start; gap:24px; margin-bottom:18px; }
.photo-placeholder { width:190px; height:240px; border:2px dashed #d6c6b4; color:#a88a70; display:flex; align-items:center; justify-content:center; font-weight:700; letter-spacing:1px; flex:0 0 190px; background:#fbf8f3; }
.about-title p { margin:8px 0 0; color:#6b7280; }
.about-content .projects-container { display:none; }
a, button, nav, .navbar, .btn, .about-side, .search-box, .radio-group, footer, .menu, .project-list, .sidebar-featured, .blog-list-container { display:none !important; }
</style></head><body><div class='page'>__CONTENT__</div></body></html>
"@

$entries = New-Object System.Collections.Generic.List[object]
$entries.Add([pscustomobject]@{ Kind='about'; Source=(Join-Path $workspace '_pages\about.html'); Title='About Me'; Html=(Parse-AboutToHtml (Join-Path $workspace '_pages\about.html')) })

$projectFiles = Get-ChildItem (Join-Path $workspace '_projects\ko') -File | Sort-Object Name
$additionalMap = @{}
$additionalFiles = Get-ChildItem (Join-Path $workspace '_projects\additional') -Recurse -File -Filter *.md | Where-Object { $_.Name -notlike '*_en.md' }
foreach ($a in $additionalFiles) {
    $additionalMap[$a.FullName] = $true
}

foreach ($pf in $projectFiles) {
    $parsed = Parse-MarkdownToHtml $pf.FullName $workspace
    $entries.Add([pscustomobject]@{ Kind='project'; Source=$pf.FullName; Title=$parsed.Title; Html=$parsed.Html })
    $projectText = Get-Content $pf.FullName -Encoding UTF8 -Raw
    $matches = [System.Text.RegularExpressions.Regex]::Matches($projectText, '/projects/additional/[^)\s]+')
    foreach ($m in $matches) {
        $slug = $m.Value.Trim('/')
        $parts = $slug.Split('/')
        if ($parts.Length -ge 4) {
            $candidate = Join-Path $workspace ('_projects\additional\' + $parts[2] + '\' + $parts[3] + '.md')
            if (Test-Path $candidate) {
                $parsedAdd = Parse-MarkdownToHtml $candidate $workspace
                $entries.Add([pscustomobject]@{ Kind='additional'; Source=$candidate; Title=$parsedAdd.Title; Html=$parsedAdd.Html })
            }
        }
    }
}

Add-Type -AssemblyName System.Drawing
$edge = 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
if (-not (Test-Path $edge)) { throw 'msedge.exe not found' }

$pages = New-Object System.Collections.Generic.List[object]
$index = 0
foreach ($entry in $entries) {
    $index++
    $safe = ('{0:D2}_{1}' -f $index, ([System.Text.RegularExpressions.Regex]::Replace($entry.Title, '[^A-Za-z0-9가-힣_-]+', '_').Trim('_')))
    if ([string]::IsNullOrWhiteSpace($safe)) { $safe = ('{0:D2}_page' -f $index) }
    $htmlPath = Join-Path $htmlDir ($safe + '.html')
    $fullHtml = $style.Replace('__CONTENT__', $entry.Html)
    Set-Content -Path $htmlPath -Value $fullHtml -Encoding UTF8

    $shotPath = Join-Path $shotDir ($safe + '.png')
    & $edge --headless=new --disable-gpu --hide-scrollbars --window-size=950,12000 --screenshot="$shotPath" (To-FileUri $htmlPath) | Out-Null
    if (-not (Test-Path $shotPath)) { throw "Screenshot failed: $shotPath" }

    $img = [System.Drawing.Image]::FromFile($shotPath)
    $segmentHeight = [int][math]::Round($img.Width * 16 / 9)
    $y = 0
    $pageNo = 1
    while ($y -lt $img.Height) {
        $remaining = $img.Height - $y
        $cropH = [Math]::Min($segmentHeight, $remaining)
        if ($cropH -lt [int]($segmentHeight * 0.35) -and $pageNo -gt 1) { break }
        $bmp = New-Object System.Drawing.Bitmap $img.Width, $cropH
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.Clear([System.Drawing.Color]::White)
        $g.DrawImage($img, (New-Object System.Drawing.Rectangle 0,0,$img.Width,$cropH), (New-Object System.Drawing.Rectangle 0,$y,$img.Width,$cropH), [System.Drawing.GraphicsUnit]::Pixel)
        $cropPath = Join-Path $cropDir ("${safe}_p${pageNo}.png")
        $bmp.Save($cropPath, [System.Drawing.Imaging.ImageFormat]::Png)
        $g.Dispose(); $bmp.Dispose()
        $pages.Add([pscustomobject]@{ Title=$entry.Title; Image=$cropPath; Kind=$entry.Kind })
        $y += $segmentHeight - 90
        $pageNo++
    }
    $img.Dispose()
}

$pp = New-Object -ComObject PowerPoint.Application
$pp.Visible = -1
$pres = $pp.Presentations.Add()
$pres.PageSetup.SlideWidth = 540
$pres.PageSetup.SlideHeight = 960

try {
    $slideIndex = 0
    foreach ($page in $pages) {
        $slideIndex++
        $slide = $pres.Slides.Add($slideIndex, 12)
        $slide.Background.Fill.ForeColor.RGB = 16777215
        $slide.Shapes.AddPicture($page.Image, 0, -1, 0, 0, 540, 960) | Out-Null
    }
    if (Test-Path $outPpt) { Remove-Item -LiteralPath $outPpt -Force }
    $pres.SaveAs($outPpt)
}
finally {
    $pres.Close(); $pp.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($pres) | Out-Null
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($pp) | Out-Null
    [GC]::Collect(); [GC]::WaitForPendingFinalizers()
}

Write-Output "Created: $outPpt"
Write-Output "Pages: $($pages.Count)"
