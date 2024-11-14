<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.hibernate.Session"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.SQLException" %>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.util.*" %>
<%@page import="java.lang.*" %>
   
   <jsp:include page="/bootstrap.jsp" flush="false">
   <jsp:param name="title" value="M2M"/>
   <jsp:param name="headTitle" value="M2M"/>
   <jsp:param name="limenu" value="Configuration"/>
   <jsp:param name="lisubmenu" value="<%=request.getParameter(\"lisubmenu\")%>"/>
  </jsp:include>

   <%
  	Vector<String> services_vec = new Vector<String>();
  	String remote = null;
  	String ipaddress = null ;
  	String loopbackip =null;
  	String nodename = null ;
	String export_status = "";
	String processed_str="";
	String non_processed_str="";
  	 String RED_OVAL = "down";
  	 int WHITE_OVAL = 1;
  	 int GREY_OVAL = 2;
  	 String GREEN_OVAL = "up";
	 String YELLO_OVAL = "inactive";
  	 String status = RED_OVAL;
	 String YES_STR = "yes";
  	 String NO_STR = "no";
	 int row=1;
	 String fetchtype = request.getParameter("type")==null?"all":request.getParameter("type");
	 String configtype = request.getParameter("configtype")==null?"edit":request.getParameter("configtype");
	 String lisubmenu = request.getParameter("lisubmenu")==null?"edit":request.getParameter("lisubmenu");
	 //System.out.println("Configuration type is:"+configtype);
	 boolean edit = false;
	 String bulkslnumbers = "";
	 String is_bulkedit="false";
	 User user = (User)session.getAttribute("loggedinuser");

	 if(session.getAttribute("m2medit")!=null)
	 {
		 edit = true;
		 session.removeAttribute("m2medit");
	 }
	 if(session.getAttribute("slnumbers")!=null)
	 {
		 bulkslnumbers = (String)session.getAttribute("slnumbers");
		 session.removeAttribute("slnumbers");
	 }
	  if(session.getAttribute("bulkedit")!=null)
	 {
		 is_bulkedit = (String)session.getAttribute("bulkedit");
		 session.removeAttribute("bulkedit");
	 }
	  if(session.getAttribute("m2mprocessstatus")!=null)
	 {
		 export_status = (String)session.getAttribute("m2mprocessstatus");
		 session.removeAttribute("m2mprocessstatus");
	 }
	  if(session.getAttribute("processed")!=null)
	 {
		 processed_str = (String)session.getAttribute("processed");
		 session.removeAttribute("processed");
	 }
	  if(session.getAttribute("failed")!=null)
	 {
		 non_processed_str = (String)session.getAttribute("failed");
		 session.removeAttribute("failed");
	 }
	 
  	 Vector<String> firmvervec = new Vector<String>();
  	 try{
  		 File file1 = new File("");
  		Properties props = M2MProperties.getM2MProperties();
  		String firmpath = props.getProperty("firmwaredir");
  		File firmwaredir = new File(firmpath);
  		if(firmwaredir.exists())
  		{
  			for(File file : firmwaredir.listFiles())
  			{
  				if(file.isDirectory())
  				{
  					firmvervec.add(file.getName());
  				}
  			}
  		}

  	} catch (Exception e) {
  		e.printStackTrace();
  	}
  %>
<style>
.success
{
	color:green;
}
.fail{
	color:red;
}
p
{
	padding : 0px 0px 0px 0px;
	margin : 0px 0px 0px 0px;
}
#tab td
{
	padding : 1px;
	padding-left : 2px;
	vertical-align:middle;
}
#tab th,
{
  max-width:12%;
  margin:0px;
  padding : 4px px 4px 0px;
}
#tab td input
{
  max-width:80px;
}
input[type="checkbox"]	
{
  margin:0px;
  padding-right:10px;
  max-width:20px;
  display:inline;
  vertical-align:middle;
}
input[type="file"]{
	display:none;
}
#tab td img
{
 vertical-align:middle; 
 width:15px; 
 height:15px;
}
#sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0px;
  z-index: 1;
}
 #noanchordefalut
 {
	 color:black; 
 }
 html, body {margin: 1; height: 100%; overflow-y: hidden}
 #edit{
	font-size:20px;
	 cursor:pointer;
	 vertical-align:middle;
 }
 #submit
 {
	 height:30px;
	 outline:none;
	 margin :0px 5px 5px 0px;
 }
 .fa-edit
 {
	 padding-top:3px;
	 height:24px;
 }
 .btn
 {
	 border : 1px solid black;
	 height : 20px;
	 padding : 0;
 }
 label{
	 margin:0px;
 }
 select
 {
	 max-width:120px;
 }
</style>
<!-- <body onfocus="parent_disable();" onclick="parent_disable();"> -->
<body>
<script type="text/javascript">
var popupWindow=null;
var counter = 1;
function wizngPage(serialno,version)
{
  //popupWindow=window.open("http://localhost:82/cgi/Nomus.cgi", "popup", "directories=no, status=no, menubar=no, scrollbars=yes, resizable=no,width=800,height=600,top=200,left=200");
  //popupWindow=window.open("m2m/wizng/mainpage.jsp?slnumber="+serialno,"popup","directories=no, status=no, menubar=no, scrollbars=yes, resizable=no,width=800,height=600,top=200,left=200");
  var is_bulkedit = document.getElementById("bulk_edit").checked;
  var url = "wizng/mainpage.jsp?slnumber="+serialno+"&version="+version;
  if(version.startsWith(Symbols.WiZV2))
  {  
	  url = "wizngv2/window.jsp?slnumber="+serialno+"&version="+version;
  }
  if(is_bulkedit)
	  url +="&bulkedit="+is_bulkedit;
  window.open(url);
  //popupWindow = window.open("m2m/wizng/mainpage.jsp?slnumber="+serialno,counter++,"popup","directories=no, status=no, menubar=no, scrollbars=yes, resizable=no,width=800,height=600,top=200,left=200");
  //counter = counter%100;
}

function parent_disable() {
	if (popupWindow && !popupWindow.closed)
		popupWindow.focus();
	document.onmousedown = focusPopup;
	document.onkeyup = focusPopup;
	document.onmousemove = focusPopup;
}
	function focusPopup() {
		if (popupWindow && !popupWindow.closed) {
			popupWindow.focus();
		}
	}

	function displaystatus(status, processed, failed) {
		var msg = "";
		msg = status + "\n";
		if (processed.length > 0) {
			msg += "Processed : " + processed + "\n";
		}
		if (failed.length > 0) {
			msg += "The following are Failed due to selected File is invalid : "
					+ failed + "\n";
		}
		alert(msg);
	}
	function showEditCheckBoxes(slnums) {
		var slnumarr = slnums.split(",");
		document.getElementById("bulk_edit").checked = "true";
		for (var i = 0; i < slnumarr.length; i++) {
			var cbobj = document.getElementsByName(slnumarr[i] + "edit")[0];
			if (cbobj != null) {
				cbobj.checked = true;
				cbobj.style.display = 'inline';
			}
		}
	}
	function loadFile(serialno) {
		var is_bulkedit = document.getElementById("bulk_edit").checked;
		var slnumbers = "";
		if (is_bulkedit) {
			var cnt = document.getElementById("cnt").value;
			for (var i = 1; i < cnt - 1; i++) {
				if (document.getElementById("edit" + i).checked)
					slnumbers += document.getElementById("slid" + i).innerHTML
							.trim()
							+ ",";
			}
			if (document.getElementById("edit" + (cnt - 1)).checked)
				slnumbers += document.getElementById("slid" + i).innerHTML
						.trim();
		}
		const form = document.createElement('form');
		const hiddenField1 = document.createElement('input');
		hiddenField1.type = 'hidden';
		hiddenField1.name = "serialno";
		hiddenField1.value = serialno;
		form.appendChild(hiddenField1);
		const hiddenField2 = document.createElement('input');
		hiddenField2.type = 'hidden';
		hiddenField2.name = "bulkedit";
		hiddenField2.value = is_bulkedit;
		form.appendChild(hiddenField2);
		const hiddenField3 = document.createElement('input');
		hiddenField3.type = 'hidden';
		hiddenField3.name = "slnumbers";
		hiddenField3.value = slnumbers;
		form.appendChild(hiddenField3);
		document.body.appendChild(form);
		form.submit();
		//window.location.href="m2m/loadfile.jsp?serialno="+serialno+"&bulkedit="+is_bulkedit;
	}
	function uploadfile() {
		var cnt = document.getElementById("cnt").value;
		var bulk_config = document.getElementById("bulk_config");
		var blkcnfgfile = document.getElementById("bulk_configfile");
		var blkcnfgfileobj = blkcnfgfile.value;

		var filename = blkcnfgfileobj.substring(blkcnfgfileobj
				.lastIndexOf("\\") + 1);
		if (bulk_config.checked) {
			for (var i = 1; i < cnt; i++) {
				var exprtconfig = document.getElementById("browse" + i);
				exprtconfig.innerHTML = filename;
			}
		} else {
			alert("please tick the Bulk Config CheckBox before going to choose the file");
			blkcnfgfile.value = "";
		}
	}
	function changeFileName(lblid, fileobjid, checkobjid) {
		var filenamelblobj = document.getElementById(lblid);
		var fileobj = document.getElementById(fileobjid);
		var filepath = fileobj.value;
		var filename = filepath.substring(filepath.lastIndexOf("\\") + 1);
		var checkobjctid = document.getElementById(checkobjid)
		if (checkobjctid.checked) {
			filenamelblobj.innerHTML = filename;
		} else {
			alert("please Tick Export Config to upload the file");
			fileobj.value = "";
		}
	}
	function changebulkupgradeversion() {
		var cnt = document.getElementById("cnt").value;
		var bulk_upgrade = document.getElementById("bulk_upgd");
		var blkupgdvrsnobj = document.getElementById("bulkupgdvrsn");
		var blkupgdvrsn = blkupgdvrsnobj.value;
		if (bulk_upgrade.checked) {
			for (var i = 1; i < cnt; i++) {
				document.getElementById("upgdvrsn" + i).value = blkupgdvrsn;
			}
		} else {
			alert("please tick the Bulk Upgrade option before going to select the version");
			blkupgdvrsnobj.value = "";
		}
	}
	function checkandselectupgdvrsn(chckfwupgdid, upgrdvrsn) {
		var chckfwupgdobj = document.getElementById(chckfwupgdid);
		var upgdvrsnobj = document.getElementById(upgrdvrsn);
		if (!chckfwupgdobj.checked) {
			alert("please tick the Firmware Upgrade CheckBox and select the version");
			upgdvrsnobj.value = "";
			upgdvrsnobj.title = "";
			return false;
		} else {
			upgdvrsnobj.title = upgdvrsnobj.value;
			return true;
		}
	}
	function selectAll(type) {
		var cnt = document.getElementById("cnt").value;
		var table = document.getElementById("tab");
		var tablerows = table.rows;
		var searchval = document.getElementById("search").value.toLowerCase();
		if (type == "Config") {
			var bulk_config = document.getElementById("bulk_config");
			if (bulk_config.checked) {
				var confirmBox = confirm("Are you sure you want to Load? This action will Load all the devices");
				if (confirmBox == true) {
					for (var i = 1; i < cnt; i++) {
						var columns = tablerows[i].cells;
						for (var cidx = 0; cidx < 7; cidx++) {
							var innstr = columns[cidx].innerHTML.toLowerCase();
							if (innstr.includes(searchval)) {
								document.getElementById("config" + i).checked = true;
								break;
							}
						}

					}
				} else {
					document.getElementById("bulk_config").checked = false;
				}
			} else {
				for (var i = 1; i < cnt; i++)
					document.getElementById("config" + i).checked = false;
			}

		} else if (type == 'Upgrade') {
			var bulk_upgd = document.getElementById("bulk_upgd");
			if (bulk_upgd.checked) {
				var confirmBox = confirm("Are you sure you want to Upgrade? This action will Upgrade all the devices");
				if (confirmBox == true) {

					for (var i = 1; i < cnt; i++) {
						var columns = tablerows[i].cells;

						for (var cidx = 0; cidx < 7; cidx++) {
							var innstr = columns[cidx].innerHTML.toLowerCase();
							if (innstr.includes(searchval)) {
								document.getElementById("fwupgd" + i).checked = true;
								break;
							}
						}
					}
				} else {
					document.getElementById("bulk_upgd").checked = false;
				}
			} else {
				for (var i = 1; i < cnt; i++)
					document.getElementById("fwupgd" + i).checked = false;
			}

		} else if (type == 'Reboot') {
			var bulk_reboot = document.getElementById("bulk_reboot");
			if (bulk_reboot.checked) {
				var confirmBox = confirm("Are you sure you want to Reboot? This action will Reboot all the devices");
				if (confirmBox == true) {

					for (var i = 1; i < cnt; i++) {
						var columns = tablerows[i].cells;

						for (var cidx = 0; cidx < 7; cidx++) {
							var innstr = columns[cidx].innerHTML.toLowerCase();
							if (innstr.includes(searchval)) {
								document.getElementById("reboot" + i).checked = true;
								break;
							}
						}
					}
				} else {
					document.getElementById("bulk_reboot").checked = false;
				}

			} else {
				for (var i = 1; i < cnt; i++)
					document.getElementById("reboot" + i).checked = false;

			}

		} else if (type == 'edit') {
			var bulk_edit = document.getElementById("bulk_edit");
			if (bulk_edit.checked) {
				var confirmBox = confirm("Are you sure you want to bulk edit? This action will edit all the devices");
				if (confirmBox == true) {

					for (var i = 1; i < cnt; i++) {
						var columns = tablerows[i].cells;

						for (var cidx = 0; cidx < 7; cidx++) {
							var innstr = columns[cidx].innerHTML.toLowerCase();
							if (innstr.includes(searchval)) {
								document.getElementById("edit" + i).checked = true;
								document.getElementById("edit" + i).style.display = "inline"
								//document.getElementById("editlbl"+i).style.display ="inline";
								break;
							}
						}
					}
				} else {
					document.getElementById("bulk_edit").checked = false;
				}
			} else {
				for (var i = 1; i < cnt; i++) {
					document.getElementById("edit" + i).checked = false;
					document.getElementById("edit" + i).style.display = "none";
					//document.getElementById("editlbl"+i).style.display="none";
				}
			}
		}
	}
	function CheckOtherAndselectAll(type, id) {
		if (bulkcheckevent(id)) {
			selectAll(type);
		}
	}
	function bulkcheckevent(eventid) {
		var bulkids = [ "bulk_config", "bulk_upgd", "bulk_reboot", "bulk_edit" ];
		var selobj = document.getElementById(eventid);
		if (selobj.checked == false)
			return true;
		for (var i = 0; i < bulkids.length; i++) {
			if (bulkids[i] != eventid) {
				if (document.getElementById(bulkids[i]).checked) {
					selobj.checked = false;
					return false;
				}
			}
		}
		selobj.checked = true;
		return true;
	}

	function sinRowCheckEvent(id, rowid) {
		var ids = [ "config", "fwupgd", "reboot" ];
		var selobj = document.getElementById(id + rowid);
		if (selobj.checked == false)
			return true;
		for (var i = 0; i < ids.length; i++) {
			if (ids[i] != id) {
				if (document.getElementById(ids[i] + rowid).checked) {
					selobj.checked = false;
					return false;
				}
			}
			selobj.checked = true;
		}
		return true;
	}
	function validateM2M() {
		var altmsg = "";
		var table = document.getElementById("tab");
		var rows = table.rows;
		var bulkeditcheck = document.getElementById("bulk_edit");
		var bulkfilecheck = document.getElementById("bulk_config");
		var bulkfilename = document.getElementById("bulk_configfile").value;
		var bulkupgdcheck = document.getElementById("bulk_upgd");
		var bulkupgdvrsn = document.getElementById("bulkupgdvrsn").value;
		var checked_pro = false;

		if (bulkfilecheck.checked && bulkfilename.length == 0) {
			altmsg += "Please select the file at Bulk Config before Submit\n";
		}
		if (bulkupgdcheck.checked && bulkupgdvrsn == "") {
			altmsg += "Please select the version at Bulk Upgrade before Submit\n";
		}
		for (var i = 1; i < rows.length; i++) {
			var serialno = document.getElementById("slid" + i).innerHTML;
			var editcbobj = document.getElementById("edit" + i);
			var exconfobj = document.getElementById("config" + i);
			var fwupobj = document.getElementById("fwupgd" + i);
			var fwver = document.getElementById("upgdvrsn" + i);
			var rebootobj = document.getElementById("reboot" + i);
			var filename = document.getElementById("configfile" + i);
			if (exconfobj.checked) {
				if (filename.value.length == 0 && bulkfilename.length == 0)
					altmsg += "Please select the Config file for the Serial number "
							+ serialno + "\n";
				else
					checked_pro = true;
			} else if (fwupobj.checked) {
				if (fwver.value == "")
					altmsg += "Please select the Firmware Version to Upgrade for the Serial number "
							+ serialno + "\n";
				else
					checked_pro = true;
			} else if (rebootobj.checked || editcbobj.checked)
				checked_pro = true;
		}
		if (altmsg.trim().length == 0) {
			if (checked_pro == false) {
				altmsg += "Please select atleast one option";
				alert(altmsg);
				return false;
			}
			return true;
		} else {
			alert(altmsg);
			return false;
		}
	}
	function getSelFields() {
		var checkids = [ "Node_Label", "Cellular_IP", "Loopback_IP",
				"Serial_Number", "IMEI_NO", "Location", "Firmware_Version",
				"Config", "Export_Config", "Firmware_Upgrade", "Reboot",
				"Status" ];
		var selcols = "";
		for (var i = 0; i < checkids.length; i++) {
			var checkobj = document.getElementById(checkids[i]);
			if (checkobj.checked)
				selcols += checkids[i] + ",";
		}
		const form = document.createElement('form');
		form.method = "post";
		form.action = "userColumnsController";
		const hiddenField1 = document.createElement('input');
		hiddenField1.type = 'hidden';
		hiddenField1.name = "selcols";
		hiddenField1.value = selcols;
		form.appendChild(hiddenField1);
		form.submit();
	}
	$(function() {
		$(".openPopup").on("contextmenu", function() {
			$('#output').text($('#output').text() + 'Clicked! ');
		});
	});
</script>
<form id="m2mform" name="m2mform" class="form-horizontal" method="post" enctype="multipart/form-data" action="m2mprocess?configtype=<%=configtype%>&lisubmenu=<%=lisubmenu%>" onsubmit="return validateM2M()">
 <div align="right">
<!--<label for="search" style="float:left; padding-top:6px; vertical-align:middle;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Filter:&nbsp;</label>
<label style="float:left;"><input type="text" style="display:inline; height:20px;" id="search" name="search" placeholder="search" title="search" onkeyup="doFilter()" autofocus onfocus="this.value = this.value;"></label>-->
<label><%if(!fetchtype.equalsIgnoreCase("down")){%><label id="upcntlbl"></label><%}%><%if(!fetchtype.equalsIgnoreCase("up")){%><label id="downcntlbl"></label><%}%></label>
<!--<Button type="button"><a id="noanchordefalut" href="m2m/orgupdate.jsp">Organization Update</a></button>&nbsp;&nbsp;&nbsp;-->
<label style="margin-top:5px;" <%if(!configtype.equals("edit")){%> hidden <%}%>><input type="checkbox" name="bulk_edit" id="bulk_edit"  onchange="CheckOtherAndselectAll('edit','bulk_edit')"/><span>&nbsp;Bulk Edit</span></label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<label for="Bulk Config" style="margin-top:5px;" <%if(!configtype.equals("export")){%> hidden <%}%>><input type="checkbox" name="bulk_config" id="bulk_config" onchange="CheckOtherAndselectAll('Config','bulk_config')"/><span>&nbspBulk Config</span>&nbsp;&nbsp;<input type="file" style="display:inline;" id="bulk_configfile" accept=".zip" name="bulk_configfile" onchange="uploadfile()"/></label>
<label for=" Bulk Upgrade" style="margin-top:5px;" <%if(!configtype.equals("firmwareupgrade")){%> hidden <%}%>><input type="checkbox" name="bulk_upgd" id="bulk_upgd"  onchange="CheckOtherAndselectAll('Upgrade','bulk_upgd')"/><span>&nbspBulk Upgrade</span>&nbsp;&nbsp;<select style="height:20px; width:72px; display:inline;" name="bulkupgdvrsn" id="bulkupgdvrsn" onchange="changebulkupgradeversion()">
    <option value="">select</option>
	<% 
    for(int i=0;i<firmvervec.size();i++)
    {
   %>
    	<option value=<%=firmvervec.get(i)%>><%=firmvervec.get(i) %></option>
   <%
    }
  %>
  </select></label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<label <%if(!configtype.equals("reboot")){%> hidden <%}%> style="margin:5px;"><input type="checkbox" name="bulk_reboot" id="bulk_reboot" onchange="CheckOtherAndselectAll('Reboot','bulk_reboot')"/><span>&nbspBulk Reboot</span></label>
<input type="submit" id="submit" class="btn btn-default" value="Submit"></input>
</div>
<!-- <input type="hidden" id="uniquename" name="uniquename" /> -->
<!-- <div class="row top-buffer"> -->
<div style="overflow-y:scroll;max-height:62vh">
  <div>
	  <table class="table table-condensed" id="tab">
      <thead id="sticky">	  
				      <tr>
					<th width="7%"><div valign="middle">
					    Node Label
					<input type="checkbox" name="Node_Label" id="Node_Label" class="openPopup" checked onchange="showOrgPopup('Node_Label')" /></div></th>
					<th width="6%"><div valign="middle">
					    Cellular IP
					<input type="checkbox" name="Cellular_IP" id="Cellular_IP" checked onchange="getSelFields()"/></div></th>
					<th width="6%"><div valign="middle">
					    Loopback IP
					<input type="checkbox" name="Loopback_IP" id="Loopback_IP" checked onchange="getSelFields()"/></div></th>
					<th width="8%"><div valign="middle">
					      Serial Number
					<input type="checkbox" name="Serial_Number" id="Serial_Number" checked onchange="getSelFields()"/></div></th>
					<th width="9%"><div valign="middle">
					     IMEI NO
					<input type="checkbox" name="IMEI_NO" id="IMEI_NO" checked onchange="getSelFields()"/></div></th>
					<th width="7%"><div valign="middle">
					     Location
					<input type="checkbox" name="Location" id="Location" checked onchange="getSelFields()"/></div></th>
					<th width="9%"><div valign="middle">
					     Firmware Version
					<input type="checkbox" name="Firmware_Version" id="Firmware_Version" checked onchange="getSelFields()"/></div></th>
					<!--<th width="8%"><div valign="middle">
					     Router Uptime
					</div></th>
					<th width="6%"><div valign="middle">
					     Active Sim
					</div></th>
					<th width="5%"><div valign="middle">
					    Network
					</div></th>
					<th width="8%"><div valign="middle">
					     Signal Strength
					</div></th>-->
					<th width="5%" <%if(!configtype.equals("edit")){%> hidden <%}%>><div valign="middle">
					 Config
				   <input type="checkbox" name="Config" id="Config" checked onchange="getSelFields()"/></div></th>
					<th width="8%" <%if(!configtype.equals("export")){%> hidden <%}%>><div valign="middle">
					 Export Config
				   <input type="checkbox" name="Export_Config" id="Export_Config" checked onchange="getSelFields()"/></div></th>
				   <th width="9%" <%if(!configtype.equals("firmwareupgrade")){%> hidden <%}%>><div valign="middle">
						Firmware Upgrade
				   <input type="checkbox" name="Firmware_Upgrade" id="Firmware_Upgrade" checked onchange="getSelFields()"/></div></th>
				   <th width="6%" <%if(!configtype.equals("reboot")){%> hidden <%}%>><div valign="middle">
					Reboot
			       <input type="checkbox" name="Reboot" id="Reboot" checked onchange="getSelFields()"/></div></th>
				   <th width="5%"><div>
						Status
				   <input type="checkbox" name="Status" id="Status" checked onchange="getSelFields()"/></div></th>
				    </tr>
		</thead>				
<%
		Connection conn = null;
		Statement stmt= null;
		ResultSet rs = null;
		Session hibsession = null;
		try
		{    
			hibsession = HibernateSession.getDBSession();
			conn = ((SessionImpl) hibsession).connection();
			stmt = conn.createStatement();
			String slnumlist = user.getSlnumberLIstToString();
			String qry = "select * from Nodedetails where status='up' order by slnumber";
			if(slnumlist.trim().length() != 0 && !slnumlist.equalsIgnoreCase("all"))
				qry = "select * from Nodedetails where status='up' and slnumber in('"+slnumlist+"') order by slnumber";
			
			rs=stmt.executeQuery(qry);
            while(rs.next())
			{	
%>
<tbody id="rowdata">
<tr>
<!-- Node Label -->
  <td>
   <%
		nodename = rs.getString("nodelabel");
		if(nodename == null)
		{
			out.print("NA");
		}
		else{
			out.print(nodename);
		}	
	%>
  </td>
  <!-- IpAddress -->
  <td>
	<%
	ipaddress = rs.getString("ipaddress");
	if(ipaddress == null)
	{
		out.print("NA");
	}
	else{
		out.print(ipaddress);
	}	
%>
</td>
<!-- Loopback IP -->
<td>
	<%
	loopbackip  = rs.getString("loopbackip");
	if(loopbackip == null)
	{
		out.print("-");
	}
	else{
		out.print(loopbackip);
	}	
%>
  </td>
  <!-- Device Serial Number -->
  <td>
  <p id="slid<%=row%>">
    <%
		String deviceserialno = rs.getString("slnumber");
		if(deviceserialno == null || deviceserialno.equalsIgnoreCase("NA") || deviceserialno.equalsIgnoreCase("noSuchObject"))
		{
			out.print("");
		}
		else{
			out.print(deviceserialno);
		}	
	%>
  </p>
  </td>
  <!-- IMEI Number -->
  <td>
    <%
		String imeino = rs.getString("imeinumber");
		if(imeino == null)
		{
			out.print("");
		}
		else{
			out.print(imeino);
		}	
	%>
  
  </td>
  <!-- Location -->
  <td>
  <%
		String location = rs.getString("location");
		if(location!= null)
		{
			out.print(location);
		}
		else
		 out.print("");
   
  %>
</td>
<!-- Firmware Version -->
  <td>
  <%
		String fwvsn = rs.getString("fwversion")==null?"":rs.getString("fwversion").trim();
		if(fwvsn!= null)
		{
			out.print(fwvsn);
		}
		else
		 out.print("");
   
  %>
</td>
<!-- Router Uptime -->
  <!-- <td>
  <%
		String routeruptime = "";
		if(routeruptime!= null)
		{
			out.print(routeruptime);
		}
		else
		 out.print("-");
   
  %>
</td> -->
<!-- Active Sim -->
<!-- <td>
<%
		String actvsim = "";
		if(actvsim!= null)
		{
			out.print(actvsim);
		}
		else
		 out.print("-");
   
  %>
</td> -->
<!-- Network -->
  <!-- <td>
  <%
		String network = "";
		if(network!= null)
		{
			out.print(network);
		}
		else
		 out.print("-");
   
  %>
</td> -->
<!-- Signal Strength-->
  <!-- <td>
  <%
		String sgnalstnth = rs.getString("signalstrength");
		if(sgnalstnth!= null)
		{
			out.print(sgnalstnth);
		}
		else
		 out.print("-");
   
  %>
</td> -->
<!-- Config-->
<td  <%if(!configtype.equals("edit")){%> hidden <%}%>>
	  <!-- <label hidden id="editlbl<%=row%>"><input type="checkbox" name="<%=deviceserialno%>edit" id="edit<%=row%>" class="checkbox" /></label>&nbsp;&nbsp;-->
	  <label><input style="display:none" type="checkbox" name="<%=deviceserialno%>edit" id="edit<%=row%>" class="checkbox" /></label>
	  <label><i class="fa fa-edit" id="edit" title="Edit" onclick="wizngPage('<%=deviceserialno%>','<%=fwvsn%>');"></i></label>
</td>
<!-- Export Config-->
<td  <%if(!configtype.equals("export")){%> hidden <%}%>>

    <label><input type="checkbox"  name="<%=deviceserialno%>config" id="config<%=row%>" class="checkbox" onchange="sinRowCheckEvent('config','<%=row%>')"/></label>&nbsp;&nbsp;
    <label class="btn"><input type="file" id="configfile<%=row%>" accept=".zip" name="<%=deviceserialno%>configfile" onchange="changeFileName('browse<%=row%>','configfile<%=row%>','config<%=row%>')"><p id="browse<%=row%>">Browse</p></input></label>
</td>
<!--Firmware Upgrade-->
<td   <%if(!configtype.equals("firmwareupgrade")){%> hidden <%}%>>
  <label><input type="checkbox" name="<%=deviceserialno%>fwupgd" id="fwupgd<%=row%>" class="checkbox" onchange="sinRowCheckEvent('fwupgd','<%=row%>')"/>&nbsp;&nbsp;
  <select name="<%=deviceserialno%>upgdvrsn" id="upgdvrsn<%=row%>" onchange="checkandselectupgdvrsn('fwupgd<%=row%>','upgdvrsn<%=row%>')">
  <option value="">select</option>
  <% 
    for(int i=0;i<firmvervec.size();i++)
    {
   %>
    	<option value=<%=firmvervec.get(i)%>><%=firmvervec.get(i)%></option>
   <%
    }
  %>
</select></label>
</td>

<!-- Reboot-->
<td  <%if(!configtype.equals("reboot")){%> hidden <%}%>>
<label><input type="checkbox" name="<%=deviceserialno%>reboot" id="reboot<%=row%>" class="checkbox" onchange="sinRowCheckEvent('reboot','<%=row%>')"></label>
</td>
<!-- sttaus -->
<td >
    <%int result = 0;
	  String inprocess = NO_STR;
	if(configtype.equals("reboot"))
	{
		result = rs.getInt("rebootstatus");
		inprocess = rs.getString("reboot");
	}
	else if(configtype.equals("firmwareupgrade"))
	{
		result = rs.getInt("upgradestatus");
		inprocess = rs.getString("upgrade");
	}
	else if(configtype.equals("export"))
	{
		result = rs.getInt("exportstatus");
		inprocess = rs.getString("export");
	}
	else if(configtype.equals("edit"))
	{
		result = rs.getInt("sendconfigstatus");
		inprocess = rs.getString("sendconfig");
	}
	if(inprocess.equals(NO_STR))
	 {
	 if(result == 1)
	 {%>
	<label class="success"> Success</label>
	 <%} else if(result == 2){%>
	<label class="fail"> Fail</label>
	 <%}
	 } else if(inprocess.equals(YES_STR)){%>
	    <label>In Progress</label>
	<%}%>	
</td>
</tr>
	 <%  row++; }
		
		}
		catch(Exception e)
		{
			e.printStackTrace();	
	
	    }
		finally
		{
		try{
			if(hibsession != null)
				hibsession.close();
			if(stmt != null && !stmt.isClosed())
				stmt.close();
			if(rs != null && !rs.isClosed())
				rs.close();
				
		}
		catch(Exception e)
		  {
			
		  }
		}
     %>
</tbody>
</table>
<input hidden id="cnt" name="cnt" value="<%=row%>">
</div>	
</div>
</form>
<div id="output"></div>
<% if(edit == true)
{%>
<script type="text/javascript">
	wizngPage("");
</script>
<%}
if(export_status.trim().length() > 0 || non_processed_str.trim().length() > 0)
{%>
<script type="text/javascript">
	displaystatus("<%=export_status%>","<%=processed_str%>","<%=non_processed_str%>");
</script>
<%}if(is_bulkedit.equalsIgnoreCase("true"))
{
%>
<script type="text/javascript">
	showEditCheckBoxes("<%=bulkslnumbers%>");
</script>
<%}%>
</body>

<jsp:include page="/bootstrap-footer.jsp" flush="false"/>
