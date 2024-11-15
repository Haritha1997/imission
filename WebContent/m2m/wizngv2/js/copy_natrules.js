var iprows=1;

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
		if (iprows == 26) 
		{ 
			alert("Maximum 25 rows are allowed"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("trafficrwcnt").value = iprows; 
		iprows = document.getElementById("trafficrwcnt").value; 
		document.getElementById("trafficrwcnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id='trafficrow"+iprows+"' >"+
		"<td>"+iprows+"</td>"+
		<!--"<td align=\"center\" class=\"text1\" id=\"instancename"+iprows+"\" name=\"instancename"+iprows+"\" onkeypress=\"return avoidSpace(event) || avoidEnter(event)\" onfocus=\"loadInstanceNameIndex('instancename"+iprows+"')\" onfocusout=\"duplicateInstanceNamesExists('instancename"+iprows+"','WiZConff')\" readonly></td>"+-->
		"<td><input type=\"text\" align=\"center\" class=\"text\" id=\"instancename"+iprows+"\" name=\"instancename"+iprows+"\" onkeypress=\"return avoidSpace(event) || avoidEnter(event)\" onfocus=\"loadInstanceNameIndex('instancename"+iprows+"')\" onfocusout=\"duplicateInstanceNamesExists('instancename"+iprows+"','WiZConff')\" readonly></td>"+
		<!--"<td><input type=\"text\" size=\"50\" maxlength=\"50\" name=\"match\" class=\"text\" id=\"match"+iprows+"\"></input></td>"+-->
		"<td align=\"left\"><label style=\"text-align:left\" name=\"match"+iprows+"\" id=\"match"+iprows+"\"></label></td>"+
		<!--"<td><input type=\"text\" size=\"50\" maxlength=\"50\" name=\"action\" class=\"text\" id=\"action"+iprows+"\"></input></td>"+-->
		"<td align=\"left\"><label style=\"text-align:left\" name=\"action"+iprows+"\" id=\"action"+iprows+"\"></label></td>"+
		"<td><label class=\"switch\"><input type=\"checkbox\" id=\"activation"+iprows+"\" name=\"activation"+iprows+"\" checked><span class=\"slider round\"></span></input></label></td>"+
		<!--"<td><input type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" value=\"Edit\" class=\"button1\" align=\"left\" onclick=\"gotoNATRuleEditPage('instancename"+iprows+"')\">"+-->
		"<td><button type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"gotoNATRuleEditPage('instancename"+iprows+"')\">Edit <i class='fas fa-edit' style='font-size:12px;color:white'></i></button>"+
		"<image id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"/images/delete.png\" width=\"22\" height=\"22\" align=\"right\" title=\"Delete\" onclick=\"deleteNATRulepage(this, 'instancename"+iprows+"');\"></image></td>"+
		"<td hidden>0</td>"+
		"<td hidden>"+iprows+"</td>"+
		"</tr>"; 
		$('#WiZConff').append(row);  
		loadNewinstnameToIPSecInstname(iprows,tablename);		
	} 
	else
	{
		alert("no add row");
	}
	reindexTable();
	var height = table.rows[1].cells[0].offsetHeight;
	window.scrollBy(0,height);
}

function loadNewinstnameToIPSecInstname(row,tablename)
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

function fillrow(rowid,instancename,matchstr,action,activation)
{
	document.getElementById('instancename'+rowid).value=instancename;
	document.getElementById('match'+rowid).innerHTML=matchstr;
	document.getElementById('action'+rowid).innerHTML=action;
	document.getElementById('activation'+rowid).checked=activation;
}

function gotoNATRuleEditPage(showinstancename)
{
	var instname = document.getElementById(showinstancename).value;
	location.href = "edit_natrules.jsp";
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

function addNATRule(showinstancename, addinstance)
{
	alert("in the function add nat rule");
    	var table = document.getElementById("WiZConff");
	var iprows = table.rows.length;
        if (iprows==26)
	{
		alert("Maximum 25 Entries are allowed");
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

		//alert("New instant value is : '"+newinstval+"'");
	}

	var instname = document.getElementById(showinstancename).value;
	location.href = "edit_natrules.jsp";
}

function deleteNATRulepage(el,id)
{
    	var instance=document.getElementById(id).value;
   	while (el.parentNode && el.tagName.toLowerCase() != 'tr') 
	{
        el = el.parentNode;
    	}
    	if (el.parentNode && el.parentNode.rows.length > 1) 
	{
        el.parentNode.removeChild(el);
    	}
	reindexTable();
	location.href = "edit_natrules.jsp";
}


