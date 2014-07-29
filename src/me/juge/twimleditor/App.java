package me.juge.twimleditor;

import java.io.StringReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;

public class App {
	private static final Logger log = Logger.getLogger( App.class.getName() );

	private int debugLevel = 0; //. 0:本番, 1:自宅, 2:外
	private String DBSERVER = "(SQL DB Server hostname)";
	private int DBPORT = 50000;
	private String DBNAME = "(DB name)";
	private String DBUSERNAME = "(username)";
	private String DBPASSWORD = "(password)";

	
	public App(){
	}

	
	public int deleteTwiML( int id, String userid ){
		int r = -1;
		
		if( id > 0 ){
			Connection conn = null;
			if( ( conn = getConnection() ) != null ){
				try{
					Statement stmt = conn.createStatement();

					String sql = "delete twimls where id = " + id + " and userid = '" + userid + "'";
					r = stmt.executeUpdate( sql );
					
					stmt.close();
					conn.close();
				}catch( Exception e ){
					e.printStackTrace();
				}
			}
		}

		return r;
	}
	
	public int insertTwiML( String title, String userid, String username, int is_public, String twiml ){
		int r = -1;
		
		//. twiml のバリデーション
		if( isValidXML( twiml ) ){
			twiml = twiml.replaceAll( "'", "\"" );
			
			Connection conn = null;
			if( ( conn = getConnection() ) != null ){
				try{
					Statement stmt = conn.createStatement();

					String sql = "insert into twimls( title, userid, username, is_public, twiml, created, updated ) values( '" + title + "', '" + userid + "', '" + username + "', " + is_public + ", '" + twiml + "', current timestamp, current timestamp)";
					r = stmt.executeUpdate( sql );
					if( r > 0 ){
						sql = "select max(id) from twimls";
						ResultSet rs = stmt.executeQuery( sql );
						while( rs.next() ){
							r = rs.getInt( 1 );
						}
					}
					
					stmt.close();
					conn.close();
				}catch( Exception e ){
					e.printStackTrace();
				}
			}
		}

		return r;
	}

	public int updateTwiML( int id, String title, String userid, String username, int is_public, String twiml ){
		int r = -1;
		
		//. twiml のバリデーション
		if( isValidXML( twiml ) ){
			twiml = twiml.replaceAll( "'", "\"" );
			
			Connection conn = null;
			if( ( conn = getConnection() ) != null ){
				try{
					Statement stmt = conn.createStatement();

					String sql = "update twimls set title = '" + title + "', username = '" + username + "', is_public = " + is_public + ", twiml = '" + twiml + "', updated = current timestamp where id = " + id + " and userid = '" + userid + "'";
					r = stmt.executeUpdate( sql );
					
					stmt.close();
					conn.close();
				}catch( Exception e ){
					e.printStackTrace();
				}
			}
		}

		return r;
	}

	
	public TwiML[] selectTwiML(){
		return selectTwiML( ( String )null, ( String )null );
	}

	public TwiML[] selectTwiML( String voice ){
		return selectTwiML( "voice", voice );
	}
	
	public TwiML[] selectTwiML( String key, String value ){
		String[] keys = null;
		String[] values = null;
		if( key != null && key.length() > 0 && value != null && value.length() > 0 ){
			keys = new String[]{ key };
			values = new String[]{ value };
		}
		
		return selectTwiML( keys, values );
	}
	
	public TwiML[] selectTwiML( String[] keys, String[] values ){
		TwiML[] r = null;
				
		Connection conn = null;
		if( ( conn = getConnection() ) != null ){
			List<TwiML> list = new ArrayList<TwiML>();
			try{
				Statement stmt = conn.createStatement();

				String sql = "select * from twimls";
				String user_cond = " is_public = 1";
				boolean onlymine = false;
				if( keys != null && values != null && keys.length > 0 && values.length > 0 ){
					String where = ""; //" where";
					for( int i = 0; i < keys.length; i ++ ){
						String x = "";
						if( keys[i].equals( "q" ) ){
							x = " xmlexists('$t/Response/Say[" + keys[i] + "=\"" + values[i] + "\"]' passing twimls.twiml as \"t\")";
							where += ( " and" + x );
						}else if( keys[i].equals( "onlymine" ) ){
							onlymine = true;
						}else if( keys[i].equals( "userid" ) ){
							if( onlymine ){
								user_cond = " userid = '" + values[i] + "'";
							}else{
								user_cond = " ( is_public = 1 or userid = '" + values[i] + "')";
							}
						}else{
							x = " xmlexists('$t/Response/Say[@" + keys[i] + "=\"" + values[i] + "\"]' passing twimls.twiml as \"t\")";
							where += ( " and" + x );
						}
					}
					sql += ( " where" + user_cond );
					sql += ( where );
				}
				
				//System.out.println( "sql = " + sql );
				ResultSet rs = stmt.executeQuery( sql );
				while( rs.next() ){
					int id = rs.getInt( 1 );
					String title = rs.getString( 2 );
					String userid = rs.getString( 3 );
					String username = rs.getString( 4 );
					int is_public = rs.getInt( 5 );
					String twiml = rs.getString( 6 );
					Date created = rs.getDate( 7 );
					Date updated = rs.getDate( 8 );
					TwiML t = new TwiML( id, title, userid, username, is_public, twiml, created, updated );
					list.add( t );
				}
				
				stmt.close();
				conn.close();

				r = ( TwiML[] )list.toArray( new TwiML[0] );
			}catch( Exception e ){
				e.printStackTrace();
			}
		}
			
		//System.out.println( "#r = " + r.length );
		return r;
	}

	public TwiML selectTwiML( int id ){
		TwiML r = null;
				
		Connection conn = null;
		if( id > 0 && ( conn = getConnection() ) != null ){
			try{
				Statement stmt = conn.createStatement();

				String sql = "select * from twimls where id = " + id;
				ResultSet rs = stmt.executeQuery( sql );
				while( rs.next() ){
					String title = rs.getString( 2 );
					String userid = rs.getString( 3 );
					String username = rs.getString( 4 );
					int is_public = rs.getInt( 5 );
					String twiml = rs.getString( 6 );
					Date created = rs.getDate( 7 );
					Date updated = rs.getDate( 8 );

					r = new TwiML( id, title, userid, username, is_public, twiml, created, updated );
				}
				
				stmt.close();
				conn.close();
			}catch( Exception e ){
				e.printStackTrace();
			}
		}
				
		return r;
	}

	
	public int createSample(){
		int r = 0;
		
		Connection conn = null;
		if( ( conn = getConnection() ) != null ){
			try{
				Statement stmt = conn.createStatement();
				
				try{
//					stmt.executeUpdate( "drop table twimls" );

//					stmt.executeUpdate( "create table twimls( id int not null generated always as identity(start with 1 increment by 1 no cache), title varchar(100), userid varchar(20), username varchar(255), is_public int, twiml xml, created timestamp, updated timestamp )" );
				}catch( Exception e ){
				}
				
				try{
					r += stmt.executeUpdate( "insert into twimls( title, userid, username, is_public, twiml, created, updated ) values( 'おもてなし', '', '', 1, '<Response><Say language=\"ja-JP\" voice=\"alice\">お も て な し</Say></Response>', current timestamp, current timestamp )" );
					r += stmt.executeUpdate( "insert into twimls( title, userid, username, is_public, twiml, created, updated ) values( '半沢', '', '', 1, '<Response><Say language=\"ja-JP\" voice=\"alice\">倍返しだ！</Say></Response>', current timestamp, current timestamp )" );
					r += stmt.executeUpdate( "insert into twimls( title, userid, username, is_public, twiml, created, updated ) values( 'Hello(man)', '', '', 1, '<Response><Say language=\"en\" voice=\"man\">Hello. What are you going do today?</Say></Response>', current timestamp, current timestamp )" );
					r += stmt.executeUpdate( "insert into twimls( title, userid, username, is_public, twiml, created, updated ) values( 'Hello(weman)', '', '', 1, '<Response><Say language=\"en\" voice=\"woman\">Hello. What are you going do today?</Say></Response>', current timestamp, current timestamp )" );
					r += stmt.executeUpdate( "insert into twimls( title, userid, username, is_public, twiml, created, updated ) values( 'もも', '', '', 1, '<Response><Say language=\"ja-JP\" voice=\"alice\">もももすもももももはもも</Say></Response>', current timestamp, current timestamp )" );				
					r += stmt.executeUpdate( "insert into twimls( title, userid, username, is_public, twiml, created, updated ) values( 'ジュテーム', '', '', 1, '<Response><Say language=\"fr\" voice=\"woman\">Je t&apos;aime.</Say></Response>', current timestamp, current timestamp )" );
				}catch( Exception e ){
					e.printStackTrace();
				}
				
				stmt.close();
				conn.close();
			}catch( Exception e ){
				e.printStackTrace();
			}
		}
		
		return r;
	}
	
	
	private Connection getConnection(){
		Connection conn = null;
		
		
		//. 接続先情報を確定する
		String jdbcuri = "", dburi = "", dbusername = "", dbpassword = "";
		String env = System.getenv( "VCAP_SERVICES" );
		
		if( env != null && env.length() > 0 ){
//			int n1 = env.indexOf( "BLUAcceleration" );
			int n1 = env.indexOf( "SQLDB" );
			if( n1 > -1 ){
				env = env.substring( n1 );
			}
			
			n1 = env.indexOf( "\"jdbcuri\": \"" );
			if( n1 > -1 ){
				int n2 = env.indexOf( "\"", n1 + 12 );
				if( n2 > n1 + 12 ){
					jdbcuri = env.substring( n1 + 12, n2 );
				}
			}
			
			n1 = env.indexOf( "\"uri\": \"" );
			if( n1 > -1 ){
				int n2 = env.indexOf( "\"", n1 + 8 );
				if( n2 > n1 + 8 ){
					dburi = env.substring( n1 + 8, n2 );
					int n3 = dburi.indexOf( "//" );
					int n4 = dburi.indexOf( "@" );
					if( n3 > -1 && n4 > n3 ){
						dburi = dburi.substring( 0, n3 + 2 ) + dburi.substring( n4 + 1 );
					}
				}
			}
			n1 = env.indexOf( "\"username\": \"" );
			if( n1 > -1 ){
				int n2 = env.indexOf( "\"", n1 + 13 );
				if( n2 > n1 + 13 ){
					dbusername = env.substring( n1 + 13, n2 );
				}
			}
			n1 = env.indexOf( "\"password\": \"" );
			if( n1 > -1 ){
				int n2 = env.indexOf( "\"", n1 + 13 );
				if( n2 > n1 + 13 ){
					dbpassword = env.substring( n1 + 13, n2 );
				}
			}
			
			//. 強制
			dburi = "db2://" + DBSERVER + ":" + DBPORT + "/" + DBNAME;
			jdbcuri = "jdbc:" + dburi;
			dbusername = DBUSERNAME;
			dbpassword = DBPASSWORD;
		}else{
			dburi = "db2://" + DBSERVER + ":" + DBPORT + "/" + DBNAME;
			jdbcuri = "jdbc:" + dburi;
			dbusername = DBUSERNAME;
			dbpassword = DBPASSWORD;
		}
		
		
		//. 当面はこちら
		try{
			//System.out.println( "jdbcuri = " + jdbcuri + ", dbusername = " + dbusername + ", dbpassword = " + dbpassword );
			Class.forName( "com.ibm.db2.jcc.DB2Driver" );
			conn = DriverManager.getConnection( jdbcuri, dbusername, dbpassword );
			
		}catch( Exception e ){
			e.printStackTrace();
		}
		
		return conn;
	}

	private boolean isValidXML( String xml ){
		boolean b = true;
		
		try{
			DocumentBuilderFactory dbfactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = dbfactory.newDocumentBuilder();
			Document xdoc = builder.parse( new InputSource( new StringReader( xml ) ) );
		}catch( Exception e ){
			b = false;
		}
		
		return b;
	}
	
	public TwiML[] searchAvailableTwiML( String _userid ){
		TwiML[] r = null;
				
		Connection conn = null;
		if( ( conn = getConnection() ) != null ){
			List<TwiML> list = new ArrayList<TwiML>();
			try{
				Statement stmt = conn.createStatement();

				String sql = "select * from twimls where is_public = 1";
				if( _userid != null && _userid.length() > 0 ){
					sql += " or userid = '" + _userid + "'";
				}
				//System.out.println( "searchAvailableTwiML: " + sql );
				
				ResultSet rs = stmt.executeQuery( sql );
				while( rs.next() ){
					int id = rs.getInt( 1 );
					String title = rs.getString( 2 );
					String userid = rs.getString( 3 );
					String username = rs.getString( 4 );
					int is_public = rs.getInt( 5 );
					String twiml = rs.getString( 6 );
					Date created = rs.getDate( 7 );
					Date updated = rs.getDate( 8 );
					TwiML t = new TwiML( id, title, userid, username, is_public, twiml, created, updated );
					list.add( t );
				}
				
				stmt.close();
				conn.close();

				r = ( TwiML[] )list.toArray( new TwiML[0] );
			}catch( Exception e ){
				e.printStackTrace();
			}
		}
				
		return r;
	}

	public boolean isEditable( int id, String userid ){
		TwiML twiml = selectTwiML( id );
		return isEditable( twiml, userid );
	}
	
	public boolean isEditable( TwiML twiml, String userid ){
		boolean r = false;
		
		if( twiml != null && userid != null && userid.length() > 0 ){
			String uid = twiml.getUserid();
			r = ( uid.equals( userid ) );
		}
		
		return r;
	}
}
