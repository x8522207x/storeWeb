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
			<label>第幾章</label> 
			<input type="number" pattern="[0-9.]"  id="part-chapter" placeholder="第幾章" >
			<br>
			<label>第幾節</label> 
			<input type="number" pattern="[0-9.]"  id="part-number" placeholder="第幾節" >
			<br>
			<label>單元名稱</label> 
			<input type="text" id="part-name" placeholder="單元名稱" >
			<br>
			<label>影片網址</label> 
			<input type="text" id="video" placeholder="影片網址" >
			<br>
			<button type="button" id="submit">確定</button>
			<button type="button" id="cancel">取消</button>
		</div>
	</body>
	<script>
		$("#submit").click(function(e){
			if($("#part-number").val() === "" || $("#part-name").val() === ""|| $("#part-chapter").val() === "" || $("#video").val() === "" ){
				alert("有欄位沒填");
			}
			if($("#part-number").val() !== "" && $("#part-chapter").val() !== ""&& $("#part-name").val() !== "" && $("#video").val() !== "" ){
				$.ajax({
					url: 'api/math/videoAction.jsp',
					type: 'POST',
					async: false,
					data: {
						"add"         :   "true",
						"partChapter"  : $("#part-chapter").val(),
						"partNumber"  : $("#part-number").val(),
						"partName"	: $("#part-name").val(),
						"video"	: $("#video").val(),
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