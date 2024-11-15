function IPv4AddressKeyOnly(e) {
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	//<-----------arrows--------->           <---Dot---->  <--backspace-> <----Tab--->      <-----CR------>     <----------digits------------>       
	if ((keyCode >= 37 && keyCode <= 40) || (keyCode == 46 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode >= 48 && keyCode <= 57)) {
		return true;
	}
	return false;
}

function chkIPV4(ip4_len) {
	for (x = 0; x < ip4_len; x++) {
		var id_name = "ip4_" + (x + 1); // to get the ip4 ids dynamically....
		var ip4add = document.getElementById(id_name).value;
		var ipv4 = document.getElementById(id_name);
		if (ip4add.length == 0 || ip4add == "NA") {
			ipv4.style.background = "white";
			return true;
		}
		var name = document.getElementById(id_name).name;
		var chk_arr = ip4add.split(".");
		if (chk_arr.length != 4) {
			alert(name + " is not Valid");
			ipv4.style.background = "pink";
			return false;
		}
		for (var i = 0; i < chk_arr.length; i++) {
			if (!(/^\d+/.test(chk_arr[i]))) {
				alert(name + " is not Valid");
				ipv4.style.background = "pink";
				return false;
			} else if (chk_arr[i] < 0 || chk_arr[i] > 255) {
				alert(name + " is not Valid");
				ipv4.style.background = "pink";
				return false;
			}
		}
	}

	ipv4.style.background = "white";
	return true;
}

function AddrMatch() {
	var NWAddr = document.getElementById("ip4_1").value;
	var NMAddr = document.getElementById("ip4_2").value;
	var GWAddr = document.getElementById("ip4_3").value;
	if ((NWAddr == NMAddr) || (NMAddr == GWAddr) || (NWAddr == GWAddr)) {
		alert("Netwokr IP, Netmask IP and Gateway IP cannot be same !!");
		return false;
	}
	return true;
}

function chkMACAddr(MAC_len) {
	for (x = 0; x < MAC_len; x++) {
		var id_name = "MAC_" + (x + 1); // to get the MAC ids dynamically....
		var MACadd = document.getElementById(id_name).value;
		var MAC = document.getElementById(id_name);
		if (MACadd.length == 0 || MACadd == "NA") {
			MAC.style.background = "white";
			return true;
		}
		var name = document.getElementById(id_name).name;
		var chk_arr = MACadd;
		var regexMac = /^([0-9A-F]{2}[:-]){5}([0-9A-F]{2})$/i
		if (!(regexMac.test(chk_arr))) {
			alert(name + " is not Valid");
			MAC.style.background = "pink";
			return false;
		}
	}

	MAC.style.background = "white";
	return true;
}

function chkMulticast(ip4_len) {
	for (x = 0; x < ip4_len; x++) {
		var id_name = "ip4_" + (x + 1); // to get the ip4 ids dynamically....
		var ip4add = document.getElementById(id_name).value;
		var ipv4 = document.getElementById(id_name);
		if (ip4add.length == 0 || ip4add == "NA") {
			ipv4.style.background = "white";
			return true;
		}
		var name = document.getElementById(id_name).name;
		var chk_arr = ip4add.split(".");
		if (chk_arr.length != 4) {
			alert(name + " is not Valid");
			ipv4.style.background = "pink";
			return false;
		}
		for (var i = 0; i < chk_arr.length; i++) {
			if (!(/^\d+/.test(chk_arr[i]))) {
				alert(name + " is not Valid");
				ipv4.style.background = "pink";
				return false;
			} else if ((chk_arr[0] < 224 || chk_arr[0] > 239) || (chk_arr[1] < 0 || chk_arr[1] > 255) || (chk_arr[2] < 0 || chk_arr[2] > 255) || (chk_arr[3] < 0 || chk_arr[3] > 255)) {
				alert(name + " is not Valid");
				ipv4.style.background = "pink";
				return false;
			}
		}
	}
	ipv4.style.background = "white";
	return true;
}