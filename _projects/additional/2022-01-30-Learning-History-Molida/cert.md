---
layout: page
title: "증명서 생성 기능 일부 예시"
permalink: /projects/additional/2022-01-30-Learning-History-Molida/cert/
---

<a href="javascript:history.back()" class="btn btn-outline-success btn-sm">
  ← 뒤로가기
</a>

# 증명서 생성 기능 일부 예시
<br>

## 개요
사용자가 직접 증명서를 생성·편집할 수 있도록 하는 동적 문서 생성 시스템입니다. 생성된 증명서 양식은 수정, 삭제가 가능합니다. doc, 이미지 등의 배경이 될 수 있는 파일을 업로드하여 배경을 만들 수 있으며, 그 배경으로 증명서를 제작할 수 있습니다.

<br>
## 핵심 코드 예제
#### 화면 코드
```html
// 그림 그리는 곳
<c:forEach items="${certInfo.pageList}" var="page" end="${certInfo.pageList.size()}" varStatus="status">
  <div class="pageNum" style="display: none;">${status.count} / ${status.end}</div>

  <div id="drawingBox${status.count}"
       data-page-id="${page.pageId}"
       class="drawing-box"
       style="background-image: url('/file/view?fileId=${page.fileId}')"
       onclick="onSelect(this)"
       onmouseenter="onHover(this)">

    <c:forEach items="${certInfo.paramList}" var="param">
      <c:if test="${param.pageId eq page.pageId}">
        
        <c:choose>
          <!-- 공통 파라미터 -->
          <c:when test="${param.isCommon eq 'Y'}">
            
            <c:choose>
              <!-- 텍스트 타입 -->
              <c:when test="${param.type eq 'TEXT'}">
                <div id="${param.id}"
                     data-param-id="${param.paramSeq}"
                     class="input-box"
                     title="${param.name}"
                     style="${param.style}"
                     contenteditable="true"
                     onclick="onSelect(this)">
                  ${param.displayValue}
                </div>
              </c:when>

              <!-- 이미지 타입 -->
              <c:otherwise>
                <div id="${param.id}"
                     data-param-id="${param.paramSeq}"
                     class="image-box"
                     title="${param.name}"
                     style="background-image: url('/file/view?fileId=${param.fileId}'); ${param.style}"
                     onclick="onSelect(this)">
                </div>
              </c:otherwise>

            </c:choose>
          </c:when>

          <!-- 개별 파라미터 -->
          <c:when test="${param.isCommon eq 'N'}">
            <div id="${param.id}"
                 data-param-id="${param.paramSeq}"
                 class="input-box"
                 title="데이터 값"
                 style="${param.style}"
                 contenteditable="true"
                 onclick="onSelect(this)">
              ${param.value}
            </div>
          </c:when>

        </c:choose>

      </c:if>
    </c:forEach>

  </div>

  <div class="barcode-area">바코드 : </div>
</c:forEach>
```

#### JavaScript 코드
```javascript
// 마우스 엔터 드롭 앤 드롭 클로닝
function onmouseEnter(obj){
	$selectedObj = obj;
	$($selectedObj).droppable({
		accept: '#menuBar .drag',
		ontainment: $selectedObj,
	    drop: function( event, ui ) {
	    	dragMoveBox(ui, $selectedObj);
		} 
	});
}

// 배경화면 기본 세로 세팅
function verticalSize(){
	$('.drawingBox_css').css('width',hWidth);
	$('.drawingBox_css').css('height',hHeight);
	$('.drawingBox_css').css('background-repeat','no-repeat');
	$('.drawingBox_css').css('display','block');
	$('.drawingBox_css').css('position','relative');
	$('.drawingBox_css').css('margin-bottom','10px');
	$('.drawingBox_css').css('background-size', hWidth+" "+hHeight);
	attachPage();
	putterBarCode();
}

// 배경화면  기본 가로 세팅
function horizontalSize() {
	$('.drawingBox_css').css('width',wWidth);
	$('.drawingBox_css').css('height',wHeight);
	$('.drawingBox_css').css('background-size',wWidth+' '+ wHeight);
	$('.drawingBox_css').css('background-repeat','no-repeat');
	$('.drawingBox_css').css('display','block');
	$('.drawingBox_css').css('position','relative');
	$('.drawingBox_css').css('margin-bottom','10px');
	attachPage();
	putterBarCode();
}

// auto Page 지정
function autoPages(xyCheck){
	var autoPage = '0';
	var heightSize = '1155';
	if (xyCheck =="H"){
		heightSize = '780';
	}
	
	var totalpage = $('html').prop('scrollHeight') / heightSize;
	var raalScroll = ($('html').scrollTop()+200) / heightSize;

	if(totalpage > 1.3) {
		if(totalpage > 2  && xyCheck == 'V'){
			raalScroll = ($('html').scrollTop()+300) / heightSize;
		}
		if(raalScroll > 6  && xyCheck == 'V'){
			raalScroll = ($('html').scrollTop()+ 600) / heightSize;
		} 
		
		if(totalpage > 3  && xyCheck == 'H'){
			raalScroll = ($('html').scrollTop()+ 300) / heightSize;
		}
		if(raalScroll >= 5 && xyCheck == 'H'){
			raalScroll = ($('html').scrollTop()+ 500) / heightSize;
		} 
		
		raalScroll++;
		var indexCheck = raalScroll.toString().indexOf('.');
		if(indexCheck > 0){
			autoPage = raalScroll.toString().substring(0, raalScroll.toString().indexOf('.'));
		} else {
			autoPage = raalScroll;
		}
		raalScroll = 0;
	}else {
		autoPage = '1';
	}
	console.log("PAGE :" + autoPage + ', TOTAL : ' + $('html').prop('scrollHeight')+', TOP : ' +$('html').scrollTop()+ ",:::"+ totalpage);
	return autoPage;
}
```

<br>

## 핵심 포인트
- Drag & Drop 방식으로 사용자의 증명서 생성에 있어 편의성 제공 및 동적 증명서 생성  
- 브라우저 상에서 증명서 생성 및 편집 기능 제공  
- 등록한 증명서 양식은 엑셀 데이터와 맵핑하여 증명서 대량 제작에 사용 가능  
- 다량의 페이지 제작(계약서, 설명서 등) 가능하게 설계  
 
 <br>

---

## 주요 화면
>> **증명서 제작 화면 예시**  
![certMaker](/assets/images/project/molida/certMaker.png)  
<br>
>> **증명서 제작 설명 예시**  
![explain](/assets/images/project/molida/explain.png)  
<br>
>> **증명서 제작 결과 예시**  
![result](/assets/images/project/molida/result.png)  