<%@page import="com.nomus.m2m.dao.BackUpDao"%>
<%@page import="org.hibernate.boot.model.relational.Database"%>
<%@page import="java.util.List"%>
<%@page import="com.nomus.m2m.pojo.BackUp"%>
<%@page import="com.nomus.m2m.pojo.License"%>
<%@page import="com.nomus.m2m.dao.LicDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/bootstrap.jsp" flush="false">
  <jsp:param name="title" value="User Account" />
  <jsp:param name="headTitle" value="BackUp" />
  <jsp:param name="operation" value="settings" />
  <jsp:param name="breadcrumb" value="User Account" />
</jsp:include>
<%
String status = "";
if(session.getAttribute("status") != null)
{
	status = session.getAttribute("status").toString();
	session.removeAttribute("status");
}
BackUpDao dbdao = new BackUpDao();
BackUp backup = null;
List<BackUp> backuplist= dbdao.getBackupList();
if(backuplist.size() > 0)
	backup = backuplist.get(0);

String bkpsts = (backup == null)? "No":backup.getBackupSts();
String bkpfor = backup == null ? "1":backup.getBackupForEvery()+"";
String bkppathname= (backup == null ||backup.getBackupPath()==null)? "":backup.getBackupPath();
String sendmail = backup == null ?"No" : backup.getSendMail();
String receivermail = (backup == null ||backup.getReceiverMail()==null)?"" : backup.getReceiverMail();
String bkptype = (backup == null||backup.getBackupType()==null)? "Local":backup.getBackupType();
String remproto= (backup == null ||backup.getRemoteProtocol()==null)? "SCP":backup.getRemoteProtocol();
String username= (backup == null ||backup.getUsername()==null)? "":backup.getUsername();
String pwd = (backup == null ||backup.getPassword()==null) ?"" : backup.getPassword();
String ipaddr = (backup == null ||backup.getIPaddress()==null) ? "" : backup.getIPaddress();
String port = (backup == null ||backup.getPort()==null) ? "" : backup.getPort();
%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="css/jquery-ui.css">
<script src="js/jquery.js"></script>
<script src="js/jquery-ui.js"></script>
<script src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/imission/m2m/wizngv2/js/common.js"></script>
<!-- <script type="text/javascript" src="/imission/m2m/wizng2v1/js/common.js"></script> -->
<style>
table
{
text-align: left;
}
table tbody tr td 
{
padding : 10px;
text-align: 
}
</style>
<script type="text/javascript">
$.noConflict();
$(document).on('click', '.toggle1-password', function () {
	   $(this).toggleClass("fa-eye fa-eye-slash");
	   var input = $("#pwd");
	   input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
	});
function validateBackUp()
{
	 var altmsg = "";
	 var path = document.getElementById("bkp_path").value.trim();
	 var sendmail = document.getElementById("send_mail").value.trim();
	 var receivermail = document.getElementById("receivermail").value.trim();
	 emailformat=/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
	 if(document.getElementById("bkp_sts").value.trim()=="Yes")
	 {
		 if(path=="")
			altmsg += "BackUp Path Name should not be empty\n";
		 if(sendmail=="Yes")
		 {
			 if(receivermail=="")
				altmsg+="Email Should Not be Empty!\n";
			 else if(!receivermail.match(emailformat))
				altmsg+="Invalid Email";
		 }
		 if(document.getElementById("bkp_type").value.trim()=="Remote")
		 {
			 var protocol=document.getElementById("bkp_remopts").value.trim();
			/*  if(protocol=="SCP")
			 { */
				 var username=document.getElementById("username").value.trim();
				 var pwd=document.getElementById("pwd").value.trim();
				 if(username=="")
					 altmsg += "Username should not be empty\n";
				 if(pwd=="")
					 altmsg += "Password should not be empty\n";
			// }
			 var ipaddr=document.getElementById("ipaddr");
			 var port=document.getElementById("port").value.trim();
			 var valid=validateIPOnly('ipaddr',true,'IP Address')
			 if(!valid)
			 {
				 if(ipaddr.value.trim()=="")
				 	altmsg += "IP Address should not be empty\n";
				 else
					 altmsg += "IP Address not valid\n";
				 ipaddr.style.outline="initial";
			 }
			 if(port=="")
				 altmsg += "Port should not be empty\n";
			
		 }
	 }
	 
	 if(altmsg.trim().length>0)
	 {
		alert(altmsg);
		return false;
	 }
	 else
	{
		return true;
	}	
}
function showbackupoptions()
{
	try{
	 var bkp_stsval = document.getElementById("bkp_sts").value.trim();
	 var sendmail=document.getElementById("send_mail").value.trim();
	
	 if(bkp_stsval=="Yes")
	 {
		 var bkptype=document.getElementById("bkp_type").value.trim();
		 var bkp_remopts=document.getElementById("bkp_remopts").value.trim();
		 document.getElementById("bkp_for_tr").style.display="";
		 document.getElementById("bkp_path_tr").style.display="";
		 document.getElementById("send_mail_tr").style.display="";
		 document.getElementById("bkp_type_tr").style.display="";
		 if(sendmail=="Yes")
			 document.getElementById("receivermail_tr").style.display="";
		 else
			 document.getElementById("receivermail_tr").style.display="none";
		 
		 if(bkptype=="Remote")
		 {
			 document.getElementById("remoteoptstab").style.display="";
			 /* if(bkp_remopts=="SCP")
			 {
				 document.getElementById("username_tr").style.display="";
				 document.getElementById("pwd_tr").style.display="";
			 }
			 else
			 {
				 document.getElementById("username_tr").style.display="none";
				 document.getElementById("pwd_tr").style.display="none";
			 } */
		 }
		 else
		 {
			 document.getElementById("remoteoptstab").style.display="none"; 
			 document.getElementById("username").value = "";
			 document.getElementById("pwd").value = "";
			 document.getElementById("ipaddr").value = "";
			 document.getElementById("port").value = "";
		 }
	 }
	 else
	 {
		 document.getElementById("bkp_for_tr").style.display="none";
		 document.getElementById("bkp_path_tr").style.display="none";
		 document.getElementById("bkp_type_tr").style.display="none";
		 document.getElementById("remoteoptstab").style.display="none";
		 document.getElementById("send_mail_tr").style.display="none";
		 document.getElementById("receivermail_tr").style.display="none"; 
	 }
	}catch(e){alert(e)} 
}
</script>
</head>
<body>
<form method="post" action="SaveBackUpsettings" onsubmit="return validateBackUp()">
      <table>
      <thead>
		<div class="panel-heading" style="width: 50%">
			<h3 class="panel-title" align="left">BackUp</h3>
		</div>
		</thead>
      <tr>
      <td>
      <table>
		<tbody>
		  <tr>
		  	<td><label for="bkp_sts" >BackUp:</label></td>
			<td>
				<select type="text" id="bkp_sts" name="bkp_sts" class="text1" style="min-width: 170px; min-height: 25px;" onchange="showbackupoptions();">
					<option value="No"	<%if(bkpsts.equals("No")){%>selected<%}%>>No</option>
					<option value="Yes" <%if(bkpsts.equals("Yes")){%>selected<%}%>>Yes</option>
				</select>
			</td>
			</tr>
			<tr id="bkp_for_tr">
			    <td><label for="location" >BackUp For Every:</label></td>
				<td>
					<select type="text" id="bkp_for_every" name="bkp_for_every" class="text1" style="min-width: 170px; min-height: 25px;">
						<option value="1" <%if(bkpfor.equals("1")){%>selected<%}%>>Daily</option>
						<option value="2" <%if(bkpfor.equals("2")){%>selected<%}%>>2Days</option>
						<option value="3" <%if(bkpfor.equals("3")){%>selected<%}%>>3Days</option>
						<option value="4" <%if(bkpfor.equals("4")){%>selected<%}%>>4Days</option>
						<option value="5" <%if(bkpfor.equals("5")){%>selected<%}%>>5Days</option>
						<option value="7" <%if(bkpfor.equals("7")){%>selected<%}%>>Weekly</option>
						<option value="10" <%if(bkpfor.equals("10")){%>selected<%}%>>10Days</option>
						<option value="15" <%if(bkpfor.equals("15")){%>selected<%}%>>15Days</option>
					</select>	
				</td>
			</tr>
			<tr id="bkp_type_tr">
		  	<td><label for="bkp_type" >BackUp Type:</label></td>
			<td>
				<select type="text" id="bkp_type" name="bkp_type" class="text1" style="min-width: 170px; min-height: 25px;" onchange="showbackupoptions();">
					<option value="Local"	<%if(bkptype.equals("Local")){%>selected<%}%>>Local</option>
					<option value="Remote" <%if(bkptype.equals("Remote")){%>selected<%}%>>Remote</option>
				</select>
			</td>
			</tr>
			<tr id="bkp_path_tr">
			    <td><label for="nodelimit" >BackUp Path:</label></td>
				<td>
					<input type="text"  id="bkp_path" name="bkp_path" value='<%=bkppathname%>' style="min-width: 170px; min-height: 25px;" onkeypress='return avoidSpace(event);' onmouseover="setTitle(this)"></input>
				</td>
			</tr>
			<tr id="send_mail_tr">
			  	<td><label for="org_name" >Send Mail:</label></td>
				<td>
					<select type="text" id="send_mail" name="send_mail" class="text1" style="min-width: 170px; min-height: 25px;" onchange="showbackupoptions();">
						<option value="No" <%if(sendmail.equals("No")){%>selected<%}%>>No</option>
						<option value="Yes" <%if(sendmail.equals("Yes")){%>selected<%}%>>Yes</option>
					</select>
				</td>
			</tr>
			<tr id="receivermail_tr">
			    <td><label for="nodelimit" >Email:</label></td>
				<td>
					<input type="text"  id="receivermail" name="receivermail" value='<%=receivermail%>' style="min-width: 170px; min-height: 25px;" onkeypress='return avoidSpace(event);' onmouseover="setTitle(this)"></input>
				</td>
			</tr>
		</tbody>
		</table>
		</td>
		<td>
		<table id="remoteoptstab">
		<tbody>
			<tr id="bkp_remopts_tr">
		  	<td><label for="bkp_remopts" >Remote Protocol:</label></td>
			<td>
				<select type="text" id="bkp_remopts" name="bkp_remopts" class="text1" style="min-width: 170px; min-height: 25px;" onchange="showbackupoptions();">
					<option value="SCP"	<%if(remproto.equals("SCP")){%>selected<%}%>>SCP</option>
					<option value="FTP" <%if(remproto.equals("FTP")){%>selected<%}%>>FTP</option>
				</select>
			</td>
			</tr>
			<tr id="username_tr">
			    <td><label for="username" >Username:</label></td>
				<td>
					<input type="text"  id="username" name="username" value='<%=username%>' style="min-width: 170px; min-height: 25px;" onkeypress='return avoidSpace(event);' onmouseover="setTitle(this)"></input>
				</td>
			</tr>
			<tr id="pwd_tr">
			    <td><label for="pwd" >Password:</label></td>
				<td>
					<input id="pwd" type="password" name="pwd" value="<%=pwd%>" style="min-width: 170px; min-height: 25px;" value="" onkeypress="return avoidSpace(event)">
						<span toggle="#password-field"  class="fa fa-fw fa-eye field_icon toggle1-password"></span>
				</td>
			</tr>
			<tr id="ipadd_tr">
			    <td><label for="ipaddr" >IP Address:</label></td>
				<td>
					<input type="text"  id="ipaddr" name="ipaddr" value='<%=ipaddr%>' style="min-width: 170px; min-height: 25px;" onkeypress='return avoidSpace(event);'onfocusout="validateIPOnly('ipaddr',false,'IP Address')"></input>
				</td>
			</tr>
			<tr id="port_tr">
			    <td><label for="port" >Port:</label></td>
				<td>
					<input type="number"  id="port" name="port" value='<%=port%>' min="1" max="65535" style="min-width: 170px; min-height: 25px;" onkeypress='return avoidSpace(event);'></input>
				</td>
			</tr>
		</tbody>
		
		</table>
		</td>
		</tr>
		<tr>
		    <td colspan="1">
				<div class="form-group">
					<div class="col-sm-offset-2 col-sm-6">
						<div class="col-sm-offset-2 col-sm-6">
							<div class="btn-group" role="group" style="padding-right: 20px;">
							<button type="submit" class="btn btn-default">Submit</button>
							</div>
						</div>
					</div>
				</div>
			</td>
			</tr>
		</table>
		</form>
</body>
<script type="text/javascript">
showbackupoptions();
</script>
</html>
<%if(status.trim().length() > 0){%>
<script>
alert('<%=status%>');
</script>
<%status="";} %>
<jsp:include page="/bootstrap-footer.jsp" flush="false"/>