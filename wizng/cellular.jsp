<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject cellularobj = null;
   JSONObject sim1obj = null;
   JSONObject sim2obj = null;
   BufferedReader jsonfile = null;   
   String sim1autoapn = "No Change";
   String sim1cellnw = "No Change";
   String sim1pppauth = "No Change";
   String sim1sts = "No Change";
   String sim2autoapn = "No Change";
   String sim2cellnw = "No Change";
   String sim2pppauth = "No Change";
   String sim2sts = "No Change";
   String primsim = "No Change";
   String sim1apn = "";
   String sim2apn = "";
   String recprim = "";
   String trackip = "";
   String timeout = "";
   String acttout = "No Change";
   String pdreboot = "";
   String slnumber=request.getParameter("slnumber");
   String errorstr = request.getParameter("error");
   String fwversion = request.getParameter("version");
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
   		cellularobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("CELLULAR");
   		sim1obj = cellularobj.getJSONObject("SIM1");
   		sim2obj = cellularobj.getJSONObject("SIM2");
   		sim1autoapn =  sim1obj.getString("autoapn")==null?"No Change":sim1obj.getString("autoapn");
   		sim1cellnw =  sim1obj.getString("nwType")==null?"No Change":sim1obj.getString("nwType");
   		sim1pppauth =  sim1obj.getString("pppAuth")==null?"No Change":sim1obj.getString("pppAuth");
   		sim1sts =  sim1obj.getString("status")==null?"No Change":sim1obj.getString("status");
   		sim1apn = sim1obj.getString("apn")==null?"":sim1obj.getString("apn");
   		
   		sim2autoapn =  sim2obj.getString("autoapn")==null?"No Change":sim2obj.getString("autoapn");
   		sim2cellnw =  sim2obj.getString("nwType")==null?"No Change":sim2obj.getString("nwType");
   		sim2pppauth =  sim2obj.getString("pppAuth")==null?"No Change":sim2obj.getString("pppAuth");
   		sim2sts =  sim2obj.getString("status")==null?"No Change":sim2obj.getString("status");
   		sim2apn = sim2obj.getString("apn")==null?"":sim2obj.getString("apn");
   		
   		
	    
   		primsim = cellularobj.getString("PrimarySIM")==null?"No Change":cellularobj.getString("PrimarySIM");
   		recprim = cellularobj.getString("ShiftFreq")==null?"":cellularobj.getString("ShiftFreq");
   		trackip = cellularobj.getString("TrackIP")==null?"":cellularobj.getString("TrackIP");
   	    timeout = cellularobj.getString("TrackTimeOut")==null?"No Change":cellularobj.getString("TrackTimeOut");
   	    acttout = cellularobj.getString("PPPTimer")==null?"":cellularobj.getString("PPPTimer");
   	    pdreboot = cellularobj.getString("RebootTimeOut")==null?"":cellularobj.getString("RebootTimeOut");
		
		if(acttout.equals("0"))
		{
			acttout="";
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
      <style type="text/css">
#WiZConf {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 720px;
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
	display: inline;
	border-radius: 6px;
	background-color: #6caee0;
	color: #ffffff;
	font-weight: bold;
	box-shadow: 1px 2px 4px 0 rgba(0, 0, 0, 0.08);
	padding: 12px 20px;
	border: 0;
	margin: 20px;
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
      <script type = "text/JavaScript"> 
function checkAPN() {
	var sim1apnobj = document.getElementById("APN");
	var sim2apnobj = document.getElementById("APN2");
	var sim1apn = sim1apnobj.value.trim();
	var sim2apn = sim2apnobj.value.trim();
	if (sim1apn == "" && sim2apn == "") {
		sim1apnobj.style.outline = "thin solid red";
		sim1apnobj.title = "Please Enter either SIM1  APN or SIM2 APN";
		sim2apnobj.style.outline = "thin solid red";
		sim2apnobj.title = "Please Enter either SIM1  APN or SIM2 APN";
		return "Please Enter either SIM1  APN or SIM2 APN";
	} else {
		sim1apnobj.style.outline = "initial";
		sim1apnobj.title = "";
		sim2apnobj.style.outline = "initial";
		sim2apnobj.title = "";
		return "";
	}
}

function chkFunc() {
	var altmsg = "";
	var tripobj=document.getElementById("trip");
	var trckip=tripobj.value;
	var tmoutobj=document.getElementById("timeout");
	var timeout=tmoutobj.value;
	if(trckip=="0.0.0.0" && timeout=="0")
	{    
		document.getElementById("action").value="0";
	}
	else if (!validateIP("trip", false, "Track IP")) {
		altmsg += "invalid Track IP\n";
	}
	if (altmsg != "") {
		alert(altmsg);
		return false;
	}
	return true;
}
function gotoSimShiftPage() {
	location.href = "Nomus.cgi?cgi=Sim_Shift_Process.cgi";
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
			ipele.style.outline = "thin solid red";
			ipele.title = name + " should not be empty";
			return false;
		} else {
			ipele.style.outline = "initial";
			ipele.title = "";
			return true;
		}
	} 
	else if (!ipaddr.match(ipformat) || ipaddr == "255.255.255.255") {
		ipele.style.outline = "thin solid red";
		ipele.title = "Invalid " + name;
		return false;
	} 
	else {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
}

function AvoidSpace(event) {
	var k = event ? event.which : window.event.keyCode;
	if (k == 32) {
		alert("space is not allowed");
		return false;
	}
}

function CheckAPNStatus() {
	var altmsg = "";
	var apns = ["APN", "APN2"];
	var status_cb = ["SIM1_sts", "SIM2_sts"];
	var nw_cb = ["NW", "NW2"];
	var status_lbl = ["s1status", "s2status"];
	var nw_lbl = ["sim1nw", "sim2nw"];
	var stsnames = ["SIM1 Status", "SIM2 Status"];
	var nwnames = ["SIM1 Network", "SIM2 Network"];
	for (var i = 0; i < apns.length; i++) {
		var apnname = document.getElementById(apns[i]).value.trim();
		if (apnname != "") {
			var curstatusobj = document.getElementById(status_cb[i]);
			var curstatus = curstatusobj.value.trim();
			var stslbl = document.getElementById(status_lbl[i]).innerHTML;
			var curnwobj = document.getElementById(nw_cb[i]);
			var curnw = curnwobj.value.trim();
			var nwlbl = document.getElementById(nw_lbl[i]).innerHTML;
			stslbl = stslbl.trim();
			nwlbl = nwlbl.trim();
			if (curnw == 0 && nwlbl == "") {
				curnwobj.style.outline = "thin solid red";
				curnwobj.title = nwnames[i] + " should not be No Change";
				altmsg += nwnames[i] + " should not be No Change\n";
			} else {
				curnwobj.style.outline = "initial";
				curnwobj.title = "";
			}
			if (curstatus == 0 && stslbl == "") {
				curstatusobj.style.outline = "thin solid red";
				curstatusobj.title = stsnames[i] + " should not be No Change";
				altmsg += stsnames[i] + " should not be No Change\n";
			} else {
				curstatusobj.style.outline = "initial";
				curstatusobj.title = "";
			}
		}
	}
	return altmsg;
}

function IPv4AddressKeyOnly(e) {
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	if ((keyCode == 46 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode >= 48 && keyCode <= 57)) {
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
function showErrorMsg(errormsg)
{
	alert(errormsg);
}
</script>
   </head>
   <body onload="selectComboItem()">
      <form action="savepage.jsp?page=cellular&slnumber=<%=slnumber%>&version=<%=fwversion%>" method="post" onsubmit="return chkFunc();">
         <br>
         <p align="center" class="style1">Cellular Configuration</p>
         <table align="center" id="WiZConf">
            <tbody>
               <tr>
                  <th align="center" width="180px">Parameters</th>
                  <th colspan="2" align="center" style="text-align:center;">SIM 1</th>
                  <th colspan="2" align="center" style="text-align:center;">SIM 2</th>
               </tr>
               <tr>
                  <td>Auto APN</td>
                  <td width="140" id="sim1AutoApn"><%=sim1autoapn%></td>
                  <td>
                     <select name="AutoAPN1" id="AutoAPN1">
                        <option value="No Change" <%if(sim1autoapn.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="Enable" <%if(sim1autoapn.equals("Enable")){%>selected<%}%>>Enable</option>
                        <option value="Disable" <%if(sim1autoapn.equals("Disable")){%>selected<%}%>>Disable</option>
                     </select>
                  </td>
                  <td width="140" id="sim2AutoApn"><%=sim2autoapn%></td>
                  <td>
                     <select name="AutoAPN2" id="AutoAPN2">
                        <option value="No Change" <%if(sim2autoapn.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="Enable" <%if(sim2autoapn.equals("Enable")){%>selected<%}%>>Enable</option>
                        <option value="Disable" <%if(sim2autoapn.equals("Disable")){%>selected<%}%>>Disable</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>APN</td>
                  <td width="140"><%=sim1apn%></td>
                  <td><input name="APN" type="text" value="<%=sim1apn%>" class="text" id="APN" onkeypress="return SpecialKeyOnly(event)" size="12" maxlength="32"><%=cellularobj == null?"":cellularobj.get("apn")==null?"":cellularobj.getString("apn")%></td>
                  <td width="140"><%=sim2apn%></td>
                  <td><input name="APN2" type="text" value="<%=sim2apn%>" class="text" id="APN2" value="" onkeypress="return SpecialKeyOnly(event)" size="12" maxlength="32"></td>
               </tr>
               <tr>
                  <td>Network</td>
                  <td width="140" id="sim1nw"><%=sim1cellnw==null?"No Change":sim1cellnw%></td>
                  <td>
                     <select name="NW" id="NW">
                        <option value="No Change" <%if(sim1cellnw.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="Auto" <%if(sim1cellnw.equals("Auto")){%>selected<%}%>>Auto</option>
                        <option value="2G" <%if(sim1cellnw.equals("2G")){%>selected<%}%>>2G</option>
                        <option value="3G" <%if(sim1cellnw.equals("3G")){%>selected<%}%>>3G</option>
                        <option value="4G" <%if(sim1cellnw.equals("4G")){%>selected<%}%>>4G</option>
                     </select>
                  </td>
                  <td width="140" id="sim2nw"></td>
                  <td>
                     <select name="NW2" id="NW2">
                       <option value="No Change" <%if(sim2cellnw.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="Auto" <%if(sim2cellnw.equals("Auto")){%>selected<%}%>>Auto</option>
                        <option value="2G" <%if(sim2cellnw.equals("2G")){%>selected<%}%>>2G</option>
                        <option value="3G" <%if(sim2cellnw.equals("3G")){%>selected<%}%>>3G</option>
                        <option value="4G" <%if(sim2cellnw.equals("4G")){%>selected<%}%>>4G</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>PPP Username</td>
                  <td colspan="2"><input name="SIM1_PPPUname" type="text" class="text" id="SIM1_PPPUname" value="<%=sim1obj == null?"":sim1obj.get("pppUsername")==null?"":sim1obj.getString("pppUsername")%>" size="16" maxlength="32" onkeypress="return AvoidSpace(event)"></td>
                  <td colspan="2"><input name="SIM2_PPPUname" type="text" class="text" id="SIM2_PPPUname" value="<%=sim2obj == null?"":sim2obj.get("pppUsername")==null?"":sim2obj.getString("pppUsername")%>" size="16" maxlength="32" onkeypress="return AvoidSpace(event)"></td>
               </tr>
               <tr>
                  <td>PPP Password</td>
                  <td colspan="2"><input name="SIM1_Password" type="password" class="text" id="SIM1_CuPass" value="<%=sim1obj == null?"":sim1obj.get("pppPW")==null?"":sim1obj.getString("pppPW")%>" size="16" maxlength="32" onkeypress="return AvoidSpace(event)"></td>
                  <td colspan="2"><input name="SIM2_Password" type="password" class="text" id="SIM2_CuPass" value="<%=sim2obj == null?"":sim2obj.get("pppPW")==null?"":sim2obj.getString("pppPW")%>" size="16" maxlength="32" onkeypress="return AvoidSpace(event)"></td>
               </tr>
               <tr>
                  <td>PPP Authentication</td>
                  <td><%=sim1pppauth%></td>
                  <td>
                     <select name="SIM1_PPPAuth" id="SIM1_PPPAuth">
                        <option value="No Change" <%if(sim1pppauth.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="PAP" <%if(sim1pppauth.equals("PAP")){%>selected<%}%>>PAP</option>
                        <option value="CHAP" <%if(sim1pppauth.equals("CHAP")){%>selected<%}%>>CHAP</option>
                        <option value="ANY" <%if(sim1pppauth.equals("ANY")){%>selected<%}%>>ANY</option>
                        <option value="NONE" <%if(sim1pppauth.equals("NONE")){%>selected<%}%>>NONE</option>
                     </select>
                  </td>
                  <td><%=sim2pppauth%></td>
                  <td>
                     <select name="SIM2_PPPAuth" id="SIM2_PPPAuth">
                        <option value="No Change" <%if(sim2pppauth.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="PAP" <%if(sim2pppauth.equals("PAP")){%>selected<%}%>>PAP</option>
                        <option value="CHAP" <%if(sim2pppauth.equals("CHAP")){%>selected<%}%>>CHAP</option>
                        <option value="ANY" <%if(sim2pppauth.equals("ANY")){%>selected<%}%>>ANY</option>
                        <option value="NONE" <%if(sim2pppauth.equals("NONE")){%>selected<%}%>>NONE</option>
                     </select>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Status</td>
                  <td id="s1status"> <%=sim1sts==null?"No Change":sim1sts%></td>
                  <td>
                     <select name="SIM1_Status" id="SIM1_sts">
                        <option value="No Change" <%if(sim1sts.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="Enable" <%if(sim1sts.equals("Enable")){%>selected<%}%>>Enable</option>
                        <option value="Disable" <%if(sim1sts.equals("Disable")){%>selected<%}%>>Disable</option>
                     </select>
                  </td>
                  <td id="s2status"><%=sim2sts==null?"No Change":sim2sts%></td>
                  <td>
                     <select name="SIM2_Status" id="SIM2_sts">
                        <option value="No Change" <%if(sim2sts.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="Enable" <%if(sim2sts.equals("Enable")){%>selected<%}%>>Enable</option>
                        <option value="Disable" <%if(sim2sts.equals("Disable")){%>selected<%}%>>Disable</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td colspan="5" height="20"></td>
               </tr>
               <tr>
                  <td>Primary SIM</td>
                  <td colspan="2"><%=primsim %></td>
                  <td colspan="2">
                     <select name="Pri_SIM" id="Pri_SIM">
                        <option value="No Change" <%if(primsim.equals("No Change")){%>selected<%}%> >No Change</option>
                        <option value="SIM1" <%if(primsim.equals("SIM1")){%>selected<%}%>>SIM1</option>
                        <option value="SIM2" <%if(primsim.equals("SIM2")){%>selected<%}%>>SIM2</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Recheck Primary(Hr)</td>
                  <td colspan="2"><%=recprim%></td>
                  <td colspan="2"><input type="number"  min="0" max="99"  name="Recheck_Primary" id="rechk" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td>Track IP </td>
                  <td colspan="2"><%=trackip %></td>
                  <td colspan="2"><input type="text"  class="text" id="trip" name="Track_IP" maxlength="15" onfocusout="validateIP('trip',false,'Track IP');" onkeypress="return IPv4AddressKeyOnly(event)"/></td>
               </tr>
               <tr>
                  <td>TimeOut(Sec) </td>
                  <td colspan="2"><%=timeout %></td>
                  <td colspan="2"><input type="text" class="text" maxlength="2" id="timeout" name="Timeout" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td>Action on Timeout</td>
                  <td colspan="2"><%=acttout%></td>
                  <td colspan="2">
                     <select name="action" id="action">
                        <option value="0" <%if(acttout.equals("No Change")){%>selected<%}%> >No Change</option>
                        <option value="Sim Shift" <%if(acttout.equals("Sim Shift")){%>selected<%}%> >Sim Shift</option>
                        <option value="Reboot" <%if(acttout.equals("Reboot")){%>selected<%}%> >Reboot</option>
                        <option value="Reconnect" <%if(acttout.equals("Reconnect")){%>selected<%}%> >Reconnect</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>PPP down Reboot TimeOut(Min) </td>
                  <td colspan="2"><%=pdreboot%></td>
                  <td colspan="2"><input type="text" class="text" maxlength="2" id="rbttimeout" name="RebootTimeout" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" style="display:inline block" value="Submit" class="button"></div>
      </form>
	  <%if(errorstr != null && errorstr.trim().length() > 0)
			{%>
		     <script>
			 showErrorMsg('<%=errorstr%>');
			 </script>
			<%}
	  %>
      <script type = "text/javascript">	  
	  function selectComboItem() 
	  {
		for (var i = 0; i < hiddenvalarr.length; i++) 
	    {
			selAction(checkarr[i], document.getElementById(hiddenvalarr[i]).value);
	    }
      }	  
     </script>
	 <script src="js/timeout.js" type="text/javascript"></script>
   </body>
</html>