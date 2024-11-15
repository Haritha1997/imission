<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject ethobj = null;
   BufferedReader jsonfile = null;   
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
   		ethobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
   				.getJSONObject("ADDRESSCONFIG").getJSONObject("ETH0");
   		
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
	cursor:ponter;
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
var txtBox1 = new Array("LANIPV4", "LANNetmask", "LANSIPV4", "LANSNetmask");
var nxtbox = new Array("IPv4 Address", "Subnet Address", "Secondary IP Address", "Secondary Subnet Mask");

function chkFunc() {
	var altmsg = "";
	for (var x = 0; x <txtBox1.length; x++) {
		var valid = false;
		var ip4add = document.getElementById(txtBox1[x]).value;
		if (txtBox1[x] == "LANIPV4") {
			valid = validateIP(txtBox1[x], false, nxtbox[x]);
		} else if ((txtBox1[x] == "LANNetmask")) {
			valid = validateSubnetMask(txtBox1[x], false, nxtbox[x]);
		} else if ((txtBox1[x] == "LANSIPV4")) {
			valid = validateIP(txtBox1[x], false, nxtbox[x]);
		} else if ((txtBox1[x] == "LANSNetmask")) {
			valid = validateSubnetMask(txtBox1[x], false, nxtbox[x]);
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
	if ((keyCode == 46 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode>= 48 && keyCode <= 57)) {
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
   <body onload="selectComboItem()">
      <form name="f1" action="savepage.jsp?page=eth0&slnumber=<%=slnumber%>" method="post" onsubmit="return chkFunc()">
         <p align="center" class="style1">Eth0 IP Configuration</p>
         <table align="center" id="WiZConf">
            <tbody>
               <tr>
                  <th width="230">Parameters</th>
                  <th width="320">Current Config</th>
                  <th width="150">Configuration</th>
               </tr>
               <tr>
                  <td>MAC Address</td>
                  <td colspan="2"><%=ethobj == null?"":ethobj.get("MacAddress")==null?"":ethobj.getString("MacAddress")%></td>
               </tr>
               <tr>
                  <td>IPv4 Address</td>
                  <td><%=ethobj == null?"":ethobj.get("ipAddress")==null?"":ethobj.getString("ipAddress")%></td>
                  <td><input name="LANIPV4" type="text" class="text" id="LANIPV4" size="12" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td>Subnet Address</td>
                  <td><%=ethobj == null?"":ethobj.get("subnetAddress")==null?"":ethobj.getString("subnetAddress")%></td>
                  <td><input name="LANNetmask" type="text" class="text" id="LANNetmask" size="12" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td>Secondary IP Address</td>
                  <td><%=ethobj == null?"":ethobj.get("secondIP")==null?"":ethobj.getString("secondIP")%></td>
                  <td><input name="LANSIPV4" type="text" class="text" id="LANSIPV4" size="12" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td>Secondary Subnet Mask</td>
                  <td><%=ethobj == null?"":ethobj.get("secondSubnet")==null?"":ethobj.getString("secondSubnet")%></td>
                  <td><input name="LANSNetmask" type="text" class="text" id="LANSNetmask" size="12" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)"></td>
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
function selectComboItem() 
{
	var ipver_text = document.getElementById("ip_ver_inp").value;
	for (var i = 0; i <document.getElementById("IPVer").options.length; i++) {
		if (document.getElementById("IPVer").options.item(i).text == ipver_text) {
			document.getElementById("IPVer").options[i].selected = 'selected';
			selAction(document.getElementById("IPVer"));
		}
	}
} </script>
   </body>
</html>