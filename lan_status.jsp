<html>
   <head>
      <meta http-equiv="refresh" content="5">
      <link href="css/fontawesome.css" rel="stylesheet">
      <link href="css/solid.css" rel="stylesheet">
      <link href="css/v4-shims.css" rel="stylesheet">
      <link href="css/style.css" rel="stylesheet" type="text/css">
      <script type="text/javascript">
	  function showDivision(divname) {
	var divname_arr = ["lanpage", "dhcppage"];
	var list = document.getElementById("lanstatusdiv");
	var childs = list.children;
	for (var i = 0; i < divname_arr.length; i++) {
		if (divname == divname_arr[i]) {
			document.getElementById(divname_arr[i]).style.display = "inline";
			childs[i].children[0].id = "hilightthis";
		} else {
			document.getElementById(divname_arr[i]).style.display = "none";
			childs[i].children[0].id = "";
		}
	}
	setSavedItem('LanStatusPage', divname);
}

function setSavedItem(id, value) {
	localStorage.setItem(id, value);
}

function getSavedItem(v) {
	if (!localStorage.getItem(v)) return null;
	return localStorage.getItem(v);
}

function loadTabedPage() {
	var page = getSavedItem('LanStatusPage');
	if (page == null) {
		showDivision('lanpage');
	} else {
		showDivision(page);
	}
}
	  </script>
      <style></style>
   </head>
   <body>
      <table class="borderlesstab nobackground" id="WiZConf" align="center" style="width:600px;margin-bottom:0px;">
         <tbody>
            <tr style="padding:0px;margin:0px;">
               <td style="padding:0px;margin:0px;">
                  <ul id="lanstatusdiv">
                     <li><a class="casesense lanstatus" onclick="showDivision('lanpage')" id="hilightthis">LAN Status</a></li>
                     <li><a class="casesense lanstatus" onclick="showDivision('dhcppage')" id="">Active DHCP Leases</a></li>
                  </ul>
               </td>
            </tr>
         </tbody>
      </table>
      <div id="lanpage" align="center" style="margin: 0px; display: inline;">
         <table class="borderlesstab" id="lanstatus1" align="center" style="width:600px;">
            <tbody>
               <tr>
                  <th width="250px">Parameters</th>
                  <th width="350px">Status</th>
               </tr>
               <tr>
                  <td>Link Status</td>
                  <td>
                     <div><img style="vertical-align:middle;display:inline;" src="/icons/port_down.png" width="31" height="25">&nbsp;&nbsp;<img style="vertical-align:middle;display:inline;" src="/icons/port_down.png" width="31" height="25">&nbsp;&nbsp;<img style="vertical-align:middle;display:inline;" src="/icons/port_down.png" width="31" height="25">&nbsp;&nbsp;<img style="vertical-align:middle;display:inline;" src="/icons/port_up.png" width="31" height="25"><br>LAN1&nbsp;&nbsp;LAN2&nbsp;&nbsp;LAN3&nbsp;&nbsp;LAN4</div>
                  </td>
               </tr>
               <tr>
                  <td>Status</td>
                  <td>Up</td>
               </tr>
               <tr>
                  <td>Protocol</td>
                  <td>Static address</td>
               </tr>
               <tr>
                  <td>Uptime</td>
                  <td>0h 42m 13s</td>
               </tr>
               <tr>
                  <td>MAC Address</td>
                  <td>00:22:85:aa:bb:cc</td>
               </tr>
               <tr>
                  <td>RX</td>
                  <td>2.29 MB  (20925 Pkts)</td>
               </tr>
               <tr>
                  <td>TX</td>
                  <td>27.86 MB  (27331 Pkts)</td>
               </tr>
               <tr>
                  <td>IPv4 Address</td>
                  <td>192.168.1.1/24</td>
               </tr>
               <tr>
               	<td>IPv6 Address</td>
               	<td></td>
               </tr>
            </tbody>
         </table>
         <br><br>
      </div>
      <div id="dhcppage" align="center" style="margin: 0px; display: none;">
         <table class="borderlesstab" style="width:600px;" align="center" id="lanstatus2">
            <tbody>
               <tr>
                  <th>Hostname</th>
                  <th>IPv4-Address</th>
                  <th>MAC-Address</th>
                  <th>Leasetime remaining</th>
               </tr>
               <tr>
                  <td colspan="4">
                     <center>There are no active leases</center>
                  </td>
               </tr>
            </tbody>
         </table>
         <br><br>
      </div>
      <script>loadTabedPage();</script>
   </body>
</html>