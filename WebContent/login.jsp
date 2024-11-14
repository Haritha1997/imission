<%@page language="java"
	contentType="text/html"
	session="true"
	import="java.util.Map"%>

<%@ taglib prefix='c' uri='http://java.sun.com/jsp/jstl/core'%>
<%
	String errormsg = "";
	if(session.getAttribute("loginerror") != null)
	{
		errormsg = session.getAttribute("loginerror").toString();
		session.removeAttribute("loginerror");
	}
	String expmsg = "";
	if(session.getAttribute("expmsg") != null)
	{
		expmsg = session.getAttribute("expmsg").toString();
		session.removeAttribute("expmsg");
	}
%>
 <title>
    <c:forEach var="headTitle" items="${paramValues.headTitle}">
	<c:out value="${headTitle}" escapeXml="false"/> 
    </c:forEach>
   Login
</title> 
<link rel="stylesheet" type="text/css" href="imission/css/bootstrap.css" media="screen"/>
<link rel="shortcut icon" href="images/i_sym.png"/>
<head>
<style>
body{
	overflow:hidden;
}
#imagediv
{
	background-image: url("/imission/images/login-image.png");
	background-size: cover;
}
input[type=text], input[type=password] {
  height:25px;
  margin: 8px;
  display: inline-block;
  border-radius:5px;
  font-size:14px;
  margin-right:30px;
  margin-bottom: 20px;
}
#login
{
  text-align:center;
  margin-right:60px;
  font-size:14px;
}
.imgtext {
  position: absolute;
  top: 5%;
  right:25px;
  color:#FFF;
}
h6{
line-height:35px;
padding-top:0px;
font-family: Arial, Helvetica, sans-serif;
font-size:13px;	
font-weight:500;
}
span{
line-height:1px;
font-weight: 500;
font-size: 28px;
}
#missiontext{
font-family: "Times New Roman", Times, serif;
font-weight:500;
}
</style>

<script type="text/javascript">
$('#loginForm').attr('autocomplete', 'off');
function setpaddingToZero()
{
var padele = document.getElementById("paddingupdiv");
padele.style.paddingTop = '0px';
}

function setImageDivHeight()
{
	var imagediv= document.getElementById("imagediv");
	var curheight =(parseInt(window.innerHeight)-90);
	imagediv.style.height = curheight;
	imagediv.style.maxHeight = curheight;
	imagediv.style.backgroundSize = "100% "+curheight+"px";
}
function disableBack() { 
	window.history.forward(); 
	}
setTimeout("disableBack()", 0);
function setFieldsReadOnly()
{
	document.getElementById("input_j_username").readOnly = true;
	document.getElementById("input_j_password").style.display = "none";
	var pwd=document.getElementById("preventAutoPass");
	pwd.style.display = "";
	}
</script>
</head>
<body>
	<div style="padding-left:0.5%">
	  <form class="form-horizontal" role="form" id="loginForm" action="LoginController" method="post" style="margin-bottom:50px;" onsubmit="setFieldsReadOnly()" autocomplete="off">
			<table width="100%" height="100%">
			<tr>
			<td width="35%" style="vertical-align:top">
			 <table height="100%" width="100%" height="100%">
			 <tr style="height:200px;min-height:200px;max-height:200px">
				 <td style="min-width:300px;vertical-align:top;">
				 
					<div style="max-width:400px;min-width:312px;">
					    <img src="/imission/images/imission_logo.jpg" alt="imissionlogo" width="210px" height="70px"/>
					   </div>
				 </td>
				</tr>
				<tr>
					<td style="min-width:30%;text-align:center;vertical-align:top">
						<div class="form-group"  style="display:inline;">
							<!--<label for="input_j_username" class="col-sm-1 control-label">Username</label>-->							
							<input type="text" id="input_j_username" style="align:center;" name="j_username" autocomplete="off"  readonly 
    onfocus="this.removeAttribute('readonly');"
								<c:if test="${not empty param.login_error}"> value='<c:out value="${SPRING_SECURITY_LAST_USERNAME}"/>'
								</c:if> placeholder="Username" autofocus="autofocus">
								</input>
						</div>
						<br/>
						<div class="form-group" style="display:inline" id="dopwd">
							<!--<label for="j_password" class="col-sm-1 control-label">Password</label>-->					
							<input type="password"  id="input_j_password" name="j_password" placeholder="Password" autocomplete="off" autocomplete="off"  readonly 
    onfocus="this.removeAttribute('readonly');">
							<input type="password" style="display:none;" id="preventAutoPass" name="preventAutoPass" placeholder="Password" autocomplete="off">
						</div></br>
						<a href="forgotpwd.jsp" style="font-size:13px;margin-left:15%;margin-top:50%;">Forgot Password</a></br>
						<div class="form-group" style="display:inline" align="center">
							<label for="submit" class="col-sm-1 control-label"></label><br/>
							<input type="submit" value="Login" name="Login" id="login" class="btn btn-default"></input>
						</div>
						<p style="font-size:14px; color:red;"> <%=errormsg %></p><br/><br/>
						<p style="font-size:14px; color:red;"> <%=expmsg %></p>
						<input name="j_usergroups" type="hidden" value=""/>
					<c:if test="${not empty param.login_error}">
					 <div style="padding-top:80">
						   <p style="font-size:14px; color:black;">
								Your log-in attempt failed, please try again.
						   </p>
							  <%-- This is: AbstractProcessingFilter.SPRING_SECURITY_LAST_EXCEPTION_KEY --%>
							   <p style="font-size:14px; color:red;">Reason: ${SPRING_SECURITY_LAST_EXCEPTION.message}</p>
					  </div>		   
					</c:if>						
					</td>					
				</tr>
				</table>
				</td>
				<td width="65%" style="height:100%">
				<table width="100%" height="100%">
				<tr>
					<td style="min-width:60%; vertical-align:top;" id="imgtd">
					  <div id="imagediv">
						<!-- <div class="imgtext">
							<span><i style="padding-right:4px; font-family:italic">i</i><span id="missiontext">Mission</span></span>
							<p style="font-size:12px">Remote Management System</p>
						</div> -->
						</div>
						<!-- <img src="/imission/images/login-image.png" alt="loginimage" style="width:99.9%;height:91vh;max-height:91vh;padding:0;margin:0" /> -->
					</td>
				</tr>
				</table>
				</td>
			</tr>
			</table>
				</form>
					</div>
						</body>
					<script type="text/javascript">
					setImageDivHeight();
					if (document.getElementById) {
					  document.getElementById('input_j_username').focus();
					}
					var pwd=document.getElementById("preventAutoPass");
					pwd.value="hf983hfbiufasau23#/";
					//setpaddingToZero();
					</script>
<jsp:include page="bootstrap-footer.jsp" flush="false" />

 
 



