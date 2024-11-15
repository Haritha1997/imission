<%@page import="org.apache.commons.net.util.SubnetUtils"%>
<%@page import="java.net.NetworkInterface"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.nomus.staticmembers.M2MProperties"%>
 <%
   JSONObject wizjsonnode = null;
   JSONArray  route_arr = null;
   JSONArray  static_route_arr = new JSONArray();
   String enable_server ="";
   BufferedReader jsonfile = null;   
   		String slnumber=request.getParameter("slnumber");
   		String version=request.getParameter("version");
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
			route_arr =  wizjsonnode.containsKey("network")?(wizjsonnode.getJSONObject("network").containsKey("route")?wizjsonnode.getJSONObject("network").getJSONArray("route"):new JSONArray()):new JSONArray();
	  		for(int i=0;i<route_arr.size();i++)
	  		{
	  			JSONObject staticobj=route_arr.getJSONObject(i);
	  			if(staticobj.containsKey("interface"))
		  			if(staticobj.getString("interface").equals("lan")||staticobj.getString("interface").equals("wan")||staticobj.getString("interface").equals("cellular"))
		  				static_route_arr.add(staticobj);
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
<head>
<link rel="stylesheet" type="text/css" href="css/style.css">
<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/staticroute.js"></script>
<script type="text/javascript" src="js/common.js"></script>
<style>
#WiZConff {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 1000px;
}
</style>

<script type="text/javascript">
	var iprows = 1;
	var iprows6 = 1;

	
	function validateRoute() {
		var alertmsg = "";
		var ipv4table = document.getElementById("WiZConff");
		var ipv4rows = ipv4table.rows;
		var valid;
		try
		{
			for (var i = 1; i < ipv4rows.length; i++) {
				var cols = ipv4rows[i].cells;
				var interfaceobj = cols[1].childNodes[0]; //this line added on 25-8-2022
				var targetobj = cols[2].childNodes[0];
				var netmaskobj = cols[3].childNodes[0];
				var gatewayobj = cols[4].childNodes[0];
				var metricobj = cols[5].childNodes[0];
				var mtuobj = cols[6].childNodes[0];
				valid = validateIP(targetobj.id, true, "Target");
				var ipvalid = valid;
				if (!valid) {
					if (targetobj.value.trim() == "") {
						alertmsg += "The IPV4Target in the row " + i
								+ " should not be empty\n";
					} else {
						alertmsg += "The IPV4Target in the row " + i
								+ " is not valid\n";
					}
				}
				valid = validateSubnetMaskStaticRoute(netmaskobj.id, true, "Netmask");
				var netvalid = valid;
				if (!valid) {
					if (netmaskobj.value.trim() == "") {
						alertmsg += "The IPV4Netmask in the row " + i
								+ " should not be empty\n";
					} else {
						alertmsg += "The IPV4Netmask in the row " + i
								+ " is not valid\n";
					}
				}
				if(ipvalid && netvalid)
				{
					var network = getNetwork(targetobj.value,netmaskobj.value);
					var broadcast = getBroadcast(network,netmaskobj.value);
					/* var target_arr = targetobj.value.split(".");
					if(parseInt(target_arr[0]) >= 224)
					{
						targetobj.title = "Invalid Target IP the row "+i+", Target IP should not starts with "+target_arr[0]+"\n";
						alertmsg += targetobj.title;
						targetobj.style.outline = "thin solid red";
					} */
					if(targetobj.value != network)
					{
						targetobj.title = "Target in the row "+i+" should be Network\n";
						alertmsg += targetobj.title;
						targetobj.style.outline = "thin solid red";
					}
				}
				valid = validateIPOnly(gatewayobj.id, false, "Gateway");
				if (!valid) {
					if (gatewayobj.value.trim() == "") {
						alertmsg += "The IPV4Gateway in the row " + i
								+ " should not be empty\n";
					} else {
						alertmsg += "The IPV4Gateway in the row " + i
								+ " is not valid\n";
					}
				}
				else if(gatewayobj.value.trim() != "")
				{
					var gtval = gatewayobj.value.trim();
					/*if(gtval == network)
					{
						gatewayobj.style.outline = "thin solid red";
						gatewayobj.title = "IPv4 Gateway should not be the network "+network+" of Static IPv4 Route Target "+targetobj.value+"\n";
						alertmsg += gatewayobj.title;
					}
					else if(gtval == broadcast)
					{
						gatewayobj.style.outline = "thin solid red";
						gatewayobj.title = "IPv4 Gateway should not be the Broadcast "+broadcast+" of Static IPv4 Route Target "+targetobj.value+"\n";
						alertmsg += gatewayobj.title;
					}*/
					if(gtval == targetobj.value)
					{
						gatewayobj.style.outline = "thin solid red";
						gatewayobj.title = "IPv4 Gateway should not be the Static IPv4 Route Target "+targetobj.value+"\n";
						alertmsg += gatewayobj.title;
					}
					else if(gtval == netmaskobj.value)
					{
						
						gatewayobj.style.outline = "thin solid red";
						gatewayobj.title = "IPv4 Gateway should not be the Static IPv4 Route Netmask "+netmaskobj.value+"\n";
						alertmsg += gatewayobj.title;
					}
					/*else if(!(isGraterOrEquals(gtval,network) && !isGraterOrEquals(gtval,broadcast)))
					{
						gatewayobj.style.outline = "thin solid red";
						gatewayobj.title ="Ipv4 Gateway "+gtval+" in the row "+i+" should be with in the network of "+targetobj.value+"\n";
						alertmsg +=gatewayobj.title;
					}*/
				}
				/////////////////////////////// New lines added from here on 25-8-2022 ////////////////////////
				var i_interface = interfaceobj.value;
				var i_target = targetobj.value;
				var i_netmask = netmaskobj.value;
				var i_gateway = gatewayobj.value;
				var i_metric = metricobj.value;
				var i_mtu = mtuobj.value;
				for (var j = 1; j < ipv4rows.length; j++) {
					var jinterfaceobj = ipv4rows[j].cells[1].childNodes[0];
					var jtargetobj = ipv4rows[j].cells[2].childNodes[0];
					var jnetmaskobj = ipv4rows[j].cells[3].childNodes[0];
					var jgatewayobj = ipv4rows[j].cells[4].childNodes[0];
					var jmetricobj = ipv4rows[j].cells[5].childNodes[0];
					var jmtuobj = ipv4rows[j].cells[6].childNodes[0];
					if (jtargetobj != null && (jtargetobj.value.trim() != "")) {
						j_interface = jinterfaceobj.value;
						j_target = jtargetobj.value;
						j_netmask = jnetmaskobj.value;
						j_gateway = jgatewayobj.value;
						j_metric = jmetricobj.value;
						j_mtu = jmtuobj.value;
	
						if ((i_interface == j_interface) && (i_target == j_target)
								&& (i != j) && (i_netmask == j_netmask)
								&& (i_gateway == j_gateway)
								&& (i_metric == j_metric)) {
							if (!alertmsg.includes(i_target
									+ " entry already exists"))
								alertmsg += i_target + " entry already exists \n";
							targetobj.style.outline = "thin solid red";
							break;
						} else if ((i != j)
								&& (i_interface == j_interface)
								&& (isOverlaped(i_target, i_netmask, j_target,
										j_netmask))) {
							if (!((alertmsg.includes(i_target + " and " + i_netmask
									+ " is overlaps with the networks " + j_target
									+ " and " + j_netmask)) || (alertmsg
									.includes(j_target + " and " + j_netmask
											+ " is overlaps with the networks "
											+ i_target + " and " + i_netmask))))
								alertmsg += i_target + " and " + i_netmask
										+ " is overlaps with the networks "
										+ j_target + " and " + j_netmask + "\n";
							break;
						}
					}
				} // new lines ended..................
			}
			var ipv6table = document.getElementById("ipv6");
			var ipv6rows = ipv6table.rows;
			for (var i = 1; i < ipv6rows.length; i++) {
				var cols = ipv6rows[i].cells;
				var interfaceobj = cols[1].childNodes[0]; // this line is added on 25-8-2022
				var targetobj = cols[2].childNodes[0];
				var gatewayobj = cols[3].childNodes[0];
				var metricobj = cols[4].childNodes[0];
				var mtuobj = cols[5].childNodes[0];
				var valid = validateIPv6(targetobj.id, true, "Target", true);
				if (!valid) {
					if (targetobj.value.trim() == "") {
						alertmsg += "The IPV6Target in the row " + i
								+ " should not be empty\n";
					} else {
						alertmsg += "The IPV6Target in the row " + i
								+ " is not valid\n";
					}
				}
				valid = validateIPv6gateway(gatewayobj.id, false, "Gateway");
				if (!valid) {
					if (gatewayobj.value.trim() == "") {
						alertmsg += "The IPV6Gateway in the row " + i
								+ " should not be empty\n";
					} else {
						alertmsg += "The IPV6Gateway in the row " + i
								+ " is not valid\n";
					}
				}
				/////////////////////////////// New lines added from here on 25-8-2022 ////////////////////////
				var i_interface = interfaceobj.value;
				var i_target = targetobj.value;
				var i_gateway = gatewayobj.value;
				var i_metric = metricobj.value;
				var i_mtu = mtuobj.value;
				for (var j = 1; j < ipv6rows.length; j++) {
					var jinterfaceobj = ipv6rows[j].cells[1].childNodes[0];
					var jtargetobj = ipv6rows[j].cells[2].childNodes[0];
					var jgatewayobj = ipv6rows[j].cells[3].childNodes[0];
					var jmetricobj = ipv6rows[j].cells[4].childNodes[0];
					var jmtuobj = ipv6rows[j].cells[5].childNodes[0];
										
					if (jtargetobj != null && (jtargetobj.value.trim() != "")) {
						j_interface = jinterfaceobj.value;
						j_target = jtargetobj.value;
						j_gateway = jgatewayobj.value;
						j_metric = jmetricobj.value;
						j_mtu = jmtuobj.value;
	
						if ((i_interface == j_interface) && (i_target == j_target)
								&& (i != j) && (i_gateway == j_gateway)
								&& (i_metric == j_metric)) {
							if (!alertmsg.includes(i_target
									+ " entry already exists"))
								alertmsg += i_target + " entry already exists \n";
							targetobj.style.outline = "thin solid red";
							break;
						}
					}
				} // new lines ended..................
	
			}
			if (alertmsg.trim().length == 0) {
				return true;
			} else {
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
	<form action="savedetails.jsp?page=static_routing&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="return validateRoute()">
		<!-- <p class="style5" align="center"> Static IPV4 Routes</p> -->
		<input type="text" id="routesrwcnt" name="routesrwcnt" value="1" hidden="" />
		<p class="style5" align="center">Static Routing</p>
		<br>
		<table class="borderlesstab nobackground" align="center"
			style="width: 600px; margin-bottom: 0px;">
			<tbody>
				<tr style="padding: 0px; margin: 0px;">
					<td style="padding: 0px; margin: 0px;">
						<ul id="sroutediv">
							<li><a class="casesense lanconfiguration"
								style="cursor: pointer" onclick="showDivision('ipv4routediv')"
								id="hilightthis">Static IPV4 Routes</a></li>
							<li><a class="casesense lanconfiguration"
								style="cursor: pointer" onclick="showDivision('ipv6routediv')"
								id="">Static IPV6 Routes</a></li>
						</ul>
					</td>
				</tr>
			</tbody>
		</table>
		<div id="ipv4routediv" align="center"
			style="margin: 0px; display: inline;">
			<table class="borderlesstab" id="WiZConff" align="center">
				<tbody>
					<tr>
						<th style="text-align: center; min-width: 30px">S.No</th>
						<th
							style="text-align: center; max-width: 130px; min-width: 130px;">
							Interface</th>
						<th
							style="text-align: center; max-width: 160px; min-width: 160px;">
							Target</th>
						<th
							style="text-align: center; max-width: 130px; min-width: 130px;">
							Netmask</th>
						<th
							style="text-align: center; max-width: 130px; min-width: 130px;">
							IPV4 Gateway</th>
						<th
							style="text-align: center; max-width: 130px; min-width: 130px;">
							Metric</th>
						<th
							style="text-align: center; max-width: 130px; min-width: 130px;">
							MTU</th>
						<th style="text-align: center; min-width: 40px">Action</th>
					</tr>
				</tbody>
			</table>
			<div align="center">
				<input class="button" type="button" id="add" value="Add"
					style="display: inline block" onclick="addRow('WiZConff','<%=version%>')">
				<input type="submit" value="Apply" name="Apply"
					style="display: inline block" class="button">
			</div>
		</div>

		<div id="ipv6routediv" align="center"
			style="margin: 0px; display: inline;">
			<input type="text" id="ipv6routesrwcnt" name="ipv6routesrwcnt" value="1" hidden="">
			<table class="borderlesstab" id="ipv6" align="center" style="width: 1000px">
				<tbody>
					<tr>
						<th style="text-align: center; min-width: 30px">S.No</th>
						<th
							style="text-align: center; max-width: 130px; min-width: 130px;">
							Interface</th>
						<th
							style="text-align: center; max-width: 130px; min-width: 130px;">
							Target</th>
						<th
							style="text-align: center; max-width: 130px; min-width: 130px;">
							IPV6 Gateway</th>
						<th
							style="text-align: center; max-width: 130px; min-width: 130px;">
							Metric</th>
						<th
							style="text-align: center; max-width: 130px; min-width: 130px;">
							MTU</th>
						<th style="text-align: center; min-width: 40px">Action</th>
					</tr>
				</tbody>
			</table>
			<div align="center">
				<input class="button" type="button" id="add" value="Add"
					style="display: inline block" onclick="addRow('ipv6','<%=version%>')"> 
					<input type="submit" value="Apply" name="Apply"
					style="display: inline block" class="button">
			</div>
		</div>
	</form>
 <%for(int i=0;i<static_route_arr.size();i++)
		{
			JSONObject route_obj = (JSONObject)static_route_arr.get(i);
			String  inter_face = route_obj.containsKey("interface")? route_obj.getString("interface"):"";
			if(inter_face.equals("lan")||inter_face.equals("wan")||inter_face.equals("cellular"))
			{
				//String  inter_face = route_obj.containsKey("interface")? route_obj.getString("interface"):"";
				String  target = route_obj.containsKey("target")? route_obj.getString("target"):"";
				String  netmask = route_obj.containsKey("netmask")? route_obj.getString("netmask"):"";
				String  gateway = route_obj.containsKey("gateway")? route_obj.getString("gateway"):"";
				String  metric = route_obj.containsKey("metric")? route_obj.getString("metric"):"";
				String  mtu = route_obj.containsKey("mtu")? route_obj.getString("mtu"):"";
			%>
			<script>
			addRow('WiZConff','<%=version%>');
			fillrow('<%=i+1%>','<%=inter_face%>','<%=target%>','<%=netmask%>','<%=gateway%>','<%=metric%>','<%=mtu%>');
			</script>
			<%	
			}
		}
	  %>
	<script>
		showDivision('ipv4routediv');
	</script>
</body>