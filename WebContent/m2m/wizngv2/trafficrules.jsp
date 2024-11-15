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
   JSONArray trafficrules_arr = null;
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
   		
			trafficrules_arr =  wizjsonnode.containsKey("firewall")?(wizjsonnode.getJSONObject("firewall").containsKey("rule")?wizjsonnode.getJSONObject("firewall").getJSONArray("rule"):new JSONArray()):new JSONArray();
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
      <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
      <style></style>
      <script type="text/javascript" src="js/common.js"></script>
      <script type="text/javascript" src="js/traffic.js"></script>
      <style>
	   #bluebg
	   {
	   	color:#0069d6;
	   }
	  </style>
      <script>
	  function checkExcludeAndProceed(id,slnumber,version)
	  {
		  if(isExcludedCharsExists(id))
		  {
			  alert("Please Don't use Excluded characters mentioned under NOTE");
			  return;
		  }
		  addTrafficRule(id, true,slnumber,'<%=version%>');
	  }
	  </script>
   </head>
   <body onload="adjustTooltipwhitespace();">
      <form action="savedetails.jsp?page=trafficrules&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="">
	  <input type="text" id="slno" value="<%=slnumber%>" hidden />
         <br>
         <blockquote>
            <p class="style5" align="center">Traffic Rules</p>
         </blockquote>
         <br><input type="text" id="trafficrwcnt" name="trafficrwcnt" value="1" hidden="">
         <table class="borderlesstab" id="WiZConff" align="center" style="width:1000px;">
            <tbody>
               <tr>
                  <th align="center" style="text-align:center;" width="50px">S.No</th>
                  <th align="center" style="text-align:center;" width="90px">Instance Name</th>
                  <th align="center" style="text-align:center;" width="400px">Match</th>
                  <th align="center" style="text-align:center;" width="160px">Action</th>
                  <th align="center" style="text-align:center;" width="30px">Activation</th>
                  <th align="center" style="text-align:center;" width="120px">Action</th>
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
         <br>
         <div align="center"><input type="submit" name="Apply" value="Apply" class="button"></div>
      </form>
      <script>
	  function adjustTooltipwhitespace() {
	var tooltips = document.getElementsByClassName('tooltiptext');
	var table = document.getElementById('WiZConff');
	for (var i = 0; i < tooltips.length; i++) {
		var tooltiptextobj = tooltips[i];
		var childs = tooltiptextobj.childNodes;
		if (childs.length > 3) {
			tooltiptextobj.style.minWidth = '500px';
			for (var i = 0; i < childs.length; i++) {
				if (childs[i].tagName == 'VAR') {
					childs[i].style.whiteSpace = 'normal';
				}
			}
		}
	}
}
</script>
<%
	    for(int i=0;i<trafficrules_arr.size();i++)
		{
			JSONObject traffic_obj = (JSONObject)trafficrules_arr.get(i);
			String  instname = traffic_obj.containsKey("name")? traffic_obj.getString("name"):"";
			boolean enable = traffic_obj.containsKey("enabled")?traffic_obj.getString("enabled").equals("1")?true:false:false;
			String  action = traffic_obj.containsKey("target")? traffic_obj.getString("target"):"";
			JSONArray protocol_arr = traffic_obj.containsKey("proto")?traffic_obj.getJSONArray("proto"):new JSONArray();
			JSONArray icmptype_arr = traffic_obj.containsKey("icmp_type")?traffic_obj.getJSONArray("icmp_type"):new JSONArray();
			String srcintf = traffic_obj.containsKey("src")?traffic_obj.getString("src"):"Device (output)";
			String srcip = traffic_obj.containsKey("src_ip")?traffic_obj.getString("src_ip"):"";
			String srcport = traffic_obj.containsKey("src_port")?traffic_obj.getString("src_port"):"";
			String desintf = traffic_obj.containsKey("dest")?traffic_obj.getString("dest"):"Device (input)";
			String desip = traffic_obj.containsKey("dest_ip")?traffic_obj.getString("dest_ip"):"";
			String desport = traffic_obj.containsKey("dest_port")?traffic_obj.getString("dest_port"):"";
			String match_str = "";
			if(srcintf.equals("Device (output)"))
				match_str += "Outgoing <label id=\\'bluebg\\'>IPV4</label>";
			else if(desintf.equals("Device (input)"))
				match_str += "Incoming <label id=\\'bluebg\\'>IPV4</label>";
			else
				match_str += "Forwarded <label id=\\'bluebg\\'>IPV4</label>";

			 String protocols = "";
			for(int j=0;j<protocol_arr.size();j++)
			{
				if(j>0)
					protocols+=",";
				protocols += protocol_arr.getString(j);	
			}
			if(!protocols.equals("all") && protocol_arr.size()>0)
				match_str += ", protocol <label id=\\'bluebg\\'>"+protocols.toUpperCase()+"</label>";
			match_str+="#newline#From ";
			
			if(srcintf.equals("Device (output)"))
				match_str += "Device ";
			
			else if(srcintf.equals("*"))
				match_str += "Any Interface ";
			
			else
				match_str += srcintf;
			
			if(srcip.length() > 0)
					match_str += ", IP <label id=\\'bluebg\\'>"+srcip+"</label>";
				if(srcport.length() > 0)
					match_str += ", Port <label id=\\'bluebg\\'>"+srcport+"</label>";
			
			match_str+="#newline#To  ";
			
			if(desintf.equals("Device (input)"))
				match_str += "Device";	
				
			else if(desintf.equals("*"))
				match_str += "Any Interface ";
				
			else
				match_str += desintf;
			
			if(desip.length() > 0)
					match_str += ", IP <label id=\\'bluebg\\'>"+desip+"</label>";
				if(desport.length() > 0)
					match_str += ", Port <label id=\\'bluebg\\'>"+desport+"</label>";	
				
			%>
			<script>
			addRow('WiZConff',false,'<%=slnumber%>','<%=version%>');
			fillrow('<%=i+1%>','<%=instname%>','<%=match_str%>','<%=action%>',<%=enable%>);
			</script>
			<%	
		}
	  %>
</body>
</html>