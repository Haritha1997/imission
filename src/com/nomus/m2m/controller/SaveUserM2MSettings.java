package com.nomus.m2m.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.nomus.m2m.dao.M2MDetailsDao;
import com.nomus.m2m.dao.OrganizationDao;
import com.nomus.m2m.pojo.M2MDetails;
import com.nomus.m2m.pojo.Organization;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.M2MProperties;

/**
 * Servlet implementation class SaveUserM2MSettings
 */
@WebServlet("/m2m/saveuserm2msettings")
public class SaveUserM2MSettings extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SaveUserM2MSettings() {
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
		String message = "";
		try{
			User loguser = (User)request.getSession().getAttribute("loggedinuser");
			Organization org = loguser.getOrganization();
			M2MDetailsDao m2mdao = new M2MDetailsDao();
		  	M2MDetails m2mdls = m2mdao.getM2MDetails(1);
			org.setRefresh(request.getParameter("selrefresh").toString());
			org.setRefreshTime(Integer.parseInt(request.getParameter("refreshtime")));
			m2mdls.setUsername(request.getParameter("email").toString());
			m2mdls.setPassword(request.getParameter("pwd").toString());
			m2mdls.setSmtptport(Integer.parseInt(request.getParameter("smtpport")));
			m2mdls.setSmtpserver(request.getParameter("smtpserver").toString());
			OrganizationDao orgdao = new OrganizationDao();
			if(orgdao.updateOrganization(org)&&m2mdao.updateM2MDetails(m2mdls))
				message = "User M2M Settings are saved successfully.";
			else
				message = "Failed to Save.";
			M2MProperties.loadM2MProperties();
		} catch (Exception e) {
			message = "Failed to Save.";
			e.printStackTrace();
		}
		finally{
		}
		response.sendRedirect("/imission/message.jsp?status="+message);
	}
}
