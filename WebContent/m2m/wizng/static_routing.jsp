<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.util.Hashtable"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject strtng_configobj = null;
   JSONObject strtng_table = null;
   JSONArray strtngnumarr = null;
   BufferedReader jsonfile = null;
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
   		//System.out.print(wizjsonnode);
   		strtng_configobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").getJSONObject("STATICROUTE");
   		strtng_table = strtng_configobj.getJSONObject("TABLE");
   		String name =(String)strtng_table.get("NAME");
   		strtngnumarr = strtng_table.getJSONArray("arr")==null ? new JSONArray(): strtng_table.getJSONArray("arr");
		
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
      <style type="text/css">select {
	width: 120px;
}

#WiZConf,
#WiZConf1 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 1000px;
}

#WiZConf td,
#WiZConf th,
#WiZConf1 th {
	border: 2px solid #ddd;
	padding: 2px;
	width: 10%;
	text-align: center;
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
	width: 126px;
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
 <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script> 
<script type="text/javascript"> 
function addStaticRoutingData(id,intf,destNetw,netmask,gateway,metric){ 
document.getElementById("interface"+id).value=intf;
document.getElementById("destNetw"+id).value=destNetw;
document.getElementById("netmask"+id).value=netmask;
document.getElementById("gateway"+id).value=gateway; 
document.getElementById("metric"+id).value=metric;
if(intf !="--Select--"){
var obj = document.getElementById("gateway"+id);
obj.disabled = true;
obj.style.backgroundColor = "#808080";
obj.style.outline = "initial";
obj.value = " ";
}
}

function addRow(tablename,product_type) {
	
	var table = document.getElementById(tablename);
	var rowcnt = table.rows.length;
	if (tablename == "WiZConf") {
		if (rowcnt == 11) {
			alert("Maximum 10 rows are allowed in Static Routing Table");
			return false;
		}
		if (rowcnt == 1) {
			document.getElementById("routesrwcnt").value = rowcnt;
		}
		rowcnt = document.getElementById("routesrwcnt").value;
		document.getElementById("routesrwcnt").value = Number(rowcnt) + 1;
		
		var row = "<tr><td><input type=\"checkbox\"></input></td><td>" + rowcnt + "</td><td><input name=\"destNetw"+rowcnt+"\" type=\"text\" class=\"text\" onkeypress=\"return IPv4AddressKeyOnly(event)\" id=\"destNetw"+rowcnt+"\" value=\"\" size=\"12\" maxlength=\"16\"  onfocusout=\"validateIP('destNetw" + rowcnt + "',true,'destNetw')\"></td><td><input name=\"netmask"+rowcnt+"\" type=\"text\" class=\"text\" onkeypress=\"return IPv4AddressKeyOnly(event)\" id=\"netmask"+rowcnt+"\" value=\"\" size=\"12\" maxlength=\"16\"  onfocusout=\"validateSubnetMask('netmask" + rowcnt + "',true,'netmask')\"></td><td><select name=\"interface"+rowcnt+"\" id=\"interface"+rowcnt+"\" onchange=\"validateGateway('gateway"+rowcnt+"','interface"+rowcnt+"',true,'gateway')\"><option value=\"--Select--\">--Select--</option><option value=\"Eth0\">Eth0</option><option value=\"Loopback\">Loopback</option><option value=\"cellular\">cellular</option></select></td><td><input name=\"gateway"+rowcnt+"\" type=\"text\" class=\"text\" id=\"gateway"+rowcnt+"\" value=\"\" size=\"12\" onkeypress=\"return IPv4AddressKeyOnly(event)\" maxlength=\"16\"  onfocusout=\"validateGateway('gateway" + rowcnt + "','interface" + rowcnt + "',true,'gateway')\"></td><td><input name=\"metric"+rowcnt+"\" type=\"number\" class=\"text\" min=\"1\" max=\"255\" id=\"metric" + rowcnt + "\" value=\"\" size=\"12\" onfocusout=\"validateMetric('metric" + rowcnt + "',true,'metric')\"></td></tr>";
	    if(product_type == "3LAN-1WAN")
	    {
	    	row = "<tr><td><input type=\"checkbox\"></input></td><td>" + rowcnt + "</td><td><input name=\"destNetw"+rowcnt+"\" type=\"text\" class=\"text\" onkeypress=\"return IPv4AddressKeyOnly(event)\" id=\"destNetw"+rowcnt+"\" value=\"\" size=\"12\" maxlength=\"16\"  onfocusout=\"validateIP('destNetw" + rowcnt + "',true,'destNetw')\"></td><td><input name=\"netmask"+rowcnt+"\" type=\"text\" class=\"text\" onkeypress=\"return IPv4AddressKeyOnly(event)\" id=\"netmask"+rowcnt+"\" value=\"\" size=\"12\" maxlength=\"16\"  onfocusout=\"validateSubnetMask('netmask" + rowcnt + "',true,'netmask')\"></td><td><select name=\"interface"+rowcnt+"\" id=\"interface"+rowcnt+"\" onchange=\"validateGateway('gateway"+rowcnt+"','interface"+rowcnt+"',true,'gateway')\"><option value=\"--Select--\">--Select--</option><option value=\"Eth0\">Eth0</option><option value=\"Eth1\">Eth1</option><option value=\"Loopback\">Loopback</option><option value=\"Dialer\">Dialer</option><option value=\"cellular\">cellular</option></select></td><td><input name=\"gateway"+rowcnt+"\" type=\"text\" class=\"text\" id=\"gateway"+rowcnt+"\" value=\"\" size=\"12\" onkeypress=\"return IPv4AddressKeyOnly(event)\" maxlength=\"16\"  onfocusout=\"validateGateway('gateway" + rowcnt + "','interface" + rowcnt + "',true,'gateway')\"></td><td><input name=\"metric"+rowcnt+"\" type=\"number\" class=\"text\" min=\"1\" max=\"255\" id=\"metric" + rowcnt + "\" value=\"\" size=\"12\" onfocusout=\"validateMetric('metric" + rowcnt + "',true,'metric')\"></td></tr>"; 
	    }
		$('#WiZConf').append(row);
		reindexTable();
	}
}

function deleteRow() {
	try {
		var table = document.getElementById("WiZConf");
		var rowCount = table.rows.length;
		for (var i = 1; i < rowCount; i++) {
			var row = table.rows[i];
			var chkbox = row.cells[0].childNodes[0];
			if (null != chkbox && true == chkbox.checked) {
				table.deleteRow(i);
				rowCount--;
				i--;
			}
		}
		reindexTable();
	} catch (e) {
		alert(e);
	}
}

function reindexTable() {
	var table = document.getElementById("WiZConf");
	var rowCount = table.rows.length;
	for (var i = 1; i < rowCount; i++) {
		var row = table.rows[i];
		row.cells[1].innerHTML = i;
	}
}

function validateRoute() {
	var alertmsg = "";
	var table = document.getElementById("WiZConf");
	var rows = table.rows;
	for (var i = 1; i < rows.length; i++) {
		var cols = rows[i].cells;
		var destNetwobj = cols[2].childNodes[0];
		var netmaskobj = cols[3].childNodes[0];
		var interfaceobj = cols[4].childNodes[0];
		var gatewayobj = cols[5].childNodes[0];
		var metricobj = cols[6].childNodes[0];
		var valid = validateIP(destNetwobj.id, true, "destNetw");
		if (!valid) {
			if (destNetwobj.value.trim() == "") {
				alertmsg += "The Destination Network in the row " + i + " should not be empty\n";
			} else {
				alertmsg += "The Destination Network in the row " + i + " is not valid\n";
			}
		}
		valid = validateSubnetMask(netmaskobj.id, true, "netmask");
		if (!valid) {
			if (netmaskobj.value.trim() == "") {
				alertmsg += "The Netmask in the row " + i + " should not be empty\n";
			} else {
				alertmsg += "The Netmask in the row " + i + " is not valid\n";
			}
		}
		valid = validateGateway(gatewayobj.id, interfaceobj.id, true, "gateway");
		if (!valid) {
			if (gatewayobj.value.trim() == "") {
				alertmsg += "The Gateway in the row " + i + " should not be empty\n";
			} else {
				alertmsg += "The Gateway in the row " + i + " is not valid\n";
			}
		}
		valid = validateMetric(metricobj.id, true, "metric");
		if (!valid) {
			if (metricobj.value.trim() == "") {} else {
				alertmsg += "The Distance Metric(0-255) in the row " + i + " is not valid\n";
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
	var ipformat = /^(25[0-4]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-4]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
	var ipaddr = ipele.value;
	if(ipaddr=="0.0.0.0" && name=="destNetw")
	{
		return true;
	}
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
	else if ((!ipaddr.match(ipformat)) || ipaddr == "255.255.255.255") {
		//else if ((!ipaddr.match(ipformat) || validateSubnetMask(id,checkempty,name)) || ipaddr == "255.255.255.255") {
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
	var ipformat = /^(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$/;
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
	} else if (!ipaddr.match(ipformat)) {
		ipele.style.outline = "thin solid red";
		ipele.title = "Invalid " + name;
		return false;
	} else {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
}

function validateMetric(id, checkempty, name) {
	var metricele = document.getElementById(id);
	if (metricele.readOnly == true) {
		metricele.style.outline = "initial";
		metricele.title = "";
		return true;
	}
	var metric = metricele.value;
		//alert("metric is : "+metric+" and is in range "+(metric < 0 || metric > 255));
	if (metric == "") {
		if (checkempty) {} else {
			metricele.style.outline = "initial";
			metricele.title = "";
			return true;
		}
	} else if (metric < 0 || metric > 255) {
		metricele.style.outline = "thin solid red";
		metricele.title = "Invalid " + name;
		return false;
	} else {
		metricele.style.outline = "initial";
		metricele.title = "";
		return true;
	}
}

function validateGateway(id1, id2, checkempty, name) {
	var interfaceOption = document.getElementById(id2);
	var obj = document.getElementById(id1);
	if (interfaceOption.value!="--Select--") {
		obj.disabled = true;
		obj.style.backgroundColor = "#808080";
		obj.style.outline = "";
		obj.value = "";
		return true;
	} else {
		obj.disabled = false;
		obj.style.backgroundColor = "#ffffff";
		if(validateIP(id1, checkempty, name)){
			return true;
		}
		else 
			return false;
	}
	return false;
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
      <title> WiZ</title>
   </head>
   <body>
      <form action="savepage.jsp?page=static_routing&slnumber=<%=slnumber%>" method="post" onsubmit="return validateRoute()">
         <input id="routesrwcnt" name="routesrwcnt" value="1" hidden="" type="text">
		 <p class="style1" align="center"> Static Route Configuration</p>
         <table id="WiZConf1" align="center">
            <tbody>
               <tr>
                  <th colspan="7"> Static Routing Table</th>
               </tr>
            </tbody>
         </table>
         <table id="WiZConf" align="center">
            <thead>
               <tr>
                  <th> select</th>
                  <th> S No</th>
                  <th> Destination Network</th>
                  <th> Netmask</th>
                  <th> Interface</th>
                  <th> Gateway</th>
                  <th> AD </th>
               </tr>
            </thead>
            <tbody>
               	<% 
            	   for(int j=0;j<strtngnumarr.size();j++)
            	   {
            		    JSONObject strtngobj = strtngnumarr.getJSONObject(j);
            		    String srinterface = strtngobj.getString("srInterface")==null? "":strtngobj.getString("srInterface");
                  		String srdestnetw = strtngobj.getString("srDestNetw")==null? "":strtngobj.getString("srDestNetw");
                  		String srnetmask = strtngobj.getString("srNetmask")==null? "":strtngobj.getString("srNetmask");
                  		String srgateway = strtngobj.getString("srGateway")==null? "":strtngobj.getString("srGateway");
                  		String srmetric = strtngobj.getString("srMetric")==null? "":strtngobj.getString("srMetric");
                  
                     %>
                   <script type="text/javascript">
	 				 addRow('WiZConf','<%=product_type%>');
	 				addStaticRoutingData('<%=(j+1)%>','<%=srinterface%>','<%=srdestnetw%>','<%=srnetmask%>','<%=srgateway%>','<%=srmetric%>');
	 			 </script>
				   <%}%>
            </tbody>
         </table>
         <div align="center"> <input class="button" id="add" value="Add" onclick="addRow('WiZConf','<%=product_type%>')" type="button"> <input class="button" id="delete" value="Delete" onclick="deleteRow('WiZConf')" type="button"> <input type="submit" value="Submit" class="button"> </div>
      </form>
		<%if(errorstr != null && errorstr.trim().length() > 0)
			{%>
		     <script>
			 showErrorMsg('<%=errorstr%>');s
			 </script>
		<%}
		%>	  
   </body>
</html>