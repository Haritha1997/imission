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
   JSONObject nat_configobj = null;
   JSONObject nat_table = null;
   JSONArray natnumarr = null;
   BufferedReader jsonfile = null;
   String product_type = ""; //3LAN-1WAN or 4LAN
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
   		nat_configobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").getJSONObject("NATCONFIG").getJSONObject("NAT");
   		nat_table = nat_configobj.getJSONObject("TABLE");
   		String name =(String)nat_table.get("NAME");
   		natnumarr = nat_table.getJSONArray("arr")==null ? new JSONArray(): nat_table.getJSONArray("arr");
		
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
select 
{
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
	height: 23px;
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
function addNatData(id,innat,srcip,srcnm,outnat,act)
{
    document.getElementById("innat"+id).value=innat;
    document.getElementById("srcip"+id).value=srcip;
    document.getElementById("srcnm"+id).value=srcnm;
    document.getElementById("outnat"+id).value=outnat;
    document.getElementById("act"+id).value=act;
}
function addRow(tablename,product_type) 
{ 

    var table = document.getElementById(tablename);
    var rowcnt = table.rows.length;
    if (tablename == "WiZConf") 
	{ 
	if (rowcnt == 11) { 
    alert("Maximum 10 rows are allowed in NAT Configuration Table "); 
	return false; 
	} 
	if (rowcnt ==1) 
    document.getElementById("natrwcnt").value = rowcnt; 
    rowcnt = document.getElementById("natrwcnt").value; 
	
    document.getElementById("natrwcnt").value = Number(rowcnt) + 1;
	var row = "<tr><td><input type=\"checkbox\"></input></td><td>"+rowcnt+"</td><td><select name=\"innat"+rowcnt+"\" id=\"innat"+rowcnt+"\" onchange=\"setnatvalues('innat"+rowcnt+"','outnat"+rowcnt+"')\"><option value=\"Eth0\">Eth0</option><option value=\"Loopback\">Loopback</option></select></td><td><input name=\"srcip"+rowcnt+"\" type=\"text\" class=\"text\" onkeypress=\"return IPv4AddressKeyOnly(event)\" id=\"srcip"+rowcnt+"\" value=\"\" size=\"12\" maxlength=\"15\" onfocusout=\"validateIP('srcip"+rowcnt+"',true,'Source IP')\"></td><td><input name=\"srcnm"+rowcnt+"\" type=\"text\" class=\"text\" onkeypress=\"return IPv4AddressKeyOnly(event)\" id=\"srcnm"+rowcnt+"\" value=\"\" size=\"12\" maxlength=\"15\" onfocusout=\"validateSubnetMask('srcnm"+rowcnt+"',true,'Netmask')\"></td><td><select name=\"outnat"+rowcnt+"\" id=\"outnat"+rowcnt+"\" onchange=\"setnatvalues('innat"+rowcnt+"','outnat"+rowcnt+"')\"><option value=\"Cellular\">Cellular</option><option value=\"Loopback\">Loopback</option></select></td><td><select id=\"act"+rowcnt+"\" name=\"act"+rowcnt+"\"><option value=\"Permit\">Permit</option><option value=\"Deny\">Deny</option></select></td><td hidden>"+rowcnt+"</td></tr>";
	if(product_type=="3LAN-1WAN")
	{
		row = "<tr><td><input type=\"checkbox\"></input></td><td>"+rowcnt+"</td><td><select name=\"innat"+rowcnt+"\" id=\"innat"+rowcnt+"\" onchange=\"setnatvalues('innat"+rowcnt+"','outnat"+rowcnt+"')\"><option value=\"Eth0\">Eth0</option><option value=\"Loopback\">Loopback</option></select></td><td><input name=\"srcip"+rowcnt+"\" type=\"text\" class=\"text\" onkeypress=\"return IPv4AddressKeyOnly(event)\" id=\"srcip"+rowcnt+"\" value=\"\" size=\"12\" maxlength=\"15\" onfocusout=\"validateIP('srcip"+rowcnt+"',true,'Source IP')\"></td><td><input name=\"srcnm"+rowcnt+"\" type=\"text\" class=\"text\" onkeypress=\"return IPv4AddressKeyOnly(event)\" id=\"srcnm"+rowcnt+"\" value=\"\" size=\"12\" maxlength=\"15\" onfocusout=\"validateSubnetMask('srcnm"+rowcnt+"',true,'Netmask')\"></td><td><select name=\"outnat"+rowcnt+"\" id=\"outnat"+rowcnt+"\" onchange=\"setnatvalues('innat"+rowcnt+"','outnat"+rowcnt+"')\"><option value=\"Cellular\">Cellular</option><option value=\"Loopback\">Loopback</option><option value=\"Eth1\">Eth1</option><option value=\"Dialer\">Dialer</option></select></td><td><select id=\"act"+rowcnt+"\" name=\"act"+rowcnt+"\"><option value=\"Permit\">Permit</option><option value=\"Deny\">Deny</option></select></td><td hidden>"+rowcnt+"</td></tr>";
	}
	$('#WiZConf').append(row);
	reindexTable();
	}
}

function deleteRow() {
	try {
		var table = document.getElementById("WiZConf");
		var rowCount = table.rows.length;
		for (var i = 1; i <rowCount; i++) {
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
	for (var i = 1; i <rowCount; i++) {
		var row = table.rows[i];
		row.cells[1].innerHTML = i;
	}
}

function setnatvalues(innatid, outnatid) {
	var innatobj = document.getElementById(innatid);
	var outnatobj = document.getElementById(outnatid);
	if (innatobj.value == 2) {}
}

function validateNat() {
	var alertmsg = "";
	var table = document.getElementById("WiZConf");
	var rows = table.rows;
	for (var i = 1; i <rows.length; i++) {
		var cols = rows[i].cells;
		var srcipobj = cols[3].childNodes[0];
		var netmaskobj = cols[4].childNodes[0];
		var valid = validateIP(srcipobj.id, true, "Source IP");
		if (!valid) {
			if (srcipobj.value.trim() == "") {
				alertmsg += "The Source IP in the row " + i + " should not be empty\n";
			} else {
				alertmsg += "The Source IP in the row " + i + " is not valid\n";
			}
		}
		valid = validateSubnetMask(netmaskobj.id, true, "Netmask");
		if (!valid) {
			if (netmaskobj.value.trim() == "") {
				alertmsg += "The Netmask in the row " + i + " should not be empty\n";
			} else {
				alertmsg += "The Netmask in the row " + i + " is not valid\n";
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
	var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
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
	} else if (!ipaddr.match(ipformat) || ipaddr == "255.255.255.255" || ipaddr == "0.0.0.0") {
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
function showErrorMsg(errormsg)
{
	alert(errormsg);
}
</script>
<title> WiZ</title>
   </head>
   <body>
  
      <form action="savepage.jsp?page=nat&slnumber=<%=slnumber%>" method="post" onsubmit="return validateNat()">
         <p class="style1" align="center"> NAT Configuration</p>
		  <input id="natrwcnt" name="natrwcnt" value="1" hidden="" type="text">
         <table id="WiZConf1" align="center">
            <tbody>
               <tr>
                  <th colspan="7"> NAT Configuration</th>
               </tr>
            </tbody>
         </table>
         <table id="WiZConf" align="center">
            <thead>
               <tr>
                  <th> select</th>
                  <th> S No</th>
                  <th> Inside Interface</th>
                  <th> Source IP</th>
                  <th> Netmask</th>
                  <th> Outside Interface</th>
                  <th> Action</th>
               </tr>
            </thead>
            <tbody>
			<% 
            	   for(int j=0;j<natnumarr.size();j++)
            	   {
            		   JSONObject natobj = natnumarr.getJSONObject(j);
                  String insintf = natobj.getString("natInsideif")==null? "":natobj.getString("natInsideif");
                  String sourceIP = natobj.getString("sourceIP")==null? "":natobj.getString("sourceIP");
                  String sourceSubnet = natobj.getString("sourceSubnet")==null? "":natobj.getString("sourceSubnet");
                  String outintf = natobj.getString("natOutsideif")==null? "":natobj.getString("natOutsideif");
                  String natAction = natobj.getString("natAction")==null? "":natobj.getString("natAction");
                     %>
                   <script type="text/javascript">
	 				 addRow('WiZConf','<%=product_type%>');
	  				 addNatData('<%=(j+1)%>','<%=insintf%>','<%=sourceIP%>','<%=sourceSubnet%>','<%=outintf%>','<%=natAction%>');
	 			 </script>
				   <%}%>
            </tbody>
         </table> 
         <div align="center"> <input class="button" id="add" value="Add" onclick="addRow('WiZConf','<%=product_type%>')" type="button"> <input class="button" id="delete" value="Delete" onclick="deleteRow('WiZConf')" type="button"> <input type="submit" value="Submit" class="button"> </div>
      </form>	 
	  <%
   	if(errorstr != null && errorstr.trim().length() > 0)
			{%>
		     <script>
			 showErrorMsg('<%=errorstr%>');
			 </script>
			<%}
	  %>
   </body>
</html>