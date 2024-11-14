<html>
   <head>
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
	  <script type="text/javascript" src="js/common.js"></script>
	  <script type="text/javascript">
	  function validateDns() 
	  {
		var alertmsg = "";
		var dnameobj = document.getElementById("dname");
		var valid = validatename("dname", true, "Domain Name");
		if (!valid) {
			if (dnameobj.value.trim() == "") alertmsg += "Domain Name should not be empty\n";
			else alertmsg += "Domain Name is not valid\n";
		}
		if (alertmsg.trim().length == 0) return true;
		else {
			alert(alertmsg);
			return false;
		}
	}
	  </script>
   </head>
   <%String slnumber=request.getParameter("slnumber"); %>
   <body>
      <form action="savedetails.jsp?page=nslookup&slnumber=<%=slnumber%>" method="post" onsubmit="return validateDns()">
         <p class="style5" align="center">Network Utilities</p>
         <br>
         <table class="borderlesstab" id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="200">Parameters</th>
                  <th width="200">Configuration</th>
               </tr>
               <tr>
                  <td>Domain Name</td>
                  <td><input type="text" class="text" id="dname" name="dname" onfocusout="validatename('dname',true,'Domain Name')" onkeypress="return avoidSpace(event)"></td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" value="Nslookup" name="Nslookup" style="display:inline block" class="button"></div>
      </form>
   </body>
</html>