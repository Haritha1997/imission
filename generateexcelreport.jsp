
<%@page import="org.hibernate.Session"%>
<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.apache.poi.ss.usermodel.HorizontalAlignment"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Hashtable"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@page import="org.apache.poi.ss.usermodel.FillPatternType"%>
<%@page import="org.apache.poi.ss.usermodel.IndexedColors"%>
<%@page import="org.apache.poi.ss.usermodel.CellStyle"%>
<%@page import="org.apache.poi.ss.usermodel.Header"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFFont"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFRichTextString"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>

<%@page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%
	String reporttype=request.getParameter("reptype");
  XSSFWorkbook workbook = new XSSFWorkbook();
  DecimalFormat df = new DecimalFormat(".##");
 
		Connection con=null;
        Statement st= null;
        ResultSet rs = null;
        Session hibsession = null;
		try
		{    
			hibsession = HibernateSession.getDBSession();
			con = ((SessionImpl) hibsession).connection();
            st = con.createStatement();
            int rowcnt = 1;
            System.out.println("reportname is : "+reporttype);
            if(reporttype.equals("inventory"))
            {
            	
                String qry = "select nodelabel ,loopbackip, slnumber , fwversion,location from  Nodedetails";
                rs = st.executeQuery(qry);
                XSSFSheet spreadsheet = workbook.createSheet("Inventory Report");
                Header header = spreadsheet.getHeader();  
                header.setCenter("M2M Inventory Report"); 
                for(int i=0;i<26;i++)
                	spreadsheet.setColumnWidth(i, 15*256);
                XSSFRow row = spreadsheet.createRow((short) rowcnt);
                CellStyle style = workbook.createCellStyle();  
                // Setting Background color  
                style.setFillBackgroundColor(IndexedColors.AQUA.getIndex());  
                //style.setFillPattern(CellStyle.ALIGN_GENERAL); 
                //style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                XSSFFont font = (XSSFFont)workbook.createFont();
		XSSFRichTextString richString1 = new XSSFRichTextString( "Nodename" );
		XSSFRichTextString richString2 = new XSSFRichTextString( "IP Address" );
		XSSFRichTextString richString3 = new XSSFRichTextString("Serial Number");
		XSSFRichTextString richString4 = new XSSFRichTextString("Firmware Version");
		XSSFRichTextString richString5 = new XSSFRichTextString("Location");
		
		font.setBold(true);
		richString1.applyFont(font);
		richString2.applyFont(font);
		richString3.applyFont(font);
		richString4.applyFont(font);
		richString5.applyFont(font);
                XSSFCell cell0 =  row.createCell(0);
                cell0.setCellValue(richString1);
                cell0.setCellStyle(style);
                XSSFCell cell1 =  row.createCell(1);
                cell1.setCellValue(richString2);
                cell1.setCellStyle(style);
                XSSFCell cell2 =  row.createCell(2);
                cell2.setCellValue(richString3);
                cell2.setCellStyle(style);
                XSSFCell cell3 =  row.createCell(3);
                cell3.setCellValue(richString4);
                cell3.setCellStyle(style);
		 		XSSFCell cell4 =  row.createCell(4);
                cell4.setCellValue(richString5);
                cell4.setCellStyle(style);
                
                while(rs.next())
                {
                    rowcnt++;
                    row = spreadsheet.createRow((short) rowcnt);
                    row.createCell(0).setCellValue(rs.getString(1));
                    row.createCell(1).setCellValue(rs.getString(2));
                    row.createCell(2).setCellValue(rs.getString(3));
                    row.createCell(3).setCellValue(rs.getString(4));
			row.createCell(4).setCellValue(rs.getString(5));
                }
            }
            else if(reporttype.equals("devicestatus"))
            {
            	String fromdate = request.getParameter("fromdate").trim();
            	String todate = request.getParameter("todate").trim();
            	
            	System.out.print("fromdate is : "+fromdate+" and todate is : "+todate);
            	SimpleDateFormat sdf =  new SimpleDateFormat("yyyy-MM-dd");
            	Date from_date = sdf.parse(fromdate);
            	Calendar cal = Calendar.getInstance();
            	 cal.setTime( sdf.parse(todate));
            	cal.add(Calendar.DAY_OF_MONTH, 1);
            	Date to_date = cal.getTime();
            	
            	String qry="select distinct(slnumber),nodelabel,loopbackip,routeruptime,signalstrength,network,date(createdtime) as createdtime from Nodedetails n order by n.slnumber";
                Hashtable<String ,Hashtable <String,String>> nodedet_ht = new Hashtable<String ,Hashtable <String,String>>(); 
            	rs = st.executeQuery(qry);
            	
            	while(rs.next())
            	{
            		if(nodedet_ht.get(rs.getString("slnumber")) == null)
            		{
					Hashtable<String, String> m2m_node_ht = new Hashtable<String, String>();
					m2m_node_ht.put("nodelabel", rs.getString("nodelabel"));
					m2m_node_ht.put("slnumber", rs.getString("slnumber"));
					m2m_node_ht.put("loopbackip", rs.getString("loopbackip"));
					m2m_node_ht.put("routeruptime", rs.getString("routeruptime"));
					m2m_node_ht.put("signalstrength", rs.getString("signalstrength"));
					m2m_node_ht.put("network", rs.getString("network"));
					m2m_node_ht.put("createdtime", rs.getString("createdtime"));
	
					nodedet_ht.put(m2m_node_ht.get("slnumber"), m2m_node_ht);
				}
			}
			rs.close();
			

			qry = "select slnumber,extract(epoch from(sum(uptime-downtime)))/60 as outagetime from m2mnodeoutages where downtime >= date '"+fromdate
					+ "' and uptime <=date '"+todate+"' + integer '1' group by slnumber";
			rs = st.executeQuery(qry);
			while (rs.next()) {
				Hashtable<String, String> m2m_node_ht = nodedet_ht.get(rs.getString("slnumber"));
				double outagemins = Double.parseDouble(rs.getString("outagetime"));
				//System.out.println("dategap is : "+dategap+" outagemins :"+outagemins+" and percentage is :"+((dategap-outagemins)/dategap)*100);
				Date created_time = sdf.parse(m2m_node_ht.get("createdtime"));
				double dategap;
				if(created_time.compareTo(from_date) < 0)
					dategap = Math.abs(to_date.getTime() - from_date.getTime())/(60*1000);
				else
					dategap = Math.abs(to_date.getTime() - created_time.getTime())/(60*1000);
				if(m2m_node_ht != null && dategap > 0)
					m2m_node_ht.put("availability", df.format(((dategap-outagemins)/dategap)*100));
				else 
					m2m_node_ht.put("availability", "");
			}
			
			XSSFSheet spreadsheet = workbook.createSheet("Device Status Report");
			Header header = spreadsheet.getHeader();
			header.setCenter("Device Status Report");
			for (int i = 0; i < 26; i++)
				spreadsheet.setColumnWidth(i, 15 * 256);

			XSSFRow row = spreadsheet.createRow((short) rowcnt);
			CellStyle style = workbook.createCellStyle();
			style.setFillBackgroundColor(IndexedColors.AQUA.getIndex());
			//style.setFillPattern();
			//style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			XSSFFont font = (XSSFFont) workbook.createFont();
			XSSFRichTextString richString0 = new XSSFRichTextString("Nodename");
			XSSFRichTextString richString1 = new XSSFRichTextString("Serial Number");
			XSSFRichTextString richString2 = new XSSFRichTextString("IP Address");
			XSSFRichTextString richString3 = new XSSFRichTextString("Router Uptime");
			XSSFRichTextString richString4 = new XSSFRichTextString("Signal Strength");
			XSSFRichTextString richString5 = new XSSFRichTextString("Network");
			XSSFRichTextString richString6 = new XSSFRichTextString("Node Availabilty (%)");
			font.setBold(true);
			richString0.applyFont(font);
			richString1.applyFont(font);
			richString2.applyFont(font);
			richString3.applyFont(font);
			richString4.applyFont(font);
			richString5.applyFont(font);
			richString6.applyFont(font);
			XSSFCell cell0 = row.createCell(0);
			cell0.setCellValue(richString0);
			cell0.setCellStyle(style);
			XSSFCell cell1 = row.createCell(1);
			cell1.setCellValue(richString1);
			cell1.setCellStyle(style);
			XSSFCell cell2 = row.createCell(2);
			cell2.setCellValue(richString2);
			cell2.setCellStyle(style);
			XSSFCell cell3 = row.createCell(3);
			cell3.setCellValue(richString3);
			cell3.setCellStyle(style);

			XSSFCell cell4 = row.createCell(4);
			cell4.setCellValue(richString4);
			cell4.setCellStyle(style);
			XSSFCell cell5 = row.createCell(5);
			cell5.setCellValue(richString5);
			cell5.setCellStyle(style);
			XSSFCell cell6 = row.createCell(6);
			cell6.setCellValue(richString6);
			cell6.setCellStyle(style);
			
			Set<String> keyset = nodedet_ht.keySet();
			for (String slnum : keyset) {
				rowcnt++;
				Hashtable<String,String> node_ht = nodedet_ht.get(slnum);
				
				row = spreadsheet.createRow((short) rowcnt);
				row.createCell(0).setCellValue(node_ht.get("nodelabel"));
				row.createCell(1).setCellValue(node_ht.get("slnumber"));
				row.createCell(2).setCellValue(node_ht.get("loopbackip"));
				row.createCell(3).setCellValue(node_ht.get("routeruptime"));
				row.createCell(4).setCellValue(node_ht.get("signalstrength"));
				row.createCell(5).setCellValue(node_ht.get("network"));
				row.createCell(6).setCellValue(node_ht.get("availability")==null?"":node_ht.get("availability"));
			}
		}
	} catch (Throwable e) {
		e.printStackTrace();
	} finally {
		try {
			if(hibsession != null)
				hibsession.close();
			
				
			if (st != null)
				st.close();
			if (rs != null)
				rs.close();
		} catch (SQLException se) {

		}
	}
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-disposition", "inline; filename=" + reporttype + ".xlsx");
	workbook.write(response.getOutputStream());
	response.getOutputStream().close();
%>