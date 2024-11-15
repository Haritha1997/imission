<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.util.Hashtable"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

<%
   JSONObject wizjsonnode = null;
   JSONObject ipsec_configobj = null;
   JSONObject ipsec_obj = null;
   JSONObject ipsec_table = null;
   JSONArray ipsecnumarr = null;
   BufferedReader jsonfile = null;   
   String slnumber=request.getParameter("slnumber");
   String errorstr = request.getParameter("error");
   String fmversion=request.getParameter("version");
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
   	   		ipsec_configobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").getJSONObject("IPSECCONFIG");
   	   	    ipsec_obj =ipsec_configobj.getJSONObject("IPSEC");
   	   	    String ipsecslctno=(String)ipsec_obj.get("IpsecSelectNo");
   	   	    ipsec_table = ipsec_obj.getJSONObject("TABLE");
   	   	    ipsecnumarr = ipsec_table.getJSONArray("arr")==null ? new JSONArray(): ipsec_table.getJSONArray("arr");
			//System.out.println(ipsecnumarr);
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
      <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
      <meta http-equiv="Pragma" content="no-cache">
      <meta http-equiv="Expires" content="0">
      <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
      <link rel="stylesheet" href="js/delete.png">
      <style type="text/css">
#WiZConf {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 800px;
}

#WiZConf1 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 550px;
}

#WiZConf td,
#WiZConf th {
	border: 2px solid #ddd;
	padding: 5px;
}

#WiZConf1 td,
#WiZConf th {
	border: 2px solid #ddd;
	padding: 8px;
}

#WiZConf tr:nth-child(even) {
	background-color: #f2f2f2;
}

#WiZConf1 tr:nth-child(even) {
	background-color: #f2f2f2;
}

#WiZConf tr:hover {
	background-color: #d3f2ef;
}

#WiZConf1 tr:hover {
	background-color: #d3f2ef;
}

#WiZConf th {
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

.text {
	background: white;
	border: 2px Solid #DDD;
	border-radius: 5px;
	box-shadow: 1 1 5px #DDD inset;
	color: #000;
	height: 20px;
	width: 100px;
}

.text1 {
	height: 15px;
	width: 110px;
}

.text2 {
	height: 20px;
	width: 40px;
}

.text3 {
	background: white;
	border: 2px Solid #DDD;
	border-radius: 5px;
	box-shadow: 1 1 5px #DDD inset;
	color: #000;
	height: 20px;
	width: 50px;
}

#WiZConf td input {
	max-width: 100px;
}

input[type="text"]::-ms-clear {
	display: inline;
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
	cursor:pointer
}

.page {
	display: none;
	padding: 0 0.5em;
}

.page h1 {
	font-size: 2em;
	line-height: 1em;
	margin-top: 1.1em;
	font-weight: bold;
}

.page p {
	font-size: 1.5em;
	line-height: 1.275em;
	margin-top: 0.15em;
}

.loading p {
	font-size: 1.5em;
	line-height: 1.275em;
	margin-top: 0.15em;
}

#loading {
	display: none;
	position: absolute;
	top: 0;
	left: 0;
	z-index: 100;
	width: 100vw;
	height: 100vh;
	background-color: rgba(192, 192, 192, 0.5);
	background-image: url("js/loader.gif ");
	background-repeat: no-repeat;
	background-position: center;
	transition-duration: 10s;
}

.button1 {
	padding-right: 12px;
	font-weight: bold;
	background-color: #6caee0;
	margin-right: 1px;
	cursor:pointer
}
.image{
	cursor:pointer;
}
.style1 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	color: #5798B4;
	font-size: 22px;
	font-weight: bold;
}

body {
	background-color: #FAFCFD;
}
</style>
<script type = "text/javascript">
var oldinstname;
var instid;

function avoidSpace(event) {
	var k = event ? event.which : window.event.keyCode;
	if (k == 32) {
		alert("space is not allowed");
		return false;
	}
}

function avoidEnter(event) {
	var k = event ? event.which : window.event.keyCode;
	if (k == 13) {
		return false;
	}
}

function isEmpty(id, name) {
	var ele = document.getElementById(id);
	var val = ele.value;
	if (val == "") {
		ele.style.outline = "thin solid red";
		ele.title = name + " should not be empty";
		return false;
	} else {
		ele.style.outline = "initial";
		ele.title = "";
		return true;
	}
}

function AlphaNumericOnly(e) {
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	if ((keyCode == 8 || keyCode == 9) || (keyCode>= 48 && keyCode <= 57) || (keyCode>= 65 && keyCode <= 90) || (keyCode>= 97 && keyCode <= 122)) {
		return true;
	}
	return false;
}

function addnewinstnametoipsecconfig(id,slnumber,version) {
	var table = document.getElementById('WiZConf');
	var rowcnt = table.rows.length;
	if(rowcnt==6)
	{
		alert("Maximum 5 rows are allowed in IPSEC Table");
		return false;
	}
	var newinst=document.getElementById(id);
	var newinstname = newinst.value;
	if(newinstname.length==0)
	{	
		alert("New Instance Name Should Not Be Empty");	
		newinst.style.outline = "thin solid red";
		newinst.title = "New Instance Name should not be empty";
		return false;
	}
	var url="savepage.jsp?page=ipsec_multi&slnumber="+slnumber+"&version="+version+"&instancename="+newinstname+"&action=add";
	openInFrame(url);
}

function openInFrame(url) {
	top.frames['WelcomeFrame'].location.href = url;
}
function gototunnelConfigpage(instancename,slnumber,version) {
	var instname = document.getElementById(instancename).value;
	var url="tunnelconfig.jsp?instancename="+instname+"&slnumber="+slnumber+"&version="+version;
	openInFrame(url);
}
function deleteRow(rowid,insnameid,slnumber) 
{
	var instname = document.getElementById(insnameid).value;
	var url="savepage.jsp?page=ipsec_multi&slnumber="+slnumber+"&instancename="+instname+"&action=delete";
	document.getElementById(rowid).remove();
	reindexTable();
	openInFrame(url);
}

function addInstancenames(id, instancename, enable, optlevel, interf, status, uptime) {
	document.getElementById("instancename" + id).value = instancename;
	document.getElementById("enable" + id).value = enable;
	document.getElementById("optlevel" + id).value = optlevel;
	document.getElementById("interface" + id).value = interf;
	document.getElementById("status" + id).value = status;
	document.getElementById("uptime" + id).value = uptime;
}

function loadInstanceNameIndex(id) {
	oldinstname = "";
	if (document.getElementById(id).value == "") {
		return;
	}
	instid = id;
	oldinstname = document.getElementById(id).value;
}

function duplicateInstanceNamesExists(id, tablename) {
	var dupexists = false;
	var name = document.getElementById(id).value;
	var obj = document.getElementById(id);
	if (name == "") {
		if (tablename == "WiZConf") obj.title = "Instance Name should not be empty";
	} else {
		obj.style.outline = "initial";
		obj.title = "";
	}
	if (tablename == "WiZConf") {
		var searchstr = "instancename";
		var displaystr = "Instance Name";
		var ipsectab = document.getElementById("WiZConf");
		var rowsize = ipsectab.rows.length;
		for (var i = 1; i <rowsize; i++) {
			var lcolind = ipsectab.rows[i].cells.length - 1;
			var oriind = ipsectab.rows[i].cells[lcolind].innerHTML;
			var instname = document.getElementById(searchstr + oriind).value;
			if ((id != searchstr + oriind) && instname == name && instname != "") {
				alert(displaystr + " " + name + " already exists.");
				dupexists = true;
				document.getElementById(id).value = oldinstname;
				break;
			}
		}
	}
	return dupexists;
}
function addTunnelData(id,instancename,enable,prfrdpeer,lclcrenpt,status){ 
	document.getElementById("instancename"+id).value=instancename;
	document.getElementById("enable"+id).value=enable;
	document.getElementById("optlevel"+id).value=prfrdpeer;
	document.getElementById("interface"+id).value=lclcrenpt;
	document.getElementById("status"+id).value=status;
	}

function addRow(tablename,version) {
	var table = document.getElementById(tablename);
	var rowcnt = table.rows.length;
	var newinstancename = document.getElementById("nwinstname");
	var newinstobj = newinstancename.value;
	if (tablename == "WiZConf") {
		if (rowcnt == 6) {
			alert("Maximum 5 rows are allowed in IPSEC Table");
			return false;
		}
		if (rowcnt == 1) document.getElementById("ipsecrwcnt").value = rowcnt;
		rowcnt = document.getElementById("ipsecrwcnt").value;
		document.getElementById("ipsecrwcnt").value = Number(rowcnt) + 1;
		var row = "<tr id='ipsecrow"+rowcnt+"'>" + "<td>" + rowcnt + "</td>" + "<td><input type=\"text\" class=\"text\"  id=\"instancename" + rowcnt + "\" name=\"instancename" + rowcnt + "\" onkeypress=\"return avoidSpace(event) || avoidEnter(event) \" onfocus=\"loadInstanceNameIndex('instancename" + rowcnt + "')\" readonly></input></td>" + "<td><input type=\"text\" name=\"enable\" class=\"text3\" size=\"1\" id=\"enable" + rowcnt + "\" onkeypress=\"return avoidSpace(event) || avoidEnter(event) \" readonly></input></td>" + "<td><input type=\"text\" name=\"optlevel\" class=\"text\" id=\"optlevel" + rowcnt + "\"  onkeypress=\"return avoidSpace(event) || avoidEnter(event) \" readonly></input></td>" + "<td><input type=\"text\" name=\"interface\" class=\"text\" id=\"interface" + rowcnt + "\"  onkeypress=\"return avoidSpace(event) || avoidEnter(event) \" readonly></input></td>" + "<td><input type=\"text\" name=\"status\" class=\"text3\" id=\"status" + rowcnt + "\"  onkeypress=\"return avoidSpace(event) || avoidEnter(event) \" readonly></input></td>" + "<td><input type=\"text\" name=\"uptime\" class=\"text\" id=\"uptime" + rowcnt + "\"  onkeypress=\"return avoidSpace(event) || avoidEnter(event) \" readonly></input></td>" + "<td><input type=\"button\" id=\"editrw" + rowcnt + "\" name=\"editrw" + rowcnt + "\" value=\"Edit\" class=\"button1\" align=\"left\" onclick=\"gototunnelConfigpage('instancename"+rowcnt+"','<%=slnumber%>','"+version+"')\">" + "<img class=\"image\" id=\"delrw" + rowcnt + "\" name=\"delrw" + rowcnt + "\" src=\"images/delete.png\" width=\"22\" height=\"24\" align=\"right\" title=\"Delete\" onclick=\"deleteRow('ipsecrow"+rowcnt+"','instancename"+rowcnt+"','<%=slnumber%>')\"></img></td>" + "<td hidden>0</td>" + "<td hidden>" + rowcnt + "</td>" + "</tr>";
		$('#WiZConf').append(row);
		loadNewinstnameToIPSecInstname(rowcnt, tablename);
	} else {
		alert("no add row");
	}
	newinstancename.value = "";
	reindexTable();
	var height = table.rows[1].cells[0].offsetHeight;
	window.scrollBy(0, height);
}

function reindexTable() {
	var table = document.getElementById("WiZConf");
	var rowCount = table.rows.length;
	for (var i = 1; i <rowCount; i++) {
		var row = table.rows[i];
		row.cells[0].innerHTML = i;
	}
}

function loadNewinstnameToIPSecInstname(row, tablename) {
	var table = document.getElementById(tablename);
	var rowcnt = table.rows.length;
	if (tablename == "WiZConf") {
		var instid = "instancename" + row;
		var instances = getNewInstanceNames();
		var selinstobj = document.getElementById(instid);
		var instdata = "";
		for (i = 0; i <instances.length; i++) {
			if (instances[i] != "") instdata += instances[i];
		}
		$("#" + instid).append(instdata);
		selinstobj.value = instdata;
		duplicateInstanceNamesExists(instid, tablename);
	}
}

function getNewInstanceNames() {
	var instarr = [];
	var insttab = document.getElementById("WiZConf1");
	var rowsize = insttab.rows.length;
	for (var i = 0; i <rowsize; i++) {
		var instancename = document.getElementById("nwinstname").value;
		instarr.push(instancename);
	}
	return instarr;
}

function showSpinner() {
	setVisible('#loading', true);
	setTimeout(closeSpinner, 23000);
}

function setVisible(selector, visible) {
	document.querySelector(selector).style.display = visible ? 'block' : 'none';
}

function closeSpinner() {
	document.getElementById('loading').style.display = 'none';
}

function show2Spinner() {
	set2Visible('#loading', true);
	setTimeout(close2Spinner, 8000);
}

function set2Visible(selector, visible) {
	document.querySelector(selector).style.display = visible ? 'block' : 'none';
}

function close2Spinner() {
	document.getElementById('loading').style.display = 'none';
}
function showErrorMsg(errormsg)
{
	alert(errormsg);
}
	</script>
</script>
   </head>
   <body>
      <div class="loading" id="loading" style="text-align:center"></div>
      <label class="page" style="text-align:center"></label>
	  <input type="text" id="ipsecrwcnt" name="ipsecrwcnt" value="1" hidden="">
      <form action="savepage.jsp?page=ipsec_multi&slnumber=<%=slnumber%>&action=apply" method="post" onsubmit="">
         <blockquote>
            <p align="center" class="style1">IPSEC with Multitunnel</p>
         </blockquote>
         <table align="center" id="WiZConf">
            <thead>
               <tr>
                  <th align="center" style="text-align:center;" width="50px">Sr No</th>
                  <th align="left" style="text-align:center;" width="90px">Instance Name</th>
                  <th align="center" style="text-align:center;" width="30px">Enable</th>
                  <th align="center" style="text-align:center;" width="90px">Preffered Peer</th>
                  <th align="center" style="text-align:center;" width="40px">Local Crypto Endpoint </th>
                  <th align="center" style="text-align:center;" width="30px">Status</th>
                  <th align="center" style="text-align:center;" width="60px">Up Time</th>
                  <th align="center" style="text-align:center;" width="80px">Action</th>
               </tr>
			   </thead>
			   <tbody>
            </tbody>
         </table>
         <br><br><br><br>
         <table align="center" id="WiZConf1">
            <tbody>
               <tr>
                  <td width="180px">New Instance Name</td>
                  <td><input type="text" style="align:center;" class="text1" id="nwinstname" name="nwinstname" minlength="2" maxlength="32" value="" onkeypress="return AlphaNumericOnly(event)" onfocusout="isEmpty('nwinstname','Instance Name')"></td>
                  <td colspan="2"><button type="button" class="button1" id="add" value="Add" onclick="addnewinstnametoipsecconfig('nwinstname','<%=slnumber%>','<%=fmversion%>');">Add</button></td>
               </tr>
            </tbody>
         </table>
         <div align="center"> <input type="submit" value="Apply" class="button"></div>
         <br>
         <p align="center">Note: Any Edits are reflected in the IPSec Track Configurations.<br>Please verify Track Configurations after any Edit.</p>
      </form>
   </body>
   <% 
					int row = 0;
            	   for(int j=0;j<ipsecnumarr.size();j++)
            	   {
            		    JSONObject ipsecobj = ipsecnumarr.getJSONObject(j);
						String action = ipsecobj.containsKey("action")?ipsecobj.getString("action"):"";
						if(action.equals("Delete"))
							continue;
						else {
							row++;
            		    String instancename = ipsecobj.getString("instancename")==null? "":ipsecobj.getString("instancename");
            		    String enable = ipsecobj.getString("Activation")==null? "No":ipsecobj.getString("Activation").equals("Enable")?"Yes":"No";
                  		String prfpeer = ipsecobj.getString("DualPeer")==null? "Single Peer":ipsecobj.getString("DualPeer").equals("Enable")?"Dual Peer":"Single Peer";
                  		String lclcptepnt = ipsecobj.getString("interface")==null? "":ipsecobj.getString("interface");
                  		String status = ipsecobj.getString("status")==null? "":ipsecobj.getString("status");
                     %>
                   <script type="text/javascript">
	 				 addRow('WiZConf','<%=fmversion%>');
	 				addTunnelData(<%=row%>,'<%=instancename%>','<%=enable%>','<%=prfpeer%>','<%=lclcptepnt%>','<%=status%>');
	 			 </script>
				   <%}
				   }%>
<%if(errorstr != null && errorstr.trim().length() > 0)
{%>
 <script>
 showErrorMsg('<%=errorstr%>');
 </script>
<%}
%>				   
</html>