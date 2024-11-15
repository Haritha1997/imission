	<%@page import="com.nomus.staticmembers.M2MProperties"%>
	<%@page import="java.util.ArrayList"%>
	<%@page import="java.lang.reflect.Array"%>
	<%@page import="java.util.List"%>
	<%@page import="java.util.Iterator"%>
	<%@page import="org.apache.commons.net.util.SubnetUtils"%>
	<%@page import="java.net.NetworkInterface"%>
	<%@page import="net.sf.json.JSONArray"%>
	<%@page import="java.io.BufferedReader"%>
	<%@page import="java.io.FileReader"%>
	<%@page import="java.io.File"%>
	<%@page import="java.util.Properties"%>
	<%@page import="net.sf.json.JSONObject"%>
	<%
	JSONObject wizjsonnode = null;
	//ospfv2 starts
	JSONObject ospfobj = null;
	JSONObject ospfdefobj = null;
	JSONObject ospfnwobj = null;
	JSONObject ospfeth0obj = null;
	JSONObject ospfeth1obj = null;
	JSONArray nwarr = null;
	JSONArray redisarr = null;
	JSONArray areaarr = null;
	String act = "";
	String autoroute = "";
	String definfo = "";
	String def_alwys = "";
	String eth0pass = "";
	String eth0autocost = "";
	String eth1pass = "";
	String eth1autocost = "";
	//ospfv3 starts
	JSONObject ospf3obj = null;
	JSONObject ospf3defobj = null;
	JSONObject ospf3eth0obj = null;
	JSONObject ospf3eth1obj = null;
	JSONArray v3redisarr = null;
	JSONArray v3areaarr = null;
	JSONArray v3intfacearr = null;
	String v3act = "";
	String v3autoroute = "";
	String v3eth0pass = "";
	String v3eth0autocost = "";
	String v3eth1pass = "";
	String v3eth1autocost = "";
	//bgp starts
	JSONObject bgpobj = null;
	JSONObject bgpdefobj = null;
	JSONArray bgpnwarr = null;
	JSONArray bgpredisarr = null;
	JSONArray bgppathsumm = null;
	JSONObject ipprefixobj = null;
	String bgpact = "";
	String bgpautochk = "";
	String selprefixname = "";
	BufferedReader jsonfile = null;
	String slnumber = request.getParameter("slnumber");
	String errorstr = request.getParameter("error");
	String version = request.getParameter("version");
	String showdiv = request.getParameter("showdiv");
	String bgppeername = request.getParameter("peername")==null?"":request.getParameter("peername");
	int int_bgpset_edit_ind = -1;
	int int_bgppathfit_edit_ind = -1;
	int int_bgppathsum_edit_ind = -1;
	if (slnumber != null && slnumber.trim().length() > 0) {
		Properties m2mprops = M2MProperties.getM2MProperties();
		String slnumpath = m2mprops.getProperty("tlsconfigspath") + File.separator + slnumber;
		jsonfile = new BufferedReader(new FileReader(new File(slnumpath + File.separator + "Config.json")));
		StringBuilder jsonbuf = new StringBuilder("");
		String jsonString = "";
		try {
			while ((jsonString = jsonfile.readLine()) != null)
		jsonbuf.append(jsonString);
			wizjsonnode = JSONObject.fromObject(jsonbuf.toString());
			//ospfv2 starts
			ospfobj = wizjsonnode.containsKey("ospf") ? wizjsonnode.getJSONObject("ospf") : new JSONObject();
			ospfdefobj = ospfobj.containsKey("global:daemon") ? ospfobj.getJSONObject("global:daemon") : new JSONObject();
			redisarr = ospfdefobj.containsKey("Redistribute") ? ospfdefobj.getJSONArray("Redistribute") : new JSONArray();
			areaarr = ospfdefobj.containsKey("Area") ? ospfdefobj.getJSONArray("Area") : new JSONArray();
			ospfnwobj = ospfobj.containsKey("net:network") ? ospfobj.getJSONObject("net:network") : new JSONObject();
			nwarr = ospfnwobj.containsKey("Network") ? ospfnwobj.getJSONArray("Network") : new JSONArray();
			ospfeth0obj = ospfobj.containsKey("interface:Eth0")
			? ospfobj.getJSONObject("interface:Eth0")
			: new JSONObject();
			ospfeth1obj = ospfobj.containsKey("interface:Eth1")
			? ospfobj.getJSONObject("interface:Eth1")
			: new JSONObject();
			//ends
			//ospfv3 starts
			ospf3obj = wizjsonnode.containsKey("ospf6") ? wizjsonnode.getJSONObject("ospf6") : new JSONObject();
			ospf3defobj = ospf3obj.containsKey("global:daemon")
			? ospf3obj.getJSONObject("global:daemon")
			: new JSONObject();
			v3redisarr = ospf3defobj.containsKey("Redistribute")
			? ospf3defobj.getJSONArray("Redistribute")
			: new JSONArray();
			v3areaarr = ospf3defobj.containsKey("Area") ? ospf3defobj.getJSONArray("Area") : new JSONArray();
			v3intfacearr = ospf3defobj.containsKey("Interface") ? ospf3defobj.getJSONArray("Interface") : new JSONArray();
			ospf3eth0obj = ospf3obj.containsKey("interface:Eth0")
			? ospf3obj.getJSONObject("interface:Eth0")
			: new JSONObject();
			ospf3eth1obj = ospf3obj.containsKey("interface:Eth1")
			? ospf3obj.getJSONObject("interface:Eth1")
			: new JSONObject();
			//ends
			//bgp4 starts
			bgpobj = wizjsonnode.containsKey("bgp") ? wizjsonnode.getJSONObject("bgp") : new JSONObject();
			bgpdefobj = bgpobj.containsKey("global:dae_mon") ? bgpobj.getJSONObject("global:dae_mon") : new JSONObject();
			bgpnwarr = bgpdefobj.containsKey("Network") ? bgpdefobj.getJSONArray("Network") : new JSONArray();
			bgpredisarr = bgpdefobj.containsKey("Redistribute") ? bgpdefobj.getJSONArray("Redistribute") : new JSONArray();
			bgppathsumm = bgpdefobj.containsKey("path_summ") ? bgpdefobj.getJSONArray("path_summ") : new JSONArray();
			ipprefixobj = wizjsonnode.containsKey("ipprefix") ? (wizjsonnode.getJSONObject("ipprefix")) : new JSONObject();
			//bgppeerrecord = bgpobj.containsKey("Peer_Records"+peerrecord)?bgpobj.getJSONObject("Peer_Records"+peerrecord):new JSONObject();
			//ends
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (jsonfile != null)
		jsonfile.close();
		}
	}
	%>
	<html>
	<head>
	<link rel="stylesheet" href="css/fontawesome.css">
	<link rel="stylesheet" href="css/solid.css">
	<link rel="stylesheet" href="css/v4-shims.css">
	<link rel="stylesheet" type="text/css" href="css/style.css">
	<link rel="stylesheet" type="text/css"
		href="css/multiselect/bootstrap.min.css">
	<link rel="stylesheet" type="text/css"
		href="css/multiselect/bootstrap-multiselect.css">
	<style>
	.caret {
		position: absolute;
		left: 90%;
		top: 40%;
		vertical-align: middle;
		border-top: 6px solid;
	}
	
	#act_icon {
		padding-right: 10;
		color: #7B68EE;
		cursor: pointer;
	}
	
	#new_icon {
		padding-right: 10;
		color: green;
		cursor: pointer;
	}
	
	html {
		overflow-y: scroll;
	}
	
	.multiselect-container {
		width: 100% !important;
	}
	
	button.multiselect {
		height: 25px;
		margin: 0;
		padding: 0;
	}
	
	.multiselect-container>.active>a, .multiselect-container>.active>a:hover,
		.multiselect-container>.active>a:focus {
		background-color: grey;
		width: 100%;
	}
	
	.multiselect-container>li.active>a>label, .multiselect-container>li.active>a:hover>label,
		.multiselect-container>li.active>a:focus>label {
		color: #ffffff;
		width: 100%;
		white-space: normal;
	}
	
	.multiselect-container>li>a>label {
		font-size: 12.5px;
		text-align: left;
		font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
		padding-left: 25px;
		white-space: normal;
	}
	
	#configtypediv li a {
		font-size: 14px;
	}
	
	#ospf3list li a {
		font-size: 14px;
	}
	
	a, a:hover {
		color: black;
		text-decoration: none;
	}
	
	.borderlesstab th:nth-child(even), .borderlesstab td:nth-child(even) {
		width: 400px;
	}
	
	#redistribute th {
		min-width: 130 px;
		width: 130px;
	}
	
	#bgplist li a {
		font-size: 11px;
	}
	
	#bgppeersconfig  th {
		width: 300px;
	}
	
	#bgppeersettab th {
		width: 300px;
	}
	
	#path_listtab th {
		width: 300px;
	}
	
	#bgppathsummconfig th {
		width: 300px;
	}
	.Popup
	  {
	    text-align:left;
	    position: relative;
	    width: 45%;
	    background-color: #DCDCDC;
	    border:2px solid black;
	    max-height:18px;
	    border-radius: 5%;
	    border:1px dotted black;
	    margin:0.2px;
	  }
	</style>
	<script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
	<script type="text/javascript" src="js/dynamic_routing.js"></script>
	<script type="text/javascript" src="js/common.js"></script>
	<script type="text/javascript" src="js/multiselect/jquery1.12.4.min.js"></script>
	<script type="text/javascript"
		src="js/multiselect/bootstrap3.3.6.min.js"></script>
	<script type="text/javascript"
		src="js/multiselect/bootstrap-multiselect.js"></script>
	
	<script type="text/javascript">
	      var bgp_ins_det_empty = false;
	var bgpnetwork = 6;
	var iprows = 1;
	var curdiv = "";
	var currdiv = "";
	//var shutdown=1;
	var remsysnum=1;
	var neighnum = 1;
	var nei_ip_obj_arr = [];
	function showErrorMsg(errormsg)
	{
		alert(errormsg);
	}
	$(document).on('click', '.toggle-password', function () {
	   $(this).toggleClass("fa-eye fa-eye-slash");
	   var input = $("#pwd");
	   input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
	});
	$(document).on('click', '.toggle-peer_password', function() {
	    $(this).toggleClass("fa-eye fa-eye-slash");    
	    var input = $("#peer_password");
	    input.attr('type') === 'password' ? input.attr('type','text') : input.attr('type','password')
	});
	$(document).ready(function () {
	   $('#proto').multiselect({
	      buttonWidth: '150px',
	      numberDisplayed: 2,
	   });
	});
	$(document).ready(function () {
	   $('#protos').multiselect({
	      buttonWidth: '150px',
	      numberDisplayed: 2,
	   });
	});
	//$(document).ready(function () {
	//alert("calling function");
	//addPeerRecOptions('bgp_peers_rwcnt','bgpPerrow_val','peer_records');
	//});
	$(document).on('click', '.e1toggle-password', function () {
	   $(this).toggleClass("fa-eye fa-eye-slash");
	   var input = $("#e1pwd");
	   input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
	});
	$(document).on('click', '.e0toggle-password', function () {
	   $(this).toggleClass("fa-eye fa-eye-slash");
	   var input = $("#e0pwd");
	   input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
	});
	function interfacecostConfig(id) {
	   if (id == "e0intrfcost") {
	      var e0intcost = document.getElementById(id);
	      var e0autocheckobj = document.getElementById("e0intrfcost_check");
	      if (e0autocheckobj.checked == true) {
	         e0intcost.disabled = true;
	         e0intcost.value = "";
	      } else
	         e0intcost.disabled = false;
	   } else if (id == "e1intrfcost") {
	      var e1intcost = document.getElementById(id);
	      var e1autocheckobj = document.getElementById("e1intrfcost_check");
	      if (e1autocheckobj.checked == true) {
	         e1intcost.disabled = true;
	         e1intcost.value = "";
	      } else
	         e1intcost.disabled = false;
	   } else if (id == "loopintrfcost") {
	      var loopintcost = document.getElementById(id);
	      var loopautocheckobj = document.getElementById("loopintrfcost_check");
	      if (loopautocheckobj.checked == true) {
	         loopintcost.disabled = true;
	         loopintcost.value = "";
	      } else
	         loopintcost.disabled = false;
	   }
	
	}
	
	function ospfRouIdConfig() {
	   var ospfidobj = document.getElementById("ospf_routerid");
	   var autocheckobj = document.getElementById("ospf_autocheck");
	   if (autocheckobj.checked == true) {
	      ospfidobj.disabled = true;
	      ospfidobj.value = "";
	   } 
	   else
	      ospfidobj.disabled = false;
	}
	function bgpRouIdConfig() {
	   var bgpidobj = document.getElementById("bgp_routerid");
	   var bgpautocheckobj = document.getElementById("bgp_autocheck");
	   if (bgpautocheckobj.checked == true) {
	      bgpidobj.disabled = true;
	      bgpidobj.value = "";
	   } 
	   else
	      bgpidobj.disabled = false;
	}
	function checkAlphaNUmeric(id)
		  {
		 
		      var val = document.getElementById(id).value.trim();
			  if(!isValidAlphaNumberic(id)&& val.length != 0)
			  {
				  alert("Please Use Only AlphaNumeric");
				  return;
			  }
			  addNewBgpPeer();
		  }
	// ospfv2 modified end
	
	function validateOSPF2(divname) {
	   var altmsg = "";
	   try{
	   if (divname == "curdiv")
	      divname = curdiv;
	   if (divname == "ospf2_instance") { //modified global_config to ospf2_instance
	      var auto_ckd = document.getElementById("ospf_autocheck");
	      var ospfrouteobj = document.getElementById("ospf_routerid");
		  var valid = false;
		  if(!auto_ckd.checked)
		  {
		 
			var valid= validateIP("ospf_routerid", true,"Router-ID");
			if (!valid) {
				if(ospfrouteobj.value.trim() == 0)
					altmsg += "OSPF Router-ID should not be empty\n";
				else
					altmsg += "OSPF Router-ID is not valid\n";
			}
		  }
		 var index = document.getElementById("redistributecnt").value;
		
		for (var i = 1; i < index; i++) {
		var linkobj = document.getElementById("links"+i); 
		if (linkobj == null)
	            continue;
	    var invalid = false;
		if (invalid)
	            continue;
		var i_link = linkobj.value;
		for (var j = 1; j < index; j++) {
			var jlinkobj = document.getElementById("links" + j);
			if (jlinkobj != null) {
				j_link = jlinkobj.value;
			if ((i_link == j_link) && (i != j)) {
			if (!altmsg.includes(i_link + 
				" entry already exists"))
				altmsg += i_link + " entry already exists \n";
			linkobj.style.outline = "thin solid red";
			break;
			}
		}
	}
	if (j == index) {
	            linkobj.style.outline = "initial";
	            linkobj.title = "";
	         }
	}
	   } else if (divname == "networks") {
	      var index = document.getElementById("netwrkrwcnt").value;
	      var nettab = document.getElementById("networkconfig");
	      var rows = nettab.rows;
	      var currows = 0;
	      for (var i = 1; i < index; i++) {
	         var id = "network" + i;
	         var name = "Network IP in the row ";
	         var sid = "network_subnet" + i;
	         var sname = "Subnet in the row ";
	         var aid = "area" + i;
	         var aname = "Area in the row ";
	         var ipobj = document.getElementById(id);
	         var nmaskobj = document.getElementById(sid);
	         if (ipobj == null)
	            continue;
	         currows++;
	         var invalid = false;
	         if (!validateIP(id, true, name)) {
	
	            if (ipobj.value == "")
	               altmsg += name + currows + " should not be empty\n";
	            else
	               altmsg += name + currows + " is not valid\n";
	            invalid = true;
	         }
	         if (!validateSubnetMask(sid, true, sname)) {
	            if (document.getElementById(sid).value.trim() == "")
	               altmsg += sname + currows + " should not be empty\n";
	            else
	               altmsg += sname + currows + " is not valid\n";
	            invalid = true;
	         }
	         if (!validateRange(aid, true, aname)) {
	            if (document.getElementById(aid).value.trim() == "")
	               altmsg += aname + currows + " should not be empty\n";
	            else
	               altmsg += aname + currows + " is not valid\n";
	         }
	         if (invalid)
	            continue;
	         var ip_addr_i = ipobj.value;
	         for (var j = 1; j < index; j++) {
	            var jipobj = document.getElementById("network" + j);
	            var netmobj = document.getElementById("network_subnet" + j);
	            if (jipobj != null) {
	               ip_addr_j = jipobj.value;
	               inetmask_val = nmaskobj.value;
	               jnetmask_val = netmobj.value;
				   
	               if (ip_addr_i == ip_addr_j && (i != j) && (inetmask_val == jnetmask_val)) {
	                  if (!altmsg.includes(ip_addr_i + " address is already exists"))
	                     altmsg += ip_addr_i + " address is already exists\n";
	                  ipobj.style.outline = "thin solid red";
	                  break;
	               }
				   else if((i != j) && (isNetworkOVerlaped(ip_addr_i,inetmask_val,ip_addr_j,jnetmask_val)))
				   {
					if(!((altmsg.includes(ip_addr_i+" and "+ inetmask_val + " is overlaps with the networks "+ip_addr_j+" and "+jnetmask_val))
					||(altmsg.includes(ip_addr_j+" and "+ jnetmask_val + " is overlaps with the networks "+ip_addr_i+" and "+inetmask_val))))
						altmsg +=ip_addr_i+" and "+ inetmask_val + " is overlaps with the networks "+ip_addr_j+" and "+jnetmask_val+"\n"; 
						break;
				   }
	            }
	         }
	         if (j == index) {
	            ipobj.style.outline = "initial";
	            ipobj.title = "";
	         }
	         currow++;
	      }
	   } 
	   else if (divname == "interface_config") {	//modified starts from this line on 19/08/2022
		  var e0helo_inter = document.getElementById("e0heloIntrvl");
	      var e0dead_inter = document.getElementById("e0deadIntrvl");
	      if ((parseInt(e0dead_inter.value)<=parseInt(e0helo_inter.value)) && (e0dead_inter.value.trim() != "") && (e0helo_inter.value.trim() != ""))
		  {
	         altmsg += "Dead interval of LAN must be  greater than the hello interval\n";
			 e0dead_inter.style.outline="thin solid red";
			 e0helo_inter.style.outline="thin solid red";
		  }
		  else if(e0helo_inter.value == "" && parseInt(e0dead_inter.value)<= 10)
		  {
			  altmsg += "Dead Interval of LAN should be greater than the Hello Interval default value 10\n";
			  e0dead_inter.style.outline="thin solid red";
			  e0dead_inter.title="Dead Interval of LAN should be greater than the Hello Interval default value 10";
		  }
		  else if(e0dead_inter.value == "" && parseInt(e0helo_inter.value)>= 40) {
			  altmsg += "Hello Interval of LAN should not be greater than the Dead Interval default value 40\n";
			  e0helo_inter.style.outline="thin solid red";
			  e0helo_inter.title="Hello Interval of LAN should not be greater than the Dead Interval default value 40";
			}
		  else
		  {
			e0dead_inter.style.outline="initial";
			e0helo_inter.style.outline="initial";
		  }
	      var e1helo_inter = document.getElementById("e1heloIntrvl");
	      var e1dead_inter = document.getElementById("e1deadIntrvl");
	      if (parseInt(e1dead_inter.value)<=parseInt(e1helo_inter.value) && (e1dead_inter.value.trim() != "") && (e1helo_inter.value.trim() != ""))
		  {
	         altmsg += "Dead interval of WAN must be greater than the hello interval\n";
			 e1dead_inter.style.outline="thin solid red";
			 e1helo_inter.style.outline="thin solid red";
		  }
		   else if(e1helo_inter.value == "" && parseInt(e1dead_inter.value)<= 10)
		  {
			  altmsg += "Dead Interval of WAN should be greater than the Hello Interval default value 10\n";
			  e1dead_inter.style.outline="thin solid red";
			  e1dead_inter.title="Dead Interval of WAN should be greater than the Hello Interval default value 10";
		  }
		  else if(e1dead_inter.value == "" && parseInt(e1helo_inter.value)>= 40) {
			  altmsg += "Hello Interval of WAN should not be greater than the Dead Interval default value 40\n";
			  e1helo_inter.style.outline="thin solid red";
			  e1helo_inter.title="Hello Interval of WAN should not be greater than the Dead Interval default value 40";
			}
		  else
		  {
			e1dead_inter.style.outline="initial";
			e1helo_inter.style.outline="initial";
		  }
		  var prefix_arr=["e0","e1"];
		  var intf_arr=["LAN","WAN"];
		  for(var i=0;i<prefix_arr.length;i++)
		  {
			var	check_obj = document.getElementById(prefix_arr[i]+"intrfcost_check");
			var intfobj =document.getElementById(prefix_arr[i]+"intrfcost");
			  if(!check_obj.checked)
			  {
				var valid= validateRange(prefix_arr[i]+'intrfcost',true,'Interface Cost (1-65535)');
				if (!valid) {
					if(intfobj.value.trim() == 0)
						altmsg += "Interface Cost (1-65535) of "+intf_arr[i]+" should not be empty\n";
					else
						altmsg += "Interface Cost (1-65535) of "+intf_arr[i]+" is not valid\n";
				}
				
			  }
		  }
		var e0pwd=document.getElementById("e0pwd");
		var e1pwd=document.getElementById("e1pwd"); 
		var e0valid = OspfPwdCheck("e0pwd"); 
		var e1valid = OspfPwdCheck("e1pwd"); 
		if(isIntfPwdEmpty("LAN")) {
			altmsg += "LAN Password shoud not be empty\n";
		e0pwd.style.outline="thin solid red";}
		else if(e0valid=="Invalid"&&e0pwd.value.trim()!="") 
			altmsg+="LAN Password doesn't match criteria!\n";
		else if(e0valid=="Space(or)Tab") 
			altmsg+="LAN Password shouldn't contain Space(or)Tab!\n";
		if(isIntfPwdEmpty("WAN")) {
			altmsg +="WAN Password shoud not be empty\n";
			e1pwd.style.outline="thin solid red";}
		else if(e1valid=="Invalid"&&e1pwd.value.trim()!="") 
			altmsg+="WAN Password doesn't match criteria!\n";
		else if(e1valid=="Space(or)Tab") 
			altmsg+="WAN Password shouldn't contain Space(or)Tab!\n";
	   } //modified upto here........
	   else if(divname == "area_config")//pallavi
		{
			var arearow = document.getElementById("areacnt").value;
			var arow = 0;
			for (var i = 1; i <arearow; i++) {
				var area_obj = document.getElementById('area_id'+i);
				var summ_int_obj = document.getElementById('sum_int'+i);
				
				if(area_obj == null)
					continue;
				else {
					arow++;
					if (area_obj.value.trim() == "")//new lines
					altmsg += "Area id in the row "+arow+" should not be empty\n";
					var typeobj = document.getElementById("area_type"+i);
					valid = validateCIDRNotation('sum_int' + i, false, 'Summarise Inter Area');
					if (!valid) {
						if(summ_int_obj.value.trim() == "")
							altmsg += "Summarise Inter Area in row "+arow+" should not be empty\n";
						else
							altmsg += "Summarise Inter Area in row " +arow+ " is not valid\n";
					}
					if(area_obj.value == '0')
					{
						if(typeobj.value != "")
						{
							typeobj.title = "Type should be empty as Area Id is 0 in the row "+arow+"\n";
							typeobj.style.outline = "thin solid red";
							altmsg += typeobj.title;
							summ_int_obj.title = "";
						summ_int_obj.style.outline = "initial";
						}
						else if(summ_int_obj.value=="")
						{
							summ_int_obj.title = "Please select configuration(Summarise) either delete Area Id 0 in the row "+arow+"\n";
							summ_int_obj.style.outline = "thin solid red";
							altmsg += summ_int_obj.title;
							typeobj.title = "";
						   typeobj.style.outline = "initial";
						}
					}
					else if(area_obj.value != '' &&typeobj.value == ""&&summ_int_obj.value=="")
					{
					typeobj.title = "Please select configuration(Type/Summarise) either delete the row "+arow+"\n";
					summ_int_obj.title ="Please select configuration(Type/Summarise) either delete the row "+arow+"\n";
					typeobj.style.outline = "thin solid red";
					summ_int_obj.style.outline = "thin solid red";
					altmsg += "Please select configuration(Type/Summarise) either delete the row "+arow+"\n";
					}
					else
					{
						typeobj.title = "";
						typeobj.style.outline = "initial";
						summ_int_obj.title = "";
						summ_int_obj.style.outline = "initial";
					}
					
				}
				var i_area = area_obj.value;
				for (var j = 1; j < arearow; j++) 
				{
					var jareaobj = document.getElementById("area_id"+j);
					if (jareaobj != null) 
					{
							j_area = jareaobj.value;
						if ((i_area == j_area) && (i != j) &&(area_obj.value.trim!="")&&(jareaobj.value.trim()!="")) 
							{
							if (!altmsg.includes(i_area + " entry already exists"))
								altmsg +="Area id " + i_area + " entry already exists \n";
							area_obj.style.outline = "thin solid red";
							break;
							}
					}
				}
				if (j == arearow) 
				{
					area_obj.style.outline = "initial";
					area_obj.title = "";
				}
			}
	
		}//end
	   
	   else if (divname == "neighbour") {
	      var index = document.getElementById("neighbourcnt").value;
	      var neitab = document.getElementById("neighconfig");
	      var rows = neitab.rows;
	      var currow = 1;
	      for (var i = 1; i <= index; i++) {
	         var n_id = "neighbour" + i;
	         var n_name = "neighbour in the row ";
	         var iobj = document.getElementById(n_id);
	         if (iobj != null) {
	            if (!validateIP(n_id, true, n_name)) {
	               if (document.getElementById(n_id).value == "")
	                  altmsg += n_name + currow + " should not be empty\n";
	               else
	                  altmsg += n_name + currow + " is not valid\n";
	               currow++;
	               continue;
	            }
	            var i_val = iobj.value;
	            for (var j = 1; j < index; j++) {
	               var jobj = document.getElementById("neighbour" + j);
	               if (jobj != null) {
	                  j_val = jobj.value;
	                  if (i_val == j_val && i != j) {
	                     if (!altmsg.includes(i_val + " address is already exists"))
	                        altmsg += i_val + " address is already exists\n";
	                     iobj.style.outline = "thin solid red";
	                     break;
	                  }
	               }
	            }
	            if (j == index) {
	               iobj.style.outline = "initial";
	               iobj.title = "";
	            }
	            currow++;
	         }
	
	      }
	
	   }
	   }
	   catch(e)
	   {
	   alert(e)
	   }
	   if (altmsg.trim().length == 0) return true;
	   else {
	      alert(altmsg);
	      return false;
	   }
	}
	// ----------------------------- OSPFV3 fuctions start -----------------------------
	function interfacecostV3Config(id) {
	   if (id == "e0intrfcost_v3") {
	      var e0intcost = document.getElementById(id);
	      var e0autocheckobj = document.getElementById("e0intrfcost_check_v3");
	      if (e0autocheckobj.checked == true) {
	         e0intcost.disabled = true;
	         e0intcost.value = "";
	      } else
	         e0intcost.disabled = false;
	   } else if (id == "e1intrfcost_v3") {
	      var e1intcost = document.getElementById(id);
	      var e1autocheckobj = document.getElementById("e1intrfcost_check_v3");
	      if (e1autocheckobj.checked == true) {
	         e1intcost.disabled = true;
	         e1intcost.value = "";
	      } else
	         e1intcost.disabled = false;
	   } else if (id == "loopintrfcost") {
	      var loopintcost = document.getElementById(id);
	      var loopautocheckobj = document.getElementById("loopintrfcost_check");
	      if (loopautocheckobj.checked == true) {
	         loopintcost.disabled = true;
	         loopintcost.value = "";
	      } else
	         loopintcost.disabled = false;
	   }
	
	}
	function ospfRouIdConfigv3()
	{
		var ospfidobj = document.getElementById("ospf_routerid_v3");
		var autocheckobj = document.getElementById("ospf_autocheck_v3");
		if (autocheckobj.checked == true) {
	      ospfidobj.disabled = true;
	      ospfidobj.value = "";
		} 
		else
	      ospfidobj.disabled = false;
	}
	function validateOSPF3(divname)
	{
		   var altmsg = "";
		   try{
		   if (divname == "curdiv")
			  divname = curdiv;
		   if (divname == "ospf3_instance") {
			  var auto_ckd = document.getElementById("ospf_autocheck_v3");
			  var ospfrouteobj = document.getElementById("ospf_routerid_v3");
			  var valid = false;
			  if(!auto_ckd.checked)
			  {	 
				var valid= validateIP("ospf_routerid_v3",true,"Router-ID");
				if (!valid) {
					if(ospfrouteobj.value.trim() == 0)
						altmsg += "OSPF Router-ID should not be empty\n";
					else
						altmsg += "OSPF Router-ID is not valid\n";
				}
			  }
			}
		   else if(divname == "interface_v3")
			  {
					//var index = document.getElementById("intfv3rwcnt").value;
					var nettab = document.getElementById("interfacev3tab");
					var rows = nettab.rows;
					var currows = 0;
					for (var i = 1; i < rows.length; i++) {
						//var intfid = "intfce"+i;
						//var areaid = "intfarea" + i;
						var areaname = "Area in the row ";
		            var cols = rows[i].cells;
						//var intfobj = document.getElementById(intfid);
						//var areaobj = document.getElementById(areaid);
		            var intfobj = cols[1].children[0];
						var areaobj = cols[2].children[0];
						if(areaobj != null)
						{
							if(!validateRange(areaobj.id,true,areaname)) {
								if (areaobj.value.trim() == "")
									altmsg += areaname + i + "   should not be empty\n";
								else
									altmsg += areaname + " is not valid\n";
							}
						}
						if(intfobj == null)
							continue;
						var i_infval = intfobj.value;
		            
						for(var j=1;j<i;j++)
						{
		               var colsj = rows[j].cells;
							//var j_intfobj = document.getElementById("intfce"+j);
		               var j_intfobj = colsj[1].children[0];
		               var j_areaobj = colsj[2].children[0];
							var j_intfval = j_intfobj.value;
							var  j_areaval= j_areaobj.value;;
							if((i_infval == j_intfval) && (i!=j)&&(areaobj.value.trim()!="")&&(j_areaval!=""))
							{
								if(!altmsg.includes("Duplicate Entry "+i_infval +" already exists") )
									altmsg += "Duplicate Entry "+i_infval +" already exists\n";
								intfobj.style.outline = "thin solid red";
		                  j_intfobj.style.outline = "thin solid red";
								break;
		                  
							}
							
						}
						if (j == i) {
						   intfobj.style.outline = "initial";
						   intfobj.title = "";
						}
					}
			  }
		  else if(divname == "interface_config_v3")
		  {
				var e0helo_inter = document.getElementById("e0heloIntrvl_v3");
				var e0dead_inter = document.getElementById("e0deadIntrvl_v3");
				if ((parseInt(e0dead_inter.value)<=parseInt(e0helo_inter.value)) && (e0dead_inter.value.trim() != "") && (e0helo_inter.value.trim() != ""))
		  {
	         altmsg += "Dead interval of LAN must be  greater than the hello interval\n";
			 e0dead_inter.style.outline="thin solid red";
			 e0helo_inter.style.outline="thin solid red";
		  }
		  else if(e0helo_inter.value == "" && parseInt(e0dead_inter.value)<= 10)
		  {
			  altmsg += "Dead Interval of LAN should be greater than the Hello Interval default value 10\n";
			  e0dead_inter.style.outline="thin solid red";
			  e0dead_inter.title="Dead Interval of LAN should be greater than the Hello Interval default value 10";
		  }
		  else if(e0dead_inter.value == "" && parseInt(e0helo_inter.value)>= 40) {
			  altmsg += "Hello Interval of LAN should not be greater than the Dead Interval default value 40\n";
			  e0helo_inter.style.outline="thin solid red";
			  e0helo_inter.title="Hello Interval of LAN should not be greater than the Dead Interval default value 40";
			}
		  else
		  {
			e0dead_inter.style.outline="initial";
			e0helo_inter.style.outline="initial";
		  }
				var e1helo_inter = document.getElementById("e1heloIntrvl_v3");
				var e1dead_inter = document.getElementById("e1deadIntrvl_v3");
				if (parseInt(e1dead_inter.value)<=parseInt(e1helo_inter.value) && (e1dead_inter.value.trim() != "") && (e1helo_inter.value.trim() != ""))
		  {
	         altmsg += "Dead interval of WAN must be greater than the hello interval\n";
			 e1dead_inter.style.outline="thin solid red";
			 e1helo_inter.style.outline="thin solid red";
		  }
		   else if(e1helo_inter.value == "" && parseInt(e1dead_inter.value)<= 10)
		  {
			  altmsg += "Dead Interval of WAN should be greater than the Hello Interval default value 10\n";
			  e1dead_inter.style.outline="thin solid red";
			  e1dead_inter.title="Dead Interval of WAN should be greater than the Hello Interval default value 10";
		  }
		  else if(e1dead_inter.value == "" && parseInt(e1helo_inter.value)>= 40) {
			  altmsg += "Hello Interval of WAN should not be greater than the Dead Interval default value 40\n";
			  e1helo_inter.style.outline="thin solid red";
			  e1helo_inter.title="Hello Interval of WAN should not be greater than the Dead Interval default value 40";
			}
		  else
		  {
			e1dead_inter.style.outline="initial";
			e1helo_inter.style.outline="initial";
		  }
				var prefix_arr=["e0","e1"];
				var intf_arr=["LAN","WAN"];
				for(var i=0;i<prefix_arr.length;i++)
				{
					var	check_obj = document.getElementById(prefix_arr[i]+"intrfcost_check_v3");
					var intfobj =document.getElementById(prefix_arr[i]+"intrfcost_v3");
					if(!check_obj.checked)
					{
						var valid= validateRange(prefix_arr[i]+'intrfcost_v3',true,'Interface Cost (1-65535)');
						if (!valid) {
							if(intfobj.value.trim().length == 0)
								altmsg += "Interface Cost (1-65535) of "+intf_arr[i]+" should not be empty\n";
							else
							altmsg += "Interface Cost (1-65535) of "+intf_arr[i]+" is not valid\n";
						}
				
					}
				}
			}
			else if(divname == "area_config_v3")
			{
				var arearow = document.getElementById("areav3cnt").value;
				var arow = 0;
				for (var i = 1; i <arearow; i++) {
					var area_obj = document.getElementById('area_id_v3'+i);
					var summ_int_obj = document.getElementById('sum_int_v3'+i);
					if(area_obj == null)
						continue;
					else {
						arow++;
						if (area_obj.value.trim() == "")//new lines
						altmsg += "Area id in the row "+arow+" should not be empty\n";
						var typeobj = document.getElementById("area_type_v3"+i);
						/* if(area_obj.value == '0' && typeobj.value != "")
						{
							typeobj.title = "Type should be empty as Area Id is 0 in the row "+arow+"\n";
							typeobj.style.outline = "thin solid red";
							altmsg += typeobj.title;
						}
						else
						{
							typeobj.title = "";
							typeobj.style.outline = "initial";
						} */
						valid = validateIPv6('sum_int_v3'+i, false, 'Summarise Inter Area',true);
						if (!valid) {
							if(summ_int_obj.value.trim() == "")
								altmsg += "Summarise Inter Area in row "+i+" should not be empty\n";
							else
								altmsg += "Summarise Inter Area in row " +i+ " is not valid\n";
						}
						if(area_obj.value == '0')
						{
							if(typeobj.value != "")
							{
								typeobj.title = "Type should be empty as Area Id is 0 in the row "+arow+"\n";
								typeobj.style.outline = "thin solid red";
								altmsg += typeobj.title;
								summ_int_obj.title = "";
							summ_int_obj.style.outline = "initial";
							}
							else if(summ_int_obj.value=="")
							{
								summ_int_obj.title = "Please select configuration(Summarise) either delete Area Id 0 in the row "+arow+"\n";
								summ_int_obj.style.outline = "thin solid red";
								altmsg += summ_int_obj.title;
								typeobj.title = "";
							   typeobj.style.outline = "initial";
							}
						}
						else if(area_obj.value != '' &&typeobj.value == ""&&summ_int_obj.value=="")
						{
						typeobj.title = "Please select configuration(Type/Summarise) either delete the row "+arow+"\n";
						summ_int_obj.title ="Please select configuration(Type/Summarise) either delete the row "+arow+"\n";
						typeobj.style.outline = "thin solid red";
						summ_int_obj.style.outline = "thin solid red";
						altmsg += "Please select configuration(Type/Summarise) either delete the row "+arow+"\n";
						}
						else
						{
							typeobj.title = "";
							typeobj.style.outline = "initial";
							summ_int_obj.title = "";
							summ_int_obj.style.outline = "initial";
						}
					}
					var i_area = area_obj.value;
					for (var j = 1; j < arearow; j++) 
					{
						var jareaobj = document.getElementById("area_id_v3"+j);
						if (jareaobj != null) 
						{
								j_area = jareaobj.value;
							if ((i_area == j_area) && (i != j) &&(area_obj.value.trim!="")&&(jareaobj.value.trim()!="")) 
								{
								if (!altmsg.includes(i_area + " entry already exists"))
									altmsg +="Area id " + i_area + " entry already exists \n";
								area_obj.style.outline = "thin solid red";
								break;
								}
						}
					}
					if (j == arearow) 
					{
						area_obj.style.outline = "initial";
						area_obj.title = "";
					}
				}
	
			}
		}catch(e)
	   {
			alert(e)
	   }
	   if (altmsg.trim().length == 0) return true;
	   else {
	      alert(altmsg);
	      return false;
	   }
	}	
	// ----------------------------- OSPFV3 fuctions stop -----------------------------
	
	function validateBgp(divname) {
	 
	  //alert("validateBgp divname"+divname);
	   //document.getElementById(divname+'bgpsubdivpage').value = curdiv;
	   var altmsg = "";
	    try{
	   if (divname == "curdiv") 
			divname = curdiv;
	   // bgp-instance validations
	   if (divname == "bgp_instance") {
	      document.getElementById("ins_enable");
	      //var bgproutid = document.getElementById("bgp_routerid");
	      var bgpnet = document.getElementById("bgp_netk"); 
		  var auto_ckd = document.getElementById("bgp_autocheck");
	      var bgprouteobj = document.getElementById("bgp_routerid");
		  var valid = false;
		  if(!auto_ckd.checked)
		  {
			var valid= validateIP('bgp_routerid', true,'Router ID');
			if (!valid) {
				if(bgprouteobj.value.trim() == 0)
					altmsg += "Router ID should not be empty\n";
				else
					altmsg += "Router ID is not valid\n";
			}
		  }
		  
		  var enobj = document.getElementById("ins_enable");
	      var autosysnumobj = document.getElementById("sysnum");
		  var valid = false;
		  if(enobj.checked)
		  {
			//var valid= validateRange('sysnum',true,'Autonomous System Number');
			//if (!valid) {
				if(autosysnumobj.value.trim() == 0)
					altmsg += "Autonomous System Number  should not be empty\n";
			//}
		  }
		  
	      var netrow = document.getElementById("bgpnwcnt").value;
		  var nwrow=1;
	      for (var i =1; i <= netrow; i++) 
		  {
	         var nw_obj = document.getElementById('bgp_netk'+i);
	         if (nw_obj != null &&nw_obj.value.trim()!="") 
			 {
				
	            valid = validateCIDRNotation('bgp_netk' + i, true, 'Network');
	            //if (!valid && nw_obj.value.trim() == "") 
				if(!valid)
				{
				if(nw_obj.value.trim() == "")
					altmsg += "Network Address" +nwrow +" should not be empty\n";
				else
					altmsg += "Network Address"+ nwrow+ " is not valid\n";
				nwrow++;
				continue;			
				}
				var networkmask_arr=null;
				if(valid)
				{
					networkmask_arr = nw_obj.value.split('/');
					var network="";
					var broadcast="";
					network = getNetwork(networkmask_arr[0],getMask(networkmask_arr[1]));
					broadcast = getBroadcast(network,getMask(networkmask_arr[1]));
					if(networkmask_arr[0] != network)
						{
						nw_obj.title = "Network Address "+nwrow+" should be Network!\n";
						altmsg += nw_obj.title;
						nw_obj.style.outline = "thin solid red";
						 error = true;
						}
					else
						{
							var i_nw = nw_obj.value;
				            for (var j = 1; j <=netrow; j++) {
							
				               var jnwobj = document.getElementById("bgp_netk" + j);
							   var error = false;
				               if (jnwobj != null) {
				                  j_nw = jnwobj.value;
				                  if (i_nw == j_nw && i != j) {
				                     if (!altmsg.includes(i_nw + " Address is already exists"))
				                        altmsg += i_nw + " Address is already exists\n";
				                     nw_obj.style.outline = "thin solid red";
									 error = true;
				                     break;
				                  }
				               }
				            }
						}
				} 
	            if (!error) {
	               nw_obj.style.outline = "initial";
	               nw_obj.title = "";
	            }
				nwrow++;
			}
			
		 } 
		
	   } //end
	   /// add bgp peer validations
	  else if (divname == "add_bgppeer") {
	            var index = document.getElementById("bgpremnumcnt").value;
	            var autosysnumobj = document.getElementById("sysnum").value;
	            if(autosysnumobj.trim() == 0)
					altmsg += "First Configure Autonomous System Number in Instance\n";
	            nei_ip_obj_arr = [];
	            for (var i = 2; i <= index; i++) {
	                var remoteobj = document.getElementById("bgp_remsys" + i);
	                if (remoteobj == null) continue;
	                valid = validateRange("bgp_remsys" + i, true, "Remote Autonomus System Number(1-4294967295)");
	                if (!valid) {
	                    if (remoteobj.value.trim() == "") altmsg += "Remote Autonomus System Number " + (i - 1) + " should not be empty\n";
	                    else altmsg += "Remote Autonomus System Number " + (i - 1) + " is not valid\n";
	                }
	                var remoteobj = document.getElementById("bgp_remsys" + i);
	                if (remoteobj == null) continue;
	                var i_remote = remoteobj.value;
	                for (var j = 1; j <= index; j++) {
	                    var jremoteobj = document.getElementById("bgp_remsys" + j);
	                    var error = false;
	                    if (jremoteobj != null && jremoteobj.value.trim() != "") {
	                        j_remote = jremoteobj.value;
	                        if ((i_remote == j_remote) && (i != j)) {
	                            if (!altmsg.includes("Duplicate Remote Autonomus System Number  " + i_remote)) altmsg += "Duplicate Remote Autonomus System Number  " + i_remote + "\n";
	                            remoteobj.style.outline = "thin solid red";
	                            jremoteobj.style.outline = "thin solid red";
	                            error = true;
	                            break;
	                        }
	                    }
	                    if (!error) {
	                        remoteobj.style.outline = "initial";
	                        remoteobj.title = "";
	                    }
	                }
	                var neidiv = document.getElementById("peer" + i + "neighboursdiv");
	                if (neidiv == null) continue;
	                var childdivs = neidiv.children;
	                for (var k = 1; k < childdivs.length; k++) {
	                    var childs = childdivs[k].children;
	                    nei_ip_obj_arr.push(childs[0]);
	                }
	            }
	            for (var i = 0; i < nei_ip_obj_arr.length; i++) {
	                if (validateIPOnly(nei_ip_obj_arr[i].id, true, "Neighbour Address") == false) {
	                    if (nei_ip_obj_arr[i].value.trim() == "") altmsg += "Neighbour Address  " + nei_ip_obj_arr[i].value + " should not be empty\n";
	                    else altmsg += "Invalid Neighbour Address " + nei_ip_obj_arr[i].value + "\n";
	                    continue;
	                }
	                var error = false;
	                for (var j = 0; j < i; j++) {
	                    if (nei_ip_obj_arr[j].value == nei_ip_obj_arr[i].value) {
	                        if (!altmsg.includes("Duplicate Neighbour Address " + nei_ip_obj_arr[i].value)) altmsg += "Duplicate Neighbour Address " + nei_ip_obj_arr[i].value + "\n";
	                        nei_ip_obj_arr[j].style.outline = "thin solid red";
	                        nei_ip_obj_arr[j].title = "Duplicate Neighbour Address";
	                        nei_ip_obj_arr[i].style.outline = "thin solid red";
	                        nei_ip_obj_arr[i].title = "Duplicate Neighbour Address";
	                        error = true;
	                        break;
	                    }
	                }
	                if (!error) {
	                    nei_ip_obj_arr[i].title = "";
	                    nei_ip_obj_arr[i].style.outline = "initial";
	                }
	            }
	        }//end else if
	   ///////////// add bgp peer group validations
	   else if (divname == "add_bgppeersetteings") 
	   {
		   var keeptimerobj = document.getElementById("keep_timer");
		   var holdtimerobj = document.getElementById("hold_timer");
		   var keeptimval = keeptimerobj.value.trim();
		   var holdtimeval = holdtimerobj.value.trim();
			
		  if(keeptimval == "" && parseInt(holdtimeval)<180 ) 
			{
				altmsg += "Hold Timer must be  greater than 3 times the KeepAlive Timer default value 60\n";
				keeptimerobj.style.outline = "thin solid red";
			}
		  else if(holdtimeval == "" && parseInt(keeptimval)>60 ) 
			{
				altmsg += "Hold Timer must be  greater than 3 times the KeepAlive Timer\n";
				keeptimerobj.style.outline = "thin solid red";
			}
	
		  else if(parseInt(keeptimval) == 0 && parseInt(holdtimeval) != 0 && parseInt(holdtimeval) < 3) 
			{
				altmsg += "Hold Timer must be  greater than 2\n";
				holdtimerobj.style.outline = "thin solid red";
			}
	
		  else if(keeptimval!=""&&holdtimeval!=""&&parseInt(holdtimeval)<3 *parseInt(keeptimval)) 
			{
				altmsg += "Hold Timer must be  greater than 3  times the KeepAlive Timer\n";
				keeptimerobj.style.outline = "thin solid red";
				holdtimerobj.style.outline = "thin solid red";
			}
	
			else
			{
				keeptimerobj.style.outline = "initial";
				holdtimerobj.style.outline = "initial";
			}
		  
		  var updsurobj = document.getElementById("update_source");	
		  valid = validateIPOnly('update_source', false, 'Update Source');
	         if (!valid) {
	            if (updsurobj.value.trim() == "") 
					altmsg += "Update Source should not be empty\n";
	            else 
					altmsg += "Update Source is not valid\n";
	         }
			var ttlobj=document.getElementById("ttl_check");
			var geneobj=document.getElementById("ttl_hops");
			if(ttlobj.checked)
			{
				if(geneobj.value.trim()==0)
				{
					altmsg += "Hops(1-255) should not be empty\n";
					geneobj.style.outline = "thin solid red";
				}
				else
				{
				geneobj.style.outline = "initial";
				geneobj.title="";
				}
			}
			
	  }
	else if (divname == "add_bgppath") {
		  /*var neighobj=document.getElementById("neighfr_ip");
			valid = validateIPOnly('neighfr_ip', false, 'Neighbour IP');
	         if (!valid) {
	            if (neighobj.value.trim() == "") 
					altmsg += "Neighbour IP should not be empty\n";
	            else 
					altmsg += "Neighbour IP is not valid\n";
	         }*/
		  
	   }
	   
	   /*else if(divname=="path_summarization")
	   {
	   var nwaddrobj = document.getElementById("nwaddr");	
		  valid = validateCIDRNotation('nwaddr',false,'New Address');
	         if (!valid) {
	            if (nwaddrobj.value.trim() == "") 
					altmsg += " New Address should not be empty\n";
	            else 
					altmsg += " New Address is not valid\n";
					}
		}*/
	else if(divname=="add_pathsum")
	   {
	   var addressobj = document.getElementById("summ_addr");	
		  valid = validateCIDRNotation('summ_addr', true, 'Address');
	         if (!valid) {
	            if (addressobj.value.trim() == "") 
					altmsg += "Address should not be empty\n";
	            else 
					altmsg += "Address is not valid\n";
	         }
			 else if(duplicateAddressExists("summ_addr","bgppathsummconfig",false))
			{
			
			    if(addressobj.value.trim() != document.getElementById("oldsumm_addr").value.trim())
					altmsg +=addressobj.value.trim()+" is already Exists";
				else
				addressobj.style.outline = "initial";
			}
	   }//else if
	   if (altmsg.trim().length == 0) {
	      return true;
	   } else {
	      alert(altmsg);
	      return false;
	   }
	   }catch(e)
		{
		alert(e);
		}
	}
	
	<!-- Modification starts  -->
	function showpassword(intprefix) {
	   var cbobj = document.getElementById(intprefix + "authentication");
	   var pwdrow = document.getElementById(intprefix + "Password");
	   var pwdobj =  document.getElementById(intprefix + "pwd");
	   if (cbobj.value == "disabled") {
	      pwdrow.style.display = 'none';
	      pwdobj.value="";
	   } else {
	      pwdrow.style.display = '';
		  if(cbobj.value=="Plain Text")
				pwdobj.maxLength=8;
		  else
				pwdobj.maxLength=16;			
	   }
	}
	function clearpwd(clr_intprefix)
	{
		var clr_cbobj = document.getElementById(clr_intprefix + "authentication");
		var clr_pwdobj = document.getElementById(clr_intprefix + "pwd");
		if(clr_cbobj.value =="MD5")
			clr_pwdobj.value = "";
		else if(clr_cbobj.value =="Plain Text")
			clr_pwdobj.value = "";
	}
	/*Modification ends  */ 
	</script>
	</head>
	<body>
		<p class="style5" id="title" align="center">Dynamic Routing</p>
		<br>
		<div align="center">
			<table class="borderlesstab nobackground"
				style="width: 660px;; margin-bottom: 0px; margin-bottom: 0px;">
				<tbody>
					<tr style="padding: 0px; margin: 0px;">
						<td style="padding: 0px; margin: 0px;">
							<ul id="droutediv">
								<li><a class="casesense droutelist" style="cursor: pointer"
									id="hilightthis"
									onclick="showPDivision('ospfdiv','<%=slnumber%>','<%=version%>')">OSPFV2</a></li>
								<li><a class="casesense droutelist" style="cursor: pointer"
									id=""
									onclick="showPDivision('ospfv3div','<%=slnumber%>','<%=version%>')">OSPFV3</a></li>
								<li><a class="casesense droutelist" style="cursor: pointer"
									onclick="showPDivision('bgpdiv','<%=slnumber%>','<%=version%>')"
									id="">BGP4</a></li>
	
							</ul>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	
		<div id="ospfdiv" style="">
			<!-- modified global_config to ospf2_instance -->
			<form
				action="savedetails.jsp?page=ospfv2&slnumber=<%=slnumber%>&version=<%=version%>"
				method="post" onsubmit="return validateOSPF2('curdiv')">
				<table class="borderlesstab nobackground"
					style="width: 660px;; margin-bottom: 0px;" id="simtype"
					align="center">
					<input type="hidden" style="margin: 0px; padding: 0px"
						id="subdivpage" name="subdivpage" value="ospf2_instance">
					<!-- modified global_config to ospf2_instance -->
					<tbody>
						<tr style="padding: 0px; margin: 0px;">
							<td style="padding: 0px; margin: 0px;">
								<ul id="configtypediv">
									<li><a class="casesense ospflist" id="hilightthis"
										style="cursor: pointer"
										onclick="showDivision('ospf2_instance','ospflist','<%=slnumber%>','<%=version%>')">Instance</a></li>
									<!-- modified global_config to ospf2_instance -->
									<li><a class="casesense ospflist"
										style="cursor: pointer; margin-left: 60px;"
										onclick="showDivision('networks','ospflist','<%=slnumber%>','<%=version%>')"
										id="">Networks</a></li>
									<li><a class="casesense ospflist"
										style="cursor: pointer; margin-left: 60px;" id=""
										onclick="showDivision('interface_config','ospflist','<%=slnumber%>','<%=version%>')">Interface
											Config</a></li>
									<li><a class="casesense ospflist"
										style="cursor: pointer; margin-left: 70px;"
										onclick="showDivision('area_config','ospflist','<%=slnumber%>','<%=version%>')"
										id="">Area</a></li>
									<!-- <li><a class="casesense ospflist" style="cursor:pointer" onclick="showDivision('neighbour','ospflist')" id="">Neighbours</a></li> -->
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
				<div id="ospf2_instance" style="margin: 0px;" align="center">
					<table id="globalconfig" class="borderlesstab" style="width: 660px;"
						align="center">
						<tbody>
							<tr>
								<th width="300px">Parameters</th>
								<th width="300px">Configuration</th>
							</tr>
							<tr>
								<%
								if (ospfdefobj.containsKey("Ospf4"))
									act = ospfdefobj.getString("Ospf4").equals("enable") ? "checked" : "";
								%>
								<td>Enable</td>
								<td><label class="switch" style="vertical-align: middle"><input
										type="checkbox" name="intf_ospfv2" id="intf_ospfv2"
										style="vertical-align: middle" <%=act%>><span
										class="slider round"></span></label></td>
							</tr>
							<tr id="route_id_auto">
								<td>Router-ID (Auto)</td>
								<%
								autoroute = ospfdefobj.containsKey("auto_routerid")
										? ospfdefobj.getString("auto_routerid").equals("on") ? "checked" : ""
										: !ospfdefobj.containsKey("routerid") ? "checked" : "";
								%>
								<td><label class="switch" style="vertical-align: middle"><input
										type="checkbox" name="ospf_autocheck" id="ospf_autocheck"
										style="vertical-align: middle" <%=autoroute%>
										onclick="ospfRouIdConfig()"
										onchange="hideAutoFields('route_id','ospf_autocheck')"><span
										class="slider round"></span></label></td>
							</tr>
							<tr id="route_id">
								<td>Router-ID</td>
								<%
								String routeid = ospfdefobj != null
										? (!ospfdefobj.containsKey("routerid") ? "" : ospfdefobj.getString("routerid"))
										: "";
								%>
								<td><input type="text" name="ospf_routerid"
									id="ospf_routerid" class="text" value="<%=routeid%>"
									onkeypress="return avoidSpace(event)"
									onfocusout="validateIP('ospf_routerid',false,'Router-ID');"
									style="outline: initial;" title="">&nbsp;</td>
							</tr>
							<tr>
								<td>Administrative Distance (1-255)</td>
								<%
								String admdis = ospfdefobj != null
										? (!ospfdefobj.containsKey("adm_dis") ? "110" : ospfdefobj.getString("adm_dis"))
										: "";
								%>
								<td><input type="number" name="adm_dis" id="adm_dis" min="1"
									max="255" value="<%=admdis%>" class="text"
									onkeypress="return avoidSpace(event)"></td>
							</tr>
							<td>Default Metric (1-16777214)</td>
							<%
							String defmet = ospfdefobj != null
									? (!ospfdefobj.containsKey("deflt_metric") ? "" : ospfdefobj.getString("deflt_metric"))
									: "";
							%>
							<td><input type="number" name="deflt_metric"
								id="deflt_metric" min="1" max="16777214" value="<%=defmet%>"
								class="text" onkeypress="return avoidSpace(event)"></td>
							</tr>
							<tr>
								<td>Auto-Cost Referernce BW (1-4294967 Mbits)</td>
								<%
								String refbw = ospfdefobj != null ? (!ospfdefobj.containsKey("ref_bw") ? "100" : ospfdefobj.getString("ref_bw")) : "";
								%>
								<td><input type="number" name="ref_bw" id="ref_bw" min="1"
									max="4294967" value="<%=refbw%>" class="text"
									onkeypress="return avoidSpace(event)"></td>
							</tr>
							<tr>
								<td>Default Information Originate</td>
								<%
								if (ospfdefobj.containsKey("dfo"))
									definfo = ospfdefobj.getString("dfo").equals("on") ? "checked" : "";
								%>
								<td><label class="switch"><input type="checkbox"
										name="dfo" id="dfo" <%=definfo%> style="vertical-align: middle"
										onchange="hideDefalutInfoOrg()"><span
										class="slider round"></span></label> <span id="span_dfo_alw"
									style="vertical-align: top; padding-left: 5px;"> <%
	 if (ospfdefobj.containsKey("dfo_alw"))
	 	def_alwys = ospfdefobj.getString("dfo_alw").equals("on") ? "checked" : "";
	 %> <input type="checkbox" id="dfo_alw" name="dfo_alw" <%=def_alwys%>
										style="vertical-align: middle;"></input><label
										style="vertical-align: bottom; padding-left: 5px;">Always</label></span></td>
							</tr>
						</tbody>
					</table>
					<table class="borderlesstab" style="width: 660px;" id="redistribute"
						align="center">
						<input type="text" id="redistributecnt" name="redistributecnt"
							value="1" hidden="">
						<tbody>
							<tr>
								<p class="style5" id="title" align="center">Redistribute</p>
								<th style="text-align: center;" width="30px" align="center">SlNo</th>
								<th style="text-align: center;" width="30px" align="center">Links</th>
								<th style="text-align: center;" width="10px" align="center">Metric
									Type</th>
								<th style="text-align: center;" width="10px" align="center">Metric</th>
								<th style="text-align: center;" width="10px" align="center">Action</th>
							</tr>
						</tbody>
					</table>
					<%
					if (redisarr.size() > 0) {
						for (int i = 0; i < redisarr.size(); i++) {
							String resvals = redisarr.getString(i);
							String row = i + 1 + "";
							String linksval = "";
							String typevals = "";
							String metricvals = "";
							String resarr[] = resvals.split("/");
							if (resarr[0].equals("kernel"))
						linksval = "Static Routes";
							else if (resarr[0].equals("connected"))
						linksval = "Connected Routes";
							else
						linksval = "BGP Routes";
							if (resarr[1].equals("1"))
						typevals = "type1";
							else
						typevals = "type2";
							if (resarr[2].equals("-"))
						metricvals = "";
							else
						metricvals = resarr[2];
					%>
					<script>		
				 addRow('redistribute');
				 fillResRow(<%=(i + 1)%>,'<%=linksval%>','<%=typevals%>','<%=metricvals%>')
				 </script>
					<%
					}
					}
					%>
					<div align="center">
						<input class="button" type="button" id="add" value="Add"
							style="display: inline block" onclick="addRow('redistribute')">
					</div>
					<br> <br>
					<div align="center">
						<input type="submit" value="Apply" name="Apply"
							style="display: inline block" class="button">
					</div>
				</div>
				<div id="networks" style="margin: 0px; display: none;" align="center">
					<input type="text" id="netwrkrwcnt" name="netwrkrwcnt" value="1"
						hidden="">
						<input type="hidden" style="margin: 0px; padding: 0px"
						id="subdivpage" name="subdivpage" value="networks">
					<table class="borderlesstab" style="width: 660px;"
						id="networkconfig" align="center">
						<tbody>
							<tr>
								<th style="text-align: center;" width="30px" align="center">S.No</th>
								<th style="text-align: center;" width="10px" align="center">Network</th>
								<th style="text-align: center;" width="10px" align="center">Subnet</th>
								<th style="text-align: center;" width="30px" align="center">Area</th>
								<th style="text-align: center;" width="90px" align="center">Action</th>
							</tr>
						</tbody>
					</table>
					<div align="center">
						<input class="button" type="button" id="add" value="Add"
							style="display: inline block" onclick="addRow('networkconfig')">
					</div>
					<br>
					<div align="center">
						<input type="submit" value="Apply" name="Apply"
							style="display: inline block" class="button">
					</div>
				</div>
				<%
				if (nwarr.size() > 0) {
					for (int i = 0; i < nwarr.size(); i++) {
						String vals = nwarr.getString(i);
						String row = i + 1 + "";
						String ipval = "";
						String netmaskval = "";
						String areaval = "";
						String valsarr[] = vals.split("/");
						SubnetUtils utils = new SubnetUtils(valsarr[0].concat("/" + valsarr[1]));
						areaval = valsarr[2];
				%>
				<script>		
				 addRow('networkconfig');	
				 fillrow(<%=(i + 1)%>,'<%=utils.getInfo().getAddress()%>','<%=utils.getInfo().getNetmask()%>','<%=areaval%>');
				 </script>
				<%
				}
				}
				%>
				<div id="interface_config" style="margin: 0px; display: none;"
					align="center">
					<div id="eth0div" style="margin: 0px; display: inline;">
						<table class="borderlesstab" style="width: 660px;"
							id="interfaceconfig" align="center">
							<input type="hidden" style="margin: 0px; padding: 0px"
						id="subdivpage" name="subdivpage" value="interface_config">
							<tbody>
								<tr>
									<th>Parameters</th>
									<th>Configuration</th>
								</tr>
								<tr>
									<td>Interface</td>
									<td><select class="text" id="e0interfacecnfg"
										name="e0interfacecnfg"
										onchange="showSelIntf('e0interfacecnfg')">
											<option value="Eth0">LAN</option>
											<option value="Eth1">WAN</option>
											<!-- <option value="Loopback">Loopback</option>-->
									</select></td>
								</tr>
							</tbody>
						</table>
	
						<table class="borderlesstab" style="width: 660px;"
							id="e0inter_config" align="center">
							<tbody>
								<tr>
									<%
									if (ospfeth0obj.containsKey("passive"))
										eth0pass = ospfeth0obj.getString("passive").equals("on") ? "checked" : "";
									%>
									<td>Passive</td>
									<td><label class="switch" style="vertical-align: middle"><input
											type="checkbox" name="e0passive_int" id="e0passive_int"
											<%=eth0pass%> style="vertical-align: middle"><span
											class="slider round"></span></label></td>
								</tr>
								<tr>
									<%
									String hel_time = ospfeth0obj != null
											? (!ospfeth0obj.containsKey("hello_time") ? "10" : ospfeth0obj.getString("hello_time"))
											: "";
									%>
									<td>Hello Interval (1-65535)</td>
									<td><input type="number" name="e0heloIntrvl"
										id="e0heloIntrvl" value="<%=hel_time%>" min="1" max="65535"
										class="text" onkeypress="return avoidSpace(event)"></td>
								</tr>
								<tr>
									<%
									String dead_time = ospfeth0obj != null
											? (!ospfeth0obj.containsKey("dead_time") ? "40" : ospfeth0obj.getString("dead_time"))
											: "";
									%>
									<td>Dead Interval (1-65535)</td>
									<td><input type="number" name="e0deadIntrvl"
										value="<%=dead_time%>" id="e0deadIntrvl" min="1" max="65535"
										class="text" onkeypress="return avoidSpace(event)"></td>
								</tr>
								<tr>
									<td>Authentication</td>
									<%
									String authval = ospfeth0obj != null
											? (!ospfeth0obj.containsKey("authentication") ? "" : ospfeth0obj.getString("authentication"))
											: "disabled";
									%>
									<td><select class="text" id="e0authentication"
										name="e0authentication" onchange="showpassword('e0');clearpwd('e0');showOrHideMd5KeyID('e0authentication','e0keyid','e0pwdinfo')">
											<option value="disabled" <%if (authval.equals("disabled")) {%>
												selected <%}%>>Disabled</option>
											<option value="Plain Text"
												<%if (authval.equals("Plain Text")) {%> selected <%}%>>Plain
												Text</option>
											<option value="MD5" <%if (authval.equals("MD5")) {%> selected
												<%}%>>MD5</option>
									</select>&nbsp;
									<%String e0keyid = ospfeth0obj != null?(!ospfeth0obj.containsKey("md5_key") ? "1" : ospfeth0obj.getString("md5_key")): ""; %> 
									<input type="number"
									name="e0keyid" id="e0keyid" min="1" max="255"
									placeholder="Key ID(1-255)" value="<%=e0keyid%>"
									style="width: 100px; min-width: 100px;" class="text"
									onkeypress="return avoidSpace(event)"></td>
								</tr>
								<tr id="e0Password" style="display: none;">
									<td>Password</td>
									<%
									String eth0pwd = ospfeth0obj != null
											? (!ospfeth0obj.containsKey("password") ? "" : ospfeth0obj.getString("password"))
											: "";
									%>
									<td><input id="e0pwd" class="text" type="password"
										name="e0pwd" value="<%=eth0pwd%>" onkeypress="return avoidSpace(event)" onfocusout="OspfPwdCheck('e0pwd');" ><span
										toggle="#password-field" 
										class="fa fa-fw fa-eye field_icon e0toggle-password"></span>
										 <img  src="images/i_sym.jpg" alt="i" width="15" height="10" title="Info" id="pwdshow" style="cursor:pointer" onclick="showOrHidePWDInfo('e0pwdinfo')"/>
										<dialog id="e0pwdinfo" class="Popup">  
											<p>&#8226;Excluded characters " ' : ;</p>
					                     </dialog>
					                  <br/>
                  						<p id="e0pwdstr"></p>
								</td>
								</tr>
								<tr>
									<td>Network Type</td>
									<td>
										<%
										String nwtype = ospfeth0obj != null
												? (!ospfeth0obj.containsKey("network_type") ? "" : ospfeth0obj.getString("network_type"))
												: "";
										%> <select class="text" id="e0ospf_network_type"
										name="e0ospf_network_type">
											<option value="broadcast"
												<%if (nwtype.equals("broadcast")) {%> selected <%}%>>Broadcast</option>
											<option value="non-broadcast"
												<%if (nwtype.equals("non-broadcast")) {%> selected <%}%>>Non-Broadcast</option>
											<option value="point-to-multipoint"
												<%if (nwtype.equals("point-to-multipoint")) {%> selected
												<%}%>>Point-MultiPoint</option>
											<option value="point-to-point"
												<%if (nwtype.equals("point-to-point")) {%> selected <%}%>>Point-Point</option>
									</select>
									</td>
								</tr>
								<td>Interface Cost (Auto)</td>
								<%
								eth0autocost = ospfeth0obj.containsKey("auto_cost")
										? ospfeth0obj.getString("auto_cost").equals("on") ? "checked" : ""
										: !ospfeth0obj.containsKey("cost_value") ? "checked" : "";
								%>
								<td><label class="switch" style="vertical-align: middle"><input
										type="checkbox" name="e0intrfcost_check" id="e0intrfcost_check"
										<%=eth0autocost%> style="vertical-align: middle"
										onclick="interfacecostConfig('e0intrfcost')"
										onchange="hideAutoFields('e0_int_cost','e0intrfcost_check')"><span
										class="slider round"></span></label></td>
								</tr>
								<tr id="e0_int_cost">
									<td>Interface Cost (1-65535)</td>
									<%
									String incost = ospfeth0obj != null
											? (!ospfeth0obj.containsKey("cost_value") ? "" : ospfeth0obj.getString("cost_value"))
											: "";
									%>
									<td><input type="number" name="e0intrfcost"
										id="e0intrfcost" min="1" max="65535" value="<%=incost%>"
										class="text" onkeypress="return avoidSpace(event)"
										onfocusout="validateRange('e0intrfcost',true,'Interface Cost (1-65535)')">
									</td>
								</tr>
								<tr>
									<td>Router Priority (0-255)</td>
									<%
									String routepr = ospfeth0obj != null
											? (!ospfeth0obj.containsKey("priority") ? "1" : ospfeth0obj.getString("priority"))
											: "";
									%>
									<td><input type="number" name="e0router_priority"
										value="<%=routepr%>" id="e0router_priority" min="0" max="255"
										class="text" onkeypress="return avoidSpace(event)"></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div id="eth1div" style="margin: 0px; display: none;">
						<table class="borderlesstab" style="width: 660px;"
							id="interfaceconfig" align="center">
							<tbody>
								<tr>
									<th>Parameters</th>
									<th>Configuration</th>
								</tr>
								<tr>
									<td>Interface</td>
									<td><select class="text" id="e1interfacecnfg"
										name="e1interfacecnfg"
										onchange="showSelIntf('e1interfacecnfg')">
											<option value="Eth0">LAN</option>
											<option value="Eth1" selected="">WAN</option>
											<!-- <option value="Loopback">Loopback</option>-->
									</select></td>
								</tr>
							</tbody>
						</table>
						<table class="borderlesstab" style="width: 660px;"
							id="e1inter_config" align="center">
							<tbody>
								<tr>
									<td>Passive</td>
									<%
									if (ospfeth1obj.containsKey("passive"))
										eth1pass = ospfeth1obj.getString("passive").equals("on") ? "checked" : "";
									%>
									<td><label class="switch" style="vertical-align: middle"><input
											type="checkbox" name="e1passive_int" <%=eth1pass%>
											id="e1passive_int" style="vertical-align: middle"><span
											class="slider round"></span></label></td>
								</tr>
								<tr>
									<td>Hello Interval (1-65535)</td>
									<%
									String eth1hel_time = ospfeth1obj != null
											? (!ospfeth1obj.containsKey("hello_time") ? "10" : ospfeth1obj.getString("hello_time"))
											: "";
									%>
									<td><input type="number" name="e1heloIntrvl"
										id="e1heloIntrvl" value="<%=eth1hel_time%>" min="1" max="65535"
										class="text" onkeypress="return avoidSpace(event)"></td>
								</tr>
								<tr>
									<td>Dead Interval (1-65535)</td>
									<%
									String eth1dead_time = ospfeth1obj != null
											? (!ospfeth1obj.containsKey("dead_time") ? "40" : ospfeth1obj.getString("dead_time"))
											: "";
									%>
									<td><input type="number" name="e1deadIntrvl"
										value="<%=eth1dead_time%>" id="e1deadIntrvl" min="1"
										max="65535" class="text" onkeypress="return avoidSpace(event)"></td>
								</tr>
								<tr>
									<td>Authentication</td>
									<td>
										<%
										String eth1authval = ospfeth1obj != null
												? (!ospfeth1obj.containsKey("authentication") ? "" : ospfeth1obj.getString("authentication"))
												: "disabled";
										%> <select class="text" id="e1authentication"
										name="e1authentication" onchange="showpassword('e1');clearpwd('e1');showOrHideMd5KeyID('e1authentication','e1keyid','e1pwdinfo')">
											<option value="disabled"
												<%if (eth1authval.equals("disabled")) {%> selected <%}%>>Disabled</option>
											<option value="Plain Text"
												<%if (eth1authval.equals("Plain Text")) {%> selected <%}%>>Plain
												Text</option>
											<option value="MD5" <%if (eth1authval.equals("MD5")) {%>
												selected <%}%>>MD5</option>
									</select>
									&nbsp;
									<%String e1keyid = ospfeth1obj != null?(!ospfeth1obj.containsKey("md5_key") ? "1" : ospfeth1obj.getString("md5_key")): ""; %> 
									 <input type="number"
									name="e1keyid" id="e1keyid" min="1" max="255"
									placeholder="Key ID(1-255)" value="<%=e1keyid%>"
									style="width: 100px; min-width: 100px;" class="text"
									onkeypress="return avoidSpace(event)">
									</td>
								</tr>
								<tr id="e1Password" style="display: none;">
									<td>Password</td>
									<%
									String eth1pwd = ospfeth1obj != null
											? (!ospfeth1obj.containsKey("password") ? "" : ospfeth1obj.getString("password"))
											: "";
									%>
									<td><input id="e1pwd" class="text" type="password"
										name="e1pwd" maxlength="16" value="<%=eth1pwd%>" onkeypress="return avoidSpace(event)" onfocusout="OspfPwdCheck('e1pwd');"><span
										toggle="#password-field"
										class="fa fa-fw fa-eye field_icon e1toggle-password"></span>
										 <img  src="images/i_sym.jpg" alt="i" width="15" height="10" title="Info" id="pwdshow" style="cursor:pointer" onclick="showOrHidePWDInfo('e1pwdinfo')"/>
										<dialog id="e1pwdinfo" class="Popup">  
											<p>&#8226;Excluded characters " ' : ;</p>
					                     </dialog>
					                  <br/>
                  						<p id="e1pwdstr"></p>
								</td>
								</tr>
								<tr>
									<td>Network Type</td>
									<td>
										<%
										String eth1nwtype = ospfeth1obj != null
												? (!ospfeth1obj.containsKey("network_type") ? "" : ospfeth1obj.getString("network_type"))
												: "";
										%> <select class="text" id="e1ospf_network_type"
										name="e1ospf_network_type">
											<option value="broadcast"
												<%if (eth1nwtype.equals("broadcast")) {%> selected <%}%>>Broadcast</option>
											<option value="non-broadcast"
												<%if (eth1nwtype.equals("non-broadcast")) {%> selected <%}%>>Non-Broadcast</option>
											<option value="point-to-multipoint"
												<%if (eth1nwtype.equals("point-to-multipoint")) {%> selected
												<%}%>>Point-MultiPoint</option>
											<option value="point-to-point"
												<%if (eth1nwtype.equals("point-to-point")) {%> selected <%}%>>Point-Point</option>
									</select>
									</td>
								</tr>
								<tr>
									<td>Interface Cost (Auto)</td>
									<%
									eth1autocost = ospfeth1obj.containsKey("auto_cost")
											? ospfeth1obj.getString("auto_cost").equals("on") ? "checked" : ""
											: !ospfeth1obj.containsKey("cost_value") ? "checked" : "";
									%>
									<td><label class="switch" style="vertical-align: middle"><input
											type="checkbox" name="e1intrfcost_check"
											id="e1intrfcost_check" style="vertical-align: middle"
											<%=eth1autocost%> onclick="interfacecostConfig('e1intrfcost')"
											onchange="hideAutoFields('e1_int_cost','e1intrfcost_check')"><span
											class="slider round"></span></label></td>
								</tr>
	
								<tr id="e1_int_cost">
									<td>Interface Cost (1-65535)</td>
									<%
									String eth1incost = ospfeth1obj != null
											? (!ospfeth1obj.containsKey("cost_value") ? "" : ospfeth1obj.getString("cost_value"))
											: "";
									%>
									<td><input type="number" name="e1intrfcost"
										id="e1intrfcost" min="1" value="<%=eth1incost%>" max="65535"
										class="text" onkeypress="return avoidSpace(event)"
										onfocusout="validateRange('e1intrfcost',true,'Interface Cost (1-65535)')"></td>
								<tr>
								<tr>
									<td>Router Priority (0-255)</td>
									<%
									String eth1routepr = ospfeth1obj != null
											? (!ospfeth1obj.containsKey("priority") ? "1" : ospfeth1obj.getString("priority"))
											: "";
									%>
									<td><input type="number" name="e1router_priority"
										value="<%=eth1routepr%>" id="e1router_priority" min="0"
										max="255" class="text" onkeypress="return avoidSpace(event)"></td>
								</tr>
							</tbody>
						</table>
					</div>
					<input type="hidden" id="e0ospf_a_type_hid" value="" /> <input
						type="hidden" id="e1ospf_a_type_hid" value="" /> <br>
					<div align="center">
						<input type="submit" value="Apply" name="Apply"
							style="display: inline block" class="button">
					</div>
				</div>
	
				<div id="area_config" style="margin: 0px; display: none;"
					align="center">
					<input type="text" id="areacnt" name="areacnt" value="1" hidden="">
					<input type="hidden" style="margin: 0px; padding: 0px"
						id="subdivpage" name="subdivpage" value="area_config">
					<table class="borderlesstab" style="width: 660px;" id="areaconfig"
						align="center">
						<tbody>
							<tr>
								<th style="text-align: center;" width="30px" align="center">S.No</th>
								<th style="text-align: center;" width="10px" align="center">Area
									Id</th>
								<th style="text-align: center;" width="10px" align="center">Type</th>
								<th style="text-align: center;" width="30px" align="center">Summarise
									Inter Area</th>
								<th style="text-align: center;" width="90px" align="center">Action</th>
							</tr>
						</tbody>
					</table>
					<div align="center">
						<input class="button" type="button" id="add" value="Add"
							style="display: inline block" onclick="addRow('areaconfig')">
					</div>
					<br>
					<div align="center">
						<input type="submit" value="Apply" name="Apply"
							style="display: inline block" class="button">
					</div>
				</div>
			</form>
			<%
			if (areaarr.size() > 0) {
				for (int i = 0; i < areaarr.size(); i++) {
					String areavals = areaarr.getString(i);
					String areaidval = "";
					String typevals = "";
					String sumervals = "";
					String areavalsarr[] = areavals.split("\\|");
					areaidval = areavalsarr[0];
			  if (areavalsarr[1].equals("@"))
				 typevals = "-";
			  else if (areavalsarr[1].equals("stub"))
				typevals = "Stub";
			  else if (areavalsarr[1].equals("totally-stub"))
				typevals = "Totally Stub";
			  else if (areavalsarr[1].equals("nssa"))
				typevals = "NSSA";
			  else
				typevals = "Totally NSSA";
			  if(areavalsarr.length==3)
			  {
				if(areavalsarr[2].equals("@"))	
				   sumervals = "";
				else
				   sumervals = areavalsarr[2];
			  }
			  else
				sumervals = "";
			%>
			<script>		
				 addRow('areaconfig');
				 fillAreaRow(<%=(i + 1)%>,'<%=areaidval%>','<%=typevals%>','<%=sumervals%>');
				 </script>
			<%
			}
			}
			%>
		</div>
		<div id="ospfv3div" style="margin: 0.2px; display: none;" width="800px"
			align="center">
			<form action="savedetails.jsp?page=ospfv3&slnumber=<%=slnumber%>"
				method="post" onsubmit="return validateOSPF3('curdiv')">
				<table class="borderlesstab nobackground"
					style="width: 660px;; margin-bottom: 0px;" id="simtype"
					align="center">
					<input type="hidden" style="margin: 0px; padding: 0px"
						id="ospf3_subdivpage" name="ospf3_subdivpage"
						value="ospf3_instance">
					<!-- modified global_config to ospf2_instance -->
					<tbody>
						<tr style="padding: 0px; margin: 0px;">
							<td style="padding: 0px; margin: 0px;">
								<ul id="ospf3list">
									<li><a class="casesense ospf3list" id="hilightthis"
										style="cursor: pointer"
										onclick="showDivision('ospf3_instance','ospf3list','<%=slnumber%>','<%=version%>')">Instance</a></li>
									<li><a class="casesense ospf3list"
										style="cursor: pointer; margin-left: 60px;"
										onclick="showDivision('interface_v3','ospf3list','<%=slnumber%>','<%=version%>')"
										id="">Interfaces</a></li>
									<li><a class="casesense ospf3list"
										style="cursor: pointer; margin-left: 60px;" id=""
										onclick="showDivision('interface_config_v3','ospf3list','<%=slnumber%>','<%=version%>')">Interface
											Config</a></li>
									<li><a class="casesense ospf3list"
										style="cursor: pointer; margin-left: 70px;"
										onclick="showDivision('area_config_v3','ospf3list','<%=slnumber%>','<%=version%>')"
										id="">Area</a></li>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
				<div id="ospf3_instance" style="margin: 0px;" align="center">
					<table id="globalconfigv3tab" class="borderlesstab"
						style="width: 660px;" align="center">
						<tbody>
							<tr>
								<th width="300px">Parameters</th>
								<th width="300px">Configuration</th>
							</tr>
							<tr>
								<td>Enable</td>
								<%
								if (ospf3defobj.containsKey("Ospf6"))
									v3act = ospf3defobj.getString("Ospf6").equals("enable") ? "checked" : "";
								%>
								<td><label class="switch" style="vertical-align: middle"><input
										type="checkbox" name="intf_ospf_v3" <%=v3act%>
										id="intf_ospf_v3" style="vertical-align: middle"><span
										class="slider round"></span></label></td>
							</tr>
							<tr id="route_id_auto">
								<td>Router-ID (Auto)</td>
								<%
								v3autoroute = ospf3defobj.containsKey("auto_routerid")
										? ospf3defobj.getString("auto_routerid").equals("on") ? "checked" : ""
										: !ospf3defobj.containsKey("routerid") ? "checked" : "";
								%>
								<td><label class="switch" style="vertical-align: middle"><input
										type="checkbox" name="ospf_autocheck_v3" <%=v3autoroute%>
										id="ospf_autocheck_v3" style="vertical-align: middle"
										onclick="ospfRouIdConfigv3()"
										onchange="hideAutoFields('route_id_v3','ospf_autocheck_v3')"><span
										class="slider round"></span></label></td>
							</tr>
							<tr id="route_id_v3">
								<td>Router-ID</td>
								<%
								String routeval = ospf3defobj != null
										? (!ospf3defobj.containsKey("routerid") ? "" : ospf3defobj.getString("routerid"))
										: "";
								%>
								<td><input type="text" name="ospf_routerid_v3"
									id="ospf_routerid_v3" class="text" value="<%=routeval%>"
									onkeypress="return avoidSpace(event)"
									onfocusout="validateIP('ospf_routerid_v3',true,'Router-ID');"
									style="outline: initial;" title="">&nbsp;</td>
							</tr>
							<tr>
								<td>Administrative Distance (1-255)</td>
								<%
								String v3admdis = ospf3defobj != null
										? (!ospf3defobj.containsKey("adm_dis") ? "110" : ospf3defobj.getString("adm_dis"))
										: "";
								%>
								<td><input type="number" name="adm_dis_v3" id="adm_dis_v3"
									min="1" max="255" value="<%=v3admdis%>" class="text"
									onkeypress="return avoidSpace(event)"></td>
							</tr>
							<!--  <tr>
	                        <td>Default Metric (1-16777214)</td>
	                        <td><input type="number" name="deflt_metric_v3" id="deflt_metric_v3" min="1" max="16777214" class="text" onkeypress="return avoidSpace(event)"></td>
	                     </tr> -->
							<tr>
								<td>Auto-Cost Referernce BW (1-4294967 Mbits)</td>
								<%
								String v3autocost = ospf3defobj != null
										? (!ospf3defobj.containsKey("ref_bw") ? "100" : ospf3defobj.getString("ref_bw"))
										: "";
								%>
								<td><input type="number" name="ref_bw_v3" id="ref_bw_v3"
									min="1" max="4294967" value="<%=v3autocost%>" class="text"
									onkeypress="return avoidSpace(event)"></td>
							</tr>
							<!-- <tr>
						 <td>Default Information Originate</td>
	                        <td><label class="switch"><input type="checkbox" name="dfo_v3" id="dfo_v3" style="vertical-align:middle"  onchange="hideDefalutInfoOrg3()"><span class="slider round"></span></label>
							<span id="span_dfo_alw_v3" style="vertical-align:top;padding-left:5px;"><input type="checkbox" id="dfo_alw_v3" style="vertical-align:middle;"></input><label style="vertical-align:bottom;padding-left:5px;">Always</label></span></td>
						  </tr> -->
							<tr>
								<td>Redistribute</td>
								<td><select id="protos" name="protos" multiple="multiple"
									style="display: none;">
										<option value="connected"
											<%if (v3redisarr.contains("connected")) {%> selected <%}%>>Connected</option>
										<option value="kernel" <%if (v3redisarr.contains("kernel")) {%>
											selected <%}%>>STATIC</option>
										<option value="bgp" <%if (v3redisarr.contains("bgp")) {%>
											selected <%}%>>BGP</option>
								</select></td>
							</tr>
						</tbody>
					</table>
					<div align="center">
						<input type="submit" value="Apply" name="Apply"
							style="display: inline block" class="button">
					</div>
				</div>
				<!-- ospf3_instance div end -->
				<div id="interface_v3" style="margin: 0px; display: none;"
					align="center">
					<input type="text" id="intfv3rwcnt" name="intfv3rwcnt" value="1"
						hidden="">
					<input type="hidden" style="margin: 0px; padding: 0px"
						id="ospf3_subdivpage" name="ospf3_subdivpage"
						value="interface_v3">
					<table class="borderlesstab" style="width: 660px;"
						id="interfacev3tab" align="center">
						<tbody>
							<tr>
								<th style="text-align: center;" width="30px" align="center">S.No</th>
								<th style="text-align: center;" width="30px" align="center">Interfaces</th>
								<th style="text-align: center;" width="200px" align="center">Area
									Id</th>
								<th style="text-align: center;" width="90px" align="center">Action</th>
							</tr>
						</tbody>
					</table>
					<%
					if (v3intfacearr.size() > 0) {
						for (int i = 0; i < v3intfacearr.size(); i++) {
							String intfacevals = v3intfacearr.getString(i);
							String intfceval = "";
							String areaval = "";
							String intfacearr[] = intfacevals.split("/");
							if (intfacearr[0].equals("lo"))
						intfceval = "loopback";
							else
						intfceval = intfacearr[0];
							areaval = intfacearr[1];
							String areavalarr[] = areaval.split("\\.");
							String area = areavalarr[3];
					%>
					<script>		
				 addRow('interfacev3tab');
				 fillOspf3Intf(<%=(i + 1)%>,'<%=intfceval%>','<%=area%>');
				 </script>
					<%
					}
					}
					%>
					<div align="center">
						<input class="button" type="button" id="add" value="Add"
							style="display: inline block" onclick="addRow('interfacev3tab')">
					</div>
					<br>
					<div align="center">
						<input type="submit" value="Apply" name="Apply"
							style="display: inline block" class="button">
					</div>
				</div>
				<!-- interface_v3 div end  -->
				<div id="interface_config_v3" style="margin: 0px; display: none;"
					align="center">
					<div id="eth0div_v3" style="margin: 0px; display: inline;">
					<input type="hidden" style="margin: 0px; padding: 0px"
						id="ospf3_subdivpage" name="ospf3_subdivpage"
						value="interface_config_v3">
						<table class="borderlesstab" style="width: 660px;"
							id="interfaceconfig_v3" align="center">
							<tbody>
								<tr>
									<th>Parameters</th>
									<th>Configuration</th>
								</tr>
								<tr>
									<td>Interface</td>
									<td><select class="text" id="e0interfacecnfg_v3"
										name="e0interfacecnfg_v3"
										onchange="showSelIntfV3('e0interfacecnfg_v3')">
											<option value="Eth0">LAN</option>
											<option value="Eth1">WAN</option>
									</select></td>
								</tr>
							</tbody>
						</table>
						<table class="borderlesstab" style="width: 660px;"
							id="e0inter_config_v3" align="center">
							<tbody>
								<tr>
									<td>Passive</td>
									<%
									if (ospf3eth0obj.containsKey("passive"))
										v3eth0pass = ospf3eth0obj.getString("passive").equals("on") ? "checked" : "";
									%>
									<td><label class="switch" style="vertical-align: middle"><input
											type="checkbox" name="e0passive_int_v3" <%=v3eth0pass%>
											id="e0passive_int_v3" style="vertical-align: middle"><span
											class="slider round"></span></label></td>
								</tr>
								<tr>
									<td>Hello Interval (1-65535)</td>
									<%
									String v3hel_time = ospf3eth0obj != null
											? (!ospf3eth0obj.containsKey("hello_time") ? "10" : ospf3eth0obj.getString("hello_time"))
											: "";
									%>
									<td><input type="number" name="e0heloIntrvl_v3"
										id="e0heloIntrvl_v3" value="<%=v3hel_time%>" min="1"
										max="65535" class="text" onkeypress="return avoidSpace(event)"></td>
								</tr>
								<tr>
									<td>Dead Interval (1-65535)</td>
									<%
									String v3dead_time = ospf3eth0obj != null
											? (!ospf3eth0obj.containsKey("dead_time") ? "40" : ospf3eth0obj.getString("dead_time"))
											: "";
									%>
									<td><input type="number" name="e0deadIntrvl_v3"
										value="<%=v3dead_time%>" id="e0deadIntrvl_v3" min="1"
										max="65535" class="text" onkeypress="return avoidSpace(event)"></td>
								</tr>
								<tr>
									<td>Network Type</td>
									<td>
										<%
										String v3nwtype = ospf3eth0obj != null
												? (!ospf3eth0obj.containsKey("network_type") ? "" : ospf3eth0obj.getString("network_type"))
												: "";
										%> <select class="text" id="e0ospf_network_type_v3"
										name="e0ospf_network_type_v3">
											<option value="broadcast"
												<%if (v3nwtype.equals("broadcast")) {%> selected <%}%>>Broadcast</option>
											<!-- <option value="non-broadcast">Non-Broadcast</option>
	                                 <option value="point-to-multipoint">Point-MultiPoint</option> -->
											<option value="point-to-point"
												<%if (v3nwtype.equals("point-to-point")) {%> selected <%}%>>Point-Point</option>
									</select>
									</td>
								</tr>
								<tr>
									<td>Interface Cost (Auto)</td>
									<%
									v3eth0autocost = ospf3eth0obj.containsKey("auto_cost")
											? ospf3eth0obj.getString("auto_cost").equals("on") ? "checked" : ""
											: !ospf3eth0obj.containsKey("cost_value") ? "checked" : "";
									%>
									<td><label class="switch" style="vertical-align: middle"><input
											type="checkbox" name="e0intrfcost_check_v3"
											id="e0intrfcost_check_v3" <%=v3eth0autocost%>
											style="vertical-align: middle"
											onclick="interfacecostV3Config('e0intrfcost_v3')"
											onchange="hideAutoFields('e0_int_cost_v3','e0intrfcost_check_v3')"><span
											class="slider round"></span></label></td>
								</tr>
								<tr id="e0_int_cost_v3">
									<td>Interface Cost (1-65535)</td>
									<%
									String v3incost = ospf3eth0obj != null
											? (!ospf3eth0obj.containsKey("cost_value") ? "" : ospf3eth0obj.getString("cost_value"))
											: "";
									%>
									<td><input type="number" name="e0intrfcost_v3"
										id="e0intrfcost_v3" min="1" max="65535" value="<%=v3incost%>"
										class="text" onkeypress="return avoidSpace(event)"
										onfocusout="validateRange('e0intrfcost_v3',true,'Interface Cost (1-65535)')">
									</td>
								</tr>
								<tr>
									<td>Router Priority (0-255)</td>
									<%
									String v3routepr = ospf3eth0obj != null
											? (!ospf3eth0obj.containsKey("priority") ? "1" : ospf3eth0obj.getString("priority"))
											: "";
									%>
									<td><input type="number" name="e0router_priority_v3"
										value="<%=v3routepr%>" id="e0router_priority_v3" min="0"
										max="255" class="text" onkeypress="return avoidSpace(event)"></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div id="eth1div_v3" style="margin: 0px; display: none;">
						<table class="borderlesstab" style="width: 660px;"
							id="interfaceconfig" align="center">
							<tbody>
								<tr>
									<th>Parameters</th>
									<th>Configuration</th>
								</tr>
								<tr>
									<td>Interface</td>
									<td><select class="text" id="e1interfacecnfg_v3"
										name="e1interfacecnfg_v3"
										onchange="showSelIntfV3('e1interfacecnfg_v3')">
											<option value="Eth0">LAN</option>
											<option value="Eth1" selected="">WAN</option>
									</select></td>
								</tr>
							</tbody>
						</table>
						<table class="borderlesstab" style="width: 660px;"
							id="e1inter_config" align="center">
							<tbody>
								<tr>
									<td>Passive</td>
									<%
									if (ospf3eth1obj.containsKey("passive"))
										v3eth1pass = ospf3eth1obj.getString("passive").equals("on") ? "checked" : "";
									%>
									<td><label class="switch" style="vertical-align: middle"><input
											type="checkbox" name="e1passive_int_v3" id="e1passive_int_v3"
											<%=v3eth1pass%> style="vertical-align: middle"><span
											class="slider round"></span></label></td>
								</tr>
								<tr>
									<td>Hello Interval (1-65535)</td>
									<%
									String v3eth1hel_time = ospf3eth1obj != null
											? (!ospf3eth1obj.containsKey("hello_time") ? "10" : ospf3eth1obj.getString("hello_time"))
											: "";
									%>
									<td><input type="number" name="e1heloIntrvl_v3"
										id="e1heloIntrvl_v3" value="<%=v3eth1hel_time%>" min="1"
										max="65535" class="text" onkeypress="return avoidSpace(event)"></td>
								</tr>
								<tr>
									<td>Dead Interval (1-65535)</td>
									<%
									String v3eth1dead_time = ospf3eth1obj != null
											? (!ospf3eth1obj.containsKey("dead_time") ? "40" : ospf3eth1obj.getString("dead_time"))
											: "";
									%>
									<td><input type="number" name="e1deadIntrvl_v3"
										value="<%=v3eth1dead_time%>" id="e1deadIntrvl_v3" min="1"
										max="65535" class="text" onkeypress="return avoidSpace(event)"></td>
								</tr>
								<tr>
									<td>Network Type</td>
									<td>
										<%
										String v3eth1nwtype = ospf3eth1obj != null
												? (!ospf3eth1obj.containsKey("network_type") ? "" : ospf3eth1obj.getString("network_type"))
												: "";
										%> <select class="text" id="e1ospf_network_type_v3"
										name="e1ospf_network_type_v3">
											<option value="broadcast"
												<%if (v3eth1nwtype.equals("broadcast")) {%> selected <%}%>>Broadcast</option>
											<!--  <option value="non-broadcast">Non-Broadcast</option>
	                                 <option value="point-to-multipoint">Point-MultiPoint</option> -->
											<option value="point-to-point"
												<%if (v3eth1nwtype.equals("point-to-point")) {%> selected
												<%}%>>Point-Point</option>
									</select>
									</td>
								</tr>
								<tr>
									<td>Interface Cost (Auto)</td>
									<%
									v3eth1autocost = ospf3eth1obj.containsKey("auto_cost")
											? ospf3eth1obj.getString("auto_cost").equals("on") ? "checked" : ""
											: !ospf3eth1obj.containsKey("cost_value") ? "checked" : "";
									%>
									<td><label class="switch" style="vertical-align: middle"><input
											type="checkbox" name="e1intrfcost_check_v3"
											id="e1intrfcost_check_v3" style="vertical-align: middle"
											<%=v3eth1autocost%>
											onclick="interfacecostV3Config('e1intrfcost_v3')"
											onchange="hideAutoFields('e1_int_cost_v3','e1intrfcost_check_v3')"><span
											class="slider round"></span></label></td>
								</tr>
	
								<tr id="e1_int_cost_v3">
									<td>Interface Cost (1-65535)</td>
									<%
									String v3eth1incost = ospf3eth1obj != null
											? (!ospf3eth1obj.containsKey("cost_value") ? "" : ospf3eth1obj.getString("cost_value"))
											: "";
									%>
									<td><input type="number" name="e1intrfcost_v3"
										id="e1intrfcost_v3" min="1" max="65535"
										value="<%=v3eth1incost%>" class="text"
										onkeypress="return avoidSpace(event)"
										onfocusout="validateRange('e1intrfcost_v3',true,'Interface Cost (1-65535)')"></td>
								<tr>
								<tr>
									<td>Router Priority (0-255)</td>
									<%
									String v3eth1routepr = ospf3eth1obj != null
											? (!ospf3eth1obj.containsKey("priority") ? "1" : ospf3eth1obj.getString("priority"))
											: "";
									%>
									<td><input type="number" name="e1router_priority_v3"
										value="<%=v3eth1routepr%>" id="e1router_priority_v3" min="0"
										max="255" class="text" onkeypress="return avoidSpace(event)"></td>
								</tr>
							</tbody>
						</table>
					</div>
					<input type="hidden" id="e0ospf_a_type_hid_v3" value="" /> <input
						type="hidden" id="e1ospf_a_type_hid_v3" value="" /> <br>
					<div align="center">
						<input type="submit" value="Apply" name="Apply"
							style="display: inline block" class="button">
					</div>
				</div>
				<!-- interface_config_v3 div end -->
	
				<div id="area_config_v3" style="margin: 0px; display: none;"
					align="center">
					<input type="text" id="areav3cnt" name="areav3cnt" value="1"
						hidden="">
					<input type="hidden" style="margin: 0px; padding: 0px"
						id="ospf3_subdivpage" name="ospf3_subdivpage"
						value="area_config_v3">
					<table class="borderlesstab" style="width: 660px;" id="areaconfigv3"
						align="center">
						<tbody>
							<tr>
								<th style="text-align: center;" width="30px" align="center">S.No</th>
								<th style="text-align: center;" width="10px" align="center">Area
									Id</th>
								<th style="text-align: center;" width="10px" align="center">Type</th>
								<th style="text-align: center;" width="100px" align="center">Summarise
									Inter Area</th>
								<th style="text-align: center;" width="90px" align="center">Action</th>
							</tr>
						</tbody>
					</table>
					<%
					if (v3areaarr.size() > 0) {
						for (int i = 0; i < v3areaarr.size(); i++) {
							String areavals = v3areaarr.getString(i);
							String areaidval = "";
							String typevals = "";
							String sumervals = "";
							String areavalsarr[] = areavals.split("\\|");
							areaidval = areavalsarr[0];
					if (areavalsarr[1].equals("@"))
						typevals = "-";
					else if (areavalsarr[1].equals("stub"))
						typevals = "Stub";
					else
						typevals = "Totally Stub";
					if (areavalsarr.length==3)
					{
						if (areavalsarr[2].equals("@"))
							sumervals = "";
						else
							sumervals = areavalsarr[2];
					}
					else
						sumervals = "";
					%>
					<script>		
				 addRow('areaconfigv3');
				 fillOspf3area(<%=(i + 1)%>,'<%=areaidval%>','<%=typevals%>','<%=sumervals%>');
				 </script>
					<%
					}
					}
					%>
					<div align="center">
						<input class="button" type="button" id="add" value="Add"
							style="display: inline block" onclick="addRow('areaconfigv3')">
					</div>
					<br>
					<div align="center">
						<input type="submit" value="Apply" name="Apply"
							style="display: inline block" class="button">
					</div>
				</div>
				<!-- area_config_v3 div end -->
	
			</form>
		</div>
		<!-- OSPFV3 div end -->
		<div id="bgpdiv" style="margin: 0.2px; display: none;" width="660px">
			<form
				action="savedetails.jsp?page=bgp_instance&slnumber=<%=slnumber%>&version=<%=version%>"
				method="post" onsubmit="return validateBgp('curdiv')">
				<input type="text" id="slno" value="<%=slnumber%>" hidden />
				<table class="borderlesstab nobackground"
					style="width: 660px; margin-bottom: 0px;" id="bgpmenu"
					align="center">
					<input type="hidden" style="margin: 0px; padding: 0px"
						id="bgp_instancebgpsubdivpage" name="bgpsubdivpage"
						value="bgp_instance">
					<tbody>
						<tr style="padding: 0px; margin: 0px;">
							<td style="padding: 0px; margin: 0px;">
								<ul id="bgplist">
									<li><a class="casesense bgplist" id="hilightthis"
										style="cursor: pointer"
										onclick="showDivision('bgp_instance','bgplist','<%=slnumber%>','<%=version%>')">Instance</a></li>
									<li><a class="casesense bgplist" style="cursor: pointer"
										onclick="showDivision('bgp_peers','bgplist','<%=slnumber%>','<%=version%>')"
										id="">Peer Records</a></li>
									<li><a class="casesense bgplist" style="cursor: pointer"
										id=""
										onclick="showDivision('bgppeersettingsdiv','bgplist','<%=slnumber%>','<%=version%>')">Peer
											Settings</a></li>
									<li><a class="casesense bgplist" style="cursor: pointer"
										onclick="showDivision('path_filtering','bgplist','<%=slnumber%>','<%=version%>')"
										id="">Path Filtering</a></li>
									<li><a class="casesense bgplist" style="cursor: pointer"
										onclick="showDivision('path_summarization','bgplist','<%=slnumber%>','<%=version%>')"
										id="">Path Summarization</a></li>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
				<div id="bgp_instance" style="margin: 0px;" align="center">
					<input type="hidden" id="bgpinsrcnt" name="bgpinsrcnt" value="0">
					<table class="borderlesstab" id="bgpinsttab" style="width: 660px"
						align="center">
						<tbody>
							<tr>
								<th>Parameters</th>
								<th>Configuration</th>
							</tr>
							<tr>
								<td>Enable</td>
								<%
								if (bgpdefobj.containsKey("BGP"))
									bgpact = bgpdefobj.getString("BGP").equals("enable") ? "checked" : "";
								%>
								<td><label class="switch" style="vertical-align: middle"><input
										type="checkbox" id="ins_enable" name="ins_enable" <%=bgpact%>
										style="vertical-align: middle"><span
										class="slider round"></span></label></td>
							</tr>
							<tr id="bgp_id_auto">
								<td>Router-ID (Auto)</td>
								<%
								bgpautochk = bgpdefobj.containsKey("bgp_autocheck")
										? bgpdefobj.getString("bgp_autocheck").equals("on") ? "checked" : ""
										: !bgpdefobj.containsKey("bgp_routerid") ? "checked" : "";
								%>
								<td><label class="switch" style="vertical-align: middle"><input
										type="checkbox" name="bgp_autocheck" id="bgp_autocheck"
										style="vertical-align: middle" <%=bgpautochk%>
										onclick="bgpRouIdConfig()"
										onchange="hideAutoFields('bgproute_id','bgp_autocheck')"><span
										class="slider round"></span></label></td>
							</tr>
							<tr id="bgproute_id">
								<td>Router-ID</td>
								<%
								String bgprouteval = bgpdefobj != null
										? (!bgpdefobj.containsKey("bgp_routerid") ? "" : bgpdefobj.getString("bgp_routerid"))
										: "";
								%>
								<td><input type="text" name="bgp_routerid" id="bgp_routerid"
									class="text" onkeypress="return avoidSpace(event)"
									value="<%=bgprouteval%>"
									onfocusout="validateIP('bgp_routerid',false,'Router-ID')"
									style="outline: initial;" title="">&nbsp;</td>
							</tr>
							<tr>
								<td>Autonomous System Number</td>
								<%
								String autosysnum = bgpdefobj != null ? (!bgpdefobj.containsKey("sysnum") ? "" : bgpdefobj.getString("sysnum")) : "";
								%>
								<td><input type="number" class="text" id="sysnum"
									name="sysnum" min="1" max="4294967295"
									placeholder="(1-4294967295)" value="<%=autosysnum%>" onkeypress="return avoidSpace(event)"
									onfocusout="validateRange('sysnum',true,'Autonomous System Number ');"></td>
							</tr>
							<tr>
								<td>EBGP Administrative Distance</td>
								<%
								String bgpadmdis = bgpdefobj != null
										? (!bgpdefobj.containsKey("admindis") ? "20" : bgpdefobj.getString("admindis"))
										: "";
								%>
								<td><input type="number" class="text" id="admindis" onkeypress="return avoidSpace(event)"
									name="admindis" value="<%=bgpadmdis%>" min="1" max="255"></td>
							</tr>
							<tr>
								<td>IBGP Administrative Distance</td>
								<%
								String bgpibgpadmdis = bgpdefobj != null
										? (!bgpdefobj.containsKey("ibgp_admindis") ? "200" : bgpdefobj.getString("ibgp_admindis"))
										: "";
								%>
								<td><input type="number" class="text" id="ibgp_admindis" onkeypress="return avoidSpace(event)"
									name="ibgp_admindis" value="<%=bgpibgpadmdis%>" min="1"
									max="255"></td>
							</tr>
						</tbody>
					</table>
					<table class="borderlesstab" id="bgpnetworktab" style="width: 660px"
						align="center">
						<input type="hidden" id="bgpnwcnt" name="bgpnwcnt" value="6">
						<!-- pallavi -->
						<%
						if (bgpnwarr.size() > 0) {
							for (int i = 0; i < bgpnwarr.size(); i++) {
								String bgpnwvals = bgpnwarr.getString(i);
						%>
						<script>		
							 addBgpNetrkRow(bgpnetwork);
							 fillBgpNetrkRow(bgpnetwork,'<%=bgpnwvals%>');
							 </script>
						<%
						}
						} else {
						%>
						<script>	
	               			addBgpNetrkRow(bgpnetwork);
	               	  </script>
						<%
						}
						%>
					</table>
					<table class="borderlesstab" id="bgpinssubtab" style="width: 660px"
						align="center">
						<tbody>
							<tr>
								<td>Redistribution</td>
								<td><select id="proto" name="proto"
									multiple="multiple" style="display: none;">
										<option value="connected"
											<%if (bgpredisarr.contains("connected")) {%> selected <%}%>>Connected</option>
										<option value="ospf" <%if (bgpredisarr.contains("ospf")) {%>
											selected <%}%>>OSPF</option>
										<option value="kernel"
											<%if (bgpredisarr.contains("kernel")) {%> selected <%}%>>STATIC</option>
								</select></td>
							</tr>
						</tbody>
					</table>
					<div align="center">
						<input type="submit" value="Apply" name="Apply"
							style="display: inline block" class="button">
					</div>
				</div>
			</form>
			<form
				action="savedetails.jsp?page=bgp_peers&slnumber=<%=slnumber%>&version=<%=version%>"
				method="post" onsubmit="return validateBgp('curdiv')">
				<input type="hidden" style="margin: 0px; padding: 0px"
					id="bgp_peersbgpsubdivpage" name="bgpsubdivpage" value="">
				<div id="bgp_peers" align="center" style="display: none;">
					<input type="text" id="bgp_peers_rwcnt" name="bgp_peers_rwcnt"
						value="1" hidden="">
					<table class="borderlesstab" id="bgppeersconfig"
						style="width: 660px; margin-bottom: 0px; margin-bottom: 0px;"
						align="center">
						<tbody>
							<tr>
								<th style="text-align: center;" width="30px" align="center">S.No</th>
								<th style="text-align: center;" width="30px" align="center">Name</th>
								<th style="text-align: center;" width="30px" align="center">Status</th>
								<th style="text-align: center;" width="30px" align="center">Action</th>
							</tr>
						</tbody>
					</table>
					<br> <br>
					<table class="borderlesstab" id="bgppeersconfigadd" align="center">
						<tbody>
							<tr align="center">
								<td width="400px">New Instance Name</td>
								<td><input type="text" class="text" id="nwinstname"
									name="nwinstname" maxlength="32"
									onkeypress="return avoidSpace(event) && avoidEnter(event)"
									onfocusout="isEmpty('nwinstname','New Instance Name')"></td>
								<td colspan="2"><input type="button" class="button1"
									id="add" value="Add" onclick="checkAlphaNUmeric('nwinstname');"></td>
							</tr>
							<tr style="background-color: white;">
								<td colspan="3">
									<p
										style="font-size: 11px; font-family: verdana; margin-left: 80px;">
										<span style="color: red; text-align: left; margin-left: 20px;">
											<b>Note:</b>
										</span> Special Characters are not allowed
									</p>
								</td>
							</tr>
						</tbody>
					</table>
					<%
					String peername = "";
					String peeract = "";
					String Asvals = "";
					String peerdata="";
					int i = 0;
					Iterator<String> keys = bgpobj.keys();
					while (keys.hasNext()) {
						String ckey = keys.next();
						if (ckey.contains("Peer_Records:")) {
							Asvals = "";
							JSONObject bgp_obj = bgpobj.getJSONObject(ckey);
							String instname = ckey.replace("Peer_Records:", "");
							JSONArray peerrecords = new JSONArray();
							String old_peerASval = "";
							if (bgp_obj.containsKey("bgp_peer_en")) {
								peeract = bgp_obj.getString("bgp_peer_en");
								if(peeract.equals("on"))
									peeract= "checked";
								else
									peeract = "";
							}
							if (bgp_obj.containsKey("peername")) {
								peername = bgp_obj.getString("peername");
							}
							if (bgp_obj.containsKey("Records")) {
								peerrecords = bgp_obj.getJSONArray("Records");
						if (peerrecords.size() > 0) {
							for (int j = 0; j < peerrecords.size(); j++) {
								String vals = peerrecords.getString(j);
								String valsarr[] = vals.split("-");
								if (valsarr[0].equals(old_peerASval)) {
									Asvals += valsarr[1] + ", ";
								} else
									Asvals += " AS " + valsarr[0] + ", " + valsarr[1] + ", ";
								old_peerASval = valsarr[0];
							}
						}
						
							}
							if(bgppeername.equals(peername))
								peerdata=peeract+", "+peername+", "+Asvals;
					%>
					<script>
				addRow('bgppeersconfig','<%=slnumber%>','<%=version%>');
				fillBgpPeerRow('<%=i + 1%>','<%=peeract%>','<%=peername%>','<%=Asvals%>');
				
				</script>
					<%
					i++;
						}
					}
					%>
					<br> <br>
					<div align="center">
						<input type="submit" value="Apply" name="Apply"
							style="display: inline block" class="button">
					</div>
				</div>
			</form>
	
			<form
				action="savedetails.jsp?page=add_bgppeer&slnumber=<%=slnumber%>&version=<%=version%>"
				method="post" onsubmit="return validateBgp('curdiv')">
				<input type="hidden" style="margin: 0px; padding: 0px"
					id="add_bgppeerbgpsubdivpage" name="bgpsubdivpage" value="">
				<div id="add_bgppeer" style="margin: 0px; display: none;"
					align="center">
					<table class="borderlesstab" id="bgppeertab" style="width: 660px"
						align="center">
						<tbody>
							<tr>
								<th width="250px">Parameters</th>
								<th width="250px">Configuration</th>
							</tr>
							<tr>
								<td>Enabled</td>
								<%-- <%peeract=peeract.equals("on")?"checked":"";%> --%>
								<td><label class="switch" style="vertical-align: middle"><input
										type="checkbox" id="bgp_peer_en" name="bgp_peer_en"
										style="vertical-align: middle" <%=peeract%>><span
										class="slider round"></span></label></td>
							</tr>
							<tr>
								<td>Name</td>
								<td><input type="text" class="text" id="peername"
									name="peername" value="<%=peername%>" readonly=""></td>
							</tr>
						</tbody>
					</table>
					<table class="borderlesstab" id="peerstab" style="width: 660px"
						align="center">
						<input type="hidden" id="bgpremnumcnt" name="bgpremnumcnt"
							value="0">
						<input type="hidden" id="bgpneighnumcnt" name="bgpneighnumcnt"
							value="1">
						<tbody>
						<%-- <%System.out.println(" Asvals "+Asvals); %> --%>
						</tbody>
					</table>
					<div align="center">
						<input type="submit" value="Apply" name="Apply"
							style="display: inline block" class="button">
					</div>
				</div>
			</form>
			<form
				action="savedetails.jsp?page=bgppeersettingsdiv&slnumber=<%=slnumber%>&version=<%=version%>"
				method="post" onsubmit="return validateBgp('curdiv')">
				<input type="hidden" style="margin: 0px; padding: 0px"
					id="bgppeersettingsdivbgpsubdivpage" name="bgpsubdivpage" value="">
				<div id="bgppeersettingsdiv" style="margin: 0px; display: none;"
					align="center">
					<input type="text" id="bgppeergrpcnt" name="bgppeergrpcnt" value="1"
						hidden="">
					<table class="borderlesstab" id="bgppeersettab"
						style="width: 660px;" align="center">
						<tbody>
							<tr>
								<th style="text-align: center;" width="30px" align="center">S.No</th>
								<th style="text-align: center;" width="30px" align="center">Name</th>
								<!-- <th style="text-align:center;" width="30px" align="center">Status</th> -->
								<th style="text-align: center;" width="30px" align="center">Action</th>
							</tr>
						</tbody>
					</table>
					<br> <br>
					<div align="center">
						<input type="submit" value="Apply" name="Apply"
							style="display: inline block" class="button">
					</div>
				</div>
			</form>
			<%
			
			int j = 0;
			Iterator<String> keysset = bgpobj.keys();
			String record = "";
			String des = "";
			String pwd = "";
			String kepalivetme = "";
			String hldtime = "";
			String udurc = "";
			String deforg = "";
			String passive = "";
			String ttlauto = "";
			String ttlval = "";
			String nxthop = "";
			String refclient = "";
			String severclient = "";
			while (keysset.hasNext()) {			
			 record = "";
			 des = "";
			 pwd = "";
			 kepalivetme = "";
			 hldtime = "";
			 udurc = "";
			 deforg = "";
			 passive = "";
			 ttlauto = "";
			 ttlval = "";
			 nxthop = "";
			 refclient = "";
			 severclient = "";
			 
				String ckey = keysset.next();
				if (ckey.contains("Peer_Records:")) {
					JSONObject bgp_obj = bgpobj.getJSONObject(ckey);
					String instname = ckey.replace("Peer_Records:", "");
					if (bgp_obj.containsKey("peername"))
						record = bgp_obj.getString("peername");
					if (bgp_obj.containsKey("description"))
						des = bgp_obj.getString("description");
					if (bgp_obj.containsKey("password"))
						pwd = bgp_obj.getString("password");
					if (bgp_obj.containsKey("keep_timer"))
						kepalivetme = bgp_obj.getString("keep_timer");
					else
						kepalivetme = "60";
					if (bgp_obj.containsKey("hold_timer"))
						hldtime = bgp_obj.getString("hold_timer");
					else
						hldtime = "180";
					if (bgp_obj.containsKey("update_source"))
						udurc = bgp_obj.getString("update_source");
					if (bgp_obj.containsKey("default_org"))
						deforg = bgp_obj.getString("default_org");
					if (bgp_obj.containsKey("passive"))
						passive = bgp_obj.getString("passive");
					if (bgp_obj.containsKey("ttl_check")) {
						ttlauto = bgp_obj.getString("ttl_check");
					if (bgp_obj.containsKey("ttl_hops"))
						ttlval = bgp_obj.getString("ttl_hops");
					}
					if (bgp_obj.containsKey("nexthop_self"))
						nxthop = bgp_obj.getString("nexthop_self");
					if (bgp_obj.containsKey("reflector_client"))
						refclient = bgp_obj.getString("reflector_client");
					if (bgp_obj.containsKey("server_client"))
						severclient = bgp_obj.getString("server_client");
					
					if(record.trim().equals(bgppeername))
						int_bgpset_edit_ind = j+1;
			%>
			<script>
				addRow('bgppeersettab','<%=slnumber%>','<%=version%>');
				fillBgppersetRow('<%=j + 1%>','<%=record%>','<%=des%>','<%=pwd%>','<%=kepalivetme%>','<%=hldtime%>','<%=udurc%>','<%=deforg%>','<%=passive%>','<%=ttlauto%>','<%=ttlval%>','<%=nxthop%>','<%=refclient%>','<%=severclient%>');
				</script>
			<%
			j++;
			}
			}
			%>
			<form
				action="savedetails.jsp?page=add_bgppeersetteings&slnumber=<%=slnumber%>&version=<%=version%>"
				method="post" onsubmit="return validateBgp('curdiv')">
				<input type="hidden" style="margin: 0px; padding: 0px"
					id="add_bgppeersetteingsbgpsubdivpage" name="bgpsubdivpage" value="">
				<div id="add_bgppeersetteings" style="margin: 0px; display: none;"
					align="center">
					<input type="hidden" id="add_bgp_peers_rwcnt"
						name="add_bgp_peers_rwcnt" value="0">
					<table class="borderlesstab" id="add_bgppeersetteingstab"
						style="width: 660px" align="center">
						<tbody>
							<tr>
								<th width="200px">Parameters</th>
								<th width="200px">Configuration</th>
							</tr>
							<!-- <tr>
	                        <td>Enable</td>
	                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="set_enable" name="set_enable" style="vertical-align:middle" checked=""><span class="slider round"></span></label></td>
	                     </tr> -->
							<tr>
								<td>Peer Records</td>
								<td><input type="text" class="text" id="peer_records"
									name="peer_records" value="<%=record%>" readonly></td>
							</tr>
							<tr>
								<td>Description</td>
								<td><input type="text" class="text" id="description"
									name="description" maxlength="80" value="<%=des%>"></td>
							</tr>
							<tr>
								<td>Password</td>
								<td><input id="peer_password" class="text" type="password"
									name="peer_password" value="<%=pwd%>"><span toggle="#password-field"
									class="fa fa-fw fa-eye field_icon toggle-peer_password"></span></td>
							</tr>
							<tr>
								<td>KeepAlive Timer (Seconds)</td>
								<td><input type="number" class="text" id="keep_timer" onkeypress="return avoidSpace(event)"
									name="keep_timer" min="0" max="65535" placeholder="(0-65535)"
									value="<%=kepalivetme%>"></td>
							</tr>
							<tr>
								<td>Hold Timer (Seconds)</td>
								<td><input type="number" class="text" id="hold_timer" onkeypress="return avoidSpace(event)"
									name="hold_timer" min="0" max="65535" value="<%=hldtime%>"
									placeholder="(0-65535)"></td>
							</tr>
							<tr>
								<td>Update Source</td>
								<td><input type="text" name="update_source"
									id="update_source" class="text"
									onkeypress="return avoidSpace(event)"
									placeholder="(192.168.1.10)"
									onfocusout="validateIPOnly('update_source',false,'Update Source')"
									style="outline: initial;" title="" value="<%=udurc%>">&nbsp;</td>
							</tr>
							<tr>
								<td>Default Originate</td>
								<% deforg=deforg.equals("on")?"checked":"";%>
								<td><label class="switch"><input type="checkbox"
										name="default_org" id="defalut_org"
										style="vertical-align: middle" <%=deforg%>><span
										class="slider round"></span></label>
							</tr>
	
							<tr>
								<td>Passive</td>
								<% passive=passive.equals("on")?"checked":"";%>
								<td><label class="switch" style="vertical-align: middle"><input
										type="checkbox" name="passive" id="passive"
										style="vertical-align: middle" <%=passive%>><span
										class="slider round"></span></label></td>
							</tr>
							<tr>
								<td>TTL Generic Security Check</td>
								<% ttlauto=ttlauto.equals("on")?"checked":"";%>
								<td><label class="switch" style="vertical-align: middle"><input
										type="checkbox" name="ttl_check" id="ttl_check"
										style="vertical-align: middle"
										onchange="hideTTLGenCheck('ttl_check','ttl_hops')" <%=ttlauto%>><span
										class="slider round"></span></label>&nbsp; <input type="number"
									name="ttl_hops" id="ttl_hops" min="1" max="255"
									placeholder="Hops(1-255)" onkeypress="return avoidSpace(event)" value="<%=ttlval%>"
									style="width: 100px; min-width: 100px;" class="text"
									onkeypress="return avoidSpace(event)"></td>
							</tr>
							<tr>
								<td>Disable Next Hop Self</td>
								<% nxthop=nxthop.equals("on")?"checked":"";%>
								<td><label class="switch" style="vertical-align: middle"><input
										type="checkbox" name="nexthop_self" id="nexthop_self"
										style="vertical-align: middle"
										onchange="hideTTLGenCheck('nexthop_self','next_hop_self')"
										<%=nxthop%>><span class="slider round"></span></label>&nbsp;
							</tr>
							<tr>
								<td>Route-Reflector-Client</td>
								<% refclient=refclient.equals("on")?"checked":"";%>
								<td><label class="switch"><input type="checkbox"
										name="reflector_client" id="reflector_client"
										style="vertical-align: middle" <%=refclient%>><span
										class="slider round"></span></label>
							</tr>
							<tr>
								<td>Route-server-client</td>
								<% severclient=severclient.equals("on")?"checked":"";%>
								<td><label class="switch"><input type="checkbox"
										name="server_client" id="server_client"
										style="vertical-align: middle" <%=severclient%>><span
										class="slider round"></span></label>
							</tr>
						</tbody>
					</table>
					<div align="center">
						<input type="submit" value="Apply" name="Apply"
							style="display: inline block" class="button">
					</div>
				</div>
			</form>
	
			<form
				action="savedetails.jsp?page=path_filtering&slnumber=<%=slnumber%>&version=<%=version%>"
				method="post" onsubmit="return validateBgp('curdiv')">
				<input type="hidden" style="margin: 0px; padding: 0px"
					id="path_filteringbgpsubdivpage" name="bgpsubdivpage" value="">
				<div id="path_filtering" style="margin: 0px; display: none;"
					align="center">
					<input type="text" id="pathlistcnt" name="pathlistcnt" value="1"
						hidden="">
					<table class="borderlesstab" id="path_listtab" style="width: 660px;"
						align="center">
						<tbody>
							<tr>
								<th style="text-align: center;" width="30px" align="center">S.No</th>
								<th style="text-align: center;" width="30px" align="center">Name</th>
								<!--   <th style="text-align:center;" width="30px" align="center">Status</th> -->
								<th style="text-align: center;" width="30px" align="center">Action</th>
							</tr>
	
						</tbody>
					</table>
					<br> <br>
					<div align="center">
						<input type="submit" name="Apply" value="Apply" class="button">
					</div>
				</div>
			</form>
			<%
			int k = 0;
			Iterator<String> keyspath = bgpobj.keys();
			String recordname = "";
			String direc = "";
			List<String> oldipprefix = new ArrayList<String>();
			while (keyspath.hasNext()) {
				String ckey = keyspath.next();
				if (ckey.contains("Peer_Records:")) {
					Iterator<String> ipkeys = ipprefixobj.keys();
					List<String> ipprefix = new ArrayList<String>();
					while (ipkeys.hasNext()) {
				String ipckey = ipkeys.next();
	
				if (ipckey.contains("List:")) {
					JSONObject prefix_obj = ipprefixobj.getJSONObject(ipckey);
					String prefixname = ipckey.replace("List:", "");
					ipprefix.add(prefixname.trim());
	
				}
					}
					oldipprefix = ipprefix;
					JSONObject bgp_obj = bgpobj.getJSONObject(ckey);
					String instname = ckey.replace("Peer_Records:", "");
					if (bgp_obj.containsKey("peername"))
						recordname = bgp_obj.getString("peername");
					if (bgp_obj.containsKey("prefix_list"))
						selprefixname = bgp_obj.getString("prefix_list");
					else
						selprefixname = "";
					if (oldipprefix.contains(selprefixname))
						oldipprefix.remove(selprefixname);
					if (bgp_obj.containsKey("path_direction")) {
						direc = bgp_obj.getString("path_direction");
					if (direc.equals("in"))
						direc = "Inbound";
					else
						direc = "Outbound";
					} 
					else
						direc = "";
					if(recordname.trim().equals(bgppeername))
						int_bgppathfit_edit_ind = k+1;
			%>
			<script>
				addRow('path_listtab','<%=slnumber%>','<%=version%>');
				fillBgpPathFilteringRow('<%=k + 1%>','<%=recordname%>','<%=selprefixname%>','<%=direc%>');
				</script>
			<%
			k++;
			}
			}
			%>
			<form
				action="savedetails.jsp?page=add_bgppath&slnumber=<%=slnumber%>&version=<%=version%>"
				method="post" onsubmit="return validateBgp('curdiv')">
				<input type="hidden" style="margin: 0px; padding: 0px"
					id="add_bgppathbgpsubdivpage" name="bgpsubdivpage" value="">
				<div id="add_bgppath" style="margin: 0px; display: none;"
					align="center">
					<input type="hidden" id="add_bgp_path_rwcnt"
						name="add_bgp_path_rwcnt" value="0">
					<table class="borderlesstab" id="add_bgppathtab"
						style="width: 660px" align="center">
						<tbody>
							<tr>
								<th width="200px">Parameters</th>
								<th width="200px">Configuration</th>
							</tr>
							<!-- <tr>
	                        <td>Enable</td>
	                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="path_enable" name="path_enable" style="vertical-align:middle" checked=""><span class="slider round"></span></label></td>
	                     </tr> -->
							<tr>
								<td>Peer Records</td>
								<td><input type="text" class="text" id="path_peer_records"
									name="path_peer_records" value="<%=recordname%>" readonly></td>
							</tr>
	
							<tr>
								<td width="200px">IP Prefix List</td>
								<td width="200px"><select id="path_prefix_list"
									name="path_prefix_list" class="text">
										<option value="<%=selprefixname%>"><%=selprefixname%></option>
										<%
										for (String pathname : oldipprefix) {
										%>
										<option value="<%=pathname%>"><%=pathname%></option>
										<%
										}
										%>
								</select></td>
							</tr>
							<tr>
								<td>Direction</td>
								<td><select id="path_direction" name="path_direction" class="text">
									<option value="Inbound" <%if (direc.contains("Inbound")) {%>selected <%}%>>Inbound</option>
									<option value="Outbound" <%if (direc.contains("Outbound")) {%>selected <%}%>>Outbound</option>
								</select></td>
							</tr>
						</tbody>
					</table>
					<div align="center">
						<input type="submit" value="Apply" name="Apply"
							style="display: inline block" class="button">
					</div>
				</div>
			</form>
			<form
				action="savedetails.jsp?page=path_summarization&slnumber=<%=slnumber%>"
				method="post" onsubmit="return validateBgp('curdiv')">
				<input type="hidden" style="margin: 0px; padding: 0px"
					id="path_summarizationbgpsubdivpage" name="bgpsubdivpage" value="">
				<div id="path_summarization" style="display: none;" align="center">
					<input type="text" id="bgp_pathsum_rwcnt" name="bgp_pathsum_rwcnt"
						value="1" hidden="">
					<table class="borderlesstab" id="bgppathsummconfig"
						style="width: 660px; margin-bottom: 0px; margin-bottom: 0px;"
						align="center">
						<tbody>
							<tr>
								<th style="text-align: center;" width="10px" align="center">S.No</th>
								<th style="text-align: center;" width="10px" align="center">Address</th>
								<th style="text-align: center;" width="30px" align="center">Status</th>
								<th style="text-align: center;" width="30px" align="center">Action</th>
							</tr>
						</tbody>
					</table>
					<br> <br>
					<table class="borderlesstab" id="pathsummaddtab" align="center">
						<tbody>
							<tr>
								<td width="400px">New IP Address</td>
								<td><input type="text" class="text" id="nwaddr"
									name="nwaddr" maxlength="32"
									onkeypress="return avoidSpace(event) && avoidEnter(event)"
									onfocusout="isEmpty('nwaddr','New Address')"></td>
								<td colspan="2"><input type="button" class="button1"
									id="add" value="Add" onclick="addNewBgpPathSumm()"></td>
							</tr>
						</tbody>
					</table>
					<br> <br>
					<div align="center">
						<input type="submit" value="Apply" name="Apply"
							style="display: inline block" class="button">
					</div>
				</div>
			</form>
			<%
			String summact = "";
			String ipval = "";
			String sumeronly = "";
			String asset = "";
			if (bgppathsumm.size() > 0) {
				for (int l = 0; l < bgppathsumm.size(); l++) {
					String pathsumm = bgppathsumm.getString(l);
					
					String pathsummarr[] = pathsumm.split("-");
					if (pathsummarr[0].equals("1"))
						summact = "checked";
					else
						summact = "";
					ipval = pathsummarr[1];
					if (pathsummarr[2].equals("1"))
						sumeronly = "checked";
					else
						sumeronly = "";
					if (pathsummarr[3].equals("1"))
						asset = "checked";
					else
						asset = "";
					if(ipval.trim().equals(bgppeername))
						int_bgppathsum_edit_ind = l+1;
			%>
			<script>	
				 addRow('bgppathsummconfig','<%=slnumber%>','<%=version%>');
				 fillBgpPathSummRow(<%=(l + 1)%>,'<%=ipval%>','<%=summact%>','<%=sumeronly%>','<%=asset%>');
				 </script>
			<%
			}
			}
			%>
			<form id="pathsum"
				action="savedetails.jsp?page=add_pathsum&slnumber=<%=slnumber%>"
				method="post" onsubmit="return validateBgp('curdiv')">
				<input type="hidden" style="margin: 0px; padding: 0px"
					id="add_pathsumbgpsubdivpage" name="bgpsubdivpage" value="">
				<div id="add_pathsum" style="margin: 0px; display: none;"
					align="center">
					<table class="borderlesstab" id="addpathsummtab"
						style="width: 660px" align="center">
						<tbody>
							<tr>
								<th width="200px">Parameters</th>
								<th width="200px">Configuration</th>
							</tr>
							<tr>
								<td>Enable</td>
								<td><label class="switch" style="vertical-align: middle"><input
										type="checkbox" id="summ_enable" name="summ_enable"
										style="vertical-align: middle" <%=summact%>><span
										class="slider round"></span></label></td>
							</tr>
							<tr>
								<td>Address</td>
								<td><input type="text" class="text" id="summ_addr"
									name="summ_addr" value="<%=ipval%>" readonly=""> <input
									type="hidden" id="oldsumm_addr" name="oldsumm_addr"></td>
							</tr>
							<tr>
								<td>Summary-only</td>
								<td><label class="switch" style="vertical-align: middle"><input
										type="checkbox" id="summ_flag" name="summ_flag"
										style="vertical-align: middle" <%=sumeronly%>><span
										class="slider round"></span></label></td>
							</tr>
							<tr>
								<td>AS-Set</td>
								<td><label class="switch" style="vertical-align: middle"><input
										type="checkbox" id="summ_as_flag" name="summ_as_flag"
										style="vertical-align: middle" <%=asset%>><span
										class="slider round"></span></label></td>
							</tr>
						</tbody>
					</table>
					<div align="center">
						<input type="submit" value="Apply" name="Apply"
							style="display: inline block" class="button">
					</div>
				</div>
	
			</form>
		</div>
	
		<script>
	         //alert("divname "+divname +" curdiv "+curdiv)
				<%-- showPDivision("ospfdiv",'<%=slnumber%>','<%=version%>'); --%>
				hideDefalutInfoOrg();
				hideAutoFields('route_id','ospf_autocheck');
				hideAutoFields('e0_int_cost','e0intrfcost_check');
	            hideAutoFields('e1_int_cost','e1intrfcost_check');
				showIntfDiv('Eth0');
				ospfRouIdConfig();
				<%-- showDivision('ospf2_instance','ospflist','<%=slnumber%>','<%=version%>'); --%> <!-- modified global_config to ospf2_instance -->
				showPassWord('Eth0');
				showOrHideMd5KeyID('e0authentication','e0keyid','e0pwdinfo');
				showOrHideMd5KeyID('e1authentication','e1keyid','e1pwdinfo');
				// -------------------- OSPFV3 calling functions start -----------------
				hideAutoFields('e0_int_cost_v3','e0intrfcost_check_v3');
	            hideAutoFields('e1_int_cost_v3','e1intrfcost_check_v3');			
				//hideDefalutInfoOrg3();
				//showPassWordV3('Eth0');
				ospfRouIdConfigv3();
				hideAutoFields('route_id_v3','ospf_autocheck_v3');
				showIntfV3Div('Eth0');
				// -------------------- OSPFV3 calling functions stop -----------------
				
				/*BGP starts*/
				hideAutoFields('bgproute_id','bgp_autocheck');
				hideTTLGenCheck('ttl_check','ttl_hops');
				addBgpRemSysRow(remsysnum);
				fillPeerRecordData('<%=peerdata%>');
				bgpRouIdConfig();
			</script>
		<%
		if (errorstr != null && errorstr.trim().length() > 0) {
		%>
		<script>
				 showErrorMsg('<%=errorstr%>');
				 </script>
		<%
		}
		if (showdiv == null) {
		%>
		<script>
						showPDivision("ospfdiv",'<%=slnumber%>','<%=version%>');
					 </script>
		<%
		} else if ((showdiv.equals("ospf2_instance") || showdiv.equals("networks") || showdiv.equals("interface_config")
				|| showdiv.equals("area_config"))) {
			%>
			<script>
			showPDivision("ospfdiv",'<%=slnumber%>','<%=version%>');
			showDivision('<%=showdiv%>','ospflist','<%=slnumber%>','<%=version%>');
		 </script>
	<%
		} else if ((showdiv.equals("ospf3_instance") || showdiv.equals("interface_v3") || showdiv.equals("interface_config_v3")
				|| showdiv.equals("area_config_v3"))) {
			%>
			<script>
			showPDivision("ospfv3div",'<%=slnumber%>','<%=version%>');
			showDivision('<%=showdiv%>','ospf3list','<%=slnumber%>','<%=version%>');
		 </script>
	<%
		} else if ((showdiv.equals("bgp_instance") || showdiv.equals("bgp_peers") ||showdiv.equals("add_bgppeer")|| showdiv.equals("bgppeersettingsdiv") 
				|| showdiv.equals("path_filtering")  || showdiv.equals("path_summarization"))) {
		%>
		<script>
					showPDivision("bgpdiv",'<%=slnumber%>','<%=version%>');
					showDivision('<%=showdiv%>','bgplist','<%=slnumber%>','<%=version%>');
				 </script>
		<%
		}else if(showdiv.equals("add_bgppeersetteings"))
		{
			%>
			<script>
						showPDivision("bgpdiv",'<%=slnumber%>','<%=version%>');
						showDivision('<%=showdiv%>','bgplist','<%=slnumber%>','<%=version%>');
						<%if(int_bgpset_edit_ind != -1){%>
					 	document.getElementById('bgpseteditrw'+<%=int_bgpset_edit_ind%>).click();
					 	<%}%>
					 </script>
			<%
		}else if(showdiv.equals("add_bgppath"))
		{
			%>
			<script>
						showPDivision("bgpdiv",'<%=slnumber%>','<%=version%>');
						showDivision('<%=showdiv%>','bgplist','<%=slnumber%>','<%=version%>');
						<%if(int_bgppathfit_edit_ind != -1){%>
					 	document.getElementById('bgppathfiteditrw'+<%=int_bgppathfit_edit_ind%>).click();
					 	<%}%>
					 </script>
			<%
		}else if(showdiv.equals("add_pathsum"))
		{
			%>
			<script>
						showPDivision("bgpdiv",'<%=slnumber%>','<%=version%>');
						showDivision('<%=showdiv%>','bgplist','<%=slnumber%>','<%=version%>');
						<%if(int_bgppathsum_edit_ind != -1){%>
					 	document.getElementById('bgppathsummeditrw'+<%=int_bgppathsum_edit_ind%>).click();
					 	<%}%>
					 </script>
			<%
		}
		%>
	</body>
	</html>
