<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject dialerobj = null;
   BufferedReader jsonfile = null;   
   String dialerstatus = "No Change";
   String dialerauth = "No Change";
   String dialerdns = "Enable";
   		String slnumber=request.getParameter("slnumber");
		String errorstr = request.getParameter("error");
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
   		dialerobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
   				.getJSONObject("ADDRESSCONFIG").getJSONObject("DIALER");
   		if(dialerobj != null)
			dialerstatus = dialerobj.getString("status");
			dialerauth = dialerobj.getString("Authentication");
			dialerdns = dialerobj.getString("AutoDNS");
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
   		String product_type = prodtypeobj.containsKey("OldProductType")? prodtypeobj.getString("OldProductType") :prodtypeobj.getString("ProductType");
   if(product_type.equalsIgnoreCase("4LAN"))
	   response.sendRedirect("notsupport.jsp?name=Dialer");
   	
   %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPag.Editor.Documet">
<style type="text/css">
	  #WiZConf {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 550px
}

#WiZConf td,
#WiZConf th {
	border: 2px solid #ddd;
	padding: 8px
}

#WiZConf tr:nth-child(even) {
	background-color: #f2f2f2
}

#WiZConf tr:hover {
	background-color: #d3f2ef
}

#WiZConf th {
	padding-top: 12px;
	padding-bottom: 12px;
	text-align: left;
	background-color: #5798B4;
	color: white
}

.text {
	background: white;
	border: 2px Solid #DDD;
	border-radius: 5px;
	box-shadow: 1 1 5px #DDD inset;
	color: #000;
	height: 24px
}

.button {
	display: block;
	border-radius: 6px;
	background-color: #6caee0;
	color: #fff;
	font-weight: bold;
	box-shadow: 1px 2px 4px 0 rgba(0, 0, 0, 0.08);
	padding: 12px 20px;
	border: 0;
	margin: 40px 183px 0
}

.style1 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	color: #5798B4;
	font-size: 16px;
	font-weight: bold
}

body {
	background-color: #FAFCFD
}
</style>
      <script type="text/javascript">function chkFunc() {
	var alertmsg = "";
	var count = 0;
	var ipAddrobj = document.getElementById("DIPV4");
	var netmaskobj = document.getElementById("Dnetmask");
	var poolNoobj = document.getElementById("poolNo");
	var servNameobj = document.getElementById("servName");
	var authobj = document.getElementById("auth");
	var userobj = document.getElementById("username");
	var pswdobj = document.getElementById("password");
	var oautoobj = document.getElementById("oauto");
	var primarydnsobj = document.getElementById("pridns");
	var secndarydnsobj = document.getElementById("Secondary DNS");
	if (oautoobj.checked) {
		count = 1;
	}
	var valid = validateIP(ipAddrobj.id, true, "ipaddr");
	if (!valid) {
		if ((ipAddrobj.value.trim() == "") && (netmaskobj.value.trim() != "")) {
			ipAddrobj.style.outline = "thin solid red";
			alertmsg += "IP Address is Necessary\n";
		} else if ((ipAddrobj.value.trim() == "") && (netmaskobj.value.trim() == "")) {} else {
			ipAddrobj.style.outline = "thin solid red";
			alertmsg += "IP Address is not valid.\n";
		}
	}
	valid = validateSubNetmask(netmaskobj.id, true, "netmask");
	if (!valid) {
		if ((netmaskobj.value.trim() == "") && (ipAddrobj.value.trim() != "")) {
			netmaskobj.style.outline = "thin solid red";
			alertmsg += "SubnetMAsk is Necessary\n";
		} else if ((netmaskobj.value.trim() == "") && (ipAddrobj.value.trim() == "")) {} else {
			netmaskobj.style.outline = "thin solid red";
			alertmsg += "Netmask is not valid.\n";
		}
	}
	valid = validatePoolNo(poolNoobj.id, true, "poolNo");
	if (!valid) {
		if (poolNoobj.value.trim() == "") {
			alertmsg += "Pool Number should not be empty.\n";
		} else {
			alertmsg += "Pool Number(1-255) is not valid.\n";
		}
	}
	if (servNameobj.value.trim() == "") {}
	valid = validateUsername(authobj.id, true, "auth");
	if (!valid) {
		if (userobj.value.trim().length == 0) {
			alertmsg += "Username should not be empty.\n";
		}
		if (pswdobj.value.trim().length == 0) {
			alertmsg += "Password should not be empty.\n";
		}
	}
	if (count != 1) {
		valid = validateIP(primarydnsobj.id, true, "pridns");
		if (!valid) {
			if (primarydnsobj.value.trim() == "") {} else {
				primarydnsobj.style.outline = "thin solid red";
				alertmsg += "Primary DNS is not valid.\n";
			}
		}
		valid = validateIP(secndarydnsobj.id, true, "Secondary DNS");
		if (!valid) {
			if (secndarydnsobj.value.trim() == "") {} else {
				secndarydnsobj.style.outline = "thin solid red";
				alertmsg += "Secondary DNS is not valid.\n";
			}
		}
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
	var ipformat = /^(2[0-2][0-3]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
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

function validateSubNetmask(id, checkempty, name) {
	var ipele = document.getElementById(id);
	if (ipele.readOnly == true) {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
	var ipformat = /^(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$/;
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
	} else if ((!ipaddr.match(ipformat)) || ipaddr == "255.255.255.255") {
		ipele.title = "Invalid " + name;
		return false;
	} else {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
}

function editFields() {
	var oautoobj = document.getElementById("oauto");
	var id_arr = ["pridns", "Secondary DNS"];
	if (oautoobj.checked) {
		for (var i = 0; i < id_arr.length; i++) {
			var obj = document.getElementById(id_arr[i]);
			obj.readOnly = true;
			obj.style.outline = "initial";
		}
	} else {
		for (var i = 0; i < id_arr.length; i++) {
			var obj = document.getElementById(id_arr[i]);
			obj.readOnly = false;
		}
	}
}

function validatePoolNo(id, checkempty, name) {
	var poolele = document.getElementById(id);
	if (poolele.readOnly == true) {
		poolele.style.outline = "initial";
		poolele.title = "";
		return true;
	}
	var poolNo = poolele.value;
	if (poolNo == "") {
		if (checkempty) {
			poolele.style.outline = "thin solid red";
			poolele.title = name + " should not be empty";
			return false;
		} else {
			poolele.style.outline = "initial";
			poolele.title = "";
			return true;
		}
	} else if ((!isNumber(poolele.value.trim())) || poolNo < 1 || poolNo > 255) {
		poolele.style.outline = "thin solid red";
		poolele.title = "Invalid " + name;
		return false;
	} else {
		poolele.style.outline = "initial";
		poolele.title = "";
		return true;
	}
}

function validateUsername(id, checkempty, name) {
	var flag = 0;
	var userobj = document.getElementById("username");
	var pswdobj = document.getElementById("password");
	var authele = document.getElementById(id);
	var authNo = authele.value;
	if (authNo > 1) {
		if (userobj.value.trim().length == 0) {
			userobj.style.outline = "thin solid red";
			userobj.title = name + " should not be empty";
			flag = 1;
		} else {
			userobj.style.outline = "initial";
			userobj.title = "";
		}
		if (pswdobj.value.trim().length == 0) {
			pswdobj.style.outline = "thin solid red";
			pswdobj.title = name + " should not be empty";
			flag = 1;
		} else {
			pswdobj.style.outline = "initial";
			pswdobj.title = "";
		}
		if (flag == 0) {
			return true;
		} else {
			return false;
		}
	}
	return true;
}

function avoidSpace(event) {
	var k = event ? event.which : window.event.keyCode;
	if (k == 32) {
		alert("space is not allowed");
		return false;
	}
}

function isNumber(n) {
	return /^[0-9]+$/.test(n);
}

function IPv4AddressKeyOnly(e) {
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	if ((keyCode == 46 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode >= 48 && keyCode <= 57)) {
		return true;
	}
	return false;
}
function showErrorMsg(errormsg)
{
	alert(errormsg);
}
	  </script>
   </head>
   <body>
      <form name="f1" action="savepage.jsp?page=dialer&slnumber=<%=slnumber%>" method="post" onsubmit="return chkFunc()">
         <p class="style1" align="center">Dialer Configuration</p>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="230">Parameters</th>
                  <th width="320">Current Config</th>
                  <th width="150">Configuration</th>
               </tr>
               <tr>
                  <td>Status</td>
                  <td><%=dialerstatus==null?"No Change":dialerstatus%></td>
                  <td>
                     <select name="enable" id="enable">
                        <option value="No Change" <%if(dialerstatus.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="Enable" <%if(dialerstatus.equals("Enable")){%>selected<%}%>>Enable</option>
                        <option value="Disable" <%if(dialerstatus.equals("Disable")){%>selected<%}%>>Disable</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>IP Address</td>
                  <td><%=dialerobj == null?"":dialerobj.get("ipAddress")==null?"":dialerobj.getString("ipAddress")%></td>
                  <td><input bindto="Ip Address" name="DIPV4" type="text" class="text" id="DIPV4" size="12" maxlength="16" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td>Netmask</td>
                  <td><%=dialerobj == null?"":dialerobj.get("NetMask")==null?"":dialerobj.getString("NetMask")%></td>
                  <td><input bindto="Netmask" name="Dnetmask" type="text" class="text" id="Dnetmask" size="12" maxlength="16" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td>Pool Number</td>
                  <td><%=dialerobj == null?"":dialerobj.get("PoolNo")==null?"":dialerobj.getString("PoolNo")%></td>
                  <td><input name="poolNo" type="text" class="text" id="poolNo" size="12" maxlength="4" onsubmit="return validatePoolNo('poolNo', 'true', 'poolNo')" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td>Authentication</td>
                  <td><%=dialerauth==null?"No Change":dialerauth%></td>
                  <td>
                     <select name="auth" id="auth">
                        <option value="No Change" <%if(dialerauth.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="NONE" <%if(dialerauth.equals("NONE")){%>selected<%}%>>NONE</option>
                        <option value="PAP" <%if(dialerauth.equals("PAP")){%>selected<%}%>>PAP</option>
                        <option value="CHAP" <%if(dialerauth.equals("CHAP")){%>selected<%}%>>CHAP</option>
                        <option value="EAP" <%if(dialerauth.equals("EAP")){%>selected<%}%>>EAP</option>
                        <option value="PAP-Callin" <%if(dialerauth.equals("PAP-Callin")){%>selected<%}%>>PAP-Callin</option>
                        <option value="CHAP-Callin" <%if(dialerauth.equals("CHAP-Callin")){%>selected<%}%>>CHAP-Callin</option>
                        <option value="EAP-Callin" <%if(dialerauth.equals("No Change")){%>selected<%}%>>EAP-Callin</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Username</td>
                  <td><%=dialerobj == null?"":dialerobj.get("username")==null?"":dialerobj.getString("username")%></td>
                  <td><input name="username" type="text" class="text" id="username" size="12" maxlength="257"></td>
               </tr>
               <tr>
                  <td>Password</td>
                  <td><%=dialerobj == null?"":dialerobj.get("password")==null?"":dialerobj.getString("password")%></td>
                  <td><input name="password" type="text" class="text" id="password" size="12" maxlength="257"></td>
               </tr>
               <tr>
                  <td>Service Name</td>
                  <td><%=dialerobj == null?"":dialerobj.get("ServiceName")==null?"":dialerobj.getString("ServiceName")%></td>
                  <td><input name="servName" type="text" class="text" id="servName" size="12" maxlength="32" value="" onkeypress="return avoidSpace(event)"></td>
               </tr>
               <tr>
                  <td colspan="3"> <input type="checkbox" id="oauto" name="oauto" <%if(dialerdns.equals("Enable")){%>checked<%}%> onchange="editFields()" width="20px">&nbsp;&nbsp;&nbsp; Obtain Automatically</td>
               </tr>
               <tr>
                  <td>Primary DNS</td>
                  <td><%=dialerobj == null?"":dialerobj.get("PrimaryDNS")==null?"":dialerobj.getString("PrimaryDNS")%></td>
                  <td><input bindto="pridns" name="pridns" type="text" class="text" id="pridns" size="12" maxlength="16" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td>Secondary DNS</td>
                  <td><%=dialerobj == null?"":dialerobj.get("SecondaryDNS")==null?"":dialerobj.getString("SecondaryDNS")%></td>
                  <td><input bindto="Secondary DNS" name="Secondary DNS" type="text" class="text" id="Secondary DNS" size="12" maxlength="16" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input value="Submit" class="button" type="submit"></div>
      </form>
	  <%if(errorstr != null && errorstr.trim().length() > 0)
			{%>
		     <script>
			 showErrorMsg('<%=errorstr%>');
			 </script>
			<%}
	  %>
      <script type="text/javascript">editFields();</script>
</html>

