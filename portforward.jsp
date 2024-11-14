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
   JSONArray portfrwd_arr = null;
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
   		
			portfrwd_arr =  wizjsonnode.containsKey("firewall")?(wizjsonnode.getJSONObject("firewall").containsKey("redirect")?wizjsonnode.getJSONObject("firewall").getJSONArray("redirect"):new JSONArray()):new JSONArray();
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
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <link href="css/fontawesome.css" rel="stylesheet">
      <link href="css/solid.css" rel="stylesheet">
      <link href="css/v4-shims.css" rel="stylesheet">
      <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
      <script type="text/javascript" src="js/common.js"></script>
	  <script type="text/javascript" src="js/portforward.js"></script>
	  <script type="text/javascript">
	  var iprows = 1;

	function validatePortForwarding() 
	{
		var alertmsg = "";
		var table = document.getElementById("WiZConff");
		var rows = table.rows;
		for (var i = 1; i < rows.length; i++) {
		var cols = rows[i].cells;
		var extportobj = cols[3].childNodes[0];
		var insipobj = cols[4].childNodes[0];
		var intportobj = cols[5].childNodes[0];
		var actobj = cols[6].childNodes[0];
		var valid = validatePortRange(extportobj.id, "External Port", true);
		if (!valid) {
			if (extportobj.value.trim() == "") alertmsg += "External Port in the row " + i + " should not be empty\n";
			else alertmsg += "External Port in the row " + i + " is not valid\n";
		}
		valid = validateIPOnly(insipobj.id, true, "Internal IP");
		if (!valid) {
			if (insipobj.value.trim() == "") 
				alertmsg += "Internal IP Address in the row " + i + " should not be empty\n";
			else 
				alertmsg += "Internal IP Address in the row " + i + " is not valid\n";
		}
		 valid = validatePortRange(intportobj.id, "Internal Port", true);
		if (!valid) {
			if (intportobj.value.trim() == "") alertmsg += "Internal Port in the row " + i + " should not be empty\n";
			else alertmsg += "Internal Port in the row " + i + " is not valid\n";
		}
	}
if (alertmsg.trim().length == 0) return true;
else {
	alert(alertmsg);
	return false;
}
	}
function checkExcludeAndProceed(id,slnumber,version)
{
	  if(isExcludedCharsExists(id))
	  {
		  alert("Please Don't use Excluded characters mentioned under NOTE");
		  return;
	  }
	  addforwardeditpage(id, true,slnumber,'<%=version%>');
}
	  </script>
   </head>
   <body>
      <form action="savedetails.jsp?page=portforward&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="return validatePortForwarding()">
	  <input type="text" id="slno" value="<%=slnumber%>" hidden />
         <br>
         <blockquote>
            <p class="style5" align="center">Port Forwards</p>
         </blockquote>
         <br><input type="text" id="portrwcnt" name="portrwcnt" value="1" hidden="">
         <table class="borderlesstab" id="WiZConff" style="width:1100px;" align="center">
            <tbody>
               <tr>
                  <th style="text-align:center;" width="50px" align="center">S.No</th>
                  <th style="text-align:center;" width="70px" align="center">Instance Name</th>
                  <th style="text-align:center;" width="90px" align="center">Protocol</th>
                  <th style="text-align:center;" width="70px" align="center">External Port</th>
                  <th style="text-align:center;" width="70px" align="center">Internal IP</th>
                  <th style="text-align:center;" width="70px" align="center">Internal Port</th>
                  <th style="text-align:center;" width="30px" align="center">Activation</th>
                  <th style="text-align:center;" width="120px" align="center">Action</th>
               </tr>
            </tbody>
         </table>
         <br><br>
         <table class="borderlesstab" id="WiZConf1" align="center" style="width:500px">
            <tbody>
               <tr>
                  <td width="180px">New Instance Name</td>
                  <td><input type="text" class="text" id="nwinstname" name="nwinstname" maxlength="32" onkeypress="return avoidSpace(event) && avoidEnter(event)" onmouseover="setTitle(this)" onfocusout="isEmpty('nwinstname','Instance Name')"></td>
                  <td><input type="button" class="button1" id="add" value="Add" onclick="checkExcludeAndProceed('nwinstname','<%=slnumber%>','<%=version%>')"></td>
               </tr>
               <br>
               <tr style="background-color:white";>
              <td width="180px">
               </td>
               <td colspan="2">
               <p style="font-size:11px;font-family: verdana;"><span style="color:red"><b>Note:</b></span>Excluded characters . \ ' " = # :</p>
               </td>
               </tr>
            </tbody>
         </table>
        
         <div align="center"><input type="submit" name="Apply" value="Apply" class="button"></div>
      </form>
	  <%
	    for(int i=0;i<portfrwd_arr.size();i++)
		{
			JSONObject portfrwd_obj = (JSONObject)portfrwd_arr.get(i);
			boolean enable = portfrwd_obj.containsKey("enabled")?portfrwd_obj.getString("enabled").equals("1")?true:false:false;
			String  instname = portfrwd_obj.containsKey("name")? portfrwd_obj.getString("name"):"";
			String  protocol = portfrwd_obj.containsKey("proto")? (portfrwd_obj.getJSONArray("proto").size()>0?portfrwd_obj.getJSONArray("proto").getString(0):"tcp"):"tcp";
			String extport = portfrwd_obj.containsKey("src_dport")? portfrwd_obj.getString("src_dport"):"";
			String destip = portfrwd_obj.containsKey("dest_ip")? portfrwd_obj.getString("dest_ip"):"";
			String destport = portfrwd_obj.containsKey("dest_port")? portfrwd_obj.getString("dest_port"):"";
			%>
			<script>
			addRow('WiZConff',false,'<%=slnumber%>','<%=version%>');
			fillrow('<%=i+1%>','<%=instname%>','<%=protocol%>','<%=extport%>','<%=destip%>','<%=destport%>',<%=enable%>);
			</script>
			<%	
		}
	  %>
   </body>
</html>