<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page='includes/head.jsp'></jsp:include>
<body>
	<div class="container">
		<form class="register-form" role="form" method="POST" id="form1">
			<div class="rg-back-login"><a href="login.jsp">回登入頁</a></div>
			<input type="hidden" name="op" value="add">
			<h2 class="form-signin-heading text-center">註冊</h2>
			<label for="inputName">姓名</label> 
			<input type="text" id="ip-name" name="name" class="form-control" placeholder="">
			<span class="danger" id="ipn" style="color:red;">請輸入姓名</span>
			<br>
			<label for="inputStaffNumber" class="margin-top-20">帳號</label>
			<input type="text" id="ip-account" name="account" class="form-control" placeholder="">
			<button type="button" id="bc" disabled>檢查重複</button>
			<span class="danger" id="ipa" style="color:red;">請輸入帳號(7個字元以上)</span>
			<br>
			<label for="inputPassword">密碼</label> 
			<input type="password" id="ip-password" name="password" class="form-control" placeholder="">
			<span class="danger" id="ip1" style="color:red;">請輸入至少 8 個字元以上</span>
			<br>
			<label for="inputPassword2">再次輸入密碼</label> 
			<input type="password" id="ip-password-2" class="form-control" name="password2" placeholder="">
			<span class="danger" id="ip2" style="color:red;">兩次密碼輸入不一致</span>
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
			<button class="btn btn-lg btn-primary btn-block margin-top-20" id="final" type="button" disabled>註冊帳號</button>
		</form>
	</div>
	<script src="JS/event.js"></script> 
	<style>
	body {
	   background-color: #cccccc;
	}
	</style>  
</body>
<jsp:include page='includes/foot.jsp'></jsp:include>
