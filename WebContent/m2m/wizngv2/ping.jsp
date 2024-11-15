<html>
   <head>
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
      <style></style>
      <script type="text/javascript" src="js/common.js"></script>
	  <script type="text/javascript">
	  function validatePing() {
	var alertmsg = "";
	var ipaddr = document.getElementById("ipaddress");
	var srcintfobj = document.getElementById("srcintfce");
	var sourceinterface = srcintfobj.options[srcintfobj.selectedIndex].text;
	var selectcustom = document.getElementById("interface");
	var noofframes = document.getElementById("frames");
	var valid = validatenameandip("ipaddress", true, "IP Address");
	if (!valid) {
		if (ipaddr.value.trim() == "") alertmsg += "IP Address should not be empty\n";
		else alertmsg += "IP Address is not valid\n";
	}
	valid = validateIP("interface", true, "Source Interface");
	if (sourceinterface == "Custom") {
		if (!valid) {
			if (selectcustom.value.trim() == "") alertmsg += "Source Interface should not be empty\n";
			else alertmsg += "Source Interface is not valid\n";
		}
	}
	valid = validateRange("frames", true, "No.of Frames");
	if (!valid) {
		if (noofframes.value.trim() == "") alertmsg += "No.of Frames should not be empty\n";
		else alertmsg += "No.of Frames is not valid\n";
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
	if (validateIP(id, false, name)) showSourceComboBox(id);
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

function validateRange(id, checkempty, name) {
	var rele = document.getElementById(id);
	var val = rele.value;
	var max = Number(rele.max);
	var min = Number(rele.min);
	if (val.trim() == "") {
		if (checkempty) {
			rele.style.outline = "thin solid red";
			rele.title = name + " should be integer in the range from " + min + " to " + max;
			return false;
		} else {
			rele.style.outline = "initial";
			rele.title = "";
			return true;
		}
	} else if (val >= min && val <= max) {
		rele.style.outline = "initial";
		rele.title = "";
		return true;
	} else {
		rele.style.outline = "thin solid red";
		rele.title = name + " should be in the range from " + min + " to " + max;
		return false;
	}
}
	  </script>
   </head>
   <%String slnumber=request.getParameter("slnumber"); %>
   <body>
      <form action="savedetails.jsp?page=ping&slnumber=<%=slnumber%>" method="post" onsubmit="return validatePing()">
         <p class="style5" align="center">Network Utilities</p>
         <br>
         <table class="borderlesstab" id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="200">Parameters</th>
                  <th width="200">Configuration</th>
               </tr>
               <tr>
                  <td>IP Address</td>
                  <td><input type="text" class="text" id="ipaddress" name="ipaddress" onfocusout="validatenameandip('ipaddress',true,'IP Address')" onkeypress="return avoidSpace(event)"></td>
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
                        <input hidden="" type="text" class="text" id="interface" name="interface" list="pingconfigs" onfocusout="validOnshowSourceComboBox('interface','Source Interface')">
                        <datalist id="pingconfigs">
                           <option>LAN</option>
                           <option>WAN</option>
                           <option>Loopback</option>
                           <option>Cellular</option>
                           <option>Any</option>
                        </datalist>
                     </div>
                  </td>
               </tr>
               <tr>
                  <td>No.of Frames</td>
                  <td><input type="number" class="text" id="frames" name="frames" min="1" max="50" onfocusout="validateRange('frames',true,'No.of Frames')"></td>
               </tr>
               <tr></tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" value="Ping" name="Ping" style="display:inline block" class="button"></div>
      </form>
   </body>
</html>