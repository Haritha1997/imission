var iprows=1;

function chkIPV4()
{
	var altmsg="";
	for(x=0;x<3;x++)
	{
		if(x==0)
		{
			var obj=document.getElementById(txtBox1[x]);
			var val=obj.value.trim();
			var name=obj.name;
			if(!isNumber(val) || parseInt(val)<1 || parseInt(val)>25)
			{
				obj.style.outline = "thin solid red";
				obj.title = "Invalid " + name;
				altmsg += name +" is not Valid \n";
			}
			else
			{
				obj.style.outline = "initial";
				obj.title = "";
			}	
		}
		else if(x>0)
		{
			var obj1=document.getElementById(txtBox1[x]);
			var val1=obj1.value;
			var name1=obj1.name;
			if(!isNumber(val1)||(parseInt(val1)<0 || parseInt(val1)>65535))
			{
				obj1.style.outline = "thin solid red";
				obj1.title = "Invalid " + name;
				altmsg += name1 +" is not Valid \n";
			}
			else
			{
				obj1.style.outline = "initial";
				obj1.title = "";
			}
		}
	}
	for(x=3;x<txtBox1.length;x++)
	{
		var obj=document.getElementById(txtBox1[x]);
		var val=obj.value.trim();
		var name=obj.name;
		var ret=validateIP(txtBox1[x],true,'Inside IP');
		if (!ret) 
		{
			if(val == "") 
			altmsg += "Inside IP should not be empty.\n";
			else 
			altmsg += "Invalid IP (" + val + ").\n";
		}
	}
	if(altmsg=="")
		return true;
	else
	{
		alert(altmsg);
		return false;
	}
}

function chkFunc()
{
	return chkIPV4();
}

function isNumber(n) 
{ 
	return /^[0-9]+$/.test(n);
}

function validateIP(id,checkempty,name) 
{
	var ipele = document.getElementById(id);
	var ipformat = /^(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)$/;
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
	else if (!ipaddr.match(ipformat) ||  ipaddr == "255.255.255.255" || ipaddr == "0.0.0.0") 
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
		ipele.title="Invalid "+name; 
		return false; 
	} 
	else 
	{ 
		ipele.style.outline ="initial"; 
		ipele.title = ""; 
		return true; 
	} 
} 

function IPv4AddressKeyOnly(e) 
{
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	if((keyCode == 46 || keyCode==8 || keyCode == 9 || keyCode == 13 ) || (keyCode >= 48 && keyCode <= 57))
	{
		return true;
	}
	return false;
} 

function loadInstanceNameIndex(id)
{		
	oldinstname="";
	if(document.getElementById(id).value == "")
	{
		return;
	}
	instid=id;
	oldinstname=document.getElementById(id).value;
}

function duplicateInstanceNamesExists(id,tablename)
{
	var dupexists=false;
    var table = document.getElementById(tablename);
	var rowcnt = table.rows.length;
	var obj=document.getElementById(id);
	var name=obj.value;
	if(name == "")
	{
		obj.style.outline ="thin solid red";
		if(tablename == "WiZConff")				
		obj.title="Instance Name should not be empty";
	}
	else
	{
		obj.title="";
	}
	if(tablename == "WiZConff")
	{
		var displaystr = "Instance Name";
		var ipsectab=document.getElementById("WiZConff");
		var rowsize=ipsectab.rows.length;
		for(var i=1;i<rowsize;i++)
		{
			var lcolind=ipsectab.rows[i].cells.length-1;
			var oriind=ipsectab.rows[i].cells[lcolind].innerHTML;
			var instname=document.getElementById('instancename'+oriind).value;

			if((id != 'instancename'+oriind) && instname == name && instname != "")
			{
				alert(displaystr+" "+name+" already exists");
				dupexists= true;
				document.getElementById(id).style.outline="thin solid red";
				document.getElementById(id).value="";
				break;
			}
		}
	}
	return dupexists;
}

function addRow(tablename,addinstance) 
{ 
	var table = document.getElementById(tablename); 
	var iprows = table.rows.length;
	var newinstancename=document.getElementById("nwinstname");
	var newinstval="";
	if(addinstance)
	{
		if(duplicateInstanceNamesExists("nwinstname",tablename))
		{
			return;
		}
		newinstval=newinstancename.value;
	}
	//var letters = /^[A-Za-z]+$/;	
	if (tablename == "WiZConff") 
	{ 
		if(newinstval == "" && addinstance)
		{ 
			alert("Enter the New Instance Name first and then add the row");
			newinstancename.style.outline ="thin solid red";
			return false;
		}
		if (iprows == 21) 
		{ 
			alert("Maximum 20 Entries are allowed");
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("grerwcnt").value = iprows; 
		iprows = document.getElementById("grerwcnt").value; 
		document.getElementById("grerwcnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id='portrow"+iprows+"' >"+
		"<td>"+iprows+"</td>"+
		"<td><input type=\"text\" align=\"center\" class=\"text\" id=\"instancename"+iprows+"\" name=\"instancename"+iprows+"\" onkeypress=\"return avoidSpace(event) || avoidEnter(event)\" onfocus=\"loadInstanceNameIndex('instancename"+iprows+"')\" onfocusout=\"duplicateInstanceNamesExists('instancename"+iprows+"','WiZConff')\" readonly></td>"+
		"<td><input type=\"text\" align=\"center\" class=\"text\" id=\"protocol"+iprows+"\" name=\"protocol"+iprows+"\"  value=\"GRE\" onkeypress=\"return avoidSpace(event) || avoidEnter(event)\"   readonly></td>"+
		"<td><label class=\"switch\"><input type=\"checkbox\" id=\"activation"+iprows+"\" name=\"activation"+iprows+"\" checked><span class=\"slider round\"></span></input></label></td>"+
		<!--"<td><input type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" value=\"Edit\" class=\"button1\" align=\"left\" onclick=\"gotoforwardeditpage('instancename"+iprows+"')\">"+-->
		"<td><button type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"gotoforwardeditpage('instancename"+iprows+"')\">Edit <i class='fas fa-edit' style='font-size:12px;color:white'></i></button>"+
		"<image style=\"cursor:pointer\" id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"/images/delete.png\" width=\"22\" height=\"22\" align=\"right\" title=\"Delete\" onclick=\"deleteforwardeditpage(this,'instancename"+iprows+"');\"></image></td>"+
		"<td hidden>0</td>"+
		"<td hidden>"+iprows+"</td>"+
		"</tr>"; 
		$('#WiZConff').append(row);  
		loadNewinstnameToGREInstname(iprows,tablename);		
	} 
	else
	{
		alert("no add row");
	}
	reindexTable();
	var height = table.rows[1].cells[0].offsetHeight;
	window.scrollBy(0,height);
}

function loadNewinstnameToGREInstname(row,tablename)
{       
    var table = document.getElementById("WiZConff");
	var rowcnt = table.rows.length;
    if(tablename=="WiZConff")
	{  
	    var instid="instancename"+row;
		var instances=getNewInstanceNames();
		var selinstobj=document.getElementById(instid);
	    var instdata="";
		for(i=0;i<instances.length;i++)
		{
			if(instances[i] != "")
			instdata +=instances[i];
		}
		$("#"+instid).append(instdata);
        selinstobj.value=instdata;
	}
}	
																
function getNewInstanceNames()
{
	var instarr=[];
	var insttab=document.getElementById("WiZConf1");
	var rowsize=insttab.rows.length;
	for(var i=0;i<rowsize;i++)
	{
		var instancename=document.getElementById("nwinstname").value;
		instarr.push(instancename);
	}
	return instarr;
}

function fillrow(rowid,instancename,protocol,activation)
{
	document.getElementById('instancename'+rowid).value=instancename;
	document.getElementById('protocol'+rowid).value=protocol;
	document.getElementById('activation'+rowid).checked=activation;
}

function gotoforwardeditpage(showinstancename)
{
	var instname = document.getElementById(showinstancename).value;
	//var slnumber = document.getElementById("slno").value;
	// location.href = "edit_gre6in4.html";
	location.href = "Nomus.cgi?cgi=manual6in4EditInstance="+instname+".cgi";
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

function isEmpty(id,name)
{
	var ele=document.getElementById(id);
	var val=ele.value;
	if(val == "")
	{
		ele.style.outline= "thin solid red";
		ele.title=name+" should be empty";
		return false;
	}
	else
	{
		ele.style.outline="initial";
		ele.title="";
		return true;
	}	
}

function validatePortRange(id,name,chkempty)
{
		var rele = document.getElementById(id);
		var val = rele.value.trim();
		var min = 1;
		var max = 65535;
		if(val == "")
		{
			if(chkempty)
			{
				rele.style.outline =  "thin solid red";
				rele.title = name+" should be integer in the range from "+min+" to "+max;
				return false;
			}
			else{
				rele.style.outline = "initial";
				rele.title = "";
				return true;
			}
		}
		var tmp="";
		var arr = val.split("-");
		if(arr.length > 1)
		{	
			if(arr.length > 2 || (parseInt(arr[1],10) < parseInt(arr[0],10)))
			{
				rele.style.outline =  "thin solid red";
				rele.title = name+" is not valid";
				return false;
			}
		}

		for(var i=0;i<arr.length;i++)
		{
			tmp = arr[i];
			if(!isNaN(tmp))
			{	
				tmp = parseInt(tmp,10);
				if( tmp>= min && tmp <= max)
				{
					rele.style.outline = "initial";
					rele.title = "";
				}
				else
				{
					rele.style.outline =  "thin solid red";
					rele.title = name+" should be in the range from "+min+" to "+max;
					valid = false;
					return false;
				}
			}
			else
			{
				rele.style.outline =  "thin solid red";
				rele.title = name+" should be integer in the range from "+min+" to "+max;
				valid = false;
				return false;
			}
		}
		return true;
}

function addforwardeditpage(showinstancename, addinstance)
{
    	var table = document.getElementById("WiZConff");
	var iprows = table.rows.length;
        if (iprows==21)
	{
		alert("Maximum 20 Entries are allowed");
		return false;
	}
	
	
	var newinstancename=document.getElementById("nwinstname");
	var newinstval="";

	if (addinstance)
	{
		if(duplicateInstanceNamesExists("nwinstname","WiZConff"))
		{
			return false;
		}
		newinstval=newinstancename.value;
		
		if (newinstval == "" && addinstance)
		{ 
			alert("Instance Name should not be empty");
			newinstancename.style.outline ="thin solid red";
			return false;
		}
	}

	var instname = document.getElementById(showinstancename).value;
	
	location.href = "edit_gre6in4.html";
	//location.href = "Nomus.cgi?cgi=manual6in4AddInstance="+instname+".cgi";
}

function deleteforwardeditpage(el,id)
{
    var instname=document.getElementById(id).value; 

	while (el.parentNode && el.tagName.toLowerCase() != 'tr') 
	{
		el = el.parentNode;
	}
	if (el.parentNode && el.parentNode.rows.length > 1) 
	{
        el.parentNode.removeChild(el);
    }
	reindexTable();
	location.href = "Nomus.cgi?cgi=manual6in4DeleteInstance="+instname+".cgi"; 
}

function validateRange(id,chkempty,name)
{
	var obj = document.getElementById(id);
	var val = obj.value.trim();
	var min = obj.min;
	var max = obj.max;
	if(chkempty && val.trim().length == 0)
		return false;		
	if((parseInt(val) < min) || (parseInt(val) > max))
		return false;
	return true;
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
	
	var totalipaddr = ipele.value;

	var ipaddr="";
	var suffix="";
	var ipaddrarr=""
	if(totalipaddr.includes("/"))
	{
		ipaddrarr = totalipaddr.split('/');
	}
	else{
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
function validateGre()
{

	var alertmsg = "";
	var rmtendaccess = document.getElementById("rem_ipaddress");			
	var mtu = document.getElementById("mtu");
	var ttl = document.getElementById("ttl");
	var keepintrval = document.getElementById("keep_alive_interval");
	var lclipaddress = document.getElementById("lcl_ipv6_address");
	var rmtipaddress = document.getElementById("rem_ipv6_ipaddress");
	var ipv6_gw = document.getElementById("ipv6_gateway");
	
	var valid = validateIP("rem_ipaddress",true,"Remote End Point IPAddress");
	if (!valid) {
		if (rmtendaccess.value.trim() == "") 
			alertmsg += "Remote End Point IPAddress should not be empty\n";
		else 
			alertmsg += "Remote End Point IPAddress is not valid\n";
	}
/*
	valid = validateRange("mtu",true,"MTU");
	if (!valid) {
		if (mtu.value.trim() == "") 
			alertmsg += "MTU should not be empty\n";
		else 
			alertmsg += "MTU is not valid\n";
	}
	valid = validateRange("ttl",true,"TTL");
	if (!valid) {
		if (ttl.value.trim() == "") 
			alertmsg += "TTL should not be empty\n";
		else 
			alertmsg += "TTL is not valid\n";
	}
	
	valid = validateRange("keep_alive_interval",true,"Keep Alive Interval");
	if (!valid) {
		if (keepintrval.value.trim() == "") 
			alertmsg += "Keep Alive Interval should not be empty\n";
		else 
			alertmsg += "Keep Alive Interval is not valid\n";
	}

*/
	valid = validateIPv6("lcl_ipv6_address",true,"Tunnel IPv6 Address");
	if (!valid) {
		if (lclipaddress.value.trim() == "") 
			alertmsg += "Tunnel IPv6 Address should not be empty\n";
		else 
			alertmsg += "Tunnel IPv6 Address is not valid\n";
	}
	valid = validateIPv6("rem_ipv6_ipaddress",true,"Target IPV6 network");
	if (!valid) {
		if (rmtipaddress.value.trim() == "") 
			alertmsg += "Target IPV6 network should not be empty\n";
		else 
			alertmsg += "Target IPV6 network is not valid\n";
	}
	valid = validateIPv6gateway("ipv6_gateway",true,"IPV6 Gatway");
	if (!valid) {
		if (ipv6_gw.value.trim() == "") 
			alertmsg += "IPV6 Gatway should not be empty\n";
		else 
			alertmsg += "IPV6 Gatway is not valid\n";
	}
	if (alertmsg.trim().length == 0) return true;
	else {
		alert(alertmsg);
		return false;
	}
}

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
