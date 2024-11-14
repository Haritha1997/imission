
<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.util.Hashtable"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

<%
   JSONObject wizjsonnode = null;
   BufferedReader jsonfile = null;   
   String slnumber=request.getParameter("slnumber");
   String errorstr = request.getParameter("error");
   String fmversion=request.getParameter("version");
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
	  #WiZConf {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 550px;
}

#WiZConf td,
#WiZConf th {
	border: 2px solid #ddd;
	padding: 8px;
}

#WiZConf tr:nth-child(even) {
	background-color: #f2f2f2;
}

#WiZConf tr:hover {
	background-color: #d3f2ef;
}

#WiZConf th {
	padding-top: 12px;
	padding-bottom: 12px;
	text-align: left;
	background-color: #5798B4;
	color: white;
}

.text {
	background: white;
	border: 2px Solid #DDD;
	border-radius: 5px;
	box-shadow: 1 1 5px #DDD inset;
	color: #000;
	height: 20px;
	width: 120px;
}

.button {
	display: block;
	border-radius: 6px;
	background-color: #6caee0;
	color: #ffffff;
	font-weight: bold;
	box-shadow: 1px 2px 4px 0 rgba(0, 0, 0, 0.08);
	padding: 12px 20px;
	border: 0;
	margin: 40px 183px 0;
}

.style1 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	color: #5798B4;
	font-size: 16px;
	font-weight: bold;
}

body {
	background-color: #FAFCFD;
}

#bordereddiv {
	border-style: groove;
	height: 120px;
	width: 300px;
	margin-left: 35%;
	align: center;
	padding-top: 3%;
}
	  </style>
      <script type="text/javascript">
function openInFrame(url) {
	top.frames['WelcomeFrame'].location.href = url;
}

function ipsecconfig(slnumber) {
	var ele = document.getElementsByName('ipsecselect');
	var temp = "";
	var url;
	var count = 0;
	for (i = 0; i < ele.length; i++) {
		if (ele[i].checked) {
			count = count + 1;
			temp = ele[i].value;
			if(temp == "multitunnel")
				url = "ipsec_multi.jsp?slnumber="+slnumber;
			else
				url = "ipsec_autofb.jsp?slnumber="+slnumber;
			openInFrame(url);
			break;
		}
	}
	if (count == 0) {
		alert("Please Select any Option ")
	}
}
function showErrorMsg(errormsg)
{
	alert(errormsg);
}
	  </script> 
	  <script src="js/timeout.js" type="text/javascript"></script>
   </head> 
      <% 
        JSONObject ipsecobj = wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("IPCONFIG").
                getJSONObject("IPSECCONFIG").getJSONObject("IPSEC");
        String ipconftype = ipsecobj.getString("IpsecSelectNo");
        JSONArray tunarr = ipsecobj.getJSONObject("TABLE").getJSONArray("arr");
        int tuncnt = tunarr.size();
            		ipconftype = ipconftype==null?"":ipconftype;
            		String url="";
            		if(ipconftype.equalsIgnoreCase("IPSec MultiTunnel") && tuncnt > 0)
            		{												
            			url = "ipsec_multi.jsp?slnumber="+slnumber+"&version="+fmversion;
            		}
            		else if(ipconftype.equalsIgnoreCase("IPSec Autofallback") && tuncnt > 0)
            		{
            			url = "ipsec_autofb.jsp?slnumber="+slnumber+"&version="+fmversion;
            		}
					if(errorstr != null && tuncnt > 0)
						url += "&error="+errorstr;
						
      if(url.length()>0 && tuncnt > 0){%>	
      <script type="text/javascript">
      openInFrame('<%=url%>');
      </script> 
     <%}
	 
	 else {%>
	 <body>
      <div>
         <form method="post" action="savepage.jsp?page=ipsec_select&slnumber=<%=slnumber%>">
            <br>
            <p align="center" class="style1">IPSec Configuration</p>
            <br><br> 
            <div align="center" id="bordereddiv"><input type="radio" id="multitunnel" name="ipsecselect" value="IPSec MultiTunnel"><label for="multitunnel">IPSec MultiTunnel</label><br>  <input type="radio" id="autofallback" name="ipsecselect" value="IPSec Autofallback"><label for="autofallback">IPSec Autofallback</label><br> </div>
            <div align="center"><input type="submit" value="Submit" class="button"></div>
         </form>
		 <%if(errorstr != null && errorstr.trim().length() > 0)
		 {%>
			 <script>
			 showErrorMsg('<%=errorstr%>');
			 </script>
		 <%}
		 %>
      </div>
   </body>
	 <%}%>
</html>