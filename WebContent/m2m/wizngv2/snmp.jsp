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
   JSONObject wizjsonnode = null;
   JSONObject snmpobj = null;
   JSONArray snmpsys = null;
   JSONObject snmpdef=null;
   JSONArray snmpver=null;
   JSONArray trapver=null;
   JSONObject trapcomm=null;
   JSONObject readcomm=null;
   JSONObject writecomm=null;
   JSONObject userobj=null;
   JSONObject trapauthobj=null;
   BufferedReader jsonfile = null;
   String slnumber=request.getParameter("slnumber");
   String errorstr = request.getParameter("error") != null?request.getParameter("error") : "" ;
   JSONObject sysobj=null;
   String snmpact="";
   String trapact="";
   String coldact="";
   String authact="";
   String linkupdnact="";
   String syscont="";
   String sysname="";
   String sysloc="";
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
   		
			snmpobj =  wizjsonnode.containsKey("snmpd")?wizjsonnode.getJSONObject("snmpd"):new JSONObject();
			snmpsys = snmpobj.containsKey("system")?snmpobj.getJSONArray("system"):new JSONArray();
			trapcomm=snmpobj.containsKey("trapcommunity:trapcommunity")?snmpobj.getJSONObject("trapcommunity:trapcommunity"):new JSONObject();
			snmpdef=snmpobj.containsKey("default:default")?snmpobj.getJSONObject("default:default"):new JSONObject();
			snmpver= snmpdef.containsKey("snmpversion")?snmpdef.getJSONArray("snmpversion"):new JSONArray();
			trapver= snmpdef.containsKey("trapversion")?snmpdef.getJSONArray("trapversion"):new JSONArray();
			readcomm=snmpobj.containsKey("com2sec6:public6")?snmpobj.getJSONObject("com2sec6:public6"):snmpobj.containsKey("com2sec:public")?snmpobj.getJSONObject("com2sec:public"):new JSONObject();
			writecomm=snmpobj.containsKey("com2sec6:private6")?snmpobj.getJSONObject("com2sec6:private6"):snmpobj.containsKey("com2sec:private")?snmpobj.getJSONObject("com2sec:private"):new JSONObject();
			userobj=snmpobj.containsKey("createUser:createUser")?snmpobj.getJSONObject("createUser:createUser"):new JSONObject();
			trapauthobj=snmpobj.containsKey("authtrapenable:authtrapenable")?snmpobj.getJSONObject("authtrapenable:authtrapenable"):new JSONObject();
			
			for (int i = 0; i <snmpsys.size();i++) {
			   sysobj = snmpsys.getJSONObject(i);
	 		   /* syscont=sysobj.getString("sysContact");
	 		   sysname = sysobj.getString("sysName");
	 		  sysloc = sysobj.getString("sysLocation"); */
	 		}
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
      <link href="css/fontawesome.css" rel="stylesheet"/>
      <link href="css/solid.css" rel="stylesheet"/>
      <link href="css/v4-shims.css" rel="stylesheet"/>
     <!--  <link rel="stylesheet" type="text/css" href="css/style.css"/> -->
   <!--    <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script> -->
  <link rel="stylesheet" type="text/css" href="css/style.css">
      <link rel="stylesheet" type="text/css" href="css/multiselect/bootstrap.min.css">
      <link rel="stylesheet" type="text/css" href="css/multiselect/bootstrap-multiselect.css">
      <script type="text/javascript" src="js/multiselect/jquery1.12.4.min.js"></script>
      <script type="text/javascript" src="js/multiselect/bootstrap3.3.6.min.js"></script>
	  <script type="text/javascript" src="js/multiselect/bootstrap-multiselect.js"></script>
      <script type="text/javascript" src="js/snmp.js"></script>
	  <script type="text/javascript" src="js/common.js"></script>
<style>
	  html {
	overflow-y: scroll;
}

.multiselect-container {
	width: 100% !important;
}
.imgicon{
	padding-bottom:10;
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
a,a:hover {
color: black;
 text-decoration: none;
}
.Popup
{
    text-align:left;
    position: absolute;
    left: 70%;
    z-index:50;
    width: 150px;
    background-color: #DCDCDC;
    border:2px solid black;
    border-radius: 4%;
}
#authpwdinfo
{
  top:730px;
}
#encrypwdinfo
{
  top:880px;
}
</style>
<script type="text/javascript">
	  var mngcnfrows = 1;
function validateSystemConfig() {
	try{
	var altmsg = "";
	var snampmsge=true;
	var trapmsge=true;
	var trapv1sel=false;
	var trapv2sel=false;
	var trapv3sel=false;
	var trapallsel=false;
	var snmpv1sel=false;
	var snmpv2sel=false;
	var snmpv3sel=false;
	var snmpallsel=false;
	var table = document.getElementById("WiZConf");
	var rows = table.rows;
	var syscntct = document.getElementById("syscntct");
	var sysname = document.getElementById("sysname");
	var syslct = document.getElementById("syslct");
	var rdcmty = document.getElementById("rdcmty");
	var wrcmty = document.getElementById("wrcmty");
	var trpcmty = document.getElementById("trapcmty");
	var managertable = document.getElementById("managerconf");
	var user=document.getElementById("user");
	var authpwd=document.getElementById("authpwd");
	var encrypwd=document.getElementById("encrypwd");
	var modesel=document.getElementById("secmode").value.trim();
	
	var snmpact=document.getElementById("activation");
	var trapact=document.getElementById("trapActvtn");
	var snmpver= document.getElementById("snmpVersion");
	var manager= document.getElementById("manager");
	var snmpverops = snmpver.options;
	var snmpversel;
	
	for (var ind = 0; ind < snmpverops.length; ind++) {
		var obj = snmpverops[ind];
		if (obj.selected) {
			snmpversel= obj.text;
			if(snmpversel=="v1")
				snmpv1sel=true;
			else if(snmpversel=="v2c")
				snmpv2sel=true;
			else if(snmpversel=="v3")
				snmpv3sel=true;
			else if(snmpversel=="All")
				snmpallsel=true;
			}
	
		}
	var trapver=document.getElementById("trapVersion");
	var trapverops = trapver.options;
	var trapversel;
	for (var ind = 0; ind < trapverops.length; ind++) {
		var obj = trapverops[ind];
		if (obj.selected) {
			trapversel= obj.text;
			if(trapversel=="v1")
				trapv1sel=true;
			else if(trapversel=="v2")
				trapv2sel=true;
			else if(trapversel=="v3")
				trapv3sel=true;
			else if(trapversel=="All")
				trapallsel=true;
			}
	
		}
	if(!snmpact.checked)
		snampmsge=false;
	if(!trapact.checked)
		trapmsge=false;
	if(snmpver.value.trim()==""&&snmpact.checked==true)
		altmsg += "SNMP Version should not be empty\n";
	if(trapver.value.trim()==""&&trapact.checked==true)
		altmsg += "Trap Version should not be empty\n";
	/* var managerrows = managertable.rows;
	for (var i = 2; i < managerrows.length; i++) 
		{
			var cols = managerrows[i].cells;
			var ipaddress = cols[1].childNodes[0].childNodes[0];
			var valid = validatedualIP(ipaddress.id, trapmsge, "Managers",false);
			if (!valid) 
			{
				altmsg += (i + 1);
				if (i == 0) altmsg += "st";
				else if (i == 1) altmsg += "nd";
				else if (i == 2) altmsg += "rd";
				else altmsg += "th";
				if (ipaddress.value.trim() == "")
					altmsg += " Manager should not be empty\n";
				else 
					altmsg += " Manager Address is not valid\n";
			}
		} */
	var valid = validatedualIP("manager", trapmsge, "Manager",false);
	if (!valid) {
		if (manager.value.trim() == "") altmsg += "Manager should not be empty\n";
		else altmsg += "Manager is not valid\n";
		}	
	var valid = validateLengthRange("syscntct", false, 1, 256, "System Contact");
	if (!valid) {
		if (syscntct.value.trim() == "") altmsg += "System Contact should not be empty\n";
		else altmsg += "System Contact is not valid\n";
	}
	else if(syscntct.value.includes('\'')||syscntct.value.includes('\"'))
	{
		altmsg += "System Contact is invalid.. Characters ' \" are not allowed\n";
		syscntct.style.outline = "thin solid red";
		syscntct.title = "System Contact is invalid.. Characters ' \" are not allowed";
	}
	valid = validateLengthRange("sysname", false, 1, 256, "System Name");
	if (!valid) {
		if (sysname.value.trim() == "") altmsg += "System Name should not be empty\n";
		else altmsg += "System Name is not valid\n";
	}
	else if(sysname.value.includes('\'') || sysname.value.includes('\"') || sysname.value.includes(':') || sysname.value.includes('#') || sysname.value.includes('=') || sysname.value.includes('.'))
	{
		altmsg += "System Name is invalid.. Characters ' \" = # : . are not allowed\n";
		sysname.style.outline = "thin solid red";
		sysname.title = "System Name is invalid.. Characters ' \" = # : . are not allowed";
	}
	valid = validateLengthRange("syslct", false, 1, 256, "System Location");
	if (!valid) {
		if (syslct.value.trim() == "") altmsg += "System Location should not be empty\n";
		else altmsg += "System Location is not valid\n";
	}
	else if(syslct.value.includes('\'')||syslct.value.includes('\"'))
	{
		altmsg += "System Location is invalid.. Characters ' \" are not allowed\n";
		syslct.style.outline = "thin solid red";
		syslct.title = "System Location is invalid.. Characters ' \" are not allowed";
	}
	var trapvalid=trapact.checked&&((trapv1sel&&trapv2sel)||(trapv1sel&&trapv3sel)||(trapv3sel&&trapv2sel)||trapallsel||trapv1sel||trapv2sel);
	if((trpcmty.value.trim()=="")&&trapvalid)
		{
		altmsg += "Trap Community should not be empty\n";
		trpcmty.style.outline = "thin solid red";
	}
	else
		trpcmty.style.outline = "initial";
	var snmpvalid=snmpact.checked&&((snmpv1sel&&snmpv2sel)||(snmpv1sel&&snmpv3sel)||(snmpv3sel&&snmpv2sel)||snmpallsel||snmpv1sel||snmpv2sel);
	if (snmpvalid)
		{
					if(rdcmty.value.trim()=="")
						{
							altmsg += "Read Community should not be empty\n";
							rdcmty.style.outline = "thin solid red";
						}
					if(wrcmty.value.trim()=="")
						{
						 	altmsg += "Write Community should not be empty\n";
						 	wrcmty.style.outline = "thin solid red";
						}
		}
	else
	 {
		rdcmty.style.outline= "initial";
		wrcmty.style.outline = "initial";
	 }
	var snmptrapvalid = ((snmpact.checked&&(snmpv3sel||snmpallsel)|| (trapact.checked&&(trapv3sel||trapallsel)))) && ((snmpv1sel && snmpv3sel) || (snmpv2sel && snmpv3sel) || snmpv3sel || snmpallsel||trapv3sel||trapallsel);
	if(snmptrapvalid)
		 {
			
			 if(user.value.trim()=="" )
				 {
				 altmsg += "User should not be empty\n";
				 user.style.outline="thin solid red";
				 }
			 else
				 user.style.outline="initial";
			 if(modesel=="priv")
			 {
				 var encrypwdvalid = pwdCheck("encrypwd","Snmp");
				 if(encrypwd.value.trim()=="")
				 {
					 altmsg += "Encryption Password should not be empty\n";
					 encrypwd.style.outline="thin solid red";
				 }
				 else if(encrypwd.value.length<8)
				 {
					altmsg += "Encryption Password must be atleast 8 characters\n";
					encrypwd.style.outline = "initial";
				 }
				 else if(!encrypwdvalid)
					 altmsg+='Encryption Password must contain at least one number and one uppercase and lowercase letter and Use Special Characters except " , '+" :  , ' ,?  and  ;\n";
				 else
					 encrypwd.style.outline="initial";
				 }
			 if(modesel!="noauth")
			  {
				 var authpwdvalid = pwdCheck("authpwd","Snmp");
				 if(authpwd.value.trim()=="")
				 {
				 altmsg += "Authentication Password should not be empty\n";
				 authpwd.style.outline="thin solid red";
				 }
				 else if(authpwd.value.length<8)
				 {
					altmsg += "Authentication Password must be atleast 8 characters\n";
					authpwd.style.outline = "initial";
				 }
				 else if(!authpwdvalid)
					 altmsg+='Authentication Password must contain at least one number and one uppercase and lowercase letter and Use Special Characters except " , '+" :  , ' ,?  and  ;\n";
			     else
				     authpwd.style.outline="initial";
			}
	}
	else
		{
		 user.style.outline="initial";
		 encrypwd.style.outline="initial";
		 authpwd.style.outline="initial";
		}
	valid = validateLengthRange("trapcmty", false, 1, 32, "Trap Community");
	if (!valid) {
		if (trpcmty.value.trim() == "") altmsg += "Trap Community should not be empty\n";
		else altmsg += "Trap Community is not valid\n";
	}
	if (altmsg.trim().length == 0) return true;
	else {
		alert(altmsg);
		return false;
	}
	}catch(e){alert(e);}
}
var snmpprevious = "";
$(document).ready(function () {
	$('#snmpVersion').multiselect({
		buttonWidth: '150px',
		numberDisplayed: 3,
	});
	$('#snmpVersion').change(function () {
		if (snmpprevious == 'all') $('#snmpVersion').multiselect('deselect', ['all']);
		else {
			var delopt = "'" + snmpprevious + "'";
			if ($('#snmpVersion :selected').length == 0) $('#snmpVersion').multiselect('deselect', [delopt]);
		}
		snmpprevious = $(this).val();
	});
});
function selectedSnmpVersions() {
	 $('#snmpVersion').multiselect({
		buttonWidth: '150px',
		numberDisplayed: 3,
	});
	var cbobj = document.getElementById("snmpVersion");
	var lastopt = cbobj.options[cbobj.length - 1];
	var opt_arr = [];
	if (lastopt.selected) {
		snmpprevious ='all';
		for (var i = 0; i < cbobj.length - 1; i++) {
			cbobj.options[i].selected = false;
			opt_arr.push(cbobj.options[i].value);
		}
		$('#snmpVersion').multiselect('deselect', opt_arr);
	}
}
var trapprevious="";
$(document).ready(function () {
	$('#trapVersion').multiselect({
		buttonWidth: '150px',
		numberDisplayed: 3,
	});
	$('#trapVersion').change(function () {
		if (trapprevious == 'all') $('#trapVersion').multiselect('deselect', ['all']);
		else {
			var delopt = "'" + trapprevious + "'";
			if ($('#trapVersion :selected').length == 0) $('#trapVersion').multiselect('deselect', [delopt]);
		}
		trapprevious = $(this).val();
	});
});
function selectedTrapVersions() {
	 $('#trapVersion').multiselect({
		buttonWidth: '150px',
		numberDisplayed: 3,
	});
	var cbobj = document.getElementById("trapVersion");
	var lastopt = cbobj.options[cbobj.length - 1];
	var opt_arr = [];
	if (lastopt.selected) {
		trapprevious ='all';
		for (var i = 0; i < cbobj.length - 1; i++) {
			cbobj.options[i].selected = false;
			opt_arr.push(cbobj.options[i].value);
		}
		$('#trapVersion').multiselect('deselect', opt_arr);
	}
}
function displayMode(id) {
	var modeobj = document.getElementById(id);
	var mode = modeobj.options[modeobj.selectedIndex].text;
	var authrow = document.getElementById('authrow');
	var encryptrow = document.getElementById('encryptrow');
	var apassrow = document.getElementById('apassrow');
	var epassrow = document.getElementById('epassrow');
	authrow.style.display = 'none';
	encryptrow.style.display = 'none';
	apassrow.style.display = 'none';
	epassrow.style.display = 'none';
	if (mode == "authPriv") {
		authrow.style.display = 'table-row';
		encryptrow.style.display = 'table-row';
		apassrow.style.display = 'table-row';
		epassrow.style.display = 'table-row';
	} else if (mode == "authNoPriv") {
		authrow.style.display = 'table-row';
		apassrow.style.display = 'table-row';
	}
}
$(document).on('click', '.toggle1-password', function () {
	$(this).toggleClass("fa-eye fa-eye-slash");
	var input = $("#authpwd");
	input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
});
$(document).on('click', '.toggle2-password', function () {
	$(this).toggleClass("fa-eye fa-eye-slash");
	var input = $("#encrypwd");
	input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
});
function showOrHidePWDInfo(id) 
{
	var authdialog = document.getElementById('authpwdinfo');
	var encrydialog = document.getElementById('encrypwdinfo');
	if(id == "authpwdinfo")
	{
		encrydialog.close();
		if(authdialog.open)
			authdialog.close();
		else
			authdialog.show();
	}
	else
	{
	 	authdialog.close(); 
	 	if(encrydialog.open)
	 		encrydialog.close();
		else
			encrydialog.show();
	}
	return dialog;
}
function alwaysEnable(id)
{
	var id =document.getElementById(id);
	id.checked=true;
	id.disabled=false;
}
</script>
   </head>
   <body>
      <form action="savedetails.jsp?page=snmp&slnumber=<%=slnumber%>" method="post" onsubmit="return validateSystemConfig()">
         <br>
		 <input type="hidden" id="trapiprows" name="trapiprows" value="2"/>
         <p class="style5" align="center">SNMP Configuration</p>
         <br>
         <table class="borderlesstab nobackground" style="width:420px; margin-bottom:0px;" id="configtype" align="center">
            <tbody>
               <tr style="padding:0px;margin:0px;">
                  <td style="padding:0px;margin:0px;">
                     <ul id="snmpconfigdiv">
                        <li><a class="casesense snmpconfiguration" onclick="showDivision('systempage')" id="hilightthis" style="cursor:pointer;">System</a></li>
                        <li><a class="casesense snmpconfiguration" onclick="showDivision('trapspage')" id="" style="cursor:pointer;">Traps</a></li>
                     </ul>
                  </td>
               </tr>
            </tbody>
         </table>
         <div id="systempage" align="center" style="margin: 0px; display: inline;">
            <table class="borderlesstab" style="width:420px;" align="center" id="WiZConf">
               <tbody>
                  <tr>
                     <th width="200">Parameters</th>
                     <th width="200">Configuration</th>
                  </tr>
                  <tr>
                     <td width="200">Activation</td>
                    <%if(snmpdef.containsKey("snmpactivation"))
						snmpact = snmpdef.getString("snmpactivation").equals("1")?"checked":""; %>
                     <td width="200"><label class="switch" style="vertical-align:middle"><input type="checkbox" name="activation" id="activation" <%=snmpact%> style="vertical-align:middle"><span class="slider round"></span></label></td>
                  </tr>
                  <tr>
                     <td width="200">SNMP Version</td>
                     <td width="200">
                     
                           <select id="snmpVersion" name="snmpVersion" multiple="multiple" onchange="selectedSnmpVersions();" style="display:none">
                              <option value="v1" <%if(snmpver.contains("v1")){%>selected<%}%>>v1</option>
                              <option value="v2c" <%if(snmpver.contains("v2c")){%>selected<%}%>>v2c</option>
                              <option value="usm" <%if(snmpver.contains("usm")){%>selected<%}%>>v3</option>
                              <option value="all" <%if(snmpver.contains("all")){%>selected<%}%>>All</option>
                           </select>
                     </td>
                  </tr>
                  <tr>
					<td>IPversion</td>
					<td>
					 <%String ipval=snmpdef!=null ?(!snmpdef.containsKey("ipversion")?"":snmpdef.getString("ipversion")):"ipv4";%>
						<select class="text" id="snmpipver" name="snmpipver">
							<option value="ipv4" <%if(ipval.equals("ipv4")){%>selected<%}%>>IPV4</option>
							<option value="ipv6" <%if(ipval.equals("ipv6")){%>selected<%}%>>IPV6</option>
							<option value="Dual" <%if(ipval.equals("Dual")){%>selected<%}%>>Dual</option>
						</select>
					</td>
				</tr>
                  <tr>
                     <td width="200">System Contact</td>
                     <% syscont =snmpsys!=null&&sysobj!=null? (!sysobj.containsKey("sysContact")?"":sysobj.getString("sysContact")):"";%>
                     <td width="200"><input type="text" name="syscntct" id="syscntct" class="text" value="<%=syscont%>" onkeypress="return avoidSpace(event)" onmouseover="setTitle(this)" onfocusout="validateLengthRange('syscntct',false,1,256,'System Contact')"></td>
                  </tr>
                  <tr>
                     <td width="200">System Name</td>
                     <% sysname=snmpsys!=null&&sysobj!=null? (!sysobj.containsKey("sysName")?"":sysobj.getString("sysName")):"";%>
                     <td width="200"><input type="text" name="sysname" id="sysname" maxlength="256" class="text" value="<%=sysname%>" onkeypress="return avoidSpace(event)" onmouseover="setTitle(this)" onfocusout="validateLengthRange('sysname',false,1,256,'System Name')"></td>
                  </tr>
                  <tr>
                     <td width="200">System Location</td>
                      <% sysloc=snmpsys!=null&&sysobj!=null? (!sysobj.containsKey("sysLocation")?"":sysobj.getString("sysLocation")):"";%>
                     <td width="200"><input type="text" name="syslct" id="syslct" maxlength="256" class="text" value="<%=sysloc%>" onkeypress="return avoidSpace(event)" onmouseover="setTitle(this)" onfocusout="validateLengthRange('syslct',false,1,256,'System Location')"></td>
                  </tr>
                  <tr>
                     <td>SNMP Port</td>
                     <td><input type="text" class="text" id="agent_port" name="agent_port" value="161" min="1" max="65535" readonly></td>
                  </tr>
               </tbody>
            </table>
            <br>
            <p class="style5" align="center">SNMP v1 and v2c Settings</p>
            <br>
            <table class="borderlesstab" style="width:420px;" align="center" id="WiZConf">
               <tbody>
                  <tr>
                     <th width="200">Parameters</th>
                     <th width="200">Configuration</th>
                  </tr>
                  <tr>
                     <td width="200">Read Community</td>
                      <%String readval=readcomm!=null ?(!readcomm.containsKey("community")?"":readcomm.getString("community")):"";%>
                     <td width="200"><input type="text" name="rdcmty" id="rdcmty" maxlength="32" class="text" onmouseover="setTitle(this)" value="<%=readval%>" onkeypress="return avoidSpace(event)" onfocusout="validateLengthRange('rdcmty',false,1,32,'Read Community')"></td>
                  </tr>
                  <tr>
                     <td width="200">Write Community</td>
                      <%String writeval=writecomm!=null ?(!writecomm.containsKey("community")?"":writecomm.getString("community")):"";%>
                     <td width="200"><input type="text" name="wrcmty" id="wrcmty" maxlength="32" class="text" onmouseover="setTitle(this)" value="<%=writeval%>" onkeypress="return avoidSpace(event)" onfocusout="validateLengthRange('wrcmty',false,1,32,'Write Community')"></td>
                  </tr>
               </tbody>
            </table>
            <br>
                  <p class="style5" align="center">SNMP v3 Settings</p>
            <br>
            <table class="borderlesstab" style="width:420px;" align="center" id="WiZConf">
               <tbody>
                  <tr>
                     <th width="200">Parameters</th>
                     <th width="200">Configuration</th>
                  </tr>
                  <tr>
                     <td width="200">User</td>
                     <%String userval=userobj!=null ?(!userobj.containsKey("v3user")?"":userobj.getString("v3user")):"";%>
                     <td width="200"><input type="text" name="user" id="user" maxlength="256" class="text" onmouseover="setTitle(this)" value="<%=userval%>" onkeypress="return avoidSpace(event)"></td>
                  </tr>
                  <tr>
                     <td width="200">Security Mode</td>
                     <td width="200">
                     <%String mode=userobj!=null ?(!userobj.containsKey("level")?"":userobj.getString("level")):"";%>
                        <select class="text" name="secmode" id="secmode" onchange="displayMode('secmode')">
                           <option value="priv" <%if(mode.equals("priv")){%>selected<%}%>>authPriv</option>
                           <option value="auth" <%if(mode.equals("auth")){%>selected<%}%>>authNoPriv</option>
                           <option value="noauth" <%if(mode.equals("none")){%>selected<%}%>>noAuthNoPriv</option>
                        </select>
                     </td>
                  </tr>
                  <tr id="authrow"  name="authrow" style="display: none;">
                     <td width="200">Authentication</td>
                     <td width="200">
                      <%String authval=userobj!=null ?(!userobj.containsKey("authentication")?"":userobj.getString("authentication")):"";%>
                        <select class="text" name="authentication" id="authentication">
                           <option value="MD5" <%if(authval.equals("MD5")){%>selected<%}%>>MD5</option>
                           <option value="SHA" <%if(authval.equals("SHA")){%>selected<%}%>>SHA</option>
                        </select>
                     </td>
                  </tr>
                  <tr id="encryptrow" name="encryptrow" style="display: none;">
                     <td width="200">Encryption</td>
                     <td width="200">
                     <%String encryval=userobj!=null ?(!userobj.containsKey("encryption")?"":userobj.getString("encryption")):"";%>
                        <select class="text" name="encryption" id="encryption">
                           <option value="DES" <%if(encryval.equals("DES")){%>selected<%}%>>DES</option>
                          <%--  <option value="AES" <%if(encryptrow.equals("AES")){%>selected<%}%>>AES</option> --%>
                        </select>
                     </td>
                  </tr>
                  <tr id="apassrow" style="display: none;">
                     <td width="200">Authentication Password</td>
                     <td width="200">
                     <%String authpwd=userobj!=null ?(!userobj.containsKey("authpass")?"":userobj.getString("authpass")):"";%>
                     <input type="password" name="authpwd" id="authpwd" maxlength="256" class="text" value="<%=authpwd%>" onkeypress="return avoidSpace(event)" onkeyup="checkPwdStrength('authpwd','authstr')" onfocusout="pwdCheck('authpwd','Snmp')"><span toggle="#password-field" class="fa fa-fw fa-eye field_icon toggle1-password"></span>
                    <img  src="images/i_sym.jpg" alt="i" width="15" height="10" title="Info" id="authpwdshow" style="cursor:pointer" onclick="showOrHidePWDInfo('authpwdinfo')"/>
					<dialog id="authpwdinfo" class="Popup" style="width:15%;border:1px dotted black;">  
						<p>Password must contain:</p><p>&#8226;Minimum 8 Characters</p><p>&#8226;One Numeric(0-9)</p><p>&#8226;One Uppercase Letter(A-Z)</p>
						<p>&#8226;One Lowercase Letter(a-z)</p><p>&#8226;One Special Character</p><p>&#8226;Excluded characters " ' : ? ;</p>
                     </dialog>
                     <p id="authstr"></p>
                     </td>
                  </tr>
                  <tr id="epassrow" style="display: none;">
                     <td width="200">Encryption Password</td>
                     <td width="200">
                     <%String encrypwd=userobj!=null ?(!userobj.containsKey("encryptpass")?"":userobj.getString("encryptpass")):"";%>
                     <input type="password" name="encrypwd" id="encrypwd" maxlength="256" class="text" value="<%=encrypwd%>" onkeypress="return avoidSpace(event)" onkeyup="checkPwdStrength('encrypwd','encrystr')" onfocusout="pwdCheck('encrypwd','Snmp')"><span toggle="#password-field" class="fa fa-fw fa-eye field_icon toggle2-password"></span>
                     <img  src="images/i_sym.jpg" alt="i" width="15" height="10" title="Info" id="encrypwdshow" onclick="showOrHidePWDInfo('encrypwdinfo')"/>
					 <dialog id="encrypwdinfo" class="Popup" style="width:15%;border:1px dotted black;">  
						<p>Password must contain:</p><p>&#8226;Minimum 8 Characters</p><p>&#8226;One Numeric(0-9)</p><p>&#8226;One Uppercase Letter(A-Z)</p>
						<p>&#8226;One Lowercase Letter(a-z)</p><p>&#8226;One Special Character</p><p>&#8226;Excluded characters " ' : ? ;</p>
					</dialog>  
                     <p id="encrystr"></p>
                     </td>
                  </tr>
               </tbody>
            </table>
         </div>
         <div id="trapspage" align="center" style="margin: 0px; display: none;">
            <table class="borderlesstab" style="width:420px;" align="center" id="WiZConf">
               <tbody>
                  <tr>
                     <th width="200">Parameters</th>
                     <th width="200">Configuration</th>
                  </tr>
                  <tr>
                     <td>Trap Version</td>
                     <td>
                     <select id="trapVersion" name="trapVersion" multiple="multiple" style="display:none" onchange="selectedTrapVersions()">
                              <option value="v1" <%if(trapver.contains("v1")){%>selected<%}%>>v1</option>
                              <option value="v2c" <%if(trapver.contains("v2c")){%>selected<%}%>>v2</option>
                              <option value="usm" <%if(trapver.contains("usm")){%>selected<%}%>>v3</option>
                              <option value="all" <%if(trapver.contains("all")){%>selected<%}%>>All</option>
                           </select>
                     </td>
                  </tr>
                  <tr>
                     <td>Trap Community</td>
                     <%String trapcomval=trapcomm!=null ?(!trapcomm.containsKey("community")?"":trapcomm.getString("community")):"";%>
                     <td><input type="text" name="trapcmty" id="trapcmty" maxlength="32" class="text" onmouseover="setTitle(this)" value="<%=trapcomval%>" onkeypress="return avoidSpace(event)" onfocusout="validateLengthRange('trapcmty',false,1,32,'Trap Community')"></td>
                  </tr>
                  <tr>
                     <td>Trap Port</td>
                     <td><input type="text" class="text" id="trap_port" name="trap_port" value="162" min="1" max="65535" ></td>
                  </tr>
               </tbody>
            </table>
            <br>
            <p class="style5" align="center">Traps</p>
            <br>
            <table class="borderlesstab" style="width:420px;" align="center" id="WiZConf">
               <tbody>
                  <tr>
                     <th width="200">Parameters</th>
                     <th width="200">Configuration</th>
                  </tr>
                  <tr>
                     <td>Cold Start</td>
                     <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="coldstart" id="coldstart"   style="vertical-align:middle" onclick="alwaysEnable('coldstart')" ><span class="slider round"></span></label></td>
                  </tr>
                  <tr>
                     <td>Authentication</td>
                     <%if(trapauthobj.containsKey("enable"))
						authact = trapauthobj.getString("enable").equals("1")?"checked":""; %>
                     <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="authtrapenable" id="authtrapenable" style="vertical-align:middle" onclick="alwaysEnable('authtrapenable')"><span class="slider round"></span></label></td>
                  </tr>
                  <tr>
                     <td>Link Up/Down</td>
                     <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="linkUpDownNotifications" id="linkUpDownNotifications"  style="vertical-align:middle" onclick="alwaysEnable('linkUpDownNotifications')"><span class="slider round"></span></label></td>
                  </tr>
               </tbody>
            </table>
            <br>
            <p class="style5" align="center">Manager Configuration</p>
            <br>
            <table class="borderlesstab" style="width:420px;" align="center" id="managerconf">
               <tbody>
                  <tr>
                     <th width="200">Parameters</th>
                     <th width="200">Configuration</th>
                  </tr>
                  <tr>
                     <td>Activation</td>
                     <%if(snmpdef.containsKey("trapActivation"))
						trapact = snmpdef.getString("trapActivation").equals("1")?"checked":""; %>
                     <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="trapActvtn" id="trapActvtn" <%=trapact%> style="vertical-align:middle"><span class="slider round"></span></label></td>
                  </tr>
                   <tr>
                     <td>Manager</td>
                     <%String manager=snmpdef!=null ?(!snmpdef.containsKey("host")?"":snmpdef.getString("host")):"";%>
                     <td><input type="text" name="manager" id="manager" maxlength="32" class="text" onmouseover="setTitle(this)" value="<%=manager%>" onkeypress="return avoidSpace(event)" onfocusout="validatedualIP('manager',false,'Manager',false)"></td>
                  </tr>
               </tbody>
            </table>
         </div>
         <div align="center"><input type="submit" name="Apply" value="Apply" style="display:inline block" class="button"></div>
      </form>
      <script>
      <%if(errorstr.trim().length() > 0)
      {%>
    	  alert('<%=errorstr%>');
      <%}%>
	  showDivision('systempage');
	  displayMode('secmode');  
	  alwaysEnable('coldstart');
	  alwaysEnable('authtrapenable');
	  alwaysEnable('linkUpDownNotifications');
	  selectedSnmpVersions();
	  selectedTrapVersions();
	  </script>
   </body>
</html>