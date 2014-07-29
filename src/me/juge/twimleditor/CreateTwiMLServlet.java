package me.juge.twimleditor;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CreateTwiMLServlet extends HttpServlet {	
	@Override
	protected void doPost( HttpServletRequest req, HttpServletResponse res ) throws ServletException, IOException{
		String contenttype = "text/plain; charset=UTF-8";
		String title = "", userid = "", username = "";
		int is_public = 1;
		String out = "";

		try{
			App app = new App();
			req.setCharacterEncoding( "UTF-8" );

			String _title = req.getParameter( "title" );
			if( _title != null && _title.length() > 0 ){
				title = _title;
			}
			String _userid = req.getParameter( "userid" );
			if( _userid != null && _userid.length() > 0 ){
				userid = _userid;
			}
			String _username = req.getParameter( "username" );
			if( _username != null && _username.length() > 0 ){
				username = _username;
			}
			String _is_public = req.getParameter( "is_public" );
			if( _is_public != null && _is_public.length() > 0 ){
				try{
					is_public = Integer.parseInt( _is_public );
				}catch( Exception e ){
				}
			}

			String xml = req.getParameter( "twiml" );
			if( userid != null && userid.length() > 0 && xml != null && xml.length() > 0 ){
				int r = app.insertTwiML( title, userid, username, is_public, xml );
				out = "" + r;
			}else{
				out = "-1";
			}
		}catch( Exception e ){
			e.printStackTrace();
			out += "-1 : " + e;
		}
		
		res.setContentType( contenttype );
		res.setCharacterEncoding( "UTF-8" );
//		res.setHeader( "Access-Control-Allow-Origin", "*" );
		res.getWriter().println( out );
	}
}
