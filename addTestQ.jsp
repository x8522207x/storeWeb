<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<html lang="zh-TW">
	<head>
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
		<div class="container">
			<br>
			<label>題目</label> 
			<input type="text" id="question" placeholder="題目">
			<br>
			<label>答案</label> 
			<input type="text" id="answer" placeholder="答案">
			<br>
			<label>分數</label> 
			<input type="text" id="grade" placeholder="分數">
			<br>
			<button type="button" id="submit">確定</button>
			<button type="button" id="cancel">取消</button>
		</div>
	</body>
	<script>
		$("#submit").click(function(e){
			if( $("#question").val() === "" || $("#answer").val() === "" || $("#grade").val() === "" ){
				alert("有欄位沒填");
			}
			if($("#question").val() !== "" && $("#answer").val() !== ""&& $("#grade").val() !== "" ){
				$.ajax({
					url: 'api/math/testAction.jsp',
					type: 'POST',
					async: false,
					data: {
						"add"		: "true",
						"question"	: $("#question").val(),
						"answer"	: $("#answer").val(),
						"grade"	: $("#grade").val(),
					},
				}).done(function (){
					e.preventDefault();
					window.opener.location.reload();
					self.close();
				});
			}
		});
		$("#cancel").click(function(){
			self.close();
		});
	</script>
</html>