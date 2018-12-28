<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="ascdc.sinica.dhtext.db.DBText"%>
<%@ page import ="java.util.ArrayList"%>
<%@ page import ="java.util.Set"%>
<%@ page import ="java.util.TreeSet"%>
<%
request.setCharacterEncoding("UTF-8");
String partNumber = request.getParameter("partNumber");
String watch = (request.getParameter("watch") == null)? "" :request.getParameter("watch");
String delete = (request.getParameter("delete") == null)? "" :request.getParameter("delete");
String edit = (request.getParameter("edit") == null)? "" :request.getParameter("edit");
String editUpdate = (request.getParameter("editUpdate") == null)? "" :request.getParameter("editUpdate");
String add = (request.getParameter("add") == null)? "" :request.getParameter("add");
DBText a = new DBText();
a.connection();
if(watch.equals("true")){	
	String b[][] =a.getData("SELECT `partName`, `video` FROM `classvideo` WHERE `partNumber`='"+partNumber+"'");
	if(b != null){
		response.getWriter().print(b[0][0]+","+b[0][1]);
	}
}else if(delete.equals("true")){
	a.updateData("DELETE FROM `classvideo` WHERE `partNumber` = '"+partNumber+"'");
}else if(edit.equals("true")){
	String partChapter = request.getParameter("partChapter");
	String b[][] =a.getData("SELECT `partName`, `video` FROM `classvideo` WHERE `partNumber`='"+partNumber+"' and `partChapter` = '"+partChapter+"'");
	if(b != null){
		response.getWriter().print("partName::"+b[0][0]+",video::"+b[0][1]);
	}
}else if(editUpdate.equals("true")){
	String partChapter = request.getParameter("partChapter");
	String partName = request.getParameter("partName");
	String video = request.getParameter("video");
	a.updateData("UPDATE `classvideo` SET `partName`='"+partName+"',`video`='"+video+"' WHERE `partChapter` ='"+partChapter+"' and `partNumber` = '"+partNumber+"'");
}else if(add.equals("true")){
	String partChapter	= request.getParameter("partChapter");
	String partName	= request.getParameter("partName");
	String video	= request.getParameter("video");
	a.executeSQLInsert("INSERT INTO `classvideo`( `partNumber`,`partChapter`, `partName`, `video`) VALUES ('"+partNumber+"','"+partChapter+"','"+partName+"','"+video+"')");
}

a.closeConnection();
%>