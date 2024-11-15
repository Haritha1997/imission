<%@page import="java.util.ArrayList"%>
<%@page import="org.apache.commons.net.util.SubnetUtils"%>
<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.net.NetworkInterface"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>
 <%
   		String slnumber=request.getParameter("slnumber");
 		String version=request.getParameter("version");
		String errorstr = request.getParameter("error");
		String status = request.getParameter("status");
		 String name = request.getParameter("name")==null?"":request.getParameter("name");
		   JSONObject wizjsonnode = null;
		   JSONObject openvpnobj = null;
		   FileReader propsfr = null;
		   JSONObject pointtopointobj = null;
		   JSONArray peer_nwk=null;
		   BufferedReader jsonfile = null;  
		   String certificatedir=null;
		   String activation="";
		   String config_mode="";
		   String remaddr="";
		   String remport="1194";
		   String localport="1194";
		   String protocol="";
		   String ifconfig_local="";
		   String ifconfig_remote="";
		   String static_psk="";
		   String static_psk_algo="None";
		   String auth_algo="";
		   String ciphers="";
		   String compres="";
		   String com_algo="lzo";
		   String keep_alive_int="";
		   String keep_alive_to="";
		   ArrayList<String> pskfile_list = new ArrayList<String>();
		   String selpskfilename="";
		   File psk_dir = null;
		   File cert_dir = null;
		   File vpn_crt_dir= null;
		   if(slnumber != null && slnumber.trim().length() > 0)
		   {
			   Properties m2mprops = M2MProperties.getM2MProperties();
			   String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
			   jsonfile = new BufferedReader(new FileReader(new File(slnumpath+File.separator+"Config.json")));
			   certificatedir = m2mprops.getProperty("tlsconfigspath")+"/"+slnumber+"/WiZ_NG/Startup_Configurations/certificates";
			   StringBuilder jsonbuf = new StringBuilder("");
			   String jsonString="";
			   cert_dir = new File(certificatedir);
			   vpn_crt_dir = new File(certificatedir+"/openvpn");
			   psk_dir = new File(certificatedir+"/openvpn/psk");
			   if(!cert_dir.exists())
				   cert_dir.mkdir();
			   if(!vpn_crt_dir.exists())
				   vpn_crt_dir.mkdir();
			   if(!psk_dir.exists())
				   psk_dir.mkdir();
			   for(File file : psk_dir.listFiles())
			   {
				   if(file.isFile())
				   {
					   if(file.getName().endsWith(".key"))
				   			pskfile_list.add(file.getName());
				   }
			   }
			   try
			   {
					while((jsonString = jsonfile.readLine())!= null)
		   			jsonbuf.append( jsonString );
					wizjsonnode= JSONObject.fromObject(jsonbuf.toString());
					wizjsonnode= JSONObject.fromObject(jsonbuf.toString());
					openvpnobj = wizjsonnode.containsKey("openvpn")?wizjsonnode.getJSONObject("openvpn"):new JSONObject();
					pointtopointobj = openvpnobj.containsKey("openvpn:"+name)?openvpnobj.getJSONObject("openvpn:"+name):new JSONObject();
					peer_nwk=pointtopointobj.containsKey("route")?pointtopointobj.getJSONArray("route"):new JSONArray();
					activation=pointtopointobj.containsKey("enabled")?pointtopointobj.getString("enabled").equals("1")?"checked":"":"";
					config_mode= pointtopointobj.containsKey("configmode")?pointtopointobj.getString("configmode"):"Remote";
					if(config_mode.equals("remote"))
					{
					remaddr = pointtopointobj.containsKey("remote")?pointtopointobj.getString("remote").split(" ")[0]:"";
					if(remaddr.equals("@"))
						remaddr="";
					remport = pointtopointobj.containsKey("remote")?pointtopointobj.getString("remote").split(" ")[1]:"1194";
					}
					else
						localport = pointtopointobj.containsKey("port")?pointtopointobj.getString("port"):"1194";
					protocol = pointtopointobj.containsKey("proto")?pointtopointobj.getString("proto"):"udp";
					ifconfig_local = pointtopointobj.containsKey("ifconfig")?pointtopointobj.getString("ifconfig").split(" ")[0]:"";
					ifconfig_remote = pointtopointobj.containsKey("ifconfig")?pointtopointobj.getString("ifconfig").split(" ")[1]:"";
					if(pointtopointobj.containsKey("static_auth"))
					{
						static_psk="checked";
						static_psk_algo=pointtopointobj.getString("static_dir");
					}
					auth_algo=pointtopointobj.containsKey("auth")?pointtopointobj.getString("auth"):"SHA1";
					ciphers=pointtopointobj.containsKey("cipher")?pointtopointobj.getString("cipher"):"AES-128-CBC";
					if(pointtopointobj.containsKey("compress"))
					{
					compres="checked";
					com_algo=pointtopointobj.getString("compress");
					}
					keep_alive_int = pointtopointobj.containsKey("keepalive")?pointtopointobj.getString("keepalive").split(" ")[0]:"10";
					keep_alive_to = pointtopointobj.containsKey("keepalive")?pointtopointobj.getString("keepalive").split(" ")[1]:"60";
					selpskfilename=pointtopointobj.containsKey("secret")?pointtopointobj.getString("secret").split("/")[4]:"";
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
			   }
			   finally
			   {
				   if(propsfr != null)
					   propsfr.close();
				   
				   if(jsonfile != null)
					   jsonfile.close();
			   }
		   }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <link href="css/fontawesome.css" rel="stylesheet">
      <link href="css/solid.css" rel="stylesheet">
      <link href="css/v4-shims.css" rel="stylesheet">
      <link href="css/style.css" rel="stylesheet" type="text/css">
      <link rel="stylesheet" href="css/multiselect/bootstrap.min.css">
      <link rel="stylesheet" type="text/css" href="css/multiselect/bootstrap-multiselect.css">
      <link rel="stylesheet" href="css/openvpn.css">
      <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
	  <script type="text/javascript" src="js/common.js"></script>
      <script type="text/javascript" src="js/multiselect/jquery1.12.4.min.js"></script>
      <script type="text/javascript" src="js/multiselect/bootstrap3.3.6.min.js"></script>
      <script type="text/javascript" src="js/multiselect/bootstrap-multiselect.js"></script>
      <script type="text/javascript" src="js/client-vpn.js"></script>
</head>
<style>
    .hiderow
    {
        display: none;
    }
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
    a:hover { 
        color: black; text-decoration: none;
     }
    .borderlesstab th:nth-child(even),.borderlesstab td:nth-child(even)
    {
    /* width: 400px; */
    }
    #hmacauth
    {
        margin-top: 5px;
        margin-bottom: 6px;
    }
    #compress,#staticpsk
    {
        margin-top: 5px;
        margin-bottom: 6px;
    }
</style>
<script type="text/javascript">
function validatePoint() {
    var altmsg = "";
    var ipaddr = document.getElementById("remotelocal").value.trim();
    var rmtaddr = document.getElementById("remoteaddress").value.trim();
    var config = document.getElementById("ifconfig").value.trim();
    var config1 = document.getElementById("ifconfig1").value.trim();
    var rmtport = document.getElementById("remoteport");
    var loclport = document.getElementById("localport");
    if (ipaddr == "Remote") {
        var valid = validatenameandip('remoteaddress', true, 'Remote Address');
        if (!valid) {
            if (rmtaddr == "") altmsg += "Remote Address should not be empty\n";
            else altmsg += "Remote Address is not valid\n";
        }
        valid = validateRange('remoteport', true, 'Remote Port');
        if (!valid) {
            if (rmtport.value.trim() == "") altmsg += "Remote port should not be empty\n";
            else altmsg += "Remote port is not valid\n";
        }
    }
    if (ipaddr == "Local") {
        valid = validateRange('localport', true, 'Local Port');
        if (!valid) {
            if (loclport.value.trim() == "") altmsg += "Local port should not be empty\n";
            else altmsg += "Local port is not valid\n";
        }
    }
    var valid = validatenameandip('ifconfig', true, 'Ifconfig');
    if (!valid) {
        if (config == "") altmsg += "Ifconfig should not be empty\n";
        else altmsg += "Ifconfig is not valid\n";
    }
    var valid = validatenameandip('ifconfig1', true, 'Ifconfig');
    if (!valid) {
        if (config1 == "") altmsg += "Ifconfig second should not be empty\n";
        else altmsg += "Ifconfig second is not valid\n";
    }
    if (rmtaddr == config && rmtaddr == config1 && config == config1 && rmtaddr != "" && config != "" && config1 != "") {
        altmsg += "Remote addresses " + rmtaddr + " and Ifconfig " + config + "and Ifconfig " + config1 + "  should not be the same\n";
    } else if (rmtaddr == config && rmtaddr != "" && config != "") {
        altmsg += "Remote addresses " + rmtaddr + " and Ifconfig " + config + " should not be the same\n";
    } else if (rmtaddr == config1 && rmtaddr != "" && config1 != "") {
        altmsg += altmsg += "Remote addresses " + rmtaddr + " and Ifconfig " + config1 + " should not be the same\n";
    } else if (config == config1 && config != "" && config1 != "") {
        altmsg += "Ifconfig addresses " + config + " and Ifconfig " + config1 + " should not be the same\n";
    }
    var actid = document.getElementById("mainact");
    if (actid.checked == true) {
        var pskobj = document.getElementById("staticpsk");
        var seletpsk = document.getElementById("pasktabselfile");
        if (pskobj.checked == true) {
            if (seletpsk.value.trim() == '') {
                altmsg += "please select the file Pre-Shared Key\n";
                seletpsk.style.outline = "thin solid red";
            } else seletpsk.style.outline = "initial";
        } else {
            if (seletpsk.value.trim() != '') {
                altmsg += "please enable the Pre-Shared Key\n";
                seletpsk.style.outline = "thin solid red";
            } else seletpsk.style.outline = "initial";
        }
    }
    var alivintmobj = document.getElementById("keepalive");
    var alivtimeobj = document.getElementById("timeout");
    if ((alivintmobj.value.trim() == '') && (!alivtimeobj.value.trim() == '')) {
        altmsg += "Alive Time Interval should not be empty \n";
        alivintmobj.style.outline = "thin solid red";
    } else alivintmobj.style.outline = "initial";
    if ((alivtimeobj.value.trim() == '') && (!alivintmobj.value.trim() == '')) {
        altmsg += "Alive Time Out should not be empty\n";
        alivtimeobj.style.outline = "thin solid red";
    } else alivtimeobj.style.outline = "initial";
    table = document.getElementById("pointtable");
    rowcnt = table.rows;
    for (var i = 13; i < rowcnt.length; i++) {
        networkobj = rowcnt[i].cells[1].childNodes[0];
        networkobj_i = networkobj.value.trim();
        subnetobj = rowcnt[i].cells[2].childNodes[0];
        subnetobj_i = subnetobj.value.trim();
        var valid1 = validateIP(networkobj.id, true, "Network");
        var valid2 = validateSubnetMask(subnetobj.id, true, "Subnet Mask");
        if (valid1) {
            if (networkobj_i != "" && subnetobj_i == "") altmsg += "Subnet Mask " + (i - 12) + " should not be empty\n";
        } else {
            if (networkobj_i != "") altmsg += "Network " + (i - 12) + " Invalid\n";
        }
        if (valid2) {
            if (networkobj_i == "" && subnetobj_i != "") altmsg += "Network " + (i - 12) + " should not be empty\n";
        } else {
            if (subnetobj_i != "") altmsg += "Subnet Mask " + (i - 12) + " Invalid\n";
        }
        if (!valid1 && !valid2) {
            if (networkobj_i == "" && subnetobj_i == "") {
                networkobj.style.outline = "none";
                subnetobj.style.outline = "none";
            }
        }
        if (rowcnt.length > 14 && networkobj_i == "" && subnetobj_i == "") {
            altmsg += "Please remove empty Peer Network\n";
            break;
        }
        if (valid1) {
            network = getNetwork(networkobj_i, subnetobj_i);
            if (networkobj_i != network) {
                networkobj.title = "Network in the row " + (i - 12) + " should be Network\n";
                altmsg += networkobj.title;
                networkobj.style.outline = "thin solid red";
            }
        }
        for (var j = i + 1; j < rowcnt.length; j++) {
            networkobj_j = rowcnt[j].cells[1].childNodes[0];
            networkob_j = networkobj_j.value.trim();
            subnetobj_j = rowcnt[j].cells[2].childNodes[0];
            subnetob_j = subnetobj_j.value.trim();
            if (networkobj_i == networkob_j && i != j && subnetobj_i == subnetob_j && networkobj_i != "" && networkob_j != "" && subnetobj_i != "" && subnetob_j != "") {
                if (!altmsg.includes(networkobj_i + " address is already exists")) altmsg += networkobj_i + " address is already exists\n";
                networkobj.style.outline = "thin solid red";
                break;
            } else if ((i != j) && (isNetworkOVerlaped(networkobj_i, subnetobj_i, networkob_j, subnetob_j)) && networkobj_i != "" && networkob_j != "" && subnetobj_i != "" && subnetob_j != "") {
                if (!((altmsg.includes(networkobj_i + " and " + subnetobj_i + " is overlaps with the networks " + networkob_j + " and " + subnetob_j)) || (altmsg.includes(networkob_j + " and " + subnetob_j + " is overlaps with the networks" + networkobj_i + " and " + subnetobj_i)))) altmsg += networkobj_i + " and " + subnetobj_i + " is overlaps with the networks " + networkob_j + " and " + subnetob_j + "\n";
                break;
            }
        }
    }
    if (altmsg.trim().length == 0) return "";
    else {
        alert(altmsg);
        return false;
    }
}
</script>
<body>
    <form  action="savedetails.jsp?page=pointtopoint&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="return validatePoint()">
          <p class="style1" align="center">Point To Point Configuration</p>
          <input type="hidden" id="slnumber" value="<%=slnumber %>" />
        <input type="hidden" id="version" value="<%=version %>" />
         <div id="Client" style="margin: 0px; display: inline;" align="center">
            <input type="hidden" name="addpointtopoint" id="addpointtopoint" value="1">
            <table class="borderlesstab" style="width:800px;margin-bottom: 0;" id="pointtable" align="center">
               <tbody>
                  <tr>
                     <th colspan="4">
                        <div align="center"><strong>Configuration parameter for each instance</strong></div>
                     </th>
                  </tr>
                  <tr>
                     <td>Activation</td>
                     <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="mainact" id="mainact" <%=activation%> style="vertical-align:middle"><span class="slider round"></span></label></td>
                     <td width="200px">Instance Name</td>
                     <td><input type="text" name="inst_name" id="inst_name" class="text" value="<%=name %>" readonly=""></td>
                  </tr>
                  <tr>
                     <td>Config Mode</td>
                     <td>
                        <select name="remotelocal" id="remotelocal" class="text" onclick="remoteandlocal()">
                           <option value="Remote" <%if (config_mode.equals("remote")) {%>selected <%}%>>Remote</option>
                           <option value="Local" <%if (config_mode.equals("local")) {%>selected <%}%>>Local</option>
                        </select>
                     </td>
                     <td></td>
                     <td></td>
                  </tr>
                  <tr id="remoterow">
                     <td>Remote Address</td>
                     <td><input type="text" class="text" name="remoteaddress" id="remoteaddress" placeholder="eg: 192.168.1.10" value="<%=remaddr%>" onfocusout="validatenameandip('remoteaddress',true,'Remote Address')" onkeypress="return avoidSpace(event)"></td>
                     <td>Remote Port</td>
                     <td><input type="number" class="text" name="remoteport" id="remoteport" placeholder="(1-65535)" value="<%=remport%>" min="1" max="65535" onkeypress="return avoidSpace(event)" onfocusout="validateRange('remoteport',true,'Remote Port')"></td>
                  </tr>
                  <tr id="localrow" style="display: none;">
                     <td>Local Port</td>
                     <td><input type="number" class="text" name="localport" id="localport" placeholder="(1-65535)" value="<%=localport%>" min="1" max="65535" onkeypress="return avoidSpace(event)" onfocusout="validateRange('localport',true,'Local Port')"></td>
                     <td></td>
                     <td></td>
                  </tr>
                  <tr>
                     <td>Protocol</td>
                     <td><input type="text" id="protocol" name="protocol" class="text" value="<%=protocol%>" readonly=""></td>
                     <td></td>
                     <td></td>
                  </tr>
                  <tr>
                     <td></td>
                     <td>Local</td>
                     <td>Remote</td>
                     <td></td>
                  </tr>
                  <tr>
                     <td>Ifconfig</td>
                     <td><input type="text" class="text" name="ifconfig" id="ifconfig" value="<%=ifconfig_local%>" placeholder="eg: 192.168.1.10" onfocusout="validatenameandip('ifconfig',true,'Ifconfig')" onkeypress="return avoidSpace(event)"></td>
                     <td><input type="text" class="text" name="ifconfig1" id="ifconfig1" value="<%=ifconfig_remote%>" placeholder="eg: 192.168.1.11" onfocusout="validatenameandip('ifconfig1',true,'Ifconfig1')" onkeypress="return avoidSpace(event)"></td>
                     <td></td>
                  </tr>
                  <tr>
                     <td>Static (PSK) Authentication</td>
                     <td><input type="checkbox" name="static_auth" id="staticpsk" onclick="pskstaticshow()" <%=static_psk%>></td>
                     <td><label id="pskdir" style="display: none;">Direction</label></td>
                     <td>
                        <select name="static_dir" id="pskcb" class="text" style="display: none;">
                           <option value="None" <%if (static_psk_algo.equals("None")) {%>selected <%}%>>None</option>
                           <option value="0" <%if (static_psk_algo.equals("0")) {%>selected <%}%>>Outgoing</option>
                           <option value="1" <%if (static_psk_algo.equals("1")) {%>selected <%}%>>Incoming</option>
                        </select>
                     </td>
                  </tr>
                  <tr>
                     <td>Authentication Algorithm</td>
                     <td>
                        <select name="hmac_algor" id="hmacalgor" class="text">
                           <option value="SHA1" <%if (auth_algo.equals("SHA1")) {%>selected <%}%>>SHA1</option>
                           <option value="SHA256" <%if (auth_algo.equals("SHA256")) {%>selected <%}%>>SHA256</option>
                           <option value="SHA384" <%if (auth_algo.equals("SHA384")) {%>selected <%}%>>SHA384</option>
                           <option value="SHA512" <%if (auth_algo.equals("SHA512")) {%>selected <%}%>>SHA512</option>
                        </select>
                     </td>
                     <td>Ciphers</td>
                     <td>
                        <select name="cipher" id="cipher" class="text">
                           <option value="AES-128-CBC" <%if (ciphers.equals("AES-128-CBC")) {%>selected <%}%>>AES-128-CBC</option>
                           <option value="AES-192-CBC" <%if (ciphers.equals("AES-192-CBC")) {%>selected <%}%>>AES-192-CBC</option>
                           <option value="AES-256-CBC" <%if (ciphers.equals("AES-256-CBC")) {%>selected <%}%>>AES-256-CBC</option>
                        </select>
                     </td>
                  </tr>
                  <tr>
                     <td>Compress</td>
                     <td><input type="checkbox" name="compress" id="compress" <%=compres%> onclick="compressshow()"></td>
                     <td><label id="algorow" style="display: none;">Algorithm</label></td>
                     <td>
                        <select name="algorithm" id="algorithm" class="text" style="display: none;">
                           <option value="lzo" <%if (com_algo.equals("lzo")) {%>selected <%}%>>LZO</option>
                           <option value="lz4" <%if (com_algo.equals("lz4")) {%>selected <%}%>>LZ4</option>
                           <option value="lz4-v2" <%if (com_algo.equals("lz4-v2")) {%>selected <%}%>>LZ4-V2</option>
                        </select>
                     </td>
                  </tr>
                  <tr>
                     <td>Keep Alive Interval(secs)</td>
                     <td><input type="number" name="keepalive" id="keepalive" class="text" min="1" max="60" value="<%=keep_alive_int%>" onkeypress="return avoidSpace(event)"></td>
                     <td>Keep Alive Timeout </td>
                     <td><input type="number" name="timeout" id="timeout" class="text" min="60" max="180" value="<%=keep_alive_to%>" onkeypress="return avoidSpace(event)"></td>
                  </tr>
                  <tr>
                     <td></td>
                     <td>Network</td>
                     <td>Subnet Mask</td>
                     <td></td>
                     <%
				if (peer_nwk.size() > 0) {
					for (int i = 0; i < peer_nwk.size(); i++) {
						String vals = peer_nwk.getString(i);
						String row = i + 1 + "";
						String valsarr[] = vals.split(" ");
				%>
					<script>	
							addpeerRoutRow(netlistrow);
							fillpeerRoutRow(<%=(i + 1)%>,'<%=valsarr[0]%>','<%=valsarr[1]%>');
					 </script>
				<%
				}
				}
				else
				{%>
					<script>	
						 addpeerRoutRow(netlistrow);
					 </script>
				<%}%>
                  </tr>
               </tbody>
            </table>
            <input type="text" id="pasktabopvpconf" name="pasktabopvpconf" value="1" hidden="">
            <table class="borderlesstab" style="width:800px;margin-bottom:0px;" align="center" id="pasktab" name="pasktab">
               <tbody id="file-table-body-psk" name="file-table-body-psk" colspan="5">
                  <tr>
                     <th colspan="5">
                        <div align="center"><strong>Pre-Shared Key</strong></div>
                     </th>
                  </tr>
                  <tr id="selfilrow">
                     <td colspan="5"><input type="button" name="pasktabchosefileid" id="pasktabchosefileid" value="Choose File" onclick="toggleTableRows('pasktab')"><label style="padding-right:20px;margin-left: 100PX;">Selected file : </label><input type="text" name="pasktabselfile" id="pasktabselfile" value="<%=selpskfilename%>"class="text" readonly=""></td>
                  </tr>
                  <tr class="hiderow" style="display: none;">
                     <td colspan="2"><input type="file" id="pasktabfile" accept=".key" name="pasktabfile" onchange="setSelectedFileName(event,'pasktabfname','pasktab')"><label for="pasktabfile" id="file-label-psk" name="file-label-psk">Browse</label></td>
                     <td colspan="1"><input type="text" class="text" id="pasktabfname" name="pasktabfname" placeholder="Browse the File" readonly=""></td>
                     <td colspan="1">
                        <input type="button" id="upbtn-psk" name="upbtn-psk" value="Upload" onclick="configUploadFile('pasktabfile','pskpBar','pasktabfname','pasktab','inst_name','<%=certificatedir%>','psk')">
                        <p id="pskpBar"></p>
                        <div id="process" hidden=""><input type="hidden" id="pskfileName" name="pskfileName" value=""></div>
                     </td>
                     <td colspan="1"><input type="button" onclick="cancelFileSelection('pasktabfname')" id="canbtn-psk" name="canbtn-psk" value="Cancel"></td>
                  </tr>
                  <tr class="hiderow hiderowcol" style="display: none;">
                     <td colspan="2">FileName</td>
                     <td>Status</td>
                     <td colspan="2">Action</td>
                  </tr>
               </tbody>
            </table>
         </div>
         <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"></div>
      </form>
       <%
    String delfile="";
    for(String pskfilename :pskfile_list)
    {  
    	delfile=certificatedir+"/openvpn/psk/"+pskfilename;
    	%>
    	<script>
    	addRow('pasktab','pasktabopvpconf','<%=delfile%>','<%=slnumber%>','<%=version%>','pointtopoint.jsp','<%=name%>','secret');
    	fillrow('pasktab','<%=pskfilename%>');
    	</script>
    <%}
    if(status != null)
    {
    	if(status.equals("success"))
    	{%>
    		<script type="text/javascript">
    		alert("File Deleted.")
    		</script>
    	<%} else if(status.equals("failed")) {%>
    		<script type="text/javascript">
    		alert("Delete Failed.")
    		</script>
    	<%}
    	 else if(status != ""){%>
    		<script type="text/javascript">
    			alert('<%=status%>');
    		</script>
   		<% }
    }
    %>
</body>
<script>
compressshow();
remoteandlocal();
pskstaticshow();
setStatus('pasktab')
</script>
</html>