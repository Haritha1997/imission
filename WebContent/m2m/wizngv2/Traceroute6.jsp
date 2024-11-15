<html>
   <head>
     <link href="/css/solid.css" rel="stylesheet">
	<link href="/css/v4-shims.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="css/style.css">
	<script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
	<script type="text/javascript" src="js/common.js"></script>
<script type = "text/javascript" > 
function validateTrace() {
    var alertmsg = "";
    var ipaddr = document.getElementById("ipaddress");
    var srcintfobj = document.getElementById("srcintfce");
    var sourceinterface = srcintfobj.options[srcintfobj.selectedIndex].text;
    var selectcustom = document.getElementById("interface");
    var valid = validateipv6nameandip("ipaddress", true, "IPv6 Address");
    if (!valid) {
        if (ipaddr.value.trim() == "") alertmsg += "IPv6 Address should not be empty\n";
        else alertmsg += "IPv6 Address is not valid\n";
    }
    valid = IPv6gatewayvalidate("interface", true, "Source Interface");
    if (sourceinterface == "Custom") {
        if (!valid) {
            if (selectcustom.value.trim() == "") alertmsg += "Source Interface should not be empty\n";
            else alertmsg += "Source Interface is not valid\n";
        }
    }
    if (alertmsg.trim().length == 0) return true;
    else {
        alert(alertmsg);
        return false;
    }
}

function selectSourceCustom(id) {
    var srcinfceselobj = document.getElementById(id);
    var srcintfce = srcinfceselobj.options[srcinfceselobj.selectedIndex].text;
    if (srcintfce == "Custom") {
        srcinfceselobj.style.display = 'none';
        var srcinfcetxtobj = document.getElementById("interface");
        srcinfcetxtobj.style.display = 'inline';
        srcinfcetxtobj.focus();
    }
}

function validOnshowSourceComboBox(id, name) {
    if (IPv6gatewayvalidate(id, false, name)) showSourceComboBox(id);
}

function showSourceComboBox(id) {
    var srcinfcetxtobj = document.getElementById(id);
    var srcinfceselobj = document.getElementById('srcintfce');
    if (srcinfcetxtobj.value.trim() != "") {
        if (srcinfceselobj.length == 7) srcinfceselobj.remove(0);
        var newOption = document.createElement('option');
        newOption.value = srcinfcetxtobj.value.trim();
        newOption.innerHTML = srcinfcetxtobj.value.trim();
        srcinfceselobj.add(newOption, 0);
    }
    srcinfcetxtobj.style.display = 'none';
    srcinfceselobj.style.display = 'inline';
    srcinfceselobj.selectedIndex = 0;
}
function showRequredDiv(trace6dis,statusdis)
{
	var routingdivobj = document.getElementById("trace6div");
	routingdivobj.style.display = trace6dis;
	var statusdivobj = document.getElementById("statusdiv");
	statusdivobj.style.display = statusdis;
}
</script>
   </head>
   <body>
      <form action="Nomus.cgi?cgi=TRACEROUTE6PROCESS.cgi" method="post" onsubmit="return validateTrace()">
      <div id="trace6div" align="center">
         <p class="style5" align="center">Network Utilities</p>
         <br>
         <table class="borderlesstab" id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="200">Parameters</th>
                  <th width="200">Configuration</th>
               </tr>
               <tr>
                  <td>IPv6 Address</td>
                  <td><input type="text" class="text" id="ipaddress" name="ipaddress" onfocusout="validateipv6nameandip('ipaddress',true,'IPv6 Address')" onkeypress="return avoidSpace(event)"></td>
               </tr>
               <tr>
                  <td>
                     <div>Source Interface</div>
                  </td>
                  <td>
                     <select name="srcintfce" id="srcintfce" class="text" onchange="selectSourceCustom('srcintfce')">
                        <option value="lan">LAN</option>
                        <option value="wan">WAN</option>
                        <option value="loopback">Loopback</option>
                        <option value="cellular">Cellular</option>
                        <option value="any" selected="">Any</option>
                        <option value="6">Custom</option>
                     </select>
                     <div>
                        <input type="text" class="text" id="interface" name="interface" list="traceconfigs" onfocusout="validOnshowSourceComboBox('interface','Source Interface')" hidden="">
                        <datalist id="traceconfigs">
                           <option>LAN</option>
                           <option>WAN</option>
                           <option>Loopback</option>
                           <option>Cellular</option>
                           <option>Any</option>
                        </datalist>
                     </div>
                  </td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" value="Traceroute" name="Traceroute" style="display:inline block" class="button" onclick="showRequredDiv('none','')"></div>
         </div>
      <div id="statusdiv" align="center" style="margin:0px;display:none;">
			<p class="style1" align="center">Status</p>
            <br>
         <textarea id="text" name="text" cols="80" rows="25" style="font-size:12px" readonly="readonly" wrap="off" align="center">
		 </textarea>
		 <div align="center"><input type="button" onclick="showRequredDiv('','none')" name="Back" value="Back" class="button" ></div>
		 </div>
      </form>
   </body>
</html>