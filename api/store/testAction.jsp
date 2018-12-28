<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="ascdc.sinica.dhtext.db.DBText"%>
<%@ page import ="java.util.ArrayList"%>
<%@ page import ="java.util.Set"%>
<%@ page import ="java.util.TreeSet"%>
<%
request.setCharacterEncoding("UTF-8");
String add = (request.getParameter("add") == null)? "" :request.getParameter("add");
String result = (request.getParameter("result") == null)? "" :request.getParameter("result");
DBText a = new DBText();
a.connection();
if(add.equals("true")){
	String question	= request.getParameter("question");
	String answer	= request.getParameter("answer");
	String grade	= request.getParameter("grade");
	a.executeSQLInsert("INSERT INTO `testq`( `question`,`answer`, `grade`) VALUES ('"+question+"','"+answer+"','"+grade+"')");
}else if(result.equals("true")){
	String userAnswer	= request.getParameter("userAnswer").substring(0,request.getParameter("userAnswer").length()-1);
	int grade = 0;
	String b[][] =a.getData("SELECT `grade`,`answer` FROM `testq`");
	for(int i=0;i<userAnswer.split(",").length;i++){
		if(userAnswer.split(",")[i].equals(b[i][1])){
			grade+= Integer.parseInt(b[i][0]);
		}
	}
	response.getWriter().print(grade);
}

a.closeConnection();
%>