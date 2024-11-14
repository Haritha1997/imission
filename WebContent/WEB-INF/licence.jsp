<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/bootstrap.jsp" flush="false">
  <jsp:param name="title" value="User Account" />
  <jsp:param name="operation" value="settings" />
  <jsp:param name="breadcrumb" value="User Account" />
</jsp:include>
<% 
String msg_str = request.getParameter("status");
if(msg_str == null)
{
	if(session.getAttribute("status") != null)
	{
		msg_str =  session.getAttribute("status").toString();
	 	session.removeAttribute("status");
	}
}
else
	session.removeAttribute("status");
msg_str = msg_str==null?"":msg_str;
String orgname = request.getParameter("orgname") == null ? "":request.getParameter("orgname");
String location = request.getParameter("location") == null ? "":request.getParameter("location");
String expdate = request.getParameter("expdate") == null ? "":request.getParameter("expdate");
String macAddress = request.getParameter("macaddr") == null ? "":request.getParameter("macaddr");
String email = request.getParameter("email") == null ? "" :request.getParameter("email");
%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="css/jquery-ui.css">
<script src="js/jquery.js"></script>
<script src="js/jquery-ui.js"></script>
<script src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript">
$.noConflict();
$(function() {
    $( "#expdate" ).datepicker({
        changeMonth: true,
        changeYear: true,
        minDate: 0,
		dateFormat: 'dd-mm-yy'
    });
});
function saveKeyData()
{
	 var altmsg = "";
	 var organization = document.getElementById("orgname").value;
	 var location = document.getElementById("loc").value;
	 var expDate = document.getElementById("expdate").value;
	 var macaddr = document.getElementById("macaddr").value;
	 var email = document.getElementById("email").value;
	 emailformat=/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
	 var macformat = /^([0-9a-fA-F]{2}[:-]?){5}[0-9a-fA-F]{2}$/;
	 if(organization.trim().length == 0)
		altmsg += "Organization Name should not be empty\n";
	 if(location.trim().length == 0)
		 altmsg += "Location should not be empty\n";
	if(macaddr.trim() == "")
			altmsg += "MAC Address should not be empty\n";
	else {
		if(!macaddr.match(macformat) && (macaddr.split(":").length != 6 || macaddr.split("-").length != 6))
			altmsg+="Invalid MAC Address!\n";
	}
	 if(email.trim().length == 0)
		 altmsg += "Email ID should not be empty\n";
	 else {
		 if(!email.match(emailformat))
		    	altmsg+="Invalid Email!\n";
	 }
	 if(expDate.trim().length == 0)
		 altmsg += "Expire Date should not be empty\n";
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
function displayerrmsg(msg)
{
	alert(msg);
}
</script>
</head>
<body>
<form class="form-horizontal" method="post" action="UserController?action=new" onsubmit="return saveKeyData()">
		<div class="panel-heading" align="center" style="margin-top: 10px;width:40%;">
			<h3 class="panel-title" align="left">License Key</h3>
		</div>
		<div class="panel-body">
			<div class="form-group" align="left">
				<label for="org_name" class="col-sm-2 control-label">Organization Name</label>
				<div class="col-sm-6" align="left">
					<input type="text" id="orgname" name="orgname" value='<%=orgname%>' />
				</div>
			</div>
			<div class="form-group" align="left">
				<label for="location" class="col-sm-2 control-label">Location</label>
				<div class="col-sm-6" align="left">
					<input type="text" id="loc" name="loc" value='<%=location%>' />
				</div>
			</div>
			<div class="form-group" align="left">
				<label for="mac_addr" class="col-sm-2 control-label">MAC Address</label>
				<div class="col-sm-6" align="left">
					<input type="text" id="macaddr" name="macaddr" value='<%=macAddress%>' maxlength="17"/>
				</div>
			</div>
			<div class="form-group" align="left">
				<label for="email" class="col-sm-2 control-label">Email ID</label>
				<div class="col-sm-6" align="left">
					<input type="text" class="datepicker" id="email" name="email" value='<%=email%>' />
				</div>
			</div>
			<div class="form-group" align="left">
				<label for="ex_pdate" class="col-sm-2 control-label">Expiry Date</label>
				<div class="col-sm-6" align="left">
					<input type="text" class="datepicker" id="expdate" name="expdate" value='<%=expdate%>' />
				</div>
			</div>
			
			<div class="form-group">
					<div class="col-sm-offset-2 col-sm-6">
						<div class="btn-group" role="group" style="padding-right: 20px;">
						<button type="submit" class="btn btn-default">Generate</button>
						</div>
					</div>
				</div>
			</div>
		</form>
<%if(msg_str.trim().length() > 0) {
%>
<script>
displayerrmsg('<%=msg_str%>');
</script>
<%}%>
</body>

</html>