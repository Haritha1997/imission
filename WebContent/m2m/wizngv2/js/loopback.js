function validateSubnetMask(id,checkempty,name) 
{ 
	var ipele=document.getElementById(id); 
	if(ipele.readOnly == true) { ipele.style.outline="initial"; ipele.title=""; return true; } 
	var ipformat=/^(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$/; 
	var ipaddr = ipele.value; if(ipaddr=="") 
	{ 
		if(checkempty) 
		{ 
			ipele.style.outline ="thin solid red"; 
			ipele.title=name+" should not be empty"; 
			return false; 
		} 
		else 
		{ 
			ipele.style.outline="initial"; 
			ipele.title=""; return true; 
		} 	
	} 
	else if(!ipaddr.match(ipformat)) 
	{ 
		ipele.style.outline="thin solid red"; 
		ipele.title="Invalid "+name; return false; 
	} 
	else 
	{ 
		ipele.style.outline ="initial"; ipele.title = ""; return true; 
	} 
} 

/*function validateIP(id, checkempty, name) 
{ 
	var ipele = document.getElementById(id); 
	if (ipele.readOnly == true) 
	{ 
		ipele.style.outline = "initial"; 
		ipele.title = "";
		return true; 
	} 
	//var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-4]|2[0-4][0-9]|[01]?[1-9][0-9]?)$/; 
	var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[1-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-5][0-9]|[01]?[0-9][0-9]?)$/;
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
	else if (!ipaddr.match(ipformat) || ipaddr == "255.255.255.255" ) 
	{ 
		ipele.style.outline = "thin solid red"; 
		ipele.title = "Invalid " + name; return false; 
	} 
	else 
	{ 
		ipele.style.outline = "initial"; ipele.title = ""; return true; 
	} 
}
 */
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

function adjtabIPV4andSubnetFirstcolumn(tabname,setIPV4,setSubnet)
{
	var table = document.getElementById(tabname);
	var rows = table.rows;
	var index = 0;
	if(tabname == "WiZConf")
		index = 2;
	for(var i=index;i<rows.length;i++)
	{
		if(i==index)
		{
			rows[i].cells[0].childNodes[0].innerHTML = setIPV4;
			rows[i].cells[0].childNodes[2].innerHTML = setSubnet;
	    }
		else
		{
			rows[i].cells[0].childNodes[0].innerHTML = "";
			rows[i].cells[0].childNodes[2].innerHTML = "";
		}
	}
}

function deleteRow(rowid)
{
	var ele = document.getElementById("laniprow"+rowid);
	$('table#WiZConf tr#laniprow'+rowid).remove();
}
function avoidSpace(event)
{
	var k = event ? event.which : window.event.keyCode;
	if (k == 32) 
	{
		alert("space is not allowed");
		return false;
	}
}
	
function addIPRowAndChangeIcon(rowid)
{

	var table = document.getElementById("WiZConf");
	if(table.rows.length >=7)
	{
		alert("Max 5 rows are allowed");
		return;
	}
	iprows++;
	var remove=document.getElementById("remove"+rowid);
	var add=document.getElementById("add"+rowid);
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline"; 
	$("#WiZConf").append("<tr id='laniprow"+iprows+"'><td><div>IPv4 Address</div><br/><div>Subnet Address</div></td><td><div><input type='text' class='text' id='lanip"+iprows+"' name='lanip"+iprows+"' onkeypress='return avoidSpace(event);' style='display:inline block; position:relative; left:3px;' maxlength='15' onfocusout=\"validateIPOnly('lanip"+iprows+"',true,'IPv4 Address')\"></input></div><div style='margin-left:155px'><i class='fa fa-plus' id='add"+iprows+"' style='font-size:10px; margin-left:5px;color:green;display:inline block' onclick='addIPRowAndChangeIcon("+iprows+")'></i><i class='fa fa-close' style='display:inline;font-size:10px; margin-left:5px; color:red;' id='remove"+iprows+"' onclick='deletetableRow("+iprows+")'></i></div><div><input type='text' class='text' id='lansn"+iprows+"' name='lansn"+iprows+"' onkeypress='return avoidSpace(event)' style='display:inline block; position:relative; left:3px;' maxlength='15' onfocusout=\"validateSubnetMask('lansn"+iprows+"',true,'Subnet Address')\"></input><input hidden id='row"+iprows+"' value='"+iprows+"'></div></td></tr>");
	setLoopbackIpRowCnt();
	adjtabIPV4andSubnetFirstcolumn('WiZConf','IPv4 Address','Subnet Address');
}


function deletetableRow(row)
{
	deleteRow(row);
	findLastRowAndDisplayRemoveIcon();
	adjtabIPV4andSubnetFirstcolumn('WiZConf','IPv4 Address','Subnet Address');
}
function findLastRowAndDisplayRemoveIcon()
{
	var table = document.getElementById("WiZConf");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[1].childNodes[1].childNodes[0];
	var removeobj = lastrow.cells[1].childNodes[1].childNodes[1];
	addobj.style.display="inline";
	if(table.rows.length > 3)
		removeobj.style.display="inline";
	else if(table.rows.length == 3)
	removeobj.style.display="none";
}

function fillIProw(rowid,ipaddress,subnet)
{
	document.getElementById('lanip'+rowid).value=ipaddress;
	document.getElementById('lansn'+rowid).value=subnet;
}

function setLoopbackIpRowCnt()
{
	document.getElementById("loopbackiprows").value = iprows;
}

function addIPV6RowAndChangeIcon(rowid)
{
	var table = document.getElementById("ipconfig1");
	if(table.rows.length >=5)
	{
		alert("Max 5 Entries are allowed");
		return;
	}
	ipv6rows++;
	var remove=document.getElementById("removedns"+rowid);
	var add=document.getElementById("adddns"+rowid);
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline";
	$("#ipconfig1").append("<tr id='ipv6"+ipv6rows+"'><td min-width=\"200\"><div>IPV6 Address</div></td><td width=\"195\"><div><input type='text' class='text' style='position: relative; left: 3px;display:inline block' id='IPV6"+ipv6rows+"' name='IPV6"+ipv6rows+"' onkeypress='return avoidSpace(event);' style='display:inline block;' onmouseover=\"setTitle(this)\" onfocusout=\"validateIPv6('IPV6"+ipv6rows+"',false,'IPV6 Address',true)\"></input><i class='fa fa-plus' id='adddns"+ipv6rows+"' style='font-size:10px; margin-left:10px;color:green;display:inline block'; onclick='addIPV6RowAndChangeIcon("+ipv6rows+")'></i><i class='fa fa-close' style='display:inline;font-size:10px; margin-left:5px; color:red;' id='removedns"+ipv6rows+"' onclick='deleteIPV6tableRow("+ipv6rows+")'></i><input hidden id='row"+ipv6rows+"' value='"+ipv6rows+"'></div></td></tr>");
	document.getElementById("loopbackipv6rows").value = ipv6rows;//guru
	adjtabIPV6Firstcolumn('ipconfig1','IPV6 Address');
}
function deleteIPV6Row(rowid)
{
	var ele = document.getElementById("ipv6"+rowid);
	$('table#ipconfig1 tr#ipv6'+rowid).remove();
	
}
function deleteIPV6tableRow(row)
{
	deleteIPV6Row(row);
	findIPV6LastRowAndDisplayRemoveIcon();
	adjtabIPV6Firstcolumn('ipconfig1','IPV6 Address');
}
function adjtabIPV6Firstcolumn(tabname,setname)
{
	var table = document.getElementById(tabname);
	var rows = table.rows;
	var index = 0;
	if(tabname == "ipconfig1")
		index = 0;
	for(var i=index;i<rows.length;i++)
	{
		if(i==index)
		{
			rows[i].cells[0].childNodes[0].innerHTML = setname;
	    }
		else
		{
			rows[i].cells[0].childNodes[0].innerHTML = "";
		}
	}
}
function findIPV6LastRowAndDisplayRemoveIcon()
{
	var table = document.getElementById("ipconfig1");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[1].childNodes[0].childNodes[1];
	var removeobj = lastrow.cells[1].childNodes[0].childNodes[2];
	addobj.style.display="inline";
	if(table.rows.length > 1)
		removeobj.style.display="inline";
	else if(table.rows.length == 1)
	removeobj.style.display="none";
}

function fillIPV6Row(rowid,dnsserver)
{
	document.getElementById('IPV6'+rowid).value=dnsserver;
}
