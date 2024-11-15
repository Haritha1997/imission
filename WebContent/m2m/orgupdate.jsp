<%@page import="java.util.zip.ZipEntry"%>
<%@page import="java.util.zip.ZipFile"%>
<%@page import="java.nio.file.StandardCopyOption"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.IOException"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.*"%>
<%@page import="javax.servlet.MultipartConfigElement"%>
<%@page import="javax.servlet.ServletException"%>
<%@page import="javax.servlet.annotation.WebServlet"%>
<%@page import="javax.servlet.http.HttpServlet"%>
<%@page import="javax.servlet.http.HttpServletRequest"%>
<%@page import="javax.servlet.http.HttpServletResponse"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="javax.servlet.http.Part"%>
<jsp:include page="/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="M2M" />
	<jsp:param name="headTitle" value="M2M" />
	<jsp:param name="limenu" value="Configuration" />
	<jsp:param name="lisubmenu" value="Organization Update" />
</jsp:include>
<%
boolean loopback = false;
boolean eth0ip = false;
boolean eth1ip = false;
boolean sysname = false;
boolean location = false;
boolean valid_file = true;
int options_cnt = 0;
int cnt = 0;
String statusstr = null;
Vector<Vector<String>> orgupdatevec = null;
String options[] = null;
String filename = null;
HttpSession httpsession = request.getSession();
if (httpsession.getAttribute("status") != null) {
	statusstr = httpsession.getAttribute("status").toString();
	httpsession.removeAttribute("status");
}
if (httpsession.getAttribute("orgupdatevec") != null) {
	orgupdatevec = (Vector<Vector<String>>) httpsession.getAttribute("orgupdatevec");
	httpsession.removeAttribute("orgupdatevec");
}
if (httpsession.getAttribute("options") != null) {
	options = (String[]) httpsession.getAttribute("options");
	httpsession.removeAttribute("options");
}
if (httpsession.getAttribute("orgupdatefile") != null) {
	filename = httpsession.getAttribute("orgupdatefile").toString();
	httpsession.removeAttribute("orgupdatefile");
}
%>
<head>
<script type="text/javascript" src="/imission/m2m/wizngv2/js/common.js"></script>
<style>
input[type="file"] {
	color: transparent;
}

body {
	background-color: white;
	font: 12px "Open Sans", Arial, sans-serif;
}

#bold {
	vertical-align: middle;
	margin-bottom: 5px;
	font-weight: bold;
}

p {
	padding: 0px 0px 0px 0px;
	margin: 0px 0px 0px 0px;
}

#tab td {
	padding: 1px;
	vertical-align: middle;
}

#tab th {
	max-width: 12%;
	margin: 0px;
	padding: 4px 0px 4px 0px;
}

#tab td input {
	max-width: 120px;
	align: middle;
}

input[type="checkbox"] {
	margin: 0px;
	padding: 0px;
	max-width: 20px;
	display: inline;
	vertical-align: middle;
}

input[type="file"] {
	display: none;
}

#tab td img {
	vertical-align: middle;
	width: 15px;
	height: 15px;
}

div.sticky {
	position: -webkit-sticky;
	position: sticky;
	top: 0;
}

#noanchordefalut {
	color: black;
}
</style>
<script type="text/javascript">
var loopback_opt=false;
var eth0_opt=false;
var eth1_opt=false;
function setTitle(obj)
{
	obj.title = obj.value;
}
function submitFile()
{
	const form = document.getElementById("form");
	form.method = "post";
	var selfile = document.getElementById("orgupdatefile").value.toLowerCase();
	if(!selfile.endsWith(".xls") && !selfile.endsWith(".xlsx"))
	{
		alert("Please select excel file\n");
		return false;
	}
	else
	{
		form.action = "OrganizationUpdateFileLoder";
		form.submit();
	}
}
function setSelectedOptions(lb,e0_opt,e1_opt)
{
	loopback_opt = lb;
	eth0_opt = e0_opt;
	eth1_opt = e1_opt;
}
function doSelectAll()
{
	var isall = document.getElementById("all").checked;
	if(isall)
	{
		document.getElementById("LoopbckIP").checked = true;
		document.getElementById("Eth0IP").checked = true;
		eth0_opt= true;
		loopback_opt = true;
		//document.getElementById("Eth1IP").checked = true;
		document.getElementById("Systemname").checked = true;
		document.getElementById("Location").checked = true;
	}
	else
	{
		document.getElementById("LoopbckIP").checked = false;
		document.getElementById("Eth0IP").checked = false;
		eth0_opt= false;
		loopback_opt = false;
		//document.getElementById("Eth1IP").checked = false;
		document.getElementById("Systemname").checked = false;
		document.getElementById("Location").checked = false;
	}
	showSelected();
}
function showSelected()
{
	var table = document.getElementById("tab");
	var rows = table.rows;
	var selcnt = 1;
	if(document.getElementById("LoopbckIP").checked)
	{
		hideOrShowColumn(1,true);
		hideOrShowColumn(2,true);
		selcnt+=2;
		loopback_opt = true;
	}
	else
	{
		hideOrShowColumn(1,false);
		hideOrShowColumn(2,false);
		loopback_opt = false;
	}
	if(document.getElementById("Eth0IP").checked)
	{
		hideOrShowColumn(3,true);
		hideOrShowColumn(4,true);
		selcnt+=2;
		eth0_opt = true;
	}
	else
	{
		hideOrShowColumn(3,false);
		hideOrShowColumn(4,false);
		eth0_opt = false;
	} 
	/*if(document.getElementById("Eth1IP").checked)
		{
		hideOrShowColumn(5,true);
		hideOrShowColumn(6,true);
		selcnt+=2;
		eth1_opt = true;
	}
	else
	{
		hideOrShowColumn(5,false);
		hideOrShowColumn(6,false);
		selcnt-=2;
		eth1_opt = false;
	}*/
	if(document.getElementById("Systemname").checked)
	{
		hideOrShowColumn(7,true);
		selcnt++;
	}
	else
	{
		hideOrShowColumn(7,false);
	}
	if(document.getElementById("Location").checked)
	{
		hideOrShowColumn(8,true);
		selcnt++;
	}
	else
	{
		hideOrShowColumn(8,false);
	}
	document.getElementById("tabdiv").className = "col-md-"+selcnt;
}

function hideOrShowColumn(colind,show)
{
	var rows = document.getElementById("tab").rows;
	var row = 0;
	for( row=0;row < rows.length;row++)
	{
		if(show)
		rows[row].cells[colind].hidden="";
		else
		rows[row].cells[colind].hidden="hidden";
	}
}
function checkOption(opid)
{
	document.getElementById(opid).checked = true;
}
function showInvalidFileMessage() {
	alert("Invalid File...");
}
function showStausMessage(altmsg) {
	//alert(altmsg);
	altmsg = altmsg.replaceAll('$newline$','\n');
	alert(altmsg);
}
function setRowIndex(val)
{
	document.getElementById("cntid").value = val;
}
/* function validateIP(id, checkempty, name) {
	var ipele = document.getElementById(id);
	if (ipele.readOnly == true) {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
	var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
	var ipaddr = ipele.value.trim();
	if (ipaddr == "") {
		if (checkempty) {
			ipele.style.outline = "thin solid red";
			ipele.title = name + " should not be empty";
			return false;
		} else {
			ipele.style.outline = "initial";
			ipele.title = "";
			return true;
		}
	} else if (!ipaddr.match(ipformat) || ipaddr == "0.0.0.0" || ipaddr == "255.255.255.255") {
		ipele.style.outline = "thin solid red";
		ipele.title = "Invalid " + name;
		return false;
	} else {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
}
 */
/* function validateSubnetMask(id, checkempty, name) {
	var ipele = document.getElementById(id);
	if (ipele.readOnly == true) {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
	var ipformat =/^(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0+)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$/; 
	var ipaddr = ipele.value.trim();
	if (ipaddr == "") {
		if (checkempty) {
			ipele.style.outline = "thin solid red";
			ipele.title = name + " should not be empty";
			return false;
		} else {
			ipele.style.outline = "initial";
			ipele.title = "";
			return true;
		}
	} else if (!ipaddr.match(ipformat) || ipaddr == "0.0.0.0" || ipaddr == "255.255.255.255") {
		ipele.style.outline = "thin solid red";
		ipele.title = "Invalid " + name;
		return false;
	} else {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
} */
var oldelevalarr="";
function validateIncCammaAndVals(id, checkempty, name) {
	var ele = document.getElementById(id);
	if(!name.includes("NetMask"))
		var format =/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/; 
	else
		var format = /^(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0+)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$/; 
	
	var eleval = ele.value.trim();
	var elevalarr=eleval.split(",");
	var oldsts="";
	var nwlist=[];
	var bclist=[];
	const iparrobj = [];
	for(i=0;i<elevalarr.length;i++)
	{
		var sts="";
		if(!name.includes("NetMask"))
			oldelevalarr=elevalarr;
		if((!elevalarr[i].match(format)||elevalarr[i]=="0.0.0.0"|| elevalarr[i]== "255.255.255.255")||(oldelevalarr.length < elevalarr.length|| elevalarr.length < oldelevalarr.length))
			{
				 ele.style.outline = "thin solid red";
				 sts+="Invalid";
			}
		else
			sts+="Valid";
	 	for(j=0;j<elevalarr.length;j++)
			{
				if(i!=j&&name.includes("NetMask")&&(elevalarr[i]==elevalarr[j])&&(oldelevalarr[i]==oldelevalarr[j]))
						 sts+="Duplicate";
			} 
	 	if(oldelevalarr[i]!=""&&elevalarr[i]!="" && name.includes("NetMask") &&oldelevalarr.length == elevalarr.length)
		{
			var nw = getNetwork(oldelevalarr[i],elevalarr[i]);
	 		var bc = getBroadcast(nw,elevalarr[i]);
			nwlist.push(nw);
			bclist.push(bc);
			for(var l=0;l<iparrobj.length;l++)
			{
				var nw1 = nwlist[l];
				var bc1 = bclist[l];
				if((isGraterOrEquals(nw,nw1) && !isGraterOrEquals(nw,bc1)) || (isGraterOrEquals(nw1, nw) && !isGraterOrEquals(nw1,bc)))
					{
						sts+="Overlap";
						break;
					}
			}
			iparrobj.push(oldelevalarr[i]);
		}
	 	oldsts+=sts;

	}
	return oldsts;
}
function validatePage()
{
	try{
	if(document.getElementById("cntid").value == 0)
	{
		alert("No updates available");
		return false;
	}
    var options = document.getElementsByName("options");
	var opt_sel = false;
		for(var i=0;i<options.length;i++)
		{
			if(options[i].checked)
			{
				opt_sel = true;
				break;
			}
		}
		if(!opt_sel)
		{
			alert("No Option is selected");
			return false;
		}
		var rowcnt = document.getElementById("cntid").value;
		var errmsg = "";
		for(var i=1;i<=rowcnt;i++)
		{
			var slnumberobj =document.getElementById("slnumber"+i);
			var lbipobj = document.getElementById("loopbackip"+i);
			var lbsubnetobj = document.getElementById("lsubnet"+i);	
			var e0ipobj = document.getElementById("eth0ip"+i);
			var e0subnetobj = document.getElementById("e0subnet"+i);
			var e1ipobj = document.getElementById("eth1ip"+i);
			var e1subnetobj = document.getElementById("e1subnet"+i);
			var slnumber=slnumberobj.value;
 			var lbip =lbipobj.value;
			var lbsubnet = lbsubnetobj.value;	
			var e0ip = e0ipobj.value;
			var e0subnet = e0subnetobj.value;
			var e1ip =e1ipobj.value;
			var e1subnet = e1subnetobj.value;
			var lbnw = "";
			var e0nw = "";
			var e1nw = "";
			var lbvalid="";
			var ntmskvalid="";
			var eth0valid="";
			var eth0ntvalid="";
			//if(e1ip != "" && e1subnet != "")
				//e1nw = getNetwork(e1ip,e1subnet);
			if(!validateSerialNum("slnumber"+i, true, "Serial No"))
				{
				if(slnumber=="")
					errmsg += "SerialNumber Should  not empty in the row "+ i +"\n";
				else
					errmsg += "Invalid serial number "+slnumber+"\n";
				}
				for(var j=1;j<=rowcnt;j++)
				{
					var jslnumberobj =document.getElementById("slnumber"+j);
					if(jslnumberobj!=null)
						{
						j_slnumber = jslnumberobj.value.trim();
						if ((slnumber == j_slnumber) && (i != j) &&(slnumber!="")&&(j_slnumber!="")) 
							{
							if (!errmsg.includes("Duplicate SerialNumber "+slnumber))
								errmsg +="Duplicate SerialNumber " + slnumber + " \n";
							slnumberobj.style.outline = "thin solid red";
							break;
							}
						}
				}
			if((lbip == "" || lbsubnet == "") && loopback_opt)
				{
					errmsg +="Loopback IP or NetMask of serial number "+slnumber+" Should not empty.\n";
					if(lbip == "")
						lbipobj.style.outline = "thin solid red";
					else
						lbsubnetobj.style.outline = "thin solid red";
				}
			if(!lbip.includes(",")&&!lbsubnet.includes(","))
				{
					lbvalid=validateIP("loopbackip"+i,false,"Loopback IP");
					ntmskvalid=validateSubnetMask("lsubnet"+i,false,"NetMask");
					 if(!lbvalid&& loopback_opt)
						errmsg += "Invalid Loopback IP of serial number "+slnumber+"\n";
					 if((lbsubnet != "255.255.255.255"&&!ntmskvalid) && loopback_opt)
						errmsg += "Invalid Loopback NetMask of serial number "+slnumber+"\n";
				}
			else
			{
				var lpbkvalid=validateIncCammaAndVals("loopbackip"+i,false,"Loopback IP");
				var lbntmkvalid=validateIncCammaAndVals("lsubnet"+i,false,"NetMask");
				if(lpbkvalid.includes("Invalid"))
					errmsg += "Invalid Loopback IP of serial number "+slnumber+"\n";
				if(lpbkvalid.includes("Duplicate"))
					errmsg += "Duplicate Loopback IP of serial number "+slnumber+"\n";
				if(lbntmkvalid.includes("Overlap"))
					errmsg += "Loopback IP of serial number "+slnumber+" should not be Overlap\n";
				if(lbntmkvalid.includes("Invalid")&&!lbsubnet.includes("255.255.255.255"))
					errmsg += "Invalid Loopback NetMask of serial number "+slnumber+"\n";
				if(lbntmkvalid.includes("Duplicate"))
					errmsg += "Duplicate Loopback Ip and NetMask of serial number "+slnumber+"\n";
			}
			if((e0ip == "" || e0subnet == "") && eth0_opt)
			{
				errmsg +="Ethernet0 IP or NetMask of serial number "+slnumber+" Should not empty.\n";
				if(e0ip == "")
					e0ipobj.style.outline = "thin solid red";
				else
					e0subnetobj.style.outline = "thin solid red";
			}
			if(!e0ip.includes(",")&&!e0subnet.includes(","))
			{
				eth0valid=validateIP("eth0ip"+i,false,"Ethernet0 IP");
				eth0ntvalid=validateSubnetMask("e0subnet"+i,false,"Eth0 NetMask");
				if(!eth0valid && eth0_opt)
					errmsg += "Invalid Ethernet0 IP of serial number "+slnumber+"\n";
				else if(!eth0ntvalid&& eth0_opt)
					errmsg += "Invalid Ethernet0 NetMask of serial number "+slnumber+"\n";
			}
			else
			{
				var e0thvalid=validateIncCammaAndVals("eth0ip"+i,false,"Ethernet0 IP");
				var e0thntmkvalid=validateIncCammaAndVals("e0subnet"+i,false,"Eth0 NetMask");
				if(e0thvalid.includes("Invalid"))
					errmsg += "Invalid Ethernet0 IP of serial number "+slnumber+"\n";
				if(e0thvalid.includes("Duplicate"))
					errmsg += "Duplicate Ethernet0 IP of serial number "+slnumber+"\n";
				if(e0thntmkvalid.includes("Invalid") || e1subnet.includes("255.255.255.255"))
						errmsg += "Invalid Ethernet0 NetMask of serial number "+slnumber+"\n";
				if(e0thntmkvalid.includes("Overlap"))
					errmsg += "Ethernet0 IP of serial number "+slnumber+" should not be Overlap\n";
				if(e0thntmkvalid.includes("Duplicate"))
					errmsg += "Duplicate Ethernet0 NetMask of serial number "+slnumber+"\n";
			}
			if(!e0ip.includes(",")&&!e0subnet.includes(",")&&(lbvalid&&ntmskvalid)&&(eth0valid&&eth0ntvalid))
			{
				if(lbip !="" && lbsubnet != "")
				{
					lbnw = getNetwork(lbip,lbsubnet);
					lbbc = getBroadcast(lbnw,lbsubnet);
				}
			    if(e0ip != "" && e0subnet != "")
			    {
					e0nw = getNetwork(e0ip,e0subnet);
					e0bc=getBroadcast(e0nw,e0subnet);
			    }
				if(lbip != "" && e0ip != "" && loopback_opt && eth0_opt &&((isGraterOrEquals(lbnw,e0nw) && !isGraterOrEquals(lbnw,e0bc)) || (isGraterOrEquals(e0nw, lbnw) && !isGraterOrEquals(e0nw,lbbc))))
					errmsg +="Loopback IP and Ethernet0 IP of serial number "+slnumber+" Should not Overlap.\n";
			}
			if(e0ip.includes(",")&&e0subnet.includes(",")&&(lbvalid&&ntmskvalid)&&(eth0valid&&eth0ntvalid))
			{
					var lbnwlist=[];
					var lbsubnetbclist=[];
					var e0nwlist=[];
					var e0subnetbclist=[];
					if(lbip !="" && lbsubnet != "")
					{
						var lbiparr=lbip.split(",");
						var lsubnetarr=lbsubnet.split(",");
						if(lbiparr.length==lsubnetarr.length)
						{
							for(var m=0;m<lbiparr.length;m++)
								{
									lbnw = getNetwork(lbiparr[m],lsubnetarr[m]);
									lbbc = getBroadcast(lbnw,lsubnetarr[m]);
									lbnwlist.push(lbnw);
									lbsubnetbclist.push(lbbc);
								}
						 }
					 }
				    if(e0ip != "" && e0subnet != "")
				    {
				    	var e0iparr=e0ip.split(",");
						var e0subnetarr=e0subnet.split(",");
						if(e0iparr.length==e0subnetarr.length)
						{
							for(var n=0;n<e0iparr.length;n++)
								{
									e0nw = getNetwork(e0iparr[n],e0subnetarr[n]);
									e0bc = getBroadcast(e0nw,e0subnetarr[n]);
									e0nwlist.push(e0nw);
									e0subnetbclist.push(e0bc);
								}
						}
				     }
				    for(var l=0;l<lbiparr.length;l++)
					{
						var lbnw1 = lbnwlist[l];
						var lbbc1 = lbsubnetbclist[l];
						for(var k=0;k<e0iparr.length;k++)
						{
							var e0nw1=e0nwlist[k];
							var e0bc1=e0subnetbclist[k];
							if(lbip != "" && e0ip != "" && loopback_opt && eth0_opt &&((isGraterOrEquals(lbnw1,e0nw1) && !isGraterOrEquals(lbnw1,e0bc1)) || (isGraterOrEquals(e0nw1, lbnw1) && !isGraterOrEquals(e0nw1,lbbc1))))
								{
								if(!(errmsg.includes("Loopback IP and Ethernet0 IP of serial number "+slnumber+" Should not Overlap.")))
									errmsg +="Loopback IP and Ethernet0 IP of serial number "+slnumber+" Should not Overlap.\n";
								}
						 }
					}
			  }
			//if(e1ip == "" || e1subnet == "" && eth1_opt)
			//errmsg +="Ethernet1 IP or NetMask of serial number "+slnumber+" Should not empty.\n"; 
			//if(e1nw == e0nw && e0ip != "" && eth1_opt && eth0_opt)
				//errmsg +="Ethernet0 IP and Ethernet1 IP of serial number "+slnumber+" Should not Overlap.\n";
			//if(lbnw == e1nw && e1ip != "" && loopback_opt && eth1_opt)
				//errmsg +="Ethernet1 IP and Loopback IP of serial number "+slnumber+" Should not Overlap.\n";
			//if(!validateIP("eth0ip"+i,false,"Ethernet1 IP")&& eth1_opt)
				//errmsg += "invalid Ethernet1 IP of serial number "+slnumber+"\n";
			//if(!validateSubnetMask("e1subnet"+i,false,"Eth1 NetMask") && eth1_opt)
				//errmsg += "invalid Ethernet1 NetMask of serial number "+slnumber+"\n";
			
		}
		if(errmsg.length > 0)
		{
			alert(errmsg);
			return false;
		}
		return true;
	}catch(e){alert(e);}
}
function validateLoopbackSubnet(id)
{
	var subnet = document.getElementById(id);
	if(subnet.value=='255.255.255.255')
	{
		subnet.style.outline = "initial";
		subnet.title = "";
		return true;
	}
	else return validateSubnetMask(id,true,"NetMask");
}
function getNetwork(ip,subnet)
{
	try{
	    if(ip.length == 0)
		   return "0.0.0.0";
		var ipaddr = ip.split(".");
		var subn = subnet.split(".");
		var network = "";
		var netarr = new Array(4);		
		for(var i=0;i<ipaddr.length;i++)
		{
			network  += (parseInt(ipaddr[i]) & parseInt(subn[i]))+"";
			if(i<ipaddr.length-1)
				network +=".";
		}
	}
	catch(err)
	{
		alert(err);
	}
		return network;
}
function validateCammaOrNot(id,checkempty,name)
{
	var obj=document.getElementById(id);
	var objval=obj.value;
	if(objval.includes(","))
		validateIncCammaAndVals(id, checkempty, name);
	else if(name.includes("Loopback IP") || name.includes("Eth0 IP"))
		validateIP(id, checkempty, name);
	else if(id.includes("lsubnet"))
		validateLoopbackSubnet(id);
	else
		validateSubnetMask(id, checkempty, name);
}
</script>
<head>
<body>
	<form method="post" name="form" id="form" enctype="multipart/form-data"
		action="saveOrgUpdate" onsubmit="return validatePage();">
		<label id="bold">Select Options To Update :</label> <br /> <input
			id="cntid" name="cntid" type="text" value="0" hidden /> <input
			id="all" type="checkbox" onchange="doSelectAll()"><b> All</b></input><br />
		<input id="LoopbckIP" type="checkbox" name="options" value="LoopbckIP"
			onchange="showSelected();"><b> Loopback IP Address </b></input><br />
		<input id="Eth0IP" type="checkbox" name="options" value="Eth0IP"
			onchange="showSelected();"><b> Eth0 IP Address</b></input><br />
		<!-- <input id="Eth1IP" type="checkbox" name="options" value="Eth1IP" onchange="showSelected();"><b>  Eth1 IP Address</b></input><br/> -->
		<input id="Systemname" type="checkbox" name="options"
			value="Systemname" onchange="showSelected();"><b> System
			Name</b></input><br /> <input id="Location" type="checkbox" name="options"
			value="Location" onchange="showSelected();"><b> Location</b></input><br />
		<br /> &nbsp;&nbsp;<label>Select File :&nbsp;</label> <input
			type="file" style="display: inline; width: 70px;" id="orgupdatefile"
			name="orgupdatefile" onchange="submitFile();" /><label
			style="margin-right: 8%"><%=filename != null ? filename : ""%></label>
		<input type="submit" class="btn btn-default"
			style="width: 80px; height: 40px; font-weight: bold" value="Submit">
		<a href="orgupdate.xls"><input type="button"
			value="Download Sample File" class="btn btn-default"
			style="width: 180px; height: 40px; font-weight: bold;" /></a>


		<div class="row top-buffer">

			<%
			if (orgupdatevec != null) {
				if (options != null) {
					options_cnt = options.length;
					for (String option : options) {
				if (option.equals("LoopbckIP"))
					loopback = true;
				else if (option.equals("Eth0IP"))
					eth0ip = true;
				else if (option.equals("Eth1IP"))
					eth1ip = true;
				else if (option.equals("Systemname"))
					sysname = true;
				else if (option.equals("Location"))
					location = true;
			%>
			<script> 
			checkOption('<%=option%>');
			</script>
			<%
			}
			%>
			<script> 
			setSelectedOptions(<%=loopback%>,<%=eth0ip%>,<%=eth1ip%>);
		</script>
			<%
			} else {
			%>
			<script> 
			alert('No Option selected');
		</script>
			<%
			}
			}
			%>
			<div class="col-md-<%=options_cnt + 1%>" id="tabdiv">
				<table class="table table-bordered" id="tab"
					style="width: 50%; max-width: 50%">

					<thead>
						<%
						if (orgupdatevec != null && options_cnt > 0) {
						%>
						<th>Serial No</th>
						<th id="hloopbackip" <%if (!loopback) {%> hidden <%}%> width="">
							Loopback IP</th>
						<th id="hlsubnet" <%if (!loopback) {%> hidden <%}%> width="">
							Net Mask</th>
						<th id="heth0ip" <%if (!eth0ip) {%> hidden <%}%>>Eth0 IP</th>
						<th id="e0subnet" <%if (!eth0ip) {%> hidden <%}%> width="">Net
							Mask</th>
						<th id="heth1ip" <%if (!eth1ip) {%> hidden <%}%>>Eth1 IP</th>
						<th id="e1subnet" <%if (!eth1ip) {%> hidden <%}%> width="">Net
							Mask</th>
						<th id="hsysname" <%if (!sysname) {%> hidden <%}%>>System
							Name</th>
						<th id="hlocation" <%if (!location) {%> hidden <%}%>>Location</th>
						<%
						}
						%>
					</thead>
					<tbody>
						<%
						try {
							if (orgupdatevec != null && options_cnt > 0) {
								for (Vector<String> det_vec : orgupdatevec) {
							cnt++;
							if (det_vec.size() < 7)
								throw new ArrayIndexOutOfBoundsException();
						%>
						<tr>
							<td><Input type="text" readonly id="slnumber<%=cnt%>"
								name="slnumber<%=cnt%>"
								onfocusout="validateSerialNum('slnumber<%=cnt%>', true, 'Serial No');"
								value="<%=det_vec.get(0).trim()%>"></td>
							<td <%if (!loopback) {%> hidden <%}%>><Input type="text"
								id="loopbackip<%=cnt%>" name="loopbackip<%=cnt%>"
								onfocusout="validateCammaOrNot('loopbackip<%=cnt%>',true,'Loopback IP');"
								value="<%=det_vec.get(1).trim()%>" onmouseover="setTitle(this)"></Input></td>
							<td <%if (!loopback) {%> hidden <%}%>><Input type="text"
								id="lsubnet<%=cnt%>" name="lsubnet<%=cnt%>"
								onfocusout="validateCammaOrNot('lsubnet<%=cnt%>',true,'NetMask');"
								value="<%=det_vec.get(2).trim()%>" onmouseover="setTitle(this)"></Input></td>
							<td <%if (!eth0ip) {%> hidden <%}%>><Input type="text"
								id="eth0ip<%=cnt%>" name="eth0ip<%=cnt%>"
								onfocusout="validateCammaOrNot('eth0ip<%=cnt%>',true,'Eth0 IP');"
								value="<%=det_vec.get(3).trim()%>" onmouseover="setTitle(this)"></Input></td>
							<td <%if (!eth0ip) {%> hidden <%}%>><Input type="text"
								id="e0subnet<%=cnt%>" name="e0subnet<%=cnt%>"
								onfocusout="validateCammaOrNot('e0subnet<%=cnt%>',true,'NetMask');"
								value="<%=det_vec.get(4).trim()%>" onmouseover="setTitle(this)"></Input></td>
							<td <%if (!eth1ip) {%> hidden <%}%>><Input type="text"
								id="eth1ip<%=cnt%>" name="eth1ip<%=cnt%>"
								onfocusout="validateIP('eth1ip<%=cnt%>',true,'Eth1 IP');"
								value=""></Input></td>
							<td <%if (!eth1ip) {%> hidden <%}%>><Input type="text"
								id="e1subnet<%=cnt%>" name="e1subnet<%=cnt%>"
								onfocusout="validateSubnetMask('e1subnet<%=cnt%>',true,'NetMask');"
								value=""></Input></td>
							<td <%if (!sysname) {%> hidden <%}%>><Input type="text"
								id="sysname<%=cnt%>" name="sysname<%=cnt%>"
								value="<%=det_vec.get(5).trim()%>"></Input></td>
							<td <%if (!location) {%> hidden <%}%>><Input type="text"
								id="location<%=cnt%>" name="location<%=cnt%>"
								value="<%=det_vec.get(6).trim()%>"></Input></td>
						</tr>
						<%
						}
						%>
						<script>
		       setRowIndex('<%=cnt%>');
			 </script>
						<%
						}
						} catch (Exception e) {
						cnt = 0;
						e.printStackTrace();
						%>
						<script>
		    	showInvalidFileMessage();
		    	</script>
						<%
						}
						%>
					</tbody>
				</table>
			</div>
		</div>
	</form>
	<%
	if (statusstr != null) {
	%>
	<script>
		showStausMessage('<%=statusstr%>');
	</script>
	<%
	}
	%>
</body>