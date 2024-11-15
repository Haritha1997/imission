<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject productobj = null;
   BufferedReader jsonfile = null; 
	String product_type = "No Change";   
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
   		productobj =  wizjsonnode.getJSONObject("SYSTEMCONTROL").getJSONObject("PRODUCTTYPE");
   		if(productobj != null)
			product_type = productobj.getString("ProductType");
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
#WiZConf 
{
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 600px;
}
#WiZConf td,
#WiZConf th {
	border: 2px solid #ddd;
	padding: 8px;
	text-align: center;
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
	text-align: center;
	background-color: #5798B4;
	color: white;
}

.text {
	background: white;
	border: 2px Solid #DDD;
	border-radius: 5px;
	box-shadow: 1 1 5px #DDD inset;
	color: #000;
	height: 17px;
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

td #borderless {
	border: none;
	padding: 0 0 0 0;
}

</style>
<script type="text/javascript">
function showErrorMsg(errormsg)
{
	alert(errormsg);
}
</script>
   </head>
   <body onload="selectComboItem()">
      <br><br>
      <form name="f1" action="savepage.jsp?page=product_type&slnumber=<%=slnumber%>" method="post">
         <p class="style1" align="center">ProductType Configuration</p>
         <br>
         <table id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="150">Parameters</th>
                  <th colspan="2" width="300">Values</th>
               </tr>
               <tr>
                  <td>Type</td>
                  <td style="width: 150px;"><%=product_type==null?"No Change":product_type%></td>
                  <td>
                     <select name="type" id="type">
                        <option value="No Change" <%if(product_type.equals("No Change")){%>selected<%}%>>No Change</option>
                        <option value="3LAN-1WAN" <%if(product_type.equals("3LAN-1WAN")){%>selected<%}%>>3LAN-1WAN</option>
                        <option value="4LAN" <%if(product_type.equals("4LAN")){%>selected<%}%>>4LAN</option>
                     </select>
                  </td>
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