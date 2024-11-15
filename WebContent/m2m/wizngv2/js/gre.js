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
		//alert(altmsg);
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
		if(tablename == "GREtab1")				
		obj.title="Instance Name should not be empty";
	}
	else
	{
		obj.title="";
	}
	if(tablename == "GREtab1")
	{
		var displaystr = "Instance Name";
		var ipsectab=document.getElementById("GREtab1");
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
	if (tablename == "GREtab1") 
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
		var rowcnt=document.getElementById("grerwcnt").value;
		rowcnt= iprows; 
		iprows = rowcnt; 
		rowcnt = Number(iprows)+1;
		var row = "<tr align=\"center\" id='portrow"+iprows+"' >"+
		"<td>"+iprows+"</td>"+
		"<td><input type=\"text\" align=\"center\" class=\"text\" id=\"instancename"+iprows+"\" name=\"instancename"+iprows+"\" onkeypress=\"return avoidSpace(event) || avoidEnter(event)\" onfocus=\"loadInstanceNameIndex('instancename"+iprows+"')\" onfocusout=\"duplicateInstanceNamesExists('instancename"+iprows+"','GREtab1')\" readonly></td>"+
		// "<td><input type=\"text\" align=\"center\" class=\"text\" id=\"protocol"+iprows+"\" name=\"protocol"+iprows+"\"  value=\"GRE\" onkeypress=\"return avoidSpace(event) || avoidEnter(event)\"   readonly></td>"+
		"<td><label class=\"switch\"><input type=\"checkbox\" id=\"activation"+iprows+"\" name=\"activation"+iprows+"\"><span class=\"slider round\"></span></input></label></td>"+
		"<td><span id=\"circle"+iprows+"\" name=\"circle"+iprows+"\"></span></td>"+
		//"<td><input type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" value=\"Edit\" class=\"button1\" align=\"left\" onclick=\"editgrepage('instancename"+iprows+"')\">"
		"<td><button type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"editgrepage('instancename"+iprows+"','"+version+"')\">Edit <i class='fas fa-edit' style='font-size:12px;color:white'></i></button>"+
		"<image style=\"cursor:pointer\" id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"\images/delete.png\" width=\"22\" height=\"22\" align=\"right\" title=\"Delete\" onclick=\"deletegrepage('instancename"+iprows+"','"+slnumber+"','"+iprows+"','"+tablename+"');\"></image></td>"+

		"<td hidden>0</td>"+
		"<td hidden>"+iprows+"</td>"+
		"</tr>"; 
		document.getElementById("grerwcnt").value=iprows;
		$('#GREtab1').append(row);  
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
    var table = document.getElementById("GREtab1");
	var rowcnt = table.rows.length;
    if(tablename=="GREtab1")
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
	var insttab=document.getElementById("GREtab2");
	var rowsize=insttab.rows.length;
	for(var i=0;i<rowsize;i++)
	{
		var instancename=document.getElementById("nwinstname").value;
		instarr.push(instancename);
	}
	return instarr;
}

function fillrow(rowid,instancename, activation, status)
{
	document.getElementById('instancename'+rowid).value=instancename;
	document.getElementById('activation'+rowid).checked=activation;
	if(status == "1")
		document.getElementById('circle'+rowid).className = "bg-Up circle";
	else if(status == '0')
		document.getElementById('circle'+rowid).className = "bg-Down circle";
	else
		document.getElementById('circle'+rowid).className = "bg-Disabled circle";
}

function editgrepage(showinstancename,version)
{
	var instname = document.getElementById(showinstancename).value;
	var slnumber = document.getElementById("slno").value;
	var table = document.getElementById("GREtab1");
	var rows = table.rows.length;
	//location.href = "newedit_gre.html";
	location.href = "edit_gre.jsp?grename="+encodeURIComponent(instname)+"&slnumber="+slnumber+"&version="+version+"&rows="+rows;
}

function reindexTable()
{ 
	var table = document.getElementById("GREtab1"); 
	var rowCount = table.rows.length;
	for (var i = 1; i < rowCount; i++) 
	{ 
		var row = table.rows[i]; 
		row.cells[0].innerHTML = i; 
	} 
}

function deleteRow(rowid) 
{
	// var ele = document.getElementById("routesetiprow"+rowid);
	// $('table#routesetting1 tr#routesetiprow'+rowid).remove();
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

function addgrepage(showinstancename, addinstance,slnumber,version)
{
    var table = document.getElementById("GREtab1");
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
		if(duplicateInstanceNamesExists("nwinstname","GREtab1"))
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
	var rows=iprows++;
	//location.href = "newedit_gre.html?InstanceName="+encodeURIComponent(instname);
	location.href = "edit_gre.jsp?grename="+encodeURIComponent(instname)+"&slnumber="+slnumber+"&version="+version+"&rows="+rows;
}

/*function deleteforwardeditpage(el, id)
{
    	// var instname=document.getElementById(id).value;
	// var instance=document.getElementById(id).value;
	while (el.parentNode && el.tagName.toLowerCase() != 'tr') 
	 {
		el = el.parentNode;
	}
	if (el.parentNode && el.parentNode.rows.length > 1) 
	{
		el.parentNode.removeChild(el);
	}
	reindexTable();

}*/
function validateRange(id,chkempty,name)
{
	
	var obj = document.getElementById(id);
	var val = obj.value;
	var min = obj.min;
	var max = obj.max;
	//alert("val : "+val+" min : "+min+" max : "+max);
	if(chkempty && val.trim().length == 0)
		return false;		
	if((parseInt(val) < min) || (parseInt(val) > max))
	{
		return false;
	}
	return true;
}

//Modified by Venkatesh - 11/01/2024 - Start

function validateGre() {
    
    var enabled = document.getElementById("enable");

    const netwarrobj = [];
    const ipv4netw = [];
    const ipv4netm = [];
    const indarr = [];
    var curnetwork = "";
    var curbdcast = "";
    var alertmsg = "";
    var rmtendaccess = document.getElementById("rem_ipaddress");
    var mtu = document.getElementById("mtu");
    var ttl = document.getElementById("ttl");
    var lclipaddress = document.getElementById("lcl_ipaddress");
    var lclsubnet = document.getElementById("lcl_netmask");

    var tunlsrcobj = document.getElementById("tunnelsrcsel");
    var tunlsrc = tunlsrcobj.options[tunlsrcobj.selectedIndex].text;
    var tunltextobj = document.getElementById("tunlsrc");

    var keep_alive = document.getElementById("keep_alive");
    var keepintrval = document.getElementById("keep_alive_interval");
    var keepretries = document.getElementById("keep_alive_retries");

	var ipv4gtway = document.getElementById("gateway");
	
	var metric = document.getElementById("metric");

    var valid = validatenameandip("tunlsrc", true, "Tunnel Source");
    if (tunlsrc == "Custom") {
        if(!valid) {
            if (tunltextobj.value.trim() == "") {
                alertmsg += "Tunnel Source should not be empty\n";
            }
            else {
                alertmsg += "Tunnel Source is not valid\n";
            }
        }
    }

    valid = validateIPOnly("rem_ipaddress", true, "Remote End Point IPAddress");
    if (!valid) {
        if (rmtendaccess.value.trim() == "")
            alertmsg += "Remote End Point IPAddress should not be empty\n";
        else
            alertmsg += "Remote End Point IPAddress is not valid\n";
    }

    if (keep_alive.checked) {
        valid = validateRange("keep_alive_interval", true, "Keep Alive Interval");
        if (!valid) {
            if (keepintrval.value.trim() == "")
                alertmsg += "Keep Alive Interval should not be empty\n";
            else
                alertmsg += "Keep Alive Interval is not valid\n";
        }

        validretries = validateRange("keep_alive_retries", true, "Keep Alive Retries");
        if (!validretries) {
            if (keepretries.value.trim() == "")
                alertmsg += "Keep Alive Retries should not be empty\n";
            else
                alertmsg += "Keep Alive Retries is not valid\n";
        }
    } else {
        keepintrval.style.outline = "Initial";
        keepretries.style.outline = "initial";
    }

    valid = validateIP("lcl_ipaddress", true, "Tunnel IPv4 Addresss");
    var ipvalid = valid;
    if (!valid) {
        if (lclipaddress.value.trim() == "")
            alertmsg += "Tunnel IPv4 IPAddresss should not be empty\n";
        else
            alertmsg += "Tunnel IPv4 IPAddresss is not valid\n";
    }

    valid = validateSubnetMask("lcl_netmask", true, "Tunnel IPv4 Netmask");
    var subnetvalid = valid;
    if (!valid) {
        if (lclsubnet.value.trim() == "")
            alertmsg += "Tunnel IPv4 Netmask should not be empty\n";
        else
            alertmsg += "Tunnel IPv4 Netmask is not valid\n";
    }

    if(ipvalid && subnetvalid){
        var tunnetwork = getNetwork(lclipaddress.value, lclsubnet.value);
		var broadcast = getBroadcast(tunnetwork,lclsubnet.value);

        if(lclipaddress.value == tunnetwork){
            alertmsg += "Tunnel IPv4 Address should not be Network\n";
			lclipaddress.style.outline = "thin solid red";
        }

        if(lclipaddress.value == broadcast){
            alertmsg += "Tunnel IPv4 Addresss should not be Broadcast\n";
			lclipaddress.style.outline = "thin solid red";
        }
    }

    var rouset1table = document.getElementById("routesetting1");
    var rouset1rows = rouset1table.rows;

    try {
        for (var i = 1; i < rouset1rows.length; i++) {
            var cols = rouset1rows[i].cells;
            var network = cols[1].childNodes[0].childNodes[0];
            var netmask = cols[1].childNodes[2].childNodes[0];

            valid = validateIP(network.id, true, "Target IPv4 Network");
            var networkvalid = valid;
            if (!valid) {
                alertmsg += (i - 0);
                if (i == 1) alertmsg += "st";
                else if (i == 2) alertmsg += "nd";
                else if (i == 3) alertmsg += "rd";
                else alertmsg += "th";

                if (network.value.trim() == "")
                    alertmsg += " Target IPv4 Network should not be empty\n";
                else
                    alertmsg += "Target IPv4 Network is not valid\n";
            }
            valid = validateSubnetMask(netmask.id, true, "Target IPv4 Netmask");
            var netmaskvalid = valid;
            if (!valid) {
                alertmsg += (i - 0);
                if (i == 1) alertmsg += "st";
                else if (i == 2) alertmsg += "nd";
                else if (i == 3) alertmsg += "rd";
                else alertmsg += "th";
                if (netmask.value.trim() == "") alertmsg += " Target IPv4 Netmask should not be empty\n";
                else alertmsg += " Target IPv4 Netmask is not valid\n";
            }
            valid = false;
            if (networkvalid && netmaskvalid) {
                var networkch = getNetwork(network.value, netmask.value);
                var broadcastch = getBroadcast(networkch, netmask.value);
                if (network.value == networkch) {
                    valid = true;
                    ipv4netw.push(networkch);
                    ipv4netm.push(broadcastch);
                    curnetwork = networkch;
                    curbdcast = broadcastch;
                    netwarrobj.push(network);
                    indarr.push(i);
                } 
                else {
                    if(network.value.trim() == "")
                        continue;
                    else{
                        alertmsg += (i - 0);
                        if (i == 1) alertmsg += "st";
                        else if (i == 2) alertmsg += "nd";
                        else if (i == 3) alertmsg += "rd";
                        else alertmsg += "th";
                        alertmsg += " Target IPV4 should be Network\n"
                        network.style.outline = "thin solid red";
                    }
                }
            }
            if (valid == true) {
                for (var l = 0; l < netwarrobj.length; l++) {
                    var network1 = ipv4netw[l];
                    var broadcast1 = ipv4netm[l];
                    if (((isGraterOrEquals(curnetwork, network1) && !isGraterOrEquals(curnetwork, broadcast1)) || (isGraterOrEquals(network1, curnetwork) && !isGraterOrEquals(network1, curbdcast))) && (i != indarr[l])) {
                        alertmsg += "In Routing settings " + network.value + " overlaps with " + netwarrobj[l].value + ".\n";
                        network.style.outline = "thin solid red";
                        netwarrobj[l].style.outline = "thin solid red";
                        network.title = "overlaps with " + netwarrobj[l].value;
                        netwarrobj[l].title = "overlaps with " + network.value;
                        break;
                    }
                }
            }
        }

		valid = validateIPOnly("gateway", true, "IPV4 Gateway");
		if (!valid) {
			if (ipv4gtway.value.trim() == "")
				alertmsg += "IPV4 Gateway should not be empty\n";
			else
				alertmsg += "IPV4 Gateway is not valid\n";
		}
		/*
		valid = validateRange("metric", true, "Metric");
		if (!valid) {
			if (metric.value.trim() == "")
				alertmsg += "Metric should not be empty\n";
			else
				alertmsg += "Metric is not valid\n";
		}*/
		

        if (alertmsg.trim().length == 0) return true;
        else {
            alert(alertmsg);
            return false;
        }
    } catch (e) {
        alert(e);
    }
}
//Modified by Venkatesh - 11/01/2024 - End

//Added by Venkatesh - 11/01/2024 - Start
function adjtabNetworkandNetmaskFirstcolumn(tabname, setNetwork, setNetmask){
	var table = document.getElementById(tabname);
	var rows = table.rows;
	var index = 0;
	if(tabname == "routesetting1")
		index = 1;
	for(var i=index; i<rows.length; i++)
	{
		if(i==index)
		{
			rows[i].cells[0].childNodes[0].innerHTML = setNetwork;
			rows[i].cells[0].childNodes[2].innerHTML = setNetmask;
		}
		else
		{
			rows[i].cells[0].childNodes[0].innerHTML = "";
			rows[i].cells[0].childNodes[2].innerHTML = "";
		}
	}
}

function addIPRowAndChangeIcon(rowid)
{
	var table = document.getElementById("routesetting1");
	if(table.rows.length >=6)
	{
		alert("Max 5 Entries are allowed");
		return;
	}
	tarrows++;
	var remove=document.getElementById("remove"+rowid);
	var add=document.getElementById("add"+rowid);

	if(add != null)
	  add.style.display="none";
	
	if(remove != null)
	  remove.style.display ="inline";

	if(tarrows == 2)
		$("#routesetting1").append("<tr id='routesetiprow"+tarrows+"'><td><div>Target IPv4 Network</div><br/><div>Target IPv4 Netmask</div></td><td><div><input type='text' class='text' id='rem_subnet_ipaddress"+tarrows+"' name='rem_subnet_ipaddress"+tarrows+"' onkeypress='return avoidSpace(event)' style='display:inline block;' onfocusout=\"validateIP('rem_subnet_ipaddress"+tarrows+"',true,'Target IPv4 Network')\"></input></div><div style='margin-left:155px'><i class='fa fa-plus' id='add"+tarrows+"' style='font-size:10px; margin-left:5px;color:green;display:inline block' onclick='addIPRowAndChangeIcon("+tarrows+")'></i><i class='fa fa-close' style='display:none;font-size:10px; margin-left:5px; color:red;' id='remove"+tarrows+"' onclick='deletetableRow("+tarrows+")'></i></div><div><input type='text' class='text' id='rem_subnet_netmask"+tarrows+"' name='rem_subnet_netmask"+tarrows+"' onkeypress='return avoidSpace(event)' style='display:inline block' onfocusout=\"validateSubnetMask('rem_subnet_netmask"+tarrows+"',true,'Target IPv4 Netmask')\"></input><input hidden id='row"+tarrows+"' value='"+tarrows+"'></div></td></tr>");
	else
		$("#routesetting1").append("<tr id='routesetiprow"+tarrows+"'><td><div>Target IPv4 Network</div><br/><div>Target IPv4 Netmask</div></td><td><div><input type='text' class='text' id='rem_subnet_ipaddress"+tarrows+"' name='rem_subnet_ipaddress"+tarrows+"' onkeypress='return avoidSpace(event)' style='display:inline block;' onfocusout=\"validateIP('rem_subnet_ipaddress"+tarrows+"',true,'Target IPv4 Network')\"></input></div><div style='margin-left:155px'><i class='fa fa-plus' id='add"+tarrows+"' style='font-size:10px; margin-left:5px;color:green;display:inline block' onclick='addIPRowAndChangeIcon("+tarrows+")'></i><i class='fa fa-close' style='display:inline;font-size:10px; margin-left:5px; color:red;' id='remove"+tarrows+"' onclick='deletetableRow("+tarrows+")'></i></div><div><input type='text' class='text' id='rem_subnet_netmask"+tarrows+"' name='rem_subnet_netmask"+tarrows+"' onkeypress='return avoidSpace(event)' style='display:inline block' onfocusout=\"validateSubnetMask('rem_subnet_netmask"+tarrows+"',true,'Target IPv4 Netmask')\"></input><input hidden id='row"+iprows+"' value='"+tarrows+"'></div></td></tr>");

	document.getElementById("tarrows").value =tarrows;
	adjtabNetworkandNetmaskFirstcolumn('routesetting1','Target IPv4 Network','Target IPv4 Netmask');
}	

function deletetableRow(row)
{
	deleteRowRouteSettings(row);
	findLastRowAndDisplayRemoveIcon();
	adjtabNetworkandNetmaskFirstcolumn('routesetting1','Target IPv4 Network','Target IPv4 Netmask');
}

function deleteRowRouteSettings(rowid) 
{
	var ele = document.getElementById("routesetiprow"+rowid);
	$('table#routesetting1 tr#routesetiprow'+rowid).remove();
    // document.getElementById(rowid).remove();
	// reindexTable();
}

function findLastRowAndDisplayRemoveIcon()
{
	var table = document.getElementById("routesetting1");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[1].childNodes[1].childNodes[0];
	var removeobj = lastrow.cells[1].childNodes[1].childNodes[1];

	if(table.rows.length > 2){
		addobj.style.display="inline";
		removeobj.style.display="inline";
	}
	else if(table.rows.length == 2){
		addobj.style.display="inline";
		removeobj.style.display="none";
	}
}

function fillIProw(rowid,network,netmask)
{
	document.getElementById('rem_subnet_ipaddress'+rowid).value=network;
	document.getElementById('rem_subnet_netmask'+rowid).value=netmask;
}

function gotogre(slnumber,version){
	//location.href = "gre.jsp";
	location.href = "gre.jsp?slnumber="+slnumber+"&version="+version;
}

function selectGRECustom(id){
    var protoselobj = document.getElementById(id);
    var protoval = protoselobj.options[protoselobj.selectedIndex].text;
    if(protoval == "Custom"){
        protoselobj.style.display = "none";
        var tunlsrctxtobj = document.getElementById("tunlsrc");
        tunlsrctxtobj.style.display = "inline";
        tunlsrctxtobj.focus();
    }
}

function validOnshowGREComboBox(id, name){
    if (validatenameandip(id, false, name)) showGREComboBox(id);
}

function showGREComboBox(id){
    var tunlsrctxtobj = document.getElementById(id);
    var protoselobj = document.getElementById("tunnelsrcsel");
    if(protoselobj.length == 6)
        protoselobj.remove(0);
    if(tunlsrctxtobj.value.trim() != ""){
        var newOption = document.createElement('option');
        newOption.value = tunlsrctxtobj.value.trim();
        newOption.innerHTML = tunlsrctxtobj.value.trim();
        protoselobj.add(newOption, 0);
    }
    tunlsrctxtobj.style.display = "none";
    protoselobj.style.display = "inline";   
    protoselobj.selectedIndex = 0;
}
//Added by Venkatesh - 11/01/2024 - End
function deletegrepage(id,slnumber,row,tablename)
{
 var instname = document.getElementById(id).value;
 var table = document.getElementById(tablename); 
 var rowcnt = table.rows.length;
 location.href = "savedetails.jsp?slnumber="+slnumber+"&page=gre&grename="+encodeURIComponent(instname)+"&action=delete"+"&row="+row+"&rowcnt="+rowcnt;
 
}