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
		JSONObject nwobj=null;
		JSONObject greobj=null;
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
				nwobj=wizjsonnode.containsKey("network")?wizjsonnode.getJSONObject("network"):new JSONObject();
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
<!DOCTYPE html>
<html>
   <head>
      <!--<meta http-equiv="refresh" content="5">-->
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <link href="css/fontawesome.css" rel="stylesheet">
      <link href="css/solid.css" rel="stylesheet">
      <link href="css/v4-shims.css" rel="stylesheet">
      <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
	  <script type="text/javascript" src="js/gre.js"></script>
     <script type="text/javascript" src="js/common.js"></script>
     <!-- <script type="text/javascript" src="js/gre.js"></script> -->
     <style>
      .circle {
         width: 10px;
         height: 10px;
         border-radius: 50%;
         display:inline-block;
         margin:0 5px;
		}
		span.bg-Disabled
		{
			background:grey;
		}
		span.bg-Up
		{
			background:#3CB371;
		}
		span.bg-Down
		{
			background:red;
		}
     </style>
	  <script type="text/javascript">
	  var iprows = 1;
      //Added by Venkatesh - 19/01/2024 - Start
      function checkExcludeAndProceed(id,slnumber,version){
         if(!isValidAlphaNumberic(id) && document.getElementById(id).value.trim().length != 0)
         {
            alert("Please Use Only AlphaNumeric");
            return;
         }
         addgrepage('nwinstname', true,'<%=slnumber%>','<%=version%>');
      }
	</script>
   </head>
   <body>
      <form action="savedetails.jsp?page=gre&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="">
         <input type="text" id="slno" value="<%=slnumber%>" hidden />
         <br>
         <blockquote>
            <p class="style5" align="center">GRE</p>
         </blockquote>
         <br><input type="text" id="grerwcnt" name="grerwcnt" value="1" hidden="">
         <table class="borderlesstab" id="GREtab1" style="width:600px;" align="center">
            <tbody>
               <tr>
                  <th style="text-align:center;" width="30px" align="center">S.No</th>
                  <th style="text-align:center;" width="90px" align="center">Instance Name</th>
                  <th style="text-align:center;" width="30px" align="center">Activation</th>
                  <!-- Newly added on 09-02-2024 -->
                  <th style="text-align:center;" width="60px" align="center">Status</th>
                  <!-- Newly added on 09-02-2024 -->
                  <th style="text-align:center;" width="70px" align="center">Action</th>
               </tr>
            </tbody>
         </table>
         <br><br>
         <table class="borderlesstab" id="GREtab2" align="center">
            <tbody>
               <tr>
                  <td width="180px">New Instance Name</td>
                  <td><input type="text" class="text" id="nwinstname" name="nwinstname" maxlength="32" onkeypress="return avoidSpace(event) && avoidEnter(event)" onmouseover="setTitle(this)" onfocusout="isEmpty('nwinstname','Instance Name')"></td>
                  <!-- <td colspan="2"><input type="button" class="button1" id="add" value="Add" onclick="addgreeditpage('nwinstname', true)"></td> -->
                  <td colspan="2"><input type="button" class="button1" id="add" value="Add" onclick="checkExcludeAndProceed('nwinstname','<%=slnumber%>','<%=version%>')"></td>
               </tr>
               <tr style="background-color: white;">
                  <td colspan="2">
                      <p style="font-size:11px; font-family: verdana; margin-left:80px;">
                          <span style="color:red;text-align:left;">
                              <b>Note:</b>
                          </span>
                          Special Characters are not allowed 
                      </p>
                  </td>
              </tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" name="Apply" value="Apply" class="button"></div>
      </form>
      <%
	    int i=0;
		Iterator<String> keys =nwobj.keys();
		
	    while(keys.hasNext())
		{
			String ckey = keys.next();
			if(ckey.contains("interface:")){
			JSONObject obj = nwobj.getJSONObject(ckey);
			boolean protoval=obj.containsKey("srcif")?obj.getString("proto").equals("gre")?true:false:false;
			if(protoval){
			String grename = ckey.replace("interface:","");
			String act = "";
			String sts = "";
			if(obj.containsKey("enabled")){
				act = obj.getString("enabled");
				act=act.equals("1")?"checked":"";
				if(act.equals("checked"))
				{
					String tunnelname=obj.getString("tunnel");
					JSONObject tunnelobj=nwobj.getJSONObject("interface:"+tunnelname);
					String connval=tunnelobj.containsKey("connected")?tunnelobj.getString("connected"):"";
					sts=connval.equals("1")?"1":"0";
				}
				else
					sts="";
			}
			%>
			<script>
			addRow('GREtab1',false,'<%=slnumber%>','<%=version%>');
			fillrow('<%=i+1%>','<%=grename%>','<%=act%>','<%=sts%>');
			</script>
			<%	
			i++;
			}
			}
		}
	  %>
   </body>
</html>
