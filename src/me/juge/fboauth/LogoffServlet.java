package me.juge.fboauth;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class LogoffServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		try {
			HttpSession session = req.getSession();
			session.setAttribute("access_token", "");
			session.setAttribute("user_id", "");
			session.setAttribute("username", "");
		} catch (Exception e) {
			e.printStackTrace();
		}

		res.sendRedirect("./");
	}
}
