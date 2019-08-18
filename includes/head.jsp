<html lang="zh-TW">
	<head>
	<%@ page pageEncoding="UTF-8"%>
		<meta charset="UTF-8">
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
		<script src="https://cdn.jsdelivr.net/npm/vue"></script>
		<script>
		function getCookie(cname) {
			var name = cname + "=";
			var ca = document.cookie.split(';');
			for (var i in ca) {
				var c = ca[i];
				while (c.charAt(0) == ' ') c = c.substring(1);
				if (c.indexOf(name) == 0)
					return unescape(c.substring(name.length, c.length));
			}
			return "";
		}
		
		function setCookie(cname, cvalue, exdays) {
			var d = new Date();
			d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
			var expires = "expires=" + d.toUTCString();
			document.cookie = cname + "=" + escape(cvalue) + ";path=" + location.host + "; " + expires;
		}
		
		function deleteCookie( name ) {
			document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
		}
		</script>
	</head>
