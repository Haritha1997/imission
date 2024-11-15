<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Set"%>
<%@page import="java.awt.SecondaryLoop"%>
<%@page import="java.sql.Savepoint"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.Vector"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   String overlapintf = ""; 
   JSONObject cellularobj = null;
   JSONObject sim1obj = null;
   JSONObject sim2obj = null;
   JSONObject sim1dataobj = null;
   JSONObject sim2dataobj = null;
 
   File jsonfile = null;
   String instname="";
   boolean internal_err = false;
   BufferedReader jsonfilebr = null;   
   String slnumber=request.getParameter("slnumber");
   String pagename=request.getParameter("page");
   String fmversion=request.getParameter("version");
   String procpage = "";
   int save_val = 0;
   final  int ETH0 = 1;
   final  int WAN = 2;
   final  int LOOPBACK= 3;
   final  int NAT = 4;
   final  int PORT_FARWARD = 5;
   final  int CELLULAR = 6;
   final  int DEFAULT_CONFIG = 7;
   final  int SAVE_CONFIG = 8;
   final  int IPSEC_CONFIG= 9;
   final  int IPSLA_CONFIG = 10;
   final  int SMS_CONFIG = 11;
   final  int FW_UPGRADE= 12;
   final  int REBOOT = 13;
   final  int PWD_CONFIG = 14;
   final  int SNMP_CONFIG = 15;
   final  int TRAP_CONFIG = 16;
   final  int ADDUSER = 17;
   final  int DELUSER = 18;
   final  int EDITUSER = 19;
   final  int HTTPPORT = 20;
   final  int DNS = 21;
   final  int IPSECTRACK = 22;
   final  int DIALER = 23;
   final  int PRODUCT_TYPE = 24;
   final  int STATIC_ROUTING = 25;
   final  int AUTOFALLBACK = 26;
   final  int IPSEC_DELETE = 27;
   final  int IPSEC_APPLY = 28;
   final int M2M_CONFIG = 29;
   final int DHCP_CONFIG = 30;
   final int DATE_TIME = 31;
   final  int LAST = 32;
   if(slnumber != null && slnumber.trim().length() > 0 && pagename != null)
   {
	   Properties m2mprops = M2MProperties.getM2MProperties();
	   String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
	   jsonfile = new File(slnumpath+File.separator+"Config.json");
	   jsonfilebr = new BufferedReader(new FileReader(jsonfile));
	   StringBuilder jsonbuf = new StringBuilder("");
	   String jsonString="";
	   try
	   {
   		  while((jsonString = jsonfilebr.readLine())!= null)
   			  jsonbuf.append( jsonString );
			
		  wizjsonnode= JSONObject.fromObject(jsonbuf.toString());
	   }
	   catch(Exception e)
	   {
		   e.printStackTrace();
		   internal_err = true;
	   }
	   finally
	   {
		   if(jsonfilebr != null)
			   jsonfilebr.close();
	   }
   }%>
<html>
<head>
<script type="text/javascript">
function goToPage(page,errorname,msg,slnumber)
{
	if (page.includes("tunnelconfig") || page.includes("user_config") 
		|| page.includes("time_date") || page.includes("cellular")) {
			var url ="";
			if (errorname.length > 0)
				url = page + "&" + errorname + "=" + msg + "&slnumber="+ slnumber;				 
			 else 
				url = page + "&slnumber="+ slnumber;
			top.frames['WelcomeFrame'].location.href = url;
		} else {
			var url ="";
			if (errorname.length > 0) {
				if(page.includes("?"))
					url = page + "&" + errorname + "=" + msg + "&slnumber="
						+ slnumber;
				else
					url = page + "?" + errorname + "=" + msg + "&slnumber="
						+ slnumber;
			} else {
				var url="";
				if(page.includes("?"))
					url = page + "&slnumber="+ slnumber;						
				else
					url = page + "?slnumber="+ slnumber;
				
			}
			top.frames['WelcomeFrame'].location.href = url;
		}
	}
</script>
</head>

<% 
   String errmsg = "";
   if(wizjsonnode != null && !internal_err)
   {   
	   if(pagename.equals("eth0"))
	   {
		   procpage = "eth0.jsp";
		   save_val = ETH0;
		   JSONObject eth0obj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
	  				.getJSONObject("ADDRESSCONFIG").getJSONObject("ETH0");
		   String primip = request.getParameter("LANIPV4").length()==0?eth0obj.getString("ipAddress"):request.getParameter("LANIPV4") ;
		   String prisubnet = request.getParameter("LANNetmask").length()==0?eth0obj.getString("subnetAddress"):request.getParameter("LANNetmask") ;
		   String secip = request.getParameter("LANSIPV4").length()==0?eth0obj.getString("secondIP"):request.getParameter("LANSIPV4");
		   String secsubnet = request.getParameter("LANSNetmask").length()==0?eth0obj.getString("secondSubnet"):request.getParameter("LANSNetmask");
		   
		   if(primip.equals(secip)  && primip.trim().length() > 0 && !primip.equals("0.0.0.0"))
		   {
			   errmsg = "Primary IP and Secondary IP Should not be same";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if((primip.length() == 0 || primip.equals("0.0.0.0")) && (secip.length() > 0 && !secip.equals("0.0.0.0")))
		   {
			   errmsg = "Must Create Primary Configuration Before Create Secondary";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if((primip.length() == 0 || primip.equals("0.0.0.0")) && (prisubnet.length() > 0 && !prisubnet.equals("0.0.0.0")))
		   {
			   errmsg = "Primary IP should not be empty";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if((secip.length() == 0 && secip.equals("0.0.0.0")) && (secsubnet.length() > 0 && !secsubnet.equals("0.0.0.0")))
		   {
			   errmsg = "Secondary IP should not be empty";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if((prisubnet.length() == 0|| prisubnet.equals("0.0.0.0")) && (primip.length() > 0 && !primip.equals("0.0.0.0")))
		   {
			   errmsg = "Primary Subnet mask should not be empty";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if((secsubnet.length() == 0 || secsubnet.equals("0.0.0.0")) && (secip.length() > 0 && !secip.equals("0.0.0.0")))
		   {
			   errmsg = "Secondary Subnet mask should not be empty";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		    else if((primip.equals(GetBroadcast(primip, prisubnet)) ||
				   primip.equals(GetNetwork(primip, prisubnet))) && !primip.equals("0.0.0.0"))
		   {
			   errmsg = "Bad mask for Primary IP Address";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if((secip.equals(GetBroadcast(secip, secsubnet)) ||
				   secip.equals(GetNetwork(secip, secsubnet))) && !secip.equals("0.0.0.0"))
		   {
			   errmsg = "Bad mask for Secondary IP Address";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if(primip.length() > 0 && !primip.equals("0.0.0.0") && !eth0obj.getString("ipAddress").equals("0.0.0.0") && (primip.equals(eth0obj.getString("secondIP")) || secip.equals(eth0obj.getString("ipAddress"))))
		   {
			   errmsg = "Primary IP and Secondary IP Should not Overlap";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if(primip.length() > 0 && (overlapintf = getOVerlapingInterface(primip,"eth0",wizjsonnode,overlapintf,prisubnet)).length() > 0)
		   {
			   
			   errmsg = "Primary IP and "+overlapintf+" Should not Overlap";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if(secip.length() > 0 && (overlapintf = getOVerlapingInterface(secip,"eth0",wizjsonnode,overlapintf,secsubnet)).length() > 0)
		   {
			   
			   errmsg = "Secondary IP and "+overlapintf+" Should not Overlap";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   
		   else
		   {
			   eth0obj.put("ipAddress", primip.length()>0?primip:eth0obj.getString("ipAddress"));
			   eth0obj.put("subnetAddress",prisubnet.length()>0?prisubnet:eth0obj.getString("subnetAddress"));
			   eth0obj.put("secondIP", secip.length()>0?secip:eth0obj.getString("secondIP"));
			   eth0obj.put("secondSubnet", secsubnet.length()>0?secsubnet:eth0obj.getString("secondSubnet"));
			   
			   wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
 				.getJSONObject("ADDRESSCONFIG").put("ETH0", eth0obj);
			   
			   setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			   
		   }
	   }   
		
	   else if(pagename.equals("wan"))
		{
		   procpage = "wan.jsp";
		   save_val = WAN;
		   JSONObject wanobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
	  				.getJSONObject("ADDRESSCONFIG").getJSONObject("WAN");
		   String wanactivat = request.getParameter("WIfSts") == null?wanobj.getString("Activation"):request.getParameter("WIfSts");
		   String wtype = request.getParameter("type") == null?wanobj.getString("Type"):request.getParameter("type");
		   String primip = request.getParameter("WIPV4").length()==0 ?wanobj.getString("ipAddress"):request.getParameter("WIPV4") ;
		   String prisubnet = request.getParameter("WNetmask").length()==0 ?wanobj.getString("subnetAddress"):request.getParameter("WNetmask") ;
		   String gateway = request.getParameter("Primarygwip").length()==0?wanobj.getString("GatewayIP"):request.getParameter("Primarygwip") ;
		   String secip = request.getParameter("WSIPV4").length()==0?wanobj.getString("secIP"):request.getParameter("WSIPV4");
		   String secsubnet = request.getParameter("WSNetmask").length()==0?wanobj.getString("secSubnet"):request.getParameter("WSNetmask");
		   String wdns = request.getParameter("oauto") == null?"Disable":request.getParameter("oauto");
		   String pridns = request.getParameter("Primary DNS").length()==0?wanobj.getString("PrimaryDNS"):request.getParameter("Primary DNS");
		   String secdns = request.getParameter("Secondary DNS").length()==0?wanobj.getString("SecondaryDNS"):request.getParameter("Secondary DNS");
		   
		   if(primip.equals(secip)  && primip.trim().length() > 0 && !primip.equals("0.0.0.0"))
		   {
			   errmsg = "Primary IP and Secondary IP Should not be same";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if((primip.length() == 0 || primip.equals("0.0.0.0")) && (secip.length() > 0 && !secip.equals("0.0.0.0")))
		   {
			   errmsg = "Must Create Primary Configuration Before Create Secondary";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if((primip.length() == 0 || primip.equals("0.0.0.0")) && (prisubnet.length() > 0 && !prisubnet.equals("0.0.0.0")))
		   {
			   errmsg = "Primary IP should not be empty";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if((secip.length() == 0 || secip.equals("0.0.0.0")) && (secsubnet.length() > 0 && !secsubnet.equals("0.0.0.0")))
		   {
			   errmsg = "Secondary IP should not be empty";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if((prisubnet.length() == 0 || primip.equals("0.0.0.0")) && (primip.length() > 0 && !primip.equals("0.0.0.0")))
		   {
			   errmsg = "Primary Subnet mask should not be empty";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if((secsubnet.length() == 0 || secsubnet.equals("0.0.0.0")) && (secip.length() > 0 && !secip.equals("0.0.0.0")))
		   {
			   errmsg = "Secondary Subnet mask should not be empty";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if((primip.length() > 0 && prisubnet.length() > 0) && (gateway.length()==0 || gateway.equals("0.0.0.0")))
		   {
			   errmsg = "Primary Gateway should not be empty";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		  
		  else if((primip.equals(GetBroadcast(primip, prisubnet)) ||
				   primip.equals(GetNetwork(primip, prisubnet))) && !primip.equals("0.0.0.0"))
		   {
			   errmsg = "Bad mask for Primary IP Address";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if((secip.equals(GetBroadcast(secip, secsubnet)) ||
				   secip.equals(GetNetwork(secip, secsubnet))) && !secip.equals("0.0.0.0"))
		   {
			   errmsg = "Bad mask for Secondary IP Address";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if(primip.length() > 0 && !primip.equals("0.0.0.0") && !wanobj.getString("ipAddress").equals("0.0.0.0") && (primip.equals(wanobj.getString("secIP")) || secip.equals(wanobj.getString("ipAddress"))))
		   {
			   errmsg = "Primary IP and Secondary IP Should not Overlap";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if(primip.trim().length() > 0 &&(overlapintf = getOVerlapingInterface(primip,"wan",wizjsonnode,overlapintf,prisubnet)).length() > 0)
		   {
			   
			   errmsg = "Primary IP and "+overlapintf+" Should not Overlap";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if(secip.trim().length() > 0 && (overlapintf = getOVerlapingInterface(secip,"wan",wizjsonnode,overlapintf,secsubnet)).length() > 0)
		   {
			   
			   errmsg = "Secondary IP and "+overlapintf+" Should not Overlap";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if((wtype.equals("Stataic") && (primip.length() != 0 && !primip.equals("0.0.0.0"))) &&(gateway.length() > 0 && !gateway.equals("0.0.0.0") && (!GetNetwork(primip, prisubnet).equals(GetNetwork(gateway, prisubnet)) || 
				  gateway.equals(GetBroadcast(primip, prisubnet)) ||
				   gateway.equals(GetNetwork(primip, prisubnet)))))
		   {
			   errmsg = "Bad Mask for Gateway";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else
		   {
			   wanobj.put("Activation",wanactivat.length()>0 && !wanactivat.equals("No Change")?wanactivat:wanobj.getString("Activation"));
			   wanobj.put("Type",wtype.length()>0 && !wtype.equals("No Change")?wtype:wanobj.getString("Type"));
			   wanobj.put("ipAddress", primip.length()>0?primip:wanobj.getString("ipAddress"));
			   wanobj.put("subnetAddress",prisubnet.length()>0?prisubnet:wanobj.getString("subnetAddress"));
			   wanobj.put("GatewayIP", gateway.length()>0?gateway:wanobj.getString("GatewayIP"));
			   wanobj.put("secIP", secip.length()>0?secip:wanobj.getString("secIP"));
			   wanobj.put("secSubnet", secsubnet.length()>0?secsubnet:wanobj.getString("secSubnet"));
			   wanobj.put("AutoDNS",wdns.equals("Disable")?"Disable":"Enable");
			   wanobj.put("PrimaryDNS", pridns.length()>0?pridns:wanobj.getString("PrimaryDNS"));
			   wanobj.put("SecondaryDNS", secdns.length()>0?secdns:wanobj.getString("SecondaryDNS"));
			   
			   wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
 				.getJSONObject("ADDRESSCONFIG").put("WAN", wanobj);
			   setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			   
		   }
	   }
	   else if(pagename.equals("http_config"))
		{
		   procpage = "http_config.jsp";
		   save_val = HTTPPORT;
		   JSONObject httpconobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("HTTPCONFIG");
		   String portnum = request.getParameter("httpportnum") == null?httpconobj.getString("httpPortNum"):request.getParameter("httpportnum");
		  		   
		   httpconobj.put("httpPortNum",portnum.length()>0?Integer.parseInt(portnum):httpconobj.getInt("httpPortNum"));
			   
			   
			   wizjsonnode.getJSONObject("NETWORKCONFIG").put("HTTPCONFIG", httpconobj);
			   setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			   
		   }
	   else if(pagename.equals("cellular"))
	   {
		   if(fmversion.trim().endsWith("1.8.1"))
           {
			   procpage = "cellular1.8.1.jsp?version="+fmversion;
		   
		   cellularobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("CELLULAR");
		   sim1obj = cellularobj.getJSONObject("SIM1");
		   sim2obj = cellularobj.getJSONObject("SIM2");
		   sim1dataobj = cellularobj.getJSONObject("SIM1LIMIT");
		   sim2dataobj = cellularobj.getJSONObject("SIM2LIMIT");
		   
		String simshft = request.getParameter("simshiftaction") == null?"0":request.getParameter("simshiftaction");
		if(simshft.equals("0"))
		{
			save_val = CELLULAR;
		   String s1autoapn = request.getParameter("AutoAPN1") == null?sim1obj.getString("autoapn"):request.getParameter("AutoAPN1");
		   String s1apn = request.getParameter("APN") == null?sim1obj.getString("apn"):request.getParameter("APN");
		   String s1nwType = request.getParameter("NW") == null?sim1obj.getString("nwType"):request.getParameter("NW");
		   String s1pppUsername = request.getParameter("SIM1_PPPUname") == null?sim1obj.getString("pppUsername"):request.getParameter("SIM1_PPPUname");
		   String s1pppPW = request.getParameter("SIM1_Password") == null?sim1obj.getString("pppPW"):request.getParameter("SIM1_Password");
		   String s1pppAuth = request.getParameter("SIM1_PPPAuth") == null?sim1obj.getString("pppAuth"):request.getParameter("SIM1_PPPAuth");
		   String s1status = request.getParameter("SIM1_sts") == null?sim1obj.getString("status"):request.getParameter("SIM1_sts");
		  
		  
		   String s2autoapn = request.getParameter("AutoAPN2") == null?sim2obj.getString("autoapn"):request.getParameter("AutoAPN2");
		   String s2apn = request.getParameter("APN2") == null?sim2obj.getString("apn"):request.getParameter("APN2");
		   String s2nwType = request.getParameter("NW2") == null?sim2obj.getString("nwType"):request.getParameter("NW2");
		   String s2pppUsername = request.getParameter("SIM2_PPPUname") == null?sim2obj.getString("pppUsername"):request.getParameter("SIM2_PPPUname");
		   String s2pppPW = request.getParameter("SIM2_Password") == null?sim2obj.getString("pppPW"):request.getParameter("SIM2_Password");
		   String s2pppAuth = request.getParameter("SIM2_PPPAuth") == null?sim2obj.getString("pppAuth"):request.getParameter("SIM2_PPPAuth");
		   String s2status = request.getParameter("SIM2_sts") == null?sim2obj.getString("status"):request.getParameter("SIM2_sts");

			
			String prisim =  request.getParameter("Pri_SIM") == null?cellularobj.getString("PrimarySIM"):request.getParameter("Pri_SIM");
			String rechprim = request.getParameter("Recheck_Primary") == null?cellularobj.getInt("ShiftFreq")+"":request.getParameter("Recheck_Primary");
			String trackip = request.getParameter("Track_IP") == null?cellularobj.getString("TrackIP"):request.getParameter("Track_IP");
			String tracktout = request.getParameter("trkduration") == null?cellularobj.getString("TrackTimeOut"):request.getParameter("trkduration");
			String totloss = request.getParameter("totloss") == null?cellularobj.getString("Total Loss(%)"):request.getParameter("totloss");
			String acttout =  request.getParameter("action") == null?cellularobj.getString("Action on Timeout"):request.getParameter("action");
			String acttout1 =  request.getParameter("action1") == null?cellularobj.getString("Action on Timeout"):request.getParameter("action1");
			String rebtout = request.getParameter("RebootTimeout") == null?cellularobj.getString("RebootTimeOut"):request.getParameter("RebootTimeout");
			String icmpfail = request.getParameter("icmp") == null?"Disable":"Enable";
			String icmpfail1 = request.getParameter("icmp1") == null?"Disable":"Enable";
			String datalmtexce = request.getParameter("data") == null?"Disable":"Enable";
			String celurntwkunstble = request.getParameter("rebootrw1") == null?"Disable":"Enable";
			String daylmt = request.getParameter("daily") == null?"Disable":"Enable";
			String mntlmt = request.getParameter("month") == null?"Disable":"Enable";
			String datalmt = request.getParameter("datalimit") == null?cellularobj.getString("When Both Data Limit Exceeded"):request.getParameter("datalimit");

			
			String sim1lmt = request.getParameter("maxdata1") == null?sim1dataobj.getString("Max Data Limitation (MB)"):request.getParameter("maxdata1");
			String sim1mnt = request.getParameter("dateofmonth1") == null?sim1dataobj.getString("Date Of Month To Clean"):request.getParameter("dateofmonth1");
			//String sim1used = request.getParameter("useddata1") == null?sim1dataobj.getString("Already Used (KB)"):request.getParameter("useddata1");
			
			String sim2lmt = request.getParameter("maxdata2") == null?sim2dataobj.getString("Max Data Limitation (MB)"):request.getParameter("maxdata2");
			String sim2mnt = request.getParameter("dateofmonth2") == null?sim2dataobj.getString("Date Of Month To Clean"):request.getParameter("dateofmonth2");
			//String sim2used = request.getParameter("useddata2") == null?sim2dataobj.getString("Already Used (KB)"):request.getParameter("useddata2");
			
			
				if((s1status.equals("Enable")) && (s2status.equals("Enable")))
				{
					cellularobj.put("Action on Timeout",acttout.length()>0?acttout:cellularobj.getString("Action on Timeout"));
				}
				else
				{
					cellularobj.put("Action on Timeout",acttout1.length()>0?acttout1:cellularobj.getString("Action on Timeout"));
				}
				
				if(trackip.equals("") || tracktout.equals(""))
				{
					errmsg = "Please Configure TrackIP,Track TimeOut and TotalLoss.";
					%>
						<script>
						goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
						</script>
					<%
				}
				else if(!trackip.equals("0.0.0.0") &&!tracktout.equals("0") && totloss.equals(""))
				{
					errmsg = "Please Configure TrackIP,Track TimeOut and TotalLoss.";
					%>
						<script>
						goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
						</script>
					<%
				}
				else if(!trackip.equals("0.0.0.0") &&!totloss.equals("0") && tracktout.equals("0"))
				{
					errmsg = "Please Configure TrackIP,Track TimeOut and TotalLoss.";
					%>
						<script>
						goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
						</script>
					<%
				}
				else if(!trackip.equals("0.0.0.0") && totloss.equals("0") && tracktout.equals("0"))
				{
					errmsg = "Please Configure TrackIP,Track TimeOut and TotalLoss.";
					%>
						<script>
						goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
						</script>
					<%
				}
				else if(trackip.equals("0.0.0.0") && totloss.equals("0") && !tracktout.equals("0"))
				{
					errmsg = "Please Configure TrackIP,Track TimeOut and TotalLoss.";
					%>
						<script>
						goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
						</script>
					<%
				}
				else if(trackip.equals("0.0.0.0") && !totloss.equals("0") && !tracktout.equals("0"))
				{
					errmsg = "Please Configure TrackIP,Track TimeOut and TotalLoss.";
					%>
						<script>
						goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
						</script>
					<%
				}
				else if(!trackip.equals("0.0.0.0") && totloss.equals("0") && !tracktout.equals("0"))
				{
					errmsg = "Please Configure TrackIP,Track TimeOut and TotalLoss.";
					%>
						<script>
						goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
						</script>
					<%
				}
				else if ((s1status.equals("Enable")) && (s2status.equals("Enable")) &&(datalmtexce.equals("Enable")) && (!(daylmt.equals("Enable")) && !(mntlmt.equals("Enable"))))
				{
					errmsg = "Please select DailyLimit or MonthlyLimit.";
					%>
						<script>
						goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
						</script>
					<%
					
				}
				else if ((s1status.equals("Enable")) && (s2status.equals("Enable")) &&(datalmtexce.equals("Enable")) && (((sim1lmt.equals("")) && (sim2lmt.length()>0)) || ((sim2lmt.equals("")) && (sim1lmt.length()>0)) || ((sim2lmt.equals("")) && (sim1lmt.equals("")))))
				{
					errmsg = "Please Configure Data Limit Field.";
					%>
						<script>
						goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
						</script>
					<%
					
				}
				else if(s1autoapn.equals("Disable")&&s1status.equals("Enable")&& s2autoapn.equals("Disable")&&s2status.equals("Enable"))
		        {
			    if(s1apn.equals("") && s2apn.equals(""))
			    {
				errmsg = "Please Configure SIM1 APN and SIM2 APN";
				 %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
			    }
			    else if(s1apn.equals(""))
			    {
				errmsg = "Please Configure SIM1 APN";
				 %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
			    }
			    else if(s2apn.equals(""))
			    {
				errmsg = "Please Configure SIM2 APN";
				 %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
			    }
		       }
		       else if(s1autoapn.equals("Disable")&&s1status.equals("Enable")&& s1apn.equals(""))
		       {
				errmsg = "Please Configure SIM1 APN";
				   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		       }
		       else if(s2autoapn.equals("Disable")&&s2status.equals("Enable")&& s2apn.equals(""))
		       {
				errmsg = "Please Configure SIM2 APN";
				   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		       }
			else
			{
			sim1obj.put("autoapn",s1autoapn.length()>0&&!s1autoapn.equals("No Change")?s1autoapn:sim1obj.getString("autoapn"));
		    sim1obj.put("apn",s1apn.length()>0?s1apn:sim1obj.getString("apn"));
		    sim1obj.put("nwType",s1nwType.length()>0&&!s1nwType.equals("No Change")?s1nwType:sim1obj.getString("nwType"));
		    sim1obj.put("pppUsername",s1pppUsername.length()>0?s1pppUsername:sim1obj.getString("pppUsername"));
		    sim1obj.put("pppPW",s1pppPW.length()>0?s1pppPW:sim1obj.getString("pppPW"));
		    sim1obj.put("pppAuth",s1pppAuth.length()>0&&!s1pppAuth.equals("No Change")?s1pppAuth:sim1obj.getString("pppAuth"));
		    sim1obj.put("status",s1status.length()>0&&!s1status.equals("No Change")?s1status:sim1obj.getString("status"));
		  
		   
		    sim2obj.put("autoapn",s2autoapn.length()>0&&!s2autoapn.equals("No Change")?s2autoapn:sim2obj.getString("autoapn"));
		    sim2obj.put("apn",s2apn.length()>0?s2apn:sim2obj.getString("apn"));
		    sim2obj.put("nwType",s2nwType.length()>0&&!s2nwType.equals("No Change")?s2nwType:sim2obj.getString("nwType"));
		    sim2obj.put("pppUsername",s2pppUsername.length()>0?s2pppUsername:sim2obj.getString("pppUsername"));
		    sim2obj.put("pppPW",s2pppPW.length()>0?s2pppPW:sim2obj.getString("pppPW"));
		    sim2obj.put("pppAuth",s2pppAuth.length()>0&&!s2pppAuth.equals("No Change")?s2pppAuth:sim2obj.getString("pppAuth"));
		    sim2obj.put("status",s2status.length()>0&&!s2status.equals("No Change")?s2status:sim2obj.getString("status"));
		  
		    sim1dataobj.put("Max Data Limitation (MB)",sim1lmt.length()>0?Integer.parseInt(sim1lmt):sim1dataobj.getInt("Max Data Limitation (MB)"));
		    sim1dataobj.put("Date Of Month To Clean",sim1mnt.length()>0?Integer.parseInt(sim1mnt):sim1dataobj.getInt("Date Of Month To Clean"));
		    //sim1dataobj.put("Already Used (KB)",sim1used.length()>0?sim1used:sim1dataobj.getString("Already Used (KB)"));
		   
		    sim2dataobj.put("Max Data Limitation (MB)",sim2lmt.length()>0?Integer.parseInt(sim2lmt):sim2dataobj.getInt("Max Data Limitation (MB)"));
		    sim2dataobj.put("Date Of Month To Clean",sim2mnt.length()>0?Integer.parseInt(sim2mnt):sim2dataobj.getInt("Date Of Month To Clean"));
		    //sim2dataobj.put("Already Used (KB)",sim2used.length()>0?sim2used:sim2dataobj.getString("Already Used (KB)"));
		   
		    cellularobj.put("SIM1",sim1obj.toString().length()>0?sim1obj:cellularobj.getJSONObject("SIM1"));
		    cellularobj.put("SIM2",sim2obj.toString().length()>0?sim2obj:cellularobj.getJSONObject("SIM2"));
		         
				 
			cellularobj.put("SIM1LIMIT",sim1dataobj.toString().length()>0?sim1dataobj:cellularobj.getJSONObject("SIM1LIMIT"));
			cellularobj.put("SIM2LIMIT",sim2dataobj.toString().length()>0?sim2dataobj:cellularobj.getJSONObject("SIM2LIMIT"));
			
						
			cellularobj.put("PrimarySIM",prisim.length()>0&&!prisim.equals("No Change")?prisim:cellularobj.getString("PrimarySIM"));
			cellularobj.put("ShiftFreq",rechprim.length()>0?Integer.parseInt(rechprim):cellularobj.getInt("ShiftFreq"));
			cellularobj.put("TrackIP",trackip.length()>0?trackip:cellularobj.getString("TrackIP"));
			cellularobj.put("TrackTimeOut",tracktout.length()>0?Integer.parseInt(tracktout):cellularobj.getInt("TrackTimeOut"));
			cellularobj.put("Total Loss(%)",totloss.length()>0?Integer.parseInt(totloss):cellularobj.getInt("Total Loss(%)"));
			cellularobj.put("RebootTimeOut",rebtout.length()>0?Integer.parseInt(rebtout):cellularobj.getInt("RebootTimeOut"));
			cellularobj.put("ICMP Detection Fails",icmpfail.length()>0?icmpfail:cellularobj.getString("ICMP Detection Fails"));
			cellularobj.put("Reboot/Reconnect When ICMP Detection Fails",icmpfail1.length()>0?icmpfail1:cellularobj.getString("Reboot/Reconnect When ICMP Detection Fails"));
			cellularobj.put("DataLimit_Exceeded",datalmtexce.length()>0?datalmtexce:cellularobj.getString("DataLimit_Exceeded"));
		    cellularobj.put("Reboot, When Cellular Network Unstable",celurntwkunstble.length()>0?celurntwkunstble:cellularobj.getString("Reboot, When Cellular Network Unstable"));
			cellularobj.put("Daily Limit",daylmt.length()>0?daylmt:cellularobj.getString("Daily Limit"));
			cellularobj.put("Monthly Limit",mntlmt.length()>0?mntlmt:cellularobj.getString("Monthly Limit"));
			cellularobj.put("When Both Data Limit Exceeded",datalmt.length()>0?datalmt:cellularobj.getString("When Both Data Limit Exceeded"));
			
			}
		}
		else
		{
			save_val=0;
			cellularobj.put("SIMShift",simshft.length()>0?Integer.parseInt(simshft):cellularobj.getInt("SIMShift"));
		}
			  		wizjsonnode.getJSONObject("NETWORKCONFIG").put("CELLULAR", cellularobj);
			   		setSaveIndex(wizjsonnode,save_val);
			  		BufferedWriter jsonWriter = null;
			   		try
			  		{
				   		jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			  		 	jsonWriter.write(wizjsonnode.toString(2));
			   		}
			   		catch(Exception e)
			   		{
				   		e.printStackTrace();
				   		internal_err = true;
			   		}
			   		finally
			   		{
				   		if(jsonWriter != null)
				   		jsonWriter.close();
			   		}
			
	   }
	   else
		   {		
		   procpage = "cellular.jsp?version="+fmversion;
		   save_val = CELLULAR;
		   cellularobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("CELLULAR");
		   sim1obj = cellularobj.getJSONObject("SIM1");
		   sim2obj = cellularobj.getJSONObject("SIM2");
		   String s1autoapn = request.getParameter("AutoAPN1") == null?sim1obj.getString("autoapn"):request.getParameter("AutoAPN1");
		   String s1apn = request.getParameter("APN") == null?sim1obj.getString("apn"):request.getParameter("APN");
		   String s1nwType = request.getParameter("NW") == null?sim1obj.getString("nwType"):request.getParameter("NW");
		   String s1pppUsername = request.getParameter("SIM1_PPPUname") == null?sim1obj.getString("pppUsername"):request.getParameter("SIM1_PPPUname");
		   String s1pppPW = request.getParameter("SIM1_Password") == null?sim1obj.getString("pppPW"):request.getParameter("SIM1_Password");
		   String s1pppAuth = request.getParameter("SIM1_PPPAuth") == null?sim1obj.getString("pppAuth"):request.getParameter("SIM1_PPPAuth");
		   String s1status = request.getParameter("SIM1_Status") == null?sim1obj.getString("status"):request.getParameter("SIM1_Status");
		   
		   String s2autoapn = request.getParameter("AutoAPN2") == null?sim2obj.getString("autoapn"):request.getParameter("AutoAPN2");
		   String s2apn = request.getParameter("APN2") == null?sim2obj.getString("apn"):request.getParameter("APN2");
		   String s2nwType = request.getParameter("NW2") == null?sim2obj.getString("nwType"):request.getParameter("NW2");
		   String s2pppUsername = request.getParameter("SIM2_PPPUname") == null?sim2obj.getString("pppUsername"):request.getParameter("SIM2_PPPUname");
		   String s2pppPW = request.getParameter("SIM2_Password") == null?sim2obj.getString("pppPW"):request.getParameter("SIM2_Password");
		   String s2pppAuth = request.getParameter("SIM2_PPPAuth") == null?sim2obj.getString("pppAuth"):request.getParameter("SIM2_PPPAuth");
		   String s2status = request.getParameter("SIM2_Status") == null?sim2obj.getString("status"):request.getParameter("SIM2_Status");
		   
		   String primsim = request.getParameter("Pri_SIM") == null?cellularobj.getString("PrimarySIM"):request.getParameter("Pri_SIM");
		   String rechprim = request.getParameter("Recheck_Primary") == null?cellularobj.getInt("ShiftFreq")+"":request.getParameter("Recheck_Primary");
		   String trackip = request.getParameter("Track_IP") == null?cellularobj.getString("TrackIP"):request.getParameter("Track_IP");
		   String timeout = request.getParameter("Timeout") == null?cellularobj.getInt("TrackTimeOut")+"":request.getParameter("Timeout");
		   String action = request.getParameter("action") == null?cellularobj.getString("PPPTimer"):request.getParameter("action");
		   String rebtimeout = request.getParameter("RebootTimeout") == null?cellularobj.getInt("RebootTimeOut")+"":request.getParameter("RebootTimeout");
		   
		   sim1obj.put("autoapn",s1autoapn.length()>0&&!s1autoapn.equals("No Change")?s1autoapn:sim1obj.getString("autoapn"));
		   sim1obj.put("apn",s1apn.length()>0?s1apn:sim1obj.getString("apn"));
		   sim1obj.put("nwType",s1nwType.length()>0&&!s1nwType.equals("No Change")?s1nwType:sim1obj.getString("nwType"));
		   sim1obj.put("pppUsername",s1pppUsername.length()>0?s1pppUsername:sim1obj.getString("pppUsername"));
		   sim1obj.put("pppPW",s1pppPW.length()>0?s1pppPW:sim1obj.getString("pppPW"));
		   sim1obj.put("pppAuth",s1pppAuth.length()>0&&!s1pppAuth.equals("No Change")?s1pppAuth:sim1obj.getString("pppAuth"));
		   sim1obj.put("status",s1status.length()>0&&!s1status.equals("No Change")?s1status:sim1obj.getString("status"));
		   
		   sim2obj.put("autoapn",s2autoapn.length()>0&&!s2autoapn.equals("No Change")?s2autoapn:sim2obj.getString("autoapn"));
		   sim2obj.put("apn",s2apn.length()>0?s2apn:sim2obj.getString("apn"));
		   sim2obj.put("nwType",s2nwType.length()>0&&!s2nwType.equals("No Change")?s2nwType:sim2obj.getString("nwType"));
		   sim2obj.put("pppUsername",s2pppUsername.length()>0?s2pppUsername:sim2obj.getString("pppUsername"));
		   sim2obj.put("pppPW",s2pppPW.length()>0?s2pppPW:sim2obj.getString("pppPW"));
		   sim2obj.put("pppAuth",s2pppAuth.length()>0&&!s2pppAuth.equals("No Change")?s2pppAuth:sim2obj.getString("pppAuth"));
		   sim2obj.put("status",s2status.length()>0&&!s2status.equals("No Change")?s2status:sim2obj.getString("status"));
		   
		   cellularobj.put("SIM1",sim1obj.toString().length()>0?sim1obj:cellularobj.getJSONObject("SIM1"));
		   cellularobj.put("SIM2",sim2obj.toString().length()>0?sim2obj:cellularobj.getJSONObject("SIM2"));
		   
		   cellularobj.put("PrimarySIM",primsim.length()>0&&!primsim.equals("No Change")?primsim:cellularobj.getString("PrimarySIM"));
		   cellularobj.put("ShiftFreq",rechprim.length()>0?Integer.parseInt(rechprim):cellularobj.getInt("ShiftFreq"));
		   cellularobj.put("TrackIP",trackip.length()>0?trackip:cellularobj.getString("TrackIP"));
		   cellularobj.put("TrackTimeOut",timeout.length()>0?Integer.parseInt(timeout):cellularobj.getInt("TrackTimeOut"));
		   cellularobj.put("PPPTimer",action.length()>0&&!action.equals("No Change")?action:cellularobj.getString("PPPTimer"));
		   cellularobj.put("RebootTimeOut",rebtimeout.length()>0?Integer.parseInt(rebtimeout):cellularobj.getInt("RebootTimeOut"));
		   
		   if(s1autoapn.equals("Disable")&&s1status.equals("Enable")&& s2autoapn.equals("Disable")&&s2status.equals("Enable"))
		   {
			   if(s1apn.equals("") && s2apn.equals(""))
			   {
				errmsg = "Please Configure SIM1 APN and SIM2 APN";
				 %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
			   }
			   else if(s1apn.equals(""))
			   {
				errmsg = "Please Configure SIM1 APN";
				 %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
			   }
			   else if(s2apn.equals(""))
			   {
				errmsg = "Please Configure SIM2 APN";
				 %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
			   }
		   }
		   else if(s1autoapn.equals("Disable")&&s1status.equals("Enable")&& s1apn.equals(""))
		   {
				errmsg = "Please Configure SIM1 APN";
				   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if(s2autoapn.equals("Disable")&&s2status.equals("Enable")&& s2apn.equals(""))
		   {
				errmsg = "Please Configure SIM2 APN";
				   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if(s1status.equals("Disable")&& s2status.equals("Disable")&&action.equals("Sim Shift"))
		   {
				errmsg = "In  Action on Timeout, Sim Shift is not Applicable(Both sims are not enabled)";
				   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if(s1status.equals("Disable")&& s2status.equals("Enable")&&action.equals("Sim Shift"))
		   {
				errmsg = "In  Action on Timeout, Sim Shift is not Applicable(Both sims are not enabled)";
				   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if(s1status.equals("Enable")&& s2status.equals("Disable")&&action.equals("Sim Shift"))
		   {
				errmsg = "In  Action on Timeout, Sim Shift is not Applicable(Both sims are not enabled)";
				   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   if(s1status.equals("Enable")&& s2status.equals("Enable")&&action.equals("Reconnect"))
		   {
				errmsg = "In Action on Timeout, Reconnect is not Applicable(Both sims are enabled)";
				   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   
		   else if(trackip.equals("0.0.0.0")&&!timeout.equals("0")&& !action.equals("No Change"))
		   {
                errmsg = "Please Configure TrackIp and Action on Timeout Fields.";
				 %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				</script>
			  <%	
		   }
		   else if(!trackip.equals("0.0.0.0")&&timeout.equals("0")&& !action.equals("No Change"))
		   {
                errmsg = "Please Configure TrackIp and Action on Timeout Fields.";
				 %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				</script>
			  <%	
		   }
		   if(errmsg.length() > 0)
		   {  %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			  <%}
			else
			{
			  		wizjsonnode.getJSONObject("NETWORKCONFIG").put("CELLULAR", cellularobj);
			   		setSaveIndex(wizjsonnode,save_val);
			  		BufferedWriter jsonWriter = null;
			   		try
			  		 {
				   		jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			  		 	jsonWriter.write(wizjsonnode.toString(2));
			 
			   		}
			   		catch(Exception e)
			   		{
				   		e.printStackTrace();
				   		internal_err = true;
			   		}
			   		finally
			   		{
				   		if(jsonWriter != null)
				   		jsonWriter.close();
			   		}
			}
		  }
	   }
	   else if(pagename.equals("smsconfig"))
	   {

		   procpage = "sms_config.jsp";
		   save_val = SMS_CONFIG;
		   JSONObject smsconfobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("SMSCONFIG");
		   JSONArray orinumsarr = smsconfobj.getJSONArray("SmsAuthNum");
		  
		   JSONArray numsarr = new JSONArray();
		   for(int i=1;i<=3;i++)
		   {
			   numsarr.add(request.getParameter("Srcmn"+i)==null?"":request.getParameter("Srcmn"+i));
			   if((numsarr.getString(i-1).length() > 0) && (!numsarr.getString(i-1).startsWith("+91") || 
					   numsarr.getString(i-1).length() != 13 || !isNumber(numsarr.getString(i-1).substring(1))))
			   {
				   if(errmsg.length() == 0)
				   {
					   numsarr.remove(i-1);
					   numsarr.add(i-1,orinumsarr.get(i-1));
					   errmsg = "invalid Number";
				   }
			   }
		   }
		   
		   String sim1cnum = request.getParameter("Sim1cmn") == null?smsconfobj.getString("Sim1CntrNum"):request.getParameter("Sim1cmn");
		   String sim2cnum = request.getParameter("Sim2cmn") == null?smsconfobj.getString("Sim2CntrNum")+"":request.getParameter("Sim2cmn");
		   if((sim1cnum.length() > 0)&&(!sim1cnum.startsWith("+91") || sim1cnum.length() != 13 || !isNumber(sim1cnum.substring(1))))
		   {
			   if(errmsg.length() == 0)
			   {
				   sim1cnum=smsconfobj.getString("Sim1CntrNum");
				   errmsg = "invalid Number";
			   }
		   }
		   if((sim2cnum.length() > 0) && (!sim2cnum.startsWith("+91") || sim2cnum.length() != 13 || !isNumber(sim2cnum.substring(1))))
		   {
			   if(errmsg.length() == 0)
			   {
				   sim2cnum=smsconfobj.getString("Sim2CntrNum");
				   errmsg = "invalid Number";
			   }
			   
		   }
		   
		   smsconfobj.put("SmsAuthNum",numsarr);
		   smsconfobj.put("Sim1CntrNum",sim1cnum);
		   smsconfobj.put("Sim2CntrNum",sim2cnum);
			   
			wizjsonnode.getJSONObject("NETWORKCONFIG").put("SMSCONFIG", smsconfobj);
			setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			   if(errmsg.length() > 0)
			   {%>
				   <script>
				    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
					 </script>
			   <%}	      
	   }
	   else if(pagename.equals("smsconfig"))
	   {

		   procpage = "sms_config.jsp";
		   save_val = SMS_CONFIG;
		   JSONObject smsconfobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("SMSCONFIG");
		   JSONArray orinumsarr = smsconfobj.getJSONArray("SmsAuthNum");
		  
		   JSONArray numsarr = new JSONArray();
		   for(int i=1;i<=3;i++)
		   {
			   numsarr.add(request.getParameter("Srcmn"+i)==null?"":request.getParameter("Srcmn"+i));
			   if((numsarr.getString(i-1).length() > 0) && (!numsarr.getString(i-1).startsWith("+91") || 
					   numsarr.getString(i-1).length() != 13 || !isNumber(numsarr.getString(i-1).substring(1))))
			   {
				   if(errmsg.length() == 0)
				   {
					   numsarr.remove(i-1);
					   numsarr.add(i-1,orinumsarr.get(i-1));
					   errmsg = "invalid Number";
				   }
			   }
		   }
		   
		   String sim1cnum = request.getParameter("Sim1cmn") == null?smsconfobj.getString("Sim1CntrNum"):request.getParameter("Sim1cmn");
		   String sim2cnum = request.getParameter("Sim2cmn") == null?smsconfobj.getString("Sim2CntrNum")+"":request.getParameter("Sim2cmn");
		   if((sim1cnum.length() > 0)&&(!sim1cnum.startsWith("+91") || sim1cnum.length() != 13 || !isNumber(sim1cnum.substring(1))))
		   {
			   if(errmsg.length() == 0)
			   {
				   sim1cnum=smsconfobj.getString("Sim1CntrNum");
				   errmsg = "invalid Number";
			   }
		   }
		   if((sim2cnum.length() > 0) && (!sim2cnum.startsWith("+91") || sim2cnum.length() != 13 || !isNumber(sim2cnum.substring(1))))
		   {
			   if(errmsg.length() == 0)
			   {
				   sim2cnum=smsconfobj.getString("Sim2CntrNum");
				   errmsg = "invalid Number";
			   }
			   
		   }
		   
		   smsconfobj.put("SmsAuthNum",numsarr);
		   smsconfobj.put("Sim1CntrNum",sim1cnum);
		   smsconfobj.put("Sim2CntrNum",sim2cnum);
			   
			wizjsonnode.getJSONObject("NETWORKCONFIG").put("SMSCONFIG", smsconfobj);
			setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			   if(errmsg.length() > 0)
			   {%>
				   <script>
				    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
					 </script>
			   <%}	      
	   }
	   else if(pagename.equals("sla"))
	   {

		   procpage = "sla.jsp";
		   save_val = IPSLA_CONFIG;
		   boolean exists = false;
		   JSONObject ipslaobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").
				   getJSONObject("IPSLA");
		   JSONArray slaarr = ipslaobj.getJSONObject("TABLE").getJSONArray("arr");
		  
		   String slno = request.getParameter("SrNo")==null?"":request.getParameter("SrNo");
		   String desip = request.getParameter("Destination_IP")==null?"":request.getParameter("Destination_IP");
		   String srcintf = request.getParameter("src_Interface")==null?"":request.getParameter("src_Interface");
		   String freq = request.getParameter("Frequency")==null?"":request.getParameter("Frequency");
		   String status = request.getParameter("Status")==null?"":request.getParameter("Status");
		   for(int i=0;i<slaarr.size();i++)
		   {
			   JSONObject sla = slaarr.getJSONObject(i);
			   if(slno.trim().equals(sla.getString("sl")))
			   {
				   sla.put("dstIP",desip);
				   sla.put("interface",srcintf.equals("No Change")?sla.getString("interface"):srcintf);
				   sla.put("frequency",Integer.parseInt(freq));
				   sla.put("status",status.equals("No Change")?sla.getString("status"):status);
				   
				   slaarr.remove(i);
				   slaarr.add(i,sla);
				   exists = true;
				   errmsg =  trapSrcConfigured(sla.getString("interface"),wizjsonnode);
				   break;
			   }
				   
		   }
		   
		   if(!exists)
		   {
			   
		   	   if(srcintf.equals("No Change"))
			   {
				   errmsg = "Source Interface Should Not be Empty ..";
			   }
			   else
			   {
				   errmsg = trapSrcConfigured(srcintf,wizjsonnode);
			   }
			   if(status.equals("No Change"))
			   {
				   errmsg += "   Status Should Not be empty..";
			   }
			  if(errmsg.trim().length() == 0)
			  {
			  	JSONObject sla = new JSONObject();
			 	 sla.put("sl",Integer.parseInt(slno));
			  	sla.put("dstIP",desip);
			  	sla.put("dstIP",desip);
			  	sla.put("interface",srcintf);
			  	sla.put("frequency",Integer.parseInt(freq));
			  	sla.put("status",status);
			  	slaarr.add(sla);
			  }
		   }
			
		   if(errmsg.trim().length() > 0)
		   {
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else
		   {
		   		ipslaobj.getJSONObject("TABLE").put("arr",slaarr);
				wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").
			  	 put("IPSLA",ipslaobj);
				setSaveIndex(wizjsonnode,save_val);
			   	BufferedWriter jsonWriter = null;
			   	try
			   	{
				   	 jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			  		 jsonWriter.write(wizjsonnode.toString(2));
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
		   }
	   }
	   else if(pagename.equals("portforward"))
	   {

		   procpage = "portforward.jsp";
		   save_val = PORT_FARWARD;
		   boolean exists = false;
		   JSONObject portfwobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").
				   getJSONObject("NATCONFIG").getJSONObject("PORTFW");
		   JSONArray portfwarr = portfwobj.getJSONObject("TABLE").getJSONArray("arr");
		  
		   String slno = request.getParameter("SrNo")==null?"":request.getParameter("SrNo");
		   String Protocol = request.getParameter("Protocol")==null?"No Change":request.getParameter("Protocol");
		   String Inside_IP = request.getParameter("Inside_IP")==null?"":request.getParameter("Inside_IP");
		   String InsPort = request.getParameter("InsPort")==null?0+"":request.getParameter("InsPort");
		   String FwdIntf = request.getParameter("FwdIntf")==null?"No Change":request.getParameter("FwdIntf");
		   String FwdPort = request.getParameter("FwdPort")==null?0+"":request.getParameter("FwdPort");
		   String status = request.getParameter("Status")==null?"No Change":request.getParameter("Status");
		   
		   for(int i=0;i<portfwarr.size();i++)
		   {
			   JSONObject pfdet = portfwarr.getJSONObject(i);
			   if(!pfdet.getString("sl").equals(slno)&&
					   pfdet.getString("insideIP").equals(Inside_IP)&&
					   pfdet.getString("insidePortnumber").equals(InsPort)&&
					   pfdet.getString("FwdInterface").equals(FwdIntf)&&
					   pfdet.getString("FwdPortnumber").equals(FwdPort))
			   {
				   errmsg="Configuration Already Exists..";
				   break;
			   }
			   else if(pfdet.getString("insidePortnumber").equals(InsPort) && !pfdet.getString("sl").equals(slno))
			   {
				   errmsg="Duplicate Inside Port ...";
				   break;
			   }
			   else if(pfdet.getString("FwdPortnumber").equals(FwdPort) && !pfdet.getString("sl").equals(slno))
			   {
				   errmsg="Duplicate Forward Port ...";
				   break;
			   }
		   }
		   if(errmsg.length() > 0)
		   {%>
			   <script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				</script>
		   <%}
		   else
		   {
		    int mslno = -1;
		   for(int i=0;i<portfwarr.size();i++)
		   {			   
			   JSONObject oldpfdet = portfwarr.getJSONObject(i);
			   if(oldpfdet != null && slno.trim().equals(oldpfdet.getString("sl")))
			   {
				   JSONObject  pfdet = new JSONObject();
				   pfdet.put("sl",oldpfdet.getInt("sl"));
				   pfdet.put("Protocoltype",Protocol.equals("No Change")?oldpfdet.getString("Protocoltype"):Protocol);
				   pfdet.put("insideIP",Inside_IP);
				   pfdet.put("insidePortnumber",Integer.parseInt(InsPort));
				   pfdet.put("FwdInterface",FwdIntf.equals("No Change")?oldpfdet.getString("FwdInterface"):FwdIntf);
				   pfdet.put("FwdPortnumber",Integer.parseInt(FwdPort));
				   pfdet.put("status",status.equals("No Change")?oldpfdet.getString("status"):status);
				   
				   if(status.equals("Delete") 
						   &&(!oldpfdet.getString("Protocoltype").equals(pfdet.getString("Protocoltype"))
								   ||!oldpfdet.getString("insideIP").equals(pfdet.getString("insideIP"))
								   ||!oldpfdet.getString("insidePortnumber").equals(pfdet.getString("insidePortnumber"))
								   ||!oldpfdet.getString("FwdInterface").equals(pfdet.getString("FwdInterface"))
								   ||!oldpfdet.getString("FwdPortnumber").equals(pfdet.getString("FwdPortnumber"))))
				   {
					   errmsg = "Configuaration Mismatched(while deleting)";
					   break;
				   }
				   portfwarr.remove(i);
				   mslno = oldpfdet.getInt("sl");
				   //if(!status.equals("Delete"))
				   portfwarr.add(i,pfdet);
				   exists = true;
			   }
		   }
		   
		   if(!exists && errmsg.length() == 0)
		   {
			   if(Protocol.equals("No Change") && FwdIntf.equals("No Change"))
			   {
				   errmsg = "Protocol and  Forward Interface are Not Configured";
			   }
			   else if(Protocol.equals("No Change"))
			   {
				   errmsg = "Protocol is Not Configured";
			   }
			   else if(FwdIntf.equals("No Change"))
			   {
				   errmsg = "Forward Interface is Not Configured";
			   }
			   else if(status.equals("No Change"))
			   {
				   errmsg = "Status Should not be empty";
			   }
			   else
			   {	   
			  	JSONObject pfdet = new JSONObject();
				  
			  	pfdet.put("sl",Integer.parseInt(slno));
			  	pfdet.put("Protocoltype",Protocol);
			  	pfdet.put("insideIP",Inside_IP);
			  	pfdet.put("insidePortnumber",Integer.parseInt(InsPort));
			  	pfdet.put("FwdInterface",FwdIntf);
			  	pfdet.put("FwdPortnumber",Integer.parseInt(FwdPort));
			  	pfdet.put("status",status);
				
			  	//if(!status.equals("Delete"))
			   		portfwarr.add(pfdet);
			   		mslno = pfdet.getInt("sl");
			   }
		   }
		   if(errmsg.length() > 0)
		   {%>
			   <script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				</script>
		   <%}
		   else
		   {
		   portfwobj.getJSONObject("TABLE").put("arr",portfwarr);
		   if(mslno >=0)
		   {
			   int pf_ind = portfwobj.containsKey("PortFwdSNo")?portfwobj.getInt("PortFwdSNo"):0;
			   pf_ind = pf_ind | (1<<(mslno-1));
			   portfwobj.put("PortFwdSNo", pf_ind);
		   }
			wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").getJSONObject("NATCONFIG").
			   put("PORTFW",portfwobj);
			   
			setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
		   }
		   }
	   }
	   else if(pagename.equals("static_routing")) //guru
	   {

		   procpage = "static_routing.jsp";
		   save_val = STATIC_ROUTING;
		   int strowcnt = Integer.parseInt(request.getParameter("routesrwcnt"));
		   JSONObject strouteobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").
				   getJSONObject("STATICROUTE");
		   JSONArray oldsttabarr = strouteobj.getJSONObject("TABLE").getJSONArray("arr");
		   JSONArray newsttabarr = new JSONArray();
		   
		   for(int i=1;i<strowcnt;i++)
		   {
			   if(request.getParameter("destNetw"+i) == null)
			   {
				   /* if(oldsttabarr.size() >=i-1)
					   oldsttabarr.remove(i-1); */
				   continue;
			   }
			   JSONObject stroutedet = new JSONObject();
			   stroutedet.put("srInterface",request.getParameter("interface"+i)==null?"":request.getParameter("interface"+i));
			   stroutedet.put("srDestNetw",request.getParameter("destNetw"+i)==null?"0.0.0.0":request.getParameter("destNetw"+i));
			   stroutedet.put("srNetmask",request.getParameter("netmask"+i)==null?"0.0.0.0":request.getParameter("netmask"+i));
			   stroutedet.put("srGateway",request.getParameter("gateway"+i)==null?"0.0.0.0":request.getParameter("gateway"+i));
			   try
			   {
				   stroutedet.put("srMetric",request.getParameter("metric"+i).trim().length()==0?1:Integer.parseInt(request.getParameter("metric"+i).trim()));
			   }
			   catch(Exception e)
			   {
				   stroutedet.put("srMetric",1);
			   }
			   newsttabarr.add(stroutedet);
		   }
		   
		   for(int i=newsttabarr.size()-1;i>=0;i--)
		   {
			   	boolean error = false;
			   	JSONObject stroutedet = newsttabarr.getJSONObject(i);
			  	 if((stroutedet.getString("srDestNetw").equals("0.0.0.0") && !stroutedet.getString("srNetmask").equals("0.0.0.0")) || 
					   (!stroutedet.getString("srDestNetw").equals("0.0.0.0") && stroutedet.getString("srNetmask").equals("0.0.0.0")))
			   	{
				  	errmsg += "Inconsistent address and  mask  "+stroutedet.get("srDestNetw")+" and "+stroutedet.get("srNetmask");
					error = true; 
			   	}
			   	else if(!isConsistance(stroutedet.getString("srDestNetw"),stroutedet.getString("srNetmask")))
			   	{
				   	errmsg += "Inconsistent address and  mask  "+stroutedet.get("srDestNetw")+" and "+stroutedet.get("srNetmask");
				  	 error = true;
			  	}
			  	if(!error)
			   	{
			  	 	for(int j=0;j<newsttabarr.size();j++)
			   		{
					   JSONObject addroute = newsttabarr.getJSONObject(j);
					   if(i!=j && addroute.get("srInterface").equals(stroutedet.get("srInterface")) && 
					   addroute.get("srDestNetw").equals(stroutedet.get("srDestNetw")) && 
					   addroute.get("srNetmask").equals(stroutedet.get("srNetmask")) && 
					   addroute.get("srGateway").equals(stroutedet.get("srGateway")))
					   {
						   error = true;
						   errmsg += "Entry already "+stroutedet.get("srDestNetw")+
						    		  "  "+stroutedet.get("srNetmask")+"  "+stroutedet.get("srInterface")+
									  "  "+stroutedet.get("srGateway")+" exists,Please try again.. ";
						   break;
					   }
				   }
			   	} 
				if(error)
				{
					newsttabarr.remove(i);
					if(oldsttabarr.size() > i)
					{
						newsttabarr.add(i,oldsttabarr.getJSONObject(i));
					}
				}
			}			   
			strouteobj.getJSONObject("TABLE").put("arr",newsttabarr);
			wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").
			   put("STATICROUTE",strouteobj);
			   
			setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			   if(errmsg.length() > 0)
			   {%>
			   <script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				</script>
		   	 <%}
	   }

	   else if(pagename.equals("loopback"))
		{
			procpage = "loopback.jsp";
			save_val = LOOPBACK;
			JSONObject loopbackobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
  				.getJSONObject("ADDRESSCONFIG").getJSONObject("LOOPBACK");
	
		   String lbactivat = request.getParameter("LBIfSts") == null || request.getParameter("LBIfSts").equals("No Change") ?loopbackobj.getString("Activation"):request.getParameter("LBIfSts");
		   String lbip = request.getParameter("LBIPv4").length()==0?loopbackobj.getString("ipAddress"):request.getParameter("LBIPv4") ;
		   String lbsubnet = request.getParameter("LBNetmask").length()==0?loopbackobj.getString("subnetAddress"):request.getParameter("LBNetmask") ;
		   String lbiparr[] = lbip.split("\\.");
		   if(lbip=="")
		   {
			   errmsg = "Primary IP Address and Secondary IP Address Should not be same";
			   %>
			   	<script>
				  goToPage("loopback.jsp","error",'<%=errmsg%>','<%=slnumber%>');
				</script>
			   <%
		   }
		   else if(lbsubnet.length() == 0 || lbsubnet.equals("0.0.0.0") && lbip.length() > 0)
		   {
			   errmsg = "`Subnet Mask should not be empty";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if(lbip.trim().length() > 0 && !lbip.equals("0.0.0.0") && (overlapintf = getOVerlapingInterface(lbip,"loopback",wizjsonnode,overlapintf,lbsubnet)).length() > 0)
		   {
			   
			   errmsg = "loopback IP and "+overlapintf+" Should not Overlap";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   if((lbip.equals(GetNetwork(lbip, lbsubnet)) || lbip.equals(GetBroadcast(lbip, lbsubnet))) && !lbip.equals("0.0.0.0"))
		   {
			   boolean proceed = false;
			    if(!lbsubnet.equals("255.255.255.255"))
				{
					errmsg = "Bad mask for Loopback IP Address";
					proceed = true;
				}
				else if(lbiparr[3].equals("0") || lbiparr[3].equals("255"))
				{
					errmsg = "Invalid Host for Loopback IP Address";	
					proceed = true;
				}
				if(proceed)
				{
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
				}
		   }
		   if(errmsg.trim().length() == 0)
		   {
			   loopbackobj.put("Activation",lbactivat.length()>0?lbactivat:loopbackobj.getString("Activation"));
			   loopbackobj.put("ipAddress", lbip.length()>0?lbip:loopbackobj.getString("ipAddress"));
			   loopbackobj.put("subnetAddress",lbsubnet.length()>0?lbsubnet:loopbackobj.getString("subnetAddress"));
			   
			   wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
 				.getJSONObject("ADDRESSCONFIG").put("LOOPBACK", loopbackobj);
			   setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(4));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			   
		   }
	   }
	   else if(pagename.equals("dialer"))
		{
			procpage = "dialer.jsp";
			save_val = DIALER;
		   //System.out.println("\n\n Auto DNS is : "+request.getParameter("oauto")+"\n\n");
		   JSONObject dialerobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
	  				.getJSONObject("ADDRESSCONFIG").getJSONObject("DIALER");

		   String dialerstatus = request.getParameter("enable") == null?dialerobj.getString("Status"):request.getParameter("enable");
		   String dialerip = request.getParameter("DIPV4").length()==0?dialerobj.getString("ipAddress"):request.getParameter("DIPV4") ;
		   String dialersubnet = request.getParameter("Dnetmask").length()==0?dialerobj.getString("NetMask"):request.getParameter("Dnetmask") ;
		   String poolnumber = request.getParameter("poolNo") == null?dialerobj.getInt("PoolNo")+"":request.getParameter("poolNo") ;
		   String authenticat = request.getParameter("auth") == null?dialerobj.getString("Authentication"):request.getParameter("auth");
		   String username = request.getParameter("username") == null?dialerobj.getString("username"):request.getParameter("username");
		   String pwd = request.getParameter("password") == null?dialerobj.getString("password"):request.getParameter("password");
		   String servname = request.getParameter("servName") == null?dialerobj.getString("ServiceName"):request.getParameter("servName");
		   String dialerdns = request.getParameter("oauto") == null?"Disable":"Enable";
		   String pridns = request.getParameter("pridns") == null?dialerobj.getString("PrimaryDNS"):request.getParameter("pridns");
		   String secdns = request.getParameter("Secondary DNS") == null?dialerobj.getString("SecondaryDNS"):request.getParameter("Secondary DNS");
		   
		   if(poolnumber == "")
		   {
			   errmsg = "PoolNo Should not be same";
			   %>
			   	<script>
				  goToPage("dialer.jsp","error",'<%=errmsg%>','<%=slnumber%>');
				</script>
			   <%
		   }
		   else if(dialerip.length() > 0 && !dialerip.equals("0.0.0.0") && (dialersubnet.length() == 0 || dialersubnet.equals("0.0.0.0")))
		   {
			   errmsg = "NetMask should not be Empty";
		   }
		   else if(dialerip.trim().length() > 0 && !dialerip.equals("0.0.0.0") && (overlapintf = getOVerlapingInterface(dialerip,"dialer",wizjsonnode,overlapintf,dialersubnet)).length() > 0)
		   {
			   
			   errmsg = "Dialer IP and "+overlapintf+" Should not Overlap";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else if(dialerip.equals(GetBroadcast(dialerip, dialersubnet)) ||
				   dialerip.equals(GetNetwork(dialerip, dialersubnet)))
		   {
			   errmsg = "Bad mask for Dailer IP Address";
			   %>
			   	<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else
		   {
			   //System.out.println("pool number is : "+poolnumber+"\n\n");
			   dialerobj.put("status",dialerstatus.length()>0?dialerstatus:dialerobj.getString("Status"));
			   dialerobj.put("ipAddress", dialerip.length()>0?dialerip:dialerobj.getString("ipAddress"));
			   dialerobj.put("NetMask",dialersubnet.length()>0?dialersubnet:dialerobj.getString("NetMask"));
			   dialerobj.put("PoolNo", poolnumber.length()>0?Integer.parseInt(poolnumber):dialerobj.getInt("poolNo"));
			   dialerobj.put("Authentication",authenticat.length()>0?authenticat:dialerobj.getString("Authentication"));
			   dialerobj.put("username", username.length()>0?username:dialerobj.getString("username"));
			   dialerobj.put("password", pwd.length()>0?pwd:dialerobj.getString("password"));
			   dialerobj.put("ServiceName", servname.length()>0?servname:dialerobj.getString("ServiceName"));
			   dialerobj.put("AutoDNS",dialerdns.length()>0?dialerdns:dialerobj.getString("AutoDNS"));
			   dialerobj.put("PrimaryDNS", pridns.length()>0?pridns:dialerobj.getString("PrimaryDNS"));
			   dialerobj.put("SecondaryDNS", secdns.length()>0?secdns:dialerobj.getString("SecondaryDNS"));
			   
			   //System.out.println("pool number from dialer is : "+dialerobj.getInt("poolNo")+"\n\n");
			   wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
 				.getJSONObject("ADDRESSCONFIG").put("DIALER", dialerobj);
			   setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			   
		   }
	   }
	    
		else if(pagename.equals("nat"))
	   {

		   procpage = "nat.jsp";
		   save_val = NAT;
		   boolean exists = false;
		   String rowcnt = request.getParameter("natrwcnt");
		   JSONObject natobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").
				   getJSONObject("NATCONFIG").getJSONObject("NAT");
		   JSONArray oldnattabarr = natobj.getJSONObject("TABLE").getJSONArray("arr");
		   
		  JSONArray nattabarr = new JSONArray();
		for(int i=1;i<Integer.parseInt(rowcnt);i++)
		{
			JSONObject natrow = new JSONObject();
			
			if(request.getParameter("innat"+i)==null)
				continue;
		   String natint = request.getParameter("innat"+i)==null?"":request.getParameter("innat"+i);
		   String natsrcip = request.getParameter("srcip"+i)==null?"":request.getParameter("srcip"+i);
		   String natsrcsub = request.getParameter("srcnm"+i)==null?"":request.getParameter("srcnm"+i);
		   String natoutif = request.getParameter("outnat"+i)==null?"":request.getParameter("outnat"+i);
		   String nataction = request.getParameter("act"+i)==null?"":request.getParameter("act"+i);
		   
		   
		   natrow.put("natInsideif",natint);
		   natrow.put("sourceIP",natsrcip);
		   natrow.put("sourceSubnet",natsrcsub);
		   natrow.put("natOutsideif",natoutif);
		   natrow.put("natAction",nataction);
		   nattabarr.add(natrow);
		}
		for(int i=nattabarr.size()-1;i>=0;i--)
		{
			boolean error = false;
			JSONObject natrow1 = nattabarr.getJSONObject(i);
			for(int j=0;j<nattabarr.size();j++)
			{
				   JSONObject natrow2 = nattabarr.getJSONObject(j);
				   if( i!=j && natrow1.getString("natInsideif").equals(natrow2.getString("natInsideif")) && 
				   natrow1.getString("sourceIP").equals(natrow2.getString("sourceIP")) &&
				   natrow1.getString("sourceSubnet").equals(natrow2.getString("sourceSubnet")) &&
				   natrow1.getString("natOutsideif").equals(natrow2.getString("natOutsideif")) && 
				   natrow1.getString("natAction").equals(natrow2.getString("natAction")) )
				   {
					   errmsg = "Entry already exists,Please try again..  ";
							  error = true;
							   break;
				   }
				   else if(!natrow1.getString("natOutsideif").equals(natrow2.getString("natOutsideif")))
				   {
					   errmsg = "  Outside Interface should be same in All Entries ,Please try again..  ";
							   error = true;
							   break;

				   }
				  
			}
			if(!error && natrow1.getString("natInsideif").equals(natrow1.getString("natOutsideif")))
			{
				errmsg = "  Inside And Outside Interface Should not be Same,Please try again..  ";
				error = true;
			}
			if(error)
			{
				nattabarr.remove(i);
				if(oldnattabarr.size() > i)
				{
					nattabarr.add(i,oldnattabarr.getJSONObject(i));
				}
			}
		}
		
			 	natobj.getJSONObject("TABLE").put("arr", nattabarr);
		 		setSaveIndex(wizjsonnode,save_val);  
				BufferedWriter jsonWriter = null;
		  	 	try
		  	 	{
			   		jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
		   			jsonWriter.write(wizjsonnode.toString(2));
		 
		   	 	 }
		  		 catch(Exception e)
		  	 	{
			   		e.printStackTrace();
			   		internal_err = true;
		   			}
		  		 finally
		   		{
			  		if(jsonWriter != null)
			   		jsonWriter.close();
		   		}	   
		  	 	if(errmsg.length() > 0)
				{%>
					<script>
						 goToPage("nat.jsp","error",'<%=errmsg%>','<%=slnumber%>');
					</script>
				<% 
				}
	   }
		
	   else if(pagename.equals("dns"))
		{
			procpage = "dns.jsp";
			save_val = DNS;
		   //System.out.println("\n\n Auto DNS is : "+request.getParameter("oauto")+"\n\n");
		   JSONObject dnsobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
	  				.getJSONObject("DNS");

		String dns = request.getParameter("oauto") == null?"Disable":"Enable";
		String pridns = request.getParameter("pridns") == null?dnsobj.getString("PrimaryDNS"):request.getParameter("pridns");
		String secdns = request.getParameter("secdns") == null?dnsobj.getString("SecondaryDNS"):request.getParameter("secdns");
		 
		   if(pridns == "")
		   {
			   errmsg = "PrimaryDNS Should not be same";
			   %>
			   	<script>
				  goToPage("dns.jsp","error",'<%=errmsg%>','<%=slnumber%>');
				</script>
			   <%
		   }
		   else
		   {
			   dnsobj.put("AutoDNS",dns.length()>0?dns:dnsobj.getString("AutoDNS"));
			   dnsobj.put("PrimaryDNS", pridns.length()>0?pridns:dnsobj.getString("PrimaryDNS"));
			   dnsobj.put("SecondaryDNS", secdns.length()>0?secdns:dnsobj.getString("SecondaryDNS"));
			   
			   
			   wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
 				.put("DNS", dnsobj);
			   setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			   
		   }  
	   }
	    else if(pagename.equals("snmp"))
		{
			procpage = "snmp.jsp";
			save_val = SNMP_CONFIG;
		   //System.out.println("\n\n Auto DNS is : "+request.getParameter("oauto")+"\n\n");
		   JSONObject snmpobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
	  				.getJSONObject("SNMPCONFIG").getJSONObject("SNMP");

		String snmpver = request.getParameter("version") == null?snmpobj.getString("Version"):request.getParameter("version");
		String snmpsyscnt = request.getParameter("systmcntct") == null?snmpobj.getString("System_Contact"):request.getParameter("systmcntct");
		String sysname = request.getParameter("systmname") == null?snmpobj.getString("System_Name"):request.getParameter("systmname");
		String sysloc = request.getParameter("systmlctn") == null?snmpobj.getString("System_Location"):request.getParameter("systmlctn");
		String readcomm = request.getParameter("readcmnty") == null?snmpobj.getString("Read_Community"):request.getParameter("readcmnty");
		String writecomm = request.getParameter("wrtecmnty") == null?snmpobj.getString("Write_Community"):request.getParameter("wrtecmnty");
		String snmpuser = request.getParameter("user") == null?snmpobj.getString("user"):request.getParameter("user");
		String securmode = request.getParameter("sctymode") == null?snmpobj.getString("Security Mode"):request.getParameter("sctymode");
		String snmpauth = request.getParameter("authtcn") == null?"":request.getParameter("authtcn");
		String snmpencry = request.getParameter("encrptn") == null?"":request.getParameter("encrptn");
		String authpwd = request.getParameter("authpwd") == null?"":request.getParameter("authpwd");
		String encrypwd = request.getParameter("encpwd") == null?"":request.getParameter("encpwd");
		   
		   if(securmode == "Authentication")
		   {
			   errmsg = "AUthentication Should not be same";
			   %>
			   	<script>
				  goToPage("snmp.jsp","error",'<%=errmsg%>','<%=slnumber%>');
				</script>
			   <%
		   }
		   else
		   {
			   snmpobj.put("Version", snmpver.length()>0&&!snmpver.equals("No Change")?snmpver:snmpobj.getString("Version"));
			   snmpobj.put("System_Contact", snmpsyscnt.length()>0?snmpsyscnt:snmpobj.getString("System_Contact"));
			   snmpobj.put("System_Name", sysname.length()>0?sysname:snmpobj.getString("System_Name"));
			   snmpobj.put("System_Location", sysloc.length()>0?sysloc:snmpobj.getString("System_Location"));
			   snmpobj.put("Read_Community", readcomm.length()>0?readcomm:snmpobj.getString("Read_Community"));
			   snmpobj.put("Write_Community", writecomm.length()>0?writecomm:snmpobj.getString("Write_Community"));
			   snmpobj.put("user", snmpuser.length()>0?snmpuser:snmpobj.getString("user"));
			   snmpobj.put("Security_Mode", securmode.length()>0&&!securmode.equals("No Change")?securmode:snmpobj.getString("Security_Mode"));
			   snmpobj.put("Authentication", snmpauth.length()>=0&&!snmpauth.equals("No Change")?snmpauth:snmpobj.getString("Authentication"));
			   snmpobj.put("Encryption", snmpencry.length()>=0&&!snmpencry.equals("No Change")?snmpencry:snmpobj.getString("Encryption"));
			   snmpobj.put("Authentication_Pswd", authpwd.length()>=0?authpwd:snmpobj.getString("Authentication_Pswd"));
			   snmpobj.put("Encryption_Pswd", encrypwd.length()>=0?encrypwd:snmpobj.getString("Encryption_Pswd"));
			   
			   
			   wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
 				.getJSONObject("SNMPCONFIG").put("SNMP", snmpobj);
			   setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
				   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			   
		   }  
	   }
	   else if(pagename.equals("traps"))
		{
			procpage = "traps.jsp";
			save_val = TRAP_CONFIG;
		   JSONObject trapobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
	  				.getJSONObject("SNMPCONFIG").getJSONObject("TRAP");

		String trapver = request.getParameter("trpvsn") == null?trapobj.getString("Trap_Version"):request.getParameter("trpvsn");
		String trapcomm = request.getParameter("trpcmnty") == null?trapobj.getString("Trap_Community"):request.getParameter("trpcmnty");
		String trapsrc = request.getParameter("trpsrc") == null?trapobj.getString("Trap_Source"):request.getParameter("trpsrc");
		String trapcldstrt = request.getParameter("cldstrt") == null?"Disable":"Enable";
		String trapauth = request.getParameter("athtcn") == null?"Disable":"Enable";
		String traplink = request.getParameter("lnkupdwn") == null?"Disable":"Enable";
		
		if(trapsrc.equals("No Change"))
			trapsrc = trapobj.getString("Trap_Source");
        if(((trapver.length() == 0 || trapver.equals("No Change")) && 
        		(trapobj.getString("Trap_Version").equals("") || trapobj.getString("Trap_Version").equals("No Change")))
        		&& trapcomm.length() == 0)
        		errmsg = "Version And TRAP Community are not Configured !! ,Please Configure And try again..";
        	
        else if((trapver.length() == 0 || trapver.equals("No Change")) && 
        		(trapobj.getString("Trap_Version").equals("") || trapobj.getString("Trap_Version").equals("No Change")))
        	errmsg = "Version not Configured !! , Please Configure Version And try again..";
        else if(trapcomm.length() == 0 )
        {
        	errmsg = "Community not Configured !! , Please Configure Community And try again..";
        }
        	
        else if(errmsg.length() > 0 || (errmsg =  trapSrcConfigured(trapsrc,wizjsonnode)).length() > 0)
		{%>
			<script>
			    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
			</script>
		<%}
       
		else
		{
		JSONArray maniparr = new JSONArray();
		JSONArray manstatusarr = new JSONArray();
		JSONArray oldManagerStatus = trapobj.getJSONArray("ManagerStatus");
		for(int i=1;i<6;i++)
		{
		    String mstatus = oldManagerStatus.getString(i-1);	
			maniparr.add(request.getParameter("ipadrs"+i)==null?"":request.getParameter("ipadrs"+i));
			manstatusarr.add(request.getParameter("enbldsbl"+i)==null?"":request.getParameter("enbldsbl"+i).equals("No Change")?mstatus:request.getParameter("enbldsbl"+i));
		}
		   if(trapcomm == "")
		   {
			   errmsg = "Trap Community Should not be same";
			   %>
			   	<script>
				  goToPage("traps.jsp","error",'<%=errmsg%>','<%=slnumber%>');
				</script>
			   <%
		   }
		   else
		   {
			   trapobj.put("Trap_Version", trapver.length()>0&&!trapver.equals("No Change")?trapver:trapobj.getString("Trap_Version"));
			   trapobj.put("Trap_Community", trapcomm.length()>0?trapcomm:trapobj.getString("Trap_Community"));
			   trapobj.put("Trap_Source", trapsrc.length()>0&&!trapsrc.equals("No Change")?trapsrc:trapobj.getString("Trap_Source"));
			   trapobj.put("Coldstart",trapcldstrt.length()>0?trapcldstrt:trapobj.getString("Coldstart"));
			   trapobj.put("Authentication",trapauth.length()>0?trapauth:trapobj.getString("Authentication"));
			   trapobj.put("Linkup_down",traplink.length()>0?traplink:trapobj.getString("Linkup_down"));
			   
			   trapobj.put("MangerIP",maniparr);
			   trapobj.put("ManagerStatus",manstatusarr);
			   
			   wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
 				.getJSONObject("SNMPCONFIG").put("TRAP", trapobj);
			   setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			   
		   } 
		}
	   }
	   
	    else if(pagename.equals("tunnelconfig"))
		{
	    	instname = request.getParameter("instname");
			save_val = IPSEC_CONFIG;
			procpage = "ipsec_select.jsp?version="+fmversion;
			JSONObject ipsecobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
  				.getJSONObject("IPSECCONFIG").getJSONObject("IPSEC");
			String tunlselno = ipsecobj.getString("IpsecSelectNo");
			JSONArray tunlarr = ipsecobj.getJSONObject("TABLE").getJSONArray("arr");
			Hashtable<String,JSONObject> tunnels_ht = new Hashtable<String,JSONObject>();
			int dpeer_ccnt = 0;
			String tnldualpeer = request.getParameter("dualpeer")==null?"Disable":"Enable"; //need to check another tunner have dual peer or not for that we hava to take deal peer here
			
			for(int i=0;i<tunlarr.size();i++)
			{
				JSONObject tunobj = tunlarr.getJSONObject(i);
				String instancename = tunobj.getString("instancename");
				if(!instname.equals(instancename) && 
				tunobj.getString("DualPeer").equals("Enable") && 
				tnldualpeer.equals("Enable") && !fmversion.contains("1.8.3"))
				{
					System.out.println("version is : "+fmversion+" is contains 1.8.3 : "+fmversion.contains("1.8.3"));
					errmsg = "DulaPeer is Supported Only for One Tunnel";
				}
				tunnels_ht.put(instancename,tunobj);
			}

			//System.out.println("Duel peer is : "+request.getParameter("dualpeer"));
			
			String tnllclid = request.getParameter("lidopt")==null?"":request.getParameter("lidopt");
			String tnllclep = request.getParameter("lfqep")==null?"":request.getParameter("lfqep");
			String tnlremoteid = request.getParameter("ridopt")==null?"":request.getParameter("ridopt");
			String tnlremoteep = request.getParameter("rfqep")==null?"":request.getParameter("rfqep");
			String tnlactivat = request.getParameter("activation")==null?"Disable":"Enable";
			String tnlagsmode = request.getParameter("Agsvemode")==null?"Disable":"Enable";
			String tnlremotepeer = request.getParameter("rempeer")==null?"":request.getParameter("rempeer");
			String tnlrempeerdns = request.getParameter("rempeerdns")==null?"":request.getParameter("rempeerdns");
			String tnllclcryep = request.getParameter("lclcryptendpnt")==null?"":request.getParameter("lclcryptendpnt");
			String tnlsecpeer = request.getParameter("scndrypeer")==null?"":request.getParameter("scndrypeer");
			String tnlsecpeerdns = request.getParameter("scndrypeerdns")==null?"":request.getParameter("scndrypeerdns");
			String tnlinsname = request.getParameter("instname")==null?"":request.getParameter("instname");
			String tnlpreshare1 = request.getParameter("keycnfgrtn")==null?"":request.getParameter("keycnfgrtn");
			String tnlpreshare2= request.getParameter("keycnfgrtn2")==null?"":request.getParameter("keycnfgrtn2");
			String isakmpencry= request.getParameter("ISAKMP_enc")==null?"":request.getParameter("ISAKMP_enc");
			String isakmphashing= request.getParameter("ISAKMP_hash")==null?"":request.getParameter("ISAKMP_hash");
			String isakmpdhgrup= request.getParameter("ISAKMP_grp")==null?"":request.getParameter("ISAKMP_grp");
			String isakmplft= request.getParameter("ISAKMP_lifetime")==null?84200+"":request.getParameter("ISAKMP_lifetime");
			String ipsecencry= request.getParameter("IPsec_enc")==null?"":request.getParameter("IPsec_enc");
			String ipsechashing= request.getParameter("IPsec_hash")==null?"":request.getParameter("IPsec_hash");
			String ipsecpfs= request.getParameter("PFS_grp")==null?"":request.getParameter("PFS_grp");
			String ipseclft= request.getParameter("lifetime_sec")==null?1000+"":request.getParameter("lifetime_sec");
			String tnlnat= request.getParameter("NAT_trav")==null?"":request.getParameter("NAT_trav");
			String tnldpdserv= request.getParameter("dpdserv")==null?"":request.getParameter("dpdserv");
			String tnldpeerdelay= request.getParameter("DPD_Int")==null?3+"":request.getParameter("DPD_Int");
			String tnldpeerretry= request.getParameter("DPD_retr")==null?3+"":request.getParameter("DPD_retr");
			String tnldpeerfails= request.getParameter("DPD_fails")==null?3+"":request.getParameter("DPD_fails");
			
			Integer aclrows = request.getParameter("plcyrwcnt") == null?0:Integer.parseInt(request.getParameter("plcyrwcnt"));				
			JSONObject tunlcnfobj = tunnels_ht.get(tnlinsname);
			if(tnllclcryep.equals("No Change"))
				tnllclcryep=tunlcnfobj.getString("interface");
			JSONArray oldaclarr = tunlcnfobj.getJSONObject("TABLE").getJSONArray("arr");
			
			JSONArray newaclarr = new JSONArray();
			for(int i=1;i<aclrows;i++)
			{
				String interfacename = request.getParameter("intf"+i);
				if(interfacename == null)
					continue;
				if(errmsg.length() > 0 || (errmsg =  trapSrcConfigured(interfacename,wizjsonnode)).length() > 0)
				break;
				String srcNWIP = request.getParameter("srcntwrk"+i);
				String srcSubNetIP = request.getParameter("srcsbntmsk"+i);
				String dstNWIP = request.getParameter("destntwrk"+i);
				String dstSubNetIP = request.getParameter("destnsbntmsk"+i);
				JSONObject oldaclobj = null;
				if(oldaclarr.size() > i-1)
				{
					oldaclobj = oldaclarr.getJSONObject(i-1);
				}
				JSONObject aclobj = new JSONObject();
				aclobj.put("interface",interfacename==null?"--Select--":interfacename);
				aclobj.put("srcNWIP",srcNWIP==null?"":srcNWIP);
				aclobj.put("srcSubNetIP",srcSubNetIP==null?"":srcSubNetIP);
				aclobj.put("dstNWIP",dstNWIP==null?"":dstNWIP);
				aclobj.put("dstSubNetIP",dstSubNetIP==null?"":dstSubNetIP);
				
				newaclarr.add(aclobj);
			}
			String newerrmesg = "";
			if(errmsg.length() == 0)
			{
				
			for(int i=newaclarr.size()-1;i>=0;i--)
			{
				boolean error = false;
				JSONObject acl1 = newaclarr.getJSONObject(i);
				String intf = acl1.getString("interface");
				String msg="";
				if((msg = trapSrcConfigured(intf,wizjsonnode)).length() > 0 )
				{
					newerrmesg = msg;
					error = true;
				}
				/* if(((acl1.getString("srcNWIP").equals("0.0.0.0") && !acl1.getString("srcSubNetIP").equals("0.0.0.0")) || 
						   (!acl1.getString("srcSubNetIP").equals("0.0.0.0") && acl1.getString("srcNWIP").equals("0.0.0.0"))
						   || !isConsistance(acl1.getString("srcNWIP"),acl1.getString("srcSubNetIP"))) && intf.equals("--Select--"))
				   	{
					newerrmesg = "Inconsistent source Network and  Netmask in ACLS";
					  	error = true;
				   	}
				else if((acl1.getString("dstNWIP").equals("0.0.0.0") && !acl1.getString("dstSubNetIP").equals("0.0.0.0")) || 
						   (!acl1.getString("dstSubNetIP").equals("0.0.0.0") && acl1.getString("dstNWIP").equals("0.0.0.0"))
						 ||!isConsistance(acl1.getString("dstNWIP"),acl1.getString("dstSubNetIP")) )
				   	{
					newerrmesg = "Inconsistent Destination Network and  Netmask in ACLS";
					  	error = true;
				   	} */
					for(int j=0;j<newaclarr.size();j++)
					{
						JSONObject acl2 = newaclarr.getJSONObject(j);
					
						if(i!=j && (acl1.getString("interface").equals(acl2.getString("interface")) 
							    && acl1.getString("srcNWIP").equals(acl2.getString("srcNWIP"))
							    && acl1.getString("srcSubNetIP").equals(acl2.getString("srcSubNetIP"))
							    && acl1.getString("dstNWIP").equals(acl2.getString("dstNWIP"))
							    && acl1.getString("dstSubNetIP").equals(acl2.getString("dstSubNetIP"))))
						{
							newerrmesg = "Duplicate Entry... in Policy Configuration";
							error = true;
							break;
						}
					
					}
				   	//System.out.println("error msg in policy is : "+newerrmesg);
				if(error)
				{
					newaclarr.remove(i);
					if(oldaclarr.size() > i)
						newaclarr.add(i, oldaclarr.getJSONObject(i));
				}
			}
			}
			if(errmsg.length() > 0)
			{
				 %>
				   	<script>
					  goToPage(<%=procpage%>,"error",'<%=errmsg%>','<%=slnumber%>');
					</script>
				   <%
			}
			else
			{
				   tunlcnfobj.put("LocalID", tnllclid.length()>0?tnllclid:tunlcnfobj.getString("LocalID"));
				   tunlcnfobj.put("LocalEndPoint", tnllclep.length()>0?tnllclep:tunlcnfobj.getString("LocalEndPoint"));
				   tunlcnfobj.put("RemoteID", tnlremoteid.length()>0?tnlremoteid:tunlcnfobj.getString("RemoteID"));
				   tunlcnfobj.put("RemoteEndPoint", tnlremoteep.length()>0?tnlremoteep:tunlcnfobj.getString("RemoteEndPoint"));
				   tunlcnfobj.put("Activation", tnlactivat.length()>0?tnlactivat:tunlcnfobj.getString("Activation"));
				   tunlcnfobj.put("AggressiveMode", tnlagsmode.length()>0?tnlagsmode:tunlcnfobj.getString("AggressiveMode"));
				   tunlcnfobj.put("DualPeer", tnldualpeer.length()>0?tnldualpeer:tunlcnfobj.getString("DualPeer"));
				   tunlcnfobj.put("remIP", tnlremotepeer.length()>0?tnlremotepeer:"");
				   tunlcnfobj.put("interface", tnllclcryep.length()>0&&!tnllclcryep.equals("No Change")?tnllclcryep:tunlcnfobj.getString("interface"));
				   tunlcnfobj.put("SecondaryIP", tnlsecpeer.length()>0?tnlsecpeer:"");
				   tunlcnfobj.put("remoteDNS", tnlrempeerdns.length()>0?tnlrempeerdns:"");
				   tunlcnfobj.put("secondaryDNS", tnlsecpeerdns.length()>0?tnlsecpeerdns:"");
				   
				   tunlcnfobj.put("instancename", tnlinsname.length()>0?tnlinsname:tunlcnfobj.getString("instancename"));
				   tunlcnfobj.put("PreshareKey", tnlpreshare1.length()>0?tnlpreshare1:tunlcnfobj.getString("PreshareKey"));
				   tunlcnfobj.put("PreshareKey2", tnlpreshare2.length()>0?tnlpreshare2:tunlcnfobj.getString("PreshareKey2"));
				   tunlcnfobj.put("EncryptionTypePh1", isakmpencry.length()>0&&!isakmpencry.equals("No Change")?isakmpencry:tunlcnfobj.getString("EncryptionTypePh1"));
				   tunlcnfobj.put("HashingPh1", isakmphashing.length()>0&&!isakmphashing.equals("No Change")?isakmphashing:tunlcnfobj.getString("HashingPh1"));
				   tunlcnfobj.put("DHgroup", isakmpdhgrup.length()>0&&!isakmpdhgrup.equals("No Change")?isakmpdhgrup:tunlcnfobj.getString("DHgroup"));
				   tunlcnfobj.put("LifeTimePh1", isakmplft.length()>0?Integer.parseInt(isakmplft):tunlcnfobj.getInt("LifeTimePh1"));
				   tunlcnfobj.put("EncryptionTypePh2", ipsecencry.length()>0&&!ipsecencry.equals("No Change")?ipsecencry:tunlcnfobj.getString("EncryptionTypePh2"));
				   tunlcnfobj.put("HashingPh2", ipsechashing.length()>0&&!ipsechashing.equals("No Change")?ipsechashing:tunlcnfobj.getString("HashingPh2"));
				   tunlcnfobj.put("PFSgroup", ipsecpfs.length()>0&&!ipsecpfs.equals("No Change")?ipsecpfs:tunlcnfobj.getString("PFSgroup"));
				   tunlcnfobj.put("LifeTimePh2", ipseclft.length()>0?Integer.parseInt(ipseclft):tunlcnfobj.getInt("LifeTimePh2"));
				   tunlcnfobj.put("NAT_traversal", tnlnat.length()>0&&!tnlnat.equals("No Change")?tnlnat:tunlcnfobj.getString("NAT_traversal"));
				   tunlcnfobj.put("DPDService", tnldpdserv.length()>0&&!tnldpdserv.equals("No Change")?tnldpdserv:tunlcnfobj.getString("DPDService"));
				   tunlcnfobj.put("DPDDelay", tnldpeerdelay.length()>0?Integer.parseInt(tnldpeerdelay):tunlcnfobj.getInt("DPDDelay"));
				   tunlcnfobj.put("DPDRetryDelay", tnldpeerretry.length()>0?Integer.parseInt(tnldpeerretry):tunlcnfobj.getInt("DPDRetryDelay"));
				   tunlcnfobj.put("DPDMaxFails", tnldpeerfails.length()>0?Integer.parseInt(tnldpeerfails):tunlcnfobj.getInt("DPDMaxFails"));
				   
				
				tunlcnfobj.getJSONObject("TABLE").put("arr", newaclarr);
				
				for(int i=0;i<tunlarr.size();i++)
				{
					JSONObject tunobj = tunlarr.getJSONObject(i);
					if(tunobj.getString("instancename").equals(tnlinsname))
					{
						tunlarr.remove(i);
						tunlarr.add(i, tunlcnfobj);
						break;
					}
				}
				String c_endpoint="Cellular";
                if(tnllclcryep.length() == 0 || tnllclcryep.equals("No Change"))
                {
                	errmsg = "Local Crypto Endpoint should not be empty...";
                }
                else
                {
					for(int i=0;i<tunlarr.size();i++)
					{
						JSONObject tunobj = tunlarr.getJSONObject(i);
						String intf = tunobj.getString("interface");
						//System.out.println("C_enpoint is : "+c_endpoint+" intf is : "+intf);
						if(intf.length() > 0 && !intf.equals("Cellular") && !c_endpoint.equals("Cellular") && !intf.equals(c_endpoint))
						{
							errmsg = "IPSec Tunnel should be configured on either Dialer or Ethernet1";
							break;
						}
						if(!intf.equals("Cellular"))
						c_endpoint = intf;
					}
                }
				if(errmsg.length() > 0)
				{
					 %>
					   	<script>
						  goToPage(<%=procpage%>,"error",'<%=errmsg%>','<%=slnumber%>');
						</script>
					   <%
				}
				else
				{
					wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
  						.getJSONObject("IPSECCONFIG").getJSONObject("IPSEC").getJSONObject("TABLE").put("arr",tunlarr);
				 	setSaveIndex(wizjsonnode,save_val);
			   		BufferedWriter jsonWriter = null;
			  		 try
			   		{
				   		jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			  		 	jsonWriter.write(wizjsonnode.toString(2));
			 		
			  		 }
			  		 catch(Exception e)
			   		 {
				  		 e.printStackTrace();
				   		internal_err = true;
			   		 }
			  		 finally
			  		 {
				   		if(jsonWriter != null)
				  		 jsonWriter.close();
			   		 }
				}
				if(newerrmesg.length() > 0)
				{
					procpage = "tunnelconfig.jsp?instancename="+instname;
					errmsg = newerrmesg;
					%>
					<script>
					 //alert("sending to tunnelconfig page");
					  goToPage(<%=procpage%>,"error",'<%=errmsg%>','<%=slnumber%>');
					</script>
				    <%
				}
			 }
	   }
	   
	   else if(pagename.equals("ipsec_tracking"))
		{
			procpage = "ipsec_tracking.jsp";
			save_val = IPSECTRACK;
			JSONObject ipsectrackobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
  				.getJSONObject("IPSECCONFIG").getJSONObject("IPSECTRACKING");
	
		   String ipsecactivat = request.getParameter("ipsecserv") == null?ipsectrackobj.getString("IPSECTracking"):request.getParameter("ipsecserv");
		   String ipsecip = request.getParameter("trackip") == null?ipsectrackobj.getString("TrackIP"):request.getParameter("trackip") ;
		   String srcintf = request.getParameter("srcintf") == null?ipsectrackobj.getString("SourceIntf"):request.getParameter("srcintf");
		   String pingsuc = request.getParameter("pingsuccess") == null?ipsectrackobj.getString("PingSuccess"):request.getParameter("pingsuccess");
		   String reboottime = request.getParameter("rebbotto") == null?ipsectrackobj.getString("RebootTimeOut"):request.getParameter("rebbotto");
		   
			   ipsectrackobj.put("IPSECTracking",ipsecactivat.length()>0&&!ipsecactivat.equals("No Change")?ipsecactivat:ipsectrackobj.getString("IPSECTracking"));
			   ipsectrackobj.put("TrackIP", ipsecip.length()>0?ipsecip:ipsectrackobj.getString("TrackIP"));
			   ipsectrackobj.put("SourceIntf",srcintf.length()>0&&!srcintf.equals("No Change")?srcintf:ipsectrackobj.getString("SourceIntf"));
			   ipsectrackobj.put("PingSuccess",pingsuc.length()>0&&!pingsuc.equals("No Change")?pingsuc:ipsectrackobj.getString("PingSuccess"));
			   ipsectrackobj.put("RebootTimeOut",reboottime.length()>0&&!reboottime.equals("No Change")?reboottime:ipsectrackobj.getString("RebootTimeOut"));
			   
			   wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
 				.getJSONObject("IPSECCONFIG").put("IPSECTRACKING", ipsectrackobj);
			   setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			   
		}
		else if(pagename.equals("m2m_config"))
		{
			procpage = "m2m_config.jsp";
			save_val = M2M_CONFIG;
		   JSONObject m2mobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
	  				.getJSONObject("M2M");

		String m2mact = request.getParameter("activation") == null?m2mobj.getString("Activation"):request.getParameter("activation");
		String m2mintf = request.getParameter("interface") == null?m2mobj.getString("Interface"):request.getParameter("interface");
		String m2mserver = request.getParameter("Servertype") == null?m2mobj.getString("ServerType"):request.getParameter("Servertype");
		String serverip = request.getParameter("Mserverip") == null||request.getParameter("Mserverip").equals("")?m2mobj.getString("ServerIpAddr"):request.getParameter("Mserverip");
		String domainame = request.getParameter("Mdomainname") == null||request.getParameter("Mdomainname").equals("")?m2mobj.getString("DomainName"):request.getParameter("Mdomainname");
		String serverport = request.getParameter("serverport") == null?m2mobj.getInt("ServerPort")+"":request.getParameter("serverport");
		String pollperiod = request.getParameter("Pollingperiod") == null?m2mobj.getInt("Polling_Period")+"":request.getParameter("Pollingperiod");
		String retrytimeout = request.getParameter("RetryTimeout") == null?m2mobj.getInt("Retry_Timeout")+"":request.getParameter("RetryTimeout");
		String modelno = request.getParameter("modelno") == null?m2mobj.getString("ModelNumber"):request.getParameter("modelno");
		  
		   if(m2mserver.equals("IP Address"))
			   domainame="";
			   else
				serverip="0.0.0.0";
		   if(m2mact.equals("") || m2mact.equals("No Change"))
		   {
			   errmsg = "Activation Should not be Empty";
		   }
		   else if(m2mintf.equals("") || m2mintf.equals("No Change"))
		   {
			   errmsg = "Interface Should not be Empty";
		   }
		   else if(serverip.equals("") || serverip.equals("0.0.0.0") && m2mserver.equals("IP Address"))
		   {
			   if(serverport.length() == 0 && m2mobj.getInt("ServerPort") == 0)
				   errmsg = "Server IP Address and Server Port are not empty";
			   else
			   		errmsg = "Server IP Address Should not be Empty";
		   }
		   else if(domainame.equals("") && m2mserver.equals("DomainName"))
		   {
			   if(serverport.length() == 0 && m2mobj.getInt("ServerPort") == 0)
				   errmsg = "Server Domain Name and Server Port are not empty";
			   else
			   		errmsg = "Domain Name Should not be Empty";
		   }
		   else if(serverport.length() == 0 && m2mobj.getInt("ServerPort") == 0)
		   {
			   errmsg = "Server Port is not empty";
		   }
		   
		   if(errmsg.length() > 0)
		   {
			   %>
			   	<script>
				  goToPage("m2m_config.jsp","error",'<%=errmsg%>','<%=slnumber%>');
				</script>
			   <%
		   }
		   else
		   {
			   m2mobj.put("Activation", m2mact.length()>0&&!m2mact.equals("No Change")?m2mact:m2mobj.getString("Activation"));
			   m2mobj.put("Interface", m2mintf.length()>0&&!m2mintf.equals("No Change")?m2mintf:m2mobj.getString("Interface"));
			   m2mobj.put("ServerType", m2mserver.length()>0&&!m2mserver.equals("No Change")?m2mserver:m2mobj.getString("ServerType"));
			   m2mobj.put("ServerIpAddr", serverip.length()>0?serverip:"");
			   m2mobj.put("DomainName", domainame.length()>0?domainame:"");
			   m2mobj.put("ServerPort", serverport.length()>0?Integer.parseInt(serverport):m2mobj.getInt("ServerPort"));
			   m2mobj.put("Polling_Period", pollperiod.length()>0?Integer.parseInt(pollperiod):m2mobj.getInt("Polling_Period"));
			   m2mobj.put("Retry_Timeout", retrytimeout.length()>0?Integer.parseInt(retrytimeout):m2mobj.getInt("Retry_Timeout"));
			   m2mobj.put("ModelNumber", modelno.length()>0?modelno:m2mobj.getString("ModelNumber"));
			   
			   wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
 				.put("M2M", m2mobj);
			   setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   		jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			   
		   }  
	   }
		else if(pagename.equals("product_type"))
		{
			procpage = "product_type.jsp";
			save_val = PRODUCT_TYPE;
			
		   JSONObject ptypeobj = wizjsonnode.getJSONObject("SYSTEMCONTROL").getJSONObject("PRODUCTTYPE");
		   
		   
		String ptype = request.getParameter("type") == null?ptypeobj.getString("ProductType"):request.getParameter("type");
		   
		   if(ptype.equals(ptypeobj.getString("ProductType")) || ptype.equals("No Change"))
		   {
			   errmsg = "Configuration is Already in Same Product Type";
			   %>
			   	<script>
				  goToPage("product_type.jsp","error",'<%=errmsg%>','<%=slnumber%>');
				</script>
			   <%
		   }
		   else
		   {
			   String old_pro_type= ptypeobj.getString("ProductType");
			   if(!ptypeobj.containsKey("OldProductType"))
				   ptypeobj.put("OldProductType",ptypeobj.get("ProductType"));
			   ptypeobj.put("ProductType", ptype.length()>0?ptype:ptypeobj.getString("ProductType"));
			   
			   wizjsonnode.getJSONObject("SYSTEMCONTROL").put("PRODUCTTYPE", ptypeobj);
			   setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			  procpage = "errormsg.jsp";
			  errmsg="Please Save the Configurations....";
		   }  
	   }
	   
	   else if(pagename.equals("ipsec_autofb") || pagename.equals("ipsec_multi"))
		{				
		   int del_tun_index = 0;
		   procpage = "ipsec_select.jsp?version="+fmversion;
			   
			String action = request.getParameter("action")==null?"":request.getParameter("action");
		    boolean exists = false;
		   JSONObject ipsec_obj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").
				   getJSONObject("IPSECCONFIG").getJSONObject("IPSEC");
		   del_tun_index = ipsec_obj.containsKey("del_tun_index")?ipsec_obj.getInt("del_tun_index"):0;
		   String ipsecslctno=ipsec_obj.getString("IpsecSelectNo");	   
		   JSONArray tunnelarr =ipsec_obj.getJSONObject("TABLE").getJSONArray("arr");
		   
		   
		   JSONObject tunnelrow = new JSONObject();
		   String ipsecafinstname = request.getParameter("instancename")==null?"":request.getParameter("instancename");
		   
		   if(action.equals("add"))
		   {
			   if(del_tun_index > 0)
			   {
				   errmsg = "Add Tunnel is not possible, local Device should update";
			   }
			   else if(ipsecafinstname.trim().length() == 0)
				   errmsg = "Instance Name Cannot be Empty...";
			   else
			   {
			   for(int i=0;i<tunnelarr.size();i++)
			   {
				   JSONObject tunobj = tunnelarr.getJSONObject(i);
				   if(tunobj.getString("instancename").equals(ipsecafinstname))
				   {
					   errmsg = "Instance Name "+ipsecafinstname+" Already Exists...";
					   break;
				   }
			   }
			   }
			   int slno = 1;
			   for(int i=1;i<=6;i++)
			   {
				   boolean slexists = false;
				   for(int j=0;j<tunnelarr.size();j++)
				   {
					   JSONObject tunnel = tunnelarr.getJSONObject(j);
					   int tunslno = tunnel.containsKey("sl")?tunnel.getInt("sl") :1;
					   if(tunslno == i)
						{
							slexists  = true;
							 break;
						 }
				   }
				   
				   if(!slexists)
				   {
				   		slno = i;
				   		break;
				   }
				  
			   }
			   if((tunnelarr.size() < 5 && pagename.equals("ipsec_multi")) || (pagename.equals("ipsec_autofb")&&tunnelarr.size()<1))
			   {
			    save_val = IPSEC_CONFIG;
			    tunnelrow.put("sl",slno);
		        tunnelrow.put("LocalID", "IP Address");
                tunnelrow.put("LocalEndPoint","");
           		tunnelrow.put("RemoteID", "IP Address");
           		tunnelrow.put("RemoteEndPoint", "");
           		tunnelrow.put("Activation", "Disable");
           		tunnelrow.put("AggressiveMode", "Disable");
           		tunnelrow.put("DualPeer", "Disable");
           		tunnelrow.put("remIP", "0.0.0.0");
           		tunnelrow.put("interface", "");
           		tunnelrow.put("SecondaryIP", "0.0.0.0");
           		tunnelrow.put("instancename", ipsecafinstname);
           		tunnelrow.put("PreshareKey", "");
           		tunnelrow.put("PreshareKey2", "");
           		tunnelrow.put("EncryptionTypePh1", "");
           		tunnelrow.put("HashingPh1", "");
           		tunnelrow.put("DHgroup", "");
           		tunnelrow.put("LifeTimePh1", 0);
           		tunnelrow.put("EncryptionTypePh2", "");
           		tunnelrow.put("HashingPh2", "");
           		tunnelrow.put("PFSgroup", "");
           		tunnelrow.put("LifeTimePh2", 0);
           		tunnelrow.put("NAT_traversal", "");
           		tunnelrow.put("DPDService", "");
           		tunnelrow.put("DPDDelay", 0);
           		tunnelrow.put("DPDRetryDelay", 0);
           		tunnelrow.put("DPDMaxFails", 0);
           		tunnelrow.put("remoteDNS", "");
           		tunnelrow.put("secondaryDNS", "");
           		tunnelrow.put("status", "Down");
           		//tunnelrow.put("action", "");
               JSONObject acltable = new JSONObject();
               
               acltable.put("NAME", "ACL");
               JSONArray aclarr = new JSONArray();
               acltable.put("arr", aclarr);
               tunnelrow.put("TABLE",acltable);
		   
		   		//tunnelarr.add((slno-1),tunnelrow);
		   		tunnelarr.add(tunnelrow);
			   }
			   else
			   {
				   if(pagename.equals("ipsec_autofb"))
					   errmsg = "Maximum 1 row is allowed in IPSEC Table..";
				   else
				   errmsg = "Maximum 5 rows are allowed in IPSEC Table..";
			   }
		   }
		   else if(action.equals("delete"))
		   {
			   save_val = IPSEC_DELETE;
			   
			   for(int i=0;i<tunnelarr.size();i++)
			   {
				   JSONObject tunnel = tunnelarr.getJSONObject(i);
				   
				   if(ipsecafinstname.equals(tunnel.getString("instancename")))
				   {
					   int index = tunnel.containsKey("sl")?tunnel.getInt("sl"):(i+1);
					   tunnelarr.remove(i);
					   //tunnel.put("action","Delete");
					   del_tun_index = del_tun_index | (1<<(index-1));
					   ipsec_obj.put("del_tun_index", del_tun_index);
					   break;
				   }
			   }
			   
		   }
		   else if(action.equals("apply"))
		   {
			   save_val = IPSEC_APPLY;
		   }
		   if(tunnelarr.size()==0)
		   {
			   procpage = "ipsec_select.jsp";
			   ipsec_obj.put("IpsecSelectNo","");
		   }
		   if(errmsg.length() == 0)
		   {
		   		ipsec_obj.getJSONObject("TABLE").put("arr", tunnelarr);
		 		wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").
		   		getJSONObject("IPSECCONFIG").put("IPSEC",ipsec_obj);
		 
		 		setSaveIndex(wizjsonnode,save_val);
				 BufferedWriter jsonWriter = null;
		   		try
		   		{
			  		 jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
		   			jsonWriter.write(wizjsonnode.toString(2));
		  		 }
		   		catch(Exception e)
		   		{
			  		 e.printStackTrace();
			  		 internal_err = true;
		  		 }
		   		finally
		  		 {
			  		 if(jsonWriter != null)
			   		jsonWriter.close();
		  		 }
		   }
	   }
	   else if(pagename.equals("autofallback"))
		{
			procpage = "autofallback.jsp";
			save_val = AUTOFALLBACK;
		   JSONObject autflbck =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
   				.getJSONObject("IPSECCONFIG").getJSONObject("AUTO_FALLBACK");

		String autflbckactvtn= request.getParameter("enable") == null?autflbck.getString("Activation"):request.getParameter("enable");
		String autflbckpintfce = request.getParameter("pri_inf") == null?autflbck.getString("PrimaryIntf"):request.getParameter("pri_inf");
		String autflbcksintfce	 = request.getParameter("sec_inf") == null?autflbck.getString("SecondaryIntf"):request.getParameter("sec_inf");
		String autflbckrmipadrs = request.getParameter("remoteIP") == null?autflbck.getString("RemoteIP"):request.getParameter("remoteIP");
		String autflbckpgtwy = request.getParameter("gatewayIP") == null?autflbck.getString("GatewayIP"):request.getParameter("gatewayIP");
		String autflbcksgtwy = request.getParameter("secgatewayIP") == null?autflbck.getString("SecondaryGWIP"):request.getParameter("secgatewayIP");
		String autflbckscsrate = request.getParameter("suc_rate") == null?autflbck.getString("SuccessRate"):request.getParameter("suc_rate");
		String autflbckpingcnt = request.getParameter("ping_count") == null?autflbck.getString("PingCount"):request.getParameter("ping_count");
		   
		   if(autflbckpintfce.equals(autflbcksintfce))
		   {
			   errmsg = "Primary Interface and Secondary Interface Should not be same";
			   %>
			   	<script>
				   goToPage("autofallback.jsp","error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   else
		   {
			   autflbck.put("Activation", autflbckactvtn.length()>0?autflbckactvtn:autflbck.getString("Activation"));
			   autflbck.put("PrimaryIntf", autflbckpintfce.length()>0?autflbckpintfce:autflbck.getString("PrimaryIntf"));
			   autflbck.put("SecondaryIntf", autflbcksintfce.length()>0?autflbcksintfce:autflbck.getString("SecondaryIntf"));
			   autflbck.put("RemoteIP", autflbckrmipadrs.length()>0?autflbckrmipadrs:autflbck.getString("RemoteIP"));
			   autflbck.put("GatewayIP", autflbckpgtwy.length()>0?autflbckpgtwy:autflbck.getString("GatewayIP"));
			   autflbck.put("SecondaryGWIP", autflbcksgtwy.length()>0?autflbcksgtwy:autflbck.getString("SecondaryGWIP"));
			   autflbck.put("SuccessRate", autflbckscsrate.length()>0?autflbckscsrate:autflbck.getString("SuccessRate"));
               autflbck.put("PingCount", autflbckpingcnt.length()>0?Integer.parseInt(autflbckpingcnt):autflbck.getInt("PingCount"));
			   
			 wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
 				.getJSONObject("IPSECCONFIG").put("AUTO_FALLBACK", autflbck);
			 setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			   
		   }  
	   }
	   else if(pagename.equals("ipsec_select"))
		{
			procpage = "ipsec_select.jsp";
		   JSONObject ipsecobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
   				.getJSONObject("IPSECCONFIG").getJSONObject("IPSEC");
		   String ipsectype = request.getParameter("ipsecselect")==null?"":request.getParameter("ipsecselect");
		   if(ipsectype.equals("IPSec Autofallback"))
			   procpage = "ipsec_autofb.jsp";
		   else if(ipsectype.equals("IPSec MultiTunnel"))
			   procpage = "ipsec_multi.jsp";
			   
		   ipsecobj.put("IpsecSelectNo",ipsectype);   
		   wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
				.getJSONObject("IPSECCONFIG").put("IPSEC",ipsecobj);
				
				 BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
		}
	   else if(pagename.equals("adduser"))
		{
			procpage = "user_config.jsp";
			save_val = ADDUSER;
			JSONArray users = wizjsonnode.getJSONObject("USERCONFIG").getJSONObject("TABLE").getJSONArray("USERS");
		  	String username = request.getParameter("username");
		  	String password1 = request.getParameter("password1");
		  	String password2 = request.getParameter("password2");
		  	String status = null;
		  	
		  	JSONObject usertobeadd = null;
		  	for(int i=0;i<users.size();i++)
		  	{
		  		JSONObject user = users.getJSONObject(i);
		  		if(user.getString("username").length() == 0)
		  		{
		  			usertobeadd = user;
		  			break;
		  		}
		  	}
		  	if(usertobeadd == null)
		  	{
		  		procpage  = "errormsg.jsp";
		  		errmsg = "You have Reached Maximum Users..";
		  	}
		  	else
		  	{
		  	for(int i=0;i<users.size();i++)
		  	{
		  		JSONObject user = users.getJSONObject(i);
		  		if(user.getString("username").equals(username))
		  		{
		  			errmsg="Error: User exists With this Name,Please try With Different User ..";
		  			break;
		  		}
		  	}
		  	}
		  	if(errmsg.length() > 0)
		  	{
		  	}
		  	else
		  	{
		  		if(username.length() <5 || password1.length() < 5)
		  			errmsg = "Error: Username and Password Length Should Be Minimum 5 Characters.";
		  		else if(password1.equals(password2))
		  		{
		  		JSONObject user = new JSONObject();
		  		usertobeadd.put("username",username);
		  		usertobeadd.put("password",password1);
		  		wizjsonnode.getJSONObject("USERCONFIG").getJSONObject("TABLE").put("USERS",users);
		  		setSaveIndex(wizjsonnode,save_val);
		  		 BufferedWriter jsonWriter = null;
				 errmsg="User added Successfully";
			   try
			   {
				    jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   		jsonWriter.write(wizjsonnode.toString(2));
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
				}
		  		else
		  		{
		  			errmsg = "password is not matched";
		  		}
		  	}
		  	if(procpage.equals("errormsg.jsp"))
		  	{
		  		
		  	}
		  	else if(errmsg.length() > 0)
		  	{
		  		procpage +="?status="+errmsg;
		  	}
		  	else
		  	procpage +="?status="+status;
		  	
		}
	   else if(pagename.equals("edituser"))
		{
			procpage = "user_config.jsp";
			save_val = EDITUSER;
			JSONArray users = wizjsonnode.getJSONObject("USERCONFIG").getJSONObject("TABLE").getJSONArray("USERS");
			String oldusername = request.getParameter("oldusername");
		  	String oldpassword = request.getParameter("oldpassword");
		  	String username = request.getParameter("newusername");
		  	String password1 = request.getParameter("password1");
		  	String password2 = request.getParameter("password2");
		  	String status=null;
		  	JSONObject repuser=null;
		  	boolean userexists = false;
		  	boolean wrgpassword = false;
		  	boolean duplicateuser = false;
		  	int index = -1;
		  	for(int i=0;i<users.size();i++)
		  	{
		  		JSONObject user = users.getJSONObject(i);
		  		if(user.getString("username").equals(oldusername))
		  		{
		  			
		  			if(user.getString("password").equals(oldpassword))
		  			{
		  				userexists = true;
		  				index = i;
		  				repuser = user;
		  			}
		  			else
		  			{
		  				wrgpassword = true;
		  				break;
		  			}
		  		}
		  		if(user.getString("username").equals(username) && !user.getString("username").equals(oldusername))
	  			{
	  				duplicateuser = true;
	  				break;
	  			}
		  	}
		  	if(duplicateuser)
		  		status = "Error: User already exists !!. Please try again..";
		  	else if(username.length() < 5 || password1.length() < 5)
		  		status = "Error: Username and Password Length should be minimun 5 characters";
		  	else if(repuser != null)
		  	{
		  		if(password1.equals(password2))
		  		{	
		  		JSONObject user = users.getJSONObject(index);
		  		user.put("username",username);
		  		user.put("password",password1);
		  		setSaveIndex(wizjsonnode,save_val);
		  		wizjsonnode.getJSONObject("USERCONFIG").getJSONObject("TABLE").put("USERS",users);
		  		status = "User Modified Successfully";
		  		setSaveIndex(wizjsonnode,save_val);
		  		 BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
				}
		  		else
		  		{
		  			status = "The given password is not matched";
		  		}
		  	}
		  	else
		  	{
		  		if(!userexists || wrgpassword)
		  		status = "Error: Invalid Username or Password !!. Please try again..";
		  		
		  	}
		  	
		  	procpage +="?status="+status;
		  	
		}
	   else if(pagename.equals("deleteuser"))
		{
			procpage = "user_config.jsp";
			save_val = DELUSER;
			JSONArray users = wizjsonnode.getJSONObject("USERCONFIG").getJSONObject("TABLE").getJSONArray("USERS");
		  	String username = request.getParameter("username");
		  	String password1 = request.getParameter("password1");
		  	String status=null;
		  	boolean userexists = false;
		  	boolean wrgpassword = false;
		  	int index = 0;
		  	
		  	for(int i=0;i<users.size();i++)
		  	{
		  		JSONObject user = users.getJSONObject(i);
		  		if(user.getString("username").equals(username))
		  		{
		  			userexists = true;
		  			if(user.getString("password").equals(password1))
		  			{
		  				index = i;
		  			break;
		  			}
		  			else
		  			{
		  				wrgpassword = true;
		  			}
		  		}
		  		
		  	}
		  	if(userexists)
		  	{
		  		if(!wrgpassword)
		  		{	
		  		JSONObject user =  users.getJSONObject(index);
		  		user.put("username","");
		  		user.put("password","");
		  		users.remove(index);
		  		users.add(index, user);
		  		wizjsonnode.getJSONObject("USERCONFIG").getJSONObject("TABLE").put("USERS",users);
		  		status = "User Deleted Successfully";
		  		setSaveIndex(wizjsonnode,save_val);
		  		 BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
				}
		  		else
		  		{
		  			status = "Wrong Password for the User ";
		  		}
		  	}
		  	else
		  	{
		  		status = "User Does not exists";
		  	}
		  	
		  	procpage +="?status="+status;
		  	
		}
	   else if(pagename.equals("dhcpserver"))
	   {

		   procpage = "dhcpserver.jsp";
		   save_val = DHCP_CONFIG;
		   JSONObject dhcpobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("DHCP");
		   String dhcpactv = request.getParameter("activation")==null || request.getParameter("activation").equals("No Change")?dhcpobj.getString("Activation"):request.getParameter("activation");	
		   String poolname = request.getParameter("poolname")==null?"":request.getParameter("poolname");
		   String dsnwip = request.getParameter("dsnwip")==null?"":request.getParameter("dsnwip");
		   String dsmask = request.getParameter("dsmask")==null?"":request.getParameter("dsmask");
		   String dsgw = request.getParameter("dsgw")==null?"":request.getParameter("dsgw");
		   String excludestartip = request.getParameter("excludestartip")==null?"":request.getParameter("excludestartip");
		   String excludeendip = request.getParameter("excludeendip")==null?"":request.getParameter("excludeendip");
		   String dsdomain = request.getParameter("dsdomain")==null?dhcpobj.getString("DomainName"):request.getParameter("dsdomain");
		   String dsprimdns = request.getParameter("dsprimdns")==null?"":request.getParameter("dsprimdns");
		   String dssecdns = request.getParameter("dssecdns")==null?"":request.getParameter("dssecdns");
		   
		   if(dhcpactv.equals("No Change") || dhcpactv.equals(""))
		   {
			   errmsg = "Activation should be enabled or disabled";
			   %>
			   	<script>
			    goToPage("dhcpserver.jsp","error",'<%=errmsg%>','<%=slnumber%>');
				 </script>
			   <%
		   }
		   
		   dhcpobj.put("Activation",dhcpactv.length()>0?dhcpactv:dhcpobj.getString("Activation"));
		   dhcpobj.put("PoolName",poolname.length()>0?poolname:dhcpobj.getString("PoolName"));
		   dhcpobj.put("NetworkIP",dsnwip.length()>0?dsnwip:dhcpobj.getString("NetworkIP"));
		   dhcpobj.put("Netmask",dsmask.length()>0?dsmask:dhcpobj.getString("Netmask"));
		   dhcpobj.put("GatewayIP",dsgw.length()>0?dsgw:dhcpobj.getString("GatewayIP"));
		   dhcpobj.put("StartIP",excludestartip.trim().length()==0?"0.0.0.0":excludestartip);
		   dhcpobj.put("EndIP",excludeendip.trim().length()==0?"0.0.0.0":excludeendip);
		   dhcpobj.put("DomainName",dsdomain.length()>0?dsdomain:dhcpobj.getString("DomainName"));
		   dhcpobj.put("PrimaryDNS",dsprimdns.length()>0?dsprimdns:dhcpobj.getString("PrimaryDNS"));
		   dhcpobj.put("SecondaryDNS",dssecdns.length()>0?dssecdns:dhcpobj.getString("SecondaryDNS"));
		   
		   wizjsonnode.getJSONObject("NETWORKCONFIG").put("DHCP",dhcpobj);
		   setSaveIndex(wizjsonnode,save_val);
				 BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			   jsonWriter.write(wizjsonnode.toString(2));
			 
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
		    
	   }
	   else if(pagename.equals("time_date"))
	   {
		if(fmversion.trim().endsWith("1.8.1"))
        {
		procpage = "time_date1.8.1.jsp?version="+fmversion;
		save_val = DATE_TIME;
		boolean error = false;
		String timeSync_type=request.getParameter("type")==null?"None":request.getParameter("type");
		String date_arr[]=request.getParameter("datePicker").toString().split("/");
		String time_arr[]=request.getParameter("timePicker").toString().split(":");
		JSONObject timedateobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("TIMEDATE");
		JSONArray oldntparr = timedateobj.getJSONArray("NTP")==null ? new JSONArray(): timedateobj.getJSONArray("NTP");
		JSONArray newntparr = new JSONArray();
			int datestr = 00;
			int month = 00;
			int year = 00;
			int hours = 00;
			int min = 00;
			int sec = 00;
		if(timeSync_type.equals("None"))
		{
			timedateobj.put("Time Sync Type",timeSync_type);
			timedateobj.put("Date", 00);
			timedateobj.put("Month", 00);
			timedateobj.put("Year", 00);
			timedateobj.put("Hours", 00);
			timedateobj.put("Min", 00);
			timedateobj.put("Sec", 00);
			
			for(int i=0;i<oldntparr.size();i++)
			{
				JSONObject ntp = oldntparr.getJSONObject(i);
				String servertype = "No Change";
				String ipaddress = "";
				String domainame = "";
			   
				ntp.put("NTP Server Type",servertype);
				ntp.put("IP Address",ipaddress);
				ntp.put("Domain Name",domainame);
			}
			timedateobj.put("NTP Sync Intervel (sec)",0);
		}
		
		if(timeSync_type.equals("Manual"))
		{
			
			if(date_arr.length == 3)
			{
				datestr = Integer.parseInt(date_arr[0]);
				month = Integer.parseInt(date_arr[1]);
				year = Integer.parseInt(date_arr[2]);
			}
			if(time_arr.length == 3)
			{
				hours =Integer.parseInt(time_arr[0]);
				min = Integer.parseInt(time_arr[1]);
				sec = Integer.parseInt(time_arr[2]);
			}
			for(int i=0;i<oldntparr.size();i++)
			{
				JSONObject ntp = oldntparr.getJSONObject(i);
				String servertype = "No Change";
				String ipaddress = "";
				String domainame = "";
			   
				ntp.put("NTP Server Type",servertype);
				ntp.put("IP Address",ipaddress);
				ntp.put("Domain Name",domainame);
			}
			timedateobj.put("NTP Sync Intervel (sec)",0);
			
			timedateobj.put("Time Sync Type",timeSync_type);
			timedateobj.put("Date", datestr);
			timedateobj.put("Month", month);
			timedateobj.put("Year", year);
			timedateobj.put("Hours", hours);
			timedateobj.put("Min", min);
			timedateobj.put("Sec", sec);
		} 
		if(timeSync_type.equals("NTP"))
		{ 
			String ntpsyncintvl=request.getParameter("ntpsync")==null?timedateobj.getInt("NTP Sync Intervel (sec)")+"":request.getParameter("ntpsync");
			if(ntpsyncintvl.length()==0 && (timedateobj.getInt("NTP Sync Intervel (sec)")<16 || timedateobj.getInt("NTP Sync Intervel (sec)")>65535))
			{
	
					errmsg = "Please Configure NTP Sync Intervel between 16-65535 secs...";
					%>
						<script>
						goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
						</script>
					<%
		   }
			String servertype="";
			String ipaddress="";
			String domainame="";			
			timedateobj.put("Time Sync Type",timeSync_type);				
			for(int i=0;i<oldntparr.size();i++)
			{
			   JSONObject ntp = new JSONObject();
			   servertype = request.getParameter("Type"+i)==null?"No Change":request.getParameter("Type"+i);
		       ipaddress = request.getParameter("serverIP"+i)==null?"":request.getParameter("serverIP"+i);
		       domainame = request.getParameter("servername"+i)==null?"":request.getParameter("servername"+i);
			   
		       ntp.put("sl",(i+1));
			   ntp.put("NTP Server Type",servertype);
			   ntp.put("IP Address",ipaddress);
			   ntp.put("Domain Name",domainame);
			   newntparr.add(ntp);
			}
			
			for(int i=0;i<newntparr.size();i++)
			{
				JSONObject newntp = newntparr.getJSONObject(i);
				int j;
				for(j=0;j<oldntparr.size();j++)
				{
					JSONObject oldntp = oldntparr.getJSONObject(j);
					if( i!=j && (!newntp.getString("NTP Server Type").equals("No Change")) && (oldntp.getString("IP Address").equals(newntp.getString("IP Address")) && oldntp.getString("Domain Name").equals(newntp.getString("Domain Name"))))
					{
						if(!errmsg.contains("Entry already exists...."))
						errmsg = "Entry already exists....";
						break;
					}  				   
				}
				if(j == oldntparr.size())
				{
					if(oldntparr.size() > i)
					oldntparr.remove(i);
					oldntparr.add(i,newntparr.get(i));
				}
			}			
			
			timedateobj.put("Date", 00);
			timedateobj.put("Month", 00);
			timedateobj.put("Year", 00);
			timedateobj.put("Hours", 00);
			timedateobj.put("Min", 00);
			timedateobj.put("Sec", 00);
			timedateobj.put("NTP Sync Intervel (sec)",ntpsyncintvl.length()>0?Integer.parseInt(ntpsyncintvl):timedateobj.getInt("NTP Sync Intervel (sec)"));
		}	   
		   timedateobj.put("NTP",oldntparr);
		   wizjsonnode.getJSONObject("NETWORKCONFIG").put("TIMEDATE", timedateobj);
		   setSaveIndex(wizjsonnode,save_val);
		   BufferedWriter jsonWriter = null;
		   try
		   {
				jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
				jsonWriter.write(wizjsonnode.toString(2));
		   }
		   catch(Exception e)
		   {
			   e.printStackTrace();
			   internal_err = true;
		   }
		   finally
		   {
			   if(jsonWriter != null)
			   jsonWriter.close();
		   }

		}
		else
		{
		procpage = "time_date.jsp?version="+fmversion;
		save_val = DATE_TIME;
		String date_arr[]=request.getParameter("datePicker").toString().split("/");
		String time_arr[]=request.getParameter("timePicker").toString().split(":");
		JSONObject timedateobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("TIMEDATE");
		int datestr = Integer.parseInt(date_arr[0]);
		int month = Integer.parseInt(date_arr[1]);
		int year = Integer.parseInt(date_arr[2]);
		int hours =Integer.parseInt(time_arr[0]);
		int min = Integer.parseInt(time_arr[1]);
		int sec = Integer.parseInt(time_arr[2]);
		
		   timedateobj.put("Date", datestr);
		   timedateobj.put("Month", month);
		   timedateobj.put("Year", year);
		   timedateobj.put("Hours", hours);
		   timedateobj.put("Min", min);
		   timedateobj.put("Sec", sec);
		   
		   wizjsonnode.getJSONObject("NETWORKCONFIG").put("TIMEDATE", timedateobj);
		   setSaveIndex(wizjsonnode,save_val);
		   BufferedWriter jsonWriter = null;
		   try
		   {
			   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
				jsonWriter.write(wizjsonnode.toString(2));
		 
		   }
		   catch(Exception e)
		   {
			   e.printStackTrace();
			   internal_err = true;
		   }
		   finally
		   {
			   if(jsonWriter != null)
			   jsonWriter.close();
		   }
		   if(errmsg.length() > 0)
				{%>
					<script>
						 goToPage("time_date.jsp","error",'<%=errmsg%>','<%=slnumber%>');
					</script>
				<% 
				}
			
		}
	   }  
   }
   
   if(internal_err)
   {%>
   <script>
   goToPage("error.jsp","error","Internal Error...","");
   </script>
   <%}else if(errmsg.length() > 0){%>
   <script>
   goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');	
   </script>
   <%}else {%>
   <script>
   goToPage('<%=procpage%>',"","",'<%=slnumber%>');
   </script>
   <%}%>
   
   <%!
   public void setSaveIndex(JSONObject wizngobj,int save_val)
   {
	   int http_index = wizngobj.containsKey("HTTP_INDEX")?wizngobj.getInt("HTTP_INDEX"):0;
	   if(save_val != 0)
	   http_index = http_index | (1<<(save_val-1));
	   wizngobj.put("HTTP_INDEX", http_index);
   }
   %>
   <%!public String getOVerlapingInterface(String ip,String pagename,JSONObject wizjsonnode,String overlapintf,String subnet)
   {
	    JSONObject prodtypeobj = wizjsonnode.getJSONObject("SYSTEMCONTROL").getJSONObject("PRODUCTTYPE");
   		String product_type = prodtypeobj.containsKey("OldProductType")? prodtypeobj.getString("OldProductType") :prodtypeobj.getString("ProductType");

	   overlapintf = "";
	   JSONObject eth0obj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
 				.getJSONObject("ADDRESSCONFIG").getJSONObject("ETH0");
	   JSONObject wanobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
				.getJSONObject("ADDRESSCONFIG").getJSONObject("WAN");
	   JSONObject loopbackobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
 				.getJSONObject("ADDRESSCONFIG").getJSONObject("LOOPBACK");
	   JSONObject dialerobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
 				.getJSONObject("ADDRESSCONFIG").getJSONObject("DIALER");

	   if(pagename.equals("eth0") && !ip.equals("0.0.0.0") && ip.length() > 0)
	   {
		   
		 if(product_type.equals("3LAN-1WAN"))
		 {
				if (GetNetwork(ip, subnet).equals(GetNetwork(wanobj.getString("ipAddress"),wanobj.getString("subnetAddress")))
						|| isIpInRange(ip,wanobj.getString("ipAddress"),wanobj.getString("subnetAddress"))
						|| isIpInRange(wanobj.getString("ipAddress"),ip,subnet))
					overlapintf = "WAN Primary IP";
				else if(GetNetwork(ip, subnet).equals(GetNetwork(wanobj.getString("secIP"),wanobj.getString("secSubnet")))
						|| isIpInRange(ip,wanobj.getString("secIP"),wanobj.getString("secSubnet"))
						|| isIpInRange(wanobj.getString("secIP"),ip,subnet))
					overlapintf = "WAN Secondary IP";
			   else if(GetNetwork(ip, subnet).equals(GetNetwork(dialerobj.getString("ipAddress"),dialerobj.getString("NetMask")))
						|| isIpInRange(ip,dialerobj.getString("ipAddress"),dialerobj.getString("NetMask"))
						|| isIpInRange(dialerobj.getString("ipAddress"),ip,subnet))
					overlapintf = "Dialer IP";
		 }
		 if(GetNetwork(ip, subnet).equals(GetNetwork(loopbackobj.getString("ipAddress"),loopbackobj.getString("subnetAddress")))
					|| isIpInRange(ip,loopbackobj.getString("ipAddress"),loopbackobj.getString("subnetAddress"))
					|| isIpInRange(loopbackobj.getString("ipAddress"),ip,subnet))
				 overlapintf = "Loopback IP";
	   }
	   else if(pagename.equals("wan") && !ip.equals("0.0.0.0") && ip.length() > 0)
	   {
		   
		   	if(GetNetwork(ip, subnet).equals(GetNetwork(eth0obj.getString("ipAddress"),eth0obj.getString("subnetAddress"))) 
		   			|| isIpInRange(ip,eth0obj.getString("ipAddress"),eth0obj.getString("subnetAddress"))
					|| isIpInRange(eth0obj.getString("ipAddress"),ip,subnet))
					overlapintf = "Eth0 Primary IP";
		   	if(GetNetwork(ip, subnet).equals(GetNetwork(eth0obj.getString("secondIP"),eth0obj.getString("secondSubnet")))
					|| isIpInRange(ip,eth0obj.getString("secondIP"),eth0obj.getString("secondSubnet"))
					|| isIpInRange(eth0obj.getString("secondIP"),ip,subnet))
					overlapintf = "Eth0 Secondary IP";
		   	else if(GetNetwork(ip, subnet).equals(GetNetwork(dialerobj.getString("ipAddress"),dialerobj.getString("NetMask")))
		   			|| isIpInRange(ip,dialerobj.getString("ipAddress"),dialerobj.getString("NetMask"))
					|| isIpInRange(dialerobj.getString("ipAddress"),ip,subnet))
					overlapintf = "Dialer IP";
		   	else if(GetNetwork(ip, subnet).equals(GetNetwork(loopbackobj.getString("ipAddress"),loopbackobj.getString("subnetAddress")))
		   			|| isIpInRange(ip,loopbackobj.getString("ipAddress"),loopbackobj.getString("subnetAddress"))
					|| isIpInRange(loopbackobj.getString("ipAddress"),ip,subnet))
				 overlapintf = "Loopback IP";
	   }
	   else if(pagename.equals("dialer") && !ip.equals("0.0.0.0") && ip.length() > 0)
	   {
		   
			if(GetNetwork(ip, subnet).equals(GetNetwork(eth0obj.getString("ipAddress"),eth0obj.getString("subnetAddress")))
					|| isIpInRange(ip,eth0obj.getString("ipAddress"),eth0obj.getString("subnetAddress"))
					|| isIpInRange(eth0obj.getString("ipAddress"),ip,subnet))
				overlapintf = "Eth0 Primary IP";
	   		if(GetNetwork(ip, subnet).equals(GetNetwork(eth0obj.getString("secondIP"),eth0obj.getString("secondSubnet")))
	   				|| isIpInRange(ip,eth0obj.getString("secondIP"),eth0obj.getString("secondSubnet"))
					|| isIpInRange(eth0obj.getString("secondIP"),ip,subnet))
				overlapintf = "Eth0 Secondary IP";
	   		if (GetNetwork(ip, subnet).equals(GetNetwork(wanobj.getString("ipAddress"),wanobj.getString("subnetAddress")))
	   				|| isIpInRange(ip,wanobj.getString("ipAddress"),wanobj.getString("subnetAddress"))
					|| isIpInRange(wanobj.getString("ipAddress"),ip,subnet))
			overlapintf = "WAN Primary IP";
			else if(GetNetwork(ip, subnet).equals(GetNetwork(wanobj.getString("secIP"),wanobj.getString("secSubnet")))
					|| isIpInRange(ip,wanobj.getString("secIP"),wanobj.getString("secSubnet"))
					|| isIpInRange(wanobj.getString("secIP"),ip,subnet))
				overlapintf = "WAN Secondary IP";
		 	else if(GetNetwork(ip, subnet).equals(GetNetwork(loopbackobj.getString("ipAddress"),loopbackobj.getString("subnetAddress")))
		 			|| isIpInRange(ip,loopbackobj.getString("ipAddress"),loopbackobj.getString("subnetAddress"))
					|| isIpInRange(loopbackobj.getString("ipAddress"),ip,subnet))
				 overlapintf = "Loopback IP";
	   }
	   else if(pagename.equals("loopback") && !ip.equals("0.0.0.0") && ip.length() > 0)
	   {
		   
			if(GetNetwork(ip, subnet).equals(GetNetwork(eth0obj.getString("ipAddress"),eth0obj.getString("subnetAddress")))
					|| isIpInRange(ip,eth0obj.getString("ipAddress"),eth0obj.getString("subnetAddress"))
					|| isIpInRange(eth0obj.getString("ipAddress"),ip,subnet))
				overlapintf = "Eth0 Primary IP";
	   		else if(GetNetwork(ip, subnet).equals(GetNetwork(eth0obj.getString("secondIP"),eth0obj.getString("secondSubnet")))
	   				|| isIpInRange(ip,eth0obj.getString("secondIP"),eth0obj.getString("secondSubnet"))
					|| isIpInRange(eth0obj.getString("secondIP"),ip,subnet))
				overlapintf = "Eth0 Secondary IP";
	   		if(product_type.equals("3LAN-1WAN"))
			 {
					if (GetNetwork(ip, subnet).equals(GetNetwork(wanobj.getString("ipAddress"),wanobj.getString("subnetAddress")))
							|| isIpInRange(ip,wanobj.getString("ipAddress"),wanobj.getString("subnetAddress"))
							|| isIpInRange(wanobj.getString("ipAddress"),ip,subnet))
						overlapintf = "WAN Primary IP";
					else if(GetNetwork(ip, subnet).equals(GetNetwork(wanobj.getString("secIP"),wanobj.getString("secSubnet")))
							|| isIpInRange(ip,wanobj.getString("secIP"),wanobj.getString("secSubnet"))
							|| isIpInRange(wanobj.getString("secIP"),ip,subnet))
						overlapintf = "WAN Secondary IP";
				   else if(GetNetwork(ip, subnet).equals(GetNetwork(dialerobj.getString("ipAddress"),dialerobj.getString("NetMask")))
							|| isIpInRange(ip,dialerobj.getString("ipAddress"),dialerobj.getString("NetMask"))
							|| isIpInRange(dialerobj.getString("ipAddress"),ip,subnet))
						overlapintf = "Dialer IP";
			 }
	   }
	   
	   return overlapintf;
	}%>
	<%!
	  public boolean isIpInRange(String ipaddress,String startip,String endip)
	  {
		  if(startip.trim().length()==0 || endip.trim().length()== 0 || startip.equals("0.0.0.0") || endip.equals("0.0.0.0"))
			  return false;
		  
		   ipaddress = ipaddress.trim();
		   startip = startip.trim();
		   endip = endip.trim();
		   String nip = GetNetwork(startip,endip);
		   String bip = GetBroadcast(startip,endip);
		   
		   String ipadd[] = ipaddress.split("\\.");
		   String sip[] = nip.split("\\.");
		   String eip[] = bip.split("\\.");
		   
		   if(Integer.parseInt(ipadd[0]) >= Integer.parseInt(sip[0])
				   &&Integer.parseInt(ipadd[1]) >= Integer.parseInt(sip[1])
				   &&Integer.parseInt(ipadd[2]) >= Integer.parseInt(sip[2])
				   &&Integer.parseInt(ipadd[3]) >= Integer.parseInt(sip[3])
				   &&Integer.parseInt(ipadd[0]) <= Integer.parseInt(eip[0])
				   &&Integer.parseInt(ipadd[1]) <= Integer.parseInt(eip[1])
				   &&Integer.parseInt(ipadd[2]) <= Integer.parseInt(eip[2])
				   &&Integer.parseInt(ipadd[3]) <= Integer.parseInt(eip[3]))
			   return true;
		   return false;
	  }
	%>
	 <%!
   public String trapSrcConfigured(String trapsrc,JSONObject wizjsonnode)
   {
		   JSONObject eth0obj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
	 				.getJSONObject("ADDRESSCONFIG").getJSONObject("ETH0");
		   JSONObject wanobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
					.getJSONObject("ADDRESSCONFIG").getJSONObject("WAN");
		   JSONObject loopbackobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
	 				.getJSONObject("ADDRESSCONFIG").getJSONObject("LOOPBACK");
		   JSONObject dialerobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
	 				.getJSONObject("ADDRESSCONFIG").getJSONObject("DIALER");
		   String srcip;
		   String activ;
		if(trapsrc.equals("Eth0"))
		{
			srcip = eth0obj.getString("ipAddress");
			if(srcip.length() == 0 || srcip.equals("0.0.0.0"))
				return "ETH0 IP is NOT Configured !!, Please Configure ETH0 IP And try again..";
		}
		else if(trapsrc.equals("Eth1"))
		{
			srcip = wanobj.getString("ipAddress");
			activ = wanobj.getString("Activation"); 
			if(srcip.length() == 0 || srcip.equals("0.0.0.0"))
				return "ETH1 IP is NOT Configured !!, Please Configure ETH1 IP And try again..";
			else if(!activ.equals("Enable"))
			{
				return "ETH1 is in Disable State !!, Please Enable And try again.. ";
			}
		}
		else if(trapsrc.equals("Loopback"))
		{
			srcip = loopbackobj.getString("ipAddress");
			activ = loopbackobj.getString("Activation"); 
			if(srcip.length() == 0 || srcip.equals("0.0.0.0"))
				return "LOOPBACK IP is NOT Configured !!, Please Configure LOOPBACK Interface And try again..";
			else if(!activ.equals("Enable"))
			{
				return "LOOPBACK Interface is in Disable State!!, Please Enable And try again..";
			}
		}
		return "";
   }%>
   <%! public String GetNetwork(String ip,String subnet)
	{
	   ip = ip.trim();
	   subnet = subnet.trim();
	   if(ip.length() == 0)
		   return "0.0.0.0";
		String ipaddr[] = ip.split("\\.");
		String subn[] = subnet.split("\\.");
		String network = "";
		
		int netarr[] = new int[4];
		
		for(int i=0;i<ipaddr.length;i++)
		{
			network  += (Integer.parseInt(ipaddr[i]) & Integer.parseInt(subn[i]))+"";
			if(i<ipaddr.length-1)
				network +=".";
		}
		return network;
	}
   %>
	<%!public String GetBroadcast(String ip,String subnet)
	{
		 ip = ip.trim();
		 subnet = subnet.trim();
		 if(ip.length() == 0)
			   return "0.0.0.0";
		String ipaddr[] = ip.split("\\.");
		String subn[] = subnet.split("\\.");
		String network = "";
		
		int netarr[] = new int[4];
		
		for(int i=0;i<ipaddr.length;i++)
		{
			network  += (Integer.parseInt(ipaddr[i]) | (255-Integer.parseInt(subn[i])))+"";
			if(i<ipaddr.length-1)
				network +=".";
		}
		return network;
	}%>
	<%!public boolean isNumber(String mno)
	{
		for(int i=0;i<mno.length();i++)
		{
			if(!Character.isDigit(mno.charAt(i)))
					return false;
		}
		return true;
	}%>
	
	<%!public boolean isConsistance(String network,String netmask)
	{
		network = network.trim();
		netmask = netmask.trim();
		String ipaddr[] = network.split("\\.");
		String smask[] = netmask.split("\\.");
		for(int i=0;i<4;i++)
		{
			if(smask[i].equals("0"))
			if(ipaddr[i].equals("0"))
			{
				
			}
			else
				return false;
		}
		return true;
		
		
	}%>
   </html>