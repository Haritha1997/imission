package com.nomus.m2m.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.nomus.m2m.dao.UserDao;
import com.nomus.m2m.pojo.User;

/**
 * Servlet implementation class SaveFavourites
 */
@WebServlet("/savefavourites")
public class SaveFavourites extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SaveFavourites() {
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
		String[] slnums = request.getParameterValues("favourites");
		List<String> favlist = new ArrayList<String>();
		if(slnums != null)
		for(String slnum : slnums)
			favlist.add(slnum);
		User loggedinuser = (User) request.getSession().getAttribute("loggedinuser");
		loggedinuser.setFavouriteList(favlist);
		UserDao udao = new UserDao();
		udao.updateUser(loggedinuser);
		response.sendRedirect("dashboard.jsp");
	}
}
