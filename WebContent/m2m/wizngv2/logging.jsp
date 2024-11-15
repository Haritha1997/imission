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
   JSONObject systemobj = null;
   JSONObject systempage = null;
   JSONArray systemarr = null;
   BufferedReader jsonfile = null;  
   String buffersize = "";
   String logserver = "";
   String logserverport = "";
   String logserverproto = "";
   String logoutput = "";
   String cronloglvl = "";
   String ipseclog = "";
	
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

			systemobj =  wizjsonnode.getJSONObject("system");
			systemarr = systemobj.getJSONArray("system")==null ? new JSONArray(): systemobj.getJSONArray("system");	
			systempage = systemarr.get(0)==null ? new JSONObject(): (JSONObject)systemarr.get(0);
			
			buffersize = systempage.get("log_size")==null? "":systempage.getString("log_size");
			logserver = systempage.get("log_ip")==null? "":systempage.getString("log_ip");
			logserverport = systempage.get("log_port")==null? "":systempage.getString("log_port");
			logserverproto = systempage.get("log_proto")==null? "":systempage.getString("log_proto");
			logoutput = systempage.get("conloglevel")==null? "":systempage.getString("conloglevel");
			cronloglvl = systempage.get("cronloglevel")==null? "":systempage.getString("cronloglevel");
			ipseclog = systempage.get("ipsecloglevel")==null? "":systempage.getString("ipsecloglevel");
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
	  <script type="text/javascript">
	  function validatelogging() {
	var alertmsg = "";
	var systmlogsrvr = document.getElementById("logserver");
	var valid = validatenameandip("logserver", false, "External System Log Server");
	if (!valid) {
		if (systmlogsrvr.value.trim() == "") alertmsg += "External System Log Server should not be empty\n";
		else alertmsg += "External System Log Server is not valid\n";
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
      <form action="savedetails.jsp?page=logging&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="return validatelogging()">
         <br>
         <p class="style5" align="center">Logging</p>
         <br>
         <table class="borderlesstab" id="WiZConf" style="width:600px;" align="center">
            <tbody>
               <tr>
                  <th width="300px">Parameters</th>
                  <th width="300px">Configuration</th>
               </tr>
               <tr>
                  <td>Local Logging</td>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="logging" name="logging" style="vertical-align:middle" <%if(systempage.containsKey("log_file") && systempage.getString("log_file").equals("/syslog/system.log")) {%> checked <%}%>><span class="slider round"></span></label></td>
               </tr>
               <tr>
                  <td>System Log Buffer Size (KB)</td>
                  <td><input type="number" class="text" name="logbufrsize" id="logbufrsize" value="<%=systempage == null?"":systempage.get("log_size")==null?"64":systempage.getString("log_size")%>" min="1" max="65535" onkeypress="return avoidSpace(event)"></td>
               </tr>
               <tr>
                  <td>Remote Logging</td>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="log_remote" name="log_remote" style="vertical-align:middle" <%if((systempage.containsKey("log_remote") && systempage.getString("log_remote").equals("1"))) {%> checked <%}%>><span class="slider round"></span></label></td>
               </tr>
               <tr>
                  <td>External System Log Server</td>
                  <td><input type="text" class="text" name="logserver" id="logserver" value="<%=systempage == null?"":systempage.get("log_ip")==null?"":systempage.getString("log_ip")%>" onfocusout="validatenameandip('logserver',false,'External System Log Server')" onkeypress="return avoidSpace(event)"></td>
               </tr>
               <tr>
                  <td>External System Log Server Port</td>
                  <td><input type="number" class="text" name="logservrport" id="logservrport" value="<%=systempage == null?"":systempage.get("log_port")==null?"":systempage.getString("log_port")%>" min="1" max="65535" onkeypress="return avoidSpace(event)"></td>
               </tr>
               <tr>
                  <td>External System Log Server Protocol</td>
                  <td>
                     <select class="text" id="logservrprotocol" name="logservrprotocol">
                        <option value="udp" <%if(logserverproto.equals("udp")){%>selected<%}%>>UDP</option>
                        <option value="tcp" <%if(logserverproto.equals("tcp")){%>selected<%}%>>TCP</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Log Output Level</td>
                  <td>
                     <select class="text" id="logotptlvl" name="logotptlvl">
                        <option value="8" <%if(logoutput.equals("8")){%>selected<%}%>>Debug</option>
                        <option value="7" <%if(logoutput.equals("7")){%>selected<%}%>>Info</option>
                        <option value="6" <%if(logoutput.equals("6")){%>selected<%}%>>Notice</option>
                        <option value="5" <%if(logoutput.equals("5")){%>selected<%}%>>Warning</option>
                        <option value="4" <%if(logoutput.equals("4")){%>selected<%}%>>Error</option>
                        <option value="3" <%if(logoutput.equals("3")){%>selected<%}%>>Critical</option>
                        <option value="2" <%if(logoutput.equals("2")){%>selected<%}%>>Alert</option>
                        <option value="1" <%if(logoutput.equals("1")){%>selected<%}%>>Emergency</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Cron Log Level</td>
                  <td>
                     <select class="text" id="cronloglevl" name="cronloglevl">
                        <option value="5" <%if(cronloglvl.equals("5")){%>selected<%}%>>Debug</option>
                        <option value="8" <%if(cronloglvl.equals("8")){%>selected<%}%>>Normal</option>
                        <option value="9" <%if(cronloglvl.equals("9")){%>selected<%}%>>Warning</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Cellular PPP Logging</td>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="ppploglevel" name="ppploglevel" style="vertical-align:middle" <%if((systempage.containsKey("ppploglevel") && systempage.getString("ppploglevel").equals("1"))) {%> checked <%}%>><span class="slider round"></span></label></td>
               </tr>
               <%if(version.trim().startsWith(Symbols.WiZV2+Symbols.EL)){%>
               <tr>
               	
                  <td>WAN PPPoE Logging</td>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="pppoeloglevel" name="pppoeloglevel" style="vertical-align:middle" <%if(systempage.containsKey("pppoeloglevel") && systempage.getString("pppoeloglevel").equals("1")) {%> checked <%}%>><span class="slider round"></span></label></td>
               </tr>
               <% }  %>
               <tr>
                  <td>IPSec Log Level</td>
                  <td>
                     <select class="text" id="ipsecloglevel" name="ipsecloglevel" style="width:260px">
                        <option value="-1" <%if(ipseclog.equals("-1")){%>selected<%}%>>Absolutely silent</option>
                        <option value="0"  <%if(ipseclog.equals("0")){%>selected<%}%>>Very basic auditing logs</option>
                        <option value="1" <%if(ipseclog.equals("1")){%>selected<%}%>>Generic control flow with errors</option>
                        <option value="2" <%if(ipseclog.equals("2")){%>selected<%}%>>More detailed debugging control flow</option>
                        <option value="3" <%if(ipseclog.equals("3")){%>selected<%}%>>Include RAW data dumps in hex</option>
                        <option value="4" <%if(ipseclog.equals("4")){%>selected<%}%>>Include sensitive material in dumps</option>
                     </select>
                  </td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" name="Apply" value="Apply" style="display:inline block" class="button"></div>
      </form>
   </body>
</html>