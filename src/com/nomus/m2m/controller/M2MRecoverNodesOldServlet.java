package com.nomus.m2m.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Session;
import org.hibernate.internal.SessionImpl;

import com.nomus.m2m.dao.HibernateSession;


@WebServlet("/m2m/m2mrecovernodesold")
public class M2MRecoverNodesOldServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public M2MRecoverNodesOldServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		Connection con=null;
		Statement st=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		PreparedStatement ps1=null;
		Session hibsession = null;
		try
		{
			hibsession = HibernateSession.getDBSession();
			con = ((SessionImpl)hibsession).connection();
			con.setAutoCommit(false);
			String sql = "slnumber,id from Nodedetails";
			st = con.createStatement();
			rs = st.executeQuery(sql);
			String slnumber = "";
			int nodeid = 0;
			String update_qry = "update Nodedetails set status=? where slnumber=?";
			String insert_qry = "insert into m2mnodeoutages (nodeid,slnumber,downtime,severity) values (?,?,?,?)";
			final String check_str = "check";
			ps = con.prepareStatement(update_qry);
			ps1 = con.prepareStatement(insert_qry);
			boolean batch_added = false;
			while(rs.next())
			{
				slnumber = rs.getString(1);
				nodeid = rs.getInt(2);
				if(request.getParameter(check_str+slnumber) != null)
				{
					ps.setString(1,"down");
					ps.setString(2, slnumber);
					ps.addBatch();

					ps1.setInt(1, nodeid);
					ps1.setString(2,slnumber);
					ps1.setTimestamp(3,new Timestamp(Calendar.getInstance().getTimeInMillis()));
					ps1.setString(4,"major");
					ps1.addBatch();
					batch_added = true;
				}
			}
			if(batch_added)
			{
				ps.executeBatch();
				ps1.executeBatch();
			}
			con.commit();
		}
		catch(Exception e) {
			try
			{
				con.rollback();
			}
			catch(Exception ec)
			{
				ec.printStackTrace();
			}
			e.printStackTrace();
		}   
		finally
		{
			if(hibsession != null)
				hibsession.close();
			try {
				if(rs != null)
					rs.close();
				if(st != null)
					st.close();
				if(ps != null)
					ps.close();
				if(ps1 != null)
					ps1.close();
			}
			catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}
		}
		response.sendRedirect("/imission/index.jsp?type=down&lisubmenu=Down");
	}

}
