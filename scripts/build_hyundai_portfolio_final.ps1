$ErrorActionPreference = 'Stop'
$workspace = (Get-Location).Path
$src = Join-Path $workspace 'hyundai_portfolio_latest_vertical_part2_cleanup.pptx'
$out = Join-Path $workspace 'hyundai_portfolio_final.pptx'
$keep = @(1,2,3,4,5,9,10,11,12,14,16,18,19,22,23,24,25,26,27,28,29,30,32,34,35,36,37,39,41,43,45,47,48,50,6)

$pp = New-Object -ComObject PowerPoint.Application
$pp.Visible = -1
$srcPres = $pp.Presentations.Open($src, $false, $true, $false)
$new = $pp.Presentations.Add()

try {
    $new.PageSetup.SlideWidth = $srcPres.PageSetup.SlideWidth
    $new.PageSetup.SlideHeight = $srcPres.PageSetup.SlideHeight

    $idx = 0
    foreach ($n in $keep) {
        $srcPres.Slides.Item($n).Copy()
        $idx++
        $new.Slides.Paste($idx) | Out-Null
    }

    $contents = $new.Slides.Add(6, 12)
    $contents.Background.Fill.ForeColor.RGB = (245 + (247 * 256) + (250 * 65536))
    $bar = $contents.Shapes.AddShape(1, 0, 0, 540, 52)
    $bar.Fill.ForeColor.RGB = (0 + (45 * 256) + (114 * 65536))
    $bar.Line.Visible = 0 | Out-Null

    $title = $contents.Shapes.AddTextbox(1, 28, 86, 470, 36)
    $title.TextFrame.TextRange.Text = '상세 포트폴리오 구성'
    $title.TextFrame.TextRange.Font.NameFarEast = '맑은 고딕'
    $title.TextFrame.TextRange.Font.Name = 'Malgun Gothic'
    $title.TextFrame.TextRange.Font.Size = 24
    $title.TextFrame.TextRange.Font.Bold = -1
    $title.TextFrame.TextRange.Font.Color.RGB = (18 + (34 * 256) + (66 * 65536))
    $title.Line.Visible = 0
    $title.Fill.Visible = 0

    $bodyText = "1. eCross`r`n2. Saforus`r`n3. HR Metaverse / Electronic Contract / Coding Test`r`n4. Gangneung Citizen App`r`n5. Molida`r`n6. Blockchain Certificate Portal`r`n7. Railway POS / IC Library / Manufacturing QA / E-Learning`r`n`r`n각 프로젝트 뒤에는 관련 additional 내용을 바로 배치해,`r`n기술적 깊이와 개선 근거를 함께 확인할 수 있도록 구성했습니다.`r`n`r`n최종본에서는 코드 원문 위주의 장표와 정보 밀도가 낮은 장표를 줄여`r`n제출용 포트폴리오 관점에서 읽기 쉽게 정리했습니다."
    $body = $contents.Shapes.AddTextbox(1, 32, 150, 470, 520)
    $body.TextFrame.TextRange.Text = $bodyText
    $body.TextFrame.TextRange.Font.NameFarEast = '맑은 고딕'
    $body.TextFrame.TextRange.Font.Name = 'Malgun Gothic'
    $body.TextFrame.TextRange.Font.Size = 16
    $body.TextFrame.TextRange.Font.Color.RGB = (38 + (49 * 256) + (73 * 65536))
    $body.Line.Visible = 0
    $body.Fill.Visible = 0

    foreach ($slide in $new.Slides) {
        foreach ($shape in @($slide.Shapes)) {
            try {
                if ($shape.HasTextFrame -and $shape.TextFrame.HasText) {
                    $text = $shape.TextFrame.TextRange.Text
                    $text = $text -replace '^\s*•\s*--\s*$', ''
                    $text = $text -replace '^About Me$', '프로필'
                    $text = $text -replace 'HYUNDAI MOTORS', 'HYUNDAI MOTOR COMPANY'
                    $text = $text -replace '지원 포지션 가정:', '지원 포지션:'
                    $text = $text -replace 'EAI/ESB 연계 솔루션 개발 \(eCross\) - 개발 화면 예시', 'eCross 화면 예시'
                    $text = $text -replace '미디어 파일 포렌식 서비스 개발 \(Saforus\) - 개발 화면 예시', 'Saforus 화면 예시'
                    $text = $text -replace '강릉시 커뮤니티 앱 \(내손안에 강릉\) - 개발 화면 예시', '강릉시 커뮤니티 앱 화면 예시'
                    $text = $text -replace '블록체인 기반 교육 이력 및 자격증 인증 서비스 \(Molida\) - 개발 화면 예시', 'Molida 화면 예시'
                    $text = $text -replace '증명서 생성 기능 일부 예시 화면 예시', '증명서 생성 기능 결과 예시'
                    $shape.TextFrame.TextRange.Text = $text.Trim()
                    if ([string]::IsNullOrWhiteSpace($shape.TextFrame.TextRange.Text)) { $shape.Delete() }
                }
            } catch {}
        }
    }

    if (Test-Path $out) { Remove-Item -LiteralPath $out -Force }
    $new.SaveAs($out)
}
finally {
    try { $new.Close() } catch {}
    try { $srcPres.Close() } catch {}
    try { $pp.Quit() } catch {}
    try { [System.Runtime.Interopservices.Marshal]::ReleaseComObject($new) | Out-Null } catch {}
    try { [System.Runtime.Interopservices.Marshal]::ReleaseComObject($srcPres) | Out-Null } catch {}
    try { [System.Runtime.Interopservices.Marshal]::ReleaseComObject($pp) | Out-Null } catch {}
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}

Write-Output "Created: $out"
