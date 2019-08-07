<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="db.DBText"%>
<%@ page import ="java.util.*"%>
<%@ page import ="org.json.*"%>

<%
request.setCharacterEncoding("UTF-8");
DBText a = new DBText();
JSONArray jar = new JSONArray();
String sql = new String();
String arrange = (request.getParameter("arrange") == null)? "" :request.getParameter("arrange");
String edit = (request.getParameter("edit") == null)? "" :request.getParameter("edit");
String decide = (request.getParameter("decide") == null)? "" :request.getParameter("decide");
String getWorkTime = (request.getParameter("getWorkTime") == null)? "" :request.getParameter("getWorkTime");
String allTable = (request.getParameter("allTable") == null)? "" :request.getParameter("allTable");
String month = request.getParameter("month");
String year	= request.getParameter("year");
a.connection();
if(arrange.equals("true")){
	String user = request.getParameter("user");
	String name = request.getParameter("name");
	String[] day = request.getParameterValues("day[]");
	if(day != null ){
		sql = "SELECT `workTime` FROM `staff-account` WHERE `name`= '"+name+"'";
		jar = a.getData(sql);
		if(!jar.isEmpty()){
			for(int i=0 ; i< day.length ;i++){
				JSONObject obj = jar.getJSONObject(0);
				sql = "INSERT INTO `staff-arrange`( `user`,`name`, `year`, `month`, `day`, `orderWork`) VALUES ('"+user+"','"+name+"','"+year+"','"+(Integer.parseInt(month)+2)+"','"+day[i]+"','"+obj.get("workTime")+"')";
				a.executeSQLUpdate(sql);
			}
		}
	}
}else if(edit.equals("true")){
	String user = request.getParameter("user");
	String[] day = request.getParameterValues("day[]");
	if(day != null ){
		for(int i =0; i< day.length ; i++){
			sql = "DELETE FROM `staff-arrange` WHERE `day` = '"+day[i]+"' AND `user` ='"+user+"'";
			a.executeSQLUpdate(sql);
		}
	}
}else if(decide.equals("true")){
	String[] name = request.getParameterValues("name[]");
	String orderWork = request.getParameter("orderWork");
	if(name != null ){
		for(int i=0 ; i< name.length ;i++){
			if(!name[i].equals("無")){
				String day = name[i].substring(name[i].lastIndexOf(")")+1,name[i].length());
				String user = name[i].substring(name[i].indexOf("(")+1, name[i].indexOf(")"));
				sql = "DELETE FROM `staff-worktime`  WHERE `day` = '"+day+"' and `orderWork` ='"+orderWork+"' and `year` = '"+year+"' and `month` = '"+(Integer.parseInt(month)+2)+"'";
				a.executeSQLUpdate(sql);
				sql = "INSERT INTO `staff-worktime`( `user`,`name`, `year`, `month`, `day`, `orderWork`) VALUES ('"+user+"','"+name[i].substring(0, name[i].indexOf("("))+"','"+year+"','"+(Integer.parseInt(month)+2)+"','"+day+"','"+orderWork+"')";
				a.executeSQLUpdate(sql);
				user = name[i].substring(name[i].lastIndexOf("(")+1, name[i].lastIndexOf(")"));
				sql = "INSERT INTO `staff-worktime`( `user`,`name`, `year`, `month`, `day`, `orderWork`) VALUES ('"+user+"','"+name[i].substring(name[i].indexOf(")")+1, name[i].lastIndexOf("("))+"','"+year+"','"+(Integer.parseInt(month)+2)+"','"+day+"','"+orderWork+"')";
				a.executeSQLUpdate(sql);
			}
		}
	}
}else if(getWorkTime.equals("true")){
	String name = request.getParameter("name");
	String day = "";
	sql = "SELECT `day` FROM `staff-worktime` WHERE `name`='"+name+"' AND `year` ='"+year+"' AND `month` ='"+(Integer.parseInt(month)+1)+"' ORDER BY CAST(`staff-worktime`.`day` AS UNSIGNED) ASC";
	jar = a.getData(sql);
	if(!jar.isEmpty()){
		for(int i=0 ; i< jar.length() ;i++){
			JSONObject obj = jar.getJSONObject(i);
			day += obj.get("day") + "、";
		}
	}
	response.getWriter().print(day);
}else if(allTable.equals("true")){
	sql = "SELECT `user`, `name`, `workTime` FROM `staff-account`";
	JSONArray name = a.getData(sql);
	ArrayList<String> nameAL = new ArrayList<>();
	JSONObject jsonO = new JSONObject();
	Set<String> setName = new LinkedHashSet<>(); 
	if(!name.isEmpty() ){
		for(int i=0 ; i< name.length() ;i++){
			JSONObject obj = name.getJSONObject(i);
			nameAL.add(obj.get("workTime")+"_"+obj.get("name")+"("+obj.get("user")+")");
		}
	}
	setName.addAll(nameAL); 
	nameAL.clear(); 
	nameAL.addAll(setName);
	for(int i=0 ;i<nameAL.size();i++){
		String day = "";
		String user = nameAL.get(i).split("_")[1].substring(nameAL.get(i).split("_")[1].indexOf("(")+1, nameAL.get(i).split("_")[1].indexOf(")"));
		String nameSql = nameAL.get(i).split("_")[1].substring(0, nameAL.get(i).split("_")[1].indexOf("("));
		sql = "SELECT `day` FROM `staff-worktime` WHERE `user`='"+user+"' and `name`='"+nameSql+"' AND `year` ='"+year+"' AND `month` ='"+(Integer.parseInt(month)+2)+"' ORDER BY CAST(`staff-worktime`.`day` AS UNSIGNED) ASC";
		jar = a.getData(sql);
		if(!jar.isEmpty()){
			for(int j=0 ; j< jar.length() ;j++){
				JSONObject obj = jar.getJSONObject(j);
				day += obj.get("day") + "、";
			}
		}
		if(!day.equals("")){
			jsonO.put(nameAL.get(i), day.substring(0,day.length()-1));
		}
	}
	
	response.getWriter().print(jsonO);
}
a.closeConnection();
%>