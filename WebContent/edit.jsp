<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="me.juge.twimleditor.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.logging.*" %>
<% request.setCharacterEncoding("utf-8"); %>

<%
App app = new App();
TwiML twiml = null;
int id = 0;
String _id = request.getParameter( "id" );
if( _id != null && _id.length() > 0 ){
	try{
		id = Integer.parseInt( _id );
	}catch( Exception e ){
	}
	
	if( id > 0 ){
		twiml = app.selectTwiML( id );
	}
}
%>

<html>
<body>
<%
if( id > 0 && twiml != null ){
	String xml = twiml.getTwiml( true );	
%>
<table border='1'>
<tr width="90%">
<!--  <td><%= id %></td> -->
 <td><textarea rows="10" cols="80" style="width:100%;height:50px"><%= xml %></textarea></td>
</tr>
</table>
<%
}
%>
</body>
</html>