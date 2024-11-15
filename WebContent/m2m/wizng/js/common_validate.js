function digitKeyOnly(e) {
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	//<-----------arrows--------->           <--backspace-> <----Tab--->    <-----CR------>    <----------digits------------>       
	if ((keyCode >= 37 && keyCode <= 40) || (keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode >= 48 && keyCode <= 57)) {
		return true;
	}
	return false;
}

function SerialNumKeyOnly(e, x, y) {
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	var value = Number(e.target.value + e.key) || 0;

	if ((keyCode >= 37 && keyCode <= 40) || (keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode >= 48 && keyCode <= 57)) {
		return isValidNumber(value, x, y);
	}
	return false;
}

function TrapKeyOnly(e) {
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	//<-----------arrows--------->          <-----Minus--->   <--backspace-> <----Tab--->    <-----CR------>    <----------digits------------>       
	if ((keyCode >= 37 && keyCode <= 40) || (keyCode == 45 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode >= 48 && keyCode <= 57)) {
		return true;
	}
	return false;
}

function isValidNumber(number, min, max) {
	if (number == 0)
		return true;
	else
		return (min <= number && number <= max);
}

function chkPort(port_len) {
	for (x = 0; x < port_len; x++) {
		var id_name = "port_" + (x + 1);
		var port_val = document.getElementById(id_name).value;
		var port = document.getElementById(id_name);
		var name = document.getElementById(id_name).name;
		if (parseInt(port_val) < 0 || parseInt(port_val) > 65535) {
			alert(name + " is not Valid");
			port.style.background = "pink";
			return false;
		}
		// if(name=="End Port" && (parseInt(port_val)<parseInt(document.getElementById("port_1").value)) && 1>0)
		// {
		// 	alert(name+ " must greater than Start Port");
		// 	return false;
		// }
	}
	port.style.background = "white";
	return true;
}

function chk_SHDSLTraps(len) {
	var x;
	for (x = 0; x < len; x++) {
		var id_name = "range_" + (x + 1);
		var val = document.getElementById(id_name).value;
		var name = document.getElementById(id_name).name;
		var range = document.getElementById(id_name);
		switch (x) {
			case 0:
			case 1:
				if (parseInt(val) < -127 || parseInt(val) > 128) {
					alert(name + " is not Valid");
					range.style.background = "pink";
					return false;
				}
				break;
			case 2:
			case 3:
			case 5:
			case 6:
				if (parseInt(val) < 0 || parseInt(val) > 900) {
					alert(name + " is not Valid");
					range.style.background = "pink";
					return false;
				}
				break;

			case 4:
				if (parseInt(val) < 0 || parseInt(val) > 2147483647) {
					alert(name + " is not Valid");
					range.style.background = "pink";
					return false;
				}
				break;
		}
	}
	range.style.background = "white";
	return true;
}

function SNMP_SytemParams(len) {
	var x;
	for (x = 0; x < len; x++) {
		var id_name = "SNMP_" + (x + 1);
		var val = document.getElementById(id_name).value;
		var name = document.getElementById(id_name).name;
		var test = document.getElementById(id_name);
		var len1 = val.length;
		if (len1 > 125) {
			for (var i = 0; i < len1; i++) {
				var Ch = val.charCodeAt(i);
				if (((Ch >= 0) && (Ch <= 47)) || ((Ch >= 58) && (Ch <= 64)) || ((Ch >= 91) && (Ch <= 96)) || ((Ch >= 123) && (Ch <= 127))) {
					alert("Only 125 Special Characters are Allowed !!");
					test.style.background = "pink";
					return false;
				}
			}
		}

	}
	test.style.background = "white";
	return true;
}

function Change_Pswd() {
	//New Password
	name1 = document.getElementById("NewPass").name;
	val1 = document.getElementById("NewPass").value;
	len1 = document.getElementById("NewPass").length;
	newpass = document.getElementById("NewPass");

	// Confirm Password
	name2 = document.getElementById("ReNewPass").name;
	val2 = document.getElementById("ReNewPass").value;
	len2 = document.getElementById("ReNewPass").length;
	renewpass = document.getElementById("ReNewPass");

	if (!(val1 == val2 && len1 == len2)) {
		alert("New Password and Confirm Password does not Match !!");
		newpass.style.background = "pink";
		renewpass.style.background = "pink";
		return false;
	}
	newpass.style.background = "white";
	renewpass.style.background = "white";
	return true;
}

function checkFrames() {
	var obj = document.getElementById("NoofFrames");
	var val = obj.value;
	var name = obj.name;
	var ch = val.charCodeAt("NoofFrames");
	if ((ch < 48 || ch > 57)) {
		alert(name + " is not Valid");
		obj.style.background = "pink";
		return false;
	}
	if (parseInt(val) < 1 || parseInt(val) > 50) {
		alert(name + " is not Valid");
		obj.style.background = "pink";
		return false;
	}
	obj.style.background = "white";
	obj.style.background = "white";
	return true;
}

function chkFilter_Port(port_len) {
	for (x = 0; x < port_len; x++) {
		var id_name = "Port_" + (x + 1);
		var port_val = document.getElementById(id_name).value;
		var port = document.getElementById(id_name);
		var name = document.getElementById(id_name).name;
		if (parseInt(port_val) < 0 || parseInt(port_val) > 65535) {
			alert(name + " is not Valid");
			port.style.background = "pink";
			return false;
		}
		if (name == "Source End Port" && (parseInt(port_val) < parseInt(document.getElementById("Port_1").value)) && 1 > 0) {
			alert(name + " must greater than Source Start Port");
			return false;
		}
		if (name == "Dest. End Port" && (parseInt(port_val) < parseInt(document.getElementById("Port_3").value)) && 1 > 0) {
			alert(name + " must greater than Dest. Start Port");
			return false;
		}

	}
	port.style.background = "white";
	return true;
}

function chk_IPFilterName() {
	var id_name = "name_1";
	var val = document.getElementById(id_name).value;
	var Fname = document.getElementById(id_name);
	var name = document.getElementById(id_name).name;
	var len = val.length;
	var j;
	for (j = 0; j < len; j++) {
		var ascii;
		ascii = val.charCodeAt(j);
		if ((ascii < 47 || ascii > 57) && (ascii < 65 || ascii > 90) && (ascii < 97 || ascii > 122)) {
			alert(name + " is not valid");
			Fname.style.background = "pink";
			return false;
		}
	}
	Fname.style.background = "white";
	return true;
}

function chk_ICMP_Type() {
	var id_name = "ICMP_Type";
	var val = document.getElementById(id_name).value;
	var ICMPname = document.getElementById(id_name);
	var name = document.getElementById(id_name).name;
	switch (parseInt(val)) {
		case 0:
		case 3:
		case 4:
		case 5:
		case 8:
		case 9:
		case 10:
		case 11:
		case 12:
		case 13:
		case 14:
		case 17:
		case 18:
			return true;
		default:
			alert(name + "Invalid\n\r Valid ICMP Types : 0,3-5,8-14,17,18");
			ICMPname.style.background = "pink";
			return false;
	}
	ICMPname.style.background = "white";
	return true;
}

function checkPPP_Pswd() {
	if (document.getElementById("Edit_Pswd").checked) {
		val1 = document.getElementById("PPP_NewPass").value;
		len1 = val1.length;
		NewPswd = document.getElementById("PPP_NewPass");

		val2 = document.getElementById("PPP_ReNewPass").value;
		len2 = val2.length;
		Re_NewPswd = document.getElementById("PPP_ReNewPass");

		if (!(val1 == val2 && len1 == len2)) {
			alert("New Password and Confirm Password does not Match !!");
			NewPswd.style.background = "pink";
			Re_NewPswd.style.background = "pink";
			return false;
		}
	}
	NewPswd.style.background = "white";
	Re_NewPswd.style.background = "white";
	return true;
}

function ChkDLTimeout(dl_len) {
	for (x = 0; x < dl_len; x++) {
		var id_name = "dl_" + (x + 1);
		var dl_val = document.getElementById(id_name).value;
		var dloop = document.getElementById(id_name);
		var name = document.getElementById(id_name).name;
		if (parseInt(dl_val) < 0 || parseInt(dl_val) > 4095) {
			alert(name + " is not Valid");
			dloop.style.background = "pink";
			return false;
		}
	}
	dloop.style.background = "white";
	return true;
}