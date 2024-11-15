<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/css/style.css"/>
<style type="text/css">
a:hover {
	font-size:14;
}
</style>
<script type = "text/javascript">
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
		document.getElementById('displayframe').src = "welcome.html";
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
				   "stavpnmenu","debugmenu","nwstatmenu","routingmenu","systemmenu", "dhcpmenu", "configmenu"];
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
</script>
</head>
<body onload="loadFunction()">
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
	<div style="position:relative;padding-bottom:1%;"> <!-- New compact -->
	    <table>
		<tr>
		<td>
		<div>
			<ul class="submenu1" id="networkmenu">
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('ethernetmenu')">Ethernet</a>
				</li>
				<li onclick="hilightthis(this,'submenu1')"><a href="/cgi/Nomus.cgi?cgi=CellularAddress.cgi" target="displayframe" onclick="showsubmenu('cellularmenu')">Cellular</a>
				</li>
				<li onclick="hilightthis(this,'submenu1')"><a href="/cgi/Nomus.cgi?cgi=LoopbackAddress.cgi" target="displayframe" onclick="showsubmenu('empty')">Loopback</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('firewalmenu')">Firewall</a>
				
				<!-- <li onclick="hilightthis(this,'submenu1')"><a href="/cgi/Nomus.cgi?cgi=StaticRoute.cgi" target="displayframe" onclick="showsubmenu('empty')" >Static Routes</a></li> -->
				
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('routingmenu')">Routing</a></li>


				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('dhcpmenu')">DHCP</a></li>
				<!--<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('empty')">DNS</a></li>  -->
			</ul>

			<!-- networkmenu  end -->
			<!--  servicesmenu start-->
			<ul class="submenu1" id="servicesmenu">
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('empty')">Health Check</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('empty')">SMS</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('servpnmenu')">VPN</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('managementmenu')">Management</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="/cgi/Nomus.cgi?cgi=M2MConfig.cgi" target="displayframe" onclick="showsubmenu('empty')">M2M</a></li>
			</ul>

			<!--  services menu end-->
			<!-- Diagnostics menu start-->
			<ul class="submenu1" id="diagmenu">
				<li onclick="hilightthis(this,'submenu1')"><a href="/cgi/Nomus.cgi?cgi=Ping.cgi" target="displayframe" onclick="showsubmenu('empty')">Ping</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="/cgi/Nomus.cgi?cgi=Traceroute.cgi" target="displayframe" onclick="showsubmenu('empty')">Traceroute</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="/cgi/Nomus.cgi?cgi=NsLookup.cgi" target="displayframe" onclick="showsubmenu('empty')">Nslookup</a></li>
			</ul>
			<!-- Diagnostics menu end-->
			<!-- System menu start-->
			<ul class="submenu1" id="sysmenu">
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('systemmenu')">System</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="/cgi/Nomus.cgi?cgi=Password.cgi" target="displayframe" onclick="showsubmenu('empty')">Password</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('configmenu')">Configuration</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="/cgi/Nomus.cgi?cgi=FirmwareUpgrade.cgi" target="displayframe" onclick="showsubmenu('empty')">Firmware Upgrade</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="/cgi/Nomus.cgi?cgi=Reboot.cgi" target="displayframe" onclick="showsubmenu('empty')">Reboot</a></li>
			</ul>
			<!-- System menu end-->
			<!-- status menu start-->
			<ul class="submenu1" id="statusmenu">
				<li onclick="hilightthis(this,'submenu1')"><a href="/cgi/Nomus.cgi?cgi=Overview.cgi" target="displayframe" onclick="showsubmenu('empty')">Overview</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('nwstatmenu')">Network</a></li>
			<!--	<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('empty')">Firewall</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('empty')">Routes</a></li>  -->
				<li onclick="hilightthis(this,'submenu1')"><a href="#" onclick="showsubmenu('stavpnmenu')">VPN</a></li>
				<li onclick="hilightthis(this,'submenu1')"><a href="/cgi/Nomus.cgi?cgi=M2MStatus.cgi" target="displayframe" onclick="showsubmenu('empty')">M2M</a></li>
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
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=LanAddress.cgi" target="displayframe">LAN</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=WanAddress.cgi" target="displayframe">WAN</a></li>
			</ul>
			<ul class="submenu2" id="firewalmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=GeneralSettings.cgi" target="displayframe">General Settings</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=NATRules.cgi" target="displayframe">NAT Rules</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=PortForwards.cgi" target="displayframe">Port Forwards</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=TrafficRules.cgi" target="displayframe">Traffic Rules</a></li>
			</ul>

			<ul class="submenu2" id="routingmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=StaticRoute.cgi" target="displayframe">Static Routing</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=OspfRoute.cgi" target="displayframe">Dynamic Routing</a></li>
			</ul>

			<ul class="submenu2" id="dhcpmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=StaticLease.cgi" target="displayframe">Static Leases</a></li>
			</ul>
			<!--  networkmenu  end-->
			<!--  servicesmenu start-->
			<ul class="submenu2" id="servpnmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=IPSec.cgi" target="displayframe">IPSec</a></li>
			</ul>

			<ul class="submenu2" id="managementmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=HTTP.cgi" target="displayframe">HTTP</a></li>
			<!--	<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=SSH.cgi" target="displayframe">SSH</a></li> 
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=Telnet.cgi" target="displayframe">Telnet</a></li>  -->
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=SNMP.cgi" target="displayframe">SNMP</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=NTP.cgi" target="displayframe">NTP</a></li>
			</ul>
			<!--  servicesmenu end-->


			<ul class="submenu2" id="systemmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=System.cgi" target="displayframe">System</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=Logging.cgi" target="displayframe">Logging</a></li> 
			</ul>

			<ul class="submenu2" id="configmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=FactoryDefaults.cgi" target="displayframe">Factory Defaults</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=BackupRestore.cgi" target="displayframe">Backup/Restore</a></li>
			</ul>

			<!-- status menu start-->
			<ul class="submenu2" id="nwstatmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=LanStatus.cgi" target="displayframe">LAN</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=WanStatus.cgi" target="displayframe">WAN</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=CellularStatus.cgi" target="displayframe">Cellular</a></li>
			</ul>

			<ul class="submenu2" id="stavpnmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=IPSecStatus.cgi" target="displayframe">IPSec</a></li>
			</ul>
			<ul class="submenu2" id="debugmenu">
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=PPPLog.cgi" target="displayframe">PPP Log</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=IPSecLog.cgi" target="displayframe">IPSec Log</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=SystemLog.cgi" target="displayframe">System Log</a></li>
				<li onclick="hilightthis(this,'submenu2')"><a href="/cgi/Nomus.cgi?cgi=KernelLog.cgi" target="displayframe">Kernel Log</a></li>
			</ul>
			<!-- status menu end-->
		</div>
		</td>
		</tr>
		</table>
	</div>
	<!-- New compact code start -->
	<div>	
		<div style="position:relative;padding-top:56.25%;">
			<iframe style="position:absolute;top:0;left:0;width:100%;height:100%;" allowfullscreen frameborder="0" noresize="" name="displayframe" id="displayframe"></iframe>
		</div>
	</div>
	<!-- New compact code end -->
</body>
</html>
