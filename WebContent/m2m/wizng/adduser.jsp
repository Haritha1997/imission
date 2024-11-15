
<% 
String slnumber = request.getParameter("slnumber");
%>
<html>
   <head>
      <style type="text/css">#WiZConf {font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;font-size: 12.5px;border-collapse: collapse;width: 360px;}#invisible{font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;font-size: 12.5px;border-collapse: collapse;width: 360px;}#WiZConf td, #WiZConf th {border: 2px solid #ddd;  padding: 8px;}#WiZConf tr:nth-child(even){background-color: #f2f2f2;}#WiZConf tr:hover {background-color: #d3f2ef;}#WiZConf th {padding-top: 12px;padding-bottom: 12px;text-align: left;background-color: #5798B4;color: white;}.text {background: white;border: 2px Solid #DDD;border-radius: 5px;box-shadow: 1 1 5px #DDD inset;color: #000;height:17px;width: 140px;}.button{display: inline;border-radius:6px;background-color:#6caee0;color: #ffffff;font-weight: bold;box-shadow: 1px 2px 4px 0 rgba(0, 0, 0, 0.08);padding: 12px 20px;border: 0;margin: 10px 10px 0;}.style1{font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;color:#5798B4;font-size: 16px;font-weight: bold;}#errorlbl{color:red;}body{background-color: #FAFCFD;}</style>
      <script type="text/javascript">function avoidSpace(event) {var k = event ? event.which : window.event.keyCode;if (k == 32) {alert("space is not allowed");return false;}}function validatePwd(event) {var uname = document.getElementById("username").value;var pwd1 = document.getElementById("password1").value;var pwd2 = document.getElementById("password2").value;var err_lbl = document.getElementById("errorlbl");if(uname.trim() == ""){err_lbl.innerHTML="Username should not be empty";return false;}if(pwd1 == pwd2){err_lbl.innerHTML="";if(pwd1.trim() != "")return true;else{err_lbl.innerHTML="Password should not be mempty";return false;}}else{err_lbl.innerHTML="Password is not matched";return false;}}function SpecialKeyOnly(e) {var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;if((keyCode == 32) ){alert("space is not allowed");return false;}if (keyCode == 34) return false;return true;}  </script>
      <title>Add User Configuration</title>
   </head>
   <body>
      <form name="f1" action="savepage.jsp?page=adduser&slnumber=<%=slnumber%>" method="post" onsubmit="return validatePwd()">
         <p class="style1" align="center">Add User Configuration</p>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th>Parameters</th>
                  <th>Configurations</th>
               </tr>
               <tr>
                  <td><label>Username</label></td>
                  <td><input type="text" id="username" name="username" onkeypress="return SpecialKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td><label>Password</label></td>
                  <td><input type="password" id="password1" name="password1" onkeypress="return SpecialKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td><label>Confirm Password</label></td>
                  <td><input type="password" id="password2" name="password2" onkeypress="return SpecialKeyOnly(event)"></td>
               </tr>
            </tbody>
         </table>
         <table id="invisible" align="center">
            <tbody>
               <tr>
                  <td colspan="2"><label id="errorlbl"></label></td>
               </tr>
               <tr></tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" value="Submit" onsubmit="" class="button"></div>
      </form>
      <script src="js/timeout.js" type="text/javascript"></script>
   </body>
</html>

