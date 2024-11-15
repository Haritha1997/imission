function showDivision(divname) {
	var divname_arr = ["sim1page", "sim2page", "sim_switch"];
        var list = document.getElementById("simtypediv");
        var childs = list.children;

	for (var i = 0; i < divname_arr.length; i++) {
		if (divname == divname_arr[i]) {
			document.getElementById(divname_arr[i]).style.display = "inline";
			childs[i].children[0].id = "hilightthis";
		} else {
			document.getElementById(divname_arr[i]).style.display = "none";
			childs[i].children[0].id = "";
		}
	}
}

// View SIM1 PPP Password	
$(document).on('click', '.toggle-sim1pwd', function() {
    $(this).toggleClass("fa-eye fa-eye-slash");    
    var input = $("#sim1pwd");
    input.attr('type') === 'password' ? input.attr('type','text') : input.attr('type','password')
});

// View SIM2 PPP Password
$(document).on('click', '.toggle-sim2pwd', function() {
    $(this).toggleClass("fa-eye fa-eye-slash");    
    var input = $("#sim2pwd");
    input.attr('type') === 'password' ? input.attr('type','text') : input.attr('type','password')
});

function Sim1ConnectionType(id) 
{
	/*var cnctntypeobj = document.getElementById(id).value;
	var hideppp = document.getElementById("sim1cnctntype");
	var pppauth = document.getElementById("hidpppsim1auth");
	var dialno = document.getElementById("hidsim1dialno");

	if (cnctntypeobj == 2)
	{
		pppauth.style.display = "none";
		dialno.style.display = "none";
	}
	else 
	{
		pppauth.style.display = "";
	  	dialno.style.display = "";
	}*/
	
}


function Ipversion(id)
{

	var cnctntypeobj = document.getElementById(id);
	var cnctntype = cnctntypeobj.options[cnctntypeobj.selectedIndex].text;
	//var pppauth = document.getElementById("hidpppsim1auth");
	/*var dialno = document.getElementById("hidsim1dialno");
	var hideppp = document.getElementById("sim1cnctntype").value;*/
	//var hide = document.getElementById("simtype");	
	
	//alert("cnctntype===:"+cnctntype);
	if (cnctntype == "IPV6")
	{
		/*pppauth.style.display = "none";
		dialno.style.display = "none";*/
		document.getElementById("ipv4_sel").style.display="none";
		document.getElementById("ipv6_sel").style.display="";

	}
	else if (cnctntype == "Dual")
	{
		/*pppauth.style.display = "none";
		dialno.style.display = "none";*/
		document.getElementById("ipv4_sel").style.display="none";
		document.getElementById("ipv6_sel").style.display="";
		//document.getElementsById("sim1cnctntype").value=2;

	}
	/*else if((cnctntype == "IPV4") && (hideppp == 2))
	{

		document.getElementById("ipv6_sel").style.display="none";
		document.getElementById("ipv4_sel").style.display="";
		pppauth.style.display = "none";
		dialno.style.display = "none";

	}*/
	else
	{
		document.getElementById("ipv6_sel").style.display="none";
		document.getElementById("ipv4_sel").style.display="";
		//document.getElementsById("sim1cnctntype").value=1;
		/*pppauth.style.display = "";
		dialno.style.display = "";*/
	}

}

function Sim2ConnectionType(id) 
{
	/*var cnctntypeobj = document.getElementById(id);
	var cnctntype = cnctntypeobj.options[cnctntypeobj.selectedIndex].text;
	var pppauth = document.getElementById("hidpppsim2auth");
	var dialno = document.getElementById("hidsim2dialno");

	if (cnctntype == "DHCP") 
	{
		pppauth.style.display = "none";
		dialno.style.display = "none";
	} 
	else 
	{
		pppauth.style.display = "";
	  	dialno.style.display = "";
	}*/
}

function Sim2Ipversion(id)
{
	var cnctntypeobj = document.getElementById(id);
	var cnctntype = cnctntypeobj.options[cnctntypeobj.selectedIndex].text;
	/*var pppauth = document.getElementById("hidpppsim2auth");
	var dialno = document.getElementById("hidsim2dialno");*/
	//var hideppp = document.getElementById("sim2cnctntype").value;
	
	if (cnctntype == "IPV6")
	{
		/*pppauth.style.display = "none";
		dialno.style.display = "none";*/
		document.getElementById("sim2ipv4_sel").style.display="none";
		document.getElementById("sim2ipv6_sel").style.display="";
	}
	else if (cnctntype == "Dual")
	{
		/*pppauth.style.display = "none";
		dialno.style.display = "none";*/
		document.getElementById("sim2ipv4_sel").style.display="none";
		document.getElementById("sim2ipv6_sel").style.display="";
	}
	/*else if((cnctntype == "IPV4") && (hideppp == 2))
	{
		document.getElementById("sim2ipv6_sel").style.display="none";
		document.getElementById("sim2ipv4_sel").style.display="";
		pppauth.style.display = "none";
		dialno.style.display = "none";
	}*/
	else
	{
		document.getElementById("sim2ipv6_sel").style.display="none";
		document.getElementById("sim2ipv4_sel").style.display="";
		/*pppauth.style.display = "";
		dialno.style.display = "";*/
	}
}

function adjtabFirstcolumn(tabname, setname)
{
	var table = document.getElementById(tabname);
	var rows = table.rows;
	var index = 14;

	for (var i = index; i < rows.length; i++) {
		if (i == index) {
			rows[i].cells[0].childNodes[0].innerHTML = setname;
		} else {
			rows[i].cells[0].childNodes[0].innerHTML = "";
		}
	}
	if(rows.length == (index+1))
	{		
		rows[index].cells[1].childNodes[0].childNodes[1].style.display="inline";
		rows[index].cells[1].childNodes[0].childNodes[2].style.display="none";
	}
}

//sim1
function deleteSim1DNSRow(rowid)
{
	var ele = document.getElementById("cusdns"+rowid);
	$('table#sim1 tr#cusdns'+rowid).remove();
	
}
function deleteTableSim1DNSRow(row)
{
	deleteSim1DNSRow(row);
	findSim1DNSLastRowAndDisplayRemoveIcon();
	adjtabFirstcolumn('sim1', 'Custom DNS Servers');
}

function addSim1DNSRowAndChangeIcon(rowid)
{
	var table = document.getElementById("sim1");
	if (table.rows.length >= 19)
	{
		alert("Max 5 Entries are allowed");
		return;
	}
	sim1customdns++;
	var remove=document.getElementById("remove"+rowid);
	var add=document.getElementById("add"+rowid);
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline";
	/*new line for mouseClick and Validate both IPV4 and IPV6  on 24/08/22*/ 
	$("#sim1").append("<tr id='cusdns"+sim1customdns+"'><td><div>Custom DNS Servers</div></td><td><div><input type='text' class='text' id='sim1customdns"+sim1customdns+"' name='sim1customdns"+sim1customdns+"' placeholder='EnterIPV4OrIPV6Address' onkeypress='return avoidSpace(event);' style='display:inline block;'  onmouseover=\"setTitle(this)\" onfocusout=\"validatedualIP('sim1customdns"+sim1customdns+"',false,'Custom DNS Server',false)\"></input><i class='fa fa-plus' id='add"+sim1customdns+"' style='font-size:10px; margin-left:5px;color:green;display:inline block;' onclick='addSim1DNSRowAndChangeIcon("+sim1customdns+")'></i><i class='fa fa-close' style='font-size:10px; margin-left:5px; color:red;display:inline;' id='remove"+sim1customdns+"' onclick='deleteTableSim1DNSRow("+sim1customdns+")'></i><input hidden id='row"+sim1customdns+"' value='"+sim1customdns+"'></div></td></tr>");
	document.getElementById("sim1dnsrows").value = sim1customdns;
	adjtabFirstcolumn('sim1', 'Custom DNS Servers');
}

function findSim1DNSLastRowAndDisplayRemoveIcon()
{
	var table = document.getElementById("sim1");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[1].childNodes[0].childNodes[1];
	var removeobj = lastrow.cells[1].childNodes[0].childNodes[2];
	addobj.style.display="inline";
	if(table.rows.length > 15)
		removeobj.style.display="inline";
	else if(table.rows.length == 15)
		removeobj.style.display="none";
}

function fillSim1DNSRow(rowid,dnsserver)
{
	document.getElementById('sim1customdns'+rowid).value=dnsserver;
}

//sim2
function deleteSim2DNSRow(rowid)
{
	var ele = document.getElementById("cusdns1"+rowid);
	$('table#sim2 tr#cusdns1'+rowid).remove();
	
}

function deleteTableSim2DNSRow(row)
{
	deleteSim2DNSRow(row);
	findSim2DNSLastRowAndDisplayRemoveIcon();
	adjtabFirstcolumn('sim2', 'Custom DNS Servers');
}
function addSim2DNSRowAndChangeIcon(rowid)
{
	var table = document.getElementById("sim2");
	if(table.rows.length >=19)
	{
		alert("Max 5 Entries are allowed");
		return;
	}
	sim2customdns++;
	var remove=document.getElementById("remove1"+rowid);
	var add=document.getElementById("add1"+rowid);
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline";
/*new line for mouseClick and Validate both IPV4 and IPV6 */	
$("#sim2").append("<tr id='cusdns1"+sim2customdns+"'><td><div>Custom DNS Servers</div></td><td><div><input type='text' class='text' id='sim2customdns"+sim2customdns+"' name='sim2customdns"+sim2customdns+"' placeholder='EnterIPV4OrIPV6Address' onkeypress='return avoidSpace(event);' style='display:inline block;' onmouseover=\"setTitle(this)\"  onfocusout=\"validatedualIP('sim2customdns"+sim2customdns+"',false,'Custom DNS Server',false)\"></input><i class='fa fa-plus' id='add1"+sim2customdns+"' style='font-size:10px; margin-left:5px;color:green;display:inline block;' onclick='addSim2DNSRowAndChangeIcon("+sim2customdns+")'></i><i class='fa fa-close' style='font-size:10px; margin-left:5px; color:red;display:inline;' id='remove1"+sim2customdns+"' onclick='deleteTableSim2DNSRow("+sim2customdns+")'></i><input hidden id='row"+sim2customdns+"' value='"+sim2customdns+"'></div></td></tr>");
document.getElementById("sim2dnsrows").value = sim2customdns;	
adjtabFirstcolumn('sim2', 'Custom DNS Servers');
}
function findSim2DNSLastRowAndDisplayRemoveIcon()
{
	var table = document.getElementById("sim2");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[1].childNodes[0].childNodes[1];
	var removeobj = lastrow.cells[1].childNodes[0].childNodes[2];
	addobj.style.display="inline";
	if(table.rows.length > 15)
		removeobj.style.display="inline";
	else if(table.rows.length == 15)
		removeobj.style.display="none";
}
function fillSim2DNSRow(rowid,dnsserver1)
{
	document.getElementById('sim2customdns'+rowid).value=dnsserver1;
}
//new function for DNS Both IPV4 and IPV6 address on 24/08/22.......
function validatedualIP(id,checkempty,name,isCIDR)
{
	var valid = validateIPOnly(id,checkempty,name);
	if(!valid)
		valid =  validateIPv6(id,checkempty,name,isCIDR);
	return valid;
}
// new function added to hide the custom dns server
function hideCustomDNSRows(tableid,cdnsid)
{
	var table = document.getElementById(tableid); 
	var obtaindns = document.getElementById(cdnsid);
	for(var i=14;i<table.rows.length;i++)		
		obtaindns.checked?table.rows[i].style.display="none":table.rows[i].style.display="";
}
function setSimShiftOptions()
{
	var sim1status = document.getElementById('sim1actvn');
	var sim2status = document.getElementById('sim2actvn');
	var primesim = document.getElementById('psim');
	var rechkpsim = document.getElementById('recheckmaster');
	var rchktime = document.getElementById('recheckTime');
	//var shiftbtn = document.getElementById('shiftbtn');
	var bwobj = document.getElementById('actid');
	var sqobj = document.getElementById('sqid');
	if(sim1status.checked && sim2status.checked)
	{
		primesim.disabled = false;
		rechkpsim.disabled = false;
		//rechkpsim.checked = true;
		rchktime.disabled = false;
		bwobj.disabled = false;
		sqobj.disabled = false;
		//shiftbtn.disabled = false;
		primesim.style.backgroundColor ='white';
		rechkpsim.style.backgroundColor ='white';
		rchktime.style.backgroundColor ='white';
		if(rchktime.value.trim() == '')
		{
			rchktime.value = 5;
			rchktime.style.outline = "initial";
		}
		
			
	}
	else{
		if(sim1status.checked)
			primesim.value="SIM 1";
		else if(sim2status.checked)
			primesim.value="SIM 2";
			
		primesim.disabled = true;
		rechkpsim.checked = false;
		rechkpsim.disabled = true;
		rchktime.disabled = true;
		bwobj.disabled = true;
		bwobj.checked = false;
		sqobj.disabled = true;
		sqobj.checked = false;
		//shiftbtn.disabled = true;
		primesim.style.backgroundColor ='#D3D3D3';
		rechkpsim.style.backgroundColor ='#D3D3D3';
		rchktime.style.backgroundColor ='#D3D3D3';
		
		if(rchktime.value.trim() == '')
		{
			rchktime.value = 5;
			rchktime.style.outline = "initial";
		}
	}
}
function bandWidth(type){
	var sim = document.getElementById("sim");
	var actid = document.getElementById("actid");
	var daily = document.getElementById("daily");
	var month = document.getElementById("month");
	var limit = document.getElementById("limit");
	var dayused = document.getElementById("dailyused");
	var monused = document.getElementById("monthused");
	var dateofmonth = document.getElementById("dateofmonth");
	var limittype = document.getElementById("limittype");
	if(type == 'daily')
	{
		if(daily.checked)
		{
			limit.style.display="";
			dayused.style.display="";
			monused.style.display="none";
			dateofmonth.style.display="none";
			limittype.innerHTML="Daily Limit(MB)";
			month.checked = false;
		}
	}
	else if(type == 'month')
	{ 
		if(month.checked)
		{		
			limit.style.display="";
			dateofmonth.style.display="";
			dayused.style.display="none";
			monused.style.display="";
			limittype.innerHTML="Monthly Limit(MB)";
			daily.checked = false;
		}
	}
	else if(type == 'bandwidth')
	{
		if(actid.checked)
		{
			if(daily.checked || (!daily.checked && !month.checked))
			{
				daily.checked=true;
				monused.style.display="none";
				limit.style.display="";
				dayused.style.display="";
				monused.style.display="none";
				dateofmonth.style.display="none";
			}
		}
	}
	else{
		dateofmonth.style.display="none";
		monused.style.display="none";
		
		//actid.checked=true;
		//month.checked=false;
		//daily.checked=true;
		
	}

}
//addded new function for validate cellular Data Limit Without Max value
function validateRangeWithoutMax(id, checkempty, name) {
	var rele = document.getElementById(id);
	var val = rele.value;
	var min = Number(rele.min);
	
	if (val.trim() == "") {
		if (checkempty) {
			rele.style.outline =  "thin solid red";
			rele.title = name+" should be integer in the range from "+min;
			return false;
		} else {
			rele.style.outline = "initial";
			rele.title = "";
			return true;
		}
	}

	if (!isNaN(val)) {			
		if (val >= min) {
			rele.style.outline = "initial";
			rele.title = "";
			return true;
		} else {
			rele.style.outline =  "thin solid red";
			rele.title = name+" should be in the range from "+min;
			return false;
		}
	} else {
		rele.style.outline =  "thin solid red";
		rele.title = name+" should be integer in the range from "+min;
		return false;
	}
}
function limitToMaxLength(id)
{
	var obj = document.getElementById(id);
	if(obj.value.length > obj.maxLength)
		obj.value = obj.value.substring(0,obj.maxLength);
}
function simswitchbw()
{
	var badwitid = document.getElementById("actid");
	var sigaquid = document.getElementById("sqid");
	var sigqudiv = document.getElementById("sqdiv");
	var bwdiv = document.getElementById("bandwidthdiv");
	sigqudiv.style.display= "none";
	if(badwitid.checked)
	{
		bwdiv.style.display = "";
		sigqudiv.style.display= "none";
		sigaquid.checked = false;
	}
}
function simswitchsq()
{
	var badwitid = document.getElementById("actid");
	var sigaquid = document.getElementById("sqid");
	var sigqudiv = document.getElementById("sqdiv");
	var bwdiv = document.getElementById("bandwidthdiv");
	if(sigaquid.checked)
	{
		bwdiv.style.display = "none";
		sigqudiv.style.display= "";
		badwitid.checked = false;
	}
}