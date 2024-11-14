<%@page import="com.nomus.staticmembers.UserRole"%>
<%@page import="com.nomus.m2m.dao.UserDao"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<jsp:include page="/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Change Password" />
  <jsp:param name="headTitle" value="Change Password" />
  <jsp:param name="breadcrumb" value="<a href='Changepassword.jsp'></a>" />
  <jsp:param name="breadcrumb" value="Change Password" />
</jsp:include>
<%
User user = (User)session.getAttribute("loggedinuser");
int userid = Integer.parseInt(request.getParameter("userid").toString().trim());
UserDao userdao = new UserDao();
User usertomodify = userdao.getUser(userid);
String username = session.getAttribute("username")==null?null:session.getAttribute("username").toString();
String status = "";
if(session.getAttribute("status") != null)
{
	status = session.getAttribute("status").toString();
	session.removeAttribute("status");
}
%>
<html>
<head>
<link rel="stylesheet" href="/imission/css/jquery-ui.css">
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
    left: 85%;
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
  function verifyGoForm() 
  {
	  var altmsg="";
	  var usernameobj=document.getElementById("username");
	  var oldpwd=document.getElementById("old_pass");
	  if(oldpwd.value.trim()=="")
	    	altmsg+="Old Password Should Not be Empty!\n";
	  var passwordobj=document.getElementById("pass1");
	  var cnfmpwd=document.getElementById("pass2");
	  var validpwd=pwdCheck("pass1","newPassword");
	  //var paswdformat="^(?=.*)"+ "(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])"+ "(?=.*[$@!*^&])"+ "(?=\\S+$).{8,}$";
	    if(passwordobj.value.trim()=="")
	    	altmsg+="New Password Should Not be Empty!\n";
	    else if(usernameobj.value.trim() !="" && passwordobj.value.toLowerCase().trim().startsWith(usernameobj.value.trim()))
        	altmsg += "New Password should not start with Username!\n";
	    else if(passwordobj.value.length<8)
	    	altmsg+="New Password must contain at least 8 or more characters!\n";
	    else if(!validpwd)
	    	altmsg+='New Password must contain at least one number and one uppercase and lowercase letter and Use Special Characters except " , '+" :  , '  and  ;\n";
	    else if(passwordobj.value.includes(" "))
	    	altmsg += "New Password Should Not Contain Spaces!\n";
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
      window.location.href = "Changepassword.jsp";
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

   <div class="panel panel-default">
       <div class="panel-heading"> 
        <h3 class="panel-title">Please enter the new  and confirm passwords.</h3>
      </div>
      <br>
      <div class="panel-body">
        <form class="form-horizontal" role="form" id="newUserForm" method="post" name="newUserForm" action="/imission/user/UserController?action=ChangePassword" onsubmit="return verifyGoForm()">
       <input hidden  id="userid" type="text" name="userid"  value=<%=usertomodify.getId()%> readonly></input>
        <div class="form-group">
		<label for="username" class="col-sm-2 control-label">Username:</label>
			<div class="col-sm-10">
			<input id="username" type="text" name="username" class="form-control" autocomplete="off" style="width: 300px;background-color: white;cursor:auto" value="<%=username==null?usertomodify.getUsername():username%>" onkeypress="return avoidSpace(event)" readonly>
			</div>
		</div>
		<div class="form-group" colspan="2">
		<label class="col-sm-2 control-label">Old Password:</label>
		<div class="col-sm-10">
			<input id="old_pass" type="password" name="old_pass" class="form-control col-sm-6"
				style="width: 300px;background-color: white;cursor:auto" value="" onkeypress="return avoidSpace(event)" autocomplete="off"  readonly 
   				 onfocus="this.removeAttribute('readonly');"/>
				<span toggle="#password-field"  class="fa fa-fw fa-eye field_icon toggle3-password col-sm-1 control-label"></span>
			</div>
		</div>
		<div class="form-group">
		<label for="pass1" class="col-sm-2 control-label">New Password:</label>
		<div class="col-sm-4">
			<input id="pass1" type="password" name="pass1" class="form-control col-sm-6" autocomplete="off"  readonly 
    			onfocus="this.removeAttribute('readonly');" style="width: 300px;background-color: white;cursor:auto" value="" onkeypress="return avoidSpace(event)" onkeyup="checkPwdStrength('pass1','pwdstr')" onfocusout="pwdCheck('pass1','newPassword');checkPwdStrength('pass1','pwdstr');"/>
			<span toggle="#password-field"  class="fa fa-fw fa-eye field_icon toggle1-password col-sm-1 control-label"></span>
			  <img  src="/imission/m2m/wizngv2/images/i_sym.jpg" alt="i" title="Info" id="pwdshow" class="col-sm-1 control-label" style="padding-right:2px;" onclick="showOrHidePWDInfo('pwdinfo')"/>
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