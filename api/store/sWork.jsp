<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="ascdc.sinica.dhtext.db.DBText"%>
<%@ page import ="java.util.*"%>
<%@ page import ="org.json.*"%>

<%
request.setCharacterEncoding("UTF-8");
DBText a = new DBText();
String arrange = (request.getParameter("arrange") == null)? "" :request.getParameter("arrange");
String edit = (request.getParameter("edit") == null)? "" :request.getParameter("edit");
String decide = (request.getParameter("decide") == null)? "" :request.getParameter("decide");
String getWorkTime = (request.getParameter("getWorkTime") == null)? "" :request.getParameter("getWorkTime");
String allTable = (request.getParameter("allTable") == null)? "" :request.getParameter("allTable");
a.connection();
if(arrange.equals("true")){
	String user = request.getParameter("user");
	String[] day = request.getParameterValues("day[]");
	String month = request.getParameter("month");
	String year	= request.getParameter("year");
	if(day != null ){
		String b[][] =a.getData("SELECT `workTime` FROM `staff-account` WHERE `name`='"+user+"'");
		for(int i=0 ; i< day.length ;i++){
			a.executeSQLInsert("INSERT INTO `staff-arrange`( `user`, `year`, `month`, `day`, `orderWork`) VALUES ('"+user+"','"+year+"','"+(Integer.parseInt(month)+1)+"','"+day[i]+"','"+b[0][0]+"')");
		}
	}
}else if(edit.equals("true")){
	String user = request.getParameter("user");
	String[] day = request.getParameterValues("day[]");
	if(day != null ){
		for(int i =0; i< day.length ; i++){
			a.updateData("DELETE FROM `staff-arrange` WHERE `day` = '"+day[i]+"' AND `user` ='"+user+"'");
		}
	}
}else if(decide.equals("true")){
	String[] user = request.getParameterValues("user[]");
	String year = request.getParameter("year");
	String month = request.getParameter("month");
	String orderWork = request.getParameter("orderWork");
	if(user != null ){
		for(int i=0 ; i< user.length ;i++){
			if(!user[i].equals("無")){
				a.updateData("DELETE FROM `staff-worktime` WHERE `day` = '"+(i+1)+"' AND `orderWork` ='"+orderWork+"'");
				a.executeSQLInsert("INSERT INTO `staff-worktime`( `user`, `year`, `month`, `day`, `orderWork`) VALUES ('"+user[i]+"','"+year+"','"+(Integer.parseInt(month)+1)+"','"+(i+1)+"','"+orderWork+"')");
			}
		}
	}
}else if(getWorkTime.equals("true")){
	String user = request.getParameter("user");
	String year = request.getParameter("year");
	String month = request.getParameter("month");
	String day = "";
	String b[][] = a.getData("SELECT `day` FROM `staff-worktime` WHERE `user`='"+user+"' AND `year` ='"+year+"' AND `month` ='"+(Integer.parseInt(month)+1)+"'");
	if(b != null ){
		for(int i=0 ; i< b.length ;i++){
			day += b[i][0] + "、";
		}
	}
	response.getWriter().print(day);
}else if(allTable.equals("true")){
	String year = request.getParameter("year");
	String month = request.getParameter("month");
	String user[][] = a.getData("SELECT `name` ,`workTime` FROM `staff-account`");
	ArrayList<String> name = new ArrayList<>();
	JSONObject jsonO = new JSONObject();
	if(user != null ){
		for(int i=0 ; i< user.length ;i++){
			name.add(user[i][1]+"_"+user[i][0]);
		}
	}
	Set<String> setName = new LinkedHashSet<>(); 
	setName.addAll(name); 
	name.clear(); 
	name.addAll(setName);
	for(int i=0 ;i<name.size();i++){
		String day = "";
		String b[][] = a.getData("SELECT `day` FROM `staff-worktime` WHERE `user`='"+name.get(i).split("_")[1]+"' AND `year` ='"+year+"' AND `month` ='"+(Integer.parseInt(month)+1)+"'");
		if(b != null ){
			for(int j=0 ; j< b.length ;j++){
				day += b[j][0] + "、";
			}
		}
		if(!day.equals("")){
			jsonO.put(name.get(i), day.substring(0,day.length()-1));
		}
	}
	
	response.getWriter().print(jsonO);
}
a.closeConnection();
%>