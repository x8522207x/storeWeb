var time = 0;
function annotationLoad()
{
	//return;
	var inputs = document.body.getElementsByTagName("p");
	var ids =[];
	for (var i = 0; i < inputs.length; i++) {
		if(inputs[i].id!==""){
			ids.push(inputs[i].id);//抓段落ID
			//alert(inputs[i].id);
		}
	}
	var titles =[];
	var book_ids = [];
	for (var i = 0; i < $("div[id='authority']>strong").length; i++) {
		if($("div[id='authority']>strong")[i].childNodes[0].nodeValue!==""){
			titles.push($("div[id='authority']>strong")[i].childNodes[0].nodeValue);//抓權威檔類型
			book_ids.push($("div[id='authority']>input")[i].id.split("_")[1]);//抓權威檔ID
		}
	}
	var changebook = false;//有更動文本的話改成true
	//if(time>0)
		//changebook = true;
	var uri =  window.location.href;
	var anno =new annotation('#segementContentDIV');
	setCookie('time',time,30);
	anno.init({
		titles: titles,
		book_ids: book_ids,
		ids: ids,
		uri: uri,
		changebook: changebook,
		//imageAnnotation: false,
		//keywords: []
	});
	console.log("!!!!!!");
    time++;
    //alert(time);
}

function replaceAll(str, find, replace) {
    return str.replace(new RegExp(find, 'g'), replace);
}
/**
一般、進階、查詢關鍵字字串組合
**/
function searchKeyNavigation()
{
	//頁碼初始化
	$("#pages").val('1');
	//進階檢索才處理
	searchKey = $('#searchKey').val();
	if($('#search-advance').is(':visible'))
	{
		searchKey = queryCombination();
	}
	else
	{
		if(searchKey!=""&&searchKey.indexOf('"')==-1&&searchKey.indexOf(' ')==-1)
		{
			searchKey='"'+searchKey+'"';
			$('#searchKey').val('"'+$('#searchKey').val()+'"');
		}
	}
	if(searchKey=="")
	{
		//alert("請輸入查詢條件!");
		//return;
	}
	//undo關鍵字處理
	if($('#search-general').is(':visible'))
	{
		if(searchKey!=""&&searchKeys.indexOf(searchKey)==-1)
			searchKeys.push(searchKey);
	}
}
/**
間距查詢
**/
function patternSearch(currentBIDItemJoin,p,tempCurrentGID,multiSearchdefault,searchStatus)
{	
	var tdContainSearch=0;
	for(var i = 0; i <= $("tr[id*='AddExpertRow']").length-1;i++){
		if($("#searchLeft"+i).val() == '' && $("#searchRight"+i).val() == '' ){
			tdContainSearch = i;
			break;
		}
	}
	var containSpace = checkSpace(i-1);
	
	//alert(currentBIDItemJoin);
	if(!containSpace){
		var input = patternQueryCombination();
		//alert(input);
		$.get('patternSearch/userImportCalculate.jsp',{'currentGID':tempCurrentGID,'bid':currentBIDItemJoin,'searchStatus':searchStatus,'defaultSelect':multiSearchdefault,'input':JSON.stringify(input),'ckDic':$("#DicCK").prop("checked"),'pages': p,'searchType':searchType,'searchLeftDistence':$("#searchLeftDistence").val(),'searchRightDistence':$("#searchLeftDistence").val(),'currentGroupType':currentGroupType,'currentBID':currentBID,'currentPath':currentPath},function(data){
	 		$('#layout_main').html(data);
	 		var userInputNum = $('#uIN').val();
	 		if(userInputNum==1){
				$.get('patternSearch/segementExpert.jsp',{'bid':currentBIDItemJoin,'input':JSON.stringify(input),'ckDic':$("#DicCK").prop("checked"),'pages': p,'searchType':searchType,'searchLeftDistence':$("#searchLeftDistence").val(),'searchRightDistence':$("#searchRightDistence").val(),'currentGroupType':currentGroupType,'bookSearch':$("#bookSearch").prop("checked"),'gid':tempCurrentGID,'direct':true},
					function(data) {
					  
					  segementjstree(currentGroupType);
					 // console.log(data);
					  $('#layout_main').html(data);
					  $("#loadAction").hide();
					  if(currentPath=="null")
					  	$('#'+currentGroupType).jstree(true).select_node(currentBID);
					  $('#breadcrumb').text(currentPath);
					  $('#breadcrumb').attr("alt",currentBID);
					  
					  //alert($('#searchKey').val());
					  //console.log($('#q').html());
						var q = $('#q').val();
					  //文本總字數
			   	  
				   	  if(currentBID.indexOf("j")==-1)
				   	  {
				   	  	  $.get('api/wordCount.jsp',{'bid':currentBID}, function(data) {
				   	  	  	$('#wordCount').html(data);
				   	  	  });
				   	  }
				   	  else
				   	  {
				   	  	  $('#wordCount').html("");
				   	  }
				  	  $('#breadcrumb').attr("alt",currentBID);
				  	  //console.log($("#expertQuery").val());
					  //alert('expertEditNodeAct');
					 //alert(bid);
					 //alert($("#expertQuery").val());
					 if(bid.indexOf("j")==-1&&bid.indexOf(",")==-1)
					  	  expertEditNodeAct($("#expertQuery").val(),bid,currentGroupType);
					  	  
						 //jstree改func
						
					  //點group時
					   annotationLoad();
					   
					  //end 點group時
					   if(getDepth(currentBID,currentGroupType)<3)
				  		{
				  	 		 //alert('hide');
				  	  		$("#btnChapterAnalyzer").hide();
				  		}
				  		else
				  		{
				  	 		 //alert('show');
				  	  		$("#btnChapterAnalyzer").show();
			  			}
				});
			}
		});
	}
}
/**
檢查間距查詢欄位空白
**/
function checkSpace(id){
	var space = false;
	if(id == -1){
		space = true;
		alert("請填入查詢詞");
		return;
	}
	else{
		for(var i = 0; i <= id;i++){
			if($("#searchLeft"+i).val() == '' || $("#searchRight"+i).val() == '' ){
				space = true;
				alert("請填入查詢詞");
				return;
			}
		}
	}
	
	
	return space;
}

function searchundo(bid,p)
{
	var undoSize = searchKeys.length;
	if(undoSize>0)
	{
		if(undoSize!=1)
		{
			searchKey = searchKeys.slice(-2)[0];
			searchKeys.splice(undoSize-1, 1);
			
		}
		else
		{
			searchKey = "";
			searchKeys = new Array();
		}
		//alert('redo key:'+searchKey+' undoSize:'+undoSize);
		$("#searchKey").val(searchKey);
		if(!currentBID)
		{
			    alert("請先選擇檢索群組!");
			    return;
				currentBIDItem = new Array();
				//alert("請選擇查詢群組!");
				var parentsItem = getRootID(currentGroupType,currentGroupType);
				for(var i=0;i<parentsItem.length;i++)
				{
					currentBIDItem.push(getChildrenID(parentsItem[i],currentGroupType));
				}
				currentBID = parentsItem[0];
				if(currentBID.indexOf("j")!=-1)
					currentGID = currentBID;
				//alert($('#'+currentGroupType).jstree(true).get_selected(currentBID));
		}
		var currentBIDItemJoin =currentBIDItem.join();
		if(currentBIDItem.length>500)
			alert("搜尋範圍過大，請選擇檢索群組!")
		if(currentGID!=""||currentBIDItem.length>500)
		{
			//if(currentBIDItem.length>1);
				//currentBIDItemJoin = currentBIDItem[0][0]+","+currentBIDItem[0][1];
		}
		
		var tempCurrentGID = currentGID;
		if($("#currentBIDItemJoin").val()!=""&&bid.indexOf("j")!=-1)
		{
			 	currentBIDItemJoin =$("#currentBIDItemJoin").val();
			 	tempCurrentGID = "";
		}
		
		$("#loadAction").show();
		//直接按查詢時防呆
		
		if(currentBIDItemJoin=="")
			currentBIDItemJoin = currentBID;
		
		if(searchType!="expert")
		$.get('text/segement.jsp',{'bid':currentBIDItemJoin,'searchKey': searchKey,'ckDic':$("#DicCK").prop("checked"),'pages': p,'searchType':searchType,'currentGroupType':currentGroupType,'bookSearch':$("#bookSearch").prop("checked"),'gid':tempCurrentGID}, function(data) {
		          
		          segementjstree(currentGroupType);
		          segementjstreeInit = 1;
		          $('#layout_main').html(data);
		          $("#loadAction").hide();
			   	  $('#breadcrumb').text(currentPath);
			   	  //alert(currentBID);
			   	  //文本總字數
			   	  /*if(currentBID.indexOf("j")==-1)
			   	  {
			   	  	  $.get('api/wordCount.jsp',{'bid':bid}, function(data) {
			   	  	  	$('#wordCount').html(data);
			   	  	  });
			   	  }
			   	  else
			   	  {
			   	  	  $('#wordCount').html("");
			   	  }*/
			  	  $('#breadcrumb').attr("alt",currentBID);
			  	  $('#'+currentGroupType).jstree(true).select_node(currentBID);
			  	  //$(".bookHeader").text(currentHeaderPath);
			  	  //alert(searchKey);
			  	  //alert(bid);
			  	  if(bid.indexOf("j")==-1)
			  	  {
			  	  	editNodeAct(searchKey,bid,currentGroupType);
			  	  }
			  	  //點group時
			  	  else
			  	  {
			  	  	/*
			  	  	var childrenNode = getChildrenID(currentBID,currentGroupType);
			  	  	for(var i=0;i<childrenNode.length;i++){
			  	  		//alert(childrenNode[i]);
			  	  		editNodeAct(searchKey,childrenNode[i],currentGroupType);
			  	  	}*/
			  	  }
			  	  //end 點group時
			  	  annotationLoad();
			  	  //3層以上才開啟物件分析功能
			  	  //alert(getDepth(currentBID,currentGroupType));
				  //if(getDepth(currentBID,currentGroupType)<3)
				  //章節段落數小於100且不是群組
				  if(currentRawCount!=-1&&currentRawCount<100)
				  {
				  	  //alert('hide');
				  	  $("#btnChapterAnalyzer").show();
				  	  //$("#btnChapterAnalyzer").hide();
				  	  
				  }
				  else
				  {
				  	  //alert('show');
				  	  $("#btnChapterAnalyzer").hide();
				  }
		});
		else
		{
			patternSearch(currentBIDItemJoin,p,tempCurrentGID,0,true);
		}
	}
}
/**
點選查詢按鈕
**/
function searchInit(bid,p)
{
	searchKeyNavigation();
	if(!currentBID)
	{
		    alert("請先選擇檢索群組!");
		    return;
			currentBIDItem = new Array();
			//alert("請選擇查詢群組!");
			var parentsItem = getRootID(currentGroupType,currentGroupType);
			for(var i=0;i<parentsItem.length;i++)
			{
				currentBIDItem.push(getChildrenID(parentsItem[i],currentGroupType));
			}
			currentBID = parentsItem[0];
			if(currentBID.indexOf("j")!=-1)
				currentGID = currentBID;
			//alert($('#'+currentGroupType).jstree(true).get_selected(currentBID));
	}
	var currentBIDItemJoin =currentBIDItem.join();
	if(currentBIDItem.length>500)
		alert("搜尋範圍過大，請選擇檢索群組!")
	if(currentGID!=""||currentBIDItem.length>500)
	{
		//if(currentBIDItem.length>1);
			//currentBIDItemJoin = currentBIDItem[0][0]+","+currentBIDItem[0][1];
	}
	
	var tempCurrentGID = currentGID;
	if($("#currentBIDItemJoin").val()!=""&&bid.indexOf("j")!=-1)
	{
		 	currentBIDItemJoin =$("#currentBIDItemJoin").val();
		 	tempCurrentGID = "";
	}
	
	$("#loadAction").show();
	//直接按查詢時防呆
	
	if(currentBIDItemJoin=="")
		currentBIDItemJoin = currentBID;
	
	//alert(searchKeys);
	if(searchType!="expert")
	$.get('text/segement.jsp',{'bid':currentBIDItemJoin,'searchKey': searchKey,'ckDic':$("#DicCK").prop("checked"),'pages': p,'searchType':searchType,'currentGroupType':currentGroupType,'bookSearch':$("#bookSearch").prop("checked"),'gid':tempCurrentGID}, function(data) {
	          
	          segementjstree(currentGroupType);
	          segementjstreeInit = 1;
	          $('#layout_main').html(data);
	          $("#loadAction").hide();
		   	  $('#breadcrumb').text(currentPath);
		   	  //alert(currentBID);
		   	  //文本總字數
		   	  /*if(currentBID.indexOf("j")==-1)
		   	  {
		   	  	  $.get('api/wordCount.jsp',{'bid':bid}, function(data) {
		   	  	  	$('#wordCount').html(data);
		   	  	  });
		   	  }
		   	  else
		   	  {
		   	  	  $('#wordCount').html("");
		   	  }*/
		  	  $('#breadcrumb').attr("alt",currentBID);
		  	  $('#'+currentGroupType).jstree(true).select_node(currentBID);
		  	  //$(".bookHeader").text(currentHeaderPath);
		  	  //alert(searchKey);
		  	  //alert(bid);
		  	  if(bid.indexOf("j")==-1)
		  	  {
		  	  	editNodeAct(searchKey,bid,currentGroupType);
		  	  }
		  	  //點group時
		  	  else
		  	  {
		  	  	/*
		  	  	var childrenNode = getChildrenID(currentBID,currentGroupType);
		  	  	for(var i=0;i<childrenNode.length;i++){
		  	  		//alert(childrenNode[i]);
		  	  		editNodeAct(searchKey,childrenNode[i],currentGroupType);
		  	  	}*/
		  	  }
		  	  //end 點group時
		  	  annotationLoad();
		  	  //3層以上才開啟物件分析功能
		  	  //alert(getDepth(currentBID,currentGroupType));
			  //if(getDepth(currentBID,currentGroupType)<3)
			  //章節段落數小於100且不是群組
			  if(currentRawCount!=-1&&currentRawCount<100)
			  {
			  	  //alert('hide');
			  	  $("#btnChapterAnalyzer").show();
			  	  //$("#btnChapterAnalyzer").hide();
			  	  
			  }
			  else
			  {
			  	  //alert('show');
			  	  $("#btnChapterAnalyzer").hide();
			  }
	});
	else
	{
		patternSearch(currentBIDItemJoin,p,tempCurrentGID,0,true);
	}
}
function bookTitleFilter()
{
	
	var sk = replaceAll($('#searchKey').val(), '"', '');
	$('#'+currentGroupType).jstree(true).search(sk);
	$("#bookSearch").prop("checked",false);
}
function search(bid,p)
{

	searchKeyNavigation();
	
	if(bid!='')
	if(!currentBID)
	{
			currentBIDItem = new Array();
			//alert("請選擇查詢群組!");
			var parentsItem = getRootID(currentGroupType,currentGroupType);
			for(var i=0;i<parentsItem.length;i++)
			{
				currentBIDItem.push(getChildrenID(parentsItem[i],currentGroupType));
			}
			currentBID = parentsItem[0];
			//alert($('#'+currentGroupType).jstree(true).get_selected(currentBID));
	}
	
	else
	{
		currentBIDItem = new Array();
		if(bid.indexOf("j")!=-1)
		{
			//bid = currentBID+"-"+currentText;
			currentBIDItem.push(getChildrenID(currentBID,currentGroupType));
		}
		else
		{
			//bid = currentBID
			currentBIDItem.push(bid);
		}
	}
	//alert(currentBIDItem);
	//alert(bid);
	//alert(searchKey);
	//if(bid.indexOf("j")==-1)
	$("#loadAction").show();
	//if(bid.indexOf("j")==-1)
	var currentBIDItemJoin =currentBIDItem.join();
	//alert(currentBIDItemJoin);

	var tempCurrentGID = currentGID;
	if($("#currentBIDItemJoin").val()!=""&&bid.indexOf("j")!=-1)
	{
		 	currentBIDItemJoin =$("#currentBIDItemJoin").val();
		 	tempCurrentGID = "";
	}

	
	if(searchType!="expert")
	$.get('text/segement.jsp',{'bid':currentBIDItemJoin,'searchKey': searchKey,'ckDic':$("#DicCK").prop("checked"),'pages': p,'searchType':searchType,'currentGroupType':currentGroupType,'bookSearch':$("#bookSearch").prop("checked"),'gid':tempCurrentGID}, function(data) {
	           //alert(currentGroupType)
	           
	          segementjstree(currentGroupType);
	          segementjstreeInit = 1;
	          $('#layout_main').html(data);
	          $("#loadAction").hide();
		   	  $('#breadcrumb').text(currentPath);
		   	  //alert(currentBID);
		   	  //文本總字數
		   	  
		   	  if(currentBID.indexOf("j")==-1)
		   	  {
		   	  	  $.get('api/wordCount.jsp',{'bid':currentBID}, function(data) {
		   	  	  	$('#wordCount').html(data);
		   	  	  });
		   	  }
		   	  else
		   	  {
		   	  	  $('#wordCount').html("");
		   	  }
		  	  $('#breadcrumb').attr("alt",currentBID);
		  	  //$(".bookHeader").text(currentHeaderPath);
		  	  //alert(bid);
		  	  if(bid.indexOf("j")==-1)
		  	  {
		  	  	editNodeAct(searchKey,bid,currentGroupType);
		  	  }
		  	  //點group時
		  	  else
		  	  {
		  	  	
		  	  	/*var childrenNode = getChildrenID(currentBID,currentGroupType);
		  	  	for(var i=0;i<childrenNode.length;i++){
		  	  		//alert(childrenNode[i]);
		  	  		editNodeAct(searchKey,childrenNode[i],currentGroupType);
		  	  	}*/
		  	  }
		  	  //end 點group時
		  	  annotationLoad();
		  	  //3層以上才開啟物件分析功能
		  	  //alert(getDepth(currentBID,currentGroupType));
			  //if(getDepth(currentBID,currentGroupType)<3)
			  //章節段落數小於100且不是群組
			  if(currentRawCount!=-1&&currentRawCount<100)
			  {
			  	  //alert('hide');
			  	  $("#btnChapterAnalyzer").show();
			  	  //$("#btnChapterAnalyzer").hide();
			  	  
			  }
			  else
			  {
			  	  //alert('show');
			  	  $("#btnChapterAnalyzer").hide();
			  }
	});
	
	else
	{
		patternSearch(currentBIDItemJoin,p,tempCurrentGID,0,false);
	}
}
