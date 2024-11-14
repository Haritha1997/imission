<% 
String name = request.getParameter("name");
%>
<html>
   <head>
      <meta http-equiv="pragma" content="no-cache">
      <style type="text/css">.button{display: block;border-radius: 6px;background-color:#6caee0;color: #ffffff;font-weight: bold;box-shadow: 1px 2px 4px 0 rgba(0, 0, 0, 0.08);padding: 12px 20px;border: 0;margin: 40px 183px 0;}.style1{font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;color:#5798B4;font-size: 18px;font-weight: bold;}.style2{font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;color:#000000;font-size: 16px;font-weight: bold;}body{background-color: #FAFCFD;}</style>
   </head>
   <body>
         <p>&nbsp;</p>
         <p>&nbsp;</p>
         <hr noshade="" color="#5798B4">
         <p>&nbsp;</p>
         <p class="style1" align="center">This Product does not support <%=name%></p>
         <p class="style2" align="center"> </p>
         <p>&nbsp;</p>
         <hr noshade="" color="#5798B4">
   </body>
</html>

