<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<html lang="zh-TW">
	<jsp:include page='includes/head.jsp'></jsp:include>
	<body>
	  <div class="container">
		<form class="register-form" role="form"  method="POST" id="form1">
		  <div class="rg-back-login"><a href="login.jsp">回登入頁</a></div>
		  <input type="hidden" name="op" value="add">
		  <h2 class="form-signin-heading text-center">註冊</h2>
		  <label for="inputName">姓名</label> 
		  <input type="text" id="ip-name" name="name" class="form-control" placeholder="">
		  <span class="danger" id="ipn" style="color:red;">請輸入姓名</span>
		  <br>
		  <label for="inputStudentNumber" class="margin-top-20">帳號</label>
		  <input type="text" id="ip-account" name="account" class="form-control" placeholder="">
		  <span class="danger" id="ipa" style="color:red;">請輸入帳號(7個字元以上)</span>
		  <button type="button" id="bc" disabled>檢查重複</button>
		  <br>
		  <label for="inputPassword">密碼</label> 
		  <input type="password" id="ip-password" name="password" class="form-control" placeholder="">
		  <span class="danger" id="ip1" style="color:red;">請輸入至少 8 個字元以上</span>
		  <br>
		  <label for="inputPassword2">再次輸入密碼</label> 
		  <input type="password" id="ip-password-2" class="form-control" name="password2" placeholder="">
		  <span class="danger" id="ip2" style="color:red;" >兩次密碼輸入不一致</span>
		  <br>
		  <label for="inputEmail">E-Mail</label> 
		  <input type="text" id="ip-email" name="email" class="form-control" placeholder="">
		  <span class="danger" id="ipe" style="color:red;">請輸入有效的 Email</span>
		  <br>
		  <label for="inputDepart">工作時間</label> 
		  <br>
		  <select id="workTime">
			  <option value="morning">12:00 a.m. ~8:00 a.m.</option>
			  <option value="noon">8:00 a.m. ~4:00 p.m.</option>
			  <option value="night">4:00 p.m. ~12:00 a.m.</option>
		  </select>
		  <button class="btn btn-lg btn-primary btn-block margin-top-20" id="final"  type="button" onclick="register()"  disabled>註冊帳號</button>
		</form>
	  </div>
	</body>
</html>
<script type="text/javascript">
	var nameInput = document.getElementById('ip-name');
	var passwordInput = document.getElementById('ip-password');
	var passwordInput2 = document.getElementById('ip-password-2');
	var emailInput = document.getElementById('ip-email');
	var accountInput = document.getElementById('ip-account');
	var workTime = document.getElementById('workTime');
	accountInput.onkeyup = function(e){
		if( accountInput.value.length > 6){
			document.getElementById('ipa').setAttribute('hidden','hidden');
			document.getElementById('bc').removeAttribute('disabled');
		}else{
			document.getElementById('ipa').removeAttribute('hidden');
			document.getElementById('bc').setAttribute('disabled','disabled');
		}
	}
	nameInput.onkeyup = function(e){
		if( nameInput.value.length > 0){
			document.getElementById('ipn').setAttribute('hidden','hidden');
		}else{
			document.getElementById('ipn').removeAttribute('hidden');
		}
	}
	passwordInput.onkeyup = function(e){
		if(passwordInput.value.length > 7){
			document.getElementById('ip1').setAttribute('hidden','hidden');
		}else{
			document.getElementById('ip1').removeAttribute('hidden');
		}
	}
	passwordInput2.onkeyup = function (e) {
		if( passwordInput.value !== passwordInput2.value){
			document.getElementById('ip2').removeAttribute('hidden');
		}else if(passwordInput.value === passwordInput2.value){
			document.getElementById('ip2').setAttribute('hidden','hidden');
		}
	};
	emailInput.onkeyup = function(e){
		if( validateEmail(emailInput.value)){
			document.getElementById('ipe').setAttribute('hidden','hidden');
		}else{
			document.getElementById('ipe').removeAttribute('hidden');
		}
	}

	function validateEmail(email) {
		var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
		return re.test(String(email).toLowerCase());
	}
	
	function register(){
		if( nameInput.value.length === 0 || passwordInput.value.length === 0 || passwordInput2.value.length === 0 || emailInput.value.length === 0 || accountInput.value.length === 0){
			alert("還有欄位未填");
		}else if( nameInput.value.length > 0 && passwordInput.value.length > 7 && passwordInput2.value.length > 7 && emailInput.value.length > 0 && accountInput.value.length>6){
			var register = "true";
			$.ajax({
				url: 'api/store/sAccountDB.jsp',
				type: 'POST',
				async: false,
				data: {
					"register"  : register,
					"account"	: accountInput.value,
					"password"	: passwordInput.value,
					"email"	: emailInput.value,
					"name"	: nameInput.value,
					"workTime" : workTime.value
				},
			});
			alert("恭喜註冊成功!即將跳回登入頁");
			window.location = "http://localhost:8080/store/login.jsp";
		}
	}
	
	$("#bc").click(function(){
		$.ajax({
				url: 'api/store/sAccountDB.jsp',
				type: 'POST',
				data: {
					"check"  : "true",
					"account"	: accountInput.value,
				},
		}).done(function (data){
				if(data.includes("true") === true){
					alert("恭喜!這個帳號可以使用");
					document.getElementById('final').removeAttribute('disabled');
				}else if(data.includes("false") === true){
					alert("這個帳號已經有人註冊");
				}
		});
    }); 


</script>
<style>
body {
   background-color: #cccccc;
}
</style>