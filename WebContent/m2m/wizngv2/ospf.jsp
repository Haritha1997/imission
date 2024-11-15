<html>
   <head>
      <link rel="stylesheet" href="css/fontawesome.css">
      <link rel="stylesheet" href="css/solid.css">
      <link rel="stylesheet" href="css/v4-shims.css">
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <link rel="stylesheet" type="text/css" href="css/multiselect/bootstrap.min.css">
      <link rel="stylesheet" type="text/css" href="css/multiselect/bootstrap-multiselect.css">
	  <meta http-equiv="refresh" content="90">
      <style>
	  .caret 
	  { 
	  position: absolute; 
	  left: 90%; top: 40%;
	  vertical-align: middle;
	  border-top: 6px solid;
	  }
	  #act_icon 
	  { 
	  padding-right:10; 
	  color:#7B68EE;
	  cursor:pointer;
	  }
	  #new_icon 
	  {
	  padding-right:10;
	  color:green; 
	  cursor:pointer;
	  }
	  html 
	  { 
	  overflow-y: scroll;
	  }
	  .multiselect-container
	  {
	  width: 100% !important; 
	  }
	  button.multiselect
	  {
	  height: 25px; 
	  margin: 0; padding: 0;
	  } 
	  .multiselect-container>.active>a,.multiselect-container>.active>a:hover,.multiselect-container>.active>a:focus { background-color: grey; width: 100%; }.multiselect-container>li.active>a>label,.multiselect-container>li.active>a:hover>label,.multiselect-container>li.active>a:focus>label {color: #ffffff; width: 100%; white-space: normal; }.multiselect-container>li>a>label {font-size: 12.5px; text-align: left; font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;padding-left: 25px; white-space: normal; } 
#configtypediv li a
{
font-size:14px;
} 
a,
a:hover { color: black; text-decoration: none; }
.borderlesstab th:nth-child(even),.borderlesstab td:nth-child(even)
{
width: 400px;
}
#redistribute th
{
	min-width:130 px;
	width:130px;
}

#bgplist li a
{
font-size:11px;
} 
#bgppeersconfig  th
{
width: 300px;
}
#bgppeersettab th
{
width: 300px;
}

#path_listtab th
{
width: 300px;
}
#bgppathsummconfig th
{
width: 300px;
}
  </style>
      <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
      <script type="text/javascript" src="js/common.js"></script>
      <script type="text/javascript" src="js/dynamic_routing.js"></script>
      <script type="text/javascript" src="js/multiselect/jquery1.12.4.min.js"></script>
      <script type="text/javascript" src="js/multiselect/bootstrap3.3.6.min.js"></script>
      <script type="text/javascript" src="js/multiselect/bootstrap-multiselect.js"></script>
      
      <script type="text/javascript">var bgp_ins_det_empty = false;
var bgpnetwork = 6;
var iprows = 1;
var curdiv = "";
//var shutdown=1;
var remsysnum=1;
var neighnum = 1;
var nei_ip_obj_arr = [];
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
//$(document).ready(function () {
//alert("calling function");
//addPeerRecOptions('bgp_peers_rwcnt','bgpPerrow_val','peer_records');
//});
$(document).on('click', '.e1toggle-password', function () {
   $(this).toggleClass("fa-eye fa-eye-slash");
   var input = $("#e1pwd");
   input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
});
$(document).on('click', '.looptoggle-password', function () {
   $(this).toggleClass("fa-eye fa-eye-slash");
   var input = $("#looppwd");
   input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
});
// ospfv2 modified start
/*$(document).ready(function () {

   //hide by default
   $('#def_org').hide();

   $('#dfo').click(function (e) {
      if ($('#dfo').prop('checked')) {
         $('#def_org').show();
      } else {
         $('#def_org').hide();
      }
   });
});

$(document).ready(function () {

   //hide by default
   $('#met_type').hide();
   $('#met').hide();

   $('#conn').click(function (e) {
      if ($('#conn').prop('checked')) {
         $('#met_type').show();
         $('#met').show();
      } else {
         $('#met_type').hide();
         $('#met').hide();
      }
   });
});
$(document).ready(function () {

   //hide by default
   $('#stat_met_type').hide();
   $('#stat_met').hide();

   $('#stat').click(function (e) {
      if ($('#stat').prop('checked')) {
         $('#stat_met_type').show();
         $('#stat_met').show();
      } else {
         $('#stat_met_type').hide();
         $('#stat_met').hide();
      }
   });
});
$(document).ready(function () {

   //hide by default
   $('#rip_met_type').hide();
   $('#rip_met').hide();

   $('#rip').click(function (e) {
      if ($('#rip').prop('checked')) {
         $('#rip_met_type').show();
         $('#rip_met').show();
      } else {
         $('#rip_met_type').hide();
         $('#rip_met').hide();
      }
   });
});
$(document).ready(function () {

   //hide by default
   $('#bgp_met_type').hide();
   $('#bgp_met').hide();

   $('#redis_bgp_check').click(function (e) {
      if ($('#redis_bgp_check').prop('checked')) {
         $('#bgp_met_type').show();
         $('#bgp_met').show();
      } else {
         $('#bgp_met_type').hide();
         $('#bgp_met').hide();
      }
   });
});
*/
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
function bgpttlConfig() {
   var ttlhopobj = document.getElementById("ttl_hops");
   var ttlobj = document.getElementById("ttl_check");
   if (ttlobj.checked == false) {
      ttlhopobj.disabled = false;
      ttlhopobj.value = "";
   } 
   else
      ttlhopobj.disabled = false;
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
   if (divname == "global_config") {
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
      if ((e0dead_inter.value)<1*(e0helo_inter.value)||(e0dead_inter.value)==(e0helo_inter.value))
         altmsg += "Dead interval of Eth0 must be  greater than the hello interval\n";
      var e1helo_inter = document.getElementById("e1heloIntrvl");
      var e1dead_inter = document.getElementById("e1deadIntrvl");
      if ((e1dead_inter.value)<1*(e1helo_inter.value) ||(e1dead_inter.value)==(e1helo_inter.value))
         altmsg += "Dead interval of Eth1 must be greater than the hello interval\n";
      /*var loophelo_inter = document.getElementById("loopheloIntrvl");
      var loopdead_inter = document.getElementById("loopdeadIntrvl");
      if (loopdead_inter.value < 3 * (loophelo_inter.value))
         altmsg += "Dead interval of Loopback must be 3 times greater than the hello interval\n";*/
	  //var valid = false;
	  //var prefix_arr=["e0","e1","loop"];
	  var prefix_arr=["e0","e1"];
	  //var intf_arr=["Eth0","Eth1","Loopback"];
	  var intf_arr=["Eth0","Eth1"];
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
	  if(isIntfPwdEmpty(curintfdiv))
		altmsg +="Password shoud not be empty\n";
	  
      /*var area_pre_arr = ["e0","e1","loop"];
	  var area_suf = "ospf_area";
	  var area_intf_arr = ["Eth0","Eth1","Loopback"];
	  for(var i=0;i<area_pre_arr.length;i++)
	  {
			var value = document.getElementById(prefix_arr[i]+area_suf).value;
			var cintf = checkIsDuplicateArea(area_pre_arr[i],area_suf);
			if( cintf != "")
			{
				if(!altmsg.includes("OSPF Area value "+value +" should not be same for the Interfaces "+area_intf_arr[i]+" and "+cintf) 
				&& !altmsg.includes("OSPF Area value "+value +" should not be same for the Interfaces "+cintf+" and "+area_intf_arr[i]))
					altmsg += "OSPF Area value "+value +" should not be same for the Interfaces "+area_intf_arr[i]+" and "+cintf+"\n";
			}
				
	  }*/
   } //modified upto here........
   else if(divname="area_config")
   {
    var arearow = document.getElementById("areacnt").value;
	  var arow = 0;
      for (var i = 1; i <arearow; i++) {
         var area_obj = document.getElementById('area_id' + i);
		 //var valid= validateRange('area_id' + i,true,'Area Id');

         if (area_obj != null) {
			arow++;
			if (area_obj.value.trim() == "")//new lines
					altmsg += "Area id in the row "+arow+" should not be empty\n";
		    var typeobj = document.getElementById("area_type"+i);
			var summobj= document.getElementById("sum_int"+i);
			if(area_obj.value == '0' && typeobj.value != "")
			{
				typeobj.title = "Type should be empty as Area Id is 0 in the row "+arow+"\n";
				typeobj.style.outline = "thin solid red";
				altmsg += typeobj.title;
			}
			else
			{
				typeobj.title = "";
				typeobj.style.outline = "initial";
			}
            valid = validateCIDRNotation('sum_int' + i, false, 'Summarise Inter Area');
            if (!valid) {
				if(summobj.value.trim() == "")
					altmsg += "Summarise Inter Area in row "+i+" should not be empty\n";
				else
					altmsg += "Summarise Inter Area in row " +i+ " is not valid\n";
			}
         }
      }
	   //var index = document.getElementById("areacnt").value;
for (var i = 1; i <arearow; i++) 
{
	var areaobj = document.getElementById("area_id"+i); 
	if (areaobj == null)
            continue;
    var invalid = false;
	if (invalid)
            continue;
	var i_area = areaobj.value;
	for (var j = 1; j < arearow; j++) 
	{
		var jareaobj = document.getElementById("area_id" + j);
		if (jareaobj != null) 
		{
				j_area = jareaobj.value;
			if ((i_area == j_area) && (i != j) &&(areaobj.value.trim="")&&(jareaobj.value.trim()=="")) 
				{
				if (!altmsg.includes(i_area + 
				" entry already exists"))
					altmsg +="Area id " + i_area + " entry already exists \n";
				areaobj.style.outline = "thin solid red";
				break;
				}
		}
	}
	if (j == arearow) 
		{
            areaobj.style.outline = "initial";
            areaobj.title = "";
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
				altmsg += "Network " +nwrow +" should not be empty\n";
			else
				altmsg += "Network "+ nwrow+ " is not valid\n";
			nwrow++;
			continue;			
			}
			
			var i_nw = nw_obj.value;
            for (var j = 1; j <=netrow; j++) {
			
               var jnwobj = document.getElementById("bgp_netk" + j);
			   var error = false;
               if (jnwobj != null) {
                  j_nw = jnwobj.value;
                  if (i_nw == j_nw && i != j) {
                     if (!altmsg.includes(i_nw + " address is already exists"))
                        altmsg += i_nw + " address is already exists\n";
                     nw_obj.style.outline = "thin solid red";
					 error = true;
                     break;
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
	nei_ip_obj_arr = [];
	for (var i = 2;i<=index; i++) 
	{
		var remoteobj = document.getElementById("bgp_remsys" + i);
		if(remoteobj==null)
			continue;
		valid=validateRange("bgp_remsys"+i,true,"Remote Autonomus System Number(1-4294967295)");
		if(!valid)
		{
		if(remoteobj.value.trim()=="")
			altmsg+="Remote Autonomus System Number(1-4294967295) " + (i-1) + " should not be empty\n";
		else
			altmsg+="Remote Autonomus System Number(1-4294967295) " +(i-1)+ " is not valid\n";
		}
	//var remoteobj = document.getElementById("bgp_remsys" + i);
	//if (remoteobj == null)
	// continue;
	var i_remote = remoteobj.value;
	for (var j =1; j<=index; j++)
	{
	var jremoteobj = document.getElementById("bgp_remsys" + j);
	var error = false;
	if (jremoteobj != null &&jremoteobj.value.trim()!="")
	{
	j_remote = jremoteobj.value;
	if ((i_remote == j_remote) && (i != j))
	{
	if (!altmsg.includes("Duplicate Remote Autonomus System Number  "+i_remote))
		altmsg += "Duplicate Remote Autonomus System Number "+i_remote+"\n";
	remoteobj.style.outline ="thin solid red";
	jremoteobj.style.outline ="thin solid red";
	error = true;
	break;
	}		
	}
	if(!error)
	{
	remoteobj.style.outline = "initial";
	remoteobj.title = "";
	}
	}	
	  var neidiv = document.getElementById("peer"+i+"neighboursdiv");
       if(neidiv == null)	 
		continue;
	  var childdivs=neidiv.children;
	  for(var k=1;k<childdivs.length;k++)
	  {
		var childs = childdivs[k].children;
		nei_ip_obj_arr.push(childs[0]);
	  }
	}
	//alert(nei_ip_obj_arr.length);
	for(var i=0;i<nei_ip_obj_arr.length;i++)
	{

		//if(nei_ip_obj_arr[i].value.trim()=="")
			//continue;			
		if(validateIPOnly(nei_ip_obj_arr[i].id,true,"Neighbour Address") == false)
		{
		if(nei_ip_obj_arr[i].value.trim()==0)
			altmsg += "Neighbour Address should not be empty\n";
		else
			altmsg += "Invalid Neighbour Address "+nei_ip_obj_arr[i].value+"\n";
		continue;
		}
		var error = false;	
		for(var j=0;j<i;j++)
		{					
			if(nei_ip_obj_arr[j].value == nei_ip_obj_arr[i].value)
			{
				
				if(!altmsg.includes("Duplicate Neighbour Address "+nei_ip_obj_arr[i].value))
					altmsg+="Duplicate Neighbour Address "+nei_ip_obj_arr[i].value+"\n";
				nei_ip_obj_arr[j].style.outline = "thin solid red";
				nei_ip_obj_arr[j].title = "Duplicate Neighbour Address";
				nei_ip_obj_arr[i].style.outline = "thin solid red";
				nei_ip_obj_arr[i].title = "Duplicate Neighbour Address";
				error = true;
				break;
			}
		}
		if(!error)
		{
			nei_ip_obj_arr[i].title = "";
			nei_ip_obj_arr[i].style.outline = "initial";
		}
	}
		
	
	
}//end else if
   ///////////// add bgp peer group validations
   else if (divname == "add_bgppeersettings") 
   {
		/*var peerrecdobj = document.getElementById("peer_records");	
            if (peerrecdobj.value.trim() == "") 
					altmsg += "Peer Records should not be empty\n";
					
		 else if(duplicateAddressExists("peer_records","bgppeersettab",false))
		{
		
		    if(peerrecdobj.value.trim() != document.getElementById("oldpeer_recd").value.trim())
				altmsg +=peerrecdobj.value.trim()+" is already Exists";
			else
			peerrecdobj.style.outline = "initial";
		}*/
 /*var neighobj=document.getElementById("neigh_ip");
		valid = validateIPOnly('neigh_ip', false, 'Neighbour IP');
         if (!valid) {
            if (neighobj.value.trim() == "") 
				altmsg += "Neighbour IP should not be empty\n";
            else 
				altmsg += "Neighbour IP is not valid\n";
         }*/
	  var keeptimerobj = document.getElementById("keep_timer");
      var holdtimerobj = document.getElementById("hold_timer");
	  var keeptimval = keeptimerobj.value.trim();
	  var holdtimeval = holdtimerobj.value.trim();
	  if (keeptimval == "" && parseInt(holdtimeval)<180) 
	  {
		altmsg += "Hold Timer must be  greater than 3 times the KeepAlive Timer default value 60\n";
		holdtimerobj.style.outline = "thin solid red";
	  }
	  else if (holdtimeval == "" && parseInt(keeptimval)>60)
	  {	  
	  altmsg += "Hold Timer must be  greater than 3 times the KeepAlive Timer \n";
	  keeptimerobj.style.outline = "thin solid red";
	  }
	  else if(keeptimval!=""&&holdtimeval!=""&&parseInt(holdtimeval)<3*parseInt(keeptimval))
	  {
			altmsg += "Hold Timer  must be  3 times greater than the KeepAlive Timer\n";
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
		/* else if(duplicateAddressExists("summ_addr","bgppathsummconfig",false))
		{
		
		    if(addressobj.value.trim() != document.getElementById("oldsumm_addr").value.trim())
				altmsg +=addressobj.value.trim()+" is already Exists";
			else
			addressobj.style.outline = "initial";
		}*/
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
   if (cbobj.value == "Disabled") {
      pwdrow.style.display = 'none';
   } else {
      pwdrow.style.display = '';
	  if(cbobj.value=="Plain Text")
			pwdobj.maxLength=8;
	  else
			pwdobj.maxLength=16;			
   }
}
<!-- Modification ends  -->
</script>
   </head>
   <body>
      <p class="style5" id="title" align="center">Dynamic Routing</p>
      <br>
      <div align="center">
         <table class="borderlesstab nobackground" style="width:660px;margin-bottom:0px;margin-bottom:0px;">
            <tbody>
               <tr style="padding:0px;margin:0px;">
                  <td style="padding:0px;margin:0px;">
                     <ul id="droutediv">
                        <li><a class="casesense droutelist" style="cursor:pointer" id="hilightthis" onclick="showPDivision('ospfdiv')">OSPFV2</a></li>
                        <li><a class="casesense droutelist" style="cursor:pointer" onclick="showPDivision('bgpdiv')" id="">BGP4</a></li>
					
                     </ul>
                  </td>
               </tr>
            </tbody>
         </table>
      </div>
      <div id="ospfdiv" style="">
         <form action="Nomus.cgi?cgi=OspfConfigProcess.cgi" method="post" onsubmit="return validateOSPF2('curdiv')">
            <table class="borderlesstab nobackground" style="width:660px;margin-bottom:0px;" id="simtype" align="center">
               <input type="hidden" style="margin:0px;padding:0px" id="subdivpage" name="subdivpage" value="global_config">
               <tbody>
                  <tr style="padding:0px;margin:0px;">
                     <td style="padding:0px;margin:0px;">
                        <ul id="configtypediv">
                           <li><a class="casesense ospflist" id="hilightthis" style="cursor:pointer" onclick="showDivision('global_config','ospflist')">Global Config</a></li>
                           <li><a class="casesense ospflist" style="cursor:pointer" onclick="showDivision('networks','ospflist')" id="">Networks</a></li>
                           <li><a class="casesense ospflist" style="cursor:pointer" id="" onclick="showDivision('interface_config','ospflist')">Interface Config</a></li>
                           <li><a class="casesense ospflist" style="cursor:pointer" onclick="showDivision('area_config','ospflist')" id="">Area</a></li>
						   <li><a class="casesense ospflist" style="cursor:pointer" onclick="showDivision('neighbour','ospflist')" id="">Neighbours</a></li>
                        </ul>
                     </td>
                  </tr>
               </tbody>
            </table>
            <div id="global_config" style="margin: 0px;" align="center">
               <table id="globalconfig" class="borderlesstab" style="width:660px;" align="center">
                  <tbody>
                     <tr>
                        <th width="300px">Parameters</th>
                        <th width="300px">Configuration</th>
                     </tr>
                     <tr>
                        <td>OSPFV2</td>
                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="intf_ospfv2" id="intf_ospfv2" style="vertical-align:middle" checked=""><span class="slider round"></span></label></td>
                     </tr>
                      <tr id="route_id_auto">
                        <td>Router-ID (Auto)</td>
						<td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="ospf_autocheck" id="ospf_autocheck" style="vertical-align:middle" checked="" onclick="ospfRouIdConfig()" onchange="hideAutoFields('route_id','ospf_autocheck')"><span class="slider round"></span></label></td>
                     </tr>
					 <tr id="route_id">
					 <td>Router-ID</td>
					<td><input type="text" name="ospf_routerid" id="ospf_routerid"  class="text"  onkeypress="return avoidSpace(event)" onfocusout="validateIP('ospf_routerid',false,'Router-ID');" style="outline: initial;" title="">&nbsp;</td>
                     </tr>
					  <tr>
                        <td>Administrative Distance (1-255)</td>
                        <td><input type="number" name="adm_dis" id="adm_dis" min="1" max="255" value="110" class="text" onkeypress="return avoidSpace(event)"></td>
                     </tr>
                        <td>Default Metric (1-16777214)</td>
                        <td><input type="number" name="deflt_metric" id="deflt_metric" min="1" max="16777214" class="text" onkeypress="return avoidSpace(event)"></td>
                     </tr>
                     <!--<tr>
                        <td>ABR Type</td>
                        <td><input type="text" class="text" id="abr_type" name="abr_type" value="Standard" readonly="" >
                        </td>
                     </tr>-->
                     <tr>
                        <td>Auto-Cost Referernce BW (1-4294967 Mbits)</td>
                        <td><input type="number" name="ref_bw" id="ref_bw" min="1" max="4294967" value="100" class="text" onkeypress="return avoidSpace(event)"></td>
                     </tr>
                     <tr>
					 <td>Default Information Originate</td>
                        <td><label class="switch"><input type="checkbox" name="dfo" id="dfo" style="vertical-align:middle"  onchange="hideDefalutInfoOrg()"><span class="slider round"></span></label>
						<span id="span_dfo_alw" style="vertical-align:top;padding-left:5px;"><input type="checkbox" id="dfo_alw" style="vertical-align:middle;"></input><label style="vertical-align:bottom;padding-left:5px;">Always</label></span></td>
					  </tr>
					 </tbody>
					 </table>
				<table class="borderlesstab" style="width:660px;" id="redistribute" align="center"><input type="text" id="redistributecnt" name="redistributecnt" value="1" hidden="">
                  <tbody>
                     <tr>
						<p class="style5" id="title" align="center"> Redistribute</p>
						<th style="text-align:center;" width="30px" align="center">SlNo</th>
                        <th style="text-align:center;" width="30px" align="center">Links</th>
                        <th style="text-align:center;" width="10px" align="center">Metric Type</th>
						<th style="text-align:center;" width="10px" align="center">Metric</th>
						<th style="text-align:center;" width="10px" align="center">Action</th>
                     </tr>
                  </tbody>
               </table>
               <div align="center"><input class="button" type="button" id="add" value="Add" style="display:inline block" onclick="addRow('redistribute')"></div>
               <br>
                     <!--<tr id="def_org">  <!-- Modified this line  
                        <td>Type</td>
                        <td>
                           <select class="text" id="def_info_org_type" name="def_info_org_type">
                              <option value="0">None</option>
                              <option value="1">Always</option>
                           </select>
                        </td>
                     </tr>
                     <tr>
                        <td><input type="checkbox" id="conn" name="conn" onclick="showGlobIntfhiderows()">&nbsp;<label>Redistribute Connected Routes</label></td>
                        <td></td>
                     </tr>
                     <tr id="met_type">   <!-- Modified this line  
                        <td>Metric Type</td>
                        <td>
                           <select class="text" id="redis_conn_type" name="redis_conn_type">
                              <option value="None">None</option>
                              <option value="External Type 1">External Type 1</option>
                              <option value="External Type 2">External Type 2</option>
                           </select>
                        </td>
                     </tr>
                     <tr id="met">  <!-- Modified this line 
                        <td>Metric (1-16777214)</td>
                        <td><input type="number" name="redis_conn_metric" id="redis_conn_metric" min="1" max="16777214" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('redis_conn_metric',false,'Metric (1-16777214)')"></td>
                     </tr>
                     <tr>
                        <td><input type="checkbox" id="stat" name="stat" onclick="showGlobIntfhiderows()">&nbsp;<label>Redistribute Static Routes</label></td>
                        <td></td>
                     </tr>
                     <tr id="stat_met_type">   <!-- Modified this line  
                        <td>Metric Type</td>
                        <td>
                           <select class="text" id="redis_stat_type" name="redis_stat_type">
                              <option value="None">None</option>
                              <option value="External Type 1">External Type 1</option>
                              <option value="External Type 2">External Type 2</option>
                           </select>
                        </td>
                     </tr> 
                     <tr id="stat_met">   <!-- Modified this line 
                        <td>Metric (1-16777214)</td>
                        <td><input type="number" name="redis_stat_metric" id="redis_stat_metric" min="1" max="16777214" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('redis_stat_metric',false,'Metric (1-16777214)')"></td>
                     </tr>
                     <tr>
                        <td><input type="checkbox" id="rip" name="rip" onclick="showGlobIntfhiderows()">&nbsp;<label>Redistribute RIP Routes</label></td>
                        <td></td>
                     </tr>
                     <tr id="rip_met_type">   <!-- Modified this line  
                        <td>Metric Type</td>
                        <td>
                           <select class="text" id="redis_rip_type" name="redis_rip_type">
                              <option value="None">None</option>
                              <option value="External Type 1">External Type 1</option>
                              <option value="External Type 2">External Type 2</option>
                           </select>
                        </td>
                     </tr>
                     <tr id="rip_met">   <!-- Modified this line  
                        <td>Metric (1-16777214)</td>
                        <td><input type="number" name="redis_rip_metric" id="redis_rip_metric" min="1" max="16777214" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('redis_rip_metric',false,'Metric (1-16777214)')"></td>
                     </tr>
                     <tr>
                        <td><input type="checkbox" id="bgp" name="bgp" onclick="showGlobIntfhiderows()">&nbsp;<label>Redistribute BGP Routes</label></td>
                        <td></td>
                     </tr>
                     <tr id="bgp_met_type">   <!-- Modified this line  
                        <td>Metric Type</td>
                        <td>
                           <select class="text" id="redis_bgp_type" name="redis_bgp_type">
                              <option value="None">None</option>
                              <option value="External Type 1">External Type 1</option>
                              <option value="External Type 2">External Type 2</option>
                           </select>
                        </td>
                     </tr>
                     <tr id="bgp_met">   <!-- Modified this line  
                        <td>Metric (1-16777214)</td>
                        <td><input type="number" name="redis_bgp_metric" id="redis_bgp_metric" min="1" max="16777214" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('redis_bgp_metric',false,'Metric (1-16777214)')"></td>
                     </tr>
                  </tbody>
               </table>-->
               <br>
               <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"><input type="submit" value="Save &amp; Apply " name="Save" style="display:inline block" class="button"></div>
            </div>
            <div id="networks" style="margin:0px; display: none;" align="center">
               <input type="text" id="netwrkrwcnt" name="netwrkrwcnt" value="1" hidden="">
               <table class="borderlesstab" style="width:660px;" id="networkconfig" align="center">
                  <tbody>
                     <tr>
                        <th style="text-align:center;" width="30px" align="center">S.No</th>
                        <th style="text-align:center;" width="10px" align="center">Network</th>
                        <th style="text-align:center;" width="10px" align="center">Subnet</th>
                        <th style="text-align:center;" width="30px" align="center">Area</th>
                        <th style="text-align:center;" width="90px" align="center">Action</th>
                     </tr>
                  </tbody>
               </table>
               <div align="center"><input class="button" type="button" id="add" value="Add" style="display:inline block" onclick="addRow('networkconfig')"></div>
               <br>
               <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"><input type="submit" value="Save &amp; Apply " name="Save" style="display:inline block" class="button"></div>
            </div>
            <div id="interface_config" style="margin:0px; display:none;" align="center">
               <div id="eth0div" style="margin: 0px; display: inline;">
                  <table class="borderlesstab" style="width:660px;" id="interfaceconfig" align="center">
                     <tbody>
                        <tr>
                           <th>Parameters</th>
                           <th>Configuration</th>
                        </tr>
                        <tr>
                           <td>Interface</td>
                           <td>
                              <select class="text" id="e0interfacecnfg" name="e0interfacecnfg" onchange="showSelIntf('e0interfacecnfg')">
                                 <option value="Eth0">Eth0</option>
                                 <option value="Eth1">Eth1</option>
                                <!-- <option value="Loopback">Loopback</option>-->
                              </select>
                           </td>
                        </tr>
						<!--<tr>
						<td>Advertise</td>
                        <td><label class="switch"><input type="checkbox" name="e0adver" id="e0adver" style="vertical-align:middle"  onchange="hideInterConfig('e0adver','e0inter_config')"><span class="slider round"></span></label></td>
						</tr>-->
						</tbody>
						</table>
						
						<table class="borderlesstab" style="width:660px;" id="e0inter_config" align="center">
						<tbody>
						<tr>
						<td>Passive</td>
						<td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="e0passive_int" id="e0passive_int" style="vertical-align:middle" ><span class="slider round"></span></label></td>
						</tr>
						<!--<tr>
						<td>TTL Generic Security Check</td>
						<td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="e0ttl_check" id="e0ttl_check" style="vertical-align:middle" onchange="hideTTLGenCheck('e0ttl_check','e0ttl_genericcheck')"><span class="slider round"></span></label>&nbsp;
						<input type="number" name="e0ttl_genericcheck" id="e0ttl_genericcheck" min="1" max="254" placeholder="Hops(1-254)" style="width:100px;min-width:100px;" class="text" onkeypress="return avoidSpace(event)"></td>
						</tr>-->
                        <tr>
                           <td>Hello Interval (1-65535)</td>
                           <td><input type="number" name="e0heloIntrvl" id="e0heloIntrvl" value="10" min="1" max="65535" class="text" onkeypress="return avoidSpace(event)"></td>
                        </tr>
                        <tr>
                           <td>Dead Interval (1-65535)</td>
                           <td><input type="number" name="e0deadIntrvl" value="40" id="e0deadIntrvl" min="1" max="65535" class="text" onkeypress="return avoidSpace(event)" ></td>
                        </tr>
                        <tr>
                           <td>Authentication</td>
                           <td>
                              <select class="text" id="e0authentication" name="e0authentication" onchange="showpassword('e0');">
                                 <option value="Disabled">Disabled</option>
                                 <option value="Plain Text">Plain Text</option>
                                 <option value="MD5">MD5</option>
                              </select>
                           </td>
                        </tr>
                        <tr id="e0Password" style="display: none;">
                           <td>Password</td>
                           <td><input id="e0pwd" class="text" type="password" name="pwd" value=""><span toggle="#password-field" class="fa fa-fw fa-eye field_icon toggle-password"></span></td>
                        </tr>
                        <tr>
                           <td>Network Type</td>
                           <td>
                              <select class="text" id="e0ospf_network_type" name="e0ospf_network_type">
                                 <option value="broadcast" selected="">Broadcast</option>
                                 <option value="non-broadcast">Non-Broadcast</option>
                                 <option value="point-to-multipoint">Point-MultiPoint</option>
                                 <option value="point-to-point">Point-Point</option>
                              </select>
                           </td>
                        </tr>
                        <!--<tr>
                           <td>OSPF Area(0-4294967295)</td>
                           <td><input type="number" name="e0ospf_area" id="e0ospf_area" min="0" max="4294967295" class="text" onkeypress="return avoidSpace(event)" onfocusout="setOSPFAreaType('e0','e0ospf_area');checkIsDuplicateArea('e0','ospf_area')"></td>
                        </tr>
                        <tr>
                           <td>OSPF Area Type</td>
                           <td>
                              <select class="text" id="e0ospf_area_type" name="e0ospf_area_type" onclick="setOSPFAreaType('e0','e0ospf_area_type')">
                                 <option value="normal">NONE</option>
                                 <option value="stub">Stub</option>
                                 <option value="stub no-summary">Totally Stub</option>
                                 <option value="nssa">NSSA</option>
                              </select>
                           </td>
                        </tr>-->
                        <tr>
                           <td>Interface Cost (Auto)</td>
						   <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="e0intrfcost_check" id="e0intrfcost_check" style="vertical-align:middle"  checked="" onclick="interfacecostConfig('e0intrfcost')" onchange="hideAutoFields('e0_int_cost','e0intrfcost_check')"><span class="slider round"></span></label></td>
                        </tr>
						<tr id="e0_int_cost">
						<td>Interface Cost (1-65535)</td>
						<td><input type="number" name="e0intrfcost" id="e0intrfcost" min="1" max="65535" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('e0intrfcost',true,'Interface Cost (1-65535)')"> </td>
						</tr>
                        <tr>
                           <td>Router Priority (0-255)</td>
                           <td><input type="number" name="e0router_priority" value="1" id="e0router_priority" min="0" max="255" class="text" onkeypress="return avoidSpace(event)"></td>
                        </tr>
                     </tbody>
                  </table>
               </div>
               <div id="eth1div" style="margin: 0px; display: none;">
                  <table class="borderlesstab" style="width:660px;" id="interfaceconfig" align="center">
                     <tbody>
                        <tr>
                           <th>Parameters</th>
                           <th>Configuration</th>
                        </tr>
                        <tr>
                           <td>Interface</td>
                           <td>
                              <select class="text" id="e1interfacecnfg" name="e1interfacecnfg" onchange="showSelIntf('e1interfacecnfg')">
                                 <option value="Eth0">Eth0</option>
                                 <option value="Eth1" selected="">Eth1</option>
                                <!-- <option value="Loopback">Loopback</option>-->
                              </select>
                           </td>
                        </tr>
						<!--<tr>
						<td>Advertise</td>
                        <td><label class="switch"><input type="checkbox" name="e1adver" id="e1adver" style="vertical-align:middle"  onchange="hideInterConfig('e1adver','e1inter_config')"><span class="slider round"></span></label></td>
						</tr>-->
						
						</tbody>
						</table>
						<table class="borderlesstab" style="width:660px;" id="e1inter_config" align="center">
						<tbody>
						<tr>
						<td>Passive</td>
						<td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="e1passive_int" id="e1passive_int" style="vertical-align:middle" ><span class="slider round"></span></label></td>
						</tr>
						<!--<tr>
						<td>TTL Generic Security Check</td>
						<td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="e1ttl_check" id="e1ttl_check" style="vertical-align:middle"  onchange="hideTTLGenCheck('e1ttl_check','e1ttl_genericcheck')"><span class="slider round"></span></label>&nbsp;
						<input type="number" name="e1ttl_genericcheck" id="e1ttl_genericcheck" min="1" max="254" placeholder="Hops(1-254)" style="width:100px;min-width:100px;" class="text" onkeypress="return avoidSpace(event)"></td>
						</tr>-->
                        <tr>
                           <td>Hello Interval (1-65535)</td>
                           <td><input type="number" name="e1heloIntrvl" id="e1heloIntrvl" value="10" min="1" max="65535" class="text" onkeypress="return avoidSpace(event)"></td>
                        </tr>
                        <tr>
                           <td>Dead Interval (1-65535)</td>
                           <td><input type="number" name="e1deadIntrvl" value="40" id="e1deadIntrvl" min="1" max="65535" class="text" onkeypress="return avoidSpace(event)"></td>
                        </tr>
                        <tr>
                           <td>Authentication</td>
                           <td>
                              <select class="text" id="e1authentication" name="e1authentication" onchange="showpassword('e1');">
                                 <option value="Disabled">Disabled</option>
                                 <option value="Plain Text">Plain Text</option>
                                 <option value="MD5">MD5</option>
                              </select>
                           </td>
                        </tr>
                        <tr id="e1Password" style="display: none;">
                           <td>Password</td>
                           <td><input id="e1pwd" class="text" type="password" name="pwd" maxlength="16" value=""><span toggle="#password-field" class="fa fa-fw fa-eye field_icon e1toggle-password"></span></td>
                        </tr>
                        <tr>
                           <td>Network Type</td>
                           <td>
                              <select class="text" id="e1ospf_network_type" name="e1ospf_network_type">
                                 <option value="broadcast" selected="">Broadcast</option>
                                 <option value="non-broadcast">Non-Broadcast</option>
                                 <option value="point-to-multipoint">Point-MultiPoint</option>
                                 <option value="point-to-point">Point-Point</option>
                              </select>
                           </td>
                        </tr>
                        <!--<tr>
                           <td>OSPF Area(0-4294967295)</td>
                           <td><input type="number" name="e1ospf_area" id="e1ospf_area" min="0" max="4294967295" class="text" onkeypress="return avoidSpace(event)" onfocusout="setOSPFAreaType('e1','e1ospf_area');checkIsDuplicateArea('e1','ospf_area')"></td>
                        </tr>
                        <tr>
                           <td>OSPF Area Type</td>
                           <td>
                              <select class="text" id="e1ospf_area_type" name="e1ospf_area_type" onclick="setOSPFAreaType('e1','e1ospf_area_type')">
                                 <option value="normal">NONE</option>
                                 <option value="stub">Stub</option>
                                 <option value="stub no-summary">Totally Stub</option>
                                 <option value="nssa">NSSA</option>
                              </select>
                           </td>
                        </tr>-->
                         <tr>
                           <td>Interface Cost (Auto)</td>
						   <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="e1intrfcost_check" id="e1intrfcost_check" style="vertical-align:middle" checked="" onclick="interfacecostConfig('e1intrfcost')" onchange="hideAutoFields('e1_int_cost','e1intrfcost_check')"><span class="slider round"></span></label></td>
                        </tr>
						
						<tr id="e1_int_cost">
						<td>Interface Cost (1-65535)</td>
						<td><input type="number" name="e1intrfcost" id="e1intrfcost" min="1" max="65535"  class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('e1intrfcost',true,'Interface Cost (1-65535)')"></td>
                        <tr>
                        <tr>
                           <td>Router Priority (0-255)</td>
                           <td><input type="number" name="e1router_priority" value="1" id="e1router_priority" min="0" max="255" class="text" onkeypress="return avoidSpace(event)"></td>
                        </tr>
                     </tbody>
                  </table>
               </div>
              <!-- <div id="loopbackdiv" style="margin: 0px; display: none;">
                  <table class="borderlesstab" style="width:660px;" id="interfaceconfig" align="center">
                     <tbody>
                        <tr>
                           <th>Parameters</th>
                           <th>Configuration</th>
                        </tr>
                        <tr>
                           <td>Interface</td>
                           <td>
                              <select class="text" id="loopinterfacecnfg" name="loopinterfacecnfg" onchange="showSelIntf('loopinterfacecnfg')">
                                 <option value="Eth0">Eth0</option>
                                 <option value="Eth1">Eth1</option>
                                 <option value="Loopback" selected="">Loopback</option>
                              </select>
                           </td>
                        </tr>
						<!--<tr>
						<td>Advertise</td>
                        <td><label class="switch"><input type="checkbox" name="loopadver" id="loopadver" style="vertical-align:middle" onchange="hideInterConfig('loopadver','loopinter_config')"><span class="slider round"></span></label></td>
						</tr>-->
						
						<!--</tbody>
						</table>
						<table class="borderlesstab" style="width:660px;" id="loopinter_config" align="center">
						<tbody>
						<tr>
						<td>Passive</td>
						<td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="lppassive_int" id="lppassive_int" style="vertical-align:middle"><span class="slider round"></span></label></td>
						</tr>
						<!--<tr>
						<td>TTL Generic Security Check</td>
						<td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="lpttl_check" id="lpttl_check" style="vertical-align:middle" onchange="hideTTLGenCheck('lpttl_check','lpttl_genericcheck')"><span class="slider round"></span></label>&nbsp;
						<input type="number" name="lpttl_genericcheck" id="lpttl_genericcheck" min="1" max="254" placeholder="Hops(1-254)" style="width:100px;min-width:100px;" class="text" onkeypress="return avoidSpace(event)"></td>
						</tr>-->
                        <!--<tr>
                           <td>Hello Interval (1-65535)</td>
                           <td><input type="number" name="loopheloIntrvl" id="loopheloIntrvl" value="10" min="1" max="65535" class="text" onkeypress="return avoidSpace(event)"></td>
                        </tr>
                        <tr>
                           <td>Dead Interval (1-65535)</td>
                           <td><input type="number" name="loopdeadIntrvl" value="40" id="loopdeadIntrvl" min="1" max="65535" class="text" onkeypress="return avoidSpace(event)"></td>
                        </tr>
                        <tr>
                           <td>Authentication</td>
                           <td>
                              <select class="text" id="loopauthentication" name="loopauthentication" onchange="showpassword('loop');">
                                 <option value="Disabled">Disabled</option>
                                 <option value="Plain Text">Plain Text</option>
                                 <option value="MD5">MD5</option>
                              </select>
                           </td>
                        </tr>
                        <tr id="loopPassword" style="display: none;">
                           <td>Password</td>
                           <td><input id="looppwd" class="text" type="password" name="pwd" maxlength="16" value=""><span toggle="#password-field" class="fa fa-fw fa-eye field_icon looptoggle-password"></span></td>
                        </tr>
                       <!-- <tr>
                           <td>OSPF Area(0-4294967295)</td>
                           <td><input type="number" name="loopospf_area" id="loopospf_area" min="0" max="4294967295" class="text" onkeypress="return avoidSpace(event)" onfocusout="setOSPFAreaType('loop','loopospf_area');checkIsDuplicateArea('loop','ospf_area')"></td>
                        </tr>
                        <tr>
                           <td>OSPF Area Type</td>
                           <td>
                              <select class="text" id="loopospf_area_type" name="loopospf_area_type" onclick="setOSPFAreaType('loop','loopospf_area_type')">
                                 <option value="normal">NONE</option>
                                 <option value="stub">Stub</option>
                                 <option value="stub no-summary">Totally Stub</option>
                                 <option value="nssa">NSSA</option>
                              </select>
                           </td>
                        </tr>-->
                        <!-- <tr>
                           <td>Interface Cost (Auto)</td>
						   <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="loopintrfcost_check" id="loopintrfcost_check" style="vertical-align:middle" checked="" onclick="interfacecostConfig('loopintrfcost')" onchange="hideAutoFields('loop_int_cost','loopintrfcost_check')"><span class="slider round"></span></label></td>
						 </tr>
						 <tr id="loop_int_cost">
						 <td>Interface Cost (1-65535)</td>
						 <td><input type="number" name="loopintrfcost" id="loopintrfcost" min="1" max="65535"  class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('loopintrfcost',true,'Interface Cost (1-65535)')"></td>    <!-- Modified this line  -->
                        <!-- </tr>
                        <tr>
                           <td>Router Priority (0-255)</td>
                           <td><input type="number" name="looprouter_priority" value="1" id="looprouter_priority" min="0" max="255" class="text" onkeypress="return avoidSpace(event)"></td>
                        </tr>
                     </tbody>
                  </table>
               </div>-->
			   <!-- modified from here on 30-8-2022 -->
			   <input type="hidden" id="e0ospf_a_type_hid" value=""/>
			   <input type="hidden" id="e1ospf_a_type_hid" value=""/>
			   <!--<input type="hidden" id="loopospf_a_type_hid" value=""/>
			   <!-- modification ended ........  -->
               <br>
               <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"><input type="submit" value="Save &amp; Apply " name="Save" style="display:inline block" class="button"></div>
            </div>
			
			<div id="area_config" style="margin:0px; display: none;" align="center">
               <input type="text" id="areacnt" name="areacnt" value="1" hidden="">
               <table class="borderlesstab" style="width:660px;" id="areaconfig" align="center">
                  <tbody>
                     <tr>
                        <th style="text-align:center;" width="30px" align="center">S.No</th>
                        <th style="text-align:center;" width="10px" align="center">Area Id</th>
                        <th style="text-align:center;" width="10px" align="center">Type</th>
                        <th style="text-align:center;" width="30px" align="center">Summarise Inter Area</th>
                        <th style="text-align:center;" width="90px" align="center">Action</th>
                     </tr>
                  </tbody>
               </table>
               <div align="center"><input class="button" type="button" id="add" value="Add" style="display:inline block" onclick="addRow('areaconfig')"></div>
               <br>
               <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"><input type="submit" value="Save &amp; Apply " name="Save" style="display:inline block" class="button"></div>
            </div>	
			
            <div id="neighbour" style="margin: 0px; display: none;" align="center">
               <input type="text" id="neighbourcnt" name="neighbourcnt" value="1" hidden="">
               <table class="borderlesstab" style="width:660px;" id="neighconfig" align="center">
                  <tbody>
                     <tr>
                        <th style="text-align:center;" width="30px" align="center">S.No</th>
                        <th style="text-align:center;" width="10px" align="center">neighbour</th>
                        <th style="text-align:center;" width="10px" align="center">Action</th>
                     </tr>
                  </tbody>
               </table>
               <div align="center"><input class="button" type="button" id="add" value="Add" style="display:inline block" onclick="addRow('neighconfig')"></div>
               <br>
               <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"><input type="submit" value="Save &amp; Apply " name="Save" style="display:inline block" class="button"></div>
            </div>
         </form>
      </div>
	  
      <div id="bgpdiv" style="margin: 0.2px; display: none;" width="660px">
         <form action="Nomus.cgi?cgi=bgp.cgi" method="post" onsubmit="return validateBgp('curdiv')">
            <table class="borderlesstab nobackground" style="width:660px;margin-bottom:0px;" id="bgpmenu" align="center">
               <input type="hidden" style="margin:0px;padding:0px" id="bgp_instancebgpsubdivpage" name="bgpsubdivpage" value="bgp_instance">
               <tbody>
                  <tr style="padding:0px;margin:0px;">
                     <td style="padding:0px;margin:0px;">
                        <ul id="bgplist">
                           <li><a class="casesense bgplist" id="hilightthis" style="cursor:pointer" onclick="showDivision('bgp_instance','bgplist')">Instance</a></li>
                           <li><a class="casesense bgplist" style="cursor:pointer" onclick="showDivision('bgp_peers','bgplist')" id="">Peer  Records</a></li>
                           <li><a class="casesense bgplist" style="cursor:pointer" id="" onclick="showDivision('bgppeersettingsdiv','bgplist')">Peer Settings</a></li>
                           <li><a class="casesense bgplist" style="cursor:pointer" onclick="showDivision('path_filtering','bgplist')" id="">Path Filtering</a></li>
						   <li><a class="casesense bgplist" style="cursor:pointer" onclick="showDivision('path_summarization','bgplist')" id="">Path Summarization</a></li>
                        </ul>
                     </td>
                  </tr>
               </tbody>
            </table>
            <div id="bgp_instance" style="margin: 0px;" align="center">
               <input type="hidden" id="bgpinsrcnt" name="bgpinsrcnt" value="0">
               <table class="borderlesstab" id="bgpinsttab" style="width:660px" align="center">
                  <tbody>
                     <tr>
                        <th>Parameters</th>
                        <th>Configuration</th>
                     </tr>
                     <tr>
                        <td>Enable</td>
                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="ins_enable" name="enable" style="vertical-align:middle"><span class="slider round"></span></label></td>
                     </tr>
					 <tr id="bgp_id_auto">
                        <td>Router-ID (Auto)</td>
						<td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="bgp_autocheck" id="bgp_autocheck" style="vertical-align:middle" checked="" onclick="bgpRouIdConfig()" onchange="hideAutoFields('bgproute_id','bgp_autocheck')"><span class="slider round"></span></label></td>
                     </tr>
					 <tr id="bgproute_id">
					 <td>Router-ID</td>
					<td><input type="text" name="bgp_routerid" id="bgp_routerid"  class="text"  onkeypress="return avoidSpace(event)" onfocusout="validateIP('bgp_routerid',false,'Router-ID')" style="outline: initial;" title="">&nbsp;</td>
                     </tr>
					  <tr>
                        <td>Autonomous System Number</td>
                        <td><input type="number" class="text" id="sysnum" name="sysnum"  min="1" max="4294967295" placeholder="(1-4294967295)" onfocusout="validateRange('sysnum',true,'Autonomous System Number ');"></td>
                     </tr>
                     <tr>
                        <td>EBGP Administrative Distance</td>
                        <td><input type="number" class="text" id="admindis" name="admindis" value="20" min="1" max="255"  ></td>
                     </tr>
					 <tr>
                        <td>IBGP Administrative Distance</td>
                        <td><input type="number" class="text" id="ibgp_admindis" name="ibgp_admindis" value="200" min="1" max="255"  ></td>
                     </tr> 
                    <!-- 
					</tr> -->
                    <!-- <tr id="netr1">-->
                       <!-- <td>-->
                          <!-- <div>Network</div>-->
                        <!--</td>-->
						<!--<td><div><input type="text" class="text" id="bgp_netk1" name="bgp_netk1" onkeypress="return avoidSpace(event);" placeholder="(192.168.1.0/24)" onfocusout="validateCIDRNotation('bgp_netk1',false,'Network')"/><label class="add" id="addbgpnetrk1" style="font-size: 15px; display: inline;" onclick="addBgpNetrkRow('bgpinsttab',1)">+</label><label class="remove" style="display: none; font-size: 15px;" id="removebgpnetrk1" onclick="deleteBgpNetrkTableRow(1)">x</label><input id="row10" value="10" hidden=""></div><!-- Modified this line</td>-->  
                    <!-- </tr>  -->
					</tbody>
               </table>
			    <table class="borderlesstab" id="bgpnetworktab" style="width:660px" align="center"><input type="hidden" id="bgpnwcnt" name="bgpnwcnt" value="6">
				</table>
               <table class="borderlesstab" id="bgpinssubtab" style="width:660px" align="center">
                  <tbody>
                     <tr>
                        <td width="230px">Redistribution</td>
                        <td width="200px">
                           <select  id="proto" name="proto" multiple="multiple" style="display: none;">
                              <option value="connected">connected</option>
                              <option value="OSPF">OSPF</option>
                              <option value="STATIC">STATIC</option>
                           </select>
                        </td>
                     </tr>
					  <!--<tr id="down">
                        <td width="200px">Shutdown</td>
                        <td width="200px">
							<div onclick="mouseInAction();">
								<select id="instance_shutdown"  name="instance_shutdown" class="text" multiple="multiple">
                       
								</select>
							</div>
                        </td>
                     </tr>-->
                  </tbody>
               </table>
			   <!--<table class="borderlesstab" id="bgpshutdowntab" style="width:660px" align="center"><input type="text" id="bgpshutdowncnt" name="bgpshutdowncnt" value="1" hidden="">
                  <tbody>
				  </tbody>
				  </table>-->
               <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"><input type="submit" value="Save &amp; Apply " name="Save" style="display:inline block" class="button"></div>
            </div>
			</form>
			 <form action="Nomus.cgi?cgi=bgp.cgi" method="post" onsubmit="return validateBgp('curdiv')">
			 <input type="hidden" style="margin:0px;padding:0px" id="bgp_peersbgpsubdivpage" name="bgpsubdivpage" value="">
            <div id="bgp_peers" align="center" style="display:none;">
               <input type="text" id="bgp_peers_rwcnt" name="bgp_peers_rwcnt" value="1" hidden="">
               <table class="borderlesstab" id="bgppeersconfig" style="width:660px;;margin-bottom:0px;margin-bottom:0px;" align="center">
                  <tbody>
                     <tr>
						<th style="text-align:center;" width="30px" align="center">S.No</th>
						<th style="text-align:center;" width="30px" align="center">Name</th>					
                        <th style="text-align:center;" width="30px" align="center">Status</th>
                        <th style="text-align:center;" width="30px" align="center">Action</th>
                     </tr>
                  </tbody>
               </table>
               <br> <br>
			   <table class="borderlesstab" id="bgppeersconfigadd" align="center">
            <tbody>
			<tr>
                  <td width="180px">New Instance Name</td>
                  <td><input type="text" class="text" id="nwinstname" name="nwinstname" maxlength="32" onkeypress="return avoidSpace(event) && avoidEnter(event)" onfocusout="isEmpty('nwinstname','New Instance Name')"></td>
                  <td colspan="2"><input type="button" class="button1" id="add" value="Add" onclick="checkAlphaNUmeric('nwinstname');"></td>
               </tr>
               <br>
            </tbody>
			</table>
              <!-- <div align="center"><input type="button" class="button" id="add" value="Add" onclick="addNewBgpPeer()"></div>-->
               <br> <br>
               <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"><input type="submit" value="Save &amp; Apply " name="Save" style="display:inline block" class="button"></div>
            </div>
            </form>
			
			 <form action="Nomus.cgi?cgi=bgp.cgi" method="post" onsubmit="return validateBgp('curdiv')">
			<input type="hidden" style="margin:0px;padding:0px" id="add_bgppeerbgpsubdivpage" name="bgpsubdivpage" value="">
			<div id="add_bgppeer" style="margin:0px;display:none;" align="center">
               <table class="borderlesstab" id="bgppeertab" style="width:660px" align="center">
                  <tbody>
                     <tr>
                        <th width="250px">Parameters</th>
                        <th width="250px">Configuration</th>
                     </tr>
                     <tr>
                        <td>Enabled</td>
                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="bgp_peer_en" name="bgp_peer_en" style="vertical-align:middle"><span class="slider round"></span></label></td>
                     </tr>
                     <tr>
                        <td>Name</td>
                        <td><input type="text" class="text" id="peername" name="peername" value="" readonly=""></td>
                     </tr>
                     <!--<tr>
                        <td>Remote Address</td>
                        <td><input type="text" class="text" id="rmt_addr" name="rmt_addr" value="" onfocusout="validateIP('rmt_addr',true,'Remote Address')"></td>
                     </tr>
                     <tr>
                        <td>Remote Port</td>
                        <td><input type="number" class="text" id="rmt_pur" name="rmt_pur" min="0" max="65535" placeholder="(0-65535)" onfocusout="validateRange('rmt_pur',true,'Remote Pur');"></td>
                     </tr>
                     <tr>
                        <td>EBGP Multihop</td>
                        <td><input type="number" class="text" id="bgp_hub" name="bgp_hub" min="1" max="255" placeholder="(0-255)" onfocusout="validateRange('bgp_hub',true,'EBGP Multihub')"></td>
                     </tr>
                     <tr>
                        <td>Default Originate</td>
                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="enable" name="enable" style="vertical-align:middle"><span class="slider round"></span></label></td>
                     </tr>
                     <tr>
                        <td>Description</td>
                        <td><input type="text" class="text" id="desc" name="desc" value="" maxlength="80"></td>
                     </tr>
                     <tr>
                        <td>Password</td>
                        <td><input type="password" class="text" id="pwd" name="pwd" value="" maxlength="80" onkeypress="return avoidSpace(event)"> <span toggle="#password-field" class="fa fa-fw fa-eye field_icon" onmousedown="showPassword('bpeerpwd')" onmouseup="hidePassword('bpeerpwd')"></span> </td>
                     </tr>-->
                  </tbody>
               </table>
			   <table class="borderlesstab" id="peerstab" style="width:660px" align="center"><input type="hidden" id="bgpremnumcnt" name="bgpremnumcnt" value="0">
			   <tbody>
			   
			   </tbody>
			   </table>
               <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"><input type="submit" value="Save &amp; Apply " name="Save" style="display:inline block" class="button"></div>
            </div>
			</form>
			 <form action="Nomus.cgi?cgi=bgp.cgi" method="post" onsubmit="return validateBgp('curdiv')">
            <input type="hidden" style="margin:0px;padding:0px" id="bgppeersettingsdivbgpsubdivpage" name="bgpsubdivpage" value="">
			<div id="bgppeersettingsdiv" style="margin: 0px;display:none;" align="center">
               <input type="text" id="bgppeergrpcnt" name="bgppeergrpcnt" value="1" hidden="">
               <table class="borderlesstab" id="bgppeersettab" style="width:660px;" align="center">
                  <tbody>
                     <tr>
                        <th style="text-align:center;" width="30px" align="center">S.No</th>
						  <th style="text-align:center;" width="30px" align="center">Name</th>
                        <!--<th style="text-align:center;" width="30px" align="center">Status</th>-->
                        <th style="text-align:center;" width="30px" align="center">Action</th>
                     </tr>
                  </tbody>
               </table>
			   <br> <br>
				<!--<div align="center"><input type="button" class="button" id="add" value="Add" onclick="addNewBgpPeerSettings()"></div>
		 <br><br>-->
			   <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"><input type="submit" value="Save &amp; Apply " name="Save" style="display:inline block" class="button"></div>
            </div>
			</form>
			 <form action="Nomus.cgi?cgi=bgp.cgi" method="post" onsubmit="return validateBgp('curdiv')">
            <input type="hidden" style="margin:0px;padding:0px" id="add_bgppeersettingsbgpsubdivpage" name="bgpsubdivpage" value="">
			<div id="add_bgppeersettings" style="margin:0px;display:none;" align="center">
				<input type="hidden" id="add_bgp_peers_rwcnt" name="add_bgp_peers_rwcnt" value="0">
               <table class="borderlesstab" id="add_bgppeersettingstab" style="width:660px" align="center">
                  <tbody>
                     <tr>
                        <th width="200px">Parameters</th>
                        <th width="200px">Configuration</th>
                     </tr>
                     <!--<tr>
                        <td>Enable</td>
                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="bgpgrpenable" name="bgpgrpenable" style="vertical-align:middle"><span class="slider round"></span></label></td>
                     </tr>
                     <tr>
                        <td>Name</td>
                        <td><input type="text" class="text" id="pgrpname" name="pgrpname" value=""></td>
                     </tr>
                     <tr>
                        <td>Remote As</td>
                        <td><input type="number" class="text" id="peegrp_rrmt_as" name="peegrp_rrmt_as" value="" min="1" max="4294967295" onfocusout="validateRange('peegrp_rrmt_as',true,'Remote As')"></td>
                     </tr>
                    <!-- <tr id="neigh"><td><div>Neighbour Address</div></td><td><input type="text" class="text" id="nei_addr" name="nei_addr" value="" onfocusout="validateIP('rmt_addr',true,'Remote Address')"><label class="add" id="addbgpgrpneiaddr1" style="font-size: 15px; display: inline;" onclick="addBgpPeerGrpNeighRow('add_bgppeergrptab',1)">+</label><label class="remove" style="display: none; font-size: 15px;" id="removebgppeergrpnei1" onclick="deleteBgpPeerGrpNeighTableRow(1)">x</label><input id="row10" value="10" hidden=""></div></td></tr>
					 </tbody>
					 </table>
					 <table class="borderlesstab" id="add_bgppeergrpsubtab" style="width:660px" align="center">
                  <tbody>
                     <tr>
                        <td width="200px">Adervertisement Interval</td>
                        <td width="200px"><input type="number" class="text" id="adint" name="adint" placeholder="10" onfocusout="validateRange('rmt_pur',true,'Remote Pur');"></td>
                     </tr>-->
					<!--<tr>
                        <td>Enable</td>
                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="set_enable" name="set_enable" style="vertical-align:middle" checked=""><span class="slider round"></span></label></td>
                     </tr>-->
					 <tr>
                        <td>Peer Records</td>
                        <td><input type="text" class="text" id="peer_records" name="peer_records" value="" readonly></td>
                     </tr>
					<!-- <tr>
					 
                        <td width="200px">Peer Records</td>
						<td width="200px">
				<select id="peer_records" name="peer_records" class="text" onfocus="addPeerRecOptions('bgp_peers_rwcnt','bgpPerrow_val','peer_records');">
                      </select>
					  <input type="hidden" id="oldpeer_recd" name="oldpeer_recd">
                        </td>
						<!--<div>
                         <select id="peer_records" name="peer_records" class="text" onfocus="addPeerRecOptions('bgp_peers_rwcnt','bgpPerrow_val','peer_records');"onchange="PeerCustomOptions('peer_records','','neigh_ip')">
                      
                           </select>
						   </div>
						   <input type="hidden" id="neigh_ipcnt" name="neigh_ipcnt">
						<div>
							<input style="display:none;" id="neigh_ip" type="text" class="text"  onkeypress="return IPV6avoidSpace(event)" onfocusout="validOnshowPeerComboBox('neigh_ip','Neighbour IP','neigh_ipcnt','peer_records')">
						</div>-->
                        </td>
                     </tr>
					
					 <tr>
                        <td>Description</td>
                        <td><input type="text" class="text" id="description" name="description" value="" maxlength="80"></td>
                     </tr>
					 <tr>
                        <td>Password</td>
                  <td><input id="peer_password" class="text" type="password" name="peer_password" value=""><span toggle="#password-field" class="fa fa-fw fa-eye field_icon toggle-peer_password"></span></td>
                     </tr>
					 <tr>
                        <td>KeepAlive Timer (Seconds)</td>
                        <td><input type="number" class="text" id="keep_timer" name="keep_timer" min="0" max="65535" placeholder="(0-65535)" value="20"></td>
                     </tr>
					 <tr>
                        <td>Hold Timer (Seconds)</td>
                        <td><input type="number" class="text" id="hold_timer" name="hold_timer" min="0" max="65535" value="60" placeholder="(0-65535)"></td>
                     </tr>
					<!-- <tr>
                        <td width="200px">Route-map</td>
                        <td width="200px">
                           <select id="route_map" name="route_map" class="text">
                              <option value=""></option>
                              <option value=""></option>
                              <option value=""></option>
                           </select>
                        </td>
                     </tr>-->
					 <tr>
						<td>Update Source</td>
						<td><input type="text" name="update_source" id="update_source"  class="text"  onkeypress="return avoidSpace(event)" placeholder="(192.168.1.10)" onfocusout="validateIPOnly('update_source',false,'Update Source')" style="outline: initial;" title="">&nbsp;</td>
                     </tr>
					 <tr>
					 <td>Default Originate</td>
                        <td><label class="switch"><input type="checkbox" name="default_org" id="defalut_org" style="vertical-align:middle"><span class="slider round"></span></label>
						   
					  </tr>
					 
					 <tr>
						<td>Passive</td>
						<td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="passive" id="passive" style="vertical-align:middle" ><span class="slider round"></span></label></td>
					</tr>
					<tr>
						<td>TTL Generic Security Check</td>
						<td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="ttl_check" id="ttl_check" style="vertical-align:middle" onclick="bgpttlConfig()" onchange="hideTTLGenCheck('ttl_check','ttl_hops')"><span class="slider round"></span></label>&nbsp;
						<input type="number" name="ttl_hops" id="ttl_hops" min="1" max="255" placeholder="Hops(1-255)" style="width:100px;min-width:100px;" class="text" onkeypress="return avoidSpace(event)"></td>
					</tr>
					<tr>
						<td>Disable Next Hop Self</td>
						<td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="nexthop_self" id="nexthop_self" style="vertical-align:middle" onchange="hideTTLGenCheck('nexthop_self','next_hop_self')" checked><span class="slider round"></span></label>&nbsp;
					</tr>
					<td>Route-Reflector-Client</td>
                        <td><label class="switch"><input type="checkbox" name="reflector_client" id="reflector_client" style="vertical-align:middle"><span class="slider round"></span></label>
					 </tr>
					  <td>Route-server-client</td>
                        <td><label class="switch"><input type="checkbox" name="server_client" id="server_client" style="vertical-align:middle"><span class="slider round"></span></label>
					</tr>
                     <!--<tr>
                        <td>Description </td>
                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="descption" name="descption" style="vertical-align:middle"><span class="slider round"></span></label></td>
                     </tr>
                     <tr>
                        <td>inbound Soft-Reconfiguration</td>
                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="insreconf" name="insreconf" style="vertical-align:middle"><span class="slider round"></span></label></td>
                     </tr>
                     <tr>
                        <td>Disable Connected Check</td>
                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="dccheck" name="dccheck" style="vertical-align:middle"><span class="slider round"></span></label></td>
                     </tr>-->
                  </tbody>
               </table>
               <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"><input type="submit" value="Save &amp; Apply " name="Save" style="display:inline block" class="button"></div>
            </div>
			</form>
			 <form action="Nomus.cgi?cgi=bgp.cgi" method="post" onsubmit="return validateBgp('curdiv')">
            <input type="hidden" style="margin:0px;padding:0px" id="path_filteringbgpsubdivpage" name="bgpsubdivpage" value="">
			<div id="path_filtering" style="margin: 0px;display:none;" align="center">
               <input type="text" id="pathlistcnt" name="pathlistcnt" value="1" hidden="">
               <table class="borderlesstab" id="path_listtab" style="width:660px;" align="center">
                  <tbody>
                     <tr>
                       <th style="text-align:center;" width="30px" align="center">S.No</th>
					     <th style="text-align:center;" width="30px" align="center">Name</th>
                        <!--<th style="text-align:center;" width="30px" align="center">Status</th>-->
                        <th style="text-align:center;" width="30px" align="center">Action</th>
                     </tr>
                     
                  </tbody>
               </table>
			   <br> <br>
              
               <!--<div align="center"><input type="button" class="button" id="add" value="Add" onclick="addNewBgpPathFiltering()"></div>
			   <br><br>-->
               <div align="center"><input type="submit" name="S" value="Apply" class="button"><input type="submit" name="Save" value="Save &amp; Apply " class="button"></div>
            </div>
			</form>
			 <form action="Nomus.cgi?cgi=bgp.cgi" method="post" onsubmit="return validateBgp('curdiv')">
			<input type="hidden" style="margin:0px;padding:0px" id="add_bgppathbgpsubdivpage" name="bgpsubdivpage" value="">
			<div id="add_bgppath" style="margin: 0px; display: none;" align="center">
				<input type="hidden" id="add_bgp_path_rwcnt" name="add_bgp_path_rwcnt" value="0">
               <table class="borderlesstab" id="add_bgppathtab" style="width:660px" align="center">
                  <tbody>
                     <tr>
                        <th width="200px">Parameters</th>
                        <th width="200px">Configuration</th>
                     </tr>
					<!-- <tr>
                        <td>Enable</td>
                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="path_enable" name="path_enable" style="vertical-align:middle" checked=""><span class="slider round"></span></label></td>
                     </tr>-->
					 <tr>
                        <td>Peer Records</td>
                        <td><input type="text" class="text" id="path_peer_records" name="path_peer_records" value="" readonly></td>
                     </tr>
					<!--<tr>
                        <td width="200px">Peer Records</td>
                        <td width="200px">
					<select id="path_peer_records" name="path_peer_records" class="text" onfocus="addPeerRecOptions('bgp_peers_rwcnt','bgpPerrow_val','path_peer_records');">
                      </select>
					</td>
                    </tr>					  
						<!--<div>
                           <select id="path_peer_records" name="path_peer_records" class="text" onfocus="addPeerRecOptions('bgp_peers_rwcnt','bgpPerrow_val','path_peer_records');" onchange="PeerCustomOptions('path_peer_records','','neighfr_ip')">
                      
                           </select>
						   </div>
						   <input type="hidden" id="neighfr_ipcnt" name="neighfr_ipcnt">
						<div>
							<input style="display:none;" id="neighfr_ip" type="text" class="text"  onkeypress="return IPV6avoidSpace(event)" onfocusout="validOnshowPeerComboBox('neighfr_ip','Neighbour IP','neighfr_ipcnt','path_peer_records')">
						</div>-->
                       
					<tr>
                        <td width="200px">IP Prefix List</td>
                        <td width="200px">
                           <select id="path_prefix_list" name="path_prefix_list" class="text">
                      
                           </select>
                        </td>
                    </tr>
					<tr>
                        <td>Direction</td>
                        <td>
                           <select id="path_direction" name="path_direction" class="text">
                      <option value="Inbound" selected>Inbound</option>
					  <option value="Outbound">Outbound</option>
                           </select>
                        </td>
                    </tr>
                  </tbody>
               </table>
               <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"><input type="submit" value="Save &amp; Apply " name="Save" style="display:inline block" class="button"></div>
            </div>
			</form>
			<form action="Nomus.cgi?cgi=bgp.cgi" method="post" onsubmit="return validateBgp('curdiv')">
			<input type="hidden" style="margin:0px;padding:0px" id="path_summarizationbgpsubdivpage" name="bgpsubdivpage" value="">
			<div id="path_summarization" style="display:none;"align="center">
               <input type="text" id="bgp_pathsum_rwcnt" name="bgp_pathsum_rwcnt" value="1" hidden="">
               <table class="borderlesstab" id="bgppathsummconfig" style="width:660px;;margin-bottom:0px;margin-bottom:0px;" align="center">
                  <tbody>
                     <tr>
						<th style="text-align:center;" width="10px" align="center">S.No</th>
						<th style="text-align:center;" width="10px" align="center">Address</th>						
                        <th style="text-align:center;" width="30px" align="center">Status</th>
                        <th style="text-align:center;" width="30px" align="center">Action</th>
                     </tr>
                  </tbody>
               </table>
               <br> <br>
			   <table class="borderlesstab" id="pathsummaddtab" align="center">
            <tbody>
			<tr>
                  <td width="180px">New Address</td>
                  <td><input type="text" class="text" id="nwaddr" name="nwaddr" maxlength="32" onkeypress="return avoidSpace(event) && avoidEnter(event)" onfocusout="isEmpty('nwaddr','New Address')"></td>
                  <td colspan="2"><input type="button" class="button1" id="add" value="Add" onclick="addNewBgpPathSumm()"></td>
               </tr>
               <br>
            </tbody>
			</table>
			  <br> <br>
               <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"><input type="submit" value="Save &amp;Apply " name="Save" style="display:inline block" class="button"></div>
            </div>
            
			</form>
			<form action="Nomus.cgi?cgi=bgp.cgi" method="post" onsubmit="return validateBgp('curdiv')">
			<input type="hidden" style="margin:0px;padding:0px" id="add_pathsumbgpsubdivpage" name="bgpsubdivpage" value="">
			<div id="add_pathsum" style="margin:0px;display:none;" align="center">
               <table class="borderlesstab" id="addpathsummtab" style="width:660px" align="center">
                  <tbody>
                     <tr>
                        <th width="200px">Parameters</th>
                        <th width="200px">Configuration</th>
                     </tr>
					 <tr>
                        <td>Enable</td>
                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="summ_enable" name="summ_enable" style="vertical-align:middle" checked=""><span class="slider round"></span></label></td>
                     </tr>
					 <!--<tr>
                        <td>Address</td>
                        <td><input type="text" class="text" id="summ_addr" name="summ_addr" value="" placeholder="(192.168.1.0/24)" onfocusout="validateCIDRNotation('summ_addr',true,'Address')" readonly="" >
						
						</td>
                     </tr>-->
					 <tr>
                        <td>Address</td>
                        <td><input type="text" class="text" id="summ_addr" name="summ_addr" value="" readonly="">
						<input type="hidden" id="oldsumm_addr" name="oldsumm_addr"></td>
                     </tr>
                     <tr>
                        <td>Summary-only</td>
                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="summ_flag" name="summ_flag" style="vertical-align:middle" checked><span class="slider round"></span></label></td>
                     </tr>
					<tr>
                        <td>AS-Set</td>
                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="summ_as_flag" name="summ_as_flag" style="vertical-align:middle"><span class="slider round"></span></label></td>
                    </tr>
                  </tbody>
               </table>
               <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"><input type="submit" value="Save &amp; Apply " name="Save" style="display:inline block" class="button"></div>
            </div>
			
         </form>
		 </div>
         <script>
			showPDivision("ospfdiv");
			hideDefalutInfoOrg();
			hideAutoFields('route_id','ospf_autocheck');
			hideAutoFields('e0_int_cost','e0intrfcost_check');
            hideAutoFields('e1_int_cost','e1intrfcost_check');
			showIntfDiv('Eth0');
			ospfRouIdConfig();
			//addRow('networkconfig')
			//fillrow(1,'1.2.3.6','255.0.0.0',5);
			//addRow('redistribute')
			//fillResRow(1,'BGP Routes','type2',1000);
			//addRow('areaconfig')
			//fillAreaRow(1,5,'Stub','1.2.3.6/5');
			//hideAutoFields('loop_int_cost','loopintrfcost_check');
			
            /*hideInterConfig('e0adver','e0inter_config');
			hideInterConfig('e1adver','e1inter_config');
			hideInterConfig('loopadver','loopinter_config');
		
			/*hideTTLGenCheck('e0ttl_check','e0ttl_genericcheck');
			hideTTLGenCheck('e1ttl_check','e1ttl_genericcheck');
			hideTTLGenCheck('lpttl_check','lpttl_genericcheck');*/
			
			showDivision('global_config','ospflist');
			showPassWord('Eth0');
			/*BGP starts*/
			hideTTLGenCheck('ttl_check','ttl_hops');
			addRow('bgppeersconfig');
			fillBgpPeerRow(1,'checked','ins1','checked, ins1, AS 1, 1.2.3.4');
			
			addRow('bgppeersconfig');
			fillBgpPeerRow(2,'','ins2','checked, ins2, AS 1, 1.2.3.4, 2.3.4.5, 3.4.5.6, AS 2, 4.5.6.7, 5.6.7.8, AS 3, 12.12.12.1');
			
			addRow('bgppeersettab');
			fillBgppersetRow(1,'ins1','pallavi','pallavi@123',21,31,'1.2.3.4','checked','','checked',18,'','checked','');
			addRow('bgppeersettab');
			fillBgppersetRow(2,'ins2','chinnu','pallavi@123',21,31,'1.2.3.4','checked','','','','','checked','');
			addRow('path_listtab');
			fillBgpPathFilteringRow(1,'ins1','','Outbound');
			addRow('path_listtab');
			fillBgpPathFilteringRow(2,'ins2','','');
			
			addRow('bgppathsummconfig');
			fillBgpPathSummRow(1,'1.2.3.6/5','checked','','checked');
			addRow('bgppathsummconfig');
			fillBgpPathSummRow(2,'1.2.5.9/24','','checked','');
			hideAutoFields('bgproute_id','bgp_autocheck');
			addBgpNetrkRow(bgpnetwork);
			addBgpRemSysRow(remsysnum);
			bgpRouIdConfig();
			bgpttlConfig();
			//addPeerShutdownOptions('bgp_peers_rwcnt','bgpPerrow_val','instance_shutdown');
			//addPeerRecOptions('bgp_peers_rwcnt','bgpPerrow_val','peer_records');
			//addPeerRecOptions('bgp_peers_rwcnt','bgpPerrow_val','path_peer_records');
			//PeerCustomOptions('peer_records','','neigh_ip');
			//PeerCustomOptions('path_peer_records','','neighfr_ip');
			//addRow('bgppeersconfig');
			//fillBgpPeerRow(4,'','ins4');
			//showGlobIntfhiderows();
			//addBgpNetrkRow(7);
			//fillBgpNetrkRow(7,'192.168.1.20/24');
			//fillBgpNetrkRow(8,'192.168.1.20/24');
			//addBgpShutdownRow(shutdown);
			//setBgpInsVal();
			//fillBgpPeerRow(1,20,'192.168.10.20','checked',10,30,'checked');
			//fillBgpgrpRow(1,'ins1',20,'checked','23.23.23.23',10,'None','checked','','');
			//setOSPFAreaType('e0','e0ospf_area_type');
			//setOSPFAreaType('e1','e1ospf_area_type');
			//setOSPFAreaType('loop','loopospf_area_type');
		</script>
      
   </body>
</html>
