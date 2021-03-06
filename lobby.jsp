<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import ="db.DBText"%>
<%@ page import ="org.json.*"%>
<%@ page import ="java.text.*"%>
<%@ page import ="java.util.*"%>
<%@ page import ="java.time.YearMonth"%>
<html lang="zh-TW">
	<jsp:include page='includes/head.jsp'></jsp:include>
	<script>
		var user = getCookie('user');
		var name = getCookie('name');
		var identity = getCookie('identity');
		if(user === "" && identity === "" && name === ""){
			var result = alert("請登入");
			window.location = "http://localhost:8080/storebackup/login.jsp";
		}
	</script>
	<%
								Calendar now = Calendar.getInstance();
								YearMonth yearMonthObject = YearMonth.of(Calendar.DAY_OF_YEAR, Calendar.DAY_OF_MONTH+1);
								int daysInMonth = yearMonthObject.lengthOfMonth();
								DBText a = new DBText();
								JSONArray jar = new JSONArray();
	%>
	<body>
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<a class="navbar-brand" href="lobby.jsp">超商店員排班系統</a>
			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<h4 id="alertTime" style="text-align: center;color: red;"></h4>
			<h4 id="name" style="position:absolute;right:80px;"></h4>
			<a class="btn btn-outline-primary" id="logOut" style="position:absolute;right:10px;">登出</a>
		</nav>
		<div class="container-fluid">
			<div class="row">
				<nav class="col-md-2 d-none d-md-block bg-light sidebar">
					<div class="sidebar-sticky">
						<ul class="nav flex-column">
							<li class="nav-item">
								<a class="nav-link active" id="calendar" onclick="calendar()" href="#calendar">
									<img src="image/calendar.png" height="24" width="24">班表
								</a>
							</li>
							<li class="nav-item">  
								<a class="nav-link active" id="calendarAll" onclick="calendarAll()" href="#calendarAll">
									<img src="image/calendarAll.png" height="24" width="24">班表(全部)
								</a>
							</li>
							<li class="nav-item">
								<a class="nav-link active" id="calendarSet" onclick="calendarSet()" href="#calendarSet">
									<img src="image/calendarSet.png" height="24" width="24">排班
								</a>
							</li>
						</ul>
					</div>
				</nav>
				<main role="main" id="main1" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4" hidden>
					<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom">
						<h1 class="h2">個人班表</h1>
					</div>
					<div class="calendar">
						<div class="title">
							<h1 class="green" id="calendar-title">Month</h1>
							<h2 class="green-small" id="calendar-year">Year</h2>
							<!--<a class="prev" id="prev">
								<img src="image/left.png" height="24" width="24" >
							</a>
							<a class="next" id="next">
								<img src="image/right.png" height="24" width="24" >
							</a>-->
						</div>
						<div class="body">
							<div class="lightgrey body-list">
								<ul>
									<li>MON</li>
									<li>TUE</li>
									<li>WED</li>
									<li>THU</li>
									<li>FRI</li>
									<li>SAT</li>
									<li>SUN</li>
								</ul>
							</div>
							<div class="darkgrey body-list">
								<ul id="days">
								</ul>
							</div>
						</div>
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
						<h1 class="h2">本月班表</h1>
					</div>
					<div>
					<h3>早班(12:00 a.m. ~8:00 a.m.)</h1>
					<span id="morningTable"></span>
					</div>
					<div>
					<h3>午班(8:00 a.m. ~4:00 p.m.)</h1>
					<span id="noonTable"></span>
					</div>
					<div>
					<h3>晚班(4:00 p.m. ~12:00 a.m.)</h1>
					<span id="nightTable"></span>
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
						<h1 class="h2">每月排班</h1>
						<div class="btn-toolbar mb-2 mb-md-0">
							<h3 id="limitTime">
							</h3>
						</div>
					</div>
					<div id="div3" hidden>
						<h4>選擇下個月可能可以上班的日期</h4>
						<%
							for(int i=1; i<=daysInMonth; i++){
						%>
						<input type="checkbox" id="arrange<%=i%>"><%=i%></input>
						<%
								if(i%7 == 0){
						%>
						<br>
						<%
								}
							}
						%>
						<br>
						<input type="checkbox" id="checkArrange">全選</input>
						<br>
						<input type="button" id="cancelArrange" value="取消"></input>
						<input type="button" value="送出" onclick="arrangeSubmit()"></input>
					</div>
					<div id="div4" hidden>
						<h4>已選的日期</h4>
						<%
							a.connection();
							String sql = "SELECT `day` FROM `staff-arrange` WHERE `name` ='"+session.getAttribute("name")+"' and `month`="+(now.get(Calendar.MONTH)+2)+" and `user` ='"+session.getAttribute("user")+"'ORDER BY CAST(`staff-arrange`.`day` AS UNSIGNED) ASC";
							jar =a.getData(sql);
							if(!jar.isEmpty()){
								for(int i = 0; i < jar.length(); i++){
									JSONObject obj = jar.getJSONObject(i);
						%>
						<input type="checkbox" id="edit<%=obj.get("day")%>"><%=obj.get("day")%></input>
						<%
									if(i%7 == 6){
						%>
						<br>
						<%
									}
								}
							}
						%>
						<br>
						<input type="checkbox" id="editArrange">全選</input>
						<br>
						<input type="button" id="cancelEdit" value="取消"></input>
						<input type="button" value="刪除" onclick="arrangeDelete()"></input>
					</div>
					<div id="div5" class="row" hidden>
						<h4>安排上班人員</h4>
						<div class="col">
							<h5>12:00 a.m. ~8:00 a.m.(1人/天)</h5>
							<%
								ArrayList<String> worker = new ArrayList<String>();
								ArrayList<String> workerChoose = new ArrayList<String>();
								ArrayList<String> worker2 = new ArrayList<String>();
								ArrayList<String> workerChoose2 = new ArrayList<String>();
								ArrayList<String> worker3 = new ArrayList<String>();
								ArrayList<String> workerChoose3 = new ArrayList<String>();
								JSONArray morningWorker = a.getData("SELECT `user`,`name` FROM `staff-account` WHERE `workTime` = 'morning'");
								for(int i=1; i<=daysInMonth; i++){
							%>
							<h6><%=i%>(選擇人員：<span>
								<select id="workTimeMorning<%=i%>">
									<option value=""></option>
								<%
									if(!morningWorker.isEmpty()){
										for(int j=0; j<morningWorker.length(); j++){
											JSONObject obj = morningWorker.getJSONObject(j);
								%>
									<option value="<%=obj.get("name")+"("+obj.get("user")+")"+i%>"><%=obj.get("name")+"("+obj.get("user")+")"%></option>
									<%
										}
									}
									%>
								</select>
							</span>）</h6>
								<%
									JSONArray c = a.getData("SELECT `user`,`name` FROM `staff-arrange` WHERE `day` ='" + i+ "' AND `year` ='"+now.get(Calendar.YEAR)+"' AND `month` ='"+(now.get(Calendar.MONTH)+2)+"' AND `orderWork` = 'morning'");
									JSONArray decidePeople = a.getData("SELECT `user`,`name` FROM `staff-worktime` WHERE `day` ='" + i+ "' AND `year` ='"+now.get(Calendar.YEAR)+"' AND `month` ='"+(now.get(Calendar.MONTH)+2)+"' AND `orderWork` = 'morning'");
									String adviceMor = "";
									String unadviceMor = "";
									String decideMor = "";
									if(!c.isEmpty()){
										for(int j=0; j<c.length(); j++){
											JSONObject obj = c.getJSONObject(j);
											workerChoose.add(obj.get("name").toString()+"("+obj.get("user")+")");//這一天有誰可以工作
										}
									}
									if(!decidePeople.isEmpty()){
										for(int j=0; j<decidePeople.length(); j++){
											JSONObject obj = decidePeople.getJSONObject(j);
											decideMor += obj.get("name")+"("+obj.get("user")+")";
										}
									}
									if(!morningWorker.isEmpty()){
										for(int j=0; j<morningWorker.length(); j++){
											JSONObject obj = morningWorker.getJSONObject(j);
											worker.add(obj.get("name").toString()+"("+obj.get("user")+")");//工作時間是早上的人
										}
									}
									if(workerChoose.size() != 0){
										for(int j=0; j< workerChoose.size(); j++){
											adviceMor += workerChoose.get(j)+"、";
										}
										for(int k=0;k< workerChoose.size(); k++){
											for(int j=0; j<worker.size(); j++){
												if(worker.get(j).equals(workerChoose.get(k))){
													worker.remove(j);
													break;
												}
											}
										}
									}
									for(int j=0; j<worker.size(); j++){
										unadviceMor += worker.get(j)+"、";
									}
									adviceMor = adviceMor.length() > 0 ? adviceMor.substring(0, adviceMor.length() - 1) : adviceMor;
									unadviceMor = unadviceMor.length() > 0 ? unadviceMor.substring(0, unadviceMor.length() - 1) : unadviceMor;
									adviceMor = adviceMor.equals("") ? "無" : adviceMor;
									decideMor = decideMor.equals("") ? "無" : decideMor;
									unadviceMor = unadviceMor.equals("") ? "無" : unadviceMor;
									workerChoose.clear();
									worker.clear();
								%>
							<h6>
								已選人員：<%=decideMor%>
							</h6>
							<h6>
								建議的人員：<%=adviceMor%>
							</h6>
							<h6>
								不建議的人員：<%=unadviceMor%>
							</h6>
							<%
								}
							%>
						</div>
						<div class="col">
							<h5>8:00 a.m. ~4:00 p.m.(2人/天)</h5>
							<%
								JSONArray noonWorker =a.getData("SELECT `user`,`name` FROM `staff-account` WHERE `workTime` = 'noon'");
								for(int i=1; i<=daysInMonth; i++){
							%>
							<h6><%=i%>(選擇人員：<span>
								<select id="workTimeNoon<%=i%>">
									<option value=""></option>
								<%
									if(!noonWorker.isEmpty()){
										for(int j=0; j<noonWorker.length(); j++){
											JSONObject obj = noonWorker.getJSONObject(j);
								%>
									<option value="<%=obj.get("name").toString()+"("+obj.get("user")+")"%>"><%=obj.get("name").toString()+"("+obj.get("user")+")"%></option>
									<%
										}
									}
									%>
								</select>
								<select id="twoWorkTimeNoon<%=i%>">
									<option value=""></option>
								<%
									if(!noonWorker.isEmpty()){
										for(int j=0; j<noonWorker.length(); j++){
											JSONObject obj = noonWorker.getJSONObject(j);
								%>
									<option value="<%=obj.get("name").toString()+"("+obj.get("user")+")"+i%>"><%=obj.get("name").toString()+"("+obj.get("user")+")"%></option>
									<%
										}
									}
									%>
								</select>
							</span>)</h6>
								<%
									JSONArray d =a.getData("SELECT `user`,`name` FROM `staff-arrange` WHERE `day` ='" +i+ "' AND `year` ='"+now.get(Calendar.YEAR)+"' AND `month` ='"+(now.get(Calendar.MONTH)+2)+"' AND `orderWork` = 'noon'");
									JSONArray decidePeople2 =a.getData("SELECT `user`,`name` FROM `staff-worktime` WHERE `day` ='" +i+ "' AND `year` ='"+now.get(Calendar.YEAR)+"' AND `month` ='"+(now.get(Calendar.MONTH)+2)+"' AND `orderWork` = 'noon'");
									String decideNoo = "";
									String adviceNoo = "";
									String unadviceNoo = "";
									if(!d.isEmpty()){
										for(int j=0; j<d.length(); j++){
											JSONObject obj = d.getJSONObject(j);
											workerChoose2.add(obj.get("name").toString()+"("+obj.get("user")+")");//這一天有誰可以工作
										}
									}
									if(!decidePeople2.isEmpty()){
										for(int j=0; j<decidePeople2.length(); j++){
											JSONObject obj = decidePeople2.getJSONObject(j);
											decideNoo += obj.get("name").toString()+"("+obj.get("user")+")"+"、";
										}
									}
									if(!noonWorker.isEmpty()){
										for(int j=0; j<noonWorker.length(); j++){
											JSONObject obj = noonWorker.getJSONObject(j);
											worker2.add(obj.get("name").toString()+"("+obj.get("user")+")");//工作時間是早上的人
										}
									}
									if(workerChoose2.size() != 0){				
										for(int j=0; j< workerChoose2.size(); j++){
											adviceNoo += workerChoose2.get(j)+"、";
										}
										for(int k=0;k< workerChoose2.size(); k++){
											for(int j=0; j<worker2.size(); j++){
												if(worker2.get(j).equals(workerChoose2.get(k))){
													worker2.remove(j);
													break;
												}
											}
										}
									}
									for(int j=0; j<worker2.size(); j++){
										unadviceNoo += worker2.get(j)+"、";
									}
									adviceNoo = adviceNoo.length() > 0 ? adviceNoo.substring(0, adviceNoo.length() - 1) : adviceNoo;
									unadviceNoo = unadviceNoo.length() > 0 ? unadviceNoo.substring(0, unadviceNoo.length() - 1) : unadviceNoo;
									decideNoo = decideNoo.length() > 0 ? decideNoo.substring(0, decideNoo.length() - 1) : decideNoo;
									adviceNoo = adviceNoo.equals("") ? "無" : adviceNoo;
									decideNoo = decideNoo.equals("") ? "無" : decideNoo;
									unadviceNoo = unadviceNoo.equals("") ? "無" : unadviceNoo;
									workerChoose2.clear();
									worker2.clear();
								%>
							<h6>
								已選人員：<%=decideNoo%>
							</h6>			
							<h6>
								建議的人員：<%=adviceNoo%>
							</h6>
							<h6>
								不建議的人員：<%=unadviceNoo%>
							</h6>
							<%
								}
							%>
						</div>
						<div class="col">
							<h5>4:00 p.m. ~12:00 a.m.(2人/天)</h5>
							<%
								JSONArray nightWorker =a.getData("SELECT `user`,`name` FROM `staff-account` WHERE `workTime` = 'night'");
								for(int i=1; i<=daysInMonth; i++){
							%>
							<h6><%=i%>(選擇人員：<span>
								<select id="workTimeNight<%=i%>">
									<option value=""></option>
								<%
									if(!nightWorker.isEmpty()){
										for(int j=0; j<nightWorker.length(); j++){
											JSONObject obj = nightWorker.getJSONObject(j);
								%>
									<option value="<%=obj.get("name").toString()+"("+obj.get("user")+")"%>"><%=obj.get("name").toString()+"("+obj.get("user")+")"%></option>
									<%
										}
									}
									%>
								</select>
								<select id="twoWorkTimeNight<%=i%>">
									<option value=""></option>
								<%
									if(!nightWorker.isEmpty()){
										for(int j=0; j<nightWorker.length(); j++){
											JSONObject obj = nightWorker.getJSONObject(j);
								%>
									<option value="<%=obj.get("name").toString()+"("+obj.get("user")+")"+i%>"><%=obj.get("name").toString()+"("+obj.get("user")+")"%></option>
									<%
										}
									}
									%>
								</select>
							</span>)</h6>
								<%
									JSONArray e =a.getData("SELECT `user`,`name` FROM `staff-arrange` WHERE `day` ='" +i+ "' AND `year` ='"+now.get(Calendar.YEAR)+"' AND `month` ='"+(now.get(Calendar.MONTH)+2)+"' AND `orderWork` = 'night'");
									JSONArray decidePeople4 =a.getData("SELECT `user`,`name` FROM `staff-worktime` WHERE `day` ='" +i+ "' AND `year` ='"+now.get(Calendar.YEAR)+"' AND `month` ='"+(now.get(Calendar.MONTH)+2)+"' AND `orderWork` = 'night'");
									String adviceNig = "";
									String unadviceNig = "";
									String decideNig = "";
									if(!e.isEmpty()){
										for(int j=0; j<e.length(); j++){
											JSONObject obj = e.getJSONObject(j);
											workerChoose3.add(obj.get("name").toString()+"("+obj.get("user")+")");//這一天有誰可以工作
										}
									}
									if(!decidePeople4.isEmpty()){
										for(int j=0; j<decidePeople4.length(); j++){
											JSONObject obj = decidePeople4.getJSONObject(j);
											decideNig += obj.get("name").toString()+"("+obj.get("user")+")"+"、";
										}
									}
									if(!nightWorker.isEmpty()){
										for(int j=0; j<nightWorker.length(); j++){
											JSONObject obj = nightWorker.getJSONObject(j);
											worker3.add(obj.get("name").toString()+"("+obj.get("user")+")");//工作時間是早上的人
										}
									}
									if(workerChoose3.size() != 0){				
										for(int j=0; j< workerChoose3.size(); j++){
											adviceNig += workerChoose3.get(j)+"、";
										}
										for(int k=0;k< workerChoose3.size(); k++){
											for(int j=0; j<worker3.size(); j++){
												if(worker3.get(j).equals(workerChoose3.get(k))){
													worker3.remove(j);
													break;
												}
											}
										}
									}
									for(int j=0; j<worker3.size(); j++){
										unadviceNig += worker3.get(j)+"、";
									}
									
									adviceNig = adviceNig.length() > 0 ? adviceNig.substring(0, adviceNig.length() - 1) : adviceNig;
									unadviceNig = unadviceNig.length() > 0 ? unadviceNig.substring(0, unadviceNig.length() - 1) : unadviceNig;
									decideNig = decideNig.length() > 0 ? decideNig.substring(0, decideNig.length() - 1) : decideNig;
									adviceNig = adviceNig.equals("") ? "無" : adviceNig;
									decideNig = decideNig.equals("") ? "無" : decideNig;
									unadviceNig = unadviceNig.equals("") ? "無" : unadviceNig;
									
									workerChoose3.clear();
									worker3.clear();
								%>
							<h6>
								已選人員：<%=decideNig%>
							</h6>
							<h6>
								建議的人員：<%=adviceNig%>
							</h6>
							<h6>
								不建議的人員：<%=unadviceNig%>
							</h6>
							<%
								}
								a.closeConnection();
							%>
						</div>
					</div>
					<input type="button" id="bossArrange" onclick="bossArrange()" value="送出" hidden></input>
					<canvas class="my-4 chartjs-render-monitor" id="myChart" width="866" height="365" style="display: block; width: 866px; height: 365px;"></canvas>
				</main>
			</div>
		</div>
	</body>
</html>
<script type="text/javascript">
	var month_olympic = [31,29,31,30,31,30,31,31,30,31,30,31];
	var month_normal = [31,28,31,30,31,30,31,31,30,31,30,31];
	var month_name = ["January","Febrary","March","April","May","June","July","Auguest","September","October","November","December"];
	var holder = document.getElementById("days");
	/*var prev = document.getElementById("prev");
	var next = document.getElementById("next");*/
	var ctitle = document.getElementById("calendar-title");
	var cyear = document.getElementById("calendar-year");
	var my_date = new Date();
	var my_year = my_date.getFullYear();
	var my_month = my_date.getMonth();
	var my_day = my_date.getDate();
	
	function dayStart(month, year) {
		var tmpDate = new Date(year, month, 1);
		return (tmpDate.getDay());
	}
	
	function daysMonth(month, year) {
		var tmp = year % 4;
		if (tmp === 0) {
			return (month_olympic[month]);
		} else {
			return (month_normal[month]);
		}
	}
	
	function refreshDate(){
		var str = "";
		var totalDay = daysMonth(my_month, my_year); 
		var firstDay = dayStart(my_month, my_year); 
		var myclass;
		for(var i=1 ; i< firstDay; i++){ 
			str += "<li id=></li>"; 
		}
		for(var i=1 ; i<= totalDay; i++){
			str += "<li id="+my_year+"_"+(my_month+1)+"_"+i+">"+i+"</li>";
		}
		holder.innerHTML = str; 
		ctitle.innerHTML = month_name[my_month]; 
		cyear.innerHTML = my_year; 
		$.ajax({
			url: 'api/store/sWork.jsp',
			type: 'POST',
			async: false,
			data: {
				"getWorkTime"		: "true",
				"name"  : getCookie('name'),
				"month"	: my_month,
				"year"	: my_year,
			},
		}).done(function (data){
			for(var i= 0; i< data.split("、").length-1; i++){
				$("#"+my_year+"_"+(my_month+1)+"_"+data.split("、")[i])[0].className += "green-small";
			}
		});
	}
	
	function calendar(){
		$("#main1").attr('hidden',false);
		$("#main2").attr('hidden',true);
		$("#main3").attr('hidden',true);
	}
	
	function calendarAll(){
		$("#main1").attr('hidden',true);
		$("#main2").attr('hidden',false);
		$("#main3").attr('hidden',true);
	}
	
	function calendarSet(){
		$("#main1").attr('hidden',true);
		$("#main2").attr('hidden',true);
		$("#main3").attr('hidden',false);
	}
	
	/*prev.onclick = function(e){
		e.preventDefault();
		my_month--;
		if(my_month<0){
			my_year--;
			my_month = 11;
		}
		refreshDate();
	}
	next.onclick = function(e){
		e.preventDefault();
		my_month++;
		if(my_month>11){
			my_year++;
			my_month = 0;
		}
		refreshDate();
	}*/
	$("#checkArrange").click(function(){
		if($("#checkArrange").prop("checked")){//如果全選按鈕有被選擇的話（被選擇是true）
			$("input[id*='arrange']").each(function(){
				$(this).prop("checked",true);//把所有的核取方框的property都變成勾選
			})
		}else{
			$("input[id*='arrange']").each(function(){
				$(this).prop("checked",false);//把所有的核方框的property都取消勾選
			})
		}
	})
	
	$("#editArrange").click(function(){
		if($("#editArrange").prop("checked")){//如果全選按鈕有被選擇的話（被選擇是true）
			$("input[id*='edit']").each(function(){
				$(this).prop("checked",true);//把所有的核取方框的property都變成勾選
			})
		}else{
			$("input[id*='edit']").each(function(){
				$(this).prop("checked",false);//把所有的核方框的property都取消勾選
			})
		}
	})
	
	$("#cancelArrange").click(function(){
		$("input[id*='arrange']").each(function(){
			$(this).prop("checked",false);//把所有的核取方框的property都變成勾選
		})
		$("#checkArrange").prop("checked",false);
	})
	
	$("#cancelEdit").click(function(){
		$("input[id*='edit']").each(function(){
			$(this).prop("checked",false);//把所有的核取方框的property都變成勾選
		})
		$("#editArrange").prop("checked",false);
	})
	
	$("#logOut").click(function(){
		deleteCookie('identity');
		deleteCookie('name');
		deleteCookie('user');
		$(location).attr('href','http://localhost:8080/storebackup/login.jsp')
	})
	
	function arrangeSubmit(){
		var day = [];
		for(var i= 0; i< $("input[id*='arrange']").length; i++){
			if($("input[id*='arrange']")[i].checked === true){
				day.push(i+1);
			}
		}
		for(var i= 0; i< $("input[id*='edit']").length; i++){
			for(var j=0; j<day.length;j++){
				if(day[j] == $("input[id*='edit']")[i].nextSibling.data.trim()){
					day.splice(j, 1);
					break;
				}
			}
		}
		$.ajax({
			url: 'api/store/sWork.jsp',
			type: 'POST',
			async: false,
			data: {
				"arrange"		: "true",
				"name"  : getCookie('name'),
				"user"	: getCookie('user'),
				"day"	: day,
				"month"	: my_month,
				"year"	: my_year,
			},
		}).done(function(){
			window.location = "http://localhost:8080/storebackup/lobby.jsp";
		});
	}
	
	function arrangeDelete(){
		var day = [];
		for(var i= 0; i< $("input[id*='edit']").length; i++){
			if($("input[id*='edit']")[i].checked === true){
				day.push($("input[id*='edit']")[i].nextSibling.data.trim());
			}
		}
		$.ajax({
			url: 'api/store/sWork.jsp',
			type: 'POST',
			async: false,
			data: {
				"edit"		: "true",
				"user"  : getCookie('user'),
				"day"	: day,
			},
		}).done(function(){
			window.location = "http://localhost:8080/storebackup/lobby.jsp";
		});
	}
	
	function bossArrange(){
		var noonAir = "";
		var nightAir = "";
		for(var i= 0; i<$("select[id*='workTimeNoon']").length; i++){
			if(($("select[id*='workTimeNoon']")[i].value === "" && $("select[id*='twoWorkTimeNoon']")[i].value !== "") || ($("select[id*='workTimeNoon']")[i].value !== "" && $("select[id*='twoWorkTimeNoon']")[i].value === "") || ($("select[id*='workTimeNoon']")[i].value === $("select[id*='twoWorkTimeNoon']")[i].value && $("select[id*='twoWorkTimeNoon']")[i].value !== "")){
				noonAir += (i+1)+"、";
			}
			if(($("select[id*='workTimeNight']")[i].value === "" && $("select[id*='twoWorkTimeNight']")[i].value !== "") || ($("select[id*='workTimeNight']")[i].value !== "" && $("select[id*='twoWorkTimeNight']")[i].value === "") || ($("select[id*='workTimeNight']")[i].value === $("select[id*='twoWorkTimeNight']")[i].value && $("select[id*='twoWorkTimeNight']")[i].value !== "")){
				nightAir += (i+1)+"、";
			}
		}
		if(noonAir.length > 0 || nightAir.length > 0){
			noonAir = noonAir.substring(0, noonAir.length-1);
			nightAir = nightAir.substring(0, nightAir.length-1);
			alert("午班："+noonAir+" 以及 晚班："+nightAir+" 有少派人 或者 重複指派人");
		}else{
			var name = [];
			for(var i=0; i<$("select[id*='workTimeMorning']").length; i++){
				if($("select[id*='workTimeMorning']")[i].value === ""){
					name.push("無");
				}else{
					var value = $("select[id*='workTimeMorning']")[i].value;
					name.push(value);
				}
			}
			$.ajax({
				url: 'api/store/sWork.jsp',
				type: 'POST',
				async: false,
				data: {
					"decide"		: "true",
					"name"  : name,
					"year"	:my_year,
					"month"	:my_month,
					"orderWork"	: "morning",
				},
			});
			name = [];
			for(var i=0; i<$("select[id*='workTimeNoon']").length; i++){
				if($("select[id*='twoWorkTimeNoon']")[i].value === "" || $("select[id*='workTimeNoon']")[i].value === ""){
					name.push("無");
				}else{
					name.push($("select[id*='workTimeNoon']")[i].value+$("select[id*='twoWorkTimeNoon']")[i].value);
					console.log($("select[id*='workTimeNoon']")[i].value+$("select[id*='twoWorkTimeNoon']")[i].value);
				}
			}
			$.ajax({
				url: 'api/store/sWork.jsp',
				type: 'POST',
				async: false,
				data: {
					"decide"		: "true",
					"name"  : name,
					"year"	: my_year,
					"month"	: my_month,
					"orderWork"	: "noon",
				},
			});
			name = [];
			for(var i=0; i<$("select[id*='workTimeNight']").length; i++){
				if($("select[id*='twoWorkTimeNight']")[i].value === "" || $("select[id*='workTimeNight']")[i].value === ""){
					name.push("無");
				}else{
					name.push($("select[id*='workTimeNight']")[i].value+$("select[id*='twoWorkTimeNight']")[i].value);
				}
			}

			$.ajax({
				url: 'api/store/sWork.jsp',
				type: 'POST',
				async: false,
				data: {
					"decide"		: "true",
					"name"  : name,
					"year"	: my_year,
					"month"	: my_month,
					"orderWork"	: "night",
				},
			}).done(function(){
				window.location = "http://localhost:8080/storebackup/lobby.jsp";
			});
		}
	}
	
	$(function() {
		if(getCookie('identity') === "boss"){
			$("#calendar").attr('hidden',true);
			$("#calendarAll").attr('hidden',false);
			$("#calendarSet").attr('hidden',false);
			$("#div3").attr('hidden', true);
			$("#div4").attr('hidden', true);
			$("#div5").attr('hidden', false);
			$("#div6").attr('hidden', false);
			$("#limitTime").attr('hidden', true);
			$("#bossArrange").attr('hidden', false);
			$.ajax({
				url: 'api/store/sWork.jsp',
				type: 'POST',
				async: false,
				data: {
					"allTable"		: "true",
					"year"	: my_year,
					"month"	: my_month,
				},
			}).done(function(data){
				var morningT = "";
				var noonT = "";
				var nightT = "";
				for(var i in JSON.parse(data)){
					if(i.split("_")[0].includes("morning")){
						$("#morningTable")[0].innerHTML += i.split("_")[1]+"："+JSON.parse(data)[i]+"<br>";
					}else if(i.split("_")[0].includes("noon")){
						$("#noonTable")[0].innerHTML += i.split("_")[1]+"："+JSON.parse(data)[i]+"<br>";
					}else if(i.split("_")[0].includes("night")){
						$("#nightTable")[0].innerHTML += i.split("_")[1]+"："+JSON.parse(data)[i]+"<br>";
					}
				}
			});
		}else{
			$("#calendar").attr('hidden',false); 
			$("#calendarAll").attr('hidden',true);
			$("#calendarSet").attr('hidden',true);
			$("#div3").attr('hidden', false);
			$("#div4").attr('hidden', false);
			$("#div5").attr('hidden', true);
			$("#div6").attr('hidden', true);
		}
		$("#limitTime").text("開放時間："+(my_month+1)+"/"+(daysMonth(my_month, my_year)-6)+"～"+(my_month+1)+"/"+(daysMonth(my_month, my_year)-1));
		$("#name").text(getCookie('name'));

		if((my_day < (daysMonth(my_month, my_year)-25) || my_day > (daysMonth(my_month, my_year)-1) )&& getCookie('identity') === "staff"){
			$("#calendarSet").attr('hidden',true);
			$("#alertTime").text("請注意本月排班時間是："+(my_month+1)+"/"+(daysMonth(my_month, my_year)-6)+"～"+(my_month+1)+"/"+(daysMonth(my_month, my_year)-1));
		}else if((daysMonth(my_month, my_year)-6) <= my_day <= (daysMonth(my_month, my_year)-1) && getCookie('identity') === "staff"){
			$("#calendarSet").attr('hidden',false);
		}
		calendarAll();
		refreshDate();
	})
	
</script>
<style>
	.calendar{
		width:1050px;
		height:400px;
		background:#fff;
		box-shadow:0px 1px 1px rgba(0,0,0,0.1);
	}
	.green, .green-small{
		text-align:center;
	}
	.next, .prev{
		cursor: pointer;
	}
	.body-list ul{
		width:100%;
		font-family:arial;
		font-weight:bold;
		font-size:14px;
	}
	.body-list ul li{
		width:14.28%;
		height:36px;
		line-height:36px;
		list-style-type:none;
		display:block;
		box-sizing:border-box;
		float:left;
		text-align:center;
	}
	.green, .green-small{
		color:#6ac13c; /*绿色*/
	}
	body {
	   background-image: url("image/lobby.jpg");
	   background-size: 100% 100%;
	}
</style>
