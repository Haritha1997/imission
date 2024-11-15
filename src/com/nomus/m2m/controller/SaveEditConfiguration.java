package com.nomus.m2m.controller;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Calendar;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.nomus.m2m.dao.NodedetailsDao;
import com.nomus.m2m.pojo.NodeDetails;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.M2MProperties;
import com.nomus.staticmembers.UserTempFile;

/**
 * Servlet implementation class SaveEditConfiguration
 */
@WebServlet("/m2m/SaveEditConfiguration")
public class SaveEditConfiguration extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SaveEditConfiguration() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		User user = (User) request.getSession().getAttribute("loggedinuser");
		String slnumber=request.getParameter("slnumber");
		Properties m2mprops = M2MProperties.getM2MProperties();
		String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
		String zipFilePath = slnumpath+File.separator+m2mprops.getProperty("targetfilename");

		response.setContentType("text/HTML");
		PrintWriter pw = response.getWriter();
		pw.write("<html>");
		pw.write("<head>");
		pw.write(" <meta http-equiv=\"pragma\" content=\"no-cache\">");
		pw.write("<style type=\"text/css\">.button{display: block;border-radius: 6px;background-color:#6caee0;color: #ffffff;font-weight: bold;box-shadow: 1px 2px 4px 0 rgba(0, 0, 0, 0.08);padding: 12px 20px;border: 0;margin: 40px 183px 0;}.style1{font-family: \"Trebuchet MS\", Arial, Helvetica, sans-serif;color:#5798B4;font-size: 18px;font-weight: bold;}.style2{font-family: \"Trebuchet MS\", Arial, Helvetica, sans-serif;color:#000000;font-size: 16px;font-weight: bold;}body{background-color: #FAFCFD;}</style>");
		pw.write("</head>");
		pw.write("<body>");
		pw.write("<form action=\"/cgi/Nomus.cgi?command=password\" method=\"post\">");
		pw.write("<p>&nbsp;</p>");
		pw.write("<p>&nbsp;</p>");
		pw.write("<hr noshade=\"\" color=\"#5798B4\">");
		pw.write("<p>&nbsp;</p>");
		pw.write("<p class=\"style2\" align=\"center\">Configuration Save in Progress.Please Wait...</p>");
		pw.write("<p class=\"style2\" align=\"center\"> </p>");
		pw.write("<p>&nbsp;</p>");
		pw.write("<hr noshade=\"\" color=\"#5798B4\">");
		pw.write("</form>");
		pw.write("</body>");
		
		NodedetailsDao ndao = new NodedetailsDao();
 		NodeDetails ndet = ndao.getNodeDetails("slnumber", slnumber);
			
		File srcfile = new File(slnumpath+File.separator+"Config.json");
		File desfile  = new File(slnumpath+File.separator+"WiZ_NG"+File.separator+"Startup_Configurations"+File.separator+"Config.json");
		Files.copy(srcfile.toPath(), desfile.toPath(),StandardCopyOption.REPLACE_EXISTING);
		File targetfile = new File(zipFilePath);
		File m2mvalid_file = new File(slnumpath+File.separator+"WiZ_NG"+File.separator+"Startup_Configurations"+File.separator+"M2MValidation.txt");
		FileWriter m2m_fw = null;
		BufferedWriter m2m_bw = null;
		try{
			m2m_fw = new FileWriter(m2mvalid_file);
			m2m_bw = new BufferedWriter(m2m_fw);
			m2m_bw.write("modified");
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			if(m2m_bw != null)
				m2m_bw.close();
			if(m2m_fw != null)
				m2m_fw.close();
		}
		if(targetfile.exists())
			targetfile.delete();

		/****** from here *****/
		String osname = System.getProperty("os.name");
		ProcessBuilder builder = null;
		Process p = null;
		if(osname.toLowerCase().startsWith("windows"))
		{
			builder = new ProcessBuilder("cmd.exe", "/c", "7za.exe a -tzip "+slnumpath+File.separator+"WiZ_NG.zip "+slnumpath+File.separator+"WiZ_NG"+File.separator+"Startup_Configurations");
			p = builder.start();
		}
		else
		{
			p = Runtime.getRuntime().exec("zip "+slnumpath+File.separator+"WiZ_NG.zip "+slnumpath+File.separator+"WiZ_NG");
			builder = new ProcessBuilder("7za.exe a -tzip "+slnumpath+File.separator+"WiZ_NG.zip "+slnumpath+File.separator+"WiZ_NG");
		}

		//ProcessBuilder builder = new ProcessBuilder("cmd.exe", "/c", "zip.exe");
		builder.redirectErrorStream(true);
		BufferedReader r = new BufferedReader(new InputStreamReader(p.getInputStream()));
		String line;
		while (true) {
			line = r.readLine();
			if (line == null) { break; }
			System.out.println(line);
		}
		r.close();
		/***** TO Here *****/

		File bulkeditfile = new File(UserTempFile.getUserTempDir(user,"Bulk-Edit")+File.separator+"bulkedit.txt");
		if(bulkeditfile.exists())
		{
			File target_file = new File(UserTempFile.getUserTempDir(user,"Bulk-Edit")+File.separator+m2mprops.getProperty("targetfilename")); 
			File src_file = new File(zipFilePath);
			try
			{
				Files.copy(src_file.toPath(),target_file.toPath(),StandardCopyOption.REPLACE_EXISTING);
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
		if(ndet != null)
		{
			ndet.setCversion(ndet.getCversion()+1);
			ndet.setSendconfig("yes");
			ndet.setConfiginittime(Calendar.getInstance().getTime());
			ndao.updateNodeDetails(ndet);
		}
		response.sendRedirect("saved.jsp");
		pw.write("</html>");
	}
}
