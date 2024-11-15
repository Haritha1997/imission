/*function validateSubnetMask(id,checkempty,name) 
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
} */

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

function deleteRow(rowid)
{
	var ele = document.getElementById("waniprow"+rowid);
	$('table#statictab tr#waniprow'+rowid).remove();
}
/*function avoidSpace(event)
{
	var k = event ? event.which : window.event.keyCode;
	if (k == 32) 
	{
		alert("space is not allowed");
		return false;
	}
}*/

function adjtabFirstcolumn(tabname,ipaddr1,subnet1)
{
	var table = document.getElementById(tabname);
	var rows = table.rows;
	var index = 0;
	if(tabname == "statictab")
		index = 0;
	rows[0].cells[0].childNodes[0].innerHTML = ipaddr1;
	rows[0].cells[0].childNodes[2].innerHTML = subnet1;
}

function addIPRowAndChangeIcon(tabid,rowid)
{
	var table = document.getElementById(tabid);
	if(table.rows.length >=5)
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
	if(table.rows.length == 0)
		//$("#"+tabid).append("<tr id='waniprow"+iprows+"'><td width='200'><div>IPv4 Address</div><br/><div>Subnet Address</div></td><td><div><input type='text' class='text' id='wanip"+iprows+"' name='wanip"+iprows+"' onkeypress='return avoidSpace(event);' style='display:inline block;' onfocusout=\"validateIP('wanip"+iprows+"',true,'IPv4 Address')\"></input></div><div align='right' style='margin-right:3px'><i class='fa fa-plus' id='add"+iprows+"' style='font-size:10px; margin-left:5px;color:green;display:inline block'onclick='addIPRowAndChangeIcon('statictab',"+iprows+")'></i><i class='fa fa-close' style='display:inline;font-size:10px; margin-left:5px; color:red;' id='remove"+iprows+"' onclick='deletetableRow("+iprows+")'></i></div><div><input type='text' class='text' id='wansn"+iprows+"' name='wansn"+iprows+"' onkeypress='return avoidSpace(event)' style='display:inline block' onfocusout=\"validateSubnetMask('wansn"+iprows+"',true,'Subnet Address')\"></input><input hidden id='row"+iprows+"' value='"+iprows+"'></div></td></tr>");
	$("#"+tabid).append("<tr id='waniprow"+iprows+"'><td width='200'><div>IPV4 Address</div><br/><div>Subnet Address</div></td><td width='200'><div><input type='text' class='text' id='wanip"+iprows+"' name='wanip"+iprows+"' onkeypress='return avoidSpace(event);' style='display:inline block; position:relative; left:3px' maxlength='15' onfocusout=\"validateIPOnly('wanip"+iprows+"',true,'IPV4 Address')\"></input></div><div style='margin-left:155px;'><i class='fa fa-plus' style='font-size:10px; margin-left:5px;color:green;display:inline block' id='add"+iprows+"'  onclick=\"addIPRowAndChangeIcon('statictab',"+iprows+")\"></i><i class='fa fa-close' style='font-size:10px; margin-left:5px;color:red;display:inline block' id='remove"+iprows+"' onclick='deletetableRow("+iprows+")'></i></div><div width='200'><input type='text' class='text' id='wansn"+iprows+"' name='wansn"+iprows+"' onkeypress='return avoidSpace(event)' style='display:inline block; position:relative; left:3px;' maxlength='15' onfocusout=\"validateSubnetMask('wansn"+iprows+"',true,'Subnet Address')\"></input><input hidden id='row"+iprows+"' value='"+iprows+"'></div></td></tr>");

		//$("#"+tabid).append("<tr id='waniprow"+iprows+"'><td width='200'><div>IPV4 Address</div><br/><div>Subnet Address</div></td><td width='200'><div><input type='text' class='text' id='wanip"+iprows+"' name='wanip"+iprows+"' onkeypress='return avoidSpace(event);' style='display:inline block; position:relative; left:3px'  onfocusout=\"validateIP('wanip"+iprows+"',true,'IPV4 Address')\"></input></div><div style='margin-left:120px;'><label class='add' id='add"+iprows+"' onclick=\"addIPRowAndChangeIcon('statictab',"+iprows+")\">+</label><label class='remove' style='display:inline;' id='remove"+iprows+"' onclick='deletetableRow("+iprows+")'>x</label></div><div width='200'><input type='text' class='text' id='wansn"+iprows+"' name='wansn"+iprows+"' onkeypress='return avoidSpace(event)' style='display:inline block; position:relative; left:3px' onfocusout=\"validateSubnetMask('wansn"+iprows+"',true,'Subnet Address')\"></input><input hidden id='row"+iprows+"' value='"+iprows+"'></div></td></tr>");
	else
	$("#"+tabid).append("<tr id='waniprow"+iprows+"'><td width='200'><div></div><br/><div></div></td><td width='200'><div><input type='text' class='text' id='wanip"+iprows+"' name='wanip"+iprows+"' onkeypress='return avoidSpace(event);' style='display:inline block; position:relative; left:3px' maxlength='15' onfocusout=\"validateIPOnly('wanip"+iprows+"',true,'IPV4 Address')\"></input></div><div style='margin-left:155px;'><label class='add' id='add"+iprows+"' onclick=\"addIPRowAndChangeIcon('statictab',"+iprows+")\">+</label><label class='remove' style='display:inline;' id='remove"+iprows+"' onclick='deletetableRow("+iprows+")'>x</label></div><div width='200'><input type='text' class='text' id='wansn"+iprows+"' name='wansn"+iprows+"' onkeypress='return avoidSpace(event)' style='display:inline block; position:relative; left:3px' maxlength='15' onfocusout=\"validateSubnetMask('wansn"+iprows+"',true,'Subnet Address')\"></input><input hidden id='row"+iprows+"' value='"+iprows+"'></div></td></tr>");
	//$("#"+tabid).append("<tr id='waniprow"+iprows+"'><td width='200'><div></div><br/><div></div></td><td width='200'><div><input type='text' class='text' id='wanip"+iprows+"' name='wanip"+iprows+"' onkeypress='return avoidSpace(event);' style='display:inline block; position:relative; left:3px'  onfocusout=\"validateIP('wanip"+iprows+"',true,'IPV4 Address')\"></input></div><div style='margin-left:120px;'><label class='add' id='add"+iprows+"' onclick=\"addIPRowAndChangeIcon('statictab',"+iprows+")\">+</label><label class='remove' style='display:inline;' id='remove"+iprows+"' onclick='deletetableRow("+iprows+")'>x</label></div><div width='200'><input type='text' class='text' id='wansn"+iprows+"' name='wansn"+iprows+"' onkeypress='return avoidSpace(event)' style='display:inline block; position:relative; left:3px' onfocusout=\"validateSubnetMask('wansn"+iprows+"',true,'Subnet Address')\"></input><input hidden id='row"+iprows+"' value='"+iprows+"'></div></td></tr>");

	document.getElementById("waniprows").value = iprows;
	adjtabFirstcolumn(tabid,'IPV4 Address','Subnet Address');
}

function deletetableRow(row)
{
	deleteRow(row);
	findLastRowAndDisplayRemoveIcon();
	adjtabFirstcolumn('statictab','IPV4 Address','Subnet Address');
}
function findLastRowAndDisplayRemoveIcon()
{
	var table = document.getElementById("statictab");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[1].childNodes[1].childNodes[0];
	var removeobj = lastrow.cells[1].childNodes[1].childNodes[1];
	addobj.style.display="inline";
	if(table.rows.length > 1)
		removeobj.style.display="inline";
	else if(table.rows.length == 1)
	removeobj.style.display="none";
}
function fillIProw(rowid,ipaddress,subnet)
{
	document.getElementById('wanip'+rowid).value=ipaddress;
	document.getElementById('wansn'+rowid).value=subnet;
}
function displayActiveTable(selboxid)
{
	var selobj = document.getElementById(selboxid);
	var tableids = ['statictab','staticdns','dhcptab','pppoetab','ipv6config','dhcp6c','dhcp6c1'];
	var protocal = selobj.options[selobj.selectedIndex].text;
	var tableid = 'statictab';
	if(protocal=='DHCP Client' || protocal=='PPPoE')
	{
		for(var i=0;i<tableids.length;i++)
		{
			var tabobj = document.getElementById(tableids[i]);
			if((protocal=='DHCP Client' && tableids[i] == 'dhcptab') || (protocal=='PPPoE' && tableids[i] == 'pppoetab'))
			{
				tabobj.style.display='table';
			}
			else
			{
				tabobj.style.display='none';
			}
		}
	}
	else if(protocal=='DHCPv6 Client')
	{
		for(var i=0;i<tableids.length;i++)
		{
			var tabobj = document.getElementById(tableids[i]);
			if((protocal=='DHCPv6 Client' && tableids[i] == 'dhcp6c') || (protocal=='DHCPv6 Client' && tableids[i] == 'dhcp6c1'))
			{
				tabobj.style.display='table';
			}
			else
			{
				tabobj.style.display='none';
			}
		}
	}
	else
	{
		for(var i=0;i<tableids.length;i++)
		{
			var tabobj = document.getElementById(tableids[i]);
			if(tableids[i] == 'statictab' || tableids[i] == 'staticdns' || tableids[i] == 'ipv6config')
			{
				tabobj.style.display='table';
			}
			else
			{
				tabobj.style.display='none';
			}
		}
	}
     activateDNSServer('dnssvractv');	
}

function changeIcon(rowid)
{
	var add=document.getElementById("add"+rowid);
	var remove=document.getElementById("remove"+rowid);
	add.style.display="none";
	remove.style.display ="inline";
}

//dhcp custom dns server
function adjtabFirstcolumndhcp(tabname,setname)
{
	var table = document.getElementById(tabname);
	var rows = table.rows;
	var index = 0;
	if(tabname == "dhcptab")
		index = 6;
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
function deleteRowdhcp(rowid)
{
	var ele = document.getElementById("cusdnsdhcp"+rowid);
	$('table#dhcptab tr#cusdnsdhcp'+rowid).remove();
}
function deletetableRowdhcp(row)
{
	deleteRowdhcp(row);
	findLastRowAndDisplayRemoveIcondhcp();
	adjtabFirstcolumndhcp('dhcptab','Custom DNS Server');
}
function addIPRowAndChangeIcondhcp(rowid)
{
	var table = document.getElementById("dhcptab");
	if(table.rows.length >=11)
	{
		alert("Max 5 rows are allowed");
		return;
	}
	customdnsdhcp++;
	var remove=document.getElementById("removedhcp"+rowid);
	var add=document.getElementById("adddhcp"+rowid);
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline";
	//$("#dhcptab").append("<tr id='cusdnsdhcp"+customdnsdhcp+"'><td><div>Custom DNS Server</div></td><td><div><input type='text' class='text' placeholder= 'EnterIPv4orIPV6Address'  id='serversdhcp"+customdnsdhcp+"' name='serversdhcp"+customdnsdhcp+"' onkeypress='return avoidSpace(event);' style='display:inline block;' onfocusout=\"validateIP('serversdhcp"+dhcp+"',true,'Custom DNS Server')\"></input><label class='add' id='adddhcp"+customdnsdhcp+"' style='display:inline block;' onclick='addIPRowAndChangeIcondhcp("+customdnsdhcp+")'>+</label><label class='remove' style='display:inline;' id='removedhcp"+customdnsdhcp+"' onclick='deletetableRowdhcp("+customdnsdhcp+")'>x</label><input hidden id='row"+customdnsdhcp+"' value='"+customdnsdhcp+"'></div></td></tr>");
	$("#dhcptab").append("<tr id='cusdnsdhcp"+customdnsdhcp+"'><td min-width=\"200\"><div>Custom DNS Server</div></td><td width=\"195\"><div><input type='text' class='text' style='position: relative; left: 3px;display:inline block' placeholder='EnterIPv4orIPV6Address' id='serversdhcp"+customdnsdhcp+"' name='serversdhcp"+customdnsdhcp+"'  style='display:inline block;' onmouseover=\"setTitle(this)\" onkeypress='return avoidSpace(event);' onfocusout=\"validatedualIP('serversdhcp"+customdnsdhcp+"',false,'Custom DNS Server',false)\"></input><i class='fa fa-plus' id='adddhcp"+customdnsdhcp+"' style='font-size:10px; margin-left:7px;color:green;display:inline block'; onclick='addIPRowAndChangeIcondhcp("+customdnsdhcp+")'></i><i class='fa fa-close' style='display:inline;font-size:10px; margin-left:5px; color:red;' id='removedhcp"+customdnsdhcp+"' onclick='deletetableRowdhcp("+customdnsdhcp+")'></i><input hidden id='row"+customdnsdhcp+"' value='"+customdnsdhcp+"'></div></td></tr>");

	document.getElementById("dnsdhcprows").value=customdnsdhcp;
	adjtabFirstcolumndhcp('dhcptab','Custom DNS Server');
}
function findLastRowAndDisplayRemoveIcondhcp()
{
	var table = document.getElementById("dhcptab");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[1].childNodes[0].childNodes[1];
	var removeobj = lastrow.cells[1].childNodes[0].childNodes[2];
	addobj.style.display="inline";
	if(table.rows.length > 8)
		removeobj.style.display="inline";
	else if(table.rows.length == 7)
	removeobj.style.display="none";
}
function fillIProwdhcp(rowid,dnsserverdhcp)
{
	document.getElementById('serversdhcp'+rowid).value=dnsserverdhcp;
}

//pppoe custom dns server
function adjtabFirstcolumnpppoe(tabname,setname)
{
	var table = document.getElementById(tabname);
	var rows = table.rows;
	var index = 0;
	if(tabname == "pppoetab")
		index = 8;
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
function deleteRowpppoe(rowid)
{
	var ele = document.getElementById("cusdnspppoe"+rowid);
	$('table#pppoetab tr#cusdnspppoe'+rowid).remove();
}
function deletetableRowpppoe(row)
{
	deleteRowpppoe(row);
	findLastRowAndDisplayRemoveIconpppoe();
	adjtabFirstcolumnpppoe('pppoetab','Custom DNS Server');
}
function addIPRowAndChangeIconpppoe(rowid)
{
	var table = document.getElementById("pppoetab");
	if(table.rows.length >=13)
	{
		alert("Max 5 rows are allowed");
		return;
	}
	customdnspppoe++;
	var remove=document.getElementById("removepppoe"+rowid);
	var add=document.getElementById("addpppoe"+rowid);
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline";
	//$("#pppoetab").append("<tr id='cusdnspppoe"+customdnspppoe+"'><td><div>Custom DNS Server</div></td><td><div><input type='text' class='text' id='serverspppoe"+customdnspppoe+"' name='serverspppoe"+customdnspppoe+"' onkeypress='return avoidSpace(event);' style='display:inline block;' onfocusout=\"validateIP('serverspppoe"+customdnspppoe+"',true,'Custom DNS Server')\"></input><label class='add' id='addpppoe"+customdnspppoe+"' style='display:inline block;' onclick='addIPRowAndChangeIconpppoe("+customdnspppoe+")'>+</label><label class='remove' style='display:inline;' id='removepppoe"+customdnspppoe+"' onclick='deletetableRowpppoe("+customdnspppoe+")'>x</label><input hidden id='row"+customdnspppoe+"' value='"+customdnspppoe+"'></div></td></tr>");
	$("#pppoetab").append("<tr id='cusdnspppoe"+customdnspppoe+"'><td min-width=\"200\"><div>Custom DNS Server</div></td><td width=\"195\"><div><input type='text' class='text' style='position: relative; left: 3px;display:inline block' placeholder='EnterIPv4orIPV6Address' id='serverspppoe"+customdnspppoe+"' name='serverspppoe"+customdnspppoe+"'  style='display:inline block;' onmouseover=\"setTitle(this)\" onkeypress='return avoidSpace(event);' onfocusout=\"validatedualIP('serverspppoe"+customdnspppoe+"',false,'Custom DNS Server',false)\"></input><i class='fa fa-plus' id='addpppoe"+customdnspppoe+"' name='addpppoe"+customdnspppoe+"' style='font-size:10px; margin-left:7px;color:green;display:inline block'; onclick='addIPRowAndChangeIconpppoe("+customdnspppoe+")'></i><i class='fa fa-close' style='display:inline;font-size:10px; margin-left:5px; color:red;' id='removepppoe"+customdnspppoe+"' onclick='deletetableRowpppoe("+customdnspppoe+")'></i><input hidden id='row"+customdnspppoe+"' value='"+customdnspppoe+"'></div></td></tr>");

	document.getElementById("dnspppoerows").value = customdnspppoe;
	adjtabFirstcolumnpppoe('pppoetab','Custom DNS Server');
}
function findLastRowAndDisplayRemoveIconpppoe()
{
	var table = document.getElementById("pppoetab");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[1].childNodes[0].childNodes[1];
	var removeobj = lastrow.cells[1].childNodes[0].childNodes[2];
	addobj.style.display="inline";
	if(table.rows.length > 10)
		removeobj.style.display="inline";
	else if(table.rows.length == 9)
	removeobj.style.display="none";
}
function fillIProwpppoe(rowid,dnsserverpppoe)
{
	document.getElementById('serverspppoe'+rowid).value=dnsserverpppoe;
}

//custom static dns server
function adjtabFirstcolumnstatic(tabname,setname)
{
	var table = document.getElementById(tabname);
	var rows = table.rows;
	var index = 0;
	if(tabname == "staticdns")
		index = 4;
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
function deleteRowstatic(rowid)
{
	var ele = document.getElementById("cusdnsstatic"+rowid);
	$('table#staticdns tr#cusdnsstatic'+rowid).remove();
}
function deletetableRowstatic(row)
{
	deleteRowstatic(row);
	findLastRowAndDisplayRemoveIconstatic();
	adjtabFirstcolumnstatic('staticdns','Custom DNS Server');
}
function addIPRowAndChangeIconstatic(rowid)
{
	var table = document.getElementById("staticdns");
	if(table.rows.length >=9)
	{
		alert("Max 5 rows are allowed");
		return;
	}
	customdnsstatic++;
	var remove=document.getElementById("removestatic"+rowid);
	var add=document.getElementById("addstatic"+rowid);
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline";
	//$("#staticdns").append("<tr id='cusdnsstatic"+customdnsstatic+"'><td><div>Custom DNS Server</div></td>   <td><div><input type='text' class='text' id='serversstatic"+customdnsstatic+"' name='serversstatic"+customdnsstatic+"' onkeypress='return avoidSpace(event);' style='display:inline block;' onfocusout=\"validateIP('serversstatic"+customdnsstatic+"',true,'Custom DNS Server')\"></input><label class='add' id='addstatic"+customdnsstatic+"' style='display:inline block;' onclick='addIPRowAndChangeIconstatic("+customdnsstatic+")'>+</label><label class='remove' style='display:inline;' id='removestatic"+customdnsstatic+"' onclick='deletetableRowstatic("+customdnsstatic+")'>x</label><input hidden id='row"+customdnsstatic+"' value='"+customdnsstatic+"'></div></td></tr>");
	$("#staticdns").append("<tr id='cusdnsstatic"+customdnsstatic+"'><td min-width=\"200\"><div>Custom DNS Server</div></td><td width=\"195\"><div><input type='text' class='text' style='position: relative; left: 3px;display:inline block'placeholder='EnterIPv4orIPV6Address'  id='serversstatic"+customdnsstatic+"' name='serversstatic"+customdnsstatic+"'  style='display:inline block;' onmouseover=\"setTitle(this)\" onkeypress='return avoidSpace(event);' onfocusout=\"validatedualIP('serversstatic"+customdnsstatic+"',false,'Custom DNS Server',false)\"></input><i class='fa fa-plus' id='addstatic"+customdnsstatic+"' style='font-size:10px; margin-left:7px;color:green;display:inline block'; onclick='addIPRowAndChangeIconstatic("+customdnsstatic+")'></i><i class='fa fa-close' style='display:inline;font-size:10px; margin-left:5px; color:red;' id='removestatic"+customdnsstatic+"' onclick='deletetableRowstatic("+customdnsstatic+")'></i><input hidden id='row"+customdnsstatic+"' value='"+customdnsstatic+"'></div></td></tr>");
	document.getElementById("dnsstarows").value = customdnsstatic;
	adjtabFirstcolumnstatic('staticdns','Custom DNS Server');
}
function findLastRowAndDisplayRemoveIconstatic()
{
	var table = document.getElementById("staticdns");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[1].childNodes[0].childNodes[1];
	var removeobj = lastrow.cells[1].childNodes[0].childNodes[2];
	addobj.style.display="inline";
	if(table.rows.length > 5)
		removeobj.style.display="inline";
	else if(table.rows.length == 5)
	removeobj.style.display="none";
}
function fillIProwstatic(rowid,dnsserverstatic)
{
	document.getElementById('serversstatic'+rowid).value=dnsserverstatic;
}

function validOnshowWanComboBox(id,name,id1)
{
	
  var ipv6addrs=document.getElementById("ipv6address");
  var ipv6gw=document.getElementById("ipv6gateway");
  var ipv6asghnt=document.getElementById("ipv6hint");
  var ipv6agntxtobj = document.getElementById(id);
  var ipv6agnselobj = document.getElementById('ipv6asl');
  var ipv6agntxt=ipv6agntxtobj.value;
  document.getElementById(id1).value=ipv6agntxtobj.value;
  if(ipv6agntxtobj.value.trim() != "")
  {
	  if(ipv6agntxtobj.value>64)
	  {
		  ipv6agntxtobj.style.outline="thin solid red";
		  ipv6agntxtobj.title = "invalid "+name;
		  return false;
	  }
	  else
	  {
		  ipv6agntxtobj.style.outline="initial";
		  ipv6agntxtobj.title = "";
		  return true;
	  }
      
  }
  ipv6agntxtobj.style.display = 'none';
  ipv6agnselobj.style.display = 'inline';
  ipv6addrs.style.display="";
  ipv6gw.style.display="";
  ipv6asghnt.style.display="none";
  ipv6agnselobj.selectedIndex = 0;
  //ipv6agntxtobj.style.outline="initial";
  //ipv6agntxtobj.title = "";
}

function IPv6Assignment(id)
{
  var ipv6aslselobj=document.getElementById(id);
  var ipv6asgnmnt=ipv6aslselobj.options[ipv6aslselobj.selectedIndex].text;
  var ipv6asghnt=document.getElementById("ipv6hint");
  var ipv6addrs=document.getElementById("ipv6address");
  var ipv6gw=document.getElementById("ipv6gateway");
  if(ipv6asgnmnt=="disable")
  {
	  ipv6asghnt.style.display="none";
      ipv6addrs.style.display="";
      ipv6gw.style.display="";
  }
  else if(ipv6asgnmnt=="64")
  {
	  
	 ipv6asghnt.style.display="";
     ipv6addrs.style.display="none";
     ipv6gw.style.display="none";	 
  }
  else if(ipv6asgnmnt=="custom")
  {
	    ipv6aslselobj.style.display = 'none';
		ipv6asghnt.style.display="";
        ipv6addrs.style.display="none";
        ipv6gw.style.display="none";
		var ipv6agmttxtobj = document.getElementById("ipv6asgmnt");
		ipv6agmttxtobj.style.display = 'inline';
		ipv6agmttxtobj.focus();
  }
  else if((ipv6aslselobj.value)<64)
  {
   	    ipv6addrs.style.display="none";
   	    ipv6gw.style.display="none";
   	    ipv6asghnt.style.display="";
  }

}

function validOnshowCusComboBox(id,name)
{
  var ipv6agntxtobj = document.getElementById(id);
  var ipv6agnselobj = document.getElementById('reqipv6prelen');
  if(ipv6agntxtobj.value.trim() != "")
  {
	  if(ipv6agntxtobj.value>64)
	  {
		  ipv6agntxtobj.style.outline="thin solid red";
		  ipv6agntxtobj.title = "invalid "+name;
		  return false;
	  }
	  else
	  {
		  ipv6agntxtobj.style.outline="initial";
		  ipv6agntxtobj.title = "";
		  return true;
	  }
      
  }
  ipv6agntxtobj.style.display = 'none';
  ipv6agnselobj.style.display = 'inline';
  ipv6agntxtobj.style.outline="initial";
  ipv6agntxtobj.title = "";
  ipv6agnselobj.selectedIndex = 0;
}
function IPv6prefixlength(id)
{
  var ipv6prelenobj=document.getElementById(id);
  var ipv6prelen=ipv6prelenobj.options[ipv6prelenobj.selectedIndex].text;
	if(ipv6prelen=="custom")
	{
		ipv6prelenobj.style.display = 'none';
		var ipv6cusobj = document.getElementById("ipv6prelength");
		ipv6cusobj.style.display = 'inline';
		ipv6cusobj.focus();
	}
}

//custom dhcp6c 
function adjtabFirstcolumndhcp6c(tabname,setname)
{
	var table = document.getElementById(tabname);
	var rows = table.rows;
	var index = 0;
	if(tabname == "dhcp6c1")
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
function deleteRowdhcp6c(rowid)
{
	var ele = document.getElementById("cusdnsdhcp6c"+rowid);
	$('table#dhcp6c1 tr#cusdnsdhcp6c'+rowid).remove();
}
function deletetableRowdhcp6c(row)
{
	deleteRowdhcp6c(row);
	findLastRowAndDisplayRemoveIcondhcp6c();
	adjtabFirstcolumndhcp6c('dhcp6c1','Custom DNS Server');
}
function addIPRowAndChangeIcondhcp6c(rowid)
{
	var protocol=document.getElementById("wanproto");
	
	 var table = document.getElementById("dhcp6c1");
	 if(table.rows.length >=5)
	 {
		alert("Max 5 rows are allowed");
		return;
	 }
	customdnsdhcp6c++;
	var remove=document.getElementById("removedhcp6c"+rowid);
	var add=document.getElementById("adddhcp6c"+rowid);
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline";
	//$("#dhcp6c1").append("<tr id='cusdnsdhcp6c"+customdnsdhcp6c+"'><td><div>Custom DNS Server</div></td><td style='padding-left:50px;'><div><input type='text' class='text' id='serversdhcp6c"+customdnsdhcp6c+"' name='serversdhcp6c"+customdnsdhcp6c+"' style='display:inline block;' onkeypress='return avoidSpace(event);' onfocusout=\"validateIPv6('serversdhcp6c"+customdnsdhcp6c+"',true,'Custom DNS Server')\"></input><label class='add' id='adddhcp6c"+customdnsdhcp6c+"' style='display:inline block;' onclick='addIPRowAndChangeIcondhcp6c("+customdnsdhcp6c+")'>+</label><label class='remove' style='display:inline;' id='removedhcp6c"+customdnsdhcp6c+"' onclick='deletetableRowdhcp6c("+customdnsdhcp6c+")'>x</label><input hidden id='row"+customdnsdhcp6c+"' value='"+customdnsdhcp6c+"'></div></td></tr>");
	$("#dhcp6c1").append("<tr id='cusdnsdhcp6c"+customdnsdhcp6c+"'><td min-width=\"200\"><div>Custom DNS Server</div></td><td width=\"195\"><div><input type='text' class='text' style='position: relative; left: 3px;display:inline block' placeholder='EnterIPv4orIPV6Address' id='serversdhcp6c"+customdnsdhcp6c+"' name='serversdhcp6c"+customdnsdhcp6c+"'  style='display:inline block;' onmouseover=\"setTitle(this)\" onkeypress='return avoidSpace(event);' onfocusout=\"validatedualIP('serversdhcp6c"+customdnsdhcp6c+"',false,'Custom DNS Server',false)\"></input><i class='fa fa-plus' id='adddhcp6c"+customdnsdhcp6c+"' style='font-size:10px; margin-left:7px;color:green;display:inline block'; onclick='addIPRowAndChangeIcondhcp6c("+customdnsdhcp6c+")'></i><i class='fa fa-close' style='display:inline;font-size:10px; margin-left:5px; color:red;' id='removedhcp6c"+customdnsdhcp6c+"' onclick='deletetableRowdhcp6c("+customdnsdhcp6c+")'></i><input hidden id='row"+customdnsdhcp6c+"' value='"+customdnsdhcp6c+"'></div></td></tr>");

	document.getElementById("dnsdhcp6rows").value = customdnsdhcp6c;
	adjtabFirstcolumndhcp6c('dhcp6c1','Custom DNS Server');
	
}
function findLastRowAndDisplayRemoveIcondhcp6c()
{
	var table = document.getElementById("dhcp6c1");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[1].childNodes[0].childNodes[1];
	var removeobj = lastrow.cells[1].childNodes[0].childNodes[2];
	addobj.style.display="inline";
	if(table.rows.length > 1)
		removeobj.style.display="inline";
	else if(table.rows.length == 1)
	removeobj.style.display="none";
}
function fillIProwdhcp6c(rowid,dnsserverdhcp6c)
{
	document.getElementById('serversdhcp6c'+rowid).value=dnsserverdhcp6c;
}
function activateDNSServer(id)
{
	var protocol=document.getElementById("wanproto");
	var table=document.getElementById("dhcp6c1");
	if(protocol.value=='dhcpv6')
	{
	    var activation=document.getElementById(id);
		if(activation.checked)
	    {
		  table.style.display="none";
		}
		else
	    {
		  table.style.display="";
	    }
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
// added new functions..........

function hideDhcpCustomDns(tableid,cdnsid)
{
	var table = document.getElementById(tableid); 
	var obtaindns = document.getElementById(cdnsid);
	for(var i=6;i<table.rows.length;i++)		
	obtaindns.checked?table.rows[i].style.display="none":table.rows[i].style.display="";
}
function hidePppCustomDns(tablid,cdnsid)
{
	var table = document.getElementById(tablid); 
	var obtaindns = document.getElementById(cdnsid);
	for(var i=8;i<table.rows.length;i++)		
	obtaindns.checked?table.rows[i].style.display="none":table.rows[i].style.display="";
}

		
