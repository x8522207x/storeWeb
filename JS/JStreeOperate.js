
function isEmptyObject(obj){
	for(var key in obj){
		if(obj.hasOwnProperty(key))
			return false;
	}
	return true;
}
/**
JSTree章節命中筆數更新
**/

function editNodeAct(searchQuery,bid,groupType)
{
	//return;
	//alert(searchQuery);
	if(bid=='')
		return;
	$.ajax({
			type:"GET",
			url:"text/editTree.jsp",
			data:{query:searchQuery,bid:bid},
			dataType:"json",
			success: function(response){
			//console.log(response);
			//console.log('isEmptyObject');
			if(!isEmptyObject(response))
			{
				editNodeText(response,groupType,bid);
				//console.log('editNodeText');
			}
			//else
				//alert("沒有符合的搜尋結果");
			},
			error: function(xhr, status, thrown){
				console.log(xhr, status, thrown);
			}
			
		});
}

function expertEditNodeAct(searchQuery,bid,groupType)
{
	//alert(searchQuery);
	//return;
	if(bid=='')
		return;
	$.ajax({
			type:"GET",
			url:"text/expertEditTree.jsp",
			data:{query:searchQuery,bid:bid},
			dataType:"json",
			success: function(response){
			//console.log(response);
			//console.log('isEmptyObject');
			
			if(!isEmptyObject(response))
			{
				editExpertNodeText(response,groupType,bid);
				//console.log('editNodeText');
			}
			else
			{
				//alert("沒有符合的搜尋結果");
			}
			},
			error: function(xhr, status, thrown){
				console.log(xhr, status, thrown);
			}
		});
}
/**
  * 更新搜尋節點的文本數。
  * @param data  HashMap<id, num> 搜尋節點的id與旗子目錄的
  * @return 
  */
 function editNodeText(data,groupType,bid){    
	
	var tree = $("#"+groupType).jstree(true);  // 取得整個 jstree
	var searchedNode = tree.get_node(bid);     // 取得搜尋的節點
	var searchedNodeData = tree.get_json(searchedNode, {flat:true});  // 取得搜尋節點的 json data, 型態是 json array: [{...}, {...}, ... ]
	
	
	if(searchedNodeData.length>100)
		searchedNodeData = searchedNodeData.slice(0, 100);
	//var searchedNodeData = tree.get_children_dom(searchedNode);

	//searchedNodeData = getChildren(bid,groupType);
	//alert(searchedNodeData);
	/*
	var exist = function(id){ // id 是否存在 data 裡
		for(var key in data)
			if(key === id)
				return true;
		return false;
	};*/

	// 復原前一次搜尋的節點
	//console.log('searchedNode');
	$(".searchedNode").each(function(){ 
		var node = resetNodeText(groupType, this.id);
		node.li_attr.class = "";
		tree.show_node(node);
	});

	// iterate searchedNode的所有子節點，若該子節點存在data裡就更新，隱藏其餘子節點
	//console.log('searchedNodeData:'+searchedNodeData.length);
	if($('#searchKey').val()!="")
	$.each(searchedNodeData, function(index, value){
		var id = value.id;
		var node = tree.get_node(id);
		node.li_attr.class = "searchedNode";   // 搜尋到的節點。不能用$().addClass();
		if(data.hasOwnProperty(id))
			node.text = node.text.replace(/[>]\d+[<]/, ">" + data[id] + "<");
		else
			tree.hide_node(id);
	});
	
	
	// 展開葉節點
	//console.log('open_node');
	tree.open_node(searchedNode, openLeafCallback(tree, searchedNode));
	//console.log('redraw');
	tree.redraw(true);   //更新jstree
}
function editExpertNodeText(data,groupType,bid){    
	
	var tree = $("#"+groupType).jstree(true);  // 取得整個 jstree
	var searchedNode = tree.get_node(bid);     // 取得搜尋的節點
	var searchedNodeData = tree.get_json(searchedNode, {flat:true});  // 取得搜尋節點的 json data, 型態是 json array: [{...}, {...}, ... ]
	
	if(searchedNodeData.length>100)
		searchedNodeData = searchedNodeData.slice(0, 100);
	
	/*var exist = function(id){ // id 是否存在 data 裡
		for(var key in data)
			if(key === id)
				return true;
		return false;
	};*/

	// 復原前一次搜尋的節點
	//console.log('searchedNode');
	$(".searchedNode").each(function(){ 
		var node = resetNodeText(groupType, this.id);
		node.li_attr.class = "";
		tree.show_node(node);
	});

	// iterate searchedNode的所有子節點，若該子節點存在data裡就更新，隱藏其餘子節點
	//console.log('searchedNodeData:'+searchedNodeData.length);
	//if($('#searchKey').val()!="")
	$.each(searchedNodeData, function(index, value){
		
		var id = value.id;
		var node = tree.get_node(id);
		node.li_attr.class = "searchedNode";   // 搜尋到的節點。不能用$().addClass();
		if(data.hasOwnProperty(id))
			node.text = node.text.replace(/[>]\d+[<]/, ">" + data[id] + "<");
		else
			tree.hide_node(id);
	});
	
	
	// 展開葉節點
	//console.log('open_node');
	tree.open_node(searchedNode, openLeafCallback(tree, searchedNode));
	//console.log('redraw');
	tree.redraw(true);   //更新jstree
}
 // 重置節點文本數量
function resetNodeText(groupType, id){
	var node = $("#"+groupType).jstree(true).get_node(id);
	var tmp = node.text.split("/")[2];
	var originTextNum = tmp.substring(0, tmp.length-1);
	node.text = node.text.replace(/[>]\d+[<]/, ">" + originTextNum + "<");
	return node;
}

// 遞迴展開未隱藏的第一個子節點
function openLeafCallback(tree, node){
	// callback
	return function(){
		var children = tree.get_children_dom(node).filter(":not(.jstree-hidden)");
		if(children != false)
			tree.open_node(children, openLeafCallback(tree, children));
	}
}
 /**
  * 送出POST請求, 取得文本數HashMap<id, num>
  * @return 
  */
$('#submit').click(function(){
		console.log($('#search').val());
		$.ajax({
			type:"POST",
			url:"query.do",
			data:{search:$('#search').val()},
			dataType:"json",
			success: function(response){
				console.log(response);
				editNodeText(response);
			}
		});
});

/**
 * 隱藏指定id的節點
 * @param id  Array of String
 */
function hide_nodes(id,groupType){
	for(var i = 0; i < id.length; ++i)
		node = $('#'+groupType).jstree().get_node(id[i]);
	$('#'+groupType).jstree().hide_node(node);
}
function hide_nodesTitleCondition(id,groupType,titleCondition){
			var node = $('#'+groupType).jstree().get_node(id);
			if(node.text.indexOf(titleCondition)==-1)
			{
				//alert('remove');
				$('#'+groupType).jstree(true).hide_node(node);
				//$('#'+groupType).jstree(true).delete_node(node);
				return false;
			}
			else
			{
				return true;
			}
}

/**
 * 顯示指定id的節點
 * @param id  Array of String
 */
function show_nodes(id,groupType){
	
	for(var i = 0; i < id.length; ++i)
		node = $('#'+groupType).jstree().get_node(id[i]);
	$('#'+groupType).jstree().show_node(node);
}

/**
  * 取得最上層節點
  * @param    
  * @return String Arrays  回傳所有最上層的ID。Ex: [1, 2, 3, 4]     
  */
function getRootID(groupType,groupType){
	
	var jstreeData = $("#"+groupType).jstree().get_json();
	var tops = [];
	for(var i = 0; i < jstreeData.length; ++i){
		tops.push(jstreeData[i].id);
	}
	console.log(tops);
	return tops;
} 

/**
  * 取得父節點ID
  * @param    
  * @return String Arrays  回傳所有最上層的ID。Ex: [1, 2, 3, 4]     
  */
function getParentID(id, groupType){
    
    var parentID = $("#" + groupType).jstree().get_parent(id);
    //console.log(node.parentID);
    return parentID;
}

/**
  * 取得指定節點的所有子節點ID
  * @param  id  指定節點的ID      
  * @return String Arrays  回傳所有子節點的ID。Ex: [1, 2, 3, 4]     
  */
function getChildrenID(id,groupType){
	
	//var node = $('#'+groupType).jstree().get_node(id);
	//console.log(node.children);
	//return node.children;
	var node = $('#'+groupType).jstree().get_node(id);  //node refers to jstree().get_node(id)
	//console.log(node);                                //如果node改變, jstree也會改變  (authorityStatisic.js的matchTop10有刪除節點)
	return node.children.slice();                       //solution: slice(): clones the array (node.children) and returns the reference to the new array 
	//return node.children;
}
function getChildren(id,groupType){
	
	//var node = $('#'+groupType).jstree().get_node(id);
	//console.log(node.children);
	//return node.children;
	var node = $('#'+groupType).jstree().get_node(id);  //node refers to jstree().get_node(id)
	//console.log(node);                                //如果node改變, jstree也會改變  (authorityStatisic.js的matchTop10有刪除節點)
	return node.children;                       //solution: slice(): clones the array (node.children) and returns the reference to the new array 
	//return node.children;
}

/**
  * 取得指定節點的深度, 文本(ex:三國志)是第一層
  * @param  id  指定節點的ID      
  * @return String Arrays  回傳所有子節點的ID。Ex: [1, 2, 3, 4]     
  */
function getDepth(id, groupType){
    
    var node = $('#'+groupType).jstree().get_node(id);
    var depth = node.parents.length - 2;                //node.parents回傳node的所有上層的節點, 扣掉["j1_1", "#"] 
    //console.log(depth);
    return depth;
}
/**取得所有節點
*/
function allNode(groupType)
{
		myTreeContainer =   $('#'+currentGroupType).jstree(true).get_container();
		
		var allChildren=myTreeContainer.find("li");
		for(var i=0;i<allChildren.length;i++){
			if($(allChildren[i]).attr("id").indexOf("_")==-1&&$(allChildren[i]).attr("id").indexOf("j")==-1)
		    {
		    	var bidTemp = $(allChildren[i]).attr("id");
		   	}
		}
}
/**
 * 更新jstree file
 */
function treeReflash(groupType)
{
	$("#treeReflash").show();
	$.get('text/segementGroupBookReflash.jsp',{'groupID':groupType}, function(data) {
		$("#treeReflash").hide();
		alert("文本目錄更新完成，網頁即將重新整理!");
		window.location.reload();
	});
}
/**
* 文本segement頁只載入jsTree
*/
function segementjstree(groupType)
{
	//alert(groupType);
	//第一次戴入設定比對文本才動作
	//alert(segementjstreeInit);
	//if(segementjstreeInit==0)
	//alert('currentGID:'+currentGID);
	if(true)
	$.get('text/segementGroupBook.jsp',{'groupID':groupType}, function(data) {
		//if($('#segementjstree').val())
		$('#segementjstree').jstree({'plugins':["wholerow","checkbox","search"],'search': {'case_insensitive': true,'show_only_matches' : true}, 'core' : {"check_callback" : true,
			'data' : JSON.parse(data.trim())
			//$('#'+groupType).jstree(true).select_node(currentGID);
		}}).on('ready.jstree', function(e, data){
			var tree = $('#segementjstree').jstree(true);
			var jstreeData = tree.get_json();
			//tree.open_node(jstreeData[0]);
			//$('#segementjstree').jstree(true).select_node(jstreeData[0]);
			if(currentGID!="")
				$('#segementjstree').jstree(true).select_node("j1_"+currentGID);
			else
				$('#segementjstree').jstree(true).select_node(currentBID);
		});
		
		//open all
		//$("#segementjstree").jstree("open_all");
		//selected all
		//alert(currentBIDItem[0]);
		//$("#segementjstree li[role=treeitem]").each(function () {
	    	$("#segementjstree").jstree('select_node', '#'+currentBIDItem[0]);
		//});
		//$("#segementjstreeTemp").html($("#segementjstree").html());
	});
	else
	{
	
	}
	
}

function jsTreeTempFilter()
{
	//alert('saf');
	//alert($('#segementjstreeTitle').val());
	$('#segementjstree').jstree(true).search($('#segementjstreeTitle').val());
}
/**
* 載入jsTree與文本資訊
*/
function jsTree(groupType,searchKey,bookSearch)
{
	//alert(bookSearch+" "+searchKey);
	
	$("#loadAction").show();
	currentGroupType = groupType;
	//群組文本程式產生
	//alert($('#'+groupType).html().length);
	if($('#'+groupType).html().length==0)
	$.get('text/segementGroupBook.jsp',{'groupID':groupType,'searchKey':searchKey,'bookSearch':bookSearch}, function(data) {
		$('#'+groupType).on('after_close.jstree', function (e, data) {
	            var tree = $('#'+groupType).jstree(true);
	            var children = tree.get_children_dom(data.node);
	            tree.delete_node(children);
	    })
	    .on("open_node.jstree", function(e, data){
			var tree = $('#'+groupType).jstree(true);
			var node = data.node;
			
			// 只展開選取的節點，關閉其他節點
			var nodeKeepOpen = [node.id]; // 要保持展開的節點，即選取節點的父節點
			node.parents.forEach(function(partenID){
				nodeKeepOpen.push(partenID)
			});
			$('.jstree-node').each( function(){ // 關閉所有節點，除了 nodeKeepOpen
				if(nodeKeepOpen.indexOf(this.id) === -1)
					tree.close_node(this.id);
			});


			// 展開葉節點。
			var children = tree.get_children_dom(node);
			console.log(children);
			do{
				tree.open_node(children);
				children = tree.get_children_dom(children);
			}while(children);
			
		})
		.on('ready.jstree', function(e, data){
			var tree = $("#"+groupType).jstree(true);
			var jstreeData = tree.get_json();
			if(jstreeData[0])
				currentBID = jstreeData[0].id;
		});
		
		//if($("#"+groupType).html()=='')
		{
			//var newNode = {'cache':false,'plugins':["wholerow","search"],'search': {'case_insensitive': true,'show_only_matches' : true}, 'core':{"check_callback" : true,
		    var newNode = {'cache':false,'plugins':["wholerow","search"],'search': {'show_only_matches' : true}, 'core':{"check_callback" : true,
		      'data' : JSON.parse(data.trim())
		      
		    }};
		    
			$('#'+groupType).jstree(newNode);
			
			$('#'+groupType).jstree("open_all");
			
			$('#'+groupType).on('changed.jstree', function (e, data) {
				  var path = data.instance.get_path(data.node,'/');
				  var pathItem = RemoveTFHTML(path).split("/");
				  //alert(path+" "+pathItem.length);
				  //群組與文本書名
				  currentHeaderPath = pathItem[0];
				  if(pathItem>1)
				  	  currentHeaderPath = currentHeaderPath+"/"+pathItem[1]+"/";
				  
				  //end 群組與文本書名
				  if(pathItem.length>=3)
				  {
				  	  if(pathItem[1]==pathItem[2])
				  	  {	
				  	  	path="";
		  		  	  	for(var i=0;i<pathItem.length;i++)
				  	  	{
				  	  	  	  if(i==1)
				  	  	  	  	  continue;
				  	  	  	  else
				  	  	  	  	path=path+pathItem[i]+"/";
				  	  	}
				  	 }
				  }
				  //alert(path);
				  var id =  data.node.id;
				  currentBID = id;
				 
				  var rawS = data.node.text.lastIndexOf('font>');
				  var rawE = data.node.text.indexOf(')',rawS);
				  if(rawS!=-1&&rawE!=-1&&(rawE>rawS))
				  {
				  	currentRawCount = parseInt(data.node.text.substring(rawS+6,rawE));
				  }
				  else
				  {
				  	  currentRawCount = -1;
				  }
				  currentText = RemoveTFHTML(data.node.text);
				  var endPathIndex = path.indexOf('(');
				  currentPath = RemoveTFHTML(path);//.replace('/\([^z]*?\)/g','');
				  currentPath = currentPath.replace("<span class='glyphicon glyphicon-cloud'>","");
				  currentPath = currentPath.replace("</span>","");
				  currentPath = currentPath.replace("<span class='glyphicon glyphicon-cloud'>","");
				  currentPath = currentPath.replace("</span>","");
				  //alert(currentPath);
				  if(path)
				  {
					  console.log('Selected: ' + path);
					  console.log('id: ' + id);
				  }
				  $('#searchDIV').show();
				  $('#segementDIV').show();
				  $("#pages").val("1");
				  $('#layout_right').html('');
				  
				  if(id.substring(0,1)=='j')
				  {
				  	 
				  	  currentGID = id.split("_")[1];
				  	  //alert("currentGID:"+currentGID);
				  }
				  else
				  	  currentGID = "";
				  if(id.indexOf("_")==-1)
				  {
				  	  
				  	  book_create(id,groupType);
				  }
				  if(isFirst!=0)
				  {
				  	  	search(id,1);
				  }
			 });
			 //打開第一個節點
			 //$('#'+groupType).jstree('select_node', ".jstree-anchor");
			 	isFirst = 1;
		}  //end if
	});
	
	$("#loadAction").hide();
}
function RemoveTFHTML( strText ) {
 
    var regEx = /\([^.]*?\)/g;
 
    return strText.replace(regEx, "");
 
}

var bookCreateList = [];
/**
* 載入文本JSON
*/
function book_create(id,groupType) {
	//alert(id);
	//create book node
	//alert(bookCreateList);
	if(bookCreateList.indexOf(id)==-1)
	{
		bookCreateList.push(id);
		var ref = $('#'+groupType).jstree(true),
		sel = ref.get_selected();
		if(!sel.length) { return false; }
		sel = sel[0];
		var request = $.getJSON("book/"+userSessionID+"/"+id+".json");
		//var request = $.postJSON("book/testnew.json");
		var book = {};
		request.complete(function() {
		  if(request.status!=404)
		  {
			  book = JSON.parse(request.responseText);
			  //alert(request.responseText);
			  var sel2 = ref.create_node(sel, book);
			  if(sel2) {
					//ref.edit(sel);
					$('#'+groupType).jstree("open_node", sel2);
					//$('#'+groupType).jstree("remove", sel);
					//$('#'+groupType).jstree().hide_node(sel2);
			   }
			   //$("#"+groupType).jstree().redraw(true);   //更新jstree
			   	  //$('#deliverables').jstree(true).show_all();
			   	   //$('#'+currentGroupType).jstree('search', "草");
			}
			else
			{
				alert("文本載入完成，請稍候!");
				$.get('text/segementGroupBook.jsp',{'groupID':currentGroupType,'reCreate':1}, function(data) {
					alert("資料重新整理完成，即將刷新頁面!");
					window.location.reload();
				});
				
			}
	    });
	}
	else
	{
		//alert("已建立");
	}
}
function getCurrentPath(groupType)
{
	var selectedNodes = $('#'+groupType).jstree(true).get_selected();
}
/**
	JS Tree被選取且不是Group與不是隱藏node ID
*/
function getSelectedID(JSTreeContentID)
{
	var selectedItem = $('#'+JSTreeContentID).jstree('get_selected');
	var itemsVec = new Array();
	for(var i=0;i<selectedItem.length;i++)
	{
		if(selectedItem[i].indexOf("j")==-1&&selectedItem[i].indexOf("_")==-1)
			if($("#"+selectedItem[i]).attr("class"))
			{
				if($("#"+selectedItem[i]).attr("class").indexOf("jstree-hidden")==-1)
					itemsVec.push(selectedItem[i]);
			}
			else
				itemsVec.push(selectedItem[i]);
		
	}
	//alert(itemsVec.join());
	return itemsVec;
}
/**
	JS Tree關鍵字有對到且不是Group與不是隱藏node ID
*/
function getOnlyKeyMatchID(JSTreeContentID)
{
	var itemsVec = new Array();
	myTreeContainer =   $('#'+currentGroupType).jstree(true).get_container();
	var allChildren=myTreeContainer.find("li");
	var searCount = 0;
	var allCount = 0;
	for(var i=0;i<allChildren.length;i++){
		if($(allChildren[i]).attr("id").indexOf("_")==-1&&$(allChildren[i]).attr("id").indexOf("j")==-1)
	    {
	    	allCount++;
	    	if($(allChildren[i]).attr("class"))
			{
				if($(allChildren[i]).attr("class").indexOf("jstree-hidden")==-1)
				{
					itemsVec.push(allChildren[i].id);
					searCount++;
				}
			}
			else
			{
				itemsVec.push(allChildren[i].id);
				searCount++;
			}
	   	}
	}
	//全查到設為無結果
	if(searCount==allCount)
		itemsVec = new Array();
	return itemsVec;
}
/**test code*/
function hide(id,titleCondition){
	//alert(titleCondition);
    //var id = $("#hide_id").val() ? $("#hide_id").val() : "j1_72";
    var tree = $("#main").jstree(true);
    var node = tree.get_node(id);
    //alert(node.text)
    if(node.text.indexOf(titleCondition)==-1)
    {
	    tree.hide_node(node);
	    console.log(node);
	}
}

function show(){

    var id = $("#hide_id").val() ? $("#hide_id").val() : "j1_72";
    var tree = $("#main").jstree(true);
    var node = tree.get_node(id);
    
    tree.show_node(node);
    console.log(node);
}
function del(){

    var id = $("#hide_id").val() ? $("#hide_id").val() : "j1_72";
    var tree = $("#main").jstree(true);
    var node = tree.get_node(id);
    
    /*######*/
    tree.delete_node(id);
    console.log(node);
}
