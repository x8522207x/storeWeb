<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="ascdc.sinica.dhtext.db.DBText"%>

<%
request.setCharacterEncoding("UTF-8");
DBText a = new DBText();
String arrange = (request.getParameter("arrange") == null)? "" :request.getParameter("arrange");
String edit = (request.getParameter("edit") == null)? "" :request.getParameter("edit");
a.connection();
if(arrange.equals("true")){
	String user = request.getParameter("user");
	String[] day = request.getParameterValues("day[]");
	String month = request.getParameter("month");
	String year	= request.getParameter("year");
	if(day[0] != null ){
		String b[][] =a.getData("SELECT `workTime` FROM `staff-account` WHERE `name`='"+user+"'");
		for(int i=0 ; i< day.length ;i++){
			a.executeSQLInsert("INSERT INTO `staff-arrange`( `user`, `year`, `month`, `day`, `orderWork`) VALUES ('"+user+"','"+year+"','"+(Integer.parseInt(month)+1)+"','"+day[i]+"','"+b[0][0]+"')");
		}
	}
	a.closeConnection();
}else if(edit.equals("true")){
	String user = request.getParameter("user");
	String[] day = request.getParameterValues("day[]");
	if(day[0] != null ){
		for(int i =0; i< day.length ; i++){
			a.updateData("DELETE FROM `staff-arrange` WHERE `day` = '"+day[i]+"' AND `user` ='"+user+"'");
		}
	}
	a.closeConnection();
}

%>