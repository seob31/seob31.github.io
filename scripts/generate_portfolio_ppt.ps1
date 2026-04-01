$ErrorActionPreference = "Stop"

$workspace = Split-Path -Parent $PSScriptRoot
$sourcePath = Join-Path $workspace "career_portfolio_ko_ppt.md"
$outputPath = Join-Path $workspace "career_portfolio_ko.pptx"

if (-not (Test-Path $sourcePath)) {
    throw "Source markdown not found: $sourcePath"
}

$raw = Get-Content $sourcePath -Encoding UTF8
$slides = @()
$current = $null
$currentSection = $null

foreach ($line in $raw) {
    if ($line -match '^## 슬라이드\s+\d+\.\s+(.+)$') {
        if ($null -ne $current) {
            $slides += $current
        }
        $current = [ordered]@{
            Label = $Matches[1].Trim()
            Title = ""
            Sections = New-Object System.Collections.Generic.List[string]
        }
        $currentSection = $null
        continue
    }

    if ($null -eq $current) {
        continue
    }

    if ($line -match '^###\s+(.+)$') {
        $currentSection = $Matches[1].Trim()
        continue
    }

    if ([string]::IsNullOrWhiteSpace($line) -or $line -eq '---') {
        continue
    }

    if ($currentSection -eq '제목' -and [string]::IsNullOrWhiteSpace($current.Title)) {
        $current.Title = $line.Trim()
        continue
    }

    $prefix = ""
    if ($line -match '^- ') {
        $prefix = [char]0x2022 + " "
        $content = $line.Substring(2).Trim()
    } else {
        $content = $line.Trim()
    }

    if (-not [string]::IsNullOrWhiteSpace($currentSection)) {
        $current.Sections.Add("[$currentSection] $prefix$content")
    } else {
        $current.Sections.Add("$prefix$content")
    }
}

if ($null -ne $current) {
    $slides += $current
}

if ($slides.Count -eq 0) {
    throw "No slide sections found in markdown."
}

$pp = New-Object -ComObject PowerPoint.Application
$pp.Visible = -1

$presentation = $pp.Presentations.Add()

try {
    foreach ($slideData in $slides) {
        $slide = $presentation.Slides.Add($presentation.Slides.Count + 1, 2)

        $titleText = $slideData.Title
        if ([string]::IsNullOrWhiteSpace($titleText)) {
            $titleText = $slideData.Label
        }

        $slide.Shapes.Title.TextFrame.TextRange.Text = $titleText

        $bodyShape = $slide.Shapes.Placeholders.Item(2)
        $bodyText = ($slideData.Sections -join "`r`n")
        $bodyShape.TextFrame.TextRange.Text = $bodyText

        $bodyShape.TextFrame.TextRange.Font.NameFarEast = "맑은 고딕"
        $bodyShape.TextFrame.TextRange.Font.Name = "Malgun Gothic"
        $bodyShape.TextFrame.TextRange.Font.Size = 20
        $slide.Shapes.Title.TextFrame.TextRange.Font.NameFarEast = "맑은 고딕"
        $slide.Shapes.Title.TextFrame.TextRange.Font.Name = "Malgun Gothic"
        $slide.Shapes.Title.TextFrame.TextRange.Font.Size = 28
    }

    if (Test-Path $outputPath) {
        Remove-Item -LiteralPath $outputPath -Force
    }

    $presentation.SaveAs($outputPath)
}
finally {
    $presentation.Close()
    $pp.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($presentation) | Out-Null
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($pp) | Out-Null
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}

Write-Output "Created: $outputPath"
