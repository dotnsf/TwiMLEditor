<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="me.juge.fboauth.*" %>
<%@ page import="me.juge.twimleditor.*" %>
<%@ page import="com.restfb.*" %>
<%@ page import="com.restfb.types.*" %>
<%@ page import="com.restfb.json.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.logging.*" %>
<% request.setCharacterEncoding("utf-8"); %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html> 
<head> 
<title>Online TwiML Editor</title> 

<meta http-equiv="content-type" content="text/html; charset=UTF-8">

<!-- 
<meta property="og:title" content=""/>
<meta property="og:type" content="website"/>
<meta property="og:url" content=""/>
<meta property="og:image" content=""/>
<meta property="og:site_name" content=""/>
<meta property="og:description" content=""/>
 -->
 
<meta http-equiv="viewport" content="width=device-width, initial-scale=1" />
<meta http-equiv="apple-mobile-web-app-capable" content="yes" />

<link href="css/bootstrap.min.css" rel="stylesheet" media="screen"/>
<link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.8.19/themes/redmond/jquery-ui.css">

<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.8.19/jquery-ui.min.js"></script>

<%
App app = new App();
FBOAuthApp fbapp = new FBOAuthApp();
Logger log = Logger.getLogger( FBOAuthApp.class.getName() );

String errormsg = request.getParameter( "errormsg" );
if( errormsg != null && errormsg.length() > 0 ){
%>
	alert( "<%= errormsg %>" );
<%
}

int twimlid = -1;
String _id = request.getParameter( "id" );
if( _id != null && _id.length() > 0 ){
	try{
		twimlid = Integer.parseInt( _id );
	}catch( Exception e ){
	}
}
if( twimlid <= 0 ){
%>
<script type="text/javascript">
alert( "対象の TwiML が指定されていません" );
</script>
<%	
}

String access_token = ( String )session.getAttribute( "access_token" );
if( access_token == null || access_token.length() == 0 ){
	String code = request.getParameter( "code" );
	if( code != null && code.length() > 0 ){
		access_token = fbapp.getAccessToken( code, session );
		if( access_token != null ){
			session.setAttribute( "access_token", access_token );

			response.sendRedirect( "./" );
		}else{
			//. アクセストークン取得失敗
			session.setAttribute( "access_token", access_token );

			response.sendRedirect( "./" );
		}
	}else{
		
	}
}


String username = fbapp.GetUsernameFromSession( session );
Long user_id = fbapp.GetUseridFromSession( session );


String me_id = "", me_picture = "", me_link = "", me_name = "";
try{
	if( access_token != null && access_token.length() > 0 ){
//		System.out.println( "access_token = " + access_token );
		DefaultFacebookClient fbc = new DefaultFacebookClient( access_token );
//		System.out.println( "fbc = " + fbc );
		JsonObject me = fbc.fetchObject( "/me", JsonObject.class );
//		System.out.println( "me = " + me );

//		log.info( "me = " + me );

		me_id = me.getString( "id" );
		me_picture = "https://graph.facebook.com/" + me_id + "/picture";
		me_link = me.getString( "link" );
		me_name = me.getString( "name" );
	}
}catch( Exception e ){
	log.warning( "" + e );
	e.printStackTrace();
}
%>

<script type="text/javascript">
<!--
var fb_key = "<%= fbapp.oauth_consumer_key %>";
var server_url = "<%= fbapp.server_url %>";
function fblogin(){
	$('body').css("cursor","wait");
	var redirect_url = "https://www.facebook.com/dialog/oauth?client_id=" + fb_key + "&redirect_uri=" + server_url + "view.jsp?id=<%= twimlid %>&scope=user_about_me";
	location.href = redirect_url;
}

function logOff(){
	location.href = "./logoff";
}

//. Facebook API のバグ
var wls = window.location.search;
if( wls !== "" && wls.indexOf( "?group=" ) == -1 ){
	window.location.search = "";
}

function refreshSize(){
	m_width = getMobileBrowserWidth();
	m_height = getMobileBrowserHeight();
}

function getMobileBrowserWidth(){
	if( window.innerWidth ){
		return window.innerWidth;
	}else if( document.documentElement && document.documentElement.clientWidth != 0 ){
		return document.documentElement.clientWidth;
	}else if( document.body ){
		return document.body.clientWidth;
	}
}

function getMobileBrowserHeight(){
	if( window.innerHeight ){
		return window.innerHeight;
	}else if( document.documentElement && document.documentElement.clientHeight != 0 ){
		return document.documentElement.clientHeight;
	}else if( document.body ){
		return document.body.clientHeight;
	}
}

window.onload = function(){
//	$('.match').hide();

//	console.log( "window.location.hash = " + window.location.hash );
	window.location.hash = "";
}
//-->
</script>

<style type="text/css">
*{
 margin: 0;
 padding: 0;
}

.navbar-fixed-top{
 position: fixed;
 top: 0;
 right: 0;
 left: 0;
 z-index: 1030;
 margin-bottom: 0;
 background-color: #428BCA;
 foreground-color: #ffffff;
}

body{
 background-color: #eee;
}

.carnonactive{
  border-width: 0px;
}
.caractive{
  border-color: #ffcccc;
  border-width: thick;
  border-style: solid;
}

.letsvote{
  background-color: #ccffcc;
}

.votenotavailable{
  background-color: #ffffcc;
}

.match{
}

</style>
</head> 
<body> 

  <!-- //navi -->
  <nav class="navbar navbar-default navbar-fixed-top">
    <div class="navbar-header">
      <button class="navbar-toggle" data-toggle="collapse" data-target=".target">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      
      <a href="https://twitter.com/share" class="twitter-share-button" data-text="ワールドカップを予想してみよう！ #wc2014" data-lang="ja">ツイート</a>
      <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
    
      <a name="fb_share" type="button_count" share_url="http://ec2.teyan.de/WC2014GL/"></a>
      <script src="http://static.ak.fbcdn.net/connect.php/js/FB.Share" type="text/javascript"></script>

    </div>
    <div class="collapse navbar-collapse target">
      <ul class="nav navbar-nav navbar-right">   
      	<li>
<%
if( user_id != null && user_id > 0 && username != null && username.length() > 0 ){
%>    
<!-- 
		<a href="#" onClick="logOff();">
		<img src="<%= me_picture %>" title="Logout" width="24" height="24"/>
		<font color="#000088"><%= username %></font>
		</a>
-->	
		
		<!-- 428BCA -->
		<div class="btn-group">
		  <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
     		<a href="#" onClick="logOff();">
		    <img src="<%= me_picture %>" title="Logout" width="24" height="24"/>
		    </a>
		  </button>
		  <ul class="dropdown-menu" role="menu">
		    <li><a href="#" onClick="logOff();">ログオフ</a></li>
		  </ul>
		</div>		
<%
}else{
%>      
        <a href="#" onClick="fblogin()"><img src="./imgs/f.png" title="Login"></a>
<%
}
%>      
		</li>
      </ul>
    </div>
  </nav>
  <!-- navi// -->
  
  <!-- //search -->
  <div class="container" align="right" style="padding:80px 0">
    <form name="frm1" id="frm1" method="post" action="./search">
      <input type="text" name="q" placeholder="" value=""/>
    </form>
  </div>
  <!-- search// -->

  <!-- //jumbotron -->
  <div class="jumbotron" style="padding:20px 0 0px">
   <h2>Online TwiML Editor</h2>
  </div>
  <!-- jumbotron// -->

  <!-- //table -->
  <div class="container" style="padding:20px 0">
<%
if( username != null && username.length() > 0 ){
%>
    <div align="right">
      <input type="button" value="Create" onClick="createTwiML('<%= username %>'); return false;"/>
    </div>
<%
}
%>
    <table class="table table-bordered table-condensed">
      <thead>
        <tr><th>Title</th><th>Username</th><th>Updated</th><th>Actions</th></tr>
      </thead>
      <tbody id="listtbody">
<%
TwiML[] twimls = app.searchAvailableTwiML( username );
if( twimls == null || twimls.length == 0 ){
	app.createSample();
	twimls = app.searchAvailableTwiML( username );
}

if( twimls != null && twimls.length > 0 ){
	for( int i = 0; i < twimls.length; i ++ ){
		boolean editable = app.isEditable( twimls[i], username );
		int id = twimls[i].getId();
		String title = twimls[i].getTitle();
		String name = twimls[i].getUsername();
		Date updated = twimls[i].getUpdated();
		
		String tr = "<tr>";
		tr += "<td><a href='./view.jsp?id=" + id + "'>" + title + "</a></td>";
		tr += "<td>" + name + "</td>";
		tr += "<td>" + updated + "</td>";

		if( editable ){
			tr += "<td><input type='button' value='Edit' onClick='editTwiML(" + id + ", '" + username + "'); return false;'/><input type='button' value='Delete' onClick='deleteTwiML(" + id + ", '" + username + "'); return false;'/></td>";
		}else{
			tr += "<td>&nbsp;</td>";
		}

		tr += "</tr>";
%>
        <%= tr %>
<%
	}
}
%>
      </tbody>
    </table>
  </div>
  <!-- table// -->

</body>

<script type="text/javascript">
$(fun)

function createTwiML( username ){
	console.log( "createTwiML : " + username );
}

function deleteTwiML( id, username ){
	console.log( "deleteTwiML : " + id + "," + username );
}

function editTwiML( id, username ){
	console.log( "editTwiML : " + id + "," + username );
}
</script>
</html>
