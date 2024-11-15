<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.hibernate.Session"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject cellularobj = null;
   JSONObject sim1obj = null;
   JSONObject sim2obj = null;
   JSONObject sim1dataobj = null;
   JSONObject sim2dataobj = null;
   BufferedReader jsonfile = null;   
   String sim1autoapn = "No Change";
   String sim1cellnw = "No Change";
   String sim1pppauth = "No Change";
   String sim1sts = "No Change";
   String sim2autoapn = "No Change";
   String sim2cellnw = "No Change";
   String sim2pppauth = "No Change";
   String sim2sts = "No Change";
   String prisim = "No Change";
   String icmpfail = "Enable";
   String icmpfail1 = "Enable";
   String daylmt = "Enable";
   String mntlmt = "Enable";
   String datalmtexce = "Enable";
   String rebtout = "";
   String celrntwunstble="Enable";
   String recprim = "";
   String trackip = "";
   String tracktout = "";
   String totloss = "";
   String acttout = "";
   String acttout1 = "";
   String datalmt = "";
   String sim1apn = "";
   String sim2apn = "";
   String sim2lmt = "";
   String sim1lmt = "";
   String sim1mnt = "";
   String sim2mnt = "";
   String sim1used = "";
   String sim2used = "";
   String dualsim = "";
   String snglsim = "";
   String simshft = "";
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
	   Connection conn = null;
	   Statement stmt= null;
	   ResultSet rs = null;
	   Session hibsession = null;
	   try
	   {
		  hibsession = HibernateSession.getDBSession();
		  conn = ((SessionImpl)hibsession).connection();
		  stmt = conn.createStatement();
		  rs = stmt.executeQuery("select sim1usage,sim2usage from nodedetails where slnumber = '"+slnumber+"'");
		  if(rs.next())
		  {
			  sim1used = rs.getString("sim1usage")==null?"":rs.getString("sim1usage");
			  sim2used = rs.getString("sim2usage")==null?"":rs.getString("sim2usage");
		  }
   		  while((jsonString = jsonfile.readLine())!= null)
   			  jsonbuf.append( jsonString );
   		wizjsonnode= JSONObject.fromObject(jsonbuf.toString());
   		
   		cellularobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("CELLULAR");
   		sim1obj = cellularobj.getJSONObject("SIM1");
   		sim2obj = cellularobj.getJSONObject("SIM2");
		sim1dataobj = cellularobj.getJSONObject("SIM1LIMIT");
		sim2dataobj = cellularobj.getJSONObject("SIM2LIMIT");
		
   		sim1autoapn =  sim1obj.getString("autoapn")==null?"No Change":sim1obj.getString("autoapn");
		sim1apn = sim1obj.getString("apn")==null?"":sim1obj.getString("apn");
   		sim1cellnw =  sim1obj.getString("nwType")==null?"No Change":sim1obj.getString("nwType");
   		sim1pppauth =  sim1obj.getString("pppAuth")==null?"No Change":sim1obj.getString("pppAuth");
   		sim1sts =  sim1obj.getString("status")==null?"No Change":sim1obj.getString("status");
   		
   		
   		sim2autoapn =  sim2obj.getString("autoapn")==null?"No Change":sim2obj.getString("autoapn");
		sim2apn = sim2obj.getString("apn")==null?"":sim2obj.getString("apn");
   		sim2cellnw =  sim2obj.getString("nwType")==null?"No Change":sim2obj.getString("nwType");
   		sim2pppauth =  sim2obj.getString("pppAuth")==null?"No Change":sim2obj.getString("pppAuth");
   		sim2sts =  sim2obj.getString("status")==null?"No Change":sim2obj.getString("status");
		
		prisim = cellularobj.getString("PrimarySIM")==null?"No Change":cellularobj.getString("PrimarySIM");
		recprim = cellularobj.getString("ShiftFreq")==null?"":cellularobj.getString("ShiftFreq");
		trackip = cellularobj.getString("TrackIP")==null?"":cellularobj.getString("TrackIP");
		tracktout = cellularobj.getString("TrackTimeOut")==null?"":cellularobj.getString("TrackTimeOut");
		totloss = cellularobj.getString("Total Loss(%)")==null?"":cellularobj.getString("Total Loss(%)");
		acttout = cellularobj.getString("Action on Timeout")==null?"":cellularobj.getString("Action on Timeout");
		acttout1 = cellularobj.getString("Action on Timeout")==null?"":cellularobj.getString("Action on Timeout");
		icmpfail = cellularobj.getString("ICMP Detection Fails");
		icmpfail1 = cellularobj.getString("Reboot/Reconnect When ICMP Detection Fails");
		datalmtexce = cellularobj.getString("DataLimit_Exceeded");
		celrntwunstble = cellularobj.getString("Reboot, When Cellular Network Unstable");
		daylmt = cellularobj.getString("Daily Limit");
		mntlmt = cellularobj.getString("Monthly Limit");
		datalmt = cellularobj.getString("When Both Data Limit Exceeded")==null?"":cellularobj.getString("When Both Data Limit Exceeded");
		rebtout = cellularobj.getString("RebootTimeOut")==null?"":cellularobj.getString("RebootTimeOut");
		
		sim1lmt = sim1dataobj.getString("Max Data Limitation (MB)")==null?"":sim1dataobj.getString("Max Data Limitation (MB)");
		sim1mnt = sim1dataobj.getString("Date Of Month To Clean")==null?"":sim1dataobj.getString("Date Of Month To Clean");
		//sim1used = sim1dataobj.getString("Already Used (KB)")==null?"":sim1dataobj.getString("Already Used (KB)");
		
		sim2lmt = sim2dataobj.getString("Max Data Limitation (MB)")==null?"":sim2dataobj.getString("Max Data Limitation (MB)");
   		sim2mnt = sim2dataobj.getString("Date Of Month To Clean")==null?"":sim2dataobj.getString("Date Of Month To Clean");
		//sim2used = sim2dataobj.getString("Already Used (KB)")==null?"":sim2dataobj.getString("Already Used (KB)");
		
		simshft = cellularobj.getString("SIMShift")==null?"":cellularobj.getString("SIMShift");
		
		if(trackip.equals("0.0.0.0") && tracktout.equals("0"))
		{
			totloss = "0";
			acttout = "Reboot";
		}
		if(acttout.equals("Reconnect"))
		{
			acttout = "";
		}
		if(acttout1.equals("Sim Shift"))
		{
			acttout1 = "";
		}
	   }
	   catch(Exception e)
	   {
		   e.printStackTrace();
	   }
	   finally
	   {
		   if(hibsession != null)
			   hibsession.close();
		   if(rs != null)
			   rs.close();
		   if(stmt != null)
			   stmt.close();
		   
			   
		   if(jsonfile != null)
			   jsonfile.close();
	   }
   }
   	
   %>
<head>

<style type="text/css">
#WiZConf {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 720px;
}

#WiZConf td,
#WiZConf th {
	border: 2px solid #ddd;
	padding: 8px;
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
	text-align: left;
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
	display: inline;
	border-radius: 6px;
	background-color: #6caee0;
	color: #ffffff;
	font-weight: bold;
	box-shadow: 1px 2px 4px 0 rgba(0, 0, 0, 0.08);
	padding: 12px 20px;
	border: 0;
	margin: 20px;
}

.style1 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	color: #5798B4;
	font-size: 16px;
	font-weight: bold;
}
.style2{
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	color:#2B65EC;
	font-size: 13px;
	font-weight: bold;
}

body {
	background-color: #FAFCFD;
}

</style>
   <script type="text/JavaScript">
   function checkAPN() {
	var sim1apnobj = document.getElementById("APN");
	var sim2apnobj = document.getElementById("APN2");
	var sim1apn = sim1apnobj.value.trim();
	var sim2apn = sim2apnobj.value.trim();
	if (sim1apn == "" && sim2apn == "") {
		sim1apnobj.style.outline = "thin solid red";
		sim1apnobj.title = "Please Enter either SIM1  APN or SIM2 APN";
		sim2apnobj.style.outline = "thin solid red";
		sim2apnobj.title = "Please Enter either SIM1  APN or SIM2 APN";
		return "Please Enter either SIM1  APN or SIM2 APN";
	} else {
		sim1apnobj.style.outline = "initial";
		sim1apnobj.title = "";
		sim2apnobj.style.outline = "initial";
		sim2apnobj.title = "";
		return "";
	}
}
function validateRange(id,name)
{
		var rele = document.getElementById(id);
		var val = rele.value;
		var max = Number(rele.max);
		var min = Number(rele.min);
		if(val.trim() == "")
		{
			rele.style.outline =  "thin solid red";
			rele.title = name+" should be integer in the range from "+min+" to "+max;
			return false;
		}
		if(!isNaN(val))
		{			
			if(val >= min && val <= max)
			{
				rele.style.outline = "initial";
				rele.title = "";
				return true;
			}
			else
			{
				rele.style.outline =  "thin solid red";
				rele.title = name+" should be in the range from "+min+" to "+max;
				return false;
			}
		}
		else
		{
			rele.style.outline =  "thin solid red";
			rele.title = name+" should be integer in the range from "+min+" to "+max;
			return false;
		}
}
function chkFunc() {
	var altmsg = "";
	var dtcln1 = document.getElementById("dateofmonth1");
	var dtcln2 = document.getElementById("dateofmonth2");
	var trackip = document.getElementById("Track_IP");
	var mnth = document.getElementById("month");
	if (!validateIP("Track_IP", false, "Track IP")) 
	{
		altmsg += "invalid Track IP\n";

	}
	if(mnth.checked)
	{
		var valid = validateRange("dateofmonth1","Date Of Month To Clean");
		if(!valid)
		{
			if(dtcln1.value.trim() == "")
			{
				altmsg += "Date Of Month To Clean in Sim1 should not be empty\n";
			}
			else
			{
				altmsg += "Date Of Month To Clean in Sim1 is not valid\n";
			}
		}
		var valid = validateRange("dateofmonth2","Date Of Month To Clean");
		if(!valid)
		{
			if(dtcln2.value.trim() == "")
			{
				altmsg += "Date Of Month To Clean in Sim2 should not be empty\n";
			}
			else
			{
				altmsg += "Date Of Month To Clean in Sim2 is not valid\n";
			}
		}
	}
	if (altmsg != "") {
		alert(altmsg);
		return false;
	}
	return true;
}

function gotoSimShiftPage() {
	
	var sim1status = document.getElementById("SIM1_sts").value;
	var sim2status = document.getElementById("SIM2_sts").value;
	if(sim1status=="Enable" && sim2status=="Enable")
	{
		location.href = "savepage.jsp?page=cellular&slnumber=<%=slnumber%>&version=<%=fwversion%>&simshiftaction=1";
	}
	else
	{
		alert("SIMShift Failed.(Both SIMs are not Enabled.)");
	}
}

function validateIP(id, checkempty, name) {
	var ipele = document.getElementById(id);
	if (ipele.readOnly == true) {
		ipele.style.outline = "initial";f
		ipele.title = "";
		return true;
	}
	var ipformat = /^(25[0-4]|2[0-4][0-9]|[01]?[0-9][0-9]?).(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).(25[0-4]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
	var ipaddr = ipele.value;
	if (ipaddr == "") {
		if (checkempty) {
			
			ipele.title = name + " should not be empty";
			return false;
		} else {
			ipele.style.outline = "initial";
			ipele.title = "";
			return true;
		}
	} else if (!ipaddr.match(ipformat) || ipaddr == "255.255.255.255") {
		
		ipele.title = "Invalid " + name;
		return false;
	} else {
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
}

function AvoidSpace(event) {
	var k = event ? event.which : window.event.keyCode;
	if (k == 32) {
		alert("space is not allowed");
		return false;
	}
}

function CheckAPNStatus() {
	var altmsg = "";
	var apns = ["APN", "APN2"];
	var status_cb = ["SIM1_sts", "SIM2_sts"];
	var nw_cb = ["NW", "NW2"];
	var status_lbl = ["s1status", "s2status"];
	var nw_lbl = ["sim1nw", "sim2nw"];
	var stsnames = ["SIM1 Status", "SIM2 Status"];
	var nwnames = ["SIM1 Network", "SIM2 Network"];
	for (var i = 0; i < apns.length; i++) {
		var apnname = document.getElementById(apns[i]).value.trim();
		if (apnname != "") {
			var curstatusobj = document.getElementById(status_cb[i]);
			var curstatus = curstatusobj.value.trim();
			var stslbl = document.getElementById(status_lbl[i]).innerHTML;
			var curnwobj = document.getElementById(nw_cb[i]);
			var curnw = curnwobj.value.trim();
			var nwlbl = document.getElementById(nw_lbl[i]).innerHTML;
			stslbl = stslbl.trim();
			nwlbl = nwlbl.trim();
			if (curnw == 0 && nwlbl == "") {
				curnwobj.style.outline = "thin solid red";
				curnwobj.title = nwnames[i] + " should not be No Change";
				altmsg += nwnames[i] + " should not be No Change\n";
			} else {
				curnwobj.style.outline = "initial";
				curnwobj.title = "";
			}
			if (curstatus == 0 && stslbl == "") {
				curstatusobj.style.outline = "thin solid red";
				curstatusobj.title = stsnames[i] + " should not be No Change";
				altmsg += stsnames[i] + " should not be No Change\n";
			} else {
				curstatusobj.style.outline = "initial";
				curstatusobj.title = "";
			}
		}
	}
	return altmsg;
}

function IPv4AddressKeyOnly(e) {
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	if ((keyCode == 46 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode >= 48 && keyCode <= 57)) {
		return true;
	}
	return false;
}

function SpecialKeyOnly(e) {
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	if ((keyCode == 32)) {
		alert("space is not allowed");
		return false;
	}
	if (keyCode == 34) return false;
	return true;
}
function editFields() {
	
	var sim1status = document.getElementById("SIM1_sts").value;
	var sim2status = document.getElementById("SIM2_sts").value;
	var addrow = document.getElementById("addrw");
	var addrow2 = document.getElementById("addrow");
	var addrow1 = document.getElementById("addrw1");
	var icmprow = document.getElementById("icmprw");
	var icmprow1 = document.getElementById("icmprow");
	var icmp1row = document.getElementById("icmprw1");
	var icmp2row = document.getElementById("icmprw2");
	var icmp3row = document.getElementById("icmprw3");
	var icmp4row = document.getElementById("icmprw4");
	var icmp5row = document.getElementById("icmprw5");
	var datakb = document.getElementById("datakb");
	var datakb1 = document.getElementById("radiobtns");
	var datakb2 = document.getElementById("datarow2");
	var datakb3 = document.getElementById("datarow3");
	var datakb4 = document.getElementById("datarow5");
	var datakb5 = document.getElementById("datarow4");
    var simrow = document.getElementById("simrow");
	var daily = document.getElementById("daily");
	var month = document.getElementById("month");
	if (month.checked)
			document.getElementById("month").checked = true;
			datakb4.style.display = "";
	if ((sim1status == "Enable") && (sim2status == "Enable")) {
		addrow.style.display = "";
		addrow1.style.display = "";
		addrow2.style.display = "";
		icmprow.style.display = "";
		datakb.style.display = "";
		daily.style.display = "";
		month.style.display = "";
		icmprow1.style.display = "none";
		icmp4row.style.display = "none";
		icmp5row.style.display = "none";
		document.getElementById("rebootrw").style.display="";
		document.getElementById("icmp1").checked=false;
		document.getElementById("simpolicy").innerHTML="Dual Sim Policy";
        document.getElementById("simpolicy").style.display="";
		
	} else if (((sim1status == "Enable") && (sim2status == "Disable")) || ((sim1status == "Disable") && (sim2status == "Enable"))) {
		document.getElementById("simpolicy").innerHTML="Single Sim Policy";
        document.getElementById("simpolicy").style.display="";
		icmprow1.style.display = "";
		addrow2.style.display = "";
		icmprow.style.display = "none";
		addrow.style.display = "none";
		addrow1.style.display = "none";
		datakb.style.display = "none";
		datakb1.style.display = "none";
		datakb2.style.display = "none";
		datakb3.style.display = "none";
		datakb4.style.display = "none";
		datakb5.style.display = "none";
		simrow.style.display = "none";
		daily.style.display = "none";
		month.style.display = "none";
		icmp4row.style.display = "none";
		document.getElementById("rebootrw").style.display="";
		document.getElementById("icmp").checked=false;
	} else {
		document.getElementById("simpolicy").innerHTML="";
        document.getElementById("simpolicy").style.display="none";
		addrow.style.display = "none";
		addrow1.style.display = "none";
		addrow2.style.display = "none";
		icmprow.style.display = "none";
		icmprow1.style.display = "none";
		datakb.style.display = "none";
		datakb1.style.display = "none";
		datakb2.style.display = "none";
		datakb3.style.display = "none";
		datakb4.style.display = "none";
		datakb5.style.display = "none";
		simrow.style.display = "none";
		daily.style.display = "none";
		month.style.display = "none";
	}
	if ((sim1status == "Enable") && (sim2status == "Enable")) {

		
		var month = document.getElementById("month");
		var data = document.getElementById("daily");
		document.getElementById("rebootrw").style.display="";
		if (month.checked)
			document.getElementById("month").checked = true;
			datakb4.style.display = "";

		if (data.checked)
			document.getElementById("daily").checked = true;

		document.getElementById("icmp1").checked = false;

		if((!document.getElementById("month").checked))
		{
			datakb4.style.display = "none";
		}
		if ((!document.getElementById("icmp").checked)) {
			icmp1row.style.display = "none";
			icmp2row.style.display = "none";
			icmp3row.style.display = "none";
		}
		if ((!document.getElementById("data").checked)) {
			 datakb1.style.display = "none";
			 datakb2.style.display = "none";
			 datakb3.style.display = "none";
			 datakb4.style.display = "none";
			 datakb5.style.display = "none";
			 simrow.style.display = "none";
		}
		if(!document.getElementById("rebootrw1").checked)
			addrow2.style.display="none";
        else
        addrow2.style.display="";
	} else if (((sim1status == "Enable") && (sim2status == "Disable")) || ((sim1status == "Disable") && (sim2status == "Enable"))) {
		document.getElementById("rebootrw").style.display="";
		document.getElementById("icmp").checked = false;
		document.getElementById("data").checked = false;
		if ((!document.getElementById("icmp1").checked)) {
			icmp1row.style.display = "none";
			icmp2row.style.display = "none";
			icmp3row.style.display = "none";
			icmp5row.style.display = "none";
		}
		if(!document.getElementById("rebootrw1").checked)
           addrow2.style.display="none";
          else
            addrow2.style.display="";
		
	} else {
		document.getElementById("icmp1").checked = false;
		document.getElementById("icmp").checked = false;
		document.getElementById("rebootrw").style.display="none";
		document.getElementById("rebootrw1").checked =false;
        document.getElementById("data").checked =false;
		icmp1row.style.display = "none";
		icmp2row.style.display = "none";
		icmp3row.style.display = "none";
		icmp4row.style.display = "none";
		icmp5row.style.display = "none";
	}
}
function edittrack() {
	var icmp1row = document.getElementById("icmprw1");
	var icmp2row = document.getElementById("icmprw2");
	var icmp3row = document.getElementById("icmprw3");
	var icmp4row = document.getElementById("icmprw4");
	var icmp5row = document.getElementById("icmprw5");
	if (document.getElementById("icmp").checked) {
		icmp1row.style.display = "";
		icmp2row.style.display = "";
		icmp3row.style.display = "";
		icmp5row.style.display = "";
	} else if (document.getElementById("icmp1").checked) {
		icmp1row.style.display = "";
		icmp2row.style.display = "";
		icmp4row.style.display = "";
		icmp5row.style.display = "";
		icmp3row.style.display = "none";
	} else {
		icmp1row.style.display = "none";
		icmp2row.style.display = "none";
		icmp3row.style.display = "none";
		icmp4row.style.display = "none";
		icmp5row.style.display = "none";
	}
}
function editdate(input) 
{
	var datakb4 = document.getElementById("datarow5");
	var checkboxes = document.getElementsByClassName("radioCheck");
	var daily = document.getElementById("daily");
	var month = document.getElementById("month");

		for(var i = 0; i < checkboxes.length; i++)
    	{
    		
    		if(checkboxes[i].checked == true)
    		{
    			checkboxes[i].checked = false;
    		}
    	}
		if(input.checked == true)
    	{
    		input.checked = false;
    	}
    	else
    	{
    		input.checked = true;
    	}
			if(month.checked)		
			datakb4.style.display = "";
		else
			datakb4.style.display = "none";

}
function editdata() {
	
	var datalt = document.getElementById("data");
	var month = document.getElementById("month");
	var daily = document.getElementById("daily");
	var datakb1 = document.getElementById("radiobtns");
	
	var datakb2 = document.getElementById("datarow2");
	var datakb3 = document.getElementById("datarow3");
	var datakb4 = document.getElementById("datarow5");
	var datakb5 = document.getElementById("datarow4");
	var simrow = document.getElementById("simrow");
	if (datalt.checked && (!month.checked && !daily.checked)) {
		simrow.style.display="";
		datakb1.style.display = "";
		datakb2.style.display = "";
		datakb3.style.display = "";
		datakb5.style.display = "";
	} 
	else if(datalt.checked && month.checked)
	{
		simrow.style.display="";
		datakb1.style.display = "";
		datakb2.style.display = "";
		datakb3.style.display = "";
		datakb4.style.display = "";
		datakb5.style.display = "";
	}
	else if(datalt.checked && daily.checked)
	{
		simrow.style.display="";
		datakb1.style.display = "";
		datakb2.style.display = "";
		datakb3.style.display = "";
		datakb5.style.display = "";
	}
	else 
	{
		simrow.style.display="none";
		datakb1.style.display = "none";
		datakb2.style.display = "none";
		datakb3.style.display = "none";
		datakb4.style.display = "none";
		datakb5.style.display = "none";
	}
}
function reboot()
{
  if(document.getElementById("rebootrw1").checked)
      document.getElementById("addrow").style.display="";
  else
      document.getElementById("addrow").style.display="none";
}
function showErrorMsg(errormsg)
{
	alert(errormsg);
} 
</script>
</head>
<body onload="selectComboItem()">
   <form action="savepage.jsp?page=cellular&slnumber=<%=slnumber%>&version=<%=fwversion%>" method="post" onsubmit="return chkFunc();">
      <p class="style1" align="center">Cellular Configuration</p>
      <table id="WiZConf" align="center">
         <tbody>
            <tr>
               <th width="180px" align="center">Parameters</th>
               <th colspan="2" style="text-align:center;" align="center">SIM 1</th>
               <th colspan="2" style="text-align:center;" align="center">SIM 2</th>
            </tr>
            <tr>
               <td>Auto APN</td>
               <td id="sim1AutoApn" width="140"><%=sim1autoapn%></td>
               <td>
                  <select name="AutoAPN1" id="AutoAPN1" class="text">
                     <option value="No Change" <%if(sim1autoapn.equals("No Change")){%>selected<%}%>>No Change</option>
                     <option value="Enable" <%if(sim1autoapn.equals("Enable")){%>selected<%}%>>Enable</option>
                     <option value="Disable" <%if(sim1autoapn.equals("Disable")){%>selected<%}%>>Disable</option>
                  </select>
               </td>
               <td id="sim2AutoApn" width="140"><%=sim2autoapn%></td>
               <td>
                  <select name="AutoAPN2" id="AutoAPN2" class="text">
                     <option value="No Change" <%if(sim2autoapn.equals("No Change")){%>selected<%}%>>No Change</option>
                     <option value="Enable" <%if(sim2autoapn.equals("Enable")){%>selected<%}%>>Enable</option>
                     <option value="Disable" <%if(sim2autoapn.equals("Disable")){%>selected<%}%>>Disable</option>
                  </select>
               </td>
            </tr>
            <tr>
               <td>APN</td>
               <td width="140"><%=sim1apn%></td>
               <td><input name="APN" type="text" class="text" id="APN" value="<%=sim1apn%>" onkeypress="return SpecialKeyOnly(event)" size="12" maxlength="32"><%=cellularobj == null?"":cellularobj.get("apn")==null?"":cellularobj.getString("apn")%></td>
               <td width="140"><%=sim2apn%></td>
               <td><input name="APN2" type="text" class="text" id="APN2" value="<%=sim2apn%>" onkeypress="return SpecialKeyOnly(event)" size="12" maxlength="32"><%=cellularobj == null?"":cellularobj.get("apn")==null?"":cellularobj.getString("apn")%></td>
            </tr>
            <tr>
               <td>Network</td>
               <td id="sim1nw" width="140"><%=sim1cellnw==null?"No Change":sim1cellnw%></td>
               <td>
                  <select name="NW" id="NW" class="text">
                     <option value="No Change" <%if(sim1cellnw.equals("No Change")){%>selected<%}%>>No Change</option>
                     <option value="Auto" <%if(sim1cellnw.equals("Auto")){%>selected<%}%>>Auto</option>
                     <option value="2G" <%if(sim1cellnw.equals("2G")){%>selected<%}%>>2G</option>
                     <option value="3G" <%if(sim1cellnw.equals("3G")){%>selected<%}%>>3G</option>
                     <option value="4G" <%if(sim1cellnw.equals("4G")){%>selected<%}%>>4G</option>
                  </select>
               </td>
               <td id="sim2nw" width="140"><%=sim2cellnw==null?"No Change":sim2cellnw%></td>
               <td>
                  <select name="NW2" id="NW2" class="text">
                     <option value="No Change" <%if(sim2cellnw.equals("No Change")){%>selected<%}%>>No Change</option>
                     <option value="Auto" <%if(sim2cellnw.equals("Auto")){%>selected<%}%>>Auto</option>
                     <option value="2G" <%if(sim2cellnw.equals("2G")){%>selected<%}%>>2G</option>
                     <option value="3G" <%if(sim2cellnw.equals("3G")){%>selected<%}%>>3G</option>
                     <option value="4G" <%if(sim2cellnw.equals("4G")){%>selected<%}%>>4G</option>
                  </select>
               </td>
            </tr>
            <tr>
               <td>PPP Username</td>
               <td colspan="2"><input name="SIM1_PPPUname" type="text" class="text" id="SIM1_PPPUname" value="<%=sim1obj == null?"":sim1obj.get("pppUsername")==null?"":sim1obj.getString("pppUsername")%>"" size="16" maxlength="32" onkeypress="return AvoidSpace(event)"></td>
               <td colspan="2"><input name="SIM2_PPPUname" type="text" class="text" id="SIM2_PPPUname" value="<%=sim2obj == null?"":sim2obj.get("pppUsername")==null?"":sim2obj.getString("pppUsername")%>" size="16" maxlength="32" onkeypress="return AvoidSpace(event)"></td>
            </tr>
            <tr>
               <td>PPP Password</td>
               <td colspan="2"><input name="SIM1_Password" type="password" class="text" id="SIM1_Password" value="<%=sim1obj == null?"":sim1obj.get("pppPW")==null?"":sim1obj.getString("pppPW")%>" size="16" maxlength="32" onkeypress="return AvoidSpace(event)"></td>
               <td colspan="2"><input name="SIM2_Password" type="password" class="text" id="SIM2_Password" value="<%=sim2obj == null?"":sim2obj.get("pppPW")==null?"":sim2obj.getString("pppPW")%>" size="16" maxlength="32" onkeypress="return AvoidSpace(event)"></td>
            </tr>
            <tr>
               <td>PPP Authentication</td>
               <td><%=sim1pppauth%></td>
               <td>
                  <select name="SIM1_PPPAuth" id="SIM1_PPPAuth" class="text">
                     <option value="No Change" <%if(sim1pppauth.equals("No Change")){%>selected<%}%>>No Change</option>
                     <option value="PAP" <%if(sim1pppauth.equals("PAP")){%>selected<%}%>>PAP</option>
                     <option value="CHAP" <%if(sim1pppauth.equals("CHAP")){%>selected<%}%>>CHAP</option>
                     <option value="ANY" <%if(sim1pppauth.equals("ANY")){%>selected<%}%>>ANY</option>
                     <option value="NONE" <%if(sim1pppauth.equals("NONE")){%>selected<%}%>>NONE</option>
                  </select>
               </td>
               <td><%=sim2pppauth%></td>
               <td>
                  <select name="SIM2_PPPAuth" id="SIM2_PPPAuth" class="text">
                     <option value="No Change" <%if(sim2pppauth.equals("No Change")){%>selected<%}%>>No Change</option>
                     <option value="PAP" <%if(sim2pppauth.equals("PAP")){%>selected<%}%>>PAP</option>
                     <option value="CHAP" <%if(sim2pppauth.equals("CHAP")){%>selected<%}%>>CHAP</option>
                     <option value="ANY" <%if(sim2pppauth.equals("ANY")){%>selected<%}%>>ANY</option>
                     <option value="NONE" <%if(sim2pppauth.equals("NONE")){%>selected<%}%>>NONE</option>
                  </select>
               </td>
            </tr>
            <tr>
               <td>Status</td>
               <td id="s1status"><%=sim1sts==null?"No Change":sim1sts%></td>
               <td>
                  <select name="SIM1_sts" id="SIM1_sts" class="text" onchange="editFields();"  selected="">
                     <option value="Enable" <%if(sim1sts.equals("Enable")){%>selected<%}%>>Enable</option>
                     <option value="Disable" <%if(sim1sts.equals("Disable")){%>selected<%}%>>Disable</option>
                  </select>
               </td>
               <td id="s2status"><%=sim2sts==null?"No Change":sim2sts%></td>
               <td>
                  <select name="SIM2_sts" id="SIM2_sts" class="text" onchange="editFields();" selected="">
                     <option value="Enable" <%if(sim2sts.equals("Enable")){%>selected<%}%>>Enable</option>
                     <option value="Disable" <%if(sim2sts.equals("Disable")){%>selected<%}%>>Disable</option>
                  </select>
               </td>
            </tr>
         </tbody>
      </table>
      <br>
	  <table id="WiZConf" align="center">
	  <tbody>
	  <tr id="rebootrw" style="">
	  <td colspan="4" width="180px">
	  <input type="checkbox" name="rebootrw1" id="rebootrw1" <%if(celrntwunstble.equals("Enable")){%>checked<%}%> onclick="reboot();">&nbsp;Reboot, When Cellular Downtime Exceeded</td>
	  </tr>
	  </tbody>
	  </table>
			<table id="WiZConf" align="center">
			<tbody>
			<tr id="addrow">
			<td width="155">Downtime (Min)</td>
			<td colspan="2" width="115"><%=rebtout%></td>
			<td colspan="2"><input type="number" class="text" min="0" max="99" maxlength="2" id="to" name="RebootTimeout" value="<%=rebtout%>" onkeypress="return IPv4AddressKeyOnly(event)"></td>
			</tr>
			</tbody>
			</table>
			<br>
           <table id="WiZConf" align="center">
		   <tbody>
		   <tr>
		   <th id="simpolicy" width="180px" align="center" style="text-align:center;"></th>
		   </tr>
		   </tbody>
		   </table>
			<table id="WiZConf"  align="center">
            <tbody>
            <tr id="addrw">
               <td width="155">Primary SIM</td>
               <td colspan="2" width="115"><%=prisim%></td>
               <td colspan="2">
                  <select name="Pri_SIM" id="Pri_SIM" class="text">
                     <option value="No Change" <%if(prisim.equals("No Change")){%>selected<%}%>>No Change</option>
                     <option value="SIM1" <%if(prisim.equals("SIM1")){%>selected<%}%>>SIM1</option>
                     <option value="SIM2" <%if(prisim.equals("SIM2")){%>selected<%}%>>SIM2</option>
                  </select>
               </td>
            </tr>
            <tr id="addrw1">
               <td>Recheck Primary(Hr)</td>
               <td colspan="2"><%=recprim%></td>
               <td colspan="2"><input type="number" class="text" min="0" max="99" maxlength="2" name="Recheck_Primary" id="Recheck_Primary" value="<%=recprim%>" onkeypress="return IPv4AddressKeyOnly(event)"></td>
            </tr>
         </tbody>
      </table>
      <br>
      <table id="WiZConf" align="center">
         <tbody>
            <tr id="icmprw">
               <td width="180px" colspan="4"><input type="checkbox" id="icmp" name="icmp" <%if(icmpfail.equals("Enable")){%>checked<%}%> onclick="edittrack();" >&nbsp;Health Check</td>
         </tbody>
      </table>
      <table id="WiZConf" align="center">
         <tbody>
            <tr id="icmprow">
               <td width="180px" colspan="4"><input type="checkbox" name="icmp1" id="icmp1" <%if(icmpfail1.equals("Enable")){%>checked<%}%> onclick="edittrack();" >&nbsp;Health Check </td>
         </tbody>
      </table>
      <table id="WiZConf" align="center">
         <tbody>
            <tr id="icmprw1">
               <td width="155">Track IP </td>
               <td width="250"><%=trackip%></td>
               <td><input type="text" class="text" id="Track_IP" name="Track_IP" maxlength="15" value="<%=trackip%>" onfocusout="validateIP('Track_IP',true,'Track IP')" onkeypress="return IPv4AddressKeyOnly(event)"></td>
            </tr>
            <tr id="icmprw2">
               <td>Track Duration(Sec) </td>
               <td><%=tracktout%></td>
               <td><input type="text" class="text" maxlength="2" id="trkduration" name="trkduration" value="<%=tracktout%>" onkeypress="return IPv4AddressKeyOnly(event)"></td>
            </tr>
            <tr id="icmprw5">
               <td>Total Loss(%)</td>
               <td><%=totloss%></td>
               <td><input type="text" class="text" maxlength="2" id="totloss" name="totloss" value="<%=totloss%>" onkeypress="return IPv4AddressKeyOnly(event)"></td>
            </tr>
            <tr id="icmprw3">
               <td>Action on Timeout</td>
               <td><%=acttout%></td>
               <td>
                  <select name="action" id="action" class="text">
                     <option value="Sim Shift" <%if(acttout.equals("Sim Shift")){%>selected<%}%>>Sim Shift</option>
                     <option value="Reboot" <%if(acttout.equals("Reboot")){%>selected<%}%>>Reboot</option>
                  </select>
               </td>
            </tr>
            <tr id="icmprw4">
               <td>Action on Timeout</td>
               <td><%=acttout1%></td>
               <td>
                  <select name="action1" id="action1" class="text">
                     <option value="Reboot" <%if(acttout1.equals("Reboot")){%>selected<%}%>>Reboot</option>
                     <option value="Reconnect" <%if(acttout1.equals("Reconnect")){%>selected<%}%>>Reconnect</option>
                  </select>
               </td>
            </tr>
         </tbody>
      </table>
      <br>
      <table id="WiZConf" align="center">
         <tbody>
            <tr id="datakb">
               <td width="350px" colspan="2"><input type="checkbox" name="data" id="data" <%if(datalmtexce.equals("Enable")){%>checked<%}%>  onclick="editdata();">&nbsp;SIM Shift When Data Limit is Exceeded </td>
			   <td id="radiobtns"><input type="radio" colspan="2" class="radioCheck" id="daily" name="daily" <%if(daylmt.equals("Enable")){%>checked<%}%>  onclick="editdate(this);" />&nbsp;Daily Limit &nbsp;&nbsp;
               <input type="radio" class="radioCheck" id="month" name="month"  <%if(mntlmt.equals("Enable")){%>checked<%}%> onclick="editdate(this);" />&nbsp;Monthly Limit </td>
            </tr>
         </tbody>
      </table>
      <table id="WiZConf" align="center">
         <tbody>
            <tr id="datarow2">
               <td width="150">When Both Data Limit Exceeded</td>
               <td colspan="2" width="70" ><%=datalmt%></td>
               <td colspan="2">
                  <select name="datalimit" id="datalimit" class="text">
                     <option value="Use SIM1" <%if(datalmt.equals("Use SIM1")){%>selected<%}%>>Use SIM1</option>
					 <option value="Use SIM2" <%if(datalmt.equals("Use SIM2")){%>selected<%}%>>Use SIM2</option>
                  </select>
               </td>
            </tr>
			<tr id="simrow">
			<td></td>
			<td colspan="2" class="style2">SIM1</td>
			<td colspan="2" class="style2">SIM2</td>
			</tr>
            <tr id="datarow3">
               <td>Data Limit (MB)</td>
               <td colspan="2"><input name="maxdata1" type="text" class="text" id="maxdata1" value="<%=sim1lmt%>" size="16" maxlength="32" onkeypress="return AvoidSpace(event)"></td>
               <td colspan="2"><input name="maxdata2" type="text" class="text" id="maxdata2" value="<%=sim2lmt%>" size="16" maxlength="32" onkeypress="return AvoidSpace(event)"></td>
            </tr>
			<tr id="datarow4">
               <td>Data Used (KB)</td>
               <td colspan="2"><input name="useddata1" type="text" class="text" id="useddata1" value="<%=sim1used%>" size="16" maxlength="32" onkeypress="return AvoidSpace(event)" readonly></td>
               <td colspan="2"><input name="useddata2" type="text" class="text" id="useddata2" value="<%=sim2used%>" size="16" maxlength="32" onkeypress="return AvoidSpace(event)" readonly></td>
            </tr>
            <tr id="datarow5">
               <td>Date Of Month To Clean</td>
               <td colspan="2"><input name="dateofmonth1" type="text" class="text" size="2" min="1" max="28" id="dateofmonth1" value="<%=sim1mnt%>" onkeypress="return AvoidSpace(event)" onfocusout="validateRange('dateofmonth1','Date Of Month To Clean')"></td>
               <td colspan="2"><input name="dateofmonth2" type="text" class="text" size="2" min="1" max="28" id="dateofmonth2" value="<%=sim2mnt%>" onkeypress="return AvoidSpace(event)" onfocusout="validateRange('dateofmonth2','Date Of Month To Clean')"></td>
            </tr>
            
         </tbody>
      </table>
      <div align="center"><input type="submit" style="display:inline block" value="Submit" class="button">
	  <input type="button" value="SIM Shift" style="display:inline block" class="button" onclick="gotoSimShiftPage();">
	  </div>
   </form>
      <%
   if(errorstr != null && errorstr.trim().length() > 0)
			{%>
		     <script>
			 showErrorMsg('<%=errorstr%>');
			 </script>
			<%}
	  %>
   <script type="text/javascript">
   function selectComboItem() {
	for (var i = 0; i < hiddenvalarr.length; i++) {
		selAction(checkarr[i], document.getElementById(hiddenvalarr[i]).value);
	}
}
editFields();
edittrack();
editdata();
reboot();
</script>
<script src="js/timeout.js" type="text/javascript"></script>
</body>