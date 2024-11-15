var iprows=1;
var slnumber;
/*function avoidSpace(event) 
{
	var k = event ? event.which : window.event.keyCode;
	if (k == 32) 
	{
		alert("Space is not allowed");
		return false;
	}
}*/
		
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
		obj.title="Username should not be empty";
	}
	else
	{
		obj.title="";
	}

	if(tablename == "WiZConff")
	{
		var displaystr = "Username";
		var ipsectab=document.getElementById("WiZConff");
		var rowsize=ipsectab.rows.length;
		for(var i=1;i<rowsize;i++)
		{
			var lcolind=ipsectab.rows[i].cells.length-1;
			var oriind=ipsectab.rows[i].cells[lcolind].innerHTML;
			var instname=document.getElementById('username'+oriind).value;

			if((id != 'username'+oriind) && instname == name && instname != "")
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
function setslnumber(slnum)
{
	slnumber = slnum;
}
function addRow(tablename,addinstance,slnumber) 
{ 
	var table = document.getElementById(tablename); 
	var iprows = table.rows.length;
	var newinstancename=document.getElementById("nwusername");
	var newinstval="";
	if(addinstance)
	{
		if(duplicateInstanceNamesExists("nwusername",tablename))
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
			alert("Username should not be empty");
			newinstancename.style.outline ="thin solid red";
			return false;
		}
		if (iprows == 6) 
		{ 
			alert("Maximum 5 Entries are allowed"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("pwdrwcnt").value = iprows; 
		iprows = document.getElementById("pwdrwcnt").value; 
		document.getElementById("pwdrwcnt").value = Number(iprows)+1;

		var row = "<tr align=\"center\">"+
		"<td>"+iprows+"</td>"+
		<!--"<td align=\"center\" class=\"text\" id=\"username"+iprows+"\" name=\"username"+iprows+"\" onkeypress=\"return avoidSpace(event) || avoidEnter(event)\" onfocus=\"loadInstanceNameIndex('username"+iprows+"')\" onfocusout=\"duplicateInstanceNamesExists('username"+iprows+"','WiZConff')\" readonly></td>"+-->
		"<td><input type=\"text\" class=\"text\" id=\"username"+iprows+"\" name=\"username"+iprows+"\" onkeypress=\"return avoidSpace(event) || avoidEnter(event)\" onfocus=\"loadInstanceNameIndex('username"+iprows+"')\" onfocusout=\"duplicateInstanceNamesExists('username"+iprows+"','WiZConff')\" readonly></td>"+

		<!--"<td><input type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" value=\"Edit\" class=\"button1\" align=\"left\" onclick=\"gotopwdeditpage('username"+iprows+"')\">"+-->
		"<td><button type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"gotopwdeditpage('username"+iprows+"')\">Edit <i class='fas fa-edit' style='font-size:12px;color:white'></i></button>"+
		"<image id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"22\" height=\"22\" align=\"right\" title=\"Delete\" onclick=\"deleteUsrRow('WiZConff','username"+iprows+"','"+slnumber+"');\"></image></td>"+
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
	window.scrollBy(0,0);
}

function loadNewinstnameToIPSecInstname(row,tablename)
{       
    var table = document.getElementById("WiZConff");
	var rowcnt = table.rows.length;
    if(tablename=="WiZConff")
	{  
	    var instid="username"+row;
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
		var instancename=document.getElementById("nwusername").value;
		instarr.push(instancename);
	}
	return instarr;
}

function fillrow(rowid, username)
{
	document.getElementById('username'+rowid).value=username;
}

function gotopwdeditpage(showusername)
{
	var username = document.getElementById(showusername).value;
	//var slnumber = document.getElementById("slno").value;
	location.href = "edit_password.jsp?slnumber="+slnumber+"&username="+encodeURIComponent(username)+"&action=edituser";
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

function addPasswordPage(showinstancename, addinstance)
{
    var table = document.getElementById("WiZConff");
	var iprows = table.rows.length;
     if (iprows==6)
	{
		alert("Maximum 5 Entries are allowed");
		return false;
	}

	var newinstancename=document.getElementById("nwusername");
	var newinstval="";

	if (addinstance)
	{
		if(duplicateInstanceNamesExists("nwusername","WiZConff"))
		{
			return false;
		}
		newinstval=newinstancename.value;
		
		if (newinstval == "" && addinstance)
		{ 
			alert("Username should not be empty");
			newinstancename.style.outline ="thin solid red";
			return false;
		}
		else if(newinstval == "root")
		{
			alert("You cannot add root user");
			newinstancename.style.outline ="thin solid red";
			return false;
		}

		//alert("New instant value is : '"+newinstval+"'");
	}

	var instname = document.getElementById(showinstancename).value;
	if(addinstance)
		action="adduser";
	else
		action="edituser";	
	location.href = "edit_password.jsp?slnumber="+slnumber+"&username="+encodeURIComponent(instname)+"&action="+action;
}

function deleteUsrRow(tableid,usrid,slnumber)
{	
	var table = document.getElementById(tableid);
	var rows = table.rows;
	if(rows.length == 2)
		alert("There is only one user... Please don't delete the user");
	else
	{
		var username = document.getElementById(usrid).value;
		location.href = "savedetails.jsp?page=password&slnumber="+slnumber+"&username="+encodeURIComponent(username)+"&action=delete";
	}
	
}



