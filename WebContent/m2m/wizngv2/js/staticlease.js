function addRow(tablename) 
{
	var table = document.getElementById(tablename); 
	var iprows = table.rows.length; 
	if (tablename == "WiZConff") 
	{ 
		if (iprows == 26) 
		{ 
			alert("Maximum 25 Entries are allowed"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("routesrwcnt").value = iprows; 
		iprows = document.getElementById("routesrwcnt").value; 
		document.getElementById("routesrwcnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id=\"staticlease"+iprows+"\">"+
		"<td style=\"text-align: center; vertical-align: middle;\">"+iprows+"</td>"+
		"<td><input name=\"hostname"+iprows+"\" type=\"text\" class=\"text\" id=\"hostname"+iprows+"\" size=\"12\" maxlength=\"32\" onkeypress='return avoidSpace(event);' onmouseover=\"setTitle(this)\" onfocusout=\"validateHostname('hostname"+iprows+"',true,'hostname')\"></td>"+
		"<td><input name=\"ipaddress"+iprows+"\" type=\"text\" class=\"text\" id=\"ipaddress"+iprows+"\" size=\"12\" maxlength=\"15\" onkeypress=\"return avoidSpace(event) && avoidEnter(event)\" onfocusout=\"validateIPOnly('ipaddress"+iprows+"',true,'ipaddress')\"></td>"+
		"<td><input name=\"macaddress"+iprows+"\" type=\"text\" class=\"text\" id=\"macaddress"+iprows+"\" size=\"12\" maxlength=\"17\" onkeypress='return avoidSpace(event);' onfocusout=\"validateMacIP('macaddress"+iprows+"',true,'macaddress')\"></td>"+
		"<td><input name=\"leasetime"+iprows+"\" type=\"text\" class=\"text\" id=\"leasetime"+iprows+"\" size=\"12\" maxlength=\"15\" onkeypress='return avoidSpace(event);' onkeypress=\"return avoidSpace(event) && avoidEnter(event)\" placeholder=\"xxh(or)xxm(or)xxs\" onfocusout=\"validateLeaseTime('leasetime"+iprows+"',true,'leasetime')\"></td>"+
		"<td><image id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"22\" height=\"22\" align=\"center\" title=\"Delete\" onclick=\"deleteRow('staticlease"+iprows+"');\"></image></td>"+
		"<td hidden>0</td>"+
		"<td hidden>"+iprows+"</td>"+
		"</tr>"; 
		$('#WiZConff').append(row);  	 
	} 
	else
	{
		alert("no add row");
	}
	reindexTable();
	var height = table.rows[1].cells[0].offsetHeight;
	window.scrollBy(0,0);
}
function reindexTable()
{ 
	var table = document.getElementById("WiZConff"); 
	var rowCount = table.rows.length;
	for (var i = 1; i < rowCount; i++) 
	{ 
		var row = table.rows[i]; 
		row.cells[0].innerHTML = i; 
	} 
}
function deleteRow(rowid) 
{
    document.getElementById(rowid).remove();
	reindexTable();
}

function fillrow(rowid,hostname,ipaddress,macaddress,leasetime)
{
	document.getElementById('hostname'+rowid).value=hostname;
	document.getElementById('ipaddress'+rowid).value=ipaddress;
	document.getElementById('macaddress'+rowid).value=macaddress;
	document.getElementById('leasetime'+rowid).value=leasetime;
}

function validateMacIP(id, checkempty, name) 
{ 
	
	var ipele = document.getElementById(id); 
	if (ipele.readOnly == true) 
	{ 
		ipele.style.outline = "initial"; 
		ipele.title = "";
		return true; 
	} 
	var ipformat = /^([0-9a-fA-F]{2}[:.-]?){5}[0-9a-fA-F]{2}$/;
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
	else if (!ipaddr.match(ipformat) || ipaddr == "00:00:00:00:00:00" || ipaddr.toLowerCase()=="ff:ff:ff:ff:ff:ff") //modified
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

