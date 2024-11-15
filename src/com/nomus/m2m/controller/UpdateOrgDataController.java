package com.nomus.m2m.controller;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.nomus.m2m.dao.LoadBatchDao;
import com.nomus.m2m.pojo.LoadBatch;
import com.nomus.m2m.pojo.OrganizationData;
import com.nomus.staticmembers.DateTimeUtil;

/**
 * Servlet implementation class UpdateOrgDataController
 */
@WebServlet("/account/UpdateOrganizationData")
public class UpdateOrgDataController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UpdateOrgDataController() {
		super();
		// TODO Auto-generated constructor stub
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		// TODO Auto-generated method stub
		//String status ;
		HttpSession httpsession = request.getSession();
		String selbatchid = request.getParameter("uporgbatname");
		String selvalidupto = request.getParameter("batch_validupto");
		Date validuptodate = DateTimeUtil.getDate(selvalidupto);
		LoadBatchDao batchdao = new LoadBatchDao();
		try
		{
			LoadBatch batch = batchdao.getLoadBatch(Integer.parseInt(selbatchid.trim()));
			batch.setValidUpTo(validuptodate);
			List<OrganizationData> orgdatalist = batch.getOrgdatalist();
			for(OrganizationData orgdata : orgdatalist)
				orgdata.setValidUpto(batch.getValidUpTo());
			batchdao.updateLoadBatch(batch); 
			httpsession.setAttribute("status", "The Batch "+batch.getBatchName()+" of organization "+batch.getOrganization().getName()+" is Updated Successfully.");
		}
		catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			//status = "Save failed. Please Try Again";
			httpsession.setAttribute("status", "Update Failed..., Please Try Again");
		}
		response.sendRedirect("index.jsp");
	}
}
