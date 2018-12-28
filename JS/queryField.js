var fieldCount = 5;
var fieldPSCount = 3;
var fieldMaxIndex = fieldCount-1;
var fieldPSMaxIndex = fieldPSCount-1;

/**新增查詢欄位，預設為兩筆資料**/
function addRow()
{
    for (i = 0; i < fieldCount; i++) {
        var rowId = "AddRow" + i;
        var opId = "OP" + i;
        var sqId = "SQ" + i;
        var fieldId = "FO" + i;
        if (document.getElementById(rowId).style.display=="none") {
        //if ($("#"+rowId).css('display') == 'none') {
        	$("#"+rowId).show();
        	$("#removeRowField").html('<a href="javascript:removeRow();" id="removeRowTxt" name="removeRowTxt">移除查詢欄位</a>');
            break;
        }
    }
    if (i >= fieldMaxIndex)
    {
    	$("#addRowField").html('<font color="#666666">新增查詢欄位</font>');
	}
}

/**新增專業搜尋查詢欄位，預設為兩筆資料**/
function addExpertRow()
{
	
    for (i = 1; i < fieldPSCount; i++) {
		var mfId = "matchFront" + i;
		var mbId = "matchBehind" + i;
        var rowId = "AddExpertRow" + i;
        var opId = "ExpertOP" + i;
        var sqId = "ExpertSQ" + i;
        var fieldId = "ExpertFO" + i;
        if (document.getElementById(rowId).style.display=="none") {
        //if ($("#"+rowId).css('display') == 'none') {
        	$("#"+rowId).show();
        	$("#removeExpertRowField").html('<a href="javascript:removeExpertRow();" id="removeExpertRowTxt" name="removeExpertRowTxt">移除查詢欄位</a>');
            break;
        }
    }
    if (i >= fieldPSMaxIndex)
    {
    	$("#addExpertRowField").html('<font color="#666666">新增查詢欄位</font>');
	}
}

/**移除查詢欄位**/
function removeRow()
{
    var i = 0;
    for (i = fieldMaxIndex; i > 0; i--) {
        var rowId = "AddRow" + i;
        var opId = "OP" + i;
        var sqId = "SQ" + i;
        var fieldId = "FO" + i;
        if(document.getElementById(rowId).style.display==""||document.getElementById(rowId).style.display=="table-row") {
        //if ($("#"+rowId).css('display') == '') {
        	$("#"+rowId).hide();
        	$("#"+sqId).val('');            
			$("#addRowField").html('<a href="javascript:addRow();">新增查詢欄位</a>');
            break;
        }
    }
    if (i <= 2) {
    	$("#removeRowField").html('<span><font color="#666666">移除查詢欄位</font></span>');
    }
}
function removeExpertRow()
{
    var i = 0;
	
    for (i = fieldPSMaxIndex; i > 0; i--) {
        var rowId = "AddExpertRow" + i;
        var slId = "searchLeft" + i;
		var spId = "spacing" + i;
		var srId = "searchRight" + i;
		var mfId = "matchFront" + i;
		var opId = "ExpertOP" + i;
		var mbId = "matchBehind" + i;
        var fieldId = "ExpertFO" + i;
        if(document.getElementById(rowId).style.display==""||document.getElementById(rowId).style.display=="table-row") {
        //if ($("#"+rowId).css('display') == '') {
			document.getElementById("OR"+i).selected = "true";
        	$("#"+rowId).hide();
			$("#"+slId).val('');
			$("#"+spId).val('');
			$("#"+srId).val('');
			$("#"+slId).removeAttr('disabled');
			$("#"+mfId).removeAttr('disabled');
			$("#matchBehind" + (i-1)).removeAttr('disabled');
			$("#leftQueryField"+i).removeAttr('style');
            $("#addExpertRowField").html('<a href="javascript:addExpertRow();">新增查詢欄位</a>');
            break;
        }
    }
    if (i < 2) {
    	$("#removeExpertRowField").html('<span><font color="#666666">移除查詢欄位</font></span>');
    }
}
function queryCombination()
{
	//alert($("#SQ").val());
	var querySytax = "";
	if($("#SQ").val()&&$("#SQ").val()!="")
		querySytax = "\""+$("#SQ").val()+"\"";
	for (i = 0; i < 10; i++) {
        var rowId = "AddRow" + i;
        var opId = "OP" + i;
        var sqId = "SQ" + i;
        var fieldId = "FO" + i;
        var queryKeyword = $("#"+sqId).val();
        if (queryKeyword!="") {
        	//alert($("#"+opId).val()+ " "+queryKeyword);
        	querySytax+=$("#"+opId).val()+"\""+queryKeyword+"\"";
        }
    }
    return querySytax;
    //alert(querySytax);
    //alert(querySytax);
}
function patternQueryCombination()
{/*
	$("tr[id*='AddExpertRow']").each(function( index ) {
		//alert($(this).attr("id"));
	});*/
	
	var inputResult = [];
    var jsonStr = "";
	//alert($("input[name='searchType']:radio:checked").val());
	for(var i = 0; i <= $("tr[id*='AddExpertRow']").length;i++){
		//if($("#searchLeft"+i).val() == '' && $("#searchRight"+i).val() == '' && $("#spacing"+i).val() == '' ){
		if($("#searchLeft"+i).val() == '' && $("#searchRight"+i).val() == '' ){
			break;
		}
		else{
			if($("#searchLeft"+i).val().includes(" ")&&$("#searchRight"+i).val().includes(" ")){
				alert("請另開搜尋欄位");
				break;
			}
			else{
				
			var order;
			
			if( $("#orderSct"+i).val() == "有順序"){
				order = true;
				
			}
			else{
				order = false;
				
			}
			
			
			var op;
			if(i>0){

				if($("#expertOP"+i).val() == 0){
					
					op = "AND";
				}
				else if($("#expertOP"+i).val() == 1){
					op = "OR";
				
				}
				else{
					op = "NOT";
				}
			}
			else if(i==0)
				op = "OR";
			
			
			var matchFront;
			var matchBehind;
			
			if(document.getElementById("matchFront"+i).checked == true){
				matchFront = true;
			}else{
				matchFront = false;
			}
			
			if(document.getElementById("matchBehind"+i).checked == true){
				matchBehind = true;
			}else{
				matchBehind = false;
			}
			var spacing  = $("#spacing"+i).val();
		    if(spacing=="")
		    	spacing = 50;
		    //alert(spacing);
			var input = {"searchLeft" : $("#searchLeft"+i).val(),
						  "spacing" : spacing,
						  "searchRight" : $("#searchRight"+i).val(),
						  "inOrder" : order,
						 "OP" : op,
						 "matchFront" : matchFront,
						 "matchBehind" : matchBehind,
						 "searchType" : $("input[name='searchType']:radio:checked").val()};
						 
			jsonStr = input;
			
			inputResult.push(input);
			}
		}
	}
	
	return inputResult;
	
}
/**組合查詢欄位檢索語法**/
function queryExpertCombination()
{
	var querySytax = $("#SQ").val();
	
	if(querySytax=="")
	{
		$("#SQ").focus();
		//alert("主查詢欄位為空!");
		return;
	}
	else
	{
		if(querySytax.indexOf('"')==-1)
			querySytax = '"'+querySytax+'"';
		for (i = 0; i < 10; i++) {
	        var rowId = "AddRow" + i;
	        var opId = "OP" + i;
	        var sqId = "SQ" + i;
	        var fieldId = "FO" + i;
	        var queryKeyword = $("#"+sqId).val();
	        if (queryKeyword!="") {
	        	querySytax+=$("#"+opId).val()+'"'+queryKeyword+'"';
	        }
	    }
	}
    return querySytax;
}
/**查詢欄位合併關鍵字**/
function addSearch(key)
{
	var newKey = "";
	if($('#searchKey').val()=="")
		newKey = '"'+key+'"';
	else
		newKey = $('#searchKey').val()+" AND "+'"'+key+'"';
	
	
	//進階查詢才增加
	if($('#search-advance').is(':visible'))
		addRowWord(key);
	else
		$('#searchKey').val(newKey);
	searchInit('',1)
}
/**權威詞再查詢後調整查詢欄位**/
function addRowWord(appendWord)
{
	if($("#SQ").val()=="")
	{
		$("#SQ").val(appendWord)
	}
	else
	{
	    for (i = 0; i < fieldCount; i++) {
	        var rowId = "AddRow" + i;
	        var opId = "OP" + i;
	        var sqId = "SQ" + i;
	        var fieldId = "FO" + i;
	        if($("#"+sqId).val()=="")
	        {
	        	$("#"+sqId).val(appendWord)
	        	$("#"+rowId).show();
	        	$("#removeRowField").html('<a href="javascript:removeRow();" id="removeRowTxt" name="removeRowTxt">移除查詢欄位</a>');
	        	break;
	        }
	        else
	        {
		        if (document.getElementById(rowId).style.display=="none") {
		        //if ($("#"+rowId).css('display') == 'none') {
		        	$("#"+rowId).show();
		        	$("#"+sqId).val(appendWord);
		        	$("#removeRowField").html('<a href="javascript:removeRow();" id="removeRowTxt" name="removeRowTxt">移除查詢欄位</a>');
		            break;
		        }
		 	}
	    }
	    if (i >= fieldMaxIndex)
	    {
	    	$("#addRowField").html('<font color="#666666">新增查詢欄位</font>');
		}
	}
}
/**控制一般、進階、專業檢索畫面**/

function queryNav(nav)
{
	//alert(nav);
	searchType = nav;
	$("#search-general").hide();
	$("#search-advance").hide();
	$("#search-expert").hide();
	$("#search-"+nav).show();
	//$('#searchKey').val('');
	//jsTree('main');
	//search('',1);
	
}

function selectAND(id,disabledUnit,equalUnit,disableMatchBehind,disableMatchFront,leftQueryField){
	var x = document.getElementById(id).value;
	
	if(x=="0"){
		$("#"+disabledUnit).val($("#"+equalUnit).val());
		$("#"+disableMatchBehind).prop('checked', false);
		$("#"+disableMatchFront).prop('checked', false);
		$("#"+disabledUnit).attr('disabled', true);
		$("#"+disableMatchFront).attr('disabled', true);
		$("#"+disableMatchBehind).attr('disabled', true);
		$("#"+leftQueryField).attr('style','visibility:hidden;');
	}
	else{
		$("#"+disabledUnit).removeAttr('disabled');
		$("#"+disableMatchFront).removeAttr('disabled');
		$("#"+disableMatchBehind).removeAttr('disabled');
		$("#"+leftQueryField).removeAttr('style');
		$("#"+disabledUnit).val('');

	}
	// console.log(id);
	// console.log(equalUnit);
	// console.log($("#"+equalUnit).val());
	// console.log($("#"+disabledUnit).val());
}

function ChangeSearchValue(id,disabledUnit,equalUnit,currentId){
	
	if(currentId<4){
		var x = document.getElementById(id).value;
		if(x=="0"){
			$("#"+disabledUnit).val($("#"+equalUnit).val());
		}
	}
	
}
