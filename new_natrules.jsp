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
		//System.out.println("in nat rules page serial number is : "+slnumber);
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
   		
			//System.out.print(wizjsonnode);
			natrules_arr =  wizjsonnode.containsKey("firewall")?(wizjsonnode.getJSONObject("firewall").containsKey("nat")?wizjsonnode.getJSONObject("firewall").getJSONArray("nat"):new JSONArray()):new JSONArray();
			//System.out.println("natrules_arr is :"+natrules_arr);
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
	  <script type="text/javascript" src="js/natrules.js"></script>
	  <script type="text/javascript" src="js/common.js"></script>
   </head>
   <body>
      <form action="savedetails.jsp?page=natrules&slnumber=<%=slnumber%>" method="post" onsubmit="">
	  <input type="text" id="slno" value="<%=slnumber%>" hidden />
         <br>
         <blockquote>
            <p class="style5" align="center">NAT Rules</p>
         </blockquote>
         <br><input type="text" id="trafficrwcnt" name="trafficrwcnt" value="1" hidden="">
         <table class="borderlesstab" id="WiZConff" style="width:1200px;" align="center">
            <tbody>
               <tr>
                  <th style="text-align:center;" width="50px" align="center">S.No</th>
                  <th style="text-align:center;" width="90px" align="center">Instance Name</th>
                  <th style="text-align:center;" width="300px" align="center">Match</th>
                  <th style="text-align:center;" width="280px" align="center">Action</th>
                  <th style="text-align:center;" width="30px" align="center">Activation</th>
                  <th style="text-align:center;" width="120px" align="center">Action</th>
               </tr>
            </tbody>
         </table>
         <br><br>
         <table class="borderlesstab" id="WiZConf1" align="center">
            <tbody>
               <tr>
                  <td width="180px">New Instance Name</td>
                  <td><input type="text" class="text" id="nwinstname" name="nwinstname" maxlength="32" onkeypress="return avoidSpace(event) || avoidEnter(event)" onfocusout="isEmpty('nwinstname','Instance Name')"></td>
                  <td colspan="2"><input type="button" class="button1" id="add" value="Add" onclick="addNATRule('nwinstname', true)"></td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" name="Apply" value="Apply" class="button"><input type="submit" name="Save" value="Save &amp; Apply" class="button"></div>
      </form>
	  <%
	    for(int i=0;i<natrules_arr.size();i++)
		{
			JSONObject nat_obj = (JSONObject)natrules_arr.get(i);
			System.out.println(nat_obj);
			String  instname = nat_obj.containsKey("name")? nat_obj.getString("name"):"";
			String protocol = nat_obj.containsKey("proto")?nat_obj.getString("proto"):"";
			String srcip = nat_obj.containsKey("src_ip")?nat_obj.getString("src_ip"):"";
			String srcport = nat_obj.containsKey("src_port")?nat_obj.getString("src_port"):"";
			String outbndintf = nat_obj.containsKey("src")?nat_obj.getString("src"):"";
			String desip = nat_obj.containsKey("dest_ip")?nat_obj.getString("dest_ip"):"";
			String desport = nat_obj.containsKey("dest_port")?nat_obj.getString("dest_port"):"";
			String action = nat_obj.containsKey("target")?nat_obj.getString("target"):"";
			String rewrtip = nat_obj.containsKey("snat_ip")?nat_obj.getString("snat_ip"):"";
			String rewrtport = nat_obj.containsKey("snat_port")?nat_obj.getString("snat_port"):"";
			%>
			<script>
			addRow('WiZConff',false);
			fillrow('<%=i+1%>','<%=instname%>','forwarded ','tunnel to tunnel',true);
			</script>
			<%	
		}
	  %>
   </body>
</html>