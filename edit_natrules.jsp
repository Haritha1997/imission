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
   JSONArray edit_natrules_arr = null;
   JSONObject edit_natrulespage = null;
   BufferedReader jsonfile = null;  
   String instname = "";
   String outintf = "";
   String protocol = "";
   String srcip = "";
   String srcport = "";
   String desip = "";
   String desport = "";
   String action = "";
   String rewrtip = "";
   String rewrtport = "";
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
   		
			edit_natrules_arr =  wizjsonnode.containsKey("firewall")?(wizjsonnode.getJSONObject("firewall").containsKey("nat")?wizjsonnode.getJSONObject("firewall").getJSONArray("nat"):new JSONArray()):new JSONArray();
			int sel_index = -1;
			for(int i=0;i<edit_natrules_arr.size();i++)
			{
				if(((JSONObject)edit_natrules_arr.get(i)).getString("name").equals(instancename))
				{
					sel_index=i;
					break;
				}
			}
			if(sel_index != -1)
			{
			 JSONObject edit_natrule =  (JSONObject)edit_natrules_arr.get(sel_index);
			 instname = edit_natrule.containsKey("name")?edit_natrule.getString("name"):"";
			 enabled = 	edit_natrule.containsKey("enabled")?(edit_natrule.getString("enabled").equals("1")?true:false):false;
			 outintf = edit_natrule.containsKey("src")?edit_natrule.getString("src"):"";
			 protocol = edit_natrule.containsKey("proto")?edit_natrule.getString("proto"):"";
			 srcip = edit_natrule.containsKey("src_ip")?edit_natrule.getString("src_ip"):"";
			 srcport = edit_natrule.containsKey("src_port")?edit_natrule.getString("src_port"):"";
			 desip = edit_natrule.containsKey("dest_ip")?edit_natrule.getString("dest_ip"):"";
			 desport = edit_natrule.containsKey("dest_port")?edit_natrule.getString("dest_port"):""; 
			 action = edit_natrule.containsKey("target")?edit_natrule.getString("target"):""; 
			 rewrtip = edit_natrule.containsKey("snat_ip")?edit_natrule.getString("snat_ip"):"";
			 rewrtport = edit_natrule.containsKey("snat_port")?edit_natrule.getString("snat_port"):"";
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
      <script type="text/javascript" src="js/multiselect/bootstrap3.3.6.min.js"></script>
	  <script type="text/javascript" src="js/multiselect/bootstrap-multiselect.js"></script>
	  <script type="text/javascript" src="js/natrules.js"></script>
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
function displayprotos(protoid, actid) {
	//alert("protoid"+protoid);
	var protoobj = document.getElementById(protoid);
	var sprotrow = document.getElementById('sportrow');
	var dprotrow = document.getElementById('dprotrow');
	reportrow = document.getElementById('rewrportrow');
	sprotrow.style.display = 'none';
	dprotrow.style.display = 'none';
	var protos = protoobj.options;
	var protocol;
	for (var ind = 0; ind < protos.length; ind++) {
		var obj = protos[ind];
		if (obj.selected) {
			protocol = obj.text;
			if (protocol == "TCP" || protocol == "UDP" ) {
				sprotrow.style.display = 'table-row';
				dprotrow.style.display = 'table-row';
				reportrow.style.display = 'table-row';
				
			}
			
			else if(protocol == "Any" || protocol == "ICMP")
			{
				sprotrow.style.display = 'none';
				dprotrow.style.display = 'none';
				reportrow.style.display = 'none';
			}
		}
	}
	DisplayRowsOnAction(protoid, actid);
}

function DisplayRowsOnAction(protoid, actid) {
	//alert("in the DisplayRowsOnAction");
	var protoobj = document.getElementById(protoid);
	var actionobj = document.getElementById(actid);
	var actionval = actionobj.options[actionobj.selectedIndex].text;
	reiprow = document.getElementById('rewriprow');
	reportrow = document.getElementById('rewrportrow');
	//alert("actionval is ::"+actionval);
	
	reiprow.style.display = 'none';
	reportrow.style.display = 'none';
	var protos = protoobj.options;
	var protocol;
	if(protos.length <0 ||actionval == 'SNAT')
		reiprow.style.display = 'table-row';
	for (var ind = 0; ind < protos.length; ind++) {
		var obj = protos[ind];
		if (obj.selected) {
			protocol = obj.text;
			if (actionval == 'SNAT') {
				reiprow.style.display = 'table-row';
				if (protocol == "TCP" || protocol == "UDP") 
					reportrow.style.display = 'table-row';
				else if(protocol == "Any" || protocol == "ICMP")
					reportrow.style.display = 'none';
			}
		}
	}
}

function validateNat() {
	try
	{
		var alertmsg = "";
		var sipobj = document.getElementById("sipaddress");
		var dipobj = document.getElementById("dipaddress");
		var rwipobj = document.getElementById("rewriteip");
		var sportobj = document.getElementById("s_port");
		var dportobj = document.getElementById("d_port");
		var protoobj = document.getElementById("proto");
		var rwportobj = document.getElementById("rewriteport");
		var actionobj = document.getElementById("action");
		var check_empty = true;
		var enableobj = document.getElementById("activation");
		if(!enableobj.checked)
			check_empty = false;
		var actionval = actionobj.options[actionobj.selectedIndex].text;
		if(enableobj.checked == true)
		{
			if(protoobj.value.trim() == "")
			{
				alertmsg += "Protocol should not be empty\n";
				showErrorBorder(protoobj,"Protocol should not be empty");
			}
			else
				removeErrorBorder(protoobj);
		}
			var valid; 
			valid = validateIPOrNetwork("sipaddress", false, "Source IP Address");
			var sipvalid = valid;
			if (!valid) {
				if (sipobj.value == "") {
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
			valid = validateIPOrNetwork("dipaddress", false, "Destination IP Address");
			if (!valid) {
				if (dipobj.value == "") 
				{
					showErrorBorder(dipobj,"Destination IP Address should not be empty");
					alertmsg += "Destination IP Address should not be empty\n";
				}
				else
				{
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
				else if(desipn != "")
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
					//if(srcipn == desipn && desipn != "" && srcipn != "")
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
			valid = validatePortRange("s_port", "Source Port", false);
			if (!valid) {
				if (sportobj.value.trim() == "") 
					alertmsg += "Source Port should not be empty\n";
				else 
					alertmsg += "Source Port is not valid\n";
			}
			valid = validatePortRange("d_port", "Destination Port", false);
			if (!valid) {
				if (dportobj.value.trim() == "") 
					alertmsg += "Destination Port should not be empty\n";
				else 
					alertmsg += "Destination Port is not valid\n";
			}
			
				if (actionval == 'SNAT') 
				{
					valid = validateIPOnly("rewriteip",check_empty, "Rewrite IP Address");
					if (!valid) 
					{
						if (rwipobj.value.trim() == "")  
						{
							showErrorBorder(rwipobj,"Rewrite IP Address should not be empty");
							alertmsg += "Rewrite IP Address should not be empty\n";
						}
						else
						{
							showErrorBorder(rwipobj,"Rewrite IP Address is not valid");
							alertmsg += "Rewrite IP Address is not valid\n";
						}
						
					}
					else 
					{
						if(srcnw !="" && rwipobj.value.trim() !="")
						{
							if(srcnw == srcbc && srcnw == rwipobj.value.trim())
							{
								alertmsg += "Rewrite IP Address Should not be same as Source IP Address \n";
								showErrorBorder(rwipobj,"Rewrite IP Address Should not be same as Source IP Address \n");
								showErrorBorder(sipobj,"Rewrite IP Address Should not be same as Source IP Address \n");
								valid = false;
							}
						}
						if(desnw !="" && rwipobj.value.trim() !="")
						{
							if(desnw == desbc && desnw == rwipobj.value.trim())
							{
								alertmsg += "Rewrite IP Address Should not be same as  Destination IP Address \n";
								showErrorBorder(rwipobj,"Rewrite IP Address Should not be same as  Destination IP Address \n");
								showErrorBorder(dipobj,"Rewrite IP Address Should not be same as  Destination IP Address \n");
								valid = false;
							}
						}
					}
					if(valid)
						removeErrorBorder(rwipobj);
					if(protoobj.value.trim() != "") 
					{
					valid = validatePortRange("rewriteport", "Rewrite Port", false);
					if (!valid) {
						if (rwportobj.value.trim() == "") alertmsg += "Rewrite Port should not be empty\n";
						else alertmsg += "Rewrite Port is not valid\n";
								}
					}
				}
				
				
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
});

function selectedProtos() {
	$('#proto').multiselect({
		buttonWidth: '150px',
		numberDisplayed: 3,
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
function gotonatrules(slnumber,version) {
	location.href = "natrules.jsp?slnumber="+slnumber+"&version="+version;
}
</script>
   </head>
   <body>
      <div style="min-width:96%">
         <div>
            <form action="savedetails.jsp?page=edit_natrules&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="return validateNat()">
               <br>
               <p align="center" id="traffic" class="style5">NAT Rules</p>
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
                           <select id="proto" name="proto" multiple="multiple" onchange="displayprotos('proto','action');selectedProtos()" style="display:none">
                              <option value="tcp" <%if(protocol.contains("tcp")){%>selected<%}%>>TCP</option>
                              <option value="udp" <%if(protocol.contains("udp")){%>selected<%}%>>UDP</option>
                              <option value="icmp" <%if(protocol.contains("icmp")){%>selected<%}%>>ICMP</option>
                              <option value="all" <%if(protocol.contains("all")){%>selected<%}%>>Any</option>
                           </select>
                        </td>
                     </tr>
                     <tr id="obint">
                        <td>Outbound Interface</td>
                        <td>
                        
                           <select class="text" id="outbound" name="outbound">
                              <option value="lan" <%if(outintf.equals("lan")){%>selected<%}%>>LAN</option>
                        <%if(version.trim().startsWith(Symbols.WiZV2+Symbols.EL))
        				{
				   		%>
                              <option value="wan" <%if(outintf.equals("wan")){%>selected<%}%>>WAN</option>
                              <%}%>
                              <option value="cellular" <%if(outintf.equals("cellular")){%>selected<%}%>>Cellular</option>
                              <option value="*" <%if(outintf.equals("*") || outintf.equals("")){%>selected<%}%>>Any (forward)</option>
                           </select>
                        </td>
                     </tr>
                     <tr id="sipa">
                        <td>Source IP Address</td>
                        <td><input type="text" class="text" id="sipaddress" name="sipaddress" value="<%=srcip%>" placeholder="any" maxlength="18" onkeypress="return avoidSpace(event)" onfocusout="validateIPOrNetwork('sipaddress',false,'Source IP Address')"></td>
                     </tr>
                     <tr id="sportrow" style="display: none;">
                        <td>Source Port</td>
                        <td><input type="text" class="text" id="s_port" name="s_port" value="<%=srcport%>" placeholder="(1-65535)" min="1" max="65535" onkeypress="return avoidSpace(event)"  onfocusout="validatePortRange('s_port','Source Port', false)"></td>
                     </tr>
                     <tr>
                        <td>Destination IP Address</td>
                        <td><input type="text" class="text" id="dipaddress" name="dipaddress" value="<%=desip%>" placeholder="any" maxlength="18" onkeypress="return avoidSpace(event)" onfocusout="validateIPOrNetwork('dipaddress',false,'Destination IP Address')"></td>
                     </tr>
                     <tr id="dprotrow" style="display: none;">
                        <td>Destination Port</td>
                        <td><input type="text" class="text" id="d_port" name="d_port" value="<%=desport%>" placeholder="(1-65535)" min="1" max="65535" onkeypress="return avoidSpace(event)" onfocusout="validatePortRange('d_port','Destination Port',false)"></td>
                     </tr>
                     <tr>
                        <td>Action</td>
                        <td>
                           <select class="text" id="action" name="action" onchange="DisplayRowsOnAction('proto','action')">
                              <option value="SNAT" <%if(action.equals("SNAT")){%>selected<%}%>>SNAT</option>
                              <option value="MASQUERADE" <%if(action.equals("MASQUERADE")){%>selected<%}%>>MASQUERADE</option>
                              <option value="ACCEPT" <%if(action.equals("ACCEPT")){%>selected<%}%>>ACCEPT</option>
                           </select>
                        </td>
                     </tr>
                     <tr id="rewriprow" hidden="" style="display: none;">
                        <td>Rewrite IP Address</td>
                        <td><input type="text" class="text" id="rewriteip" name="rewriteip" value="<%=rewrtip%>" maxlength="15" onkeypress="return avoidSpace(event)" onfocusout="validateIPOnly('rewriteip',false,'Rewrite IP Address')"></td>
                     </tr>
                     <tr id="rewrportrow" hidden="" style="display: none;">
                        <td>Rewrite Port</td>
                        <td><input type="text" class="text" id="rewriteport" name="rewriteport" value="<%=rewrtport%>" placeholder="(1-65535)" min="1" max="65535" onkeypress="return avoidSpace(event)" onfocusout="validatePortRange('rewriteport','Rewrite Port',false)"></td>
                     </tr>
                  </tbody>
               </table>
               <div align="center"><input type="button" value="Back to Overview" name="back" style="display:inline block" class="button" onclick="gotonatrules('<%=slnumber%>','<%=version%>')"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"></div>
            </form>
            <script>
            //alert("calling displayprotos");
			displayprotos('proto','action');
			  //alert("calling selectedProtos");
			selectedProtos();
			
			</script>
         </div>
      </div>
   </body>
</html>