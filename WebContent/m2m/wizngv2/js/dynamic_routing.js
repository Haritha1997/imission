var curdiv="";
var currdiv="";
var curintfdiv="Eth0";
var curintfv3div="Eth0";
var curlist="";//for popup
function showDivision(divname,sellist,slnumber,version)
{
	try {
	//alert(curdiv+"  "+curlist +"  "+sellist);
	if(curdiv!="" && curlist == sellist &&curdiv !=divname)//for popup
	{
		if(!validateOSPF2(curdiv))
			return;
		else if(!validateOSPF3(curdiv))
			return;
	}
		
/*bgp4*/
	if(curdiv == "bgp_instance")
	{
				if(bgp_ins_det_empty )
			{
				alert("Please save the bgp instance details");
				return;
			}
	}	
	curdiv=divname;
	curlist=sellist;//for popup
	var divname_arr = ["ospf2_instance","networks","interface_config","area_config"];
	if(sellist == "ospf3list")
		divname_arr = ["ospf3_instance","interface_v3","interface_config_v3","area_config_v3"];
	if(sellist == "bgplist")
		divname_arr = ["bgp_instance","bgp_peers","bgppeersettingsdiv","path_filtering","path_summarization","add_bgppeer","add_bgppeersetteings","add_bgppath","add_pathsum"];
	var list = document.getElementsByClassName(sellist);
	for(var i=0;i<divname_arr.length;i++)
	{
		if(divname == divname_arr[i])
		{
			/***********************/
			document.getElementById(divname_arr[i]).style.display = "";
			if(sellist == "ospflist")
			{
				document.getElementById('subdivpage').value = divname;
			}
			if(sellist == "ospf3list")
				document.getElementById("ospf3_subdivpage").value = divname;
			
			if(divname == "interface_config")
			{
				showpassword('e0');
				showpassword('e1');
				//showpassword('loop');
				
			}
			if(divname == "interface_config_v3")
			{
				//showpasswordv3('e0');
				//showpasswordv3('e1');
			}
			if(sellist == "bgplist")
			{
			 //alert("bgplist =="+divname);

				document.getElementById(divname+'bgpsubdivpage').value = divname;
				// alert("subdivpage===:"+subdivpage.value);
				if(divname == "add_bgppeer")
				{
					list[1].id="hilightthis";
				}
				else if(divname == "add_bgppeersetteings")
				{
					list[2].id="hilightthis";
				}
				else if(divname == "add_bgppath")
				{
					list[3].id="hilightthis"; 
				}  
				else if(divname == "add_pathsum")
				{
					list[4].id="hilightthis"; 
				}
			}
			if(i<5)
				list[i].id="hilightthis";
			
			/*********************/
			
			if(divname != "add_bgppeer")
				document.getElementById("add_bgppeer").style.display="none";
			if(divname != "add_bgppeersetteings")
				document.getElementById("add_bgppeersetteings").style.display="none";
			if(divname != "add_bgppath")
				document.getElementById("add_bgppath").style.display="none";
			if(divname != "add_pathsum")
				document.getElementById("add_pathsum").style.display="none";
		}
		else
		{		
			document.getElementById(divname_arr[i]).style.display = "none";
			if(i<5)
			list[i].id="";
		}
		
	}
	}catch(e)
	{
		alert(e);
	}
}
function showPDivision(divname,slnumber,version)
{
	var divname_arr = ["ospfdiv","ospfv3div","bgpdiv"];
	var droutelist = document.getElementsByClassName("droutelist");
	for(var i=0;i<divname_arr.length;i++)
	{		
		//alert("showPDivision==="+divname);
		//alert("droutelist==="+droutelist);
		if(divname == divname_arr[i])
		{
			droutelist[i].id="hilightthis";
			document.getElementById(divname_arr[i]).style.display = "";
			
			 if(divname == "ospfdiv")
			 {
			 	showDivision('ospf2_instance','ospflist',slnumber,version);
			 }
			 else if(divname == "ospfv3div")
			 {
				 showDivision('ospf3_instance','ospf3list',slnumber,version);
			 }
			 else if(divname == "bgpdiv")
			 {
			 	showDivision('bgp_instance','bgplist',slnumber,version);
			 }
		}
		else
		{
			droutelist[i].id="";
			document.getElementById(divname_arr[i]).style.display = "none";			
		}
	}
}

function validateRange(id,checkempty,name)
{		
	/*BGP4/*

		if(id == "pg_rmt_as")
		{
			setNeighbourConfig();
		} 
		/*BGP4 end*/
//alert("in the validateRange");
		var rele = document.getElementById(id);
		//alert(rele);
		var val = rele.value;
		//alert(val);
		var max = Number(rele.max);
		var min = Number(rele.min);
		if(val.trim() == "")
		{
		    if(checkempty)
			{
				rele.style.outline =  "thin solid red";
				rele.title = name+" should be integer in the range from "+min+" to "+max;
				return false;
			}
			else
			{
		        rele.style.outline = "initial";
				rele.title = "";
				return true;
			}
		}
		if(!isNaN(val))
		{			
			if(val >= min && val <= max)
			{
				rele.style.outline = "initial";
				rele.title = "";
				return true;
			}
			else
			{
				rele.style.outline =  "thin solid red";
				rele.title = name+" should be in the range from "+min+" to "+max;
				return false;
			}
		}
		else
		{
			rele.style.outline =  "thin solid red";
			rele.title = name+" should be integer in the range from "+min+" to "+max;
			return false;
		}
}


function addRow(tablename,slnumber,version) 
{
	//alert("***** addROW ****===:"+tablename);
	var table = document.getElementById(tablename); 
	var iprows = table.rows.length; 
	if (tablename == "networkconfig") 
	{ 
		if (iprows == 21) 
		{ 
			alert("Maximum 20 rows are allowed in OSPF Network Table"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("netwrkrwcnt").value = iprows; 
		iprows = document.getElementById("netwrkrwcnt").value; 
		document.getElementById("netwrkrwcnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id=\"ospfntwrk"+iprows+"\">"+
		"<td style=\"text-align: center; vertical-align: middle;\" class=\"text\">"+iprows+"</td>"+
		"<td><input name=\"network"+iprows+"\" type=\"text\" class=\"text\" id=\"network"+iprows+"\" size=\"12\" maxlength=\"15\"  onkeypress=\"return avoidSpace(event);\" onfocusout=\"validateIP('network"+iprows+"',true,'network')\"></td>"+
		"<td><input name=\"network_subnet"+iprows+"\" type=\"text\" class=\"text\" id=\"network_subnet"+iprows+"\" size=\"12\"  onkeypress=\"return avoidSpace(event);\" maxlength=\"15\" onfocusout=\"validateSubnetMask('network_subnet"+iprows+"',true,'network_subnet')\"></td>"+
		"<td><input name=\"area"+iprows+"\" type=\"number\" min=\"0\" max=\"4294967295\" placeholder=\"0-4294967295\" class=\"text\" id=\"area"+iprows+"\" size=\"12\"  onkeypress=\"return avoidSpace(event);\" maxlength=\"15\"></td>"+
		"<td><image style=\"cursor:pointer\" id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"30\" height=\"22\" align=\"center\" title=\"Delete\" onclick=\"checkAreaExistsOrNot('area"+iprows+"','area_id','ospfntwrk"+iprows+"','"+tablename+"');\"></image></td>"+
		"<td hidden>0</td>"+
		"<td hidden><input hidden id=\"nwarearow_val"+iprows+"\"/></td>"
		"</tr>"; 
		$('#networkconfig').append(row); 
        reindexTable('networkconfig');		
	}
	
	else if (tablename == "areaconfig")
	{ 
		if (iprows == 6) 
		{ 
			alert("Maximum 5 rows are allowed in OSPF Area Table"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("areacnt").value = iprows; 
		iprows = document.getElementById("areacnt").value; 
		document.getElementById("areacnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id=\"ospfarea"+iprows+"\">"+
		"<td style=\"text-align: center; vertical-align: middle;\">"+iprows+"</td>"+
		"<td><select name=\"area_id"+iprows+"\" class=\"text\" id=\"area_id"+iprows+"\" onfocus='addAreaOptions(\"area_id"+iprows+"\" )'></select></td>"+
		"<td><select name=\"area_type"+iprows+"\" class=\"text\" id=\"area_type"+iprows+"\" onfocusout='checkAreaType(\"area_id"+iprows+"\",\"area_type"+iprows+"\")'><option value=\"\"></option><option value=\"Stub\">Stub</option><option value=\"Totally Stub\">Totally Stub</option><option value=\"NSSA\">NSSA</option><option value=\"Totally NSSA\">Totally NSSA</option></select></td>"+
		"<td><input name=\"sum_int"+iprows+"\" type=\"text\" class=\"text\" id=\"sum_int"+iprows+"\"  maxlength=\"18\" placeholder=\"(A.B.C.D/M)\"  onkeypress=\"return avoidSpace(event);\" onfocusout=\"validateCIDRNotation('sum_int"+iprows+"',false,'Summarise Inter Area')\"></td>"+
		"<td><image style=\"cursor:pointer\" id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"30\" height=\"22\" align=\"center\" title=\"Delete\" onclick=\"deleteRow('ospfarea"+iprows+"','areaconfig');\"></image></td>"+
		"<td hidden>0</td>"+
		"<td hidden>"+iprows+"</td>"+
		"</tr>"; 
		$('#areaconfig').append(row); 
		addAreaOptions('area_id'+iprows);
       reindexTable('areaconfig');	   
	}
	else if (tablename == "neighconfig") //diff ospfv2
	{ 
		if (iprows == 21) 
		{ 
			alert("Maximum 20 rows are allowed in OSPF Network Table"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("neighbourcnt").value = iprows; 
		iprows = document.getElementById("neighbourcnt").value; 
		document.getElementById("neighbourcnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id=\"ospfneighbour"+iprows+"\">"+
		"<td style=\"text-align: center; vertical-align: middle;\">"+iprows+"</td>"+
		"<td><input name=\"neighbour\" type=\"text\" class=\"text\" id=\"neighbour"+iprows+"\" size=\"12\" maxlength=\"15\" onfocusout=\"validateIP('neighbour"+iprows+"',true,'neighbournetwork')\"></td>"+
		"<td><image style=\"cursor:pointer\" id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"30\" height=\"22\" align=\"center\" title=\"Delete\" onclick=\"deleteRow('ospfneighbour"+iprows+"','neighconfig');\"></image></td>"+
		"<td hidden>0</td>"+
		"<td hidden>"+iprows+"</td>"+
		"</tr>"; 
		$('#neighconfig').append(row); 
       reindexTable('neighconfig');		
	}
//new on 21/12/22
else if (tablename == "redistribute")
	{ 
		if (iprows == 4) 
		{ 
			alert("Maximum 3 rows are allowed in OSPF Redistribute Table"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("redistributecnt").value = iprows; 
		iprows = document.getElementById("redistributecnt").value; 
		document.getElementById("redistributecnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id=\"redistributerow"+iprows+"\">"+
		"<td style=\"text-align: center; vertical-align: middle;\">"+iprows+"</td>"+
		"<td><select name=\"links"+iprows+"\" class=\"text\" id=\"links"+iprows+"\"><option value=\"Connected Routes\">Connected Routes</option><option value=\"Static Routes\">Static Routes</option><option value=\"BGP Routes\">BGP Routes</option></select></td>"+
		"<td><select name=\"metric_type"+iprows+"\"  class=\"text\" id=\"metric_type"+iprows+"\"><option value=\"type1\">Type1</option><option value=\"type2\">Type2</option></select></td>"+
		"<td><input name=\"metric"+iprows+"\" type=\"number\" class=\"text\" id=\"metric"+iprows+"\" placeholder=\"1-16777214\" min=\"1\" max=\"16777214\"  onkeypress=\"return avoidSpace(event);\"></td>"+
		"<td><image style=\"cursor:pointer\" id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"30\" height=\"22\" align=\"center\" title=\"Delete\" onclick=\"deleteRow('redistributerow"+iprows+"','redistribute');\"></image></td>"+
		"<td hidden>0</td>"+
		"<td hidden>"+iprows+"</td>"+
		"</tr>"; 
		$('#redistribute').append(row); 
       reindexTable('redistribute');		
	}
//ends here
 //-------------------------------- OSPFV3 ----------------------------
	else if (tablename == "networkconfigv3") 
	{ 
		if (iprows == 21) 
		{ 
			alert("Maximum 20 rows are allowed in OSPF6 Network Table"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("netwrkv3rwcnt").value = iprows; 
		iprows = document.getElementById("netwrkv3rwcnt").value; 
		document.getElementById("netwrkv3rwcnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id=\"ospfntwrkv3"+iprows+"\">"+
		"<td style=\"text-align: center; vertical-align: middle;\" class=\"text\">"+iprows+"</td>"+
		"<td><input name=\"network_v3"+iprows+"\" type=\"text\" class=\"text\" id=\"network_v3"+iprows+"\" size=\"12\" maxlength=\"15\" onfocusout=\"validateIP('network"+iprows+"',true,'network')\"></td>"+
		"<td><input name=\"network_subnet_v3"+iprows+"\" type=\"text\" class=\"text\" id=\"network_subnet_v3"+iprows+"\" size=\"12\" maxlength=\"15\" onfocusout=\"validateSubnetMask('network_subnet"+iprows+"',true,'network_subnet')\"></td>"+
		"<td><input name=\"area_v3"+iprows+"\" type=\"number\" min=\"0\" max=\"4294967295\" placeholder=\"0-4294967295\" class=\"text\" id=\"area_v3"+iprows+"\" size=\"12\" maxlength=\"15\"></td>"+
		"<td><image style=\"cursor:pointer\" id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"20\" height=\"22\" align=\"center\" title=\"Delete\" onclick=\"deleteRow('ospfntwrkv3"+iprows+"','networkconfigv3');\"></image></td>"+
		"<td hidden>0</td>"+
		"</tr>"; 
		$('#networkconfigv3').append(row); 
        reindexTable('networkconfigv3');		
	}
	else if(tablename == "interfacev3tab")
	{
		if (iprows == 21) 
		{ 
			alert("Maximum 20 rows are allowed in OSPF Network Table"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("intfv3rwcnt").value = iprows; 
		iprows = document.getElementById("intfv3rwcnt").value; 
		document.getElementById("intfv3rwcnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id=\"ospfinterfacev3"+iprows+"\">"+
		"<td style=\"text-align: center; vertical-align: middle;\">"+iprows+"</td>"+
		"<td><select name=\"intfce"+iprows+"\" class=\"text\" id=\"intfce"+iprows+"\" ><option value='eth0'>LAN</option><option value='eth1'>WAN</option><option value='loopback'>Loopback</option></select></td>"+
		//"<td><input type=\"text\" class=\"text\" name=\"intfarea"+iprows+"\" id=\"intfarea"+iprows+"\" placeholder='(0-4294967295)||Ip addr' /></td> "+
		"<td><input name=\"intfarea"+iprows+"\" type=\"number\" min=\"0\" max=\"4294967295\" class=\"text\" id=\"intfarea"+iprows+"\" size=\"12\" maxlength=\"15\" onkeypress=\"return avoidSpace(event);\"></td>"+
		"<td><image style=\"cursor:pointer\" id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"20\" height=\"22\" align=\"center\" title=\"Delete\" onclick=\"checkAreaExistsOrNot('intfarea"+iprows+"','area_id_v3','ospfinterfacev3"+iprows+"','"+tablename+"');\"></image></td>"+
		"<td hidden>0</td>"+
		"<td hidden>"+iprows+"</td>"+
		"<td hidden><input hidden id=\"nwareav3row_val"+iprows+"\"/></td>"
		"</tr>"; 
		$('#interfacev3tab').append(row); 
       reindexTable('interfacev3tab');	
	} 
	else if (tablename == "areaconfigv3")
	{ 
		if (iprows == 6) 
		{ 
			alert("Maximum 5 rows are allowed in OSPF6 Area Table"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("areav3cnt").value = iprows; 
		iprows = document.getElementById("areav3cnt").value; 
		document.getElementById("areav3cnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id=\"ospfareav3"+iprows+"\">"+
		"<td style=\"text-align: center; vertical-align: middle;\">"+iprows+"</td>"+
		"<td><select name=\"area_id_v3"+iprows+"\" class=\"text\" id=\"area_id_v3"+iprows+"\" onfocus='addAreaV3Options(\"area_id_v3"+iprows+"\" )'></select></td>"+
		//"<td><input type=\"text\" name=\"area_type_v3"+iprows+"\" class=\"text\" id=\"area_type_v3"+iprows+"\" onfocusout='checkAreaType(\"area_id_v3"+iprows+"\",\"area_type"+iprows+"\")' value=\"Stub\" readOnly /></td>"+
		"<td><select name=\"area_type_v3"+iprows+"\" class=\"text\" id=\"area_type_v3"+iprows+"\" onfocusout='checkAreaType(\"area_type_v3"+iprows+"\",\"area_type"+iprows+"\")'><option value=\"\"></option><option value=\"Stub\">Stub</option><option value=\"Totally Stub\">Totally Stub</option></select></td>"+
		"<td><input name=\"sum_int_v3"+iprows+"\" type=\"text\" class=\"text\" id=\"sum_int_v3"+iprows+"\" placeholder=\"Enter IPV6 Cidr Notation\" onmouseover=\"setTitle(this)\"  onkeypress=\"return avoidSpace(event);\" onfocusout=\"validateIPv6('sum_int_v3"+iprows+"',false,'Summarise Inter Area',true)\"></td>"+
		"<td><image style=\"cursor:pointer\" id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"20\" height=\"22\" align=\"center\" title=\"Delete\" onclick=\"deleteRow('ospfareav3"+iprows+"','areaconfigv3');\"></image></td>"+
		"<td hidden>0</td>"+
		"<td hidden>"+iprows+"</td>"+
		"</tr>"; 
		$('#areaconfigv3').append(row); 
		addAreaV3Options('area_id_v3'+iprows);
       reindexTable('areaconfigv3');	   
	}
	else if (tablename == "neighconfigv3") //diff ospfv2
	{ 
		if (iprows == 21) 
		{ 
			alert("Maximum 20 rows are allowed in OSPF Network Table"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("neighbourv3cnt").value = iprows; 
		iprows = document.getElementById("neighbourv3cnt").value; 
		document.getElementById("neighbourv3cnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id=\"ospfneighbourv3"+iprows+"\">"+
		"<td style=\"text-align: center; vertical-align: middle;\">"+iprows+"</td>"+
		"<td><input name=\"neighbour_v3"+iprows+"\" type=\"text\" class=\"text\" id=\"neighbour_v3"+iprows+"\" size=\"12\" maxlength=\"15\" onfocusout=\"validateIP('neighbour_v3"+iprows+"',true,'neighbournetwork')\"></td>"+
		"<td><image style=\"cursor:pointer\" id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"20\" height=\"22\" align=\"center\" title=\"Delete\" onclick=\"deleteRow('ospfneighbourv3"+iprows+"','neighconfigv3');\"></image></td>"+
		"<td hidden>0</td>"+
		"<td hidden>"+iprows+"</td>"+
		"</tr>"; 
		$('#neighconfigv3').append(row); 
       reindexTable('neighconfigv3');		
	}
// --------------------------------------- BGP4 ---------------------------
	
else if(tablename == "bgppeersconfig")
	{
		if (iprows == 21) 
		{ 
			alert("Maximum 20 rows are allowed in Peer Record Table"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("bgp_peers_rwcnt").value = iprows; 
		iprows = document.getElementById("bgp_peers_rwcnt").value; 
		document.getElementById("bgp_peers_rwcnt").value = Number(iprows)+1;
		
		var row = "<tr align=\"center\" id=\"bgppeerrow"+iprows+"\">"+
		"<td>"+iprows+"</td>"+
		//"<td><input type=\"text\" class=\"text\" id=\"peer_name"+iprows+"\" name=\"peer_name\"></td>"+
		//"<td><input type=\"number\" readonly  class=\"text\" id=\"main_rtm_as"+iprows+"\" name=\"main_rtm_as\" min=\"1\" max=\"4294967295\" onfocusout=\"validateRange('main_rtm_as"+iprows+"',true,'Remote As')\"></td>"+
		"<td><input type=\"text\" readonly class=\"text\" id=\"bgpname"+iprows+"\" name=\"bgpname"+iprows+"\" maxlength=\"32\" value=\"\"onkeypress=\"return avoidSpace(event) || avoidEnter(event)\"/> </td>"+
		"<td><label class=\"switch\" style=\"vertical-align:middle\"><input type=\"checkbox\" id=\"main_en"+iprows+"\" name=\"main_en"+iprows+"\" style=\"vertical-align:middle\"><span class=\"slider round\"></span></label></td>"+
		
		"<td><button type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"editBgpPeer("+iprows+",'bgpname"+iprows+"')\">Edit <i class='fas fa-edit' style='font-size:12px;color:white'></i></button>"+
		"<image id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"22\" height=\"22\" align=\"right\" title=\"Delete\" onclick=\"deleteBGPRow('bgpname"+iprows+"','"+slnumber+"','"+version+"','bgp_peers');\"></image></td>"+
		"<td hidden>"+iprows+"</td>"+
		"<td hidden><input hidden id=\"bgpPerrow_val"+iprows+"\"/></td>"
		"</tr>"; 
		$('#bgppeersconfig').append(row); 
		reindexTable('bgppeersconfig');
	}

	else if(tablename=="bgppeersettab")
	{
		if (iprows == 21) 
		{ 
			alert("Maximum 20 rows are allowed in Peer Settings Table"); 
			return false; 
		} 

		if (iprows == 1) 
		document.getElementById("bgppeergrpcnt").value = iprows; 
		iprows = document.getElementById("bgppeergrpcnt").value; 
		document.getElementById("bgppeergrpcnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id=\"bgppeergrprow"+iprows+"\">"+
		"<td>"+iprows+"</td>"+
		//"<td><input type=\"text\" class=\"text\" id=\"peergrp_name"+iprows+"\" name=\"peergrp_name\"></td>"+
		//"<td><input type=\"number\" class=\"text\" readonly id=\"grp_rmt_as"+iprows+"\" name=\"grp_rmt_as\" min=\"1\" max=\"4294967295\" onfocusout=\"validateRange('grp_rmt_as"+iprows+"',true,'Remote As')\"></td>"+
		"<td><input type=\"text\" readonly class=\"text\" id=\"pg_name"+iprows+"\" name=\"pg_name"+iprows+"\" maxlength=\"32\" value=\"\"/> </td>"+
		//"<td><label class=\"switch\" style=\"vertical-align:middle\"><input type=\"checkbox\" id=\"pg_main_enable"+iprows+"\" name=\"pg_main_enable"+iprows+"\" style=\"vertical-align:middle\" checked><span class=\"slider round\"></span></label></td>"+
		//"<td><button type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"editBgpPeerSettings("+iprows+")\">Edit <i class='fas fa-edit' style='font-size:12px;color:white'></i></button><image id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"22\" height=\"22\" align=\"right\" title=\"Delete\" onclick=\"deleteRow('bgppeergrprow"+iprows+"','bgppeersettab');\"></image></td>"+
		"<td><button type=\"button\" id=\"bgpseteditrw"+iprows+"\" name=\"bgpseteditrw"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"editBgpPeerSettings("+iprows+")\">Edit</td>"+
		"<td hidden>"+iprows+"</td>"+
		"<td hidden><input hidden id=\"bgprow_val"+iprows+"\"/></td>"
		"</tr>"; 
		$('#bgppeersettab').append(row); 
		reindexTable('bgppeersettab');
	}

	
	else if(tablename == "path_listtab")
	{
		if (iprows == 21) 
		{ 
			alert("Maximum 20 rows are allowed in Path Filtering Table"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("pathlistcnt").value = iprows; 
		iprows = document.getElementById("pathlistcnt").value; 
		document.getElementById("pathlistcnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id=\"bgppathlist"+iprows+"\">"+
		"<td>"+iprows+"</td>"+
		"<td><input type=\"text\" readonly class=\"text\" id=\"path_name"+iprows+"\" name=\"path_name\" maxlength=\"32\" value=\"\"/> </td>"+
		//"<td><label class=\"switch\" style=\"vertical-align:middle\"><input type=\"checkbox\" id=\"path_enable"+iprows+"\" name=\"path_enable"+iprows+"\" style=\"vertical-align:middle\" checked><span class=\"slider round\"></span></label></td>"+
		//"<td><button type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"editBgpPathFiltering("+iprows+")\">Edit <i class='fas fa-edit' style='font-size:12px;color:white'></i></button><image id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"22\" height=\"22\" align=\"right\" title=\"Delete\"  onclick=\"deleteRow('bgppathlist"+iprows+"','path_listtab');\"></image></td>"+
		"<td><button type=\"button\" id=\"bgppathfiteditrw"+iprows+"\" name=\"bgppathfiteditrw"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"editBgpPathFiltering("+iprows+")\">Edit </td>"+
		//"<td><image style=\"cursor:pointer\" id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\30\" height=\"22\" align=\"center\" title=\"Delete\" onclick=\"deleteRows('bgppathlist"+iprows+"','acc_list');\"></image></td>"+
		"<td hidden>"+iprows+"</td>"+
		"<td hidden><input hidden id=\"bgppath_val"+iprows+"\"/></td>"
		//"<td hidden>"+iprows+"</td>"+
		"</tr>"; 
		$('#path_listtab').append(row);
		reindexTable('path_listtab');		
		//addPeerOptions('peer_name'+iprows);		
	}

else if(tablename=="bgppathsummconfig")
{
		if (iprows == 21) 
		{ 
			alert("Maximum 20 rows are allowed in PathSummarization Table"); 
			return false; 
		} 

		if (iprows == 1) 
		document.getElementById("bgp_pathsum_rwcnt").value = iprows; 
		iprows = document.getElementById("bgp_pathsum_rwcnt").value; 
		document.getElementById("bgp_pathsum_rwcnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id=\"bgppathsummrow"+iprows+"\">"+
		"<td>"+iprows+"</td>"+
		"<td><input type=\"text\" readonly class=\"text\" id=\"path_address"+iprows+"\" name=\"path_address"+iprows+"\" maxlength=\"32\" value=\"\"/> </td>"+
		"<td><label class=\"switch\" style=\"vertical-align:middle\"><input type=\"checkbox\" id=\"path_main_enable"+iprows+"\" name=\"path_main_enable"+iprows+"\" style=\"vertical-align:middle\"><span class=\"slider round\"></span></label></td>"+
		"<td><button type=\"button\" id=\"bgppathsummeditrw"+iprows+"\" name=\"bgppathsummeditrw"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"editBgpPathSumm("+iprows+",'"+version+"')\">Edit <i class='fas fa-edit' style='font-size:12px;color:white'></i></button>"+
		"<image id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"22\" height=\"22\" align=\"right\" title=\"Delete\" onclick=\"deleteBGPRow('path_address"+iprows+"','"+slnumber+"','"+version+"','path_summarization');\"></image></td>"+
		"<td hidden><input hidden id=\"bgppathsumm_val"+iprows+"\"/></td>"
		"</tr>"; 
		$('#bgppathsummconfig').append(row); 
		reindexTable('bgppathsummconfig');
	}
	/*bgp4 end*/

	var height = table.rows[1].cells[0].offsetHeight;
	window.scrollBy(0,height);
}


function reindexTable(tablename)
{ 
	var table = document.getElementById(tablename); 
	var rowCount = table.rows.length;
	for (var i = 1; i < rowCount; i++) 
	{ 
		var row = table.rows[i]; 
		row.cells[0].innerHTML = i; 
	} 
}

/*bgp4*/

function fillBgppersetRow(rowid,name,desc,passw,kpalitimer,holdtimer,upsrc,deforg,passive,ttlcheck,ttlhops,nexthop,refclient,serclient)
{
	document.getElementById("pg_name"+rowid).value=name;
	//document.getElementById("pg_main_enable"+rowid).checked=stat;
	document.getElementById("bgprow_val"+rowid).value=name+", "+desc+", "+passw+", "+kpalitimer+", "+holdtimer+", "+upsrc+", "+deforg+", "+passive+", "+ttlcheck+", "+ttlhops+", "+nexthop+", "+refclient+", "+serclient;
}
function fillBgpPathFilteringRow(rowid,name,prefixlist,direc)
{	
	document.getElementById("path_name"+rowid).value=name;
	//document.getElementById("path_enable"+rowid).checked=stat;
	document.getElementById("bgppath_val"+rowid).value=name+", "+prefixlist+", "+direc;	
}
/*bgp4 end*/
function fillBgpPathSummRow(rowid,name,stat,summ,asset)
{
	document.getElementById("path_address"+rowid).value = name;
	document.getElementById("path_main_enable"+rowid).checked=stat;
	var rowdata = document.getElementById("bgppathsumm_val"+rowid);	
	rowdata.value=name+", "+stat+", "+summ+", "+asset;
}
function deleteRow(rowid,tablename) 
{
    document.getElementById(rowid).remove();
	reindexTable(tablename);
}


function fillrow(rowid,network,netmask,netwrkarea)
{
	document.getElementById('network'+rowid).value=network;
	document.getElementById('network_subnet'+rowid).value=netmask;
	document.getElementById('area'+rowid).value=netwrkarea;
}
function fillAreaRow(rowid,areaid,areatype,sumintarea)
{
	document.getElementById('area_id'+rowid).value=areaid;
	document.getElementById('area_type'+rowid).value=areatype;
	document.getElementById('sum_int'+rowid).value=sumintarea;
}
function fillResRow(rowid,links,metype,metric)
{
	document.getElementById('links'+rowid).value=links;
	document.getElementById('metric_type'+rowid).value=metype;
	document.getElementById('metric'+rowid).value=metric;
}

function fill_row(rowid,neighbour)
{
	document.getElementById('neighbour'+rowid).value=neighbour;
}
function editBgpPathFiltering(index)
{
var vals = document.getElementById("bgppath_val"+index).value.split(', ');
	document.getElementById("add_bgppathbgpsubdivpage").value="add_bgppath";
	var bgppeerdiv = document.getElementById("path_filtering");
	bgppeerdiv.style.display = "none";
	var addbgppeerdiv = document.getElementById("add_bgppath");
	addbgppeerdiv.style.display = "";	
	curdiv="add_bgppath";	
	document.getElementById("path_peer_records").value=vals[0];
	//document.getElementById("path_peer_records").disabled= true;
	//document.getElementById("path_enable").checked=vals[1];
	document.getElementById("path_prefix_list").value=vals[1];
	document.getElementById("path_direction").value=vals[2];
}

function deleteRows(rowid,tablename)
{
	 document.getElementById(rowid).remove();
}

/*BGP4*/
function addNewBgpPeer()
{
	var bgppeerdiv = document.getElementById("bgp_peers");
	document.getElementById("add_bgppeerbgpsubdivpage").value="add_bgppeer";
	var addbgppeerdiv = document.getElementById("add_bgppeer");
	var newinstanceobj=document.getElementById("nwinstname");
	var newinstval="";
	if(duplicateInstanceNamesExists("nwinstname","bgppeersconfig"))
		{
			return ;
		}
	newinstval=newinstanceobj.value;
		
		if (newinstval == "")
		{ 
			alert("New Instance Name should not be empty");
			newinstanceobj.style.outline ="thin solid red";
			return false;
		}
		else
		{
			bgppeerdiv.style.display = "none";
			addbgppeerdiv.style.display = "";
			clearPeerRecData();
			document.getElementById("peername").value=newinstval;
			curdiv="add_bgppeer";
		    //curdiv="add_bgppeer?nwinstname="+encodeURIComponent(newinstval);
			//alert(curdiv)
			document.getElementById("bgp_peer_en").checked=true;
		}
}

function editBgpPeer(index,peernameid)
{
	var asinfo = document.getElementById("bgpPerrow_val"+index).value;
	//document.getElementById('add_bgppeerbgpsubdivpage').value="add_bgppeer";
	var bgppeerdiv = document.getElementById("bgp_peers");
	bgppeerdiv.style.display = "none";
	var addbgppeerdiv = document.getElementById("add_bgppeer");
	addbgppeerdiv.style.display = "";
	curdiv="add_bgppeer";
	clearPeerRecData();
	asinfo = asinfo.split('AS ');
	var baseinfo = asinfo[0];
	baseinfo = baseinfo.split(", ");
	if(baseinfo.length > 0)
		document.getElementById('peername').value = baseinfo[1];
	if(baseinfo.length > 1)
		document.getElementById("bgp_peer_en").checked=baseinfo[0];
	for(var i=1;i<asinfo.length;i++)
	{
		if(i > 1)
			addBgpRemSysRow(remsysnum);
		var data = asinfo[i].split(", ");
		if(data.length> 0)
		document.getElementById("bgp_remsys"+(i+1)).value=data[0];
		for(var j=1;j<data.length;j++)
		{
			if(data[j].trim().length == 0)
				continue;
			if(j > 1)
			{
				addNeighbour(remsysnum,neighnum);
			}
			document.getElementById("bgp_remsys"+(i+1)+"nei"+neighnum).value=data[j];
		}
	}
}
function clearPeerRecData()
{
	var table = document.getElementById('peerstab');
	var rows = table.rows;
	
	for(var i=rows.length-1;i>=0;i--)
		rows[i].remove();
	remsysnum=1;
	neighnum=1;
	addBgpRemSysRow(remsysnum);
}
function deletePeerRecord(el,id)
{
//alert("in the deletePeerRecordrow "+id);
    var instance=document.getElementById(id).value;
   	while (el.parentNode && el.tagName.toLowerCase() != 'tr') 
	{
        el = el.parentNode;
	}
    	if (el.parentNode && el.parentNode.rows.length > 1) 
	{
        el.parentNode.removeChild(el);
	}
	
	location.href = "Nomus.cgi?cgi=PeerRecordDeleteInstance="+instance+".cgi";
	reindexTable('bgppeersconfig');
	//curdiv="bgp_peers";

}
function addNewBgpPathSumm()
{
	var bgppathdiv = document.getElementById("path_summarization");
	document.getElementById("add_pathsumbgpsubdivpage").value="add_pathsum";
	var addbgppathdiv = document.getElementById("add_pathsum");
	var newaddrid=document.getElementById("nwaddr");
	var newaddrval="";
	if(duplicateAddressExists("nwaddr","bgppathsummconfig",true))
	{
		return;
	}
	newaddrval=newaddrid.value;
		if (newaddrval == "")
		{ 
			alert("New Address should not be empty");
			newaddrid.style.outline ="thin solid red";
			//bgppathdiv.style.display = "";
			//addbgppathdiv.style.display = "none";
			return false;
			
		}
		else 
		{	
			var valid = validateCIDRNotation('nwaddr',false,'New Address');
			if (!valid)
			{
				alert("New Address is not valid");
				newaddrid.style.outline ="thin solid red";
				return;
			}
			bgppathdiv.style.display = "none";
			addbgppathdiv.style.display = "";
			document.getElementById("oldsumm_addr").value='';
			document.getElementById("summ_addr").value='';
			document.getElementById("summ_addr").readOnly = true;
			document.getElementById("summ_enable").checked=true;
			document.getElementById("summ_flag").checked=true;
			document.getElementById("summ_as_flag").checked=false;
			document.getElementById("summ_addr").value=newaddrval;
			curdiv="add_pathsum";
			
			var form = document.getElementById('pathsum');
			form.action = form.action+"&action=add";
		}
}
function editBgpPathSumm(index,version)
{
	var vals = document.getElementById("bgppathsumm_val"+index).value.split(', ');
	var bgppeerdiv = document.getElementById("path_summarization");
	document.getElementById("add_pathsumbgpsubdivpage").value="add_pathsum";
	bgppeerdiv.style.display = "none";
	var addbgppeerdiv = document.getElementById("add_pathsum");
	addbgppeerdiv.style.display = "";
	curdiv="add_pathsum";
	document.getElementById("oldsumm_addr").value=vals[0];
	var add_obj = document.getElementById("summ_addr");
	add_obj.value=vals[0];
	add_obj.readOnly=false;
	document.getElementById("summ_enable").checked=vals[1];
	document.getElementById("summ_flag").checked=vals[2];
	document.getElementById("summ_as_flag").checked=vals[3];
	
	var form = document.getElementById('pathsum');
	form.action = form.action+"&action=edit"+"&index="+index+"";
}


/*function deletePathSumm(el,id)
{
	//alert("in the deletePeerRecordrow"+id);
    var address=document.getElementById(id).value;
   	while (el.parentNode && el.tagName.toLowerCase() != 'tr') 
	{
        el = el.parentNode;
    	}
    	if (el.parentNode && el.parentNode.rows.length > 1) 
	{
        el.parentNode.removeChild(el);
    }
	reindexTable('bgppathsummconfig');
	location.href = "Nomus.cgi?cgi=PathSummDeleteAddress="+address+".cgi";
}*/
//pallavi
function editBgpPeerSettings(index)
{
	var vals = document.getElementById("bgprow_val"+index).value.split(', ');
	document.getElementById("add_bgppeersetteingsbgpsubdivpage").value="add_bgppeersetteings";
	var bgppeersetdiv = document.getElementById("bgppeersettingsdiv");
	bgppeersetdiv.style.display = "none";
	var addbgppeersetdiv = document.getElementById("add_bgppeersetteings");
	addbgppeersetdiv.style.display = "";
	var ttlhops_ele  = document.getElementById("ttl_hops");
	ttlhops_ele.value = '';
		curdiv="add_bgppeersetteings";
	//checked ,ins1 ,192.168.2.2 ,23.23.23.23 ,10 ,sdhflkn ,checked ' ,
	document.getElementById("peer_records").value=vals[0];
	//document.getElementById("peer_records").disabled= true;
	//document.getElementById("set_enable").checked=vals[1];
	document.getElementById("description").value=vals[1];
	document.getElementById("peer_password").value=vals[2];
	document.getElementById("keep_timer").value=vals[3];
	document.getElementById("hold_timer").value=vals[4];
	document.getElementById("update_source").value=vals[5];
	document.getElementById("defalut_org").checked=vals[6]=='on'?true:false;
	document.getElementById("passive").checked=vals[7]=='on'?true:false;
	document.getElementById("ttl_check").checked=vals[8]=='on'?true:false;
	if(document.getElementById("ttl_check").checked)
		ttlhops_ele.style.display="";
	else
		ttlhops_ele.style.display="none";
	
	document.getElementById("ttl_hops").value=vals[9];
	document.getElementById("nexthop_self").checked=vals[10];
	document.getElementById("reflector_client").checked=vals[11];
	document.getElementById("server_client").checked=vals[12];
}

function deleteBgpPeerSettings(index)
{
	document.getElementById("bgppeergrprow"+index).remove();
}

/*ospfv2 not modified*/

function showSelIntf(id) 
{
	var selintf = document.getElementById(id).value;
	curintfdiv = selintf;
	//if(id == 'loopinterfacecnfg')
		//document.getElementById(id).value = "Loopback";
	 if(id == 'e0interfacecnfg')
		document.getElementById(id).value = "Eth0";
	else if(id == 'e1interfacecnfg')
		document.getElementById(id).value = "Eth1";
	showIntfDiv(selintf);
}

function showIntfDiv(selintf)  //changed this function on 19/08/2022
{
	if(selintf=='Eth0')
	{
		document.getElementById('eth0div').style.display='inline';
		document.getElementById('e0interfacecnfg').value="Eth0";
		document.getElementById('eth1div').style.display='none';		
		checkInterFcost('e1intrfcost','e1intrfcost_check');
	}
	else if(selintf=='Eth1')
	{
		document.getElementById('eth1div').style.display='inline';
		document.getElementById('e1interfacecnfg').value="Eth1";
		document.getElementById('eth0div').style.display='none';
		checkInterFcost('e0intrfcost','e0intrfcost_check');
	}
}
function checkInterFcost(fieldid,chkboxid) //added this function on 19/08/2022
{
	var fieldobj = document.getElementById(fieldid);
	var chkboxobj = document.getElementById(chkboxid);
	if(!chkboxobj.checked && fieldobj.value.trim() == "")
	{
		chkboxobj.checked = false;
		fieldobj.style.outline = "initial";	
	}
} //function ended......
function showPassWord(selintf)
{
	if(selintf=='Eth0')
		showpassword('e0');
	if(selintf=='Eth1')
		showpassword('e1');
	//if(selintf=='Loopback')
		//showpassword('loop');
}

function setMaxLength(cbid,inputid)
{
	optobj = document.getElementById(cbid);
	inputobj = document.getElementById(inputid);
	alert(inputobj);
	if(optobj.value="Plain Text")
		inputobj.maxLength = 8;
	else if(optobj.value="MD5")
		inputobj.maxLength = 16;
	else
		inputobj.maxLength = 0;
}


/*BGP4*/

function isEmpty(id,name)
{
	var ele=document.getElementById(id);
	var val=ele.value;
	if(val == "")
	{
		ele.style.outline= "thin solid red";
		ele.title= name+ " should  not be empty";
		return false;
	}
	else
	{
		ele.style.outline="initial";
		ele.title="";
		return true;
	}	
}
function selectIpNet(id,index)
{
	var ipnetobj = document.getElementById(id);
	var ipnetval = ipnetobj.options[ipnetobj.selectedIndex].text;
	if(ipnetval == "Ip/Netmask") {
		ipnetobj.style.display = 'none';
		var filterobj = document.getElementById("filterdept"+index);
		filterobj.style.display = 'inline';		 
		filterobj.focus();
	}
}
function validOnshowAccListComboBox(id,name,index)
{
	var ipnet_obj = document.getElementById(id);
	if(ipnet_obj != null)
	{
		if(ipnet_obj.value=="Any")
		{
			showAccListComboBox(id,index);
			ipnet_obj.value = "";
			return true;
		}	
	}
}
function showAccListComboBox(id,index) 
{
	var inputobj = document.getElementById(id);
	var selectobj = document.getElementById("filters_nw"+index);
	/*if (filtersobj.value.trim() != "")
	{
		if (ipnetsobj.length == 4)		
			ipnetsobj.remove(0);
		var newOption = document.createElement('option');
		newOption.value = filtersobj.value.trim();
		newOption.innerHTML=filtersobj.value.trim();
		ipnetsobj.add(newOption,0);
	}*/
	inputobj.style.display = 'none';	
	selectobj.style.display = 'inline';	
	selectobj.selectedIndex = 0;
				
		
}
function addBgpNetrkRow(rowid)
{
	var table = document.getElementById("bgpnetworktab");
	if(table.rows.length >=5)
	{
		alert("Max 5 rows are allowed");
		return;
	}
	//var ct = document.getElementById("bgpnwcnt").value;
	bgpnetwork++;
	var remove=document.getElementById("removebgpnetrk"+rowid);
	var add=document.getElementById("addbgpnetrk"+rowid);
	//Modifided from this line
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline";
	//Modified till this line
	$("#bgpnetworktab").append("<tr id=\"netr"+bgpnetwork+"\"><td><div>Network</div></td><td width=\"195\"><div><input type=\"text\" class=\"text\" id=\"bgp_netk"+bgpnetwork+"\" name=\"bgp_netk"+bgpnetwork+"\" style='position: relative; left: 3px;display:inline block' onkeypress=\"return avoidSpace(event);\" placeholder=\"(192.168.1.0/24)\" onfocusout=\"validateCIDRNotation('bgp_netk"+bgpnetwork+"',false,'Network')\"><label class=\"add\" id=\"addbgpnetrk"+bgpnetwork+"\" style=\"font-size: 17px; margin-left:7px;color:green;display: inline;\" onclick=\"addBgpNetrkRow("+bgpnetwork+")\">+</label><label class=\"remove\" style=\"display: inline; font-size: 15px;margin-left:5px; color:red;\" id=\"removebgpnetrk"+bgpnetwork+"\" onclick=\"deleteBgpNetrkTableRow("+bgpnetwork+")\">x</label><input id=\"row"+bgpnetwork+"\" value=\""+bgpnetwork+"\" hidden=\"\"></div></td></tr>");
	document.getElementById("bgpnwcnt").value = bgpnetwork;
	adjtabFircol('bgpnetworktab','Network');
}
function deleteBgpNetrkRow(rowid)
{
	var ele = document.getElementById("netr"+rowid);
	$('table#bgpnetworktab tr#netr'+rowid).remove();
	adjtabFircol('bgpnetworktab','Network');//modified this line
	
}
function deleteBgpNetrkTableRow(row)
{
	
	deleteBgpNetrkRow(row);
	findBgpNetLastRowAndDisplayRemoveIcon();
	adjtabFircol('bgpnetworktab','Network');
	
}
function findBgpNetLastRowAndDisplayRemoveIcon()
{
	var table = document.getElementById("bgpnetworktab");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[1].childNodes[0].childNodes[1];
	var removeobj = lastrow.cells[1].childNodes[0].childNodes[2];
	//alert(addobj+" "+removeobj);
	addobj.style.display="inline";
	if(table.rows.length > 5) 
		removeobj.style.display="inline";
		
	else if(table.rows.length == 5)
		removeobj.style.display="none";
}
function adjtabFircol(tabname,setname)
{
	var table = document.getElementById(tabname);
	var rows = table.rows;
	
	var index = 0;
	if(tabname == "bgpnetworktab")
		index = 6;
	
	for(var i=index;i<rows.length;i++)
	{
		if(i==index)
		{
			rows[i].cells[0].innerHTML = setname;//modified this line
	    }
		else
		{
			rows[i].cells[0].innerHTML = "";
		}
	}
	//Modified from this line
	if(rows.length == (index+1))
	{
		rows[index].cells[1].childNodes[0].childNodes[1].style.display="inline";
		rows[index].cells[1].childNodes[0].childNodes[2].style.display="none";
	}
	//Modified till this line
	
}
////Remote Autonomus System Number  

function addBgpRemSysRow(rowid)
{
	var table = document.getElementById("peerstab");
	if(table.rows.length >=5)
	{
		alert("Max 5 rows are allowed");
		return;
	}
	if(table.rows.length==0)
		remsysnum=1;
	else 
	remsysnum = parseInt(document.getElementById("bgpremnumcnt").value);

	remsysnum++;
	var remove=document.getElementById("removebgpremnum"+rowid);
	var add=document.getElementById("addbgpremnum"+rowid);
	//Modifided from this line
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline";
	//Modified till this line
	//$("#peerstab").append("<tr id=\"remauto"+remsysnum+"\"><td><div>Remote Autonomus System Number(1-4294967295)</div></td><td><div><input type=\"text\" class=\"text\" id=\"bgp_remsys"+remsysnum+"\" name=\"bgp_remsys"+remsysnum+"\" style='position: relative; right:15px;display:inline block'><label class=\"add\" id=\"addbgpremnum"+remsysnum+"\" style=\"font-size: 17px;padding-left:3px;color:green;display: inline;\" onclick=\"addBgpRemSysRow("+remsysnum+")\">+</label><label class=\"remove\" style=\"display: inline; font-size: 15px;margin-left:5px; color:red;\" id=\"removebgpremnum"+remsysnum+"\" onclick=\"deleteBgpRemSysTableRow("+remsysnum+")\">x</label><input id=\"row"+remsysnum+"\" value=\""+remsysnum+"\" hidden=\"\"></div></td></tr><tr id=\"neiaddr"+remsysnum+"\"><td><div>Neighbour Address</div></td><td><div><input type=\"text\" class=\"text\" id=\"bgp_neigh"+remsysnum+"\" name=\"bgp_neigh"+remsysnum+"\" style='position: relative; right:15px;display:inline block' onkeypress=\"return avoidSpace(event);\" placeholder=\"(192.168.1.0/24)\" onfocusout=\"validateCIDRNotation('bgp_neigh"+remsysnum+"',false,'Neighbour Address')\"><label class=\"add\" id=\"addbgpremnum"+remsysnum+"\" style=\"font-size: 17px;padding-left:3px;color:green;display: inline;\" onclick=\"addBgpRemSysRow("+remsysnum+")\">+</label><label class=\"remove\" style=\"display: inline; font-size: 15px;margin-left:5px; color:red;\" id=\"removebgpremnum"+remsysnum+"\" onclick=\"deleteBgpRemSysTableRow("+remsysnum+")\">x</label><input id=\"row"+remsysnum+"\" value=\""+remsysnum+"\" hidden=\"\"></div></td></tr>");	
	$("#peerstab").append("<tr id=\"remauto"+remsysnum+"\"><td valign='top' style=\"width:250px;\"><div>Remote Autonomus System Number(1-4294967295)</div></td><td><div id='peersdiv'><input type=\"number\" class=\"text\" id=\"bgp_remsys"+remsysnum+"\" min=\"1\" max=\"4294967295\"name=\"bgp_remsys"+remsysnum+"\" style='position: relative;display:inline block' onkeypress=\"return avoidSpace(event);\" onfocusout=\"validateRange('bgp_remsys"+remsysnum+"',true,'Remote Autonomus System Number(1-4294967295)')\" ><label class=\"add\" id=\"addbgpremnum"+remsysnum+"\" style=\"font-size: 17px;padding-left:3px;color:green;display: inline;\" onclick=\"addBgpRemSysRow("+remsysnum+")\">+</label><label class=\"remove\" style=\"display: inline; font-size: 15px;margin-left:5px; color:red;\" id=\"removebgpremnum"+remsysnum+"\" onclick=\"deleteBgpRemSysTableRow("+remsysnum+")\">x</label><input id=\"row"+remsysnum+"\" value=\""+remsysnum+"\" hidden=\"\">"
	+"<div id=\"peer"+remsysnum+"neighboursdiv\" style=\"max-width:240px;border:1px solid black;padding-left:0px;\"><label style=\"padding-top:15px;\">Neighbour Address</label><div id="+remsysnum+""+neighnum+"><input type=\"text\" class=\"text\" id=\"bgp_remsys"+remsysnum+"nei"+neighnum+"\" name=\"bgp_remsys"+remsysnum+"nei"+neighnum+"\" placeholder=\"(192.168.2.24)\"style='position: relative;display:inline block' onkeypress=\"return avoidSpace(event)\" onfocusout=\"validateIPOnly('bgp_remsys"+remsysnum+"nei"+neighnum+"',true,'Neighbour Address ')\"><label class=\"add\" id=\""+remsysnum+"addneighbour"+neighnum+"\" style=\"font-size: 17px;padding-left:3px;color:green;display: inline;\" onclick=\"addNeighbour("+remsysnum+","+neighnum+")\">+</label><label class=\"remove\" style=\"display: none; font-size: 15px;margin-left:5px; color:red;\" id=\""+remsysnum+"removeneighbour"+neighnum+"\" onclick=\"deleteNeighbour('peer"+remsysnum+"neighboursdiv','"+remsysnum+"','"+neighnum+"')\">x</label><input id=\"row"+neighnum+"\" value=\""+neighnum+"\" hidden=\"\"></div> </div></div></td></tr>");
	//<tr id=\"neiaddr"+remsysnum+"\"><td><div>Neighbour Address</div></td><td><div><input type=\"text\" class=\"text\" id=\"bgp_neigh"+remsysnum+"\" name=\"bgp_neigh"+remsysnum+"\" style='position: relative; right:15px;display:inline block' onkeypress=\"return avoidSpace(event);\" placeholder=\"(192.168.1.0/24)\" onfocusout=\"validateCIDRNotation('bgp_neigh"+remsysnum+"',false,'Neighbour Address')\"><label class=\"add\" id=\"addbgpremnum"+remsysnum+"\" style=\"font-size: 17px;padding-left:3px;color:green;display: inline;\" onclick=\"addBgpRemSysRow("+remsysnum+")\">+</label><label class=\"remove\" style=\"display: inline; font-size: 15px;margin-left:5px; color:red;\" id=\"removebgpremnum"+remsysnum+"\" onclick=\"deleteBgpRemSysTableRow("+remsysnum+")\">x</label><input id=\"row"+remsysnum+"\" value=\""+remsysnum+"\" hidden=\"\"></div></td></tr>");	
	document.getElementById("bgpremnumcnt").value = remsysnum;
	adjtabFircol('peerstab','Remote Autonomus System Number(1-4294967295)');
}


function deleteBgpRemSysRow(rowid)
{
	var ele = document.getElementById("remauto"+rowid);
	$('table#peerstab tr#remauto'+rowid).remove();
	adjtabFircol('peerstab','Remote Autonomus System Number(1-4294967295)');//modified this line
	
}
function deleteBgpRemSysTableRow(row)
{
	deleteBgpRemSysRow(row);
	findBgpRemSysLastRowAndDisplayRemoveIcon();
	adjtabFircol('peerstab','Remote Autonomus System Number(1-4294967295)');
	
}
function findBgpRemSysLastRowAndDisplayRemoveIcon()
{
	var table = document.getElementById("peerstab");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[1].childNodes[0].childNodes[1];
	var removeobj = lastrow.cells[1].childNodes[0].childNodes[2];
	//alert(addobj+" "+removeobj);
	addobj.style.display="inline";
	if(table.rows.length > 5) 
		removeobj.style.display="inline";
		
	else if(table.rows.length == 5)
		removeobj.style.display="none";
}
function adjtabFircol(tabname,setname)
{
	var table = document.getElementById(tabname);
	var rows = table.rows;
	
	var index = 0;
	if(tabname == "peerstab")
		index = 0;
	for(var i=index;i<rows.length;i++)
	{
		if(i==index)
		{
			rows[i].cells[0].innerHTML = setname;//modified this line
	    }
		else
		{
			rows[i].cells[0].innerHTML = "";
		}
	}
	//Modified from this line
	if(rows.length == (index+1))
	{
		rows[index].cells[1].childNodes[0].childNodes[1].style.display="inline";
		rows[index].cells[1].childNodes[0].childNodes[2].style.display="none";
	}
	//Modified till this line
	
}
function fillBgpRenSysNumRow(rowid,remnum)
{
	document.getElementById('bgp_remsys'+rowid).value=remnum;
}



function setNeighbourConfig()
{
	if(document.getElementById("as").value == document.getElementById("pg_rmt_as").value)
		addNCOptions('all');	
	else
		addNCOptions('req');
	
}
function addNCOptions(opt)
{
	selobj = document.getElementById("neiconf");
	for(var i = selobj.options.length - 1; i >= 0; i--)
		selobj.remove(i);
	var opts_arr=["None","Remote Reflector Client","Remote Server Client"];
	if(opt == "req")
		opts_arr=["None","Remote Server Client"];
	for(var i=0;i<opts_arr.length;i++)
	{
		var opt = document.createElement('option');
		opt.value = opts_arr[i];
		opt.innerHTML = opts_arr[i];
		selobj.appendChild(opt);
	}
}
function addPeerOptions(id)
{
	var bgpPeerRows = document.getElementById("bgp_peers_rwcnt").value;
	var bgpPgrpRows = document.getElementById("bgppeergrpcnt").value;
	selobj = document.getElementById(id);
	for(var i = selobj.options.length - 1; i >= 0; i--)
		selobj.remove(i);
	const namap = new Map();
	for(var i=1;i<bgpPgrpRows;i++)
	{
		var bgpgrprowval = document.getElementById("bgprow_val"+i);
		if(bgpgrprowval != null)
		{
			var vals = bgpgrprowval.value.split(",");
			namap.set(vals[3].trim(),vals[1].trim());
			var opt = document.createElement('option');
			opt.value = vals[1].trim();
			opt.innerHTML = vals[1].trim();
			selobj.appendChild(opt);
		}
	}
	for(i=1;i<bgpPeerRows;i++)
	{
		var rtm_addr = document.getElementById("main_rtm_addr"+i);
		
		if(rtm_addr != null && !namap.has(rtm_addr.value))
		{		
			var opt = document.createElement('option');
			opt.value = rtm_addr.value;
			opt.innerHTML = rtm_addr.value;
			selobj.appendChild(opt);
		}			
	}
	
}
/*function setBgpInsVal()
{
	//alert("in the function setBgpInsVal");
	var bgp_ins_ids = ["ins_enable","admindis"];
	var bgpinsvals = "";
	for(var i=0;i<bgp_ins_ids.length;i++)
	{
		if(bgp_ins_ids[i] == "ins_enable")
			bgpinsvals += document.getElementById(bgp_ins_ids[i]).checked;
		else
			bgpinsvals += document.getElementById(bgp_ins_ids[i]).value;
		if(i < bgp_ins_ids.length-1)
			bgpinsvals += " ,";
	
	}
	//alert("bgpinsvals  : "+bgpinsvals);
	//document.getElementById("old_bgp_ins_val").value = bgpinsvals;
}
function bgpModified()
{
	var enable = document.getElementById("ins_enable").checked+"";
	var asval = document.getElementById("admindis").value;
	//var ins_vals = document.getElementById("old_bgp_ins_val").value.split(" ,");
	if(asval != ins_vals[1].trim() )
		return true;
	else
		return false;
}*/
function fillBgpPeerRow(rowid,stat,name,totalinfo)
{
	document.getElementById("main_en"+rowid).checked = stat;
	document.getElementById("bgpname"+rowid).value = name;
	document.getElementById("bgpPerrow_val"+rowid).value =stat+", "+name+", "+totalinfo;
}
function fillBgpNetrkRow(rowid,network)
{
	document.getElementById('bgp_netk'+rowid).value=network;
}
/*BGP END*/

/*function showGlobIntfhiderows()
{
	var chk_arr=["dfo","conn","stat","rip","bgp"];
	var row_arr1=["def_org","met","stat_met","rip_met","bgp_met"];
	var row_arr2=["def_org","met_type","stat_met_type","rip_met_type","bgp_met_type"];

	for(var i=0;i<chk_arr.length;i++)
	{
		var chkb_obj = document.getElementById(chk_arr[i]);
		if(chkb_obj.checked)
		{
			document.getElementById(row_arr1[i]).style.display="";
			document.getElementById(row_arr2[i]).style.display="";
		}
		else
		{
			document.getElementById(row_arr1[i]).style.display="none";
			document.getElementById(row_arr2[i]).style.display="none";
		}
	}
}
*/
//////// new functions added 19/08/2022
//for OSPF
/////modified from here on 30-8-2022
function setOSPFAreaType(prefix,id)
{
		var ospfarea = document.getElementById(prefix+"ospf_area").value;
		
		var ospfareatype = document.getElementById(prefix+"ospf_area_type");
		if(ospfarea == 0)
		{
			if(id==prefix+"ospf_area_type")
				alert("OSPF Area Type should be NONE as OSPF area is 0");
			ospfareatype.value="normal";
			
			document.getElementById(prefix+"ospf_a_type_hid").value="normal";
		}
		else
		{	
			hidden_obj = document.getElementById(prefix+"ospf_a_type_hid");
			if(ospfareatype.value == "normal")
			{
				if(id==prefix+"ospf_area_type")
				{
					alert("OSPF Area Type should not be NONE as OSPF area is not 0");
					ospfareatype.value=document.getElementById(prefix+"ospf_a_type_hid").value;
				}
				else if(hidden_obj.value == "normal" ||hidden_obj.value.trim()=="" )
				{
					ospfareatype.value = "stub";
				}
			}
			document.getElementById(prefix+"ospf_a_type_hid").value = ospfareatype.value;
		}

}
//////// modification ended
function getNetwork(ip,subnet)
{
	var ip_arr = ip.split(".");
	var subnet_arr = subnet.split(".");
	var network="";
	for(var i=0;i<ip_arr.length;i++)
	{
		network += ip_arr[i]&subnet_arr[i];
		if(i<ip_arr.length-1)
			network+=".";
	}
	return network;
}
function getBroadcast(network,subnet)
{
	var net_arr = network.split(".");
	var subnet_arr = subnet.split(".");
	var inv_sub_arr=[255-subnet_arr[0],255-subnet_arr[1],255-subnet_arr[2],255-subnet_arr[3]];
	var broadcast="";
	for(var i=0;i<net_arr.length;i++)
	{
		broadcast += net_arr[i]|inv_sub_arr[i];
		if(i<net_arr.length-1)
			broadcast+=".";
	}
	return broadcast;

}
function isIntfPwdEmpty(intfname)
{ 
	var intf_pwd_map=new Map();
	intf_pwd_map.set("LAN","e0pwd");
	intf_pwd_map.set("WAN","e1pwd");
	//intf_pwd_map.set("Loopback","looppwd");
	
	var intf_authchk_map=new Map();
	intf_authchk_map.set("LAN","e0authentication");
	intf_authchk_map.set("WAN","e1authentication");
	//intf_authchk_map.set("Loopback","loopauthentication");
	
	if(intf_pwd_map.has(intfname))
	{
		var auth_obj = document.getElementById(intf_authchk_map.get(intfname));
		var pwd_obj = document.getElementById(intf_pwd_map.get(intfname));
		if(auth_obj.value!="disabled" && pwd_obj.value.trim() == "")
			return true;
	}
	return false;
}

/////////////// BGP4 Modification starts ////////////
function loadInstanceNameIndex(id)
{		
alert("in the loadInstanceNameIndex");
	oldinstname="";
	if(document.getElementById(id).value == "")
	{
		return;
	}
	instid=id;
	oldinstname=document.getElementById(id).value;
}
function duplicateInstanceNamesExists(id,tablename,name)
{
	//alert("in the duplicateInstanceNamesExists nwinstname " + id +" "+tablename);
	var dupexists=false;
    var table = document.getElementById(tablename);
	var rowcnt = table.rows.length;
	var obj=document.getElementById(id);
	var name=obj.value;
	if(name == "")
	{
		obj.style.outline ="thin solid red";
		if(tablename == "bgppeersconfig")				
		obj.title="New Instance Name  should not be empty";
	}
	else
	{
		obj.title="";
	}
	if(tablename == "bgppeersconfig")
	{
		var displaystr = "New Instance Name";
		var bgppeertab=document.getElementById("bgppeersconfig");
		var rowsize=bgppeertab.rows.length;
		for(var i=1;i<rowsize;i++)
		{
			var insname=bgppeertab.rows[i].cells[1].children[0].value;
			if(insname == name && insname != "")
			{
				alert(name+" already exists");
				dupexists= true;
				document.getElementById(id).style.outline="thin solid red";
				
				break;
			}
		}
	}
	return dupexists;
}

// new function added on 2-9-22
function checkIsDuplicateArea(prefix,suffix)
{
	//var prefix_arr = ["e0","e1","loop"];
	//var intf_arr = ["Eth0","Eth1","Loopback"];
	var prefix_arr = ["e0","e1"];
	var intf_arr = ["Eth0","Eth1"];
	
	var area_obj = document.getElementById(prefix+suffix);
	var area_val = area_obj.value;
	for(var i=0;i<prefix_arr.length;i++)
	{
		if(prefix != prefix_arr[i])
		{
			var value = document.getElementById(prefix_arr[i]+suffix).value;
			if(value == area_val)
			{
				area_obj.style.outline= "thin solid red";
				area_obj.title=area_val+" is already exists for the Interface "+intf_arr[i];
				return intf_arr[i];
			}
										
		}
	}
	area_obj.style.outline="initial";
	area_obj.title="";
	return "";
}

/*function hideAreaType(id1,id2)
{
	
	var areaobj=document.getElementById(id1);
	var areatypeobj=document.getElementById(id2);
	if(areaobj.value==0)
		areatypeobj.style.display = "none";
	else
		areatypeobj.style.display = "";
}*/

//  new function on 20/12/22
function hideTTLGenCheck(id1,id2)
{
	var ttlobj=document.getElementById(id1);
	var ttlcheckobj=document.getElementById(id2);
	if(ttlobj.checked)
		ttlcheckobj.style.display = "";
	else
		ttlcheckobj.style.display = "none";
}
function hideDefalutInfoOrg()
{

	var defalutobj=document.getElementById("dfo");
	var spnobj=document.getElementById("span_dfo_alw");
	var typeobj=document.getElementById("dfo_alw");
	if(defalutobj.checked)
		spnobj.style.display="";
	else
	{
		spnobj.style.display="none";
		typeobj.checked="";
	}
}
function hideInterConfig(id1,id2)
{
	var advobj=document.getElementById(id1);
	var interconfigobj=document.getElementById(id2);
	if(advobj.checked)
		interconfigobj.style.display="";
	else
		interconfigobj.style.display="none";
}
function hideAutoFields(id1,id2)
{
	var obj=document.getElementById(id1);
	var autoobj=document.getElementById(id2);
	if(autoobj.checked)
		obj.style.display="none";
	else
		obj.style.display="";	
}	


function addAreaOptions(id)
{   
	var nwRows = document.getElementById("netwrkrwcnt").value;
	selobj = document.getElementById(id);
	const namap = new Map();
	for(var i = selobj.options.length - 1; i >= 0; i--)
		selobj.remove(i);
	for(var i=1;i<nwRows;i++)
	{
		var areaobj = document.getElementById("area"+i);		
		if(areaobj != null)
		{
			if(namap.get(areaobj.value) === undefined)	
				namap.set(areaobj.value,areaobj.value);				
			else
				continue;
			var opt = document.createElement('option');
			opt.value = areaobj.value;
			opt.innerHTML = areaobj.value;
			selobj.appendChild(opt);
		}
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
/*
isNetworkOVerlaped
*/
/*function addPeerRecOptions(id1,id2,id3)
{
	//alert("addPeerRecOptions function");
	//var bgpPeerRows = document.getElementById("bgp_peers_rwcnt").value;
	var bgpPeerRows = document.getElementById(id1).value;
	selobj = document.getElementById(id3);
	const namap = new Map();
	
	for(var i = selobj.options.length - 1; i >= 0; i--)
	{
		var opt = selobj.options[i];
		if(opt.selected)
			namap.set(opt.value,opt.value);
		selobj.remove(i);
	}
	
	var bgprowval="";
	for(var i=1;i<bgpPeerRows;i++)
	{
		 //bgprowval = document.getElementById("bgpPerrow_val"+i);
	 bgprowval = document.getElementById(id2+i);
		if(bgprowval != null)
		{
			var vals = bgprowval.value.split(",");
			
			var opt = document.createElement('option');
			opt.value = vals[1].trim();
			opt.innerHTML = vals[1].trim();
			if(namap.get(opt.value) != null)
				opt.selected = 'true';
			selobj.appendChild(opt);
		}
	}
	/*var opt = document.createElement('option');
			opt.value = 'Neighbour IP';
			opt.innerHTML = 'Neighbour IP';
			selobj.appendChild(opt);*/
//}

/*var mousein = false;
function mouseInAction()
{
	addPeerShutdownOptions('bgp_peers_rwcnt','bgpPerrow_val','instance_shutdown');
}

function addPeerShutdownOptions(id1,id2,id3)
{
	//alert("addPeerRecOptions function");
	//var bgpPeerRows = document.getElementById("bgp_peers_rwcnt").value;
	try
	{
	if(mousein)
		return;
	mousein = true;
	//alert(mousein);
	var bgpPeerRows = document.getElementById(id1).value;
	selobj = document.getElementById(id3);
	const namap = new Map();
	for(var i = selobj.options.length - 1; i >= 0; i--)
	{
		var opt = selobj.options[i];
		if(opt.selected)
		namap.set(opt.value,opt.value);
		selobj.remove(i);
	}
	var bgprowval="";
	var display =selobj.style.display;
	$('#instance_shutdown').multiselect('destroy');
	for(var i=1;i<bgpPeerRows;i++)
	{
		 //bgprowval = document.getElementById("bgpPerrow_val"+i);
		bgprowval = document.getElementById(id2+i);
		if(bgprowval != null)
		{
			var vals = bgprowval.value.split(",");			
			var opt = document.createElement('option');
			opt.value = vals[1].trim();
			opt.innerHTML = vals[1].trim();
			if(namap.get(opt.value) != null)
				opt.selected = 'true';
			selobj.appendChild(opt);
		}
	}
		$('#instance_shutdown').multiselect({
		  buttonWidth: '150px',
		  numberDisplayed:1,
	   });
	}
	catch(e)
	{
		alert(e);
	}
}
*/
function addNeighbour(remsysnumcnt,neicnt)
{
	var remove=document.getElementById(remsysnumcnt+"removeneighbour"+neighnum);
	var add=document.getElementById(remsysnumcnt+"addneighbour"+neighnum);
	//Modifided from this line
	
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline";
	//Modified till this line
	//var divobj = document.getElementById("peer"+remsysnum+"neigh"+neighnum);
	var divid = "peer"+remsysnumcnt+"neighboursdiv";
	var divobj = document.getElementById(divid);
	neighnum++;
	$("#"+divid).append("<div id="+remsysnumcnt+""+neighnum+"><input type=\"text\" class=\"text\" id=\"bgp_remsys"+remsysnumcnt+"nei"+neighnum+"\" name=\"bgp_remsys"+remsysnumcnt+"nei"+neighnum+"\" style='position: relative;display:inline block' onkeypress=\"return avoidSpace(event)\" placeholder=\"(192.168.2.24)\"onfocusout=\"validateIPOnly('bgp_remsys"+remsysnumcnt+"nei"+neighnum+"',true,'Neighbour Address')\"><label class=\"add\" id=\""+remsysnumcnt+"addneighbour"+neighnum+"\" style=\"font-size: 17px;padding-left:3px;color:green;display: inline;\" onclick=\"addNeighbour("+remsysnumcnt+","+neighnum+")\">+</label><label class=\"remove\" style=\"display: inline; font-size: 15px;margin-left:5px; color:red;\" id=\""+remsysnumcnt+"removeneighbour"+neighnum+"\" onclick=\"deleteNeighbour('peer"+remsysnumcnt+"neighboursdiv','"+remsysnumcnt+"','"+neighnum+"')\">x</label><input id=\"row"+neighnum+"\" value=\""+neighnum+"\" hidden=\"\"></div>");	
	document.getElementById("bgpneighnumcnt").value = neighnum;
	adjNeightabFircol(remsysnumcnt);
}
function deleteNeighbour(neidivid,remsysnum,neighnum)
{
	var divid = remsysnum+""+neighnum;
	document.getElementById(divid).remove();
	findNeighLRowAndDisRemoveIcon(neidivid);
}
function findNeighLRowAndDisRemoveIcon(neidivid)
{
	var neidivobj=document.getElementById(neidivid);
	//alert(remsysnum+" neighnum="+neighnum+" "+removeobj);
	var childdivs=neidivobj.children;

	if(childdivs.length == 2)
	{	
		lastdiv = childdivs[1];
		var childs = lastdiv.children;
		childs[1].style.display="inline";
		childs[2].style.display="none";
	}
	else
	{
		lastdiv = childdivs[childdivs.length-1];
		var childs = lastdiv.children;
		childs[1].style.display="inline";
		childs[2].style.display="inline";
	}
}
function adjNeightabFircol(remsysnumcnt)
{ 
	var outneidivobj = document.getElementById("peer"+remsysnumcnt+"neighboursdiv");
	var childs =  outneidivobj.children;
	if(childs.length > 1)
	{
		var inneidivobj = childs[childs.length-2];
		inneidivobj.children[1].style.display = 'none';
		inneidivobj.children[2].style.display = '';
	}	
}
/*function PeerCustomOptions(id,txtval,neiip)
{
  var peerselobj=document.getElementById(id);
  var neighipobj=peerselobj.options[peerselobj.selectedIndex].text;
  
  if((neighipobj=="Neighbour IP"))
  {
	    peerselobj.style.display = 'none';
		var neighiptxtobj = document.getElementById(neiip);
		neighiptxtobj.style.display = 'inline';
		neighiptxtobj.value = txtval;
		neighiptxtobj.focus();
   }
}
function validOnshowPeerComboBox(id,name,id1,id2)
{
  var peerneiipobj = document.getElementById(id);
  var peerobj = document.getElementById(id2);
  document.getElementById(id1).value=peerneiipobj.value;
  if(peerneiipobj.value.trim() == "")
  {
	  peerneiipobj.style.display = 'none';
	  peerobj.style.display = 'inline';
	  peerobj.selectedIndex = 0;
  }
  else
	  validateIPOnly(id,false,name);
}*/
function duplicateAddressExists(id,tablename,showpopup)
{
	//alert("in the duplicateAddressExists" + id +" "+tablename);
	var dupexists=false;
    var table = document.getElementById(tablename);
	var rowcnt = table.rows.length;
	var obj=document.getElementById(id);
	var name=obj.value;
	if(name == "")
	{
		obj.style.outline ="thin solid red";
		if(tablename == "bgppathsummconfig")				
		obj.title="New Address  should not be empty";
	}
	else
	{
		obj.title="";
	}
	if(tablename == "bgppathsummconfig")
	{
		var displaystr = "New Address";
		var bgppathtab=document.getElementById("bgppathsummconfig");
		var rowsize=bgppathtab.rows.length;
		for(var i=1;i<rowsize;i++)
		{
			var insname=bgppathtab.rows[i].cells[1].children[0].value;
			if(insname == name && insname != "")
			{
				if(showpopup)
				alert(name+" already exists");
				dupexists= true;
				document.getElementById(id).style.outline="thin solid red";
				break;
			}
		}
	}
	return dupexists;
}
// ----------------------------- new functions for OSPFV3 --------------------------
function hideDefalutInfoOrg3()
{

	var defalutobj=document.getElementById("dfo_v3");
	var spnobj=document.getElementById("span_dfo_alw_v3");
	var typeobj=document.getElementById("dfo_alw_v3");
	if(defalutobj.checked)
		spnobj.style.display="";
	else
	{
		spnobj.style.display="none";
		typeobj.checked="";
	}
}
/*function showPassWordV3(selintf)
{
	if(selintf=='Eth0')
		showpassword('e0');
	if(selintf=='Eth1')
		showpassword('e1');
}*/
function addAreaV3Options(id)
{   
	var nwRows = document.getElementById("intfv3rwcnt").value;
	selobj = document.getElementById(id);
	const namap = new Map();
	for(var i = selobj.options.length - 1; i >= 0; i--)
		   selobj.remove(i);
	for(var i=1;i<nwRows;i++)
	{
		var areaobj = document.getElementById("intfarea"+i);		
		if(areaobj != null)
		{
			if(namap.get(areaobj.value) === undefined)	
				namap.set(areaobj.value,areaobj.value);				
			else
				continue;
			var opt = document.createElement('option');
			opt.value = areaobj.value;
			opt.innerHTML = areaobj.value;
			selobj.appendChild(opt);
		}
	}	
}
function showSelIntfV3(id)
{
	var selintfv3 = document.getElementById(id).value;
	curintfv3div = selintfv3;
	 if(id == 'e0interfacecnfg_v3')
		document.getElementById(id).value = "Eth0";
	else if(id == 'e1interfacecnfg_v3')
		document.getElementById(id).value = "Eth1";
	showIntfV3Div(selintfv3);
}
function showIntfV3Div(selintfv3) 
{
	if(selintfv3 == 'Eth0')
	{
		document.getElementById('eth0div_v3').style.display='inline';
		document.getElementById('e0interfacecnfg_v3').value="Eth0";
		document.getElementById('eth1div_v3').style.display='none';		
		checkInterFcost('e1intrfcost_v3','e1intrfcost_check_v3');
	}
	else if(selintfv3=='Eth1')
	{
		document.getElementById('eth1div_v3').style.display='inline';
		document.getElementById('e1interfacecnfg_v3').value="Eth1";
		document.getElementById('eth0div_v3').style.display='none';
		checkInterFcost('e0intrfcost_v3','e0intrfcost_check_v3');
	}
}
function fillOspf3Intf(rowid,intf,infarea)
{
	document.getElementById("intfce"+rowid).value = intf;
	document.getElementById("intfarea"+rowid).value = infarea;	
}
function fillOspf3area(rowid,areaid,type,summint)
{
    document.getElementById("area_id_v3"+rowid).value=areaid;
	document.getElementById("area_type_v3"+rowid).value=type;
	document.getElementById("sum_int_v3"+rowid).value=summint;
}
function checkAreaExistsOrNot(nwarea,arearow,rowid,tableid) 
{
var nwareaval=document.getElementById(nwarea);
var areain="";
if(arearow=="area_id")
	areain= document.getElementById("areacnt").value;
else
	areain= document.getElementById("areav3cnt").value;
	for(var j = 1; j < areain; j++) {
		var areaval=document.getElementById(arearow+j);
		if(areaval==null)
			continue;
		else
		{
			 if(nwareaval.value.trim() == areaval.value.trim()){
			alert("This Area " + nwareaval.value.trim() + " exists In Area Section , 1st Remove Areaid " +nwareaval.value.trim()+ " in Area Section \n");
			return;
			 }
		}
		}
	    deleteRow(rowid,tableid);
}
function deleteBGPRow(id,slnumber,version,page)
{
	var peername=document.getElementById(id).value;
	location.href = "savedetails.jsp?slnumber="+slnumber+"&page="+page+"&name="+encodeURIComponent(peername)+"&version="+version+"&action=delete";
}
function fillPeerRecordData(peerdata)
{
	peerdata = peerdata.split("AS ");
	var baseinfo = peerdata[0];
	baseinfo = baseinfo.split(", ");
	if(baseinfo.length > 1)
		document.getElementById('peername').value = baseinfo[1];
	if(baseinfo.length > 0)
		document.getElementById("bgp_peer_en").checked=baseinfo[0];
	for(var i=1;i<peerdata.length;i++)
	{
		if(i > 1)
			addBgpRemSysRow(remsysnum);
		var data = peerdata[i].split(", ");
		var curct = i+1;
		if(data.length> 0)
			document.getElementById("bgp_remsys"+(i+1)).value=data[0];
		for(var j=1;j<data.length;j++)
		{
			if(data[j].trim().length == 0)
				continue;
			if(j > 1)
			{
				addNeighbour(remsysnum,neighnum);
			}
			document.getElementById("bgp_remsys"+(i+1)+"nei"+neighnum).value=data[j];

		}
	}
}
function OspfPwdCheck(id)
{
	var pwdobj = document.getElementById(id);

   var pwd = pwdobj.value;
	var uc = 0;
   var lc = 0;
   var num = 0;
   var spec = 0;
   var esp = 0;
   var space=0;
   var format = /[!@#$%^&*()_+\-=\[\]{}|,.<>~]/;
   var eformat = /[;:'"\/\\]/;

   for(var i=0;i<pwd.length;i++)
   {
      var ch = pwd.charAt(i);
 	  if(ch.match(" ")||ch.match("\t"))
		space++;
      else if(ch.match(/[a-z]/))
         lc++;
      else if(ch.match(/[A-Z]/))
         uc++;
      else if(ch.match(/[0-9]/))
         num++;
      else if(ch.match(format))
         spec ++;
      else if(ch.match(eformat))
         esp++;
      
   }
  if(space>0)
	   	return "Space(or)Tab";
   if((lc>0||uc>0||num>0||spec>0)&&esp==0){
      pwdobj.style.outline='initial';
     return "Valid";
 }
	if(pwd!="")
		pwdobj.style.outline='thin solid red';
	else
		pwdobj.style.outline='initial';
	pwdobj.title = ' must contain at least one number and one uppercase and lowercase letter and Use Special Characters except " , '+" :  , ' ,\/ ,\\ and  ;";
return "Invalid";
}
function showOrHideMd5KeyID(selid,md5rowid,dialogid)
 {
	 var selidobj=document.getElementById(selid);
	 var md5rowidobj=document.getElementById(md5rowid);
	 var dialog=document.getElementById(dialogid);
	 if(dialog.open)
		dialog.close();
	 if(selidobj.value=="MD5")
	 	 md5rowidobj.style.display = '';
	 else
	 {
	 	md5rowidobj.style.display = 'none';
	 	md5rowidobj.value="1";
	 }
 }