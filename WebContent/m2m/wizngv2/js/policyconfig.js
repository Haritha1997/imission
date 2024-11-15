 
/*function validateIP(id, checkempty, name) 
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
			ipele.title = ""; 
			return true; 
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
}*/
function deleteLocalNetwork(rowid)
{
	var ele = document.getElementById("laniprow"+rowid);
	$('table#lnettab tr#laniprow'+rowid).remove();
}
function deleteRemoteNetwork(rowid)
{
	var ele = document.getElementById("plcyconfgrow"+rowid);
	$('table#rnettab tr#plcyconfgrow'+rowid).remove();
}
function deleteByPassNetwork(rowid)
{
	var ele = document.getElementById("plcyconfgrow1"+rowid);
	$('table#BypassLan tr#plcyconfgrow1'+rowid).remove();
}
function adjtabFirstcolumn(tabname,setname)
{
	var table = document.getElementById(tabname);
	var rows = table.rows;
	var index = 0;
	if(tabname == "lnettab")
		index = 1;
	for(var i=index;i<rows.length;i++)
	{
		if(i==index)
			rows[i].cells[0].childNodes[0].innerHTML = setname;
		else
		rows[i].cells[0].childNodes[0].innerHTML = "";
	}
}
function addLocalNetworkAndChangeIcon(rowid)
{
	var table = document.getElementById("lnettab");
	if(table.rows.length ==11)
	{
		alert("Max 10 rows are allowed");
		return;
	}
	lclnetiprows++;
	var remove=document.getElementById("remove"+rowid);
	var add=document.getElementById("add"+rowid);
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline"; 
/*
	$("#lnettab").append("<tr id='laniprow"+lclnetiprows+"'><td width=\"250px\"><div>Local Network </div></td><td width=\"250px\"><div><input type='text' class='text' id='lanip"+lclnetiprows+"' name='lanip"+lclnetiprows+"' onkeypress='return avoidSpace(event);' style='display:inline block' onfocusout=\"validateIP('lanip"+lclnetiprows+"',true,'IPv4 Address')\"></input></div></td><td width=\"300px\"><div><input type='text' class='text' id='lansn"+lclnetiprows+"' name='lansn"+lclnetiprows+"' onkeypress='return avoidSpace(event)' style='display:inline block;' onfocusout=\"validateSubnetMask('lansn"+lclnetiprows+"',true,'Subnet Address')\"></input><label class='add' id='add"+lclnetiprows+"' style='display:inline block;' onclick='addLocalNetworkAndChangeIcon("+lclnetiprows+")'>+</label><label class='remove' style='display:inline;' id='remove"+lclnetiprows+"' onclick='deleteTableLocalNetwork("+lclnetiprows+")'>x</label><input hidden id='row"+lclnetiprows+"' value='"+lclnetiprows+"'></div></td></tr>");
*/
	$("#lnettab").append("<tr id='laniprow"+lclnetiprows+"'><td width=\"250px\"><div>Local Network </div></td><td width=\"250px\"><div><input type='text' class='text' id='lanip"+lclnetiprows+"' name='lanip"+lclnetiprows+"' onkeypress='return avoidSpace(event);' style='display:inline block' onfocusout=\"validateIP('lanip"+lclnetiprows+"',false,'IPv4 Address')\"></input></div></td><td width=\"300px\"><div><input type='text' class='text' id='lansn"+lclnetiprows+"' name='lansn"+lclnetiprows+"' onkeypress='return avoidSpace(event)' maxlength='15' style='display:inline block' onfocusout=\"validateSubnetMask('lansn"+lclnetiprows+"',true,'Subnet Address',true)\"></input><i class='fa fa-plus' id='add"+lclnetiprows+"' style='font-size:10px; margin-left:5px;color:green;display:inline block' onclick='addLocalNetworkAndChangeIcon("+lclnetiprows+")'></i><i class='fa fa-close' style='font-size:10px; margin-left:5px;color:red;display:inline' id='remove"+lclnetiprows+"' onclick='deleteTableLocalNetwork("+lclnetiprows+")'></i><input hidden id='row"+lclnetiprows+"' value='"+lclnetiprows+"'></div></td></tr>");
	document.getElementById("lcliprows").value = lclnetiprows;
    adjtabFirstcolumn('lnettab','Local Network');
}
function addRemoteNetworkAndChangeIcon(rowid)
{
	var table = document.getElementById("rnettab");
	if(table.rows.length >=10)
	{
		alert("Max 10 rows are allowed");
		return;
	}
	remnetiprows++;
	var remove=document.getElementById("remove1"+rowid);
	var add=document.getElementById("add1"+rowid);
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline"; 
/*
	$("#rnettab").append("<tr id='plcyconfgrow"+remnetiprows+"'><td width=\"250px\"><div>Remote Network </div></td><td width=\"250px\"><div><input type='text' class='text' id='rmip"+remnetiprows+"' name='rmip"+remnetiprows+"' onkeypress='return avoidSpace(event);' style='display:inline block' onfocusout=\"validateIP('rmip"+remnetiprows+"',true,'IPv4 Address')\"></input></div></td><td width=\"300px\"><div><input type='text' class='text' id='rmsn"+remnetiprows+"' name='rmsn"+remnetiprows+"' onkeypress='return avoidSpace(event)' style='display:inline block;' onfocusout=\"validateSubnetMask('rmsn"+remnetiprows+"',true,'Subnet Address')\"></input><label class='add' id='add1"+remnetiprows+"' style='display:inline block;' onclick='addRemoteNetworkAndChangeIcon("+remnetiprows+")'>+</label><label class='remove' style='display:inline;' id='remove1"+remnetiprows+"' onclick='deleteTableRemoteNetwork("+remnetiprows+")'>x</label><input hidden id='row"+remnetiprows+"' value='"+remnetiprows+"'></div></td></tr>");
*/
$("#rnettab").append("<tr id='plcyconfgrow"+remnetiprows+"'><td width=\"250px\"><div>Remote Network </div></td><td width=\"250px\"><div><input type='text' class='text' id='rmip"+remnetiprows+"' name='rmip"+remnetiprows+"' onkeypress='return avoidSpace(event);' style='display:inline block' onfocusout=\"validateIP('rmip"+remnetiprows+"',false,'IPv4 Address')\"></input></div></td><td width=\"300px\"><div><input type='text' class='text' id='rmsn"+remnetiprows+"' name='rmsn"+remnetiprows+"' onkeypress='return avoidSpace(event)' style='display:inline block;' onfocusout=\"validateSubnetMask('rmsn"+remnetiprows+"',false,'Subnet Address',true)\"></input><i class='fa fa-plus' id='add1"+remnetiprows+"' style='font-size:10px; margin-left:5px;color:green;display:inline block' onclick='addRemoteNetworkAndChangeIcon("+remnetiprows+")'></i><i class='fa fa-close' style='font-size:10px; margin-left:5px;color:red;display:inline' id='remove1"+remnetiprows+"' onclick='deleteTableRemoteNetwork("+remnetiprows+")'></i><input hidden id='row"+remnetiprows+"' value='"+remnetiprows+"'></div></td></tr>");
	document.getElementById("rmtiprows").value = remnetiprows;
    adjtabFirstcolumn('rnettab','Remote Network');
}
function addByPassNetworkAndChangeIcon(rowid)
{
	var table = document.getElementById("BypassLan");
	if(table.rows.length >=10)
	{
		alert("Max 10 rows are allowed");
		return;
	}
	bpsnetiprows++;
	var remove=document.getElementById("remove2"+rowid);
	var add=document.getElementById("add2"+rowid);
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline";

/* 
	$("#BypassLan").append("<tr id='plcyconfgrow1"+bpsnetiprows+"'><td width=\"250px\"><div>ByPass Network</div></td><td width=\"250px\"><div><input type='text' class='text' id='bypasip"+bpsnetiprows+"' name='bypasip"+bpsnetiprows+"' onkeypress='return avoidSpace(event);' style='display:inline' onfocusout=\"validateIP('bypasip"+bpsnetiprows+"',true,'IPv4 Address')\"></input></div></td><td width=\"300px\"><div><input type='text' class='text' id='bypassn"+bpsnetiprows+"' name='bypassn"+bpsnetiprows+"' onkeypress='return avoidSpace(event)' style='display:inline block;' onfocusout=\"validateSubnetMask('bypassn"+bpsnetiprows+"',true,'Subnet Address')\"></input><label class='add' id='add2"+bpsnetiprows+"' style='display:inline block;' onclick='addByPassNetworkAndChangeIcon("+bpsnetiprows+")'>+</label><label class='remove' style='display:inline;' id='remove2"+bpsnetiprows+"' onclick='deleteTableByPassNetwork("+bpsnetiprows+")'>x</label><input hidden id='row"+bpsnetiprows+"' value='"+bpsnetiprows+"'></div></td></tr>");
*/
$("#BypassLan").append("<tr id='plcyconfgrow1"+bpsnetiprows+"'><td width=\"250px\"><div>ByPass Network</div></td><td width=\"250px\"><div><input type='text' class='text' id='bypasip"+bpsnetiprows+"' name='bypasip"+bpsnetiprows+"' onkeypress='return avoidSpace(event);' style='display:inline' onfocusout=\"validateIP('bypasip"+bpsnetiprows+"',false,'IPv4 Address')\"></input></div></td><td width=\"300px\"><div><input type='text' class='text' id='bypassn"+bpsnetiprows+"' name='bypassn"+bpsnetiprows+"' onkeypress='return avoidSpace(event)' style='display:inline block;' onfocusout=\"validateSubnetMask('bypassn"+bpsnetiprows+"',false,'Subnet Address',true)\"></input><i class='fa fa-plus' id='add2"+bpsnetiprows+"' style='font-size:10px; margin-left:5px;color:green;display:inline block' onclick='addByPassNetworkAndChangeIcon("+bpsnetiprows+")'></i><i class='fa fa-close' style='font-size:10px; margin-left:5px;color:red;display:inline' id='remove2"+bpsnetiprows+"'  onclick='deleteTableByPassNetwork("+bpsnetiprows+")'></i><input hidden id='row"+bpsnetiprows+"' value='"+bpsnetiprows+"'></div></td></tr>");
	document.getElementById("bypassiprows").value = bpsnetiprows;
	adjtabFirstcolumn('BypassLan','ByPass Network');
}

function deleteTableLocalNetwork(row)
{
	deleteLocalNetwork(row);
	findLocalNetworkAndDisplayRemoveIcon();
	adjtabFirstcolumn('lnettab','Local Network');
}
function deleteTableRemoteNetwork(row)
{
	deleteRemoteNetwork(row);
	findRemoteNetworkAndDisplayRemoveIcon();
	adjtabFirstcolumn('rnettab','Remote Network');
}
function deleteTableByPassNetwork(row)
{
	deleteByPassNetwork(row);
	findByPassNetworkAndDisplayRemoveIcon();
	adjtabFirstcolumn('BypassLan','ByPass Network');
}
function findLocalNetworkAndDisplayRemoveIcon()
{
	var table = document.getElementById("lnettab");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[2].childNodes[0].childNodes[1];
	var removeobj = lastrow.cells[2].childNodes[0].childNodes[2];
	addobj.style.display="inline";
	if(table.rows.length > 2)
	removeobj.style.display="inline";
	else if(table.rows.length == 2)
	removeobj.style.display="none";
}
function findRemoteNetworkAndDisplayRemoveIcon()
{
	var table = document.getElementById("rnettab");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[2].childNodes[0].childNodes[1];
	var removeobj = lastrow.cells[2].childNodes[0].childNodes[2];
	addobj.style.display="inline";
	if(table.rows.length > 1)
	removeobj.style.display="inline";
	else if(table.rows.length == 1)
	removeobj.style.display="none";
}
function findByPassNetworkAndDisplayRemoveIcon()
{
	var table = document.getElementById("BypassLan");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[2].childNodes[0].childNodes[1];
	var removeobj = lastrow.cells[2].childNodes[0].childNodes[2];
	addobj.style.display="inline";
	if(table.rows.length > 1)
	removeobj.style.display="inline";
	else if(table.rows.length == 1)
	removeobj.style.display="none";
}

function fillLocalNetwork(rowid,ipaddress,subnet)
{
	document.getElementById('lanip'+rowid).value=ipaddress;
	document.getElementById('lansn'+rowid).value=subnet;
}
function fillRemoteNetwork(rowid,ipaddress,subnet)
{
	document.getElementById('rmip'+rowid).value=ipaddress;
	document.getElementById('rmsn'+rowid).value=subnet;
}
function fillByPassNetwork(rowid,ipaddress,subnet)
{
	document.getElementById('bypasip'+rowid).value=ipaddress;
	document.getElementById('bypassn'+rowid).value=subnet;
}

function showByPassLan(id,tableid)
{
	var lanbypass=document.getElementById(id);
	var table=document.getElementById(tableid);
	if(lanbypass.checked)
	{	
		table.style.width = "800px";
		table.style.display="inline";
		table.style.textAlign = "left";		
	}
	else
	{
		table.style.display="none";
	}
}
function showDivision(divname)
{
	var divname_arr = ["configpage","policypage","trackingpage"];
        var list = document.getElementById("ipsecediv");
        var childs = list.children;

	for(var i=0;i<divname_arr.length;i++)
	{
		if(divname == divname_arr[i])
		{
			document.getElementById(divname_arr[i]).style.display = "inline";
			childs[i].children[0].id = "hilightthis";
		} else {
			document.getElementById(divname_arr[i]).style.display = "none";
			childs[i].children[0].id = "";
		}
	}
}

