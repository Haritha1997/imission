<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="com.nomus.staticmembers.Symbols"%>
<%@page import="com.nomus.m2m.dao.NodedetailsDao"%>
<%@page import="com.nomus.m2m.pojo.NodeDetails"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.net.URLDecoder"%>
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
	JSONArray edit_portfrwd_arr = null;
	JSONObject zerotierobj=null;
	JSONObject ztsample_configobj=null;
	BufferedReader jsonfile = null;  
   
	String instname = "";
	String protocol = "";
	String srcintf = "";
	String srcip = "";
	String srcport = "";
	String destintf = "";
	String desip = "";
	String desport = "";
	String extip = "";
	String extport = "";
	String enable="";
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
   		
			edit_portfrwd_arr =  wizjsonnode.containsKey("firewall")?(wizjsonnode.getJSONObject("firewall").containsKey("redirect")?wizjsonnode.getJSONObject("firewall").getJSONArray("redirect"):new JSONArray()):new JSONArray();
			zerotierobj=wizjsonnode.containsKey("zerotier")?wizjsonnode.getJSONObject("zerotier"):new JSONObject();
			ztsample_configobj=zerotierobj.containsKey("zerotier:sample_config")?zerotierobj.getJSONObject("zerotier:sample_config"):new JSONObject();
			enable=ztsample_configobj.containsKey("enabled")?ztsample_configobj.getString("enabled"):"";
			int sel_index = -1;
			for(int i=0;i<edit_portfrwd_arr.size();i++)
			{
				//System.out.println(((JSONObject)edit_portfrwd_arr.get(i)).getString("name")+" "+instancename);
				if(((JSONObject)edit_portfrwd_arr.get(i)).getString("name").equals(instancename))
				{
					sel_index=i;
					break;
				}
			}
			if(sel_index != -1)
			{
				JSONObject edit_portfrwd =  (JSONObject)edit_portfrwd_arr.get(sel_index);
				instname = edit_portfrwd.containsKey("name")?edit_portfrwd.getString("name"):"";
				enabled = 	edit_portfrwd.containsKey("enabled")?(edit_portfrwd.getString("enabled").equals("1")?true:false):false;
				protocol = edit_portfrwd.containsKey("proto")?edit_portfrwd.getJSONArray("proto").toString():"";
				srcintf = edit_portfrwd.containsKey("src")?edit_portfrwd.getString("src"):"";
				srcip = edit_portfrwd.containsKey("src_ip")?edit_portfrwd.getString("src_ip"):"";
				srcport = edit_portfrwd.containsKey("src_port")?edit_portfrwd.getString("src_port"):"";
				destintf = edit_portfrwd.containsKey("dst")?edit_portfrwd.getString("dst"):"";
				desip = edit_portfrwd.containsKey("dest_ip")?edit_portfrwd.getString("dest_ip"):"";
				desport = edit_portfrwd.containsKey("dest_port")?edit_portfrwd.getString("dest_port"):"";
				extip = edit_portfrwd.containsKey("src_dip")?edit_portfrwd.getString("src_dip"):"";
				extport = edit_portfrwd.containsKey("src_dport")?edit_portfrwd.getString("src_dport"):"";
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
      <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
      <style></style>
      <script type="text/javascript" src="js/portforward.js"></script>
	  <script type="text/javascript" src="js/common.js"></script>
	  <script type="text/javascript">
	  function validateForwardEdit() {
	var alertmsg = "";
	try{
	var sipobj = document.getElementById("sipaddress");
	var sportobj = document.getElementById("s_port");
	var protoobj = document.getElementById("proto");
	var eipobj = document.getElementById("eipaddress");
	var eportobj = document.getElementById("e_port");
	var intipobj = document.getElementById("intipaddress");
	var iportobj = document.getElementById("i_port");
	var srcintfobj = document.getElementById("sinterface");
	var intfobj = document.getElementById("int_interface");
	var check_empty = true;
	var enableobj = document.getElementById("activation");
	if(!enableobj.checked)
		check_empty = false;
	
	if(protoobj.value.trim() == "")
		alertmsg += "Protocol should not be empty\n";
	var valid = validateIPOrNetworkPortAndTraffic("sipaddress", false, "Source IP Address");
	var sipvalid = valid;
	if (!valid) {
		if (sipobj.value.trim() == "") {
			showErrorBorder(sipobj,"Source IP Address should not be empty");
			alertmsg += "Source IP Address should not be empty\n";
		}
		else {
			showErrorBorder(sipobj,"Source IP Address is not valid");
			alertmsg += "Source IP Address is not valid\n";
		}
	}
	
	var valid = validateIPOrNetworkPortAndTraffic("eipaddress", false, "External IP Address");
	if (!valid) {
		if (eipobj.value.trim() == "") {
			showErrorBorder(eipobj,"External IP Address should not be empty");
			alertmsg += "External IP Address should not be empty\n";
		}
		else {
			showErrorBorder(eipobj,"External IP Address is not valid");
			alertmsg += "External IP Address is not valid\n";
		}
	}
	else
		removeErrorBorder(eipobj);
	var srcipn = sipobj.value.trim();
	var exipn = eipobj.value.trim();
	var srcnw="";
	var exnw="";
	var srcbc="";
	var exbc="";
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
		if(exipn.includes('/'))
		{
			var exnwarr = exipn.split('/');
			exnw =  getNetwork(exnwarr[0],getMask(exnwarr[1]));
			exbc = getBroadcast(exnw,getMask(exnwarr[1]));
		}
		else if(exipn!="")
		{
			exnw =  getNetwork(exipn,getMask("32"));
			exbc = getBroadcast(exnw,getMask("32"));
		}
		if(srcipn !="" &&exipn !="")
		{
			if((srcnw == exnw && srcbc==exbc  && (srcipn.endsWith("/32") || exipn.endsWith("/32"))) ||(srcipn == exipn)&&(!srcipn.includes("/") && !srcipn.endsWith("/0")))
			{
				
				alertmsg += "Source IP Address should not be same as  External IP Address \n";
				showErrorBorder(sipobj,"Source IP Address should not be same as  External IP Address");
				showErrorBorder(eipobj,"External IP Address should not be same as Source IP Address");
			}
			else
			{
				removeErrorBorder(sipobj);
				removeErrorBorder(eipobj);
			}
		}
		/* if(!srcipn.includes('/') && !exipn.includes('/'))
		{
			 if(srcipn == exipn)
			{
				alertmsg += "Source IP Address should not be same as  External IP Address \n";
				showErrorBorder(sipobj,"Source IP Address should not be same as  External IP Address");
				showErrorBorder(eipobj,"External IP Address should not be same as Source IP Address");
			}
			else
			{
				removeErrorBorder(sipobj);
				removeErrorBorder(eipobj);
			}
		} */
		
    }
	if(check_empty)
		{
if(srcintfobj.value.trim() ==  intfobj.value.trim())
{
			showErrorBorder(intfobj,"Source Interface and Internal Interface Should not be same");
			showErrorBorder(srcintfobj,"Source Interface and Internal Interface Should not be same");
			alertmsg += "Source Interface and Internal Interface Should not be same\n";
}
else {
	removeErrorBorder(intfobj);
	removeErrorBorder(srcintfobj);	
}}
	var valid = validatePortRange("e_port", "External Port", check_empty);
	if (!valid) {
		if (eportobj.value.trim() == ""){
			alertmsg += "External Port should not be empty\n";
		}
		else {
			alertmsg += "External Port is not valid\n";
		}
	}
	var valid = validatePortRange("s_port", "Source Port", false);
	if (!valid) {
		if (sportobj.value.trim() == "") alertmsg += "Source Port should not be empty\n";
		else alertmsg += "Source Port is not valid\n";
	}
	var valid = validateIPOnly("intipaddress", check_empty, "Internal IP Address");
	if (!valid) {
		if (intipobj.value.trim() == "") {
			showErrorBorder(intipobj,"Internal IP Address should not be empty");
			alertmsg += "Internal IP Address should not be empty\n";
		}
		else {
			showErrorBorder(intipobj,"Internal IP Address is not valid");
			alertmsg += "Internal IP Address is not valid\n";
		}
	}
	else
		{
			if(srcnw !="" && intipobj.value.trim() !="")
			{
				if(srcnw == srcbc && srcnw == intipobj.value.trim())
				{
					alertmsg += "Internal IP Address Should not be same as Source IP Address \n";
					showErrorBorder(intipobj,"Internal IP Address Should not be same as Source IP Address \n");
					valid = false;
				}
			}
			if(exnw !="" && intipobj.value.trim() !="")
			{
				if(exnw == exbc && exnw == intipobj.value.trim())
				{
					alertmsg += "Internal IP Address Should not be same as  External IP Address \n";
					showErrorBorder(intipobj,"Internal IP Address Should not be same as  External IP Address \n");
					valid = false;
				}
			}
		}
	if(valid)
		removeErrorBorder(intipobj);
	var valid = validatePortRange("i_port", "Internal Port", check_empty);
	if (!valid) {
		if (iportobj.value.trim() == "") alertmsg += "Internal Port should not be empty\n";
		else alertmsg += "Internal Port is not valid\n";
	}
	
	if (alertmsg.trim().length == 0) return true;
	else {
		alert(alertmsg);
		return false;
	}
	  }catch(e)
	  {
		  alert(e);
	  }
}
function gotoportforwards(slnumber,version) {
	location.href = "portforward.jsp?slnumber="+slnumber+"&version="+version;
}

	  </script>
   </head>
   <body>
      <form action="savedetails.jsp?page=edit_portforward&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="return validateForwardEdit()">
         <br>
         <p align="center" id="forwardedit" class="style5">Port Forwards</p>
         <br>
         <table class="borderlesstab" id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="200px">Parameters</th>
                  <th width="200px">Configuration</th>
               </tr>
               <tr>
                  <td>Activation</td>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="activation" name="activation" style="vertical-align:middle" <%if(enabled){%> checked <%}%>><span class="slider round"></span></label></td>
               </tr>
               <tr>
                  <td>Instance Name</td>
                  <td><input type="text" class="text" id="instancename" name="instancename" value="<%=instancename%>" onmouseover="setTitle(this)" readonly=""></td>
               </tr>
               <tr>
                  <td>Protocol</td>
                  <td>
                     <select class="text" id="proto" name="proto">
                        <option value="tcp" <%if(protocol.contains("tcp")){%>selected<%}%>>TCP</option>
                        <option value="udp" <%if(protocol.contains("udp")){%>selected<%}%>>UDP</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Source Interface</td>
                  <td>
                     <select class="text" id="sinterface" name="sinterface">
                        <option value="lan" <%if(srcintf.equals("lan")){%>selected<%}%>>LAN</option>
                        <%
                        if(version.trim().startsWith(Symbols.WiZV2+Symbols.EL))
                        {%>
                        <option value="wan" <%if(srcintf.equals("wan")){%>selected<%}%>>WAN</option>
                        <%}%>
                        <option value="cellular" <%if(srcintf.equals("cellular") || srcintf.equals("")){%>selected<%}%>>Cellular</option>
                        <%if(enable.equals("1"))
            			{ %>
            			<option value="zt0" <%if(srcintf.equals("zt0")){%>selected<%}%>>ZeroTier</option>
                        <%}%>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Source IP Address</td>
                  <td><input type="text" class="text" id="sipaddress" name="sipaddress" maxlength="18" value="<%=srcip%>" placeholder="any" onkeypress="return avoidSpace(event)" onfocusout="validateIPOrNetworkPortAndTraffic('sipaddress',false,'Source IP Address')"></td>
               </tr>
               <tr>
                  <td>Source Port</td>
                  <td><input type="text" class="text" id="s_port" name="s_port" value="<%=srcport%>" placeholder="(1-65535)" min="1" max="65535" onkeypress="return avoidSpace(event)" onfocusout="validatePortRange('s_port','Source Port',false)"></td>
               </tr>
               <tr>
                  <td>External IP Address</td>
                  <td><input type="text" class="text" id="eipaddress" name="eipaddress" maxlength="18" value="<%=extip%>" placeholder="any" onkeypress="return avoidSpace(event)"onfocusout="validateIPOrNetworkPortAndTraffic('eipaddress',false,'External IP Address')"></td>
               </tr>
               <tr>
                  <td>External Port</td>
                  <td><input type="text" class="text" id="e_port" name="e_port" value="<%=extport%>" placeholder="(1-65535)" min="1" max="65535" onkeypress="return avoidSpace(event)" onfocusout="validatePortRange('e_port','External Port',true)"></td>
               </tr>
               <tr>
                  <td>Internal Interface</td>
                  <td>
                     <select class="text" id="int_interface" name="int_interface">
                        <option value="lan" <%if(destintf.equals("lan")){%>selected<%}%>>LAN</option>
                        <%if(version.trim().startsWith(Symbols.WiZV2+Symbols.EL))
                        {%>
                        <option value="wan" <%if(destintf.equals("wan")){%>selected<%}%>>WAN</option>
                      <%}%>
                        <option value="cellular" <%if(destintf.equals("cellular")){%>selected<%}%>>Cellular</option>
                     <%if(enable.equals("1"))
            			{ %>
            			<option value="zt0" <%if(destintf.equals("zt0")){%>selected<%}%>>ZeroTier</option>
                        <%}%>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Internal IP Address</td>
                  <td><input type="text" class="text" id="intipaddress" name="intipaddress" value="<%=desip%>" maxlength="15" onkeypress="return avoidSpace(event)" onfocusout="validateIPOnly('intipaddress',true,'Internal IP Address')"></td>
               </tr>
               <tr>
                  <td>Internal Port</td>
                  <td><input type="text" class="text" id="i_port" name="i_port" value="<%=desport%>" placeholder="(1-65535)" min="1" max="65535" onkeypress="return avoidSpace(event)" onfocusout="validatePortRange('i_port','Internal Port', true)"></td>
               </tr>
               <tr></tr>
            </tbody>
         </table>
         <div align="center"><input type="button" value="Back to Overview" name="back" style="display:inline block" class="button" onclick="gotoportforwards('<%=slnumber%>','<%=version%>')"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"></div>
      </form>
   </body>
</html>