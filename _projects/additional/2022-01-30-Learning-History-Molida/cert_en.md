---
layout: page
title: "Partial Example of Certificate Generation Feature"
permalink: /projects/additional/2022-01-30-Learning-History-Molida/cert_en/
---

<a href="javascript:history.back()" class="btn btn-outline-success btn-sm">
  <- Back
</a>

# Partial Example of Certificate Generation Feature
<br>

## Overview
A dynamic document generation system that allows users to directly create and edit certificates. Generated certificate templates can be modified or deleted. Users can upload files such as DOCs or images to use as backgrounds and produce certificates on top of those backgrounds.

<br>
## Core Code Example
#### UI Code
```html
// Drawing area
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
          <!-- Common parameter -->
          <c:when test="${param.isCommon eq 'Y'}">
            
            <c:choose>
              <!-- Text type -->
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

              <!-- Image type -->
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

          <!-- Individual parameter -->
          <c:when test="${param.isCommon eq 'N'}">
            <div id="${param.id}"
                 data-param-id="${param.paramSeq}"
                 class="input-box"
                 title="Data value"
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

  <div class="barcode-area">Barcode : </div>
</c:forEach>
```

#### JavaScript Code
```javascript
// Mouse-enter drag-and-drop cloning
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

// Default vertical background setup
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

// Default horizontal background setup
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

// Auto page selection
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

## Key Points
- Provides convenience through drag-and-drop based dynamic certificate generation  
- Supports certificate creation and editing directly in the browser  
- Registered templates can be mapped with Excel data for bulk certificate generation  
- Designed to support multi-page document creation (contracts, manuals, etc.)
 
 <br>

---

## Key Screens
>> **Certificate Builder Screen Example**  
![certMaker](/assets/images/project/molida/certMaker.png)  
<br>
>> **Certificate Builder Guide Example**  
![explain](/assets/images/project/molida/explain.png)  
<br>
>> **Certificate Builder Result Example**  
![result](/assets/images/project/molida/result.png)  
