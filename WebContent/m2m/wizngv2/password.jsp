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
   JSONArray pwd_arr = null;
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
   		
			pwd_arr =  wizjsonnode.containsKey("htpasswd_decrypt")?(wizjsonnode.getJSONObject("htpasswd_decrypt").containsKey("credentials")?wizjsonnode.getJSONObject("htpasswd_decrypt").getJSONArray("credentials"):new JSONArray()):new JSONArray();
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
      <link href="css/style.css" rel="stylesheet" type="text/css">
      <link href="css/fontawesome.css" rel="stylesheet">
      <link href="css/solid.css" rel="stylesheet">
      <link href="css/v4-shims.css" rel="stylesheet">
      <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
      <style></style>
      <script type="text/javascript" src="js/pwd.js"></script>
       <script type="text/javascript" src="js/common.js"></script>
      <script type="text/javascript">
      function checkExcludeAndProceed(id)
	  {
		  if(isExcludedCharsExistsUsername(id))
		  {
			  alert("Please Don't use Excluded characters mentioned under NOTE");
			  return;
		  }
		  addPasswordPage(id, true);
	  }
     
      </script>
   </head>
   <body>
      <form action="savedetails.jsp?page=password&slnumber=<%=slnumber%>" id="form" method="post" onsubmit="">
         <br>
         <blockquote>
            <p align="center" id="output" class="style5">Password</p>
            <br>
         </blockquote>
         <input type="text" id="pwdrwcnt" name="pwdrwcnt" value="1" hidden="">
         <table class="borderlesstab" id="WiZConff" align="center" style="width:400px;">
            <tbody>
               <tr>
                  <th align="center" style="text-align:center;" width="50px">S.No</th>
                  <th align="center" style="text-align:center;" width="120px">Username</th>
                  <th align="center" style="text-align:center;" width="120px">Action</th>
               </tr>
            </tbody>
         </table>
         <br><br>
         <table class="borderlesstab" id="WiZConf1" align="center" >
            <tbody>
               <tr>
                  <td width="180px">New Username</td>
                  <td><input type="text" class="text" max="32" id="nwusername" name="nwusername" maxlength="32" onkeypress="return avoidSpace(event) && avoidEnter(event)" onmouseover="setTitle(this)" onfocusout="isEmpty('nwusername','Username')"></td>
                  <td colspan="2"><input type="button" class="button1" id="add" value="Add" onclick="checkExcludeAndProceed('nwusername')"></td>
               </tr>
               <tr style="background-color:white;">
               <!-- <td width="180px">
               </td>
               <td colspan="2">
               <p style="font-size:11px;font-family: verdana;"><span style="color:red"><b> Note:</b></span>  Excluded characters . \ ' " # : =</p>
               </td> -->
               <td colspan="3"><p style="font-size:11px;font-family: verdana;margin-left:80px;"><span style="color:red;text-align:left;"><b> Note:</b></span>  Excluded characters  \ . ' " = : # </p></td>
               </tr>
            </tbody>
         </table>
         
      </form>
       <%
	    for(int i=0;i<pwd_arr.size();i++)
		{
			JSONObject portfrwd_obj = (JSONObject)pwd_arr.get(i);
			String uname = portfrwd_obj.containsKey("username")? portfrwd_obj.getString("username"):"";
			%>
			<script>
			  addRow('WiZConff',false,'<%=slnumber%>');
			  fillrow(<%=i+1%>,'<%=uname%>');
			</script>
			<%	
		}
	  %>
      <script>
      setslnumber('<%=slnumber%>');
	  
	  </script>
   </body>
</html>