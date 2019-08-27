<%@ page import ="db.DBText"%>
<%@ page import ="org.json.*"%>
<%@ page import ="java.text.*"%>
<%@ page import ="java.util.*"%>
<%@ page import ="java.time.YearMonth"%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page='includes/head.jsp'></jsp:include>
<%
	Calendar now = Calendar.getInstance();
	YearMonth yearMonthObject = YearMonth.of(Calendar.DAY_OF_YEAR, Calendar.DAY_OF_MONTH+1);
	int daysInMonth = yearMonthObject.lengthOfMonth();
	DBText a = new DBText();
	JSONArray jar = new JSONArray();
%>
<body>
	<script>
		let user = getCookie('user'),
			name = getCookie('name'),
			identity = getCookie('identity');
		if(user === "" && identity === "" && name === "") {
			let result = alert("請登入");
			window.location = "http://localhost:8080/storebackup/login.jsp";
		}
	</script>
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="lobby.jsp">超商店員排班系統</a>
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
							<a class="nav-link active" id="calendar" href="#calendar">
								<img src="image/calendar.png" height="24" width="24">班表
							</a>
						</li>
						<li class="nav-item">  
							<a class="nav-link active" id="calendarAll" href="#calendarAll">
								<img src="image/calendarAll.png" height="24" width="24">班表(全部)
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link active" id="calendarSet" href="#calendarSet">
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
					<h2>本月班表</h2>
				</div>
				<div>
				<h3>早班(12:00 a.m. ~ 8:00 a.m.)</h1>
				<span id="morningTable"></span>
				</div>
				<div>
				<h3>午班(8:00 a.m. ~ 4:00 p.m.)</h1>
				<span id="noonTable"></span>
				</div>
				<div>
				<h3>晚班(4:00 p.m. ~ 12:00 a.m.)</h1>
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
					<h2>安排上班人員</h2>
					<div class="btn-toolbar mb-2 mb-md-0">
						<h3 id="limitTime">
						</h3>
					</div>
					<input type="button" id="bossArrange" value="送出" hidden></input>
				</div>
				<div id="div3" hidden>
					<h4>選擇下個月可能可以上班的日期</h4>
					<%
						for(int i = 1; i <= daysInMonth; i++) {
					%>
					<input type="checkbox" id= "day<%= i%>"><%= i%></input>
					<%
							if(i%7 == 0) {
					%>
					<br>
					<%
							}
						}
					%>
					<br>
					<input type="checkbox" id="arrangeCheck">全選</input>
					<br>
					<input type="button" id="arrangeCancel" value="取消"></input>
					<input type="button" value="送出" id="submit"></input>
				</div>
				<div id="div4" hidden>
					<h4>已選的日期</h4>
					<%
						a.connection();
						String sql = "SELECT `day` FROM `staff-arrange` WHERE `name` ='"+session.getAttribute("name")+"' and `month`="+(now.get(Calendar.MONTH)+2)+" and `user` ='"+session.getAttribute("user")+"'ORDER BY CAST(`staff-arrange`.`day` AS UNSIGNED) ASC";
						jar = a.getData(sql);
						if(!jar.isEmpty()) {
							for(int i = 0; i < jar.length(); i++) {
								JSONObject obj = jar.getJSONObject(i);
					%>
					<input type="checkbox" id="edit<%=obj.get("day")%>"><%=obj.get("day")%></input>
					<%
								if(i%7 == 6) {
					%>
					<br>
					<%
								}
							}
						}
					%>
					<br>
					<input type="checkbox" id="arrangeEdit">全選</input>
					<br>
					<input type="button" id="cancelEdit" value="取消"></input>
					<input type="button" id="delete" value="刪除"></input>
				</div>
				<div id="div5" class="row" hidden>
					<div class="col">
						<h5>12:00 a.m. ~ 8:00 a.m.(1人/天)</h5>
						<%
							ArrayList<String> worker = new ArrayList<String>();
							ArrayList<String> workerChoose = new ArrayList<String>();
							JSONArray morningWorker = a.getData("SELECT `user`,`name` FROM `staff-account` WHERE `workTime` = 'morning'");
							JSONArray workerC = new JSONArray();
							JSONArray decidePeople = new JSONArray();
							StringBuilder advice = new StringBuilder();
							StringBuilder unadvice = new StringBuilder();
							StringBuilder decide = new StringBuilder();
							for(int i = 1; i <= daysInMonth; i++) {
						%>
						<h6><%=i%>(選擇人員：<span>
							<select id="workTimeMorning<%=i%>">
								<option value=""></option>
							<%
								if(!morningWorker.isEmpty()) {
									for(int j = 0; j < morningWorker.length(); j++) {
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
								workerC = a.getData("SELECT `user`,`name` FROM `staff-arrange` WHERE `day` ='" + i+ "' AND `year` ='"+now.get(Calendar.YEAR)+"' AND `month` ='"+(now.get(Calendar.MONTH)+2)+"' AND `orderWork` = 'morning'");
								decidePeople = a.getData("SELECT `user`,`name` FROM `staff-worktime` WHERE `day` ='" + i+ "' AND `year` ='"+now.get(Calendar.YEAR)+"' AND `month` ='"+(now.get(Calendar.MONTH)+2)+"' AND `orderWork` = 'morning'");
								advice.delete(0, advice.length());
								unadvice.delete(0, unadvice.length());
								decide.delete(0, decide.length());
								if(!workerC.isEmpty()) {
									for(int j = 0; j < workerC.length(); j++) {
										JSONObject obj = workerC.getJSONObject(j);
										workerChoose.add(obj.get("name").toString()+"("+obj.get("user")+")");//這一天有誰可以工作
									}
								}
								if(!decidePeople.isEmpty()) {
									for(int j = 0; j < decidePeople.length(); j++) {
										JSONObject obj = decidePeople.getJSONObject(j);
										decide.append(obj.get("name")+"("+obj.get("user")+")");
									}
								}
								if(!morningWorker.isEmpty()) {
									for(int j = 0; j < morningWorker.length(); j++) {
										JSONObject obj = morningWorker.getJSONObject(j);
										worker.add(obj.get("name").toString()+"("+obj.get("user")+")");//工作時間是早上的人
									}
								}
								if(workerChoose.size() != 0) {
									for(int j = 0; j < workerChoose.size(); j++) {
										advice.append(workerChoose.get(j)+"、");
									}
									for(int k = 0; k < workerChoose.size(); k++) {
										for(int j = 0; j < worker.size(); j++) {
											if(worker.get(j).equals(workerChoose.get(k))) {
												worker.remove(j);
												break;
											}
										}
									}
								}
								for(int j = 0; j < worker.size(); j++) {
									unadvice.append(worker.get(j)+"、");
								}
								advice = advice.length() > 0 ? new StringBuilder(new StringBuilder(advice.substring(0, advice.length() - 1))) : advice;
								unadvice = unadvice.length() > 0 ? new StringBuilder(unadvice.substring(0, unadvice.length() - 1)) : unadvice;
								advice = advice.toString().equals("") ? new StringBuilder("無") : advice;
								decide = decide.toString().equals("") ? new StringBuilder("無") : decide;
								unadvice = unadvice.toString().equals("") ? new StringBuilder("無") : unadvice;
								workerChoose.clear();
								worker.clear();
							%>
						<h6>
							已選人員：<%=decide%>
						</h6>
						<h6>
							建議的人員：<%=advice%>
						</h6>
						<h6>
							不建議的人員：<%=unadvice%>
						</h6>
						<%
							}
						%>
					</div>
					<div class="col">
						<h5>8:00 a.m. ~ 4:00 p.m.(2人/天)</h5>
						<%
							JSONArray noonWorker = a.getData("SELECT `user`,`name` FROM `staff-account` WHERE `workTime` = 'noon'");
							for(int i = 1; i <= daysInMonth; i++) {
						%>
						<h6><%=i%>(選擇人員：<span>
							<select id="workTimeNoon<%=i%>">
								<option value=""></option>
							<%
								if(!noonWorker.isEmpty()) {
									for(int j = 0; j < noonWorker.length(); j++) {
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
								if(!noonWorker.isEmpty()) {
									for(int j = 0; j < noonWorker.length(); j++) {
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
								workerC = a.getData("SELECT `user`,`name` FROM `staff-arrange` WHERE `day` ='" +i+ "' AND `year` ='"+now.get(Calendar.YEAR)+"' AND `month` ='"+(now.get(Calendar.MONTH)+2)+"' AND `orderWork` = 'noon'");
								decidePeople = a.getData("SELECT `user`,`name` FROM `staff-worktime` WHERE `day` ='" +i+ "' AND `year` ='"+now.get(Calendar.YEAR)+"' AND `month` ='"+(now.get(Calendar.MONTH)+2)+"' AND `orderWork` = 'noon'");
								advice.delete(0, advice.length());
								unadvice.delete(0, unadvice.length());
								decide.delete(0, decide.length());
								if(!workerC.isEmpty()) {
									for(int j = 0; j < workerC.length(); j++) {
										JSONObject obj = workerC.getJSONObject(j);
										workerChoose.add(obj.get("name").toString()+"("+obj.get("user")+")");//這一天有誰可以工作
									}
								}
								if(!decidePeople.isEmpty()) {
									for(int j = 0; j < decidePeople.length(); j++) {
										JSONObject obj = decidePeople.getJSONObject(j);
										decide.append(obj.get("name").toString()+"("+obj.get("user")+")"+"、");
									}
								}
								if(!noonWorker.isEmpty()) {
									for(int j = 0; j < noonWorker.length(); j++) {
										JSONObject obj = noonWorker.getJSONObject(j);
										worker.add(obj.get("name").toString()+"("+obj.get("user")+")");//工作時間是早上的人
									}
								}
								if(workerChoose.size() != 0) {				
									for(int j = 0; j < workerChoose.size(); j++) {
										advice.append(workerChoose.get(j)+"、");
									}
									for(int k = 0; k < workerChoose.size(); k++) {
										for(int j = 0; j < worker.size(); j++) {
											if(worker.get(j).equals(workerChoose.get(k))) {
												worker.remove(j);
												break;
											}
										}
									}
								}
								for(int j = 0; j < worker.size(); j++) {
									unadvice.append(worker.get(j)+"、");
								}
								advice = advice.length() > 0 ? new StringBuilder(advice.substring(0, advice.length() - 1)) : advice;
								unadvice = unadvice.length() > 0 ? new StringBuilder(unadvice.substring(0, unadvice.length() - 1)) : unadvice;
								decide = decide.length() > 0 ? new StringBuilder(decide.substring(0, decide.length() - 1)) : decide;
								advice = advice.toString().equals("") ? new StringBuilder("無") : advice;
								decide = decide.toString().equals("") ? new StringBuilder("無") : decide;
								unadvice = unadvice.toString().equals("") ? new StringBuilder("無") : unadvice;
								workerChoose.clear();
								worker.clear();
							%>
						<h6>
							已選人員：<%=decide%>
						</h6>			
						<h6>
							建議的人員：<%=advice%>
						</h6>
						<h6>
							不建議的人員：<%=unadvice%>
						</h6>
						<%
							}
						%>
					</div>
					<div class="col">
						<h5>4:00 p.m. ~ 12:00 a.m.(2人/天)</h5>
						<%
							JSONArray nightWorker =a.getData("SELECT `user`,`name` FROM `staff-account` WHERE `workTime` = 'night'");
							for(int i = 1; i <= daysInMonth; i++) {
						%>
						<h6><%=i%>(選擇人員：<span>
							<select id="workTimeNight<%=i%>">
								<option value=""></option>
							<%
								if(!nightWorker.isEmpty()) {
									for(int j = 0; j < nightWorker.length(); j++) {
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
								if(!nightWorker.isEmpty()) {
									for(int j = 0; j < nightWorker.length(); j++) {
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
								workerC = a.getData("SELECT `user`,`name` FROM `staff-arrange` WHERE `day` ='" +i+ "' AND `year` ='"+now.get(Calendar.YEAR)+"' AND `month` ='"+(now.get(Calendar.MONTH)+2)+"' AND `orderWork` = 'night'");
								decidePeople = a.getData("SELECT `user`,`name` FROM `staff-worktime` WHERE `day` ='" +i+ "' AND `year` ='"+now.get(Calendar.YEAR)+"' AND `month` ='"+(now.get(Calendar.MONTH)+2)+"' AND `orderWork` = 'night'");
								advice.delete(0, advice.length());
								unadvice.delete(0, unadvice.length());
								decide.delete(0, decide.length());
								if(!workerC.isEmpty()) {
									for(int j = 0; j < workerC.length(); j++) {
										JSONObject obj = workerC.getJSONObject(j);
										workerChoose.add(obj.get("name").toString()+"("+obj.get("user")+")");//這一天有誰可以工作
									}
								}
								if(!decidePeople.isEmpty()) {
									for(int j = 0; j < decidePeople.length(); j++) {
										JSONObject obj = decidePeople.getJSONObject(j);
										decide.append(obj.get("name").toString()+"("+obj.get("user")+")"+"、");
									}
								}
								if(!nightWorker.isEmpty()) {
									for(int j = 0; j < nightWorker.length(); j++) {
										JSONObject obj = nightWorker.getJSONObject(j);
										worker.add(obj.get("name").toString()+"("+obj.get("user")+")");//工作時間是早上的人
									}
								}
								if(workerChoose.size() != 0) {				
									for(int j = 0; j < workerChoose.size(); j++) {
										advice.append(workerChoose.get(j)+"、");
									}
									for(int k = 0;k < workerChoose.size(); k++) {
										for(int j = 0; j < worker.size(); j++) {
											if(worker.get(j).equals(workerChoose.get(k))) {
												worker.remove(j);
												break;
											}
										}
									}
								}
								for(int j = 0; j < worker.size(); j++) {
									unadvice.append(worker.get(j)+"、");
								}
								
								advice = advice.length() > 0 ? new StringBuilder(advice.substring(0, advice.length() - 1)) : advice;
								unadvice = unadvice.length() > 0 ? new StringBuilder(unadvice.substring(0, unadvice.length() - 1)) : unadvice;
								decide = decide.length() > 0 ? new StringBuilder(decide.substring(0, decide.length() - 1)) : decide;
								advice = advice.toString().equals("") ? new StringBuilder("無") : advice;
								decide = decide.toString().equals("") ? new StringBuilder("無") : decide;
								unadvice = unadvice.toString().equals("") ? new StringBuilder("無") : unadvice;
								
								workerChoose.clear();
								worker.clear();
							%>
						<h6>
							已選人員：<%=decide%>
						</h6>
						<h6>
							建議的人員：<%=advice%>
						</h6>
						<h6>
							不建議的人員：<%=unadvice%>
						</h6>
						<%
							}
							a.closeConnection();
						%>
					</div>
				</div>
				<canvas class="my-4 chartjs-render-monitor" id="myChart" width="866" height="365" style="display: block; width: 866px; height: 365px;"></canvas>
			</main>
		</div>
	</div>
	<script src="JS/calendar.js"></script>
	<script src="JS/event.js"></script>
	<script type="text/javascript">
		let calendarO = new Calendar("days", "calendar-title", "calendar-year");	
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
</body>
<jsp:include page='includes/foot.jsp'></jsp:include>
