<%@page import="com.nomus.staticmembers.DateTimeUtil"%>
<%@page import="com.nomus.m2m.pojo.License"%>
<%@page import="com.nomus.m2m.dao.LicDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/bootstrap.jsp" flush="false">
  <jsp:param name="title" value="User Account" />
  <jsp:param name="headTitle" value="License Info" />
  <jsp:param name="operation" value="settings" />
  <jsp:param name="breadcrumb" value="User Account" />
</jsp:include>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="css/jquery-ui.css">
<script src="js/jquery.js"></script>
<script src="js/jquery-ui.js"></script>
<script src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/imission/m2m/wizngv2/js/common.js"></script>
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
$(function() {
    $( "#expdate" ).datepicker({
        changeMonth: true,
        changeYear: true,
        minDate: 0,
		dateFormat: 'dd-mm-yy'
    });
});
function isNumber(input)
{
	var regex=/^[0-9]+$/;
    if (input.match(regex))
        return true;
    else 
    return false;    
}
function saveKeyData()
{
	 var altmsg = "";
	 var organization = document.getElementById("orgname").value;
	 var location = document.getElementById("location").value;
	 var expDate = document.getElementById("expdate").value;
	 var nodelimit = document.getElementById("nodelimit").value.trim();
	 var key= document.getElementById("key").value;
	 //var macaddr = document.getElementById("macaddr").value;
	/*  var email = document.getElementById("email").value;
	 emailformat=/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
	 var macformat = /^([0-9a-fA-F]{2}[:-]?){5}[0-9a-fA-F]{2}$/; */
	 if(organization.trim().length == 0)
		altmsg += "Organization Name should not be empty\n";
	 if(location.trim().length == 0)
		 altmsg += "Location should not be empty\n";
	/* if(macaddr.trim() == "")
			altmsg += "MAC Address should not be empty\n";
	else {
		if(!macaddr.match(macformat) && (macaddr.split(":").length != 6 || macaddr.split("-").length != 6))
			altmsg+="Invalid MAC Address!\n";
	} */
	 /* if(email.trim().length == 0)
		 altmsg += "Email ID should not be empty\n";
	 else {
		 if(!email.match(emailformat))
		    	altmsg+="Invalid Email!\n";
	 } */
	 if(expDate.trim().length == 0)
		 altmsg += "Expire Date should not be empty\n";
	 else if(!isValidDateFormat(expDate.trim()))
	    	altmsg+="Invalid Expire Date!\n";
	 if(nodelimit.length == '')
		 altmsg += "Nodes Limit should not be empty\n";
	 else if(!isNumber(nodelimit))
		 altmsg += "Invalid Nodes Limit\n";
	 if(key.trim().length == '')
		 altmsg += "Key should not be empty\n";
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
function isValidDateFormat(dateString) {
	  // Regular expression to match DD-MM-YYYY format
	  var regex = /^\d{2}-\d{2}-\d{4}$/;
	  return regex.test(dateString);
}
function avoidSpace(event) 
{
	var k = event ? event.which : window.event.keyCode;
  var element = event.target;
  var inputType = element.type;

	if (k == 32) {
		alert("Space is not allowed.");
		return false;
	}   
  if (inputType == "number") {
      if(k<48 || k>57)
      {
          alert("Enter Number Only.");
          return false;
      }
  }
  return true;
}
</script>
</head>
<body>
<% 
String msg_str = request.getAttribute("msg")==null?"":(String)request.getAttribute("msg");
if(session.getAttribute("msg")!=null )
	session.removeAttribute("msg");
LicDao ldao = new LicDao();
License lic = ldao.getLicenseDetails();

String orgname = lic == null ? "":lic.getOrgName();
String location = lic == null ? "":lic.getLocation();
String expdate = lic == null ? "": DateTimeUtil.getDateString(lic.getValidUpTo());
String nodelimit = lic == null ?"" : lic.getNodeLimit()+"";
String key = lic == null ? "" :lic.getKey();
%>
<form method="post" action="LicenseValidate" onsubmit="return saveKeyData()">
      <table>
        <thead>
		<div class="panel-heading" align="center" style="margin-top: 10px;width:50%;">
			<h3 class="panel-title" align="left">License Key</h3>
		</div>
		</thead>
		<tbody>
		  <tr>
		  <td>
				<label for="org_name" >Organization Name</label>
				</td>
				<td>
					<input type="text" id="orgname" name="orgname" value='<%=orgname%>' />
			</td>
			</tr>
			
			<tr>
		    <td>
				<label for="location" >Location</label>
				</td>
				<td><input type="text" id="location" name="location" value='<%=location%>' />
			</td>
			</tr>
			<tr>
		    <td>
				<label for="nodelimit" >Nodes Limit</label>
				</td>
				<td>
					<input type="text"  id="nodelimit" name="nodelimit" maxlength="9" value='<%=nodelimit%>' onkeypress='return avoidSpace(event);'></input>
			</td>
			</tr>
			<tr>
		    <td>
				<label for="expdate" >Expiry Date</label>
				</td>
				<td>
					<input type="text"  id="expdate" name="expdate" class="datepicker" placeholder="dd-mm-yyyy" value='<%=expdate%>'></input>
			</td>
			</tr>
			<tr>
		    <td>
				<label for="key" >Key</label>
				</td>
				<td>
					<input type="text" id="key" name="key" value='<%=key%>' title='<%=key%>' onkeypress='return avoidSpace(event);'/>
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
			
		</tbody>
		
		</table>
		<%-- <input type="text" class="datepicker" id="expdate" name="expdate" value='<%=expdate%>' /> --%>
		<p style="font-size:14px; color:blue; padding-left:10%;"><%if(msg_str.length() > 0) {%><%=msg_str%><% if(msg_str.toLowerCase().contains("success")){%>go to <a href="login.jsp">Login</a><%}}%></p>
		</form>
</body>
</html>
<jsp:include page="/bootstrap-footer.jsp" flush="false"/>