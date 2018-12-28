/*權威詞統計*/
function authorityAnalyzer(authorityID,currentGroupType,totalNums)
{
	if($('#authorityAnalyzer'+authorityID).html().indexOf("高頻字")==-1)
	{
		var currentBIDItemJoin =currentBIDItem.join();
		if(currentBIDItem.length>500)
		{
			alert("搜尋範圍過大!");
			return;
		}
		if(currentGID!=""||currentBIDItem.length>500)
		{
			if(currentBIDItem.length>1);
				currentBIDItemJoin = currentBIDItem[0][0]+","+currentBIDItem[0][1];
		}
		$("#loadAction").show();
			$.get('text/authorityLayer.jsp',{'totalNums':totalNums,'bid':currentBIDItemJoin,'searchKey': $('#searchKey').val(),'authorityID':authorityID,'currentGroupType':currentGroupType,'bookSearch':$("#bookSearch").prop("checked"),'gid':currentGID}, function(data) {
		          $('#authorityAnalyzer'+authorityID).html(data);
		          //$('#layout_right').show();
		          
		          $("#loadAction").hide();
			});
	}
}
/*N-gram統計*/
function authorityAnalyzerNgram(ngram,currentGroupType,totalNums)
{
	/*$("#authorityAnalyzerNgram11").attr("class","dropdown-submenu");
	$("#authorityAnalyzerNgram22").attr("class","dropdown-submenu");
	$("#authorityAnalyzerNgram33").attr("class","dropdown-submenu");
	$("#authorityAnalyzerNgram44").attr("class","dropdown-submenu");
	$("#authorityAnalyzerNgram55").attr("class","dropdown-submenu");*/
	if($('#authorityAnalyzerNgram'+ngram).html().length<10)
	{
		//alert("#authorityAnalyzerNgram"+ngram+" open");
		//$("#authorityAnalyzerNgram"+ngram+ngram).attr("class","dropdown-submenu open");
		var currentBIDItemJoin =currentBIDItem.join();
		if(currentBIDItem.length>500)
		{
			alert("搜尋範圍過大!");
			return;
		}
		if(currentGID!=""||currentBIDItem.length>500)
		{
			if(currentBIDItem.length>1);
				currentBIDItemJoin = currentBIDItem[0][0]+","+currentBIDItem[0][1];
		}
		//alert(currentBIDItemJoin);
		$("#loadAction").show();
			$.get('text/authorityLayerNgram.jsp',{'totalNums':totalNums,'bid':currentBIDItemJoin,'searchKey': searchKey,'ngram':ngram,'currentGroupType':currentGroupType,'bookSearch':$("#bookSearch").prop("checked"),'gid':currentGID}, function(data) {
		          $('#authorityAnalyzerNgram'+ngram).html(data);
		          //$('#layout_right').show();
		          
		          $("#loadAction").hide();
			});
	}
}
/*N-gram統計下載*/
function downloadNgramExcel(bid,ngram,totalNums)
{
	var currentBIDItemJoin =currentBIDItem.join();
	if(currentBIDItem.length>500)
	{
			alert("搜尋範圍過大!");
			return;
	}
	if(currentGID!=""||currentBIDItem.length>500)
	{
			if(currentBIDItem.length>1);
				currentBIDItemJoin = currentBIDItem[0][0]+","+currentBIDItem[0][1];
	}
	window.open('api/downloadNgramExcel.jsp?totalNums='+totalNums+'&bid='+currentBIDItemJoin+'&searchKey='+$('#searchKey').val()+'&ngram='+ngram+'&bookSearch='+$("#bookSearch").prop("checked")+'&gid='+currentGID);
}
/*權威詞統計下載*/
function downloadAuthorityExcel(bid,authorityID,totalNums)
{
	var currentBIDItemJoin =currentBIDItem.join();
	if(currentBIDItem.length>500)
	{
			alert("搜尋範圍過大!");
			return;
	}
	if(currentGID!=""||currentBIDItem.length>500)
	{
			if(currentBIDItem.length>1);
				currentBIDItemJoin = currentBIDItem[0][0]+","+currentBIDItem[0][1];
	}
	window.open('api/downloadAuthorityExcel.jsp?totalNums='+totalNums+'&bid='+currentBIDItemJoin+'&searchKey='+$('#searchKey').val()+'&authorityID='+authorityID+'&bookSearch='+$("#bookSearch").prop("checked")+'&gid='+currentGID);
}

/*進階查詢N-gram統計*/
function expertSearchNgram(ngram,agreementsjson,searchLeftDistence,searchRightDistence)
{
	var input = patternQueryCombination()
	//alert(input);
	//alert(JSON.stringify(input));
	//alert('authorityAnalyzerNgram');
	//patternQueryCombination();
	//var searchleft = $("#searchLeft").val();
	//alert(searchleft);
	$("#loadAction").show();
	//alert(input[0].searchLeft+";"+input[0].spacing+";"+input[0].searchRight+";"+input[0].inOrder+";"+input[0].OP);
	var bid;
	if(currentBID.indexOf("ID")==-1)
			bid = currentBID+"-"+currentText;
		else
			bid = currentBID
		//JSON.parse
		//alert(bid+";"+$('#searchKey').val()+";"+ngram);
		$.get('patternSearch/expertSearchNgram.jsp',{'bid':bid,'agreementsjson':agreementsjson,'ngram':ngram,'input':JSON.stringify(input),'searchLeftDistence':searchLeftDistence,'searchRightDistence':searchRightDistence}, function(data) {
	          //alert(data);
			  $('#expertSearchNgram'+ngram).html(data);
	          //$('#layout_right').show();
	          $("#loadAction").hide();
		});
}


/*進階查詢N-gram統計*/

function checkRequest(clipperNum,agreementsjson,searchLeftDistence,searchRightDistence){
		var clickjxxx= new Array();

		for(j=0;j<clipperNum;j++){
			var clickNgram = new Array();
			var clickAll = new Array();
			var num=j+1;
			$("input:checkbox:checked[name=allF"+j+"]").each(function(i) { 
				clickAll[i] = this.value; 
			});					
			$("input:checkbox:checked[name=allC"+j+"]").each(function(i) { 
				clickNgram[i] = this.value; 
			});	
			if(clickNgram.length==0 && clickAll.length==0){
				alert("請勾選第"+num+"夾的Ngram值");
				return false;	
			}
			clickjxxx[j] = clickNgram.join();
		}
		//var clickNgramFinal_1 =  clickjxxx[0];
		var clickNgramFinal = new Array();
		for (var i =1 ;i<=clipperNum ; i++){
				clickNgramFinal[i-1]=clickjxxx[i-1];
		}
		

		var input = patternQueryCombination()
		$("#loadAction").show();
		var bid;
		if(currentBID.indexOf("ID")==-1)
				bid = currentBID+"-"+currentText;
			else
				bid = currentBID

		$.post('patternSearch/expertSearchNgram.jsp',{'bid':bid,'agreementsjson':agreementsjson,'clickNgramFinal':JSON.stringify(clickNgramFinal),'input':JSON.stringify(input),'searchLeftDistence':searchLeftDistence,'searchRightDistence':searchRightDistence}, function(data) {
		  		var seeds = ""+new Date().getTime();
				var w = window.open('about:blank',seeds,"toolbar=yes,scrollbars=yes,resizable=yes,width=1024,height=768");
				w.document.write(data);
				//$('#pnpg').html(data);
		  		$("#loadAction").hide();
		});						

		

}
/*進階查詢權威統計*/

function checkResult(clipperNum,agreementsjson,searchLeftDistence,searchRightDistence){
		var clickjxxx= new Array();

		for(j=0;j<clipperNum;j++){
			var clickNgram = new Array();
			var clickAll = new Array();
			var num=j+1;
			$("input:checkbox:checked[name=allTitle"+j+"]").each(function(i) { 
				clickAll[i] = this.value; 
			});					

			$("input:checkbox:checked[name=allTitleC"+j+"]").each(function(i) { 
				clickNgram[i] = this.value; 

			});	
			if(clickNgram.length==0 && clickAll.length==0){
				alert("請勾選第"+num+"夾的權威值");
				return false;	
			}
			clickjxxx[j] = clickNgram.join();
		}

		var clickNgramFinal = new Array();
		for (var i =1 ;i<=clipperNum ; i++){
				clickNgramFinal[i-1]=clickjxxx[i-1];
		}
		

		var input = patternQueryCombination()
		$("#loadAction").show();
		var bid;
		if(currentBID.indexOf("ID")==-1)
				bid = currentBID+"-"+currentText;
			else
				bid = currentBID

		$.post('patternSearch/expertSearchAuthority.jsp',{'bid':bid,'agreementsjson':agreementsjson,'clickNgramFinal':JSON.stringify(clickNgramFinal),'input':JSON.stringify(input),'searchLeftDistence':searchLeftDistence,'searchRightDistence':searchRightDistence}, function(data) {
		  		var seeds = ""+new Date().getTime();
				var w = window.open('about:blank',seeds,"toolbar=yes,scrollbars=yes,resizable=yes,width=1024,height=768");
				w.document.write(data);
				//$('#pnpg').html(data);
		  		$("#loadAction").hide();
		});						

		

}
function check_all(obj,cName){
    var checkboxs = document.getElementsByName(cName); 
    for(var i=0;i<checkboxs.length;i++){checkboxs[i].checked = obj.checked;} 
}
