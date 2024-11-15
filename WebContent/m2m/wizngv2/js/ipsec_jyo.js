var iprows=1;

function avoidSpace(event) 
{
	var k = event ? event.which : window.event.keyCode;
	if (k == 32) 
	{
		alert("Space is not allowed");
		return false;
	}
}
		
function avoidEnter(event) 
{
	var k = event ? event.which : window.event.keyCode;
	if (k == 13) 
	{
		alert("Enter is not allowed");
		return false;
	}
}
	
function isEmpty(id,name)
{
	var ele=document.getElementById(id);
	var val=ele.value;
	if(val == "")
	{
		ele.style.outline= "thin solid red";
		ele.title=name+" should not be empty";
		return false;
	}
	else
	{
		ele.style.outline="initial";
		ele.title="";
		return true;
	}
}
 
function deleteRow(rowid)
{
	var ele = document.getElementById("laniprow"+rowid);
	$('table#WiZConf tr#laniprow'+rowid).remove();
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

function duplicateInstanceNamesExists(id, tablename)
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
		//obj.style.outline="initial";
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
	//alert("new instant value is : "+newinstval);
	}
	//var letters = /^[A-Za-z]+$/;
    if(tablename=="WiZConff")
	{
		if(newinstval == "" && addinstance)
		{ 
			alert("Instance Name should not be empty");
			newinstancename.style.outline ="thin solid red";
			return false;
		}
        if(iprows==6)
		{
			alert("Maximum 5 Entries are allowed");
			return false;
		}
		if(iprows == 1)
		document.getElementById("ipsecrwcnt").value = iprows;
		iprows = document.getElementById("ipsecrwcnt").value;
		document.getElementById("ipsecrwcnt").value = Number(iprows)+1;

		var row = "<tr align=\"center\">"+
			"<td>"+iprows+"</td>"+
			<!--"<td align=\"center\" class=\"text1\" id=\"instancename"+iprows+"\" name=\"instancename"+iprows+"\" onkeypress=\"return avoidSpace(event) || avoidEnter(event)\" onfocus=\"loadInstanceNameIndex('instancename"+iprows+"')\" onfocusout=\"duplicateInstanceNamesExists('instancename"+iprows+"','WiZConff')\" readonly></td>"+-->
			"<td><input type=\"text\" class=\"text\" id=\"instancename"+iprows+"\" name=\"instancename"+iprows+"\" onkeypress=\"return avoidSpace(event) || avoidEnter(event)\" onfocus=\"loadInstanceNameIndex('instancename"+iprows+"')\" onfocusout=\"duplicateInstanceNamesExists('instancename"+iprows+"','WiZConff')\" readonly></td>"+
			"<td><select name=\"exmode\" class=\"text\" id=\"exmode"+iprows+"\"><option value=\"1\">IKEv1-Main</option><option value=\"2\">IKEv1-Aggressive</option><option value=\"3\">IKEv2</option></select></td>"+
			"<td><select name=\"authmode\" class=\"text\" id=\"authmode"+iprows+"\"><option value=\"1\">PSK Client</option><option value=\"2\">PSK Server</option></select></td>"+
			<!--"<td align=\"center\" class=\"text1\" id=\"optlvl"+iprows+"\" name=\"optlvl"+iprows+"\" onkeypress=\"return avoidSpace(event) || avoidEnter(event)\"></td>"+-->
			"<td><input type=\"text\" class=\"text\" id=\"optlvl"+iprows+"\" name=\"optlvl"+iprows+"\" onkeypress=\"return avoidSpace(event) || avoidEnter(event)\" readonly></td>"+
			"<td><label class=\"switch\"><input type=\"checkbox\" id=\"activation"+iprows+"\" name=\"activation"+iprows+"\" checked><span class=\"slider round\"></span></input></label></td>"+
			<!--"<td><input type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" value=\"Edit\" class=\"button1\" align=\"left\" onclick=\"gotoIPSecPage('instancename"+iprows+"')\">"+-->
			"<td><button type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"gotoIPSecPage('instancename"+iprows+"')\">Edit <i class='fas fa-edit' style='font-size:12px;color:white'></i></button>"+
			"<image id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"22\" height=\"22\" align=\"right\" title=\"Delete\" onclick=\"deleteIPSecPage(this,'instancename"+iprows+"');\"></image></td>"+
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


function fillrow(rowid,instancename,activation,exmode,authmode,optlvl)
{
	document.getElementById('instancename'+rowid).value=instancename;
	document.getElementById('activation'+rowid).checked=activation;
	document.getElementById('exmode'+rowid).value=exmode;
	document.getElementById('authmode'+rowid).value=authmode;
	document.getElementById('optlvl'+rowid).value=optlvl;
	
}
function deleteRow(el,id) 
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
}
function reindexTable()
{
	var table = document.getElementById("WiZConff");
	var rowCount = table.rows.length;
	//alert("row count is : "+rowCount);
	for (var i = 1; i < rowCount; i++) 
	{
		var row = table.rows[i];
		row.cells[0].innerHTML = i;
	}
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

function gotoIPSecPage(showinstancename)
{
	//alert("in the function go to ipsec config page");
	var instname = document.getElementById(showinstancename).value;
	location.href = "edit_ipsec.html";
}

function addIPSecPage(showinstancename, addinstance)
{
    	var table = document.getElementById("WiZConff");
	var iprows = table.rows.length;
     if (iprows==6)
	{
		alert("Maximum 5 Entries are allowed");
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
	location.href = "edit_ipsec.html";
}

function deleteIPSecPage(el,id)
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
	location.href = "edit_ipsec.html";
}


