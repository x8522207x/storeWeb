<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="ascdc.sinica.dhtext.db.DBText"%>
<%@ page import ="java.util.ArrayList"%>
<%@ page import ="java.util.Set"%>
<%@ page import ="java.util.TreeSet"%>
<%
request.setCharacterEncoding("UTF-8");
String partNumber = request.getParameter("partNumber");
String partChapter	= request.getParameter("partChapter");
String watch = (request.getParameter("watch") == null)? "" :request.getParameter("watch");
String delete = (request.getParameter("delete") == null)? "" :request.getParameter("delete");
String deleteUpdate = (request.getParameter("deleteUpdate") == null)? "" :request.getParameter("deleteUpdate");
String add = (request.getParameter("add") == null)? "" :request.getParameter("add");
String edit = (request.getParameter("edit") == null)? "" :request.getParameter("edit");
DBText a = new DBText();
a.connection();
if(watch.equals("true")){	
	//ArrayList<String>question = new ArrayList<String>();
	//ArrayList<String>answer = new ArrayList<String>();
	String question ="[";
	String answer = "[";
	String b[][] =a.getData("SELECT `question`, `answer` FROM `practiceq` WHERE `partNumber`='"+partNumber+"' and `partChapter`= '"+partChapter+"'");
	
	if(b != null){
		for(int i=0;i<b.length;i++){
			if(i!=b.length-1){
			//question.add(b[i][0]);
			question += b[i][0]+",,,";
			//answer.add(b[i][1]);
			answer += b[i][1]+",,,";
			}else if(i == b.length-1){
				question += b[i][0]+"]";
				answer += b[i][1]+"]";
			}
		}
		response.getWriter().print(question+":::"+answer);
	}
}else if(delete.equals("true")){
	a.updateData("DELETE FROM `practiceq` WHERE `partNumber` = '"+partNumber+"'");
}else if(add.equals("true")){
	String question	= request.getParameter("question");
	String answer	= request.getParameter("answer");
	a.executeSQLInsert("INSERT INTO `practiceq`( `partNumber`,`partChapter`, `question`, `answer`) VALUES ('"+partNumber+"','"+partChapter+"','"+question+"','"+answer+"')");
}else if(deleteUpdate.equals("true")){
	a.updateData("DELETE FROM `practiceq` WHERE `partNumber` = '"+partNumber+"' and `partChapter` = '"+partChapter+"'");
}else if(edit.equals("true")){
	String question	= request.getParameter("question");
	String answer	= request.getParameter("answer");
	String oldQuestion	= request.getParameter("oldQuestion");
	String oldAnswer	= request.getParameter("oldAnswer");
	a.updateData("UPDATE `practiceq` SET `question`='"+question+"',`answer`='"+answer+"' WHERE `partChapter` ='"+partChapter+"' and `partNumber` = '"+partNumber+"'and `question` = '"+oldQuestion+"'and `answer` = '"+oldAnswer+"'");
}
a.closeConnection();
%>