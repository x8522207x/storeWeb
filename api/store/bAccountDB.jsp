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
String bLogIn = (request.getParameter("bLogIn") == null)? "" :request.getParameter("bLogIn");
a.connection();
boolean result = true;
if(register.equals("true")){
	String password	= request.getParameter("password");
	String email	= request.getParameter("email");
	String name	= request.getParameter("name");	
	if(account != null){
		a.executeSQLUpdate("INSERT INTO `boss-account`( `account`, `password`, `email`, `name`) VALUES ('"+account+"','"+password+"','"+email+"','"+name+"')");
	}
	a.closeConnection();
}else if(check.equals("true")){
	jar = a.getData("SELECT `account` FROM `boss-account`");
	a.closeConnection();
	if(!jar.isEmpty()){
		for(int i=0;i<jar.length();i++){
			JSONObject obj = jar.getJSONObject(i);
			result = true;
			if(account.equals(obj.get("account"))){
				result = false;
				response.getWriter().print(result); 
				break;
			}
		}
		if(result != false){
			response.getWriter().print(result);
		}		
	}else{
		result = true;
		response.getWriter().print(result); 
	}
}else if(bLogIn.equals("true")){
	String password	= request.getParameter("password");
	jar = a.getData("SELECT `user`,`account`,`password`,`name` FROM `boss-account`");
	a.closeConnection();
	boolean alive = false;
	if(!jar.isEmpty()){
		for(int i=0;i<jar.length();i++){
			JSONObject obj = jar.getJSONObject(i);
			if(account.equals(obj.get("account"))){
				if(password.equals(obj.get("password"))){
					String userInfo = "true;"+obj.get("name")+";"+obj.get("user");
					session.setAttribute( "user", obj.get("user"));
					response.getWriter().print(userInfo);
					alive = true;
					break;
				}else{
					response.getWriter().print("pfalse");
					alive = true;
					break;
				}
			}
		}
		if(alive == false){
			response.getWriter().print("afalse");
		}
	}else{
		response.getWriter().print("afalse");
	}
}

%>