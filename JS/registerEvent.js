const [nameInput, passwordInput, passwordInput2, emailInput, accountInput, workTime] = document.getElementById('ip-name'), document.getElementById('ip-password'), document.getElementById('ip-password-2'), document.getElementById('ip-email'), document.getElementById('ip-account'), document.getElementById('workTime')];

document.querySelector("#final").addEventListener('click', register);	  
	  
accountInput.onkeyup = e => {
	if( accountInput.value.length > 6) {
		document.getElementById('ipa').setAttribute('hidden','hidden');
		document.getElementById('bc').removeAttribute('disabled');
	} else {
		document.getElementById('ipa').removeAttribute('hidden');
		document.getElementById('bc').setAttribute('disabled','disabled');
	}
};

nameInput.onkeyup = e => nameInput.value.length > 0 ? document.getElementById('ipn').setAttribute('hidden','hidden') : document.getElementById('ipn').removeAttribute('hidden');


passwordInput.onkeyup = e => passwordInput.value.length > 7 ? document.getElementById('ip1').setAttribute('hidden','hidden') : document.getElementById('ip1').removeAttribute('hidden');


passwordInput2.onkeyup = e => passwordInput.value !== passwordInput2.value ? document.getElementById('ip2').removeAttribute('hidden') : document.getElementById('ip2').setAttribute('hidden','hidden');


emailInput.onkeyup = e => validateEmail(emailInput.value) ? document.getElementById('ipe').setAttribute('hidden','hidden') : document.getElementById('ipe').removeAttribute('hidden');

$("#bc").click(() => {
	$.ajax({
		url: 'api/store/sAccountDB.jsp',
		type: 'GET',
		data: {
			"check"  : "true",
			"account"	: accountInput.value,
		},
	}).done(data => {
		if(data.includes("true")) {
			alert("恭喜!這個帳號可以使用");
			document.getElementById('final').removeAttribute('disabled');
		}else if(data.includes("false")) {
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
		}).done(() => {
			alert("恭喜註冊成功!即將跳回登入頁");
			window.location = "http://localhost:8080/storebackup/login.jsp";
		});
	}
}