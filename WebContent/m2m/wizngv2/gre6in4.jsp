<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="pragma" content="no-cache" />
<link rel="stylesheet" type="text/css" href="css/style.css">
      <link href="css/fontawesome.css" rel="stylesheet">
      <link href="css/solid.css" rel="stylesheet">
      <link href="css/v4-shims.css" rel="stylesheet">
      <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
	  <script type="text/javascript" src="js/gre6in4.js"></script>
	  <script type="text/javascript">
	  var iprows = 1;

	
	  </script>

</head>
<body>
<form action="" method="post" onsubmit="">
         <br>
         <blockquote>
            <p class="style5" align="center">GRE6in4</p>
         </blockquote>
         <br><input type="text" id="grerwcnt" name="grerwcnt" value="1" hidden="">
         <table class="borderlesstab" id="WiZConff" style="width:800px;" align="center">
            <tbody>
               <tr>
                  <th style="text-align:center;" width="50px" align="center">S.No</th>
                  <th style="text-align:center;" width="70px" align="center">Instance Name</th>
                  <th style="text-align:center;" width="90px" align="center">Protocol GRE6in4</th>
                  <th style="text-align:center;" width="30px" align="center">Activation</th>
                  <th style="text-align:center;" width="120px" align="center">Action</th>
               </tr>
            </tbody>
         </table>
         <br><br>
         <table class="borderlesstab" id="WiZConf1" align="center">
            <tbody>
               <tr>
                  <td width="180px">New Instance Name</td>
                  <td><input type="text" class="text" id="nwinstname" name="nwinstname" maxlength="32" onkeypress="return avoidSpace(event) || avoidEnter(event)" onfocusout="isEmpty('nwinstname','Instance Name')"></td>
                  <td colspan="2"><input type="button" class="button1" id="add" value="Add" onclick="addforwardeditpage('nwinstname', true)"></td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" name="Apply" value="Apply" class="button"></div>
      </form>
</body>

</html>