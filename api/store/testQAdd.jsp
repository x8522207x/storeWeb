<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="ascdc.sinica.dhtext.db.DBText"%>

<%
request.setCharacterEncoding("UTF-8");
DBText a = new DBText();
String partNumber	= request.getParameter("partNumber");
String question	= request.getParameter("question");
String answer	= request.getParameter("answer");
a.connection();
a.executeSQLInsert("INSERT INTO `testq`( `partNumber`, `question`, `answer`) VALUES ('"+partNumber+"','"+question+"','"+answer+"')");

a.closeConnection();
%>