<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject sms_configobj = null;
   BufferedReader jsonfile = null;   
   JSONArray smsathnumarr = null;
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
   		
   		//System.out.print(wizjsonnode);
   		sms_configobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("SMSCONFIG");
   		smsathnumarr = sms_configobj.getJSONArray("SmsAuthNum")==null ? new JSONArray():sms_configobj.getJSONArray("SmsAuthNum");
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
	width: 560px;
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

</style>
 <script type = "text/javascript"> function IPv4AddressKeyOnly(e) {
	var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
	if ((keyCode == 43 || keyCode == 46 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode >= 48 && keyCode <= 57)) {
		return true;
	}
	return false;
}
function showErrorMsg(errormsg)
{
	alert(errormsg);
}
 </script>
   </head>
   <body>
      <form action="savepage.jsp?page=smsconfig&slnumber=<%=slnumber%>" method="post">
         <p align="center" class="style1">SMS Configuration</p>
         <table align="center" id="WiZConf">
            <tbody>
               <tr>
                  <th align="center" width="120px">Parameters</th>
                  <th colspan="2" align="center" style="text-align:center;">Values</th>
               </tr>
               <tr>
                  <td width="200px">Source Mobile Number 1</td>
                  <td align="center" style="text-align:center;" onkeypress="return IPv4AddressKeyOnly(event)"><%=smsathnumarr.size() > 0 ?smsathnumarr.getString(0):""%></td>
                  <td width="160px"><input type="text" class="text" max="12" id="Srcmn1" name="Srcmn1" maxlength="13" value="<%=smsathnumarr.size() > 0 ?smsathnumarr.getString(0):""%>" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td width="200px">Source Mobile Number 2</td>
                  <td align="center" style="text-align:center;" onkeypress="return IPv4AddressKeyOnly(event)"><%=smsathnumarr.size() > 1 ?smsathnumarr.getString(1):""%></td>
                  <td width="160px"><input type="text" class="text" max="12" id="Srcmn2" name="Srcmn2" maxlength="13" value="<%=smsathnumarr.size() > 1 ?smsathnumarr.getString(1):""%>" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td width="200px">Source Mobile Number 3</td>
                  <td align="center" style="text-align:center;"><%=smsathnumarr.size() > 2 ?smsathnumarr.getString(2):""%></td>
                  <td width="160px"><input type="text" class="text" max="12" id="Srcmn3" name="Srcmn3" maxlength="13" value="<%=smsathnumarr.size() > 2 ?smsathnumarr.getString(2):""%>" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td width="200px">SIM1 Message Center Number</td>
                  <td align="center" style="text-align:center;"><%=sms_configobj == null?"":sms_configobj.get("Sim1CntrNum")==null?"":sms_configobj.getString("Sim1CntrNum")%></td>
                  <td width="160px"><input type="text" class="text" max="12" id="Sim1cmn" name="Sim1cmn" maxlength="13" value="<%=sms_configobj == null?"":sms_configobj.get("Sim1CntrNum")==null?"":sms_configobj.getString("Sim1CntrNum")%>" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
               <tr>
                  <td widtd="200px">SIM2 Message Center Number</td>
                  <td align="center" style="text-align:center;"><%=sms_configobj == null?"":sms_configobj.get("Sim2CntrNum")==null?"":sms_configobj.getString("Sim2CntrNum")%></td>
                  <td width="160px"><input type="text" class="text" max="12" maxlength="13" id="Sim2cmn" name="Sim2cmn" value="<%=sms_configobj == null?"":sms_configobj.get("Sim2CntrNum")==null?"":sms_configobj.getString("Sim2CntrNum")%>" onkeypress="return IPv4AddressKeyOnly(event)"></td>
               </tr>
            </tbody>
         </table>
         <div align="center"><input type="submit" value="Submit" class="button"></div>
      </form>
      <%if(errorstr != null && errorstr.trim().length() > 0)
			{%>
		     <script>
			 showErrorMsg('<%=errorstr%>');
			 </script>
		<%}
		%>
   </body>
</html>