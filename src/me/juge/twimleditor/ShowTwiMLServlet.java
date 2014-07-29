package me.juge.twimleditor;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ShowTwiMLServlet extends HttpServlet {	
	@Override
	protected void doGet( HttpServletRequest req, HttpServletResponse res ) throws ServletException, IOException{
		String contenttype = "application/xml; charset=UTF-8";
		int id = 0;
		String out = "<?xml version='1.0' encoding='UTF-8'?>\n";

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
			
			if( id > 0 ){
				TwiML twiml = app.selectTwiML( id );
				out += twiml.getTwiml( false );
			}else{
				out += "<Error id='" + id + "'/>";
			}
		}catch( Exception e ){
			e.printStackTrace();
			out += "<Exception>" + e + "</Exception>";
		}
		
		res.setContentType( contenttype );
		res.setCharacterEncoding( "UTF-8" );
//		res.setHeader( "Access-Control-Allow-Origin", "*" );
		res.getWriter().println( out );
	}
}
