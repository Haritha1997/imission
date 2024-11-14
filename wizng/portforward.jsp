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
   JSONObject pfw_configobj = null;
   JSONObject pfw_table = null;
   JSONArray  pfwnumarr = null;
   BufferedReader jsonfile = null;   
   		String slnumber=request.getParameter("slnumber");
		String errorstr = request.getParameter("error");
   String product_type = "";
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
   		nat_configobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").getJSONObject("NATCONFIG");
   		pfw_configobj=  nat_configobj.getJSONObject("PORTFW");
   		pfw_table = pfw_configobj.getJSONObject("TABLE");
   		String name =(String)pfw_table.get("NAME");
   		pfwnumarr = pfw_table.getJSONArray("arr")==null ? new JSONArray(): pfw_table.getJSONArray("arr");
		
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

		.page {
			display: none;
			padding: 0 0.5em;
		}

		.page h1 {
			font-size: 2em;
			line-height: 1em;
			margin-top: 1.1em;
			font-weight: bold;
		}

		.page p {
			font-size: 1.5em;
			line-height: 1.275em;
			margin-top: 0.15em;
		}

		.loading p {
			font-size: 1.5em;
			line-height: 1.275em;
			margin-top: 0.15em;
		}

		#loading {
			display: none;
			position: absolute;
			top: 0;
			left: 0;
			z-index: 100;
			width: 100vw;
			height: 100vh;
			background-color: rgba(192, 192, 192, 0.5);
			background-image: url("js/loader.gif ");
			background-repeat: no-repeat;
			background-position: center;
			transition-duration: 10s;
		}
	   </style>
      <script type="text/javascript">
	  
		var txtBox1 = new Array("SrNo", "Port1", "Port2", "InsIP");

		function chkIPV4() {
			var altmsg = "";
			for (x = 0; x < 3; x++) {
				if (x == 0) {
					var obj = document.getElementById(txtBox1[x]);
					var val = obj.value.trim();
					var name = obj.name;
					if (!isNumber(val) || parseInt(val) < 1 || parseInt(val) > 25) {
						obj.style.outline = "thin solid red";
						obj.title = "Invalid " + name;
						altmsg += name + " is not Valid \n";
					} else {
						obj.style.outline = "initial";
						obj.title = "";
					}
				} else if (x > 0) {
					var obj1 = document.getElementById(txtBox1[x]);
					var val1 = obj1.value;
					var name1 = obj1.name;
					if (!isNumber(val1) || (parseInt(val1) < 0 || parseInt(val1) > 65535)) {
					obj1.style.outline = "thin solid red";
						obj1.title = "Invalid " + name;
						altmsg += name1 + " is not Valid \n";
					} else {
						obj1.style.outline = "initial";
						obj1.title = "";
					}
				}
			}
			for (x = 3; x < txtBox1.length; x++) {
				var obj = document.getElementById(txtBox1[x]);
				var val = obj.value.trim();
				var name = obj.name;
				var ret = validateIP(txtBox1[x], true, 'Inside IP');
				if (!ret) {
					if (val == "") altmsg += "Inside IP should not be empty.\n";
					else altmsg += "Invalid IP (" + val + ").\n";
				}
			}
			if (altmsg == "") return true;
			else {
				alert(altmsg);
				return false;
			}
		}

		function chkFunc() {
			return chkIPV4();
		}

		function isNumber(n) {
			return /^[0-9]+$/.test(n);
		}

		function validateIP(id, checkempty, name) {
			var ipele = document.getElementById(id);
			if (ipele.readOnly == true) {
			ipele.style.outline = "initial";
			ipele.title = "";
			return true;
		}
			var ipformat = /^(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)$/;
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
			if ((keyCode == 46 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode >= 48 && keyCode <= 57)) {
				return true;
			}
			return false;
		}

		function showSpinner() {
			setVisible('#loading', true);
			setTimeout(closeSpinner, 8000);
		}

		function setVisible(selector, visible) {
			document.querySelector(selector).style.display = visible ? 'block' : 'none';
		}

		function closeSpinner() {
			document.getElementById('loading').style.display = 'none';
		}	
		function getRowDetails(e)
		{
			if(IPv4AddressKeyOnly(e))
			{
				var rownum = document.getElementById("SrNo").value;
				var slatab = document.getElementById("WiZConf");
				var rows = slatab.rows;
				if(rownum < 26)
				{
					var row = rows[rownum];
					document.getElementById("Proto").value = row.cells[1].innerHTML;
					document.getElementById("InsIP").value = row.cells[2].innerHTML;			
					document.getElementById("Port1").value = row.cells[3].innerHTML;
					document.getElementById("FwdIntf").value = row.cells[4].innerHTML;
					document.getElementById("Port2").value = row.cells[5].innerHTML;
					document.getElementById("Status").value = row.cells[6].innerHTML;
				}
			}
		}
		function showErrorMsg(errormsg)
		{
			alert(errormsg);
		}
	  </script>
   </head>
   <body>
      <form name="f1" action="savepage.jsp?page=portforward&slnumber=<%=slnumber%>" method="post" onsubmit="return chkFunc()">
         <p class="style1" align="center">Port Forwarding</p>
         <table id="WiZConf" width="760" align="center">
            <tbody>
               <tr>
                  <th style="min-width:10%">Sr. No.</th>
                  <th style="min-width:12%">Protocol</th>
                  <th style="min-width:16%">Inside IP</th>
                  <th style="min-width:12%">Port</th>
                  <th style="min-width:16%">Forward Interface</th>
                  <th style="min-width:12%">Port</th>
                  <th style="min-width:12%">Status</th>
               </tr>
              <% 
               	Hashtable <String,JSONObject> pfwindx = new Hashtable<String,JSONObject>();
				
            	   for(int j=0;j<pfwnumarr.size();j++)
            	   {
            		   JSONObject pwfobj = pfwnumarr.getJSONObject(j);
            		   pfwindx.put(pwfobj.getString("sl"), pwfobj);
            	   }
            	   for(int i=1;i<=25;i++) {
					   boolean add = false;
            		  if(pfwindx.containsKey(i+""))
            		  {
            			  JSONObject pwfobj =   pfwindx.get(i+"");
						  if(!pwfobj.getString("status").equals("Delete"))
						  {
							  add = true;
               %>
               <tr>
                  <td><%=pwfobj.getString("sl")==null?"":pwfobj.getString("sl")%></td>
                  <td><%=pwfobj.getString("Protocoltype")==null?"":pwfobj.getString("Protocoltype")%></td>
                  <td><%=pwfobj.getString("insideIP")==null?"":pwfobj.getString("insideIP")%></td>
                  <td><%=pwfobj.getString("insidePortnumber")==null?"":pwfobj.getString("insidePortnumber")%></td>
                  <td><%=pwfobj.getString("FwdInterface")==null?"":pwfobj.getString("FwdInterface")%></td>
                  <td><%=pwfobj.getString("FwdPortnumber")==null?"":pwfobj.getString("FwdPortnumber")%></td>
                  <td><%=pwfobj.getString("status")==null?"":pwfobj.getString("status")%></td>
                  
               </tr>
					  <%}
			    }if(!add){%>
            		  <tr>
                  <td><%=i%></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
               </tr>  
            	   <%}}%>
             
               <tr>
                  <td colspan="8"><strong>Edit Entry</strong></td>
               </tr>
               <tr>
                  <td><input class="text" bindto="SrNo" name="SrNo" type="text" id="SrNo" size="2" maxlength="2" onkeyup="return getRowDetails(event)"></td>
                  <td>
                     <select name="Protocol" id="Proto">
                        <option value="No Change" selected="">No Change</option>
                        <option value="TCP">TCP</option>
                        <option value="UDP">UDP</option>
                     </select>
                  </td>
                  <td><input class="text" name="Inside_IP" type="text" id="InsIP" size="15" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)"></td>
                  <td><input class="text" name="InsPort" type="text" id="Port1" size="3" maxlength="5" onkeypress="return IPv4AddressKeyOnly(event)"></td>
                  <td>
                     <select name="FwdIntf" id="FwdIntf">
                        <option value="No Change" selected="">No Change</option>
                        <option value="Cellular">Cellular</option>
                        <option value="Loopback">Loopback</option>
                        <%if(product_type.equals("3LAN-1WAN"))
                        {%>
                          <option value="Eth1">Eth1</option>
                          <option value="Dialer">Dialer</option>
                       <% } 
                        %>
                     </select>
                  </td>
                  <td><input class="text" name="FwdPort" type="text" id="Port2" size="3" maxlength="5" onkeypress="return IPv4AddressKeyOnly(event)"></td>
                  <td>
                     <select name="Status" id="Status">
                        <option value="No Change" selected="">No Change</option>
                        <option value="Enable">Enable</option>
                        <option value="Disable">Disable</option>
                        <option value="Delete">Delete</option>
                     </select>
                  </td>
               </tr>
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

