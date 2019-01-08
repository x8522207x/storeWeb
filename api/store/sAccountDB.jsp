<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="ascdc.sinica.dhtext.db.DBText"%>

<%
request.setCharacterEncoding("UTF-8");
DBText a = new DBText();
String account	= request.getParameter("account");
String register = (request.getParameter("register") == null)? "" :request.getParameter("register");
String check = (request.getParameter("check") == null)? "" :request.getParameter("check");
String sLogIn = (request.getParameter("sLogIn") == null)? "" :request.getParameter("sLogIn");
a.connection();
boolean result = true;
if(register.equals("true")){
	String password	= request.getParameter("password");
	String email	= request.getParameter("email");
	String name	= request.getParameter("name");
	String workTime	= request.getParameter("workTime");		
	if(account != null ){
		a.executeSQLInsert("INSERT INTO `staff-account`( `account`, `password`, `email`, `name`, `workTime`) VALUES ('"+account+"','"+password+"','"+email+"','"+name+"','"+workTime+"')");
		if(workTime.equals("noon")||workTime.equals("night")){
			a.executeSQLInsert("INSERT INTO `staff-account`( `account`, `password`, `email`, `name`, `workTime`) VALUES ('"+account+"','"+password+"','"+email+"','"+name+"','"+workTime+"2')");
		}
	}
	a.closeConnection();
}else if(check.equals("true")){
	String data[][]=a.getData("SELECT `account` FROM `staff-account`");
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
}else if(sLogIn.equals("true")){
	String password	= request.getParameter("password");
	String data[][]=a.getData("SELECT  `account`,`password`,`name` FROM `staff-account`");
	a.closeConnection();
	boolean alive = false;
	if(data != null){
		for(int i=0;i<data.length;i++){
			if(account.equals(data[i][0])){
				if(password.equals(data[i][1])){
					String userInfo = "true;"+data[i][2];
					response.getWriter().print(userInfo);
					session.setAttribute( "user", data[i][2] );
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