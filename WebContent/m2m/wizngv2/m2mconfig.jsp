<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="com.nomus.m2m.dao.NodedetailsDao"%>
<%@page import="com.nomus.staticmembers.Symbols"%>
<%@page import="com.nomus.m2m.pojo.NodeDetails"%>
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
   JSONObject m2mobj = null;
   String intfm2m = "";
   
   BufferedReader jsonfile = null;  
	
   		String slnumber=request.getParameter("slnumber");
   		String version=request.getParameter("version");
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
   		
			m2mobj =  wizjsonnode.getJSONObject("m2m").getJSONObject("m2m:m2m");
			
			if(m2mobj.containsKey("interface"))
			intfm2m = m2mobj.getString("interface");
			
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
      <script type="text/javascript" src="js/common.js"></script>
	  <script type="text/javascript">
	  function validatem2m() {
	var alertmsg = "";
	var server = document.getElementById("server");
	var port = document.getElementById("port");
	var pollout = document.getElementById("pollout");
	var timeout = document.getElementById("timeout");
	var check_empty = true;
	var enableobj = document.getElementById("activation");
	if(!enableobj.checked)
		check_empty = false;
	var valid =validateIPOnly("server", check_empty, "Server");
	if (!valid) {
		if (server.value.trim() == "") alertmsg += "Server should not be empty\n";
		else alertmsg += "Server is not valid\n";
	}
	valid = validateRange('port',check_empty,'Port');
	if(!valid) {
		if (port.value.trim() == "") 
			alertmsg += "Server Port should not be empty\n";
		else 
			alertmsg += "Server Port is not valid\n";
	}
	valid = validateRange('pollout',check_empty,'Polling Period');
	if(!valid) {
		if (pollout.value.trim() == "") 
			alertmsg += "Polling Period should not be empty\n";
		 else 
			 alertmsg += "Polling Period is not valid\n";
	}
	valid = validateRange('timeout',check_empty,'Retry Timeout');
	if(!valid) {
		if (timeout.value.trim() == "") 
			alertmsg += "Retry Timeout should not be empty\n";
		else 
			alertmsg += "Retry Timeout is not valid\n";
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
      <form action="savedetails.jsp?page=m2mconfig&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="return validatem2m()">
         <br>
         <p class="style5" align="center">M2M Configuration</p>
         <br>
         <table class="borderlesstab" id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="200px">Parameters</th>
                  <th width="200px">Configuration</th>
               </tr>
               <tr>
                  <td>Activation</td>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="activation" name="activation" style="vertical-align:middle" <%if(m2mobj.containsKey("enabled") && m2mobj.getString("enabled").equals("1")) {%> checked <%}%> ><span class="slider round"></span></label></td>
               </tr>
               <tr>
                  <td>Interface</td>
                  
                  <td>
                     <select name="interface" id="interface" class="text">
                        <option value="lan" <%if(intfm2m.equals("lan")){%>selected<%}%>>LAN</option>
                        <%if(version.trim().startsWith(Symbols.WiZV2+Symbols.EL)){%>
                        	<option value="wan" <%if(intfm2m.equals("wan")){%>selected<%}%>>WAN</option>
                        <% }%>
                        <option value="cellular" <%if(intfm2m.equals("cellular")){%>selected<%}%>>Cellular</option>
                        <option value="any" <%if(intfm2m.equals("any")){%>selected<%}%>>Any</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Server</td>
                  <td><input type="text" class="text" name="server" id="server" value="<%=m2mobj == null?"":m2mobj.get("server")==null?"":m2mobj.getString("server")%>" maxlength="256" onkeypress="return avoidSpace(event)" onfocusout="validateIPOnly('server',true,'Server')"></td>
               </tr>
               <tr>
                  <td>Server Port</td>
                  <td><input type="number" class="text" name="port" id="port" value="<%=m2mobj == null?"":m2mobj.get("port")==null?"":m2mobj.getString("port")%>" min="1" max="65535" onkeypress="return avoidSpace(event)" onfocusout="validateRange('port',true,'Port')"></td>
               </tr>
               <tr>
                  <td>Polling Period (Min)</td>
                  <td><input type="number" class="text" name="pollout" id="pollout" value="<%=m2mobj == null?"":m2mobj.get("pollout")==null?"":m2mobj.getString("pollout")%>" min="1" max="60" onkeypress="return avoidSpace(event)" onfocusout="validateRange('pollout',true,'Polling Period')"></td>
               </tr>
               <tr>
                  <td>Retry Timeout (Min)</td>
                  <td><input type="number" class="text" name="timeout" id="timeout" value="<%=m2mobj == null?"":m2mobj.get("timeout")==null?"":m2mobj.getString("timeout")%>" min="1" max="5" onkeypress="return avoidSpace(event)" onfocusout="validateRange('timeout',true,'Retry Timeout')"></td>
               </tr>
               <tr>
                  <td>Model Number</td>
                  <td><input type="text" class="text" name="model" id="model" value="<%=m2mobj == null?"":m2mobj.get("model")==null?"":m2mobj.getString("model")%>" maxlength="256" onkeypress="return avoidSpace(event)"></td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" name="Apply" value="Apply" style="display:inline block" class="button"></div>
      </form>
   </body>
</html>