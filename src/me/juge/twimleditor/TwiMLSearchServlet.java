package me.juge.twimleditor;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class TwiMLSearchServlet extends HttpServlet {	
	@Override
	protected void doGet( HttpServletRequest req, HttpServletResponse res ) throws ServletException, IOException{
		String language = "", voice = "", userid = "", q = "", contenttype = "application/json; charset=UTF-8";
		int id = 0, onlymine = 0;
		String out = "[";

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
				out += "{'id': " + twiml.getId() + ", 'twiml': '" + twiml.getTwiml() + "'}";
			}else{
				String _language = req.getParameter( "language" );
				if( _language != null && _language.length() > 0 ) language = _language;
				String _voice = req.getParameter( "voice" );
				if( _voice != null && _voice.length() > 0 ) voice = _voice;
				String _onlymine = req.getParameter( "onlymine" );
				if( _onlymine != null && _onlymine.length() > 0 ){
					try{
						onlymine = Integer.parseInt( _onlymine );
					}catch( Exception e ){
					}
				}
				String _userid = req.getParameter( "userid" );
				if( _userid != null && _userid.length() > 0 ) userid = _userid;
				String _q = req.getParameter( "q" );
				if( _q != null && _q.length() > 0 ) q = _q;
				
				List<String> listKey = new ArrayList<String>();
				List<String> listVal = new ArrayList<String>();
				if( language != null && language.length() > 0 ){
					listKey.add( "language" );
					listVal.add( language );
				}
				if( voice != null && voice.length() > 0 ){
					listKey.add( "voice" );
					listVal.add( voice );
				}
				//. これは userid の前に！
				if( onlymine > 0 ){
					listKey.add( "onlymine" );
					listVal.add( "1" );
				}
				if( userid != null && userid.length() > 0 ){
					listKey.add( "userid" );
					listVal.add( userid );
				}
				if( q != null && q.length() > 0 ){
					listKey.add( "q" );
					listVal.add( q );
				}
				
				TwiML[] twimls = app.selectTwiML( listKey.toArray( new String[0] ), listVal.toArray( new String[0] ) );

				int n = twimls.length;
				if( n > 0 ){
					for( int i = 0; i < n; i ++ ){
						TwiML twiml = twimls[i];
						boolean editable = false;
						if( userid != null && userid.length() > 0 ){
							editable = userid.equals( twiml.getUserid() );
						}
						String line = "{\"id\": " + twiml.getId() + ", \"title\": \"" + twiml.getTitle(true) + "\", \"userid\": \"" + twiml.getUserid() + "\", \"username\": \"" + twiml.getUsername(true) + "\", \"is_public\": " + twiml.getIs_public() + ", \"twiml\": \"" + twiml.getTwiml(true) + "\", \"editable\": " + editable + ", \"created\": \"" + twiml.getCreated() + "\", \"updated\": \"" + twiml.getUpdated() + "\"}";
						if( i == 0 ){
							out += line;
						}else{
							out += ( "," + line );
						}
					}
				}
			}
		}catch( Exception e ){
			e.printStackTrace();
		}
		
		out += "]";
		
		//System.out.println( "out = " + out );
		
		res.setContentType( contenttype );
		res.setCharacterEncoding( "UTF-8" );
//		res.setHeader( "Access-Control-Allow-Origin", "*" );
		res.getWriter().println( out );
	}
}
