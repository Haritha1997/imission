<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject wanobj = null;
   BufferedReader jsonfile = null;   
   String wantype = "No Change";
   String wandns = "Enable";
   String wanact = "No Change";
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
   		wanobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
   				.getJSONObject("ADDRESSCONFIG").getJSONObject("WAN");
   		if(wanobj != null)
			wantype = wanobj.getString("Type");
			wanact = wanobj.getString("Activation");
			wandns = wanobj.getString("AutoDNS");
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
	   response.sendRedirect("notsupport.jsp?name=WAN Interface");
   %>

<html>
   <head>
      <style type="text/css">
	  #WiZConf {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 550px;
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
      <script type="text/javascript">
	  var txtBox1 = new Array("Primary DNS", "Secondary DNS", "WIPV4", "WNetmask", "WSIPV4", "WSNetmask", "Primarygwip");
var nxtbox = new Array("Primary DNS", "Secondary DNS", "Primary IP Address", "Primary Subnet Address", "Secondary IP Address", "Secondary Subnet Address", "Primary Gateway");

function chkFunc() {
	var altmsg = "";
	var count = 0;
	var oautoobj = document.getElementById("oauto");
	if (oautoobj.checked) {
		count = 1;
	}
	for (var x = 0; x < txtBox1.length; x++) {
		var valid = false;
		var ip4add = document.getElementById(txtBox1[x]).value;
		if ((txtBox1[x] == "Primary DNS")) {
			if ((count != 1)) valid = true;
			else valid = validateIP(txtBox1[x], false, nxtbox[x]);
		} else if ((txtBox1[x] == "Secondary DNS")) {
			if ((count != 1)) valid = true;
			else valid = validateIP(txtBox1[x], false, nxtbox[x]);
		} else if (txtBox1[x] == "WIPV4") {
			valid = validateIP(txtBox1[x], false, nxtbox[x]);
		} else if ((txtBox1[x] == "WNetmask")) {
			valid = validateSubnetMask(txtBox1[x], false, nxtbox[x]);
		} else if ((txtBox1[x] == "WSIPV4")) {
			valid = validateIP(txtBox1[x], false, nxtbox[x]);
		} else if ((txtBox1[x] == "WSNetmask")) {
			valid = validateSubnetMask(txtBox1[x], false, nxtbox[x]);
		} else if ((txtBox1[x] == "Primarygwip")) {
			valid = validateIP(txtBox1[x], false, nxtbox[x]);
		}
		if (!valid) {
			if (ip4add == "") altmsg += nxtbox[x] + " should not be empty.\n";
			else altmsg += "Invalid " + nxtbox[x] + " (" + ip4add + ").\n";
		}
	}
	if (altmsg == "") return true;
	else {
		alert(altmsg);
		return false;
	}
}

function editFields() {
	var oautoobj = document.getElementById("oauto");
	var id_arr = ["Primary DNS", "Secondary DNS"];
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

function validateIP(id, checkempty, name) {
	var ipele = document.getElementById(id);
	if (ipele.readOnly == true) {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
	var ipformat = /^(2[0-2][0-3]|1[0-9][0-9]|[1-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
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
	} else if (!ipaddr.match(ipformat) || ipaddr == "0.0.0.0" || ipaddr == "255.255.255.255") {
		ipele.style.outline = "thin solid red";
		ipele.title = "Invalid " + name;
		return false;
	} else {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
}

function validateSubnetMask(id, checkempty, name) {
	var ipele = document.getElementById(id);
	if (ipele.readOnly == true) {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
	var ipformat = /^(((255.){3}(255|254|252|248|240|224|192|128|0+))|((255.){2}(255|254|252|248|240|224|192|128|0+).0)|((255.)(255|254|252|248|240|224|192|128|0+)(.0+){2})|((255|254|252|248|240|224|192|128|0+)(.0+){3}))$/;
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
	} else if (!ipaddr.match(ipformat) || ipaddr == "0.0.0.0" || ipaddr == "255.255.255.255") {
		ipele.style.outline = "thin solid red";
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
	if ((keyCode == 46 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode >= 48 && keyCode <= 57)) {
		return true;
	}
	return false;
}

function makeEditableFields(cbid) {
	var cbid = document.getElementById(cbid);
	var cbval = cbid.value;
	var select = ["WIPV4","WNetmask","Primarygwip","WSIPV4","WSNetmask"];
	if (cbval != "Static" && cbval != "No Change" ) {
		for (var i = 0; i < 5; i++) {
			var obj = document.getElementById(select[i]);
			if (cbval == "DHCP") {
				if (i < 2) obj.readOnly = true;
				else
				{
					obj.readOnly = true;
					obj.style.backgroundColor = "#808080";
				}
			} 
			else 
			{
				if (i < 2) obj.readOnly = false;
				else 
				{
					obj.readOnly = true;
					obj.style.backgroundColor = "#808080";
				}
			}
		}
	} 
	else 
	{
		for (var i = 0; i < 5; i++) {
			var obj = document.getElementById(select[i]);
			obj.readOnly = false;
			obj.style.backgroundColor = "#ffffff";
		}
	}
}
function showErrorMsg(errormsg)
{
	alert(errormsg);
}
	  </script>
   </head>
   <body onload="selectComboItem()">
      <form name="f1" action="savepage.jsp?page=wan&slnumber=<%=slnumber%>" method="post" onsubmit="return chkFunc()">
         <p class="style1" align="center">ETH1 IP Configuration</p>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="230">Parameters</th>
                  <th width="320">Current Config</th>
                  <th width="150">Configuration</th>
               </tr>
               <tr>
                  <td>MAC Address</td>
                  <td colspan="2"><%=wanobj == null?"":wanobj.get("MacAddress")==null?"":wanobj.getString("MacAddress")%></td>
               </tr>
               <tr>
                  <td>Activation</td>
                  <td><%=wanact==null?"No Change":wanact%></td>
                  <td>
                     <select name="WIfSts" id="WIfSts">
                        <option value="No Change" <%if(wanact.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="Enable" <%if(wanact.equals("Enable")){%>selected<%}%>>Enable</option>
                        <option value="Disable" <%if(wanact.equals("Disable")){%>selected<%}%>>Disable</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Type</td>
                  <td><%=wantype==null?"No Change":wantype%></td>
                  <td>
                     <select name="type" id="type" onchange="makeEditableFields('type')">
                        <option value="No Change" <%if(wantype.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="Static" <%if(wantype.equals("Static")){%>selected<%}%>>Static</option>
                        <option value="DHCP" <%if(wantype.equals("DHCP")){%>selected<%}%>>DHCP</option>
                        <option value="PPPOE" <%if(wantype.equals("PPPOE")){%>selected<%}%>>PPPOE</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Primary IP Address</td>
                  <td><%=wanobj == null?"":wanobj.get("ipAddress")==null?"":wanobj.getString("ipAddress")%></td>
                  <td><input name="WIPV4" type="text" class="text" id="WIPV4" size="12" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)" style="background-color: rgb(255, 255, 255);"></td>
               </tr>
               <tr>
                  <td>Primary Subnet Address</td>
                  <td><%=wanobj == null?"":wanobj.get("subnetAddress")==null?"":wanobj.getString("subnetAddress")%></td>
                  <td><input name="WNetmask" type="text" class="text" id="WNetmask" size="12" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)" style="background-color: rgb(255, 255, 255);"></td>
               </tr>
               <tr>
                  <td>Primary Gateway</td>
                  <td><%=wanobj == null?"":wanobj.get("GatewayIP")==null?"":wanobj.getString("GatewayIP")%></td>
                  <td><input name="Primarygwip" type="text" class="text" id="Primarygwip" value="" size="12" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)" style="background-color: rgb(255, 255, 255);"></td>
               </tr>
               <tr>
                  <td>Secondary IP Address</td>
                  <td><%=wanobj == null?"":wanobj.get("secIP")==null?"":wanobj.getString("secIP")%></td>
                  <td><input name="WSIPV4" type="text" class="text" id="WSIPV4" value="" size="12" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)" style="background-color: rgb(255, 255, 255);"></td>
               </tr>
               <tr>
                  <td>Secondary Subnet Address</td>
                  <td><%=wanobj == null?"":wanobj.get("secSubnet")==null?"":wanobj.getString("secSubnet")%></td>
                  <td><input name="WSNetmask" type="text" class="text" id="WSNetmask" value="" size="12" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)" style="background-color: rgb(255, 255, 255);"></td>
               </tr>
               <tr>
                  <td colspan="3"><input type="checkbox" id="oauto" name="oauto" <%if(wandns.equals("Enable")){%>checked<%}%> onchange="editFields()">&nbsp;&nbsp;&nbsp; Obtain Automatically</td>
               </tr>
               <tr>
                  <td>Primary DNS</td>
                  <td><%=wanobj == null?"":wanobj.get("PrimaryDNS")==null?"":wanobj.getString("PrimaryDNS")%></td>
                  <td><input class="text" type="text" id="Primary DNS" name="Primary DNS" maxlength="16" value="" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td>Secondary DNS</td>
                  <td><%=wanobj == null?"":wanobj.get("SecondaryDNS")==null?"":wanobj.getString("SecondaryDNS")%></td>
                  <td><input class="text" type="text" id="Secondary DNS" name="Secondary DNS" maxlength="16" value="" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" value="Submit" class="button"></div>
      </form>
       <%
   	if(errorstr != null && errorstr.trim().length() > 0)
			{%>
		     <script>
			 showErrorMsg('<%=errorstr%>');
			 </script>
			<%}
	  %>
      <script type = "text/javascript"> 
	  editFields();

function selectComboItem() {
	var ipver_text = document.getElementById("ip_ver_inp").value;
	for (var i = 0; i < document.getElementById("IPVer").options.length; i++) {
		if (document.getElementById("IPVer").options.item(i).text == ipver_text) {
			document.getElementById("IPVer").options[i].selected = 'selected';
			selAction(document.getElementById("IPVer"));
		}
	}
}
makeEditableFields('type');

</script>
   </body>
</html>

