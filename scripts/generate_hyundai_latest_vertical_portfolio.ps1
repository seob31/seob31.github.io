$ErrorActionPreference = "Stop"

function RGB($r, $g, $b) {
    return $r + ($g * 256) + ($b * 65536)
}

function New-Block($type, $text) {
    return [pscustomobject]@{
        Type = $type
        Text = $text
        Items = @()
        Rows = @()
        Path = $null
        Caption = $null
    }
}

function Resolve-AssetPath($target, $baseDir, $workspace) {
    if ([string]::IsNullOrWhiteSpace($target)) { return $null }
    if ($target.StartsWith('/')) {
        $p = Join-Path $workspace $target.TrimStart('/')
        if (Test-Path $p) { return (Resolve-Path $p).Path }
    }
    if ([System.IO.Path]::IsPathRooted($target)) {
        if (Test-Path $target) { return (Resolve-Path $target).Path }
    }
    $candidate = Join-Path $baseDir $target
    if (Test-Path $candidate) { return (Resolve-Path $candidate).Path }
    return $null
}

function Clean-InlineText($text) {
    if ($null -eq $text) { return "" }
    $result = $text
    $result = [System.Text.RegularExpressions.Regex]::Replace($result, '!\[(.*?)\]\((.*?)\)', '$1')
    $result = [System.Text.RegularExpressions.Regex]::Replace($result, '\[(.*?)\]\((.*?)\)', '$1')
    $result = $result -replace '\*\*(.*?)\*\*', '$1'
    $result = $result -replace '`([^`]+)`', '$1'
    $result = $result -replace '<br\s*/?>', "`n"
    return $result.Trim()
}

function Parse-MarkdownBlocks($path, $workspace) {
    $content = Get-Content $path -Encoding UTF8
    $front = @{}
    $bodyStart = 0
    if ($content.Count -gt 0 -and $content[0] -eq '---') {
        for ($i = 1; $i -lt $content.Count; $i++) {
            if ($content[$i] -eq '---') {
                $bodyStart = $i + 1
                break
            }
            if ($content[$i] -match '^([A-Za-z_]+):\s*(.*)$') {
                $front[$Matches[1]] = $Matches[2].Trim('"')
            }
        }
    }

    $blocks = New-Object System.Collections.Generic.List[object]
    $baseDir = Split-Path -Parent $path
    $title = $front["title"]
    $hero = $front["image"]
    if ($hero) {
        $heroPath = Resolve-AssetPath $hero $baseDir $workspace
        if ($heroPath) {
            $imgBlock = New-Block "image" ""
            $imgBlock.Path = $heroPath
            $imgBlock.Caption = "대표 이미지"
            $blocks.Add($imgBlock)
        }
    }

    $inCode = $false
    $codeLines = New-Object System.Collections.Generic.List[string]
    $currentBullets = $null
    $currentTable = $null

    for ($i = $bodyStart; $i -lt $content.Count; $i++) {
        $line = $content[$i].TrimEnd()

        if ($line -match '^```') {
            if (-not $inCode) {
                if ($currentBullets) { $blocks.Add($currentBullets); $currentBullets = $null }
                if ($currentTable) { $blocks.Add($currentTable); $currentTable = $null }
                $inCode = $true
                $codeLines.Clear()
            } else {
                $codeBlock = New-Block "code" ($codeLines -join "`n")
                $blocks.Add($codeBlock)
                $inCode = $false
            }
            continue
        }

        if ($inCode) {
            $codeLines.Add($line)
            continue
        }

        if ([string]::IsNullOrWhiteSpace($line)) {
            if ($currentBullets) { $blocks.Add($currentBullets); $currentBullets = $null }
            if ($currentTable) { $blocks.Add($currentTable); $currentTable = $null }
            continue
        }

        if ($line -match '^##\s+(.*)$') {
            if ($currentBullets) { $blocks.Add($currentBullets); $currentBullets = $null }
            if ($currentTable) { $blocks.Add($currentTable); $currentTable = $null }
            $blocks.Add((New-Block "h2" (Clean-InlineText $Matches[1])))
            continue
        }

        if ($line -match '^###\s+(.*)$') {
            if ($currentBullets) { $blocks.Add($currentBullets); $currentBullets = $null }
            if ($currentTable) { $blocks.Add($currentTable); $currentTable = $null }
            $blocks.Add((New-Block "h3" (Clean-InlineText $Matches[1])))
            continue
        }

        if ($line -match '^>>\s*\*\*(.*?)\*\*') {
            if ($currentBullets) { $blocks.Add($currentBullets); $currentBullets = $null }
            if ($currentTable) { $blocks.Add($currentTable); $currentTable = $null }
            $blocks.Add((New-Block "h3" (Clean-InlineText $Matches[1])))
            continue
        }

        if ($line -match '!\[(.*?)\]\((.*?)\)') {
            if ($currentBullets) { $blocks.Add($currentBullets); $currentBullets = $null }
            if ($currentTable) { $blocks.Add($currentTable); $currentTable = $null }
            $imgPath = Resolve-AssetPath $Matches[2] $baseDir $workspace
            if ($imgPath) {
                $imgBlock = New-Block "image" ""
                $imgBlock.Path = $imgPath
                $imgBlock.Caption = (Clean-InlineText $Matches[1])
                $blocks.Add($imgBlock)
            }
            continue
        }

        if ($line -match '^\|\s*(.+)\s*\|$') {
            if ($currentBullets) { $blocks.Add($currentBullets); $currentBullets = $null }
            if (-not $currentTable) {
                $currentTable = New-Block "table" ""
                $currentTable.Rows = New-Object System.Collections.Generic.List[object]
            }
            $cells = @($line.Trim('|').Split('|') | ForEach-Object { Clean-InlineText $_.Trim() })
            if (($cells -join "") -match '^-+$') { continue }
            $currentTable.Rows.Add($cells)
            continue
        }

        if ($line -match '^\-\s+(.*)$') {
            if ($currentTable) { $blocks.Add($currentTable); $currentTable = $null }
            if (-not $currentBullets) {
                $currentBullets = New-Block "bullets" ""
                $currentBullets.Items = New-Object System.Collections.Generic.List[string]
            }
            $currentBullets.Items.Add((Clean-InlineText $Matches[1]))
            continue
        }

        if ($currentBullets) { $blocks.Add($currentBullets); $currentBullets = $null }
        if ($currentTable) { $blocks.Add($currentTable); $currentTable = $null }
        $blocks.Add((New-Block "p" (Clean-InlineText $line)))
    }

    if ($currentBullets) { $blocks.Add($currentBullets) }
    if ($currentTable) { $blocks.Add($currentTable) }

    return @{
        Title = $title
        Blocks = $blocks
        Front = $front
    }
}

function Add-TextBox($slide, $left, $top, $width, $height, $text, $size, $rgb, $bold = $false) {
    $shape = $slide.Shapes.AddTextbox(1, $left, $top, $width, $height)
    $shape.TextFrame.WordWrap = -1
    $shape.TextFrame.AutoSize = 1
    $shape.TextFrame.MarginLeft = 2
    $shape.TextFrame.MarginRight = 2
    $shape.TextFrame.MarginTop = 2
    $shape.TextFrame.MarginBottom = 2
    $shape.TextFrame.TextRange.Text = $text
    $shape.TextFrame.TextRange.Font.NameFarEast = "맑은 고딕"
    $shape.TextFrame.TextRange.Font.Name = "Malgun Gothic"
    $shape.TextFrame.TextRange.Font.Size = $size
    $shape.TextFrame.TextRange.Font.Color.RGB = $rgb
    $shape.TextFrame.TextRange.Font.Bold = [int]$bold
    $shape.Line.Visible = 0
    $shape.Fill.Visible = 0
    return $shape
}

function Add-BulletsBox($slide, $left, $top, $width, $height, $items, $size, $rgb) {
    $shape = $slide.Shapes.AddTextbox(1, $left, $top, $width, $height)
    $shape.TextFrame.WordWrap = -1
    $shape.TextFrame.AutoSize = 1
    $shape.TextFrame.MarginLeft = 2
    $shape.TextFrame.MarginRight = 2
    $shape.TextFrame.MarginTop = 2
    $shape.TextFrame.MarginBottom = 2
    $shape.TextFrame.TextRange.Text = (($items | ForEach-Object { [char]0x2022 + " " + $_ }) -join "`r`n")
    $shape.TextFrame.TextRange.Font.NameFarEast = "맑은 고딕"
    $shape.TextFrame.TextRange.Font.Name = "Malgun Gothic"
    $shape.TextFrame.TextRange.Font.Size = $size
    $shape.TextFrame.TextRange.Font.Color.RGB = $rgb
    $shape.TextFrame.TextRange.ParagraphFormat.Bullet.Visible = 0
    $shape.Line.Visible = 0
    $shape.Fill.Visible = 0
    return $shape
}

function Add-SectionHeader($slide, $projectTitle, $kind, $pageLabel, $theme) {
    $slide.Background.Fill.ForeColor.RGB = $theme.Background
    $bar = $slide.Shapes.AddShape(1, 0, 0, 540, 52)
    $bar.Fill.ForeColor.RGB = $theme.Header
    $bar.Line.Visible = 0 | Out-Null

    Add-TextBox $slide 28 12 350 24 $projectTitle 20 $theme.HeaderText $true | Out-Null
    $tagText = if ($kind -eq "additional") { "ADDITIONAL" } elseif ($kind -eq "about") { "ABOUT" } else { "PROJECT" }
    Add-TextBox $slide 390 13 70 20 $tagText 10 $theme.HeaderText $true | Out-Null
    Add-TextBox $slide 468 13 45 20 $pageLabel 10 $theme.HeaderText $false | Out-Null

    $line = $slide.Shapes.AddLine(28, 64, 512, 64)
    $line.Line.ForeColor.RGB = $theme.Line
}

function Add-Footer($slide, $text, $theme) {
    $line = $slide.Shapes.AddLine(28, 922, 512, 922)
    $line.Line.ForeColor.RGB = $theme.Line
    Add-TextBox $slide 30 928 470 18 $text 9 $theme.Muted $false | Out-Null
}

function Measure-TextHeight($slide, $text, $size, $width, $bold = $false, $isBullet = $false, $rgb = 0) {
    if ($isBullet) {
        $shape = Add-BulletsBox $slide -2000 -2000 $width 2000 $text $size $rgb
    } else {
        $shape = Add-TextBox $slide -2000 -2000 $width 2000 $text $size $rgb $bold
    }
    $height = [Math]::Ceiling($shape.Height)
    $shape.Delete()
    return $height
}

function Add-TableBlock($slide, $left, $top, $width, $rows, $theme) {
    $rowCount = $rows.Count
    $colCount = ($rows | Select-Object -First 1).Count
    $height = [Math]::Max(40, ($rowCount * 28) + 12)
    $shape = $slide.Shapes.AddTable($rowCount, $colCount, $left, $top, $width, $height)
    $table = $shape.Table
    for ($r = 1; $r -le $rowCount; $r++) {
        for ($c = 1; $c -le $colCount; $c++) {
            $cell = $table.Cell($r, $c).Shape
            $cell.TextFrame.TextRange.Text = $rows[$r - 1][$c - 1]
            $cell.TextFrame.TextRange.Font.NameFarEast = "맑은 고딕"
            $cell.TextFrame.TextRange.Font.Name = "Malgun Gothic"
            $cell.TextFrame.TextRange.Font.Size = 11
            $cell.TextFrame.TextRange.Font.Color.RGB = $theme.Text
            if ($r -eq 1) {
                $cell.Fill.ForeColor.RGB = $theme.TableHeader
                $cell.TextFrame.TextRange.Font.Bold = -1
            } else {
                $cell.Fill.ForeColor.RGB = $theme.Surface
            }
        }
    }
    return $shape.Height
}

function Get-ImageFit($path, $maxWidth, $maxHeight) {
    Add-Type -AssemblyName System.Drawing
    $img = [System.Drawing.Image]::FromFile($path)
    $ratio = [Math]::Min($maxWidth / $img.Width, $maxHeight / $img.Height)
    $width = [Math]::Round($img.Width * $ratio, 2)
    $height = [Math]::Round($img.Height * $ratio, 2)
    $img.Dispose()
    return @{ Width = $width; Height = $height }
}

$workspace = (Get-Location).Path
$output = Join-Path $workspace "hyundai_portfolio_latest_vertical.pptx"

$theme = @{
    Background = (RGB 245 247 250)
    Header = (RGB 0 45 114)
    HeaderText = (RGB 255 255 255)
    Title = (RGB 18 34 66)
    Accent = (RGB 0 90 169)
    Text = (RGB 38 49 73)
    Muted = (RGB 102 112 128)
    Line = (RGB 210 220 235)
    Surface = (RGB 255 255 255)
    TableHeader = (RGB 236 242 249)
}

$entries = New-Object System.Collections.Generic.List[object]

$aboutHtml = Join-Path $workspace "_pages\about.html"
$entries.Add([pscustomobject]@{
    Kind = "about"
    Title = "About Me"
    Blocks = @(
        (New-Block "h2" "Introduction"),
        [pscustomobject]@{ Type = "about_intro"; Text = ""; Items = @(); Rows = @(); Path = $null; Caption = $null },
        (New-Block "h2" "Skills"),
        [pscustomobject]@{ Type = "bullets"; Text = ""; Items = @(
            "Back-end: Java, Spring Framework, Spring Boot, Spring WebFlux, JPA, MyBatis, Spring Batch, Kafka, Quartz",
            "Front-end: React, JavaScript, HTML, CSS, jQuery, Ajax, JSP",
            "Database: Oracle, PostgreSQL, MariaDB, MySQL, H2, Redis 등",
            "Infra & DevOps: AWS, Docker, HaProxy, MSA"
        ); Rows = @(); Path = $null; Caption = $null },
        (New-Block "h2" "License"),
        [pscustomobject]@{ Type = "bullets"; Text = ""; Items = @(
            "OCJP Silver - Java SE 8 / ORACLE / 2018.01",
            "정보처리기사 / 한국산업인력공단 / 2017.05"
        ); Rows = @(); Path = $null; Caption = $null }
    )
    Source = $aboutHtml
})

$projectFiles = Get-ChildItem (Join-Path $workspace "_projects\ko") -File | Sort-Object Name -Descending
foreach ($pf in $projectFiles) {
    $parsed = Parse-MarkdownBlocks $pf.FullName $workspace
    $entries.Add([pscustomobject]@{
        Kind = "project"
        Title = $parsed.Title
        Blocks = $parsed.Blocks
        Source = $pf.FullName
    })

    $text = Get-Content $pf.FullName -Encoding UTF8 -Raw
    $additionalLinks = [System.Text.RegularExpressions.Regex]::Matches($text, '/projects/additional/[^)\s]+')
    foreach ($link in $additionalLinks) {
        $parts = $link.Value.Trim('/').Split('/')
        if ($parts.Length -ge 4) {
            $additionalPath = Join-Path $workspace ('_projects\additional\' + $parts[2] + '\' + $parts[3] + '.md')
            if (Test-Path $additionalPath) {
                $parsedAdditional = Parse-MarkdownBlocks $additionalPath $workspace
                $entries.Add([pscustomobject]@{
                    Kind = "additional"
                    Title = $parsedAdditional.Title
                    Blocks = $parsedAdditional.Blocks
                    Source = $additionalPath
                })
            }
        }
    }
}

$pp = New-Object -ComObject PowerPoint.Application
$pp.Visible = -1
$pres = $pp.Presentations.Add()
$pres.PageSetup.SlideWidth = 540
$pres.PageSetup.SlideHeight = 960

try {
    $slideIndex = 0
    foreach ($entry in $entries) {
        $contentIndex = 0
        $pageInEntry = 1
        $slide = $null
        $y = 0
        $contentBottom = 910

        while ($contentIndex -lt $entry.Blocks.Count) {
            if ($null -eq $slide) {
                $slideIndex++
                $slide = $pres.Slides.Add($slideIndex, 12)
                Add-SectionHeader $slide $entry.Title $entry.Kind ("P" + $pageInEntry) $theme
                $y = 82
                Add-Footer $slide ((Split-Path $entry.Source -Leaf)) $theme
                if ($entry.Kind -eq "about" -and $pageInEntry -eq 1) {
                    $photoBox = $slide.Shapes.AddShape(1, 350, 96, 140, 180)
                    $photoBox.Fill.ForeColor.RGB = (RGB 251 248 243)
                    $photoBox.Line.ForeColor.RGB = $theme.Line
                    $photoBox.TextFrame.TextRange.Text = "PHOTO"
                    $photoBox.TextFrame.TextRange.Font.NameFarEast = "맑은 고딕"
                    $photoBox.TextFrame.TextRange.Font.Name = "Malgun Gothic"
                    $photoBox.TextFrame.TextRange.Font.Size = 18
                    $photoBox.TextFrame.TextRange.Font.Color.RGB = $theme.Muted
                    $photoBox.TextFrame.TextRange.ParagraphFormat.Alignment = 2
                    $photoBox.TextFrame.VerticalAnchor = 3

                    $introBody = Add-BulletsBox $slide 28 92 292 210 @(
                        "Inzent (2023.09 ~ 재직중) / 백엔드 중심 풀스택 Java 개발자",
                        "백엔드 중심 개발, 성능 최적화, 유지보수",
                        "프론트엔드 개발과 클라우드 관리 및 운영",
                        "기능 설계, 개발 문서 작성, 센터 내 팀 QA 담당",
                        "Markany (2019.11 ~ 2023.05) / 시스템 설계, 아키텍처, SRE, IDC 운영",
                        "NextKey (2018.01 ~ 2019.10) / 고객사 상주 백엔드 개발, 테스트, Peer Leader"
                    ) 12 $theme.Text
                    $y = [Math]::Max(322, [Math]::Ceiling($introBody.Top + $introBody.Height + 16))
                    $contentIndex = 1
                }
            }

            if ($contentIndex -ge $entry.Blocks.Count) { break }
            $block = $entry.Blocks[$contentIndex]
            $remaining = $contentBottom - $y
            if ($remaining -lt 60) {
                $slide = $null
                $pageInEntry++
                continue
            }

            switch ($block.Type) {
                "h2" {
                    $h = Measure-TextHeight $slide $block.Text 18 470 $true $false $theme.Accent
                    if ($y + $h + 8 -gt $contentBottom) { $slide = $null; $pageInEntry++; continue }
                    $shape = Add-TextBox $slide 28 $y 470 30 $block.Text 18 $theme.Accent $true
                    $y = [Math]::Ceiling($shape.Top + $shape.Height + 10)
                    $contentIndex++
                }
                "h3" {
                    $h = Measure-TextHeight $slide $block.Text 15 470 $true $false $theme.Title
                    if ($y + $h + 6 -gt $contentBottom) { $slide = $null; $pageInEntry++; continue }
                    $shape = Add-TextBox $slide 36 $y 460 26 $block.Text 15 $theme.Title $true
                    $y = [Math]::Ceiling($shape.Top + $shape.Height + 8)
                    $contentIndex++
                }
                "p" {
                    $h = Measure-TextHeight $slide $block.Text 12 470 $false $false $theme.Text
                    if ($y + $h + 6 -gt $contentBottom) { $slide = $null; $pageInEntry++; continue }
                    $shape = Add-TextBox $slide 36 $y 470 80 $block.Text 12 $theme.Text $false
                    $y = [Math]::Ceiling($shape.Top + $shape.Height + 8)
                    $contentIndex++
                }
                "bullets" {
                    $items = @($block.Items)
                    $h = Measure-TextHeight $slide $items 12 468 $false $true $theme.Text
                    if ($h -gt ($contentBottom - $y) -and $items.Count -gt 1) {
                        $fitCount = [Math]::Max(1, [Math]::Floor((($contentBottom - $y) - 8) / 26))
                        $shown = $items[0..([Math]::Min($fitCount - 1, $items.Count - 1))]
                        $shape = Add-BulletsBox $slide 42 $y 460 240 $shown 12 $theme.Text
                        $y = [Math]::Ceiling($shape.Top + $shape.Height + 8)
                        if ($fitCount -lt $items.Count) {
                            $block.Items = $items[$fitCount..($items.Count - 1)]
                        } else {
                            $contentIndex++
                        }
                    } else {
                        if ($y + $h + 6 -gt $contentBottom) { $slide = $null; $pageInEntry++; continue }
                        $shape = Add-BulletsBox $slide 42 $y 460 240 $items 12 $theme.Text
                        $y = [Math]::Ceiling($shape.Top + $shape.Height + 8)
                        $contentIndex++
                    }
                }
                "table" {
                    $estimated = [Math]::Max(70, ($block.Rows.Count * 28) + 12)
                    if ($y + $estimated -gt $contentBottom) { $slide = $null; $pageInEntry++; continue }
                    $tableHeight = Add-TableBlock $slide 36 $y 468 $block.Rows $theme
                    $y = [Math]::Ceiling($y + $tableHeight + 10)
                    $contentIndex++
                }
                "code" {
                    $text = $block.Text
                    $h = Measure-TextHeight $slide $text 9 458 $false $false $theme.Text
                    if ($h -gt 220) { $h = 220 }
                    if ($y + $h + 14 -gt $contentBottom) { $slide = $null; $pageInEntry++; continue }
                    $box = $slide.Shapes.AddShape(1, 36, $y, 468, $h + 12)
                    $box.Fill.ForeColor.RGB = (RGB 250 247 242)
                    $box.Line.ForeColor.RGB = $theme.Line
                    $codeShape = Add-TextBox $slide 46 ($y + 8) 448 ($h + 4) $text 9 $theme.Text $false
                    $y = [Math]::Ceiling($y + $h + 20)
                    $contentIndex++
                }
                "image" {
                    $fit = Get-ImageFit $block.Path 448 300
                    $captionHeight = 0
                    if (-not [string]::IsNullOrWhiteSpace($block.Caption)) { $captionHeight = 20 }
                    if ($y + $fit.Height + $captionHeight + 16 -gt $contentBottom) {
                        if ($fit.Height -gt 220 -and $remaining -gt 180) {
                            $fit = Get-ImageFit $block.Path 448 ($remaining - 30)
                        } else {
                            $slide = $null
                            $pageInEntry++
                            continue
                        }
                    }
                    $left = [Math]::Round((540 - $fit.Width) / 2, 2)
                    $slide.Shapes.AddPicture($block.Path, 0, -1, $left, $y, $fit.Width, $fit.Height) | Out-Null
                    $y = [Math]::Ceiling($y + $fit.Height + 6)
                    if (-not [string]::IsNullOrWhiteSpace($block.Caption)) {
                        $cap = Add-TextBox $slide 36 $y 468 18 $block.Caption 10 $theme.Muted $false
                        $y = [Math]::Ceiling($cap.Top + $cap.Height + 8)
                    }
                    $contentIndex++
                }
                default {
                    $contentIndex++
                }
            }
        }
    }

    if (Test-Path $output) {
        Remove-Item -LiteralPath $output -Force
    }
    $pres.SaveAs($output)
}
finally {
    $pres.Close()
    $pp.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($pres) | Out-Null
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($pp) | Out-Null
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}

Write-Output "Created: $output"


