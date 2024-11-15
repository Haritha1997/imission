package com.nomus.m2m.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.nomus.m2m.dao.M2MSchReportsDao;

/**
 * Servlet implementation class DeleteScheduleReportsController
 */
@WebServlet("/report/deleteScheduleReports")
public class DeleteScheduleReportsController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteScheduleReportsController() {
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
		//String limitstr = (request.getParameter("limit") == null ? "20" : request.getParameter("limit"));
		String ids = request.getParameter("ids");
		M2MSchReportsDao schrepdao = new M2MSchReportsDao();
		schrepdao.deleteSchduleReports(ids);
		response.sendRedirect("scheduledreportlist.jsp");
	}

}
