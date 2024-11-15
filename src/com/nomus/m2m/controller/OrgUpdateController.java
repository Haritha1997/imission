package com.nomus.m2m.controller;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.net.util.SubnetUtils;

import com.nomus.m2m.dao.NodedetailsDao;
import com.nomus.m2m.pojo.NodeDetails;
import com.nomus.staticmembers.FileExtracter;
import com.nomus.staticmembers.M2MProperties;
import com.nomus.staticmembers.Symbols;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * Servlet implementation class OrgUpdateController
 */
@WebServlet("/m2m/saveOrgUpdate")
@MultipartConfig(fileSizeThreshold=1024*1024*20,
maxFileSize=1024*1024*100,      	
maxRequestSize=1024*1024*200)
public class OrgUpdateController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public OrgUpdateController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		int rowcnt = Integer.parseInt(request.getParameter("cntid"));
		String options[] = request.getParameterValues("options");
		String status = ""; 
		String slnumber = "";
		HttpSession httpsession = request.getSession();


		if(rowcnt != 0 && options != null)
		{
			for(int i=1;i<=rowcnt;i++)
			{
				boolean success = true;
				slnumber = request.getParameter("slnumber"+i).trim();
				Properties m2mprops = M2MProperties.getM2MProperties();
				NodedetailsDao nddao = new NodedetailsDao();
				NodeDetails nd =  nddao.getNodeDetails("slnumber", slnumber);
				JSONObject wizjsonnode = getJsonObject(slnumber,m2mprops);
				if(wizjsonnode != null && nd != null)
				{
					for(String option : options)
					{
						String value = "";
						String subnet = "";
						if (option.equals("LoopbckIP"))
						{
							value = request.getParameter("loopbackip"+i).trim();
							subnet = request.getParameter("lsubnet"+i).trim();
						}
						else if(option.equals("Eth0IP"))
						{
							value = request.getParameter("eth0ip"+i).trim();
							subnet = request.getParameter("e0subnet"+i).trim();
						}
						else if (option.equals("Eth1IP"))
						{
							value = request.getParameter("eth1ip"+i).trim();
							subnet = request.getParameter("e1subnet"+i).trim();
						}
						else if (option.equals("Systemname"))
							value = request.getParameter("sysname"+i).trim();
						else if (option.equals("Location"))
							value = request.getParameter("location"+i).trim();

						if(nd.getFwversion().startsWith(Symbols.WiZV2))
						{
							if (option.equals("LoopbckIP"))
							{
								//remove old Loopbak data
								JSONObject loopbackobj = wizjsonnode.getJSONObject("network").getJSONObject("interface:loopback");
								JSONArray loopback_ip_arr = new JSONArray();
								if(loopbackobj != null && loopbackobj.containsKey("ipaddr"))
									loopback_ip_arr = loopbackobj.getJSONArray("ipaddr");
								for(int ind=loopback_ip_arr.size()-1;ind>-1;ind--)
									loopback_ip_arr.remove(ind);

								loopbackobj.put("ipaddr", loopback_ip_arr);
								wizjsonnode.getJSONObject("network").put("interface:loopback",loopbackobj);
							}
							else if(option.equals("Eth0IP"))
							{
								//remove old LAN data
								JSONObject lanobj = wizjsonnode.getJSONObject("network").getJSONObject("interface:lan");
								JSONArray lanip_arr = new JSONArray();
								if(lanip_arr != null && lanobj.containsKey("ipaddr"))
									lanip_arr = lanobj.getJSONArray("ipaddr");
								for(int ind=lanip_arr.size()-1;ind>-1;ind--)
									lanip_arr.remove(ind);

								lanobj.put("ipaddr",lanip_arr);
								wizjsonnode.getJSONObject("network").put("interface:lan", lanobj);
							}
							else if (option.equals("Eth1IP"))
							{
								//remove old WAN data	
								JSONObject wanobj =wizjsonnode.getJSONObject("network").getJSONObject("interface:wan");
								JSONArray wanip_arr = new JSONArray();
								if(wanobj != null && wanobj.containsKey("ipaddr") )
									wanip_arr = wanobj.getJSONArray("ipaddr");
								for(int ind=wanip_arr.size()-1;ind>-1;ind--)
									wanip_arr.remove(ind);

								wanobj.put("ipaddr",wanip_arr);
								wizjsonnode.getJSONObject("network").put("interface:wan", wanobj);
							}

						}
						updateOption(wizjsonnode,option,value,subnet,nd.getFwversion());  				  
					}
					String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
					String zipFilePath = slnumpath+File.separator+m2mprops.getProperty("targetfilename");
					zipFilesAndFolders(slnumber,wizjsonnode,slnumpath,zipFilePath,nd.getCversion()+1,nd.getFwversion());
					File jsonfile = null;
					jsonfile = new File(slnumpath+File.separator+"Config.json");
					BufferedWriter jsonWriter = null;
					try
					{
						jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
						jsonWriter.write(wizjsonnode.toString(2));
						nd.setOrgupdate(1);
						nd.setCversion(nd.getCversion()+1);
						nddao.updateNodeDetails(nd);
					} 
					catch(Exception e)
					{
						success = false;
						e.printStackTrace();
					}
					finally
					{
						if(jsonWriter != null)
							jsonWriter.close();
					}
					status += slnumber+(success?" : Success":" : Failed")+"$newline$"; 
				}
				else
					status += slnumber+" : failed, No device has this Serial Number$newline$";
			}
		}
		if(status.length() > 0)
			httpsession.setAttribute("status", status);
		response.sendRedirect("orgupdate.jsp");
	}

	public JSONObject getJsonObject(String slnumber,Properties m2mprops)
	{
		File jsonfile = null;
		JSONObject wizjsonnode = null;
		BufferedReader jsonfilebr = null; 

		String jsonString="";
		try
		{
			String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
			jsonfile = new File(slnumpath+File.separator+"Config.json");
			//if(!jsonfile.exists())
			FileExtracter.extractAndCopyConfig(slnumber);
			jsonfilebr = new BufferedReader(new FileReader(jsonfile));
			StringBuilder jsonbuf = new StringBuilder("");
			while((jsonString = jsonfilebr.readLine())!= null)
				jsonbuf.append( jsonString );

			wizjsonnode= JSONObject.fromObject(jsonbuf.toString());

		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			try{

				if(jsonfilebr != null)
					jsonfilebr.close();
			}catch(Exception e)
			{

			}
		}
		return wizjsonnode;
	}

	public boolean zipFilesAndFolders(String slnumber,JSONObject wizjsonnode,String slnumpath, String zipFilePath,int cversion,String fwversion)
	{
		boolean zipped = true;
		File srcfile = new File(slnumpath+File.separator+"Config.json");
		BufferedWriter jsonWriter = null;
		try
		{
			if(!fwversion.startsWith(Symbols.WiZV2))
			{
				JSONObject m2mconfobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").getJSONObject("M2M");
				if(m2mconfobj != null)
				{
					m2mconfobj.put("Modified_User","M2M");
					m2mconfobj.put("Version",cversion);
				}
				wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").put("M2M", m2mconfobj);
			}

			jsonWriter = new BufferedWriter(new FileWriter(srcfile));
			jsonWriter.write(wizjsonnode.toString(2));

		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			try
			{
				if(jsonWriter != null)
					jsonWriter.close();
			}catch(Exception e){}
		}
		FileWriter m2m_fw = null;
		BufferedWriter m2m_bw = null;

		File desfile  = new File(slnumpath+File.separator+"WiZ_NG"+File.separator+"Startup_Configurations"+File.separator+"Config.json");
		File targetfile = new File(zipFilePath);
		try{
			Files.copy(srcfile.toPath(), desfile.toPath(),StandardCopyOption.REPLACE_EXISTING);
			File m2mvalid_file = new File(slnumpath+File.separator+"WiZ_NG"+File.separator+"Startup_Configurations"+File.separator+"M2MValidation.txt");

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
			try
			{
				if(m2m_bw != null)
					m2m_bw.close();
				if(m2m_fw != null)
					m2m_fw.close();
			}catch(Exception e)
			{}
		}
		if(targetfile.exists())
			System.out.println(targetfile.delete());
		//ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(targetfile.getAbsolutePath()));
		//zipDir(slnumpath+File.separator+"WiZ_NG", zos,slnumpath);
		//zos.close();
		/****** from here *****/
		String osname = System.getProperty("os.name");
		ProcessBuilder builder = null;
		Process p = null;
		BufferedReader br=null;
		try
		{
			if(osname.toLowerCase().startsWith("windows"))
			{
				builder = new ProcessBuilder("cmd.exe", "/c", "7za.exe a -tzip "+slnumpath+File.separator+"WiZ_NG.zip "+slnumpath+File.separator+"WiZ_NG"+File.separator+"Startup_Configurations");
				p = builder.start();
			}
			else
			{
				p = Runtime.getRuntime().exec("zip "+slnumpath+File.separator+"WiZ_NG.zip "+slnumpath+File.separator+"WiZ_NG"+File.separator+"Startup_Configurations");
				builder = new ProcessBuilder("7za.exe a -tzip "+slnumpath+File.separator+"WiZ_NG.zip "+slnumpath+File.separator+"WiZ_NG"+File.separator+"Startup_Configurations");
			}

			//ProcessBuilder builder = new ProcessBuilder("cmd.exe", "/c", "zip.exe");
			builder.redirectErrorStream(true);
			br = new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;
			while (true) {
				line = br.readLine();
				if (line == null) { break; }
				//System.out.println(line);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			try
			{
				if(br != null)
					br.close();
			}catch(Exception e){}

		}
		return zipped;
	}
	public void updateOption(JSONObject wizjsonnode,String option,String value,String subnet,String swversion)
	{
		if(swversion.startsWith(Symbols.WiZV2))
		{
			if (option.equals("LoopbckIP"))
			{
				JSONObject loopbackobj = wizjsonnode.getJSONObject("network").getJSONObject("interface:loopback");
				JSONArray loopback_ip_arr = new JSONArray();
				if(loopbackobj.get("ipaddr") != null)
					loopback_ip_arr = loopbackobj.getJSONArray("ipaddr");

				boolean found = false;
				for(int i=loopback_ip_arr.size()-1;i>=0;i--)
				{
					String cidr_loopip = loopback_ip_arr.getString(i);
					SubnetUtils looputils = new SubnetUtils(cidr_loopip);
					looputils.setInclusiveHostCount(true);
					String lanipaddress=looputils.getInfo().getAddress();
					if(lanipaddress.trim().equals(value.trim()))
					{
						found = true;
						break;
					}
				}
				if(!found)
				{
					if(!value.contains(",")&&!subnet.contains(","))
					{
						SubnetUtils sutils = new SubnetUtils(value,subnet);
						loopback_ip_arr.add(sutils.getInfo().getCidrSignature());
					}
					else
					{
						String vals[]=value.split(",");
						String subnetvals[]=subnet.split(",");
						for(int i=0;i<vals.length;i++)
						{
							SubnetUtils sutils = new SubnetUtils(vals[i],subnetvals[i]);
							loopback_ip_arr.add(sutils.getInfo().getCidrSignature());
						}
								
					}
					loopbackobj.put("enabled","1");
				}

				loopbackobj.put("ipaddr", loopback_ip_arr);
				wizjsonnode.getJSONObject("network").put("interface:loopback",loopbackobj);
			}
			else if (option.equals("Eth0IP"))
			{
				JSONObject lanobj = wizjsonnode.getJSONObject("network").getJSONObject("interface:lan");
				JSONArray lanip_arr = new JSONArray();
				if(lanip_arr != null)
					lanip_arr = lanobj.getJSONArray("ipaddr");
				boolean found = false;
				for(int i=lanip_arr.size()-1;i>=0;i--)
				{
					String cidr_lanip = lanip_arr.getString(i);
					SubnetUtils lanutils = new SubnetUtils(cidr_lanip);
					lanutils.setInclusiveHostCount(true);
					String lanipaddress=lanutils.getInfo().getAddress();
					if(lanipaddress.trim().equals(value.trim()))
					{
						found = true;
						break;
					}
				}
				if(!found)
				{
					if(!value.contains(",")&&!subnet.contains(","))
					{
						SubnetUtils sutils = new SubnetUtils(value,subnet);
						lanip_arr.add(sutils.getInfo().getCidrSignature());
					}
					else
					{
						String vals[]=value.split(",");
						String subnetvals[]=subnet.split(",");
						for(int i=0;i<vals.length;i++)
						{
							SubnetUtils sutils = new SubnetUtils(vals[i],subnetvals[i]);
							lanip_arr.add(sutils.getInfo().getCidrSignature());
						}
					}
				}
				lanobj.put("ipaddr",lanip_arr);
				wizjsonnode.getJSONObject("network").put("interface:lan", lanobj);
			}

			else if (option.equals("Eth1IP"))
			{
				JSONObject wanobj =wizjsonnode.getJSONObject("network").getJSONObject("interface:wan");
				JSONArray wanip_arr = new JSONArray();
				if(wanip_arr != null)
					wanip_arr = wanobj.getJSONArray("ipaddr");
				boolean found = false;
				for(int i=wanip_arr.size()-1;i>=0;i--)
				{
					String ipaddr = wanip_arr.getString(i);
					if(ipaddr.trim().equals(value.trim()))
					{
						found = true;
						break;
					}
				}
				if(!found)
				{
					SubnetUtils sutils = new SubnetUtils(value,subnet);
					wanip_arr.add(sutils.getInfo().getCidrSignature());
					wanobj.put("enabled","1");
				}
				wanobj.put("ipaddr",wanip_arr);
				wizjsonnode.getJSONObject("network").put("interface:wan", wanobj);
			}
			else if (option.equals("Systemname") || option.equals("Location"))
			{
				JSONObject systemobj =  wizjsonnode.getJSONObject("system");
				JSONObject syssnmppage =  !systemobj.containsKey("snmp:snmp")? new JSONObject():systemobj.getJSONObject("snmp:snmp");
				JSONArray systemarr = !systemobj.containsKey("system") ? new JSONArray(): systemobj.getJSONArray("system");	
				JSONObject snmpobj = wizjsonnode.containsKey("snmpd")?wizjsonnode.getJSONObject("snmpd"):new JSONObject();
				JSONArray snmpsys = !snmpobj.containsKey("system")?new JSONArray():snmpobj.getJSONArray("system");
				JSONObject systempage = null;
				JSONObject snmppage = null;
				if(snmpsys.size() > 0)
					snmppage = snmpsys.get(0)==null ? new JSONObject(): (JSONObject)snmpsys.get(0);
				if(systemarr == null)
					systemarr = new JSONArray();
				if(systemarr.size() > 0)
					systempage = systemarr.get(0)==null ? new JSONObject(): (JSONObject)systemarr.get(0);
					else
						systempage = new JSONObject();
				
				 if(syssnmppage.isNullObject()) 
					 syssnmppage = new JSONObject();
				 
				if (option.equals("Systemname"))
				{
					systempage.put("hostname",value);
					snmppage.put("sysName",value);
					syssnmppage.put("sysName",value);
				}
				else if(option.equals("Location"))
				{
					snmppage.put("sysLocation",value);
					syssnmppage.put("sysLocation",value);
				}
				if(systemarr.size() > 0)
					systemarr.remove(0);
				systemarr.add(0,systempage);
				systemobj.put("system", systemarr);
				systemobj.put("snmp:snmp", syssnmppage);
				wizjsonnode.put("system",systemobj);
				if(snmpsys.size() > 0)
					snmpsys.remove(0);
				snmpsys.add(0,snmppage);
				snmpobj.put("system", snmpsys);
				wizjsonnode.put("snmpd",snmpobj);
				
				
			}

		}
		else
		{
			if (option.equals("LoopbckIP"))
			{
				JSONObject loopbackobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
						.getJSONObject("ADDRESSCONFIG").getJSONObject("LOOPBACK");
				loopbackobj.put("ipAddress",value);
				loopbackobj.put("subnetAddress",subnet);
				loopbackobj.put("Activation","Enable");
				wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
				.getJSONObject("ADDRESSCONFIG").put("LOOPBACK", loopbackobj);
			}
			else if (option.equals("Eth0IP"))
			{
				JSONObject eth0obj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
						.getJSONObject("ADDRESSCONFIG").getJSONObject("ETH0");
				eth0obj.put("ipAddress", value);
				eth0obj.put("subnetAddress",subnet);
				wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
				.getJSONObject("ADDRESSCONFIG").put("ETH0", eth0obj);
			}

			else if (option.equals("Eth1IP"))
			{
				JSONObject wanobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
						.getJSONObject("ADDRESSCONFIG").getJSONObject("WAN");
				wanobj.put("ipAddress", value);
				wanobj.put("subnetAddress",subnet);
				wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
				.getJSONObject("ADDRESSCONFIG").put("WAN", wanobj);
			}
			else if (option.equals("Systemname") || option.equals("Location"))
			{
				JSONObject snmpobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
						.getJSONObject("SNMPCONFIG").getJSONObject("SNMP");

				if (option.equals("Systemname"))
					snmpobj.put("System_Name", value);
				else if(option.equals("Location"))
					snmpobj.put("System_Location", value);
				wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
				.getJSONObject("SNMPCONFIG").put("SNMP", snmpobj);
			}
		}
	}
}
