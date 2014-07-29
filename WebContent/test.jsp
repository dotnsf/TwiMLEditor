<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="me.juge.twimlmanager.*" %>
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
	BmxSsoApp app = new BmxSsoApp();
int r = app.createTableAndSample();
%>

<html>
<body>
<%= r %>
</body>
</html>