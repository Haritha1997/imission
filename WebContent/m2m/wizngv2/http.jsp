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
   JSONObject httpobj = null;
   JSONArray  dnsarr = null;
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
   	
			httpobj =  wizjsonnode.getJSONObject("apache").getJSONObject("apache:defaults");
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
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <script type="text/javascript" src="js/common.js"></script>
      <script type="text/javascript">
	  function validateHttpConfig() {
	var alertmsg = "";
	var portobj = document.getElementById("port");
	//var stimeobj = document.getElementById("stimer");
	var rtimeobj = document.getElementById("rtimer");
	var check_empty=true;
	var enableobj = document.getElementById("activation");
	if(!enableobj.checked)
		check_empty=false;
	var valid = validateRange("port","Port");
	if (!valid) {
		if (portobj.value.trim() == "") alertmsg += "The Port Number should not be empty\n";
		else alertmsg += "The Port Number is not valid\n";
	}
	/* var valid = validateRange("stimer","Session Timer");
	if (!valid) {
		if (stimeobj.value.trim() == "") alertmsg += "The Session Timer should not be empty\n";
		else alertmsg += "The Session Timer is not valid\n";
	} */
	var valid = validateRange("rtimer","Refresh Timer");
	if (!valid) {
		if (rtimeobj.value.trim() == "") alertmsg += "The Refresh Timer should not be empty\n";
		else alertmsg += "The Refresh Timer is not valid\n";
	}
	if (alertmsg.trim().length == 0) return true;
	else {
		alert(alertmsg);
		return false;
	}
}
	  </script>
   </head>
    <%String activation = "";%>
   <body>
      <form action="savedetails.jsp?page=http&slnumber=<%=slnumber%>" method="post" onsubmit="return validateHttpConfig()">
         <br>
         <p class="style5" align="center">HTTP Configuration</p>
         <br>
         <table class="borderlesstab" id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="200px">Parameters</th>
                  <th width="200px">Configuration</th>
               </tr>
               <tr>
                  <td>HTTPS</td>
                  <%
                    if(httpobj.containsKey("enable_https"))
                    	activation = httpobj.get("enable_https").toString().equals("1")?"checked":"";                   	
                  %>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="activation" id="activation" style="vertical-align:middle" <%=activation%> ><span class="slider round"></span></label></td>
              		 
               </tr>
               <tr>
                  <td>Listen Port</td>
                  <td><input type="number" class="text" id="port" name="port" min="1" max="65535"  value="<%=httpobj == null?"80":httpobj.get("listen_port")==null?"80":httpobj.getString("listen_port")%>" onfocusout="validateRange('port','Port')"></td>
               </tr>
              <%--  <tr>
                  <td>Session Timer (Secs)</td>
                  <td><input type="number" class="text" id="stimer" name="stimer" value="<%=httpobj == null?"":httpobj.get("session_timeout")==null?"":httpobj.getString("session_timeout")%>" min="1" max="86400" onfocusout="validateRange('stimer','Session Timer')"></td>
               </tr> --%>
               <tr>
                  <td>Refresh Timer (Secs)</td>
                  <td><input type="number" class="text" id="rtimer" name="rtimer" value="<%=httpobj == null?"50":httpobj.get("refresh_timeout")==null?"50":httpobj.getString("refresh_timeout")%>" min="1" max="3600" onfocusout="validateRange('rtimer','Refresh Timer')"></td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" name="Apply" value="Apply" style="display:inline block" class="button"></div>
      </form>
	  
   </body>
</html>