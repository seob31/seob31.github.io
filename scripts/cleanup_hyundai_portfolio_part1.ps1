$ErrorActionPreference = 'Stop'

$workspace = (Get-Location).Path
$src = Join-Path $workspace 'hyundai_portfolio_latest_vertical_merged.pptx'
$out = Join-Path $workspace 'hyundai_portfolio_latest_vertical_part1_cleanup.pptx'

function Clean-Text([string]$text) {
    if ([string]::IsNullOrWhiteSpace($text)) { return $text }

    $lines = $text -split "`r?`n"
    $cleaned = New-Object System.Collections.Generic.List[string]

    foreach ($raw in $lines) {
        $line = $raw.Trim()
        if ([string]::IsNullOrWhiteSpace($line)) { continue }

        if ($line -match '^<a href=') { continue }
        if ($line -match '^</a>$') { continue }
        if ($line -match 'javascript:history\.back') { continue }
        if ($line -match 'btn-outline-success') { continue }
        if ($line -eq '← 뒤로가기') { continue }
        if ($line -eq '---') { continue }
        if ($line -match '^[A-Za-z0-9_-]+\.md$') { continue }
        if ($line -match '^(PROJECT|ABOUT|ADDITIONAL)$') { continue }
        if ($line -match '^P\d+$') { continue }
        if ($line -match '^#\s+') { continue }
        if ($line -match '^<.*>$') { continue }

        $line = $line -replace '^-\s*→\s*', ''
        $line = $line -replace '^→\s*', ''
        $line = $line -replace '^\-\s*', '• '
        $line = $line -replace '^\d+\.\s+', ''
        $line = $line -replace '\$\{id\}\.log', 'id.log'
        $line = $line -replace '\s{2,}', ' '

        if ($line -match '^[a-z0-9_-]{2,15}$') { continue }

        $cleaned.Add($line)
    }

    return ($cleaned -join "`r`n").Trim()
}

$pp = New-Object -ComObject PowerPoint.Application
$pp.Visible = -1
$pres = $pp.Presentations.Open($src, $false, $false, $false)

try {
    foreach ($slide in $pres.Slides) {
        foreach ($shape in $slide.Shapes) {
            try {
                if ($shape.HasTextFrame -and $shape.TextFrame.HasText) {
                    $original = $shape.TextFrame.TextRange.Text
                    $newText = Clean-Text $original
                    if ([string]::IsNullOrWhiteSpace($newText)) {
                        $shape.Delete()
                    } elseif ($newText -ne $original) {
                        $shape.TextFrame.TextRange.Text = $newText
                    }
                }
            } catch {
            }
        }
    }

    $bridge = $pres.Slides.Add(7, 12)
    $bridge.Background.Fill.ForeColor.RGB = (28 + (36 * 256) + (52 * 65536))
    $title = $bridge.Shapes.AddTextbox(1, 36, 180, 460, 80)
    $title.TextFrame.TextRange.Text = '상세 프로젝트 포트폴리오'
    $title.TextFrame.TextRange.Font.NameFarEast = '맑은 고딕'
    $title.TextFrame.TextRange.Font.Name = 'Malgun Gothic'
    $title.TextFrame.TextRange.Font.Size = 28
    $title.TextFrame.TextRange.Font.Bold = -1
    $title.TextFrame.TextRange.Font.Color.RGB = 16777215
    $title.Line.Visible = 0
    $title.Fill.Visible = 0

    $body = $bridge.Shapes.AddTextbox(1, 40, 290, 450, 120)
    $body.TextFrame.TextRange.Text = "최신 프로젝트부터 정리한 상세 경력 포트폴리오입니다.`r`n각 프로젝트 바로 뒤에 관련 additional 내용을 배치해 기술적 깊이와 개선 근거를 함께 볼 수 있도록 구성했습니다."
    $body.TextFrame.TextRange.Font.NameFarEast = '맑은 고딕'
    $body.TextFrame.TextRange.Font.Name = 'Malgun Gothic'
    $body.TextFrame.TextRange.Font.Size = 16
    $body.TextFrame.TextRange.Font.Color.RGB = 16777215
    $body.Line.Visible = 0
    $body.Fill.Visible = 0

    $line = $bridge.Shapes.AddLine(40, 270, 500, 270)
    $line.Line.ForeColor.RGB = (210 + (220 * 256) + (235 * 65536))

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
