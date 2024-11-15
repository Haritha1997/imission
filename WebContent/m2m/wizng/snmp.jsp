<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject snmpobj = null;
   BufferedReader jsonfile = null; 
   String snmpversion = "No Change";
   String snmpsecurity = "No Change";
   String snmpact = "No Change";
   String snmpencry = "No Change";
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
   		snmpobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
   				.getJSONObject("SNMPCONFIG").getJSONObject("SNMP");		
		if(snmpobj != null)
			snmpversion = snmpobj.getString("Version");
			snmpsecurity = snmpobj.getString("Security_Mode");
			snmpact = snmpobj.getString("Authentication");
			snmpencry = snmpobj.getString("Encryption");
   		
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
	width: 480px;
}

#WiZConf1 {
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

#WiZConf1 td,
#WiZConf1 th {
	border: 2px solid #ddd;
	padding: 8px;
}

#WiZConf tr:nth-child(even) {
	background-color: #f2f2f2;
}

#WiZConf1 tr:nth-child(even) {
	background-color: #f2f2f2;
}

#WiZConf tr:hover {
	background-color: #d3f2ef;
}

#WiZConf1 tr:hover {
	background-color: #d3f2ef;
}

#WiZConf th {
	padding-top: 12px;
	padding-bottom: 12px;
	text-align: left;
	background-color: #5798B4;
	color: white;
}

#WiZConf1 th {
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

</style>
   </head>
   <body>
  <script> function avoidSpace(event) {
	var k = event ? event.which : window.event.keyCode;
	if (k == 32) {
		alert("space is not allowed");
		return false;
	}
}

function setEditableFields(securitymode) {
	var smarr = ["authtcn", "encrptn", "authpwd", "encpwd"];
	var scty = "";
	var selopt = "";
	var sctymodearr;
	if (securitymode == "WiZConf1") {
		scty = "scty";
		sctymodearr = smarr;
	}
	selopt = document.getElementById(scty + "mode").value;
	if (selopt == "No Change") {
		for (var i = 0; i < sctymodearr.length; i++) {
			var obj = document.getElementById(sctymodearr[i]);
			if (i < 4) {
				obj.readOnly = false;
				obj.disabled = false;
				obj.style.backgroundColor = "#ffffff";
				if(i<2)
				{
					obj.value="No Change";
				}
			} else {
				obj.readOnly = true;
				obj.style.backgroundColor = "#808080";
				obj.style.outline = "initial";
				obj.title = "";
			}
		}
	} else if (selopt == "Privacy") {
		for (var i = 0; i < sctymodearr.length; i++) {
			var obj = document.getElementById(sctymodearr[i]);
			if (i < 4) {
				obj.readOnly = false;
				obj.disabled = false;
				obj.style.backgroundColor = "#ffffff";
				if(i<2)
				obj.value="No Change";
			} else {
				obj.readOnly = true;
				obj.value="";
				obj.style.backgroundColor = "#808080";
				obj.style.outline = "initial";
				obj.title = "";
			}
		}
	} else if (selopt == "Authentication") {
		for (var i = 0; i < sctymodearr.length; i++) {
			var obj = document.getElementById(sctymodearr[i]);
			if (i == 0) {
				obj.readOnly = false;
				obj.disabled = false;
				obj.value="No Change";
				obj.style.backgroundColor = "#ffffff";
			} else if (i == 2) {
				obj.readOnly = false;
				obj.disabled = false;
				obj.value="No Change";
				obj.style.backgroundColor = "#ffffff";
			} else {
				obj.readOnly = true;
				obj.disabled = true;
				obj.value="";
				obj.style.backgroundColor = "#808080";
				obj.style.outline = "initial";
				obj.title = "";
			}
		}
	} else if (selopt == "No Auth") {
		for (var i = 0; i < sctymodearr.length; i++) {
			var obj = document.getElementById(sctymodearr[i]);
			obj.readOnly = true;
			obj.disabled = true;
			obj.value="";
			obj.style.backgroundColor = "#808080";
			obj.style.outline = "initial";
			obj.title = "";
		}
	}
}

function changeSctyMode(securitymode) {
	if (securitymode == "WiZConf1") setEditableFields(securitymode)
}

function isEmpty(id, checkempty, name) {
	var ipele = document.getElementById(id);
	if (ipele.readOnly == true) {
		ipele.style.outline = "initial";
		ipele.title = "";
		return;
	}
	var userinput = ipele.value;
	if (userinput == "") {
		if (checkempty) {
			ipele.style.outline = "thin solid red";
			ipele.title = name + " should not be empty \n";
		} else {
			ipele.style.outline = "initial";
			ipele.title = "";
		}
	}
}

function validateIsEmpty(userinput, checkempty) {
	if (userinput == "") {
		if (!checkempty) return true;
		else {
			return false;
		}
	} else {
		return true;
	}
}

function validateLengthRange(id, checkempty, minlength, maxlength, name) {
	var ipele = document.getElementById(id);
	if (ipele.readOnly == true) {
		ipele.style.outline = "initial";
		ipele.title = "";
		return;
	}
	var userinput = ipele.value;
	if (userinput == "") {
		if (checkempty) {
			ipele.title = name + " should not be empty";
		} else {
			ipele.style.outline = "initial";
			ipele.title = "";
		}
	} else if (userinput.length >= minlength && userinput.length <= maxlength) {
		ipele.style.outline = "initial";
		ipele.title = "";
	} else {
		ipele.style.outline = "thin solid red";
		ipele.title = "Please Enter input in " + name + " between " + minlength + " and " + maxlength + " characters";
	}
}

function validateLengthRangeByAddress(userinput, checkempty, minlength, maxlength) {
	if (userinput == "") {
		if (!checkempty) return true;
		else {
			return false;
		}
	}
	if (userinput.length >= minlength && userinput.length <= maxlength) {
		return true;
	} else {
		return false;
	}
}

function validateSNMP() {
	var alertmsg = "";
	var title = ["SNMP"];
	var systmcnfgtnids = ["systmcntct", "systmname", "systmlctn"];
	var systmcnfgtnnames = ["System Contact", "System Name", "System Location"];
	var v1andv2csettingids = ["readcmnty", "wrtecmnty"];
	var v1andv2csettingnames = ["Read Community", "Write Community"];
	var iptables = [systmcnfgtnids, v1andv2csettingids];
	var namestables = [systmcnfgtnnames, v1andv2csettingnames];
	var tbc;
	for (tbc = 0; tbc < iptables.length; tbc++) {
		var iptable = iptables[tbc];
		var namestable = namestables[tbc];
		for (i = 0; i < iptable.length; i++) {
			var ipele = document.getElementById(iptable[i]);
			if (ipele.readOnly == true) continue;
			var valid = false;
			if (namestable[i] == "System Contact" || namestable[i] == "System Name" || namestable[i] == "System Location") {
				if (namestable[i].startsWith("Primary")) valid = validateLengthRangeByAddress(ipele.value, true, 1, 256);
				if (namestable[i].startsWith("System")) valid = validateIsEmpty(ipele.value, true);
				else valid = validateLengthRangeByAddress(ipele.value, false, 1, 256);
			} else if (namestable[i] == "Read Community" || namestable[i] == "Write Community") {
				if (namestable[i].startsWith("Primary")) valid = validateLengthRangeByAddress(ipele.value, true, 1, 32);
				if (namestable[i].endsWith("Community")) valid = validateIsEmpty(ipele.value, true);
				else valid = validateLengthRangeByAddress(ipele.value, false, 1, 32);
			}
			if (valid) {
				continue;
			} else {
				ipele.style.outline = "thin solid red";
				if (ipele.value == "") {
					alertmsg += namestable[i] + " Should Not Be Empty.\n";
					ipele.title = namestable[i] + " should not be empty.\n";
				} else {
					alertmsg += "Invalid " + namestable[i] + "(" + ipele.value + ") Of SNMP Configuration .";
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
      <form action="savepage.jsp?page=snmp&slnumber=<%=slnumber%>" method="post" onsubmit="return validateSNMP();">
         <br>
         <blockquote>
            <p class="style1" align="center">SNMP Configuration</p>
         </blockquote>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th colspan="3" style="text-align:center;" align="center" width="200px">System Configuration</th>
               </tr>
               <tr>
                  <td width="150px">Version</td>
                  <td width="250px"><%=snmpversion==null?"No Change":snmpversion%></td>
                  <td colspan="2" width="150px">
                     <select name="version" id="version">
                        <option value="No Change" <%if(snmpversion.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="v1" <%if(snmpversion.equals("v1")){%>selected<%}%>>v1</option>
                        <option value="v2c" <%if(snmpversion.equals("v2c")){%>selected<%}%>>v2c</option>
                        <option value="v3" <%if(snmpversion.equals("v3")){%>selected<%}%>>v3</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td width="125px">System Contact</td>
                  <td colspan="2" width="175px"><input class="text" id="systmcntct" name="systmcntct" onkeypress="return SpecialKeyOnly(event)" value="<%=snmpobj == null?"":snmpobj.get("System_Contact")==null?"":snmpobj.getString("System_Contact")%>" onfocusout="validateLengthRange('systmcntct',false,1,256,'System Contact') || isEmpty('systmcntct',true,'System Contact') " type="text"></td>
               </tr>
               <tr>
                  <td width="100px">System Name</td>
                  <td colspan="2" width="175px"><input class="text" id="systmname" name="systmname" onkeypress="return SpecialKeyOnly(event)" value="<%=snmpobj == null?"":snmpobj.get("System_Name")==null?"":snmpobj.getString("System_Name")%>" onfocusout="validateLengthRange('systmname',false,1,256,'System Name') || isEmpty('systmname',true,'System Name') " type="text"></td>
               </tr>
               <tr>
                  <td width="100px">System Location</td>
                  <td colspan="2" width="175px"><input class="text" min="1" max="256" id="systmlctn" onkeypress="return SpecialKeyOnly(event)" name="systmlctn" value="<%=snmpobj == null?"":snmpobj.get("System_Location")==null?"":snmpobj.getString("System_Location")%>" onfocusout="validateLengthRange('systmlctn',false,1,256,'System Location') || isEmpty('systmlctn',true,'System Location') " type="text"></td>
               </tr>
            </tbody>
         </table>
         <br><br>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th colspan="3" style="text-align:center;" align="center" width="200px">SNMP v1 and v2c Settings</th>
               </tr>
               <tr>
                  <td width="100px">Read Community</td>
                  <td colspan="2" width="175px"><input class="text" id="readcmnty" name="readcmnty" onkeypress="return SpecialKeyOnly(event)" value="<%=snmpobj == null?"":snmpobj.get("Read_Community")==null?"":snmpobj.getString("Read_Community")%>" onfocusout="validateLengthRange('readcmnty',false,1,32,'Read Community') || isEmpty('readcmnty',true,'Read Community') " type="text"></td>
               </tr>
               <tr>
                  <td width="100px">Write Community </td>
                  <td colspan="2" width="175px"><input class="text" id="wrtecmnty" name="wrtecmnty" onkeypress="return SpecialKeyOnly(event)" value="<%=snmpobj == null?"":snmpobj.get("Write_Community")==null?"":snmpobj.getString("Write_Community")%>" onfocusout="validateLengthRange('wrtecmnty',false,1,32,'Write Community') || isEmpty('wrtecmnty',true,'Write Community') " type="text"></td>
               </tr>
            </tbody>
         </table>
         <br><br>
         <table id="WiZConf1" align="center">
            <tbody>
               <tr>
                  <th colspan="3" style="text-align:center;" align="center" width="200px">SNMP v3 Settings</th>
               </tr>
               <tr>
                  <td width="180px">User</td>
                  <td colspan="2" width="160px"><input class="text" max="32" id="user" name="user" value="<%=snmpobj == null?"":snmpobj.get("user")==null?"":snmpobj.getString("user")%>" onkeypress="return SpecialKeyOnly(event)" type="text"></td>
               </tr>
               <tr>
                  <td width="180px">Security Mode</td>
                  <td width="160px"><%=snmpsecurity==null?"No Change":snmpsecurity%></td>
                  <td colspan="2" align="center" width="160px">
                     <select name="sctymode" id="sctymode" onchange="changeSctyMode('WiZConf1')">
                        <option value="No Change" <%if(snmpsecurity.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="Privacy" <%if(snmpsecurity.equals("Privacy")){%>selected<%}%>>Privacy</option>
                        <option value="Authentication" <%if(snmpsecurity.equals("Authentication")){%>selected<%}%>>Authentication</option>
                        <option value="No Auth" <%if(snmpsecurity.equals("No Auth")){%>selected<%}%>>No Auth</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td width="180px">Authentication</td>
                  <td width="160px"><%=snmpact==null?"No Change":snmpact%></td>
                  <td colspan="2" width="160px">
                     <select name="authtcn" id="authtcn">
						<option value="" <%if(snmpact.equals("")){%>selected<%}%>></option>
                        <option value="No Change" <%if(snmpact.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="MD5" <%if(snmpact.equals("MD5")){%>selected<%}%>>MD5</option>
                        <option value="SHA1" <%if(snmpact.equals("SHA1")){%>selected<%}%>>SHA1</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td width="180px">Encryption</td>
                  <td width="160px"><%=snmpencry==null?"No Change":snmpencry%></td>
                  <td colspan="2" width="160px">
                     <select name="encrptn" id="encrptn">
					 <option value="" <%if(snmpencry.equals("")){%><%}%>></option>
                        <option value="No Change" <%if(snmpencry.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="AES" <%if(snmpencry.equals("AES")){%>selected<%}%>>AES</option>
                        <option value="DES" <%if(snmpencry.equals("DES")){%>selected<%}%>>DES</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td width="180px">Authentication Password</td>
                  <td colspan="2" width="160px"><input class="text" max="32" id="authpwd" name="authpwd" value="<%=snmpobj == null?"":snmpobj.get("Authentication_Pswd")==null?"":snmpobj.getString("Authentication_Pswd")%>" onkeypress="return avoidSpace(event)" type="password"></td>
               </tr>
               <tr>
                  <td width="180px">Encryption Password</td>
                  <td colspan="2" width="160px"><input class="text" max="32" id="encpwd" name="encpwd" value="<%=snmpobj == null?"":snmpobj.get("Encryption_Pswd")==null?"":snmpobj.getString("Encryption_Pswd")%>" onkeypress="return avoidSpace(event)" type="password"></td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input value="Submit" class="button" type="submit"></div>
      </form>
	    <script>
			 setEditableFields('WiZConf1');
	   </script>
	  <%if(errorstr != null && errorstr.trim().length() > 0)
			{%>
		     <script>
			 showErrorMsg('<%=errorstr%>');
			 </script>
			<%}
	  %>
   </body>
</html>