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
   JSONObject systemobj = null;
   JSONObject systempage = null;
   JSONArray systemarr = null;
   BufferedReader jsonfile = null;  
   String hostname = "";
   String timefrmt = "";
   String timezone = "";
	
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
   		
			systemobj =  wizjsonnode.getJSONObject("system");
			systemarr = systemobj.getJSONArray("system")==null ? new JSONArray(): systemobj.getJSONArray("system");	
			systempage = systemarr.get(0)==null ? new JSONObject(): (JSONObject)systemarr.get(0);
			
			hostname = systempage.getString("hostname")==null? "":systempage.getString("hostname");
			timefrmt = systempage.getString("timeformat")==null? "":systempage.getString("timeformat");
			timezone = systempage.getString("zonename")==null? "":systempage.getString("zonename");
			
			if(systempage.containsKey("timeformat"))
			timefrmt = systempage.getString("timeformat");
		
			if(systempage.containsKey("zonename"))
			timezone = systempage.getString("zonename");
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
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <!-- <link rel="stylesheet" type="text/css" href="css/timepicker/bootstrap.min.css">
      <link rel="stylesheet" type="text/css" href="css/timepicker/bootstrap-datetimepicker.min.css"> -->
      <script type="text/javascript" src="js/common.js"></script>
      <!-- <script type="text/javascript" src="js/timepicker/jquery.min.js"></script>
	  <script type="text/javascript" src="js/timepicker/bootstrap.min.js"></script>
	  <script type="text/javascript" src="js/timepicker/moment-with-locales.min.js"></script>
	  <script type="text/javascript" src="js/timepicker/bootstrap-datetimepicker.min.js"></script> -->
	  <script type="text/javascript">
	/*  $(function () {
	$('#sdate').datetimepicker({
		pickTime: false,
		format: "DD/MM/YYYY"
	});
});
$(function () {
	var tfmt = document.getElementById("tformat").value;
	if (tfmt == "12") {
		$('#stime').datetimepicker({
			pickDate: false,
			timeFormat: 'HH:mm:ss A',
			useSeconds: true
		});
	} else {
		$('#stime').datetimepicker({
			pickDate: false,
			format: 'H:m:s',
			pick12HourFormat: false,
			useSeconds: true
		});
	}
});

function setSystemDateAndTime() {
	var today = new Date();
	var dd = String(today.getDate()).padStart(2, '0');
	var mm = String(today.getMonth() + 1).padStart(2, '0');
	var yyyy = today.getFullYear();
	var hours = today.getHours() + "";
	var minutes = today.getMinutes() + "";
	var seconds = today.getSeconds() + "";
	if (hours.legth == 1) hours = '0' + hours;
	if (minutes.length == 1) minutes = '0' + minutes;
	if (seconds.length == 1) seconds = '0' + seconds;
	var tfmt = document.getElementById("tformat").value;
	if (tfmt == "12") {
		var amorpm = "AM";
		if (hours > 12) {
			hours = hours - 12;
			amorpm = "PM";
		}
		var time = hours + ":" + minutes + ":" + seconds + " " + amorpm;
	} else {
		var time = hours + ":" + minutes + ":" + seconds
	}
	today = dd + '/' + mm + '/' + yyyy;
	document.getElementById("sdate").value = today;
	document.getElementById("stime").value = time;
}

function setTimeformat() {
	var stime = document.getElementById("stime").value;
	var tfmt = document.getElementById("tformat").value;
	if (tfmt == "12") {
		var arr = stime.split(':');
		var hours = $.trim(arr[0]);
		var minutes = $.trim(arr[1]);
		var seconds = $.trim(arr[2]);
		var amorpm = "AM";
		if (hours > 12) {
			hours = parseInt(hours) - 12;
			amorpm = "PM";
		}
		$('#stime').data("DateTimePicker").destroy();
		$('#stime').datetimepicker({
			pickDate: false,
			timeFormat: 'HH:mm:ss A',
			useSeconds: true
		});
		var time = hours + ":" + minutes + ":" + seconds + " " + amorpm;
		document.getElementById("stime").value = time;
	} else {
		var arr = stime.split(' ');
		var time = $.trim(arr[0]);
		var amorpm = $.trim(arr[1]);
		arr = time.split(':');
		var hours = $.trim(arr[0]);
		var minutes = $.trim(arr[1]);
		var seconds = $.trim(arr[2]);
		if (amorpm == "PM") {
			hours = parseInt(hours) + 12;
		}
		time = hours + ":" + minutes + ":" + seconds;
		document.getElementById("stime").value = time;
		$('#stime').data("DateTimePicker").destroy();
		$('#stime').datetimepicker({
			pickDate: false,
			format: 'H:m:s',
			pick12HourFormat: false,
			useSeconds: true
		});
	}
}
 */
/* function donotrefresh() {
	try {
		window.stop();
	} catch (err) {}
	document.execCommand("Stop");
} */

/* function validateDate(dateString) {
	//dateString = dateString.trim();
	let dateformat = /^(0?[1-9]|[1-2][0-9]|3[0-1])[\/](0?[1-9]|1[0-2])[\/]\d{4}$/;
	//var dateFormat = /^(0?[1-9]|[12][0-9]|3[01])[\/](0?[1-9]|1[012])[\/]\d{4}$/;
	if (dateString.match(dateformat)) {
		let operator = dateString.split('/');
		let datepart = [];
		if (operator.length > 1) {
			datepart = dateString.split('/');
		}
		let day = parseInt(datepart[0]);
		let month = parseInt(datepart[1]);
		let year = parseInt(datepart[2]);
		let ListofDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		if (month == 1 || month > 2) {
			if (day > ListofDays[month - 1]) {
				return false;
			}
		} else if (month == 2) {
			let leapYear = false;
			if ((!(year % 4) && year % 100) || !(year % 400)) {
				leapYear = true;
			}
			if ((leapYear == false) && (day >= 29)) {
				return false;
			} else if ((leapYear == true) && (day > 29)) {
				return false;
			}
		}
	} else {
		return false;
	}
	return true;
}

function validateTime24Hrs(timeString) {
	let timeformat = /(?:[01]\d|2[0123]):(?:[012345]\d):(?:[012345]\d)/;
	if (timeString.match(timeformat)) {
		return true;
	} else {
		return false;
	}
}

function validateTime12Hrs(timeString) {
	let timeformat = /(1[0-2]|0?[1-9]):(?:[012345]\d):(?:[012345]\d) ?([AP][M])/;
	if (timeString.match(timeformat)) {
		return true;
	} else {
		return false;
	}
}
 */
function validateSystemConfig() {
	var altmsg = "";
	var hostname = document.getElementById("hostname");
	if (hostname.value == "") {
		altmsg += "Host name should not be Empty\n";
		hostname.style.outline = "thin solid red";
		hostname.title = "Host name should not be Empty";
	}
	else if(hostname.value.includes('\'') || hostname.value.includes('\"') || hostname.value.includes(':') || hostname.value.includes('#') || hostname.value.includes('=') || hostname.value.includes('.'))
	{
		altmsg += "Host name is invalid.. Characters ' \" = # : . are not allowed\n";
		hostname.style.outline = "thin solid red";
		hostname.title = "Host name is invalid.. Characters ' \" = # : . are not allowed";
	}
	else
	{
		hostname.style.outline = "initial";
		hostname.title = "";
	}
	if (altmsg.length == 0)
		return true;
	else
	{
		alert(altmsg);
		return false;
	}
}
		</script>
   </head>
   <body>
	<form action="savedetails.jsp?page=system&slnumber=<%=slnumber%>" id="myform" method="post" onsubmit="return validateSystemConfig()">
         <br>
         <p class="style5" align="center">Device</p>
         <br>
         <table class="borderlesstab" id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="200px">Parameters</th>
                  <th width="200px">Configuration</th>
               </tr>
               <tr>
                  <td>Host Name</td>
                  <td><input type="text" class="text" name="hostname" id="hostname" value="<%=systempage == null?"":systempage.get("hostname")==null?"":systempage.getString("hostname")%>" maxlength="32" onkeypress="return avoidSpace(event)"></td>
               </tr>
                  </tbody>
               </table>
               <div align="center"><input type="submit" name="Apply" value="Apply" style="display:inline block" class="button"></div>
        </form>
   </body>
</html>