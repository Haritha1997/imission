<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="com.nomus.staticmembers.Symbols"%>
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
   JSONObject remotepingobj = null;
   JSONObject  rempriobj = null;
   JSONObject  remsecobj = null;
   JSONObject remconfigobj=null;
   BufferedReader jsonfile = null;   
   String slnumber=request.getParameter("slnumber");
   String errorstr = request.getParameter("error");
   String version=request.getParameter("version");
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
		remotepingobj =  wizjsonnode.getJSONObject("remoteping");
 		rempriobj=remotepingobj.getJSONObject("remoteping:primary");
		remsecobj=remotepingobj.getJSONObject("remoteping:secondary");
		remconfigobj=remotepingobj.getJSONObject("remoteping:configinfo");
		
  } catch(Exception e)
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
   <title>Remote Connectivity Check</title>
      <link rel="stylesheet" href="css/fontawesome.css">
      <link rel="stylesheet" href="css/fontawesome.css">
      <link rel="stylesheet" href="css/solid.css">
      <link rel="stylesheet" href="css/v4-shims.css">
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
     <script type="text/javascript" src="js/common.js"></script>
	  <style type="text/css">
	   .caret {
	position: absolute;
	left: 90%;
	top: 40%;
	vertical-align: middle;
	border-top: 6px solid;
}

#act_icon {
	padding-right: 10;
	color: #7B68EE;
	cursor: pointer;
}

#new_icon {
	padding-right: 10;
	color: green;
	cursor: pointer;
}

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

a,
a:hover {
	color: black;
	text-decoration: none;
}
p{
padding:10px;
}
	  </style>
	  <script type="text/javascript">  
	  function showErrorMsg(errormsg)
	  {
	  	alert(errormsg);
	  }
	  var old_secintf = "cellular";
	  function setSecondaryInterface()
	  {
			var priintf = document.getElementById("pinterface").value;
			var secintfobj = document.getElementById("sinterface");
			var secintf = secintfobj.value;
			if(priintf !="cellular")
			{
				secintfobj.value="cellular";
				old_secintf = "cellular"
			}
			 else
			 {
				 if(secintf=="cellular")
				 {
					 if(old_secintf == "cellular")
					 {
						secintfobj.value = "eth1";
						old_secintf = "eth1";
					 }
					 else
					    secintfobj.value = old_secintf;
				 }
				 else
				   old_secintf = secintf;
			 }
	  }  
	  function validateTargetConCheck()
	  {
		var altmsg = "";
		var check_empty = true;
		var enable = document.getElementById("ena/dis");
		var priintf = document.getElementById("pinterface").value;
		var secintf = document.getElementById("sinterface").value;
		var ipadd1 = document.getElementById("remip1").value;
		var ipadd2 = document.getElementById("remip2").value;
		if(!enable.checked)
			check_empty = false;
		if(priintf == secintf)
			altmsg+="Primary Interface and Secondary Interface should not be same\n";
		var valid = validateIPOnly("remip1", check_empty, "Target IP1");
		var ip1valid = valid;
		if(!valid)
		{
			if(ipadd1.trim().length==0)
				altmsg+="Target IP1 should not be empty\n";
			else
				altmsg+="Target IP1 is not valid\n";
		}
		valid = validateIPOnly("remip2", false, "Target IP2");
		if(!valid)
			altmsg+="Target IP2 is not valid\n";
		if(ipadd1 == ipadd2 && ip1valid && ipadd1.length>0 && ipadd2.length>0)
			altmsg+="Target IP1 TargetIP2 should not be same\n";
		
		
		if(altmsg.length > 0)
		{
			alert(altmsg);
			return false;
		}
		return true;
	  }
function showOrHidePrimSecIntf(){
	var  selobj=document.getElementById("actfail");
	var field1obj = document.getElementById("priintrow");
	var field2obj = document.getElementById("secintrow");
	if(selobj.value != "Fallback"){
		field1obj.style.display = "none";
		field2obj.style.display = "none";
	}else{
		field1obj.style.display = "";
		field2obj.style.display = "";
	}
	//showOrHideTargetip2();	
}
/* function showOrHideTargetip2(){
	var  selobj=document.getElementById("actfail");
	var ipobj = document.getElementById("tarip2");
	if(selobj.value == "Fallback")
		ipobj.style.display = "none";
	else
		ipobj.style.display = "";
} */
function setActivtyOptions(){
	var healthchkobj  = document.getElementById("healthchkon");
	var actonfailobj=document.getElementById("actfail");
	var oldvalue =  actonfailobj.value;
	for (var i=actonfailobj.length-1; i>=0; i--)  
        actonfailobj.remove(i);
	var actarr = ['Reboot','Reconnect','SIMShift','Fallback'];
    for(i=0;i<actarr.length;i++){	  
		let option = new Option(actarr[i],actarr[i],actarr[i]);
		if(actarr[i] != 'SIMShift' && actarr[i] != 'Fallback'&&actarr[i]!='Reconnect')
			actonfailobj.appendChild(option);
		else if((healthchkobj.value == "Cellular" && actarr[i] == 'SIMShift') || (healthchkobj.value == "All" && actarr[i] == 'Fallback')|| (healthchkobj.value != "All" && actarr[i] == 'Reconnect'))
			actonfailobj.appendChild(option);}
	
	var childs = actonfailobj.childNodes;
	for(i=0;i<childs.length;i++){
		if(childs[i].value==oldvalue){
			actonfailobj.value = oldvalue;
			break;}}
	showOrHidePrimSecIntf();
}
</script>
	</head>
	<% String enabled =""; %>
   <body>
      <div align="center">
	   <p class="style5" align="center">Remote Connectivity Check</p>
	  <form action="savedetails.jsp?page=healthcheck&slnumber=<%=slnumber%>&version=<%=version%>"   method="post"  onsubmit="return validateTargetConCheck()">
          <table id="Remote" class="borderlesstab" style="width:600px;" align="center">
					<thead>
                     <tr>
                        <th width="300px">Parameters</th>
                        <th width="300px">Configuration</th>
                     </tr>
					  </thead>
					 
                  <tbody>
                    <tr>
                    <%if(remconfigobj.containsKey("enabled"))
                    	enabled = remconfigobj.getString("enabled").equals("on")?"checked":""; %>
                        <td>Activation</td>
                        <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="ena/dis" id="ena/dis" style=
						"vertical-align:middle" <%=enabled%>><span class="slider round"></span></label></td>
                     </tr>
					<tr>
                        <td>Health Check On</td>
                        <% String healthcheckon =  remconfigobj!=null? (!remconfigobj.containsKey("healthchkon")?"":remconfigobj.getString("healthchkon")):""; 
                        %>
                        <td>
                           <select class="text" id="healthchkon" name="healthchkon" onclick="setActivtyOptions()">
                              <option value="Cellular" <%if(healthcheckon.equals("Cellular")){%>selected<%} %>>Cellular</option>
							  <% if(version.trim().startsWith(Symbols.WiZV2+Symbols.EL))
        						{
				   				%>
							  <option value="Ethernet" <%if(healthcheckon.equals("Ethernet")){%>selected<%} %>>Eth1</option>
							 <%--  <option value="Dialer" <%if(healthcheckon.equals("Dialer")){%>selected<%} %>>Dialer</option> --%>
							  <option value="All" <%if(healthcheckon.equals("All")){%>selected<%} %>>All</option>
							   <%}%>
                           </select>
                        </td>
                     </tr>
					  <tr>
                        <td>Activity On Failure</td>
                         <% String activityon =  remconfigobj!=null? (!remconfigobj.containsKey("action")?"":remconfigobj.getString("action")):""; %>
                        <td>						
                           <select class="text" id="actfail" name="actfail" onclick="showOrHidePrimSecIntf()" onchange="optionValues()">
                              <option value="Reboot" <%if(activityon.equals("Reboot")){%>selected<%} %>>Reboot</option>
							  <option value="Reconnect" <%if(activityon.equals("Reconnect")){%>selected<%} %>>Reconnect</option>
							  <option value="SIMShift" <%if(activityon.equals("SIMShift")){%>selected<%} %>>SIMShift</option>
							  <option value="Fallback" <%if(activityon.equals("Fallback")){%>selected<%} %>>Fallback</option>
                           </select>
                        </td>
                     </tr>

					 <tr id="priintrow">
                        <td>Primary Interface</td>
                         <% String priint =  remconfigobj!=null? (!remconfigobj.containsKey("primary")?"":remconfigobj.getString("primary")):""; %>
                        <td>
                           <select class="text" id="pinterface" name="pinterface" onchange="setSecondaryInterface()">
                              <option value="cellular" <%if(priint.equals("cellular")){%>selected<%} %>>Cellular</option>
							  <option value="eth1" <%if(priint.equals("eth1")){%>selected<%} %>>Eth1</option>
							  <%-- <option value="dialer" <%if(priint.equals("dialer")){%>selected<%} %>>Dialer</option> --%>
                           </select>
                        </td>
                     </tr>

					 <tr id="secintrow">
                        <td>Secondary Interface</td>
                         <% String secint =  remconfigobj!=null? (!remconfigobj.containsKey("secondary")?"":remconfigobj.getString("secondary")):""; %>
                        <td>
                           <select class="text" id="sinterface" name="sinterface" onchange="setSecondaryInterface()">
							  <option value="eth1" <%if(secint.equals("eth1")){ %>selected<%} %>>Eth1</option>
                              <option value="cellular" <%if(secint.equals("cellular")){%>selected<%} %>>Cellular</option>
							 <%--  <option value="dialer" <%if(secint.equals("dialer")){%>selected<%} %>>Dialer</option> --%>
                           </select>
                        </td>
                     </tr>					 
					 <tr>
                        <td>Target IP1</td>
                        <% String remip1 =  remconfigobj!=null? (!remconfigobj.containsKey("remote1")?"":remconfigobj.getString("remote1")):""; %>
                        <td><input type="text" name="remip1" value="<%=remip1%>" id="remip1" class="text" onkeypress="return avoidSpace(event)" placeholder="A.B.C.D" onfocusout="validateIPOnly('remip1',true,'Target IP1')"></td>
                     </tr>
					 <tr id="tarip2">
                        <td>Target IP2</td>
                        <% String remip2 =  remconfigobj!=null? (!remconfigobj.containsKey("remote2")?"":remconfigobj.getString("remote2")):""; %>
                        <td><input type="text" name="remip2" value="<%=remip2%>" id="remip2" class="text" onkeypress="return avoidSpace(event)" placeholder="A.B.C.D" onfocusout="validateIPOnly('remip2',false,'Target IP2')"></td>
                     </tr>			
					 <tr>
					 <td> Interval(Sec)</td>
					 <% String reminte =  remconfigobj!=null? (!remconfigobj.containsKey("interval")?"":remconfigobj.getString("interval")):""; %>
					  <td><input type="number" id="interval" name="interval" value="<%=reminte%>" min="0" max="30" onkeypress="return avoidSpace(event)"></td>
					 </tr>
					 <tr>
					 <td> TimeOut(Sec)</td>
					  <% String remtime =  remconfigobj!=null? (!remconfigobj.containsKey("timeout")?"":remconfigobj.getString("timeout")):""; %>
					  <td><input type="number" id="tout" value="<%=remtime%>" name="tout"  min="0" max="60" onkeypress="return avoidSpace(event)"></td>
					 </tr>
					 <tr>
					 <td> No.of Cycles</td>
					  <% String cycles =  remconfigobj!=null? (!remconfigobj.containsKey("cycles")?"":remconfigobj.getString("cycles")):""; %>
					  <td><input type="number" id="cycles" name="cycles" value="<%=cycles%>"   min="0" max="99" onkeypress="return avoidSpace(event)"></td>
					 </tr>
					 <tr>
                        <td>Success Percentage</td>
                         <% String successper =  remconfigobj!=null? (!remconfigobj.containsKey("success")?"":remconfigobj.getString("success")):""; %>
                        <td>
                           <select class="text" id="susper" name="susper">
                              <option value="20" <%if(successper.equals("20")){ %>selected<%} %>>20</option>
							  <option value="40" <%if(successper.equals("40")){ %>selected<%} %>>40</option>
							  <option value="60" <%if(successper.equals("60")){ %>selected<%} %>>60</option>
							  <option value="70" <%if(successper.equals("70")){ %>selected<%} %>>70</option>
							  <option value="80" <%if(successper.equals("80")){ %>selected<%} %>>80</option>
							  <option value="90" <%if(successper.equals("90")){ %>selected<%} %>>90</option>
                           </select>
                        </td>
                     </tr>					 
					 </tbody>
        </table> 
<div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button">
</div>
</form> 
</div>	
</body>
 <%
   	if(errorstr != null && errorstr.trim().length() > 0)
			{%>
		     <script>
			 showErrorMsg('<%=errorstr%>');
			 </script>
			<%}%>
<script>
showOrHidePrimSecIntf();
setActivtyOptions();
</script>
</html>	
					 