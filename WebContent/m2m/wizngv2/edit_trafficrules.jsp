<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="com.nomus.staticmembers.Symbols"%>
<%@page import="com.nomus.m2m.dao.NodedetailsDao"%>
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
 String instancename = request.getParameter("instancename")==null?"":request.getParameter("instancename");
   JSONObject wizjsonnode = null;
   JSONArray edit_trafficrules_arr = null;
   JSONObject edit_trafficrulespage = null;
   BufferedReader jsonfile = null;  
   String instname = "";
   String protocol = "";
   String icmptype = "";
   String srcintf = "";
   String srcip = "";
   String srcport = "";
   String srcmac="";
   String destintf = "";
   String desip = "";
   String desport = "";
   String action = "";
   boolean enabled = false;
   
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
   		
			edit_trafficrules_arr =  wizjsonnode.containsKey("firewall")?(wizjsonnode.getJSONObject("firewall").containsKey("rule")?wizjsonnode.getJSONObject("firewall").getJSONArray("rule"):new JSONArray()):new JSONArray();
			int sel_index = -1;
			for(int i=0;i<edit_trafficrules_arr.size();i++)
			{
				if(((JSONObject)edit_trafficrules_arr.get(i)).getString("name").equals(instancename))
				{
					sel_index=i;
					break;
				}
			}
			if(sel_index != -1)
			{
			 JSONObject edit_traficrule =  (JSONObject)edit_trafficrules_arr.get(sel_index);
			 instname = edit_traficrule.containsKey("name")?edit_traficrule.getString("name"):"";
			 enabled = 	edit_traficrule.containsKey("enabled")?(edit_traficrule.getString("enabled").equals("1")?true:false):false;
			 protocol = edit_traficrule.containsKey("proto")?edit_traficrule.getString("proto"):"";
			 icmptype = edit_traficrule.containsKey("icmp_type")? edit_traficrule.getString("icmp_type"):"";
			 srcintf = edit_traficrule.containsKey("src")? edit_traficrule.getString("src"):"Device (input)";
			 srcip = edit_traficrule.containsKey("src_ip")? edit_traficrule.getString("src_ip"):"";
			 srcport = edit_traficrule.containsKey("src_port")? edit_traficrule.getString("src_port"):"";
			 srcmac = edit_traficrule.containsKey("src_mac")? edit_traficrule.getString("src_mac"):"";
			 destintf = edit_traficrule.containsKey("dest")? edit_traficrule.getString("dest"):"Device (output)";
			 desip = edit_traficrule.containsKey("dest_ip")? edit_traficrule.getString("dest_ip"):"";
			 desport = edit_traficrule.containsKey("dest_port")? edit_traficrule.getString("dest_port"):""; 
			 action = edit_traficrule.containsKey("target")? edit_traficrule.getString("target"):""; 
			}
			else
			instname = instancename;
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
   <meta http-equiv="pragma" content="no-cache" />
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <link rel="stylesheet" type="text/css" href="css/multiselect/bootstrap.min.css">
      <link rel="stylesheet" type="text/css" href="css/multiselect/bootstrap-multiselect.css">
      <script type="text/javascript" src="js/multiselect/jquery1.12.4.min.js"></script>
      <style></style>
      <script type="text/javascript" src="js/multiselect/bootstrap3.3.6.min.js"></script>
	  <script type="text/javascript" src="js/multiselect/bootstrap-multiselect.js"></script>
	  <script type="text/javascript" src="js/traffic.js"></script>
	  <script type="text/javascript" src="js/common.js"></script>
      <style type="text/css">
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

.multiselect-container>.active>a,
.multiselect-container>.active>a:hover,
.multiselect-container>.active>a:focus {
	background-color: grey;
	width: 100%;
}

.multiselect-container>li.active>a>label,
.multiselect-container>li.active>a:hover>label,
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

.caret {
	position: absolute;
	left: 90%;
	top: 40%;
	vertical-align: middle;
	border-top: 6px solid;
	border-top: 6px solid\9;
}
</style>
<script type="text/javascript">
var previous = "";
var previousICMP = "";

function validateTraffic() {
	var alertmsg = "";
	try{
	var sipobj = document.getElementById("sipaddress");
	var dipobj = document.getElementById("dipaddress");
	var srcmacadr = document.getElementById("smacaddress");
	var protoobj = document.getElementById("proto");
	var sportobj = document.getElementById("s_port");
	var dportobj = document.getElementById("d_port");
	var srcintfobj = document.getElementById("sinterface");
	var desintfobj = document.getElementById("dinterface");
	var actobj = document.getElementById("activation");
	if(actobj.checked == true) {
		if(protoobj.value.trim() == "")
			alertmsg += "Protocol should not be empty\n";
	}
		var valid = validateIPOrNetworkPortAndTraffic("sipaddress", false, "Source IP Address");
		var sipvalid = valid;
		if (!valid) {
			if (sipobj.value.trim() == ""){
				showErrorBorder(sipobj,"Source IP Address should not be empty");
				alertmsg += "Source IP Address should not be empty\n";
			}
			else {
				showErrorBorder(sipobj,"Source IP Address is not valid");
				alertmsg += "Source IP Address is not valid\n";
			}
		}
		else
			removeErrorBorder(sipobj);
		var valid = validateIPOrNetworkPortAndTraffic("dipaddress", false, "Destination IP Address");
		if (!valid) {
			if (dipobj.value.trim() == "") {
				showErrorBorder(dipobj,"Destination IP Address should not be empty");
				alertmsg += "Destination IP Address should not be empty\n";
			}
			else {
				showErrorBorder(dipobj,"Destination IP Address is not valid");
				alertmsg += "Destination IP Address is not valid\n";
			}
		}
		else
			removeErrorBorder(dipobj);
		var srcipn = sipobj.value.trim();
		var desipn = dipobj.value.trim();
		var srcnw="";
		var desnw="";
		var srcbc="";
		var desbc="";
		if(valid && sipvalid)
        {
			if(srcipn.includes('/'))
			{
				var srnwarr = srcipn.split('/');
				srcnw =  getNetwork(srnwarr[0],getMask(srnwarr[1]));
				srcbc = getBroadcast(srcnw,getMask(srnwarr[1]));
			}
			else if(srcipn!="")
			{
				srcnw =  getNetwork(srcipn,getMask("32"));
				srcbc = getBroadcast(srcnw,getMask("32"));
			}
			if(desipn.includes('/'))
			{
				var desnwarr = desipn.split('/');
				desnw =  getNetwork(desnwarr[0],getMask(desnwarr[1]));
				desbc = getBroadcast(desnw,getMask(desnwarr[1]));
			}
			else if(desipn!="")
			{
				
				desnw =  getNetwork(desipn,getMask("32"));
				desbc = getBroadcast(desnw,getMask("32"));
			}
			if(desipn != "" && srcipn != "" )
			{
				if((srcnw == desnw && srcbc==desbc  && (srcipn.endsWith("/32") || desipn.endsWith("/32"))) ||(srcipn == desipn)&& (!srcipn.includes("/") && !srcipn.endsWith("/0")))
				{
					
					alertmsg += "Source IP Address should not be same as  Destination IP Address \n";
					showErrorBorder(sipobj,"Source IP Address should not be same as  Destination IP Address");
					showErrorBorder(dipobj,"Destination IP Address should not be same as Source IP Address");
				}
				else
				{
					removeErrorBorder(sipobj);
					removeErrorBorder(dipobj);
				}
				
			}
			/* if(!srcipn.includes('/') && !desipn.includes('/'))
			{
				if(srcipn == desipn)
				{
					alertmsg += "Source IP Address should not be same as  Destination IP Address \n";
					showErrorBorder(sipobj,"Source IP Address should not be same as  Destination IP Address");
					showErrorBorder(dipobj,"Destination IP Address should not be same as Source IP Address");
				}
				else
				{
					removeErrorBorder(sipobj);
					removeErrorBorder(dipobj);
				}
			} */
			
        }
		var valid = validatePortRange("s_port", "Source Port", false);
		if (!valid) {
			if (sportobj.value.trim() == "") alertmsg += "Source Port should not be empty\n";
			else alertmsg += "Source Port is not valid\n";
		}
		var valid = validateMacIP('smacaddress',false,'Source MAC Address');
		if(!valid){
			if(srcmacadr.value.trim() == "" )
				alertmsg += "Source MAC Address should not be empty\n";
			else
				alertmsg += "Source MAC Address is not valid\n";
		}
		var valid = validatePortRange("d_port", "Destination Port", false);
		if (!valid) {
			if (dportobj.value.trim() == "") alertmsg += "Destination Port should not be empty\n";
			else alertmsg += "Destination Port is not valid\n";
		}
		if(actobj.checked == true)
			{
		if((srcintfobj.value.trim() == "Device (output)" && desintfobj.value.trim() == "Device (input)") || srcintfobj.value.trim() ==  desintfobj.value.trim())
		{
			if(srcintfobj.value.trim() == "Device (output)")
			{
				showErrorBorder(srcintfobj,"Source Interface and Destination Interface Should not be device");
				showErrorBorder(desintfobj,"Destination Interface and Source Interface Should not be device");
				alertmsg += "Source Interface and Destination Interface Should not be device\n";
			}
			else
				{
					showErrorBorder(desintfobj,"Source Interface and Destination Interface Should not be same");
					showErrorBorder(srcintfobj,"Source Interface and Destination Interface Should not be same");
					alertmsg += "Source Interface and Destination Interface Should not be same\n";
				}
			
		}
		else {
			removeErrorBorder(desintfobj);
			removeErrorBorder(srcintfobj);	
		}
			}
		/*  if(sipobj.value.trim() == dipobj.value.trim() && sipobj.value.trim() !="" && dipobj.value.trim() !="")
		{
			showErrorBorder(sipobj,"Source Ip Address and Destination Ip Address Should not be same");
			showErrorBorder(dipobj,"Source Ip Address and Destination Ip Address Should not be same");
			alertmsg += "Source Ip Address and Destination Ip Address Should not be same\n";
		}
		else {
			removeErrorBorder(sipobj);
			removeErrorBorder(dipobj);	
		} */
	//}
	if (alertmsg.trim().length == 0) return true;
	else {
		alert(alertmsg);
		return false;
	}
	}
	catch(e)
	{
		alert(e);
	}
}

function displayprotos(id) {
	var protoobj = document.getElementById(id);
	var sprotrow = document.getElementById('sportrow');
	var dprotrow = document.getElementById('dprotrow');
	var icmprow = document.getElementById('icmprow');
	sprotrow.style.display = 'none';
	dprotrow.style.display = 'none';
	icmprow.style.display = 'none';
	var protos = protoobj.options;
	var protocol;
	for (var ind = 0; ind < protos.length; ind++) {
		var obj = protos[ind];
		if (obj.selected) {
			protocol = obj.text;
			if (protocol == "TCP" || protocol == "UDP") {
				sprotrow.style.display = 'table-row';
				dprotrow.style.display = 'table-row';
			}
			if (protocol == "ICMP") {
				icmprow.style.display = 'table-row';
				sprotrow.style.display = 'none';
				dprotrow.style.display = 'none';
			}
			if(protocol == "Any")
			{
				sprotrow.style.display = 'none';
				dprotrow.style.display = 'none';
				icmprow.style.display = 'none';
			}
		}
	}
}
$(document).ready(function () {
	$('#proto').multiselect({
		buttonWidth: '150px',
		numberDisplayed: 3,
	});
	$('#proto').change(function () {
		if (previous == 'all') $('#proto').multiselect('deselect', ['all']);
		else if (previous == 'icmp') $('#proto').multiselect('deselect', ['icmp']);
		else {
			var delopt = "'" + previous + "'";
			if ($('#proto :selected').length == 0) $('#proto').multiselect('deselect', [delopt]);
		}
		previous = $(this).val();
	});
	$('#matchicmp').multiselect({
		buttonWidth: '150px',
		numberDisplayed: 1,
	});
	$('#matchicmp').change(function () {
		if (previousICMP == 'any') $('#matchicmp').multiselect('deselect', ['any']);
		else {
			var delopt = "'" + previousICMP + "'";
			if ($('#matchicmp :selected').length == 0) $('#matchicmp').multiselect('deselect', [delopt]);
		}
		previousICMP = $(this).val();
	});
});

function selectedProtos() {
	$('#proto').multiselect({
		buttonWidth: '150px',
		numberDisplayed: 3,
	});
	$('#matchicmp').multiselect({
		buttonWidth: '150px',
		numberDisplayed: 1,
	});
	var cbobj = document.getElementById("proto");
	var lastopt = cbobj.options[cbobj.length - 1];
	var icmpopt=cbobj.options[cbobj.length - 2];
	var opt_arr = [];
	if (icmpopt.selected) {
		previous = 'icmp';
		for (var i = 0; i < cbobj.length - 2; i++) {
			cbobj.options[i].selected = false;
			opt_arr.push(cbobj.options[i].value);
		}
		$('#proto').multiselect('deselect', opt_arr);
	}
	if (lastopt.selected) {
		previous = 'all';
		for (var i = 0; i < cbobj.length - 1; i++) {
			cbobj.options[i].selected = false;
			opt_arr.push(cbobj.options[i].value);
		}
		$('#proto').multiselect('deselect', opt_arr);
	}
}

function selectedICMPOptions() {
	var cbobj = document.getElementById("matchicmp");
	var lastopt = cbobj.options[cbobj.length - 1];
	var opt_arr = [];
	if (lastopt.selected) {
		previousICMP = 'any';
		for (var i = 0; i < cbobj.length - 1; i++) {
			cbobj.options[i].selected = false;
			opt_arr.push(cbobj.options[i].value);
		}
		$('#matchicmp').multiselect('deselect', opt_arr);
	}
}
function gototrafficrules(slnumber,version) {
	location.href = "trafficrules.jsp?slnumber="+slnumber+"&version="+version;
}
</script>
   </head>
   <body>
      <div style="min-width:96%">
         <div>
            <form action="savedetails.jsp?page=edit_trafficrules&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="return validateTraffic()">
               <br>
               <p align="center" id="traffic" class="style5">Traffic Rules</p>
               <br>
               <table class="borderlesstab" id="WiZConf" align="center">
                  <tbody>
                     <tr>
                        <th width="200px">Parameters</th>
                        <th width="200px">Configuration</th>
                     </tr>
                     <tr>
                        <td>Activation</td>
                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="activation" name="activation" style="vertical-align:middle" <%if(enabled){%> checked <%}%> ><span class="slider round"></span></label></td>
                     </tr>
                     <tr id="instancename">
                        <td>Instance Name</td>
                        <td><input type="text" class="text" id="instancename" name="instancename" value="<%=instancename%>" onmouseover="setTitle(this)" readonly=""></td>
                     </tr>
                     <tr id="protocol">
                        <td>Protocol</td>
                        <td>
                           <select id="proto" name="proto" multiple="multiple" onchange="displayprotos('proto');selectedProtos()" style="display: none;">
                              <option value="tcp" <%if(protocol.contains("tcp")){%>selected<%}%>>TCP</option>
                              <option value="udp" <%if(protocol.contains("udp")){%>selected<%}%>>UDP</option>
                              <option value="icmp" <%if(protocol.contains("icmp")){%>selected<%}%>>ICMP</option>
                              <option value="all" <%if(protocol.contains("all")){%>selected<%}%>>Any</option>
                           </select>
                        </td>
                     </tr>
                     <tr id="icmprow" style="display: none;">
                        <td>Match ICMP type</td>
                        <td>
                           <select id="matchicmp" name="matchicmp" multiple="multiple" onchange="selectedICMPOptions()" style="display: none;">
                              <option value="address-mask-request" <%if(icmptype.contains("address-mask-request")){%>selected<%}%>>address-mask-request</option>
                              <option value="address-mask-reply" <%if(icmptype.contains("address-mask-reply")){%>selected<%}%>>address-mask-reply</option>
                              <option value="communication-prohibited" <%if(icmptype.contains("communication-prohibited")){%>selected<%}%>>communication-prohibited</option>
                              <option value="destination-unreachable" <%if(icmptype.contains("destination-unreachable")){%>selected<%}%>>destination-unreachable</option>
                              <option value="echo-request" <%if(icmptype.contains("echo-request")){%>selected<%}%>>echo-request</option>
                              <option value="echo-reply" <%if(icmptype.contains("echo-reply")){%>selected<%}%>>echo-reply</option>
                              <option value="fragmentation-needed" <%if(icmptype.contains("fragmentation-needed")){%>selected<%}%>>fragmentation-needed</option>
                              <option value="host-precedence-violation" <%if(icmptype.contains("host-precedence-violation")){%>selected<%}%>>host-precedence-violation</option>
                              <option value="host-prohibited" <%if(icmptype.contains("host-prohibited")){%>selected<%}%>>host-prohibited</option>
                              <option value="host-redirect" <%if(icmptype.contains("host-redirect")){%>selected<%}%>>host-redirect</option>
                              <option value="host-unknown" <%if(icmptype.contains("host-unknown")){%>selected<%}%>>host-unknown</option>
                              <option value="host-unreachable" <%if(icmptype.contains("host-unreachable")){%>selected<%}%>>host-unreachable</option>
                              <option value="ip-header-bad" <%if(icmptype.contains("ip-header-bad")){%>selected<%}%>>ip-header-bad</option>
                              <option value="network-prohibited" <%if(icmptype.contains("network-prohibited")){%>selected<%}%>>network-prohibited</option>
                              <option value="network-redirect" <%if(icmptype.contains("network-redirect")){%>selected<%}%>>network-redirect</option>
                              <option value="network-unknown" <%if(icmptype.contains("network-unknown")){%>selected<%}%>>network-unknown</option>
                              <option value="network-unreachable" <%if(icmptype.contains("network-unreachable")){%>selected<%}%>>network-unreachable</option>
                              <option value="parameter-problem" <%if(icmptype.contains("parameter-problem")){%>selected<%}%>>parameter-problem</option>
                              <option value="port-unreachable" <%if(icmptype.contains("port-unreachable")){%>selected<%}%>>port-unreachable</option>
                              <option value="precedence-cutoff" <%if(icmptype.contains("precedence-cutoff")){%>selected<%}%>>precedence-cutoff</option>
                              <option value="protocol-unreachable" <%if(icmptype.contains("protocol-unreachable")){%>selected<%}%>>protocol-unreachable</option>
                              <option value="redirect" <%if(icmptype.contains("redirect")){%>selected<%}%>>redirect</option>
                              <option value="required-option-missing" <%if(icmptype.contains("required-option-missing")){%>selected<%}%>>required-option-missing</option>
                              <option value="source-quench" <%if(icmptype.contains("source-quench")){%>selected<%}%>>source-quench</option>
                              <option value="source-route-failed" <%if(icmptype.contains("source-route-failed")){%>selected<%}%>>source-route-failed</option>
                              <option value="time-exceeded" <%if(icmptype.contains("time-exceeded")){%>selected<%}%>>time-exceeded</option>
                              <option value="timestamp-request" <%if(icmptype.contains("timestamp-request")){%>selected<%}%>>timestamp-request</option>
                              <option value="timestamp-reply" <%if(icmptype.contains("timestamp-reply")){%>selected<%}%>>timestamp-reply</option>
                              <option value="TOS-host-redirect" <%if(icmptype.contains("TOS-host-redirect")){%>selected<%}%>>TOS-host-redirect</option>
                              <option value="TOS-host-unreachable" <%if(icmptype.contains("TOS-host-unreachable")){%>selected<%}%>>TOS-host-unreachable</option>
                              <option value="TOS-network-redirect" <%if(icmptype.contains("TOS-network-redirect")){%>selected<%}%>>TOS-network-redirect</option>
                              <option value="TOS-network-unreachable" <%if(icmptype.contains("TOS-network-unreachable")){%>selected<%}%>>TOS-network-unreachable</option>
                              <option value="ttl-zero-during-transit" <%if(icmptype.contains("ttl-zero-during-transit")){%>selected<%}%>>ttl-zero-during-transit</option>
                              <option value="ttl-zero-during-reassembly" <%if(icmptype.contains("ttl-zero-during-reassembly")){%>selected<%}%>>ttl-zero-during-reassembly</option>
                              <option value="router-advertisement" <%if(icmptype.contains("router-advertisement")){%>selected<%}%>>router-advertisement</option>
                              <option value="router-solicitation" <%if(icmptype.contains("router-solicitation")){%>selected<%}%>>router-solicitation</option>
                              <option value="any" <%if(icmptype.contains("any")){%>selected<%}%>>any</option>
                           </select>
                        </td>
                     </tr>
                     <tr id="sint">
                        <td>Source Interface</td>
                        <td>
                           <select class="text" id="sinterface" name="sinterface">
                              <option value="" <%if(srcintf.equals("Device (output)")){%>selected<%}%>>Device (output)</option>
                              <option value="lan" <%if(srcintf.equals("lan")){%>selected<%}%>>LAN</option>
                          
                        <% if(version.trim().startsWith(Symbols.WiZV2+Symbols.EL))
                        {%>
                              <option value="wan" <%if(srcintf.equals("wan")){%>selected<%}%>>WAN</option>
                              <%}%>
                              <option value="cellular" <%if(srcintf.equals("cellular")){%>selected<%}%>>Cellular</option>
                              <option value="*" <%if(srcintf.equals("*")){%>selected<%}%>>Any (forward)</option>
                           </select>
                        </td>
                     </tr>
                     <tr id="sipa">
                        <td>Source IP Address</td>
                        <td><input type="text" class="text" id="sipaddress" name="sipaddress" value="<%=srcip%>" onkeypress="return avoidSpace(event)" placeholder="any" maxlength="18" onfocusout="validateDualIpForPortAndTraffic('sipaddress',false,'Source IP Address',false)"></td>
                     </tr>
                     <tr id="sportrow" style="display: none;">
                        <td>Source Port</td>
                        <td><input type="text" class="text" id="s_port" name="s_port" value="<%=srcport%>" placeholder="(1-65535)" min="1" max="65535" onkeypress="return avoidSpace(event)" onfocusout="validatePortRange('s_port','Source Port', false)"></td>
                     </tr>
                     <tr id="smaca">
                        <td>Source MAC Address</td>
                        <td><input type="text" class="text" id="smacaddress" name="smacaddress" size="12" value="<%=srcmac%>" onkeypress="return avoidSpace(event)" placeholder="any" maxlength="17" onfocusout="validateMacIP('smacaddress',false,'Source MAC Address')" ></td>
                     </tr>
                     <tr id="dint">
                        <td>Destination Interface</td>
                        <td>
                           <select class="text" id="dinterface" name="dinterface">
                              <option value="" <%if(destintf.equals("Device (input)")){%>selected<%}%>>Device (input)</option>
                              <option value="lan" <%if(destintf.equals("lan")){%>selected<%}%>>LAN</option>
                              System.out.println("version is"+version);
                             <%if(version.trim().startsWith(Symbols.WiZV2+Symbols.EL))
                        	  {%>
                              <option value="wan" <%if(destintf.equals("wan")){%>selected<%}%>>WAN</option>
                             <%} %>
                              <option value="cellular" <%if(destintf.equals("cellular")){%>selected<%}%>>Cellular</option>
                              <option value="*" <%if(destintf.equals("*")){%>selected<%}%>>Any (forward)</option>
                           </select>
                        </td>
                     </tr>
                     <tr>
                        <td>Destination IP Address</td>
                        <td><input type="text" class="text" id="dipaddress" name="dipaddress" value="<%=desip%>" onkeypress="return avoidSpace(event)" placeholder="any" maxlength="18" onfocusout="validateDualIpForPortAndTraffic('dipaddress',false,'Destination IP Address',false)"></td>
                     </tr>
                     <tr id="dprotrow" style="display: none;">
                        <td>Destination Port</td>
                        <td><input type="text" class="text" id="d_port" name="d_port" value="<%=desport%>" placeholder="(1-65535)" min="1" max="65535" onkeypress="return avoidSpace(event)" onfocusout="validatePortRange('d_port','Destination Port',false)"></td>
                     </tr>
                     <tr>
                        <td>Action</td>
                        <td>
                           <select class="text" id="action" name="action">
                              <option value="ACCEPT" <%if(action.equals("ACCEPT")){%>selected<%}%>>accept</option>
                              <option value="REJECT" <%if(action.equals("REJECT")){%>selected<%}%>>reject</option>
                              <option value="DROP" <%if(action.equals("DROP")){%>selected<%}%>>drop</option>
                              <option value="NOTRACK" <%if(action.equals("NOTRACK")){%>selected<%}%>>don't track</option>
                           </select>
                        </td>
                     </tr>
                  </tbody>
               </table>
               <div align="center"><input type="button" value="Back to Overview" name="back" style="display:inline block" class="button" onclick="gototrafficrules('<%=slnumber%>','<%=version%>')"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"></div>
            </form>
            <script>displayprotos('proto');//selectedProtos();
            <%if(protocol.equals("all")) // changed by guru sir
        	{%>
        		 previous = 'all';
        	<%}%>
            </script>
         </div>
      </div>
   </body>
</html>