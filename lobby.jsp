<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import ="ascdc.sinica.dhtext.db.DBText"%>
<%@ page import ="java.text.*"%>
<%@ page import ="java.util.*"%>
<html lang="zh-TW">
	<head>
		<meta charset="utf-8">
		<title>超商店員排班系統</title>
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
			<a class="navbar-brand" href="lobby.jsp">超商店員排班系統</a>
			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<h4 id="alertTime" style="text-align: center;color: red;"></h4>
			<h4 id="user" style="position:absolute;right:80px;"></h4>
			<a class="btn btn-outline-primary" href="login.jsp"  style="position:absolute;right:10px;">登出</a>
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
							<a class="prev" id="prev">
								<img src="image/left.png" height="24" width="24" >
							</a>
							<a class="next" id="next">
								<img src="image/right.png" height="24" width="24" >
							</a>
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
		var prev = document.getElementById("prev");
		var next = document.getElementById("next");
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
			if (tmp == 0) {
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
			for(var i=1; i<firstDay; i++){ 
				str += "<li id=></li>"; 
			}
			for(var i=1; i<=totalDay; i++){
				str += "<li id="+my_year+"_"+(my_month+1)+"_"+i+">"+i+"</li>";
			}
			holder.innerHTML = str; 
			ctitle.innerHTML = month_name[my_month]; 
			cyear.innerHTML = my_year; 
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
		prev.onclick = function(e){
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
		}
		$(function() {
			if(getCookie('switchCheck') === 'true'){
				$("#calendarSet").attr('hidden',false);
				$('#switch').prop('checked', true).change();
			}else if(getCookie('switchCheck') === 'false'){
				$("#calendarSet").attr('hidden',true);
				$('#switch').prop('checked', false).change();
			}
			$('#switch').change(function() {
				setCookie('switchCheck',$(this)[0].checked, 30);
			})
			if(getCookie('identity') === "boss"){
				$("#calendar").attr('hidden',true);
				$("#calendarAll").attr('hidden',false);
				$("#calendarSet").attr('hidden',false);
				$('#switch').attr('hidden',false);
				calendarAll();
			}else{
				$("#calendar").attr('hidden',false); 
				$("#calendarAll").attr('hidden',true);
				$("#calendarSet").attr('hidden',true);
				$('#switch').attr('hidden',true);
				calendar();
			}
			$("#limitTime").text("開放時間："+(my_month+1)+"/"+(daysMonth(my_month, my_year)-6)+"～"+(my_month+1)+"/"+(daysMonth(my_month, my_year)-1));
			$("#user").text(getCookie('user'));
			
			
			
			if((my_day < (daysMonth(my_month, my_year)-6) || my_day > (daysMonth(my_month, my_year)-1) )&& getCookie('identity') === "staff"){
				$("#calendarSet").attr('hidden',true);
				$("#alertTime").text("請注意本月排班時間是："+(my_month+1)+"/"+(daysMonth(my_month, my_year)-6)+"～"+(my_month+1)+"/"+(daysMonth(my_month, my_year)-1));
			}else if((daysMonth(my_month, my_year)-6) <= my_day <= (daysMonth(my_month, my_year)-1) && getCookie('identity') === "staff"){
				$("#calendarSet").attr('hidden',false);
			}
			refreshDate();
		  })
		
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
	</style>
</html>