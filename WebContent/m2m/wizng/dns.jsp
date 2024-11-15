<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject dnsobj = null;
   String dns_autodns = "Enable";
   BufferedReader jsonfile = null; 
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
   		dnsobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
   				.getJSONObject("DNS");
			if(dnsobj != null)
			dns_autodns = dnsobj.getString("AutoDNS");
   		
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
	width: 600px;
}

#WiZConf td,
#WiZConf th,
#ipsectab td,
#ipsectab th {
	border: 2px solid #ddd;
	padding: 8px;
}


}
#WiZConf tr:nth-child(even),
#ipsectab tr:nth-child(even) {
	background-color: #f2f2f2;
}
#WiZConf tr:hover,
#ipsectab tr:hover {
	background-color: #d3f2ef;
}
#WiZConf th,
#ipsectab th {
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
	width: 185px;
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
.button1 {
	float: right;
	padding-right: 10px;
	font-weight: bold;
	background-color: #6caee0;
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
      <script type = "text/javascript"> 
function avoidSpace(event) {
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
	var ipformat = /^(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)$/;
	var ipaddr = ipele.value;
	if (ipaddr == "") {
		if (checkempty) {
			ipele.style.outline = "thin solid red";
			ipele.title = name + " should not be empty";
		} else {
			ipele.style.outline = "initial";
			ipele.title = "";
		}
	} else if (!ipaddr.match(ipformat)) {
		ipele.style.outline = "thin solid red";
		ipele.title = "Invalid " + name;
	} else {
		ipele.style.outline = "initial";
		ipele.title = "";
	}
}

function validateIPByAddress(ipaddr, checkempty) {
	var ipformat = /^(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)$/;
	if (ipaddr == "") {
		if (!checkempty) return true;
		else {
			return false;
		}
	}
	if (ipaddr.match(ipformat) && ipaddr != "0.0.0.0") {
		return true;
	} else {
		return false;
	}
}

function validateDns() {
	var oautoobj = document.getElementById("oauto");
	if (oautoobj.checked) return true;
	var id_arr = ["pridns", "secdns"];
	var name_arr = ["Primary DNS", "Secondary DNS"];
	var altmsg = "";
	for (var i = 0; i <id_arr.length; i++) {
		var ipele = document.getElementById(id_arr[i]);
		var valid = validateIPByAddress(document.getElementById(id_arr[i]).value, true);
		if (!valid) {
			ipele.style.outline = "thin solid red";
			if (ipele.value == "") {
				altmsg += name_arr[i] + " should not be empty.\n";
			} else {
				altmsg += name_arr[i] + " is not valid.\n";
			}
		}
	}
	if (altmsg != "") {
		alert(altmsg);
		return false;
	} else {
		return true;
	}
}

function editFields() {
	var oautoobj = document.getElementById("oauto");
	var id_arr = ["pridns", "secdns"];
	if (oautoobj.checked) {
		for (var i = 0; i <id_arr.length; i++) {
			var obj = document.getElementById(id_arr[i]);
			obj.readOnly = true;
			obj.style.outline = "initial";
		}
	} else {
		for (var i = 0; i <id_arr.length; i++) {
			var obj = document.getElementById(id_arr[i]);
			obj.readOnly = false;
		}
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
   <body onload="editFields()">
      <form action="savepage.jsp?page=dns&slnumber=<%=slnumber%>" method="post" onsubmit="return validateDns()">
         <blockquote>
            <p class="style1" align="center">DNS Configuration</p>
         </blockquote>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th colspan="2">
                     <div align="center"><strong>DNS Configuration</strong></div>
                  </th>
               </tr>
               <tr>
                  <td colspan="2"> <input type="checkbox" id="oauto" name="oauto" <%if(dns_autodns.equals("Enable")){%>checked<%}%> onchange="editFields()">&nbsp;&nbsp;&nbsp; Obtain Automatically</td>
               </tr>
               <tr>
                  <td width="50%">Primary DNS</td>
                  <td><input type="text" id="pridns" name="pridns" value="<%=dnsobj == null?"":dnsobj.get("PrimaryDNS")==null?"":dnsobj.getString("PrimaryDNS")%>" maxlength="16" onfocusout="validateIP('pridns',true,'Primary DNS')" onkeypress="return IPv4AddressKeyOnly(event)" readonly="" style="outline: initial;"></td>
               </tr>
               <tr>
                  <td width="50%">Secondary DNS</td>
                  <td><input type="text" id="secdns" name="secdns" value="<%=dnsobj == null?"":dnsobj.get("SecondaryDNS")==null?"":dnsobj.getString("SecondaryDNS")%>" maxlength="16" onfocusout="validateIP('secdns',true,'Secondary DNS')" onkeypress="return IPv4AddressKeyOnly(event)" readonly="" style="outline: initial;"></td>
               </tr>
            </tbody>
         </table>
         <div align="center">
            <blockquote>
               <p><input value="Submit" class="button" type="submit"></p>
            </blockquote>
         </div>
         <blockquote>
            <p></p>
            <p></p>
         </blockquote>
      </form>
   </body>
</html>