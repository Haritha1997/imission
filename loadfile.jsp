
<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.hibernate.Session"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.nio.file.StandardCopyOption"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.util.Properties"%>

<jsp:include page="/bootstrap.jsp" flush="false" >
   <jsp:param name="title" value="M2M" />
   <jsp:param name="headTitle" value="M2M" />
  </jsp:include>
<head>
<script type="text/javascript">
function goToErrorUrl(msg)
{
  window.location.href = "error.jsp?error="+msg;
}
function redirectUrl(slnumbers)
{
  window.location.href = "m2m/m2m.jsp";
}
</script>
</head>
<%
	try
	{
		
	Properties props = M2MProperties.getM2MProperties();

	String serverconfigPath = props.getProperty("httpserverpath").trim();
	String tlsconfigspath = props.getProperty("tlsconfigspath").trim();
	String targetfilename = "WiZ_NG.dat";
	targetfilename = props.getProperty("targetfilename")==null?targetfilename:props.getProperty("targetfilename").trim();
	
	//System.out.println("server path is : "+serverconfigPath+" tlsconfigspath is : "+tlsconfigspath);
    File serverconfigfile = new File(serverconfigPath);
    if(!serverconfigfile.exists())
		serverconfigfile.mkdir();
	File tlsconfigs = new File(tlsconfigspath); 
	String loadpath = tlsconfigspath+"/load";
	String serialno = request.getParameter("serialno");
	String is_bulkedit = request.getParameter("bulkedit");
	System.out.println("Serial number is : "+serialno);
	File srcdir = new File(loadpath+"/"+serialno);
	boolean copy_from_configs = true;
	File configfile = null;
	String slnumbers="";
	if(srcdir.exists())
	{
		configfile = new File(srcdir.getAbsolutePath()+"/"+targetfilename);
		if(configfile.exists())
		copy_from_configs = false;
	}
	System.out.println("copy_from_configs : "+copy_from_configs);

	if(copy_from_configs)
		configfile = new File(tlsconfigspath+"/"+serialno+"/"+targetfilename);	
	Connection con=null;
	Statement st = null;
	Session hibsession = null;
		
	if(configfile != null && configfile.exists())		
	{
		    BufferedWriter bw = null;
			File severconfigfile = new File(serverconfigPath + "/"+targetfilename);
			try {
				 
				Files.copy(configfile.toPath(), severconfigfile.toPath(), StandardCopyOption.REPLACE_EXISTING);
				bw = new BufferedWriter(new FileWriter(serverconfigPath+File.separator+"serialnumber.txt"));
				bw.write(serialno);
				bw.close();
				bw = new BufferedWriter(new FileWriter(serverconfigPath+File.separator+"Bulk-Edit.txt"));
				bw.write(is_bulkedit);
				bw.close();
				hibsession = HibernateSession.getDBSession();
				con = ((SessionImpl) hibsession).connection();
				st = con.createStatement();
				if(is_bulkedit.equalsIgnoreCase("true"))
				{
					File bulkeditfile = new File(tlsconfigspath+File.separator+"Bulk-Edit");
					if(!bulkeditfile.exists())
						bulkeditfile.mkdir();
					for(File file : bulkeditfile.listFiles())
						file.delete();
				}
			    
			    st.executeUpdate("update Nodedetails set sendconfigstatus=0 where slnumber = '"+serialno+"'");
				session.setAttribute("m2medit", "true");
				session.setAttribute("bulkedit",is_bulkedit);
                session.setAttribute("slnumbers",request.getParameter("slnumbers"));
				slnumbers = request.getParameter("slnumbers");
			} catch (Exception e) {
				e.printStackTrace();
			%>   
				<Script>
				goToErrorUrl("Error came while loading the File");
				</Script>
			<%
			}
			finally
			{
				if(hibsession != null)
					hibsession.close();
				if(bw != null)
					bw.close();
				
					
				if(st != null)
					st.close();
			}
	}
        else
	{
            %>  
			<Script>
				alert("No Configuration file of <%=serialno%> is exists ");
			</Script>
        <%}
	%>
			<Script>
				redirectUrl("<%=slnumbers%>");
			</Script>
	<%} catch (Exception e) {
	%>	
			<Script>
				goToErrorUrl("Error came while loading the File");
			</Script>
	<%}
%>
