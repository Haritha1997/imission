<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="org.apache.commons.net.util.SubnetUtils"%>
<%@page import="java.net.NetworkInterface"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject lanobj = null;
   JSONObject ntpobj = null;
   JSONArray  ntparr = null;
   String enable_server ="";
   BufferedReader jsonfile = null;   
   		String slnumber=request.getParameter("slnumber");
		String errorstr = request.getParameter("error");
   if(slnumber != null && slnumber.trim().length() > 0)
   {
	   Properties m2mprops = M2MProperties.getM2MProperties();
	   String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
	   jsonfile = new BufferedReader(new FileReader(new File(slnumpath+File.separator+"Config.json")));
	   StringBuilder jsonbuf = new StringBuilder("");
	   String jsonString="";
	   try
	   {
			while((jsonString = jsonfile.readLine())!= null)
   			jsonbuf.append( jsonString );
			wizjsonnode= JSONObject.fromObject(jsonbuf.toString());
   		
			ntpobj =  wizjsonnode.containsKey("system")?wizjsonnode.getJSONObject("system").getJSONObject("timeserver:ntp"):new JSONObject();
			enable_server = ntpobj.containsKey("enable_server")?ntpobj.getString("enable_server"):"";
			if(ntpobj != null)
			{
				if(ntpobj.containsKey("server"))
				ntparr = ntpobj.getJSONArray("server");
			}
			if(ntparr == null)
				ntparr = new JSONArray();
			
	   }
	   catch(Exception e)
	   {
		   e.printStackTrace();
	   }
	   finally
	   {
		   if(jsonfile != null)
			   jsonfile.close();
	   }
   }
%>
<html>
   <head>
   <meta http-equiv="pragma" content="no-cache" />
      <link href="css/fontawesome.css" rel="stylesheet">
      <link href="css/solid.css" rel="stylesheet">
      <link href="css/v4-shims.css" rel="stylesheet">
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
      <style></style>
      <script type="text/javascript" src="js/common.js"></script>
	  <script type="text/javascript" src="js/ntp.js"></script>
	  <script type="text/javascript">
	  var ntprows = 3;

function validatentp() {
	var alertmsg = "";
	var table = document.getElementById("WiZConf");
	var rows = table.rows;
	for (var i = 4; i < rows.length; i++) {
		var cols = rows[i].cells;
		var ntpservers = cols[1].childNodes[0].childNodes[0];
		var actobj = document.getElementById("activation");
		var check_empty = true;
		if(!actobj.checked)
			check_empty = false;
		var valid = validatenameandip(ntpservers.id, check_empty, "NTP Servers");
		if (!valid) {
			alertmsg += (i - 3);
			if (i == 4) alertmsg += "st";
			else if (i == 5) alertmsg += "nd";
			else if (i == 6) alertmsg += "rd";
			else alertmsg += "th";
			if (ntpservers.value.trim() == "") alertmsg += " NTP Server should not be empty\n";
			else alertmsg += " NTP Server is not valid\n";
		}
	}
	if (alertmsg.trim().length == 0) return true;
	else {
		alert(alertmsg);
		return false;
	}
}
	  </script>
   </head>
   <body>
      <form action="savedetails.jsp?page=ntp&slnumber=<%=slnumber%>" method="post" onsubmit="return validatentp()">
         <br>
		 <input type="hidden" id="ntprows" name="ntprows" value="3"/>
         <p class="style5" align="center">NTP Configuration</p>
         <br>
         <table class="borderlesstab" id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="200px">Parameters</th>
                  <th width="200px">Configuration</th>
               </tr>
               <tr>
                  <td>NTP Activation</td>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="activation" id="activation" style="vertical-align:middle" <%if(ntpobj.containsKey("enabled") && ntpobj.getString("enabled").equals("1")) {%> checked <%}%>><span class="slider round"></span></label></td>
               </tr>
               <tr>
                  <td>NTP Mode</td>
                  <td>
                     <select class="text" id="enable_server" name="enable_server">
                        <option value="Client" <%if(enable_server.equals("Client")){%>selected<%}%>>Client</option>
                        <option value="Server" <%if(enable_server.equals("Server")){%>selected<%}%>>Server</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Advertised DHCP Servers</td>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="use_dhcp" id="use_dhcp" style="vertical-align:middle" <%if(ntpobj.containsKey("use_dhcp") && ntpobj.getString("use_dhcp").equals("1")) {%> checked <%}%>><span class="slider round"></span></label></td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" name="Apply" value="Apply" style="display:inline block" class="button"></div>
      </form>
	  <%
	   JSONArray ntparray = ntpobj==null?new JSONArray():ntpobj.getJSONArray("server");
	   if(ntparray.size()>0){
		   for(int i=0;i<ntparray.size();i++)
		   {
			   String servaddr = ntparray.getString(i);
		%>
		 <script>		
		 addIPRowAndChangeIcon(ntprows);		
		 fillIProw(ntprows,'<%=servaddr%>');
		 </script>
		<% 
      }
	   }
	  else{
		  %>
		 <script>		 
		 addIPRowAndChangeIcon(ntprows);		 
		 </script>
		<%}
	  %>
      <script>
	  findLastRowAndDisplayRemoveIcon();
	  </script>
   </body>
</html>