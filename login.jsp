<jsp:include page='includes/head.jsp'></jsp:include>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<body>
	<div class="container">
		<h2 class="form-signin-heading text-center" style="color:#ff9933;background:#000;display:block;">超商店員排班系統</h2>
		<h2 class="form-signin-heading text-center" style="color:#ff9933;background:#000;display:block;">登入身分</h2>
		<h3 class="form-signin-heading text-center"><button id="staff" onclick="staffLog()">員工</button><button id="boss" onclick="bossLog()" class="form-signin-heading text-center">老闆</button></h3>
	</div>
	<div class="container" id="loginDiv" hidden>
		<form class="form-signin" role="form" method="POST" >
			<h2 class="form-signin-heading text-center" id= "role" style="color:#ff9933;background:#000;display:block;"></h2>
			<br>
			<label for="inputEmail" class="sr-only">帳號</label> 
			<input type="text" id="account" class="form-control" placeholder="帳號"  autofocus required name="account" >
			<br>
			<label for="inputPassword" class="sr-only">密碼</label> 
			<input type="password" id="password" class="form-control" placeholder="密碼" required name="password" >
			<br>
			<button class="btn btn-lg btn-primary btn-block" id="loginButton" type="button">登入</button>
			<br>
			<div class="text-right margin-top--20" style="color:#ff9933;background:#000;display:inline-block;">還沒有帳號？我要 <a href ="javascript:register()">註冊</a></div>
		</form>
	</div>
	<script>
		var identity = "";
		
		function staffLog() {
			[identity, $("#role")[0].textContent] = ["staff", "員工"];
			$("#loginDiv").attr('hidden',false);
		}
		
		function bossLog() {
			[identity, $("#role")[0].textContent] = ["boss", "老闆"];
			$("#loginDiv").attr('hidden',false);
		}
		
		$("#loginButton").click(function() {
			let [redirect, user] = [false, ""];
			if(identity === "staff") {
				$.ajax({
					url: 'api/store/sAccountDB.jsp',
					type: 'GET',
					async: false,
					data: {
						"sLogIn"  : "true",
						"account"	: $("#account").val(),
						"password"	: $("#password").val(),
					},
				}).done(function (data) {
					if(data.includes("true") === true) {
						[name, user, redirect] = [data.split(";")[1], data.split(";")[2], true];
					}else if(data.includes("pfalse") === true) {
						alert("密碼輸入錯誤");
					}else if(data.includes("afalse") === true) {
						alert("查無此帳號");
					}
				});
			} else {
				$.ajax({
					url: 'api/store/bAccountDB.jsp',
					type: 'GET',
					async: false,
					data: {
						"bLogIn"  : "true",
						"account"	: $("#account").val(),
						"password"	: $("#password").val(),
					},
				}).done(function (data) {
					if(data.includes("true") === true) {
						[name, user, redirect] = [data.split(";")[1], data.split(";")[2], true];
					}else if(data.includes("pfalse") === true) {
						alert("密碼輸入錯誤");
					}else if(data.includes("afalse") === true) {
						alert("查無此帳號");
					}
				});
			}
			
			if(redirect === true) {
				setCookie('identity',identity, 30);
				setCookie('name',name, 30);
				setCookie('user',user, 30);
				$(location).attr('href','http://localhost:8080/storebackup/lobby.jsp')
			}
		})
		
		function register() {
			identity === "staff" ? $(location).attr('href','http://localhost:8080/storebackup/staffRegister.jsp') : $(location).attr('href','http://localhost:8080/storebackup/bossRegister.jsp');
		}

	</script>
	<style>
	body {
	   background-image: url("image/loginStore.jpg");
	   background-size: 100% 100%;
	}
	</style>
</body>
<jsp:include page='includes/foot.jsp'></jsp:include>
