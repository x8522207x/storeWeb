<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="db.DBText"%>
<%@ page import ="java.util.*"%>
<%@ page import ="org.json.*"%>

<%
request.setCharacterEncoding("UTF-8");
DBText a = new DBText();
JSONArray jar = new JSONArray();
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
		String sql = "SELECT `workTime` FROM `staff-account` WHERE `name`= '"+user+"'";
		jar = a.getData(sql);
		if(!jar.isEmpty()){
			for(int i=0 ; i< day.length ;i++){
				JSONObject obj = jar.getJSONObject(0);
				a.executeSQLUpdate("INSERT INTO `staff-arrange`( `user`, `year`, `month`, `day`, `orderWork`) VALUES ('"+user+"','"+year+"','"+(Integer.parseInt(month)+2)+"','"+day[i]+"','"+obj.get("workTime")+"')");
			}
		}
	}
}else if(edit.equals("true")){
	String user = request.getParameter("user");
	String[] day = request.getParameterValues("day[]");
	if(day != null ){
		for(int i =0; i< day.length ; i++){
			a.executeSQLUpdate("DELETE FROM `staff-arrange` WHERE `day` = '"+day[i]+"' AND `user` ='"+user+"'");
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
				a.executeSQLUpdate("DELETE FROM `staff-worktime` WHERE `day` = '"+(i+1)+"' AND `orderWork` ='"+orderWork+"'");
				a.executeSQLUpdate("INSERT INTO `staff-worktime`( `user`, `year`, `month`, `day`, `orderWork`) VALUES ('"+user[i]+"','"+year+"','"+(Integer.parseInt(month)+1)+"','"+(i+1)+"','"+orderWork+"')");
			}
		}
	}
}else if(getWorkTime.equals("true")){
	String user = request.getParameter("user");
	String year = request.getParameter("year");
	String month = request.getParameter("month");
	String day = "";
	jar = a.getData("SELECT `day` FROM `staff-worktime` WHERE `user`='"+user+"' AND `year` ='"+year+"' AND `month` ='"+(Integer.parseInt(month)+1)+"'");
	if(!jar.isEmpty()){
		for(int i=0 ; i< jar.length() ;i++){
			JSONObject obj = jar.getJSONObject(i);
			day += obj.get("day") + "、";
		}
	}
	response.getWriter().print(day);
}else if(allTable.equals("true")){
	String year = request.getParameter("year");
	String month = request.getParameter("month");
	JSONArray user = a.getData("SELECT `name` ,`workTime` FROM `staff-account`");
	ArrayList<String> name = new ArrayList<>();
	JSONObject jsonO = new JSONObject();
	Set<String> setName = new LinkedHashSet<>(); 
	if(!user.isEmpty() ){
		for(int i=0 ; i< user.length() ;i++){
			JSONObject obj = user.getJSONObject(i);
			name.add(obj.get("workTime")+"_"+obj.get("name"));
		}
	}
	setName.addAll(name); 
	name.clear(); 
	name.addAll(setName);
	for(int i=0 ;i<name.size();i++){
		String day = "";
		jar = a.getData("SELECT `day` FROM `staff-worktime` WHERE `user`='"+name.get(i).split("_")[1]+"' AND `year` ='"+year+"' AND `month` ='"+(Integer.parseInt(month)+1)+"'");
		if(!jar.isEmpty()){
			for(int j=0 ; j< jar.length() ;j++){
				JSONObject obj = jar.getJSONObject(j);
				day += obj.get("day") + "、";
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