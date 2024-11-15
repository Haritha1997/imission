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
   		String slnumber=request.getParameter("slnumber");
 		String version=request.getParameter("version");
 		String errorstr = request.getParameter("error");
		JSONObject wizjsonnode = null;
		FileReader propsfr = null;
		JSONObject ipprefixobj = null;
		BufferedReader jsonfile = null;  
		boolean enabled = false;
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
					ipprefixobj =  wizjsonnode.containsKey("ipprefix")?(wizjsonnode.getJSONObject("ipprefix")):new JSONObject();
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
<html><head>
<link rel="stylesheet" type="text/css" href="css/style.css">
<script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/ipprefixlist.js"></script>     
<script type="text/javascript">
function showErrorMsg(errormsg)
{
	alert(errormsg);
}
var prelistnamerow=1;
function checkAlphaNUmeric(id,slnumber,version)
	  {
	 
	      var val = document.getElementById(id).value.trim();
		  if(!isValidAlphaNumberic(id)&& val.length != 0)
		  {
			  alert("Please Use Only AlphaNumeric");
			  return;
		  }
		  addNewPrefixList(id,true,slnumber,'<%=version%>');
	  }
</script>
</head>

<body>

	<form action="savedetails.jsp?page=ipprefixlist&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="">
	<br>
	<input type="text" id="slno" value="<%=slnumber%>" hidden />
	<p class="style5" align="center">IP Prefix List</p>
	<br>
	<div id="prefixlistdiv" style="margin: 0px;" align="center">
               <input type="text" id="prefixlistcnt" name="prefixlistcnt" value="1" hidden="">
               <table class="borderlesstab" id="prefixlisttab" style="width:700px;" align="center">
                  <tbody>
                     <tr>
                       <th style="text-align:center;" width="50px" align="center">S.No</th>
					    <th style="text-align:center;" width="70px" align="center">Name</th>
						<th style="text-align:center;" width="100px" align="center">No. of Records</th>
                        <th style="text-align:center;" width="70px" align="center">Status</th>
                        <th style="text-align:center;" width="100px" align="center">Action</th>
                     </tr>
                     
                  </tbody>
               </table>
			   <br> <br>
			    <table class="borderlesstab" id="prefixlistcntadd" align="center">
            <tbody>
			<tr>
                  <td width="180px">New Instance Name</td>
                  <td><input type="text" value="" class="text" id="nwinstname" name="nwinstname" maxlength="32" onkeypress="return avoidSpace(event) && avoidEnter(event)" onfocusout="isEmpty('nwinstname','New Instance Name')"></td>
                  <td colspan="2"><input type="button" class="button1" id="add" value="Add" onclick="checkAlphaNUmeric('nwinstname','<%=slnumber%>','<%=version%>');"></td>
               </tr>
			    <tr style="background-color:white;">
               <td colspan="3">
               <p style="font-size:11px;font-family: verdana;margin-left:80px;"><span style="color:red;text-align:left;"><b> Note:</b></span>Special Characters are not allowed </p>
               </td>
               </tr>
            </tbody>
			</table>
			   
               <div align="center"><input type="submit" name="Apply" value="Apply" class="button"></div>
    </div>
	</form>
	<%
   	if(errorstr != null && errorstr.trim().length() > 0)
			{%>
		     <script>
			 showErrorMsg('<%=errorstr%>');
			 </script>
			<%}
	/*  <% */
	    int i=0;
		Iterator<String> keys =ipprefixobj.keys();
		
	    while(keys.hasNext())
		{
			String ckey = keys.next();
			if(ckey.contains("List:")){
			JSONObject prefix_obj = ipprefixobj.getJSONObject(ckey);
			String instname = ckey.replace("List:","");
			String instanceact = "";
			String records = "";
			if(prefix_obj.containsKey("Instance")){
				instanceact = prefix_obj.getString("Instance");
			}
			if(prefix_obj.containsKey("Records")){
				records = prefix_obj.getString("Records");
			}
			%>
			<script>
			addRow('prefixlisttab','<%=slnumber%>','<%=version%>');
			fillPrefixList('<%=i+1%>','<%=instname%>','<%=records%>','<%=instanceact%>');
			</script>
			<%	
			i++;
			}
		}
	  %>
</body></html>