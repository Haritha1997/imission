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
		JSONObject stswizjsonnode = null;
		 JSONObject stspageaccessobj = null;
		 JSONObject wizjsonnode = null;
		 JSONObject wifilessobj = null;
		 JSONObject wifidevobj=null;
		 JSONArray wifiobj=null;
		 JSONObject wifijsobj=null;
		 JSONObject mwifiobj=null;
		 String name=null;
		 String displaywifi="False";
		 BufferedReader jsonfile = null;  
		 BufferedReader stsjsonfile = null;  
		   boolean enabled = false;
		   if(slnumber != null && slnumber.trim().length() > 0)
		   {
			   Properties m2mprops = M2MProperties.getM2MProperties();
			   String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
			   jsonfile = new BufferedReader(new FileReader(new File(slnumpath+File.separator+"Config.json")));
			   stsjsonfile = new BufferedReader(new FileReader(new File(slnumpath+File.separator+"Status.json")));
			   StringBuilder jsonbuf = new StringBuilder("");
			   StringBuilder stsjsonbuf = new StringBuilder("");
			   String jsonString="";
			   String stsjsonString="";
			   try
			   {
					while((jsonString = jsonfile.readLine())!= null)
		   			jsonbuf.append( jsonString );
					while((stsjsonString = stsjsonfile.readLine())!= null)
						stsjsonbuf.append( stsjsonString );
					stswizjsonnode= JSONObject.fromObject(stsjsonbuf.toString());
					stspageaccessobj=stswizjsonnode.containsKey("PAGE_ACCESS")?stswizjsonnode.getJSONObject("PAGE_ACCESS"):new JSONObject();
					displaywifi=stspageaccessobj.containsKey("WIFI")?stspageaccessobj.getString("WIFI"):"False";
					wizjsonnode= JSONObject.fromObject(jsonbuf.toString());
					wifijsobj=wizjsonnode.containsKey("wireless")?wizjsonnode.getJSONObject("wireless"):new JSONObject();
					wifidevobj=wifijsobj.containsKey("wifi-device:radio0")?wifijsobj.getJSONObject("wifi-device:radio0"):new JSONObject();
					wifiobj=wifijsobj.containsKey("wifi-iface")?wifijsobj.getJSONArray("wifi-iface"):new JSONArray();
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
			   }
			   finally
			   {
				   if(jsonfile != null)
					   jsonfile.close();
				   if(stsjsonfile!=null)
					   stsjsonfile.close();
			   }
		   }
if(displaywifi.equals("True")){%>
<html>
   <head>
   <title>WiFi Configuration</title>
   <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
      <link rel="stylesheet" href="css/fontawesome.css">
      <!--<link rel="stylesheet" href="css/fontawesome.css">-->
      <link rel="stylesheet" href="css/solid.css">
      <!--<link rel="stylesheet" href="css/v4-shims.css">-->
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <script type="text/javascript" src="js/common.js"></script>
	  <script type="text/javascript" src="js/wificonfig.js"></script>
	  <style type="text/css">
	   .caret {
	position: absolute;
	left: 90%;
	top: 40%;
	vertical-align: middle;
	border-top: 6px solid;
}

#act_icon {
	padding-right: 10;
	color: #7B68EE;
	cursor: pointer;
}

#new_icon {
	padding-right: 10;
	color: green;
	cursor: pointer;
}

html {
	overflow-y: scroll;
}

.multiselect-container {
	width: 100% !important;
}

button.multiselect {
	height: 25px;
	margin: 0;
	padding: 0;
}

.multiselect-container>.active>a,
.multiselect-container>.active>a:hover,
.multiselect-container>.active>a:focus {
	background-color: grey;
	width: 100%;
}

.multiselect-container>li.active>a>label,
.multiselect-container>li.active>a:hover>label,
.multiselect-container>li.active>a:focus>label {
	color: #ffffff;
	width: 100%;
	white-space: normal;
}

.multiselect-container>li>a>label {
	font-size: 12.5px;
	text-align: left;
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	padding-left: 25px;
	white-space: normal;
}

a,
a:hover {
	color: black;
	text-decoration: none;
}
p{
padding:10px;
}


	  </style>
	  <script type="text/javascript">
     function checkAlphaNUmeric(id,slnumber,version)
	  {
	      var val = document.getElementById(id).value.trim();
		  if(!isValidAlphaNumberic(id) && val.length != 0)
		  {
			  alert("Please Use Only AlphaNumeric");
			  
			  return;
		  }
		  addwifieditpage(id,true,slnumber,'<%=version%>');
	  }
      </script>
	</head>
   <body>
      <div align="center">
	   <p class="style5" align="center">WiFi Configuration</p>
	  <form action="savedetails.jsp?page=wificonfig&slnumber=<%=slnumber%>&version=<%=version%>" method="post" action="url" onsubmit=""> 
	    <input type="text" id="slno" value="<%=slnumber%>" hidden />
	  <table class="borderlesstab" style="width:600px;margin-bottom:0px;margin-bottom:0px;" id="wificonfig" align="center"><input type="text" id="wificnt" name="wificnt" value="1" hidden="">
                  <tbody>
                     <tr>
                        <th style="text-align:center;" width="30px" align="center">S.No</th>
                        <th style="text-align:center;" width="10px" align="center">SSID</th>
                        <th style="text-align:center;" width="90px" align="center">Activation</th>
						<th style="text-align:center;" width="10px" align="center">Action</th>
                     </tr>
                  </tbody>
               </table>
			   <br>
		<table class="borderlesstab" id="wificonfigid" align="center">
            <tbody>
               <tr align="center">
                  <td>SSID</td>
                  <td width="100px"><input type="text" class="text" id="ssid" name="ssid" maxlength="32" onkeypress="return avoidSpace(event) && avoidEnter(event)" onfocusout="isEmpty('ssid','SSID')"></td>
                  <td><input type="button" class="button1" id="add" value="Add"  onclick="checkAlphaNUmeric('ssid','<%=slnumber%>','<%=version%>')"></td>
               </tr>
               <br>
            </tbody>
			</table>
			<div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"></div>	
</form> 
</div>
	 <%
	  int i=0;
		Iterator<String> wifiopt =wifijsobj.keys();
	    while(wifiopt.hasNext())
		{
			String strwifiopt = wifiopt.next();
			if(strwifiopt.contains("wifi-device:radio0")){
				JSONObject wifi_obj = wifijsobj.getJSONObject(strwifiopt);
			if(!wifiobj.isEmpty())
			{
				JSONObject wifiint_obj = (JSONObject)wifiobj.getJSONObject(i);
			String act =wifi_obj.containsKey("disabled")?wifi_obj.getString("disabled").equals("0")?"checked":"":"";
			String instname = wifiint_obj.containsKey("ssid")? wifiint_obj.getString("ssid"):"";
			%>
			<script>
			addRow('wificonfig',false,'<%=slnumber%>','<%=version%>');
			fillrow('<%=i+1%>','<%=instname%>','<%=act%>');
			</script>
			<%	
			i++;
			}}
		}
	    %>
</body>

</html>	
	<%} else{%>
	<!DOCTYPE html>
	<html>
	<body>
	<%response.sendRedirect("/imission/m2m/errormsg.jsp");
   } %>				 