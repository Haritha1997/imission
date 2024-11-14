<%@page import="com.nomus.staticmembers.DateTimeUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.nomus.staticmembers.TripleDES"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="com.nomus.staticmembers.UserRole"%>
<%@page import="com.nomus.m2m.dao.UserDao"%>
<%@page import="com.nomus.m2m.pojo.User"%>


<%
	User resetuser = null;
    String encstr = request.getParameter("reset");
    
    String url = request.getScheme() + "://" +request.getServerName() +":" +request.getServerPort() +request.getRequestURI() +"?reset="+encstr;  
    String status = "";
    String resetusername="";
    boolean link = false;
	if(encstr == null)
	{
		resetuser = (User) session.getAttribute("resetuser");
	}
	else
	{
		link = true;
		TripleDES tdes = new TripleDES();
		String decstr = tdes.decrypt(encstr);
		String [] edcarr = decstr.split("&");
		int userid = Integer.parseInt(edcarr[0]);
		long millis = Long.parseLong(edcarr[1]);
		Calendar cal = Calendar.getInstance();
		Date curtime = cal.getTime();
		cal.setTimeInMillis(millis);
		Date linktime = cal.getTime();
		resetuser = new UserDao().getUser(userid);
		if(curtime.compareTo(DateTimeUtil.addHours(linktime, 1)) > 0 || resetuser.getLinkstatus().equals("expired"))
			response.sendRedirect("linkexpired.jsp?status=Link Expired");
		session.setAttribute("reseturl",url);
		
	}
	resetusername = resetuser ==null?"":resetuser.getUsername();
	if(session.getAttribute("status") != null)
	{
		status = session.getAttribute("status").toString();
		session.removeAttribute("status");
	}

%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/imission/css/jquery-ui.css">
 <link rel="stylesheet" type="text/css" href="/imission/css/bootstrap.css" media="screen"/>
 <link rel="stylesheet" type="text/css" href="/imission/css/font-awesome-4.3.0/css/font-awesome.min.css" />
<link rel="stylesheet" href="/imission/css/style.css">
 <link href="/imission/css/fontawesome.css" rel="stylesheet">
<script src="/imission/js/jquery.js"></script>
<script src="/imission/js/jquery-ui.js"></script>
<script type="text/javascript" src="/imission/m2m/wizngv2/js/common.js"></script>
<style type="text/css">
.Popup
{
    text-align:left;
    position: absolute;
    right: 15%;
    z-index:50;
    width: 180px;
    background-color: #DCDCDC;
    border:2px solid black;
    border-radius: 4%;
}
</style>
</head>
<script type="text/javascript">
$(document).on('click', '.toggle1-password', function () {
	$(this).toggleClass("fa-eye fa-eye-slash");
	var input = $("#pass1");
	input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
});
$(document).on('click', '.toggle2-password', function () {
	$(this).toggleClass("fa-eye fa-eye-slash");
	var input = $("#pass2");
	input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
});
$(document).on('click', '.toggle3-password', function () {
	$(this).toggleClass("fa-eye fa-eye-slash");
	var input = $("#old_pass");
	input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
});
  function verifyGoForm(chkoldpwd) 
  {
	  var altmsg="";
	  var passwordobj=document.getElementById("pass1");
	  var cnfmpwd=document.getElementById("pass2");
	  if(!chkoldpwd)
		  {
		  var usernameobj=document.getElementById("username");
		  var oldpwd=document.getElementById("old_pass")
		  if(oldpwd.value.trim()=="")
	    	altmsg+="Old Password Should Not be Empty!\n";
		  if(usernameobj.value.trim() !="" && passwordobj.value.toLowerCase().trim().startsWith(usernameobj.value.trim()))
	        	altmsg += "New Password should not start with Username!\n";
		  }
	
	  var validpwd=pwdCheck("pass1","ResetPwd");
		//var paswdformat="^(?=.*)"+ "(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])"+ "(?=.*[!@$^&*()])"+ "(?=\\S+$).{8,}$";
	    if(passwordobj.value.trim()=="")
	    	altmsg+="New Password Should Not be Empty!\n";
	    else if(passwordobj.value.includes(" "))
	    	altmsg += "New Password Should Not Contain Spaces!\n";
	    else if(passwordobj.value.length<8)
	    	altmsg+="New Password must contain at least 8 or more characters!\n";
	    else if(!validpwd)
	    	altmsg+='New Password must contain at least one number and one uppercase and lowercase letter and Use Special Characters except " , '+" :  , '  and  ;\n";
 	    else if(passwordobj.value.trim()!=""&&cnfmpwd.value.trim()=="")
 	    	altmsg+="Confirm Password Should Not be Empty!\n";
 	    else if (document.getElementById("pass1").value != document.getElementById("pass2").value) 
			altmsg+="Password Doesn't matched!\n";
	  if (altmsg.trim().length == 0) 
		  return true;
	  else 
	  {
		alert(altmsg);
		return false;
	  }
}
  function cancelUser()
  {
      window.location.href = "login.jsp";
  }
  function showOrHidePWDInfo(id) 
  {
  	var dialog = document.getElementById('pwdinfo');
  	if(dialog.open)
  		dialog.close();
  	else
  		dialog.show();
  	return dialog;
  }
</script>
<div class="header sticky" style="border-bottom: 3px solid #ddd;margin-bottom:5px;background-color:white;">
<div>
<img src="/imission/images/iMission2.jpg" alt="imissionlogo" width="150" style="float:left;max-height:50px;"/>
	<div align="right">
       <div style="max-width:312px;min-width:312px;padding-top:2px;">
		   <div align="left">	   
		   <img src="/imission/images/nomus_logo.jpg"  alt="nomuslogo" width="320" height="80"/>
		   </div>
		</div>
	</div>
</div>
<div>
       <div class="panel-heading"> 
        <h3 class="panel-title">Please enter the new  and confirm passwords.</h3>
      </div>
      <br>
      <div class="panel-body">
        <form class="form-horizontal" role="form" id="resetUserPwdForm" method="post" name="newUserForm" action="/imission/user/UserController?action=ResetPassword&chkoldpwd=<%=!link?true:false%>" onsubmit="return verifyGoForm(<%=!link?false:true%>)">
       <input hidden  id="userid" type="text" name="userid"  value="<%=resetuser==null?"":resetuser.getId() %>" readonly></input>
        <%if(!link){ %>
        <div class="form-group">
		<label for="username" class="col-sm-2 control-label">Username:</label>
			<div class="col-sm-10">
			<input id="username" type="text" name="username" class="form-control" autocomplete="off" style="width: 300px;background-color: white;cursor:auto" value="<%=resetusername%>" onkeypress="return avoidSpace(event)" readonly>
			</div>
		</div>
		<div class="form-group" colspan="2">
		<label class="col-sm-2 control-label">Old Password:</label>
		<div class="col-sm-10">
			<input id="old_pass" type="password" name="old_pass" class="form-control col-sm-6" autocomplete="off"  readonly 
   				 onfocus="this.removeAttribute('readonly');" style="width: 300px;background-color: white;cursor:auto" value="" onkeypress="return avoidSpace(event)" title="Password must contain at least one Number and one Uppercase and Lowercase Letter and Use Special Characters Among !@$^&*()"/>
				<span toggle="#password-field"  class="fa fa-fw fa-eye field_icon toggle3-password col-sm-1 control-label"></span>
			</div>
		</div>
		<%} %>
		<div class="form-group">
		<label for="pass1" class="col-sm-2 control-label">New Password:</label>
		<div class="col-sm-10">
			<input id="pass1" type="password" name="pass1" class="form-control col-sm-6" autocomplete="off"  readonly 
   				 onfocus="this.removeAttribute('readonly');" style="width: 300px;background-color: white;cursor:auto" value="" onkeypress="return avoidSpace(event)" onkeyup="checkPwdStrength('pass1','pwdstr')" onfocusout="pwdCheck('pass1','ResetPwd');checkPwdStrength('pass1','pwdstr');" title="Password must contain at least one Number and one Uppercase and Lowercase Letter and Use Special Characters Among !@$^&*()"/>
			<span toggle="#password-field"  class="fa fa-fw fa-eye field_icon toggle1-password col-sm-1 control-label"></span>
			  <img  src="/imission/m2m/wizngv2/images/i_sym.jpg" alt="i" title="Info" id="pwdshow" class="col-sm-1 control-label" style="padding-right:2px;width:36px;" onclick="showOrHidePWDInfo('pwdinfo')"/>
					<dialog id="pwdinfo" class="Popup" style="border:1px dotted black;">  
						<p>Password must contain:</p><p>&#8226;Minimum 8 Characters</p><p>&#8226;One Numeric(0-9)</p><p>&#8226;One Uppercase Letter(A-Z)</p>
						<p>&#8226;One Lowercase Letter(a-z)</p><p>&#8226;One Special Character</p><p>&#8226;Excluded characters " ' : ? ;</p>
                     </dialog>
				<span id="pwdstr" class="col-sm-1 control-label" style="padding-right:2px;"></span>
		</div>
		</div>
		<div class="form-group">
		<label for="pass2" class="col-sm-2 control-label">Confirm Password:</label>
		<div class="col-sm-10">
			<input id="pass2" type="password" name="pass2" class="form-control col-sm-6" autocomplete="off"  readonly 
    			onfocus="this.removeAttribute('readonly');" style="width: 300px;display:inline;;background-color: white;cursor:auto" value="" onkeypress="return avoidSpace(event)" title="Password must contain at least one number and one uppercase and lowercase letter and Special Character, and at least 8 or more characters"/>
				<span toggle="#password-field"  class="fa fa-fw fa-eye field_icon toggle2-password col-sm-1 control-label" ></span>
		</div>
		
		</div>
          <div class="form-group">
				<div class="col-sm-offset-2 col-sm-10">
					<div class="btn-group" role="group">
						<button type="submit" class="btn btn-default">Submit</button>
					</div>
					<div class="btn-group" role="group">
						<button type="button" class="btn btn-default" onclick="cancelUser()">Cancel</button>
					</div>
				</div>
		</div>
		
        </form>
      </div> <!-- panel-body -->
   </div> <!--panel-->

</html>
<%if(status.trim().length() > 0){%>
<script>
alert('<%=status%>');
</script>
<%status="";} %>
<jsp:include page="/bootstrap-footer.jsp" flush="false" />