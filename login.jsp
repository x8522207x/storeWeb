<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<html lang="zh-TW">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="">
	<meta name="author" content="超商店員排班系統">
	<title>超商店員排班系統</title>
	<link rel="stylesheet" href="css/fontawesome/css/font-awesome.min.css">
	<link rel="stylesheet" href="assets/css/style.css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
	<script src="https://code.jquery.com/jquery-3.3.1.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" ></script>
</head>
<body>
  <div class="container">
    <h2 class="form-signin-heading text-center" style="color:#ff9933;background:#000;display:block;">超商店員排班系統</h2>
	<h2 class="form-signin-heading text-center" style="color:#ff9933;background:#000;display:block;">登入身分</h2>
	<h3 class="form-signin-heading text-center"><button id="staff"  onclick="studentLog()" >員工</button><button id="boss" onclick="teacherLog()" class="form-signin-heading text-center">老闆</button></h3>
  </div>
  <div class="container" id="studentLogin" hidden>
    <form class="form-signin" role="form" method="POST" >
	  <h2 class="form-signin-heading text-center" style="color:#ff9933;background:#000;display:block;">員工</h2>
	  <br>
	  <label for="inputEmail" class="sr-only">帳號</label> 
	  <input type="text" id="staff-account" class="form-control" placeholder="帳號"  autofocus required name="account" >
	  <br>
	  <label for="inputPassword" class="sr-only">密碼</label> 
	  <input type="password" id="staff-password" class="form-control" placeholder="密碼" required name="password" >
	  <br>
	  <button class="btn btn-lg btn-primary btn-block" id="sLogin" type="button">登入</button>
	  <br>
	  <div class="text-right margin-top--20" style="color:#ff9933;background:#000;display:inline-block;">還沒有帳號？我要 <a href="staffRegister.jsp">註冊</a></div>
	</form>
  </div>
  <div class="container" id="teacherLogin" hidden>
    <form class="form-signin" role="form" method="POST">
	  <h2 class="form-signin-heading text-center" style="color:#ff9933;background:#000;display:block;">老闆</h2>
	  <br>
	  <label for="inputEmail" class="sr-only">帳號</label> 
	  <input type="text" id="boss-account" class="form-control" placeholder="帳號"  autofocus required name="account" >
	  <br>
	  <label for="inputPassword" class="sr-only">密碼</label> 
	  <input type="password" id="boss-password" class="form-control" placeholder="密碼" required name="password" >
	  <br>
	  <button class="btn btn-lg btn-primary btn-block" id="bLogin" type="button">登入</button>
	  <br>
	  <div class="text-right margin-top--20" style="color:#ff9933;background:#000;display:inline-block;">還沒有帳號？我要 <a href="bossRegister.jsp">註冊</a></div>
	</form>
  </div>
</body>
</html>
<script>
	function studentLog(){
		$("#studentLogin").attr('hidden',false);
		$("#teacherLogin").attr('hidden',true);
	}
	function teacherLog(){
		$("#teacherLogin").attr('hidden',false);
		$("#studentLogin").attr('hidden',true);
	}
	$("#sLogin").click(function(){
		var redirect = false;
		var user = "";
		$.ajax({
			url: 'api/store/sAccountDB.jsp',
			type: 'POST',
			async: false,
			data: {
				"sLogIn"  : "true",
				"account"	: $("#staff-account").val(),
				"password"	: $("#staff-password").val(),
			},
		}).done(function (data){
			if(data.includes("true") === true){
				user = data.split(";")[1];
				redirect = true;
			}else if(data.includes("pfalse") === true){
				alert("密碼輸入錯誤");
			}else if(data.includes("afalse") === true){
				alert("查無此帳號");
			}
		});
		if(redirect === true){
			setCookie('identity','staff', 30);
			setCookie('user',user, 30);
			$(location).attr('href','http://localhost:8080/store/lobby.jsp')
		}
	})
	$("#bLogin").click(function(){
		var redirect = false;
		var user = "";
		$.ajax({
			url: 'api/store/bAccountDB.jsp',
			type: 'POST',
			async: false,
			data: {
				"bLogIn"  : "true",
				"account"	: $("#boss-account").val(),
				"password"	: $("#boss-password").val(),
			},
		}).done(function (data){
			if(data.includes("true") === true){
				user = data.split(";")[1];
				redirect = true;
			}else if(data.includes("pfalse") === true){
				alert("密碼輸入錯誤");
			}else if(data.includes("afalse") === true){
				alert("查無此帳號");
			}
		});
		if(redirect === true){	
			setCookie('identity','boss', 30);
			setCookie('user',user, 30);
			$(location).attr('href','http://localhost:8080/store/lobby.jsp')
		}
	})
	function setCookie(cname, cvalue, exdays) {
		var d = new Date();
		d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
		var expires = "expires=" + d.toUTCString();
		document.cookie = cname + "=" + cvalue + ";path=" + location.host + "; " + expires;
	}

</script>
<style>
body {
   background-image: url("image/loginStore.jpg");
   background-size: 100% 100%;
}
</style>