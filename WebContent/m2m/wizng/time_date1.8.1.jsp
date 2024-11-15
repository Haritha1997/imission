<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="net.sf.jasperreports.data.cache.DateStore"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject timedate_configobj = null;
   int dateint=0;
   int month=0;
   int year=0;
   int hours=0;
   int min=0;
   int sec=0;
   String time_synctype="None";
   String date_str="";
   String time_str="";
   JSONArray ntpnumarr = null;
   int ntp_srno=0;
   String ntp_srvrtyp="No Change";
   String ntp_ipaddrs="";
   String ntp_dmnname="";
   String ntp_syncintrvl="";
   BufferedReader jsonfile = null;   
   		String slnumber=request.getParameter("slnumber");
		String errorstr = request.getParameter("error");
		String fwversion = request.getParameter("version");
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
   		
   		//System.out.print(wizjsonnode);
   		timedate_configobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("TIMEDATE");
   		time_synctype=timedate_configobj.getString("Time Sync Type");
		dateint=timedate_configobj.getInt("Date");
		month=timedate_configobj.getInt("Month");
		year=timedate_configobj.getInt("Year");
		hours=timedate_configobj.getInt("Hours");
		min=timedate_configobj.getInt("Min");
		sec=timedate_configobj.getInt("Sec");
		String yearstr=year+"";
		
		if(yearstr.length()<4)
		{
			for(int i=4;i>yearstr.length();i--)
			{
				yearstr="0"+yearstr;
			}
		}
        			
		date_str=(dateint<10?"0"+dateint:dateint)+"/"+(month<10?"0"+month:month)+"/"+yearstr;
		time_str=(hours<10?"0"+hours:hours)+":"+(min<10?"0"+min:min)+":"+(sec<10?"0"+sec:sec);
		
		if(date_str.startsWith("00"))
		{
			date_str="";
		}
		if(time_str.equals("00:00:00"))
		{
			time_str="";
		}

		ntpnumarr = timedate_configobj.getJSONArray("NTP")==null ? new JSONArray(): timedate_configobj.getJSONArray("NTP");
		ntp_syncintrvl=timedate_configobj.getString("NTP Sync Intervel (sec)")==null?"":timedate_configobj.getString("NTP Sync Intervel (sec)");
		if(ntp_syncintrvl.equals("0"))
		{
			ntp_syncintrvl="";
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
<head>
   <script src="js/jquery-1.4.2.min.js"></script>
   <link rel="stylesheet" href="css/timepicker/bootstrap.min.css">
   <link rel="stylesheet" href="css/timepicker/bootstrap-datetimepicker.min.css">
   <script src="js/timepicker/jquery.min.js"></script>
   <script src="js/timepicker/bootstrap.min.js"></script>
   <script src="js/timepicker/moment-with-locales.min.js"></script>
   <script src="js/timepicker/bootstrap-datetimepicker.min.js"></script>
<style type="text/css">
#WiZConf {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 600px;
}

#WiZConf td,
#WiZConf th {
	border: 2px solid #ddd;
	padding: 8px;
	text-align: center;
}

#WiZConf tr:nth-child(even) {
	background-color: #f2f2f2;
}

#WiZConf tr:hover {
	background-color: #d3f2ef;
}

#WiZConf th {
	padding-top: 12px;
	padding-bottom: 12px;
	text-align: center;
	background-color: #5798B4;
	color: white;
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

.button {
	display: block;
	border-radius: 6px;
	background-color: #6caee0;
	color: #ffffff;
	font-weight: bold;
	box-shadow: 1px 2px 4px 0 rgba(0, 0, 0, 0.08);
	padding: 12px 20px;
	border: 0;
	margin: 40px 183px 0;
}

.style1 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	color: #5798B4;
	font-size: 16px;
	font-weight: bold;
}

td #borderless {
	border: none;
	padding: 0 0 0 0;
}
</style>
<script type="text/javascript">
$(function () {
	$('#datePicker').datetimepicker({
		pickTime: false,
		format: "DD/MM/YYYY"
	});
});
$(function () {
	$('#timePicker').datetimepicker({
		pickDate: false,
		format: 'H:m:s',
		pick12HourFormat: false,
		useSeconds: true
	});
}); 
</script>
<script type="text/JavaScript">
function validate(id, ip, name) {
	var value = document.getElementById(id).value;
	var addr = document.getElementById(ip);
	var domain = document.getElementById(name);
	if (value == "IP Address")
	{
		domain.disabled =true;
		domain.style.backgroundColor = "#808080";
		domain.style.outline = "initial"; 
		addr.disabled = false; 
		addr.style.backgroundColor = "#ffffff"; 
		addr.style.outline = "initial"; 
		domain.value = "";
	}
	else if (value == "Domain Name") {
		domain.disabled = false;
		domain.style.backgroundColor = "#ffffff";
		domain.style.outline = "initial";
		addr.disabled = true;
		addr.style.backgroundColor = "#808080";
		addr.style.outline = "initial";
		addr.value = "";
	} else if (value == "No Change") {
		addr.disabled = false;
		addr.style.backgroundColor = "#808080";
		addr.style.outline = "initial";
		domain.disabled = false;
		domain.style.backgroundColor = "#808080";
		domain.style.outline = "initial";
		addr.value = "";
		domain.value = "";
	}
}
function AvoidSpace(event) {
	var k = event ? event.which : window.event.keyCode;
	if ((k >= 65 && k <= 90) || (k >= 97 && k <= 122) || (k == 46) || (k == 45) || (k == 8) || (k == 9) || (k == 13) || (k >= 48 && k <= 57)) return true;
	else return false;
}

function IPv4AddressKeyOnly(e) {
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	if ((keyCode == 46 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode >= 48 && keyCode <= 57)) {
		return true;
	}
	return false;
}
function addNtpData(id,slno,type,ipadrs,dmnname)
{
    document.getElementById("slno"+id).innerHTML=slno;
    document.getElementById("Type"+id).value=type;
    document.getElementById("serverIP"+id).value=ipadrs;
    document.getElementById("servername"+id).value=dmnname;
}
function dateandtime() 
{
	var type = document.getElementById("type").value;
	var addrow1 = document.getElementById("addrow1");
	var addrow2 = document.getElementById("addrow2");
	var addrow3 = document.getElementById("addrow3");
	var ntprow1 = document.getElementById("ntprow1");
	var ntprow2 = document.getElementById("ntprow2");
	var ntprow3 = document.getElementById("ntprow3");
	var ntprow4 = document.getElementById("ntprow4");
	var ntprow5 = document.getElementById("ntprow5");
	var ntprow6 = document.getElementById("ntprow6");
	if (type == "Manual") 
	{
		addrow1.style.display = "";
		addrow2.style.display = "";
		addrow3.style.display = "";
		ntprow1.style.display = "none";
		ntprow2.style.display = "none";
		ntprow3.style.display = "none";
		ntprow4.style.display = "none";
		ntprow5.style.display = "none";
		ntprow6.style.display = "none";
	} 
	else if (type == "NTP") 
	{
		addrow1.style.display = "none";
		addrow2.style.display = "none";
		addrow3.style.display = "none";
		ntprow1.style.display = "";
		ntprow2.style.display = "";
		ntprow3.style.display = "";
		ntprow4.style.display = "";
		ntprow5.style.display = "";
		ntprow6.style.display = "";
	} 
	else 
	{
		addrow1.style.display = "none";
		addrow2.style.display = "none";
		addrow3.style.display = "none";
		ntprow1.style.display = "none";
		ntprow2.style.display = "none";
		ntprow3.style.display = "none";
		ntprow4.style.display = "none";
		ntprow5.style.display = "none";
		ntprow6.style.display = "none";
	}
}
function validateIPByAddress(ipaddr, checkempty) {
	var ipformat = /^(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)$/;
	if (ipaddr == "") {
		if (!checkempty) return true;
		else {
			return false;
		}
	}
	if (ipaddr.match(ipformat) && ipaddr != "0.0.0.0") {
		return true;
	} else {
		return false;
	}
}

function checkdomain(id1, id2) {
	var domain = document.getElementById(id1);
	var altmsg = "";
	if (domain.value == "") {
		domain.style.outline = "thin solid red";
		altmsg += id2 + " should not be empty.\n";
		return altmsg;
	} else {
		domain.style.outline = "initial";
		return altmsg;
	}
}

function checkip(id1, id2) {
	var ipele = document.getElementById(id1);
	var altmsg = "";
	var valid = validateIPByAddress(document.getElementById(id1).value, true);
	if (!valid) {
		ipele.style.outline = "thin solid red";
		if (ipele.value == "") altmsg += id2 + " should not be empty.\n";
		else altmsg += id2 + " is not valid.\n";
		return altmsg;
	} else return altmsg;
}

function validatentp_config() {
	var ipele;
	var altmsg = "";
	var valid = "";
	var domain = "";
	var typeoobj = document.getElementById("type").value;
	if (typeoobj == "Manual") return true;
	else if (typeoobj == "NTP") {
		var Type1 = document.getElementById("Type1").value;
		var Type2 = document.getElementById("Type2").value;
		var Type3 = document.getElementById("Type3").value;
		var Type4 = document.getElementById("Type4").value;
		var id_arr = ["serverIP1", "serverIP2", "serverIP3", "serverIP4"];
		var name_arr = ["Server 1 IP Address", "Server 2 IP Address", "Server 3 IP Address", "Server 4 IP Address"];
		var domain_id_arr = ["servername1", "servername2", "servername3", "servername4"];
		var domain_name_arr = ["Server 1 Domain Name", "Server 2 Domain Name", "Server 3 Domain Name", "Server 4 Domain Name"];
		if (Type1 == "IP Address") altmsg += checkip(id_arr[0], name_arr[0]);
		else if (Type1 == "Domain Name") altmsg += checkdomain(domain_id_arr[0], domain_name_arr[0]);
		if (Type2 == "IP Address") altmsg += checkip(id_arr[1], name_arr[1]);
		else if (Type2 == "Domain Name") altmsg += checkdomain(domain_id_arr[1], domain_name_arr[1]);
		if (Type3 == "IP Address") altmsg += checkip(id_arr[2], name_arr[2]);
		else if (Type3 == "Domain Name") altmsg += checkdomain(domain_id_arr[2], domain_name_arr[2]);
		if (Type4 == "IP Address") altmsg += checkip(id_arr[3], name_arr[3]);
		else if (Type4 == "Domain Name") altmsg += checkdomain(domain_id_arr[3], domain_name_arr[3]);
		if(Type1 == "No Change" && Type2 == "No Change" && Type3 == "No Change" && Type4 == "No Change")
		{
			altmsg +="Please Configure atleast One Server Type";
		}
		if (altmsg != "") {
			alert(altmsg);
			return false;
		} else return true;
	}
}

function validateIP(id, checkempty, name) {
	var ipele = document.getElementById(id);
	if (ipele.readOnly == true) {
		ipele.style.outline = "initial";
		ipele.title = "";
		return;
	}
	var ipformat = /^(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)$/;
	var ipaddr = ipele.value;
	if (ipaddr == "") 
	{
		if (checkempty) 
		{
			ipele.style.outline = "thin solid red";
			ipele.title = name + " should not be empty";
		} 
		else 
		{
			ipele.style.outline = "initial";
			ipele.title = "";
		}
	} else if (!ipaddr.match(ipformat)) {
		ipele.style.outline = "thin solid red";
		ipele.title = "Invalid " + name;
	} else {
		ipele.style.outline = "initial";
		ipele.title = "";
	}
}
function showErrorMsg(errormsg)
{
	alert(errormsg);
}
</script>
</head>
<body>
   <form name="f1" action="savepage.jsp?page=time_date&slnumber=<%=slnumber%>&version=<%=fwversion%>" onsubmit="return validatentp_config()" method="post">
      <br>
      <p class="style1" align="center">Clock Configuration</p>
      <br>
      <table id="WiZConf" align="center">
         <tbody>
            <tr>
               <th width="200">Parameters</th>
               <th colspan="2" width="400">Values</th>
            </tr>
            <tr>
               <td>Time Sync Type</td>
               <td style="width: 180px;"><%=time_synctype%></td>
               <td>
                  <select name="type" id="type" class="text" onchange="dateandtime()">
                     <option value="None" <%if(time_synctype.equals("None")){%>selected<%}%>>None</option>
                     <option value="Manual" <%if(time_synctype.equals("Manual")){%>selected<%}%>>Manual</option>
                     <option value="NTP" <%if(time_synctype.equals("NTP")){%>selected<%}%>>NTP</option>
                  </select>
               </td>
            </tr>
         </tbody>
      </table>
      <br><br>
      <table id="WiZConf" align="center">
         <tbody>
            <tr id="addrow1" style="display: none;">
               <th width="200">Parameters</th>
               <th width="180">Current_Config</th>
               <th>Configuration</th>
            </tr>
            <tr id="addrow2" style="display: none;">
               <td>DD/MM/YYYY</td>
               <td style="min-width:150px"><%=date_str%></td>
               <td><input type="text" name="datePicker" id="datePicker" class="form-control" value="<%=date_str%>" readonly></td>
            </tr>
            <tr id="addrow3" style="display: none;">
               <td>HH:MM:SS</td>
               <td style="min-width:150px"><%=time_str%></td>
               <td><input type="text" name="timePicker" id="timePicker" class="form-control" value="<%=time_str%>" readonly></td>
            </tr>
         </tbody>
      </table>
      <table id="WiZConf" width="760" align="center">
         <tbody></tbody>
      </table>
      <table id="WiZConf" width="760" align="center">
         <tbody>
            <tr id="ntprow1" style="">
               <th width="10" align="center">Sr.No.</th>
               <th width="145" align="center">NTP Server Type</th>
               <th width="180" align="center"> IP Address</th>
               <th align="center">Domain Name</th>
            </tr>
            <tr id="ntprow2" style="">
               <td id="slno1"></td>
               <td>
                  <select name="Type0" id="Type1" onchange="validate('Type1','serverIP1','servername1')" align="center">
                     <option value="No Change">No Change</option>
                     <option value="IP Address">IP Address</option>
                     <option value="Domain Name">Domain Name</option>
                  </select>
               </td>
               <td>
			   <input class="text" name="serverIP0" value="" type="text" id="serverIP1" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)" onfocusout="validateIP('serverIP1',true,'Server 1 IP Address')" style="background-color: rgb(255, 255, 255); outline: initial;"></input>
			   </td>
               <td>
			   <input class="text" name="servername0" value="" type="text" id="servername1" maxlength="253" onkeypress="return AvoidSpace(event)" style="background-color: rgb(255, 255, 255); outline: initial;"></input>
			   </td>
            </tr>
            <tr id="ntprow3" style="">
               <td id="slno2"></td>
               <td>
                  <select name="Type1" id="Type2" onchange="validate('Type2','serverIP2','servername2')" align="center">
                     <option value="No Change">No Change</option>
                     <option value="IP Address">IP Address</option>
                     <option value="Domain Name">Domain Name</option>
                  </select>
               </td>
               <td>
			   <input class="text" name="serverIP1" value="" type="text" id="serverIP2" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)" onfocusout="validateIP('serverIP2',true,'Server 2 IP Address')" style="background-color: rgb(255, 255, 255); outline: initial;"></input>
			   </td>
               <td>
			   <input class="text" name="servername1" value="" type="text" id="servername2" maxlength="253" onkeypress="return AvoidSpace(event)" style="background-color: rgb(255, 255, 255); outline: initial;"></input>
			   </td>
            </tr>
            <tr id="ntprow4" style="">
               <td id="slno3"></td>
               <td>
                  <select name="Type2" id="Type3" onchange="validate('Type3','serverIP3','servername3')" align="center">
                     <option value="No Change">No Change</option>
                     <option value="IP Address">IP Address</option>
                     <option value="Domain Name">Domain Name</option>
                  </select>
               </td>
               <td>
			   <input class="text" name="serverIP2" value="" type="text" id="serverIP3" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)" onfocusout="validateIP('serverIP3',true,'Server 3 IP Address')" style="background-color: rgb(255, 255, 255); outline: initial;"></input>
			   </td>
               <td>
			   <input class="text" name="servername2" value="" type="text" id="servername3" maxlength="253" onkeypress="return AvoidSpace(event)" style="background-color: rgb(255, 255, 255); outline: initial;"></td>
            </tr>
            <tr id="ntprow5" style="">
               <td id="slno4"></td>
               <td>
                  <select name="Type3" id="Type4" onchange="validate('Type4','serverIP4','servername4')" align="center">
                     <option value="No Change">No Change</option>
                     <option value="IP Address">IP Address</option>
                     <option value="Domain Name">Domain Name</option>
                  </select>
               </td>
               <td>
			   <input class="text" name="serverIP3" value="" type="text" id="serverIP4" maxlength="15" onkeypress="return IPv4AddressKeyOnly(event)" onfocusout="validateIP('serverIP4',true,'Server 4 IP Address')" style="background-color: rgb(255, 255, 255); outline: initial;"></input>
			   </td>
               <td>
			   <input class="text" name="servername3" value="" type="text" id="servername4" maxlength="253" onkeypress="return AvoidSpace(event)" style="background-color: rgb(255, 255, 255); outline: initial;"></input>
			   </td>
            </tr>
            <tr id="ntprow6" style="">
               <td colspan="2">Sync Intervel(16-65535) (sec)</td>
               <td><%=ntp_syncintrvl%></td>
               <td><input type="number" name="ntpsync" id="ntpsync" class="text" min="16" max="65535" value="<%=ntp_syncintrvl%>" maxlength="6" ></input></td>
            </tr>
		<%
		 JSONObject ntpobj=null;
		 for(int j=0;j<ntpnumarr.size();j++)
         {
         ntpobj = ntpnumarr.getJSONObject(j);
         ntp_srno=ntpobj.getInt("sl");
		 ntp_srvrtyp=ntpobj.getString("NTP Server Type")==null?"No Change":ntpobj.getString("NTP Server Type");
		 ntp_ipaddrs=ntpobj.getString("IP Address");
		 ntp_dmnname=ntpobj.getString("Domain Name");
		%>
                   <script type="text/javascript">
	 				 
	  				 addNtpData('<%=(j+1)%>','<%=ntp_srno%>','<%=ntp_srvrtyp%>','<%=ntp_ipaddrs%>','<%=ntp_dmnname%>');
	 			 </script>
		<%}%>
         </tbody>
      </table>
      <div align="center"><input type="submit" value="Submit" class="button"></div>
   </form>
   <%if(errorstr != null && errorstr.trim().length() > 0)
			{%>
		     <script>
			 showErrorMsg('<%=errorstr%>');
			 </script>
			<%}
	  %>
   <script src="js/timeout.js" type="text/javascript"></script>
   <script type="text/javascript">
   dateandtime();
   validate('Type1','serverIP1','servername1');
   validate('Type2','serverIP2','servername2');
   validate('Type3','serverIP3','servername3');
   validate('Type4','serverIP4','servername4');
   </script>
   <script src="js/timeout.js" type="text/javascript"></script>
   <div class="bootstrap-datetimepicker-widget dropdown-menu">
      <div class="datepicker">
         <div class="datepicker-days" style="display: block;">
            <table class="table-condensed">
               <thead>
                  <tr>
                     <th class="prev">‹</th>
                     <th colspan="5" class="picker-switch">August 2021</th>
                     <th class="next">›</th>
                  </tr>
                  <tr>
                     <th class="dow">Su</th>
                     <th class="dow">Mo</th>
                     <th class="dow">Tu</th>
                     <th class="dow">We</th>
                     <th class="dow">Th</th>
                     <th class="dow">Fr</th>
                     <th class="dow">Sa</th>
                  </tr>
               </thead>
               <tbody>
                  <tr>
                     <td class="day old">25</td>
                     <td class="day old">26</td>
                     <td class="day old">27</td>
                     <td class="day old">28</td>
                     <td class="day old">29</td>
                     <td class="day old">30</td>
                     <td class="day old">31</td>
                  </tr>
                  <tr>
                     <td class="day">1</td>
                     <td class="day">2</td>
                     <td class="day">3</td>
                     <td class="day">4</td>
                     <td class="day">5</td>
                     <td class="day">6</td>
                     <td class="day">7</td>
                  </tr>
                  <tr>
                     <td class="day">8</td>
                     <td class="day">9</td>
                     <td class="day">10</td>
                     <td class="day">11</td>
                     <td class="day">12</td>
                     <td class="day">13</td>
                     <td class="day">14</td>
                  </tr>
                  <tr>
                     <td class="day">15</td>
                     <td class="day">16</td>
                     <td class="day">17</td>
                     <td class="day">18</td>
                     <td class="day">19</td>
                     <td class="day">20</td>
                     <td class="day">21</td>
                  </tr>
                  <tr>
                     <td class="day">22</td>
                     <td class="day">23</td>
                     <td class="day">24</td>
                     <td class="day">25</td>
                     <td class="day active today">26</td>
                     <td class="day">27</td>
                     <td class="day">28</td>
                  </tr>
                  <tr>
                     <td class="day">29</td>
                     <td class="day">30</td>
                     <td class="day">31</td>
                     <td class="day new">1</td>
                     <td class="day new">2</td>
                     <td class="day new">3</td>
                     <td class="day new">4</td>
                  </tr>
               </tbody>
            </table>
         </div>
         <div class="datepicker-months" style="display: none;">
            <table class="table-condensed">
               <thead>
                  <tr>
                     <th class="prev">‹</th>
                     <th colspan="5" class="picker-switch">2021</th>
                     <th class="next">›</th>
                  </tr>
               </thead>
               <tbody>
                  <tr>
                     <td colspan="7"><span class="month">Jan</span><span class="month">Feb</span><span class="month">Mar</span><span class="month">Apr</span><span class="month">May</span><span class="month">Jun</span><span class="month">Jul</span><span class="month active">Aug</span><span class="month">Sep</span><span class="month">Oct</span><span class="month">Nov</span><span class="month">Dec</span></td>
                  </tr>
               </tbody>
            </table>
         </div>
         <div class="datepicker-years" style="display: none;">
            <table class="table-condensed">
               <thead>
                  <tr>
                     <th class="prev">‹</th>
                     <th colspan="5" class="picker-switch">2020-2029</th>
                     <th class="next">›</th>
                  </tr>
               </thead>
               <tbody>
                  <tr>
                     <td colspan="7"><span class="year old">2019</span><span class="year">2020</span><span class="year active">2021</span><span class="year">2022</span><span class="year">2023</span><span class="year">2024</span><span class="year">2025</span><span class="year">2026</span><span class="year">2027</span><span class="year">2028</span><span class="year">2029</span><span class="year old">2030</span></td>
                  </tr>
               </tbody>
            </table>
         </div>
      </div>
   </div>
   <div class="bootstrap-datetimepicker-widget dropdown-menu">
      <div class="timepicker">
         <div class="timepicker-picker">
            <table class="table-condensed">
               <tbody>
                  <tr>
                     <td><a href="#" class="btn" data-action="incrementHours"><span class="glyphicon glyphicon-chevron-up"></span></a></td>
                     <td class="separator"></td>
                     <td><a href="#" class="btn" data-action="incrementMinutes"><span class="glyphicon glyphicon-chevron-up"></span></a></td>
                     <td class="separator"></td>
                     <td><a href="#" class="btn" data-action="incrementSeconds"><span class="glyphicon glyphicon-chevron-up"></span></a></td>
                  </tr>
                  <tr>
                     <td><span data-action="showHours" data-time-component="hours" class="timepicker-hour">18</span></td>
                     <td class="separator">:</td>
                     <td><span data-action="showMinutes" data-time-component="minutes" class="timepicker-minute">12</span></td>
                     <td class="separator">:</td>
                     <td><span data-action="showSeconds" data-time-component="seconds" class="timepicker-second">19</span></td>
                  </tr>
                  <tr>
                     <td><a href="#" class="btn" data-action="decrementHours"><span class="glyphicon glyphicon-chevron-down"></span></a></td>
                     <td class="separator"></td>
                     <td><a href="#" class="btn" data-action="decrementMinutes"><span class="glyphicon glyphicon-chevron-down"></span></a></td>
                     <td class="separator"></td>
                     <td><a href="#" class="btn" data-action="decrementSeconds"><span class="glyphicon glyphicon-chevron-down"></span></a></td>
                  </tr>
               </tbody>
            </table>
         </div>
         <div class="timepicker-hours" data-action="selectHour" style="display: none;">
            <table class="table-condensed">
               <tr>
                  <td class="hour">00</td>
                  <td class="hour">01</td>
                  <td class="hour">02</td>
                  <td class="hour">03</td>
               </tr>
               <tr>
                  <td class="hour">04</td>
                  <td class="hour">05</td>
                  <td class="hour">06</td>
                  <td class="hour">07</td>
               </tr>
               <tr>
                  <td class="hour">08</td>
                  <td class="hour">09</td>
                  <td class="hour">10</td>
                  <td class="hour">11</td>
               </tr>
               <tr>
                  <td class="hour">12</td>
                  <td class="hour">13</td>
                  <td class="hour">14</td>
                  <td class="hour">15</td>
               </tr>
               <tr>
                  <td class="hour">16</td>
                  <td class="hour">17</td>
                  <td class="hour">18</td>
                  <td class="hour">19</td>
               </tr>
               <tr>
                  <td class="hour">20</td>
                  <td class="hour">21</td>
                  <td class="hour">22</td>
                  <td class="hour">23</td>
               </tr>
            </table>
         </div>
         <div class="timepicker-minutes" data-action="selectMinute" style="display: none;">
            <table class="table-condensed">
               <tr>
                  <td class="minute">00</td>
                  <td class="minute">05</td>
                  <td class="minute">10</td>
                  <td class="minute">15</td>
               </tr>
               <tr>
                  <td class="minute">20</td>
                  <td class="minute">25</td>
                  <td class="minute">30</td>
                  <td class="minute">35</td>
               </tr>
               <tr>
                  <td class="minute">40</td>
                  <td class="minute">45</td>
                  <td class="minute">50</td>
                  <td class="minute">55</td>
               </tr>
            </table>
         </div>
         <div class="timepicker-seconds" data-action="selectSecond" style="display: none;">
            <table class="table-condensed">
               <tr>
                  <td class="second">00</td>
                  <td class="second">05</td>
                  <td class="second">10</td>
                  <td class="second">15</td>
               </tr>
               <tr>
                  <td class="second">20</td>
                  <td class="second">25</td>
                  <td class="second">30</td>
                  <td class="second">35</td>
               </tr>
               <tr>
                  <td class="second">40</td>
                  <td class="second">45</td>
                  <td class="second">50</td>
                  <td class="second">55</td>
               </tr>
            </table>
         </div>
      </div>
   </div>
</body>