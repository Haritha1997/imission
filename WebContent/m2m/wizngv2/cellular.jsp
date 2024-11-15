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
   JSONObject Sim1obj = null;
   JSONObject  Sim2obj = null;
   JSONObject  Simswitchobj = null;
   JSONObject datausageobj=null;
   JSONObject bandwidthobj=null;
   String sim1cnctntype = "";
   String sim2cnctntype = "";
   String sim1pppauth = "";
   String sim1ntwrk = "";
   String sim2pppauth = "";
   String sim2ntwrk = "";
   String prisim = "";
   String ipversn = "";
   String sim2Ipversn = "";
   String dailyact="";
   String monthlyact="";
   String bwch="";
   JSONArray  sim1dnsarr = null;
   JSONArray  sim2dnsarr = null;
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
   		
			Sim1obj = wizjsonnode.getJSONObject("cellular").getJSONObject("SIM:sim1");
			Sim2obj = wizjsonnode.getJSONObject("cellular").getJSONObject("SIM:sim2");
			Simswitchobj = wizjsonnode.getJSONObject("cellular").getJSONObject("common:common");
			datausageobj=wizjsonnode.containsKey("DataUsage")?wizjsonnode.getJSONObject("DataUsage"):new JSONObject();
			bandwidthobj=datausageobj.containsKey("remaining:bandwidth")?datausageobj.getJSONObject("remaining:bandwidth"):new JSONObject();
			
			sim1cnctntype = Sim1obj.getString("protocol");
			sim2cnctntype = Sim2obj.getString("protocol");
			
			if(Sim1obj.containsKey("auth"))
				sim1pppauth = Sim1obj.getString("auth");
			sim1ntwrk = Sim1obj.containsKey("mode")?Sim1obj.getString("mode"):""; 
			
			if(Sim2obj.containsKey("auth"))
				sim2pppauth = Sim2obj.getString("auth");
			if(Sim2obj.containsKey("mode"))
				sim2ntwrk = Sim2obj.getString("mode");
			
			if(Simswitchobj.containsKey("master"))
				prisim = Simswitchobj.getString("master");
			ipversn = Sim1obj.containsKey("ipversion")?Sim1obj.getString("ipversion"):"";
			sim2Ipversn = Sim2obj.containsKey("ipversion")?Sim2obj.getString("ipversion"):"";
			if(Sim1obj != null)
			{
				if(Sim1obj.containsKey("dns"))
				sim1dnsarr = Sim1obj.getJSONArray("dns");			
			}
			
			if(sim1dnsarr == null)
				sim1dnsarr = new JSONArray();
			
			if(Sim2obj != null)
			{
				if(Sim2obj.containsKey("dns"))
				sim2dnsarr = Sim2obj.getJSONArray("dns");			
			}
			
			if(sim2dnsarr == null)
				sim2dnsarr = new JSONArray();
			
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
<head>
	<link href="css/fontawesome.css" rel="stylesheet">
	<link href="css/solid.css" rel="stylesheet">
	<link href="css/v4-shims.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="css/style.css">
	<script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
	<script type="text/javascript" src="js/common.js"></script>
	<script type="text/javascript" src="js/cellular.js"></script>
	 <style type="text/css">
	h3{
		font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
		font-size:20px;
		background-color:gray;
		color:white;
		width:500px;
	 }
</style>
	<script type="text/javascript">
		var sim1customdns = 13;
		var sim2customdns = 13;
		function validateCellularConfig() {
			var altmsg = "";
			var sim1table = document.getElementById("sim1"); 
			var sim1rows = sim1table.rows;
			var sim1dns = document.getElementById("sim1autodns");
			var sim1act = document.getElementById("sim1actvn");
		var apnautoobj=document.getElementById("sim1autoapn");
		var apnobj=document.getElementById("sim1apn");
		if(sim1act.checked) {
			if(apnautoobj.checked==false)
			{
				if(apnobj.value.trim().length==0)
				{
					apnobj.style.outline = "thin solid red";
					apnobj.title = "APN  for sim1 should not be empty";
					altmsg+="APN  for sim1 should not be empty\n";
					
				}
				else
				{
					apnobj.style.outline = "initial";
					apnobj.title = "";
				}
			}
		}
		else
		{
			apnobj.style.outline = "initial";
			apnobj.title = "";
		}
		var customsim1_dns_arr=[];//added new line on 2-12-22
			if (sim1dns.checked == false) {
			//newly modified this if block on 2-12-22
				for (var i = 14; i < sim1rows.length;i++) { 
					var cols = sim1rows[i].cells; 
					var customsim1dns = cols[1].childNodes[0].childNodes[0];
					
					var valid = validatedualIP(customsim1dns.id, false, "Custom DNS Server",false);
						if(!valid)
					{
						if (customsim1dns.value.trim() == "") 
							altmsg += "SIM1 Custom DNS Server - " + (i - 13) + " should not be empty\n";
						else 
							altmsg += "SIM1 Custom DNS Server - " + (i - 13) + " is not valid\n";
					}
				else if(customsim1dns.value.trim() != "") 
					{
					if(valid)
				{
					for(ct=0;ct<customsim1_dns_arr.length;ct++)
					{
						if(customsim1_dns_arr[ct].value == customsim1dns.value)
						{
							customsim1dns.style.outline = "thin solid red";
							customsim1dns.title="Duplicate SIM1 Custom DNS Server "+customsim1dns.value;
							customsim1_dns_arr[ct].style.outline = "thin solid red";
							customsim1_dns_arr[ct].title = customsim1dns.title;
							altmsg += customsim1dns.title+"\n";
							break;
						}
					}
					if(ct==customsim1_dns_arr.length)
						customsim1_dns_arr.push(customsim1dns);
				}
				}
			}
		}
		//modified upto here....
			var sim2table = document.getElementById("sim2"); 
		 	var sim2rows = sim2table.rows;
			var sim2dns = document.getElementById("sim2autodns");
		    var apnautoobj1=document.getElementById("sim2autoapn");
		    var apnobj1=document.getElementById("sim2apn");
		    var sim2act = document.getElementById("sim2actvn");
			var customsim2_dns_arr=[];//added new line on 2-12-22
			if(sim2act.checked) {
			    if(apnautoobj1.checked==false)
			    {
					if(apnobj1.value.trim().length==0) {
						apnobj1.style.outline = "thin solid red";
						apnobj1.title = "APN for sim2 should not be empty";
						altmsg+="APN for sim2 should not be empty\n";
					}
					else{
						apnobj1.style.outline = "initial";
						apnobj1.title = "";
					}
			    }
		}
		else{
			apnobj1.style.outline = "initial";
			apnobj1.title = "";
		}
			if (sim2dns.checked == false) {
				//newly modified this if block on 2-12-22
				for (var i = 14; i < sim2rows.length;i++) {  
					var cols = sim2rows[i].cells; 
					var customsim2dns = cols[1].childNodes[0].childNodes[0];
					
					valid = validatedualIP(customsim2dns.id, false, "Custom DNS Server",false);
						if(!valid)
					{
						if (customsim2dns.value.trim() == "") 
							altmsg += "SIM2 Custom DNS Server - " + (i - 13) + " should not be empty\n";
						else 
							altmsg += "SIM2 Custom DNS Server - " + (i - 13) + " is not valid\n";
					}
				else if(customsim2dns.value.trim() != "") 
					{
					if(valid)
				{
					for(ct=0;ct<customsim2_dns_arr.length;ct++)
					{
						if(customsim2_dns_arr[ct].value == customsim2dns.value)
						{
							customsim2dns.style.outline = "thin solid red";
							customsim2dns.title="Duplicate SIM2 Custom DNS Server "+customsim2dns.value;
							customsim2_dns_arr[ct].style.outline = "thin solid red";
							customsim2_dns_arr[ct].title = customsim2dns.title;
							altmsg += customsim2dns.title+"\n";
							break;
						}
					}
					if(ct==customsim2_dns_arr.length)
						customsim2_dns_arr.push(customsim2dns);
				}
				}
			}
		}	
		//modified upto here....
			var noofretries = document.getElementById("retries");
			var valid = validateRange("retries", true, "No of Retries");
			if (!valid) {
				if (noofretries.value.trim() == "")
					altmsg += "No. of Retries should not be empty\n";
				else 
					altmsg += "No. of Retries is not valid\n"; 
			}

			var recheckmaster = document.getElementById("recheckmaster");
			if (recheckmaster.checked) {
				var recheckTime = document.getElementById("recheckTime");
				var valid = validateRange("recheckTime", true, "Recheck Primary SIM Timeout");
				if (!valid) {
					if (recheckTime.value.trim() == "")
						altmsg += "Recheck Primary SIM Timeout should not be empty\n";
					else 
						altmsg += "Recheck Primary SIM Timeout is not valid\n"; 
				}
			}
			
			//added new lines
			var sim1actvn = document.getElementById("sim1actvn");
	var sim2actvn = document.getElementById("sim2actvn");
	var simshiftact = document.getElementById("actid");
	var singqua = document.getElementById("sqid");
	if(simshiftact.checked || singqua.checked)
	{
		if(!sim1actvn.checked)
			altmsg +="SIM1 is not disable. SIM1 must be enabled for SIM Switch\n";
		if(!sim2actvn.checked)
			altmsg +="SIM2 is not disable. SIM2 must be enabled for SIM Switch\n";
	}
	
	//daily validation popup
	var daily = document.getElementById("daily");
	var actid = document.getElementById("actid");
	if(actid.checked == true)
	{
		if(daily.checked == true)
		{
			var sim1_day_of_daily =  document.getElementById("limitSim1");
			var sim2_day_of_daily =  document.getElementById("limitSim2");
			if(sim1_day_of_daily.value.trim() == "" && sim2_day_of_daily.value.trim() == "")
			{
				altmsg += "Daily Limit fields should not be empty\n";
				sim1_day_of_daily.style.outline = "thin solid red";
				sim2_day_of_daily.style.outline = "thin solid red";
			}else if(sim1_day_of_daily.value.trim() == "" && sim2_day_of_daily.value.trim() !== "")
			{
				altmsg += "Daily Limit field SIM1 should not be empty \n";
				sim1_day_of_daily.style.outline = "thin solid red";
				sim2_day_of_daily.style.outline = "initial";
			}else if(sim1_day_of_daily.value.trim() !== "" && sim2_day_of_daily.value.trim() == "")
			{
				altmsg += "Daily Limit field SIM2 should not be empty\n";
				sim1_day_of_daily.style.outline = "initial";
				sim2_day_of_daily.style.outline = "thin solid red";
			}
			else{
				sim1_day_of_daily.style.outline = "initial";
				sim2_day_of_daily.style.outline = "initial";
			}
		}
	}
	
	
	//month validation popup
	var month = document.getElementById("month");
	var actid = document.getElementById("actid");
	if(actid.checked == true)
	{
		if(month.checked ==  true)
		{
			var sim1_day_of_month =  document.getElementById("dateSim1");
			var sim2_day_of_month = document.getElementById("dateSim2");
			var monthlitsim1 =  document.getElementById("limitSim1");
			var monthlitsim2 =  document.getElementById("limitSim2");
			if(monthlitsim1.value.trim() == "" && monthlitsim2.value.trim() == "")
			{
				altmsg += "Monthly Limit fields should not be empty\n";
				monthlitsim1.style.outline = "thin solid red";
				monthlitsim2.style.outline = "thin solid red";
			}
			else if(monthlitsim1.value.trim() == "" && monthlitsim2.value.trim() !== "")
			{
				altmsg += "Monthly Limit field SIM1 should not be empty \n";
				monthlitsim1.style.outline = "thin solid red";
			}else if(monthlitsim1.value.trim() !== "" && monthlitsim2.value.trim() == "")
			{
				altmsg += "Monthly Limit field SIM2 should not be empty\n";
				monthlitsim2.style.outline = "thin solid red";
			}
			if((sim1_day_of_month.value.trim() =="" && sim2_day_of_month.value.trim() =="")) {
				altmsg += "Date of month to clean Sim1 and Sim2 should not be Empty\n";
				sim1_day_of_month.style.outline = "thin solid red";
				sim2_day_of_month.style.outline = "thin solid red";
			}
			else if(sim1_day_of_month.value.trim() =="" && sim2_day_of_month.value.trim() !="")
			{
				altmsg += "Date of month to clean Sim1 should not be Empty\n";
				sim1_day_of_month.style.outline = "thin solid red";
				
			}else if(sim1_day_of_month.value.trim() !="" && sim2_day_of_month.value.trim() =="")
			{
				altmsg += "Date of month to clean Sim2 should not be Empty\n";
				sim2_day_of_month.style.outline = "thin solid red";
			}
			else
			{
				sim1_day_of_month.style.outline = "initial";
				sim2_day_of_month.style.outline = "initial";
			}
		}
	}
			
		 	if (altmsg.trim().length == 0) 
		 	{
		 		// to send the values after submit even they are disabled
		 		var primesim = document.getElementById('psim');
				var rechkpsim = document.getElementById('recheckmaster');
				var rchktime = document.getElementById('recheckTime');
				primesim.disabled = false;
				rechkpsim.disabled = false;
				rchktime.disabled = false;
		 		return true; 
		 	}
		 	else {
		 		alert(altmsg); 	
		 		return false; 
		 	}  
		}
</script>
</head>
<body>
	<form action="savedetails.jsp?page=cellular&slnumber=<%=slnumber%>" method="post" onsubmit="return validateCellularConfig()">
	<br>
	<input type="hidden" id="sim1dnsrows" name="sim1dnsrows" value="14"/>
	<input type="hidden" id="sim2dnsrows" name="sim2dnsrows" value="14"/>
	<p id="cellularconfig" class="style5" align="center">Cellular Configuration</p>
	<br>
	<table class="borderlesstab nobackground" style="width:400px;margin-bottom:0px;" id="simtype" align="center">
		<tbody>
			<tr style="padding:0px;margin:0px;">
				<td style="padding:0px;margin:0px;">
					<ul id="simtypediv">
						<li><a class="casesense cellularlist"style="cursor:pointer;" onclick="showDivision('sim1page')" id="hilightthis">SIM 1</a></li>
						<li><a class="casesense cellularlist" style="cursor:pointer;" onclick="showDivision('sim2page')" id="">SIM 2</a></li>
						<li><a class="casesense cellularlist" style="cursor:pointer;" onclick="showDivision('sim_switch')" id="">General Settings</a></li>
					</ul>
				</td>
			</tr>
		</tbody>
	</table>
	<div id="sim1page" style="margin: 0px; display: inline;" align="center">
		<table class="borderlesstab" style="width:400px;" id="sim1" align="center">
			<tbody>
				<tr>
					<th width="200px">Parameters</th>
					<th width="200px">Configuration</th>
				</tr>
				<tr>
					<td>Activation</td>
					<td>
						<label class="switch" style="vertical-align:middle">
							<input type="checkbox" name="sim1actvn" id="sim1actvn" style="vertical-align:middle"  <%if((Sim1obj.containsKey("enabled") && Sim1obj.getString("enabled").equals("1"))) {%> checked <%}%> onchange="setSimShiftOptions()"><span class="slider round"></span></label>
					</td>
				</tr>
				<tr>
					<td>IPversion</td>
					<td>
						<select class="text" id="sim1ipversion" name="sim1ipversion" onchange="Ipversion('sim1ipversion')">
							<option value="ipv4" <%if(ipversn.equals("ipv4")){%>selected<%}%>>IPV4</option>
							<option value="ipv6" <%if(ipversn.equals("ipv6")){%>selected<%}%>>IPV6</option>
							<option value="Dual" <%if(ipversn.equals("Dual")){%>selected<%}%>>Dual</option>
						</select>
					</td>
				</tr>
				<tr id="ipv6_sel" style="display: none;">
					<td>Protocol</td>
					<td>
						<select class="text" id="sim1type" name="sim1type" onchange="Sim1ConnectionType('sim1type')">
							<option value=2>DHCP</option>
						</select>
					</td>
				</tr>
				<tr id="ipv4_sel" style="">
					<td>Protocol</td>
					<td>
						<select class="text" id="sim1cnctntype" name="sim1cnctntype" onchange="Sim1ConnectionType('sim1cnctntype')">
							<option value="dhcp">DHCP</option>
						</select>
					</td>
				</tr>
				<tr id="hidpppsim1usrname">
					<td>Username</td>
					<td>
						<input type="text" name="sim1usrname" id="sim1usrname" maxlength="256" value="<%=Sim1obj == null?"":Sim1obj.get("username")==null?"":Sim1obj.getString("username")%>" class="text" onkeypress="return avoidSpace(event) && avoidEnter(event)">
					</td>
				</tr>
				<tr id="hidpppsim1pwd">
					<td>Password</td>
					<td>
						<input type="password" name="sim1pwd" id="sim1pwd" maxlength="256" value="<%=Sim1obj == null?"":Sim1obj.get("password")==null?"":Sim1obj.getString("password")%>" class="text" onkeypress="return avoidSpace(event) && avoidEnter(event)"><span toggle="#password-field" class="fa fa-fw fa-eye field_icon toggle-sim1pwd"></span></td>
				</tr>
				<tr>
					<td>APN</td>
					<td>
						<input type="text" name="sim1apn" id="sim1apn" maxlength="256" value="<%=Sim1obj == null?"":Sim1obj.get("apn")==null?"":Sim1obj.getString("apn")%>" class="text" onkeypress="return avoidSpace(event) && avoidEnter(event)" >
					</td>
				</tr>
				<tr>
					<td>Auto APN</td>
					<td>
						<label class="switch" style="vertical-align:middle">
							<input type="checkbox" name="sim1autoapn" id="sim1autoapn" style="vertical-align:middle" <%if(Sim1obj.containsKey("autoapn") && Sim1obj.getString("autoapn").equals("1")) {%> checked <%}%> ><span class="slider round" onchange="validateApn()"></span></label>
					</td>
				</tr>
				<tr>
					<td>Pin Code</td>
					<td>
						<input type="text" name="sim1pincode" id="sim1pincode" maxlength="256" value="<%=Sim1obj == null?"":Sim1obj.get("pincode")==null?"":Sim1obj.getString("pincode")%>" class="text" onkeypress="return avoidSpace(event) && avoidEnter(event)" onfocusout="validatepincode('ipv6adrs','true','IPv6 Address')">
					</td>
				</tr>
				<tr>
					<td>Network</td>
					<td>
						<select class="text" id="sim1ntwrk" name="sim1ntwrk">
							<option value="auto" <%if(sim1ntwrk.equalsIgnoreCase("Auto")){%>selected<%}%>>Auto</option>
							<option value="2G" <%if(sim1ntwrk.equalsIgnoreCase("2G")){%>selected<%}%>>2G</option>
							<option value="3G" <%if(sim1ntwrk.equalsIgnoreCase("3G")){%>selected<%}%>>3G</option>
							<option value="4G" <%if(sim1ntwrk.equalsIgnoreCase("4G")){%>selected<%}%>>4G</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>MTU</td>
					<td>
						<input type="number" name="sim1mtu" id="sim1mtu" placeholder="1500" value="<%=Sim1obj == null?"":Sim1obj.get("mtu")==null?"":Sim1obj.getString("mtu")%>" min="1" max="9000" class="text" onkeypress="return avoidSpace(event) && avoidEnter(event)" onfocusout="validateRange('sim1mtu',false,'MTU')">
					</td>
				</tr>
				<tr>
					<td>Metric</td>
					<td>
						<input type="number" name="sim1metric" id="sim1metric" placeholder="0" value="<%=Sim1obj == null?"":Sim1obj.get("metric")==null?"":Sim1obj.getString("metric")%>" min="0" max="255" class="text" onkeypress="return avoidSpace(event) && avoidEnter(event)" onfocusout="validateRange('sim1metric',false,'Metric')">
					</td>
				</tr>
				<%-- <tr>
					<td>Default Route</td>
					<td>
						<label class="switch" style="vertical-align:middle">
							<input type="checkbox" name="sim1dfltrte" id="sim1dfltrte" style="vertical-align:middle" <%if(Sim1obj.containsKey("defaultroute") && Sim1obj.getString("defaultroute").equals("1")) {%> checked <%}%> ><span class="slider round"></span></label>
					</td>
				</tr> --%>
				<tr>
					<td>Obtain DNS Servers Automatically</td>
					<td>
						<label class="switch" style="vertical-align:middle">
							<input type="checkbox" name="sim1autodns" id="sim1autodns" style="vertical-align:middle" <%if(Sim1obj.containsKey("autodns") && Sim1obj.getString("autodns").equals("1")) {%> checked <%}%> onclick="hideCustomDNSRows('sim1','sim1autodns')"><span class="slider round"></span></label> <!-- Modified this line -->
					</td>
				</tr>
			</tbody>
		</table>
		<br>
		  <p style="font-size:11px;font-family: verdana;"><span style="color:red;"><b> Note:</b></span>Please refer healthcheck while deactivating the Sims</p>
	</div>
	<div id="sim2page" style="margin: 0px; display: none;" align="center">
		<table class="borderlesstab" style="width:400px;" id="sim2" align="center">
			<tbody>
				<tr>
					<th width="200px">Parameters</th>
					<th width="200px">Configuration</th>
				</tr>
				<tr>
					<td>Activation</td>
					<td>
						<label class="switch" style="vertical-align:middle">
							<input type="checkbox" name="sim2actvn" id="sim2actvn" style="vertical-align:middle" <%if(Sim2obj.containsKey("enabled") && Sim2obj.getString("enabled").equals("1")) {%> checked <%}%> onchange="setSimShiftOptions()"><span class="slider round"></span></label>
					</td>
				</tr>
				<tr>
					<td>IPversion</td>
					<td>
						<select class="text" id="sim2ipversion" name="sim2ipversion" onchange="Sim2Ipversion('sim2ipversion')">
							<option value="ipv4" <%if(sim2Ipversn.equals("ipv4")){%>selected<%}%>>IPV4</option>
							<option value="ipv6" <%if(sim2Ipversn.equals("ipv6")){%>selected<%}%>>IPV6</option>
							<option value="Dual" <%if(sim2Ipversn.equals("Dual")){%>selected<%}%>>Dual</option>
						</select>
					</td>
				</tr>
				<tr id="sim2ipv6_sel" style="display: none;">
					<td>Protocol</td>
					<td>
						<select class="text" id="sim2type" name="sim2type" onchange="Sim2ConnectionType('sim2type')">
							<option value=2>DHCP</option>
						</select>
					</td>
				</tr>
				<tr id="sim2ipv4_sel">
					<td>Protocol</td>
					<td>
						<select class="text" id="sim2cnctntype" name="sim2cnctntype" onchange="Sim2ConnectionType('sim2cnctntype')">
							<!--<option value="1" selected="">PPP</option>-->
							<option value="dhcp"<%if(sim2cnctntype.equals("DHCP")){%>selected<%}%> >DHCP</option>
						</select>
					</td>
				</tr>
				 <tr id="hidpppsim2usrname">
					<td>Username</td>
					<td>
						<input type="text" name="sim2usrname" id="sim2usrname" maxlength="256" value="<%=Sim2obj == null?"":Sim2obj.get("username")==null?"":Sim2obj.getString("username")%>" class="text" onkeypress="return avoidSpace(event) && avoidEnter(event)">
					</td>
				</tr>
				<tr id="hidpppsim2pwd">
					<td>Password</td>
					<td>
						<input type="password" name="sim2pwd" id="sim2pwd" maxlength="256" value="<%=Sim2obj == null?"":Sim2obj.get("password")==null?"":Sim2obj.getString("password")%>" class="text" onkeypress="return avoidSpace(event) && avoidEnter(event)"><span toggle="#password-field" class="fa fa-fw fa-eye field_icon toggle-sim2pwd"></span></td>
				</tr>
				<tr>
					<td>APN</td>
					<td>
						<input type="text" name="sim2apn" id="sim2apn" maxlength="256" value="<%=Sim2obj == null?"":Sim2obj.get("apn")==null?"":Sim2obj.getString("apn")%>" class="text" onkeypress="return avoidSpace(event) && avoidEnter(event)">
					</td>
				</tr>
				<tr>
					<td>Auto APN</td>
					<td>
						<label class="switch" style="vertical-align:middle">
							<input type="checkbox" name="sim2autoapn" id="sim2autoapn" style="vertical-align:middle" <%if(Sim2obj.containsKey("autoapn") && Sim2obj.getString("autoapn").equals("1")) {%> checked <%}%>><span class="slider round"></span></label>
					</td>
				</tr>
				<tr>
					<td>Pin Code</td>
					<td>
						<input type="text" name="sim2pincode" id="sim2pincode" maxlength="256" value="<%=Sim2obj == null?"":Sim2obj.get("pincode")==null?"":Sim2obj.getString("pincode")%>" class="text" onkeypress="return avoidSpace(event) && avoidEnter(event)">
					</td>
				</tr>
				<tr>
					<td>Network</td>
					<td>
						<select class="text" id="sim2ntwrk" name="sim2ntwrk">
							<option value="auto" <%if(sim2ntwrk.equals("auto")){%>selected<%}%>>Auto</option>
							<option value="2G" <%if(sim2ntwrk.equals("2G")){%>selected<%}%>>2G</option>
							<option value="3G" <%if(sim2ntwrk.equals("3G")){%>selected<%}%>>3G</option>
							<option value="4G" <%if(sim2ntwrk.equals("4G")){%>selected<%}%>>4G</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>MTU</td>
					<td>
						<input type="number" name="sim2mtu" id="sim2mtu" class="text" value="<%=Sim2obj == null?"":Sim2obj.get("mtu")==null?"":Sim2obj.getString("mtu")%>" placeholder="1500" min="1" max="9000" onkeypress="return avoidSpace(event) && avoidEnter(event)" onfocusout="validateRange('sim2mtu',false,'MTU')">
					</td>
				</tr>
				<tr>
					<td>Metric</td>
					<td>
						<input type="number" name="sim2metric" id="sim2metric" placeholder="0" value="<%=Sim2obj == null?"":Sim2obj.get("metric")==null?"":Sim2obj.getString("metric")%>" min="0" max="255" class="text" onkeypress="return avoidSpace(event) && avoidEnter(event)" onfocusout="validateRange('sim2metric',false,'Metric')">
					</td>
				</tr>
				<%-- <tr>
					<td>Default Route</td>
					<td>
						<label class="switch" style="vertical-align:middle">
							<input type="checkbox" name="sim2dfltrte" id="sim2dfltrte" style="vertical-align:middle" <%if(Sim2obj.containsKey("defaultroute") && Sim2obj.getString("defaultroute").equals("1")) {%> checked <%}%> ><span class="slider round"></span></label>
					</td>
				</tr> --%>
				<tr>
					<td>Obtain DNS Servers Automatically</td>
					<td>
						<label class="switch" style="vertical-align:middle">
							<input type="checkbox" name="sim2autodns" id="sim2autodns" style="vertical-align:middle" onclick="hideCustomDNSRows('sim2','sim2autodns');" <%if(Sim2obj.containsKey("autodns") && Sim2obj.getString("autodns").equals("1")) {%> checked <%}%>><span class="slider round"></span></label> <!-- Modified this line -->
					</td>
				</tr>
			</tbody>
		</table>
		<br>
		  <p style="font-size:11px;font-family: verdana;"><span style="color:red;"><b> Note:</b></span>Please refer healthcheck while deactivating the Sims</p>
	</div>
	<div id="sim_switch" style="margin: 0px; display: none;" align="center">
		<table class="borderlesstab" style="width:500px;" id="WiZConf" align="center">
			<tbody>
				<tr>
					<th width="300px">Parameters</th>
					<th width="300px">Configuration</th>
				</tr>
				<tr>
					<td>Primary SIM</td>
					<td>
						<select class="text" id="psim" name="psim">
							<option value="SIM 1" <%if(prisim.equals("SIM 1")){%>selected<%}%>>SIM 1</option>
							<option value="SIM 2" <%if(prisim.equals("SIM 2")){%>selected<%}%>>SIM 2</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>No of Retries</td>
					<td>
						<input type="number" name="retries" id="retries" class="text" min="1" max="20" value="<%=Simswitchobj == null?"":Simswitchobj.get("retries")==null?"":Simswitchobj.getString("retries")%>" onkeypress="return avoidSpace(event) && avoidEnter(event)" onfocusout="validateRange('retries',true,'No of Retries')">
					</td>
				</tr>
				<tr>
					<td>Recheck Primary SIM</td>
					<td>
						<label class="switch" style="vertical-align:middle">
						<input type="checkbox" name="recheckmaster" id="recheckmaster" style="vertical-align:middle" <% if(Simswitchobj.containsKey("recheck") && Simswitchobj.getString("recheck").equals("1")) {%> checked <%}%> ><span class="slider round"></span></label>
					</td>
				</tr>
				<tr>
					<td>Recheck Primary SIM Timeout (HRS)</td>
					<td>
						<input type="number" name="recheckTime" id="recheckTime" class="text" min="1" max="720" value="<%=Simswitchobj == null?"":Simswitchobj.get("recheckTime")==null?"5":Simswitchobj.getString("recheckTime")%>" onkeypress="return avoidSpace(event) && avoidEnter(event)" onfocusout="validateRange('recheckTime',true,'Recheck Primary SIM Timeout')">
					</td>
				</tr>
				<!--  <tr>
					<td>Manual SIM Shift</td>
					<td>
						<input type="submit" name="Shift" value="Shift" class="button1">
					</td>
				</tr> -->
				<tr>
				<td>Sim Switch</td>
				<% bwch=bandwidthobj==null?"":bandwidthobj.containsKey("DataLimit_Exceeded")?bandwidthobj.getString("DataLimit_Exceeded").equals("1")?"checked":"":""; 
				 String sigqutych=Simswitchobj==null?"":Simswitchobj.containsKey("signalquality")?Simswitchobj.getString("signalquality").equals("1")?"checked":"":"";%>
				<td>Bandwidth&nbsp;<input type="checkbox" name="actid" id="actid" <%=bwch%> onclick="simswitchbw();bandWidth('bandwidth')">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Signal Quality&nbsp;<input type="checkbox" name="sqid" id="sqid" <%=sigqutych%> onclick="simswitchsq()"></td>
			</tr>
			</tbody>
		</table>
		<br>
	<!-- added new  -->	
	<div id="bandwidthdiv" align="center">
			<table class="borderlesstab" style="width:500px;" id="banwidthtab" align="center">
				<tbody>
					<tr id="band">
						<h3>Band width </h3>
					</tr>
					<tr id="actidrow">
						<!-- <td style="max-width:40px">Activation <input type="checkbox" id="actid" name="actid" onclick="bandWidth('activation')"></td> -->
						<td style="max-width:40px">Frequency</td>
						<%dailyact=bandwidthobj==null?"":bandwidthobj.containsKey("DailyLimit")?bandwidthobj.getString("DailyLimit").equals("1")?"checked":"":"";%>
						<td style="text-align:center;max-width:50px;">Daily <input type="radio" id="daily" name="daily" <%=dailyact%> onclick="bandWidth('daily')"></td>
						<%monthlyact=bandwidthobj==null?"":bandwidthobj.containsKey("MonthlyLimit")?bandwidthobj.getString("MonthlyLimit").equals("1")?"checked":"":"";%>
						<td style="text-align:center;max-width:50px;">Monthly <input type="radio" id="month" name="month" <%=monthlyact%> onclick="bandWidth('month')"></td>
					</tr>
					<tr id="sim" class="text1">
						<td></td>
						<td style="text-align:center">SIM1</td>
						<td style="text-align:center">SIM2</td>
					</tr>
					<tr id="limit" class="text1">
						<td id="limittype">Daily Limit(MB)</td>
						<%String dailylimsim1=bandwidthobj==null?"":bandwidthobj.containsKey("MaxDataLimit0")?bandwidthobj.getString("MaxDataLimit0"):""; 
						  String dailylimsim2=bandwidthobj==null?"":bandwidthobj.containsKey("MaxDataLimit1")?bandwidthobj.getString("MaxDataLimit1"):""; %>	
						<td><input type="number" id="limitSim1" class="text" name="limitSim1" min="1" maxlength="8" value="<%=dailylimsim1%>" onkeyup="limitToMaxLength('limitSim1')" onkeypress="return avoidSpace(event)" onfocusout="validateRangeWithoutMax('limitSim1',true,'Daily Limit(MB)')"></td>
						
						<td><input type="number" id="limitSim2" class="text" name="limitSim2" min="1" maxlength="8" value="<%=dailylimsim2%>" onkeyup="limitToMaxLength('limitSim2')" onkeypress="return avoidSpace(event)" onfocusout="validateRangeWithoutMax('limitSim2',true,'Daily Limit(MB)')"></td>
					</tr>
					<tr id="dailyused" class="text1">
						<td>Used Data(KB)</td>
						<td><input type="text" id="dayusedsim1" name="dayusedsim1" class="text" value="0.0" onkeypress="return avoidSpace(event)" readonly></td>
						<td><input type="text" id="dayusedsim2" name="dayusedsim2" class="text" value="0.0" onkeypress="return avoidSpace(event)" readonly></td>
					</tr>
					<tr id="monthused" class="text1">
						<td>Used Data(KB)</td>
						<td><input type="text" id="monusedsim1" name="monusedsim1" class="text" value="10.10" onkeypress="return avoidSpace(event)" readonly></td>
						<td><input type="text" id="monusedsim2" name="monusedsim2" class="text" value="10.10" onkeypress="return avoidSpace(event)" readonly></td>
					</tr>
					<tr id="dateofmonth" class="text1">
						<td>Date of month to clean</td>
						<%String moncleansim1=bandwidthobj==null?"":bandwidthobj.containsKey("DoMToClean0")?bandwidthobj.getString("DoMToClean0"):""; 
						  String moncleansim2=bandwidthobj==null?"":bandwidthobj.containsKey("DoMToClean1")?bandwidthobj.getString("DoMToClean1"):"";%>
						<td><input type="number" id="dateSim1" class="text" name="dateSim1" min="1" max="28" value="<%=moncleansim1%>" placeholder="1-28" onkeypress="return avoidSpace(event)" onfocusout="validateRange('dateSim1',true,'Date of month to clean')"></td>
						<td><input type="number" id="dateSim2" class="text" name="dateSim2" min="1" max="28" value="<%=moncleansim2%>" placeholder="1-28" onkeypress="return avoidSpace(event)" onfocusout="validateRange('dateSim2',true,'Date of month to clean')"></td>
					</tr>
				   </tbody>
				 </table>
		  </div>
		 <br>
		  
		  <div id="sqdiv" name="sqdiv">
			<p style="font-size:11px;font-family: verdana;"><span style="color:red;"><b> Note:</b></span>SQ based Sim Shift happens if SQ is less than -89dBm </p>
		  </div>
		  <br>
	</div>
	<div align="center">
		<input type="submit" name="Apply" value="Apply" style="display:inline block" class="button" >

</div>
</form>
<% 
 if(sim1dnsarr.size() > 0)
	  {
     for(int i=0;i<sim1dnsarr.size();i++)
     {
		 String dns =sim1dnsarr.getString(i);
 %>
		 <script>		
		 addSim1DNSRowAndChangeIcon(sim1customdns);
		 
		 fillSim1DNSRow(sim1customdns,'<%=dns%>');
		 </script>
	<% 
     }
	  }
	  else{%>
	<script>		
	addSim1DNSRowAndChangeIcon(sim1customdns);	 
		 </script>
	  <%}%>
<% 
 if(sim2dnsarr.size() > 0)
	  {
     for(int i=0;i<sim2dnsarr.size();i++)
     {
		 String dns =sim2dnsarr.getString(i);
 %>
		 <script>		
		 addSim2DNSRowAndChangeIcon(sim2customdns);
		 
		 fillSim2DNSRow(sim2customdns,'<%=dns%>');
		 </script>
	<% 
     }
	  }
	  else{%>
	<script>		
	addSim2DNSRowAndChangeIcon(sim2customdns);	 
		 </script>
	  <%}%>

<script>
	showDivision('sim1page');
	// new lines added..........
	hideCustomDNSRows('sim1','sim1autodns');
	hideCustomDNSRows('sim2','sim2autodns');
	//Sim1ConnectionType('sim1cnctntype');
	//Sim2ConnectionType('sim2cnctntype');
	Ipversion('sim1ipversion');
	Sim2Ipversion('sim2ipversion');
	setSimShiftOptions();
	simswitchbw();
	simswitchsq();
</script>
<% 
	if(dailyact.equals("checked")) {
		%>
		<script>
	bandWidth('daily');
	</script>
	<% } else if(monthlyact.equals("checked")){%>
	<script>
	bandWidth('month');
	</script>
	<%} else {%>
	<script>
	bandWidth('');
	</script>
	<%}%>
</body>