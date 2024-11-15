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
		if(tablename == "wificonfig")				
		obj.title="SSID should not be empty";
	}
	else
	{
		obj.title="";
	}
	if(tablename == "wificonfig")
	{
		var displaystr = "SSID";
		var ipsectab=document.getElementById("wificonfig");
		var rowsize=ipsectab.rows.length;
		for(var i=1;i<rowsize;i++)
		{
			var ssid=ipsectab.rows[i].cells[1].innerHTML;
			if(ssid == name && ssid != "")
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

function addRow(tablename,addinstance,slnumber,version) 
{ 
	var table = document.getElementById(tablename); 
	var iprows = table.rows.length;
	var newssid=document.getElementById("ssid");
	var newinstval="";
	if (tablename == "wificonfig") 
	{ 
     if(newinstval == "" && addinstance)
		{ 
			newssid.style.outline ="thin solid red";
			return false;
		}
	  
		if (iprows>1) 
		{ 
			alert("Maximum 1 row is allowed in WiFi Table"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("wificnt").value = iprows; 
		iprows = document.getElementById("wificnt").value; 
		document.getElementById("wificnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id='wifirows"+iprows+"' >"+
		"<td>"+iprows+"</td>"+
		"<td><input type=\"hidden\" id=\"ss_id"+iprows+"\" name=\"ss_id"+iprows+"\"/><label align=\"center\" class=\"text1\" id=\"lblss_id"+iprows+"\" name=\"lblss_id"+iprows+"\"  onkeypress=\"return avoidSpace(event) || avoidEnter(event)\" onfocus=\"loadInstanceNameIndex('ss_id"+iprows+"')\"></label></td>"+
		"<td><label class=\"switch\"><input type=\"checkbox\" id=\"activation"+iprows+"\" name=\"activation"+iprows+"\" checked><span class=\"slider round\"></span></input></label></td>"+
		"<td><button type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"gotowifieditpage('lblss_id"+iprows+"','"+version+"')\">Edit <i class='fas fa-edit' style='font-size:12px;color:white'></i></button>"+
		"<image id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\30\" height=\"22\" align=\"right\" title=\"Delete\" onclick=\"deleteWifipage('lblss_id"+iprows+"','"+slnumber+"');\"></image></td>"+
		
		"<td hidden>0</td>"+
		"<td hidden>"+iprows+"</td>"+
		"</tr>"; 
		$('#wificonfig').append(row); 
		loadNewSsidToWifiInstname(iprows,tablename);		
	} 
	else
	{
		alert("no add row");
	}
	reindexTable();
	var height = table.rows[1].cells[0].offsetHeight;
	window.scrollBy(0,height);
}

function loadNewSsidToWifiInstname(row,tablename)
{       

    var table = document.getElementById("wificonfig");
	var rowcnt = table.rows.length;
    if(tablename=="wificonfig")
	{  
	    var instid="ss_id"+row;
		var instances=getNewSsid();
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
																
function getNewSsid()
{
	var instarr=[];
	var insttab=document.getElementById("wificonfigid");
	var rowsize=insttab.rows.length;
	for(var i=0;i<rowsize;i++)
	{
		var instancename=document.getElementById("ssid").value;
		instarr.push(instancename);
	}
	return instarr;
}

function fillrow(rowid,ssid,activation)
{
	document.getElementById('ss_id'+rowid).value=ssid;
	document.getElementById('lblss_id'+rowid).innerHTML=ssid;
	document.getElementById('activation'+rowid).checked=activation;
	
}

function gotowifieditpage(showinstancename,version)
{
	var instname = document.getElementById(showinstancename).innerText;
	var slnumber = document.getElementById("slno").value;
	location.href = "edit_wificonfig.jsp?essid="+encodeURIComponent(instname)+"&slnumber="+slnumber+"&version="+version;
}

function reindexTable()
{ 
	var table = document.getElementById("wificonfig"); 
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
		ele.title=name+" should  not be empty";
		return false;
	}
	else
	{
		ele.style.outline="initial";
		ele.title="";
		return true;
	}	
}
function addwifieditpage(showinstancename, addinstance,slnumber,version)
{
    var table = document.getElementById("wificonfig");
	var iprows = table.rows.length;
        if (iprows>1)
	{
		alert("Maximum 1 Entries are allowed");
		return false;
	}
	var newssid=document.getElementById("ssid");
	var newinstval="";

	if (addinstance)
	{
		if(duplicateInstanceNamesExists("ssid","wificonfig"))
		{
			return false;
		}
		newinstval=newssid.value;
		
		if (newinstval == "" && addinstance)
		{ 
			alert("SSID should not be empty");
			newssid.style.outline ="thin solid red";
			return false;
		}
	}
	var instname = document.getElementById(showinstancename).value;
	location.href = "edit_wificonfig.jsp?essid="+encodeURIComponent(instname)+"&slnumber="+slnumber+"&version="+version;
}
function deleteWifipage(id,slnumber)
{
 var instname = document.getElementById(id).innerText;
location.href = "savedetails.jsp?slnumber="+slnumber+"&page=wificonfig&essid="+encodeURIComponent(instname)+"&action=delete";
 
}
function isValidAlphaNumberic(id)
	{
		var idobj = document.getElementById(id);
		var val = idobj.value;
		var regex=/^([a-zA-Z0-9_]+)$/;
		if(val.match(regex))
			{
			idobj.style.outline = "initial";
			return true;
			}
		idobj.style.outline = "thin solid red";
		return false;
	}
	$(document).on('click', '.toggle-key1', function() {
    $(this).toggleClass("fa-eye fa-eye-slash");    
    var input = $("#key1");
    input.attr('type') === 'password' ? input.attr('type','text') : input.attr('type','password')
});
$(document).on('click', '.toggle-key2', function() {
    $(this).toggleClass("fa-eye fa-eye-slash");    
    var input = $("#key2");
    input.attr('type') === 'password' ? input.attr('type','text') : input.attr('type','password')
});
$(document).on('click', '.toggle-key3', function() {
    $(this).toggleClass("fa-eye fa-eye-slash");    
    var input = $("#key3");
    input.attr('type') === 'password' ? input.attr('type','text') : input.attr('type','password')
});
$(document).on('click', '.toggle-key4', function() {
    $(this).toggleClass("fa-eye fa-eye-slash");    
    var input = $("#key4");
    input.attr('type') === 'password' ? input.attr('type','text') : input.attr('type','password')
});
$(document).on('click', '.toggle-key', function() {
    $(this).toggleClass("fa-eye fa-eye-slash");    
    var input = $("#key");
    input.attr('type') === 'password' ? input.attr('type','text') : input.attr('type','password')
});
/*function avoidSpace(event) 
	{
		var k = event ? event.which : window.event.keyCode;
		if (k == 32) 
		{
			alert("space is not allowed");
			return false;
		}
		return true;
	}*/
	function avoidEnter(event) 
	{
		var k = event ? event.which : window.event.keyCode;
		if (k == 13) 
		{
			alert("Enter is not allowed");
			return false;
		}
		return true;
	}