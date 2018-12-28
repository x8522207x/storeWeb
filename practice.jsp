<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="ascdc.sinica.dhtext.db.DBText"%>
<%@ page import ="java.util.ArrayList"%>
<html>
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
	<body id ="practice">
	<h4>次方請用^數字表示 ex:(x^2 = x平方) 分數請用/表示 ex:(x/2 = 二分之x)</h4>
	</body>
	<script>
	
	var question = getCookie('question').substring(1,getCookie('question').length-1).split(",,,");
	var answer = getCookie('answer').substring(1,getCookie('answer').length-1).split(",,,");

	var tbody = document.getElementById('practice');
	for(var i = 0 ; i< question.length ; i++){
		var div = document.createElement('div');
		var h4 = document.createElement('h4');
		var h4_2 = document.createElement('h4');
		var input = document.createElement('input');
		var button = document.createElement('button');
		var deleteButton = document.createElement('button');
		var editButton = document.createElement('button');
		h4.append(parseInt(i)+1+": "+ question[i]);
		h4_2.append("答案");
		h4_2.appendChild(input);
		input.setAttribute('type','textarea');
		input.setAttribute('id',i);
		button.setAttribute('class','btn btn-sm btn-outline-secondary');
		deleteButton.setAttribute('class','btn btn-sm btn-outline-secondary');
		editButton.setAttribute('class','btn btn-sm btn-outline-secondary');
		button.setAttribute('name','submit');
		deleteButton.setAttribute('name','delete');
		deleteButton.setAttribute('id','delete'+i);
		editButton.setAttribute('name','edit');
		editButton.setAttribute('id','edit'+i);
		deleteButton.setAttribute('hidden','hidden');
		editButton.setAttribute('hidden','hidden');
		button.setAttribute('id','button'+i);
		div.appendChild(h4);
		div.appendChild(h4_2);
		div.appendChild(input);
		div.appendChild(button);
		div.appendChild(deleteButton);
		div.appendChild(editButton);
		tbody.appendChild(div);
		$("button[name='submit']")[i].textContent ="送出";
		$("button[name='delete']")[i].textContent ="刪除";
		$("button[name='edit']")[i].textContent ="編輯";
		if(getCookie('identity') == "teacher"){
			$(deleteButton).attr('hidden',false);
			$(editButton).attr('hidden',false);
		}
	}
	$("button[name='submit']").click( function(){
		var userAnswer = $("#"+this.id.split("button")[1])[0].value;
		if(userAnswer === answer[this.id.split("button")[1]]){
			alert("答對囉:)");
		}else{
			alert("答錯囉:(");
		}
		
	})
	$("button[name='delete']").click( function(){
		$.ajax({
			url: 'api/math/practiceAction.jsp',
			type: 'POST',
			async: false,
			data: {
				"deleteUpdate"			: "true",
				"partChapter"			:getCookie('partChapter'),
				"partNumber"			:getCookie('partNumber'),
			},
		}).done(function (){
			window.opener.location.reload();
			self.close();
		});
	});
	$("button[name='edit']").click( function(){
		id = this.id.split("edit")[1];		
		setCookie('question',question[id]);
		setCookie('answer',answer[id]);
		setCookie('partChapter',getCookie('partChapter'));
		setCookie('partNumber',getCookie('partNumber'));
		window.open('practiceEdit.jsp','practiceEdit','width=500,height=500 ');
	});
	function setCookie(cname, cvalue, exdays) {
		var d = new Date();
		d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
		var expires = "expires=" + d.toUTCString();
		document.cookie = cname + "=" + cvalue + ";path=" + location.host + "; " + expires;
	}
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
	</script>
</html>
