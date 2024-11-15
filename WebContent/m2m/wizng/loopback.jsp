<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject loopbackobj = null;
   BufferedReader jsonfile = null; 
	String loopbackact = "No Change";   
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
   		loopbackobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG")
   				.getJSONObject("ADDRESSCONFIG").getJSONObject("LOOPBACK");
   		if(loopbackobj != null)
			loopbackact = loopbackobj.getString("Activation");
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
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<style type="text/css">
#WiZConf 
{
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
      <script type = "text/javascript">
var txtBox1 = new Array("LBIPv4", "LBNetmask");
var ntxtbox = new Array("IPv4 Address", "Subnet Address");

function chkFunc() {
	var altmsg = "";
	for (var x = 0; x <txtBox1.length; x++) {
		var valid = false;
		var ip4add = document.getElementById(txtBox1[x]).value;
		if ((txtBox1[x] == "LBIPv4") || (txtBox1[x] == "LBSIPV4 ")) {
			valid = validateIP(txtBox1[x], true, ntxtbox[x]);
		} else if ((txtBox1[x] == "LBNetmask") || (txtBox1[x] == "LBSNetmask")) {
			valid = validateSubnetMask(txtBox1[x], true, ntxtbox[x]);
		}
		if (!valid) {
			if (ip4add == "") altmsg += ntxtbox[x] + " should not be empty.\n";
			else altmsg += "Invalid " + ntxtbox[x] + " (" + ip4add + ").\n";
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
	} else if (!ipaddr.match(ipformat) || ipaddr == "0.0.0.0") {
		ipele.style.outline = "thin solid red";
		ipele.title = "Invalid " + name;
		return false;
	} else {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
}
var y = Object.prototype.y = function (id) {
	return document.getElementById ? document.getElementById(id) : document.all ? document.all[id] : null
};

function selAction(sel) {
	for (var i = 0; i <sel.options.length; i++) {
		var trID = sel.options[i].getAttribute('bindTo');
		if (trID !== '') {
			var tr = y(sel.options[i].getAttribute('bindTo'));
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
function showErrorMsg(errormsg)
{
	alert(errormsg);
} 
</script>
   </head>
   <body onload="selectComboItem()">
      <form name="f1" action="savepage.jsp?page=loopback&slnumber=<%=slnumber%>" method="post" onsubmit="return chkFunc()">
         <p class="style1" align="center">Loopback IP Configuration</p>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="230">Parameters</th>
                  <th width="320">Current Config</th>
                  <th width="150">Configuration</th>
               </tr>
               <tr>
                  <td>Activation</td>
                  <td><%=loopbackact==null?"No Change":loopbackact%></td>
                  <td>
                     <select name="LBIfSts" id="LBIfSts">
                        <option value="No Change" <%if(loopbackact.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="Enable" <%if(loopbackact.equals("Enable")){%>selected<%}%>>Enable</option>
                        <option value="Disable" <%if(loopbackact.equals("Disable")){%>selected<%}%>>Disable</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>IPv4 Address</td>
                  <td><%=loopbackobj == null?"":loopbackobj.get("ipAddress")==null?"":loopbackobj.getString("ipAddress")%></td>
                  <td><input name="LBIPv4" type="text" class="text" id="LBIPv4" value="" size="12" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td>Subnet Address</td>
                  <td><%=loopbackobj == null?"":loopbackobj.get("subnetAddress")==null?"":loopbackobj.getString("subnetAddress")%></td>
                  <td><input name="LBNetmask" type="text" class="text" id="LBNetmask" value="" size="12" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)"></td>
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
	 function selectComboItem() {
	var ipver_text = document.getElementById("ip_ver_inp").value;
	for (var i = 0; i <document.getElementById("IPVer").options.length; i++) {
		if (document.getElementById("IPVer").options.item(i).text == ipver_text) {
			document.getElementById("IPVer").options[i].selected = 'selected';
			selAction(document.getElementById("IPVer"));
		}
	}
} 
</script>
   </body>
</html>