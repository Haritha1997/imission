function addRow(tablename,version) 
{ 
	var table = document.getElementById(tablename); 
	var iprows = table.rows.length; 
	if (tablename == "WiZConff") 
	{ 
		if (iprows == 26) 
		{ 
			alert("Maximum 25 rows are allowed in Static IPV4 Routes Table"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("routesrwcnt").value = iprows; 
		var options="<option value=\"lan\">LAN</option><option value=\"wan\">WAN</option><option value=\"cellular\">Cellular</option>";
		if(version.startsWith("WiZNG2ES"))
			options="<option value=\"lan\">LAN</option><option value=\"cellular\">Cellular</option>";
		iprows = document.getElementById("routesrwcnt").value; 
		document.getElementById("routesrwcnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id=\"staticroute"+iprows+"\">"+
		"<td style=\"text-align: center; vertical-align: middle;\">"+iprows+"</td>"+
		"<td><select name=\"interface" +iprows+"\" id=\"interface"+iprows+"\">"+options+"</select></td>"+

		"<td><input name=\"target"+iprows+"\" type=\"text\" class=\"text\" id=\"target"+iprows+"\" size=\"12\" maxlength=\"15\"  onkeypress=\"return avoidSpace(event);\" onfocusout=\"validateIP('target"+iprows+"',true,'target')\"></td>"+
		"<td><input name=\"netmask"+iprows+"\" type=\"text\" class=\"text\" id=\"netmask"+iprows+"\" size=\"12\" maxlength=\"15\" onkeypress=\"return avoidSpace(event);\" onfocusout=\"validateSubnetMaskStaticRoute('netmask"+iprows+"',true,'netmask')\"></td>"+
		"<td><input name=\"gateway"+iprows+"\" type=\"text\" class=\"text\" id=\"gateway"+iprows+"\" size=\"12\" maxlength=\"15\" onkeypress=\"return avoidSpace(event);\" onfocusout=\"validateIpOnly('gateway"+iprows+"',false,'Gateway')\"></td>"+
		"<td><input name=\"metric"+iprows+"\" type=\"number\" class=\"text\" id=\"metric"+iprows+"\" placeholder=\"0\" min=\"0\" max=\"255\" onkeypress=\"return avoidSpace(event);\"></td>"+
		"<td><input name=\"mtu"+iprows+"\" type=\"number\" class=\"text\" id=\"mtu"+iprows+"\" placeholder=\"1500\" min=\"64\" max=\"9000\" onkeypress=\"return avoidSpace(event);\"></td>"+
		"<td><image id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"30\" height=\"22\" align=\"center\" title=\"Delete\" onclick=\"deleteRow('staticroute"+iprows+"','WiZConff');\"></image></td>"+
		"<td hidden>0</td>"+
		"<td hidden>"+iprows+"</td>"+
		"</tr>"; 
		$('#WiZConff').append(row); 
       reindexTable('WiZConff');		
	}
    if (tablename == "ipv6") 
	{ 
		if (iprows == 26) 
		{ 
			alert("Maximum 25 rows are allowed in Static IPV6 Routes Table"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("ipv6routesrwcnt").value = iprows; 
		var options="<option value=\"lan\">LAN</option><option value=\"wan\">WAN</option><option value=\"cellular\">Cellular</option>";
		if(version.startsWith("WiZNG2ES"))
			options="<option value=\"lan\">LAN</option><option value=\"cellular\">Cellular</option>";
		iprows = document.getElementById("ipv6routesrwcnt").value; 
		document.getElementById("ipv6routesrwcnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id=\"ipv6staticroute"+iprows+"\">"+
		"<td style=\"text-align: center; vertical-align: middle;\">"+iprows+"</td>"+
		"<td><select name=\"IPV6INTERFACE\" id=\"IPV6INTERFACE"+iprows+"\">"+options+"</select></td>"+
		"<td><input name=\"IPV6TARGET "+iprows+"\" type=\"text\" class=\"text\" id=\"IPV6TARGET"+iprows+"\" size=\"12\" maxlength=\"255\"	onkeypress=\"return IPV6avoidSpace(event)\" onfocusout=\"validateIPv6('IPV6TARGET"+iprows+"',true,'target',true)\"></td>"+
		"<td><input name=\"IPV6GATEWAY "+iprows+"\" type=\"text\" class=\"text\" id=\"IPV6GATEWAY"+iprows+"\" size=\"12\" maxlength=\"255\" 	onkeypress=\"return IPV6avoidSpace(event)\" onfocusout=\"validateIPv6gateway('IPV6GATEWAY"+iprows+"',false,'Gateway')\"></td>"+
		"<td><input name=\"IPV6METRIC "+iprows+"\" type=\"number\" class=\"text\" id=\"IPV6METRIC"+iprows+"\" placeholder=\"0\" min=\"1\" max=\"255\"></td>"+
		"<td><input name=\"IPV6MTU "+iprows+"\" type=\"number\" class=\"text\" id=\"IPV6MTU"+iprows+"\" placeholder=\"1500\" min=\"64\" max=\"9000\"></td>"+
		"<td><image id=\"ipv6delrw"+iprows+"\" name=\"ipv6delrw"+iprows+"\"src=\"images/delete.png\" width=\30\" height=\"22\" align=\"center\" title=\"Delete\" onclick=\"deleteRow('ipv6staticroute"+iprows+"','ipv6');\"></image></td>"+
		"<td hidden>0</td>"+
		"<td hidden>"+iprows+"</td>"+
		"</tr>"; 
		$('#ipv6').append(row);
        reindexTable('ipv6');		
	} 	
	var height = table.rows[1].cells[0].offsetHeight;
	window.scrollBy(0,height);
}

function reindexTable(tablename)
{ 
	var table = document.getElementById(tablename); 
	var rowCount = table.rows.length;
	for (var i = 1; i < rowCount; i++) 
	{ 
		var row = table.rows[i]; 
		row.cells[0].innerHTML = i; 
	} 
}

function deleteRow(rowid,tablename) 
{
    document.getElementById(rowid).remove();
	reindexTable(tablename);
}

function fillrow(rowid,intface,target,netmask,gateway,metric,mtu)
{
	document.getElementById('interface'+rowid).value=intface;
	document.getElementById('target'+rowid).value=target;
	document.getElementById('netmask'+rowid).value=netmask;
	document.getElementById('gateway'+rowid).value=gateway;
	document.getElementById('metric'+rowid).value=metric;
	document.getElementById('mtu'+rowid).value=mtu;
}

function fillipv6row(rowid,intface,target,prefixlength,gateway,metric,mtu)
{
	document.getElementById('IPV6INTERFACE'+rowid).value=intface;
	document.getElementById('IPV6TARGET'+rowid).value=target;
	// document.getElementById('ipv6prfxln'+rowid).value=prefixlength;
	document.getElementById('IPV6GATEWAY'+rowid).value=gateway;
	document.getElementById('IPV6METRIC'+rowid).value=metric;
	document.getElementById('IPV6MTU'+rowid).value=mtu;
}



function validateIPv6(id, checkempty, name) 
{ 
	var ipele = document.getElementById(id); 
	if (ipele.readOnly == true) 
	{ 
		ipele.style.outline = "initial"; 
		ipele.title = "";
		return true; 
	} 
	var ipformat = /^(?:(?:[a-fA-F\d]{1,4}:){7}(?:[a-fA-F\d]{1,4}|:)|(?:[a-fA-F\d]{1,4}:){6}(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|:[a-fA-F\d]{1,4}|:)|(?:[a-fA-F\d]{1,4}:){5}(?::(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,2}|:)|(?:[a-fA-F\d]{1,4}:){4}(?:(?::[a-fA-F\d]{1,4}){0,1}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,3}|:)|(?:[a-fA-F\d]{1,4}:){3}(?:(?::[a-fA-F\d]{1,4}){0,2}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,4}|:)|(?:[a-fA-F\d]{1,4}:){2}(?:(?::[a-fA-F\d]{1,4}){0,3}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,5}|:)|(?:[a-fA-F\d]{1,4}:){1}(?:(?::[a-fA-F\d]{1,4}){0,4}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,6}|:)|(?::(?:(?::[a-fA-F\d]{1,4}){0,5}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,7}|:)))(?:%[0-9a-zA-Z]{1,})?$/gm;
	//var suffix="[/]";
	//var ipaddr = ipele.value; 

	/***************************************/	
	var totalipaddr = ipele.value;

	var ipaddr="";
	var suffix="";
	var ipaddrarr=""
	if(totalipaddr.includes("/"))
	{
		ipaddrarr = totalipaddr.split('/');
	}
	else
	{
		ipele.style.outline = "thin solid red"; 
		ipele.title = "Invalid " + name; 
		return false;
	}
	if(ipaddrarr.length >2)
	{
		ipele.style.outline = "thin solid red"; 
		ipele.title = "Invalid " + name;
		return false;
	}
	ipaddr = ipaddrarr[0];
	suffix = ipaddrarr[1];
	if(suffix.length==0)
	{
		ipele.style.outline = "thin solid red"; 
		ipele.title = "Invalid " + name;
		return false;
	}


/******************************************************/



	if (ipaddr == "") 
	{
		if (checkempty) 
		{ 
			ipele.style.outline = "thin solid red"; 
			ipele.title = name + " should not be empty"; 
			return false; 
		} 
		else 
		{ 
			ipele.style.outline = "initial"; 
			ipele.title = ""; return true; 
		} 
	} 
	else if (!ipaddr.match(ipformat)) 
	{ 
		ipele.style.outline = "thin solid red"; 
		ipele.title = "Invalid " + name; 
		return false; 
	} 
	else 
	{ 
		ipele.style.outline = "initial"; 
		ipele.title = ""; 
		return true; 
	} 
}

/**********************(IPV6 Gateway)****************************************/

function validateIPv6gateway(id, checkempty, name) 
{ 
	var ipele = document.getElementById(id); 
	if (ipele.readOnly == true) 
	{ 
		ipele.style.outline = "initial"; 
		ipele.title = "";
		return true; 
	} 
	var ipformat = /^(?:(?:[a-fA-F\d]{1,4}:){7}(?:[a-fA-F\d]{1,4}|:)|(?:[a-fA-F\d]{1,4}:){6}(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|:[a-fA-F\d]{1,4}|:)|(?:[a-fA-F\d]{1,4}:){5}(?::(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,2}|:)|(?:[a-fA-F\d]{1,4}:){4}(?:(?::[a-fA-F\d]{1,4}){0,1}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,3}|:)|(?:[a-fA-F\d]{1,4}:){3}(?:(?::[a-fA-F\d]{1,4}){0,2}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,4}|:)|(?:[a-fA-F\d]{1,4}:){2}(?:(?::[a-fA-F\d]{1,4}){0,3}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,5}|:)|(?:[a-fA-F\d]{1,4}:){1}(?:(?::[a-fA-F\d]{1,4}){0,4}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,6}|:)|(?::(?:(?::[a-fA-F\d]{1,4}){0,5}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,7}|:)))(?:%[0-9a-zA-Z]{1,})?$/gm;
	//var suffix="[/]";
	var ipaddr = ipele.value; 
	if (ipaddr == "") 
	{
		if (checkempty) 
		{ 
			ipele.style.outline = "thin solid red"; 
			ipele.title = name + " should not be empty"; 
			return false; 
		} 
		else 
		{ 
			ipele.style.outline = "initial"; 
			ipele.title = ""; return true; 
		} 
	} 
	else if (!ipaddr.match(ipformat)) 
	{ 
		ipele.style.outline = "thin solid red"; 
		ipele.title = "Invalid " + name; 
		return false; 
	} 
	else 
	{ 
		ipele.style.outline = "initial"; 
		ipele.title = ""; 
		return true; 
	} 
}

function IPV6avoidSpace(event)
{
	var k = event ? event.which : window.event.keyCode;
	if (k == 32) 
	{
		alert("space is not allowed");
		return false;
	}
	else if( (!(k>64 && k<71)) &&(!(k>96 && k<103)) && (!(k>46 && k<59)) )
	{
		alert("Entered character not valid in IPV6");
		return false;
	}
	
}

function showDivision(divname)
{
	var divname_arr = ["ipv4routediv","ipv6routediv"];
        var list = document.getElementById("sroutediv");
        var childs = list.children;

	for(var i=0;i<divname_arr.length;i++)
	{
		if(divname == divname_arr[i]) {
			document.getElementById(divname_arr[i]).style.display = "inline";
			childs[i].children[0].id = "hilightthis";
		}
		else {
			document.getElementById(divname_arr[i]).style.display = "none";
			childs[i].children[0].id = "";
		}
	}
}
/******************************************************/
function getNetwork(ip,netmask)
{
	var ip_arr = ip.split(".");
	var netmask_arr = netmask.split(".");
	var network = "";
	for(var i=0;i<ip_arr.length;i++)
	{
		network += ip_arr[i]&netmask_arr[i];
		if(i<ip_arr.length-1)
			network += ".";
	}
	return network;
}
function getBroadcast(network,netmask)
{
	var net_arr = network.split(".");
	var netmask_arr = netmask.split(".");
	var inv_sub_arr=[255-netmask_arr[0],255-netmask_arr[1],255-netmask_arr[2],255-netmask_arr[3]];
	var broadcast="";
	for(var i=0;i<net_arr.length;i++)
	{
		broadcast += net_arr[i]|inv_sub_arr[i];
		if(i<net_arr.length-1)
			broadcast+=".";
	}
	return broadcast; 
}
function isOverlaped(ip1,netmask1,ip2,netmask2)
{
	netwk1 = getNetwork(ip1,netmask1);
	broadcast1=getBroadcast(netwk1,netmask1);
	
	netwk2 = getNetwork(ip2,netmask2);
	broadcast2=getBroadcast(netwk2,netmask2);
	if(netwk1==netwk2 && broadcast1==broadcast2)
		return true;
	return false;
}

function validateIPOnly(id, checkempty, name) 
{ 
	var ipele = document.getElementById(id); 
	if (ipele.readOnly == true) 
	{ 
		ipele.style.outline = "initial"; 
		ipele.title = "";
		return true; 
	} 
	var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/; 
	var ipaddr = ipele.value; 
	if (ipaddr == "") 
	{
		if (checkempty) 
		{ 
			ipele.style.outline = "thin solid red"; 
			ipele.title = name + " should not be empty"; 
			return false; 
		} 
		else 
		{ 
			ipele.style.outline = "initial"; 
			ipele.title = ""; return true; 
		} 
	} 
	else if (!ipaddr.match(ipformat) || ipaddr == "255.255.255.255" ||ipaddr=="0.0.0.0") 
	{ 
		ipele.style.outline = "thin solid red"; 
		ipele.title = "Invalid " + name; return false; 
	} 
	else 
	{ 
		ipele.style.outline = "initial"; ipele.title = ""; return true; 
	} 
}
