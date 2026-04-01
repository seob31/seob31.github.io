$ErrorActionPreference = 'Stop'

$workspace = (Get-Location).Path
$src = Join-Path $workspace 'hyundai_portfolio_latest_vertical_part1_cleanup.pptx'
$out = Join-Path $workspace 'hyundai_portfolio_latest_vertical_part2_cleanup.pptx'

function Normalize-Text([string]$text) {
    if ([string]::IsNullOrWhiteSpace($text)) { return $text }
    $lines = $text -split "`r?`n"
    $cleaned = New-Object System.Collections.Generic.List[string]
    foreach ($raw in $lines) {
        $line = $raw.Trim()
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        if ($line -match '^P\d+$') { continue }
        if ($line -match '^[A-Za-z0-9_-]+\.(md|html)$') { continue }
        if ($line -match '^<a href=') { continue }
        if ($line -match '^</a>$') { continue }
        if ($line -match '^</?[^>]+>$') { continue }
        if ($line -match 'javascript:history\.back') { continue }
        if ($line -match 'btn-outline-success') { continue }
        if ($line -eq '← 뒤로가기') { continue }
        if ($line -eq 'PHOTO') { continue }
        if ($line -eq 'P1' -or $line -eq 'P2' -or $line -eq 'P3' -or $line -eq 'P4' -or $line -eq 'P5') { continue }
        $line = $line -replace '^####\s*', ''
        $line = $line -replace '^###\s*', ''
        $line = $line -replace '^##\s*', ''
        $line = $line -replace '^#\s*', ''
        $line = $line -replace '^-\s*→\s*', ''
        $line = $line -replace '^→\s*', ''
        $line = $line -replace '^\-\s*', '• '
        $line = $line -replace '^\d+\.\s+', ''
        $line = $line -replace '\s{2,}', ' '
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $cleaned.Add($line)
    }
    return ($cleaned -join "`r`n").Trim()
}

$pp = New-Object -ComObject PowerPoint.Application
$pp.Visible = -1
$pres = $pp.Presentations.Open($src, $false, $false, $false)

try {
    foreach ($slide in $pres.Slides) {
        foreach ($shape in @($slide.Shapes)) {
            try {
                if ($shape.HasTextFrame -and $shape.TextFrame.HasText) {
                    $original = $shape.TextFrame.TextRange.Text
                    $newText = Normalize-Text $original
                    if ([string]::IsNullOrWhiteSpace($newText)) {
                        $shape.Delete()
                    } elseif ($newText -ne $original) {
                        $shape.TextFrame.TextRange.Text = $newText
                    }
                }
            } catch {
            }
        }

        $texts = @()
        foreach ($shape in @($slide.Shapes)) {
            try {
                if ($shape.HasTextFrame -and $shape.TextFrame.HasText) {
                    $t = $shape.TextFrame.TextRange.Text.Trim()
                    if ($t) { $texts += $t }
                }
            } catch {}
        }

        $hasProjectTitle = $texts.Count -gt 0
        $hasContextText = $texts -match '프로젝트 개요|담당 역할|주요 성과|개요|핵심 구조|핵심 포인트|현대자동차|경력 요약|핵심 역량|상세 프로젝트 포트폴리오|About Me'
        $imageCount = 0
        foreach ($shape in @($slide.Shapes)) {
            try { if ($shape.Type -eq 13 -or $shape.Type -eq 11) { $imageCount++ } } catch {}
        }

        if ($imageCount -ge 1 -and -not $hasContextText -and $texts.Count -le 3) {
            $title = if ($texts.Count -gt 0) { $texts[0] } else { '주요 화면' }
            $caption = $slide.Shapes.AddTextbox(1, 28, 874, 484, 28)
            $caption.TextFrame.TextRange.Text = "$title 화면 예시"
            $caption.TextFrame.TextRange.Font.NameFarEast = '맑은 고딕'
            $caption.TextFrame.TextRange.Font.Name = 'Malgun Gothic'
            $caption.TextFrame.TextRange.Font.Size = 11
            $caption.TextFrame.TextRange.Font.Color.RGB = (102 + (112 * 256) + (128 * 65536))
            $caption.Line.Visible = 0
            $caption.Fill.Visible = 0
        }
    }

    if (Test-Path $out) { Remove-Item -LiteralPath $out -Force }
    $pres.SaveAs($out)
}
finally {
    try { $pres.Close() } catch {}
    try { $pp.Quit() } catch {}
    try { [System.Runtime.Interopservices.Marshal]::ReleaseComObject($pres) | Out-Null } catch {}
    try { [System.Runtime.Interopservices.Marshal]::ReleaseComObject($pp) | Out-Null } catch {}
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}

Write-Output "Created: $out"
