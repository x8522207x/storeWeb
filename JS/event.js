const nameInput = document.getElementById('ip-name'),
	  passwordInput = document.getElementById('ip-password'),
	  passwordInput2 = document.getElementById('ip-password-2'),
	  emailInput = document.getElementById('ip-email'),
	  accountInput = document.getElementById('ip-account'),
	  workTime = document.getElementById('workTime');

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

$("#arrangeCheck").click(function() {
	if($(this).prop("checked")) {//如果全選按鈕有被選擇的話（被選擇是true）
		$("input[id*='day']").each(function() {
			$(this).prop("checked",true);//把所有的核取方框的property都變成勾選
		})
	} else {
		$("input[id*='day']").each(function() {
			$(this).prop("checked",false);//把所有的核方框的property都取消勾選
		})
	}
})

$("#arrangeEdit").click(function() {
	if($(this).prop("checked")) {//如果全選按鈕有被選擇的話（被選擇是true）
		$("input[id*='edit']").each(function() {
			$(this).prop("checked",true);//把所有的核取方框的property都變成勾選
		})
	} else {
		$("input[id*='edit']").each(function() {
			$(this).prop("checked",false);//把所有的核方框的property都取消勾選
		})
	}
})

$("#arrangeCancel").click(function() {
	$("input[id*='day']").each(function() {
		$(this).prop("checked",false);//把所有的核取方框的property都變成勾選
	})
	$("#arrangeCheck").prop("checked",false);
})

$("#cancelEdit").click(function() {
	$("input[id*='edit']").each(function() {
		$(this).prop("checked",false);//把所有的核取方框的property都變成勾選
	})
	$("#arrangeEdit").prop("checked",false);
})

$("#logOut").click(function() {
	deleteCookie('identity');
	deleteCookie('name');
	deleteCookie('user');
	$(location).attr('href','http://localhost:8080/storebackup/login.jsp')
})

document.querySelector('#submit').addEventListener('click', arrangeSubmit);
document.querySelector('#delete').addEventListener('click', arrangeDelete);
document.querySelector("#final").addEventListener('click', register);
document.getElementById('bossArrange').addEventListener('click', bossArrange);
document.getElementById('calendar').addEventListener('click', calendar);
document.getElementById('calendarAll').addEventListener('click', calendarAll);
document.getElementById('calendarSet').addEventListener('click', calendarSet);

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

function bossArrange() {
	let noonAir = "",
		nightAir = "";
		
	for(let i = 0 ; i < $("select[id*='workTimeNoon']").length; i++) {
		if(($("select[id*='workTimeNoon']")[i].value === "" && $("select[id*='twoWorkTimeNoon']")[i].value !== "") || ($("select[id*='workTimeNoon']")[i].value !== "" && $("select[id*='twoWorkTimeNoon']")[i].value === "") || ($("select[id*='workTimeNoon']")[i].value === $("select[id*='twoWorkTimeNoon']")[i].value && $("select[id*='twoWorkTimeNoon']")[i].value !== "")) {
			noonAir += (i+1)+"、";
		}
		if(($("select[id*='workTimeNight']")[i].value === "" && $("select[id*='twoWorkTimeNight']")[i].value !== "") || ($("select[id*='workTimeNight']")[i].value !== "" && $("select[id*='twoWorkTimeNight']")[i].value === "") || ($("select[id*='workTimeNight']")[i].value === $("select[id*='twoWorkTimeNight']")[i].value && $("select[id*='twoWorkTimeNight']")[i].value !== "")) {
			nightAir += (i+1)+"、";
		}
	}
	
	if(noonAir.length > 0 || nightAir.length > 0) {
		noonAir = noonAir.substring(0, noonAir.length-1);
		nightAir = nightAir.substring(0, nightAir.length-1);
		alert("午班："+noonAir+" 以及 晚班："+nightAir+" 有少派人 或者 重複指派人");
	} else {
		let name = [];
		
		for(let i = 0 ; i < $("select[id*='workTimeMorning']").length; i++) {
			if($("select[id*='workTimeMorning']")[i].value === "") {
				name.push(new String("無"));
			} else {
				const value = $("select[id*='workTimeMorning']")[i].value;
				name.push(value);
			}
		}
		
		$.ajax({
			url: 'api/store/sWork.jsp',
			type: 'POST',
			async: false,
			data: {
				"decide": "true",
				"name"  : name,
				"year"	: calendarO.year,
				"month"	: calendarO.month,
				"orderWork"	: "morning",
			},
		});
		
		name = [];
		
		for(let i = 0 ; i < $("select[id*='workTimeNoon']").length; i++) {
			if($("select[id*='twoWorkTimeNoon']")[i].value === "" || $("select[id*='workTimeNoon']")[i].value === "") {
				name.push(new String("無"));
			} else {
				name.push($("select[id*='workTimeNoon']")[i].value+$("select[id*='twoWorkTimeNoon']")[i].value);
			}
		}
		
		$.ajax({
			url: 'api/store/sWork.jsp',
			type: 'POST',
			async: false,
			data: {
				"decide": "true",
				"name"  : name,
				"year"	: calendarO.year,
				"month"	: calendarO.month,
				"orderWork"	: "noon",
			},
		});
		
		name = [];
		
		for(let i = 0 ; i < $("select[id*='workTimeNight']").length; i++) {
			if($("select[id*='twoWorkTimeNight']")[i].value === "" || $("select[id*='workTimeNight']")[i].value === "") {
				name.push(new String("無"));
			} else {
				name.push($("select[id*='workTimeNight']")[i].value+$("select[id*='twoWorkTimeNight']")[i].value);
			}
		}

		$.ajax({
			url: 'api/store/sWork.jsp',
			type: 'POST',
			async: false,
			data: {
				"decide": "true",
				"name"  : name,
				"year"	: calendarO.year,
				"month"	: calendarO.month,
				"orderWork"	: "night",
			},
		}).done(function() {
			window.location = "http://localhost:8080/storebackup/lobby.jsp";
		});
	}
}

function validateEmail(email) {
	let re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
	return re.test(String(email).toLowerCase());
}

function arrangeSubmit() {
	var day = [];
	
	for(let i in $("input[id*='day']")) {
		if($("input[id*='day']")[i] && $("input[id*='day']")[i].checked === true) {
			day.push(Number(i)+1);
		}
	}
	
	for(let i in $("input[id*='edit']")) {
		if($("input[id*='edit']")[i]) {
			for(let j = 0; j < day; j++) {
				if($("input[id*='edit']")[i].nextSibling && day[j] === Number($("input[id*='edit']")[i].nextSibling.data.trim())) {
					day.splice(j, 1);
					break;
				}
			}
		}
	}
	
	$.ajax({
		url: 'api/store/sWork.jsp',
		type: 'POST',
		async: false,
		data: {
			"arrange": "true",
			"name"  : getCookie('name'),
			"user"	: getCookie('user'),
			"day"	: day,
			"month"	: calendarO.month,
			"year"	: calendarO.year,
		},
	}).done(function() {
		window.location = "http://localhost:8080/storebackup/lobby.jsp";
	});
}

function arrangeDelete() {
	var day = [];
	
	for(let i in $("input[id*='edit']")) {
		if($("input[id*='edit']")[i] && $("input[id*='edit']")[i].checked === true) {
			day.push($("input[id*='edit']")[i].nextSibling.data.trim());
		}
	}
	
	$.ajax({
		url: 'api/store/sWork.jsp?'+'edit=true&user='+getCookie('user')+'&day='+JSON.stringify(day),
		type: 'DELETE',
		async: false,
	}).done(function() {
		window.location = "http://localhost:8080/storebackup/lobby.jsp";
	});
}

function calendar() {
	$("#main1").attr('hidden',false);
	$("#main2").attr('hidden',true);
	$("#main3").attr('hidden',true);
}

function calendarAll() {
	$("#main1").attr('hidden',true);
	$("#main2").attr('hidden',false);
	$("#main3").attr('hidden',true);
}

function calendarSet() {
	$("#main1").attr('hidden',true);
	$("#main2").attr('hidden',true);
	$("#main3").attr('hidden',false);
}

$(function() {
	if(getCookie('identity') === "boss") {
		$("#calendar").attr('hidden',true);
		$("#calendarAll").attr('hidden',false);
		$("#calendarSet").attr('hidden',false);
		$("#div3").attr('hidden', true);
		$("#div4").attr('hidden', true);
		$("#div5").attr('hidden', false);
		$("#div6").attr('hidden', false);
		$("#limitTime").attr('hidden', true);
		$("#bossArrange").attr('hidden', false);
		$.ajax({
			url: 'api/store/sWork.jsp',
			type: 'GET',
			async: false,
			data: {
				"allTable": "true",
				"year"	: calendarO.year,
				"month"	: calendarO.month,
			},
		}).done(function(data) {
			let morningT = "";
			let noonT = "";
			let nightT = "";
			for(let i in JSON.parse(data)) {
				if(i.split("_")[0].includes("morning")) {
					$("#morningTable")[0].innerHTML += i.split("_")[1]+"："+JSON.parse(data)[i]+"<br>";
				}else if(i.split("_")[0].includes("noon")) {
					$("#noonTable")[0].innerHTML += i.split("_")[1]+"："+JSON.parse(data)[i]+"<br>";
				}else if(i.split("_")[0].includes("night")) {
					$("#nightTable")[0].innerHTML += i.split("_")[1]+"："+JSON.parse(data)[i]+"<br>";
				}
			}
		});
	} else {
		$("#calendar").attr('hidden',false); 
		$("#calendarAll").attr('hidden',true);
		$("#calendarSet").attr('hidden',true);
		$("#div3").attr('hidden', false);
		$("#div4").attr('hidden', false);
		$("#div5").attr('hidden', true);
		$("#div6").attr('hidden', true);
	}
	$("#limitTime").text("開放時間："+(calendarO.month+1)+"/"+(calendarO.daysMonth(calendarO.month, calendarO.year)-6)+"～"+(calendarO.month+1)+"/"+(calendarO.daysMonth(calendarO.month, calendarO.year)-1));
	$("#name").text(getCookie('name'));

	if((calendarO.day < (calendarO.daysMonth(calendarO.month, calendarO.year)-25) || calendarO.day > (calendarO.daysMonth(calendarO.month, calendarO.year)-1) )&& getCookie('identity') === "staff") {
		$("#calendarSet").attr('hidden',true);
		$("#alertTime").text("請注意本月排班時間是："+(calendarO.month+1)+"/"+(calendarO.daysMonth(calendarO.month, calendarO.year)-6)+"～"+(calendarO.month+1)+"/"+(calendarO.daysMonth(calendarO.month, calendarO.year)-1));
	}else if((calendarO.daysMonth(calendarO.month, calendarO.year)-6) <= calendarO.day <= (calendarO.daysMonth(calendarO.month, calendarO.year)-1) && getCookie('identity') === "staff") {
		$("#calendarSet").attr('hidden',false);
	}
	calendarO.refreshDate();
});