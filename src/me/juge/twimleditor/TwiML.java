package me.juge.twimleditor;

import java.util.Date;

public class TwiML {
	private int id;
	private String title;
	private String userid;
	private String username;
	private int is_public;
	private String twiml;
	private Date created;
	private Date updated;

	public TwiML( int id, String title, String userid, String username, int is_public, String twiml, Date created, Date updated ){
		this.id = id;
		this.userid = userid;
		this.title = title;
		this.username = username;
		this.is_public = is_public;
		this.twiml = twiml;
		this.created = created;
		this.updated = updated;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTwiml() {
		return getTwiml( false );
	}

	public String getTitle() {
		return getTitle( false );
	}
	
	public String getTitle( boolean sanitize ){
		String t = title;
		if( sanitize ){
			t = t.replaceAll( "&", "&amp;" );
			t = t.replaceAll( "<", "&lt;" );
			t = t.replaceAll( ">", "&gt;" );
			t = t.replaceAll( "\"", "&quot;" );
			t = t.replaceAll( "'", "&apos;" );
		}
		return t;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getTwiml( boolean sanitize ) {
		String t = twiml;
		if( sanitize ){
			t = t.replaceAll( "&", "&amp;" );
			t = t.replaceAll( "<", "&lt;" );
			t = t.replaceAll( ">", "&gt;" );
			t = t.replaceAll( "\"", "&quot;" );
			t = t.replaceAll( "'", "&apos;" );
		}
		return t;
	}

	public void setTwiml(String twiml) {
		setTwiml( twiml, false );
	}
	
	public void setTwiml(String twiml, boolean rev_sanitize ) {
		String t = twiml;
		if( rev_sanitize ){
			t = t.replaceAll( "&apos;", "'" );
			t = t.replaceAll( "&quot;", "\"" );
			t = t.replaceAll( "&gt;", ">" );
			t = t.replaceAll( "&lt;", "<" );
			t = t.replaceAll( "&amp;", "&" );
		}
		
		this.twiml = t;
	}

	public String getUsername() {
		return getUsername(false);
	}

	public String getUsername(boolean sanitize) {
		String u = username;
		if( sanitize ){
			u = u.replaceAll( "&", "&amp;" );
			u = u.replaceAll( "<", "&lt;" );
			u = u.replaceAll( ">", "&gt;" );
			u = u.replaceAll( "\"", "&quot;" );
			u = u.replaceAll( "'", "&apos;" );
		}
		return u;
	}

	public void setUsername(String username) {
		setUsername(username,false);
	}
	public void setUsername(String username, boolean rev_sanitize) {
		String u = username;
		if( rev_sanitize ){
			u = u.replaceAll( "&apos;", "'" );
			u = u.replaceAll( "&quot;", "\"" );
			u = u.replaceAll( "&gt;", ">" );
			u = u.replaceAll( "&lt;", "<" );
			u = u.replaceAll( "&amp;", "&" );
		}
		
		this.username = u;
	}

	
	public int getIs_public() {
		return is_public;
	}

	public void setIs_public(int is_public) {
		this.is_public = is_public;
	}

	public Date getCreated() {
		return created;
	}

	public void setCreated(Date created) {
		this.created = created;
	}

	public Date getUpdated() {
		return updated;
	}

	public void setUpdated(Date updated) {
		this.updated = updated;
	}
	
	
}
