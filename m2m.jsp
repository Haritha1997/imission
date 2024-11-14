<%@page import="com.nomus.m2m.pojo.Organization"%>
<%@page import="com.nomus.staticmembers.NodeStatus"%>
<%@page import="com.nomus.staticmembers.QueryGenerator"%>
<%@page import="com.nomus.m2m.pojo.NodeDetails"%>
<%@page import="com.nomus.m2m.dao.NodedetailsDao"%>
<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="com.nomus.staticmembers.UserRole"%>
<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.hibernate.Session"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.*"%>
<%@page import="com.nomus.staticmembers.Symbols"%>

<jsp:include page="/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="M2M" />
	<jsp:param name="headTitle" value="M2M" />
	<jsp:param name="limenu" value="Configuration" />
	<jsp:param name="lisubmenu"
		value="<%=request.getParameter(\"lisubmenu\")%>" />
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
  		Properties props = M2MProperties.getM2MProperties();
  		String firmpath = props.getProperty("firmwaredir");
  		File firmwaredir = new File(firmpath);
  		if(firmwaredir.exists())
  		{
  			for(File file : firmwaredir.listFiles())
  			{
  				if(file.isDirectory())
  					firmvervec.add(file.getName());
  			}
  		}

  	} catch (Exception e) {
  		e.printStackTrace();
  	}
  	Organization selorg =user.getOrganization();
  	String refresh = selorg.getRefresh();
  	int refreshtime = selorg.getRefreshTime();
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
#tab th
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
function wizngPage(serialno,version,cmpstr)
{
  var is_bulkedit = document.getElementById("bulk_edit").checked;
  var url = "wizng/mainpage.jsp?slnumber="+serialno+"&version="+version;
  if(version.startsWith(cmpstr))
  {  
	  //url = "wizngv2_with_new_pages/window.jsp?slnumber="+serialno+"&version="+version;
	 url = "wizngv2/window.jsp?slnumber="+serialno+"&version="+version;
  }
  if(is_bulkedit)
	  url +="&bulkedit="+is_bulkedit;
  window.open(url);
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
		var diff_versions = false;
		if(bulkfilecheck.checked && bulkfilename.length == 0) {
			altmsg += "Please select the file at Bulk Config before Submit\n";
		}
		if(bulkupgdcheck.checked && bulkupgdvrsn == "") {
			altmsg += "Please select the version at Bulk Upgrade before Submit\n";
		}
		for (var i = 1; i < rows.length; i++) 
		{
			var serialno = document.getElementById("slid" + i).innerHTML;
			var editcbobj = document.getElementById("edit" + i);
			var exconfobj = document.getElementById("config" + i);
			var fwupobj = document.getElementById("fwupgd" + i);
			var curfwver = document.getElementById("fwid" + i).innerHTML.trim();
			var fwver = document.getElementById("upgdvrsn" + i);
			var rebootobj = document.getElementById("reboot" + i);
			var filename = document.getElementById("configfile" + i);
			if(rebootobj.checked)
				checked_pro = true;
			if(!exconfobj.checked && !editcbobj.checked && !fwupobj.checked)
				continue;				
			//if(bulkfilecheck.checked && exconfobj.checked)
				//checked_pro = true;
			var fw_prfix="";
			if(curfwver.includes('_') && (curfwver.toLowerCase().startsWith('wizng2') ||  curfwver.toLowerCase().startsWith('wiz ng2') || curfwver.toLowerCase().startsWith('wiz_ng2')))
				fw_prfix = curfwver.substring(0,curfwver.indexOf('_')).trim();
			else if(curfwver.toLowerCase().startsWith('wizng1') || curfwver.toLowerCase().startsWith('wiz ng1') || curfwver.toLowerCase().startsWith('wiz_ng1'))
				fw_prfix = curfwver.substring(0,curfwver.toLowerCase().indexOf("ng1")+3).trim();
			else
				fw_prfix = curfwver.trim();
			if(!diff_versions)
			{
					if((bulkeditcheck.checked || bulkfilecheck.checked || bulkupgdcheck.checked))
					{
					for(var j=1;j< rows.length; j++)
					{
						var jfwver = document.getElementById("upgdvrsn" + j);
						var jserialno = document.getElementById("slid" + j).innerHTML;
						var jeditcbobj = document.getElementById("edit" + j);
						var jexconfobj = document.getElementById("config" + j);
						var jfwupobj = document.getElementById("fwupgd" + j);
						if((jexconfobj.checked || jeditcbobj.checked || jfwupobj.checked))
						{
							var curfwver_j = document.getElementById("fwid" + j).innerHTML.trim();
							var  jw_prfix = curfwver_j;
							
							if(curfwver_j.includes('_') && (curfwver_j.toLowerCase().startsWith('wizng2') ||  curfwver_j.toLowerCase().startsWith('wiz ng2') || curfwver_j.toLowerCase().startsWith('wiz_ng2')))
								jw_prfix = curfwver_j.substring(0,curfwver_j.indexOf('_')).trim();
							else if(curfwver_j.toLowerCase().startsWith('wizng1') || curfwver_j.toLowerCase().startsWith('wiz ng1') || curfwver_j.toLowerCase().startsWith('wiz_ng1'))
								jw_prfix = curfwver_j.substring(0,curfwver_j.toLowerCase().indexOf("ng1")+3).trim();
							if(fw_prfix != jw_prfix)
							{
									altmsg +="Please don't select different versions for ";
									if(bulkfilecheck.checked)
										altmsg += "Bulk Config\n";
									else if(bulkeditcheck.checked)
										altmsg += "Bulk Edit\n";
									else
										altmsg += "Bulk Upgrade\n";
									diff_versions = true;
									break;
							}
							else
							{
								if (exconfobj.checked) {
									if (filename.value.length == 0 && bulkfilename.length == 0) {
										if(!altmsg.includes("Please select the Config file for the Serial number "+ serialno.trim()))
										altmsg += "Please select the Config file for the Serial number "+ serialno.trim() + "\n";
									}
										else
										checked_pro = true;
								} else if (fwupobj.checked) {
									if (fwver.value == "") {
										if(!altmsg.includes("Please select the Firmware Version to Upgrade for the Serial number "+ serialno.trim()))
											altmsg += "Please select the Firmware Version to Upgrade for the Serial number "
												+ serialno.trim() + "\n";
									}
									else if(fwver.value.trim().toLowerCase().includes(fw_prfix.toLowerCase()))
										checked_pro = true;
									else
									{
										if(!altmsg.includes("This software Does not support "+curfwver.trim()+" with Serial Number "+serialno.trim()))
											altmsg += "This software Does not support "+curfwver.trim()+" with Serial Number "+serialno.trim()+"\n";
									}
								} else if (rebootobj.checked || editcbobj.checked)
									checked_pro = true;
							}
							
						}
					}
				}
				else
				{
					if (exconfobj.checked) {
						if (filename.value.length == 0 && bulkfilename.length == 0) {
							if(!altmsg.includes("Please select the Config file for the Serial number "+ serialno.trim()))
							altmsg += "Please select the Config file for the Serial number "+ serialno.trim() + "\n";
						}
							else
							checked_pro = true;
					} else if (fwupobj.checked) {
						if (fwver.value == "") {
							//if(!altmsg.includes("Please select the Firmware Version to Upgrade for the Serial number "+ serialno.trim()))
								altmsg += "Please select the Firmware Version to Upgrade for the Serial number "
									+ serialno.trim() + "\n";
						}
						else if(fwver.value.trim().toLowerCase().includes(fw_prfix.toLowerCase()))
							checked_pro = true;
						else
							{
							altmsg += "This software Does not support "+curfwver.trim()+" with Serial Number "+serialno.trim()+"\n";
							}
					} else if (rebootobj.checked || editcbobj.checked)
						checked_pro = true;
			}
			
			}
			else
				break;
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
	/* function showCheckBox(id)
	{
		//alert("in the function showCheckBox");
		document.getElementById(id).style.display = "";
	} */
	function hideCheckBox(id)
	{
		document.getElementById(id).style.display = "none";
	}
	<%-- function dorefresh()
	{
		var refobj = document.getElementById("refresh");
		if(refobj.checked)
		{
			var m = document.createElement('meta');
			  m.setAttribute("http-equiv",'<%=refresh.equalsIgnoreCase("yes")?"refresh":""%>');
			  m.setAttribute("content",'<%=refreshtime%>');
			  m.setAttribute("id","metatag");
			  document.head.appendChild(m);
		}
		else
		{
			 var meta = document.getElementById("metatag");
			 document.head.removeChild(meta);
		}
		
	} --%>
</script>
	<form id="m2mform" name="m2mform" class="form-horizontal" method="post" enctype="multipart/form-data" action="m2mprocess?configtype=<%=configtype%>&lisubmenu=<%=lisubmenu%>" onsubmit="return validateM2M()">
 <div align="right" >
 <%-- Refresh : 
    <label class="switch" style="vertical-align:middle;padding-right:30px;"><input type="checkbox" id="refresh" name="refresh" style="vertical-align:middle" onclick="dorefresh()" <%if(refresh != null && refresh.equals("yes")) {%> checked <%} %>></label> --%>
<label><%if(!fetchtype.equalsIgnoreCase("down")){%><label id="upcntlbl"></label><%}%><%if(!fetchtype.equalsIgnoreCase("up")){%><label id="downcntlbl"></label><%}%></label>
<label style="margin-top:5px;display:none;" <%if(!configtype.equals("edit")){%> hidden <%}%>><input type="checkbox" name="bulk_edit" id="bulk_edit"  onchange="CheckOtherAndselectAll('edit','bulk_edit')"/><span>&nbsp;Bulk Edit</span></label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<label for="Bulk Config" style="margin-top:5px;display:none;" <%if(!configtype.equals("export")){%> hidden <%}%>><input type="checkbox" name="bulk_config" id="bulk_config" onchange="CheckOtherAndselectAll('Config','bulk_config')"/><span>&nbspBulk Config</span>&nbsp;&nbsp;<input type="file" style="display:inline;" id="bulk_configfile" accept=".zip" name="bulk_configfile" onchange="uploadfile()"/></label>
<label for=" Bulk Upgrade" style="padding-right: 15px;" <%if(!configtype.equals("firmwareupgrade")){%> hidden <%}%> ><input type="checkbox" name="bulk_upgd" id="bulk_upgd"  onchange="CheckOtherAndselectAll('Upgrade','bulk_upgd')"/><span>&nbspBulk Upgrade</span>&nbsp;&nbsp;<select style="height:20px; width:72px; display:inline;" name="bulkupgdvrsn" id="bulkupgdvrsn" onchange="changebulkupgradeversion()">
<option value="">select</option>
<% for(int i=0;i<firmvervec.size();i++){%>
		<option value="<%=firmvervec.get(i)%>"><%=firmvervec.get(i) %></option>
<%}%>
</select></label>
<label <%if(!configtype.equals("reboot")){%> hidden <%}%> style="padding-right: 15px;"><input type="checkbox" name="bulk_reboot" id="bulk_reboot" onchange="CheckOtherAndselectAll('Reboot','bulk_reboot')"/><span>&nbsp;Bulk Reboot</span></label>
<label <%if(lisubmenu.equals("Edit")){%> hidden <%}%>><input type="submit" id="submit" class="btn btn-default" value="Submit"></input></label>
</div>
<div style="overflow-y:scroll;max-height:62vh">
  <div>
	  <table class="table table-condensed" id="tab">
      <thead id="sticky">	  
				      <tr>
					<th width="7%"><div valign="middle" onmouseover="showCheckBox('nlcb')" onmouseout="hideCheckBox('nlcb')">
					Node Label  <input type="checkbox" checked id="nlcb" style="display:none" onclick=""/>
					</div></th>
					<th width="7%"><div valign="middle" onmouseover="showCheckBox('celipcb')" onmouseout="hideCheckBox('celipcb')">
					    Connected IP
					  <input type="checkbox" checked id="celipcb" style="display:none" onclick=""/></div></th>
					<th width="6%"><div valign="middle" onmouseover="showCheckBox('lopipcb')" onmouseout="hideCheckBox('lopipcb')">
					    Loopback IP
					 <input type="checkbox" checked id="lopipcb" style="display:none" onclick=""/></div></th>
					<th width="8%"><div valign="middle" onmouseover="showCheckBox('slcb')" onmouseout="hideCheckBox('slcb')">
					      Serial Number
					 <input type="checkbox" checked id="slcb" style="display:none" onclick=""/></div></th>
					<th width="9%"><div valign="middle" onmouseover="showCheckBox('imeicb')" onmouseout="hideCheckBox('imeicb')">
					     IMEI NO
					 <input type="checkbox" checked id="imeicb" style="display:none" onclick=""/></div></th>
					<th width="7%"><div valign="middle" onmouseover="showCheckBox('loccb')" onmouseout="hideCheckBox('loccb')">
					     Location
					 <input type="checkbox" checked id="loccb" style="display:none" onclick=""/></div></th>
					<th width="9%"><div valign="middle" onmouseover="showCheckBox('fvcb')" onmouseout="hideCheckBox('fvcb')">
					     Firmware Version
					 <input type="checkbox" checked id="fvcb" style="display:none" onclick=""/></div></th>
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
				<th width="5%" <%if(!configtype.equals("edit")){%> hidden <%}%>>
					<div valign="middle" onmouseover="showCheckBox('concb')" onmouseout="hideCheckBox('concb')">
					Config
					<input type="checkbox" checked id="concb" style="display: none" onclick="" /></div></th>
				<th width="8%" <%if(!configtype.equals("export")){%> hidden <%}%>>
				<div valign="middle" onmouseover="showCheckBox('exconcb')" onmouseout="hideCheckBox('exconcb')">
				Export Config
				<input type="checkbox" checked id="exconcb" style="display: none" onclick="" /></div></th>
				<th width="9%" <%if(!configtype.equals("firmwareupgrade")){%>hidden <%}%>>
					<div valign="middle" onmouseover="showCheckBox('fucb')" onmouseout="hideCheckBox('fucb')">
					Firmware Upgrade
					<input type="checkbox" checked id="fucb" style="display: none" onclick="" /></div></th>
				<th width="6%" <%if(!configtype.equals("reboot")){%> hidden <%}%>>
					<div valign="middle" onmouseover="showCheckBox('rebcb')" onmouseout="hideCheckBox('rebcb')">
					Reboot 
					<input type="checkbox" checked id="rebcb" style="display: none" onclick="" /></div></th>
				<th width="5%" valign="middle" onmouseover="showCheckBox('stacb')" onmouseout="hideCheckBox('stacb')">
					<div>
					Status 
					<input type="checkbox" checked id="stacb" style="display: none" onclick="" /></div></th>
			</tr>
		</thead>
					<%

		try
		{    
			
			NodedetailsDao  nddao = new NodedetailsDao();
			List<NodeDetails> nodelist = nddao.getNodeList(user,NodeStatus.UP,true);
            for(NodeDetails node : nodelist)
			{	
              int nodeid = node.getId();
%>
<tbody id="rowdata">
<tr>
<!-- Node Label -->
<td>
	<%
		nodename = node.getNodelabel();
		if(nodename == null)
		{
			out.print("NA");
		}
		else{
			out.print(nodename);
		}	
	%>
</td>
<!-- Connected IP -->
<td>
	<%
	ipaddress = node.getIpaddress();
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
	loopbackip  = node.getLoopbackip();
	if(loopbackip == null)
	{
		out.print("-");
	}
	else{
		out.print(loopbackip.replace(" ", "<br/>"));
	}	
%>
</td>
<!-- Device Serial Number -->
<td>
	<p id="slid<%=row%>">
		<%
		String deviceserialno =node.getSlnumber();
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
		String imeino = node.getImeinumber();
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
		String location = node.getLocation();
		if(location!= null)
		{
			out.print(location);
		}
		else
		 out.print("");
   
  %>
</td>
<!-- Firmware Version -->
<td id="fwid<%=row%>">
	<%
		String fwvsn = node.getFwversion()==null?"":node.getFwversion().trim();
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
  String sgnalstnth = node.getSignalstrength();
  if(sgnalstnth!= null)
		{
			out.print(sgnalstnth);
		}
		else
		 out.print("-");
   
  %>
</td> -->
<!-- Config-->
<td <%if(!configtype.equals("edit")){%> hidden <%}%>>
	<!-- <label hidden id="editlbl<%=row%>"><input type="checkbox" name="<%=nodeid%>edit" id="edit<%=row%>" class="checkbox" /></label>&nbsp;&nbsp;-->
	<label><input style="display: none" type="checkbox" name="<%=nodeid%>edit" id="edit<%=row%>" class="checkbox" /></label> 
	<label><i class="fa fa-edit" id="edit" title="Edit" onclick="wizngPage('<%=deviceserialno%>','<%=fwvsn%>','<%=Symbols.WiZV2%>');"></i></label>
</td>
<!-- Export Config-->
<td <%if (!configtype.equals("export")) {%> hidden <%}%>>
<label><input type="checkbox" name="<%=nodeid%>config" id="config<%=row%>" class="checkbox" onchange="sinRowCheckEvent('config','<%=row%>')" /></label>&nbsp;&nbsp;
	<label class="btn"><input type="file" id="configfile<%=row%>" accept=".zip" name="<%=deviceserialno%>configfile" onchange="changeFileName('browse<%=row%>','configfile<%=row%>','config<%=row%>')"><p id="browse<%=row%>">Browse</p></input></label>
</td>
<!--Firmware Upgrade-->
<td <%if (!configtype.equals("firmwareupgrade")) {%> hidden <%}%>>
	<label><input type="checkbox" name="<%=nodeid%>fwupgd" id="fwupgd<%=row%>" class="checkbox" onchange="sinRowCheckEvent('fwupgd','<%=row%>')" />&nbsp;&nbsp;
	<select name="<%=deviceserialno%>upgdvrsn" id="upgdvrsn<%=row%>" onchange="checkandselectupgdvrsn('fwupgd<%=row%>','upgdvrsn<%=row%>')">
		<option value="">select</option>
			<%
				for (int i = 0; i < firmvervec.size(); i++) {
			%>
			<option value="<%=firmvervec.get(i)%>"><%=firmvervec.get(i)%></option>
			<%
				}
			%>
	</select></label>
</td>

<!-- Reboot-->
<td <%if (!configtype.equals("reboot")) {%> hidden <%}%>>
	<label><input type="checkbox" name="<%=nodeid%>reboot" id="reboot<%=row%>" class="checkbox" onchange="sinRowCheckEvent('reboot','<%=row%>')"></label>
</td>
<!-- sttaus -->
<td>
<%
	int result = 0;
	String inprocess = NO_STR;
	if (configtype.equals("reboot")) {
		result = node.getRebootstatus();
		inprocess = node.getReboot();
	} else if (configtype.equals("firmwareupgrade")) {
		result = node.getUpgradestatus();
		inprocess = node.getUpgrade();
	} else if (configtype.equals("export")) {
		result = node.getExportstatus();
		inprocess = node.getExport();
	} else if (configtype.equals("edit")) {
		result = node.getSendconfigstatus();
		inprocess = node.getSendconfig();
	}
	if (inprocess.equals(NO_STR)) 
	{
	if (result == 1) {
	%> <label class="success"> Success</label> 
	<%} else if(result == 2){%>
	<label class="fail"> Fail</label> 
	<%}
	} else if(inprocess.equals(YES_STR)){
		if(configtype.equals("firmwareupgrade"))
		{
			String fw_status = "FW in Queue";
			if(node.getUpgradestarttime() != null && result != 3)
				fw_status = "In Progress";
			else if(result == 3)
				fw_status = "Updating";
	%> 
		<label><%=fw_status %></label> 
	<% } else { %>	
	<label>In Progress</label> 
	
	<%}}%>
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
<script type="text/javascript">
	//dorefresh();
</script>
</body>

<jsp:include page="/bootstrap-footer.jsp" flush="false" />
