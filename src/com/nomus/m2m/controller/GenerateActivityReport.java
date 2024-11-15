package com.nomus.m2m.controller;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Session;
import org.hibernate.internal.SessionImpl;

import com.nomus.m2m.dao.HibernateSession;
import com.nomus.m2m.reporttools.GenerateReportFormat;

/**
 * Servlet implementation class GenerateActivityReport
 */
@WebServlet("/activity/generateActivityReport")
public class GenerateActivityReport extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GenerateActivityReport() {
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
		String activitytype = request.getParameter("activitytype");
		String reportid = request.getParameter("reportid");
		HashMap<String, Object> parameters = new HashMap<String, Object>();
		if (activitytype.equals("edit"))
			activitytype = "Edit','Export";
		parameters.put("type", activitytype);
		parameters.put("reportid", Integer.parseInt(reportid));
		Connection con = null;
		Session hibsession = null;

		try {
			hibsession = HibernateSession.getDBSession();
			con = ((SessionImpl) hibsession).connection();
			String rep_path = getServletContext().getRealPath("report-templates");
			File reportFile = new File(rep_path+ File.separator + "activityreport.jasper");
			byte[] bytes = GenerateReportFormat.getReportInBytes(reportFile.getPath(), parameters, con, reportFile);
			response.setContentType("application/pdf;charset=UTF-8");
			response.setContentLength(bytes.length);
			ServletOutputStream outStream = response.getOutputStream();
			outStream.write(bytes, 0, bytes.length);
			outStream.flush();
			outStream.close();
			//return;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (hibsession != null) {
				hibsession.disconnect();
				hibsession.close();			
			}
		}
	}

}
