
<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.hibernate.Session"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.nio.file.StandardCopyOption"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.IOException"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.SQLException" %>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.util.*" %>
<%@page import="java.lang.*" %>

<%@page import="javax.servlet.MultipartConfigElement"%>
<%@page import="javax.servlet.ServletException"%>
<%@page import="javax.servlet.annotation.WebServlet"%>
<%@page import="javax.servlet.http.HttpServlet"%>
<%@page import="javax.servlet.http.HttpServletRequest"%>
<%@page import="javax.servlet.http.HttpServletResponse"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="javax.servlet.http.Part"%>
   
   <jsp:include page="/bootstrap.jsp" flush="false" >
   <jsp:param name="title" value="M2M" />
   <jsp:param name="headTitle" value="M2M" />
  </jsp:include>
  <html>
  <head>
  <script type="text/javascript">
  function redirectUrl(statusstr)
  {
	  const form = document.createElement('form');
		form.method = "post";
		form.action = "m2m/orgupdate.jsp";
	      const hiddenField1 = document.createElement('input');
	      hiddenField1.type = 'hidden';
	      hiddenField1.name = "status";
	      hiddenField1.value = statusstr;
	      form.appendChild(hiddenField1);
		  document.body.appendChild(form);
		  form.submit();
  }
  </script>
  </head>
  <body>
  <%
  
   try
	 {
		MultipartConfigElement MULTI_PART_CONFIG = new MultipartConfigElement(System.getProperty("java.io.tmpdir"));
	    //request.setAttribute(Request.__MULTIPART_CONFIG_ELEMENT, MULTI_PART_CONFIG);
	    //response.setContentType("text/plain;charset=UTF-8");
	    Part bulkfilePart = request.getPart("orgupdatefile");
	 }
	 catch(Exception e)
	 {
		
	 }
    int rowcnt = Integer.parseInt(request.getParameter("cntid"));
    String options[] = request.getParameterValues("options");
    String status = ""; 
    String slnumber = "";
    if(rowcnt != 0 && options != null)
    {
    	for(int i=1;i<=rowcnt;i++)
    	{
			boolean success = true;
			slnumber = request.getParameter("slnumber"+i).trim();
			Properties m2mprops = getM2MProps();
    		JSONObject wizjsonnode = getJsonObject(slnumber,m2mprops);
    		if(wizjsonnode != null)
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
  				 
  				
  				updateOption(wizjsonnode,option,value,subnet);  				  
  			  }
  			String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
  			String zipFilePath = slnumpath+File.separator+m2mprops.getProperty("targetfilename");
  			zipFilesAndFolders(slnumber,wizjsonnode,slnumpath,zipFilePath);
  			Connection con = null;
  			Statement st = null;
  			File jsonfile = null;
  			Session hibsession = null;
  		    jsonfile = new File(slnumpath+File.separator+"Config.json");
  			BufferedWriter jsonWriter = null;
			try
			{
					hibsession = HibernateSession.getDBSession();
					con = ((SessionImpl) hibsession).connection();
					jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
				   	jsonWriter.write(wizjsonnode.toString(2));
				   	st = con.createStatement();
				   	String sql = "update nodedetails set orgupdate=1 where slnumber='"+slnumber+"'";
				   	st.executeUpdate(sql);
				  
			}
			catch(Exception e)
			{
				 success = false;
				 e.printStackTrace();
			}
			finally
			{
				 if(hibsession != null)
		    		  hibsession.close();
				
					
				if(st != null)
					st.close();
				if(jsonWriter != null)
				 jsonWriter.close();
				  
			}
				status += slnumber+(success?" : Success":" : Failed")+"$newline$"; 
  		  }
		  else
		  status += slnumber+" : failed, No device has this Serial Number$newline$";
    	}
    }
    %>
    <%! Properties getM2MProps()
       {
    	Properties m2mprops = null;
    	 try
    	 {
    	 	m2mprops = M2MProperties.getM2MProperties();
    	 }
    	 catch(Exception e)
    	 {
    		 
    	 }
    	 finally
    	 {
    		 try
    		 {
    		 }
    		 catch(Exception e)
    		 {
    			 
    		 }
    	 }
    	 return m2mprops;
       }
    %>
  <%!
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
  %>
  <%! 
   public boolean zipFilesAndFolders(String slnumber,JSONObject wizjsonnode,String slnumpath, String zipFilePath)
   {
	  boolean zipped = true;
	  int cversion = 0;
	    Connection con = null;
	   	Statement st = null;
		ResultSet rs = null;
		Session hibsession = null;
	   	try
	   	{
	   		hibsession = HibernateSession.getDBSession();
			con = ((SessionImpl) hibsession).connection();
		  	st=con.createStatement();
		  	rs = st.executeQuery("select cversion from nodedetails where slnumber ='"+slnumber+"'");
		  	if(rs.next())
		  	{
			  	cversion = rs.getInt(1)+1;
		  	}
		  	st.executeUpdate("update nodedetails set cversion = cversion+1 where slnumber ='"+slnumber+"'");
	   	}
	   	catch(Exception e)
	   	{
	  	 	e.printStackTrace();
	   	}
	   	finally
	   	{
	   		if(hibsession != null)
				hibsession.close();
	   		try
	   		{
	  	 	if(rs != null)
	  		 	rs.close();
	  	 	if(st != null)
	  		 	st.close();
	  	 	
	  		 	
	   		}
	   		catch(Exception e){}
	   }
	   
	    	JSONObject m2mconfobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").getJSONObject("M2M");
			if(m2mconfobj != null)
			{
				m2mconfobj.put("Modified_User","M2M");
				m2mconfobj.put("Version",cversion);
			}
			
	    	File srcfile = new File(slnumpath+File.separator+"Config.json");
	    	wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
			.put("M2M", m2mconfobj);
	   
	   	BufferedWriter jsonWriter = null;
	   	try
	   	{
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
	    //File statupdir = new File(desDir.getAbsolutePath()+File.separator+"Startup_Configurations");
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
   
  %>
  <%! 
    public void updateOption(JSONObject wizjsonnode,String option,String value,String subnet)
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
  %>
  </body>
   <script>
	try
	{
		redirectUrl("<%=status%>"); 
	}
	catch(error)
	{
		console.log(error);
	}
   </script>
 </html>