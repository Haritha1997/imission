<html>
   <head>
      <link href="css/style.css" rel="stylesheet" type="text/css">
      <link href="css/fontawesome.css" rel="stylesheet">
      <link href="css/solid.css" rel="stylesheet">
      <link href="css/v4-shims.css" rel="stylesheet">
      <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
      <script type="text/javascript" src="js/common.js"></script>
      <style>
	  .Popup
	  {
	    text-align:left;
	    position: absolute;
	    left: 70%;
	    z-index:50;
	    width: 150px;
	    background-color: #DCDCDC;
	    border:2px solid black;
	    border-radius: 6%;
	  }
      </style>
      <script type="text/javascript">
      <%
      String slnumber=request.getParameter("slnumber");
      String username = request.getParameter("username");
      String action = request.getParameter("action")==null?"edituser":request.getParameter("action");
      String errormsg = request.getParameter("error")==null?"":request.getParameter("error");
      %>
      $(document).on('click', '.toggle-password', function () {
    		$(this).toggleClass("fa-eye fa-eye-slash");
    		var input = $("#currentPassword");
    		input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
    	});
    	$(document).on('click', '.toggle1-password', function () {
    		$(this).toggleClass("fa-eye fa-eye-slash");
    		var input = $("#newPassword");
    		input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
    	});
    	$(document).on('click', '.toggle2-password', function () {
    		$(this).toggleClass("fa-eye fa-eye-slash");
    		var input = $("#confirmPassword");
    		input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
    	});
function validatePassword(){
	try{
	var altmsg="";
	var currpwd=document.getElementById("currentPassword");	
	var newpass = document.getElementById("newPassword");
	var cnfmpass = document.getElementById("confirmPassword");
	var pwdchevalid = pwdCheck("newPassword","Password");
	<%if(action.equals("edituser")){%>
	
	if(currpwd.value.trim()=="") {
		altmsg+="Current Password should not be empty\n";
		currpwd.style.outline = "thin solid red";
		currpwd.title = "Current Password should not be empty";
	}
	
	else if(currpwd.value == newpass.value)
	{
		altmsg +="Current Password and new Password should not be same\n";
		newpass.style.outline = "thin solid red";
		newpass.title = "Current Password and new Password should not be same";
		currpwd.style.outline = "thin solid red";
		currpwd.title = "Current Password and new Password should not be same";
	}
	else
	{
		newpass.style.outline = "initial";
		newpass.title = "";
		currpwd.style.outline = "initial";
		currpwd.title = "";
	}
<%}%>
	//var paswdformat="^(?=.*)"+ "(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])"+ "(?=.*[$@!*^&()])"+ "(?=\\S+$).{8,}$";
	if(newpass.value.trim()=="") {
		altmsg+="New Password should not be empty\n";
		newpass.style.outline = "thin solid red";
		newpass.title = "New Password should not be empty";
		//return false;
	}
	else if(newpass.value.length<8)
	    	altmsg+="Password must contain at least 8 or more characters!\n";
	else if(!pwdchevalid)
	    	altmsg+='Password must contain at least one number and one uppercase and lowercase letter and Use Special Characters except " , '+" :  , '  and  ;";
	else if(cnfmpass.value != newpass.value){
		altmsg+="Password is not matched\n";
		newpass.style.outline = "thin solid red";
		newpass.title = "Password is not matched";
		cnfmpass.style.outline = "thin solid red";
		cnfmpass.title = "Password is not matched";
		//return false;
	}
	else
	{
		newpass.style.outline = "initial";
		newpass.title = "";
		cnfmpass.style.outline = "initial";
		cnfmpass.title = "";
	}
	 
	//return true;
	if (altmsg.trim().length == 0)
    	return true;
    else {
       alert(altmsg);
       return false;
    }
	}catch(e)
	{
		alert(e);
	}
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
	  
   </head>
   <body>
      <form action="savedetails.jsp?page=edit_password&slnumber=<%=slnumber%>&action=<%=action%>" id="form" method="post" onsubmit="return validatePassword()">
         <br>
         <blockquote>
            <p align="center" id="output" class="style5"><%if(action.equals("adduser")){%> Add User <%}else{%>Edit Password<%}%></p>
            <br>
         </blockquote>
         <table class="borderlesstab" id="WiZConff" align="center">
            <tbody>
               <tr>
                  <th width="300px">Parameters</th>
                  <th width="200px">Configuration</th>
               </tr>
               <tr>
                  <td>Username</td>
                  <td><input type="text" class="text" name="username" id="username" value="<%=username%>" readonly=""></td>
               </tr>
               <%if(action.equals("edituser")){%>
               <tr>
                  <td>Current Password</td>
                  <td><input id="currentPassword" class="text" type="password" value="" name="currentPassword" onkeypress="return avoidSpace(event)"  maxlength="32"><span toggle="#password-field" class="fa fa-fw fa-eye field_icon toggle-password"></span></td>
               </tr>
               <%}%>
               <tr>
                  <td>New Password</td>
                  <td width="250">
                  <input id="newPassword" class="text" type="password" value="" name="newPassword" onkeypress="return avoidSpace(event)"  maxlength="32" onkeyup="checkPwdStrength('newPassword','pwdstr')" onfocusout="pwdCheck('newPassword','Password')"><span toggle="#password-field" class="fa fa-fw fa-eye field_icon toggle1-password"></span>
                   <img  src="images/i_sym.jpg" alt="i" width="15" height="10" title="Info" id="pwdshow" style="cursor:pointer" onclick="showOrHidePWDInfo('pwdinfo')"/>
					<dialog id="pwdinfo" class="Popup" style="width:15%;border:1px dotted black;">  
						<p>Password must contain:</p><br><p>&#8226;Minimum 8 Characters</p><br><p>&#8226;One Numeric(0-9)</p><br><p>&#8226;One Uppercase Letter(A-Z)</p><br>
						<p>&#8226;One Lowercase Letter(a-z)</p><br><p>&#8226;One special Character</p><br><p>&#8226;Excluded characters " ' : ? ;</p>
                     </dialog>
                  <br/>
                  	<p id="pwdstr"></p>
                  </td>
               </tr>
               <tr>
                  <td>Confirm Password</td>
                  <td><input id="confirmPassword" class="text" type="password" value="" name="confirmPassword" onkeypress="return avoidSpace(event)"  maxlength="32"><span toggle="#password-field" class="fa fa-fw fa-eye field_icon toggle2-password"></span></td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" style="display:inline" name="Save" value="Save" class="button2"></div>
      </form>
   </body>
   <%if(errormsg != null && errormsg.trim().length() > 0) {%>
   <script>
   		alert('<%=errormsg%>');
   </script>
   <%} %>
</html>