package me.juge.fboauth;

import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;

import com.restfb.DefaultFacebookClient;
import com.restfb.json.JsonObject;

public class FBOAuthApp {
	private static final Logger log = Logger.getLogger( FBOAuthApp.class.getName() );

	static public boolean isDebug = false; //. true for local debugging
	static public String server_url = "http://twimleditor.mybluemix.net/"; //. Service Top URL
	static public String oauth_consumer_key = "(Facebook OAuth Consumer Key)"; //. OAuth Consumer Key
	static public String oauth_consumer_secret = "(Facebook OAuth Consumer Secret)"; //. OAuth Consumer Secret

	public FBOAuthApp(){
	}
	
	public String getCode(String scope) {
		String req_url = "https://www.facebook.com/dialog/oauth?client_id="
				+ oauth_consumer_key + "&redirect_uri=" + server_url
				+ "&scope=" + scope;
		
		return req_url;
	}

	public String getCode() {
		return getCode("user_about_me");
	}

	public String getAccessToken(String code, HttpSession session) {
		String access_token = null;

		String req_url = "https://graph.facebook.com/oauth/access_token?client_id="
				+ oauth_consumer_key
				+ "&redirect_uri="
				+ server_url
				+ "&client_secret=" + oauth_consumer_secret + "&code=" + code;
		try{
			HttpClient client = new HttpClient();
			GetMethod get = new GetMethod( req_url );
			int sc = client.executeMethod( get );
			String body = get.getResponseBodyAsString();
			if( sc == 200 ){
				String[] stmp1 = body.split( "&" );
				for( int i = 0; i < stmp1.length; i ++ ){
					String[] stmp2 = stmp1[i].split( "=" );
					if( stmp2[0].equals( "access_token" ) ){
						access_token = stmp2[1];
						session.setAttribute( "access_token", access_token );
						Long userid = GetUserid( session );
						if( userid != null && userid > 0 ){
							String name = ( String )session.getAttribute( "username" );
							session.setAttribute( "user_id", userid );
							session.setAttribute( "username", name );
						}
					}
				}
			}
			
			if( access_token != null ){
				//. 期間延長
				req_url = "https://graph.facebook.com/oauth/access_token?client_id="
						+ oauth_consumer_key
						+ "&client_secret="
						+ oauth_consumer_secret
						+ "&grant_type=fb_exchange_token"
						+ "&fb_exchange_token=" + access_token;
						//+ "&fb_exchange_token=EXISTING_ACCESS_TOKEN";

				get = new GetMethod( req_url );
				sc = client.executeMethod( get );
				body = get.getResponseBodyAsString();
				if( sc == 200 ){
					String[] stmp1 = body.split( "&" );
					for( int i = 0; i < stmp1.length; i ++ ){
						String[] stmp2 = stmp1[i].split( "=" );
						if( stmp2[0].equals( "access_token" ) ){
							access_token = stmp2[1];
						}
					}
				}
			}
		}catch( Exception e ){
			e.printStackTrace();
		}

		return access_token;
	}
	
	public Long GetUserid( HttpSession session ){
		Long userid = 0L;
		Long uid = -1L;
		
		try{
			String uid_ = ( String )session.getAttribute( "user_id" );
			uid = Long.parseLong( uid_ );
		}catch( Exception e ){
		}
		
		if( uid != null && uid > 0 ){
			userid = uid;
		}else{
			try{
				String access_token = ( String )session.getAttribute( "access_token" );
				if( access_token != null && access_token.length() > 0 ){
					DefaultFacebookClient fbc = new DefaultFacebookClient( access_token );
					JsonObject me = fbc.fetchObject( "/me", JsonObject.class );
					String id = me.getString( "id" );
					String name = me.getString( "name" );
					try{
						userid = Long.parseLong( id );
						if( userid > 0 ){
							session.setAttribute( "user_id", userid );
						}
					}catch( Exception e ){
					}
					
					if( name != null && name.length() > 0 ){
						session.setAttribute( "username", name );
					}
				}
			}catch( Exception e ){
				log.warning( "" + e );
				e.printStackTrace();
			}
		}
		
		return userid;
	}

	
	public String GetProfileImageURL( Long userid ){
		String imageurl = "";
		
		try{
			if( userid > 0 ){
				imageurl = "https://graph.facebook.com/" + userid + "/picture";
			}
		}catch( Exception e ){
			e.printStackTrace();
		}
		
		return imageurl;
	}
	
	public Long GetUseridFromSession( HttpSession session ){
		Long userid = 0L;
		
		try{
			userid = ( Long )session.getAttribute( "user_id" );
		}catch( Exception e ){
		}

		return userid;
	}

	public String GetUsernameFromSession( HttpSession session ){
		String username = "";
		
		try{
			username = ( String )session.getAttribute( "username" );
		}catch( Exception e ){
		}

		return username;
	}
}
