<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="com.nomus.staticmembers.UserRole"%>
<%@page import="com.nomus.m2m.dao.UserDao"%>
<%@page import="com.nomus.m2m.pojo.User"%>


<%
	String status = "";
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
</head>
<script type="text/javascript">
  function verifyGoForm() 
  {
	  var altmsg="";
	  var usernameobj=document.getElementById("username");
	  if(usernameobj.value.trim()=="")
	  	altmsg+="Username Should Not be Empty!\n";
	  var emaildobj=document.getElementById("email");
	  emailformat=/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
	  if(emaildobj.value.trim()=="")
	  	altmsg+="Email Should Not be Empty!\n";
	  else if(!emaildobj.value.match(emailformat))
	  	altmsg+="Invalid Email";
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
        <h3 class="panel-title">Please enter the Username and Email.</h3>
      </div>
      <br>
      <div class="panel-body">
        <form class="form-horizontal" role="form" id="" method="post" name="UserforgotpwdForm" action="/imission/user/UserController?action=forgotPassword" onsubmit="return verifyGoForm()">
       <%-- <input hidden  id="userid" type="text" name="userid"  value="<%=frpwduser.getId()%>" readonly></input> --%>
        <div class="form-group">
		<label for="username" class="col-sm-2 control-label">Username:</label>
			<div class="col-sm-10">
			<input id="username" type="text" name="username" class="form-control"
			style="width: 300px" value="" onkeypress="return avoidSpace(event)">
			</div>
		</div>
		<div class="form-group" colspan="2">
		<label class="col-sm-2 control-label">Email:</label>
		<div class="col-sm-10">
			<input id="email" type="text" name="email" class="form-control col-sm-6"
				style="width: 300px" value="" onkeypress="return avoidSpace(event)"/>
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