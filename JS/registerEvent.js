const nameInput = document.getElementById('ip-name'),
	  passwordInput = document.getElementById('ip-password'),
	  passwordInput2 = document.getElementById('ip-password-2'),
	  emailInput = document.getElementById('ip-email'),
	  accountInput = document.getElementById('ip-account'),
	  workTime = document.getElementById('workTime');

document.querySelector("#final").addEventListener('click', register);	  
	  
accountInput.onkeyup = function(e) {
	if( accountInput.value.length > 6) {
		document.getElementById('ipa').setAttribute('hidden','hidden');
		document.getElementById('bc').removeAttribute('disabled');
	} else {
		document.getElementById('ipa').removeAttribute('hidden');
		document.getElementById('bc').setAttribute('disabled','disabled');
	}
};

nameInput.onkeyup = function(e) {
	nameInput.value.length > 0 ? document.getElementById('ipn').setAttribute('hidden','hidden') : document.getElementById('ipn').removeAttribute('hidden');
};

passwordInput.onkeyup = function(e) {
	passwordInput.value.length > 7 ? document.getElementById('ip1').setAttribute('hidden','hidden') : document.getElementById('ip1').removeAttribute('hidden');
};

passwordInput2.onkeyup = function (e) {
	passwordInput.value !== passwordInput2.value ? document.getElementById('ip2').removeAttribute('hidden') : document.getElementById('ip2').setAttribute('hidden','hidden');
};

emailInput.onkeyup = function(e) {
	validateEmail(emailInput.value) ? document.getElementById('ipe').setAttribute('hidden','hidden') : document.getElementById('ipe').removeAttribute('hidden');
};

$("#bc").click(function() {
	$.ajax({
		url: 'api/store/sAccountDB.jsp',
		type: 'GET',
		data: {
			"check"  : "true",
			"account"	: accountInput.value,
		},
	}).done(function (data) {
		if(data.includes("true") === true) {
			alert("恭喜!這個帳號可以使用");
			document.getElementById('final').removeAttribute('disabled');
		}else if(data.includes("false") === true) {
			alert("這個帳號已經有人註冊");
		}
	});
}); 

function validateEmail(email) {
	let re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
	return re.test(String(email).toLowerCase());
}

function register() {
	if( nameInput.value.length === 0 || passwordInput.value.length === 0 || passwordInput2.value.length === 0 || emailInput.value.length === 0 || accountInput.value.length === 0) {
		alert("還有欄位未填");
	}else if( nameInput.value.length > 0 && passwordInput.value.length > 7 && passwordInput2.value.length > 7 && emailInput.value.length > 0 && accountInput.value.length>6) {
		$.ajax({
			url: 'api/store/sAccountDB.jsp',
			type: 'POST',
			async: false,
			data: {
				"register"  : "true",
				"account"	: accountInput.value,
				"password"	: passwordInput.value,
				"email"	: emailInput.value,
				"name"	: nameInput.value,
				"workTime" : workTime.value
			},
		}).done(function() {
			alert("恭喜註冊成功!即將跳回登入頁");
			window.location = "http://localhost:8080/storebackup/login.jsp";
		});
	}
}