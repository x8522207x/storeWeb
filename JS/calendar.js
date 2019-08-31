class Calendar {
  constructor(dayID, ctitleID, cyearID) {
    [this.dayID, this.ctitleID, this.cyearID, this.year, this.month, this.day] = [dayID, ctitleID, cyearID, new Date().getFullYear(), new Date().getMonth(), new Date().getDate()];
  }

  dayStart(month, year) {
    let tmpDate = new Date(year, month, 1);
	
	return tmpDate.getDay();
  }

  daysMonth(month, year) {
    let [tmp, month_olympic, month_normal] = [year % 4, [31,29,31,30,31,30,31,31,30,31,30,31], [31,28,31,30,31,30,31,31,30,31,30,31]];
	
	return tmp === 0 ? month_olympic[month] : month_normal[month];
  }

  refreshDate() {
    const [holder, ctitle, cyear, month_name] = [document.getElementById(this.dayID), document.getElementById(this.ctitleID), document.getElementById(this.cyearID), ["January","Febrary","March","April","May","June","July","Auguest","September","October","November","December"]];

    let [str, totalDay, firstDay] = ["", this.daysMonth(this.month, this.year), this.dayStart(this.month, this.year)];

    for(let i = 1 ; i < firstDay; i++) { 
      str += `<li id=></li>`; 
    }

    for(let i = 1 ; i <= totalDay; i++) {
      str += `<li id=${this.year}_${this.month+1}_${i}>${i}</li>`;
    }

    [holder.innerHTML, ctitle.innerHTML, cyear.innerHTML] = [str, month_name[this.month], this.year]; 
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
    }).done(data => {
      for(let i = 0; i < data.split("、").length-1; i++) {
        $(`#${this.year}_${this.month+1}_${data.split("、")[i]}`)[0].className += "green-small";
      }
    });
  }
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