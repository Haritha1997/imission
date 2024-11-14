<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.nomus.m2m.dao.NodedetailsDao"%>
<%@page import="com.nomus.staticmembers.Symbols"%>
<%@page import="com.nomus.m2m.pojo.NodeDetails"%>
<%@page import="org.apache.commons.net.util.SubnetUtils"%>
<%@page import="java.net.NetworkInterface"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
 String instancename = request.getParameter("nwinstname")==null?"":request.getParameter("nwinstname");
   JSONObject wizjsonnode = null;
   JSONObject ipsec_obj = null;
   JSONArray edit_ipsec_arr = null;
   JSONObject cur_ipsecobj = null;
   JSONObject ipsecobj =null;
   JSONObject isakmp_config =null;
   JSONObject ipsec_config =null;
   JSONObject policies_obj =null;
   JSONArray local_subnet_arr = null;
   JSONArray remote_subnet_arr = null;
   JSONArray bypass_subnet_arr = null;
   
   
   BufferedReader jsonfile = null;  
   String active = "";
   String instname = "";
   String localend = "";
   String remoteend = "";
   String localidenti = "";
   String remoteidenti = "";
   String ipsecmode = "";
   String oplevel = "";
   String authmode = "";
   String exmode = "";
   String routeipsec = "";
   String nattrave = "";
   String backup = "";
  
   String pershared_key = "";
   String DPD_status = "";
   String DPD_Int = "";
   String DPD_to = "";
   String tracking = "";
   String trackip = "";
   String srcintfce = "";
   String interval = "";
   String retries = "";
   String trackfailure = "";
   
   String ISAKMP_enc = "";
   String ISAKMP_hash = "";
   String ISAKMP_grp = "";
   String ISAKMP_lifetime = "";
   
   String IPsec_enc = "";
   String IPsec_hash = "";
   String PFS_grp = "";
   String IPsec_lifetime = "";
   
   //String lanip2 = "";
   //String lansn2 = "";
   String lanbypas="";
   String rmip2 = "";
   String rmsn2 = "";
   //String bypasip2 = "";
   List<String> insnamelist = new ArrayList<String>();
   
   		String slnumber=request.getParameter("slnumber");
   		String version=request.getParameter("version");
		String errorstr = request.getParameter("error");
   if(slnumber != null && slnumber.trim().length() > 0)
   {
	   Properties m2mprops = M2MProperties.getM2MProperties();
	   String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
	   jsonfile = new BufferedReader(new FileReader(new File(slnumpath+File.separator+"Config.json")));
	   StringBuilder jsonbuf = new StringBuilder("");
	   String jsonString="";
	   try
	   {
			while((jsonString = jsonfile.readLine())!= null)
   			jsonbuf.append( jsonString );
			wizjsonnode= JSONObject.fromObject(jsonbuf.toString());
			ipsec_obj = wizjsonnode.containsKey("ipsec")?wizjsonnode.getJSONObject("ipsec"):new JSONObject();
			cur_ipsecobj =  ipsec_obj.containsKey("remote:"+instancename)?ipsec_obj.getJSONObject("remote:"+instancename):new JSONObject();
			isakmp_config =  ipsec_obj.containsKey("p1_proposal:"+instancename+"_p1")?ipsec_obj.getJSONObject("p1_proposal:"+instancename+"_p1"):new JSONObject();
			ipsec_config =  ipsec_obj.containsKey("p2_proposal:"+instancename+"_p2")?ipsec_obj.getJSONObject("p2_proposal:"+instancename+"_p2"):new JSONObject();
			
			///
			Iterator<String> keys =ipsec_obj.keys();
		   	while(keys.hasNext())
		   	{
				String ckey = keys.next();
				if(ckey.contains("remote:")){
					JSONObject ins_obj = ipsec_obj.getJSONObject(ckey);
					String insname = ckey.replace("remote:","");
					if(ins_obj.containsKey("operation_level")){
						if(ins_obj.getString("operation_level").equals("main"))
							insnamelist.add(insname);
					}
				}
			}
					 
			if(cur_ipsecobj.containsKey("tunnel"))
			{
				policies_obj =  ipsec_obj.containsKey("tunnel:"+instancename+"_tunnel")?ipsec_obj.getJSONObject("tunnel:"+instancename+"_tunnel"):new JSONObject();
			}
			else
			{
				policies_obj =  ipsec_obj.containsKey("transport:"+instancename+"_transport")?ipsec_obj.getJSONObject("transport:"+instancename+"_transport"):new JSONObject();
			}
				
			instname = cur_ipsecobj.containsKey("name")?cur_ipsecobj.getString("name"):"";
			localend = cur_ipsecobj.containsKey("local_gateway")?cur_ipsecobj.getString("local_gateway"):"%any";
			remoteend = cur_ipsecobj.containsKey("gateway")?cur_ipsecobj.getString("gateway"):"";
			localidenti = cur_ipsecobj.containsKey("local_identifier")?cur_ipsecobj.getString("local_identifier"):"";
			remoteidenti = cur_ipsecobj.containsKey("remote_identifier")?cur_ipsecobj.getString("remote_identifier"):"";
			 
			ipsecmode = cur_ipsecobj.containsKey("transport")? "transport":"tunnel";
			oplevel = cur_ipsecobj.containsKey("operation_level")?cur_ipsecobj.getString("operation_level"):""; 
			backup = cur_ipsecobj.containsKey("backup_reference")?cur_ipsecobj.getString("backup_reference"):""; 
			authmode = cur_ipsecobj.containsKey("authentication")?cur_ipsecobj.getString("authentication"):""; 
			exmode = cur_ipsecobj.containsKey("exchange_mode")?cur_ipsecobj.getString("exchange_mode"):"";
			
			pershared_key = cur_ipsecobj.containsKey("pre_shared_key")?cur_ipsecobj.getString("pre_shared_key"):"";
			DPD_status = cur_ipsecobj.containsKey("dpdaction")?cur_ipsecobj.getString("dpdaction"):"";
			DPD_Int = cur_ipsecobj.containsKey("dpddelay")?cur_ipsecobj.getString("dpddelay"):"";
			DPD_to = cur_ipsecobj.containsKey("dpdtimeout")?cur_ipsecobj.getString("dpdtimeout"):"";
			tracking = cur_ipsecobj.containsKey("tracking")?cur_ipsecobj.getString("tracking"):"";
			trackip = cur_ipsecobj.containsKey("trackip")?cur_ipsecobj.getString("trackip"):"";
			srcintfce = cur_ipsecobj.containsKey("tracksource")?cur_ipsecobj.getString("tracksource"):"%any";
			interval = cur_ipsecobj.containsKey("interval")?cur_ipsecobj.getString("interval"):"";
			retries = cur_ipsecobj.containsKey("retries")?cur_ipsecobj.getString("retries"):"";
			trackfailure = cur_ipsecobj.containsKey("trackfailure")?cur_ipsecobj.getString("trackfailure"):"";
			 
			ISAKMP_enc = isakmp_config.containsKey("encryption_algorithm")?isakmp_config.getString("encryption_algorithm"):"3des";
			ISAKMP_hash = isakmp_config.containsKey("hash_algorithm")?isakmp_config.getString("hash_algorithm"):"";
			ISAKMP_grp = isakmp_config.containsKey("dh_group")?isakmp_config.getString("dh_group"):"modp1024";
			ISAKMP_lifetime = isakmp_config.containsKey("ikelifetime")?isakmp_config.getString("ikelifetime"):"";
			 
			IPsec_enc = ipsec_config.containsKey("encryption_algorithm")?ipsec_config.getString("encryption_algorithm"):"3des";
			IPsec_hash = ipsec_config.containsKey("authentication_algorithm")?ipsec_config.getString("authentication_algorithm"):"sha1";
			PFS_grp = ipsec_config.containsKey("pfs_group")?ipsec_config.getString("pfs_group"):"modp1024";
			IPsec_lifetime = ipsec_config.containsKey("lifetime")?ipsec_config.getString("lifetime"):"";
			 
			local_subnet_arr = policies_obj.containsKey("local_subnet")?policies_obj.getJSONArray("local_subnet"):new JSONArray();
			remote_subnet_arr = policies_obj.containsKey("remote_subnet")?policies_obj.getJSONArray("remote_subnet"):new JSONArray();
			lanbypas = policies_obj.containsKey("bypass")?policies_obj.getString("bypass"):"";
			bypass_subnet_arr = policies_obj.containsKey("bypass_subnet")?policies_obj.getJSONArray("bypass_subnet"):new JSONArray();
			 
	   }
	   catch(Exception e)
	   {
		   e.printStackTrace();
	   }
	   finally
	   {
		   if(jsonfile != null)
			   jsonfile.close();
	   }
   }
%>
<html>
   <head>
		<meta http-equiv="cache-control" content="max-age=0" />
		<meta http-equiv="cache-control" content="no-cache" />
		<meta http-equiv="expires" content="0" />
		<meta http-equiv="expires" content="Tue, 01 Jan 1980 1:00:00 GMT" />
		<meta http-equiv="pragma" content="no-cache" />
		<link href="css/fontawesome.css" rel="stylesheet">
		<link href="css/solid.css" rel="stylesheet">
		<link href="css/v4-shims.css" rel="stylesheet">
		<link href="css/style.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
		<script type="text/javascript" src="js/common.js"></script>
		<script type="text/javascript" src="js/policyconfig.js"></script>
		<script type="text/javascript" src="js/tracking.js"></script>
		<script type="text/javascript" src="js/ipsec.js"></script>
	</head>
<style>
	.Popup
	  {
	    text-align:left;
	    position: relative;
	    width: 30%;
	    background-color: #DCDCDC;
	    border:2px solid black;
	    max-height:15px;
	    border-radius: 5%;
	    border:1px dotted black;
	    margin:0.2px;
	  }
</style>
	  <script type="text/javascript">
	  
var lclnetiprows = 1;
var remnetiprows = 1;
var bpsnetiprows = 0;	  
	  
function backupreference(id) {
	var optnlvlobj = document.getElementById(id);
	var optnlvl = optnlvlobj.options[optnlvlobj.selectedIndex].text;
	var bckupobj = document.getElementById("backup");
	var hidnlbl = document.getElementById("hidlbl");
	var oplbl = document.getElementById("oplbl");
	if (optnlvl == "Backup") {
		bckupobj.style.display = "inline";
		hidnlbl.style.display = "inline";
		oplbl.style.marginTop="0px";
	} else {
		oplbl.style.marginTop="11px";
		bckupobj.style.display = "none";
		hidnlbl.style.display = "none";
	}
}

function selectIPSECCustom(id) {
	var lclepselobj = document.getElementById(id);
	var lclendpntvalue = lclepselobj.options[lclepselobj.selectedIndex].text;
	if (lclendpntvalue == "Custom") {
		lclepselobj.style.display = 'none';
		var lcleptxtobj = document.getElementById("lclendpnt");
		lcleptxtobj.style.display = 'inline';
		lcleptxtobj.focus();
	}
}

function selectRemoteEndCustom(id) {
	var lclepselobj = document.getElementById(id);
	var lclendpntvalue = lclepselobj.options[lclepselobj.selectedIndex].text;
	if (lclendpntvalue == "Custom") {
		lclepselobj.style.display = 'none';
		var lcleptxtobj = document.getElementById("rmotendpnt");
		lcleptxtobj.style.display = 'inline';
		lcleptxtobj.focus();
	}
}

function disableRouteBasedIPSec(id) {
	var authmodeobj = document.getElementById(id);
	var authmodevalue = authmodeobj.options[authmodeobj.selectedIndex].text;
	var rtebsdipsecid = document.getElementById("rbipsec");
	var rmtendpntcli = document.getElementById("remoteend");
	var rmtendpntser = document.getElementById("rmotendpnt");
	var rmtoptions = document.getElementById("rmtendpt");
	var tracking=document.getElementById("tracking");
	if (authmodevalue == "PSK Server") {
		rtebsdipsecid.checked = false;
		rtebsdipsecid.disabled = true;
		rmtendpntcli.style.display = 'none';
		rmtoptions.style.display = 'inline';
		rmtendpntser.style.display = 'none';
		rmtendpntcli.value="";
		tracking.checked=false;
		tracking.disabled=true;
	} else {
		rtebsdipsecid.disabled = false;
		rmtendpntcli.style.display = 'inline';
		rmtoptions.style.display = 'none';
		rmtendpntser.style.display = 'none';
		tracking.disabled=false;
	}
}

function validOnshowIPSECComboBox(id, name) {
	if (validatenameandip(id, false, name)) showIPSECComboBox(id);
}

function showIPSECComboBox(id) {
	var loceptxtobj = document.getElementById(id);
	var locepselobj = document.getElementById('localend');
	if (loceptxtobj.value.trim() != "") {
		if (locepselobj.length == 7) locepselobj.remove(0);
		var newOption = document.createElement('option');
		newOption.value = loceptxtobj.value.trim();
		newOption.innerHTML = loceptxtobj.value.trim();
		locepselobj.add(newOption, 0);
	}
	else if (locepselobj.length == 7) 
		locepselobj.remove(0);
		
	loceptxtobj.style.display = 'none';
	locepselobj.style.display = 'inline';
	locepselobj.selectedIndex = 0;
}

function validOnshowRemoteIPSECComboBox(id, name) {
	var auth_mode_obj = document.getElementById("authmode");
	var text = auth_mode_obj.options[auth_mode_obj.selectedIndex].text;
	if (validatenameandip(id, false, name)) {
		if(text=="PSK Server")
			showRemoteIPSECComboBox(id);
	} /* else {
		rmtepselctdobj.selectedIndex = 0;
	} */
}

function showRemoteIPSECComboBox(id) {
	var rmteptxtobj = document.getElementById(id);
	var rmtepselobj = document.getElementById('rmtendpt');
	if (rmteptxtobj.value.trim() != "") {
		if (rmtepselobj.length == 3) rmtepselobj.remove(0);
		var newOption = document.createElement('option');
		newOption.value = rmteptxtobj.value.trim();
		newOption.innerHTML = rmteptxtobj.value.trim();
		rmtepselobj.add(newOption, 0);
	}
	else if(rmtepselobj.length == 3) 
		rmtepselobj.remove(0);
	rmteptxtobj.style.display = 'none';
	rmtepselobj.style.display = 'inline';
	rmtepselobj.selectedIndex = 0;
}

function selectAction(id, checkempty, interval, timeout) {
	var actionele = document.getElementById(id);
	var intervalele = document.getElementById(interval);
	var timeoutele = document.getElementById(timeout);
	var action = actionele.value;
	if (action == "2" || action == "3" || action == "4") {
		if (checkempty) {
			intervalele.title = "DPD Interval should not be empty";
			timeoutele.title = "DPD Timeout should not be empty";
			return false;
		} else {
			intervalele.style.outline = "initial";
			timeoutele.style.outline = "initial";
			return true;
		}
	} else {
		intervalele.style.outline = "initial";
		timeoutele.style.outline = "initial";
		return true;
	}
}

function isEmpty(id, name, action) {
	var ele = document.getElementById(id);
	var val = ele.value;
	var actionele = document.getElementById(action);
	var action = actionele.value;
	if (action == "2" || action == "3" || action == "4") {
		if (val == "") {
			ele.style.outline = "thin solid red";
			ele.title = name + " should be empty";
			return false;
		} else {
			ele.style.outline = "initial";
			ele.title = "";
			return true;
		}
	} else {
		ele.style.outline = "initial";
		ele.title = "";
		return true;
	}
}

function validateRange(id, name) {
	var rele = document.getElementById(id);
	var val = rele.value;
	var max = Number(rele.max);
	var min = Number(rele.min);
	if (val.trim() == "") {
		rele.style.outline = "thin solid red";
		rele.title = name + " should be integer in the range from " + min + " to " + max;
		return false;
	}
	if (!isNaN(val)) {
		if (val >= min && val <= max) {
			rele.style.outline = "initial";
			rele.title = "";
			return true;
		} else {
			rele.style.outline = "thin solid red";
			rele.title = name + " should be in the range from " + min + " to " + max;
			return false;
		}
	} else {
		rele.style.outline = "thin solid red";
		rele.title = name + " should be integer in the range from " + min + " to " + max;
		return false;
	}
}

function validateTrackRange(id, name, checkbox) {
	var rele = document.getElementById(id);
	var activate = document.getElementById(checkbox);
	if (activate.checked) {
		var val = rele.value;
		var max = Number(rele.max);
		var min = Number(rele.min);
		if (val.trim() == "") {
			rele.style.outline = "thin solid red";
			rele.title = name + " should be integer in the range from " + min + " to " + max;
			return false;
		}
		if (!isNaN(val)) {
			if (val >= min && val <= max) {
				rele.style.outline = "initial";
				rele.title = "";
				return true;
			} else {
				rele.style.outline = "thin solid red";
				rele.title = name + " should be in the range from " + min + " to " + max;
				return false;
			}
		} else {
			rele.style.outline = "thin solid red";
			rele.title = name + " should be integer in the range from " + min + " to " + max;
			return false;
		}
	} else {
		rele.style.outline = "initial";
	}
}

function gotoipsec(slnumber,version) {
	location.href = "ipsec.jsp?slnumber="+slnumber+"&version="+version;
}

function validateIpsec() {
	try
	{
		var alertmsg = "";
		var remoteend = document.getElementById("rmotendpnt");
		var localendobj = document.getElementById("localend");
		var localend = localendobj.options[localendobj.selectedIndex].text;
		var localendpnt = document.getElementById("lclendpnt");
		var authmodeobj = document.getElementById("authmode");
		var authtcnmode = authmodeobj.options[authmodeobj.selectedIndex].text;
		var rendptobj = document.getElementById("rmtendpt");
		var rendpt = rendptobj.options[rendptobj.selectedIndex].text;
		var remotendpoint = document.getElementById("remoteend");
		var isakmplifetime = document.getElementById("ISAKMP_lifetime");
		var ipseclifetime = document.getElementById("IPsec_lifetime");
		var actionele = document.getElementById("DPD_status");
		var intervalele = document.getElementById("DPD_Int");
		var timeoutele = document.getElementById("DPD_to");
		var pskobj = document.getElementById("preshared_key");
		var sharekeyvalid = PSKCheck("preshared_key");
		var action = actionele.value;
		valid = validatenameandip("lclendpnt", true, "Local Endpoint");
		if (localend == "Custom") {
			if (!valid) {
				if (localendpnt.value.trim() == "") alertmsg += "Local Endpoint should not be empty\n";
				else alertmsg += "Local Endpoint is not valid\n";
			}
		}
		var valid = validatenameandip("remoteend", true, "Remote Endpoint");
		if (authtcnmode == "PSK Client") {
			if (!valid) {
				if (remotendpoint.value.trim() == "") 
					alertmsg += "Remote Endpoint should not be empty\n";
				else 
					alertmsg += "Remote Endpoint is not valid\n";
			}
		}
		valid = validatenameandip("rmotendpnt", true, "Remote Endpoint");
		if (authtcnmode == "PSK Server") {
			if (rendpt == "Custom") {
				if (!valid) {
					if (remoteend.value.trim() == "") 
						alertmsg += "Remote Endpoint should not be empty\n";
					else 
						alertmsg += "Remote Endpoint is not valid\n";
				}
			}
		}
		var oplelobj=document.getElementById("oplevel");
		var bkprefobj=document.getElementById("bckupref");
		if(oplelobj.value=="backup")
			{
			if(bkprefobj.value.trim()==""){
				alertmsg += "Backup Reference should not be empty or Operation Level Should be Main \n";
				oplelobj.style.outline = "thin solid red";
				bkprefobj.style.outline = "thin solid red";
		} else
				{
				oplelobj.style.outline = "initial";
				bkprefobj.style.outline = "initial";
				}
			}
		if(pskobj.value.trim() == "")
		{
			alertmsg += "PreShareKey should not be empty\n";
			pskobj.style.outline = "thin solid red";
			pskobj.title = "PreShareKey should not be empty";
		}
		else if(sharekeyvalid=="Invalid"&&pskobj.value.trim()!= "")
			alertmsg+="PreShareKey doesn't match criteria!\n";
		else if(sharekeyvalid=="Space(or)Tab")
			alertmsg+="Presharedkey shouldn't Contain Space(or)Tab!\n";
		else
		{
			pskobj.style.outline = "initial";
			pskobj.title = "";
		}
		
		valid = validateRange("ISAKMP_lifetime", "Life Time");
		if (!valid) {
			if (isakmplifetime.value.trim() == "") alertmsg += "Life Time(Secs) of ISAKMP SA should not be empty\n";
			else alertmsg += "Life Time(Secs) of ISAKMP SA is not valid\n";
		}
		valid = validateRange("IPsec_lifetime", "Life Time");
		if (!valid) {
			if (ipseclifetime.value.trim() == "") alertmsg += "Life Time(Secs) of IPSec SA should not be empty\n";
			else alertmsg += "Life Time(Secs) of IPSec SA is not valid\n";
		}
		valid = selectAction("DPD_status", true, "DPD_Int", "DPD_to");
		if (action == "2" || action == "3" || action == "4") {
			if (!valid) {
				if (intervalele.value.trim() == "") {
					alertmsg += "DPD Interval should not be empty\n";
					intervalele.style.outline = "thin solid red";
				} else {
					intervalele.style.outline = "initial";
				}
				if (timeoutele.value.trim() == "") {
					alertmsg += "DPD Timeout should not be empty\n";
					timeoutele.style.outline = "thin solid red";
				} else {
					timeoutele.style.outline = "initial";
				}
			}
		}
		if (alertmsg.trim().length == 0) 
		{
			oplevel.disabled = false;
			return "";
		}
		else {
			return alertmsg;
		}
	}
	catch(e)
	{
		alert(e);
	}
	
}

function validateTracking() {
	var alertmsg = "";
	var activation = document.getElementById("tracking");
	var trackip = document.getElementById("trackip");
	var srcintfobj = document.getElementById("srcintfce");
	var sourceinterface = srcintfobj.options[srcintfobj.selectedIndex].text;
	var selectcustom = document.getElementById("interface");
	var check_empty=true;
	if(!activation.checked)
		check_empty=false;
	var valid = validatenameandip("trackip", check_empty, "Remote IP");
	if (!valid) {
		if (trackip.value.trim() == "") alertmsg += "Remote IP should not be empty\n";
		else alertmsg += "Remote IP is not valid\n";
	}
	valid = validatenameandip("interface", true, "Source Interface");
	if (sourceinterface == "Custom") {
		if (!valid) {
			if (selectcustom.value.trim() == "") alertmsg += "Source Interface should not be empty\n";
			else alertmsg += "Source Interface is not valid\n";
		}
	}
	if (activation.checked) {
		
		var interval = document.getElementById("interval");
		var retries = document.getElementById("retries");
		
		valid = validateTrackRange("interval", "Track Interval", "tracking");
		if (!valid) {
			if (interval.value.trim() == "") alertmsg += "Track Interval(Secs) should not be empty\n";
			else alertmsg += "Track Interval(Secs) is not valid\n";
		}
		valid = validateTrackRange("retries", "Track Retries", "tracking");
		if (!valid) {
			if (retries.value.trim() == "") alertmsg += "Track Retries should not be empty\n";
			else alertmsg += "Track Retries is not valid\n";
		}
	}
	if (alertmsg.trim().length == 0) return "";
	else {
		return alertmsg;
	}
}

function validateConfigs() {
	var altmsg = "";
	var ipsecmode = document.getElementById("ipsecmode");
	altmsg += validateIpsec();
	if (ipsecmode.value == "tunnel") 
		altmsg += validatePolicy();
	altmsg += validateTracking();
	if (altmsg.trim().length == 0) return true;
	else {
		alert(altmsg);
		return false;
	}
}


function validatePolicy() {
	var alertmsg = "";
	var valid;
	try{
		var exchmod = document.getElementById("exmode");
		var loctable = document.getElementById("lnettab");
		var locrows = loctable.rows;
		var rmttable = document.getElementById("rnettab");
		var rmtrows = rmttable.rows;
		/* if(exchmod.value == "main" || exchmod.value == "aggressive")
		{
			if(locrows.length>2 && rmtrows.length>1)
				alertmsg += "IKEv1 doesn't support multiple subnets to multiple subnets, only one-to-many or only many-to-one supported !! Please try again..\n";
		} */
		/* var table = document.getElementById("lnettab");
		var rows = table.rows; */
		
		for (var i = 1; i < locrows.length; i++) {
			var cols = locrows[i].cells;
			var ipaddress = cols[1].childNodes[0].childNodes[0];
			var subnet = cols[2].childNodes[0].childNodes[0];
			valid = validateIP(ipaddress.id, true, "IPv4 Address");
			var ipvalid = valid;
			if (!valid) {
				alertmsg += "Local Network " + i;
				if (i == 1) alertmsg += "st";
				else if (i == 2) alertmsg += "nd";
				else if (i == 3) alertmsg += "rd";
				else alertmsg += "th";
				if (ipaddress.value.trim() == "") alertmsg += " IP Address should not be empty\n";
				else alertmsg += " IP Address is not valid\n";
			}
			valid = validateSubnetMask(subnet.id, true, "Subnet Address",true);
			var netvalid = valid;
			if (!valid) {
				alertmsg += "Local Network " + i;
				if (i == 1) alertmsg += "st";
				else if (i == 2) alertmsg += "nd";
				else if (i == 3) alertmsg += "rd";
				else alertmsg += "th";
				if (subnet.value.trim() == "") alertmsg += " Subnet Address should not be empty\n";
				else alertmsg += " Subnet Address is not valid\n";
			}
			valid = false;
			if(ipvalid && netvalid && subnet.value !="255.255.255.255")
			{			
				var locnetwork = getNetwork(ipaddress.value,subnet.value);
				var broadcast = getBroadcast(locnetwork,subnet.value);
				if(ipaddress.value == broadcast)
				{
					alertmsg += " Local Network "+ipaddress.value+" should not be Broadcast\n";
					ipaddress.style.outline = "thin solid red";
					ipaddress.title =  "Local Network should not be Broadcast";
				}
			}
			var i_ip_val = ipaddress.value;
			var i_net_val = subnet.value;
			for(var j=1;j<locrows.length;j++)
			{
				cols = locrows[j].cells;
				var j_ipaddress = cols[1].childNodes[0].childNodes[0];
				var j_subnet = cols[2].childNodes[0].childNodes[0];
				var j_ip_val = j_ipaddress.value;
				var j_net_val = j_subnet.value;
				if((i_ip_val == j_ip_val) && (i != j) && (i_net_val == j_net_val)) {
					if(!alertmsg.includes("Duplicate Local network "+i_ip_val))
						alertmsg += "Duplicate Local network "+i_ip_val+"\n";
					ipaddress.style.outline = "thin solid red";
					ipaddress.title = "Duplicate Local network "+i_ip_val;
					break;
				}
			}
		}
		
		for (var i = 0; i < rmtrows.length; i++) {
			var cols = rmtrows[i].cells;
			var ipaddress = cols[1].childNodes[0].childNodes[0];
			var subnet = cols[2].childNodes[0].childNodes[0];
			var valid = validateIP(ipaddress.id, true, "IPv4 Address");
			var ipvalid = valid;
			if (!valid) {
				alertmsg += "Remote Network " + (i + 1);
				if (i == 0) alertmsg += "st";
				else if (i == 1) alertmsg += "nd";
				else if (i == 2) alertmsg += "rd";
				else alertmsg += "th";
				if (ipaddress.value.trim() == "") alertmsg += " IP Address should not be empty\n";
				else alertmsg += " IP Address is not valid\n";
			}
			valid = validateSubnetMask(subnet.id, true, "Subnet Address",true);
			var netvalid = valid;
			if (!valid) {
				alertmsg += "Remote Network " + (i + 1);
				if (i == 0) alertmsg += "st";
				else if (i == 1) alertmsg += "nd";
				else if (i == 2) alertmsg += "rd";
				else alertmsg += "th";
				if (subnet.value.trim() == "") alertmsg += " Subnet Address should not be empty\n";
				else alertmsg += " Subnet Address is not valid\n";
			}
			valid = false;
			if(ipvalid && netvalid && subnet.value !="255.255.255.255")
			{			
				var remnetwork = getNetwork(ipaddress.value,subnet.value);
				var broadcast = getBroadcast(remnetwork,subnet.value);
				if(ipaddress.value == broadcast)
				{
					alertmsg += " Remote Network  "+ipaddress.value+" should not be Broadcast\n";
					ipaddress.style.outline = "thin solid red";
					ipaddress.title =  "Remote Network should not be Broadcast";
				}
			}
			var i_ip_val = ipaddress.value;
			var i_net_val = subnet.value;
			for(var j=0;j<rmtrows.length;j++)
			{
				cols = rmtrows[j].cells;
				var j_ipaddress = cols[1].childNodes[0].childNodes[0];
				var j_subnet = cols[2].childNodes[0].childNodes[0];
				var j_ip_val = j_ipaddress.value;
				var j_net_val = j_subnet.value;
				if((i_ip_val == j_ip_val) && (i != j) && (i_net_val == j_net_val) && i_ip_val!="" && i_net_val != "") {
					if(!alertmsg.includes("Duplicate Remote network "+i_ip_val))
						alertmsg += "Duplicate Remote network "+i_ip_val+"\n";
					ipaddress.style.outline = "thin solid red";
					ipaddress.title = "Duplicate Remote network "+i_ip_val;
					break;
				}
			}
		}
		var lanbypass = document.getElementById("lanbypas");
		if (lanbypass.checked) {
			var table = document.getElementById("BypassLan");
			var rows = table.rows;
			for (var k = 0; k < rows.length; k++) {
				var cols = rows[k].cells;
				var ipaddress = cols[1].childNodes[0].childNodes[0];
				var subnet = cols[2].childNodes[0].childNodes[0];
				var valid = validateIP(ipaddress.id, true, "IPv4 Address");
				var ipvalid=valid;
				if (!valid) {
					alertmsg += "ByPass Network " + (k + 1);
					if (k == 0) alertmsg += "st";
					else if (k == 1) alertmsg += "nd";
					else if (k == 2) alertmsg += "rd";
					else alertmsg += "th";
					if (ipaddress.value.trim() == "") alertmsg += " IP Address should not be empty\n";
					else alertmsg += " IP Address is not valid\n";
				}
				valid = validateSubnetMask(subnet.id, true, "Subnet Address",true);
				var netvalid=valid;
				if (!valid) {
					alertmsg += "ByPass Network " + (k + 1);
					if (k == 0) alertmsg += "st";
					else if (k == 1) alertmsg += "nd";
					else if (k == 2) alertmsg += "rd";
					else alertmsg += "th";
					if (subnet.value.trim() == "") alertmsg += " Subnet Address should not be empty\n";
					else alertmsg += " Subnet Address is not valid\n";
				}
				valid = false;
				if(ipvalid && netvalid && subnet.value !="255.255.255.255")
				{			
					var network = getNetwork(ipaddress.value,subnet.value);
					var broadcast = getBroadcast(network,subnet.value);
					if(ipaddress.value == broadcast)
					{
						alertmsg += " ByPass Network  "+ipaddress.value+" should not be Broadcast\n";
						ipaddress.style.outline = "thin solid red";
						ipaddress.title =  "ByPass Network should not be Broadcast";
					}
				}
				var i_ip_val = ipaddress.value;
				var i_net_val = subnet.value;
				for(var j=0;j<rows.length;j++)
				{
					cols = rows[j].cells;
					var j_ipaddress = cols[1].childNodes[0].childNodes[0];
					var j_subnet = cols[2].childNodes[0].childNodes[0];
					var j_ip_val = j_ipaddress.value;
					var j_net_val = j_subnet.value;
					if((i_ip_val == j_ip_val) && (k != j) && (i_net_val == j_net_val)) {
						if(!alertmsg.includes("Duplicate Bypass network "+i_ip_val))
							alertmsg += "Duplicate Bypass network "+i_ip_val+"\n";
						ipaddress.style.outline = "thin solid red";
						ipaddress.title = "Duplicate Bypass network "+i_ip_val;
						break;
					}
				}
			}
		}
		if (alertmsg.trim().length == 0) return "";
		else {
			return alertmsg;
		}
	}
	catch(e)
	{
		alert(e);
	}
}
$(document).on('click', '.toggle-password', function () {
	$(this).toggleClass("fa-eye fa-eye-slash");
	var input = $("#preshared_key");
	input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
});
function setDefAuthModeVals()
{
	var authmode=document.getElementById("authmode").value;
	var oplevel=document.getElementById("oplevel");
	var action=document.getElementById("DPD_status");
	var interval=document.getElementById("DPD_Int");
	var timeout=document.getElementById("DPD_to");
	if(authmode=="2")
	 {
		action.value="2";
		interval.value="12";
		timeout.value="60";
		setPSKSerVals();
	 }
	else 
	 {
		oplevel.disabled = false;
		oplevel.style.backgroundColor ='white';
		action.value="4";
		interval.value="30";
		timeout.value="150";
	 }
}
function setPSKSerVals()
{
	var authmode=document.getElementById("authmode").value;
	var oplevel=document.getElementById("oplevel");
	var action=document.getElementById("DPD_status");
	var interval=document.getElementById("DPD_Int");
	var timeout=document.getElementById("DPD_to");
	var remendpt=document.getElementById("rmtendpt");
	var bkpref=document.getElementById("hidlbl");
	var bkprefdiv=document.getElementById("backup");
	if(authmode=="2")
	 {
		if(oplevel.value != "main")
		 {
			bkpref.style.display="none";
			bkprefdiv.style.display="none";
		 }
		oplevel.value="main";
		oplevel.disabled = true;
		oplevel.style.backgroundColor ='#D3D3D3';
		remendpt.value="%any";
	 }
	if((interval.value==""&&timeout.value=="") &&action.value!="1")
	{
		interval.value="30";
		timeout.value="150";
	}
}
/* function showOrHideKeyInfo(id) 
{
	var dialog = document.getElementById('sharedkeyinfo');
	if(dialog.open)
	{
		dialog.close();
		dialog.style.display="none";
	}
	else
	{
		dialog.show();
		dialog.style.display="inline-block";
	}
		
	return dialog;
}  */
	  </script>
	  <%String activation=""; 
	  	String rbaseipsec="";
	  	String nattraversal="";
	  %>
   <body>
      <form action="savedetails.jsp?page=edit_ipsec&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="return validateConfigs()">
         <p align="center" class="style1">IPSec Configuration</p>
		 <input type="hidden" id="lcliprows" name="lcliprows" value="2"/>
		 <input type="hidden" id="rmtiprows" name="rmtiprows" value="2"/>
		 <input type="hidden" id="bypassiprows" name="bypassiprows" value="1"/>
         <table class="borderlesstab nobackground" style="width:800px;margin-bottom:0px;" id="WiZConf" align="center">
            <tbody>
               <tr style="padding:0px;margin:0px;">
                  <td style="padding:0px;margin:0px;">
                     <ul id="ipsecediv">
                        <li><a class="casesense ipseclist" onclick="showDivision('configpage')" id="hilightthis" style="cursor:pointer">IPSec</a></li>
                        <li><a class="casesense ipseclist" onclick="showDivision('policypage')" id="" style="cursor:pointer">Policies</a></li>
                        <li><a class="casesense ipseclist" onclick="showDivision('trackingpage')" id="" style="cursor:pointer">Tracking</a></li>
                     </ul>
                  </td>
               </tr>
            </tbody>
         </table>
         <div id="configpage" align="center" style="margin: 0px; display: inline;">
            <table class="borderlesstab" style="width:800px;" align="center" id="WiZConf">
               <tbody>
                  <tr>
                     <th colspan="4">
                        <div align="center"><strong>General Configuration</strong></div>
                     </th>
                  </tr>
                  <tr>
                  <%if(cur_ipsecobj.containsKey("enabled")){
                	  	activation = cur_ipsecobj.getString("enabled").equals("1")?"checked":"";
                	  }%>
                     <td>Activation</td>
                     <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="activation" id="activation" style="vertical-align:middle" <%=activation%>><span class="slider round"></span></label></td>
                     <td>Instance Name</td>
                     <td><input type="text" class="text" id="instancename" name="instancename" value="<%=instancename%>" onmouseover="setTitle(this)" readonly=""></td>
                  </tr>
                  <tr>
                     <td>Local Endpoint</td>
                     <td>
                        <div>
                           <select name="localend" id="localend" class="text" onchange="selectIPSECCustom('localend')">
                              <option value="%lan"<%if(localend.equals("%lan")){%>selected<%}%>>LAN</option>
                                <% 
                				if(version.trim().startsWith(Symbols.WiZV2+Symbols.EL))
                				{
							%>
                              <option value="%wan"<%if(localend.equals("%wan")){%>selected<%}%>>WAN</option>
                              <%}%>
                              <option value="%loopback"<%if(localend.equals("%loopback")){%>selected<%}%>>Loopback</option>
                              <option value="%cellular"<%if(localend.equals("%cellular")){%>selected<%}%>>Cellular</option>
                              <option value="%any"<%if(localend.equals("%any")){%>selected<%}%>>Any</option>
                              <option value="custom"<%if(!localend.equals("%lan") && !localend.equals("%wan") && !localend.equals("%loopback") && 
                        		   !localend.equals("%cellular") && !localend.equals("%any") && localend.trim().length() > 0){%>selected<%}%>>Custom</option>
                           </select>
                        </div>
                        <div>
                        	<%if(!localend.equals("%lan") && !localend.equals("%wan") && !localend.equals("%loopback") && 
                        		   !localend.equals("%cellular") && !localend.equals("%any") && localend.trim().length() > 0){%>
                           		<input id="lclendpnt" type="text" value="<%=localend%>" class="text" list="configurations" onkeypress="return avoidSpace(event)" onfocusout="validOnshowIPSECComboBox('lclendpnt','Local Endpoint')">
                           		<script>
                           			selectIPSECCustom('localend');
                           		</script>
                           <%}else {%>
                           		<input hidden="" id="lclendpnt" type="text" value="" class="text" list="configurations" onkeypress="return avoidSpace(event)" onfocusout="validOnshowIPSECComboBox('lclendpnt','Local Endpoint')">
                           <%}%>
                           <datalist id="configurations">                            
                           </datalist>
                        </div>
                     </td>
                     <td>Remote Endpoint</td>
                     <td>
                     <%String remoteendval=!remoteend.equals("%any")?remoteend:""; %>
                    	 <input type="text" class="text" name="remoteend" id="remoteend" value="<%=remoteendval%>" maxlength="256" onkeypress="return avoidSpace(event)" onfocusout="validatenameandip('remoteend',true,'Remote Endpoint')" style="display: inline;">
                        <div>
                           <select name="rmtendpt" id="rmtendpt" class="text" onchange="selectRemoteEndCustom('rmtendpt')" style="display: none;">
                              <option value="%any"<%if(remoteend.equals("%any")){%>selected<%}%>>Any</option>
                              <option value="custom"<%if(!remoteend.equals("%any")&&remoteend.trim().length()>0){%>selected<%}%>>Custom</option>
                           </select>
                        </div>
                        <div>
                         <%if(!remoteend.equals("%any")&&remoteend.trim().length()>0) {%>
                        <input type="text" class="text" name="rmotendpnt" id="rmotendpnt" value="<%=remoteend%>" maxlength="256" onkeypress="return avoidSpace(event)" onfocusout="validOnshowRemoteIPSECComboBox('rmotendpnt','Remote Endpoint');" style="display: none;">
                           <script>
                           selectRemoteEndCustom('rmtendpt');
                           	</script>
                           <%}else  {%>
                           <input hidden="" id="rmotendpnt" type="text" value="" class="text" list="configurations" onkeypress="return avoidSpace(event)" onfocusout="validOnshowRemoteIPSECComboBox('rmotendpnt','Remote Endpoint')" style="display: none;">
                           <%} %>
                           <datalist id="configurations">
                           </datalist>
                        </div>
                     </td>
                  </tr>
                  <tr>
                     <td>Local Identifier</td>
                     <td><input type="text" class="text" name="localId" id="localId" value="<%=localidenti%>" maxlength="256" onmouseover="setTitle(this)" onkeypress="return avoidSpace(event)" onfocusout="isEmpty('localId','Local Identifier')"></td>
                     <td>Remote Identifier</td>
                     <td><input type="text" class="text" name="remoteId" id="remoteId" value="<%=remoteidenti%>" maxlength="256" onmouseover="setTitle(this)" onkeypress="return avoidSpace(event)"></td>
                  </tr>
                  <tr>
                     <td>Mode</td>
                     <td>
                        <select name="ipsecmode" id="ipsecmode" class="text">
                           <option value="tunnel"<%if(ipsecmode.equals("tunnel")){%>selected<%}%>>Tunnel</option>
                           <option value="transport"<%if(ipsecmode.equals("transport")){%>selected<%}%>>Transport</option>
                        </select>
                     </td>
                     <td>
                        <div style="margin-top:4px"><label id="oplbl">Operation Level</label></div><br/> <label hidden="" id="hidlbl" style="display: none;">Backup Reference</label>
                     </td>
                     <td>
                        <select name="oplevel" id="oplevel" class="text" onchange="backupreference('oplevel')">
                           <option value="main"<%if(oplevel.equals("main")){%>selected<%}%>>Main</option>
                           <option value="backup"<%if(oplevel.equals("backup")){%>selected<%}%>>Backup</option>
                        </select>
                        <br/>
                        <div id="backup" hidden="" style="display: none"><br/><select name="bckupref" id="bckupref" class="text" >
                        <!--  <option value=''></option> -->
                        <% for(String insname : insnamelist)
                        {
                        	if(!insname.equals(instancename))
                        {%>
                        <option value='<%=insname%>' <%if(backup.equals(insname)){%> selected <%}%>><%=insname %></option>
                        <%} }%>
                        </select></div>
                     </td>
                  </tr>
                  <tr>
                     <td>Auth Mode</td>
                     <td>
                        <select name="authmode" id="authmode" class="text" onchange="disableRouteBasedIPSec('authmode');setDefAuthModeVals();">
                           <option value="1"<%if(authmode.equals("1")){%>selected<%}%>>PSK Client</option>
                           <option value="2"<%if(authmode.equals("2")){%>selected<%}%>>PSK Server</option>
                        </select>
                     </td>
                     <td>Exchange Mode</td>
                     <td>
                        <select name="exmode" id="exmode" class="text">
                           <option value="main"<%if(exmode.equals("main")){%>selected<%}%>>IKEv1-Main</option>
                           <option value="aggressive"<%if(exmode.equals("aggressive")){%>selected<%}%>>IKEv1-Aggressive</option>
                           <option value="ikev2"<%if(exmode.equals("ikev2")){%>selected<%}%>>IKEv2</option>
                        </select>
                     </td>
                  </tr>
                  <tr>
                   <%if(cur_ipsecobj.containsKey("auto"))
                	  	rbaseipsec = cur_ipsecobj.getString("auto").equals("route")?"checked":"";
					else
						rbaseipsec = "checked";
                	  if(cur_ipsecobj.containsKey("mobike"))
                		  nattraversal = cur_ipsecobj.getString("mobike").equals("yes")?"checked":"";
                	  else
                		  nattraversal = "checked";
                	  %>
                     <td>Route Based IPSec</td>
                     <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="rbipsec" id="rbipsec" style="vertical-align:middle" <%=rbaseipsec%>><span class="slider round"></span></label></td>
                     <td>NAT Traversal</td>
                     <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="natt" id="natt" style="vertical-align:middle" <%=nattraversal%>><span class="slider round"></span></label></td>
                  </tr>
                  <tr>
                     <th colspan="4">
                        <div align="center"><strong>Key Configuration</strong></div>
                     </th>
                  </tr>
                  <tr>
                     <td>PreShareKey</td>
                     <td colspan="3"><input id="preshared_key" class="text" type="password" value="<%=pershared_key%>" name="preshared_key" maxlength="32" onkeypress="return avoidSpace(event)" onfocsout="PSKCheck('preshared_key')"><span toggle="#password-field" class="fa fa-fw fa-eye field_icon toggle-password"></span>
                     <img  src="images/i_sym.jpg" alt="i" width="15" height="10" title="Info" id="keyshow" style="cursor:pointer" onclick="showOrHidePWDInfo('sharedkeyinfo')"/>
					<dialog id="sharedkeyinfo" class="Popup">  
						<p>&#8226;Excluded characters " ' : / \ ;</p>
                     </dialog>
                     </td>
                  </tr>
                  <tr>
                     <th colspan="4">
                        <div align="center"><strong>ISAKMP SA Configuration</strong></div>
                     </th>
                  </tr>
                  <tr>
                     <td>Encryption</td>
                     <td>
                        <select name="ISAKMP_enc" id="ISAKMP_enc" class="text">
                           <option value="des" <%if(ISAKMP_enc.equals("des")){%>selected<%}%>>DES</option>
                           <option value="3des" <%if(ISAKMP_enc.equals("3des")){%>selected<%}%>>3DES</option>
                           <option value="aes128" <%if(ISAKMP_enc.equals("aes128")){%>selected<%}%>>AES-128</option>
                           <option value="aes192" <%if(ISAKMP_enc.equals("aes192")){%>selected<%}%>>AES-192</option>
                           <option value="aes256" <%if(ISAKMP_enc.equals("aes256")){%>selected<%}%>>AES-256</option>
                        </select>
                     </td>
                     <td>Hashing</td>
                     <td>
                        <select name="ISAKMP_hash" id="ISAKMP_hash" class="text">
                           <option value="md5" <%if(ISAKMP_hash.equals("md5")){%>selected<%}%>>MD5</option>
                           <option value="sha1" <%if(ISAKMP_hash.equals("sha1")){%>selected<%}%>>SHA1</option>
                           <option value="sha256" <%if(ISAKMP_hash.equals("sha256")){%>selected<%}%>>SHA256</option>
                           <option value="sha384" <%if(ISAKMP_hash.equals("sha384")){%>selected<%}%>>SHA384</option>
                           <option value="sha512" <%if(ISAKMP_hash.equals("sha512")){%>selected<%}%>>SHA512</option>
                        </select>
                     </td>
                  </tr>
                  <tr>
                     <td>DH Group</td>
                     <td>
                        <select name="ISAKMP_grp" id="ISAKMP_grp" class="text">
                           <option value="modp768" <%if(ISAKMP_grp.equals("modp768")){%>selected<%}%>>Modp768/1</option>
                           <option value="modp1024" <%if(ISAKMP_grp.equals("modp1024")){%>selected<%}%>>Modp1024/2</option>
                           <option value="modp1536" <%if(ISAKMP_grp.equals("modp1536")){%>selected<%}%>>Modp1536/5</option>
                           <option value="modp2048" <%if(ISAKMP_grp.equals("modp2048")){%>selected<%}%>>Modp2048/14</option>
                           <option value="modp3072" <%if(ISAKMP_grp.equals("modp3072")){%>selected<%}%>>Modp3072/15</option>
                           <option value="modp4096" <%if(ISAKMP_grp.equals("modp4096")){%>selected<%}%>>Modp4096/16</option>
                           <option value="modp6144"<%if(ISAKMP_grp.equals("modp6144")){%>selected<%}%>>Modp6144/17</option>
                           <option value="modp8192"<%if(ISAKMP_grp.equals("modp8192")){%>selected<%}%>>Modp8192/18</option>
                        </select>
                     </td>
                     <td>Life Time (Secs)</td>
                     <td><input name="ISAKMP_lifetime" type="number" class="text" value="<%=isakmp_config == null?"":isakmp_config.containsKey("ikelifetime")?isakmp_config.getString("ikelifetime"):"86400"%>" id="ISAKMP_lifetime" min="120" max="2147483647" onkeypress="return avoidSpace(event)" onfocusout="validateRange('ISAKMP_lifetime','Life Time')"></td>
                  </tr>
                  <tr>
                     <th colspan="4">
                        <div align="center"><strong>IPSec SA Configuration</strong></div>
                     </th>
                  </tr>
                  <tr>
                     <td>Encryption</td>
                     <td>
                        <select name="IPsec_enc" id="IPsec_enc" class="text">
                           <option value="des" <%if(IPsec_enc.equals("des")){%>selected<%}%>>DES</option>
                           <option value="3des" <%if(IPsec_enc.equals("3des")){%>selected<%}%>>3DES</option>
                           <option value="aes128" <%if(IPsec_enc.equals("aes128")){%>selected<%}%>>AES-128</option>
                           <option value="aes192" <%if(IPsec_enc.equals("aes192")){%>selected<%}%>>AES-192</option>
                           <option value="aes256" <%if(IPsec_enc.equals("aes256")){%>selected<%}%>>AES-256</option>
                        </select>
                     </td>
                     <td>Hashing</td>
                     <td>
                        <select name="IPsec_hash" id="IPsec_hash" class="text">
                           <option value="md5" <%if(IPsec_hash.equals("md5")){%>selected<%}%>>MD5</option>
                           <option value="sha1" <%if(IPsec_hash.equals("sha1")){%>selected<%}%>>SHA1</option>
                           <option value="sha256" <%if(IPsec_hash.equals("sha256")){%>selected<%}%>>SHA256</option>
                           <option value="sha384" <%if(IPsec_hash.equals("sha384")){%>selected<%}%>>SHA384</option>
                           <option value="sha512" <%if(IPsec_hash.equals("sha512")){%>selected<%}%>>SHA512</option>
                        </select>
                     </td>
                  </tr>
                  <tr>
                     <td>PFS Group</td>
                     <td>
                        <select name="PFS_grp" id="PFS_grp" class="text">
						   <option value="disable" <%if(PFS_grp.equals("disable")){%>selected<%}%>>Disable</option>
                           <option value="modp768" <%if(PFS_grp.equals("modp768")){%>selected<%}%>>Modp768/1</option>
                           <option value="modp1024" <%if(PFS_grp.equals("modp1024")){%>selected<%}%>>Modp1024/2</option>
                           <option value="modp1536" <%if(PFS_grp.equals("modp1536")){%>selected<%}%>>Modp1536/5</option>
                           <option value="modp2048" <%if(PFS_grp.equals("modp2048")){%>selected<%}%>>Modp2048/14</option>
                           <option value="modp3072" <%if(PFS_grp.equals("modp3072")){%>selected<%}%>>Modp3072/15</option>
                           <option value="modp4096" <%if(PFS_grp.equals("modp4096")){%>selected<%}%>>Modp4096/16</option>
                           <option value="modp6144" <%if(PFS_grp.equals("modp6144")){%>selected<%}%>>Modp6144/17</option>
                           <option value="modp8192" <%if(PFS_grp.equals("modp8192")){%>selected<%}%>>Modp8192/18</option>
                        </select>
                     </td>
                     <td>Life Time (Secs)</td>
                     <td><input name="IPsec_lifetime" type="number" class="text" value="<%=ipsec_config == null?"":ipsec_config.containsKey("lifetime")?ipsec_config.getString("lifetime"):"3600"%>" id="IPsec_lifetime" min="120" max="2147483647" onkeypress="return avoidSpace(event)" onfocusout="validateRange('IPsec_lifetime','Life Time')"></td>
                  </tr>
                  <tr>
                     <th colspan="4">
                        <div align="center"><strong>Dead Peer Detection</strong></div>
                     </th>
                  </tr>
                  <tr>
                     <td>Action</td>
                     <td>
                        <select name="DPD_status" id="DPD_status" class="text" onchange="selectAction('DPD_status',true,'DPD_Int','DPD_to');">
						    <option value="4" <%if(DPD_status.equals("4")){%>selected<%}%>>Restart</option>
						   <option value="1" <%if(DPD_status.equals("1")){%>selected<%}%>>None</option>
                           <option value="2" <%if(DPD_status.equals("2")){%>selected<%}%>>Clear</option>
                           <option value="3" <%if(DPD_status.equals("3")){%>selected<%}%>>Hold</option>  
                                                   
                        </select>
                     </td>
                     <td>Interval (Secs)</td>
                     <td><input name="DPD_Int" type="number" class="text" value="<%=cur_ipsecobj == null?"":cur_ipsecobj.containsKey("dpddelay")?cur_ipsecobj.getString("dpddelay"):""%>" id="DPD_Int" min="5" max="3600" onkeypress="return avoidSpace(event)" onfocusout="isEmpty('DPD_Int','Interval','DPD_status')"></td>
                  </tr>
                  <tr>
                     <td>Timeout (Secs)</td>
                     <td colspan="3"><input name="DPD_to" type="number" class="text" value="<%=cur_ipsecobj == null?"":cur_ipsecobj.containsKey("dpdtimeout")?cur_ipsecobj.getString("dpdtimeout"):""%>" id="DPD_to" min="5" max="3600" onkeypress="return avoidSpace(event)" onfocusout="isEmpty('DPD_Int','Interval','DPD_status')"></td>
                  </tr>
               </tbody>
            </table>
         </div>
         <div id="policypage" align="center" style="margin: 0px; display: none;">
            <table class="borderlesstab" style="width:800px;" id="lnettab" align="center">
               <tbody>
                  <tr>
                     <th>Parameters</th>
                     <th>Network</th>
                     <th>Subnet</th>
                  </tr>
                  
               </tbody>
            </table>
            <table class="borderlesstab" style="width:800px;" id="rnettab" align="center">
               <tbody>
                   
               </tbody>
            </table>
            <table class="borderlesstab" style="width:800px;" id="WiZConfig" align="center">
               <tbody>
                  <tr>
                     <td width="228px">ByPass-LAN</td>
                     <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="lanbypas" id="lanbypas" style="vertical-align:middle" onchange="showByPassLan('lanbypas','BypassLan')"  <%if(policies_obj.containsKey("bypass") && policies_obj.getString("bypass").equals("1")) {%> checked <%}%>><span class="slider round"></span></label></td>
                  </tr>
               </tbody>
            </table>
            <div align="center" style="width:800px;padding:0;margin:0;">
               <table class="borderlesstab" style="width:800px;" id="BypassLan" align="center" hidden="">
                  <tbody>
                     
                  </tbody>
               </table>
            </div>
         </div>
         <div id="trackingpage" style="margin: 0px; display: none;">
            <table class="borderlesstab" style="width:800px;" id="WiZConf" align="center">
               <tbody>
                  <tr>
                     <th>Parameters</th>
                     <th width="300">Configuration</th>
                  </tr>
                  <tr>
                     <td>Tracking</td>
                     <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="tracking" id="tracking" style="vertical-align:middle"  onchange="deactivateTrack('tracking')"  <%if(cur_ipsecobj.containsKey("tracking") && cur_ipsecobj.getString("tracking").equals("1")) {%> checked <%}%>><span class="slider round"></span></label></td>
                  </tr>
                  <tr>
                     <td>Remote IP</td>
                     <td><input type="text" class="text" name="trackip" id="trackip" value="<%=cur_ipsecobj == null?"":cur_ipsecobj.containsKey("trackip")?cur_ipsecobj.getString("trackip"):""%>" maxlength="256" onkeypress="return avoidSpace(event)" onfocusout="validatenameandip('trackip',true,'Remote IP')"></td>
                  </tr>
                  <tr>
                     <td>Source Interface</td>
                     <td>
                        <div>
                           <select name="srcintfce" id="srcintfce" class="text" onchange="selectSourceCustom('srcintfce')">
                              <option value="%lan" <%if(srcintfce.equals("%lan")){%>selected<%}%>>LAN</option>
                               <% if(version.trim().startsWith(Symbols.WiZV2+Symbols.EL)){%>
                              <option value="%wan" <%if(srcintfce.equals("%wan")){%>selected<%}%>>WAN</option>
                              <% } %>
                              <option value="%loopback"<%if(srcintfce.equals("%loopback")){%>selected<%}%>>Loopback</option>
                              <option value="%cellular" <%if(srcintfce.equals("%cellular")){%>selected<%}%>>Cellular</option>
                              <option value="%any" <%if(srcintfce.equals("%any")){%>selected<%}%>>Any</option>
                              <option value="custom" <%if(!srcintfce.equals("%lan") && !srcintfce.equals("%wan") && !srcintfce.equals("%loopback") && 
                        		   !srcintfce.equals("%cellular") && !srcintfce.equals("%any") && srcintfce.trim().length() > 0){%>selected<%}%>>Custom</option>
                           </select>
                        </div>
                        <div>
                           <%if(!srcintfce.equals("%lan") && !srcintfce.equals("%wan") && !srcintfce.equals("%loopback") && 
                        		   !srcintfce.equals("%cellular") && !srcintfce.equals("%any") && srcintfce.trim().length() > 0){%>
                           		<input id="interface" name="interface" type="text" value="<%=srcintfce%>" class="text" list="trackconfigs" onfocusout="validOnshowSourceComboBox('interface','Track Source Interface')">
                           		<script>
                           		selectSourceCustom('srcintfce');
                           		</script>
                           <%}else {%>
                           		<input hidden="" id="interface" name="interface" type="text" value="" class="text" list="trackconfigs" onfocusout="validOnshowSourceComboBox('interface','Track Source Interface')">
                           <%}%>
                           <datalist id="trackconfigs">
                           </datalist>
                        </div>
                     </td>
                  </tr>
                  <tr>
                     <td>Track Interval(Secs)</td>
                     <td><input type="number" name="interval" class="text" id="interval" value="<%=cur_ipsecobj == null?"":cur_ipsecobj.containsKey("interval")?cur_ipsecobj.getString("interval"):""%>" min="5" max="3600" onkeypress="return avoidSpace(event)" onfocusout="validateTrackRange('interval','Interval','tracking')"></td>
                  </tr>
                  <tr>
                     <td>Track Retries</td>
                     <td><input type="number" class="text" name="retries" id="retries" value="<%=cur_ipsecobj == null?"":cur_ipsecobj.containsKey("retries")?cur_ipsecobj.getString("retries"):""%>" min="1" max="99" onkeypress="return avoidSpace(event)" onfocusout="validateTrackRange('retries','Retries','tracking')"></td>
                  </tr>
                  <tr>
                     <td>Activity on failure</td>
                     <td>
                        <select name="trackfailure" id="trackfailure" class="text">
                           <option value="restart_conn" <%if(trackfailure.equals("restart_conn")){%>selected<%}%>>Restart Connection</option>
                           <option value="restart_router" <%if(trackfailure.equals("restart_router")){%>selected<%}%>>Restart Router</option>
                        </select>
                     </td>
                  </tr>
               </tbody>
            </table>
         </div>
         <div align="center"><input type="button" value="Back to Overview" name="back" style="display:inline block" class="button" onclick="gotoipsec('<%=slnumber%>','<%=version%>')"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"></div>
      </form>
      <%
		    if(local_subnet_arr.size() > 0)
		    {
		    	for(int i=0;i<local_subnet_arr.size();i++)
		    	{
		    		String cidr_ip =  local_subnet_arr.getString(i);
				 SubnetUtils utils = new SubnetUtils(cidr_ip);
				 utils.setInclusiveHostCount(true);
				 String row = i+1+"";
			 %>
 			<script>		
 			addLocalNetworkAndChangeIcon(lclnetiprows);	
 			fillLocalNetwork((lclnetiprows),'<%=utils.getInfo().getAddress()%>','<%=utils.getInfo().getNetmask()%>');
 			</script>				    		
		    	<%}
		    } else {
		  %>
		   <script>		
 				addLocalNetworkAndChangeIcon(lclnetiprows);
 			</script>
		  <%} %>
		  <%
				    if(remote_subnet_arr.size() > 0)
				    {
				    	for(int i=0;i<remote_subnet_arr.size();i++)
				    	{
				    		String cidr_ip =  remote_subnet_arr.getString(i);
						 SubnetUtils utils = new SubnetUtils(cidr_ip);
						 utils.setInclusiveHostCount(true);
						 String row = i+1+"";
					 %>
		 			<script>		
		 			addRemoteNetworkAndChangeIcon(remnetiprows);		 
		 			fillRemoteNetwork(remnetiprows,'<%=utils.getInfo().getAddress()%>','<%=utils.getInfo().getNetmask()%>');
		 			</script>				    		
				    	<%}
				    } else {
				  %>
				   <script>		
				   			addRemoteNetworkAndChangeIcon(remnetiprows);
                           							
		 			</script>
				  <%} %>
	   <%
				    if(bypass_subnet_arr.size() > 0)
				    {
				    	for(int i=0;i<bypass_subnet_arr.size();i++)
				    	{
				    		String cidr_ip =  bypass_subnet_arr.getString(i);
						 SubnetUtils utils = new SubnetUtils(cidr_ip);
						 utils.setInclusiveHostCount(true);
						 String row = i+1+"";
					 %>
		 			<script>
					showByPassLan('lanbypas','BypassLan');
		 			addByPassNetworkAndChangeIcon(bpsnetiprows);		 
		 			fillByPassNetwork(bpsnetiprows,'<%=utils.getInfo().getAddress()%>','<%=utils.getInfo().getNetmask()%>');
					
		 			</script>				    		
				    	<%}
				    } else {
				  %>
				   <script>		
				   			addByPassNetworkAndChangeIcon(bpsnetiprows);
		 			</script>
				  <%} %>
      <script type="text/javascript">
	  backupreference('oplevel');
	 // setDefAuthModeVals();
	  setPSKSerVals();
	  disableRouteBasedIPSec('authmode');
	  showDivision('configpage');
	  findLocalNetworkAndDisplayRemoveIcon();
	  findRemoteNetworkAndDisplayRemoveIcon();
	  findByPassNetworkAndDisplayRemoveIcon();
	  //showIPSECComboBox('lclendpnt');
	  //showSourceComboBox('interface');
	  </script>
   </body>
</html>