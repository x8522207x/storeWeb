<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="utils.*" %>
<%@include file="Include/DBSetup.jsp" %>
<%@include file="Include/sessionChecker.jsp" %>
<%
if(!Utils.checkReferrer(Utils.getString(request.getHeader("referer")))){
	response.sendRedirect("login.jsp");
}
String funs = "";
try{
%>
<jsp:include page="head.jsp" flush="true">
	<jsp:param name="title" value="數位人文研究平台" />
	<jsp:param name="desc" value="數位人文研究平台" />
	<jsp:param name="style" value=".pre-scrollable{margin-top:10px;}" />
</jsp:include>
<body>
<div class="container width50" id="app" style="margin-bottom: 30px" > 
  <%@ include file="menu.jsp" %>
  <div class="text-center padding15"><h3>{{title}}</h3></div>
  <ul class="nav nav-tabs">
	<li :class="['tab', tab == 'manage' ? 'active' : '']"><a href="javascript:void(0);" @click="changeTab('manage')">管理成員</a></li>
	<li :class="['tab', tab == 'validate' ? 'active' : '']"><a href="javascript:void(0);" @click="changeTab('validate')">待審核成員</a></li>
  </ul>
  <div v-if="tab == 'validate'">
	  <div class="list-group">
		<a href="#" class="list-group-item" v-for="user in users" data-toggle="modal" data-target="#validateModal" v-on:click="setValidate(user)">
		使用者名稱：{{user.name}}<br>
		描述：{{user.info}}<br>
		請求加入【<font style='color: red'>{{user.group}}</font>】群組
		<!--<div class="pull-right">
		  <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" v-on:click="validate(user)">
			允許加入
		  </button>
		</div>-->
		</a>
	  </div>
	  <div v-show="typeof users === 'undefined' || users.length == 0">
		沒有資料
	  </div>
  </div>
  <div v-else>
	<div class="list-group">
 	  <a href="#" class="list-group-item" v-for="group in groups" data-toggle="modal" data-target="#myModal" v-on:click="setData(group)">
		群組名稱：{{group.name}}<br>
		描述：{{group.info}}
	  </a>
	</div>
	<div v-show="typeof groups === 'undefined' || groups.length == 0">
	沒有資料
	</div>
  </div>

<!-- 審核成員 Modal -->
<div class="modal fade" id="validateModal" tabindex="-1" role="dialog" aria-labelledby="validateModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">審核成員</h4>
      </div>
      <div class="modal-body">
		<div><label>名稱：</label>{{validate_modal_name}}</div>
		<div><label>描述：</label>{{validate_modal_info}}</div>
		<div><label>請求加入的群組：</label><font style='color:red'>{{validate_modal_group}}</font></div>
			<label>權限設定：</label> <a href="javascript:dealCheck('all')">全選</a> /  <a href="javascript:dealCheck('none')">清除</a><br>
			<div style='padding-left: 5px;' id="div_funs_checkbox">
				<span v-for="fun in funcs">
					<label style="font-weight: normal; float: left">
						<input type="checkbox" v-model="checked_funcs" v-bind:value="fun.id"> {{fun.info}}&nbsp&nbsp&nbsp
					</label>
				</span>
			</div>
			<p>&nbsp</p>
			<hr>
			<div style='text-align: center'><button type="button" class="btn btn-primary" v-on:click="validate(validate_modal_id, validate_modal_gid, validate_modal_guid)">同意加入</button></div>
      </div>
    </div>
  </div>
</div>


  <!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
	  <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">管理群組成員</h4>
      </div>
      <div class="modal-body" id="modal-body">
	    <div class="input-group">
          <input type="text" class="form-control" placeholder="加入使用者" v-model="keyword" id="search_input">
          <span class="input-group-btn">
            <button class="btn btn-secondary" type="button" @click="add" id="addUser">加入</button>
          </span>
        </div>
		<div class="pre-scrollable">
		  <div class="panel-group" id="accordion">
			<div class="panel panel-default" v-for="user in modal_users" style="margin-bottom: -5px; margin-right: 10px;">
			  <div class="panel-heading">
				<h4 class="panel-title">
				  <button type="button" class="close" v-show="user.uid != '<%=USER_SESSION.getId()%>'">
				    <span aria-hidden="true" @click="del(user)">&times;</span><span class="sr-only">Close</span>
				  </button>
				  <a data-toggle="collapse" data-parent="#accordion" :href="'#collapse' + user.id" style="text-decoration: none" @click="reset(user.uid)">{{user.name}}</a>
				</h4>
			  </div>
			  <div :id="'collapse' + user.id" class="panel-collapse collapse">
				<div class="panel-body" style="width: 100%">
				<table width="100%">
				  <tr>
				    <td width="60%">
					  <div>姓名：{{user.name}}</div>
 					  <div>帳號：{{user.account}}</div>
					  <div>單位：{{user.org}}</div>
					  <div>附註：{{user.info}}</div>
					</td>
					<td width="40%" style="padding-left: 30px">
						<div v-for="fun in funcs" v-show="user.uid != '<%=USER_SESSION.getId()%>'">
						<label style="font-weight: normal">
							<input type="checkbox" v-model="checked_funcs" v-bind:value="fun.id"> {{fun.info}}
						</label>
						</div>
					</td>
				  </tr>
				</table>
				<div style="text-align: center" v-show="user.uid != '<%=USER_SESSION.getId()%>'">
  				  <button type="button" class="btn btn-primary" v-on:click="modify(user)">修改權限</button>
				</div>
				</div>
				<span style="clear:both"></span>
			  </div>
			</div>
		  </div>
		</div>
		<br>
	  </div>
	</div>
  </div>
</div>
<center v-show="tab == 'manage'">
<nav aria-label="Page navigation example">
  <ul class="pagination justify-content-center">
    <li class="page-item" :class="[between == 1 || nowPage == 1 ? 'invisible' : '']">
      <a class="page-link" href="javascript:void(0);" @click="prevRangePage">上{{chnNumChar[range]}}頁&laquo;</a>
	</li>
	<li class="page-item" v-for="txt in count" :class="[nowPage == txt ? 'active' : '']">
      <a class="page-link" @click="changePage(txt)">{{ txt }}</a>
	</li>
	<li class="page-item" :class="[nowPage == totalPage || between >= Math.ceil(totalPage / range) ? 'invisible' : '']">
      <a class="page-link" href="javascript:void(0);" @click="nextRangePage">下{{chnNumChar[range]}}頁&raquo;</a>
	</li>
  </ul>
</nav>
</center>
<!-- Modal Start here-->
<div class="modal fade bs-example-modal-sm" id="myPleaseWait" tabindex="-1"
    role="dialog" aria-hidden="true" data-backdrop="static">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">
                    <span class="glyphicon glyphicon-time">
                    </span>Please Wait
                 </h4>
            </div>
            <div class="modal-body">
                <div class="progress">
                    <div class="progress-bar progress-bar-info
                    progress-bar-striped active"
                    style="width: 100%">
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Modal ends Here -->
</div>
<%@ include file="footer.jsp" %>
</body>
</html>
<script>
var data = {
	tab: 'manage',
	title: '群組成員設定',
	user: '',
	users: [],
	group: '',
	groups: [],
	funcs: [],
	group_funcs: [],
	checked_funcs: [],
	modal_users: [],
	validate_modal_name: '',
	validate_modal_info: '',
	validate_modal_guid: '',
	validate_modal_id: '',
	validate_modal_group: '',
	validate_modal_gid: '',
	table: 'owngroup',
	id: '',
	name: '',
	info: '',
	search_name: '',
	publicType: 0,
	valid: 0,
	start: 0,
	end: 0,
	totalPage: 0,
	totalRecord: 0,
	range: 5,
	count: [],
	ownFuns: [],
	nowPage: 1,
	pageSize: 5,
	between: 0,
	chnNumChar: ["零","一","二","三","四","五","六","七","八","九"],
	keyword: '',
	disabled: false,
};

var ajax = (function($) {
    var handler = {};
    handler.post = function(url, data, success) {
        $.ajax({
            url: url,
            type: "POST",
            data: data,
			beforeSend: function(){
				$('#myPleaseWait').modal('show');
			},
            success: function(resp) {
                success(resp);
            },
            error: function(xhr) {
				alert('伺服器發生錯誤');
			},
			complete: function(){
				$('#myPleaseWait').modal('hide');
			},
        });
    }
    handler.get = function(url, data, success) {
        $.ajax({
            url: url,
            type: "GET",
            data: data,
			beforeSend: function(){
				$('#myPleaseWait').modal('show');
			},
            success: function(resp) {
                success(resp);
            },
            error: function(xhr) {
                alert('伺服器發生錯誤');
            },
			complete: function(){
				$('#myPleaseWait').modal('hide');
			},
        });
    }
    return handler;
}(jQuery));


var app = new Vue({
  el: '#app',
  data: data,
  methods: {
	setValidate: function(user){
		data.validate_modal_name = user.name;
		data.validate_modal_info = user.info;
		data.validate_modal_guid = user.guid;
		data.validate_modal_id	 = user.id;
		data.validate_modal_group= user.group;
		data.validate_modal_gid	 = user.gid;
		data.checked_funcs = [];
		data.checked_funcs = user.authority.split(',');
	},
	del: function(user){
		delUser(user);
	},
	add: function(){
		addUser();
	},
	reset: function(uid){
		data.checked_funcs = [];
		if($.trim(data.group_funcs[uid]) != ''){
			data.checked_funcs = data.group_funcs[uid].split(',')
		}
	},
    modify: function(user){
		modifyFuns(user.uid, data.group.id, data.checked_funcs);
	},
	validate: function(uid, gid, guid){	
		permitUser(uid, gid, guid);
	},
	nextRangePage: function(){
		var tmp = data.between * data.range + 1;
		if(data.between < Math.ceil(data.totalPage / data.range)){
			if(tmp <= data.totalPage) {
				data.nowPage = tmp;
			}else{
				data.nowPage = (data.between - 1) * data.range + 1;
			}
			getData();
			getPagination();
		}
	},
	prevRangePage: function(){
		if(data.between != 1){
			var tmp = (data.between - 1) * data.range;
			if(tmp > 0) {
				data.nowPage = tmp;
			}else{
				data.nowPage = (data.between) * data.range;
			}
			getData();
			getPagination();
		}
	},
	changePage: function(param){
		data.nowPage = param;
		getData();
		getPagination();
	},
	setData: function(group){
		$('div[id^=collapse]').removeClass('in');
		data.group = group;
		getGroupUserList(group);
		getGroupFuns(group.id);
	},
	changeTab: function(param){
		data.tab = param;
		if(data.tab == "manage"){
			getData();
			getPagination();
		}else if(data.tab == "validate"){
			getValidateList();
		}
	},
  },
});
function dealCheck(type){
	if(type == 'all'){
		$('#div_funs_checkbox input').each(function(){
			data.checked_funcs.push($(this).val());
		});
	}else{
		data.checked_funcs = [];
	}
}
// 新增使用者
var addUser = function(){
	var param = {
		type: 'add',
		id: data.group.id,
		keyword: data.keyword
	};
	ajax.post(
		"api/processUserGroup.jsp", 
		param, 
		function (resp) { 
			if($.trim(resp) == "ok"){
				alert('修改完成');
				data.keyword = '';
				getGroupUserList(data.group);
				getGroupFuns(data.group.id);
			}else{
				alert('使用者不存在或已在群組');
			}
		}
	);
};

// 刪除使用者
var delUser = function(user){
	var param = {
		type: 'del',
		id: user.id,
		guid: user.uid,
		keyword: data.group.name
	};
	if(confirm('確定將【' + user.name + '】從群組移除？')){
		ajax.post(
			"api/processUserGroup.jsp", 
			param, 
			function (resp) { 
				if($.trim(resp) == "ok"){
					alert('修改完成');
					getGroupUserList(data.group);
					getGroupFuns(data.group.id);
				}else{
					alert('伺服器發生錯誤');
				}
			}
		);
	}
};

// 驗證使用者
var permitUser = function(uid, gid, guid){
	var param = {
		type: 'add',
		id: uid,
		guid: guid,
		uname: data.validate_modal_name,
		gname: data.validate_modal_group
	};
	ajax.post(
		"api/processUserGroup.jsp", 
		param, 
		function (resp) { 
			if($.trim(resp) == "ok"){
				modifyFunsValidate(data.validate_modal_guid, gid, data.checked_funcs);
			}else{
				alert('伺服器發生錯誤');
			}
		}
	);
};
// 取得群組使用者清單
var getGroupUserList = function(group){
	ajax.post(
		"api/getGroupUser.jsp", 
		{
			type: 'manage',
			gid: group.id,
		}, 
		function (resp) { 
			data.users = [];
			resp = $.trim(resp);
			if(resp != "" && resp != "error"){
				data.modal_users = JSON.parse(resp);
			}
		}
	);
};
// 取得需要驗證的清單
var getValidateList = function(){
	ajax.post(
		"api/getGroupUser.jsp", 
		{
			type: 'validate'
		}, 
		function (resp) { 
			data.users = [];
			resp = $.trim(resp);
			if(resp != "" && resp != "error"){
				data.users = JSON.parse(resp);
			}else{
				alert('伺服器發生錯誤');
			}
		}
	);
};
// 分頁
var getPagination = function(){
	ajax.post(
		"api/getPagination.jsp", 
		{
			type: data.keyword,
			nowPage: data.nowPage,
			range: data.range,
			pageSize: data.pageSize,
			table: data.table
		}, 
		function (resp) { 
			var json = JSON.parse(resp);
			data.totaPage = json.totalPage;
			data.totalRecord = json.totalRecord;
			data.totalPage = json.totalPage;
			data.start = json.start;
			data.end = json.end;
			data.between = json.between;
			data.count = [];
			for(var i = data.start; i <= data.end; i++){
				data.count.push(i);
			}
		}
	);
};
// 列表
var getData = function(){
	ajax.post(
		"api/getGroupList.jsp", 
		{
			own: 'true',
			type: data.keyword,
			nowPage: data.nowPage,
			pageSize: data.pageSize,
			table: data.group,
		}, 
		function (resp) { 
			data.groups = JSON.parse(resp);
		}
	);
};
// 功能選單
var getFuns = function(){
	ajax.post(
		"api/getFunList.jsp", 
		{
			type: 'uploadfuns'
		}, 
		function (resp) { 
			data.funcs = JSON.parse(resp);
		}
	);
};
// 根據群組取得權限
var getGroupFuns = function(gid){
	ajax.post(
		"api/getFunList.jsp", 
		{
			type: 'groupfuns',
			uid: gid, // 實際是 gid
		}, 
		function (resp) { 
			data.group_funcs = JSON.parse(resp);
		}
	);
};
// 修改權限 for validate
var modifyFunsValidate = function(uid, gid, fids){
	ajax.post(
		"api/processUserFunction.jsp", 
		{
			uid: uid,
			gid: gid,
			fid: fids.toString()
		}, 
		function (resp) { 
			resp = $.trim(resp);
			if(resp != "" && resp != "error"){
				alert('修改完成');
				getValidateList();
				$('#validateModal').modal('hide');
			}else{
				alert('伺服器發生錯誤');
			}
		}
	);
};
// 修改權限
var modifyFuns = function(uid, gid, fids){
	var param = {
		uid: uid,
		gid: gid,
		fid: fids.toString()
	};
	ajax.post(
		"api/processUserFunction.jsp", 
		param, 
		function (resp) { 
			resp = $.trim(resp);
			if(resp != "" && resp != "error"){
				alert('修改成功');
				getGroupFuns(gid);
			}else{
				alert('伺服器發生錯誤');
			}
		}
	);
};
$(function(){
	getData();
	getPagination();
	getFuns();
	$('#search_input').keypress(function(event){
		if (event.keyCode == 13) {
			$('#addUser').trigger("click");
		}
	});
});
</script>
<%
}catch(Exception e){
	if(Utils.DEBUG)
		out.print(e);
	e.printStackTrace();
}finally{
	DBUtils.closeConnection(conn);
}
%>