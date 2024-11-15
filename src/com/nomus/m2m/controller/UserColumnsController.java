package com.nomus.m2m.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.nomus.m2m.dao.UserColumnsDao;
import com.nomus.m2m.pojo.User;
import com.nomus.m2m.pojo.UserColumns;

@WebServlet("/userColumnsController")
public class UserColumnsController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String tablename = request.getParameter("tablename");
		String pagename = request.getParameter("pagename");
		//String dashboad_cols[]={"Node Label","WAN IP","Loopback IP","Serial Number","Location","FW Version","Model Number","Router Uptime","IMEI No","Active SIM","Network","Signal Strength","P0","P1","P2","P3/W"};
		try
		{
			User loggedinuser = (User) request.getSession().getAttribute("loggedinuser");
			List<UserColumns> usercollist = loggedinuser.getUserColumnsList();

			for(UserColumns usercols : usercollist)
			{
				if(!usercols.getTableName().equals(tablename))
					continue;
				usercols.setImeinumber(request.getParameter("IMEI Noid")== null ? "no" : "yes");
				usercols.setActivesim(request.getParameter("Active SIMid")== null ? "no" : "yes");
					usercols.setPort1(request.getParameter("P0id")== null ? "no" : "yes");
					usercols.setPort2(request.getParameter("P1id")== null ? "no" : "yes");
					usercols.setPort3(request.getParameter("P2id")== null ? "no" : "yes");
					usercols.setPort4(request.getParameter("P3id")== null ? "no" : "yes");
					usercols.setWAN(request.getParameter("WANid")== null ? "no" : "yes");
				usercols.setRouteruptime(request.getParameter("Router Uptimeid")== null ? "no" : "yes");
				usercols.setSignalstrength(request.getParameter("Signal Strengthid")== null ? "no" : "yes");
				usercols.setLocation(request.getParameter("Locationid")== null ? "no" : "yes");
				usercols.setFwversion(request.getParameter("FW Versionid")== null ? "no" : "yes");
				usercols.setLoopbackip(request.getParameter("Loopback IPid")== null ? "no" : "yes");
				usercols.setModelnumber(request.getParameter("Model Numberid")== null ? "no" : "yes");
				usercols.setNetwork(request.getParameter("Networkid")== null ? "no" : "yes");
				usercols.setNodelabel(request.getParameter("Node Labelid")== null ? "no" : "yes");
				usercols.setSlnumber(request.getParameter("Serial Numberid")== null ? "no" : "yes");
				usercols.setCellular_Wan_IP(request.getParameter("Connected IPid")== null ? "no" : "yes");
				usercols.setDi1(request.getParameter("DI1id")== null ? "no" : "yes");
				usercols.setDi2(request.getParameter("DI2id")== null ? "no" : "yes");
				usercols.setDi3(request.getParameter("DI3id")== null ? "no" : "yes");
				UserColumnsDao ucoldao = new UserColumnsDao();
				ucoldao.updateUserColumns(usercols);
				//usercols.setCellid(request.getParameter("cellid")== null ? "no" : "yes");
				//usercols.setCpuutil(request.getParameter("cpuutil")== null ? "no" : "yes");
				//usercols.setDhversion(request.getParameter("dhversion")== null ? "no" : "yes");
				//usercols.setIccid(request.getParameter("iccid")== null ? "no" : "yes");
				//usercols.setIpaddress(request.getParameter("ipaddress")== null ? "no" : "yes");
				//usercols.setMemoryutil(request.getParameter("memoryutil")== null ? "no" : "yes");
				//usercols.setMhversion(request.getParameter("mhversion")== null ? "no" : "yes");
				//usercols.setModulename(request.getParameter("modulename")== null ? "no" : "yes");
				//usercols.setNwband(request.getParameter("nwband")== null ? "no" : "yes");
				//usercols.setStatus(request.getParameter("status")== null ? "no" : "yes");
			}
			
		}
		catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		String redirecturl = "/imission/index.jsp"; 
		if(pagename.equals("active"))
			redirecturl = redirecturl+"?type=active&lisubmenu=Active";
		else if(pagename.equals("down"))
			redirecturl = redirecturl+"?type=down&lisubmenu=Down";
		else if(pagename.equals("inactive"))
			redirecturl = redirecturl+"?type=inactive&lisubmenu=In Active";
		response.sendRedirect(redirecturl);
	}

}
