<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import ="ascdc.sinica.dhtext.db.DBText"%>
<%@ page import ="java.util.ArrayList"%>
<%@ page import ="java.util.Set"%>
<%@ page import ="java.util.TreeSet"%>
<html lang="zh-TW">
	<head>
		<meta charset="utf-8">
		<title>微積分教學平台</title>
		<link rel="stylesheet" href="css/fontawesome/css/font-awesome.min.css">
		<link rel="stylesheet" href="assets/css/style.css">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
		<link href="https://gitcdn.github.io/bootstrap-toggle/2.2.2/css/bootstrap-toggle.min.css" rel="stylesheet">
		<script src="https://code.jquery.com/jquery-3.3.1.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" ></script>
		<script src="https://gitcdn.github.io/bootstrap-toggle/2.2.2/js/bootstrap-toggle.min.js"></script>
	</head>
	<body>
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<a class="navbar-brand" href="lobby.jsp">微積分教學平台</a>
			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<h4 id="user" style="position:absolute;right:80px;"></h4>
			<a class="btn btn-outline-primary" href="login.jsp"  style="position:absolute;right:10px;">登出</a>
		</nav>
		<div class="container-fluid">
			<div class="row">
				<nav class="col-md-2 d-none d-md-block bg-light sidebar">
					<div class="sidebar-sticky">
						<ul class="nav flex-column">
							<li class="nav-item">
								<a class="nav-link active" id="classVideo" onclick="classVideo()" href="#classVideo">
									<img src="image/video.png" height="24" width="24">上課影片
								</a>
							</li>
							<li class="nav-item">  
								<a class="nav-link active" id="practiceQ" onclick="practiceQ()" href="#practiceQ">
									<img src="image/practice.jpg" height="24" width="24">練習題目
								</a>
							</li>
							<li class="nav-item">
								<a class="nav-link active" id="testQ" onclick="testQ()" href="#testQ">
									<img src="image/exam.png" height="24" width="24">考試題目
								</a>
							</li>
						</ul>
					</div>
				</nav>

				<main role="main" id="main1" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4" hidden>
					<div class="chartjs-size-monitor" style="position: absolute; left: 0px; top: 0px; right: 0px; bottom: 0px; overflow: hidden; pointer-events: none; visibility: hidden; z-index: -1;">
						<div class="chartjs-size-monitor-expand" style="position:absolute;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1;">
							<div style="position:absolute;width:1000000px;height:1000000px;left:0;top:0"></div>
						</div>
						<div class="chartjs-size-monitor-shrink" style="position:absolute;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1;">
							<div style="position:absolute;width:200%;height:200%;left:0; top:0"></div>
						</div>
					</div>
					<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom">
						<h1 class="h2">上課影片</h1>
						<div class="btn-toolbar mb-2 mb-md-0">
							<div class="btn-group mr-2">
								<button class="btn btn-sm btn-outline-secondary" id="add" hidden>
									<img src="https://use.fontawesome.com/releases/v5.0.13/svgs/solid/plus.svg"  width=24 height=24>
								新增</button>
							</div>
						</div>
					</div>
					<div>
						<table>
							<thead>
								<tr>
									<th>第幾章</th>
									<th >列表</th> 
								</tr>
							</thead>
							<tbody>
								<%
								DBText a = new DBText();
								ArrayList<String> keyList = new ArrayList<String>();
								a.connection();
								String b[][] =a.getData("SELECT `partChapter` FROM `classvideo`");
								if(b != null){
									for(int i = 0; i < b.length; i++){
										keyList.add(b[i][0].split("-")[0]);
									}
									ArrayList<String> columnList = new ArrayList<String>();
									Set<String> ts = new TreeSet<String>();
									ts.addAll(keyList);
									for (String key : ts) {
										columnList.add(key);
									}
									for(int i = 0 ; i< columnList.size();i++){
								%>
									<tr>
										<td><%=columnList.get(i)%></td>
										<td>
											<button class="btn btn-sm btn-outline-secondary" id="video<%=columnList.get(i)%>" name="video">
												<img src="https://use.fontawesome.com/releases/v5.1.0/svgs/solid/list.svg" width=24 height=24>
											</button>
										</td> 
									</tr>
									<%
									}
								}
								%>
							</tbody>
						</table>
					</div>
					<canvas class="my-4 chartjs-render-monitor" id="myChart" width="866" height="365" style="display: block; width: 866px; height: 365px;"></canvas>
				</main>
				<main role="main" id="main2" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4" hidden>
					<div class="chartjs-size-monitor" style="position: absolute; left: 0px; top: 0px; right: 0px; bottom: 0px; overflow: hidden; pointer-events: none; visibility: hidden; z-index: -1;">
						<div class="chartjs-size-monitor-expand" style="position:absolute;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1;">
							<div style="position:absolute;width:1000000px;height:1000000px;left:0;top:0"></div>
						</div>
						<div class="chartjs-size-monitor-shrink" style="position:absolute;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1;">
							<div style="position:absolute;width:200%;height:200%;left:0; top:0"></div>
						</div>
					</div>
					<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom">
						<h1 class="h2">練習題目</h1>
						<div class="btn-toolbar mb-2 mb-md-0">
							<div class="btn-group mr-2">
								<button class="btn btn-sm btn-outline-secondary" id="add2" hidden>
									<img src="https://use.fontawesome.com/releases/v5.0.13/svgs/solid/plus.svg"  width=24 height=24>
								新增</button>
							</div>
						</div>
					</div>
					<div>
						<table>
							<thead>
								<tr>
									<th>第幾章</th>
									<th >列表</th> 
								</tr>
							</thead>
							<tbody>
								<%
								ArrayList<String> keyList2 = new ArrayList<String>();
								String b2[][] =a.getData("SELECT `partChapter` FROM `practiceq`");
								if(b2 != null){
									for(int i = 0; i < b2.length; i++){
										keyList2.add(b2[i][0].split("-")[0]);
									}
									ArrayList<String> columnList2 = new ArrayList<String>();
									Set<String> ts2 = new TreeSet<String>();
									ts2.addAll(keyList2);
									for (String key : ts2) {
										columnList2.add(key);
									}
									for(int i = 0 ; i< columnList2.size();i++){
								%>
									<tr>
										<td><%=columnList2.get(i)%></td>
										<td>
											<button class="btn btn-sm btn-outline-secondary" id="practice<%=columnList2.get(i)%>" name="practice">
												<img src="https://use.fontawesome.com/releases/v5.1.0/svgs/solid/list.svg" width=24 height=24>
											</button>
										</td> 
									</tr>
								<%
									}
								}
								%>
							</tbody>
						</table>
					</div>
					<canvas class="my-4 chartjs-render-monitor" id="myChart" width="866" height="365" style="display: block; width: 866px; height: 365px;"></canvas>
				</main>
				<main role="main" id="main3" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4" hidden>
					<div class="chartjs-size-monitor" style="position: absolute; left: 0px; top: 0px; right: 0px; bottom: 0px; overflow: hidden; pointer-events: none; visibility: hidden; z-index: -1;">
						<div class="chartjs-size-monitor-expand" style="position:absolute;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1;">
							<div style="position:absolute;width:1000000px;height:1000000px;left:0;top:0"></div>
						</div>
						<div class="chartjs-size-monitor-shrink" style="position:absolute;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1;">
							<div style="position:absolute;width:200%;height:200%;left:0; top:0"></div>
						</div>
					</div>
					<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom">
						<h1 class="h2">考試題目</h1>
						<div class="btn-toolbar mb-2 mb-md-0" id="testQuestion" hidden>
							<div class="btn-group mr-2">
								<input type="checkbox" id="switch" checked data-toggle="toggle" data-on="開啟" data-off="關閉" data-offstyle="danger"></input>
							</div>
							<div class="btn-group mr-2">
								<button class="btn btn-sm btn-outline-secondary" id="add3">
									<img src="https://use.fontawesome.com/releases/v5.0.13/svgs/solid/plus.svg"  width=24 height=24>
								新增</button>
							</div>
						</div>
					</div>
					<div>
						<%
							ArrayList<String> grade = new ArrayList<String>();
							ArrayList<String> question = new ArrayList<String>();
							ArrayList<String> answer = new ArrayList<String>();
							String b3[][] =a.getData("SELECT `grade`,`question`,`answer` FROM `testq`");
							if(b3 != null){
								for(int i = 0; i < b3.length; i++){
									grade.add(b3[i][0]);
									question.add(b3[i][1]);
									answer.add(b3[i][2]);
								}
								a.closeConnection();
								for(int i = 0 ; i< grade.size();i++){
						%>
						<h5><%=grade.get(i)%>分  題目:<%=question.get(i)%></h5>
						<input type="textarea" name="test" id="test<%=i%>"></input>
						<button class="btn btn-sm btn-outline-secondary" name="testDelete" hidden>
							<img src="https://use.fontawesome.com/releases/v5.0.13/svgs/solid/trash-alt.svg"  width=24 height=24 hidden>
						刪除</button>
						<button class="btn btn-sm btn-outline-secondary" name="testEdit"  hidden>
							<img src="https://use.fontawesome.com/releases/v5.0.13/svgs/solid/edit.svg" width=24 height=24 >
						修改</button>
						<%
								}
							}
						%>
					</div>
					<div>
						<button id="testSubmit">送出</button>
					</div>
					<canvas class="my-4 chartjs-render-monitor" id="myChart" width="866" height="365" style="display: block; width: 866px; height: 365px;"></canvas>
				</main>
				<main role="main" id="main1-1" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4" hidden>
					<div class="chartjs-size-monitor" style="position: absolute; left: 0px; top: 0px; right: 0px; bottom: 0px; overflow: hidden; pointer-events: none; visibility: hidden; z-index: -1;">
						<div class="chartjs-size-monitor-expand" style="position:absolute;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1;">
							<div style="position:absolute;width:1000000px;height:1000000px;left:0;top:0"></div>
						</div>
						<div class="chartjs-size-monitor-shrink" style="position:absolute;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1;">
							<div style="position:absolute;width:200%;height:200%;left:0; top:0"></div>
						</div>
					</div>
					<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom">
						<h1 class="h2">影片列表</h1>
					</div>
					<div>
						<table>
						<thead>
							<tr>
								<th>第幾節</th>
								<th>影片</th>
								<th id="tableVideoDelete" hidden>刪除</th>
								<th id="tableVideoEdit" hidden>修改</th>
							</tr>
						</thead>
						<tbody id="tbody1-1">
						</tbody>
						</table>
					</div>
					<canvas class="my-4 chartjs-render-monitor" id="myChart" width="866" height="365" style="display: block; width: 866px; height: 365px;"></canvas>
				</main>
				<main role="main" id="main2-1" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4" hidden>
					<div class="chartjs-size-monitor" style="position: absolute; left: 0px; top: 0px; right: 0px; bottom: 0px; overflow: hidden; pointer-events: none; visibility: hidden; z-index: -1;">
						<div class="chartjs-size-monitor-expand" style="position:absolute;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1;">
							<div style="position:absolute;width:1000000px;height:1000000px;left:0;top:0"></div>
						</div>
						<div class="chartjs-size-monitor-shrink" style="position:absolute;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1;">
							<div style="position:absolute;width:200%;height:200%;left:0; top:0"></div>
						</div>
					</div>
					<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom">
						<h1 class="h2">題目列表</h1>
					</div>
					<div>
						<table>
						<thead>
							<tr>
								<th>第幾節</th>
								<th>題目</th> 
								<th id="tableQuestionDelete" hidden>刪除</th> 
							</tr>
						</thead>
						<tbody id="tbody2-1">
						</tbody>
						</table>
					</div>
					<canvas class="my-4 chartjs-render-monitor" id="myChart" width="866" height="365" style="display: block; width: 866px; height: 365px;"></canvas>
				</main>
			</div>
		</div>
	</body>
	</html>
	<script type="text/javascript">
		$(function() {
			if(getCookie('switchCheck') === 'true'){
				$("#testQ").attr('hidden',false);
				$('#switch').prop('checked', true).change()
			}else if(getCookie('switchCheck') === 'false'){
				$("#testQ").attr('hidden',true);
				$('#switch').prop('checked', false).change()
			}
			$('#switch').change(function() {
				setCookie('switchCheck',$(this)[0].checked, 30);
			})
			if(getCookie('identity') === "teacher"){
				$("#add").attr('hidden',false);
				$("#delete1-1").attr('hidden',false);
				$("#edit1-1").attr('hidden',false);
				$("#add2").attr('hidden',false);
				$("#delete2-1").attr('hidden',false);
				$("#edit2-1").attr('hidden',false);
				$("testEdit").attr('hidden',false);
				$("testDelete").attr('hidden',false);
				$("#delete3").attr('hidden',false);
				$("#edit3").attr('hidden',false);
				$("#testQ").attr('hidden',false);
				$("#tableVideoDelete").attr('hidden',false);
				$("#tableVideoEdit").attr('hidden',false);
				$("#tableQuestionDelete").attr('hidden',false);
				$("#testQuestion").attr('hidden',false);
			}
			$("#user").text(getCookie('user'));
		  })
		$("#add").click(function(){
			window.open('addClassVideo.jsp', 'addClassVideo', 'height=200,width=400');
		});
		$("#add2").click(function(){
			window.open('addPracticeQ.jsp', 'addPracticeQ', 'height=200,width=400');
		});
		$("#add3").click(function(){
			window.open('addTestQ.jsp', 'addTestQ', 'height=200,width=400');
		});
		function classVideo(){
			$("#main1").attr('hidden',false);
			$("#main2").attr('hidden',true);
			$("#main3").attr('hidden',true);
			$("#main1-1").attr('hidden',true);
			$("#main2-1").attr('hidden',true);	
		}
		function practiceQ(){
			$("#main1").attr('hidden',true);
			$("#main2").attr('hidden',false);
			$("#main3").attr('hidden',true);	
			$("#main1-1").attr('hidden',true);
			$("#main2-1").attr('hidden',true);
		}
		function testQ(){
			$("#main1").attr('hidden',true);
			$("#main2").attr('hidden',true);
			$("#main3").attr('hidden',false);	
			$("#main1-1").attr('hidden',true);
			$("#main2-1").attr('hidden',true);
		}
		$("button[name='video']").click(function(){
			$("#main1").attr('hidden',true);
			$("#main1-1").attr('hidden',false);
			$("#tbody1-1 tr").remove(); 
			var partNumber = 0;
			var Chapter = this.id.split("video")[1];
			var tbody = document.getElementById('tbody1-1');
			$.ajax({
				url: 'api/math/getTable.jsp',
				type: 'POST',
				async: false,
				data: {
					"video"  : "true",
					"partChapter"	: this.id.split("video")[1],
				},
			}).done(function (data){	
				partNumber = data.split("]")[0].substring(1,data.split("]")[0].length).split(' ').join('');
			});
			for (var i = 0; i < partNumber.split(",").length; i++) {//產生table
				var tr = document.createElement('tr');
				var td = document.createElement('td');
				var td2 = document.createElement('td');
				var td3 = document.createElement('td');
				var td4 = document.createElement('td');
				var button = document.createElement('button');
				var deleteButton = document.createElement('button');
				var editButton = document.createElement('button');
				var img = document.createElement('img');
				var img2 = document.createElement('img');
				var img3 = document.createElement('img');
				img.setAttribute('src','https://use.fontawesome.com/releases/v5.1.0/svgs/solid/video.svg');
				img2.setAttribute('src','https://use.fontawesome.com/releases/v5.0.13/svgs/solid/trash-alt.svg');
				img3.setAttribute('src','https://use.fontawesome.com/releases/v5.0.13/svgs/solid/edit.svg');
				img.setAttribute('width',24);
				img.setAttribute('hight',24);
				img2.setAttribute('width',24);
				img2.setAttribute('hight',24);
				img3.setAttribute('width',24);
				img3.setAttribute('hight',24);
				button.setAttribute('class','btn btn-sm btn-outline-secondary');
				button.setAttribute('class','btn btn-sm btn-outline-secondary');
				deleteButton.setAttribute('class','btn btn-sm btn-outline-secondary');
				button.setAttribute('name','video1-1');
				deleteButton.setAttribute('name','delete1-1');
				editButton.setAttribute('name','edit1-1');
				deleteButton.setAttribute('hidden','hidden');
				editButton.setAttribute('hidden','hidden');
				button.setAttribute('id',partNumber.split(",")[i]);
				deleteButton.setAttribute('id',partNumber.split(",")[i]);
				editButton.setAttribute('id',partNumber.split(",")[i]);
				button.appendChild(img);
				deleteButton.appendChild(img2);
				editButton.appendChild(img3);
				td.append(partNumber.split(",")[i]);
				td2.appendChild(button);
				td3.appendChild(deleteButton);
				td4.appendChild(editButton);
				td3.setAttribute('hidden','hidden');
				td4.setAttribute('hidden','hidden');
				tr.appendChild(td);
				tr.appendChild(td2);
				tr.appendChild(td3);
				tr.appendChild(td4);
				tbody.appendChild(tr);
				if(getCookie('identity') == "teacher"){
					$(deleteButton).attr('hidden',false);
					$(editButton).attr('hidden',false);
					$(td3).attr('hidden',false);
					$(td4).attr('hidden',false);
				}
			}
			$("button[name='video1-1']").click(function(){			
				$.ajax({
					url: 'api/math/videoAction.jsp',
					type: 'POST',
					async: false,
					data: {
						"watch"			: "true",
						"partNumber"	: this.id,
					},
				}).done(function (data){
					setCookie('partName',data.split(",")[0]);
					setCookie('video',data.split(",")[1].split("<")[0].trim().replace("watch?v=","embed/"));
				});
				window.open('video.jsp','video.jsp','width=500,height=500 ');
			});
			$("button[name='delete1-1']").click(function(){			
				$.ajax({
					url: 'api/math/videoAction.jsp',
					type: 'POST',
					async: false,
					data: {
						"delete"		: "true",
						"partNumber"	: this.id,
					},
				}).done(function (){
					self.location.reload();
				});
			});
			$("button[name='edit1-1']").click(function(){
				$.ajax({
					url: 'api/math/videoAction.jsp',
					type: 'POST',
					async: false,
					data: {
						"edit"		: "true",
						"partChapter"	: Chapter,
						"partNumber"	: this.id,
					},
				}).done(function(data){
					setCookie('partName',data.trim().split(",")[0].split("::")[1],30);
					setCookie('video',data.trim().split(",")[1].split("::")[1],30);
				});
				setCookie('partChapter',Chapter,30);
				setCookie('partNumber',this.id,30);
				window.open('videoEdit.jsp','videoEdit.jsp','width=500,height=500 ');
			});
		});
		
		$("button[name='practice']").click(function(){
			$("#main2").attr('hidden',true);
			$("#main2-1").attr('hidden',false);
			$("#tbody2-1 tr").remove(); 
			var partNumber = 0;
			var Chapter = this.id.split("practice")[1];
			var tbody = document.getElementById('tbody2-1');
			$.ajax({
				url: 'api/math/getTable.jsp',
				type: 'POST',
				async: false,
				data: {
					"practice"  : "true",
					"partChapter"	: Chapter,
				},
			}).done(function (data){
				partNumber = data.split("]")[0].substring(1,data.split("]")[0].length).split(' ').join('');
			});
			for (var i = 0; i < partNumber.split(",").length; i++) {//產生table
				var tr = document.createElement('tr');
				var td = document.createElement('td');
				var td2 = document.createElement('td');
				var td3 = document.createElement('td');
				var button = document.createElement('button');
				var deleteButton = document.createElement('button');
				var img = document.createElement('img');
				var img2 = document.createElement('img');
				img.setAttribute('src','https://use.fontawesome.com/releases/v5.1.0/svgs/solid/bars.svg');
				img.setAttribute('width',24);
				img.setAttribute('hight',24);
				img2.setAttribute('src','https://use.fontawesome.com/releases/v5.0.13/svgs/solid/trash-alt.svg');
				img2.setAttribute('width',24);
				img2.setAttribute('hight',24);
				button.setAttribute('class','btn btn-sm btn-outline-secondary');
				button.setAttribute('name','practice2-1');
				button.setAttribute('id',partNumber.split(",")[i]);
				button.appendChild(img);
				deleteButton.setAttribute('class','btn btn-sm btn-outline-secondary');
				deleteButton.setAttribute('name','delete2-1');
				deleteButton.setAttribute('hidden','hidden');
				deleteButton.setAttribute('id',partNumber.split(",")[i]);
				deleteButton.appendChild(img2);
				td.append(partNumber.split(",")[i]);
				td2.appendChild(button);
				td3.appendChild(deleteButton);
				td3.setAttribute('hidden','hidden');
				tr.appendChild(td);
				tr.appendChild(td2);
				tr.appendChild(td3);
				tbody.appendChild(tr);
				if(getCookie('identity') == "teacher"){
					$(deleteButton).attr('hidden',false);
					$(td3).attr('hidden',false);
				}
			}
			$("button[name='practice2-1']").click(function(){
				var idNumber = this.id;
				$.ajax({
					url: 'api/math/practiceAction.jsp',
					type: 'POST',
					async: false,
					data: {
						"watch"			: "true",
						"partChapter"   : Chapter,
						"partNumber"	: idNumber,
					},
				}).done(function (data){
					var question = data.trim().split(":::")[0];
					var answer = data.trim().split(":::")[1];
					setCookie('question',question,30);
					setCookie('answer',answer,30);
					setCookie('partNumber',idNumber,30);
					setCookie('partChapter',Chapter,30);
				});
				window.open('practice.jsp','practice.jsp','width=1000,height=1000');
			});
			$("button[name='delete2-1']").click(function(){			
				$.ajax({
					url: 'api/math/practiceAction.jsp',
					type: 'POST',
					async: false,
					data: {
						"delete"		: "true",
						"partNumber"	: this.id,
					},
				}).done(function (data){
					self.location.reload();
				});
			});
		});
		
		$("#testSubmit").click(function(){
			var userAnswer = "";
			for(var i =0; i < $("input[name='test']").length; i++){
				userAnswer+=$("input[name='test']")[i].value+",";
			}
			$.ajax({
				url: 'api/math/testAction.jsp',
				type: 'POST',
				async: false,
				data: {
					"result"  : "true",
					"userAnswer"	: userAnswer,
				},
			}).done(function (data){	
				alert("恭喜你得分:"+data.trim());
			});
		});
		function getCookie(cname) {
			var name = cname + "=";
			var ca = document.cookie.split(';');
			for (var i = 0; i < ca.length; i++) {
				var c = ca[i];
				while (c.charAt(0) == ' ') c = c.substring(1);
				if (c.indexOf(name) == 0)
					return c.substring(name.length, c.length);
			}
			return "";
		}
		function setCookie(cname, cvalue, exdays) {
			var d = new Date();
			d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
			var expires = "expires=" + d.toUTCString();
			document.cookie = cname + "=" + cvalue + ";path=" + location.host + "; " + expires;
		}
	</script>
	<style>
	table, th, td {
		border: 1px solid black;
		text-align: center;
	}
	table {
		width:50%;
		position:absolute;
		right:350px;
		background-color: #eee;
		border: 1px solid black;
	} 
	</style>
</html>