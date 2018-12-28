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
			<input type="number" pattern="[0-9.]"  id="part-chapter" placeholder="第幾章" disabled>
			<br>
			<label>第幾節</label> 
			<input type="number" pattern="[0-9.]"  id="part-number" placeholder="第幾節" disabled>
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
		$("#part-chapter")[0].value = getCookie('partChapter');
		$("#part-number")[0].value = getCookie('partNumber');
		$("#part-name")[0].value = getCookie('partName');
		$("#video")[0].value = getCookie('video');
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
		$("#submit").click(function(){			
			$.ajax({
				url: 'api/math/videoAction.jsp',
				type: 'POST',
				async: false,
				data: {
					"editUpdate"	: "true",
					"partChapter"   : $("#part-chapter")[0].value,
					"partNumber"	: $("#part-number")[0].value,
					"partName"	: $("#part-name")[0].value,
					"video"	: $("#video")[0].value,
				},
			}).done(function (data){
				window.opener.location.reload();
				self.close();
			});
		});
		$("#cancel").click(function(){			
			self.close();
		});
	</script>
</html>