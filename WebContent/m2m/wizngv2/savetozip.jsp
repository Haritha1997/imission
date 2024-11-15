<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.hibernate.Session"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="javax.print.attribute.standard.Destination"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.zip.ZipEntry"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.util.zip.ZipOutputStream"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.nio.file.StandardCopyOption"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.FileReader"%>
<%
String slnumber=request.getParameter("slnumber");
int cversion = 1;
Properties m2mprops = M2MProperties.getM2MProperties();
String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
String zipFilePath = slnumpath+File.separator+m2mprops.getProperty("targetfilename");

JSONObject strtng_table = null;
JSONArray strtngnumarr = null;
BufferedReader jsonfile = null;
String product_type = "";   
%>
<html>
   <head>
      <meta http-equiv="pragma" content="no-cache">
      <style type="text/css">.button{display: block;border-radius: 6px;background-color:#6caee0;color: #ffffff;font-weight: bold;box-shadow: 1px 2px 4px 0 rgba(0, 0, 0, 0.08);padding: 12px 20px;border: 0;margin: 40px 183px 0;}.style1{font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;color:#5798B4;font-size: 18px;font-weight: bold;}.style2{font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;color:#000000;font-size: 16px;font-weight: bold;}body{background-color: #FAFCFD;}</style>
   </head>
   <body>
      <form action="/cgi/Nomus.cgi?command=password" method="post">
         <p>&nbsp;</p>
         <p>&nbsp;</p>
         <hr noshade="" color="#5798B4">
         <p>&nbsp;</p>
         <p class="style2" align="center">Configuration Save in Progress.Please Wait...</p>
         <p class="style2" align="center"> </p>
         <p>&nbsp;</p>
         <hr noshade="" color="#5798B4">
      </form>
   </body>
   <%  
   	Connection con = null;
   	Statement st = null;
	ResultSet rs = null;
	Session hibsession = null;
   	try
   	{
   		hibsession = HibernateSession.getDBSession();
	  	con = ((SessionImpl)hibsession).connection();
	  	st=con.createStatement();
	  	rs = st.executeQuery("select cversion from nodedetails where slnumber ='"+slnumber+"'");
	  	if(rs.next())
	  	{
		  	cversion = rs.getInt(1)+1;
	  	}
	  	st.executeUpdate("update nodedetails set cversion = cversion+1,sendconfig = 'yes' where slnumber ='"+slnumber+"'");
   	}
   	catch(Exception e)
   	{
  	 	e.printStackTrace();
   	}
   	finally
   	{
   		if(hibsession != null)
   			hibsession.close();
  	 	if(rs != null)
  		 	rs.close();
  	 	if(st != null)
  		 	st.close();  	 	
   }
   
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
     
        File bulkeditfile = new File(slnumpath+File.separator+"bulkedit.txt");
        if(bulkeditfile.exists())
        {
        	File target_file = new File(m2mprops.getProperty("tlsconfigspath")+File.separator+"Bulk-Edit"+File.separator+m2mprops.getProperty("targetfilename")); 
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
     response.sendRedirect("saved.jsp");
   %> 

 <%!   public void zipDir(String dir2zip, ZipOutputStream zos,String slnumpath) 
{
      try 
   { 
        File zipDir  = new File(dir2zip);
        String[] dirList = zipDir.list();
        
        byte[] readBuffer = new byte[2156]; 
        int bytesIn = 0; 
        for(int i=0; i<dirList.length; i++) 
        { 
            File f = new File(zipDir, dirList[i]); 
        if(f.isDirectory()) 
        { 
                //if the File object is a directory, call this 
                //function again to add its content recursively
            String filePath = f.getPath(); 
            zipDir(filePath, zos,slnumpath); 
            continue; 
        } 
            FileInputStream fis = new FileInputStream(f);
            //System.out.println("file path is : "+f.getPath()+"    "+slnumpath.replace("/","\\")+File.separator+"WiZ_NG"+File.separator);
        	ZipEntry anEntry = new ZipEntry(f.getAbsolutePath().replace(slnumpath.replace("/","\\")+File.separator+"WiZ_NG"+File.separator,"")); 
            //place the zip entry in the ZipOutputStream object 
        	zos.putNextEntry(anEntry);
            while((bytesIn = fis.read(readBuffer)) != -1) 
            { 
                zos.write(readBuffer, 0, bytesIn); 
            } 
           fis.close(); 
    } 
   }
      catch(Exception e)
      {
    	  e.printStackTrace();
      }    
}
        ////
   %>
</html>

