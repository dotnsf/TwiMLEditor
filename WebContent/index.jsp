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

<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet" media="screen"/>
<link href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap-glyphicons.css" rel="stylesheet" media="screen"/>
<link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.8.19/themes/redmond/jquery-ui.css">

<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
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
String userid = ( user_id != null ) ? "" + user_id : "";


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
	var redirect_url = "https://www.facebook.com/dialog/oauth?client_id=" + fb_key + "&redirect_uri=" + server_url + "&scope=user_about_me";
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
		<!-- 428BCA -->
		<div class="btn-group">
		  <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
     		<a href="#" onClick="logOff();">
		    <img src="<%= me_picture %>" title="Logout" width="24" height="24"/>Logout
		    </a>
		  </button>
		  <ul class="dropdown-menu" role="menu">
		    <li><a href="#" onClick="logOff();">ログオフ</a></li>
		  </ul>
		</div>		
<%
}else{
%>      
        <a href="#" onClick="fblogin()"><img src="./imgs/f.png" title="Login">Login</a>
<%
}
%>      
		</li>
      </ul>
    </div>
  </nav>
  <!-- navi// -->
  
  <!-- //jumbotron -->
  <div class="jumbotron" style="padding:80px 0 0px">
   <h2>Online TwiML Editor</h2>
  </div>
  <!-- jumbotron// -->

  <!-- //search -->
  <div class="container" align="right" style="padding:20px 0">
    <strong>検索</strong>
    <form name="frm1" id="frm1" method="post" action="#">
      <select id="search_language" name="search_language">
      <option value="">（言語選択）</option>
      <option value="ja-JP">日本語</option>
      <option value="en">英語</option>
      <option value="fr">仏語</option>      
      </select>
      <select id="search_voice" name="search_voice">
      <option value="">（音声選択）</option>
      <option value="alice">アリス</option>
      <option value="man">男性</option>
      <option value="woman">女性</option>      
      </select><br/>
<%
if( userid != null && userid.length() > 0 ){
%>
      <input type="checkbox" id="search_onlymine" name="search_onlymine" value="1"/>自分で作成したものだけ<br/>
<%
}
%>
      <input type="text" name="search_q" id="search_q" placeholder="" value=""/>
    </form>
  </div>
  <!-- search// -->

  <!-- //table -->
  <div class="container" style="padding:20px 0">
<%
if( userid != null && userid.length() > 0 ){
%>
    <div>
      <button class='btn btn-primary' data-toggle='modal' data-target='#myModalN'>Create</button>
    </div>
<%
}
%>
    <table class="table table-bordered table-condensed table-hover">
      <thead>
        <tr><th>TwiML</th><th>Title</th><th>Username</th><th>Updated</th><th>Actions</th></tr>
      </thead>
<%
TwiML[] twimls = app.searchAvailableTwiML( userid );
if( twimls == null || twimls.length == 0 ){
	app.createSample();
	twimls = app.searchAvailableTwiML( userid );
}

if( twimls != null && twimls.length > 0 ){
%>
<script type="text/javascript">
var twimls = {};
<%
	for( int i = 0; i < twimls.length; i ++ ){
		boolean editable = app.isEditable( twimls[i], userid );
		int id = twimls[i].getId();
		String title = twimls[i].getTitle();
		String uid = twimls[i].getUserid();
		String name = twimls[i].getUsername();
		Date updated = twimls[i].getUpdated();
		int is_public = twimls[i].getIs_public();
%>
twimls['<%= id %>'] = {'id':<%= id %>, 'title':'<%= title %>', 'userid':'<%= uid %>', 'name':'<%= name %>', 'updated':'<%= updated %>', 'editable':<%= editable %>, 'is_public':<%= is_public %>};
<%	
	}
%>
</script>
      <tbody id="listtbody">
<%
	for( int i = 0; i < twimls.length; i ++ ){
		boolean editable = app.isEditable( twimls[i], userid );
		int id = twimls[i].getId();
		String title = twimls[i].getTitle(true);
		String uid = twimls[i].getUserid();
		String name = twimls[i].getUsername(true);
		Date updated = twimls[i].getUpdated();
		int is_public = twimls[i].getIs_public();
		if( is_public > 0 ){
			name = "(Public Sample)";
		}
		String bold1 = ( editable ) ? "<strong>" : "";
		String bold2 = ( editable ) ? "</strong>" : "";
		
		String tr = "<tr>";
//		tr += "<td><button class='btn btn-primary btn-lg' data-toggle='modal' data-target='#myModal" + i + "'>" + title + "</button></td>";
		tr += "<td><input type='button' class='btn btn-info btn-xs' value='TwiML' onClick='viewTwiML(" + id + "); return false;'/></td>";
		tr += "<td>" + bold1 + title + bold2 + "</td>";
		tr += "<td>" + bold1 + name + bold2 + "</td>";
		tr += "<td>" + bold1 + updated + bold2 + "</td>";

		tr += "<td><button class='btn btn-primary btn-xs' data-toggle='modal' data-target='#myModal" + twimls[i].getId() + "V'>View</button>";
		if( editable ){
			tr += "<button class='btn btn-warning btn-xs' data-toggle='modal' data-target='#myModal" + twimls[i].getId() + "E'>Edit</button><input type='button' class='btn btn-danger btn-xs' value='Delete' onClick='deleteTwiML(" + id + ", \"" + uid + "\"); return false;'/>";
		}
		tr += "</td>";

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

  <!-- //modal -->
  <div class="modal fade" id="myModalN" tabindex="-1" role="dialog" aria-labelledby="myModalNLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
       <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
        <h4 class="modal-title" id="myModalNLabel">New TwiML</h4>
       </div>
       <div class="modal-body">
        <input type="text" name="newtitle" id="newtitle" placeholder="（タイトル）" value=""/><br/>
        <textarea cols="50" rows="6" name="newtwiml" id="newtwiml">
&lt;Response&gt;
&lt;Say language=&quot;ja-JP&quot; voice=&quot;alice&quot;&gt;ここにメッセージ内容を記述する&lt;/Say&gt;
&lt;/Response&gt;
        </textarea><br/>
        <input type="checkbox" name="newis_public" id="newis_public" value="1" checked="checked"/>公開する
       </div>
       <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal" onClick="createTwiML('<%= userid %>', '<%= username %>'); return false;">保存</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">閉じる</button>
       </div>
      </div>
    </div>
  </div>
  
  <div id="modals">
<%
if( twimls != null && twimls.length > 0 ){
	for( int i = 0; i < twimls.length; i ++ ){
		int ip = twimls[i].getIs_public();
		String ic = ( ip > 0 ) ? " checked=\"checked\"" : "";
%>
  <div class="modal fade" id="myModal<%= twimls[i].getId() %>V" tabindex="-1" role="dialog" aria-labelledby="myModal<%= twimls[i].getId() %>VLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
       <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
        <h4 class="modal-title" id="myModal<%= twimls[i].getId() %>VLabel"><%= twimls[i].getTitle() %></h4>
       </div>
       <div class="modal-body">
       <%= twimls[i].getTwiml( true ) %>
       </div>
       <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">閉じる</button>
       </div>
      </div>
    </div>
  </div>
<%
		if( userid != null && userid != "" ){
			if( app.isEditable( twimls[i], userid ) ){
%>
  <div class="modal fade" id="myModal<%= twimls[i].getId() %>E" tabindex="-1" role="dialog" aria-labelledby="myModal<%= twimls[i].getId() %>ELabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
       <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
        <h4 class="modal-title" id="myModal<%= twimls[i].getId() %>ELabel"><%= twimls[i].getTitle() %></h4>
       </div>
       <div class="modal-body">
        <input type="text" name="title<%= twimls[i].getId() %>" id="title<%= twimls[i].getId() %>" value="<%= twimls[i].getTitle() %>"/><br/>
        <textarea cols="50" rows="6" name="twiml<%= twimls[i].getId() %>" id="twiml<%= twimls[i].getId() %>">
        <%= twimls[i].getTwiml( true ) %>
        </textarea><br/>
        <input type="checkbox" name="is_public<%= twimls[i].getId() %>" id="is_public<%= twimls[i].getId() %>" value="1"<%= ic %>/>公開する
       </div>
       <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal" onClick="editTwiML(<%= twimls[i].getId() %>, '<%= userid %>', '<%= username %>'); return false;">保存</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">閉じる</button>
       </div>
      </div>
    </div>
  </div>
<%
			}
		}
	}
}
%>
  </div>
  <!-- modal// -->
</body>

<script type="text/javascript">
function viewTwiML( id ){
	var twiml = twimls[''+id];
	console.log( twiml ); //. twiml['editable']??
	if( twiml['editable'] > 0 || twiml['is_public'] > 0 ){
		window.open( "./showtwiml?id=" + id, twiml['name'] );
	}
}

function createTwiML( userid, username ){
	if( userid != null && userid.length > 0 ){
		var new_title = $('#newtitle').val();
		var new_twiml = $('#newtwiml').val();
		var new_is_public = $('#newis_public').val();
		if( new_is_public == null || new_is_public == '' ){
			new_is_public = 0;
		}
		console.log( "title = " + new_title + ", twiml = " + new_twiml + ", is_public = " + new_is_public );	
		$.ajax({
			type: "POST",
			url: "./createtwiml",
			data: { userid: userid, username: username, title: new_title, twiml: new_twiml, is_public: new_is_public },
			success: function(x){
				location.href = "./";
			},
			error: function(){
				location.href = "./";
			}
		});
	}
}

function deleteTwiML( id, userid ){
	var twiml = twimls[''+id];
	if( twiml['editable'] > 0 ){
		if( window.confirm('削除してよろしいですか？') ){
			$.ajax({
				type: "POST",
				url: "./deletetwiml",
				data: { id: id, userid: userid },
				success: function(x){
					location.href = "./";
				},
				error: function(){
					location.href = "./";
				}
			});
		}
	}
}

function editTwiML( id, userid, username ){
	var twiml = twimls[''+id];
	console.log( 'editable = ' + twiml['editable'] );
	if( twiml['editable'] > 0 ){
		var title = $('#title'+id).val();
		var twiml = $('#twiml'+id).val();
		var is_public = ( $('#is_public'+id).attr("chedked") == undefined ) ? 0 : 1;
		$.ajax({
			type: "POST",
			url: "./updatetwiml",
			data: { id: id, userid: userid, username: username, title: title, twiml: twiml, is_public: is_public },
			success: function(x){
				location.href = "./";
			},
			error: function(){
				location.href = "./";
			}
		});
	}
}

function beforeSearch(){
	var s_q = ( $('#search_q').val() == undefined ) ? '' : $('#search_q').val();
	var s_language = $('#search_language').val();
	var s_voice = $('#search_voice').val();
	var s_onlymine = ( $('#search_onlymine').attr("checked") == undefined ) ? 0 : 1;
	var s_userid = '';
	if( s_onlymine == 1 ){
		s_userid = '<%= userid %>';
	}
	//console.log( "q = " + s_q + ", language = " + s_language + ", voice = " + s_voice + ", onlymine = " + s_onlymine );
	$.ajax({
		type: "GET",
		url: "./twimlsearch",
		dataType: "json",
		data: { q: s_q, userid: s_userid, onlymine: s_onlymine, language: s_language, voice: s_voice },
		success: function(json){
			redraw(json);
			//location.href = "./";
		},
		error: function(req,status,error){
			console.log( "req = " + req );
			console.log( "status = " + status );
			console.log( "error = " + error );
			//location.href = "./";
		}
	});
	
	return false;
}

$(function(){
	$('#frm1').on( 'submit', function( e ){
		beforeSearch();
		return false;
	});
	
	$('#search_language').change( function(){
//		document.frm1.submit();
		beforeSearch();
		return false;
	});
	$('#search_voice').change( function(){
//		document.frm1.submit();
		beforeSearch();
		return false;
	});
	$('#search_onlymine').change( function(){
//		document.frm1.submit();
		beforeSearch();
		return false;
	});
});

function isEditable( tuserid ){
	var userid = '<%= userid %>';
	return ( userid != '' && userid == tuserid );
}

function redraw(json){
	twimls = {};
	var listtbody = '';
	var modals = '';
	if( json && json.length > 0 ){
		for( i = 0; i < json.length; i ++ ){
			var editable = isEditable( json[i].userid );
			var bold1 = ( editable ) ? "<strong>" : "";
			var bold2 = ( editable ) ? "</strong>" : "";

			//. twimls
			twimls[''+json[i].id] = json[i];
			
			//. listbody
			listtbody += "<tr><td><input type='button' class='btn btn-info btn-xs' value='TwiML' onClick='viewTwiML(" + json[i].id + "); return false;'/></td>"
					+ "<td>" + bold1 + json[i].title + bold2 + "</td>"
					+ "<td>" + bold1 + json[i].username + bold2 + "</td>"
					+ "<td>" + bold1 + json[i].updated + bold2 + "</td>"
					+ "<td><button class='btn btn-primary btn-xs' data-toggle='modal' data-target='#myModal" + json[i].id + "V'>View</button>";
			if( editable ){
				listtbody += "<button class='btn btn-warning btn-xs' data-toggle='modal' data-target='#myModal" + json[i].id + "E'>Edit</button>"
						+ "<input type='button' class='btn btn-danger btn-xs' value='Delete' onClick='deleteTwiML(" + json[i].id + ", \"<%= userid %>\"); return false;'/>";
			}
			listtbody += "</td></tr>";
			
			//. modals
			var ic = ( json[i].is_public > 0 ) ? ' checked="checked"' : '';
			modals += "<div class=\"modal fade\" id=\"myModal" + json[i].id + "V\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"myModal" + json[i].id + "VLabel\" aria-hidden=\"true\">"
					+ "<div class=\"modal-dialog\">"
					+ "<div class=\"modal-content\">"
					+ "<div class=\"modal-header\">"
					+ "<button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">X</button>"
					+ "<h4 class=\"modal-title\" id=\"myModal" + json[i].id + "VLabel\">" + json[i].title + "</h4>"
					+ "</div>"
					+ "<div class=\"modal-body\">" + json[i].twiml + "</div>"
					+ "<div class=\"modal-footer\">"
					+ "<button type=\"button\" class=\"btn btn-default\" data-dismiss=\"modal\">閉じる</button>"
					+ "</div>"
					+ "</div>"
					+ "</div>"
					+ "</div>";
			if( editable ){
				modals += "<div class=\"modal fade\" id=\"myModal" + json[i].id + "E\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"myModal" + json[i].id + "ELabel\" aria-hidden=\"true\">"
						+ "<div class=\"modal-dialog\">"
						+ "<div class=\"modal-content\">"
						+ "<div class=\"modal-header\">"
						+ "<button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">X</button>"
						+ "<h4 class=\"modal-title\" id=\"myModal" + json[i].id + "ELabel\">" + json[i].title + "</h4>"
						+ "</div>"
						+ "<div class=\"modal-body\">"
						+ "<input type=\"text\" name=\"title" + json[i].id + "\" id=\"title" + json[i].id + "\" value=\"" + json[i].title + "\"/><br/>"
						+ "<textarea cols=\"50\" rows=\"6\" name=\"twiml" + json[i].id + "\" id=\"twiml" + json[i].id + "\">"
						+ json[i].twiml
						+ "</textarea><br/>"
						+ "<input type=\"checkbox\" name=\"is_public" + json[i].id + "\" id=\"is_publlic" + json[i].id + "\" value=\"1\"" + ic + "/>公開する"
						+ "</div>"
						+ "<div class=\"modal-footer\">"
						+ "<button type=\"button\" class=\"btn btn-default\" data-dismiss=\"modal\" onClick=\"editTwiML( " + json[i].id + ",'" + json[i].userid + "', '" + json[i].username + "'); return false;\">保存</button>"
						+ "<button type=\"button\" class=\"btn btn-default\" data-dismiss=\"modal\">閉じる</button>"
						+ "</div>"
						+ "</div>"
						+ "</div>"
						+ "</div>";
			}
		}
	}
	$('#listtbody').html( listtbody );
	$('#modals').html( modals );
}
</script>
</html>
