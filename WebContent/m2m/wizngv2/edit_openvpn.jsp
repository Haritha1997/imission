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
		 String instancename = request.getParameter("instancename")==null?"":request.getParameter("instancename");
		   JSONObject wizjsonnode = null;
		   FileReader propsfr = null;
		   JSONArray edit_natrules_arr = null;
		   JSONObject edit_natrulespage = null;
		   BufferedReader jsonfile = null;  
		   boolean enabled = false;
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
<body>
    <form action="savedetails.jsp?page=edit_openvpn&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="return validateClient()">
        <p class="style1" align="center">Client Instance Parameters</p>
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
                    <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="mainact" id="mainact" style="vertical-align:middle" checked=""><span class="slider round"></span></label></td>
                    <td width="200px">Name</td>
                    <td><input type="text" name="name" id="name" class="text" readonly></td>
                </tr>
                <tr>
                    <td>Remote Address</td>
                    <td>
                       <input type="text" class="text" name="remoteaddress" id="remoteaddress" placeholder="eg: 192.168.1.10" onfocusout="validatenameandip('remoteaddress',true,'Remote Address')">
                    </td>
                    <td>Remote Port</td>
                    <td><input type="number" class="text" name="remoteport" id="remoteport" placeholder="(0-65535)" value="1194" min="0" max="65535" onfocusout="validateRange('remoteport',true,'Remote Port')"></td>                    
                </tr>
                <tr>
                    <td>Protocol</td>
                    <td><select name="protocol" id="protocol" class="text" required>
                       <option value="udp4">udp4</option>
                       <option value="tcp4">tcp4</option>
                    </select></td>
                    <td>Common Name (CN)</td>
                    <td><input type="text" class="text" name="commonname" id="commonname" maxlength="40" onmouseover="setTitle(this)"></td>   
                </tr>
                <tr>
                    <td>User_Pass Authentication</td>
                    <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="userpassactivation" id="userpassactivation" style="vertical-align:middle"><span class="slider round"></span></label></td>
                    <td>TLS Authentication</td>
                    <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="tlsactivation" id="tlsactivation" style="vertical-align:middle"><span class="slider round"></span></label></td>
                </tr>
                <tr>
                    <td>Additional HMAC Authentication</td>
                    <td>
                       <input type="checkbox" name="hmacauth" id="hmacauth" onclick="directionshow()">
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
                </tr>
                <tr>
                    <td>HMAC Authentication Algorithm</td>
                    <td><select name="hmacalgor" id="hmacalgor" class="text">
                       <option value="HMAC-SHA1">HMAC-SHA1</option>
                       <option value="HMAC-SHA256" selected="">HMAC-SHA256</option>
                       <option value="HMAC-SHA384">HMAC-SHA384</option>
                       <option value="HMAC-SHA512">HMAC-SHA512</option>
                    </select></td>
                    <td>TLS Ciphers</td>
                    <td><select  id="proto" name="proto" multiple="multiple" style="display: none;">
                       <option value="TLS_CHACHA20_POLY1305_SHA256" selected>TLS_CHACHA20_POLY1305_SHA256</option>
                       <option value="TLS_AES_256_GCM_SHA384" selected>TLS_AES_256_GCM_SHA384</option>
                       <option value="TLS_AES_128_GCM_SHA256" selected>TLS_AES_128_GCM_SHA256</option>
                    </select></td>
                </tr>
                <tr>
                   <td>Ciphers</td>
                   <td><select name="cipher" id="cipher" class="text">
                       <option value="AES-128-CBC">AES-128-CBC</option>
                       <option value="AES-128-CFB">AES-128-CFB  </option>
                       <option value="AES-128-CFB1">AES-128-CFB1</option>
                       <option value="AES-128-CFB8">AES-128-CFB8</option>
                       <option value="AES-128-GCM">AES-128-GCM</option>
                       <option value="AES-128-OFB">AES-128-OFB</option>
                       <option value="AES-192-CBC">AES-192-CBC</option>
                       <option value="AES-192-CFB">AES-192-CFB</option>
                       <option value="AES-192-CFB1">AES-192-CFB1</option>
                       <option value="AES-192-CFB8">AES-192-CFB8</option>
                       <option value="AES-192-GCM">AES-192-GCM</option>
                       <option value="AES-192-OFB">AES-192-OFB</option>
                       <option value="AES-256-CBC">AES-256-CBC</option>
                       <option value="AES-256-CFB">AES-256-CFB</option>
                       <option value="AES-256-CFB1">AES-256-CFB1</option>
                       <option value="AES-256-CFB8">AES-256-CFB8</option>
                       <option value="AES-256-GCM">AES-256-GCM</option>
                       <option value="AES-256-OFB">AES-256-OFB</option>
                   </select></td>
                   <td></td>
                   <td></td>
                </tr>
                <tr>
                    <td>Compress</td>
                    <td><input type="checkbox" name="compress" id="compress" onclick="compressshow()"></td>
                    <td><label  id="algorow">Algorithm</td>
                    <td>
                        <select name="algorithm" id="algorithm" class="text">
                        <option value="LZO" selected>LZO</option>
                        <option value="LZ4">LZ4</option>
                        <option value="LZ4-V2">LZ4-V2</option>
                    </select></td>
                </tr>
                <tr>
                   <td>TLS key Renegotiation Interval (secs)</td>
                   <td><input type="number" name="tlskey" id="tlskey" class="text" min="1" max="604800" value="3600"></td>
                   <td></td>
                   <td></td>
                </tr>
                <tr>
                   <td>Keep Alive Interval(secs)</td>
                   <td><input type="number" name="keepalive" id="keepalive" class="text" min="1" max="60" value="10"></td>
                   <td>Keep Alive Timeout </td>
                   <td><input type="number" name="timeout" id="timeout" class="text" min="60" max="180" value="60"></td>
                  
                </tr> 
                <tr>
                   <td>Log Level</td>
                   <td><input type="number" name="logle" class="text" id="logle" min="1" max="11" value="3"></td>
                   <td></td>
                   <td></td>
                </tr>
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
                            <input type="text" name="catabselfile" id="catabselfile" value="hello.html" class="text" readonly>
                        </td>
                   </tr>                   
                    <tr class='hiderow'>
                        <td colspan="2">
                            <input type="file" accept=".crt" id="catabfile"  name="catabfile" onchange="setSelectedFileName(event,'catabfname','catab')">
                            <!-- <label for="catabfile" id="file-label" name="file-label">Browse</label>
 -->
                        </td>
                        <td colspan="1">
                            <input type="text" class="text" id="catabfname" name="catabfname" placeholder="Browse the File" readonly>
                            
                        </td>
                        <td colspan="1">
                            <input type="button" id="upbtn" name="upbtn" value="Upload" onclick="configUploadFile('catabfile','capBar',evt,'fileName','catab','name')">
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
                            <input type="text" name="certtabselfile" id="certtabselfile" class="text" readonly>
                        </td>    
                    </tr>
                    <tr class='hiderow'>
                        <td colspan="2">
                            <input type="file" accept=".crt" id="certtabfile" name="certtabfile" onchange="setSelectedFileName(event,'certtabfname','certtab')">
                           <!--  <label for="certtabfile" id="file-label-cert" name="file-label-cert">Browse</label>
  -->
                        </td>
                        <td colspan="1">
                            <input type="text" class="text" id="certtabfname" name="certtabfname" placeholder="Browse the File" readonly>
                            
                        </td>
                        <td colspan="1">
                            <input type="button" id="upbtn-cert" name="upbtn-cert" value="Upload" onclick="configUploadFile('certtabfile','certpBar')">
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
                               <strong>Key Certificate</strong>
                           </div>
                       </th>
                    </tr>
                    <tr id="selfilrow">
                       <td colspan="5">
                            <input type="button" name="keytabchosefileid" id="keytabchosefileid" value="Choose File" onclick="toggleTableRows('keytab')">
                            <label style="padding-right:20px;margin-left: 100px;">Selected file : </label>
                            <input type="text" name="keytabselfile" id="keytabselfile" class="text" readonly>
                        </td>
                    </tr>
                    <tr class='hiderow'>
                        <td colspan="2">
                            <input type="file" accept=".key" id="keytabfile" name="keytabfile" onchange="setSelectedFileName(event,'keytabfname','keytab')">
                            <!-- <label for="keytabfile" id="file-label-key" name="file-label-key">Browse</label> -->
 
                        </td>
                        <td colspan="1">
                            <input type="text" class="text" id="keytabfname" name="keytabfname" placeholder="Browse the File" readonly>
                            
                        </td>
                        <td colspan="1">
                            <input type="button" id="upbtn-key" name="upbtn-key" value="Upload" onclick="configUploadFile('keytabfile','keypBar')">
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
                               <strong>Shared Secret</strong>
                           </div>
                       </th>
                    </tr>
                    <tr>
                       <td colspan="5">
                            <input type="button" name="hmactabchosefileid" id="hmactabchosefileid" value="Choose File" onclick="toggleTableRows('hmactab')">
                            <label style="padding-right:20px;margin-left: 100px;">Selected file : </label>
                            <input type="text" name="hmactabselfile" id="hmactabselfile" class="text" readonly>
                        </td>
                    </tr>
                    <tr class='hiderow'>
                        <td colspan="2">
                            <input type="file" accept=".key" id="hmactabfile" onchange="setSelectedFileName(event,'hmactabfname','hmactab')">
                            <!-- <label for="hmactabfile" id="file-label-hmac"  name="file-label-hmac">Browse</label> -->
 
                        </td>
                        <td colspan="1">
                            <input type="text" class="text" id="hmactabfname" name="hmactabfname" placeholder="Browse the File" readonly>
                        </td>
                        <td colspan="1">
                            <input type="button" id="upbtn-hmac" name="upbtn-hmac" value="Upload" onclick="configUploadFile('hmactabfile','hmacpBar')">
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
                            <input type="text" name="uptabselfile" id="uptabselfile" class="text" readonly>
                        </td>   
                    </tr>
                    <tr class='hiderow'>
                        <td colspan="2">
                            <input type="file" id="uptabfile" accept=".auth" name="uptabfile" onchange="setSelectedFileName(event,'uptabfname','uptab')">
                            <!-- <label for="uptabfile" id="file-label-up" name="file-label-up">Browse</label> -->
 
                        </td>
                        <td colspan="1">
                            <input type="text" class="text" id="uptabfname" name="uptabfname" placeholder="Browse the File" readonly>
                        </td>
                        <td colspan="1">
                            <input type="button" id="upbtn-up" name="upbtn-up" value="Upload" onclick="configUploadFile('uptabfile','uppBar')">
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
           <input type="text" id="pasktabopvpconf" name="pasktabopvpconf" value="1" hidden="">
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
                            <!-- <label for="pasktabfile" id="file-label-psk" name="file-label-psk">Browse</label> -->
 
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
           </table>
        </div>
       <div align="center">
           <input type="submit" value="Apply" name="Apply" style="display:inline block" class="button">
           <!-- <input type="submit" value="Save &amp; Apply" name="Save" style="display:inline block" class="button"> -->
       </div>
    </form>  
</body>
<script src="./js/client-vpn.js"></script>
<script>
    window.onload = function () {
            var name = localStorage.getItem("name");
            document.getElementById("name").value = name;
        };
</script>
<script>
    directionshow();
    compressshow();
    pskstaticshow();
    // ca row
    addRow('catab','catabopvpconf');
    fillrow('catab','hello.html');
    // addRow('catab','catabopvpconf');
    // fillrow('catab','index.html');
    // cert row
    addRow('certtab','certtabopvpconf');
    fillrow('certtab','index.html');
    // key row
    addRow('keytab','keytabopvpconf');
    fillrow('keytab','abc.html');
    // hmac row
    addRow('hmactab','hmactabopvpconf');
    fillrow('hmactab','demo.html');
    // up row
    addRow('uptab','uptabopvpconf');
    fillrow('uptab','abc.html');
    // psk row
    addRow('pasktab','pasktabopvpconf');
    fillrow('pasktab','xyz.html');

    // setStatus('catab');
    var arrtableid  = ['catab','certtab','keytab','hmactab','uptab','pasktab'];
    for(var i=0;i<arrtableid.length;i++)
        setStatus(arrtableid[i]);
    
</script>
</html>