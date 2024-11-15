<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.util.Hashtable"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

<%
	String instname=request.getParameter("instancename");
	String fmversion=request.getParameter("version");	
   JSONObject wizjsonnode = null;
   JSONObject ipsec_table = null;
   JSONArray ipsecnumarr = null;
   BufferedReader jsonfile = null;	
   JSONObject tunnel = null;
   String product_type = "";
   /******* select options  ********/
   String lclid = "";
   String rmteid="";
   String encptn1 = "";
   String IPSechashing="";
   String encptn2 = "";
   String ISAKMPhashing="";
   String natrvsl = "";
   String dpdusrcfg = "";
   String dhgroup="";
   String pfsgroup="";
   String lclcrpendpt="";
   
   /******* Check boxes  ********/
   String activation = "";
   String aggmode="";
   String dualpeer = "";
   
   String slnumber=request.getParameter("slnumber");
   String errorstr = request.getParameter("error");
   Hashtable <String,JSONObject> tunnameob_ht = new Hashtable<String,JSONObject>();
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
   			JSONObject prodtypeobj = wizjsonnode.getJSONObject("SYSTEMCONTROL").getJSONObject("PRODUCTTYPE");
   		product_type = prodtypeobj.containsKey("OldProductType")? prodtypeobj.getString("OldProductType") :prodtypeobj.getString("ProductType");
   	   		JSONObject ipsec_configobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").getJSONObject("IPSECCONFIG");
   	   		JSONObject ipsec_obj =ipsec_configobj.getJSONObject("IPSEC");
   	   	    String ipsecslctno=(String)ipsec_obj.get("IpsecSelectNo");
   	   	    ipsec_table = ipsec_obj.getJSONObject("TABLE");
   	   	    ipsecnumarr = ipsec_table.getJSONArray("arr")==null ? new JSONArray(): ipsec_table.getJSONArray("arr");
   	   		for (int j = 0; j < ipsecnumarr.size(); j++) 
   	   		{
				JSONObject tnlobj = ipsecnumarr.getJSONObject(j);
				tunnameob_ht.put(tnlobj.getString("instancename"), tnlobj);
			}
   	   		tunnel = tunnameob_ht.get(instname); 
			if(tunnel != null)
			{
				lclid = tunnel.getString("LocalID")==null?"IP Address":tunnel.getString("LocalID");
			    rmteid= tunnel.getString("RemoteID")==null?"":tunnel.getString("RemoteID");
			    encptn1 =  tunnel.getString("EncryptionTypePh1")==null?"":tunnel.getString("EncryptionTypePh1");
			    ISAKMPhashing= tunnel.getString("HashingPh1")==null?"":tunnel.getString("HashingPh1");
			    encptn2 =  tunnel.getString("EncryptionTypePh2")==null?"":tunnel.getString("EncryptionTypePh2");
			    IPSechashing= tunnel.getString("HashingPh2")==null?"":tunnel.getString("HashingPh2");
			    natrvsl =  tunnel.getString("NAT_traversal")==null?"":tunnel.getString("NAT_traversal");
			    dpdusrcfg= tunnel.getString("DPDService")==null?"":tunnel.getString("DPDService");
			    dhgroup =  tunnel.getString("DHgroup")==null?"":tunnel.getString("DHgroup");
			    pfsgroup= tunnel.getString("PFSgroup")==null?"":tunnel.getString("PFSgroup");
			    lclcrpendpt= tunnel.getString("interface")==null?"":tunnel.getString("interface");
			
			    activation = tunnel.getString("Activation")==null?"":tunnel.getString("Activation");
			    aggmode=tunnel.getString("AggressiveMode")==null?"":tunnel.getString("AggressiveMode");
			    dualpeer = tunnel.getString("DualPeer")==null?"":tunnel.getString("DualPeer");
			}
			
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
	  <script type="text/javascript" src="js/tunn.js"></script>
	  <script type="text/javascript" src="js/tunnel.js"></script>
      <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript">
function showErrorMsg(errormsg)
{
	alert(errormsg);
}
</script>
      <style type="text/css">
#WiZConf {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 900px;
}

#WiZConf1,
#ipsectab {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 900px;
}

#WiZConf td,
#WiZConf th,
#ipsectab td,
#ipsectab th {
	border: 2px solid #ddd;
	padding: 8px;
}

#WiZConf1 td,
#WiZConf1 th {
	border: 2px solid #ddd;
	padding: 8px;
}

#WiZConf tr:nth-child(even),
#ipsectab tr:nth-child(even) {
	background-color: #f2f2f2;
}

#WiZConf1 tr:nth-child(even) {
	background-color: #f2f2f2;
}

#WiZConf tr:hover,
#ipsectab tr:hover {
	background-color: #d3f2ef;
}

#WiZConf1 tr:hover {
	background-color: #d3f2ef;
}

#WiZConf th,
#ipsectab th {
	padding-top: 12px;
	padding-bottom: 12px;
	text-align: left;
	background-color: #5798B4;
	color: white;
}

#WiZConf1 th {
	padding-top: 12px;
	padding-bottom: 12px;
	text-align: left;
	background-color: #5798B4;
	color: white;
}

#WiZConf1 td input,
#ipsectab td input {
	max-width: 120px;
}

#WiZConf1 caption {
	padding-top: 12px;
	padding-bottom: 12px;
	text-align: center;
	background-color: #5798B4;
	color: white;
	font-weight: bold;
}

.text {
	background: white;
	border: 2px Solid #DDD;
	border-radius: 5px;
	box-shadow: 1 1 5px #DDD inset;
	color: #000;
	height: 20px;
	width: 120px;
}

.text1 {
	background: white;
	border: 2px Solid #DDD;
	border-radius: 5px;
	box-shadow: 1 1 5px #DDD inset;
	color: #000;
	height: 20px;
	width: 185px;
}

.button {
	display: block;
	border-radius: 6px;
	background-color: #6caee0;
	color: #ffffff;
	font-weight: bold;
	box-shadow: 1px 2px 4px 0 rgba(0, 0, 0, 0.08);
	padding: 12px 20px;
	border: 0;
	margin: 10px 10px 0;
}

.button1 {
	float: right;
	padding-right: 10px;
	font-weight: bold;
	background-color: #6caee0;
}

.style1 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	color: #5798B4;
	font-size: 20px;
	font-weight: bold;
}

body {
	background-color: #FAFCFD;
}
</style>

   </head>
   <body onload="selectComboItem()">
      <form action="savepage.jsp?page=tunnelconfig&slnumber=<%=slnumber%>&instname=<%=instname%>&version=<%=fmversion%>" method="post" onsubmit="return validateIPSec();">
         <blockquote>
            <p class="style1" align="center">IPSec Configuration</p>
         </blockquote>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th colspan="5">
                     <div align="center"><strong>General Configuration</strong></div>
                  </th>
               </tr>
               <tr>
                  <td width="20%">Local ID</td>
                  <td>
                     <select id="lidopt" name="lidopt" onchange="makeEditableFields('lidopt')">
                        <option value="IP Address" <%if(lclid.equalsIgnoreCase("IP Address")) {%>selected<%}%>>IP Address</option>
                        <option value="FQDN Client" <%if(lclid.equalsIgnoreCase("FQDN Client")) {%>selected<%}%>>FQDN Client</option>
                     </select>
                  </td>
                  <td width="23%">Local End Point</td>
                  <td colspan="2" width="33%"><input disabled="" id="lfqep" name="lfqep" value="<%=tunnel == null?"":tunnel.get("LocalEndPoint")==null?"":tunnel.getString("LocalEndPoint")%>" placeholder="Local End Point" type="text" width="300px" style="background-color: rgb(128, 128, 128); outline: initial;"></td>
               </tr>
               <tr>
                  <td width="20%">Remote ID</td>
                  <td>
                     <select id="ridopt" name="ridopt" onchange="checkLoacalDroopBoxValue()">
                        <option value="IP Address" <%if(rmteid.equalsIgnoreCase("IP Address")) {%>selected<%}%>>IP Address</option>
                        <option value="FQDN Server" <%if(rmteid.equalsIgnoreCase("FQDN Server")) {%>selected<%}%>>FQDN Server</option>
                        <option value="Domain Name" <%if(rmteid.equalsIgnoreCase("Domain Name")) {%>selected<%}%>>Domain Name</option>
                     </select>
                  </td>
                  <td>Remote End Point</td>
                  <td colspan="2"><input disabled="" id="rfqep" name="rfqep" value="<%=tunnel == null?"":tunnel.get("RemoteEndPoint")==null?"":tunnel.getString("RemoteEndPoint")%>" placeholder="Remote End Point 1" type="text" width="300px" style="background-color: rgb(128, 128, 128); outline: initial;"></td>
               </tr>
               <tr>
                  <td width="80px"><input type="checkbox" name="activation" id="activation" <%if(activation.equalsIgnoreCase("Enable")) {%>checked<%}%>>&nbsp;Activation</td>
                  <td width="205px"><input style="background-color: rgb(255, 255, 255);" name="Agsvemode" id="Agsvemode" type="checkbox" <%if(aggmode.equalsIgnoreCase("Enable")) {%>checked<%}%>>&nbsp;Aggresive Mode Disable</td>
                  <td width="100px"><input style="background-color: rgb(255, 255, 255);" name="dualpeer" id="dualpeer" onchange="editSecondaryPeer()" type="checkbox" <%if(dualpeer.equalsIgnoreCase("Enable")) {%>checked<%}%>>&nbsp;Dual Peer</td>
                  <td width="100px">Remote Peer</td>
                  <td width="150px">
					<input style="background-color: rgb(255, 255, 255);" name="rempeer" class="text" id="rempeer" value="<%=tunnel == null?"":tunnel.get("remIP")==null?"":tunnel.getString("remIP")%>" onfocusout="validateIP('rempeer',false,'Remote Peer')" type="text" onkeypress="return IPv4AddressKeyOnly(event)"></input>
				    <input style="min-width: 180px; display: none;" disabled name="rempeerdns" id="rempeerdns" value="<%=tunnel == null?"":tunnel.get("remoteDNS")==null?"":tunnel.getString("remoteDNS")%>" maxlength="64" class="text" onkeypress="return avoidSpace(event)" type="text" ></input>
				  </td>
               </tr>
               <tr>
                  <td width="140px">Local Crypto Endpoint</td>
                  <td width="140px"><%=lclcrpendpt%></td>
                  <td width="150px">
                     <select name="lclcryptendpnt" id="lclcryptendpnt">
                        <option value="No Change" <%if(lclcrpendpt.equalsIgnoreCase("No Change")) {%>selected<%}%>>No Change</option>
                        <option value="Cellular" <%if(lclcrpendpt.equalsIgnoreCase("Cellular")) {%>selected<%}%>>Cellular</option>	
                        <%if(product_type.equals("3LAN-1WAN")){%>
						<option value="Eth1" <%if(lclcrpendpt.equalsIgnoreCase("Eth1")) {%>selected<%}%>>Eth1</option>
                        <option value="Dialer" <%if(lclcrpendpt.equalsIgnoreCase("Dialer")) {%>selected<%}%>>Dialer</option>
						<%}%>
                     </select>
                  </td>
                  <td width="100px">Secondary Peer</td>
                  <td width="150px">
                  <input style="background-color: rgb(128, 128, 128); outline: initial;" disabled="" name="scndrypeer" class="text" id="scndrypeer" value="<%=tunnel == null?"":tunnel.get("SecondaryIP")==null?"":tunnel.getString("SecondaryIP")%>" onkeypress="return IPv4AddressKeyOnly(event)" onfocusout="validateIP('scndrypeer',false,'Secondary Peer')" type="text" ></input>
                  <input style="min-width: 180px; background-color: rgb(128, 128, 128); outline: initial; display: none;" disabled="" name="scndrypeerdns" maxlength="64" class="text" value="<%=tunnel == null?"":tunnel.get("secondaryDNS")==null?"":tunnel.getString("secondaryDNS")%>" id="scndrypeerdns" onkeypress="return avoidSpace(event)" type="text"></input></td>
               </tr>
               <tr>
                  <td colspan="2" width="250px">Instance Name</td>
                  <td colspan="3 " width="34%" id="instancename"><%=tunnel == null?"":tunnel.get("instancename")==null?"":tunnel.getString("instancename")%></td>
               </tr>
            </tbody>
         </table>
         <br>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th colspan="6">
                     <div align="center"><strong>Key Configuration</strong></div>
                  </th>
               </tr>
               <tr>
                  <td width="20%">&nbsp;Preshared Key 1</td>
                  <td width="24%"><input name="keycnfgrtn" maxlength="64" class="text1" id="keycnfgrtn" value="<%=tunnel == null?"":tunnel.get("PreshareKey")==null?"":tunnel.getString("PreshareKey")%>" onkeypress="return avoidSpace(event)" type="password"></td>
                  <td width="23%">Preshared Key 2</td>
                  <td><input name="keycnfgrtn2" maxlength="64" class="text1" id="keycnfgrtn2" value="<%=tunnel == null?"":tunnel.get("PreshareKey2")==null?"":tunnel.getString("PreshareKey2")%>" onkeypress="return avoidSpace(event)" type="password" disabled="" style="background-color: rgb(128, 128, 128); outline: initial;"></td>
               </tr>
            </tbody>
         </table>
         <br><input id="plcyrwcnt" name="plcyrwcnt" value="1" hidden="" type="text">
         <table id="WiZConf1" align="center">
            <caption>Policy Configuration</caption>
            <tbody>
               <tr>
                  <th style="text-align:center;" align="center" width="6%">Select</th>
                  <th style="text-align:center;" align="center" width="6%">S No</th>
                  <th style="text-align:center;" align="center" width="12%">Interface</th>
                  <th style="text-align:center;" align="center" width="15%">Source Network</th>
                  <th style="text-align:center;" align="center" width="15%">Source Subnet Mask</th>
                  <th style="text-align:center;" align="center" width="17%%">Destination Network</th>
                  <th style="text-align:center;" align="center" width="17%">Destination Subnet Mask</th>
               </tr>
            </tbody>
         </table>
         <div align="center"><input style="background-color:#6caee0;" id="add" value="Add" onclick="addRow('WiZConf1')" type="button"><input style="background-color:#6caee0;" id="delete" value="Delete" onclick="deleteRow('WiZConf1')" type="button"></div>
         <br>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th colspan="6">
                     <div align="center"><strong>ISAKMP Configuration</strong></div>
                  </th>
               </tr>
               <tr>
                  <td width="16%">Encryption</td>
                  <td width="16%"><%=encptn1%></td>
                  <td width="16%">
                     <select name="ISAKMP_enc" id="ISAKMP_enc">
                        <option value="No Change" <%if(encptn1.equalsIgnoreCase("No Change")) {%>selected<%}%>>No Change</option>
                        <option value="DES" <%if(encptn1.equalsIgnoreCase("DES")) {%>selected<%}%>>DES</option>
                        <option value="3DES" <%if(encptn1.equalsIgnoreCase("3DES")) {%>selected<%}%>>3DES</option>
                        <option value="AES-128" <%if(encptn1.equalsIgnoreCase("AES-128")) {%>selected<%}%>>AES-128</option>
                        <option value="AES-192" <%if(encptn1.equalsIgnoreCase("AES-192")) {%>selected<%}%>>AES-192</option>
                        <option value="AES-256" <%if(encptn1.equalsIgnoreCase("AES-256")) {%>selected<%}%>>AES-256</option>
                     </select>
                  </td>
                  <td width="16%">Hashing</td>
                  <td style="min-width:14%;"><%=ISAKMPhashing%></td>
                  <td>
                     <select name="ISAKMP_hash" id="ISAKMP_hash">
                        <option value="No Change" <%if(ISAKMPhashing.equalsIgnoreCase("No Change")) {%>selected<%}%>>No Change</option>
                        <option value="MD5" <%if(ISAKMPhashing.equalsIgnoreCase("MD5")) {%>selected<%}%>>MD5</option>
                        <option value="SHA1" <%if(ISAKMPhashing.equalsIgnoreCase("SHA1")) {%>selected<%}%>>SHA1</option>
                        <option value="SHA384" <%if(ISAKMPhashing.equalsIgnoreCase("SHA384")) {%>selected<%}%>>SHA384</option>
                        <option value="SHA512" <%if(ISAKMPhashing.equalsIgnoreCase("SHA512")) {%>selected<%}%>>SHA512</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>DH Group</td>
                  <td><%=dhgroup%></td>
                  <td>
                     <select name="ISAKMP_grp" id="ISAKMP_grp">
                        <option value="No Change" <%if(dhgroup.equalsIgnoreCase("No Change")) {%>selected<%}%>>No Change</option>
                        <option value="1" <%if(dhgroup.equalsIgnoreCase("1")) {%>selected<%}%>>1</option>
                        <option value="2" <%if(dhgroup.equalsIgnoreCase("2")) {%>selected<%}%>>2</option>
                        <option value="5" <%if(dhgroup.equalsIgnoreCase("5")) {%>selected<%}%>>5</option>
                        <option value="14" <%if(dhgroup.equalsIgnoreCase("14")) {%>selected<%}%>>14</option>
                        <option value="15" <%if(dhgroup.equalsIgnoreCase("15")) {%>selected<%}%>>15</option>
                     </select>
                  </td>
                  <td>Life Time (Secs)</td>
                  <td colspan="2"><input name="ISAKMP_lifetime" class="text" id="ISAKMP_lifetime" value="<%=tunnel == null?"":tunnel.get("LifeTimePh1")==null?"":tunnel.getString("LifeTimePh1")%>" min="60" max="86400" size="6" maxlength="6" type="number" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
            </tbody>
         </table>
         <br>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th colspan="6">
                     <div align="center"><strong>IPSec SA Configuration</strong></div>
                  </th>
               </tr>
               <tr>
                  <td width="16%">Encryption</td>
                  <td width="16%"><%=encptn2%></td>
                  <td width="16%">
                     <select name="IPsec_enc" id="IPsec_enc">
                         <option value="No Change" <%if(encptn2.equalsIgnoreCase("No Change")) {%>selected<%}%>>No Change</option>
                        <option value="DES" <%if(encptn2.equalsIgnoreCase("DES")) {%>selected<%}%>>DES</option>
                        <option value="3DES" <%if(encptn2.equalsIgnoreCase("3DES")) {%>selected<%}%>>3DES</option>
                        <option value="AES-128" <%if(encptn2.equalsIgnoreCase("AES-128")) {%>selected<%}%>>AES-128</option>
                        <option value="AES-192" <%if(encptn2.equalsIgnoreCase("AES-192")) {%>selected<%}%>>AES-192</option>
                        <option value="AES-256" <%if(encptn2.equalsIgnoreCase("AES-256")) {%>selected<%}%>>AES-256</option>
                     </select>
                  </td>
                  <td width="16%">Hashing</td>
                  <td style="min-width:14%"><%=IPSechashing%></td>
                  <td>
                     <select name="IPsec_hash" id="IPsec_hash">
                         <option value="No Change" <%if(IPSechashing.equalsIgnoreCase("No Change")) {%>selected<%}%>>No Change</option>
                        <option value="MD5" <%if(IPSechashing.equalsIgnoreCase("MD5")) {%>selected<%}%>>MD5</option>
                        <option value="SHA1" <%if(IPSechashing.equalsIgnoreCase("SHA1")) {%>selected<%}%>>SHA1</option>
                        <option value="SHA384" <%if(IPSechashing.equalsIgnoreCase("SHA384")) {%>selected<%}%>>SHA384</option>
                        <option value="SHA512" <%if(IPSechashing.equalsIgnoreCase("SHA512")) {%>selected<%}%>>SHA512</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>PFS Group</td>
                  <td><%=pfsgroup%></td>
                  <td>
                     <select name="PFS_grp" id="PFS_grp">
                        <option value="No Change" <%if(pfsgroup.equalsIgnoreCase("No Change")) {%>selected<%}%>>No Change</option>
                        <option value="1" <%if(pfsgroup.equalsIgnoreCase("1")) {%>selected<%}%>>1</option>
                        <option value="2" <%if(pfsgroup.equalsIgnoreCase("2")) {%>selected<%}%>>2</option>
                        <option value="5" <%if(pfsgroup.equalsIgnoreCase("5")) {%>selected<%}%>>5</option>
                        <option value="14" <%if(pfsgroup.equalsIgnoreCase("14")) {%>selected<%}%>>14</option>
                        <option value="15" <%if(pfsgroup.equalsIgnoreCase("15")) {%>selected<%}%>>15</option>
                        <option value="None" <%if(pfsgroup.equalsIgnoreCase("None")) {%>selected<%}%>>None</option>
                     </select>
                  </td>
                  <td>Life Time (Secs)</td>
                  <td colspan="2"><input name="lifetime_sec" class="text" id="lifetime_sec" value="<%=tunnel == null?"":tunnel.get("LifeTimePh2")==null?"":tunnel.getString("LifeTimePh2")%>" min="120" max="86400" size="6" maxlength="6" type="number" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
            </tbody>
         </table>
         <br>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th colspan="6">
                     <div align="center"><strong>Advanced IPSec VPN Configuration</strong></div>
                  </th>
               </tr>
               <tr>
                  <td colspan="2" width="32%">NAT Traversal</td>
                  <td colspan="2" width="33%"><%=natrvsl%></td>
                  <td colspan="2">
                     <select name="NAT_trav" id="NAT_trav">
                        <option value="No Change" <%if(natrvsl.equalsIgnoreCase("No Change")) {%>selected<%}%>>No Change</option>
                        <option value="Enable" <%if(natrvsl.equalsIgnoreCase("Enable")) {%>selected<%}%>>Enable</option>
                        <option value="Disable" <%if(natrvsl.equalsIgnoreCase("Disable")) {%>selected<%}%>>Disable</option>
                     </select>
                  </td>
               </tr>
            </tbody>
         </table>
         <br>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th colspan="6">
                     <div align="center"><strong>Dead Peer Detection</strong></div>
                  </th>
               </tr>
               <tr>
                  <td colspan="2" width="32%">DPD User Configuration</td>
                  <td colspan="2" width="33%"><%=dpdusrcfg%></td>
                  <td colspan="2">
                     <select id="dpdserv" name="dpdserv" onchange="editDPDFields();" style="min-width:120">
                        <option value="Enable" <%if(dpdusrcfg.equalsIgnoreCase("Enable")) {%>selected<%}%>>Enable</option>
                        <option value="Disable" <%if(dpdusrcfg.equalsIgnoreCase("Disable")) {%>selected<%}%>>Disable</option>
                     </select>
                  </td>
               </tr>
               <tr id="DPD_detrow">
                  <td width="16%" id="DPD_Inttd">DPD Delay</td>
                  <td width="16%"><input name="DPD_Int" class="text" id="DPD_Int" value="<%=tunnel == null?"":tunnel.get("DPDDelay")==null?"":tunnel.getString("DPDDelay")%>" min="10" max="3600" size="12" maxlength="4" type="number" width="120px" onkeypress="return IPv4AddressKeyOnly(event)"></td>
                  <td width="16%">DPD Retry Delay</td>
                  <td width="16%"><input name="DPD_retr" class="text" id="DPD_retr" value="<%=tunnel == null?"":tunnel.get("DPDRetryDelay")==null?"":tunnel.getString("DPDRetryDelay")%>" min="2" max="60" size="12" maxlength="2" type="number" width="120px" onkeypress="return IPv4AddressKeyOnly(event)"></td>
                  <td width="17%">DPD Max.Fails</td>
                  <td width="17%"><input name="DPD_fails" class="text" id="DPD_fails" value="<%=tunnel == null?"":tunnel.get("DPDMaxFails")==null?"":tunnel.getString("DPDMaxFails")%>" min="2" max="10" size="12" maxlength="2" type="number" width="120px" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
            </tbody>
         </table>
         <div align="center">
            <blockquote>
               <p><input value="Submit" class="button" type="submit"/></p>
            </blockquote>
			</div>
      </form>
	  
            <% 
            if(tunnel != null)
            {
            JSONArray aclarr = new JSONArray();
			 if( tunnel.containsKey("TABLE"))
				 aclarr = tunnel.getJSONObject("TABLE").getJSONArray("arr");
			 //System.out.println(aclarr);
            for(int i=0;i<aclarr.size();i++)
            {
            	JSONObject acl = aclarr.getJSONObject(i);
            	String intf = acl.getString("interface")==null? "":acl.getString("interface");
          		String srcNWIP = acl.getString("srcNWIP")==null? "":acl.getString("srcNWIP");
          		String srcSubNetIP = acl.getString("srcSubNetIP")==null? "":acl.getString("srcSubNetIP");
          		String dstNWIP = acl.getString("dstNWIP")==null? "":acl.getString("dstNWIP");
          		String dstSubNetIP = acl.getString("dstSubNetIP")==null? "":acl.getString("dstSubNetIP");
             %>
           <script type="text/javascript">
				 addRow('WiZConf1');
				addPolicyData('<%=(i+1)%>','<%=intf%>','<%=srcNWIP%>','<%=srcSubNetIP%>','<%=dstNWIP%>','<%=dstSubNetIP%>');
			 </script>
		   <%}
		   }%>
            <script type="text/javascript"> 
			function selectComboItem() {
	for (var i=0;i<hiddenvalarr.length;i++) {
		selAction(checkarr[i], document.getElementById(hiddenvalarr[i]).value);
	}
}
editSecondaryPeer();
setPeerVisibleFields();
editDPDFields();
makeEditableFields("lidopt");</script>       
</body>
<%if(errorstr != null && errorstr.trim().length() > 0)
{%>
 <script>
 showErrorMsg('<%=errorstr%>');
 </script>
<%}
%>
</html>