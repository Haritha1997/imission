package com.nomus.m2m.controller;

import java.io.IOException;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.nomus.m2m.dao.M2MSchReportsDao;
import com.nomus.m2m.pojo.M2MSchReports;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.DateTimeUtil;

/**
 * Servlet implementation class ScheduleReportController
 */
@WebServlet("/report/saveschedulereport")
public class ScheduleReportController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ScheduleReportController() {
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
		User user = (User) request.getSession().getAttribute("loggedinuser");
		String reportid = request.getParameter("reportid").replace("local_", "");
		String format = request.getParameter("format")==null?"PDF":request.getParameter("format");
		String parameter = request.getParameter("choose")==null?"slnumber":request.getParameter("choose");
		String paramvalue = request.getParameter("chooseinput")==null?"":request.getParameter("chooseinput");
		String nodetype = request.getParameter("param_nodesel")==null?"all":request.getParameter("param_nodesel");
		String timeperiod = request.getParameter("param_timeperiod")==null?"today":request.getParameter("param_timeperiod");
		String fromdate = request.getParameter("fromdate")==null?"":request.getParameter("fromdate");
		String todate = request.getParameter("todate")==null?"":request.getParameter("todate");
		String orderby = request.getParameter("orderby")==null?"slnumber":request.getParameter("orderby");
		String ordertype = request.getParameter("ordertype")==null?"asc":request.getParameter("ordertype");
		String email = request.getParameter("param_email")==null?"asc":request.getParameter("param_email");

		try
		{
			M2MSchReports m2mreport = new M2MSchReports();
			Timestamp triggertime = DateTimeUtil.getNextTriggerTime(timeperiod);
			/*String qry = "insert into m2mschreports (name, format,input,value,nodetype," + 
					"timeperiod,orderby,ordertype,nextfiretime,fromdate,todate,email) values ('"+reportid+"','"+format+"',"
					+ "'"+parameter+"','"+paramvalue+"','"+nodetype+"','"+timeperiod+"',"
					+ "'"+orderby+"','"+ordertype+"','"+triggertime+"','"+fromdate+"','"+todate+"','"+email+"')";*/
			m2mreport.setName(reportid);
			m2mreport.setFormat(format);
			m2mreport.setInput(parameter);
			m2mreport.setValue(paramvalue);
			m2mreport.setNodetype(nodetype);
			m2mreport.setTimeperiod(timeperiod);
			m2mreport.setOrderby(orderby);
			m2mreport.setOrdertype(ordertype);
			m2mreport.setNextfiretime(triggertime);
			m2mreport.setFromdate(fromdate);
			m2mreport.setTodate(todate);
			m2mreport.setEmail(email);
			m2mreport.setUser(user);
			m2mreport.setOrganization(user.getOrganization().getName());
			m2mreport.setSuperior(user.getUnder());
			M2MSchReportsDao schdao = new M2MSchReportsDao();
			schdao.saveReport(m2mreport);
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally
		{

		}
		response.sendRedirect("scheduledreportlist.jsp");

	}

}
