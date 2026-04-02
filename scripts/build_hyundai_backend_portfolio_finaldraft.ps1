$ErrorActionPreference = 'Stop'

$root = 'E:\Gilog\seob31.github.io'
$out = Join-Path $root 'Seob31_Hyundai_Backend_Portfolio_2026_FinalDraft.pptx'
$ppPath = 'C:\Program Files\Microsoft Office\Office15\POWERPNT.EXE'
if (-not (Test-Path $ppPath)) { throw 'PowerPoint not found.' }

$imgMe = Join-Path $root 'assets\images\me\me1.png'
$imgEcross1 = Join-Path $root 'assets\images\project\ESB\transac.png'
$imgEcross2 = Join-Path $root 'assets\images\project\ESB\interface.png'
$imgEcross3 = Join-Path $root 'assets\images\project\ESB\log.png'
$imgForensic1 = Join-Path $root 'assets\images\project\forensic\upload.png'
$imgForensic2 = Join-Path $root 'assets\images\project\forensic\extract.png'
$imgCoding = Join-Path $root 'assets\images\project\coding\coding.png'
$imgGang1 = Join-Path $root 'assets\images\project\gangneung\main.png'
$imgGang2 = Join-Path $root 'assets\images\project\gangneung\mydata.png'
$imgMolida1 = Join-Path $root 'assets\images\project\molida\certMaker.png'
$imgMolida2 = Join-Path $root 'assets\images\project\molida\cert.png'

$ppLayoutBlank = 12
$msoTrue = -1
$blue = 0x722D00
$navy = 0x3D2316
$light = 0xFCF9F7
$white = 0xFFFFFF
$line = 0xD9CFC3
$text = 0x44372C
$sub = 0x7A6B5E
$accent = 0xA56A2A

function Add-Text($slide, $left, $top, $width, $height, $textValue, $size = 20, $bold = $false, $color = $text, $name = 'Malgun Gothic', $align = 1) {
    $shape = $slide.Shapes.AddTextbox(1, $left, $top, $width, $height)
    $tf = $shape.TextFrame.TextRange
    $tf.Text = $textValue
    $tf.Font.Name = $name
    $tf.Font.Size = $size
    $tf.Font.Bold = $(if ($bold) { $msoTrue } else { 0 })
    $tf.Font.Color.RGB = $color
    $tf.ParagraphFormat.Alignment = $align
    $shape.TextFrame.AutoSize = 1
    return $shape
}

function Add-Panel($slide, $left, $top, $width, $height, $fill = $white, $lineColor = $line) {
    $shape = $slide.Shapes.AddShape(1, $left, $top, $width, $height)
    $shape.Fill.ForeColor.RGB = $fill
    $shape.Line.ForeColor.RGB = $lineColor
    return $shape
}

function Add-Header($slide, $title, $subtitle, $page) {
    $bar = $slide.Shapes.AddShape(1, 0, 0, 1219, 64)
    $bar.Fill.ForeColor.RGB = $blue
    $bar.Line.Visible = 0
    Add-Text $slide 32 14 650 28 $title 24 $true $white | Out-Null
    Add-Text $slide 32 40 700 16 $subtitle 9 $false 0xD6E3F5 | Out-Null
    Add-Text $slide 1135 18 50 18 $page 11 $true $white 'Malgun Gothic' 3 | Out-Null
}

function Add-Bullets($slide, $left, $top, $width, $lines, $size = 15, $color = $text) {
    $y = $top
    foreach ($lineText in $lines) {
        Add-Text $slide $left $y 20 20 '?? ($size + 1) $true $accent | Out-Null
        Add-Text $slide ($left + 18) $y $width 20 $lineText $size $false $color | Out-Null
        $y += ($size * 1.75)
    }
}

$pp = $null
$pres = $null

try {
    $pp = New-Object -ComObject PowerPoint.Application
    $pp.Visible = $true
    $pres = $pp.Presentations.Add()
    $pres.PageSetup.SlideWidth = 1219
    $pres.PageSetup.SlideHeight = 685

    $s = $pres.Slides.Add(1, $ppLayoutBlank)
    $bg = $s.Shapes.AddShape(1, 0, 0, 1219, 685)
    $bg.Fill.ForeColor.RGB = $light
    $bg.Line.Visible = 0
    $top = $s.Shapes.AddShape(1, 0, 0, 1219, 210)
    $top.Fill.ForeColor.RGB = $blue
    $top.Line.Visible = 0
    Add-Text $s 65 58 450 20 'HYUNDAI MOTOR COMPANY' 15 $true $white | Out-Null
    Add-Text $s 65 130 780 70 '???쒕퉬??/ ?뚮옯??Backend ?ы듃?대━?? 28 $true $white | Out-Null
    Add-Text $s 65 215 740 55 '吏?먯꽌? 寃쎈젰湲곗닠?쒖뿉 ?닿린 ?대젮???꾨줈?앺듃 留λ씫, 臾몄젣 ?닿껐 諛⑹떇, ?댁쁺 寃쏀뿕??以묒떖?쇰줈 ?뺣━???곸꽭 ?ы듃?대━?ㅼ엯?덈떎.' 15 $false $text | Out-Null
    if (Test-Path $imgMe) {
        $pic = $s.Shapes.AddPicture($imgMe, $false, $true, 920, 110, 200, 250)
        $pic.LockAspectRatio = $msoTrue
    }
    Add-Text $s 65 350 1000 180 "源湲몄꽠`nBackend Developer`nJava / Spring / API Integration / ?댁쁺 ?덉젙??/ Trouble Shooting" 22 $true $navy | Out-Null
    Add-Text $s 65 585 800 20 '?쒖텧 ??? ?꾨??먮룞李????쒕퉬??諛??뚮옯??Backend 媛쒕컻/媛쒖꽑' 14 $false $sub | Out-Null

    $s = $pres.Slides.Add(2, $ppLayoutBlank)
    Add-Header $s '?ы듃?대━?ㅻ? ?대젃寃?援ъ꽦???댁쑀' '吏곷Т ?붽굔怨??꾨줈?앺듃 寃쏀뿕??1:1濡??곌껐???쏀엳?꾨줉 ?ш뎄?? '02'
    Add-Panel $s 40 92 550 520 | Out-Null
    Add-Panel $s 620 92 560 520 | Out-Null
    Add-Text $s 65 120 260 25 '?꾨??먮룞李?怨듦퀬 ?듭떖 ?붽뎄' 20 $true $blue | Out-Null
    Add-Bullets $s 65 165 470 @(
        'Java / Spring 湲곕컲 ???쒕퉬?ㅒ룻뵆?ロ뤌 Backend 媛쒕컻',
        '?대씪?댁뼵???붽뎄瑜?泥섎━?섎뒗 API ?묒꽦 諛?寃利?,
        '?곗씠??泥섎━/???媛怨?援ъ“ ?ㅺ퀎? DB ?댄빐',
        '?깅뒫쨌?덉젙?굿룻솗?μ꽦??怨좊젮???쒕쾭 ?꾪궎?띿쿂',
        '紐⑤땲?곕쭅, ?μ븷 ??? Trouble Shooting',
        'Linux / Docker / Jenkins / AWS ?섍꼍 ?댁쁺 寃쏀뿕'
    \) -size 15
    Add-Text $s 645 120 260 25 '?ы듃?대━?ㅼ뿉??蹂댁뿬二쇰젮??洹쇨굅' 20 $true $blue | Out-Null
    Add-Bullets $s 645 165 470 @(
        'eCross: ?댁쁺 援ъ“ 媛쒖꽑, 濡쒓퉭 泥닿퀎, Saga, ETL, 寃利??먮룞??,
        'Saforus: AWS쨌Docker쨌Jenkins 湲곕컲 ?쒕쾭 ?댁쁺怨?諛깆뿏??湲곕뒫 媛쒕컻',
        '肄붾뵫 ?뚯뒪???쒕퉬?? Spring Boot / Linux / Docker 湲곕컲 ?ㅽ뻾 ?섍꼍 援ъ텞',
        '媛뺣쫱???? ?몃? API ?곌퀎? ?쒕퉬??湲곕뒫 援ы쁽',
        'Molida: 利앸챸???앹꽦/寃利??댁옱?? 諛고룷 ?먮룞?? 蹂댁븞 ???,
        '泥좊룄쨌?쒖“ QA: ?덉젙?? ?덉쭏, ?꾩옣???쒖뒪???댄빐'
    \) -size 15

    $s = $pres.Slides.Add(3, $ppLayoutBlank)
    Add-Header $s '寃쎈젰 ?붿빟' '湲곗닠 ?ㅼ썙?쒓? ?꾨땲???ㅼ젣濡??댁삩 ?쇱쓽 踰붿쐞瑜?癒쇱? 蹂댁뿬二쇰뒗 ?ν몴' '03'
    Add-Panel $s 40 92 360 520 | Out-Null
    Add-Panel $s 420 92 360 520 | Out-Null
    Add-Panel $s 800 92 380 520 | Out-Null
    Add-Text $s 65 120 120 25 'Career' 20 $true $blue | Out-Null
    Add-Bullets $s 65 165 290 @(
        '諛깆뿏??媛쒕컻遺???댁쁺 ?덉젙?? ?μ븷 ??? 諛고룷 ?먮룞?붽퉴吏 ?④퍡 ?섑뻾',
        '?좉퇋 援ъ텞蹂대떎 ?댁쁺 以묒씤 ?쒕퉬?ㅼ쓽 援ъ“瑜??댄빐?섍퀬 媛쒖꽑?섎뒗 ??媛뺤젏',
        '?꾨줈?앺듃留덈떎 ??븷 踰붿쐞媛 ?볦뼱 API, DB, 濡쒓렇, ?명봽?쇰? ?④퍡 ?ㅻ８'
    \) -size 15
    Add-Text $s 445 120 150 25 'Core Strength' 20 $true $blue | Out-Null
    Add-Bullets $s 445 165 290 @(
        '臾몄젣瑜?湲곕뒫 ?⑥쐞媛 ?꾨땲???먮쫫 ?⑥쐞濡??뚯븙',
        '濡쒓렇? ?곗씠???먮쫫??洹쇨굅濡??먯씤 異붿쟻',
        '湲곕뒫 媛쒕컻 ?댄썑 ?댁쁺??由ъ뒪?щ? 以꾩씠??諛⑺뼢?쇰줈 蹂댁셿',
        '?뚯뒪?맞룰?利씲룸Ц?쒗솕源뚯? 留덈Т由ы븯???듦?'
    \) -size 15
    Add-Text $s 825 120 140 25 'Tech / Env' 20 $true $blue | Out-Null
    Add-Bullets $s 825 165 300 @(
        'Java, Spring, Spring Boot',
        'MySQL, MariaDB, Oracle, Redis ???곗씠??泥섎━ 寃쏀뿕',
        'Linux, Docker, Jenkins, AWS, IDC ?댁쁺 寃쏀뿕',
        'API ?곌퀎, ?몄쬆/利앸챸, 諛곗튂/ETL, 濡쒓렇 湲곕컲 遺꾩꽍',
        'JUnit, QA, 怨좉컼 ?댁뒋 ??? ?댁쁺 臾몄꽌??
    \) -size 15

    $s = $pres.Slides.Add(4, $ppLayoutBlank)
    Add-Header $s '????꾨줈?앺듃 1. eCross' '媛???꾨??먮룞李?怨듦퀬? 留욌떯???덈뒗 ?댁쁺???뚮옯??諛깆뿏??寃쏀뿕' '04'
    Add-Panel $s 40 92 520 520 | Out-Null
    Add-Panel $s 585 92 595 250 | Out-Null
    Add-Panel $s 585 362 595 250 | Out-Null
    Add-Text $s 65 120 140 25 'Overview' 20 $true $blue | Out-Null
    Add-Bullets $s 65 165 440 @(
        '湲곗뾽 媛??곌퀎瑜??꾪븳 ESB/?명꽣?섏씠???뚮옯???댁쁺 諛?媛쒖꽑 ?꾨줈?앺듃',
        '?ㅼ닔 ?쒖뒪???ъ씠?먯꽌 ?곗씠?곌? ?덉젙?곸쑝濡??먮Ⅴ?꾨줉 以묎컙 怨꾩링??愿由?,
        '?⑥닚 湲곕뒫 媛쒕컻蹂대떎 ?댁쁺 援ъ“, 濡쒓렇, ?μ븷 ??? ?곗씠??寃利앷퉴吏 ?④퍡 ?섑뻾',
        '?꾨?李?怨듦퀬??API ?곌퀎, ?댁쁺 ?덉젙?? Trouble Shooting怨?媛??吏곸젒?곸쑝濡??곌껐?섎뒗 寃쏀뿕'
    \) -size 15
    Add-Text $s 610 120 160 25 '?대떦 ??븷' 20 $true $blue | Out-Null
    Add-Bullets $s 610 165 510 @(
        '?쒕퉬???댁쁺 以?諛쒖깮?섎뒗 ?댁뒋 遺꾩꽍 諛??먯씤 異붿쟻',
        '?곗씠???뺥빀??寃利앷낵 諛곗튂/ETL ?먮쫫 媛쒖꽑',
        'MDC, Saga ??援ъ“ 媛쒖꽑???듯븳 ?댁쁺 媛?쒖꽦 ?뺣낫',
        '由대━利??덉젙?붾? ?꾪븳 寃利??먮룞?붿? 臾몄꽌??
    \) -size 14
    if (Test-Path $imgEcross1) {
        $p = $s.Shapes.AddPicture($imgEcross1, $false, $true, 830, 133, 315, 175)
        $p.LockAspectRatio = $msoTrue
    }
    Add-Text $s 610 390 190 25 '??以묒슂?쒓?' 20 $true $blue | Out-Null
    Add-Bullets $s 610 435 510 @(
        '?뚮옯??諛깆뿏?쒕뒗 湲곕뒫 援ы쁽蹂대떎 ?댁쁺 以?臾몄젣瑜?以꾩씠???λ젰??以묒슂??,
        '???꾨줈?앺듃?먯꽌 ????ㅼ젣 ?댁쁺 ?쒖뒪?쒖쓽 蹂묐ぉ怨??μ븷 ?먯씤??援ъ“?곸쑝濡??ㅻ쨾??,
        '利? ?꾨?李④? ?붽뎄?섎뒗 ?쒓컻諛?+ ?댁쁺 + 媛쒖꽑?앹쓽 ??踰붿쐞瑜?媛????利앸챸?섎뒗 ?щ???
    \) -size 14

    $s = $pres.Slides.Add(5, $ppLayoutBlank)
    Add-Header $s 'eCross ?곸꽭 ?깃낵' 'additional?먯꽌 媛뺥뻽???ъ씤?몃? 寃쎈젰 ?ы듃?대━??臾몃㎘?쇰줈 ?ш뎄?? '05'
    Add-Panel $s 40 92 360 520 | Out-Null
    Add-Panel $s 420 92 360 520 | Out-Null
    Add-Panel $s 800 92 380 520 | Out-Null
    Add-Text $s 65 120 120 25 '援ъ“ 媛쒖꽑' 20 $true $blue | Out-Null
    Add-Bullets $s 65 165 290 @(
        'MDC ?곸슜?쇰줈 ?붿껌 ?먮쫫 異붿쟻?깆쓣 ?믪뿬 濡쒓렇 遺꾩꽍 ?⑥쑉 媛쒖꽑',
        'Saga ?⑦꽩 寃???곸슜 寃쏀뿕???듯빐 遺꾩궛 泥섎━ ?먮쫫????紐낇솗?섍쾶 愿由?,
        'OOM ?댁뒋 ???怨쇱젙?먯꽌 硫붾え由??ъ슜 ?⑦꽩怨?泥섎━ 援ъ“瑜??먭?'
    \) -size 14
    Add-Text $s 445 120 120 25 '?곗씠??泥섎━' 20 $true $blue | Out-Null
    Add-Bullets $s 445 165 290 @(
        'ETL 泥섎━ ?먮쫫???먭??섍퀬 ?댁쁺 愿?먯뿉???덉젙?깆쓣 ?믪씠??諛⑺뼢?쇰줈 蹂댁셿',
        'DB Validation ?먮룞?붾? ?듯빐 由대━利??꾪썑 ?뺥빀???먭? 遺???꾪솕',
        '?섎룞 ?뺤씤??以꾩씠怨?諛섎났 媛?ν븳 寃利??먮쫫??留뚮뱶????湲곗뿬'
    \) -size 14
    Add-Text $s 825 120 170 25 '?꾨?李?吏곷Т? ?곌껐' 20 $true $blue | Out-Null
    Add-Bullets $s 825 165 310 @(
        'API ?곌퀎 ?쒖뒪???댁쁺 寃쏀뿕',
        '臾몄젣 吏꾨떒 諛??닿껐 諛⑹븞 ?꾩텧',
        '?곗씠??泥섎━ 援ъ“ ?댄빐? 寃利?泥닿퀎 蹂닿컯',
        '?댁쁺 ?쒕퉬??媛쒖꽑 寃쏀뿕??洹쇨굅濡????꾪궎?띿쿂 愿??
    \) -size 14
    if (Test-Path $imgEcross2) {
        $p = $s.Shapes.AddPicture($imgEcross2, $false, $true, 845, 365, 140, 150)
        $p.LockAspectRatio = $msoTrue
    }
    if (Test-Path $imgEcross3) {
        $p = $s.Shapes.AddPicture($imgEcross3, $false, $true, 1000, 365, 140, 150)
        $p.LockAspectRatio = $msoTrue
    }

    $s = $pres.Slides.Add(6, $ppLayoutBlank)
    Add-Header $s '????꾨줈?앺듃 2. Saforus' '?쒕쾭 湲곕뒫 媛쒕컻, ?명봽???댁쁺, ?뺥솗??媛쒖꽑???④퍡 寃쏀뿕???꾨줈?앺듃' '06'
    Add-Panel $s 40 92 520 520 | Out-Null
    Add-Panel $s 585 92 595 520 | Out-Null
    Add-Text $s 65 120 140 25 'Overview' 20 $true $blue | Out-Null
    Add-Bullets $s 65 165 440 @(
        '踰뺢낵???щ젋??愿???쒕퉬?ㅼ뿉??諛깆뿏??湲곕뒫怨??댁쁺???④퍡 ?대떦',
        'Java 湲곕컲 ?쒕쾭 媛쒕컻 ?몄뿉??AWS, Docker, Jenkins瑜??쒖슜???댁쁺 ?섍꼍??寃쏀뿕',
        '?쒕퉬???덉쭏???꾪빐 ?뺥솗?꾩? ?곗씠??泥섎━ ?먮쫫???④퍡 ?ㅻ， ?먯씠 媛뺤젏'
    \) -size 15
    if (Test-Path $imgForensic1) {
        $p = $s.Shapes.AddPicture($imgForensic1, $false, $true, 95, 355, 190, 150)
        $p.LockAspectRatio = $msoTrue
    }
    if (Test-Path $imgForensic2) {
        $p = $s.Shapes.AddPicture($imgForensic2, $false, $true, 305, 355, 190, 150)
        $p.LockAspectRatio = $msoTrue
    }
    Add-Text $s 610 120 170 25 '二쇱슂 ??븷怨??깃낵' 20 $true $blue | Out-Null
    Add-Bullets $s 610 165 505 @(
        '?듭떖 紐⑤뱢 媛쒕컻怨??좎?蹂댁닔瑜??대떦?섎ŉ 湲곕뒫 ?뺥솗???μ긽??湲곗뿬',
        'AWS, Docker, Jenkins 湲곕컲 ?댁쁺 ?섍꼍?먯꽌 諛고룷? ?먭? ?꾨줈?몄뒪瑜?寃쏀뿕',
        '?댁쁺 以?諛쒓껄?섎뒗 臾몄젣瑜?湲곕뒫 ?섏젙??洹몄튂吏 ?딄퀬 援ъ“?곸쑝濡?媛쒖꽑',
        '諛깆뿏??媛쒕컻?먭? ?쒕퉬???댁쁺怨?諛고룷 ?먮쫫源뚯? ?댄빐?섍퀬 ?덈떎???먯쓣 蹂댁뿬二쇰뒗 ?щ?'
    \) -size 15
    Add-Text $s 610 430 190 25 '吏곷Т ?곹빀?? 20 $true $blue | Out-Null
    Add-Bullets $s 610 475 505 @(
        'Java Backend 媛쒕컻',
        'Cloud / Docker / Jenkins 寃쏀뿕',
        '?댁쁺怨?諛고룷瑜?怨좊젮???쒕쾭 媛쒕컻',
        '?뺥솗?꾩? ?덉쭏???④퍡 蹂대뒗 ?쒕퉬??媛쒕컻 ?쒕룄'
    \) -size 14

    $s = $pres.Slides.Add(7, $ppLayoutBlank)
    Add-Header $s '2022 API / ?뚮옯??諛깆뿏??寃쏀뿕' '吏㏃? ?꾨줈?앺듃?쇰룄 API ?ㅺ퀎? ?곌퀎 寃쏀뿕??蹂댁뿬二쇰뒗 洹쇨굅???대┝' '07'
    Add-Panel $s 40 92 560 520 | Out-Null
    Add-Panel $s 620 92 560 520 | Out-Null
    Add-Text $s 65 120 250 25 '?몄궗愿由ы삎 硫뷀?踰꾩뒪 ?쒕퉬?? 18 $true $blue | Out-Null
    Add-Bullets $s 65 165 470 @(
        'Java, Spring 湲곕컲 諛깆뿏??湲곕뒫 媛쒕컻',
        '?ъ슜??議곗쭅/?쒕퉬???곌퀎瑜??꾪븳 API 泥섎━? ?곗씠???먮쫫 ?댄빐',
        '?꾨줈?앺듃 蹂대쪟濡??명빐 寃곌낵蹂대떎 怨쇱젙???⑥븯吏留? ?뚮옯?쇳삎 援ъ“瑜?寃쏀뿕???щ?',
        '?꾨?李?怨듦퀬???쒗겢?쇱씠?명듃 ?붽뎄 泥섎━??Backend 肄붾뱶 ?묒꽦 諛?寃利앪앷낵 ?곌껐 媛??
    \) -size 14
    Add-Text $s 645 120 210 25 '?곗뾽?먯썝遺 ?꾩옄怨꾩빟 ?쒖뒪?? 18 $true $blue | Out-Null
    Add-Bullets $s 645 165 470 @(
        '吏㏃? 湲곌컙 ???ъ엯?섏뼱 湲곕뒫 媛쒕컻怨??좎?蹂댁닔瑜??섑뻾',
        '湲곗〈 ?쒖뒪??留λ씫??鍮좊Ⅴ寃??뚯븙?섍퀬 ?꾩슂???섏젙 ?ы빆??諛섏쁺',
        '?댁쁺 以묒씤 ?쒕퉬?ㅼ뿉 ?덉쟾?섍쾶 蹂寃쎌쓣 ?곸슜?섎뒗 湲곕낯湲곕? 蹂댁뿬二쇰뒗 ?щ?',
        '?洹쒕え 硫붿씤 ?꾨줈?앺듃蹂대떎???쒕튌瑜??곸쓳?κ낵 ?ㅻТ ??묐젰?앹쓣 蹂댁셿??二쇰뒗 寃쏀뿕'
    \) -size 14

    $s = $pres.Slides.Add(8, $ppLayoutBlank)
    Add-Header $s '?쒕퉬??援ъ텞 寃쏀뿕 1. 肄붾뵫 ?뚯뒪??/ 媛뺣쫱???? '?댁쁺???꾨줈?앺듃 ?몄뿉???ъ슜??湲곕뒫 以묒떖 ?쒕퉬?ㅻ? 援ъ텞??寃쏀뿕' '08'
    Add-Panel $s 40 92 560 520 | Out-Null
    Add-Panel $s 620 92 560 520 | Out-Null
    Add-Text $s 65 120 180 25 '肄붾뵫 ?뚯뒪???쒕퉬?? 18 $true $blue | Out-Null
    Add-Bullets $s 65 165 470 @(
        'Spring Boot 湲곕컲?쇰줈 臾몄젣 ?쒖텧/?ㅽ뻾 ?섍꼍??援ъ꽦???꾨줈?앺듃',
        'Linux ?쒕쾭, Docker 湲곕컲 ?ㅽ뻾 ?섍꼍???ㅻ（硫?諛깆뿏?쒖? ?댁쁺 ?섍꼍???④퍡 寃쏀뿕',
        '?ъ슜???붿껌???덉쟾?섍쾶 泥섎━?섍린 ?꾪븳 ?ㅽ뻾 ?먮쫫 ?ㅺ퀎 寃쏀뿕???⑥븘 ?덉쓬',
        '?꾨?李?怨듦퀬??Linux, Docker, ?쒕쾭 ?댁쁺 ?댄빐? ?곌껐?섎뒗 ?щ?'
    \) -size 14
    if (Test-Path $imgCoding) {
        $p = $s.Shapes.AddPicture($imgCoding, $false, $true, 85, 395, 430, 140)
        $p.LockAspectRatio = $msoTrue
    }
    Add-Text $s 645 120 190 25 '媛뺣쫱??而ㅻ??덊떚 ?? 18 $true $blue | Out-Null
    Add-Bullets $s 645 165 470 @(
        '怨듦났 API 諛??쒕퉬??湲곕뒫 ?곌퀎瑜??ы븿??紐⑤컮??諛깆뿏???꾨줈?앺듃',
        '?ъ슜??湲곕뒫 援ы쁽怨??곗씠???곌퀎 怨쇱젙??寃쏀뿕?섎ŉ API ?쒖슜 ??쓣 ?볧옒',
        '?꾨?李?愿?먯뿉?쒕뒗 ?몃? ?쒖뒪???곌퀎? ?ъ슜???쒕퉬??泥섎━ 寃쏀뿕?쇰줈 ?쏀옄 ???덉쓬'
    \) -size 14
    if (Test-Path $imgGang1) {
        $p = $s.Shapes.AddPicture($imgGang1, $false, $true, 655, 395, 205, 140)
        $p.LockAspectRatio = $msoTrue
    }
    if (Test-Path $imgGang2) {
        $p = $s.Shapes.AddPicture($imgGang2, $false, $true, 875, 395, 205, 140)
        $p.LockAspectRatio = $msoTrue
    }

    $s = $pres.Slides.Add(9, $ppLayoutBlank)
    Add-Header $s '????꾨줈?앺듃 3. Molida' '?꾨찓?몄? 釉붾줉泥댁씤?댁?留? ?ъ씤?몃뒗 ?댁쁺??諛깆뿏?쒖? 利앸챸??泥섎━ ?먮룞?? '09'
    Add-Panel $s 40 92 560 520 | Out-Null
    Add-Panel $s 620 92 560 520 | Out-Null
    Add-Text $s 65 120 110 25 'Overview' 20 $true $blue | Out-Null
    Add-Bullets $s 65 165 470 @(
        '援먯쑁 ?대젰쨌?먭꺽利앸챸 愿由ъ? 利앸챸??諛쒓툒/寃利?湲곕뒫???ы븿???쒕퉬??,
        '?ъ슜??湲곕뒫, 湲곌? 湲곕뒫, ?댁쁺 ?섏씠吏源뚯? ?ы븿???꾩껜 ?쒕퉬???먮쫫??寃쏀뿕',
        '釉붾줉泥댁씤?대씪???대쫫蹂대떎 ?쒖쬆紐낆꽌 ?앹꽦/諛쒓툒/寃利앪앹쓣 ?쒕퉬?ㅼ뿉 ?덉젙?곸쑝濡??듯빀???먯씠 以묒슂'
    \) -size 14
    Add-Text $s 65 355 180 25 '?대떦 ??븷怨??섎?' 20 $true $blue | Out-Null
    Add-Bullets $s 65 400 470 @(
        '?숈뒿?대젰 愿由? ?먮룞 ?깅줉, 利앸챸???앹꽦/寃利? 蹂몄씤 ?몄쬆 湲곕뒫 媛쒕컻',
        'IDC ?쒕쾭 ?댁쁺, 諛고룷 ?먮룞?? 蹂댁븞 痍⑥빟??????섑뻾',
        '?댁쁺 以묒씤 ?쒕퉬?ㅼ뿉 利앸챸 濡쒖쭅???댁옱?뷀빐 ?몃? ?섏〈?깆쓣 ??땄'
    \) -size 14
    if (Test-Path $imgMolida1) {
        $p = $s.Shapes.AddPicture($imgMolida1, $false, $true, 655, 165, 210, 150)
        $p.LockAspectRatio = $msoTrue
    }
    if (Test-Path $imgMolida2) {
        $p = $s.Shapes.AddPicture($imgMolida2, $false, $true, 885, 165, 210, 150)
        $p.LockAspectRatio = $msoTrue
    }
    Add-Text $s 645 355 200 25 '?꾨?李?愿???댁꽍' 20 $true $blue | Out-Null
    Add-Bullets $s 645 400 470 @(
        'Java 諛깆뿏??湲곕뒫 媛쒕컻',
        '諛고룷 ?먮룞?붿? ?댁쁺 ???寃쏀뿕',
        '蹂댁븞 ?댁뒋 ???寃쏀뿕',
        '?ъ슜???쒕퉬?ㅼ? ?댁쁺 湲곕뒫???④퍡 蹂??꾨줈?앺듃'
    \) -size 14

    $s = $pres.Slides.Add(10, $ppLayoutBlank)
    Add-Header $s '蹂댁“ 寃쏀뿕 1. 泥좊룄 POS / 泥좊룄 IC ?쇱씠釉뚮윭由? '?꾨찓?몄? ?ㅻⅤ吏留??덉젙?깃낵 ?곗씠???먮쫫??以묒떆?섎뒗 ?쒖뒪??寃쏀뿕' '10'
    Add-Panel $s 40 92 560 520 | Out-Null
    Add-Panel $s 620 92 560 520 | Out-Null
    Add-Text $s 65 120 170 25 '泥좊룄 POS 寃곗젣 ?쒖뒪?? 18 $true $blue | Out-Null
    Add-Bullets $s 65 165 470 @(
        '泥좊룄 ?쒖뒪?쒖쓽 寃곗젣 ?낅Т ?꾨줈?앺듃?먯꽌 ?좉퇋 紐⑤뱢 媛쒕컻怨??좎?蹂댁닔 ?섑뻾',
        '媛쒕컻 臾몄꽌 ?묒꽦怨?怨좉컼 ?붽뎄?ы빆 諛섏쁺??蹂묓뻾',
        '?ㅼ젣 寃곗젣 ?먮쫫怨??댁쁺 ?댁뒋瑜?媛源뚯씠??蹂대ŉ ?덉젙??以묒떖 ?ш퀬瑜??숈뒿'
    \) -size 14
    Add-Text $s 645 120 160 25 '泥좊룄 IC ?쇱씠釉뚮윭由? 18 $true $blue | Out-Null
    Add-Bullets $s 645 165 470 @(
        'IC 移대뱶 ?곗씠??泥섎━ ?쇱씠釉뚮윭由?媛쒕컻 ?꾨줈?앺듃',
        '?곗씠???섏쭛 援ъ“ 媛쒖꽑, Perl 湲곕컲 濡쒓렇 ?섏쭛 湲곕뒫 媛쒖꽑, JUnit ?뚯뒪??肄붾뱶 ?묒꽦',
        '濡쒓렇 湲곕컲 臾몄젣 異붿쟻怨??곗씠??援ъ“ ?댄빐 痢〓㈃?먯꽌 吏湲덉쓽 ?댁쁺????웾??諛뷀깢????寃쏀뿕'
    \) -size 14

    $s = $pres.Slides.Add(11, $ppLayoutBlank)
    Add-Header $s '蹂댁“ 寃쏀뿕 2. ?쒖“ QA / 珥덇린 ?꾨줈?앺듃' '?꾨?李?吏?먯뿉???섎? ?덈뒗 ?덉쭏 媛먭컖怨??ㅻТ ?곸쓳?μ쓽 洹쇨굅' '11'
    Add-Panel $s 40 92 560 520 | Out-Null
    Add-Panel $s 620 92 560 520 | Out-Null
    Add-Text $s 65 120 210 25 '?쒖“ ?곗뾽 ?쒖뒪??QA' 18 $true $blue | Out-Null
    Add-Bullets $s 65 165 470 @(
        '?쒖“ ?꾩옣 ?쒖뒪?쒖쓽 ?덉쭏 蹂댁쬆 由щ뱶 ??븷 ?섑뻾',
        '寃고븿 異붿쟻, ?댁뒋 ?ы쁽, ?뚯뒪???쒕굹由ъ삤 愿由????덉쭏 ?꾨줈?몄뒪瑜?二쇰룄',
        '?꾨?李⑥쿂???댁쁺 ?덉젙?깃낵 ?꾨줈?몄뒪媛 以묒슂??議곗쭅?먯꽌 媛뺤젏?쇰줈 ?쏀옄 ???덈뒗 寃쏀뿕'
    \) -size 14
    Add-Text $s 645 120 170 25 '珥덇린 ?꾨줈?앺듃 寃쏀뿕' 18 $true $blue | Out-Null
    Add-Bullets $s 645 165 470 @(
        'E-?щ떇 ??珥덇린 ?꾨줈?앺듃???꾩옱 ?????웾蹂대떎 湲곕낯湲곕? 蹂댁뿬二쇰뒗 ??븷',
        '???꾨찓???곸쓳, ?붽뎄?ы빆 ?댄빐, 湲곕뒫 援ы쁽, ?뚯뒪?멸퉴吏 ?ㅻТ ?ъ씠?댁쓣 ?듯옒',
        '?꾩옱??諛깆뿏???댁쁺 ??웾? ??珥덇린 寃쏀뿕 ?꾩뿉???꾩쟻?섏뼱 ?뺤꽦??
    \) -size 14

    $s = $pres.Slides.Add(12, $ppLayoutBlank)
    Add-Header $s '吏곷Т ?붽뎄?ы빆 留ㅽ븨' '?꾨??먮룞李?怨듦퀬瑜??쎈뒗 ?щ엺??諛붾줈 ?뺤씤?????덈룄濡??붿빟 ?뺣━' '12'
    Add-Panel $s 40 92 1140 520 | Out-Null
    Add-Text $s 70 120 250 25 '怨듦퀬 ?붽뎄?ы빆 ???ы듃?대━??洹쇨굅' 20 $true $blue | Out-Null
    Add-Bullets $s 70 170 1040 @(
        '???쒕퉬???뚮옯??Backend 媛쒕컻 ??eCross, Saforus, Molida, 肄붾뵫 ?뚯뒪???쒕퉬??,
        'API 媛쒕컻 諛??곌퀎 ??eCross, 媛뺣쫱???? 2022 API ?꾨줈?앺듃',
        '?곗씠??泥섎━/???媛怨?援ъ“ ?댄빐 ??eCross ETL/DB Validation, 泥좊룄 IC ?쇱씠釉뚮윭由? Molida',
        '?깅뒫/?덉젙???뺤옣??怨좊젮 ??eCross 援ъ“ 媛쒖꽑, ?댁쁺 濡쒓렇 異붿쟻, 諛고룷쨌寃利??먮룞??,
        '紐⑤땲?곕쭅/?μ븷 ?먯?/?몃윭釉붿뒋????eCross, Saforus, 泥좊룄/?쒖“ QA 寃쏀뿕',
        'CI/CD, Linux, Docker, AWS ??Saforus, 肄붾뵫 ?뚯뒪?? Molida ?댁쁺 寃쏀뿕'
    \) -size 16
    Add-Text $s 70 500 1000 40 '?듭떖? 湲곕뒫留?援ы쁽?섎뒗 媛쒕컻?먭? ?꾨땲?? ?댁쁺 以묒씤 ?쒕퉬?ㅼ쓽 臾몄젣瑜??뚯븙?섍퀬 媛쒖꽑?섎㈃???덉젙?곸쑝濡??댁쁺?????덈뒗 諛깆뿏??媛쒕컻?먮씪???먯엯?덈떎.' 18 $true $navy | Out-Null

    $s = $pres.Slides.Add(13, $ppLayoutBlank)
    Add-Header $s '留덈Т由? '吏?먯꽌?먯꽌 遺議깊븳 留λ씫??梨꾩슦湲??꾪븳 ?ы듃?대━?? '13'
    Add-Panel $s 40 92 1140 520 | Out-Null
    Add-Text $s 70 140 350 28 '?????ы듃?대━?ㅺ? ?꾩슂?쒓?' 24 $true $blue | Out-Null
    Add-Bullets $s 70 210 1030 @(
        '吏?먯꽌? 寃쎈젰湲곗닠?쒕뒗 ??븷怨?湲곌컙? 蹂댁뿬二쇱?留? ?ㅼ젣濡??대뼡 臾몄젣瑜??대뼸寃??ㅻ쨾?붿?源뚯? 異⑸텇???ㅻ챸?섍린 ?대졄?듬땲??',
        '???ы듃?대━?ㅻ뒗 ?꾨줈?앺듃蹂꾨줈 留≪? 踰붿쐞, 臾몄젣瑜?蹂대뒗 諛⑹떇, ?댁쁺 ?덉젙??寃쏀뿕, ?곗씠?곗? 濡쒓렇瑜??ㅻ（???쒕룄瑜??④퍡 蹂댁뿬二쇨린 ?꾪빐 留뚮뱾?덉뒿?덈떎.',
        '?꾨??먮룞李⑥쓽 ???쒕퉬???뚮옯??Backend 吏곷Т?먯꽌?? ????⑥닚 援ы쁽蹂대떎 ?댁쁺 媛?ν븳 援ъ“? 臾몄젣 ?닿껐 ??웾?쇰줈 湲곗뿬?????덉뒿?덈떎.'
    \) -size 18
    Add-Text $s 70 520 900 20 '?쒖텧 ??理쒖쥌 ?뺤씤 沅뚯옣: ?대쫫/?곕씫泥?留곹겕, ?쒗쁽 ?섏쐞, 媛뺤“ ?꾨줈?앺듃 ?쒖꽌, 遺덊븘???꾨줈?앺듃 ??젣 ?щ?' 15 $false $sub | Out-Null

    if (Test-Path $out) {
        Remove-Item $out -Force
    }
    $pres.SaveAs($out)
    Write-Output "CREATED: $out"
}
finally {
    if ($pres) {
        try { $pres.Close() } catch {}
    }
    if ($pp) {
        try { $pp.Quit() } catch {}
    }
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
}
