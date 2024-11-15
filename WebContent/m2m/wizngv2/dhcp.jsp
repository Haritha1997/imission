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
   JSONArray  static_lease_arr = null;
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
   		
			static_lease_arr =  wizjsonnode.containsKey("dhcp")?(wizjsonnode.getJSONObject("dhcp").containsKey("host")?wizjsonnode.getJSONObject("dhcp").getJSONArray("host"):new JSONArray()):new JSONArray();
								 
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
	  <script type="text/javascript" src="js/staticlease.js"></script>
	  <script type="text/javascript" src="js/common.js"></script>
	  <script type="text/javascript">
	  var iprows=1;
	  
	  function validateStaticLeases() {	
		  var alertmsg = "";
		  
		  var table = document.getElementById("WiZConff");
		  var rows = table.rows;
		  for (var i=1;i<rows.length;i++) {		
		  var cols = rows[i].cells;	
		  var hostobj = cols[1].childNodes[0];	
		  var ipaddressobj = cols[2].childNodes[0];	
		  var macobj = cols[3].childNodes[0];	
		  var leaseobj = cols[4].childNodes[0];
		  if(hostobj.value.includes('\'') || hostobj.value.includes('\"') || hostobj.value.includes(':') || hostobj.value.includes('#') || hostobj.value.includes('=') || hostobj.value.includes('.'))
		  {
			  alertmsg +="HostName in the row "+i+" is invalid.. Characters ' \" = # : . are not allowed\n";
			  hostobj.style.outline = "thin solid red";
			  hostobj.title = "Characters ' and \" are not allowed";
		  }
		  else
		  {
			  hostobj.style.outline = "initial";
			  hostobj.title = "";
		  }
			  
		  var valid = validateIPOnly(ipaddressobj.id,true,"IPv4 Address");	
		  if (!valid) {			
			  if (ipaddressobj.value.trim() == "")		
				alertmsg += "IP Address in the row "+i+" should not be empty \n ";		
			  else		
				alertmsg += "IP Address in the row "+i+" is not valid\n ";	
		  }
		  valid = validateMacIP(macobj.id,true,"MAC Address");		
		  if (!valid) {	
			  if(macobj.value.trim() == "")		
			  alertmsg += "MAC Address in the row "+i+" should not be empty\n ";	
			  else		
			  alertmsg += "MAC Address in the row "+i+" is not valid\n ";		
			}		
		  valid = validateLeaseTime(leaseobj.id,true,"Lease time");
		  if(!valid) {
			  leaseval = leaseobj.value.trim().toLowerCase();
			  if(leaseval == "")		
			  alertmsg += "Lease time in the row "+i+" should not be empty\n ";	
			  else if(!leaseval.includes("m") && !leaseval.includes("s") && !leaseval.includes("h"))
			  {
				  alertmsg += "Lease time in the row "+i+" is not valid..... Please enter units h or m after number\n ";
			  }
			  else if(leaseval.startsWith("h") || leaseval.startsWith("m") || leaseval.startsWith("s"))
			  {
				  alertmsg += "Lease time in the row "+i+" is not valid format...\n";
			  }
			  else if((leaseval.includes("h") && !leaseval.endsWith("h")) ||
					  (leaseval.includes("m") && !leaseval.endsWith("m")) || 
					  (leaseval.includes("s") && !leaseval.endsWith("s")))
			  {
				  alertmsg += "Lease time in the row "+i+" is not valid format...\n";
			  }
			  else
			  {
				  var lease = leaseval.replace("m","").replace("s","").replace("h",""); 
				  if(isNaN(lease))
					  alertmsg += "Lease time in the row "+i+" is not valid..... Please enter units h or m after number\n ";
				  else
					  alertmsg +="Lease time in the row "+i+" is not valid. Lease Time should be less than 1000 days\n "
			  }
		  }
		  else
		  {
			  leaseobj.style.outline = "initial";
			  leaseobj.title = "";
		  }
		  //added new lines
			var i_ip_val = ipaddressobj.value;
			var i_mac_val = macobj.value;
			for(var j=1;j<rows.length;j++)
			{
				var jipobj = rows[j].cells[2].childNodes[0];
				var jmacobj = rows[j].cells[3].childNodes[0];
				if((jipobj != null) && (jipobj.value.trim() != ""))
				{
					var j_ip_val = jipobj.value;
					var j_mac_val = jmacobj.value;
					if((i!=j) && (i_ip_val == j_ip_val))
					{
						if(!alertmsg.includes(i_ip_val+" is already exists"))
							alertmsg +=i_ip_val+" is already exists \n";
						ipaddressobj.style.outline = "thin solid red";
						break;
					}
				}
			  }
			  if (j == rows) {
					   ipaddressobj.style.outline = "initial";
					   ipaddressobj.title = "";
					}
					//new lines 
			  }
		 
		  if(alertmsg.trim().length == 0)
			return true;
		  else {	
			alert(alertmsg);
			return false;	
		  }
	}
	  </script>
   </head>
   <body>
      <form action="savedetails.jsp?page=dhcp&slnumber=<%=slnumber%>" method="post" onsubmit="return validateStaticLeases()">
         <br>
         <p class="style5" align="center">Static Leases</p>
         <br><input type="text" id="routesrwcnt" name="routesrwcnt" value="1" hidden="">
         <table class="borderlesstab" id="WiZConff" align="center">
            <tbody>
               <tr>
                  <th style="text-align:center;min-width:30px"> S.No</th>
                  <th style="text-align:center;max-width:130px;min-width:130px;"> HostName</th>
                  <th style="text-align:center;max-width:130px;min-width:130px;"> IPv4 Address</th>
                  <th style="text-align:center;max-width:130px;min-width:130px;"> MAC Address</th>
                  <th style="text-align:center;max-width:130px;min-width:130px;"> Lease time</th>
                  <th style="text-align:center;min-width:40px"> Action</th>
               </tr>
            </tbody>
         </table>
         <div align="center"> <br><input class="button" type="button" id="add" value="Add" style="display:inline block" onclick="addRow('WiZConff')"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"></div>
      </form>
	  <%
	    for(int i=0;i<static_lease_arr.size();i++)
		{
			JSONObject lease_obj = (JSONObject)static_lease_arr.get(i);
			String hostname = lease_obj.containsKey("name")? lease_obj.getString("name"):"";
			String ipaddress = lease_obj.containsKey("ip")? lease_obj.getString("ip"):"";
			String macaddress = lease_obj.containsKey("mac")? lease_obj.getString("mac"):"";
			String leasetime = lease_obj.containsKey("leasetime")?lease_obj.getString("leasetime"):"";
			%>
			<script>
			addRow('WiZConff');
			fillrow('<%=i+1%>','<%=hostname%>','<%=ipaddress%>','<%=macaddress%>','<%=leasetime%>');
			</script>
			<%	
		}
	  %>
   </body>
</html>