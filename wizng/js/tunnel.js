function avoidSpace(event) {
	var k = event ? event.which : window.event.keyCode;
	if (k == 32) {
		alert("space is not allowed");
		return false;
	}
}

function validateIP(id, checkempty, name) {
	var ipele = document.getElementById(id);
	if (ipele.readOnly == true) {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
	var ipformat = /^(25[0-4]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
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
	} else if (!ipaddr.match(ipformat)) {
		ipele.style.outline = "thin solid red";
		ipele.title = "Invalid " + name;
		return false;
	} else {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
}

function validateIPByAddress(ipaddr, checkempty) {
	var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
	if (ipaddr == "") {
		if (!checkempty) return true;
		else {
			return false;
		}
	}
	if (ipaddr.match(ipformat)) {
		return true;
	} else {
		return false;
	}
}

function validateSubnetMask(id, checkempty, name) {
	var ipele = document.getElementById(id);
	if (ipele.disabled == true) {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
	var ipformat = /^(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$/;
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
	} else if (!ipaddr.match(ipformat)) {
		ipele.style.outline = "thin solid red";
		ipele.title = "Invalid " + name;
		return false;
	} else {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
}

function validateSubnetMaskByAddress(ipaddr, checkempty) {
	var ipformat = /^(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$/;
	if (ipaddr == "") {
		if (!checkempty) return true;
		else {
			return false;
		}
	}
	if (ipaddr.match(ipformat)) {
		return true;
	} else {
		return false;
	}
}

function addRow(tablename) {
	var table = document.getElementById(tablename);
	var rowcnt = table.rows.length;
	if (tablename == "WiZConf1") {
		if (rowcnt == 21) {
			alert("Maximum 20 rows are allowed in Policy Configuration Table");
			return false;
		}
		if (rowcnt == 1) document.getElementById("plcyrwcnt").value = rowcnt;
		rowcnt = document.getElementById("plcyrwcnt").value;
		document.getElementById("plcyrwcnt").value = Number(rowcnt) + 1;
		var row = "<tr><td><input type=\"checkbox\"></input></td><td>"+rowcnt+"</td><td align=\"center\"><select name=\"intf"+rowcnt+"\"  onchange=\"validatesrc('srcntwrk"+rowcnt+"','srcsbntmsk"+rowcnt+"','intf"+rowcnt+"',true,'srcntwrk','srcsbntmsk')\"  id=\"intf"+rowcnt+"\"><option value=\"--Select--\">--Select--</option><option value=\"Eth0\">Eth0</option><option value=\"Loopback\">Loopback</option></select></td><td><input class=\"text\" type=\"text\" id=\"srcntwrk"+rowcnt+"\" name=\"srcntwrk"+rowcnt+"\" maxlength=\"254\" onkeypress=\"return avoidSpace(event)\" onfocusout=\"validateIP('srcntwrk"+rowcnt+"',true,'Source Network')\"></input></td><td><input class=\"text\" type=\"text\" id=\"srcsbntmsk"+rowcnt+"\" name=\"srcsbntmsk"+rowcnt+"\" maxlength=\"254\" onkeyprss=\"returnavoiSpace(event)\" onfocusout=\"validateSubnetMask('srcsbntmsk"+rowcnt+"',true,'Source Subnet Mask')\"></input></td><td><input class=\"text\" type=\"text\" id=\"destntwrk"+rowcnt+"\" name=\"destntwrk"+rowcnt+"\" maxlength=\"254\" onkeypress=\"return avoidSpace(event)\" onfocusout=\"validateIP('destntwrk"+rowcnt+"',true,'Destination Network')\"></input></td><td><input type=\"text\" class=\"text\" id=\"destnsbntmsk"+rowcnt+"\" name=\"destnsbntmsk"+rowcnt+"\" maxlength=\"254\" onkeypress=\"return avoidSpace(event)\" onfocusout=\"validateSubnetMask('destnsbntmsk"+rowcnt+"',true,'Destination Subnet Mask')\"></input></td><td hidden>0</td><td hidden>"+rowcnt+"</td></tr>";
		$('#WiZConf1').append(row);
	}
}

function addPolicyData(row, intf, srcnw, srcsn, desnw, dessn) {
	document.getElementById("intf"+row).value = intf;
	document.getElementById("srcntwrk"+row).value = srcnw;
	document.getElementById("srcsbntmsk"+row).value = srcsn;
	document.getElementById("destntwrk"+row).value = desnw;
	document.getElementById("destnsbntmsk"+row).value = dessn;
	if (intf != "--Select--") {
		var nwobj = document.getElementById("srcntwrk" + row);
		var maskobj = document.getElementById("srcsbntmsk" + row);
		nwobj.disabled = true;
		nwobj.style.backgroundColor = "#808080";
		nwobj.style.outline = "initial";
		nwobj.value = " ";
		maskobj.disabled = true;
		maskobj.style.backgroundColor = "#808080";
		maskobj.style.outline = "initial";
		maskobj.value = " ";
	}
}
function addAclData(row, intf, srcnw, srcsn, desnw, dessn) {
	document.getElementById("intf" + row).value = intf;
	document.getElementById("srcntwrk" + row).value = srcnw;
	document.getElementById("srcsbntmsk" + row).value = srcsn;
	document.getElementById("destntwrk" + row).value = desnw;
	document.getElementById("destnsbntmsk" + row).value = dessn;
}
function deleteRow() {
	try {
		var table = document.getElementById("WiZConf1");
		var rowCount = table.rows.length;
		for (var i = 0; i < rowCount; i++) {
			var row = table.rows[i];
			var chkbox = row.cells[0].childNodes[0];
			if (null != chkbox && true == chkbox.checked) {
				table.deleteRow(i);
				rowCount--;
				i--;
			}
		}
		reindexTable();
	} catch (e) {
		alert(e);
	}
}

function validatesrc(id1, id2, id3, checkempty, name1, name2) {
	var intf = document.getElementById(id3);
	var nwobj = document.getElementById(id1);
	var maskobj = document.getElementById(id2);
	if (intf.value != "--Select--") {
		nwobj.disabled = true;
		nwobj.style.backgroundColor = "#808080";
		nwobj.style.outline = "";
		nwobj.value = "";
		maskobj.disabled = true;
		maskobj.style.backgroundColor = "#808080";
		maskobj.style.outline = "";
		maskobj.value = "";
		return true;
	} else {
		nwobj.disabled = false;
		nwobj.style.backgroundColor = "#ffffff";
		maskobj.disabled = false;
		maskobj.style.backgroundColor = "#ffffff";
		var valid1 = validateIP(nwobj.id, true, "Source Network");
		return ((validateIP(id2, checkempty, name2)) && (validateIP(id1, checkempty, name1)));
	}
	return false;
}

function reindexTable() {
	var table = document.getElementById("WiZConf1");
	var rowCount = table.rows.length;
	for (var i = 1; i < rowCount; i++) {
		var row = table.rows[i];
		row.cells[1].innerHTML = i;
	}
}

function validateIPSec() {
	var alertmsg = "";
	var title = ["IPSec"];
	var gnrlcnfgtnids = ["rempeer", "scndrypeer"];
	var gnrlcnfgtnnames = ["Remote Peer", "Secondary Peer"];
	var iptables = [gnrlcnfgtnids];
	var namestables = [gnrlcnfgtnnames];
	var tbc;
	
	var cbval = document.getElementById("lidopt").value;
	for (tbc = 0; tbc < iptables.length; tbc++) {
		var iptable = iptables[tbc];
		var namestable = namestables[tbc];
		for (i = 0; i < iptable.length; i++) {
			var ipele = document.getElementById(iptable[i]);
			if (ipele.disabled == true) continue;
			var valid = true;
			if (ipele.value == "0.0.0.0") valid = false;
			else {
				if (cbval != "FQDN Client") valid = validateIPByAddress(ipele.value, true);
			}
			if (valid) {
				continue;
			} else {
				ipele.style.outline = "thin solid red";
				if (ipele.value == "") {
					alertmsg += namestable[i] + " Of General Configuration Table Should Not Be Empty.\n";
					ipele.title = namestable[i] + " should not be empty";
				} else {
					alertmsg += "Invalid " + namestable[i] + "(" + ipele.value + ") Of General Configuration .\n";
					ipele.title = "Invalid " + namestable[i];
				}
			}
		}
	}
	var plcycnfgipids = ["srcntwrk", "srcsbntmsk", "destntwrk", "destnsbntmsk"];
	var plcycnfgnames = ["Source Network", "Source Subnet Mask", "Destination Network", "Destination Subnet Mask"];
    var iptables = [plcycnfgipids,plcycnfgnames];
	var iptable = plcycnfgipids;
	var namestable = plcycnfgnames;
		var table = document.getElementById("WiZConf1");
		var rowcnt = table.rows.length;
		for (var j = 1; j < rowcnt; j++) {
			var cells = table.rows[j].cells;
			var rlen = cells.length;
			var actrowid = cells[cells.length - 1].innerHTML;
			
			for (i = 0; i < plcycnfgipids.length; i++) {
				var ipele = document.getElementById(iptable[i] + actrowid);
				if (ipele.disabled == true) continue;
				var valid = false;
				if (namestable[i] == "Source Network" || namestable[i] == "Destination Network") {
					valid = validateIP(ipele.id, true, namestable[i]);
				} else if (namestable[i].endsWith("Subnet Mask")) {
					valid = validateSubnetMask(ipele.id,true,namestable[i]);
				}
				if (valid) {
					continue;
				} else {
					ipele.style.outline = "thin solid red";
					if (ipele.value == "") {
						alertmsg += namestable[i] + " Of Policy Configuration  Table in row " + j + " Should Not Be Empty.\n";
						ipele.title = namestable[i] + " should not be empty";
					} else {
						alertmsg += "Invalid " + namestable[i] + "(" + ipele.value + ") Of Policy Configuration Table in row " + j + ".\n";
						ipele.title = "Invalid " + namestable[i];
					}
				}
			}
		}
	var preshar1 = document.getElementById("keycnfgrtn");
	var preshar2 = document.getElementById("keycnfgrtn2");
	if (preshar1.value.trim().length == 0) {
		preshar1.style.outline = "thin solid red";
		alertmsg += " Preshared key 1 Should not be empty.\n";
	} else {
		preshar1.style.outline = "initial";
	}
	var obj = document.getElementById("dualpeer");
	if ((obj.checked) && (preshar2.value.trim().length == 0)) {
		preshar2.style.outline = "thin solid red";
		alertmsg += " Preshared key 2 Should not be empty.\n";
	} else {
		preshar2.style.outline = "initial";
	}
	if (alertmsg != "") {
		alert(alertmsg);
		return false;
	} else return true;
}

function editDPDFields() {
	var dpdservice = document.getElementById("dpdserv").value;
	var dpdrow = document.getElementById("DPD_detrow");
	var DPD_Inttd = document.getElementById("DPD_Int").value;
	var DPD_retr = document.getElementById("DPD_retr").value;
	var DPD_fails = document.getElementById("DPD_fails").value;
	if (dpdservice == "Enable") 
		dpdrow.style.display = "";
	else {
		dpdrow.style.display = "none";
		document.getElementById("DPD_Int").value = 10;
		document.getElementById("DPD_retr").value = 2;
		document.getElementById("DPD_fails").value = 2;
	}
}

function editSecondaryPeer() {
	if (document.getElementById("dualpeer").checked) {
		var secpeer = document.getElementById("scndrypeer");
		var remoteid = document.getElementById("ridopt").value;
		var secpeerdns = document.getElementById("scndrypeerdns");
		if (remoteid == "IP Address") {
			secpeer.disabled = false;
			secpeer.style.backgroundColor = "#ffffff";
			secpeerdns.disabled = true;
		} else {
			secpeer.disabled = true;
			secpeerdns.disabled = false;
			secpeerdns.style.backgroundColor = "#ffffff";
		}
		var preskey2 = document.getElementById("keycnfgrtn2");
		preskey2.disabled = false;
		preskey2.style.backgroundColor = "#ffffff";
	} else {
		var secpeer = document.getElementById("scndrypeer");
		secpeer.disabled = true;
		secpeer.value = "";
		secpeer.style.backgroundColor = "#808080";
		secpeer.style.outline = "initial";
		var secpeerdns = document.getElementById("scndrypeerdns");
		secpeerdns.disabled = true;
		secpeerdns.value = "";
		secpeerdns.style.backgroundColor = "#808080";
		secpeerdns.style.outline = "initial";
		var preskey2 = document.getElementById("keycnfgrtn2");
		preskey2.disabled = true;
		preskey2.value = "";
		preskey2.style.backgroundColor = "#808080";
		preskey2.style.outline = "initial";
	}
}

function makeEditableFields(cbid) {
	var cbval = document.getElementById(cbid).value;
	var remoteIDdropbox = document.getElementById("ridopt");
	var idarr = ["Agsvemode", "dualpeer", "rempeer", "keycnfgrtn2"];
	if (cbval == "FQDN Client") {
		remoteIDdropbox.value = "FQDN Server";
		for (var i = 0; i < 2; i++) {
			var obj = document.getElementById(idarr[i]);
			obj.disabled = true;
			obj.checked = false;
			obj.style.backgroundColor = "#808080";
			obj.style.outline = "initial";
		}
		var obj = document.getElementById(idarr[2]);
		obj.disabled = false;
		obj.style.backgroundColor = "#ffffff";
	} else if (cbval == "2") {
		if(remoteIDdropbox.value == "FQDN Server")
			remoteIDdropbox.value = "IP Address";
		var obj;
		for (var i = 0; i < idarr.length; i++) {
			obj = document.getElementById(idarr[i]);
			if (obj.type == "text") obj.value = "0.0.0.0";
			else obj.checked = false;
			obj.disabled = true;
			obj.style.backgroundColor = "#808080";
			obj.style.outline = "initial";
			obj.value = "";
		}
	} else {
		if (remoteIDdropbox.value != "Domain Name") remoteIDdropbox.value = "IP Address";
		for (var i = 0; i < idarr.length; i++) {
			var obj = document.getElementById(idarr[i]);
			obj.disabled = false;
			obj.style.backgroundColor = "#ffffff";
		}
		if (remoteIDdropbox.value == "Domain Name") {
			var rempeer = document.getElementById(idarr[2]);
			rempeer.value = "0.0.0.0";
			rempeer.disabled = true;
			rempeer.style.backgroundColor = "#808080";
			rempeer.style.outline = "initial";
		}
	}
	editFQDNEndPoint("lidopt", "lfqep");
	editFQDNEndPoint("ridopt", "rfqep");
	editSecondaryPeer();
	setPeerVisibleFields();
}

function setPeerVisibleFields() {
	var remidval = document.getElementById("ridopt").value;
	var iparr = ["rempeer", "scndrypeer"];
	var dnsarr = ["rempeerdns", "scndrypeerdns"];
	if (remidval == "Domain Name") {
		for (var i = 0; i < iparr.length; i++) {
			var obj = document.getElementById(iparr[i]);
			obj.value = "0.0.0.0";
			obj.style.display = "none";
		}
		for (var i = 0; i < dnsarr.length; i++) {
			var obj = document.getElementById(dnsarr[i]);
			obj.style.display = "";
			if (i != 1) obj.disabled = false;
		}
	} else {
		for (var i = 0; i < dnsarr.length; i++) {
			var obj = document.getElementById(dnsarr[i]);
			obj.style.display = "none";
		}
		for (var i = 0; i < iparr.length; i++) {
			var obj = document.getElementById(iparr[i]);
			obj.style.display = "";
			if (i != 1) obj.disabled = false;
		}
	}
}

function editFQDNEndPoint(cbid, txtid) {
	var cbval = document.getElementById(cbid).value;
	var fqdntxtobj = document.getElementById(txtid);
	var remendp2;
	if (cbid == "ridopt") remendp2 = document.getElementById(txtid + "2");
	if (cbval == "IP Address" || cbval == "Domain Name") {
		fqdntxtobj.disabled = true;
		fqdntxtobj.value = "";
		fqdntxtobj.style.backgroundColor = "#808080";
		fqdntxtobj.style.outline = "initial";
	} else {
		fqdntxtobj.disabled = false;
		fqdntxtobj.style.backgroundColor = "#ffffff";
	}
}

function checkLoacalDroopBoxValue() {
	makeEditableFields("lidopt");
}

function IPv4AddressKeyOnly(e) {
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	if ((keyCode == 46 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode >= 48 && keyCode <= 57)) {
		return true;
	}
	return false;
}
