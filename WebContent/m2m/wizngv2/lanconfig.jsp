<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="org.apache.commons.net.util.SubnetUtils"%>
<%@page import="java.net.NetworkInterface"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject lanobj = null;
   JSONObject landhcpobj = null;
   JSONObject dnsdhcpobj = null;
   JSONArray  laniparr = null;
   JSONArray  dnsarr = null;
   JSONArray dnsancarr = null;
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
   		
			lanobj =  wizjsonnode.getJSONObject("network").getJSONObject("interface:lan");
			landhcpobj = wizjsonnode.getJSONObject("dhcp").getJSONObject("dhcp:lan");
			dnsdhcpobj =  wizjsonnode.getJSONObject("dhcp").getJSONObject("dnsmasq:dnsmasq");
			if(lanobj != null)
			{
				if(lanobj.containsKey("ipaddr"))
				laniparr = lanobj.getJSONArray("ipaddr");
				if(lanobj.containsKey("dns"))
				dnsarr   = lanobj.getJSONArray("dns");
			}
			if(landhcpobj != null)
			{
				if(landhcpobj.containsKey("ancdns"))
					dnsancarr = landhcpobj.getJSONArray("ancdns");	
			}
			
			if(laniparr == null)
				laniparr = new JSONArray();
			if(dnsarr == null)
				dnsarr = new JSONArray();
			if(dnsancarr == null)
				dnsancarr = new JSONArray();
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
   String ipv6assign_len = lanobj==null?"disable":lanobj.get("ip6asgn")==null?"disable":lanobj.getString("ip6asgn");
%>
<html>
<head>
<link href="css/fontawesome.css" rel="stylesheet">
<link href="css/solid.css" rel="stylesheet">
<link href="css/v4-shims.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="css/style.css">
<script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/lan.js"></script>
<script type="text/javascript">
function showErrorMsg(errormsg)
{
	alert(errormsg.replace("and", "&"));
}
var iprows = 1;
var customdns = 4;
var ancdnsservers = 4;

function validateLanIpConfig() {
	var alertmsg = "";
	var table = document.getElementById("ipconfig");
	var rows = table.rows;
	var valid;
	try
	{
		const laniparrobj = [];
		const lannmobj = [];
		const lannetwk=[];
		const lanbdcast=[];
		var curnetwork = "";
		var curbdcast="";
		for (var i = 2; i < rows.length; i++) {
			
			var cols = rows[i].cells;
			var ipaddress = cols[1].childNodes[0].childNodes[0];
			var subnet = cols[1].childNodes[2].childNodes[0];
			valid = validateIPOnly(ipaddress.id, true, "IPv4 Address");
			var ipvalid = valid;
			if (!ipvalid) {
				alertmsg += (i - 1);
				if (i == 2) alertmsg += "st";
				else if (i == 3) alertmsg += "nd";
				else if (i == 4) alertmsg += "rd";
				else alertmsg += "th";
				if (ipaddress.value.trim() == "") 
					alertmsg += " IPv4 Address should not be empty\n";
				else 
					alertmsg += " IPv4 Address is not valid\n";
			}
			valid = validateSubnetMask(subnet.id, true, "Subnet Address");
			var netmaskvalid = valid;
			if (!netmaskvalid) {
				alertmsg += (i - 1);
				if (i == 2) alertmsg += "st";
				else if (i == 3) alertmsg += "nd";
				else if (i == 4) alertmsg += "rd";
				else alertmsg += "th";
				if (subnet.value.trim() == "") alertmsg += " IPv4 Subnet Address should not be empty\n";
				else alertmsg += " IPv4 Subnet Address is not valid\n";
			}
			valid = false;
			if(ipvalid && netmaskvalid)
			{			
				var network = getNetwork(ipaddress.value,subnet.value);
				var broadcast = getBroadcast(network,subnet.value);
				if(ipaddress.value == network)
				{
					alertmsg += (i - 1);
					if (i == 2) alertmsg += "st";
					else if (i == 3) alertmsg += "nd";
					else if (i == 4) alertmsg += "rd";
					else alertmsg += "th";
					alertmsg += " IPv4 Address "+ipaddress.value+" should not be Network\n";
					ipaddress.style.outline = "thin solid red";
					ipaddress.title =  "IPv4 Address should not be Network";
				}
				else if(ipaddress.value == broadcast)
				{
					alertmsg += (i - 1);
					if (i == 2) alertmsg += "st";
					else if (i == 3) alertmsg += "nd";
					else if (i == 4) alertmsg += "rd";
					else alertmsg += "th";
					alertmsg += " IPv4 Address "+ipaddress.value+" should not be Broadcast\n";
					ipaddress.style.outline = "thin solid red";
					ipaddress.title =  "IPv4 Address should not be Broadcast";
				}
				else
				{
					valid = true;
					lannetwk.push(network);
					lanbdcast.push(broadcast);
					curnetwork = network;
					curbdcast = broadcast;
				}
			}
			
			if(valid == true)
			{
				for(var l=0;l<laniparrobj.length;l++)
				{
					//var network1 = getNetwork(laniparrobj[l].value,lannmobj[l].value);
					//var broadcast1 = getBroadcast(network1,lannmobj[l].value);
					var network1 = lannetwk[l];
					var broadcast1 = lanbdcast[l];
					if((isGraterOrEquals(curnetwork,network1) && !isGraterOrEquals(curnetwork,broadcast1)) || (isGraterOrEquals(network1, curnetwork) && !isGraterOrEquals(network1,curbdcast)))
					{
						alertmsg += ipaddress.value+" overlaps with "+laniparrobj[l].value+".\n";
						
						ipaddress.style.outline = "thin solid red";
						laniparrobj[l].style.outline = "thin solid red";
						ipaddress.title = "overlaps with "+laniparrobj[l].value;
						laniparrobj[l].title = "overlaps with "+ipaddress.value;
						break;
					}
				}
				laniparrobj.push(ipaddress);
				lannmobj.push(subnet);
			}
	}
	var ipgw = document.getElementById("ipv4gw");
	valid = validateIPOnly("ipv4gw", false, "IPv4 Gateway");
	if (!valid) {
		if (ipgw.value.trim() == "") alertmsg += "IPv4 Gateway should not be empty\n";
		else alertmsg += "IPv4 Gateway is not valid\n";
	}
	else if(ipgw.value.trim() != "")
	{
		var is_exists = false;
		var l=0;
		for(l=0;l<lannetwk.length;l++)
		{	
			if(lannetwk[l] == ipgw.value)
			{
				alertmsg += "IPv4 Gateway should not be the network "+lannetwk[l]+" of LAN IP Address "+laniparrobj[l].value+"\n";
				ipgw.style.outline = "thin solid red";
				ipgw.title = "IPv4 Gateway should not be the network "+lannetwk[l]+" of LAN IP Address "+laniparrobj[l].value+"\n";
				break;
			}
			else if(laniparrobj[l].value == ipgw.value)
			{
				alertmsg += "IPv4 Gateway should not be the LAN IP Address "+laniparrobj[l].value+"\n";
				ipgw.style.outline = "thin solid red";
				ipgw.title = "IPv4 Gateway should not be the LAN IP Address "+laniparrobj[l].value+"\n";
				break;
			}
			else if(lanbdcast[l] == ipgw.value)
			{
				alertmsg += "IPv4 Gateway should not be the Broadcast "+lanbdcast[l]+" of LAN IP Address "+laniparrobj[l].value+"\n";
				ipgw.style.outline = "thin solid red";
				ipgw.title = "IPv4 Gateway should not be the Broadcast "+lanbdcast[l]+" of LAN IP Address "+laniparrobj[l].value+"\n";
				break;
			}
			else if(lannmobj[l].value == ipgw.value)
			{
				alertmsg += "IPv4 Gateway should not be the LAN Subnet "+lannmobj[l].value+"\n";
				ipgw.style.outline = "thin solid red";
				ipgw.title = "IPv4 Gateway should not be the LAN Subnet "+lannmobj[l].value+"\n";
				break;
			}
			else if(laniparrobj[l].value == ipgw.value)
			{
				ipgw.title = "IPv4 Gateway should not be "+laniparrobj[l].value+" as this is LAN IP address\n";
				alertmsg += ipgw.title;
				ipgw.style.outline = "thin solid red";
				break;
			}
			else if(!is_exists && (isGraterOrEquals(ipgw.value,lannetwk[l]) && !isGraterOrEquals(ipgw.value,lanbdcast[l])))
				is_exists = true;

		}
		if(!is_exists && l == lannetwk.length)
		{
			ipgw.title = "IPv4 Gateway should be in the given LAN Networks\n";
			alertmsg += ipgw.title;
			ipgw.style.outline = "thin solid red";
		}
	}
	
	var ipbc = document.getElementById("ipv4bc");
	valid = validateIP("ipv4bc", false, "IPv4 Broadcast");
	if (!valid) {
		if (ipbc.value.trim() == "") alertmsg += "IPv4 Broadcast should not be empty\n";
		else alertmsg += "IPv4 Broadcast is not valid\n";
	}
	else if(ipbc.value.trim() != "")
	{
		var is_exists= false;
		for(var m=0;m<lannetwk.length;m++)
		{	
			if(lanbdcast[m] == ipbc.value)
			{
				is_exists = true;
				break;
			}
		}
		if(!is_exists)
		{
			ipbc.title = "IPv4 Broadcast Address should be one of the given LAN Broadcast Addresses\n";
			alertmsg += ipbc.title;
			ipbc.style.outline = "thin solid red";
		}
	}
	var mtu = document.getElementById("mtu");
	valid = validateRange("mtu", false, "MTU");
	if (!valid) {
		if (mtu.value.trim() == "") alertmsg += "MTU should not be empty\n";
		else alertmsg += "MTU is not valid\n";
	}
	var metric = document.getElementById("metric");
	valid = validateRange("metric", false, "Metric");
	if (!valid) {
		if (metric.value.trim() == "") alertmsg += "Metric should not be empty\n";
		else alertmsg += "Metric is not valid\n";
	}
	
	var ipconfigtable = document.getElementById("ipconfig1");
	var ipconfigrows = ipconfigtable.rows;
	var custom_dns_arr=[];
	for (var j = 4; j < ipconfigrows.length; j++) 
	{
		var ipcols = ipconfigrows[j].cells;
		var customdns = ipcols[1].childNodes[0].childNodes[0];
		valid = validatedualIP(customdns.id, false, "Custom DNS Server",false);
		if(!valid)
		{
			if (customdns.value.trim() == "") 
				alertmsg += "Custom DNS Server-" + (j - 3) + " should not be empty\n";
			else 
				alertmsg += "Custom DNS Server-" + (j - 3) + " is not valid\n";
		}
		else if(customdns.value.trim() != "") {
		if(valid)
		{
			for(ct=0;ct<custom_dns_arr.length;ct++)
			{
				if(custom_dns_arr[ct].value == customdns.value)
				{
					customdns.style.outline = "thin solid red";
					customdns.title="Duplicate Custom DNS Server "+customdns.value;
					custom_dns_arr[ct].style.outline = "thin solid red";
					custom_dns_arr[ct].title = customdns.title;
					alertmsg += customdns.title+"\n";
					break;
				}
			}
			if(ct==custom_dns_arr.length)
				custom_dns_arr.push(customdns);
		}
	}
	}
	 var ipv6addr = document.getElementById("ipv6adrs");
     valid = validateIPv6("ipv6adrs", false, "IPv6 Address",true);
     if (!valid) {
         if (ipv6addr.value.trim() == "") alertmsg += " IPv6 Address should not be empty\n";
         else alertmsg += " IPv6 Address is not valid\n";
     }
     var ipv6gateway = document.getElementById("ipv6gw");
     valid = validateIPv6("ipv6gw", false, "IPv6 Gateway");
     if (!valid) {
         if (ipv6gateway.value.trim() == "") alertmsg += "IPv6 Gateway should not be empty\n";
         else alertmsg += "IPv6 Gateway is not valid\n";
     }
     var leaseobj = document.getElementById("leasetime");
     var check_empty = true;
     var dhcpeble = document.getElementById("dhcpActvtn");
     if(!dhcpeble.checked)
    	 check_empty = false;
	var dhcpnetmask = document.getElementById("netmask");
	valid = validateSubnetMask("netmask", false, "IPv4 Netmask");
	if (!valid) {
	
		if (dhcpnetmask.value.trim() == "") alertmsg += "IPv4 Netmask should not be empty\n";
		else alertmsg += "IPv4 Netmask is not valid\n";
	}
	var ipv6aslength = document.getElementById("ipv6asl");
	var ipv6asshint = document.getElementById("ipv6agnthnt");
	if (ipv6aslength.value.trim() == "64") {
		if (ipv6asshint.value.trim() == "") {
			alertmsg += "IPv6 assignment hint should not be empty\n";
			ipv6asshint.style.outline = "thin solid red";
		}
	}
	else if(ipv6aslength.value.trim() == "custom")
	{
		valid = validOnshowLanComboBox('ipv6asgmnt','IPv6 assignment length','assl');
		if (!valid) {
		if (assl.value.trim() == "") 
			alertmsg += "IPv6 assignment length should not be empty\n ";
		else alertmsg += "IPv6 assignment length is not valid\n ";
		}
		if (ipv6asshint.value.trim() == "") {
			alertmsg += "IPv6 assignment hint should not be empty\n ";
			ipv6asshint.style.outline = "thin solid red ";
		}
	}
	
	//added these lines..........
	var ip6configtable = document.getElementById("dhcpserver");
	var ip6configrows = ip6configtable.rows;
	for (var j = 5; j < ip6configrows.length; j++) 
	{
		var ip6cols = ip6configrows[j].cells;
		var anndns = ip6cols[1].childNodes[0].childNodes[0];

		valid = validateIPOnly(anndns.id, false, "Announced DNS Servers");
		
		if (!valid) 
		{
		    valid=validateIPv6(anndns.id, false, "Announced DNS Servers",false);//new 
			if(!valid)//new
			{
				if (anndns.value.trim() == "") 
					alertmsg += "Announced DNS Server in row " + (j-7) + " should not be empty\n";
				else 
					alertmsg += "Announced DNS Server in row " + (j-7) + " is not valid\n";
			}
		
		}
	}
	//added upto here...........
	var valid = validateLeaseTime('leasetime',check_empty,'Lease Time');
	if(!valid)
	{
		leaseval = leaseobj.value.trim().toLowerCase();
		  if(leaseval == "")		
		  alertmsg += "Lease time should not be empty\n ";	
		  else if(!leaseval.includes("m") && !leaseval.includes("s") && !leaseval.includes("h"))
		  {
			  alertmsg += "Lease time is not valid..... Please enter units h or m after number\n ";
		  }
		  else if(leaseval.startsWith("h") || leaseval.startsWith("m") || leaseval.startsWith("s"))
		  {
			  alertmsg += "Lease time is not valid format...\n";
		  }
		  else if((leaseval.includes("h") && !leaseval.endsWith("h")) ||
				  (leaseval.includes("m") && !leaseval.endsWith("m")) || 
				  (leaseval.includes("s") && !leaseval.endsWith("s")))
		  {
			  alertmsg += "Lease time is not valid format...\n";
		  }
		  else
		  {
			  var lease = leaseval.replace("m","").replace("s","").replace("h",""); 
			  if(isNaN(lease))
				  alertmsg += "Lease time is not valid..... Please enter units h or m after number\n ";
			  else
				  alertmsg +="Lease time is not valid. Lease Time should not equal or exceed 1000 days\n "
				 
		  }
	  }
	  else
	  {
		  leaseobj.style.outline = "initial";
		  leaseobj.title = "";
	  }
	if (alertmsg.trim().length == 0) return true;
	else {
		alert(alertmsg);
		return false;
	}
	}
	catch(e)
	{
		alert(e);
	}
}



</script>
</head>

<body>

	<form action="savedetails.jsp?page=lanconfig&slnumber=<%=slnumber%>"  method="post" onsubmit="return validateLanIpConfig()">
	<br>
	<input type="hidden" id="laniprows" name="laniprows" value="1"/>
	<input type="hidden" id="dnsrows" name="dnsrows" value="4"/>
	<input type="hidden" id="dnsancrows" name="dnsancrows" value="4" />
	<p class="style5" align="center">LAN IP Configuration</p>
	<br>
	<table class="borderlesstab nobackground" id="WiZConf" style="width:400px;margin-bottom:0px;" align="center">
		<tbody>
			<tr style="padding:0px;margin:0px;">
				<td style="padding:0px;margin:0px;">
					<ul id="lanconfigdiv">
						<li><a class="casesense lanconfiguration" style="cursor:pointer;" id="hilightthis" onclick="showDivision('ipconfigpage',this)">IP Config</a></li>
						<li><a class="casesense lanconfiguration" style="cursor:pointer;" onclick="showDivision('dhcp_serverpage',this)" id="">DHCP Server</a></li>
					</ul>
				</td>
			</tr>
		</tbody>
	</table>
	<div id="ipconfigpage" style="margin: 0px; display: inline;" align="center">
		<table class="borderlesstab" id="ipconfig" style="width:400px;" align="center">
			<tbody>
				<tr>
					<th width="200">Parameters</th>
					<th width="200">Configuration</th>
				</tr>
				<tr>
					<td>MAC Address</td>
					<td style="position:relative; left:4px;"><%=lanobj == null?"":lanobj.get("macaddr")==null?"":lanobj.getString("macaddr")%></td>
				</tr>
				
			</tbody>
		</table>
		<table class="borderlesstab" style="width:400px;" id="ipconfig1" align="center">
			<tbody>
				<tr>
					<td width="200">IPv4 Gateway</td>
					<td width="200">
						<input type="text" name="ipv4gw" id="ipv4gw" value="<%=lanobj == null?"":lanobj.get("gateway")==null?"":lanobj.getString("gateway")%>" maxlength="256" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateIPOnly('ipv4gw',false,'IPv4 Gateway')">
					</td>
				</tr>
				<tr>
					<td width="200">IPv4 Broadcast</td>
					<td width="200">
						<input type="text" name="ipv4bc" id="ipv4bc" value="<%=lanobj == null?"":lanobj.get("broadcast")==null?"":lanobj.getString("broadcast")%>" maxlength="256" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateIP('ipv4bc',false,'IPv4 Broadcast')">
					</td>
				</tr>
				<tr>
					<td width="200">MTU</td>
					<td width="200">
						<input type="number" name="mtu" id="mtu" placeholder="1500" value="<%=lanobj == null?"":lanobj.get("mtu")==null?"":lanobj.getString("mtu")%>" min="1" max="9000" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('mtu',false,'MTU')">
					</td>
				</tr>
				<tr>
					<td width="200">Metric</td>
					<td width="200">
						<input type="number" name="metric" id="metric" placeholder="0" value="<%=lanobj == null?"":lanobj.get("metric")==null?"":lanobj.getString("metric")%>" min="1" max="255" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('metric',false,'Metric')">
					</td>
				</tr>
				
			</tbody>
		</table>
		<table class="borderlesstab" style="width:400px;" id="ipv6config" align="center">
			<tbody>
				<tr>
					<td>IPv6 assignment length</td>
					<td>
						<div>
							<select id="ipv6asl" name="ipv6asl" class="text" onchange="IPv6Assignment('ipv6asl','')">
								<option value="disable" <%if(ipv6assign_len.equalsIgnoreCase("disable")){%> selected <%}%> >disable</option>
								<option value="64" <%if(ipv6assign_len.equalsIgnoreCase("64")){%> selected <%}%>>64</option>
								<option value="custom"  <%if(!ipv6assign_len.equalsIgnoreCase("64")&&!ipv6assign_len.equalsIgnoreCase("disable")){%> selected <%}%>>custom</option>
							</select>
						</div>
						<%if(!ipv6assign_len.equalsIgnoreCase("64")&&!ipv6assign_len.equalsIgnoreCase("disable")){%>
							<input type="hidden" id="assl" name="assl" value="<%=ipv6assign_len%>">
						<%}else{%>
							<input type="hidden" id="assl" name="assl">
						<%}%>
						
						<div>
							<input style="display:none;" id="ipv6asgmnt" type="text" class="text" list="configurations" onkeypress="return IPV6avoidSpace(event)" onfocusout="validOnshowLanComboBox('ipv6asgmnt','IPv6 assignment length','assl')">
						</div>
					</td>
				</tr>
				<tr id="ipv6address">
					<td width="200">IPv6 Address</td>
					<td width="200">
					<input type="text" name="ipv6adrs" value="<%=lanobj == null?"":lanobj.get("ip6addr")==null?"":lanobj.getString("ip6addr") %>" id="ipv6adrs" maxlength="255" class="text" onkeypress="return IPV6avoidSpace(event)" onmouseover="setTitle(this)" onfocusout="validateIPv6('ipv6adrs','false','IPv6 Address','true')"> <!-- modified this line to add onmouseover -->
					</td>
				</tr>
				<tr id="ipv6gateway">
					<td width="200">IPv6 Gateway</td>
					<td width="200">
						<input type="text" name="ipv6gw" id="ipv6gw" value="<%=lanobj == null?"":lanobj.get("ip6gw")==null?"":lanobj.getString("ip6gw") %>" maxlength="256" class="text" onkeypress="return IPV6avoidSpace(event)" onmouseover="setTitle(this)" onfocusout="validateIPv6gateway('ipv6gw','false','IPv6 Gateway')">   <!-- modified this line to add onmouseover -->
					</td>
				</tr>
				<tr id="ipv6hint" style="display:none;">
					<td width="200">IPv6 assignment hint</td>
					<td width="200">
						<input type="text" name="ipv6agnthnt" id="ipv6agnthnt" value="<%=lanobj == null?"":lanobj.get("ip6hint")==null?"":lanobj.getString("ip6hint") %>" maxlength="256" class="text" onkeypress="return IPV6avoidSpace(event)" onfocusout="isEmpty('ipv6agnthnt','IPv6 assignment hint')">
					</td>
				</tr>
				<tr>
					<td width="200">ULA Prefix</td>
					<td width="200">
						<input type="text" name="ulapfx" id="ulapfx" value="<%=lanobj == null?"":lanobj.get("ulaprefix")==null?"":lanobj.getString("ulaprefix") %>" maxlength="256" class="text" onkeypress="return IPV6avoidSpace(event)" onmouseover="setTitle(this)" onfocusout="validateIPv6('ulapfx','false','ULA Prefix')"> <!-- modified this line to add onmouseover -->
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div id="dhcp_serverpage" style="margin: 0px; display: none;" align="center">
		<table class="borderlesstab" style="width:400px;" id="Dhcpserver" align="center">
			<tbody>
				<tr>
					<th width="200">Parameters</th>
					<th width="200">Configuration</th>
				</tr>
				<tr>
					<td>Activation</td>
					<td>
						<label class="switch" style="vertical-align:middle">
						<input type="checkbox" name="dhcpActvtn" id="dhcpActvtn" style="vertical-align:middle" <% if(landhcpobj.containsKey("ip4activation") && landhcpobj.getString("ip4activation").equals("1")) {%> checked <%}%>><span class="slider round"></span></label>
					</td>
				</tr>
				<tr>
					<td>Start</td>
					<td>
						<input type="number" name="start" id="start" value="<%=landhcpobj == null?"":landhcpobj.get("start")==null?"":landhcpobj.getString("start")%>" min="0" max="2147483647"  class="text" onkeypress="return avoidSpace(event)">
					</td>
				</tr>
				<tr>
					<td>Limit</td>
					<td>
						<input type="number" name="limit" id="limit" value="<%=landhcpobj == null?"":landhcpobj.get("limit")==null?"":landhcpobj.getString("limit")%>" min="1" max="2147483647" class="text" onkeypress="return avoidSpace(event)">
					</td>
				</tr>
				<tr>
					<td>Lease Time</td>
					<td>
						<input type="text" name="leasetime" id="leasetime" value="<%=landhcpobj == null?"":landhcpobj.get("leasetime")==null?"":landhcpobj.getString("leasetime")%>" placeholder="12h(or)m(or)s" maxlength="64" class="text" onkeypress="return avoidSpace(event)" onkeypress="return blockSpecialChar(event)"onfocusout="validateLeaseTime('leasetime',true,'Lease Time')">
					</td>
				</tr>
				<tr>
					<td title="Dynamically allocate DHCP addresses for clients. If disabled, only clients having static leases will be served.">Dynamic DHCP</td>
					<td>
						<label class="switch" style="vertical-align:middle">
							<input type="checkbox" name="dynamicdhcp" id="dynamicdhcp" style="vertical-align:middle"<%if(landhcpobj.containsKey("dynamicdhcp") && landhcpobj.getString("dynamicdhcp").equals("1")) {%> checked <%}%>><span class="slider round"></span></label>
					</td>
				</tr>
				<tr>
					<td title="Force DHCP on this network even if another server is detected.">Force</td>
					<td>
						<label class="switch" style="vertical-align:middle">
							<input type="checkbox" name="force" id="force" style="vertical-align:middle"<%if(landhcpobj.containsKey("force") && landhcpobj.getString("force").equals("1")) {%> checked <%}%>><span class="slider round"></span></label>
					</td>
				</tr>
				<tr>
					<td>DNS</td>
					<td>
					<%String dnsact=dnsdhcpobj.containsKey("noreslov")?dnsdhcpobj.getString("noreslov").equals("1")?"":"checked":"checked"; %>
						<label class="switch" style="vertical-align:middle">
						<input type="checkbox" name="dns" id="dns" style="vertical-align:middle" <%=dnsact%>><span class="slider round"></span></label>
					</td>
				</tr>
				<tr>
					<td title="Override the netmask sent to clients. Normally it is calculated from the subnet that is served.">IPv4 Netmask</td>
					<td>
						<input type="text" name="netmask" id="netmask" value="<%=landhcpobj == null?"":landhcpobj.get("netmask")==null?"":landhcpobj.getString("netmask")%>" maxlength="256" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateSubnetMask('netmask',false,'IPv4 Netmask')">
					</td>
				</tr>
				<!-- Added these lines -->
				<tr>
					<td width="200">IPv6 Settings</td>
					<td width="200">
						<label class="switch" style="vertical-align:middle">
							<input type="checkbox" name="ipv6actvtn" id="ipv6actvtn" style="vertical-align:middle" onchange="deactivatedhcp('ipv6actvtn')" <%if(landhcpobj.containsKey("ip6activation") && landhcpobj.getString("ip6activation").equals("1")) {%> checked <%}%> ><span class="slider round"></span></label>  <!-- modified this line replaced checked with unchecked -->
					</td>
				</tr>
				</tbody>
		</table>
		<table class="borderlesstab" style="width:400px;" id="dhcpserver" align="center">
			<tbody>
				<tr id="rtradvsvce">
					<td>Router Advertisement-Service</td>
					<td>
						<select id="rds" name="rds" class="text" style="margin-right:40px;" onchange="validateRtrAdvSvce('rds')">
							<option value="1" selected="">server mode</option>
							<option value="2">disabled</option>
							<option value="3">relay mode</option>
							<option value="4">hybrid mode</option>
						</select>
					</td>
				</tr>
				<tr id="dhcpv6svce">
					<td>DHCPv6-Service</td>
					<td>
						<select id="dhcpservice" class="text" name="dhcpservice" onchange="validatedhcpv6svce('dhcpservice')">
							<option value="1" selected="">server mode</option>
							<option value="2">disabled</option>
							<option value="3">relay mode</option>
							<option value="4">hybrid mode</option>
						</select>
					</td>
				</tr>
				<tr id="ndprxy">
					<td>NDP-Proxy</td>
					<td>
						<select id="ndp_proxy" class="text" name="ndp_proxy">
							<option value="1" selected="">disabled</option>
							<option value="2">relay mode</option>
							<option value="3">hybrid mode</option>
						</select>
					</td>
				</tr>
				<tr id="dhcpmode">
					<td>DHCPv6-Mode</td>
					<td>
						<select id="dhcp_mode" class="text" name="dhcp_mode">
							<option value="1" selected="">stateless+stateful</option>
							<option value="2">stateless</option>
							<option value="3">stateful-only</option>
						</select>
					</td>
				</tr>
				<tr id="ancdfrtr">
					<td>Always Announce default router</td>
					<td>
						<label class="switch" style="vertical-align:middle">
							<input type="checkbox" name="dfrtractvtn" id="dfrtractvtn" style="vertical-align:middle" ><span class="slider round"></span></label>  <!-- modified this line added by default  checked  -->
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div align="center">
		<input type="submit" name="Apply" value="Apply" style="display:inline block" class="button">
	</div>
	</form>
	  <%
   	if(errorstr != null && errorstr.trim().length() > 0)
			{%>
		     <script>
			 showErrorMsg("<%=errorstr%>");
			 </script>
			<%}
	  
	
      for(int i=0;i<laniparr.size();i++)
      {   	 
		 String cidr_ip =  laniparr.getString(i);
		 SubnetUtils utils = new SubnetUtils(cidr_ip);
		 utils.setInclusiveHostCount(true);
		 String row = i+1+"";
		 %>
		 <script>		
		 addIPRowAndChangeIcon('<%=(i+1)%>');		 
		 fillIProw('<%=(i+2)%>','<%=utils.getInfo().getAddress()%>','<%=utils.getInfo().getNetmask()%>');
		 </script>
		<% 
      }
	 if(laniparr.size() == 0)
	 {%>
		<script>	
		 addIPRowAndChangeIcon('1');
		</script>	
	 <%}
	 if(dnsarr.size() > 0)
	  {
     for(int i=0;i<dnsarr.size();i++)
     {
		 String dns =  dnsarr.getString(i);
		 %>
		 <script>		
		 addCustomDNSRowAndChangeIcon(customdns);		 
		 fillCustomDNSRow(customdns,'<%=dns%>');
		 </script>
	<% 
     }
	  }
	  else{%>
	<script>		
		 addCustomDNSRowAndChangeIcon(customdns);	 
		 </script>
	  <%}
	 if(dnsancarr.size() > 0)
	 {
		 for(int i=0;i<dnsancarr.size();i++)
		 {
			 String ancdns = dnsancarr.getString(i);
			 %>
			 <script>		
			 addAncdDNSServersRowAndChangeIcon(ancdnsservers);		 
			 fillAncdDNSServerRow(ancdnsservers,'<%=ancdns%>');
		 </script>
		 <% 
		 }
	 }
	 else {
     %>
     <script type="text/javascript">
     addAncdDNSServersRowAndChangeIcon(ancdnsservers);
     </script>
     <%} %>
      <script>
      showDivision('ipconfigpage',document.getElementById("hilightthis"));
      <%if(!ipv6assign_len.equalsIgnoreCase("64")&&!ipv6assign_len.equalsIgnoreCase("disable")){%>
	 	 IPv6Assignment('ipv6asl','<%=ipv6assign_len%>');
	  <%}else {%>
	  	IPv6Assignment('ipv6asl','');
	  <%}%>
	  deactivatedhcp('ipv6actvtn');
	  validateRtrAdvSvce('rds');
	  validatedhcpv6svce('dhcpservice');
	  //addAncdDNSServersRowAndChangeIcon(8); 
		//fillAncdDNSServerRow(ancdnsservers,'8.8.8.8'); 
		findAncdDNSServerLastRowAndDisplayRemoveIcon();
	 
	//addIPRowAndChangeIcon(1);
		//fillIProw(iprows,'192.168.2.20','255.255.255.0');
		findLastRowAndDisplayRemoveIcon();
	
		//fillCustomDNSRow(customdns,'8.8.8.8');
		findCustomDNSLastRowAndDisplayRemoveIcon();
	  </script>
</body>
</html>