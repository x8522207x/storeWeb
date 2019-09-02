<jsp:include page='includes/head.jsp'></jsp:include>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<body>
	<form role="form" class="form-signin">
		<div class="container">
			<h1 class="text-center"><span class="badge badge-primary">超商店員排班系統</span></h1>
			<h4 class="text-center"><button id="staff" class="btn btn-info" onclick="staffLog()">員工</button><button id="boss" class="btn btn-info" onclick="bossLog()" class="form-signin-heading text-center">老闆</button></h4>
			<h4 class="form-signin-heading text-center" id= "role" style="display:block;"><span class="badge badge-secondary"></span></h4>
			<br>
			<h6 class="text-center"><input type="text" id="account" placeholder="帳號" class="form-signin-heading" autofocus required></h6>
			<br>
			<h6 class="text-center"><input type="password" id="password" placeholder="密碼" class="form-signin-heading" required></h6>
			<br>
			<h6 class="text-center"><button class="btn btn-secondary form-signin-heading" id="loginButton" type="button">登入</button></h6>
			<br>
			<h6 class="text-center"><div style="display:inline-block;color:red;background-color:black;">還沒有帳號？我要 <a href ="javascript:register()">註冊</a></div></h6>
		</div>
	</form>
	<script>
		var identity = "";
		
		function staffLog() {
			[identity, $("#role")[0].textContent] = ["staff", "員工"];
			setCookie('identity',identity, 30);
		}
		
		function bossLog() {
			[identity, $("#role")[0].textContent] = ["boss", "老闆"];
			setCookie('identity',identity, 30);
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
	.container {
		position: fixed;
		top: 0;
		left: 10%;
	}
	</style>
</body>
<jsp:include page='includes/foot.jsp'></jsp:include>
