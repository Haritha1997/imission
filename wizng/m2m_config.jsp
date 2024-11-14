<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject m2mobj = null;
   BufferedReader jsonfile = null;   
   String m2mact = "No Change";
   String m2minterface = "No Change";
   String m2mservertype = "No Change";
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
   		m2mobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").getJSONObject("M2M");
   		if(m2mobj != null)
			m2mact = m2mobj.getString("Activation");
			m2minterface = m2mobj.getString("Interface");
			m2mservertype = m2mobj.getString("ServerType");
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
	String product_type = prodtypeobj.getString("ProductType");
   	
   %>
<html>
<head>
<style type="text/css">
#WiZConf 
{
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 520px;
}
#WiZConf td,
#WiZConf th {
	border: 2px solid #ddd;
	padding: 6px;
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

.text {
	background: white;
	border: 2px Solid #DDD;
	border-radius: 5px;
	box-shadow: 1 1 5px #DDD inset;
	color: #000;
	height: 25px;
	width: 140px;
}

#WiZConf1 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 520px;
}

#WiZConf1 td,
#WiZConf1 th {
	border: 2px solid #ddd;
	padding: 8px;
}

#WiZConf1 tr:nth-child(even) {
	background-color: #f2f2f2;
}

#WiZConf1 tr:hover {
	background-color: #d3f2ef;
}

#WiZConf1 th {
	padding-top: 12px;
	padding-bottom: 12px;
	text-align: center;
	background-color: #5798B4;
	color: white;
}

</style>
      <script type = "text/javascript"> 
	  function avoidSpace(event) {
	var k = event ? event.which : window.event.keyCode;
	if (k == 32) {
		alert("space is not allowed");
		return false;
	}
}

function validateRange(id, name) {
	var ipele = document.getElementById(id);
	if (ipele.readOnly == true) {
		ipele.style.outline = "initial";
		ipele.title = "";
		return;
	}
	var rele = document.getElementById(id);
	var val = rele.value;
	var max = Number(rele.max);
	var min = Number(rele.min);
	if (val.trim() == "") {
		return false;
	}
	if (!isNaN(val)) {
		if (val>= min && val <= max) {
			rele.style.outline = "initial";
			rele.title = "";
			return true;
		} else {
			rele.style.outline = "thin solid red";
			rele.title = name + " should be in the range from " + min + " to " + max;
			return false;
		}
	} else {
		rele.style.outline = "thin solid red";
		rele.title = name + " should be integer in the range from " + min + " to " + max;
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
		} else {
			ipele.style.outline = "initial";
			ipele.title = "";
		}
	} else if (!ipaddr.match(ipformat)) {
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
	if (ipaddr.match(ipformat)) {
		return true;
	} else {
		return false;
	}
}

function validateM2MConfig() {
	var alertmsg = "";
	var m2mids = ["Mserverip", "serverport"];
	var m2mnames = ["Server IP Address", "Server Port"];
	var iptables = [m2mids];
	var namestables = [m2mnames];
	var tbc;
	var stype = document.getElementById("Servertype").value;
	for (tbc = 0; tbc <iptables.length; tbc++) {
		var iptable = iptables[tbc];
		var namestable = namestables[tbc];
		for (var i = 0; i <iptable.length; i++) {
			var ipele = document.getElementById(iptable[i]);
			if (ipele.readOnly == true) continue;
			var valid = false;
			if (namestable[i].endsWith("IP Address")) {
				valid = validateIPByAddress(ipele.value, true);
			} else if (namestable[i] == "Server Port") {
				valid = validateRange(iptable[i], namestable[i]);
			}
			if (valid) {
				continue;
			} else {
				if (namestable[i] == "Server Port") {} else {
					if ((ipele.value == "") && (stype == 1)) {
						alertmsg += namestable[i] + " Should Not Be Empty.\n";
						ipele.title = namestable[i] + " should not be empty";
						ipele.style.outline = "thin solid red";
					} else if ((ipele.value != "") && (stype == 1)) {
						ipele.style.outline = "thin solid red";
						alertmsg += "Invalid " + namestable[i] + "(" + ipele.value + ") Of M2M Configuration.\n";
						ipele.title = "Invalid " + namestable[i];
					}
				}
			}
		}
	}
	if (stype == 2) {
		var name = document.getElementById("Mdomainname").value;
		var objname = document.getElementById("Mdomainname");
		if (name == "") {
			objname.style.outline = "thin solid red";
			alertmsg += "Domain Name Should not be Empty\n";
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

function M2mtype() {
	var stype = document.getElementById("Servertype").value;
	var objip = document.getElementById("Mserverip");
	var objname = document.getElementById("Mdomainname");
	if (stype == "IP Address") {
		objname.disabled = true;
		objname.value = "";
		objname.style.backgroundColor = "#808080";
		objname.style.outline = "initial";
		objip.disabled = false;
		objip.style.backgroundColor = "#ffffff";
	} else if (stype == "DomainName") {
		objip.disabled = true;
		objip.value = "";
		objip.style.backgroundColor = "#808080";
		objip.style.outline = "initial";
		objname.disabled = false;
		objname.style.backgroundColor = "#ffffff";
	} else {
		objname.disabled = false;
		objname.style.backgroundColor = "#ffffff";
		objip.disabled = false;
		objip.style.backgroundColor = "#ffffff";
	}
}
function showErrorMsg(errormsg)
{
	alert(errormsg);
} 
</script>
<script src="js/timeout.js " type="text / javascript">
</script>
   </head>
   <body onload="M2mtype()">
      <form action="savepage.jsp?page=m2m_config&slnumber=<%=slnumber%>" method="post" onsubmit="return validateM2MConfig()">
         <p class="style1" align="center">M2M Configuration</p>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="230">Parameters</th>
                  <th width="310">Current Config</th>
                  <th width="170">Configuration</th>
               </tr>
               <tr>
                  <td>Activation</td>
                  <td><%=m2mact==null?"No Change":m2mact%></td>
                  <td>
                     <select name="activation" id="activation">
                        <option value="No Change" <%if(m2mact.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="Enable">Enable</option>
                        <option value="Disable">Disable</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td >Interface</td>
                  <td><%=m2minterface==null?"No Change":m2minterface%></td>
                  <td>
                     <select name="interface" id="interface">
                        <option value="No Change" <%if(m2minterface.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="Cellular">Cellular</option>
						<%
						if(product_type.equals("3LAN-1WAN"))
						{%><option value="Eth1">Eth1</option><%}
						%>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Server Type</td>
                  <td><%=m2mservertype==null?"No Change":m2mservertype%></td>
                  <td>
                     <select name="Servertype" id="Servertype" onchange="M2mtype()">
                        <option value="No Change" <%if(m2mservertype.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="IP Address">IP Address</option>
                        <option value="DomainName">DomainName</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Server IP Address</td>
                  <td><%=m2mobj == null?"":m2mobj.get("ServerIpAddr")==null?"":m2mobj.getString("ServerIpAddr")%></td>
                  <td width="120px"><input type="text" class="text" size="12" maxlength="15" id="Mserverip" name="Mserverip" onkeypress="return IPv4AddressKeyOnly(event)" onfocusout="validateIP('Mserverip',true,'Server IP Address')" style="background-color: rgb(255, 255, 255);"></td>
               </tr>
               <tr>
                  <td>Domain Name</td>
                  <td><%=m2mobj == null?"":m2mobj.get("DomainName")==null?"":m2mobj.getString("DomainName")%></td>
                  <td width="120px"><input name="Mdomainname" value="" id="Mdomainname" maxlength="64" class="text" onkeypress="return avoidSpace(event)" type="text" style="background-color: rgb(255, 255, 255);"></td>
               </tr>
               <tr>
                  <td>Server Port</td>
                  <td><%=m2mobj == null?"":m2mobj.get("ServerPort")==null?"":m2mobj.getString("ServerPort")%></td>
                  <td width="120px"><input type="number" class="text" min="1" max="65535" id="serverport" name="serverport" onkeypress="return avoidSpace(event)" onfocusout="validateRange('serverport','Server Port')"></td>
               </tr>
               <tr>
                  <td>Polling Period (Min)</td>
                  <td><%=m2mobj == null?"":m2mobj.get("Polling_Period")==null?"":m2mobj.getString("Polling_Period")%></td>
                  <td width="120px"><input type="number" class="text" min="1" max="60" id="Pollingperiod" name="Pollingperiod" onkeypress="return avoidSpace(event)"></td>
               </tr>
               <tr>
                  <td>Retry Timeout (Sec)</td>
                  <td><%=m2mobj == null?"":m2mobj.get("Retry_Timeout")==null?"":m2mobj.getString("Retry_Timeout")%></td>
                  <td width="120px"><input type="number" class="text" min="10" max="60" id="RetryTimeout" name="RetryTimeout" onkeypress="return avoidSpace(event)"></td>
               </tr>
               <tr>
                  <td>Model Number</td>
                  <td><%=m2mobj == null?"":m2mobj.get("ModelNumber")==null?"":m2mobj.getString("ModelNumber")%></td>
                  <td width="120px"><input type="text" class="text" id="modelno" name="modelno" onkeypress="return avoidSpace(event)"></td>
               </tr>
            </tbody>
         </table>
         <br><br>
         <table id="WiZConf1" align="center">
            <tbody>
               <tr>
                  <th colspan="3" align="center">M2M Status</th>
               </tr>
               <tr>
                  <td width="144">Modified by</td>
                  <td colspan="2" id="modified"><%=m2mobj == null?"":m2mobj.get("Modified_User")==null?"":m2mobj.getString("Modified_User")%></td>
               </tr>
               <tr>
                  <td>Configuration Version</td>
                  <td id="configver"><%=m2mobj == null?"":m2mobj.get("Version")==null?"":m2mobj.getString("Version")%></td>
               </tr>
               <tr>
                  <td>Username</td>
                  <td id="uname"><%=m2mobj == null?"":m2mobj.get("Username")==null?"":m2mobj.getString("Username")%></td>
               </tr>
               <tr>
                  <td>Status</td>
                  <td id="m2mstatus"><%=m2mobj == null?"":m2mobj.get("M2MStatus")==null?"":m2mobj.getString("M2MStatus")%></td>
               </tr>
               <tr>
                  <!-- <td>CPU Utilization (%)</td>
                  <td id="cputil"><%=m2mobj == null?"":m2mobj.get("CPU_Utilization")==null?"":m2mobj.getString("CPU_Utilization")%></td>
               </tr>
               <tr>
                  <td>Memory Utilization (%)</td>
                  <td id="memoryutil"><%=m2mobj == null?"":m2mobj.get("Memory_Utilization")==null?"":m2mobj.getString("Memory_Utilization")%></td>
               </tr> -->
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