<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import ="ascdc.sinica.dhtext.db.DBText"%>
<%@ page import ="java.util.ArrayList"%>
<%@ page import ="java.util.Set"%>
<%@ page import ="java.util.TreeSet"%>
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
				<main role="main" id="main1" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4">
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
				str += "<li></li>"; 
			}
			for(var i=1; i<=totalDay; i++){
				str += "<li>"+i+"</li>";
			}
			holder.innerHTML = str; 
			ctitle.innerHTML = month_name[my_month]; 
			cyear.innerHTML = my_year; 
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
				$('#switch').prop('checked', true).change()
			}else if(getCookie('switchCheck') === 'false'){
				$("#calendarSet").attr('hidden',true);
				$('#switch').prop('checked', false).change()
			}
			$('#switch').change(function() {
				setCookie('switchCheck',$(this)[0].checked, 30);
			})
			if(getCookie('identity') === "boss"){
				$("#calendar").attr('hidden',true);
				$("#calendarAll").attr('hidden',false);
				$("#calendarSet").attr('hidden',false);
			}else{
				$("#calendar").attr('hidden',false);
				$("#calendarAll").attr('hidden',true);
				$("#calendarSet").attr('hidden',true);
			}
			$("#user").text(getCookie('user'));
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