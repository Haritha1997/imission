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
   JSONArray  static_route_arr = null;
   String enable_server ="";
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
   		
			
			static_route_arr =  wizjsonnode.containsKey("network")?(wizjsonnode.getJSONObject("network").containsKey("route")?wizjsonnode.getJSONObject("network").getJSONArray("route"):new JSONArray()):new JSONArray();
								 
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
      <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
	  <script type="text/javascript" src="js/staticroute.js"></script>
	  <script type="text/javascript" src="js/common.js"></script>
	  <script type="text/javascript">
	  var iprows = 1;

function validateRoute() {
	var alertmsg = "";
	var table = document.getElementById("WiZConff");
	var rows = table.rows;
	for (var i = 1; i < rows.length; i++) {
		var cols = rows[i].cells;
		var targetobj = cols[2].childNodes[0];
		var netmaskobj = cols[3].childNodes[0];
		var gatewayobj = cols[4].childNodes[0];
		var valid = validateIP(targetobj.id, true, "Target");
		if (!valid) {
			if (targetobj.value.trim() == "") alertmsg += "Target in the row " + i + " should not be empty\n";
			else alertmsg += "Target in the row " + i + " is not valid\n";
		}
		valid = validateSubnetMask(netmaskobj.id, true, "Netmask");
		if (!valid) {
			if (netmaskobj.value.trim() == "") alertmsg += "Netmask in the row " + i + " should not be empty\n";
			else alertmsg += "Netmask in the row " + i + " is not valid\n";
		}
		valid = validateGatewayIP(gatewayobj.id, false, "Gateway");
		if (!valid) {
			if (gatewayobj.value.trim() == "") alertmsg += "Gateway in the row " + i + " should not be empty\n";
			else alertmsg += "Gateway in the row " + i + " is not valid\n";
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
      <form action="savedetails.jsp?page=staticrules&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="return validateRoute()">
         <br>
         <p class="style5" align="center">Static Routes</p>
         <br><input type="text" id="routesrwcnt" name="routesrwcnt" value="1" hidden="">
         <table class="borderlesstab" id="WiZConff" align="center">
            <tbody>
               <tr>
                  <th style="text-align:center;min-width:30px"> S.No</th>
                  <th style="text-align:center;max-width:160px;min-width:160px;"> Interface</th>
                  <th style="text-align:center;max-width:160px;min-width:160px;"> Target</th>
                  <th style="text-align:center;max-width:160px;min-width:160px;"> Netmask</th>
                  <th style="text-align:center;max-width:160px;min-width:160px;"> Gateway</th>
                  <th style="text-align:center;max-width:160px;min-width:160px;"> Metric</th>
                  <th style="text-align:center;max-width:160px;min-width:160px;"> MTU</th>
                  <th style="text-align:center;min-width:40px"> Action</th>
               </tr>
            </tbody>
         </table>
         <div align="center"> <br><input class="button" type="button" id="add" value="Add" style="display:inline block" onclick="addRow('WiZConff','<%=version%>')"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"><input type="submit" value="Save &amp; Apply" name="Save" style="display:inline block" class="button"></div>
      </form>
	  <%
	  
	    for(int i=0;i<static_route_arr.size();i++)
		{
			JSONObject route_obj = (JSONObject)static_route_arr.get(i);
			String  inter_face = route_obj.containsKey("interface")? route_obj.getString("interface"):"";
			String  target = route_obj.containsKey("target")? route_obj.getString("target"):"";
			String  netmask = route_obj.containsKey("netmask")? route_obj.getString("netmask"):"";
			String  gateway = route_obj.containsKey("gateway")? route_obj.getString("gateway"):"";
			String  metric = route_obj.containsKey("metric")? route_obj.getString("metric"):"";
			String  mtu = route_obj.containsKey("mtu")? route_obj.getString("mtu"):"";
			%>
			<script>
			addRow('WiZConff','<%=version%>');
			fillrow('<%=i+1%>','<%=inter_face%>','<%=target%>','<%=netmask%>','<%=gateway%>','<%=metric%>','<%=mtu%>');
			</script>
			<%	
		}
	  %>
   </body>
</html>