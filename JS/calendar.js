function Calendar(dayID, ctitleID, cyearID) {
	this.dayID = dayID;
	this.ctitleID = ctitleID;
	this.cyearID = cyearID;
	this.year = new Date().getFullYear();
	this.month = new Date().getMonth();
	this.day = new Date().getDate();
};


Calendar.prototype.dayStart = function(month, year) {
	let tmpDate = new Date(year, month, 1);
	return (tmpDate.getDay());
}

Calendar.prototype.daysMonth = function(month, year) {
	let tmp = year % 4,
		month_olympic = [31,29,31,30,31,30,31,31,30,31,30,31],
		month_normal = [31,28,31,30,31,30,31,31,30,31,30,31];
	if (tmp === 0) {
		return (month_olympic[month]);
	} else {
		return (month_normal[month]);
	}
}

Calendar.prototype.refreshDate = function() {
	const holder = document.getElementById(this.dayID),
		  ctitle = document.getElementById(this.ctitleID),
		  cyear = document.getElementById(this.cyearID),
		  month_name = ["January","Febrary","March","April","May","June","July","Auguest","September","October","November","December"];
	let str = "",
		totalDay = this.daysMonth(this.month, this.year), 
		firstDay = this.dayStart(this.month, this.year), 
		myclass;
	
	for(let i= 1 ; i < firstDay; i++) { 
		str += "<li id=></li>"; 
	}
	
	for(let i= 1 ; i <= totalDay; i++) {
		str += "<li id="+this.year+"_"+(this.month+1)+"_"+i+">"+i+"</li>";
	}
	
	holder.innerHTML = str; 
	ctitle.innerHTML = month_name[this.month]; 
	cyear.innerHTML = this.year; 
	$.ajax({
		url: 'api/store/sWork.jsp',
		type: 'GET',
		async: false,
		data: {
			"getWorkTime"		: "true",
			"name"  : getCookie('name'),
			"month"	: this.month,
			"year"	: this.year,
		},
	}).done(function (data) {
		for(let i = 0; i < data.split("、").length-1; i++) {
			$("#"+this.year+"_"+(this.month+1)+"_"+data.split("、")[i])[0].className += "green-small";
		}
	});
}

/*document.getElementById("prev").onclick = function(e) {
	e.preventDefault();
	my_month--;
	if(my_month<0) {
		my_year--;
		my_month = 11;
	}
	refreshDate();
}
document.getElementById("next").onclick = function(e) {
	e.preventDefault();
	my_month++;
	if(my_month>11) {
		my_year++;
		my_month = 0;
	}
	refreshDate();
}*/