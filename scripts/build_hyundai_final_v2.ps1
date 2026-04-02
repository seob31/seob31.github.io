$ErrorActionPreference = 'Stop'
$root = 'E:\Gilog\seob31.github.io'
$src = Join-Path $root 'Seob31_Backend_Portfolio.pptx'
$out = Join-Path $root 'Seob31_Hyundai_Backend_Portfolio_Final_v2.pptx'
$img = Join-Path $root 'assets\images\me\me1.png'

$pp = New-Object -ComObject PowerPoint.Application
$pp.Visible = -1
$pres = $pp.Presentations.Add()
$pres.PageSetup.SlideWidth = 1219
$pres.PageSetup.SlideHeight = 685

$msoTrue = -1
$ppLayoutBlank = 12
$blue = 0x722D00
$navy = 0x3D2316
$light = 0xFAF7F4
$white = 0xFFFFFF
$line = 0xD8CDBF
$text = 0x44372C
$sub = 0x7A6B5E
$accent = 0xA56A2A

function Add-Text($slide, $left, $top, $width, $height, $value, $size, $bold, $color, $align) {
  $shape = $slide.Shapes.AddTextbox(1, $left, $top, $width, $height)
  $range = $shape.TextFrame.TextRange
  $range.Text = $value
  $range.Font.Name = 'Malgun Gothic'
  $range.Font.Size = $size
  $range.Font.Bold = $(if ($bold) { $msoTrue } else { 0 })
  $range.Font.Color.RGB = $color
  $range.ParagraphFormat.Alignment = $align
  $shape.TextFrame.AutoSize = 1
  return $shape
}

function Add-Rect($slide, $left, $top, $width, $height, $fill, $lineColor) {
  $s = $slide.Shapes.AddShape(1, $left, $top, $width, $height)
  $s.Fill.ForeColor.RGB = $fill
  $s.Line.ForeColor.RGB = $lineColor
  return $s
}

function Add-Header($slide, $title, $subtitle, $page) {
  $bar = $slide.Shapes.AddShape(1, 0, 0, 1219, 66)
  $bar.Fill.ForeColor.RGB = $blue
  $bar.Line.Visible = 0
  Add-Text $slide 30 14 760 24 $title 24 $true $white 1 | Out-Null
  Add-Text $slide 30 41 760 14 $subtitle 9 $false 0xD7E5F7 1 | Out-Null
  Add-Text $slide 1140 18 50 18 $page 11 $true $white 3 | Out-Null
}

function Add-Bullets($slide, $left, $top, $width, $lines, $size) {
  $y = $top
  foreach ($line in $lines) {
    Add-Text $slide $left $y 16 18 '•' ($size + 1) $true $accent 1 | Out-Null
    Add-Text $slide ($left + 18) $y $width 18 $line $size $false $text 1 | Out-Null
    $y += [int]($size * 1.8)
  }
}

try {
  $s = $pres.Slides.Add(1, $ppLayoutBlank)
  $bg = $s.Shapes.AddShape(1, 0, 0, 1219, 685)
  $bg.Fill.ForeColor.RGB = $light
  $bg.Line.Visible = 0
  $top = $s.Shapes.AddShape(1, 0, 0, 1219, 220)
  $top.Fill.ForeColor.RGB = $blue
  $top.Line.Visible = 0
  Add-Text $s 65 60 450 20 'HYUNDAI MOTOR COMPANY' 15 $true $white 1 | Out-Null
  Add-Text $s 65 128 760 70 '웹 서비스 / 플랫폼 Backend 포트폴리오' 30 $true $white 1 | Out-Null
  Add-Text $s 65 240 800 40 '지원서와 경력기술서에 담기 어려운 프로젝트 맥락, 운영 경험, 문제 해결 방식을 중심으로 정리했습니다.' 16 $false $text 1 | Out-Null
  if (Test-Path $img) { $pimg = $s.Shapes.AddPicture($img, $false, $true, 930, 120, 190, 240); $pimg.LockAspectRatio = $msoTrue }
  Add-Text $s 65 365 900 120 "김길섭`nBackend Developer`nJava / Spring / API Integration / 운영 안정화 / Trouble Shooting" 22 $true $navy 1 | Out-Null
  Add-Text $s 65 590 900 20 '현대자동차 지원 직무: 웹 서비스 및 플랫폼 Backend 서버 개발/개선' 14 $false $sub 1 | Out-Null

  $s = $pres.Slides.Add(2, $ppLayoutBlank)
  Add-Header $s '왜 이 포트폴리오가 필요한가' '요약이 아니라 실제 업무 범위와 문제 해결 능력을 보여주기 위한 문서' '02'
  Add-Rect $s 40 95 550 515 $white $line | Out-Null
  Add-Rect $s 620 95 560 515 $white $line | Out-Null
  Add-Text $s 65 125 240 24 '지원서로는 부족한 내용' 20 $true $blue 1 | Out-Null
  Add-Bullets $s 65 170 470 @(
    '프로젝트 이름, 기간, 담당 역할만으로는 실제 기여 범위를 판단하기 어렵습니다.',
    '운영 중 어떤 문제를 다뤘는지, 어떻게 개선했는지, 어떤 구조를 이해했는지가 빠지기 쉽습니다.',
    '특히 백엔드 개발자는 기능 구현보다 운영 안정화와 장애 대응 경험이 중요합니다.'
  ) 15
  Add-Text $s 645 125 250 24 '이 포트폴리오에서 보여줄 내용' 20 $true $blue 1 | Out-Null
  Add-Bullets $s 645 170 470 @(
    'eCross, Saforus, Molida 등 실제 운영형 프로젝트에서 맡은 범위',
    'API 연계, 데이터 처리, 배포, 로그, 검증, Trouble Shooting 경험',
    '대표 프로젝트는 원본 내용을 유지해 압축하지 않고 읽히도록 구성',
    '현대자동차 직무와 연결되는 해석은 앞단에서만 정리하고 본문은 실제 경험 중심으로 제시'
  ) 15

  $s = $pres.Slides.Add(3, $ppLayoutBlank)
  Add-Header $s '현대자동차 직무 적합성' '공고의 요구사항과 실제 프로젝트 경험을 1:1로 연결' '03'
  Add-Rect $s 40 95 1140 515 $white $line | Out-Null
  Add-Bullets $s 70 135 1040 @(
    'Java / Spring 기반 Backend 개발 경험: eCross, Saforus, Molida, 코딩 테스트 서비스',
    'API 개발 및 연계 경험: eCross 인터페이스 처리, 강릉시 앱, 2022 API 프로젝트',
    '데이터 처리/저장/가공 구조 이해: eCross ETL 및 DB 검증 자동화, Molida, 철도 IC 라이브러리',
    '성능·안정성·확장성 고려 경험: eCross 구조 개선, 대용량 메시지 처리 안정화, 운영 로그 구조 개선',
    '모니터링/장애 대응/Trouble Shooting: eCross, Saforus, 제조 QA, 운영 서버 대응 경험',
    'Linux / Docker / Jenkins / AWS 환경 경험: Saforus, 코딩 테스트 서비스, Molida, eCross'
  ) 17
  Add-Text $s 70 500 1020 45 '핵심은 기능만 만드는 개발자가 아니라, 운영 중인 서비스를 이해하고 개선하면서 안정적으로 유지할 수 있는 백엔드 개발자라는 점입니다.' 18 $true $navy 1 | Out-Null

  $s = $pres.Slides.Add(4, $ppLayoutBlank)
  Add-Header $s '본문 읽는 순서' '원본 포트폴리오의 정보량은 유지하고, 대표 프로젝트를 중심으로 읽히게 구성' '04'
  Add-Rect $s 40 95 360 515 $white $line | Out-Null
  Add-Rect $s 430 95 360 515 $white $line | Out-Null
  Add-Rect $s 820 95 360 515 $white $line | Out-Null
  Add-Text $s 65 125 130 24 '대표 프로젝트' 20 $true $blue 1 | Out-Null
  Add-Bullets $s 65 170 280 @('eCross','Saforus','Molida') 17
  Add-Text $s 455 125 160 24 '보강 프로젝트' 20 $true $blue 1 | Out-Null
  Add-Bullets $s 455 170 280 @('코딩 테스트 서비스','강릉시 커뮤니티 앱','2022 API 프로젝트') 17
  Add-Text $s 845 125 180 24 '보조 경험' 20 $true $blue 1 | Out-Null
  Add-Bullets $s 845 170 280 @('철도 POS / IC 라이브러리','제조 QA','초기 프로젝트 경험') 17
  Add-Text $s 65 470 1030 42 '뒤에 이어지는 본문은 기존 포트폴리오의 프로젝트 내용을 최대한 살린 버전입니다. 즉, 요약본이 아니라 실제 경력 판단을 위한 본문입니다.' 17 $false $sub 1 | Out-Null

  $null = $pres.Slides.InsertFromFile($src, 4)

  $count = $pres.Slides.Count
  $s = $pres.Slides.Add($count + 1, $ppLayoutBlank)
  Add-Header $s '마무리' '지원서에서 보이지 않는 업무 깊이를 보완하는 포트폴리오' 'END'
  Add-Rect $s 40 95 1140 515 $white $line | Out-Null
  Add-Bullets $s 70 150 1030 @(
    '대표 프로젝트는 기능 나열이 아니라, 운영 중 어떤 문제를 다뤘고 어떤 구조를 이해했는지를 보여주기 위해 유지했습니다.',
    '세부 내용이 많은 이유는 지원서와 경력기술서만으로는 백엔드 개발자의 실제 역량을 충분히 판단하기 어렵기 때문입니다.',
    '현대자동차의 웹 서비스/플랫폼 Backend 직무에서도 저는 개발, 운영, 개선을 함께 보는 관점으로 기여할 수 있습니다.'
  ) 18

  if (Test-Path $out) { Remove-Item $out -Force }
  $pres.SaveAs($out)
  Write-Output "CREATED: $out"
}
finally {
  try { if ($pres) { $pres.Close() } } catch {}
  try { if ($pp) { $pp.Quit() } } catch {}
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
}

