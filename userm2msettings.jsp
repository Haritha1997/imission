<%@page import="com.nomus.m2m.pojo.Organization"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="com.nomus.m2m.dao.M2MDetailsDao"%>
<%@page import="com.nomus.m2m.pojo.M2MDetails"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.util.Properties"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<jsp:include page="/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="M2M Configuration" />
	<jsp:param name="headTitle" value="User Configuration" />
</jsp:include>
<%
	User loguser = (User) session.getAttribute("loggedinuser");
	Organization selorg =loguser.getOrganization();
	String refresh = selorg.getRefresh();
	int refreshtime = selorg.getRefreshTime();
  	String mailusername = null;
  	String mailpassword = null;
  	int smtptport = 0;
  	String smtptserver=null;
  	M2MDetailsDao m2mdao = new M2MDetailsDao();
  	M2MDetails m2mdls = m2mdao.getM2MDetails(1);
  	if(m2mdls != null)
  	{
	  	mailusername = m2mdls.getUsername()==null ? "" : m2mdls.getUsername();
	  	mailpassword = m2mdls.getPassword()==null ? "" : m2mdls.getPassword();
	  	smtptport = m2mdls.getSmtptport() == 0 ? 587 : m2mdls.getSmtptport();
	  	smtptserver = m2mdls.getSmtpserver()==null ? "" : m2mdls.getSmtpserver();
  	}
  %>
<head>
<script src="/imission/js/jquery.js"></script>
<script src="/imission/js/jquery-ui.js"></script>
<script src="/imission/js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/imission/m2m/wizngv2/js/common.js"></script>
<script type="text/javascript">
$.noConflict();
$(document).on('click', '.toggle1-password', function () {
	   $(this).toggleClass("fa-eye fa-eye-slash");
	   var input = $("#pwd");
	   input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
	});
function hideRefTime(refid,reftimediv)
{
	var refobj = document.getElementById(refid);
	if(refobj.value == "yes")
		document.getElementById(reftimediv).style.display = "";
	else
		document.getElementById(reftimediv).style.display = "none";
}
  function validateUserM2MSettings() 
  {
	  try{
	  var altmsg="";
	  var emailval=document.getElementById("email").value.trim();
	  var passwordval=document.getElementById("pwd").value.trim();
	  var portval=document.getElementById("smtpport").value.trim();
	  var serverval=document.getElementById("smtpserver").value.trim();
	  emailformat=/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
	  if(emailval=="")
	    	altmsg+="Email Should Not be Empty!\n";
	  else if(!emailval.match(emailformat))
	    	altmsg+="Invalid Email!\n";
	  if(passwordval=="")
	    	altmsg+="Password Should Not be Empty!\n";
	  if(portval=="")
	    	altmsg+="SMTP Port Should Not be Empty!\n";
	  else if(!isNumber(portval))
	    	altmsg+="Invalid SMTP Port!\n";
	  if(serverval=="")
	    	altmsg+="SMTP Server Should Not be Empty!\n";
	  if (altmsg.trim().length == 0) 
		  return true;
	  else 
	  {
		alert(altmsg);
		return false;
	  }
	  
	  }catch(e){alert(e)}
}
</script>
</head>
<body>
<form class="form-horizontal" method="post"
		action="saveuserm2msettings" onsubmit="return validateUserM2MSettings()">
		<div class="row top-buffer">
			<div class="col-md-4">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">User M2M Settings</h3>
					</div>
					<div class="panel-body">
						<div class="form-group">
							<label for="refresh" class="col-sm-6 control-label">Refresh:</label>
							<div class="col-sm-6">
								<select name="selrefresh" id="selrefresh" onchange = "hideRefTime('selrefresh','reftimediv')">
									<option value="yes" <% if(refresh != null && refresh.equalsIgnoreCase("yes")) { %> selected <%} %>>YES</option>
									<option value="no" <% if(refresh != null && refresh.equalsIgnoreCase("no")) { %> selected <%} %>>NO</option>
								</select>
							</div>
						</div>
						<div class="form-group" id="reftimediv">
							<label for="refreshtime" class="col-sm-6 control-label">Refresh Time (sec):</label>
							<div class="col-sm-6">
								<select name="refreshtime" id="refreshtime">
									
									<option value="60" <% if(refreshtime == 60)  { %> selected <%} %>>60</option>
									<option value="90" <% if(refreshtime == 90)  { %> selected <%} %>>90</option>
									<option value="120" <% if(refreshtime == 120)  { %> selected <%} %>>120</option>
									<option value="150" <% if(refreshtime == 150)  { %> selected <%} %>>150</option>
									<option value="180" <% if(refreshtime == 180)  { %> selected <%} %>>180</option>
									<option value="210" <% if(refreshtime == 210)  { %> selected <%} %>>210</option>
									<option value="240" <% if(refreshtime == 240)  { %> selected <%} %>>240</option>
									<option value="270" <% if(refreshtime == 270)  { %> selected <%} %>>270</option>
									<option value="300" <% if(refreshtime == 300)  { %> selected <%} %>>300</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label for="email" class="col-sm-6 control-label">Email ID:</label>
							<div class="col-sm-6" >
								<input type="text"  id="email" name="email" value='<%=mailusername%>' onkeypress="return avoidSpace(event)"/>
							</div>
						</div>
						<div class="form-group">
						<label for="password" class="col-sm-6 control-label">Password:</label>
						<div class="col-sm-6">
							<input id="pwd" type="password" name="pwd" autocomplete="off"  readonly 
		                  onfocus="this.removeAttribute('readonly');"  style="width:160px;cursor:auto" value="<%=mailpassword%>" onkeypress="return avoidSpace(event)">
						<span toggle="#password-field"  class="fa fa-fw fa-eye field_icon toggle1-password"></span>
						</div>
					</div>
					<div class="form-group">
							<label for="smtpport" class="col-sm-6 control-label">SMTP Port:</label>
							<div class="col-sm-6" >
								<input type="text"  id="smtpport" name="smtpport" value='<%=smtptport%>' onkeypress="return avoidSpace(event)"/>
							</div>
					</div>
					<div class="form-group">
							<label for="smtpserver" class="col-sm-6 control-label">SMTP Server:</label>
							<div class="col-sm-6" >
								<input type="text"  id="smtpserver" name="smtpserver" value='<%=smtptserver%>' onkeypress="return avoidSpace(event)"/>
							</div>
						</div>
						<div class="panel-footer" align="center">
							<button align="center" type="submit" class="btn btn-default">Submit</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	<script type="text/javascript">
	hideRefTime('selrefresh','reftimediv');
	</script>
</body>
</html>
<jsp:include page="/bootstrap-footer.jsp" flush="false" />