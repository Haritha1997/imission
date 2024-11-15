package com.nomus.m2m.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.nomus.m2m.dao.OrganizationDao;
import com.nomus.m2m.pojo.Organization;

/**
 * Servlet implementation class SaveOrganization
 */
@WebServlet("/organization/organizationContoller")
public class OrganizationControllerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OrganizationControllerServlet() {
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
		Organization org = new Organization();
		String orgid = request.getParameter("updateorgid")==null?"":request.getParameter("updateorgid"); 
		String action = request.getParameter("action");
		org.setName(request.getParameter("org_name").trim());
		org.setAddress(request.getParameter("org_address").trim());
		String status="Organization "+org.getName()+" is already exists";
		org.setStatus("active");
		OrganizationDao orgdao = new OrganizationDao();
		Organization oldorg = orgdao.getOrganization(org.getName());
		if(oldorg == null || (oldorg.getId()+"").equals(orgid.trim()))
		{
			if(action.equals("save") && oldorg == null)
			{
				if(orgdao.addOrganization(org))
					status = "Organization "+org.getName()+" saved successfully.";
				else
					status = "Save failed.";
			}
			else
			{
				org.setId(Integer.parseInt(orgid.trim()));
				if(action.equals("delete"))
					org.setStatus("inactive");
				
				if(orgdao.updateOrganization(org))
					status = action.equals("delete")?"Deleted Successfully":"Updated successfully.";
				else
					status = action.equals("delete")?"Delete failed":"Update failed.";
			}
		}
		response.sendRedirect("organizationlist.jsp?status="+status);	
	}
}
