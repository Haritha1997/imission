<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject dhcpobj = null;
   BufferedReader jsonfile = null;   
   String activation = "";
   String poolname = "";
   String networkip = "";
   String subnet = "";
   String defaultgw = "";
   String esiprange = "";
   String eeiprange = "";
   String domainnme = "";
   String primdns = "";
   String secdns = "";
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
   		dhcpobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("DHCP");
   		if(dhcpobj != null)
   			activation = dhcpobj.getString("Activation")==null?"":dhcpobj.getString("Activation");
   			poolname = dhcpobj.getString("PoolName")==null?"":dhcpobj.getString("PoolName");
   			networkip = dhcpobj.getString("NetworkIP")==null?"":dhcpobj.getString("NetworkIP");
   			subnet = dhcpobj.getString("Netmask")==null?"":dhcpobj.getString("Netmask");
   		    defaultgw = dhcpobj.getString("GatewayIP")==null?"":dhcpobj.getString("GatewayIP");
   		    esiprange = dhcpobj.getString("StartIP")==null?"":dhcpobj.getString("StartIP");
			//System.out.println("Start IP RAnge in DHCP is:"+esiprange);
   		    eeiprange = dhcpobj.getString("EndIP")==null?"":dhcpobj.getString("EndIP");
			//System.out.println("End IP RAnge in DHCP is:"+eeiprange);
   		    domainnme = dhcpobj.getString("DomainName")==null?"":dhcpobj.getString("DomainName");
   		    primdns = dhcpobj.getString("PrimaryDNS")==null?"":dhcpobj.getString("PrimaryDNS");
   		    secdns = dhcpobj.getString("SecondaryDNS")==null?"":dhcpobj.getString("SecondaryDNS");
			if(poolname.startsWith("0"))
			{
				poolname="";
			}
			if(networkip.startsWith("0"))
			{
				networkip="";
			}
			if(subnet.startsWith("0"))
			{
				subnet="";
			}
			if(defaultgw.startsWith("0"))
			{
				defaultgw="";
			}
			if(esiprange.startsWith("0"))
			{
				esiprange="";
			}
			if(eeiprange.startsWith("0"))
			{
				eeiprange="";
			}
			if(domainnme.startsWith("0"))
			{
				domainnme="";
			}
			if(primdns.startsWith("0"))
			{
				primdns="";
			}
			if(secdns.equals("0.0.0.0"))
			{
				secdns="";
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
	width: 520px;
}

#WiZConf td,
#WiZConf th {
	border: 2px solid #ddd;
	padding: 6px;
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

.text {
	background: white;
	border: 2px Solid #DDD;
	border-radius: 5px;
	box-shadow: 1 1 5px #DDD inset;
	color: #000;
	height: 25px;
	width: 140px;
}

#WiZConf1 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 520px;
}

#WiZConf1 td,
#WiZConf1 th {
	border: 2px solid #ddd;
	padding: 8px;
}

#WiZConf1 tr:nth-child(even) {
	background-color: #f2f2f2;
}

#WiZConf1 tr:hover {
	background-color: #d3f2ef;
}

#WiZConf1 th {
	padding-top: 12px;
	padding-bottom: 12px;
	text-align: center;
	background-color: #5798B4;
	color: white;
}

</style>
<script type = "text/javascript">
	var txtBox1 = new Array("poolname", "dsnwip", "dsmask", "dsgw","excludestartip", "excludeendip", "dsprimdns", "dssecdns");
    var txtBox2 = new Array("Pool Name", "Network IP", "SubnetMask", "Gateway","Exclude Start IP", "Exclude End IP", "Primary DNS", "Secondary DNS");

function chkFunc() {
	var altmsg = "";
	var altmsg = "";
	var actvnobj=document.getElementById("activation");
	var activation = actvnobj.options[actvnobj.selectedIndex].text;
	var poolname=document.getElementById("poolname");
	var ntwrkip=document.getElementById("dsnwip");
	var sbntmsk=document.getElementById("dsmask");
	var startiprangeobj=document.getElementById("excludestartip");
	var startip=startiprangeobj.value;
	var endiprangeobj=document.getElementById("excludeendip");
	var endip=endiprangeobj.value;
	var startiparr=startip.split('.');
	var endiparr=endip.split('.');
	var prmrydnsobj=document.getElementById("dsprimdns");
	var primarydns=prmrydnsobj.value;
	var scndrydnsobj=document.getElementById("dssecdns");
	var secondarydns=scndrydnsobj.value;
	if(activation=="No Change")
	{
		altmsg +="Activation should be enabled or disabled\n";
		poolname.value="";
		ntwrkip.value="";
		sbntmsk.value="";
	}
	else if(activation=="Enable" || activation=="Disable")
	{
	for (var x = 0; x < txtBox1.length; x++) {
		var valid = false;
		var ip4add = document.getElementById(txtBox1[x]).value;
		if ((txtBox1[x] == "dsnwip") || (txtBox1[x] == "dsgw") || (txtBox1[x] == "excludestartip") || (txtBox1[x] == "excludeendip") || (txtBox1[x] == "dsprimdns") || (txtBox1[x] == "dssecdns")) {
			valid = validateIP(txtBox1[x], true, txtBox1[x]);
		} else if (txtBox1[x] == "dsmask") {
			valid = validateSubnetMask(txtBox1[x], true, txtBox1[x]);
		} else if (txtBox1[x] == "poolname") {
			var poolobj = document.getElementById("poolname");
			if (poolobj.value.trim() == "") {
				poolobj.style.outline = "thin solid red";
				poolobj.title = "Invalid " + name;
				valid = false;
			} else {
				valid = true;
				poolobj.style.outline = "initial";
				poolobj.title = "";
			}
		}
		if (!valid) {
			if (ip4add == "") {
				if ((x == 0) || (x == 1) || (x == 2)) altmsg += txtBox2[x] + " should not be empty.\n";
			} else altmsg += "Invalid " + txtBox2[x] + " (" + ip4add + ").\n";
		}
	 }  
	    for(k=0;k<4;k++)
		{
			startiparr[k]=parseInt(startiparr[k]);
			endiparr[k]=parseInt(endiparr[k]);
		}
	    if((startiparr[0]!=0) && (endiparr[0]!=0))
		{
		for(var i=0;i<4;i++)
		 {
			if(startiparr[0] > endiparr[0])
			{
				startiprangeobj.style.outline = "thin solid red";
				altmsg +="Start IP Range Should not be greater than End IP Range\n";
				break;
			}
		    else if(endiparr[i] > startiparr[i] )
			{
				break;
			}
			else if(startiparr[i] > endiparr[i])
			{
			    startiprangeobj.style.outline = "thin solid red";
				altmsg +="Start IP Range Should not be greater than End IP Range\n";
				break;
			}
			
		 }
		}
        if((startip=="") && (!endip==""))
        {
			startiprangeobj.style.outline = "thin solid red";
			altmsg +="Must Create Exclude Start IP Range Before Creating Exclude End IP Range\n";
		}
		if((primarydns=="") && (!secondarydns==""))
        {
			prmrydnsobj.style.outline = "thin solid red";
			altmsg +="Must Create Primary DNS Before Creating Secondary DNS\n";
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
	if (id == "dsnwip") {
		var ipformat = /^(2[0-2][0-3]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
	} else {
		var ipformat = /^(2[0-2][0-3]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[1]?[0-9][0-9]|[1-99]?)$/;
	}
	var ipaddr = ipele.value;
	if (ipaddr == "") {
		if (checkempty) {
			if (id == "dsnwip") {
				ipele.style.outline = "thin solid red";
				ipele.title = name + " should not be empty";
				return false;
			}
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

function NameKeyOnly(e) {
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	if ((keyCode == 46 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode >= 48 && keyCode <= 57) || (keyCode >= 97 && keyCode <= 122) || (keyCode >= 65 && keyCode <= 90)) {
		return true;
	}
	return false;
}
function showErrorMsg(errormsg)
{
	alert(errormsg);
} 
</script>
<script src="js/timeout.js " type="text/javascript"></script>
</head>
<body>
   <form action="savepage.jsp?page=dhcpserver&slnumber=<%=slnumber%>" method="post" onsubmit="return chkFunc()">
      <br>
      <p class="style1" align="center">DHCP-Server Configuration</p>
      <table id="WiZConf" align="center">
         <tbody>
            <tr>
               <th width="230">Parameters</th>
               <th width="290">Current Config</th>
               <th width="200">Configuration</th>
            </tr>
            <tr>
               <td>Activation</td>
               <td><%=activation%></td>
               <td>
                  <select name="activation" id="activation" class="text">
                     <option value="No Change" <%if(activation.equals("No Change")){%>selected<%}%>>No Change</option>
                     <option value="Enable" <%if(activation.equals("Enable")){%>selected<%}%>>Enable</option>
                     <option value="Disable" <%if(activation.equals("Disable")){%>selected<%}%>>Disable</option>
                  </select>
               </td>
            </tr>
            <tr>
               <td>Pool Name</td>
               <td><%=poolname%></td>
               <td width="120px"><input type="text" class="text" id="poolname" maxlength="36" name="poolname" onkeypress="return NameKeyOnly(event)"></td>
            </tr>
            <tr>
               <td>Network IP Address</td>
               <td><%=networkip%></td>
               <td width="120px"><input type="text"  class="text" size="12" maxlength="15" id="dsnwip" name="dsnwip" onkeypress="return IPv4AddressKeyOnly(event)"></td>
            </tr>
            <tr>
               <td>Subnet Mask Address</td>
               <td><%=subnet%></td>
               <td width="120px"><input type="text"  class="text"  size="12" maxlength="15" id="dsmask" name="dsmask" onkeypress="return IPv4AddressKeyOnly(event)"></td>
            </tr>
            <tr>
               <td>Default Gateway</td>
               <td><%=defaultgw%></td>
               <td width="120px"><input type="text"  class="text" size="12" maxlength="15" id="dsgw" name="dsgw" onkeypress="return IPv4AddressKeyOnly(event)"></td>
            </tr>
            <tr>
               <td>Exclude Start IP Range</td>
               <td><%=esiprange%></td>
               <td width="120px"><input type="text"  class="text" size="12" maxlength="15" id="excludestartip" name="excludestartip" onkeypress="return IPv4AddressKeyOnly(event)"></td>
            </tr>
            <tr>
               <td>Exclude End IP Range</td>
               <td><%=eeiprange%></td>
               <td width="120px"><input type="text"  class="text" size="12" maxlength="15" id="excludeendip" name="excludeendip" onkeypress="return IPv4AddressKeyOnly(event)"></td>
            </tr>
            <tr>
               <td>Domain Name</td>
               <td><%=domainnme%></td>
               <td width="120px"><input name="dsdomain"  id="dsdomain" maxlength="36" class="text" onkeypress="return NameKeyOnly(event)" type="text"></td>
            </tr>
            <tr>
               <td>Primary DNS</td>
               <td><%=primdns%></td>
               <td width="120px"><input type="text"  class="text" size="12" maxlength="15" id="dsprimdns" name="dsprimdns" onkeypress="return IPv4AddressKeyOnly(event)"></td>
            </tr>
            <tr>
               <td>Secondary DNS</td>
               <td><%=secdns%></td>
               <td width="120px"><input type="text" class="text" size="12"  maxlength="15" id="dssecdns" name="dssecdns" onkeypress="return IPv4AddressKeyOnly(event)"></td>
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