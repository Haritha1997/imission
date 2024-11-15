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

/*function validateIP(id,checkempty,name) 
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
}*/

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
			var instname=document.getElementById('instancename'+oriind).value.trim();
			if((id != 'instancename'+oriind) && instname == name && instname != "")
			{
				alert(displaystr+" "+name+" already exists");
				dupexists= true;
				document.getElementById(id).style.outline="thin solid red";
				//document.getElementById(id).value="";
				break;
			}
		}
	}
	return dupexists;
}

function addRow(tablename,addinstance,slnumber,version) 
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
			alert("Maximum 25 Entries are allowed");
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("portrwcnt").value = iprows; 
		iprows = document.getElementById("portrwcnt").value; 
		document.getElementById("portrwcnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id='portrow"+iprows+"' >"+
		"<td>"+iprows+"</td>"+
		"<td><input type=\"text\" name=\"instancename"+iprows+"\" class=\"text\" id=\"instancename"+iprows+"\" onkeypress=\"return avoidSpace(event) || avoidEnter(event)\"  onmouseover=\"setTitle(this)\" onfocus=\"loadInstanceNameIndex('instancename"+iprows+"')\" onfocusout=\"duplicateInstanceNamesExists('instancename"+iprows+"','WiZConff')\" readonly /</td>"+
		"<td><select name=\"protocol"+iprows+"\" id=\"protocol"+iprows+"\" class=\"text\"><option value=\"tcp\">TCP</option><option value=\"udp\">UDP</option></select></td>"+
		"<td><input type=\"text\" name=\"extport"+iprows+"\" class=\"text\" id=\"extport"+iprows+"\" maxlength=\"11\" min=\"1\" max=\"65535\" onfocusout=\"validatePortRange('extport"+iprows+"','External Port',true)\"></input></td>"+
		"<td><input type=\"text\" name=\"IntIP"+iprows+"\" class=\"text\" id=\"IntIP"+iprows+"\" size=\"15\" maxlength=\"15\" onfocusout=\"validateIPOnly('IntIP"+iprows+"',true,'Internal IP')\"></input></td>"+
		"<td><input type=\"text\" name=\"intport"+iprows+"\" class=\"text\" id=\"intport"+iprows+"\" maxlength=\"11\" min=\"1\" max=\"65535\" onkeypress=\"return avoidSpace(event)\" onfocusout=\"validatePortRange('intport"+iprows+"','Internal Port',true)\"></input></td>"+
		"<td><label class=\"switch\"><input type=\"checkbox\" id=\"activation"+iprows+"\" name=\"activation"+iprows+"\"><span class=\"slider round\"></span></input></label></td>"+
		"<td><button type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"gotoforwardeditpage('instancename"+iprows+"','"+version+"')\">Edit <i class='fas fa-edit' style='font-size:12px;color:white'></i></button>"+
		"<image style=\"cursor:pointer\" id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"22\" height=\"22\" align=\"right\" title=\"Delete\" onclick=\"deleteforwardeditpage('instancename"+iprows+"','"+slnumber+"','"+version+"');\"></image></td>"+

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
	window.scrollBy(0,0);
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

function fillrow(rowid,instancename,protocol,extport,IntIP,intport,activation)
{
	document.getElementById('instancename'+rowid).value=instancename;
	document.getElementById('protocol'+rowid).value=protocol;
	document.getElementById('extport'+rowid).value=extport;
	document.getElementById('IntIP'+rowid).value=IntIP;
	document.getElementById('intport'+rowid).value=intport;
	document.getElementById('activation'+rowid).checked=activation;
}

function gotoforwardeditpage(showinstancename,version)
{
	var instname = document.getElementById(showinstancename).value;
	var slnumber = document.getElementById("slno").value;
	location.href = "edit_portforward.jsp?instancename="+encodeURIComponent(instname)+"&slnumber="+slnumber+"&version="+version;
}
/*function gotoPortForward(showinstancename)
{
	var instname = document.getElementById(showinstancename).innerHTML;
	var slnumber = document.getElementById("slno").value;
	location.href = "portforward.jsp?instancename="+instname+"&slnumber="+slnumber;
}*/

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
		if(!isNumber(val))
		{
			rele.style.outline =  "thin solid red";
			rele.title = name+" should be integer in the range from "+min+" to "+max;
			valid = false;
			return false;
		}
		return true;
}

function addforwardeditpage(showinstancename, addinstance,slnumber,version)
{
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
	}

	var instname = document.getElementById(showinstancename).value;
	
	location.href = "edit_portforward.jsp?instancename="+encodeURIComponent(instname)+"&slnumber="+slnumber+"&version="+version;
}

function deleteforwardeditpage(id,slnumber,version)
{
    	var inst=document.getElementById(id).value.trim();
		location.href = "savedetails.jsp?slnumber="+slnumber+"&page=portforward&instancename="+encodeURIComponent(inst)+"&version="+version+"&action=delete";
}


function validateIPOrNetworkPortAndTraffic(id, checkempty, name)
{
	var valid = validateIPOrNetwork(id, checkempty, name);
	var ipval=document.getElementById(id); 
	var value=ipval.value;
	if(valid)
	{	
		if (value == "255.255.255.255" || value=="0.0.0.0") 
		{ 
			ipval.style.outline = "thin solid red"; 
			ipval.title = "Invalid " + name; 
			return false; 
		} 
		else 
		{ 
			ipval.style.outline = "initial"; ipval.title = ""; 
			return true; 
		}
	}
	else
	{
		ipval.style.outline = "thin solid red"; 
		ipval.title = "Invalid " + name; 
		return false; 
	}
	
}