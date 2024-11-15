package com.nomus.m2m.controller;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.hibernate.Session;
import org.hibernate.internal.SessionImpl;

import com.nomus.m2m.dao.HibernateSession;
import com.nomus.m2m.pojo.User;
import com.nomus.m2m.reporttools.GenerateReportFormat;
import com.nomus.staticmembers.DateTimeUtil;
import com.nomus.staticmembers.QueryGenerator;
import com.nomus.staticmembers.UserRole;

@WebServlet("/report/runreport")
public class RunReportController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public RunReportController() {
		super();
		// TODO Auto-generated constructor stub

	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String url = request.getRequestURL().toString();
		url = url.substring(0, url.lastIndexOf("/"));
		String rep_path = getServletContext().getRealPath("report-templates");
		String reportid = request.getParameter("reportid");
		String format = request.getParameter("format");
		User loguser = (User) request.getSession().getAttribute("loggedinuser");
		Connection con = null;
		Session hibsession = null;
		SessionImpl sesimpl = null;
		Map<String, Object> parameters = new HashMap<String, Object>();
		try {
			hibsession = HibernateSession.getDBSession();
			sesimpl = (SessionImpl) hibsession;
			con = sesimpl.connection();
			Statement st = null;
			ResultSet rs = null;
			XSSFWorkbook workbook = null;
			String slnumstr = QueryGenerator.getSlNumberStr(loguser);
			String locstr = QueryGenerator.getLocationsStr(loguser);
			String merged_qry = "prefix.organization ='" + loguser.getOrganization().getName() + "'";
			boolean and_added = false;
			if(!loguser.getRole().equals(UserRole.SUPERADMIN))
			{
				if (slnumstr.length() > 0) {
					and_added = true;
					merged_qry += "and ( " + slnumstr;
				}
				if (locstr.length() > 0) {
					if (!and_added)
						merged_qry += "and ";
					else
						merged_qry += "or";
					merged_qry += locstr;
				}
				if (slnumstr.length() > 0)
					merged_qry += ")";
			}
			if (reportid.equals("local_Inventory-Report")) {

				if (format.equals("EXCEL")) {
					try {
						String[] header = { "Node Name", "Connected IP", "Serial Number", "Firmware Version", "Location",
								"Module Name", "Module Revision", "Discovered At", "Status" };
						String qry = "select nodelabel ,ipaddress, slnumber , fwversion,"
								+ "location, modulename, revision, createdtime, status from  Nodedetails where "+merged_qry.replace("prefix.", "")+" order by slnumber";
						st = con.createStatement();
						rs = st.executeQuery(qry);
						workbook = GenerateReportFormat.getWorkBook(header, rs, "InventoryReport","");
					} catch (Exception e) {
						// TODO: handle exception
					} finally {
						if (hibsession != null)
							hibsession.close();						if (st != null)
							st.close();
						if (rs != null)
							rs.close();
					}
					response.setContentType("application/vnd.ms-excel");
					response.setHeader("Content-disposition", "inline; filename=Inventory-Reports.xlsx");
					workbook.write(response.getOutputStream());
					response.getOutputStream().close();

				} else if (format.equals("PDF")) {
					File reportFile = new File(rep_path + File.separator + "InventoryReport.jasper");
					String merge_qry = merged_qry.replace("prefix.", "");
					parameters.put("mergeqry", merge_qry);
					// byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(),
					// parameters, con);

					byte[] bytes = GenerateReportFormat.getReportInBytes(reportFile.getPath(), parameters, con,
							reportFile);
					if (hibsession != null)
						hibsession.close();
					response.setContentType("application/pdf;charset=UTF-8");
					response.setContentLength(bytes.length);
					ServletOutputStream outStream = response.getOutputStream();
					outStream.write(bytes, 0, bytes.length);
					outStream.flush();
					outStream.close();
				}

			} else if (reportid.equals("local_Device-Uptime")) {
				Date date = new Date();
				String curdate_str = DateTimeUtil.getDateString(DateTimeUtil.getOnlyDate(date));
				if (format.equals("EXCEL")) {
					String nodesel = request.getParameter("nodesel");
					if (nodesel.equals("all") || nodesel.equals("single"))
						nodesel = "'up','down','inactive'";
					else if (nodesel.equals("down"))
						nodesel = "'down','inactive'";
					else
						nodesel = "'" + nodesel + "'";

					String choose = request.getParameter("choose");
					String input = "'%" + request.getParameter("chooseinput") + "%'";
					String period = request.getParameter("timeperiod");
					String fromdate = "";
					String todate = "";
					Vector<String> datesvec;
					if (!period.equals("custom") && !period.equals("today")) {
						datesvec = getdates(period);
						fromdate = datesvec.get(0);
						todate = datesvec.get(1);
						todate = curdate_str.equals(todate) ? DateTimeUtil.getDateTimeStringIn24hFormat(date) : DateTimeUtil.getDateString(DateTimeUtil.getOnlyDate(DateTimeUtil.getNextDate(todate)));
					} else if (period.equals("today")) {
						SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
						fromdate = request.getParameter("fromdate");
						todate = sdf.format(Calendar.getInstance().getTime());
					} else {
						fromdate = request.getParameter("fromdate");
						todate = request.getParameter("todate");
						if(fromdate.length() > 0 && todate.length() > 0)
							todate = curdate_str.equals(todate) ? DateTimeUtil.getDateTimeStringIn24hFormat(date) : DateTimeUtil.getDateString(DateTimeUtil.getOnlyDate(DateTimeUtil.getNextDate(todate)));
					}

					try {
						String[] header = { "Node Name", "Connected IP", "Serial Number", "Down%", "Down Duration",
								"Up%", "Up Duration" };
						/*
						 * String qry =
						 * "select nd.nodelabel,nd.loopbackip,nout.slnumber,EXTRACT(EPOCH FROM (to_timestamp('"
						 * +todate+"','DD-MM-YYYY')-to_timestamp('"+
						 * fromdate+"','DD-MM-YYYY'))) total_time_sec," +
						 * " sum(EXTRACT(EPOCH FROM (COALESCE(nout.uptime,to_timestamp('"
						 * +todate+"','DD-MM-YYYY'),nout.uptime)-nout.downtime))) as tot_down_time_sec "
						 * +
						 * " from m2mnodeoutages nout inner join nodedetails nd on nd.slnumber = nout.slnumber where nd.status in ("
						 * +nodesel+") and nd.slnumber like  "+input+
						 * " and nout.downtime between to_date('"
						 * +fromdate+"' ,'DD-MM-YYYY') and to_date('"
						 * +todate+"','DD-MM-YYYY')  group by nout.slnumber,nd.nodelabel,nd.loopbackip order by slnumber"
						 * ;
						 */
						String qry = "select nd.nodelabel as nodelabel,nd.ipaddress as ipaddress,nout.slnumber as slnumber,"
								+ "EXTRACT(EPOCH FROM (to_timestamp('" + todate
								+ "','DD-MM-YYYY HH24:MI:SS')-(case when (nd.createdtime > to_timestamp('"
								+ fromdate + "','DD-MM-YYYY')) then (case when nd.createdtime > (to_timestamp('"
								+ todate + "','DD-MM-YYYY HH24:MI:SS')) then (to_timestamp('" + todate
								+ "','DD-MM-YYYY HH24:MI:SS')) else  nd.createdtime end) else to_timestamp ('"
								+ fromdate + "','DD-MM-YYYY') end))) as total_time_sec,"
								+ "sum(EXTRACT(EPOCH FROM (case when (nout.uptime is null or nout.uptime > to_timestamp('"
								+ todate + "','DD-MM-YYYY HH24:MI:SS')) then to_timestamp('" + todate
								+ "','DD-MM-YYYY HH24:MI:SS') else nout.uptime end ) - (case when nout.downtime < to_timestamp('"
								+ fromdate + "','DD-MM-YYYY') then to_timestamp('" + fromdate
								+ "','DD-MM-YYYY') else nout.downtime end))) as downper"
								+ " from m2mnodeoutages nout inner join nodedetails nd on nd.slnumber = nout.slnumber where "
								+ merged_qry.replace("prefix.", "nd.") + " and nd.status in (" + nodesel + ") and nd."
								+ choose + " like " + input + " and nout.downtime < to_timestamp('" + todate
								+ "','DD-MM-YYYY HH24:MI:SS') and (nout.uptime > to_timestamp('" + fromdate
								+ "','DD-MM-YYYY') or nout.uptime is null) group by nout.slnumber,nd.nodelabel,nd.ipaddress,nd.createdtime"
								+ " union select nd.nodelabel as nodelabel,nd.ipaddress as ipaddress,nd.slnumber as slnumber ,EXTRACT(EPOCH FROM (to_timestamp('"
								+ todate
								+ "','DD-MM-YYYY HH24:MI:SS') -(case when (nd.createdtime > to_timestamp('"
								+ fromdate + "','DD-MM-YYYY')) then (case when nd.createdtime > (to_timestamp('"
								+ todate + "','DD-MM-YYYY HH24:MI:SS')) then (to_timestamp('" + todate
								+ "','DD-MM-YYYY HH24:MI:SS')) else  nd.createdtime end) else to_timestamp ('"
								+ fromdate + "','DD-MM-YYYY') end))) as total_time_sec,0 as downper"
								+ " from nodedetails nd where " + merged_qry.replace("prefix.", "nd.")
								+ " and nd.status in (" + nodesel + ") and nd." + choose + " like " + input
								+ " and nd.slnumber not in(select slnumber from m2mnodeoutages where downtime < to_timestamp('"
								+ todate + "','DD-MM-YYYY HH24:MI:SS') and (uptime > to_timestamp('" + fromdate
								+ "','DD-MM-YYYY') or uptime is null))"
								+ " group by nd.slnumber,nd.nodelabel,nd.ipaddress,nd.createdtime order by slnumber";
						if (period.equals("today"))
							qry = "select nd.nodelabel as nodelabel,nd.ipaddress as ipaddress,nout.slnumber as slnumber,"
									+ "EXTRACT(EPOCH FROM (to_timestamp('" + todate
									+ "','DD-MM-YYYY HH24:MI:SS') -(case when (nd.createdtime > to_timestamp('"
									+ fromdate + "','DD-MM-YYYY')) then nd.createdtime else to_timestamp('" + fromdate
									+ "','DD-MM-YYYY') end))) as total_time_sec,"
									+ "sum(EXTRACT(EPOCH FROM (case when (nout.uptime is null or nout.uptime > to_timestamp('"
									+ todate + "','DD-MM-YYYY HH24:MI:SS')) then to_timestamp('" + todate
									+ "','DD-MM-YYYY HH24:MI:SS') else nout.uptime end ) - (case when nout.downtime < to_timestamp('"
									+ fromdate + "','DD-MM-YYYY') then to_timestamp('" + fromdate
									+ "','DD-MM-YYYY') else nout.downtime end))) as downper"
									+ " from m2mnodeoutages nout inner join nodedetails nd on nd.slnumber = nout.slnumber where "
									+ merged_qry.replace("prefix.", "nd.") + " and nd.status in (" + nodesel
									+ ") and nd." + choose + " like " + input + " and nout.downtime < to_timestamp('"
									+ todate + "','DD-MM-YYYY HH24:MI:SS') and (nout.uptime > to_date('" + fromdate
									+ "','DD-MM-YYYY') or nout.uptime is null) group by nout.slnumber,nd.nodelabel,nd.ipaddress,nd.createdtime"
									+ " union select nd.nodelabel as nodelabel,nd.ipaddress as ipaddress,nd.slnumber as slnumber ,EXTRACT(EPOCH FROM (to_timestamp('"
									+ todate + "','DD-MM-YYYY HH24:MI:SS')-(case when (nd.createdtime > to_timestamp('"
									+ fromdate + "','DD-MM-YYYY')) then nd.createdtime else to_timestamp('" + fromdate
									+ "','DD-MM-YYYY') end))) as total_time_sec,0 as downper"
									+ " from nodedetails nd where " + merged_qry.replace("prefix.", "nd.")
									+ " and nd.status in (" + nodesel + ") and nd." + choose + " like  " + input
									+ " and nd.slnumber not in(select slnumber from m2mnodeoutages where downtime < to_timestamp('"
									+ todate + "','DD-MM-YYYY HH24:MI:SS') and (uptime > to_date('" + fromdate
									+ "','DD-MM-YYYY') or uptime is null))"
									+ " group by nd.slnumber,nd.nodelabel,nd.ipaddress,nd.createdtime order by slnumber";
						st = con.createStatement();
						// System.out.println("in the class RunReport.java, query is : "+qry);
						rs = st.executeQuery(qry);
						workbook = GenerateReportFormat.getWorkBook(header, rs, "DeviceUptime",period);
					} catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					} finally {
						if (hibsession != null)
							hibsession.close();
						if (st != null)
							st.close();
						if (rs != null)
							rs.close();
					}
					response.setContentType("application/vnd.ms-excel");
					response.setHeader("Content-disposition", "inline; filename=Device-Uptime.xlsx");
					workbook.write(response.getOutputStream());
					response.getOutputStream().close();

				} else if (format.equals("PDF")) {
					File reportFile = new File(rep_path + File.separator + "DeviceUptimeReport.jasper");
					System.out.println(reportFile.getAbsolutePath());
					// byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(),
					// parameters, con);
					String nodesel = request.getParameter("nodesel");
					if (nodesel.equals("all") || nodesel.equals("single"))
						nodesel = "'up','down','inactive'";
					else if (nodesel.equals("down"))
						nodesel = "'down','inactive'";
					else
						nodesel = "'" + nodesel + "'";

					String choose = request.getParameter("choose");
					String input = "'%" + request.getParameter("chooseinput") + "%'";
					String period = request.getParameter("timeperiod");
					String fromdate = "";
					String todate = "";
					Vector<String> datesvec;
					if (!period.equals("custom") && !period.equals("today")) {
						datesvec = getdates(period);
						fromdate = datesvec.get(0);
						todate = datesvec.get(1);
						todate = curdate_str.equals(todate) ? DateTimeUtil.getDateTimeStringIn24hFormat(date) : DateTimeUtil.getDateString(DateTimeUtil.getOnlyDate(DateTimeUtil.getNextDate(todate)));
					} else if (period.equals("today")) {
						SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
						fromdate = request.getParameter("fromdate");
						todate = sdf.format(Calendar.getInstance().getTime());
					} else {
						fromdate = request.getParameter("fromdate");
						todate = request.getParameter("todate");
						if(fromdate.length() > 0 && todate.length() > 0)
							todate = curdate_str.equals(todate) ? DateTimeUtil.getDateTimeStringIn24hFormat(date) : DateTimeUtil.getDateString(DateTimeUtil.getOnlyDate(DateTimeUtil.getNextDate(todate)));
					}
					parameters.put("nodesel", nodesel);
					parameters.put("choose", "nd." + choose);
					parameters.put("input", input);
					parameters.put("fromdate", fromdate);
					parameters.put("todate", todate);
					parameters.put("period", period);
					String merge_qry = merged_qry.replace("prefix.", "nd.");
					parameters.put("mergeqry", merge_qry);

					byte[] bytes = GenerateReportFormat.getReportInBytes(reportFile.getPath(), parameters, con,
							reportFile);
					if (hibsession != null)
						hibsession.close();
					response.setContentType("application/pdf;charset=UTF-8");
					response.setContentLength(bytes.length);
					ServletOutputStream outStream = response.getOutputStream();
					outStream.write(bytes, 0, bytes.length);
					outStream.flush();
					outStream.close();
				}

			} else if (reportid.equals("local_State-Change")) {
				if (format.equals("EXCEL")) {
					String choose = request.getParameter("choose");
					String input =  request.getParameter("chooseinput");
					String period = request.getParameter("timeperiod");
					String fromdate = "";
					String todate = "";
					String orderby = request.getParameter("orderby")==null?"slnumber":request.getParameter("orderby");
					String ordertype = request.getParameter("ordertype")==null?"asc":request.getParameter("ordertype");
					if(input.trim().length() == 0)
					{
						orderby = "downtime";
						ordertype = "desc";
					}

					Vector<String> datesvec;
					if (!period.equals("custom")) {
						datesvec = getdates(period);
						fromdate = datesvec.get(0);
						todate = datesvec.get(1);
					} else {
						fromdate = request.getParameter("fromdate");
						todate = request.getParameter("todate");
					}
					try {
						String[] header = { "Serial Number","Outage Time", "Recover Time", "Persistent Time" };
						/*
						 * String qry =
						 * "select nout.downtime,EXTRACT(EPOCH FROM (COALESCE(nout.uptime,to_timestamp('"
						 * + todate +
						 * "','DD-MM-YYYY')+interval '1 day' ,nout.uptime)-nout.downtime)) as downduration,"
						 * +
						 * "nout.uptime,nd.nodelabel as nodelabel,nd.ipaddress as ipaddress,nd.slnumber as slnumber from m2mnodeoutages nout inner join nodedetails nd on nd.slnumber = nout.slnumber  where "
						 * + "nout.downtime between to_date('" + fromdate +
						 * "' ,'DD-MM-YYYY') and to_date('" + todate +
						 * "','DD-MM-YYYY') + interval  '1 day' and nd." + choose + " = '" + input +
						 * "' order by downtime desc";
						 */
						String qry = "select mout.severity as severity, mout.slnumber as slnumber, mout.downtime as downtime,mout.uptime as uptime,age(mout.uptime,mout.downtime)"
								+"as persisttime from m2mnodeoutages mout inner join nodedetails nd on nd.id = mout.nodeid"
								+" where nd." + choose + " = '" + input + "'"
								+"and " + merged_qry.replace("prefix.", "nd.") + " and mout.downtime between to_date('" + fromdate
								+ "' ,'DD-MM-YYYY') and to_date('" + todate + "','DD-MM-YYYY') + interval  '1 day' order by "+ orderby + " " + ordertype;
						st = con.createStatement();
						// System.out.println("query is : "+qry);
						rs = st.executeQuery(qry);
						workbook = GenerateReportFormat.getWorkBook(header, rs, "StateChange","");
					} catch (Exception e) {
						// TODO: handle exception
					} finally {
						if (hibsession != null)
							hibsession.close();
						if (st != null)
							st.close();
						if (rs != null)
							rs.close();
					}
					response.setContentType("application/vnd.ms-excel");
					response.setHeader("Content-disposition", "inline; filename=State-Change.xlsx");
					workbook.write(response.getOutputStream());
					response.getOutputStream().close();

				} else if (format.equals("PDF")) {
					File reportFile = new File(rep_path + File.separator + "StateChangeReport.jasper");

					// byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(),
					// parameters, con);
					String choose = request.getParameter("choose");
					String input = request.getParameter("chooseinput");
					String period = request.getParameter("timeperiod");
					String fromdate = "";
					String todate = "";
					Date date = new Date();
					String curdate_str = DateTimeUtil.getDateString(DateTimeUtil.getOnlyDate(date));
					Vector<String> datesvec;
					if (!period.equals("custom")) {
						datesvec = getdates(period);
						fromdate = datesvec.get(0);
						todate = datesvec.get(1);
						todate = curdate_str.equals(todate) ? DateTimeUtil.getDateTimeStringIn24hFormat(date) : DateTimeUtil.getDateString(DateTimeUtil.getOnlyDate(DateTimeUtil.getNextDate(todate)));
					} else {
						fromdate = request.getParameter("fromdate");
						todate = request.getParameter("todate");
						todate = curdate_str.equals(todate) ? DateTimeUtil.getDateTimeStringIn24hFormat(date) : DateTimeUtil.getDateString(DateTimeUtil.getOnlyDate(DateTimeUtil.getNextDate(todate)));
					}
					String merge_qry = merged_qry.replace("prefix.", "nd.");
					parameters.put("mergeqry", merge_qry);
					parameters.put("choose", "nd." + choose);
					parameters.put("input", input);
					parameters.put("fromdate", fromdate);
					parameters.put("todate", todate);
					// for(String key : keyset)
					// System.out.println("in RunReport.java, "+key+" = "+parameters.get(key));
					byte[] bytes = GenerateReportFormat.getReportInBytes(reportFile.getPath(), parameters, con,
							reportFile);
					if (hibsession != null)
						hibsession.close();
					response.setContentType("application/pdf;charset=UTF-8");
					response.setContentLength(bytes.length);
					ServletOutputStream outStream = response.getOutputStream();
					outStream.write(bytes, 0, bytes.length);
					outStream.flush();
					outStream.close();
				}
			}
			else if(reportid.equals("All-Devices"))
			{
				if (format.equals("EXCEL")) {
					try {
						String header[] = {"Node Label","Connected IP","Serial Number","IMEI NO","Location","Config","Upgrade","Reboot"};
						String qry = "select nodelabel,ipaddress,slnumber,imeinumber,location,(case when (lastconfig is not null and lastconfig > lastexport) then lastconfig  else lastexport end)  as lastconfig,lastreboot,lastupgrade from Nodedetails where "+merged_qry.replace("prefix.", "");
						st = con.createStatement();
						rs = st.executeQuery(qry);
						workbook = GenerateReportFormat.getWorkBook(header, rs, "AllDevices","");
					} catch (Exception e) {
						// TODO: handle exception
					}
					finally {
						if (hibsession != null)
							hibsession.close();
						if (st != null)
							st.close();
						if (rs != null)
							rs.close();
					}
					response.setContentType("application/vnd.ms-excel");
					response.setHeader("Content-disposition", "inline; filename=All-Devices.xlsx");
					workbook.write(response.getOutputStream());
					response.getOutputStream().close();
				}
				else if(format.equals("PDF"))
				{
					File reportFile = new File(rep_path + File.separator + "AllDevicesReport.jasper");
					String merge_qry = merged_qry.replace("prefix.", "");
					parameters.put("mergeqry", merge_qry);
					// byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(),
					// parameters, con);

					byte[] bytes = GenerateReportFormat.getReportInBytes(reportFile.getPath(), parameters, con,
							reportFile);
					if (hibsession != null)
						hibsession.close();
					response.setContentType("application/pdf;charset=UTF-8");
					response.setContentLength(bytes.length);
					ServletOutputStream outStream = response.getOutputStream();
					outStream.write(bytes, 0, bytes.length);
					outStream.flush();
					outStream.close();
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			if (hibsession != null && hibsession.isOpen())
				hibsession.close();
		}
	}

	private Vector<String> getdates(String period) {
		String fromdate = "";
		String todate = "";
		Calendar cal = Calendar.getInstance();
		Vector<String> datesvec = new Vector<String>();
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		if (period.equals("today")) {
			fromdate = sdf.format(cal.getTime());
			todate = sdf.format(cal.getTime());
		} else if (period.equals("yesterday")) {
			cal.add(Calendar.DATE, -1);
			todate = sdf.format(cal.getTime());
			fromdate = sdf.format(cal.getTime());
		} else if (period.equals("lastweek")) {
			Date date = new Date();
			Calendar c = Calendar.getInstance();
			c.setTime(date);
			int i = c.get(Calendar.DAY_OF_WEEK) - c.getFirstDayOfWeek();
			c.add(Calendar.DATE, -i - 7);
			Date start = c.getTime();
			fromdate = sdf.format(start);
			c.add(Calendar.DATE, 6);
			Date end = c.getTime();
			todate = sdf.format(end);
		} else if (period.equals("lastmonth")) {
			Calendar aCalendar = Calendar.getInstance();
			aCalendar.add(Calendar.MONTH, -1);
			aCalendar.set(Calendar.DATE, 1);
			Date start = aCalendar.getTime();
			fromdate = sdf.format(start);
			aCalendar.set(Calendar.DATE, aCalendar.getActualMaximum(Calendar.DAY_OF_MONTH));
			Date end = aCalendar.getTime();
			todate = sdf.format(end);
		} else if (period.equals("lastquarter")) {
			Calendar stmth = Calendar.getInstance();
			Calendar endmth = Calendar.getInstance();
			int month = stmth.get(Calendar.MONTH) + 1;
			int mths = month % 3 == 0 ? 3 : month % 3;
			stmth.add(Calendar.MONTH, (-2 - mths));
			stmth.set(Calendar.DATE, 1);
			endmth.add(Calendar.MONTH, (-mths));
			endmth.set(Calendar.DATE, stmth.getActualMaximum(Calendar.DAY_OF_MONTH));
			fromdate = sdf.format(stmth.getTime());
			todate = sdf.format(endmth.getTime());
		}
		datesvec.add(fromdate);
		datesvec.add(todate);
		return datesvec;
	}
}