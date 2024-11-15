<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject trapobj = null;
   BufferedReader jsonfile = null; 
   String trapstatus = "No Change";
   String trapversion = "No Change";
   String trapsource = "No Change";
   String traps_cold = "Enable";
   String traps_auth = "Enable";
   String traps_link = "Enable";
   String product_type = "";
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
   		JSONObject prodtypeobj = wizjsonnode.getJSONObject("SYSTEMCONTROL").getJSONObject("PRODUCTTYPE");
   		product_type = prodtypeobj.containsKey("OldProductType")? prodtypeobj.getString("OldProductType") :prodtypeobj.getString("ProductType");
   		trapobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
   				.getJSONObject("SNMPCONFIG").getJSONObject("TRAP");	
   		
   			if(trapobj != null)
   			{
				trapversion = trapobj.getString("Trap_Version");
				trapsource = trapobj.getString("Trap_Source");
				trapstatus = trapobj.getString("ManagerStatus");
				traps_cold = trapobj.getString("Coldstart");
				traps_auth = trapobj.getString("Authentication");
				traps_link = trapobj.getString("Linkup_down");
   			}
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
      <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
      <meta http-equiv="Pragma" content="no-cache">
      <meta http-equiv="Expires" content="0">
      <style type="text/css">
#WiZConf {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 480px;
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

.text1 {
	background: white;
	border: 2px Solid #DDD;
	border-radius: 5px;
	box-shadow: 1 1 5px #DDD inset;
	color: #000;
	height: 20px;
	width: 190px;
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
	font-size: 20px;
	font-weight: bold;
}

body {
	background-color: #FAFCFD;
}

.page {
	display: none;
	padding: 0 0.5em;
}

.page h1 {
	font-size: 2em;
	line-height: 1em;
	margin-top: 1.1em;
	font-weight: bold;
}

.page p {
	font-size: 1.5em;
	line-height: 1.275em;
	margin-top: 0.15em;
}

.loading p {
	font-size: 1.5em;
	line-height: 1.275em;
	margin-top: 0.15em;
}

#loading {
	display: none;
	position: absolute;
	top: 0;
	left: 0;
	z-index: 100;
	width: 100vw;
	height: 100vh;
	background-color: rgba(192, 192, 192, 0.5);
	background-image: url("js/loader.gif ");
	background-repeat: no-repeat;
	background-position: center;
	transition-duration: 10s;
}
</style>
 <script> function avoidSpace(event) {
	var k = event ? event.which : window.event.keyCode;
	if (k == 32) {
		alert("space is not allowed");
		return false;
	}
}

function validateIP(id, checkempty, name) {
	var ipele = document.getElementById(id);
	if (ipele.readOnly == true) {
		ipele.style.outline = "initial";
		ipele.title = "";
		return;
	}
	var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
	var ipaddr = ipele.value;
	if (ipaddr == "") {
		if (checkempty) {
			ipele.title = name + " should not be empty";
			ipele.style.outline = "thin solid red";
		} else {
			ipele.style.outline = "initial";
			ipele.title = "";
		}
	} else if (!ipaddr.match(ipformat) || ipaddr == "255.255.255.255") {
		ipele.title = "Invalid " + name;
	} else {
		ipele.style.outline = "initial";
		ipele.title = "";
	}
}

function validateIPByAddress(ipaddr, checkempty) {
	var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
	if (ipaddr == "") {
		if (!checkempty) return true;
		else {
			return false;
		}
	}
	if (ipaddr.match(ipformat) && ipaddr != "255.255.255.255") {
		return true;
	} else {
		return false;
	}
}

function validateTraps() {
	var alertmsg = "";
	var title = ["TRAPS"];
	var manageripids = ["ipadrs1", "ipadrs2", "ipadrs3", "ipadrs4", "ipadrs5"];
	var manageripnames = ["Manager1 IP Address", "Manager2 IP Address", "Manager3 IP Address", "Manager4 IP Address", "Manager5 IP Address"];
	var iptables = [manageripids];
	var namestables = [manageripnames];
	var tbc;
	for (tbc = 0; tbc <iptables.length; tbc++) {
		var iptable = iptables[tbc];
		var namestable = namestables[tbc];
		for (i = 0; i <iptable.length; i++) {
			var ipele = document.getElementById(iptable[i]);
			if (ipele.readOnly == true) continue;
			var valid = false;
			if (namestable[i].endsWith("IP Address") || namestable[i].endsWith("IP")) {
				if (namestable[i].startsWith("Primary")) valid = validateIPByAddress(ipele.value, true);
				else valid = validateIPByAddress(ipele.value, false);
			}
			if (valid) {
				continue;
			} else {
				ipele.style.outline = "thin solid red";
				if (ipele.value == "") {
					alertmsg += namestable[i] + " Of Manager " + tbc + " Table Should Not Be Empty.";
					ipele.title = namestable[i] + " should not be empty";
				} else {
					alertmsg += "Invalid " + namestable[i] + "(" + ipele.value + ") Of Manager Configuration Table.";
					ipele.title = "Invalid " + namestable[i];
				}
			}
		}
	}
	if (alertmsg != "") {
		alert(alertmsg);
		return false;
	} else return true;
}

function IPv4AddressKeyOnly(e) {
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	if ((keyCode == 46 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode>= 48 && keyCode <= 57)) {
		return true;
	}
	return false;
}

function SpecialKeyOnly(e) {
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	if ((keyCode == 32)) {
		alert("space is not allowed");
		return false;
	}
	if (keyCode == 34) return false;
	return true;
}

function showSpinner() {
	setVisible('#loading', true);
	setTimeout(closeSpinner, 8000);
}

function setVisible(selector, visible) {
	document.querySelector(selector).style.display = visible ? 'block' : 'none';
}

function closeSpinner() {
	document.getElementById('loading').style.display = 'none';
}
function showErrorMsg(errormsg)
{
	alert(errormsg);
}
 </script>
   </head>
   <body>
      <form action="savepage.jsp?page=traps&slnumber=<%=slnumber%>" method="post" onsubmit="return validateTraps();">
         <br>
         <blockquote>
            <p align="center" class="style1">Traps Configuration</p>
         </blockquote>
         <table align="center" id="WiZConf">
            <tbody>
               <tr>
                  <th colspan="3" align="center" style="text-align:center;" width="200px">Trap Configuration</th>
               </tr>
               <tr>
                  <td width="100px">Trap Version</td>
                  <td width="150px"><%=trapversion==null?"No Change":trapversion%></td>
                  <td colspan="2" width="150px">
                     <select name="trpvsn" id="trpvsn">
                        <option value="No Change" <%if(trapversion.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="v1" <%if(trapversion.equals("v1")){%>selected<%}%>>v1</option>
                        <option value="v2" <%if(trapversion.equals("v2")){%>selected<%}%>>v2</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td width="100px">Trap Community</td>
                  <td colspan="2" width="300px"><input type="text" class="text1" max="32" id="trpcmnty" name="trpcmnty" value="<%=trapobj == null?"":trapobj.get("Trap_Community")==null?"":trapobj.getString("Trap_Community")%>" onkeypress="return SpecialKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td width="100px">Trap Source</td>
                  <td width="150px"><%=trapsource==null?"No Change":trapsource%> </td>
                  <td colspan="2" width="150px">
                     <select name="trpsrc" id="trpsrc">
                        <option value="No Change" <%if(trapsource.equals("No Change")){%>selected<%}%>>No Change</option>
                        <!--<option value="1">Cellular</option>-->
                        <option value="Eth0" <%if(trapsource.equals("Eth0")){%>selected<%}%>>Eth0</option>
                        <%if(product_type.equals("3LAN-1WAN")){%><option value="Eth1" <%if(trapsource.equals("Eth1")){%>selected<%}%>>Eth1</option> <%}%>
                        <option value="Loopback" <%if(trapsource.equals("Loopback")){%>selected<%}%>>Loopback</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td width="100px">Traps</td>
                  <td colspan="2" width="300px">
				  <input type="checkbox" name="cldstrt" <%if(traps_cold.equals("Enable")){%>checked<%}%> id="cldstrt">Cold Start&nbsp;<input type="checkbox" name="athtcn" <%if(traps_auth.equals("Enable")){%>checked<%}%> id="athtcn">Authentication&nbsp;<input type="checkbox" name="lnkupdwn" <%if(traps_link.equals("Enable")){%>checked<%}%> id="lnkupdwn">Link Up/Down</td>
               </tr>
            </tbody>
         </table>
         <br><br>
         <table align="center" id="WiZConf">
            <tbody>
               <tr>
                  <th colspan="4" align="center" style="text-align:center;" width="200px">Manager Configuration</th>
               </tr>
               <tr>
                  <th align="center" style="text-align:center;" width="50px">Manager</th>
                  <th align="center" style="text-align:center;" width="175px">IP Address</th>
                  <th colspan="2" align="center" style="text-align:center;" width="275px">Status</th>
               </tr>
			   <% JSONArray iparr = trapobj==null?new JSONArray():trapobj.getJSONArray("MangerIP");
			   	  JSONArray statusarr = trapobj==null?new JSONArray():trapobj.getJSONArray("ManagerStatus");
			   	  for(int i=0;i<iparr.size();i++)
			   	  {
			   		  String ipaddr = iparr.getString(i);
			   		  String status = statusarr.getString(i);
			   %> 
               <tr>
                  <td align="center" width="100px"><%=(i+1)%></td>
                  <td align="center" width="150px"><input type="text" class="text" max="32" id="ipadrs<%=(i+1)%>" name="ipadrs<%=(i+1)%>" maxlength="16" value="<%=ipaddr%>" onfocusout="validateIP('ipadrs<%=(i+1)%>',false,'Manager<%=(i+1)%> IP Address')" onkeypress="return IPv4AddressKeyOnly(event)"></td>
                  <td align="center" width="150px"><%=status%></td>
                  <td align="center" colspan="2" width="100px">
                     <select name="enbldsbl<%=(i+1)%>" id="enbldsbl<%=(i+1)%>">
                        <option value="No Change" <% if(status.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="Enable" <% if(status.equals("Enable")){%>selected<%}%>>Enable</option>
                        <option value="Disable" <% if(status.equals("Disable")){%>selected<%}%>>Disable</option>
                     </select>
                  </td>
               </tr>
               <% }%>
            </tbody>
         </table>
         <div align="center"><input type="submit" value="Submit" class="button"></div>
      </form>
	  <%if(errorstr != null && errorstr.trim().length() > 0)
			{%>
		     <script>
			 showErrorMsg('<%=errorstr%>');
			 </script>
			<%}
	  %>
   </body>
</html>