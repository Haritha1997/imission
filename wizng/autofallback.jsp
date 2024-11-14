<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject autflbck = null;
   BufferedReader jsonfile = null; 
	String Activation = "";
	String PrimaryIntf = "";
	String SecondaryIntf = "";
	String SuccessRate = "";    
	String PingCount="";
	
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
   		
   		//System.out.print(wizjsonnode);
   		autflbck =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
   				.getJSONObject("IPSECCONFIG").getJSONObject("AUTO_FALLBACK");
				System.out.println(autflbck);
   		if(autflbck != null)
   		Activation = autflbck.getString("Activation");
   		PrimaryIntf = autflbck.getString("PrimaryIntf");
   		SecondaryIntf = autflbck.getString("SecondaryIntf");
   		SuccessRate = autflbck.getString("SuccessRate");
   		PingCount = autflbck.getString("PingCount");
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
   	 JSONObject prodtypeobj = wizjsonnode.getJSONObject("SYSTEMCONTROL").getJSONObject("PRODUCTTYPE");
   	 String	product_type = prodtypeobj.containsKey("OldProductType")? prodtypeobj.getString("OldProductType") :prodtypeobj.getString("ProductType");
     JSONObject ipsectype = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").getJSONObject("IPSECCONFIG")
	              .getJSONObject("IPSEC");
	 JSONArray tunnels_arr = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").getJSONObject("IPSECCONFIG")
	              .getJSONObject("IPSEC").getJSONObject("TABLE").getJSONArray("arr");
   if(product_type.equalsIgnoreCase("4LAN"))
	   response.sendRedirect("notsupport.jsp?name=Auto Fallback");
   else if(ipsectype.getString("IpsecSelectNo").equals("IPSec MultiTunnel"))
	   response.sendRedirect("errormsg.jsp?error=Auto-fallback does not support for Multiple Tunnels");
   else if(tunnels_arr.size() == 0)
	   response.sendRedirect("errormsg.jsp?error=IPSec Tunnel Must be Configured before Auto-fallback");
  %>
<html>
   <head>
      <style type="text/css">
#WiZConf td select {
	width: 160px;
}

#WiZConf,
#WiZConf1 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 340px;
}

#WiZConf th,
#WiZConf1 th {
	border: 2px solid #ddd;
	padding: 2px;
	text-align: center;
}

#WiZConf td {
	border: 2px solid #ddd;
	padding: 2px;
	text-align: left;
}

#WiZConf tr: nth-child(even) {
	background-color: #f2f2f2;
}

#WiZConf tr: hover {
	background-color: #d3f2ef;
}

#WiZConf th,
#WiZConf1 th {
	padding-top: 12px;
	padding-bottom: 12px;
	text-align: center;
	background-color: #5798B4;
	color: #FFFFFF;
}

.text {
	background: #FFFFFF;
	border: 2px Solid #DDD;
	border-radius: 5px;
	box-shadow: 1 1 5px #DDD inset;
	color: #000;
	height: 28px;
	width: 160px;
}

.button {
	display: block;
	border-radius: 6px;
	background-color: #6caee0;
	color: #ffffff;
	font-weight: 700;
	box-shadow: 1px 2px 4px 0 rgba(0, 0, 0, 0.08);
	padding: 12px 20px;
	border: 0;
	margin: 40px 20px 0;
	display: inline;
}

.style1 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	color: #5798B4;
	font-size: 16px;
	font-weight: 700;
}

body {
	background-color: #FAFCFD;
}
</style>
<script type = "text/javascript" src = "js/jquery-1.4.2.min.js"> </script> 
<script type="text/javascript"> 
function validateRoute() {
	var alertmsg = "";
	var RemoteIPobj = document.getElementById('remoteIP');
	var GatewayIPobj = document.getElementById('gatewayIP');
	var PriInterfaceobj = document.getElementById('pri_inf');
	var SecInterfaceobj = document.getElementById('sec_inf');
	var SecgwIPobj = document.getElementById('secgatewayIP');
	var valid = validateIP(RemoteIPobj.id, true, "remoteIP");
	if (!valid) {
		if (RemoteIPobj.value.trim() == "") {
			alertmsg += "Remote IP Address field should not be empty\n";
		} else {
			alertmsg += "Remote IP Address is not valid\n";
		}
	}
	if (PriInterfaceobj.value.trim() == "Eth 1") {
		valid = validateIP(GatewayIPobj.id, true, "gatewayIP");
		if (!valid) {
			if (GatewayIPobj.value.trim() == "") {
				alertmsg += "Primary Gateway IP Address field should not be empty\n";
			} else {
				alertmsg += "Primary Gateway IP Address is not valid\n";
			}
		}
	}
	if (SecInterfaceobj.value.trim() == "Eth 1") {
		valid = validateIP(SecgwIPobj.id, true, "secgatewayIP");
		if (!valid) {
			if (SecgwIPobj.value.trim() == "") {
				alertmsg += "Secondary Gateway IP Address field should not be empty\n";
			} else {
				alertmsg += "Secondary Gateway IP Address is not valid\n";
			}
		}
	}
	if (PriInterfaceobj.value.trim() == SecInterfaceobj.value.trim()) {
		alertmsg += "Primary and Secondary Interfcae should not be same\n";
	} else if ((PriInterfaceobj.value.trim() == "Dialer" && SecInterfaceobj.value.trim() == "Eth 1") || (PriInterfaceobj.value.trim() == "Eth 1" && SecInterfaceobj.value.trim() == "Dialer")) {
		alertmsg += "One Interface must be Cellular\n";
	}
	if (alertmsg.trim().length == 0) {
		return true;
	} else {
		alert(alertmsg);
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
	var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
	var ipaddr = ipele.value.trim();
	if (ipaddr == "") {
		if (checkempty) {
			ipele.style.outline = "thin solid red";
			ipele.title = name + " should not be empty";
			return false;
		} else {
			ipele.style.outline = "initial";
			ipele.title = "";
			return true;
		}
	} else if (!ipaddr.match(ipformat) || ipaddr == "255.255.255.255" || ipaddr == "0.0.0.0") {
		ipele.style.outline = "thin solid red";
		ipele.title = "Invalid " + name;
		return false;
	} else {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
}

function validateGateway(id1, id2, checkempty, name) {
	var alertmsg = "validategw";
	var interfaceOption = document.getElementById(id2);
	var obj = document.getElementById(id1);
	if (interfaceOption.value != "Eth 1") {
		obj.disabled = true;
		obj.style.backgroundColor = "#808080";
		obj.style.outline = "";
		obj.value = "";
		return true;
	} else {
		obj.disabled = false;
		obj.style.backgroundColor = "#ffffff";
	}
	return false;
}
</script> 
      <title> WiZ</title>
   </head>
   <body onload="validateGateway('gatewayIP', 'pri_inf', true,'gatewayIP'); validateGateway('secgatewayIP', 'sec_inf', true,'secgatewayIP')">
      <form action="savepage.jsp?page=autofallback&slnumber=<%=slnumber%>" method="post" onsubmit="return validateRoute()">
         <p class="style1" align="center"> Auto Fallback</p>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th style="min-width:50%"> Parameters</th>
                  <th style="max-width:50%"> values</th>
               </tr>
               <tr>
                  <td style="min-width:50%">Activation </td>
                  <td style="max-width: 50%">
                     <select id="enable" name="enable">
                        <option value="Enable" <%if(Activation.equals("Enable")) {%>selected<%}%>>Enable</option>
                        <option value="Disable" <%if(Activation.equals("Disable")) {%>selected<%}%>>Disable</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Primary Interface </td>
                  <td>
                     <select id="pri_inf" name="pri_inf" onchange="validateGateway('gatewayIP', 'pri_inf', true,'gatewayIP')">
                        <option value="Cellular" <%if(PrimaryIntf.equals("Cellular")) {%>selected<%}%>>Cellular</option>
                        <option value="Dialer" <%if(PrimaryIntf.equals("Dialer")) {%>selected<%}%>>Dialer</option>
                        <option value="Eth 1" <%if(PrimaryIntf.equals("Eth 1")) {%>selected<%}%>>Eth 1</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Secondary Interface </td>
                  <td>
                     <select id="sec_inf" name="sec_inf" onchange="validateGateway('secgatewayIP', 'sec_inf', true,'secgatewayIP')">
                        <option value="Cellular" <%if(SecondaryIntf.equals("Cellular")) {%>selected<%}%>>Cellular</option>
                        <option value="Dialer" <%if(SecondaryIntf.equals("Dialer")) {%>selected<%}%>>Dialer</option>
                        <option value="Eth 1" <%if(SecondaryIntf.equals("Eth 1")) {%>selected<%}%>>Eth 1</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Remote IP Address</td>
                  <td><input id="remoteIP" name="remoteIP" class="text" value="<%=autflbck == null?"":autflbck.get("RemoteIP")==null?"":autflbck.getString("RemoteIP")%>" type="text"></td>
               </tr>
               <tr>
                  <td>Primary Gateway </td>
                  <td><input id="gatewayIP" name="gatewayIP" disabled="" class="text" value="<%=autflbck == null?"":autflbck.get("GatewayIP")==null?"":autflbck.getString("GatewayIP")%>" type="text" style="background-color: rgb(128, 128, 128);"></td>
               </tr>
               <tr>
                  <td>Secondary Gateway </td>
                  <td><input id="secgatewayIP" name="secgatewayIP" disabled="" class="text" value="<%=autflbck == null?"":autflbck.get("SecondaryGWIP")==null?"":autflbck.getString("SecondaryGWIP")%>" type="text" style="background-color: rgb(128, 128, 128);"></td>
               </tr>
               <tr>
                  <td>Success Rate ( % ) </td>
                  <td>
                     <select id="suc_rate" name="suc_rate">
                        <option value="40" <%if(SuccessRate.equals("40")) {%>selected<%}%>>40</option>
                        <option value="60" <%if(SuccessRate.equals("60")) {%>selected<%}%>>60</option>
                        <option value="80" <%if(SuccessRate.equals("80")) {%>selected<%}%>>80</option>
                        <option value="90" <%if(SuccessRate.equals("90")) {%>selected<%}%>>90</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Ping Count </td>
                  <td>
                     <select id="ping_count" name="ping_count">
                        <option value="5" <%if(PingCount.equals("5")) {%>selected<%}%>>5</option>
                        <option value="10" <%if(PingCount.equals("10")) {%>selected<%}%>>10</option>
                        <option value="15" <%if(PingCount.equals("15")) {%>selected<%}%>>15</option>
                        <option value="20" <%if(PingCount.equals("20")) {%>selected<%}%>>20</option>
                     </select>
                  </td>
               </tr>
            </tbody>
         </table>
         <div align="center"> <input type="submit" value="Submit" class="button"> </div>
      </form>
      <script src="js/timeout.js" type="text/javascript"> </script>  
   </body>
</html>