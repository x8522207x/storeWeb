<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="db.DBText"%>
<%@ page import ="org.json.*"%>

<%
request.setCharacterEncoding("UTF-8");
DBText a = new DBText();
JSONArray jar = new JSONArray();
String account	= request.getParameter("account");
String register = (request.getParameter("register") == null)? "" :request.getParameter("register");
String check = (request.getParameter("check") == null)? "" :request.getParameter("check");
String sLogIn = (request.getParameter("sLogIn") == null)? "" :request.getParameter("sLogIn");
boolean result = true;
a.connection();
if(register.equals("true")) {
	String password	= request.getParameter("password");
	String email	= request.getParameter("email");
	String name	= request.getParameter("name");
	String workTime	= request.getParameter("workTime");		
	if(account != null ) {
		a.executeSQLUpdate("INSERT INTO `staff-account`( `account`, `password`, `email`, `name`, `workTime`) VALUES ('"+account+"','"+password+"','"+email+"','"+name+"','"+workTime+"')");
	}
}else if(check.equals("true")) {
	jar = a.getData("SELECT `account` FROM `staff-account`");
	if(!jar.isEmpty()) {
		for(int i = 0; i < jar.length(); i++) {
			result = true;
			JSONObject obj = jar.getJSONObject(i);
			if(obj.get("account").equals(account)) {
				result = false;
				response.getWriter().print(result); 
				break;
			}
		}
		if(result != false) {
			response.getWriter().print(result);
		}	
	} else {
		result = true;
		response.getWriter().print(result); 
	}
}else if(sLogIn.equals("true")) {
	String password	= request.getParameter("password");
	jar = a.getData("SELECT `user`,`account`,`password`,`name` FROM `staff-account`");
	boolean alive = false;
	if(!jar.isEmpty()) {
		for(int i = 0; i < jar.length(); i++) {
			JSONObject obj = jar.getJSONObject(i);	
			if(account.equals(obj.get("account"))) {
				if(password.equals(obj.get("password"))) {
					String userInfo = "true;"+obj.get("name")+";"+obj.get("user");
					response.getWriter().print(userInfo);
					session.setAttribute( "name", obj.get("name"));
					session.setAttribute( "user", obj.get("user"));
					alive = true;
					break;
				} else {
					response.getWriter().print("pfalse");
					alive = true;
					break;
				}
			}
		}
		if(alive == false) {
			response.getWriter().print("afalse");
		}
	} else {
		response.getWriter().print("afalse");
	}
}
a.closeConnection();
%>