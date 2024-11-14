
<%@page import="com.nomus.m2m.dao.NodedetailsDao"%>
<%@page import="com.nomus.staticmembers.Symbols"%>
<%@page import="com.nomus.m2m.pojo.NodeDetails"%>
<%
  String slnumber=request.getParameter("slnumber");
  String version=request.getParameter("version");
%>
<html>
<head>
<link rel="stylesheet" href="css/style.css"/>
<style type="text/css">
a:hover {
	font-size:14;
}
.submenu1 li a{
	font-size: 15px;
}
.submenu2 li a{
	font-size: 13px;
}
.submenu3 li a{
	font-size: 12px;
}
</style>
<script type = "text/javascript">
 window.scrollTo(0, 0);
function hilightthis(obj,menuname) {  
  	var ullist = document.getElementsByClassName(menuname);
	for (var i = 0; i < ullist.length; i++) {
		var list = ullist[i].getElementsByTagName("a");
		for (var j = 0; j < list.length; j++)
			list[j].id="";
	}
	obj.childNodes[0].id="hilightthis";
}

function loadFunction() {
	const queryString = window.location.search;
	// New Compatibility code
	// New Start
	const urlParams = new URLSearchParams(queryString);
	var menuname = urlParams.get('menu');
	// New End
/*
	// Old Start
	var params = queryString.replace("?","").split("&"); 
	var menuname = "";
	for (var i=0;i<params.length;i++) {
		var param = params[i];
		if (param.split("=")[0] == "menu") {
			menuname = param.split("=")[1];
			break;
		}
	}
	// Old End
*/
	showmenu(menuname);
}
    
function showmenu(menuname) {

     if (menuname == null) {
		document.getElementById('displayframe').src = "welcome.jsp?slnumber=<%=slnumber%>&version=<%=version%>";
		return; 
	}
     
	var menu = document.getElementById(menuname);
	menu.style.display = "inline";

	// New Start
	var href_obj = menu.children[0].children[0];
	href_obj.click();
	if (href_obj.hasAttribute("target"))
		document.getElementById('displayframe').src = href_obj.href;
	//alert("before click");
	// New End
}

function showsubmenu(menuname)
{
	var submen2arr = ["ethernetmenu","firewalmenu","servpnmenu","managementmenu",
				   "stavpnmenu","debugmenu","nwstatmenu","routingmenu", "systemmenu", "dhcpmenu", "configmenu"];
	//alert("menu name is : "+menuname);
	for (var i = 0; i < submen2arr.length; i++) {
		//alert("submenu legth is : "+submen2arr.length);
			
		if (submen2arr[i] != menuname) {
			document.getElementById(submen2arr[i]).style.display = "none";
		} else {
			// Old Start
			//document.getElementById(submen2arr[i]).style.display = "inline";
			// Old End
			var menu = document.getElementById(submen2arr[i]);
		  	menu.style.display = "inline";
			//showmenu(menu.id); // add this line guru
			var href_obj = menu.children[0].children[0];
			href_obj.click();
		}
	}		
}
function showsubmenu3(menuname)
{
	var submen3arr = ["gremenu"];
	for (var i = 0; i < submen3arr.length; i++) {
		if (submen3arr[i] != menuname) {
			document.getElementById(submen3arr[i]).style.display = "none";
		} else {
			var menu = document.getElementById(submen3arr[i]);
		  	menu.style.display = "inline";
			var href_obj = menu.children[0].children[0];
			href_obj.click();
		}
	}		
}
</script>
</head>
<body onload="loadFunction()" >
	<!-- <div>
		<ul>
			<li id="li" class="active"><a onclick="showmenu('networkmenu')">Network</a></li>
			<li onclick="hilightthis(this)"><a onclick="showmenu('servicesmenu')">Services</a></li>
			<li onclick="hilightthis(this)"><a onclick="showmenu('diagmenu')">Diagnostics</a></li>
			<li onclick="hilightthis(this)"><a onclick="showmenu('sysmenu')">System</a></li>
			<li onclick="hilightthis(this)"><a onclick="showmenu('statusmenu')">Status</a></li>
			<li onclick="hilightthis(this)"><a href="#">Logout</a></li>
		</ul>
	</div>
 -->
	<!--  networkmenu start-->
	<!-- <div> --> <!-- Old compact -->
	<div style="position:sticky;padding-bottom:1%;height:13%;min-height:10%;"> <!-- New compact -->
	    <table>
		<tr>
		<td>
		<div>
		<%  
				NodeDetails nd= null;
				NodedetailsDao ndao = new NodedetailsDao();
				String versn="";
				nd = ndao.getNodeDetails("slnumber", slnumber);
				if(nd != null) {
				versn = nd.getFwversion().trim();
				}
		 %>
			<ul class="submenu1" id="networkmenu">
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('ethernetmenu');showsubmenu3('empty');">Ethernet</a>
				</li>
				<li onclick="hilightthis(this,'submenu1')"><a href="cellular.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('cellularmenu');showsubmenu3('empty');">Cellular</a>
				</li>
				<li onclick="hilightthis(this,'submenu1')"><a href="loopback.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('empty');showsubmenu3('empty');">Loopback</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('firewalmenu');showsubmenu3('empty');">Firewall</a>
				<% 
				    if(versn.trim().startsWith(Symbols.WiZV2+Symbols.EL))
				    {
				%>
				<li onclick="hilightthis(this,'submenu1')"><a href="ipprefixlist.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('empty');showsubmenu3('empty');">IP Prefix List</a></li>
				<% } %>
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('routingmenu');showsubmenu3('empty');">Routing</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('dhcpmenu');showsubmenu3('empty');">DHCP</a></li>
				<!--<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('empty')">DNS</a></li>  -->
				<%
				if(versn.trim().startsWith(Symbols.WiZV2+Symbols.EL))
				   {%>
				<!-- <li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('wan6menu')">WAN6</a> -->
				<li onclick="hilightthis(this,'submenu1')"><a href="wificonfig.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('empty');showsubmenu3('empty');">WiFi</a></li>
				<% } %>
			</ul>

			<!-- networkmenu  end -->
			<!--  servicesmenu start-->
			<ul class="submenu1" id="servicesmenu">
				<li onclick="hilightthis(this,'submenu1')"><a href="healthcheck.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('empty');showsubmenu3('empty');">Health Check</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="smsconfig.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('empty');showsubmenu3('empty');">SMS</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="loadbalancing.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('empty');showsubmenu3('empty');">Load Balancing</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('servpnmenu');showsubmenu3('empty');">VPN</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('managementmenu');showsubmenu3('empty');">Management</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="m2mconfig.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('empty');showsubmenu3('empty');">M2M</a></li>
			</ul>
			<!--  services menu end-->
			<!-- Diagnostics menu start-->
			<ul class="submenu1" id="diagmenu">
				<li onclick="hilightthis(this,'submenu1')"><a href="ping.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('empty')">Ping</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="ping6.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('empty')">Ping6</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="traceroute.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('empty')">Traceroute</a></li>
								<li onclick="hilightthis(this,'submenu1')"><a href="Traceroute6.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('empty')">Traceroute6</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="nslookup.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('empty')">Nslookup</a></li>
			</ul>
			<!-- Diagnostics menu end-->
			<!-- System menu start-->
			<ul class="submenu1" id="sysmenu">
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('systemmenu')">System</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="password.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('empty')">Password</a></li>
				<!-- <li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('configmenu')">Configuration</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="firmwareupg.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('empty')">Firmware Upgrade</a></li> -->
				<li onclick="hilightthis(this,'submenu1')"><a href="reboot.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('empty')">Schedule Reboot</a></li>  
			</ul>
			<!-- System menu end-->
			<!-- status menu start-->
			<ul class="submenu1" id="statusmenu">
				<li onclick="hilightthis(this,'submenu1')"><a href="status.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe" onclick="showsubmenu('empty')">Overview</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('nwstatmenu')">Network</a></li>
			<!--	<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('empty')">Firewall</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('empty')">Routes</a></li>  -->
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('stavpnmenu')">VPN</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="m2mstatus.jsp?slnumber=<%=slnumber%>&version=<%=version%>"  target="displayframe" onclick="showsubmenu('empty')">M2M</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('empty')">Data Usage</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('debugmenu')">Logs</a></li>
			</ul>

			<!-- status menu end-->
		</div>
		</td>
		</tr>
		<tr>
		<td>
		<div>
			<!--  networkmenu start-->
			<ul class="submenu2" id="ethernetmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="lanconfig.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">LAN</a></li>
				<% 
				    if(versn.trim().startsWith(Symbols.WiZV2+Symbols.EL))
				    {
				%>
				<li onclick="hilightthis(this,'submenu2')"><a href="wanconfig.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">WAN</a></li>
				<% } %>
			</ul>
			<ul class="submenu2" id="firewalmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="generalsettings.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">General Settings</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="natrules.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">NAT Rules</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="portforward.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">Port Forwards</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="trafficrules.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">Traffic Rules</a></li>
			</ul>
			
			<ul class="submenu2" id="routingmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="static_routing.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">Static Routing</a></li>
				<% 
				    if(versn.trim().startsWith(Symbols.WiZV2+Symbols.EL))
				    {
				%>
				<li onclick="hilightthis(this,'submenu2')"><a href="dynamic_routing.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">Dynamic Routing</a></li>
				<% } %>
			</ul>
			
			<ul class="submenu2" id="dhcpmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="dhcp.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">Static Leases</a></li>
			</ul>
			<%-- <ul class="submenu2" id="wan6menu">
				<li onclick="hilightthis(this,'submenu2')"><a href="gre.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">GRE</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="gre6in4.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">GRE6in4</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="manual6in4.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">Manual6in4</a></li>
			</ul> --%>
			<!--  networkmenu  end-->
			<!--  servicesmenu start-->
			<ul class="submenu2" id="servpnmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="ipsec.jsp?slnumber=<%=slnumber%>&version=<%=version%>" onclick="showsubmenu3('empty')" target="displayframe">IPSec</a></li>
				 <li onclick="hilightthis(this,'submenu2')"><a href="openvpn.jsp?slnumber=<%=slnumber%>&version=<%=version%>" onclick="showsubmenu3('empty')" target="displayframe">OpenVPN</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="#" onclick="showsubmenu3('gremenu')">GRE</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="zerotire.jsp?slnumber=<%=slnumber%>&version=<%=version%>" onclick="showsubmenu3('empty')" target="displayframe">ZeroTier</a></li>
			</ul>

			<ul class="submenu2" id="managementmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="http.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">HTTP</a></li>
			<!--	<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=SSH.cgi" target="displayframe">SSH</a></li> 
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=Telnet.cgi" target="displayframe">Telnet</a></li>  -->
				<li onclick="hilightthis(this,'submenu2')"><a href="snmp.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">SNMP</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="ntp.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">NTP</a></li>
			</ul>
			<!--  servicesmenu end-->


			<ul class="submenu2" id="systemmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="system.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">Device</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="logging.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">Logging</a></li> 
			</ul>

			<ul class="submenu2" id="configmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="#" target="displayframe">Factory Defaults</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="backup_restore.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">Backup/Restore</a></li>
			</ul>

			<!-- status menu start-->
			<ul class="submenu2" id="nwstatmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="lan_status.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">LAN</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="wan_status.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">WAN</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="cellular_status.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">Cellular</a></li>
			</ul>

			<ul class="submenu2" id="stavpnmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="ipsec_status.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">IPSec</a></li>
			</ul>
			<ul class="submenu2" id="debugmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="ppp_log.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">PPP Log</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="ipsec_log.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">IPSec Log</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="system_log.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">System Log</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="kernel_log.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">Kernel Log</a></li>
			</ul>
			<!-- status menu end-->
		</div>
		</td>
		</tr>
		<!-- submenu 3-->
		<tr>
		<td>
		<div>
			<ul class="submenu3" id="gremenu" style="display:none;">
				<li onclick="hilightthis(this,'submenu3')"><a href="gre.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">GRE</a></li>
				<li onclick="hilightthis(this,'submenu3')"><a href="gre6in4.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">GRE6in4</a></li>
				<li onclick="hilightthis(this,'submenu3')"><a href="manual6in4.jsp?slnumber=<%=slnumber%>&version=<%=version%>" target="displayframe">Manual6in4</a></li>
			</ul>
			<!-- gremenu menu end-->
		</div>
		</td>
		</tr>
		<!--ends submenu3 -->
		</table>
	</div>
	<!-- New compact code start -->	
		<div style="position:relative;height:88%;">
			<iframe style="top:0;left:0;width:100%;height:98%;padding-bottom:0px;overflow: scroll;scrollbar-width:thin;"  frameborder="0" noresize="" name="displayframe" id="displayframe"></iframe>
		</div>
	<!-- New compact code end -->
</body>
</html>
