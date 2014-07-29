package me.juge.twimleditor;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DeleteTwiMLServlet extends HttpServlet {	
	@Override
	protected void doPost( HttpServletRequest req, HttpServletResponse res ) throws ServletException, IOException{
		String contenttype = "text/plain; charset=UTF-8";
		int id = 0;
		String userid = "";
		String out = "";

		try{
			App app = new App();
			req.setCharacterEncoding( "UTF-8" );

			String _id = req.getParameter( "id" );
			if( _id != null && _id.length() > 0 ){
				try{
					id = Integer.parseInt( _id );
				}catch( Exception e ){
				}
			}
			String _userid = req.getParameter( "userid" );
			if( _userid != null && _userid.length() > 0 ){
				userid = _userid;
			}
			
			if( id > 0 && userid.length() > 0 ){
				int r = app.deleteTwiML( id, userid );
				out = "" + r;
			}
		}catch( Exception e ){
			e.printStackTrace();
			out = "-1 : " + e;
		}
		
		res.setContentType( contenttype );
		res.setCharacterEncoding( "UTF-8" );
//		res.setHeader( "Access-Control-Allow-Origin", "*" );
		res.getWriter().println( out );
	}
}
