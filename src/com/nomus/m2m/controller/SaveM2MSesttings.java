package com.nomus.m2m.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.nomus.m2m.dao.M2MDetailsDao;
import com.nomus.m2m.pojo.M2MDetails;
import com.nomus.staticmembers.FileCreatetor;
import com.nomus.staticmembers.M2MProperties;

/**
 * Servlet implementation class SaveM2MSesttings
 */
@WebServlet("/m2m/savem2msettings")
public class SaveM2MSesttings extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SaveM2MSesttings() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		/*
		 * BufferedWriter bw = null; FileWriter fw = null;
		 */
		M2MDetails m2mdata = new M2MDetails();
		String message = "";
		M2MDetailsDao m2mdatadao = new M2MDetailsDao();
		List<M2MDetails> m2mlist = m2mdatadao.getM2MDetailsList();
		try {
			if (m2mlist.size() < 1)
			{
				m2mdata.setPort(Integer.parseInt(request.getParameter("port").trim()));
				m2mdata.setHttpserverpath(request.getParameter("httpserverpath").trim());
				m2mdata.setTlsconfigspath(request.getParameter("tlsconfigspath").trim());
				m2mdata.setFirmwaredir(request.getParameter("firmwaredir").trim());


				m2mdata.setEnabledebug("no");
				m2mdata.setReadtimeout(Integer.parseInt(request.getParameter("readtimeout").trim()));
				m2mdata.setDaysforinactive(Integer.parseInt(request.getParameter("daysforinactive")));
				if (m2mdatadao.addM2MDetails(m2mdata)) {
					message += "M2M Settings are saved successfully.";
				} else
					message += "Save failed!";
			} else {
				M2MDetails updatem2m = m2mlist.get(0);
				updatem2m.setPort(Integer.parseInt(request.getParameter("port").trim()));
				updatem2m.setHttpserverpath(request.getParameter("httpserverpath").trim());
				updatem2m.setTlsconfigspath(request.getParameter("tlsconfigspath").trim());
				updatem2m.setFirmwaredir(request.getParameter("firmwaredir").trim());

				// updatem2m.setTargetfilename(request.getParameter("targetfilename").trim());
				// updatem2m.setVersionfile(request.getParameter("versionfile").trim());

				// updatem2m.setEnabledebug(request.getParameter("enabledebug").trim());
				updatem2m.setReadtimeout(Integer.parseInt(request.getParameter("readtimeout").trim()));
				updatem2m.setDaysforinactive(Integer.parseInt(request.getParameter("daysforinactive")));
				/*
				 * updatem2m.setUsername(request.getParameter("mailusername"));
				 * updatem2m.setPassword(request.getParameter("mailpassword"));
				 */
				File tlsconf_file =  new File(request.getParameter("tlsconfigspath").trim());
				FileCreatetor.createFile(tlsconf_file);
				File fw_file = new File(request.getParameter("firmwaredir").trim());
				FileCreatetor.createFile(fw_file);
				File http_file = new File(request.getParameter("httpserverpath").trim());
				FileCreatetor.createFile(http_file);
				if (m2mdatadao.updateM2MDetails(updatem2m))
					message += "M2M Settings are Saved successfully.";
				else
					message += "Save failed!";
				
				M2MProperties.loadM2MProperties();

			}
		} catch (Exception e) {
			message = "Failed to Save.";
			e.printStackTrace();
		}
		/*
		 * finally{ if(bw != null) bw.close(); if(fw != null) fw.close(); }
		 */
		// response.sendRedirect("m2msettings.jsp");
		response.sendRedirect("/imission/message.jsp?status=" + message);
	}

}
