<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="ascdc.sinica.dhtext.db.DBText"%>
<%@ page import ="java.util.ArrayList"%>
<%@ page import ="java.util.Set"%>
<%@ page import ="java.util.TreeSet"%>
<%
request.setCharacterEncoding("UTF-8");
DBText a = new DBText();
String video = (request.getParameter("video") == null)? "" :request.getParameter("video");
String practice = (request.getParameter("practice") == null)? "" :request.getParameter("practice");
a.connection();
if(video.equals("true")){
	ArrayList<String> keyList = new ArrayList<String>();
	String partChapter	= request.getParameter("partChapter");	
	String b[][] =a.getData("SELECT `partNumber` FROM `classvideo` WHERE `partChapter`="+"'"+partChapter+"'");
	for(int i = 0; i < b.length; i++){
		keyList.add(b[i][0]);
	}
	ArrayList<String> columnList = new ArrayList<String>();
	Set<String> ts = new TreeSet<String>();
	ts.addAll(keyList);
	for (String key : ts) {
		columnList.add(key);
	}
	response.getWriter().print(columnList); 
}else if(practice.equals("true")){
	ArrayList<String> keyList = new ArrayList<String>();
	String partChapter	= request.getParameter("partChapter");	
	String b[][] =a.getData("SELECT `partNumber` FROM `practiceq` WHERE `partChapter`="+"'"+partChapter+"'");
	for(int i = 0; i < b.length; i++){
		keyList.add(b[i][0]);
	}
	ArrayList<String> columnList = new ArrayList<String>();
	Set<String> ts = new TreeSet<String>();
	ts.addAll(keyList);
	for (String key : ts) {
		columnList.add(key);
	}
	response.getWriter().print(columnList); 
}
a.closeConnection();
%>