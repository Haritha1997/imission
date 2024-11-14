<%@page import="org.hibernate.dialect.function.AvgWithArgumentCastFunction"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="org.apache.commons.net.util.SubnetUtils"%>
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
		   JSONObject vpnclientobj = null;
		   BufferedReader jsonfile = null;  
		   String certificatedir=null;
		   String activation="";
		   String remaddr="";
		   String remport="";
		   String protocol="";
		   String cn="";
		   String tlsauth="";
		   String hmac_auth="";
		   String user_auth="";
		   String hmac_direction="";
		   String psk_direction="";
		   String hmac_algo="";
		   JSONArray tls_ciphers=null;
		   String ciphers="";
		   String compres="";
		   String com_algo="lzo";
		   String tls_rgen_int="";
		   String keep_alive_int="";
		   String keep_alive_to="";
		   ArrayList<String> cafile_list = new ArrayList<String>();
		   ArrayList<String> client_crt_list = new ArrayList<String>();
		   ArrayList<String> client_key_list = new ArrayList<String>();
		   ArrayList<String> hmac_list = new ArrayList<String>();
		   ArrayList<String> user_list = new ArrayList<String>();
		   String selcafilename="";
		   String selcrtfilename="";
		   String selkeyfilename="";
		   String selhmacfilename="";
		   String seluserfilename="";
		   String  tls_cipher_opt="";
		   File cert_dir = null;
		   File vpn_crt_dir= null;
		   File client_dir = null;
		   File hmac_dir= null ;
		   File user_dir = null;
		   if(slnumber != null && slnumber.trim().length() > 0)
		   {
			   Properties m2mprops = M2MProperties.getM2MProperties();
			   String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
			   String targetfilename = m2mprops.getProperty("targetfilename")==null?"":m2mprops.getProperty("targetfilename");
			   certificatedir = m2mprops.getProperty("tlsconfigspath")+"/"+slnumber+"/WiZ_NG/Startup_Configurations/certificates";
			   jsonfile=new BufferedReader(new FileReader(new File(slnumpath+File.separator+"Config.json")));
			   StringBuilder jsonbuf = new StringBuilder("");
			   String jsonString="";
			   cert_dir = new File(certificatedir);
			   vpn_crt_dir = new File(certificatedir+"/openvpn");
			   client_dir= new File(certificatedir+"/openvpn/client");
			   hmac_dir = new File(certificatedir+"/openvpn/hmac");
			   user_dir = new File(certificatedir+"/openvpn/user");
			   if(!cert_dir.exists())
				   cert_dir.mkdir();
			   if(!vpn_crt_dir.exists())
				   vpn_crt_dir.mkdir();
			   if(!client_dir.exists())
				   client_dir.mkdir();
			   if(!hmac_dir.exists())
				   hmac_dir.mkdir();
			   if(!user_dir.exists())
				   user_dir.mkdir();
			   for(File file : vpn_crt_dir.listFiles())
			   {
				   if(file.isFile())
				   {
					   if(file.getName().endsWith(".crt"))
				   			cafile_list.add(file.getName());
				   }
			   }
			   for(File file : client_dir.listFiles())
			   {
				   if(file.isFile())
				   {
					   if(file.getName().endsWith(".crt"))
						   client_crt_list.add(file.getName());
					   if(file.getName().endsWith(".key"))
						   client_key_list.add(file.getName());
				   }
			   }   
			   for(File file : hmac_dir.listFiles())
			   {
				   if(file.isFile())
				   {
					   if(file.getName().endsWith(".key"))
						   hmac_list.add(file.getName());
				   }
			   } 
			   for(File file : user_dir.listFiles())
			   {
				   if(file.isFile())
				   {
					   if(file.getName().endsWith(".auth"))
						   user_list.add(file.getName());
				   }
			   }
			   try
			   {
					while((jsonString = jsonfile.readLine())!= null)
		   			jsonbuf.append( jsonString );
					wizjsonnode= JSONObject.fromObject(jsonbuf.toString());
					openvpnobj = wizjsonnode.containsKey("openvpn")?wizjsonnode.getJSONObject("openvpn"):new JSONObject();
					vpnclientobj = openvpnobj.containsKey("openvpn:"+name)?openvpnobj.getJSONObject("openvpn:"+name):new JSONObject();
					activation=vpnclientobj.containsKey("enabled")?vpnclientobj.getString("enabled").equals("1")?"checked":"":"";
					remaddr = vpnclientobj.containsKey("remote")?vpnclientobj.getString("remote").split(" ")[0]:"";
					if(remaddr.equals("@"))
						remaddr="";
					remport = vpnclientobj.containsKey("remote")?vpnclientobj.getString("remote").split(" ")[1]:"1194";
					protocol = vpnclientobj.containsKey("proto")?vpnclientobj.getString("proto"):"udp";
					cn = vpnclientobj.containsKey("verify_x509_name")?vpnclientobj.getString("verify_x509_name").split(" ")[0]:"";
					tlsauth = vpnclientobj.containsKey("tls_client")?vpnclientobj.getString("tls_client").equals("1")?"checked":"":"";
					hmac_auth = vpnclientobj.containsKey("hmac_auth")?vpnclientobj.getString("hmac_auth").equals("1")?"checked":"":"";
					user_auth = vpnclientobj.containsKey("user_auth")?vpnclientobj.getString("user_auth").equals("1")?"checked":"":"";
					hmac_direction=vpnclientobj.containsKey("hmac_dir")?vpnclientobj.getString("hmac_dir"):"";
					psk_direction=vpnclientobj.containsKey("hmac_dir")?vpnclientobj.getString("hmac_dir"):"";
					
					hmac_algo=vpnclientobj.containsKey("auth")?vpnclientobj.getString("auth"):"SHA256";
					tls_ciphers=vpnclientobj.containsKey("tls_cipher")?vpnclientobj.getJSONArray("tls_cipher"):null;
					if(tls_ciphers==null)
					{
						tls_ciphers = new JSONArray();
						tls_ciphers.add("TLS-ECDHE-ECDSA-WITH-CHACHA20-POLY1305-SHA256");
						tls_ciphers.add("TLS-ECDHE-ECDSA-WITH-AES-256-GCM-SHA384");
						tls_ciphers.add("TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256");
					}
					ciphers=vpnclientobj.containsKey("cipher")?vpnclientobj.getString("cipher"):"AES-128-CBC";
					if(vpnclientobj.containsKey("compress"))
						{
						compres="checked";
						com_algo=vpnclientobj.getString("compress");
						} 
					if(vpnclientobj.isEmpty())
						compres="checked";
					tls_rgen_int=vpnclientobj.containsKey("reneg_sec")?vpnclientobj.getString("reneg_sec"):"3600";
					keep_alive_int = vpnclientobj.containsKey("keepalive")?vpnclientobj.getString("keepalive").split(" ")[0]:"10";
					keep_alive_to = vpnclientobj.containsKey("keepalive")?vpnclientobj.getString("keepalive").split(" ")[1]:"60";
					selcafilename=vpnclientobj.containsKey("ca")?vpnclientobj.getString("ca").split("/")[3]:"";
					selcrtfilename=vpnclientobj.containsKey("cert")?vpnclientobj.getString("cert").split("/")[4]:"";
					selkeyfilename=vpnclientobj.containsKey("key")?vpnclientobj.getString("key").split("/")[4]:"";
					selhmacfilename=vpnclientobj.containsKey("tls_auth")?vpnclientobj.getString("tls_auth").split("/")[4]:"";
					seluserfilename=vpnclientobj.containsKey("auth_user_pass")?vpnclientobj.getString("auth_user_pass").split("/")[4]:"";
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
    <link href="css/fontawesome.css" rel="stylesheet">
      <link href="css/solid.css" rel="stylesheet">
      <link href="css/v4-shims.css" rel="stylesheet">
      <link href="css/style.css" rel="stylesheet" type="text/css">
      <!-- <link rel="stylesheet" type="text/css" href="css/style.css"> -->
      <link rel="stylesheet" href="css/multiselect/bootstrap.min.css">
      <link rel="stylesheet" type="text/css" href="css/multiselect/bootstrap-multiselect.css">
      <link rel="stylesheet" href="css/openvpn.css">
      <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
      <script type="text/javascript" src="js/multiselect/jquery1.12.4.min.js"></script>
      <script type="text/javascript" src="js/multiselect/bootstrap3.3.6.min.js"></script>
      <script type="text/javascript" src="js/multiselect/bootstrap-multiselect.js"></script>
      <script type="text/javascript" src="js/client-vpn.js"></script>
        <script type="text/javascript" src="js/common.js"></script>
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
function checkAlphaNUmeric(id)
{
   var val = document.getElementById(id).value.trim();
   if(!isValidAlphaNumberic(id) && val != "")
   {
       alert("Please Use Only AlphaNumeric");
       return;
   }
}

</script>
<body>
    <form action="savedetails.jsp?page=clientvpn&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="return validateClient()">
        <p class="style1" align="center">Client Instance Parameters</p>
        <input type="hidden" id="slnumber" value="<%=slnumber %>" />
        <input type="hidden" id="version" value="<%=version %>" />
        <div id="Client" style="margin: 0px; display: inline;" align="center">
           <table class="borderlesstab" style="width:800px;margin-bottom: 0;" id="clienttable" align="center">
              <tbody>
                <tr>
                    <th colspan="4">
                       <div align="center"><strong>Configuration parameter for each instance</strong></div>
                    </th>
                </tr>
                <tr>                    
                    <td>Activation</td>
                    <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="mainact"  id="mainact" <%=activation%> style="vertical-align:middle"><span class="slider round"></span></label></td>
                    <td width="200px">Instance Name</td>
                    <td><input type="text" name="name" id="name" class="text" value="<%=name%>" readonly></td>
                </tr>
                <tr>
                    <td>Remote Address</td>
                    <td>
                       <input type="text" class="text" name="remoteaddress" id="remoteaddress" value="<%=remaddr%>" placeholder="eg: 192.168.1.10" onkeypress="return avoidSpace(event)&& avoidEnter(event)" onfocusout="validatedualIP('remoteaddress',true,'Remote Address','true')">
                    </td>
                    <td>Remote Port</td>
                    <td><input type="number" class="text" name="remoteport" id="remoteport" placeholder="(1-65535)" value="<%=remport%>" min="1" max="65535" onkeypress="return avoidSpace(event)" onfocusout="validateRange('remoteport',true,'Remote Port')"></td>                    
                </tr>
                <tr>
                    <td>Protocol</td>
                    <td><select name="protocol" id="protocol" class="text" required>
                       <option value="udp" <%if (protocol.equals("udp")) {%>selected <%}%>>udp</option>
                       <option value="tcp" <%if (protocol.equals("tcp")) {%>selected <%}%>>tcp</option>
                    </select></td>
                    <td>Common Name (CN)</td>
                    <td><input type="text" class="text" name="commonname" id="commonname" value="<%=cn%>" maxlength="40" onmouseover="setTitle(this)" onkeypress="return avoidSpace(event)&& avoidEnter(event)" onfocusout="checkAlphaNUmeric('commonname')"></td>   
                </tr>
                <tr>
                    <td>TLS Authentication</td>
                    <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="tlsactivation" id="tlsactivation" style="vertical-align:middle" <%=tlsauth%> onclick="tlsact()"><span class="slider round"></span></label></td>
                    <td id="addhmacauth">Additional HMAC Authentication</td>
                    <td colspan="3">
                        <label class="switch" id="hmacact" style="vertical-align:middle"><input type="checkbox" name="hmacauth" id="hmacauth" <%=hmac_auth%> style="vertical-align:middle"><span class="slider round"></span></label>
                       <!-- <input type="checkbox" name="hmacauth" id="hmacauth" onclick="directionshow()"> -->
                    </td>
                </tr>
                <tr>
                    <td>User_Pass Authentication</td>
                    <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="userpassactivation" id="userpassactivation" <%=user_auth%> style="vertical-align:middle"><span class="slider round"></span></label></td>
                    <td></td>
                    <td></td>
					 </tr>
               <%--  <tr>
                    <td>Additional HMAC Authentication</td>
                    <td>
                       <input type="checkbox" name="hmacauth" id="hmacauth" <% %>onclick="directionshow()">
                    </td>
                    <td><label id = 'dirlbl'>Direction</td>
                    <td>
                       <select name="dircb" id="dircb" class="text">
                          <option value="Outgoing" selected="">Outgoing</option>
                          <option value="Incoming">Incoming</option>
                          <option value="Both">Both</option>
                       </select>
                    </td>
                </tr>
                <tr>
                    <td>Static (PSK) Authentication</td>
                    <td>
                       <input type="checkbox" name="staticpsk" id="staticpsk" onclick="pskstaticshow()">
                    </td>
                    <td><label id='pskdir'>Direction</td>
                    <td>
                       <select name="pskcb" id="pskcb" class="text">
                          <option value="Outgoing" selected="">Outgoing</option>
                          <option value="Incoming">Incoming</option>
                          <option value="Both">Both</option>
                       </select>
                    </td>
                </tr> --%>
                <tr>
                    <td>HMAC Authentication Algorithm</td>
                    <td><select name="hmacalgor" id="hmacalgor" class="text">
                       <option value="SHA1" <%if(hmac_algo.equals("SHA1")) {%>selected <%}%>>SHA1</option>
                       <option value="SHA256" <%if(hmac_algo.equals("SHA256")) {%>selected <%}%>>SHA256</option>
                       <option value="SHA384" <%if(hmac_algo.equals("SHA384")) {%>selected <%}%>>SHA384</option>
                       <option value="SHA512" <%if(hmac_algo.equals("SHA512")) {%>selected <%}%>>SHA512</option>
                    </select></td>
                    <td>TLS Ciphers</td>
                    <td><select  id="proto" name="proto" multiple="multiple" style="display: none;">
                       <option value="TLS-ECDHE-ECDSA-WITH-CHACHA20-POLY1305-SHA256" <%if(tls_ciphers.contains("TLS-ECDHE-ECDSA-WITH-CHACHA20-POLY1305-SHA256")){%>selected<%}%>>TLS_CHACHA20_POLY1305_SHA256</option>
                       <option value="TLS-ECDHE-ECDSA-WITH-AES-256-GCM-SHA384" <%if (tls_ciphers.contains("TLS-ECDHE-ECDSA-WITH-AES-256-GCM-SHA384")) {%>selected <%}%>>TLS_AES_256_GCM_SHA384</option>
                       <option value="TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256"  <%if (tls_ciphers.contains("TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256")) {%>selected <%}%>>TLS_AES_128_GCM_SHA256</option>
                    </select></td>
                </tr>
                <tr>
                   <td>Ciphers</td>
                   <td><select name="cipher" id="cipher" class="text">
                       <option value="AES-128-CBC" <%if (ciphers.equals("AES-128-CBC")) {%>selected <%}%>>AES-128-CBC</option>
                       <option value="AES-128-CFB" <%if (ciphers.equals("AES-128-CFB")) {%>selected <%}%>>AES-128-CFB  </option>
                       <option value="AES-128-CFB1" <%if (ciphers.equals("AES-128-CFB1")) {%>selected <%}%>>AES-128-CFB1</option>
                       <option value="AES-128-CFB8" <%if (ciphers.equals("AES-128-CFB8")) {%>selected <%}%>>AES-128-CFB8</option>
                       <option value="AES-128-GCM" <%if (ciphers.equals("AES-128-GCM")) {%>selected <%}%>>AES-128-GCM</option>
                       <option value="AES-128-OFB" <%if (ciphers.equals("AES-128-OFB")) {%>selected <%}%>>AES-128-OFB</option>
                       <option value="AES-192-CBC" <%if (ciphers.equals("AES-192-CBC")) {%>selected <%}%>>AES-192-CBC</option>
                       <option value="AES-192-CFB" <%if (ciphers.equals("AES-192-CFB")) {%>selected <%}%>>AES-192-CFB</option>
                       <option value="AES-192-CFB1" <%if (ciphers.equals("AES-192-CFB1")) {%>selected <%}%>>AES-192-CFB1</option>
                       <option value="AES-192-CFB8" <%if (ciphers.equals("AES-192-CFB8")) {%>selected <%}%>>AES-192-CFB8</option>
                       <option value="AES-192-GCM" <%if (ciphers.equals("AES-192-GCM")) {%>selected <%}%>>AES-192-GCM</option>
                       <option value="AES-192-OFB" <%if (ciphers.equals("AES-192-OFB")) {%>selected <%}%>>AES-192-OFB</option>
                       <option value="AES-256-CBC" <%if (ciphers.equals("AES-256-CBC")) {%>selected <%}%>>AES-256-CBC</option>
                       <option value="AES-256-CFB" <%if (ciphers.equals("AES-256-CFB")) {%>selected <%}%>>AES-256-CFB</option>
                       <option value="AES-256-CFB1" <%if (ciphers.equals("AES-256-CFB1")) {%>selected <%}%>>AES-256-CFB1</option>
                       <option value="AES-256-CFB8" <%if (ciphers.equals("AES-256-CFB8")) {%>selected <%}%>>AES-256-CFB8</option>
                       <option value="AES-256-GCM" <%if (ciphers.equals("AES-256-GCM")) {%>selected <%}%>>AES-256-GCM</option>
                       <option value="AES-256-OFB" <%if (ciphers.equals("AES-256-OFB")) {%>selected <%}%>>AES-256-OFB</option>
                   </select></td>
                   <td></td>
                   <td></td>
                </tr>
                <tr>
                    <td>Compress</td>
                    <td><input type="checkbox" name="compress" id="compress" <%=compres%> onclick="compressshow()"></td>
                    <td><label  id="algorow">Algorithm</td>
                    <td>
                        <select name="algorithm" id="algorithm" class="text">
                        <option value="LZO" <%if (com_algo.equals("lzo")) {%>selected <%}%>>LZO</option>
                        <option value="LZ4" <%if (com_algo.equals("lz4")) {%>selected <%}%>>LZ4</option>
                        <option value="LZ4-V2" <%if (com_algo.equals("lz4-v2")) {%>selected <%}%>>LZ4-V2</option>
                    </select></td>
                </tr>
                <tr>
                   <td>TLS key Renegotiation Interval (secs)</td>
                   <td><input type="number" name="tlskey" id="tlskey" class="text" min="1" max="604800" value="<%=tls_rgen_int%>" onkeypress="return avoidSpace(event)"></td>
                   <td></td>
                   <td></td>
                </tr>
                <tr>
                   <td>Keep Alive Interval(secs)</td>
                   <td><input type="number" name="keepalive" id="keepalive" class="text" min="1" max="60" value="<%=keep_alive_int%>" onkeypress="return avoidSpace(event)"></td>
                   <td>Keep Alive Timeout </td>
                   <td><input type="number" name="timeout" id="timeout" class="text" min="60" max="180" value="<%=keep_alive_to%>" onkeypress="return avoidSpace(event)"></td>
                  
                </tr> 
                <!-- <tr>
                   <td>Log Level</td>
                   <td><input type="number" name="logle" class="text" id="logle" min="1" max="11" value="3"></td>
                   <td></td>
                   <td></td>
                </tr> -->
              </tbody>
           </table>
           <input type="text" id="catabopvpconf" name="catabopvpconf" value="1" hidden="">
           <table class="borderlesstab" style="width:800px;margin-bottom:0px;" id="catab" name="catab" align="center">
               <tbody id="file-table-body" name="file-table-body" colspan="5">
                   <tr>
                       <th colspan="5">
                           <div align="center" colspan="5">
                               <strong>Certificate Authority(CA)</strong>
                           </div>
                       </th>
                   </tr>
                   <tr id="selfilrow">
                        <td colspan="5">
                            <input type="button" name="catabchosefileid" id="catabchosefileid" value="Choose File" onclick="toggleTableRows('catab')">
                            <label style="padding-right:20px;margin-left: 100px;">Selected file : </label>
                            <input type="text" name="catabselfile" id="catabselfile" value="<%=selcafilename%>" class="text" readonly>
                        </td>
                   </tr>                   
                    <tr class='hiderow'>
                        <td colspan="2">
                            <input type="file" accept=".crt" id="catabfile"  name="catabfile" onchange="setSelectedFileName(event,'catabfname','catab')">
                             <label for="catabfile" id="file-label" name="file-label">Browse</label>
                        </td>
                        <td colspan="1">
                            <input type="text" class="text" id="catabfname" name="catabfname" placeholder="Browse the File" readonly>
                            
                        </td>
                        <td colspan="1">
                            <input type="button" id="upbtn" name="upbtn" value="Upload" onclick="configUploadFile('catabfile','capBar','catabfname','catab','name','<%=certificatedir%>','ca')">
                            <p id="capBar"></p>
                            <div id="process" hidden="">
                                <input type="hidden" id="fileName" name="fileName" value="">
                            </div>
                        </td>
                        <td colspan="1">
                            <input type="button" onclick="cancelFileSelection('catabfname')" id="canbtn" name="canbtn" value="Cancel">
                        </td>
                    </tr>
                    <tr class='hiderow hiderowcol'>
                        <td colspan="2">FileName</td>
                        <td>Status</td>
                        <td colspan="2">Action</td>
                    </tr>
               </tbody>
           </table>
           <!-- cert file -->
           <input type="text" id="certtabopvpconf" name="certtabopvpconf" value="1" hidden="">
           <table class="borderlesstab" style="width:800px;margin-bottom:0px" id="certtab"  name="certtab">
               <tbody id="file-table-body-cert" name="file-table-body-cert" colspan="5">
                    <tr>
                       <th colspan="5">
                           <div align="center">
                               <strong>Certificate</strong>
                           </div>
                       </th>
                    </tr>
                    <tr id="selfilrow">
                        <td colspan="5">
                            <input type="button" name="certtabchosefileid" id="certtabchosefileid" value="Choose File" onclick="toggleTableRows('certtab')"> 
                            <label style="padding-right:20px;margin-left: 100px;">Selected file : </label>
                            <input type="text" name="certtabselfile" id="certtabselfile" value="<%=selcrtfilename%>" class="text" readonly>
                        </td>    
                    </tr>
                    <tr class='hiderow'>
                        <td colspan="2">
                            <input type="file" accept=".crt" id="certtabfile" name="certtabfile" onchange="setSelectedFileName(event,'certtabfname','certtab')">
                      <label for="certtabfile" id="file-label-cert" name="file-label-cert">Browse</label>
                        </td>
                        <td colspan="1">
                            <input type="text" class="text" id="certtabfname" name="certtabfname" placeholder="Browse the File" readonly>
                            
                        </td>
                        <td colspan="1">
                            <input type="button" id="upbtn-cert" name="upbtn-cert" value="Upload" onclick="configUploadFile('certtabfile','certpBar','certtabfname','certtab','name','<%=certificatedir%>','client')">
                            <p id="certpBar"></p>
                            <div id="certprocess" hidden="">
                                <input type="hidden" id="certfileName" name="certfileName" value="">
                            </div>
                        </td>
                        <td colspan="1">
                            <input type="button" onclick="cancelFileSelection('certtabfname')" id="canbtn-cert" name="canbtn-cert" value="Cancel">
                        </td>
                    </tr>
                    <tr class='hiderow hiderowcol'>
                        <td colspan="2">FileName</td>
                        <td colspan="1">Status</td>
                        <td colspan="2">Action</td>
                    </tr>
                    
               </tbody>
           </table>
           <!-- key file -->
           <input type="text" id="keytabopvpconf" name="keytabopvpconf" value="1" hidden="">
           <table class="borderlesstab" style="width:800px;;margin-bottom:0px;" id="keytab" name="keytab" align="center">
               <tbody id="file-table-body-key" name="file-table-body-key" colspan="5">
                    <tr>
                       <th colspan="5">
                           <div align="center">
                               <strong>Key </strong>
                           </div>
                       </th>
                    </tr>
                    <tr id="selfilrow">
                       <td colspan="5">
                            <input type="button" name="keytabchosefileid" id="keytabchosefileid" value="Choose File" onclick="toggleTableRows('keytab')">
                            <label style="padding-right:20px;margin-left: 100px;">Selected file : </label>
                            <input type="text" name="keytabselfile" id="keytabselfile" class="text" value="<%=selkeyfilename%>" readonly>
                        </td>
                    </tr>
                    <tr class='hiderow'>
                        <td colspan="2">
                            <input type="file" accept=".key" id="keytabfile" name="keytabfile" onchange="setSelectedFileName(event,'keytabfname','keytab')">
                             <label for="keytabfile" id="file-label-key" name="file-label-key">Browse</label>
 
                        </td>
                        <td colspan="1">
                            <input type="text" class="text" id="keytabfname" name="keytabfname" placeholder="Browse the File" readonly>
                            
                        </td>
                        <td colspan="1">
                            <input type="button" id="upbtn-key" name="upbtn-key" value="Upload" onclick="configUploadFile('keytabfile','keypBar','keytabfname','keytab','name','<%=certificatedir%>','client')">
                            <p id="keypBar"></p>
                            <div id="keyprocess" hidden="">
                                <input type="hidden" id="keyfileName" name="keyfileName" value="">
                            </div>
                        </td>
                        <td colspan="1">
                            <input type="button" onclick="cancelFileSelection('keytabfname')" id="canbtn-key" name="canbtn-key" value="Cancel">
                        </td>
                     </tr>
                    <tr class='hiderow hiderowcol'>
                        <td colspan="2">FileName</td>
                        <td colspan="1">Status</td>
                        <td colspan="2">Action</td>
                    </tr>
                </tbody>
           </table>
           <!-- hmac file -->
           <input type="text" id="hmactabopvpconf" name="hmactabopvpconf" value="1" hidden="">
           <table class="borderlesstab" style="width:800px;;margin-bottom:0px;" id="hmactab" name="hmactab" align="center">
               <tbody id="file-table-body-hmac" name="file-table-body-hmac" colspan="5">
                    <tr>
                       <th colspan="5">
                           <div align="center">
                               <strong>HMAC Secret</strong>
                           </div>
                       </th>
                    </tr>
                    <tr>
                       <td colspan="5">
                            <input type="button" name="hmactabchosefileid" id="hmactabchosefileid" value="Choose File" onclick="toggleTableRows('hmactab')">
                            <label style="padding-right:20px;margin-left: 100px;">Selected file : </label>
                            <input type="text" name="hmactabselfile" id="hmactabselfile" value="<%=selhmacfilename%>" class="text" readonly>
                        </td>
                    </tr>
                    <tr class='hiderow'>
                        <td colspan="2">
                            <input type="file" accept=".key" id="hmactabfile" name="hmactabfile" onchange="setSelectedFileName(event,'hmactabfname','hmactab')">
                             <label for="hmactabfile" id="file-label-hmac"  name="file-label-hmac">Browse</label>
 
                        </td>
                        <td colspan="1">
                            <input type="text" class="text" id="hmactabfname" name="hmactabfname" placeholder="Browse the File" readonly>
                        </td>
                        <td colspan="1">
                            <input type="button" id="upbtn-hmac" name="upbtn-hmac" value="Upload" onclick="configUploadFile('hmactabfile','hmacpBar','hmactabfname','hmactab','name','<%=certificatedir%>','hmac')">
                            <p id="hmacpBar"></p>
                            <div id="hmacprocess" hidden="">
                                <input type="hidden" id="hmacfileName" name="hmacfileName" value="">
                            </div>
                        </td>
                        <td colspan="1">
                            <input type="button" onclick="cancelFileSelection('hmactabfname')" id="canbtn-hmac" name="canbtn-hmac" value="Cancel">
                        </td>
                     </tr>
                    <tr class='hiderow hiderowcol'>
                        <td colspan="2">FileName</td>
                        <td colspan="1">Status</td>
                        <td colspan="2">Action</td>
                    </tr>
                </tbody>
            </table>
            <!-- up file  -->
           <input type="text" id="uptabopvpconf" name="uptabopvpconf" value="1" hidden="">
           <table class="borderlesstab" style="width:800px;;margin-bottom:0px;" id="uptab" name="uptab" align="center"> 
               <tbody id="file-table-body-up" name="file-table-body-up" colspan="5">
                    <tr>
                       <th colspan="5">
                           <div align="center">
                               <strong>User Name Password</strong>
                           </div>
                       </th>
                    </tr>
                    <tr id="selfilrow">
                        <td colspan="5">
                            <input type="button" name="uptabchosefileid" id="uptabchosefileid" value="Choose File" onclick="toggleTableRows('uptab')">
                            <label style="padding-right:20px;margin-left: 100px;">Selected file : </label>
                            <input type="text" name="uptabselfile" id="uptabselfile" class="text" value="<%=seluserfilename%>" readonly>
                        </td>   
                    </tr>
                    <tr class='hiderow'>
                        <td colspan="2">
                            <input type="file" id="uptabfile" accept=".auth" name="uptabfile" onchange="setSelectedFileName(event,'uptabfname','uptab')">
                            <label for="uptabfile" id="file-label-up" name="file-label-up">Browse</label>
 
                        </td>
                        <td colspan="1">
                            <input type="text" class="text" id="uptabfname" name="uptabfname" placeholder="Browse the File" readonly>
                        </td>
                        <td colspan="1">
                            <input type="button" id="upbtn-up" name="upbtn-up" value="Upload" onclick="configUploadFile('uptabfile','uppBar','uptabfname','uptab','name','<%=certificatedir%>','user')">
                            <p id="uppBar"></p>
                            <div id="upprocess" hidden="">
                                <input type="hidden" id="upfileName" name="upfileName" value="">
                            </div>
                        </td>
                        <td colspan="1">
                            <input type="button" onclick="cancelFileSelection('uptabfname')" id="canbtn-up" name="canbtn-up" value="Cancel">
                        </td>
                    </tr>
                    <tr class='hiderow hiderowcol'>
                        <td colspan="2">FileName</td>
                        <td colspan="1">Status</td>
                        <td colspan="2">Action</td>
                    </tr>
               </tbody>
           </table>
           <!-- psk tab file  -->
           <!-- <input type="text" id="pasktabopvpconf" name="pasktabopvpconf" value="1" hidden="">
           <table class="borderlesstab" style="width:800px;;margin-bottom:0px;" id="pasktab" name="pasktab" align="center">
                <tbody id="file-table-body-psk" name="file-table-body-psk" colspan="5">
                    <tr>
                       <th colspan="5">
                           <div align="center">
                               <strong>Pre-Shared Key</strong>
                           </div>
                       </th>
                    </tr>
                    <tr id="selfilrow">
                       <td colspan="5">
                            <input type="button" name="pasktabchosefileid" id="pasktabchosefileid" value="Choose File" onclick="toggleTableRows('pasktab')">
                            <label style="padding-right:20px;margin-left: 100PX;">Selected file : </label>
                            <input type="text" name="pasktabselfile" id="pasktabselfile" class="text" readonly>
                       </td>    
                    </tr>
                    <tr class='hiderow'>
                        <td colspan="2">
                            <input type="file" id="pasktabfile" accept=".key" name="pasktabfile" onchange="setSelectedFileName(event,'pasktabfname','pasktab')">
                            <label for="pasktabfile" id="file-label-psk" name="file-label-psk">Browse</label>
 
                        </td>
                        <td colspan="1">
                            <input type="text" class="text" id="pasktabfname" name="pasktabfname" placeholder="Browse the File" readonly>
                            
                        </td>
                        <td colspan="1">
                            <input type="button" id="upbtn-psk" name="upbtn-psk" value="Upload" onclick="configUploadFile('pasktabfile','pskpBar')">
                            <p id="pskpBar"></p>
                            <div id="pskprocess" hidden="">
                                <input type="hidden" id="pskfileName" name="pskfileName" value="">
                            </div>
                        </td>
                        <td colspan="1">
                            <input type="button" onclick="cancelFileSelection('pasktabfname')" id="canbtn-psk" name="canbtn-psk"  value="Cancel">
                        </td>
                     </tr>
                    <tr class='hiderow hiderowcol'>
                        <td colspan="2">FileName</td>
                        <td>Status</td>
                        <td colspan="2">Action</td>
                    </tr>
                </tbody>
           </table> -->
        </div>
       <div align="center">
           <input type="submit" value="Apply" name="Apply" style="display:inline block" class="button">
           <!-- <input type="submit" value="Save &amp; Apply" name="Save" style="display:inline block" class="button"> -->
       </div>
    </form> 
    <%
    String delfile="";
    for(String cafilename :cafile_list)
    {  
    	delfile=certificatedir+"/openvpn/"+cafilename;%>
   
    	<script>
    	 addRow('catab','catabopvpconf','<%=delfile%>','<%=slnumber%>','<%=version%>','client-vpn.jsp','<%=name%>','ca');
    	 fillrow('catab','<%=cafilename%>');
    	</script>
    <%}
    for(String client_crt_filename :client_crt_list)
    {
    	delfile=certificatedir+"/openvpn/client/"+client_crt_filename;
    %>
    	<script>
    	 addRow('certtab','certtabopvpconf','<%=delfile%>','<%=slnumber%>','<%=version%>','client-vpn.jsp','<%=name%>','cert');
    	 fillrow('certtab','<%=client_crt_filename%>');
    	</script>
    <%}
    for(String client_key_filename :client_key_list)
    { 
    	delfile=certificatedir+"/openvpn/client/"+client_key_filename;
    %>
    	<script>
    	addRow('keytab','keytabopvpconf','<%=delfile%>','<%=slnumber%>','<%=version%>','client-vpn.jsp','<%=name%>','key');
        fillrow('keytab','<%=client_key_filename%>');
    	</script>
    <%}
    for(String hmac_filename :hmac_list)
    {
    	delfile=certificatedir+"/openvpn/hmac/"+hmac_filename;
    %>
    	<script>
    	 addRow('hmactab','hmactabopvpconf','<%=delfile%>','<%=slnumber%>','<%=version%>','client-vpn.jsp','<%=name%>','tls_auth');
    	 fillrow('hmactab','<%=hmac_filename%>');
    	</script>
    <%}
    for(String user_filename :user_list)
    {
    	delfile=certificatedir+"/openvpn/user/"+user_filename;
    %>
    	<script>
        addRow('uptab','uptabopvpconf','<%=delfile%>','<%=slnumber%>','<%=version%>','client-vpn.jsp','<%=name%>','auth_user_pass');
        fillrow('uptab','<%=user_filename%>');
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
    	<%} else if(status != ""){%>
    	<script type="text/javascript">
    		alert('<%=status%>');
    		</script>
   <% }
    	}
    %> 
</body>
<script src="./js/client-vpn.js"></script>
<script>
tlsact();
compressshow();
pskstaticshow();
directionshow();
   /*  addRow('pasktab','pasktabopvpconf');
    fillrow('pasktab','xyz.html');
 */
    // setStatus('catab');
    var arrtableid  = ['catab','certtab','keytab','hmactab','uptab','pasktab'];
    for(var i=0;i<arrtableid.length;i++)
        setStatus(arrtableid[i]);
</script>
</html>