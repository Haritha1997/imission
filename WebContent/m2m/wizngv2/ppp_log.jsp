<html>
   <head>
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <style></style>
   </head>
   <%String slnumber=request.getParameter("slnumber"); %>
   <body>
      <form action="savedetails.jsp?page=ppp_log&slnumber=<%=slnumber%>" method="post">
         <p class="style5" align="center">PPP Logs</p>
         <br>
         <table class="borderlesstab" id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="200">Parameters</th>
                  <th width="200">Configuration</th>
               </tr>
               <tr>
                  <td>PPP Log</td>
                  <td>
                     <select class="text" style="width: 180px" id="pppLog" name="pppLog">
                        <option value="1">PPP over Cellular</option>
                        <option value="2">PPP over WAN Ethernet</option>
                     </select>
                  </td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"></div>
      </form>
   </body>
</html>