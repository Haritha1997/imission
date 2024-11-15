package com.nomus.m2m.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class DeleteScheduleReportsController
 */
@WebServlet("/user/getAdminProps")
public class GetAdminPropsController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetAdminPropsController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String source = "newUser.jsp?action=new";
		if(request.getParameter("action").trim().equals("modify"))
			source = "modifyUser.jsp?userID="+request.getParameter("userid");
		HttpSession session = request.getSession();
		
		session.setAttribute("username", request.getParameter("username")==null?"":request.getParameter("username"));
		session.setAttribute("pass1", request.getParameter("pass1")==null?"":request.getParameter("pass1"));
		session.setAttribute("pass2", request.getParameter("pass2")==null?"":request.getParameter("pass2"));
		session.setAttribute("email", request.getParameter("email")==null?"":request.getParameter("email"));
		session.setAttribute("sel_role", request.getParameter("sel_role")==null?"":request.getParameter("sel_role"));
		session.setAttribute("under", request.getParameter("under")==null?"":request.getParameter("under"));
		response.sendRedirect(source);
	}

}
