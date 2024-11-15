package com.nomus.m2m.schedulers;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.Timer;
import java.util.TimerTask;
import java.util.Vector;

import org.apache.log4j.Logger;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.hibernate.Session;
import org.hibernate.internal.SessionImpl;

import com.nomus.m2m.dao.HibernateSession;
import com.nomus.m2m.dao.LicDao;
import com.nomus.m2m.dao.LoadBatchDao;
import com.nomus.m2m.dao.M2MNodeOtagesDao;
import com.nomus.m2m.dao.M2MSchReportsDao;
import com.nomus.m2m.dao.NodedetailsDao;
import com.nomus.m2m.dao.OrganizationDao;
import com.nomus.m2m.dao.OrganizationDataDao;
import com.nomus.m2m.dao.UserDao;
import com.nomus.m2m.mail.MailSender;
import com.nomus.m2m.main.SeverityNames;
import com.nomus.m2m.pojo.License;
import com.nomus.m2m.pojo.LoadBatch;
import com.nomus.m2m.pojo.M2MNodeOtages;
import com.nomus.m2m.pojo.M2MSchReports;
import com.nomus.m2m.pojo.NodeDetails;
import com.nomus.m2m.pojo.Organization;
import com.nomus.m2m.pojo.User;
import com.nomus.m2m.reporttools.GenerateReportFormat;
import com.nomus.staticmembers.DateTimeUtil;
import com.nomus.staticmembers.M2MProperties;
import com.nomus.staticmembers.QueryGenerator;

public class ReportScheduler {
	M2MSchReportsDao repcontroller;
	static Logger logger = Logger.getLogger(ReportScheduler.class.getName());
	SimpleDateFormat shortsdf = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	private static long inactive_base_time;
	private Properties props;
	int read_timeout = 10;
	public ReportScheduler()
	{
		inactive_base_time = Calendar.getInstance().getTimeInMillis();
		props = M2MProperties.getM2MProperties();
		repcontroller = new M2MSchReportsDao();
	}

	public void doSchedule()
	{
		Timer t = new Timer();  
		TimerTask tt = new TimerTask() {  
			@Override  
			public void run() {
				try {
					setInactiveNodes();
					NodedetailsDao ndao = new NodedetailsDao(); 
					ndao.setTaskStatusFailed(30);
					List<M2MSchReports> reportlist = repcontroller.getM2MSchReports();
					LicDao ldio = new LicDao();
					ldio.updateCurdate();
					License lic=ldio.getLicenseDetails();
					if(lic.getValidUpTo().compareTo(new Date())>=0)
					{
						BackupService bs=new BackupService();
						bs.takeBackUp();
					}
					for(M2MSchReports report : reportlist)
					{
						try
						{
							checkAndSendtheMail(report);
						}
						catch(Throwable e)
						{
							e.printStackTrace();
						}
					}
					doMailWithoutAttachment();
				}
				catch(Throwable t)
				{
					t.printStackTrace();
				}
			}
		};  
		t.schedule(tt, new Date(),1000*60*4);
	}
	protected void doMailWithoutAttachment() {
		//Properties imission_m2m_props = M2MProperties.getM2MProperties();
		Properties imission_m2m_props = M2MProperties.getM2MProperties();
		String s_username = imission_m2m_props.getProperty("username");
		String s_password = imission_m2m_props.getProperty("password");
		UserDao udao = new UserDao();
		User user = null;
		OrganizationDao orgdao = new OrganizationDao();
		List<Organization> orglist = orgdao.getActOrgList();
		List<LoadBatch> batchlist = new ArrayList<LoadBatch>();
		LoadBatchDao batchdao = new LoadBatchDao();
		OrganizationDataDao orddatadao = new OrganizationDataDao();
		for(Organization selorg : orglist)
		{
			user = udao.getUser(selorg);
			batchlist = orgdao.getAboutToExpireBatchList(selorg);
			if(batchlist == null)
				continue;
			else
			{
				String body = "";
				Date curdate = new Date();
				for(LoadBatch batch : batchlist)
				{
					int days = DateTimeUtil.getDaysDiff(curdate, batch.getValidUpTo());
					if(days < 30)
					{
						if((days == 29 || days == 22 || days == 15 || days < 8) && days >= 0 && (batch.getLastExpiredPrompt() == null || DateTimeUtil.getDaysDiff(curdate, batch.getLastExpiredPrompt()) < 0))
						{
							String validupto = DateTimeUtil.dateToString(batch.getValidUpTo());
							body ="The following nodes under the batch name '"+batch.getBatchName()+"' are going to expiring on "+validupto+"\n\n";
							int ct = 1;
							for(String slnum : orddatadao.getSlNumbers(batch))
							{
								ct ++;
								body += slnum +"  "+(ct%5==0?"\n":"");
								ct %= 5;
							}
							body +="\n\nRegards,\n   "+s_username.substring(0,s_username.indexOf("@"));
							MailSender mail = new MailSender(s_username, s_password, user.getEmail(), body);
							boolean mailsend = mail.sendMailWithoutAttachFile();
							if(mailsend)
							{
								batch.setLastExpiredPrompt(curdate);
								batchdao.updateLoadBatch(batch);
							}
						}
	
						
					}
				}
			}
		}
	}

	private boolean inactiveTimeOver() {
		// TODO Auto-generated method stub
		long curtime = Calendar.getInstance().getTimeInMillis();

		if((curtime-inactive_base_time)/(60*1000) > read_timeout)
		{
			return true;
		}
		return false;
	}
	private void setInactiveNodes() {
		// TODO Auto-generated method stub
		if(inactiveTimeOver())
		{
			int daysforinactive = 2;
			try
			{
				daysforinactive = Integer.parseInt(props.getProperty("daysforinactive")==null?"2":props.getProperty("daysforinactive"));
				NodedetailsDao ndc = new NodedetailsDao();
				List<NodeDetails> nodelist = ndc.getNodeList("status","down");
				Date curdate = Calendar.getInstance().getTime();
				if(nodelist != null)
				{
					for(NodeDetails node : nodelist)
					{
						if(node.getDowntime() != null && (curdate.getTime() - node.getDowntime().getTime())/(1000*60) > daysforinactive*24*60)
						{
							node.setStatus("inactive");
							node.setSeverity(SeverityNames.CRITICAL);
							ndc.updateNodeDetails(node);
							M2MNodeOtagesDao mnoutageobj = new M2MNodeOtagesDao();
							M2MNodeOtages outage = mnoutageobj.getLastM2MNodeOtage("slnumber", node.getSlnumber());
							if(outage != null)
							{
								outage.setUpdateTime(new Date());
								outage.setSeverity(SeverityNames.CRITICAL);
								mnoutageobj.updateM2MNodeOtage(outage);
							}
							/*M2Mlogs log = new M2Mlogs();
							log.setNodeid(node.getId());
							log.setSlnumber(node.getSlnumber());
							log.setUpdatetime(new Date());
							log.setLoginfo("Node went to inactive state");
							m2mlc.addM2MLog(log);*/
						}
					}
				}
			}
			catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}
		}
	}
	protected File getPdfFile(byte[] bytes,String reportname) {
		File pdffile = new File(reportname+".pdf");
		BufferedOutputStream bos = null;
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream(pdffile);
			bos =  new BufferedOutputStream(fos);
			bos.write(bytes);
			bos.flush();
		}
		catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		finally {
			
				try {
					if(bos != null)
					bos.close();
					if(fos != null)
						fos.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		}

		return pdffile;
	}
	private void checkAndSendtheMail(M2MSchReports report) {
		// TODO Auto-generated method stub

		String format = report.getFormat();
		Statement st = null;
		ResultSet rs = null;
		Session hibsession = null;
		
		if(isFireTimeReached(report.getNextfiretime(),report.getTimeperiod()))
		{
			hibsession = HibernateSession.getDBSession();
			Date date = new Date();
			String curdate_str = DateTimeUtil.getDateString(DateTimeUtil.getOnlyDate(date));
			if(report.getName().equals("Device-Uptime"))
			{
				if(format.equals("PDF"))
				{
					Properties parameters = new Properties();
					String nodesel = report.getNodetype();
					if(nodesel.equals("all") || nodesel.equals("single"))
						nodesel = "'up','down','inactive'";
					else if(nodesel.equals("down"))
						nodesel = "'down','inactive'";
					else
						nodesel ="'"+nodesel+"'";

					String choose = report.getInput();
					String input = "'%"+report.getValue()+"%'";
					String period = report.getTimeperiod();
					String fromdate="";
					String todate="";
					Vector<String> datesvec;
					if(!period.equals("custom") && !period.equals("today"))
					{
						datesvec = getdates(period);
						fromdate = datesvec.get(0);
						todate = datesvec.get(1);  
						todate = curdate_str.equals(todate) ? DateTimeUtil.getDateTimeStringIn24hFormat(date) : DateTimeUtil.getDateString(DateTimeUtil.getOnlyDate(DateTimeUtil.getNextDate(todate)));
					}
					else if(period.equals("today"))
					{
						SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
						fromdate = report.getFromdate();
						todate = sdf.format(Calendar.getInstance().getTime());
					}
					else
					{
						fromdate = report.getFromdate();
						todate = report.getTodate();
						todate = curdate_str.equals(todate) ? DateTimeUtil.getDateTimeStringIn24hFormat(date) : DateTimeUtil.getDateString(DateTimeUtil.getOnlyDate(DateTimeUtil.getNextDate(todate)));
					}
					parameters.put("nodesel",nodesel);
					parameters.put("choose","nd."+choose);
					parameters.put("input",input);
					parameters.put("fromdate",fromdate);
					parameters.put("todate",todate);
					/*
					 * byte[] bytes = GenerateReportFormat.getReportInBytes(jasperfile.getPath(),
					 * parameters, ((SessionImpl)hibsession).connection(),jasperfile); File pdffile
					 * = getPdfFile(bytes,report.getName());
					 * doEmail(pdffile,report.getEmail(),report.getName());
					 */

				}
				else if(format.equals("EXCEL"))
				{
					XSSFWorkbook workbook = null;
					FileOutputStream fos = null;
					File excel_file = null;
					String nodesel = report.getNodetype();
					if(nodesel.equals("all") || nodesel.equals("single"))
						nodesel = "'up','down','inactive'";
					else if(nodesel.equals("down"))
						nodesel = "'down','inactive'";
					else
						nodesel ="'"+nodesel+"'";

					String choose = report.getInput();
					String input = "'%"+report.getValue()+"%'";
					String period = report.getTimeperiod();
					String fromdate="";
					String todate="";
					Vector<String> datesvec;
					if(!period.equals("custom") && !period.equals("today"))
					{
						datesvec = getdates(period);
						fromdate = datesvec.get(0);
						todate = datesvec.get(1); 
						todate = curdate_str.equals(todate) ? DateTimeUtil.getDateTimeStringIn24hFormat(date) : DateTimeUtil.getDateString(DateTimeUtil.getOnlyDate(DateTimeUtil.getNextDate(todate)));
					}
					else if(period.equals("today"))
					{
						SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
						fromdate = report.getFromdate();
						todate = sdf.format(Calendar.getInstance().getTime());
					}
					else
					{
						fromdate = report.getFromdate();
						todate = report.getTodate();
						todate = curdate_str.equals(todate) ? DateTimeUtil.getDateTimeStringIn24hFormat(date) : DateTimeUtil.getDateString(DateTimeUtil.getOnlyDate(DateTimeUtil.getNextDate(todate)));
					}
					
					try
					{
						String [] header = {"Node Name","IP Adddress","Serial Number","Down%",
								"Down Duration", "Up%", "Up Duration"};
						String slnumstr = QueryGenerator.getSlNumberStr(report.getUser());
						String locstr = QueryGenerator.getLocationsStr(report.getUser());
						String merged_qry = "prefix.organization ='" + report.getUser().getOrganization().getName() + "'";
						boolean and_added = false;
						if (slnumstr.length() > 0) {
							and_added = true;
							merged_qry += "and ( " + slnumstr;
						}
						if (locstr.length() > 0) {
							if (!and_added)
								merged_qry += "and (";
							else
								merged_qry += "or";
							merged_qry += locstr + " )";
						}
						if (slnumstr.length() > 0)
							merged_qry += ")";
						/*String qry = "select nd.nodelabel,nd.loopbackip,nout.slnumber,EXTRACT(EPOCH FROM (to_timestamp('"+todate+"','DD-MM-YYYY')-to_timestamp('"+fromdate+"','DD-MM-YYYY'))) total_time_sec," + 
                        " sum(EXTRACT(EPOCH FROM (COALESCE(nout.uptime,to_timestamp('"+todate+"','DD-MM-YYYY'),nout.uptime)-nout.downtime))) as tot_down_time_sec " + 
                        " from m2mnodeoutages nout inner join nodedetails nd on nd.slnumber = nout.slnumber where nd.status in ("+nodesel+") and nd.slnumber like  "+input+ 
                        " and nout.downtime between to_date('"+fromdate+"' ,'DD-MM-YYYY') and to_date('"+todate+"','DD-MM-YYYY')  group by nout.slnumber,nd.nodelabel,nd.loopbackip order by slnumber"; */
						String qry = "select nd.nodelabel as nodelabel,nd.loopbackip as loopbackip,nout.slnumber as slnumber,"
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
								+ "','DD-MM-YYYY') or nout.uptime is null) group by nout.slnumber,nd.nodelabel,nd.loopbackip,nd.createdtime"
								+ " union select nd.nodelabel as nodelabel,nd.loopbackip as loopbackip,nd.slnumber as slnumber ,EXTRACT(EPOCH FROM (to_timestamp('"
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
								+ " group by nd.slnumber,nd.nodelabel,nd.loopbackip,nd.createdtime order by slnumber";
						if (period.equals("today"))
							qry = "select nd.nodelabel as nodelabel,nd.loopbackip as loopbackip,nout.slnumber as slnumber,"
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
									+ "','DD-MM-YYYY') or nout.uptime is null) group by nout.slnumber,nd.nodelabel,nd.loopbackip,nd.createdtime"
									+ " union select nd.nodelabel as nodelabel,nd.loopbackip as loopbackip,nd.slnumber as slnumber ,EXTRACT(EPOCH FROM (to_timestamp('"
									+ todate + "','DD-MM-YYYY HH24:MI:SS')-(case when (nd.createdtime > to_timestamp('"
									+ fromdate + "','DD-MM-YYYY')) then nd.createdtime else to_timestamp('" + fromdate
									+ "','DD-MM-YYYY') end))) as total_time_sec,0 as downper"
									+ " from nodedetails nd where " + merged_qry.replace("prefix.", "nd.")
									+ " and nd.status in (" + nodesel + ") and nd." + choose + " like  " + input
									+ " and nd.slnumber not in(select slnumber from m2mnodeoutages where downtime < to_timestamp('"
									+ todate + "','DD-MM-YYYY HH24:MI:SS') and (uptime > to_date('" + fromdate
									+ "','DD-MM-YYYY') or uptime is null))"
									+ " group by nd.slnumber,nd.nodelabel,nd.loopbackip,nd.createdtime order by slnumber";
						st = ((SessionImpl)hibsession).connection().createStatement();
						//System.out.println("in the class RunReport.java, query is : "+qry);
						rs = st.executeQuery(qry);
						workbook = GenerateReportFormat.getWorkBook(header,rs,"DeviceUptime",period);
						if(workbook != null)
						{	
							excel_file = new File(report.getName()+".xlsx");
							fos = new FileOutputStream(excel_file);
							workbook.write(fos);
							fos.close();
						}
					}
					catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
					finally
					{
						try
						{
							if(hibsession != null)
								hibsession.close();
							if(st != null)
								st.close();
							if(rs != null)
								rs.close();
							if(fos != null)
								fos.close();
						}
						catch(Exception ine)
						{
							logger.error(ine.getMessage());
						}
					}

					if(excel_file != null)
					{
						doEmail(excel_file,report.getEmail(),report.getName());
					}

				}
			}
			else if(report.getName().equals("State-Change"))
			{
				if(format.equals("PDF"))
				{

					Properties parameters = new Properties();
					String nodesel = report.getNodetype();
					if(nodesel.equals("all") || nodesel.equals("single"))
						nodesel = "'up','down','inactive'";
					else if(nodesel.equals("down"))
						nodesel = "'down','inactive'";
					else
						nodesel ="'"+nodesel+"'";

					String choose = report.getInput();
					String input = report.getValue().trim();
					String fromdate="";
					String todate="";

					fromdate = report.getFromdate();
					todate = report.getTodate();
					parameters.put("nodesel",nodesel);
					parameters.put("choose","nd."+choose);
					parameters.put("input",input);
					parameters.put("fromdate",fromdate);
					parameters.put("todate",todate);

					/*
					 * byte[] bytes = GenerateReportFormat.getReportInBytes(jasperfile.getPath(),
					 * parameters, ((SessionImpl)hibsession).connection(),jasperfile); File pdffile
					 * = getPdfFile(bytes,report.getName());
					 * doEmail(pdffile,report.getEmail(),report.getName());
					 */
				}
				else if(format.equals("EXCEL"))
				{
					XSSFWorkbook workbook = null;
					FileOutputStream fos = null;
					File excel_file = null;
					String nodesel = report.getNodetype();
					if(nodesel.equals("all") || nodesel.equals("single"))
						nodesel = "'up','down','inactive'";
					else if(nodesel.equals("down"))
						nodesel = "'down','inactive'";
					else
						nodesel ="'"+nodesel+"'";

					String choose = report.getInput();
					String input = "'%"+report.getValue()+"%'";
					String fromdate="";
					String todate="";
					fromdate = report.getFromdate();
					todate = report.getTodate();
					try
					{
						String [] header = {"Down Time","Down Duration","Up Time"};
		                   String qry = "select nout.downtime,EXTRACT(EPOCH FROM (COALESCE(nout.uptime,to_timestamp('"+todate+"','DD-MM-YYYY')+interval '1 day' ,nout.uptime)-nout.downtime)) as downduration," + 
		                           "nout.uptime,nd.nodelabel as nodelabel,nd.loopbackip as ipaddress,nd.slnumber as slnumber from m2mnodeoutages nout inner join nodedetails nd on nd.slnumber = nout.slnumber  where "
		                           + "nout.downtime between to_date('"+fromdate+"' ,'DD-MM-YYYY') and to_date('"+todate+"','DD-MM-YYYY') + interval  '1 day' and nd."+choose+" like "+input+" order by downtime desc";
		                   
						st = ((SessionImpl)HibernateSession.getDBSession()).connection().createStatement();
						//System.out.println("in the class RunReport.java, query is : "+qry);
						rs = st.executeQuery(qry);
						workbook = GenerateReportFormat.getWorkBook(header,rs,"StateChange","");

						if(workbook != null)
						{	
							excel_file = new File(report.getName()+".xlsx");
							fos = new FileOutputStream(excel_file);
							workbook.write(fos);
							fos.close();
						}
					}
					catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
					finally
					{

						try
						{
							if(hibsession != null)
								hibsession.close();
							if(st != null)
								st.close();
							if(rs != null)
								rs.close();
							if(fos != null)
								fos.close();
						}
						catch(Exception ine)
						{
							logger.error(ine.getMessage());
						}
					}

					if(excel_file != null)
					{
						doEmail(excel_file,report.getEmail(),report.getName());
					}
				}
			}
			if(hibsession.isOpen())
				hibsession.close();
			updateReport(report);
		}
		
	}

	private void updateReport(M2MSchReports report) {
		// TODO Auto-generated method stub
		String tp = report.getTimeperiod();
		Calendar cal = Calendar.getInstance();
		Date from_date = null;
		Date to_date = null;
		Date trigger_time = null;
		if(tp.equals("today"))
		{
			try {
				cal.add(Calendar.DAY_OF_MONTH,1);
				from_date = shortsdf.parse(shortsdf.format(cal.getTime()));
				to_date = shortsdf.parse(shortsdf.format(cal.getTime()));
				trigger_time = shortsdf.parse(shortsdf.format(cal.getTime()));
				cal.add(Calendar.DAY_OF_MONTH,1);
				cal.setTime(trigger_time);
				cal.add(Calendar.MINUTE, -5);
				trigger_time = cal.getTime();
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else if(tp.equals("yesterday"))
		{
			try {
				
				to_date = shortsdf.parse(shortsdf.format(cal.getTime()));
				from_date = shortsdf.parse(shortsdf.format(cal.getTime()));
				cal.setTime(to_date);
				cal.add(Calendar.DATE, 1);
				cal.add(Calendar.MINUTE, -5);
				trigger_time = cal.getTime();
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else if(tp.equals("lastweek"))
		{
            int i = cal.get(Calendar.DAY_OF_WEEK) - cal.getFirstDayOfWeek();
            cal.add(Calendar.DATE, -i);
            try {
				from_date = shortsdf.parse(shortsdf.format(cal.getTime()));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            cal.add(Calendar.DATE, 6);
            try {
				to_date = shortsdf.parse(shortsdf.format(cal.getTime()));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            cal.add(Calendar.DATE,1);
            try {
				trigger_time = shortsdf.parse(shortsdf.format(cal.getTime()));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else if(tp.equals("lastmonth"))
		{
            cal.set(Calendar.DATE, 1);
            try {
				from_date = shortsdf.parse(shortsdf.format(cal.getTime()));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            cal.set(Calendar.DATE,cal.getActualMaximum(Calendar.DAY_OF_MONTH));
            try {
				to_date = shortsdf.parse(shortsdf.format(cal.getTime()));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            cal.add(Calendar.DATE,1);
            try {
				trigger_time = shortsdf.parse(shortsdf.format(cal.getTime()));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else if(tp.equals("lastquarter"))
		{
			int month = cal.get(Calendar.MONTH);
            int mths = month%3;			
			cal.add(Calendar.MONTH, (-mths));
			cal.set(Calendar.DATE, 1);
			try {
				from_date = shortsdf.parse(shortsdf.format(cal.getTime()));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			cal.add(Calendar.MONTH, (2));
			cal.set(Calendar.DATE, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
			try {
				to_date = shortsdf.parse(shortsdf.format(cal.getTime()));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			cal.add(Calendar.DATE,1);
			
			try {
				trigger_time = shortsdf.parse(shortsdf.format(cal.getTime()));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		report.setFromdate(sdf.format(from_date));
		report.setTodate(sdf.format(to_date));
		report.setNextfiretime(trigger_time);
		M2MSchReportsDao schcon = new M2MSchReportsDao();
		schcon.updateReport(report);
	}

	private boolean isFireTimeReached(Date nextfiretime, String daytype) {
		// TODO Auto-generated method stub
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		try {
			Date firedate = sdf.parse(sdf.format(nextfiretime));
			if(Calendar.getInstance().getTime().compareTo(firedate) == 1)
			{
				if(daytype.equals("today") || daytype.equals("yesterday"))
				{
					SimpleDateFormat dsdf = new SimpleDateFormat("HHmm");
					int triggertime = Integer.parseInt(dsdf.format(Calendar.getInstance().getTime()));
					if(triggertime >= 2355)
						return true;
					
					return false;
				}
				else
				return true;
			}
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}

	private boolean doEmail(File attach_file,String to_mail,String reportname) {
		// TODO Auto-generated method stub
		//String imission_path = PropertiesManager.getM2MProperties().getProperty("imissionpath");

		/*
		 * if(imission_path != null) {
		 */
			//Properties imission_m2m_props = M2MProperties.getM2MProperties(); 
		Properties imission_m2m_props = M2MProperties.getM2MProperties();

			String s_username = imission_m2m_props.getProperty("username");
			String s_password = imission_m2m_props.getProperty("password");
			try {
				MailSender sender = new MailSender(s_username, s_password, to_mail, attach_file, reportname);
				sender.sendMail();
				return true;
			}
			catch (Exception e)
			{
				logger.error("Sending Schdule Report to "+to_mail+" is failed");
				logger.error(e.getMessage());
				return false;
			}
		/*}
		else
		{
			logger.error("imissionpath is not configured in m2m.properies file");
			return false;
		}*/
	}

	/*
	 * private Properties getImissionM2MProperties(File file) {
	 * 
	 * Properties props = new Properties(); FileReader propfile = null; try {
	 * propfile = new FileReader(file); props.load(propfile);
	 * 
	 * } catch (Exception e) { // TODO Auto-generated catch block
	 * e.printStackTrace(); } finally {
	 * 
	 * if(propfile != null) try { propfile.close();
	 * 
	 * } catch (IOException e) { // TODO Auto-generated catch block } } return
	 * props; }
	 */
	private Vector<String> getdates(String period)
	{
		String fromdate="";
		String todate="";
		Calendar cal = Calendar.getInstance();
		Vector<String> datesvec = new Vector<String>();
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		if(period.equals("today"))
		{
			fromdate = sdf.format(cal.getTime());       
			todate = sdf.format(cal.getTime());
		}
		else if(period.equals("yesterday"))
		{
			cal.add(Calendar.DATE, -1);
			todate = sdf.format(cal.getTime());
			fromdate = sdf.format(cal.getTime());
		}
		else if(period.equals("lastweek"))
		{
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
		}
		else if(period.equals("lastmonth"))
		{
			Calendar aCalendar = Calendar.getInstance();
			aCalendar.add(Calendar.MONTH, -1);
			aCalendar.set(Calendar.DATE, 1);
			Date start = aCalendar.getTime();
			fromdate = sdf.format(start);
			aCalendar.set(Calendar.DATE,aCalendar.getActualMaximum(Calendar.DAY_OF_MONTH));
			Date end = aCalendar.getTime();
			todate = sdf.format(end);
		}
		else if(period.equals("lastquarter"))
		{
			Calendar stmth = Calendar.getInstance();
			Calendar endmth = Calendar.getInstance();
			int month = stmth.get(Calendar.MONTH)+1;
			int mths = month%3==0?3:month%3;
			stmth.add(Calendar.MONTH, (-2-mths));
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
