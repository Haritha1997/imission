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
   JSONArray natrules_arr = null;
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
   		
			natrules_arr =  wizjsonnode.containsKey("firewall")?(wizjsonnode.getJSONObject("firewall").containsKey("nat")?wizjsonnode.getJSONObject("firewall").getJSONArray("nat"):new JSONArray()):new JSONArray();
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
   <style>
   #bluebg
   {
   	color:#0069d6;
   }
   </style>
   <meta http-equiv="pragma" content="no-cache" />
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <link href="css/fontawesome.css" rel="stylesheet">
      <link href="css/solid.css" rel="stylesheet">
      <link href="css/v4-shims.css" rel="stylesheet">
      <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
	  <script type="text/javascript" src="js/natrules.js"></script>
	  <script type="text/javascript" src="js/common.js"></script>
	  <script>
	  function checkExcludeAndProceed(id,slnumber,version)
	  {
		  if(isExcludedCharsExists(id))
		  {
			  alert("Please Don't use Excluded characters mentioned under NOTE");
			  return;
		  }
		  addNATRule(id, true,slnumber,'<%=version%>');
	  }
	  </script>
   </head>
   <body>
      <form action="savedetails.jsp?page=natrules&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="">
	  <input type="text" id="slno" value="<%=slnumber%>" hidden />
         <br>
         <blockquote>
            <p class="style5" align="center">NAT Rules</p>
         </blockquote>
         <br><input type="text" id="trafficrwcnt" name="trafficrwcnt" value="1" hidden="">
         <table class="borderlesstab" id="WiZConff" style="width:95%;" align="center">
            <tbody>
               <tr>
                  <th style="text-align:center;" width="50px" align="center">S.No</th>
                  <th style="text-align:center;" width="90px" align="center">Instance Name</th>
                  <th style="text-align:center;" width="300px" align="center">Match</th>
                  <th style="text-align:center;" width="260px" align="center">Action</th>
                  <th style="text-align:center;" width="30px" align="center">Activation</th>
                  <th style="text-align:center;" width="160px" align="center">Action</th>
               </tr>
            </tbody>
         </table>
         <br><br>
         <table class="borderlesstab" id="WiZConf1" align="center" style="width:500px">
            <tbody>
               <tr>
                  <td width="180px">New Instance Name</td>
                  <td>
                  <input type="text" class="text" id="nwinstname" name="nwinstname" maxlength="32" onkeypress="return avoidSpace(event) && avoidEnter(event)" onmouseover="setTitle(this)" onfocusout="isEmpty('nwinstname','Instance Name')">
                  </td>
                  <td><input type="button" class="button1" id="add" value="Add" onclick="checkExcludeAndProceed('nwinstname','<%=slnumber%>','<%=version%>')"></td>
               </tr>
               <tr style="background-color:white;">
               <td width="180px">
               </td>
               <td colspan="2">
               <p style="font-size:11px;font-family: verdana;"><span style="color:red"><b> Note:</b></span>  Excluded characters . \ ' " = # : </p>
               </td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" name="Apply" value="Apply" class="button"></div>
      </form>
	  <%
	    for(int i=0;i<natrules_arr.size();i++)
		{
			JSONObject nat_obj = (JSONObject)natrules_arr.get(i);
			boolean enable = nat_obj.containsKey("enabled")?nat_obj.getString("enabled").equals("1")?true:false:false;
			String  instname = nat_obj.containsKey("name")? nat_obj.getString("name"):"";
			JSONArray protocol_arr = nat_obj.containsKey("proto")?nat_obj.getJSONArray("proto"):new JSONArray();
			String srcip = nat_obj.containsKey("src_ip")?nat_obj.getString("src_ip"):"";
			String srcport = nat_obj.containsKey("src_port")?nat_obj.getString("src_port"):"";
			String outbndintf = nat_obj.containsKey("src")?nat_obj.getString("src"):"";
			String desip = nat_obj.containsKey("dest_ip")?nat_obj.getString("dest_ip"):"";
			String desport = nat_obj.containsKey("dest_port")?nat_obj.getString("dest_port"):"";
			String action = nat_obj.containsKey("target")?nat_obj.getString("target"):"";
			String rewrtip = nat_obj.containsKey("snat_ip")?nat_obj.getString("snat_ip"):"";
			String rewrtport = nat_obj.containsKey("snat_port")?nat_obj.getString("snat_port"):"";
			String match_str = "Forwarded  IPV4 ";
			String action_str = "";
			String protocols = "";
			for(int j=0;j<protocol_arr.size();j++)
			{
				if(j>0)
					protocols+=",";
				protocols += protocol_arr.getString(j);		
			}
			if(!protocols.equals("all") && protocol_arr.size()>0)
			{
				match_str += ", protocol <label id=\\'bluebg\\'> "+protocols.toUpperCase()+"</label>";
			}
			match_str+="#newline#From Any Interface";
			
			if(srcip.length() > 0)
					match_str += ", IP <label id=\\'bluebg\\'> "+srcip+"</label>";
			if(srcport.length() > 0)
				match_str += ", Port <label id=\\'bluebg\\'> "+srcport+"</label> ";
			
			match_str+="#newline#To  ";
			
			if(!outbndintf.equals("*"))
			{
				match_str += outbndintf;
			}
			else
				match_str += "Any Interface";
			
			if(desip.length() > 0)
					match_str += ", IP <label id=\\'bluebg\\'> "+desip+"</label>";
			if(desport.length() > 0)
				match_str += ", Port <label id=\\'bluebg\\'> "+desport+"</label> ";
			
			if(action.equals("MASQUERADE"))
			{
				action_str = "<label id=\\'bluebg\\'>Automatically rewrite</label>" +" SourceIP";
			}
			if(action.equals("ACCEPT"))
			{
				action_str = "<label id=\\'bluebg\\'>Prevent Source rewrite</label>";
			}
			if(action.equals("SNAT"))
			{
				action_str = "<label id=\\'bluebg\\'>Statically rewrite</label> to source";
				if(rewrtip.length() > 0)
					action_str += " IP <label id=\\'bluebg\\'>"+rewrtip+"</label>";
				if(rewrtport.length() > 0)
					action_str += ", Port <label id=\\'bluebg\\'>"+rewrtport+"</label> ";
			}
			%>
			
			<script>
			addRow('WiZConff',false,'<%=slnumber%>','<%=version%>');
			fillrow('<%=i+1%>','<%=instname%>','<%=match_str%> ','<%=action_str%>',<%=enable%>);
			</script>
			<%	
		}
	  %>
   </body>
</html>