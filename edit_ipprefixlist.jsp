<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.apache.commons.net.util.SubnetUtils"%>
<%@page import="java.net.NetworkInterface"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>
 <%
           String prefixname = request.getParameter("prefixname")==null?"":request.getParameter("prefixname");
   		   String slnumber=request.getParameter("slnumber");
 		   String version=request.getParameter("version");
		   String errorstr = request.getParameter("error");
		   JSONObject wizjsonnode = null;
		   FileReader propsfr = null;
		   JSONObject ipprefixobj = null;
		   JSONObject edit_ipprefixobj = null;
		   JSONArray prefixnwrk=null;
		   BufferedReader jsonfile = null;  
		   String act="";
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
					ipprefixobj = wizjsonnode.containsKey("ipprefix")?wizjsonnode.getJSONObject("ipprefix"):new JSONObject();
					edit_ipprefixobj = ipprefixobj.containsKey("List:"+prefixname)?ipprefixobj.getJSONObject("List:"+prefixname):new JSONObject();
					prefixnwrk=edit_ipprefixobj.containsKey("Network")?edit_ipprefixobj.getJSONArray("Network"):new JSONArray();
					if(edit_ipprefixobj.isEmpty())
						   act="checked";
					/* Iterator<String> keys =ipprefixobj.keys();
				   	while(keys.hasNext())
				   	{
						String ckey = keys.next();
						
						if(ckey.contains("List:")){
							JSONObject prefixlist_obj = ipprefixobj.getJSONObject(ckey);
							System.out.println("prefixlist_obj "+prefixlist_obj);
							insname = ckey.replace("List:","");
							if(prefixlist_obj.containsKey("Instance"))
							{
								String acten=prefixlist_obj.getString("Instance");
							act=acten.contains("Enable")?"checked":"";
							}
						}
					} */
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
			   }
			   finally
			   {
				   if(propsfr != null)
					   propsfr.close();
				   
				   if(jsonfile != null)
					   jsonfile.close();
			   }
		   }
%>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="css/style.css">
	<script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
	<script type="text/javascript" src="js/common.js"></script>
	<script type="text/javascript" src="js/ipprefixlist.js"></script>  
	<script type="text/javascript">
		var netlistrow=2;
		var recordscnt=0;
		var curdiv="";
		function validatePrefixList()
		{
		try{
			var altmsg="";
				var index = document.getElementById("add_prefixlist_rwcnt").value;
				var prelisttab = document.getElementById("add_prefixlisttab");
				var rows = prelisttab.rows;
				for(var i=3;i<rows.length;i++)
				{
					var cols=rows[i].cells;
					var netobj = cols[1].childNodes[0].childNodes[0];
					var startobj = cols[1].childNodes[0].childNodes[1];
					var endobj = cols[1].childNodes[0].childNodes[2];
					var accessobj = cols[1].childNodes[0].childNodes[3];
					var valid = validateCIDRNotation(netobj.id, true, "Network");
					var ipvalid = valid;
					if (!valid) {
						if (netobj.value.trim() == "") 
							altmsg += "The Network Ip in the row " + (i-2) + " should not be empty\n";
						else 
							altmsg += "The Network Ip in the row " + (i-2) + " is not valid\n";
						continue;	
					}
					
					//added new lines pallavi
					var networkmask_arr=null;
					if(ipvalid)
					{
					var networkval = netobj.value;
					if(networkval.includes('/'))
					networkmask_arr = networkval.split('/');
					var network="";
					var broadcast="";
					network = getNetwork(networkmask_arr[0],getMask(networkmask_arr[1]));
					broadcast = getBroadcast(network,getMask(networkmask_arr[1]));
					if(networkmask_arr[0] != network)
						{
						netobj.title = "Network Ip in the row "+(i-2)+" should be Network in  Network List \n";
						altmsg += netobj.title;
						netobj.style.outline = "thin solid red";
						}
					} 
					//ends pallavi
					var net=getSuffix(netobj.value);
					if(parseInt(startobj.value)<=net)
					{
						altmsg += "Start range must be greater than prefix length\n";
						startobj.style.outline="thin solid red";
						startobj.title="Start range must be greater than prefix length";
					}
					else
					{
						startobj.style.outline="initial";
						startobj.title="";
					}
					if(parseInt(endobj.value)<=net && startobj.value.trim()=="")
					{
						altmsg += "End range must be greater than prefix length\n";
						endobj.style.outline="thin solid red";
						endobj.title="End range must be greater than prefix length";
					}
					else if(parseInt(endobj.value)<parseInt(startobj.value))
					{
						altmsg += "End range must be greater than or equal to Start range\n";
						endobj.style.outline="thin solid red";
						endobj.title="End range must be greater than or equal to Start range";
					}
					else
					{
						endobj.style.outline="initial";
						endobj.title="";
					}
					var net_add_i = netobj.value;
					var start_val_i = startobj.value;
					var end_val_i = endobj.value;
					for(var j=3;j<rows.length;j++)
					{
						var jcols=rows[j].cells;
						var netobj_j = jcols[1].childNodes[0].childNodes[0];
						var startobj_j = jcols[1].childNodes[0].childNodes[1];
						var endobj_j = jcols[1].childNodes[0].childNodes[2];
						var net_add_j = netobj_j.value;
						var start_val_j = startobj_j.value;
						var end_val_j = endobj_j.value;
						if((net_add_i.trim()!="") && (net_add_i==net_add_j)&& (i!=j)&&(start_val_i.trim()=="")&& (end_val_i.trim()=="")) {
						 if (!altmsg.includes("Warning : Duplicate Network "+net_add_i))
							altmsg += "Warning : Duplicate Network "+net_add_i+"\n";
								  netobj.style.outline = "thin solid red";
						}
						if((net_add_i.trim()!="")&& (start_val_i.trim()!="") && (end_val_i.trim()!="") && (net_add_i==net_add_j) 
						&& (start_val_i==start_val_j) && (end_val_i==end_val_j) && (i!=j)) {
							if (!altmsg.includes("Warning : Duplicate Network "+net_add_i+", "+start_val_i+", "+end_val_i))
							 altmsg += "Warning : Duplicate Network "+net_add_i+", "+start_val_i+", "+end_val_i+"\n";
						  netobj.style.outline = "thin solid red";
						  startobj.style.outline = "thin solid red";
						  endobj.style.outline = "thin solid red";
						  break;
						}
					}
				}
				
			if (altmsg.trim().length==0) {
			  return true;
		   } else {
			  alert(altmsg);
			  return false;
		   }
		}catch(e)
		{alert(e);}
		}
	</script>
</head>
<body>
	<form action="savedetails.jsp?page=edit_ipprefixlist&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="return validatePrefixList()">
		<div id="add_prefixlist" style="margin:0px;" align="center">
			<input type="hidden" id="records" name="records" value="0">
			<input type="hidden" id="add_prefixlist_rwcnt" name="add_prefixlist_rwcnt" value="0">
		   <table class="borderlesstab" id="add_prefixlisttab" style="width:700px" align="center">
			  <tbody>
			 <tr>
					<th width="150px">Parameters</th>
					<th>Configuration</th>
			 </tr>
			 <tr>
	          <td>Activation</td>
	          <td>
	            <label class="switch" style="vertical-align:middle">
	           <%if(edit_ipprefixobj.containsKey("Instance"))
						act = edit_ipprefixobj.getString("Instance").equals("Enable")?"checked":""; %>
	              <input type="checkbox" name="actvn" id="actvn" style="vertical-align:middle" <%=act%>>
	              <span class="slider round"></span>
	            </label>
	          </td>
	        </tr>
			<tr>
					<td>Prefix List Name</td>
					<td><input type="text" class="text" id="prefixlistname" name="prefixlistname" value="<%=prefixname%>" readonly></td>
					
			 </tr>				
			  </tbody>
		   </table>
		   <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"></div>
		</div>
	</form>
<%
              if(prefixnwrk.size()>0)
	  {
	      for(int i=0;i<prefixnwrk.size();i++)
	      {   
	    	  String vals=prefixnwrk.getString(i);
	    	  String ipval="";
			  String strtran="";
			  String endran="";
			  String perorden="";
			  String  valsarr[] = vals.split("-");
			  ipval=valsarr[0];
			  if(valsarr[1]=="@")
				  strtran="";
			  else
			  	  strtran=valsarr[1];
			  if(valsarr[2]=="@")
				  endran="";
			  else
				  endran=valsarr[2];
			  perorden=valsarr[3];
			 %>
			 <script>		
			 addNetListRow(netlistrow);	
			 fillNetListRow(netlistrow,'<%=ipval%>','<%=strtran%>','<%=endran%>','<%=perorden%>');
			 </script>
			<% 
	      }
	  }
      else {
    	     %>
    	     <script type="text/javascript">
    	     addNetListRow(netlistrow);
    	     </script>
   	     <%} %>
	  
</body>
</html>