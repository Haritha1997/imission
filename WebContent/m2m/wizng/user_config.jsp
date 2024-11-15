<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONArray usrconfarr = null;
   BufferedReader jsonfile = null; 

   		String slnumber=request.getParameter("slnumber");
		String status=request.getParameter("status")==null?"":request.getParameter("status");
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
   		usrconfarr =  wizjsonnode.getJSONObject("USERCONFIG").getJSONObject("TABLE").getJSONArray("USERS");	
   		
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
      <style type="text/css">
	  #WiZConf {font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;font-size: 12.5px;border-collapse: collapse;width: 600px;}#WiZConf td, #WiZConf th {border: 2px solid #ddd;  padding: 8px; text-align:center;}#WiZConf tr:nth-child(even){background-color: #f2f2f2;}#WiZConf tr:hover {background-color: #d3f2ef;}#WiZConf th {padding-top: 12px;padding-bottom: 12px;text-align:center;background-color: #5798B4;color: white;}.text {background: white; border: 2px Solid #DDD;border-radius: 5px;box-shadow: 1 1 5px #DDD inset;color: #000;height:17px;}.button{display: block;border-radius: 6px;background-color:#6caee0;color: #ffffff;font-weight: bold;box-shadow: 1px 2px 4px 0 rgba(0, 0, 0, 0.08);padding: 12px 20px;border: 0;}.style1{font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;color:#5798B4;font-size: 16px;font-weight: bold; cursor:pointer}td #borderless{ border: none;padding:0 0 0 0;}#noborder {border:none; align:center} a{text-decoration:none; cursor:pointer}
	  </style>
      <script language="javascript" type="text/javascript">
	  function openInFrame(url){	
	  top.frames['WelcomeFrame'].location.href = url;
	  }
	  function showStatus(status)
	  {
		  if(status!="")
			  alert(status);
	  }
	  </script>
   </head>
   <body>
      <p class="style1" align="center">User Configuration</p>
      <table id="WiZConf" align="center">
        <tr>
               <th width="150">Username</th>
               <th width="150">Password</th>
            </tr>
         <tbody>
		  <% 
			   	  for(int i=0;i<usrconfarr.size();i++)
			   	  {
			   		  JSONObject user = usrconfarr.getJSONObject(i);
			   		  String usrname = "";
			   		  String password = "";
					  System.out.println(user);
			   		  if(user != null)
			   		  {
			   		 	 usrname = user.getString("username");
			   		 	 password = user.getString("password");
			   		  }
			   %> 
          

            <tr>
               <td style="min-width:150px;height:16px;"><%=usrname%></td>
               <td style="min-width:150px;"><%if(password.length() > 0){%>*****<%}else{%>&nbsp;<%}%></td>
            </tr>
            <% }for(int i=usrconfarr.size();i<3;i++){%>
           <tr>
               <td style="min-width:150px;height:16px;">&nbsp;</td>
               <td style="min-width:150px;"></td>
            </tr>
            <%}%>
         </tbody>
      </table>
      <br>
      <table id="noborder" align="center">
         <tbody>
            <tr id="noborder">
               <td id="noborder" width="80px" align="center"><a href="javascript:openInFrame(&quot;adduser.jsp?slnumber=<%=slnumber%>&quot;)"><button class="button" action="javascript:openInFrame(&quot;adduser.jsp&quot;)">Add</button></a></td>
               <td id="noborder" width="100px" align="center"><a href="javascript:openInFrame(&quot;edituser.jsp?slnumber=<%=slnumber%>&quot;)"><button class="button" action="javascript:openInFrame(&quot;modifyuser.jsp&quot;)">Modify</button></a></td>
               <td id="noborder" width="100px" align="center"><a href="javascript:openInFrame(&quot;deleteuser.jsp?slnumber=<%=slnumber%>&quot;)"><button class="button" action="javascript:openInFrame(&quot;deleteuser.jsp&quot;)">Delete</button></a></td>
            </tr>
         </tbody>
      </table>
   </body>
   <script>
   showStatus('<%=status%>');
   </Script>
</html>

