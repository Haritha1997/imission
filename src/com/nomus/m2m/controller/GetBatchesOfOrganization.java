package com.nomus.m2m.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.nomus.m2m.dao.OrganizationDao;
import com.nomus.m2m.pojo.LoadBatch;
import com.nomus.m2m.pojo.Organization;

/**
 * Servlet implementation class GetBatchesOfOrganization
 */
@WebServlet("/account/getBatches")
public class GetBatchesOfOrganization extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetBatchesOfOrganization() {
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
		String orgid = request.getParameter("select_org");
		OrganizationDao orgdao = new OrganizationDao();
		Organization orgobj = orgdao.getOrganization(Integer.parseInt(orgid.trim()) );
		List<LoadBatch> batchlist = orgobj.getLoadBatchList();
		HttpSession session = request.getSession();
		session.setAttribute("orgbatchlist", batchlist);
		session.setAttribute("selorg", orgobj.getId());
		response.sendRedirect("index.jsp");
	}

}
