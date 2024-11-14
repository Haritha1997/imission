<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="org.apache.commons.net.util.SubnetUtils"%>
<%@page import="java.net.NetworkInterface"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.Iterator"%>

 <%
   JSONObject wizjsonnode = null;
  JSONObject cur_ipsecobj = null;
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
   		
			cur_ipsecobj =  wizjsonnode.containsKey("ipsec")?(wizjsonnode.getJSONObject("ipsec")): new JSONObject();
			
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
   	<meta http-equiv="cache-control" content="max-age=0" />
	<meta http-equiv="cache-control" content="no-cache" />
	<meta http-equiv="expires" content="0" />
	<meta http-equiv="expires" content="Tue, 01 Jan 1980 1:00:00 GMT" />
	<meta http-equiv="pragma" content="no-cache" />
      <link href="css/style.css" rel="stylesheet" type="text/css">
      <link href="css/fontawesome.css" rel="stylesheet">
      <link href="css/solid.css" rel="stylesheet">
      <link href="css/v4-shims.css" rel="stylesheet">
      <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
      <style></style>
      <script type="text/javascript" src="js/ipsec.js"></script>
      <script type="text/javascript" src="js/common.js"></script>
      
      <script type="text/javascript">
     function checkAlphaNUmeric(id,slnumber,version)
	  {
		  if(!isValidAlphaNumberic(id) && document.getElementById(id).value.trim().length != 0)
		  {
			  alert("Please Use Only AlphaNumeric");
			  return;
		  }
		  addIPSecPage(id, true,slnumber,'<%=version%>');
	  }
      </script>
   </head>
   <body>
      <form action="savedetails.jsp?page=ipsec&slnumber=<%=slnumber%>" id="form" method="post" onsubmit="">
         <br>
         <blockquote>
            <p align="center" id="output" class="style5">IPSec Configuration</p>
            <br>
         </blockquote>
         <input type="text" id="ipsecrwcnt" name="ipsecrwcnt" value="1" hidden="">
         <table class="borderlesstab" id="WiZConff" align="center" style="width:930px;">
            <tbody>
               <tr>
                  <th align="center" style="text-align:center;" width="50px">S.No</th>
                  <th align="center" style="text-align:center;" width="70px">Instance Name</th>
                  <th align="center" style="text-align:center;" width="120px">Exchange Mode</th>
                  <th align="center" style="text-align:center;" width="50px">Auth Mode</th>
                  <th align="center" style="text-align:center;" width="70px">Operation Level</th>
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
                  <td>
                  <input type="text" class="text" id="nwinstname" name="nwinstname" maxlength="32" onkeypress="return avoidSpace(event) && avoidEnter(event)" onmouseover="setTitle(this)" onfocusout="isEmpty('nwinstname','Instance Name')">
                  </td>
                  <td><input type="button" class="button1" id="add" value="Add" onclick="checkAlphaNUmeric('nwinstname','<%=slnumber%>','<%=version%>')"></td>
               </tr>
               <tr style="background-color:white;">
               <td colspan="2">
               <p style="font-size:11px;font-family: verdana;margin-left:80px;"><span style="color:red;text-align:left;"><b> Note:</b></span>Special Characters are not allowed </p>
               </td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" style="display:inline" name="Apply" value="Apply" class="button2"></div>
      </form>
       <%
	    int i=0;
		Iterator<String> keys =cur_ipsecobj.keys();
	    while(keys.hasNext())
		{
			String ckey = keys.next();
			if(ckey.contains("remote:")){
			JSONObject ipsec_obj = cur_ipsecobj.getJSONObject(ckey);
			String instname = ckey.replace("remote:","");
			String exmode = "";
			String auth = "";
			String op_level ="";
			String activation = "";
			String backupref = "";
			if(ipsec_obj.containsKey("authentication")){
				auth = ipsec_obj.getString("authentication");
			}
			if(ipsec_obj.containsKey("exchange_mode")){
				exmode = ipsec_obj.getString("exchange_mode");
			}
			if(ipsec_obj.containsKey("backup_reference")) {
				backupref = ipsec_obj.getString("backup_reference");
			}
			if(ipsec_obj.containsKey("operation_level")){
				if(ipsec_obj.getString("operation_level").equals("main"))
					op_level = "Main";
				else
					op_level = "Backup("+backupref+")";
			}
			if(ipsec_obj.containsKey("enabled")){
				activation = ipsec_obj.getString("enabled").toString().equals("1")?"checked":"";
			}
			%>
			<script>
			addRow('WiZConff',false,'<%=slnumber%>','<%=version%>');
			fillrow('<%=i+1%>','<%=instname%>','<%=activation%>','<%=exmode%>','<%=auth%>','<%=op_level%>');
			</script>
			<%	
			i++;
			}
		}
	  %>
   </body>
</html>