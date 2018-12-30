<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="ascdc.sinica.dhtext.db.DBText"%>

<%
request.setCharacterEncoding("UTF-8");
DBText a = new DBText();
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
		a.executeSQLInsert("INSERT INTO `boss-account`( `account`, `password`, `email`, `name`) VALUES ('"+account+"','"+password+"','"+email+"','"+name+"')");
	}
	a.closeConnection();
}else if(check.equals("true")){
	String data[][]=a.getData("SELECT  `account` FROM `boss-account`");
	a.closeConnection();
	if(data != null){
		for(int i=0;i<data.length;i++){
			result = true;
			if(account.equals(data[i][0])){
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
	String data[][]=a.getData("SELECT  `account`,`password`,`name` FROM `boss-account`");
	a.closeConnection();
	boolean alive = false;
	if(data != null){
		for(int i=0;i<data.length;i++){
			if(account.equals(data[i][0])){
				if(password.equals(data[i][1])){
					String userInfo = "true;"+data[i][2];
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