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
   JSONObject sla_configobj = null;
   JSONObject sla_table = null;
   JSONArray slanumarr = null;
   String product_type = "";
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
		JSONObject prodtypeobj = wizjsonnode.getJSONObject("SYSTEMCONTROL").getJSONObject("PRODUCTTYPE");
   		product_type = prodtypeobj.containsKey("OldProductType")? prodtypeobj.getString("OldProductType") :prodtypeobj.getString("ProductType");
   		
   		//System.out.print(wizjsonnode);
   		sla_configobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").getJSONObject("IPSLA");
   		sla_table = sla_configobj.getJSONObject("TABLE");
   		String name =(String)sla_table.get("NAME");
   		slanumarr = sla_table.getJSONArray("arr")==null ? new JSONArray(): sla_table.getJSONArray("arr");
		
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
      <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
      <meta name="GENERATOR" content="Microsoft FrontPage 4.0">
      <meta name="ProgId" content="FrontPag.Editor.Documet">
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
	height: 24px;
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
	var txtBox1 = new Array("SrNo", "freq", "DesIP", "srcintf", "Status");

	function chkFunc() {
		return chkIPV4();
	}

	function chkIPV4() {
		var altmsg = "";
		for (x = 0; x <2; x++) {
			if (x == 0) {
				var obj = document.getElementById(txtBox1[x]);
				var val = obj.value.trim();
				var name = obj.name;
				if (isNaN(parseInt(val)) || parseInt(val) <1 || parseInt(val)> 5) {
					obj.style.outline = "thin solid red";
					obj.title = "Invalid " + name;
					altmsg += name + " is not Valid \n";
				} else {
					obj.style.outline = "initial";
					obj.title = "";
				}
			} else if (x == 1) {
				var obj1 = document.getElementById(txtBox1[x]);
				var val1 = obj1.value;
				var name1 = obj1.name;
				if ((parseInt(val1) <5 || parseInt(val1)> 604800)) {
					obj1.style.outline = "thin solid red";
					obj1.title = "Invalid " + name;
					altmsg += name1 + " is not Valid. " + name1 + " should be in the range 5 to 604800 \n";
				} else {
					obj1.style.outline = "initial";
					obj1.title = "";
				}
			}
		}
		for (x = 2; x <txtBox1.length; x++) {
			var obj = document.getElementById(txtBox1[x]);
			var val = obj.value.trim();
			var name = obj.name;
			if (x == 2) {
				var ret = validateIP(txtBox1[x], true, 'Inside IP');
				if (ret == false) {
					altmsg += name + " is not Valid \n";
				}
			} else if (x == 3) {
				if (val == 0) altmsg += "Source Interface Should not be empty \n";
			} else if (x == 4) {
				if (val == 0) altmsg += name + " Should not be empty \n";
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
		var ipformat = /^(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
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

	function isNumber(n) {
		return /^-?[\d.]+(?:e-?\d+)?$/.test(n);
	}

	function IPv4AddressKeyOnly(e) {
		var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
		if ((keyCode == 46 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode>= 48 && keyCode <= 57)) {
			return true;
		}
		return false;
		}
	function getRowDetails(e)
	{
			var rownum = document.getElementById("SrNo").value;
			var slatab = document.getElementById("WiZConf");
			var rows = slatab.rows;
			if(rownum < 6)
			{
				var row = rows[rownum];
				document.getElementById("DesIP").value = row.cells[1].innerHTML;
				document.getElementById("srcintf").value = row.cells[2].innerHTML;
				document.getElementById("freq").value = row.cells[3].innerHTML;
				document.getElementById("Status").value = row.cells[4].innerHTML;
			}
	}
	function showErrorMsg(errormsg)
	{
	alert(errormsg);
	}
	 </script>
   </head>
   <body>
      <form name="f1" action="savepage.jsp?page=sla&slnumber=<%=slnumber%>" method="post" onsubmit="return chkFunc()">
         <p align="center" class="style1"> SLA Configuration</p>
         <table id="WiZConf" align="center" width="760">
            <tbody>
               <tr>
                  <th style="min-width:10%">Sr. No.</th>
                  <th style="min-width:16%">Destination IP</th>
                  <th style="min-width:14%">Source Interface</th>
                  <th style="min-width:12%">Frequency(Sec)</th>
                  <th style="min-width:12%">Status</th>
               </tr>
               <% 
               	Hashtable <String,JSONObject> slaindhs = new Hashtable<String,JSONObject>();
            	   for(int j=0;j<slanumarr.size();j++)
            	   {
            		   JSONObject slaobj = slanumarr.getJSONObject(j);
            		   slaindhs.put(slaobj.getString("sl"), slaobj);
            	   }
            	   for(int i=1;i<=5;i++) {
            		  if(slaindhs.containsKey(i+""))
            		  {
            			  JSONObject slaobj =   slaindhs.get(i+"");
               %>
               <tr>
                  <td><%=slaobj.getString("sl")==null? "" : slaobj.getString("sl") %></td>
                  <td><%=slaobj.getString("dstIP")==null? "" : slaobj.getString("dstIP") %></td>
                  <td><%=slaobj.getString("interface")==null? "" : slaobj.getString("interface") %></td>
                  <td><%=slaobj.getString("frequency")==null? "" : slaobj.getString("frequency") %></td>
                  <td><%=slaobj.getString("status")==null? "" : slaobj.getString("status") %></td>
               </tr>
               <%}else{%>
            		  <tr>
                  <td><%=i%></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
               </tr>  
            	   <%}}%>
               <tr>
                  <td colspan="5"><strong>Edit Entry</strong></td>
               </tr>
               <tr>
                  <td><input class="text" bindto="SrNo" name="SrNo" type="text" id="SrNo" size="1" maxlength="1" onkeyup="return getRowDetails(event)"></td>
                  <td><input class="text" name="Destination_IP" type="text" id="DesIP" size="15" maxlength="16" onkeypress="return IPv4AddressKeyOnly(event)"></td>
                  <td>
                     <select name="src_Interface" id="srcintf">
                        <option value="No Change" selected="">No Change</option>
                        <option value="Eth0">Eth0</option>
                        <option value="Loopback">Loopback</option>
                        <%if(product_type.equals("3LAN-1WAN")) {%><option value="Eth1">Eth1</option><%}%>
                     </select>
                  </td>
                  <td><input class="text" name="Frequency" type="text" id="freq" size="6" maxlength="12" onkeypress="return IPv4AddressKeyOnly(event)"></td>
                  <td>
                     <select name="Status" id="Status">
                        <option value="No Change" selected="">No Change</option>
                        <option value="Enable">Enable</option>
                        <option value="Disable">Disable</option>
                     </select>
                  </td>
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
   </body>
</html>