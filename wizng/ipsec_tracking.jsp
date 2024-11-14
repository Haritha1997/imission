<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject ipsec_trackingobj = null;
   BufferedReader jsonfile = null; 
	String ipsec_act = "No Change";
	String ipsec_srcint = "No Change";
	String ipsec_ping = "No Change";
	String ipsec_reboot = "No Change";  
	String product_type = "";	
   		String slnumber=request.getParameter("slnumber");
   if(slnumber != null && slnumber.trim().length() > 0)
   {
	   Properties m2mprops = M2MProperties.getM2MProperties();
	   String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
	   jsonfile = new BufferedReader(new FileReader(new File(slnumpath+File.separator+"Config.json")));
	   StringBuilder jsonbuf = new StringBuilder("");
	   String jsonString="";
	   try
	   {
   		  while((jsonString = jsonfile.readLine())!= null)
   			  jsonbuf.append( jsonString );
   		wizjsonnode= JSONObject.fromObject(jsonbuf.toString());
   		JSONObject prodtypeobj = wizjsonnode.getJSONObject("SYSTEMCONTROL").getJSONObject("PRODUCTTYPE");
   		product_type = prodtypeobj.containsKey("OldProductType")? prodtypeobj.getString("OldProductType") :prodtypeobj.getString("ProductType");
   		//System.out.print(wizjsonnode);
   		ipsec_trackingobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
   				.getJSONObject("IPSECCONFIG").getJSONObject("IPSECTRACKING");
   		if(ipsec_trackingobj != null)
			ipsec_act = ipsec_trackingobj.getString("IPSECTracking");
			ipsec_srcint = ipsec_trackingobj.getString("SourceIntf");
			ipsec_ping = ipsec_trackingobj.getString("PingSuccess");
			ipsec_reboot = ipsec_trackingobj.getString("RebootTimeOut");
	   }
	   catch(Exception e)
	   {
		   e.printStackTrace();
	   }
	   finally
	   {
		   if(jsonfile != null)
			   jsonfile.close();
	   }
   }
   	
   %>

<html>
<head>
<style type="text/css">
#WiZConf 
{
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 500px;
}

#WiZConf td,
#WiZConf th {
	border: 2px solid #ddd;
	padding: 8px;
}

#WiZConf tr:nth-child(even) {
	background-color: #f2f2f2;
}

#WiZConf tr:hover {
	background-color: #d3f2ef;
}

#WiZConf th {
	padding-top: 12px;
	padding-bottom: 12px;
	text-align: left;
	background-color: #5798B4;
	color: white;
}

.text {
	background: white;
	border: 2px Solid #DDD;
	border-radius: 5px;
	box-shadow: 1 1 5px #DDD inset;
	color: #000;
	height: 20px;
	width: 120px;
}

.button {
	display: block;
	border-radius: 6px;
	background-color: #6caee0;
	color: #ffffff;
	font-weight: bold;
	box-shadow: 1px 2px 4px 0 rgba(0, 0, 0, 0.08);
	padding: 12px 20px;
	border: 0;
	margin: 40px 183px 0;
}

.style1 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	color: #5798B4;
	font-size: 16px;
	font-weight: bold;
}

body {
	background-color: #FAFCFD;
}

</style>
      <script type = "text/javascript"> 
	 function chkFunc() {
	var altmsg = "";
	var ipAddrobj = document.getElementById("trackip");
	var valid = validateIP(ipAddrobj.id, true, "trackip");
	if (!valid) {
		if ((ipAddrobj.value.trim() == "")) {
			ipAddrobj.style.outline = "thin solid red";
			altmsg += "Track IP Should not be Empty\n";
		} else {
			ipAddrobj.style.outline = "thin solid red";
			altmsg += "IP Address is not valid.\n";
		}
	}
	if (altmsg == "") return true;
	else {
		alert(altmsg);
		return false;
	}
}

function validateIP(id, checkempty, name) {
	var ipele = document.getElementById(id);
	if (ipele.readOnly == true) {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
	var ipformat = /^(2[0-2][0-3]|1[0-9][0-9]|[1-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
	var ipaddr = ipele.value;
	if (ipaddr == "") {
		if (checkempty) {
			ipele.title = name + " should not be empty";
			return false;
		} else {
			ipele.style.outline = "initial";
			ipele.title = "";
			return true;
		}
	} else if (!ipaddr.match(ipformat) || ipaddr == "255.255.255.255") {
		ipele.title = "Invalid " + name;
		return false;
	} else {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
}

function IPv4AddressKeyOnly(e) {
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	if ((keyCode == 46 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode>= 48 && keyCode <= 57)) {
		return true;
	}
	return false;
} 
</script>
   </head>
   <body>
      <form action="savepage.jsp?page=ipsec_tracking&slnumber=<%=slnumber%>" method="post" onsubmit="return chkFunc()" ;="">
         <blockquote>
            <br>
            <p class="style1" align="center">IPSec Tracking Configuration</p>
         </blockquote>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="200">Parameters</th>
                  <th width="200">Current Config</th>
                  <th width="200">Configuration</th>
               </tr>
               <tr> </tr>
               <tr>
                  <td>Activation</td>
                  <td><%=ipsec_trackingobj == null?"":ipsec_trackingobj.get("IPSECTracking")==null?"":ipsec_trackingobj.getString("IPSECTracking")%></td>
                  <td>
                     <select name="ipsecserv" id="ipsecserv">
                        <option value="No Change" selected="" <%if(ipsec_act.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="Enable" <%if(ipsec_act.equals("Enable")){%>selected<%}%>>Enable</option>
                        <option value="Disable" <%if(ipsec_act.equals("Disable")){%>selected<%}%>>Disable</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Track IP</td>
                  <td><%=ipsec_trackingobj == null?"":ipsec_trackingobj.get("TrackIP")==null?"":ipsec_trackingobj.getString("TrackIP")%></td>
                  <td><input name="trackip" type="text" class="text" id="trackip" size="12" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td>Source Interface</td>
                  <td><%=ipsec_trackingobj == null?"":ipsec_trackingobj.get("SourceIntf")==null?"":ipsec_trackingobj.getString("SourceIntf")%></td>
                  <td>
                     <select name="srcintf" id="srcintf">
                        <option value="No Change" <%if(ipsec_srcint.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="Eth0" <%if(ipsec_srcint.equals("Eth0")){%>selected<%}%>>Eth0</option>
                        <option value="Loopback1" <%if(ipsec_srcint.equals("Loopback1")){%>selected<%}%>>Loopback1</option>
                         <%if(product_type.equals("3LAN-1WAN")){%>
                         <option value="Eth1" <%if(ipsec_srcint.equals("Eth1")){%>selected<%}%>>Eth1</option>
                         <%} %>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Ping Success %</td>
                  <td><%=ipsec_trackingobj == null?"":ipsec_trackingobj.get("PingSuccess")==null?"":ipsec_trackingobj.getString("PingSuccess")%></td>
                  <td>
                     <select id="pingsuccess" name="pingsuccess">
                        <option value="No Change" <%if(ipsec_ping.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="25" <%if(ipsec_ping.equals("25")){%>selected<%}%>>25</option>
                        <option value="50" <%if(ipsec_ping.equals("50")){%>selected<%}%>>50</option>
                        <option value="75" <%if(ipsec_ping.equals("75")){%>selected<%}%>>75</option>
                        <option value="90" <%if(ipsec_ping.equals("90")){%>selected<%}%>>90</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Reboot Timeout (min)</td>
                  <td><%=ipsec_trackingobj == null?"":ipsec_trackingobj.get("RebootTimeOut")==null?"":ipsec_trackingobj.getString("RebootTimeOut")%></td>
                  <td>
                     <select id="rebbotto" name="rebbotto">
                        <option value="No Change" <%if(ipsec_reboot.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="5" <%if(ipsec_reboot.equals("5")){%>selected<%}%>>5</option>
                        <option value="10" <%if(ipsec_reboot.equals("10")){%>selected<%}%>>10</option>
                        <option value="20" <%if(ipsec_reboot.equals("20")){%>selected<%}%>>20</option>
                        <option value="30" <%if(ipsec_reboot.equals("30")){%>selected<%}%>>30</option>
                        <option value="40" <%if(ipsec_reboot.equals("40")){%>selected<%}%>>40</option>
                        <option value="50" <%if(ipsec_reboot.equals("50")){%>selected<%}%>>50</option>
                        <option value="60" <%if(ipsec_reboot.equals("60")){%>selected<%}%>>60</option>
                     </select>
                  </td>
               </tr>
            </tbody>
         </table>
         <div align="center">
            <blockquote>
               <p>
                  <input value="Submit" class="button" type="submit"><script src="js/timeout.js" type="text/javascript"></script>
               </p>
            </blockquote>
         </div>
      </form>
   </body>
</html>