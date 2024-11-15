$(function(){
	$("#openvpn").click(function(){
		$("#client,#server,#clientpage").show();
	})
	// $("#client").click(function(){
	// 	$("#clientpage").show();
	// })
})
var iprows=1;
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

function isValidAlphaNumberic(id)
{
	var idobj = document.getElementById(id);
	var val = idobj.value;
	var regex=/^([a-zA-Z0-9]+)$/;
	if(val.match(regex))
		{
		idobj.style.outline = "initial";
		return true;
		}
	idobj.style.outline = "thin solid red";
	return false;
}

function addopenvpnpage(showinstancename, addinstance,slnumber,version)
{ 
    var table = document.getElementById("clientconfig");
	var iprows = table.rows.length;
        if (iprows==11)
	{
		alert("Maximum 10 Entries are allowed");
		return false;
	}
	var newnameid=document.getElementById("nwinstance");
	var newinstval="";

	if (addinstance)
	{
		if(duplicateInstanceNamesExists("nwinstance","clientconfig"))
		{
			return false;
		}
		newinstval=newnameid.value;
		
		if (newinstval == "" && addinstance)
		{ 
			alert("New Instance Name should not be empty");
			newnameid.style.outline ="thin solid red";
			return false;
		}
	}
	var dropdown = document.getElementById("clientserver");
    var selectedValue = dropdown.value;
      
	if (selectedValue == "1") {
		var instname = document.getElementById(showinstancename).value;
		//location.href = "client-vpn.html?instancename="+instname;
		location.href = "client-vpn.jsp?name="+encodeURIComponent(instname)+"&slnumber="+slnumber+"&version="+version;
	} else if (selectedValue == "2") {
		var instname = document.getElementById(showinstancename).value;
		//location.href = "point-page.html?instancename="+instname;
		location.href = "pointtopoint.jsp?name="+encodeURIComponent(instname)+"&slnumber="+slnumber+"&version="+version;
	}
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
		if(tablename == "clientconfig")				
		obj.title="Instance Name should not be empty";
	}
	else
	{
		//obj.style.outline="initial";
		obj.title="";
	}
	if(tablename == "clientconfig")
	{
		var displaystr = "Instance Name";
		var ipsectab=document.getElementById("clientconfig");
		var rowsize=ipsectab.rows.length;
		for(var i=1;i<rowsize;i++)
		{
			var lcolind=ipsectab.rows[i].cells.length-1;
			var oriind=ipsectab.rows[i].cells[lcolind].innerHTML;
			var instname=document.getElementById('name'+oriind).value;

			if((id != 'name'+oriind) && instname == name && instname != "")
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

function loadNewinstnameToIPSecInstname(row,tablename)
{       
    var table = document.getElementById("clientconfig");
	var rowcnt = table.rows.length;
    if(tablename=="clientconfig")
	{  
	    var instid="name"+row;
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
	var insttab=document.getElementById("openvpnid");
	var rowsize=insttab.rows.length;
	for(var i=0;i<rowsize;i++)
	{
		var instancename=document.getElementById("nwinstance").value;
		instarr.push(instancename);
	}
	return instarr;
}

function addRow(tablename,addinstance,slnumber,version) 
{
	var title;
	/*if(color == 'green')
		title = "Dis-Connected";
	else if(color == 'red')
		title = "Error-Try-To-Connect";
	else if(color == 'black')
		title = "Connect";*/
	
	var table = document.getElementById(tablename);
	var iprows = table.rows.length;
	var newinstancename=document.getElementById("nwinstance");
	var newinstval="";
	if(addinstance)
	{
	if(duplicateInstanceNamesExists("nwinstance",tablename))
	{
		return;
	}
	newinstval=newinstancename.value;
	}
    if(tablename=="clientconfig")
	{
		if(newinstval == "" && addinstance)
		{ 
			alert("Instance Name should not be empty");
			newinstancename.style.outline ="thin solid red";
			return false;
		}
        if(iprows==11)
		{
			alert("Maximum 10 Entries are allowed");
			return false;
		}
		if(iprows == 1)
		document.getElementById("opvpconf").value = iprows;
		iprows = document.getElementById("opvpconf").value;
		document.getElementById("opvpconf").value = Number(iprows)+1;
		var row = "<tr align=\"center\">"+
			"<td>"+iprows+"</td>"+
			"<td><input type=\"text\" style=\"min-width:120px;max-width:120px;\" class=\"text\" id=\"name"+iprows+"\" name=\"name"+iprows+"\" onkeypress=\"return avoidSpace(event) || avoidEnter(event)\" onmouseover=\"setTitle(this)\" onfocus=\"loadInstanceNameIndex('name"+iprows+"')\" onfocusout=\"duplicateInstanceNamesExists('nwinstance"+iprows+"','clientconfig')\" readonly></td>"+
			"<td><input type=\"text\" style=\"min-width:120px;max-width:120px;\" class=\"text\" id=\"mode"+iprows+"\" name=\"mode"+iprows+"\"readonly></td>"+
			"<td id=\"clientrow"+iprows+"\" name=\"clientrow"+iprows+"\"><select name=\"protocal"+iprows+"\" class=\"text\" id=\"protocal"+iprows+"\"><option value=\"udp\">udp</option><option value=\"tcp\">tcp</option></select></td>"+
			"<td id=\"pointrow"+iprows+"\" name=\"pointrow"+iprows+"\"><select name=\"protocalpoint"+iprows+"\" class=\"text\" id=\"protocalpoint"+iprows+"\"><option value=\"udp\">udp</option></select></td>"+
			"<td><input type=\"text\"  style=\"min-width:120px;max-width:120px;\" name=\"remoteaddress"+iprows+"\" class=\"text\" id=\"remoteaddress"+iprows+"\" placeholder=\"eg: 192.168.1.10\" onfocusout=\"validatenameandip('remoteaddress"+iprows+"',true,'Remote Address',true)\" onkeypress=\"return avoidSpace(event);\"></td>"+
			"<td><input type=\"number\" class=\"text\" id=\"remoteport"+iprows+"\" name=\"remoteport"+iprows+"\" value=\"1194\" min=\"1\" max=\"65535\" placeholder=\"1-65535\" onkeypress=\"return avoidSpace(event);\"></td>"+
			//"<td><label class=\"switch\"><input type=\"checkbox\" id=\"activation"+iprows+"\" name=\"activation"+iprows+"\" checked onclick=\"actlink('name"+iprows+"','activation"+iprows+"','remoteaddress"+iprows+"','remoteport"+iprows+"')\"><span class=\"slider round\"></span></input></label></td>"+
			"<td><label class=\"switch\"><input type=\"checkbox\" id=\"activation"+iprows+"\" name=\"activation"+iprows+"\" checked ><span class=\"slider round\"></span></input></label></td>"+
			//"<td style=\"text-align:center;\" style=\"min-width:20px;\" align=\"center\"><i class=\"fa-solid fas fa-lock-open fa-xl\" id=\'icon"+iprows+"\' style=\"color:black;\" name=\'icon"+iprows+"\' title="+title+" onclick=\"toggleButtons('icon"+iprows+"','name"+iprows+"','activation"+iprows+"','icontext"+iprows+"')\"></i><input type='hidden' id='icontext"+iprows+"' name='icontext"+iprows+"'/></td>"+
			// "<td><label name=\'status"+iprows+"\' style=\"min-width:70px;\" id=\'status"+iprows+"\' readonly>Initial State</label></td>"+
			//"<td><span style=\"min-width:20px;\" onclick=\"goToTrackingPage('name"+iprows+"','activation"+iprows+"','icon"+iprows+"','"+version+"')\"><i class=\"fa-regular fa-file-text fa-2x \"></i></span></td>"+
			"<td><button type=\"button\" id=\"editicon"+iprows+"\" name=\"editicon"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"gotoOPenVpnEditPage('name"+iprows+"','mode"+iprows+"','"+version+"')\">Edit <i class='fas fa-edit' style='font-size:12px;color:white'></i></button>"+
			"<image id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"22\" height=\"22\" align=\"right\"  title=\"Delete\" onclick=\"deleteOpenVpnpage('name"+iprows+"','"+slnumber+"','"+version+"');\"></image></td>"+
			"<td hidden>0</td>"+
			"<td hidden>"+iprows+"</td>"+
			"</tr>";

		$('#clientconfig').append(row);
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


function fillrow(rowid,instancename,mode,protocal,remoteaddress,remoteport,actn)//,iconcol
{
	document.getElementById('name'+rowid).value=instancename;
	document.getElementById('mode'+rowid).value=mode;
	document.getElementById('protocal'+rowid).value=protocal;
	document.getElementById('remoteaddress'+rowid).value=remoteaddress;
	document.getElementById('remoteport'+rowid).value=remoteport;
	document.getElementById("activation"+rowid).checked=actn;
	/*var iconobj = document.getElementById("icon"+rowid);
	var icontextobj = document.getElementById("icontext"+rowid);
	// var statusobj = document.getElementById("status"+rowid);
	if(iconcol == "green")
	{
		iconobj.style.color = "green";
		iconobj.className = "fa-solid fas fa-lock fa-xl";
		icontextobj.value = "1";
		// statusobj.innerHTML = "Success";
	}
	else if(iconcol == "red")
	{
		iconobj.style.color = "red";
		iconobj.className = "fa-solid fas fa-lock fa-xl";
		icontextobj.value = "-1";
		// statusobj.innerHTML = "Error";
	}
	else if(iconcol == "black")
	{
		iconobj.style.color = "black";
		iconobj.className = "fa-solid fas fa-lock-open fa-xl";
		icontextobj.value = "0";
		// statusobj.innerHTML = "Error";
	}*/
}
function gotoOPenVpnEditPage(showinstancename,modeid,version)
{
	var dropdown = document.getElementById(modeid);
    var selectedValue = dropdown.value;
    var slnumber = document.getElementById("slno").value; 
	if (selectedValue == "Client To Server") {
		var instname = document.getElementById(showinstancename).value;
		//location.href = "client-vpn.html?instancename="+instname;
		location.href ="client-vpn.jsp?name="+encodeURIComponent(instname)+"&slnumber="+slnumber+"&version="+version;
	} else if (selectedValue == "Point To Point") {
		var instname = document.getElementById(showinstancename).value;
		//location.href = "point-page.html?instancename="+instname;
		location.href ="pointtopoint.jsp?name="+encodeURIComponent(instname)+"&slnumber="+slnumber+"&version="+version;
	}
}

function reindexTable()
{
	var table = document.getElementById("clientconfig");
	var rowCount = table.rows.length;
	for (var i = 1; i < rowCount; i++) 
	{
		var row = table.rows[i];
		row.cells[0].innerHTML = i;
	}
}

function setTitle(obj)
{
	obj.title = obj.value;
}

function deleteRow(rowid) 
{
    document.getElementById(rowid).remove();
	reindexTable();
}
function deleteOpenVpnpage(id,slnumber)
{
    var instname=document.getElementById(id).value;

	location.href = "savedetails.jsp?slnumber="+slnumber+"&page=openvpn&name="+encodeURIComponent(instname)+"&action=delete";
}
function goToTrackingPage(insnameid,actid,iconid,version)
{
	var iconobj = document.getElementById(iconid);
	var actobj = document.getElementById(actid);
	var slnumber = document.getElementById("slno").value;
	if(actobj.checked == false)
	{
		alert("Activation must be enable And Connection must be Opened");
		return;
	}
	else if(((iconobj.className.includes("fa-solid fa-lock-keyhole-open") && iconobj.style.color =='black')))
	{
		alert("Connection must be Opened");
		return;

	}
	var insname = document.getElementById(insnameid).value;
	//location.href = 'tracking-page.html?insname='+insname;  //'Nomus.cgi?cgi=Logs.cgi&insname'+insname;
	location.href ="vpntracking.jsp?name="+encodeURIComponent(insname)+"&slnumber="+slnumber+"&version="+version;
}



function validateClient() {
    try {
        var table = document.getElementById("clientconfig");
        var rowslen = table.rows;
		// alert(rowslen.length);
        var altmsg = "";

        for (var i = 1; i < rowslen.length; i++) {
			var rmtaddrobj = document.getElementById("remoteaddress" + i);
            var rmtaddr = rmtaddrobj.value.trim();
			var rmtportobj = document.getElementById("remoteport" + i)
            var rmtport = rmtportobj.value.trim();
			var protobj = document.getElementById("protocal" +i);
			var protval = protobj.value.trim(); 
            var valid = validatedualIP('remoteaddress' + i, true, 'Remote Address', true);
            if (!valid) {
                if (rmtaddr == "") {
                    altmsg += "Remote Address " + i + " should not be empty\n";
                } else {
                    altmsg += "Remote Address " + i + " is not valid\n";
                }
            }
			valid = validateRange('remoteport' + i, true, 'Remote Port');
            if (!valid) {
                if (rmtport == "") {
                    altmsg += "Remote port " + i + " should not be empty\n";
                } else {
                    altmsg += "Remote port " + i + " is not valid\n";
                }
            }
            for(var j=i+1;j<rowslen.length; j++)
			{
				var rmtaddrobj_j = rowslen[j].cells[5].childNodes[0];
				var rmtaddr_j = rmtaddrobj_j.value.trim();
				var rmtportobj_j = rowslen[j].cells[6].childNodes[0];
				var rmtport_j = rmtportobj_j.value.trim();
				var protobj_j = rowslen[j].cells[3].childNodes[0];
				var protval_j = protobj_j.value.trim();
				if (rmtaddr == rmtaddr_j && rmtaddr!="" && rmtaddr_j!="" && rmtport == rmtport_j && rmtport!="" && rmtport_j!="" && protval == protval_j && i!=j) {
					if(!altmsg.includes("Row "+i+" and Row "+j+" should not be same"))
					{
						altmsg += "Row "+i+" and Row "+j+" should not be same\n";
						rmtaddrobj.style.outline = "thin solid red";
						rmtportobj.style.outline = "thin solid red";
						protobj.style.outline = "thin solid red";
					}
					else
					{
						rmtaddrobj.style.outline = "initial";
						rmtportobj.style.outline = "initial";
						protobj.style.outline = "initial";
					}
					break;
				} 
			}
        }
        if (altmsg.trim().length == 0) {
            return "";
        } else {
            alert(altmsg);
            return false;
        }
    } catch (e) {
        alert(e);
    }
}

function protocolhide()
{
	var table = document.getElementById('clientconfig');
        var rowslen = table.rows;
        for (var i = 1; i < rowslen.length; i++) {
			var modeid = document.getElementById("mode"+i).value.trim();
			var protoid = document.getElementById("clientrow"+i);
			var pointproto = document.getElementById("pointrow"+i);
			if(modeid == "Point To Point")
			{
				protoid.style.display = "none";
				pointproto.style.display = "";
			}
			else if(modeid == "Client To Server")
			{
				protoid.style.display = "";
				pointproto.style.display = "none";
			}

		}
}
function checknote()
{
	var clienttab = document.getElementById("clientconfig");
	var rowlen = clienttab.rows;
	var tabnote = document.getElementById("tabnote");
	if(rowlen.length > 1)
		tabnote.style.display = "";
	else
		tabnote.style.display = "none";
}
function fillrowlocal(rowid, instancename, mode, protocal, remoteaddress, remoteport, actn){
    document.getElementById('name' + rowid).value = instancename;
    document.getElementById('mode' + rowid).value = mode;
    document.getElementById('protocal' + rowid).value = protocal;
    var remoteAddressElement = document.getElementById('remoteaddress' + rowid);
    remoteAddressElement.value = remoteaddress;
    if (remoteaddress.trim() == "" || remoteaddress.trim() == "Local") {
        remoteAddressElement.setAttribute("readonly", true);
    } 
    document.getElementById('remoteport' + rowid).value = remoteport;
    document.getElementById("activation" + rowid).checked = actn;
    /*var iconobj = document.getElementById("icon" + rowid);

    if (iconcol == "green") {
        iconobj.style.color = "green";
        iconobj.className = "fa-solid fas fa-lock fa-xl";
    } else if (iconcol == "red") {
        iconobj.style.color = "red";
        iconobj.className = "fa-solid fas fa-lock-open fa-xl";
    }*/
}
function actlink(instnameid,actobj1,rmtaddrele1,rmtportele1) {
	var altmsg="";
	var instancename = document.getElementById(instnameid).value;
	var actobj = document.getElementById(actobj1);
	var rmtaddrele = document.getElementById(rmtaddrele1);
	var rmtaddval = rmtaddrele.value.trim();
	var rmtportele = document.getElementById(rmtportele1);
	var rmtportval = rmtportele.value.trim();
	if(actobj.checked)
	{
		var valid = validatedualIP(rmtaddrele.id, true, 'Remote Address', true);
		if(!valid)
		{
			if(rmtaddval == "")
			{
				altmsg += "Remote address should not empty\n";
				rmtaddrele.style.outline = "thin solid red";
				actobj.checked = false;
			}
			else
			{
				altmsg += "Remote Address is not valid\n";
				rmtaddrele.style.outline = "thin solid red";
				actobj.checked = false;
			}
		}
		else
			rmtaddrele.style.outline = "initial";
		
		if(rmtportval == "")
		{
			altmsg += "Remote port  should not empty\n";
			rmtportele.style.outline = "thin solid red";
			actobj.checked = false;
		}
		else
			rmtportele.style.outline = "initial";
		if(valid && rmtportval != "")
			window.location.href = "Nomus.cgi?Activation="+instancename+" ";
	}
	else
		window.location.href = "Nomus.cgi?Activation="+instancename+" ";
	if (altmsg.trim().length == 0) {
		return "";
	} else {
		alert(altmsg);
		return false;
	}
}
