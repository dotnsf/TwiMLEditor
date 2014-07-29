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
TwiML[] twimls = app.selectTwiML();
%>

<html>
<body>
<table border='1'>
<%
int n = twimls.length;
for( int i = 0; i < n; i ++ ){
	TwiML twiml = twimls[i];
	int id = twiml.getId();
	String xml = twiml.getTwiml( true );
%>
<tr>
 <td><a target="_blank" href="./edit.jsp?id=<%= id %>">(EDIT)</a> &nbsp; <a target="_blank" href="./showtwiml?id=<%= id %>">(SHOW)</a></td>
 <td><%= xml %></td>
</tr>
<%
}
%>
</table>
</body>
</html>