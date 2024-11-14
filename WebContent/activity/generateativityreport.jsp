<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.hibernate.Session"%>
<%@page import="com.nomus.m2m.reporttools.GenerateReportFormat"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.HashMap"%>
<head>
<title>IMission | Activity Report</title>
</head>
<%
	String activitytype = request.getParameter("activitytype");
	String reportid = request.getParameter("reportid");
	HashMap<String, Object> parameters = new HashMap<String, Object>();
	if (activitytype.equals("edit"))
		activitytype = "Edit','Export";
	parameters.put("type", activitytype);
	parameters.put("reportid", Integer.parseInt(reportid));
	Connection con = null;
	Session hibsession = null;

	try {
		hibsession = HibernateSession.getDBSession();
		con = ((SessionImpl) hibsession).connection();
		String rep_path = getServletContext().getRealPath("report-templates");
		File reportFile = new File(rep_path+ File.separator + "activityreport.jasper");
		byte[] bytes = GenerateReportFormat.getReportInBytes(reportFile.getPath(), parameters, con, reportFile);
		response.setContentType("application/pdf;charset=UTF-8");
		response.setContentLength(bytes.length);
		ServletOutputStream outStream = response.getOutputStream();
		outStream.write(bytes, 0, bytes.length);
		outStream.flush();
		outStream.close();
		return;
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (hibsession != null) {
			hibsession.disconnect();
			hibsession.close();			
		}
	}
%>