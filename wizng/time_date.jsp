<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="net.sf.jasperreports.data.cache.DateStore"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject timedate_configobj = null;
   int dateint=0;
   int month=0;
   int year=0;
   int hours=0;
   int min=0;
   int sec=0;
   String date_str="";
   String time_str="";
   BufferedReader jsonfile = null;   
   		String slnumber=request.getParameter("slnumber");
		String errorstr = request.getParameter("error");
		String fwversion = request.getParameter("version");
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
   		timedate_configobj =  wizjsonnode.getJSONObject("NETWORKCONFIG").getJSONObject("TIMEDATE");
		dateint=timedate_configobj.getInt("Date");
		month=timedate_configobj.getInt("Month");
		year=timedate_configobj.getInt("Year");
		hours=timedate_configobj.getInt("Hours");
		min=timedate_configobj.getInt("Min");
		sec=timedate_configobj.getInt("Sec");
		String yearstr=(year+"").trim();
		int ylen = yearstr.length();
		if(yearstr.length()<4)
		{
			for(int i=4;i>ylen;i--)
			{
				yearstr="0"+yearstr;
			}
		}
			
		date_str=(dateint<10?"0"+dateint:dateint)+"/"+(month<10?"0"+month:month)+"/"+yearstr;
		time_str=(hours<10?"0"+hours:hours)+":"+(min<10?"0"+min:min)+":"+(sec<10?"0"+sec:sec);
		if(date_str.equals("00/00/0000"))
			date_str="";
		if(time_str.startsWith("00:00:00"))
			time_str="";
		
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
<head>
   <style type="text/css">
#WiZConf {
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
   <link rel="stylesheet" href="css/timepicker/bootstrap.min.css">
   <link rel="stylesheet" href="css/timepicker/bootstrap-datetimepicker.min.css">
   <script src="js/timepicker/jquery.min.js"></script>
   <script src="js/timepicker/bootstrap.min.js"></script>
   <script src="js/timepicker/moment-with-locales.min.js"></script>
   <script src="js/timepicker/bootstrap-datetimepicker.min.js"></script>
   <script type="text/javascript">
   $(function () {
	$('#datePicker').datetimepicker({
		pickTime: false,
		format: "DD/MM/YYYY"
	});
});
$(function () {
	$('#timePicker').datetimepicker({
		pickDate: false,
		format: 'H:m:s',
		pick12HourFormat: false ,
		useSeconds: true
	});
});
function showErrorMsg(errormsg)
{
	alert(errormsg);
} 
</script>
</head>
<body>
   <form name="f1" action="savepage.jsp?page=time_date&slnumber=<%=slnumber%>&version=<%=fwversion%>" method="post">
      <br>
      <p class="style1" align="center">Date And Time Configuration</p>
      <table id="WiZConf" align="center">
         <tbody>
            <tr>
               <th width="150">Parameters</th>
               <th colspan="2" width="300">Values</th>
            </tr>
            <tr>
               <td>DD/MM/YYYY</td>
               <td style="min-width:150px"><%=date_str%></td>
               <td><input type="text" name="datePicker" id="datePicker" class="form-control" value="<%=date_str%>" readonly></td>
            </tr>
            <tr>
               <td>HH:MM:SS</td>
               <td style="min-width:150px"><%=time_str%></td>
               <td><input type="text" name="timePicker" id="timePicker" class="form-control" value="<%=time_str%>" readonly></td>
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
   <script src="js/timeout.js" type="text/javascript"></script>
   
</body>