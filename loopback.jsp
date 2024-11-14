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
	JSONObject loopbackobj = null;
	JSONArray  loopbackiparr = null;
	JSONArray  loopbackipv6arr = null;
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
   		
			loopbackobj =  wizjsonnode.getJSONObject("network").getJSONObject("interface:loopback");
			
			if(loopbackobj != null)
			{
				if(loopbackobj.containsKey("ipaddr"))
				loopbackiparr = loopbackobj.getJSONArray("ipaddr");
				
			}
			
			if(loopbackiparr == null)
				loopbackiparr = new JSONArray();
	   if(loopbackobj != null)
		{
			if(loopbackobj.containsKey("ip6addr"))
			loopbackipv6arr = loopbackobj.getJSONArray("ip6addr");
			
		}
		if(loopbackipv6arr == null)
			loopbackipv6arr = new JSONArray();
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
      <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
	  <script type="text/javascript" src="js/loopback.js"></script>
	<script type="text/javascript" src="js/common.js"></script> 
<script type="text/javascript">
function showErrorMsg(errormsg)
{
	alert(errormsg.replace("and", "&"));
}
var iprows=1;
var ipv6rows = 1;
function validateLoopbackIpConfig()
{
	var alertmsg = ""; 
	var table = document.getElementById("WiZConf"); 
	var rows = table.rows;  
	const lbkiparrobj = [];
	const lbknmobj = [];
	const lbknetwk=[];
	const lbkbdcast=[];
	var curnetwork = "";
	var curbdcast="";
	try
	{
			var actobj = document.getElementById("loopback");
			var check_empty = true;
			if(!actobj.checked)
				check_empty = false;
			for(var i=2;i<rows.length;i++) 
			{ 
				 var cols = rows[i].cells; 
				 var ipaddress = cols[1].childNodes[0].childNodes[0]; 
				 var subnet = cols[1].childNodes[2].childNodes[0]; 
				 var valid = validateIPOnly(ipaddress.id,check_empty,"IPV4 Address"); 
				 var ipvalid = valid;
				 
				 if(!valid) 
				 { 
					alertmsg += (i - 1);
					if (i == 2) alertmsg += "st";
					else if (i == 3) alertmsg += "nd";
					else if (i == 4) alertmsg += "rd";
					else alertmsg += "th";
					 if(ipaddress.value.trim() =="") 
					 {
					  	alertmsg += " IP Address should not be empty\n"; 
					 } 
					 else 
					 { 
					 	alertmsg += " IP Address is not valid\n"; 
					 } 
				 } 
				 valid = validateSubnetMask(subnet.id,check_empty,"Subnet Address"); 
				 var netmaskvalid = valid;
				 if(!valid) 
				 {
				 	alertmsg += (i - 1);
					if (i == 2) alertmsg += "st";
					else if (i == 3) alertmsg += "nd";
					else if (i == 4) alertmsg += "rd";
					else alertmsg += "th"; 
				    if(subnet.value.trim() == "") 
				    { 
				     	alertmsg += " Subnet Address should not be empty\n"; 
				    } 
				    else 
				    { 
				    	alertmsg += " Subnet Address is not valid\n"; 
				    } 
				 } 
				valid = false;
			   if(ipvalid && netmaskvalid  && subnet.value !="255.255.255.255" && ipaddress.value.trim() !="")
				{
					var network = getNetwork(ipaddress.value,subnet.value);
					var broadcast = getBroadcast(network,subnet.value);
					if(ipaddress.value == network)
					{
						alertmsg += (i - 1);
						if (i == 2) alertmsg += "st";
						else if (i == 3) alertmsg += "nd";
						else if (i == 4) alertmsg += "rd";
						else alertmsg += "th";
						alertmsg += " IPv4 Address should not be Network\n";
						ipaddress.title=" IPv4 Address should not be Network\n";
						ipaddress.style.outline = "thin solid red";
					}
					else if(ipaddress.value == broadcast)
					{
						alertmsg += (i - 1);
						if (i == 2) alertmsg += "st";
						else if (i == 3) alertmsg += "nd";
						else if (i == 4) alertmsg += "rd";
						else alertmsg += "th";
						alertmsg += " IPv4 Address should not be Broadcast\n";
						ipaddress.title="IPv4 Address should not be Broadcast\n";
						ipaddress.style.outline = "thin solid red";
					}
					else
					{
						valid = true;
						lbknetwk.push(network);
						lbkbdcast.push(broadcast);
						curnetwork = network;
						curbdcast = broadcast;
					}
				}
				if(valid == true)
				{
					for(var l=0;l<lbkiparrobj.length;l++)
					{
						var network1 = lbknetwk[l];
						var broadcast1 = lbkbdcast[l];
						if((isGraterOrEquals(curnetwork,network1) && !isGraterOrEquals(curnetwork,broadcast1)) || (isGraterOrEquals(network1, curnetwork) && !isGraterOrEquals(network1,curbdcast)))
						{
							alertmsg += ipaddress.value+" overlaps with "+lbkiparrobj[l].value+".\n";
							
							ipaddress.style.outline = "thin solid red";
							lbkiparrobj[l].style.outline = "thin solid red";
							ipaddress.title = "overlaps with "+lbkiparrobj[l].value;
							lbkiparrobj[l].title = "overlaps with "+ipaddress.value;
							break;
						}
					}
					lbkiparrobj.push(ipaddress);
					lbknmobj.push(subnet);
				}
			}
			var loopbk_ip6_arr=[];
		 	var table1 = document.getElementById("ipconfig1");
			var rows1 = table1.rows;
			for (var j = 0; j < rows1.length; j++) {
				var cols1 = rows1[j].cells;
				var ipv6address = cols1[1].childNodes[0].childNodes[0];
				var valid = validateIPv6(ipv6address.id, false, "IPv6 Address",true);
				if (!valid && ipv6address.value.trim() != "") {
				   alertmsg += "IPv6 Address is not valid\n";
				}
				else
				{
					for(ct=0;ct<loopbk_ip6_arr.length;ct++)
					{
						var ipv6add = ipv6address.value.trim();
						if( ipv6add !=""&&loopbk_ip6_arr[ct] == ipv6add)
						{
							ipv6address.style.outline = "thin solid red";
							ipv6address.title="Duplicate IPV6 Address "+ipv6add;
							alertmsg += ipv6address.title+"\n";
							break;
						}
					}
					if(ct==loopbk_ip6_arr.length)
						loopbk_ip6_arr.push(ipv6address.value);
				}
			}
			
			 if(alertmsg.trim().length == 0) 
			 { 
			 return true; 
			 } 
			 else 
			 { 
			 alert(alertmsg); 
			 return false; 
			 }
	}
	catch(e)
	{
		alert(e);
	}
}
</script>
</head>
<body>
<form action="savedetails.jsp?page=loopback&slnumber=<%=slnumber%>" method="post" onsubmit="return validateLoopbackIpConfig()"><br/>
<input type="hidden" id="loopbackiprows" name="loopbackiprows" value="1"/>
<input type="hidden" id="loopbackipv6rows" name="loopbackipv6rows" value="1"/>
<p class="style5" align="center">Loopback IP Configuration</p><br/>
<table class="borderlesstab" id="WiZConf" align="center">
<tbody>
<tr>
<th width="200">Parameters</th>
<th width="200">Configuration</th>
</tr>
<tr>
<td>Activation</td>
<td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="loopback" id="loopback" style="vertical-align:middle" <%if(loopbackobj.containsKey("enabled") && loopbackobj.getString("enabled").equals("1")) {%> checked <%}%> ><span class="slider round"></span></label></td>
</tr>
</tbody>
</table>
<table class="borderlesstab" id="ipconfig1" align="center">
		<tbody>
			
		</tbody>
</table>
<div align="center">
<input type="submit" value="Apply" name="Apply" style="display:inline block" class="button">

</div>
</form>
 <%
   	if(errorstr != null && errorstr.trim().length() > 0)
			{%>
		     <script>
			 showErrorMsg("<%=errorstr%>");
			 </script>
			<%}
     if(loopbackiparr.size()>0)
	  {
	      for(int i=0;i<loopbackiparr.size();i++)
	      {
			 String cidr_ip =  loopbackiparr.getString(i);
			 SubnetUtils utils = new SubnetUtils(cidr_ip);
			 utils.setInclusiveHostCount(true);
			 String row = i+1+"";
			 %>
			 <script>		
			 addIPRowAndChangeIcon('<%=(i+1)%>');		 
			 fillIProw('<%=(i+2)%>','<%=utils.getInfo().getAddress()%>','<%=utils.getInfo().getNetmask()%>');
			 </script>
			<% 
	      }
	  }
	  else
	  {
		 %>
		 <script>		
		 addIPRowAndChangeIcon('1');
		 </script>
		<%  
	  }
		if(loopbackipv6arr.size()>0)
		{
			for(int i=0;i<loopbackipv6arr.size();i++)
			{   	 
				 String ipv6_addr =  loopbackipv6arr.getString(i);
				 String row = i+1+"";
				 %>
				 <script>		
				 addIPV6RowAndChangeIcon('<%=(i+1)%>');		 
				 fillIPV6Row('<%=(i+2)%>','<%=ipv6_addr%>');
				 </script>
				<% 
			}
		}
		else
		{
			 %>
			 <script>		
			 addIPV6RowAndChangeIcon('1');
			 </script>
			<%  
		}
%>
 
</body>
 <script>
	  findLastRowAndDisplayRemoveIcon();
	  findIPV6LastRowAndDisplayRemoveIcon();
</script>
</html>