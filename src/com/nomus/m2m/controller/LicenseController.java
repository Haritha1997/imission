package com.nomus.m2m.controller;

import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.google.LicenseValidator;

import com.nomus.m2m.dao.LicDao;
import com.nomus.m2m.pojo.License;
import com.nomus.staticmembers.DateTimeUtil;

/**
 * Servlet implementation class LicenseController
 */
@WebServlet("/LicenseValidate")
public class LicenseController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LicenseController() {
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
		String orgname = request.getParameter("orgname") == null ? "":request.getParameter("orgname");
		String location = request.getParameter("location") == null ? "":request.getParameter("location");
		String expdate = request.getParameter("expdate") == null ? "":request.getParameter("expdate");
		//String macaddr = request.getParameter("macaddr") == null ? "":request.getParameter("macaddr");
		String lickey = request.getParameter("key") == null ? "" :request.getParameter("key");
		String  nodelimit = request.getParameter("nodelimit") == null ? "":request.getParameter("nodelimit").trim();
		String url = "license.jsp";
		LicenseValidator lvalid = new LicenseValidator();
		try {
			if(lvalid.validateLicense(orgname, location, "validate", expdate, lickey,nodelimit))
			{
				LicDao ldao = new LicDao();
				License lic = ldao.getLicenseDetails();
				boolean add  = false;
				Date curdate = new Date();
				if(lic == null)
				{
					lic = new License();
					lic.setCurrentDate(curdate);
					add = true;
				}
				lic.setOrgName(orgname);
				lic.setLocation(location);
				lic.setLicGenDate(DateTimeUtil.getOnlyDate(curdate));
				lic.setValidUpTo(DateTimeUtil.getDate(expdate));
				lic.setKey(lickey);
				lic.setStatus("V");
				lic.setNodeLimit(Integer.parseInt(nodelimit));
				
				if(add)
					ldao.addLicense(lic);
				else
					ldao.updateLicense(lic);
					
				request.getSession().setAttribute("msg", "License update Success.");
			}
			else
				request.getSession().setAttribute("msg", "License invalid/expired.");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
		
		response.sendRedirect(url);
	}

}
