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
   JSONObject systemobj=null;
   JSONObject rebootinfoobj = null;
   JSONObject  rebsecweekobj = null;
   JSONObject rebsecmonobj=null;
   BufferedReader jsonfile = null;   
   String slnumber=request.getParameter("slnumber");
   String errorstr = request.getParameter("error");
   String minutes ="";
   String hours="";
   String month="";
   String monthminutes ="";
   String monthhours="";
   String  date="";
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
		systemobj=wizjsonnode.getJSONObject("system");
		rebootinfoobj = systemobj.containsKey("reboot:info")?systemobj.getJSONObject("reboot:info"):new JSONObject();
		rebsecweekobj = systemobj.containsKey("sch_rebt:Weekly")?systemobj.getJSONObject("sch_rebt:Weekly"):new JSONObject();
		rebsecmonobj =systemobj.containsKey("sch_rebt:Monthly")?systemobj.getJSONObject("sch_rebt:Monthly"):new JSONObject();
		
  } catch(Exception e)
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
      <meta http-equiv="pragma" content="no-cache">
      <link rel="stylesheet" href="css/fontawesome.css">
      <link rel="stylesheet" href="css/solid.css">
      <link rel="stylesheet" href="css/v4-shims.css">
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <style type="text/css">
table{
		padding-left:10px;
	  }
	  tr,td{
		border:none;
	  }
	  td{
	  width:300px;
	  
	  }
	  label,checkbox
	  {
		margin-left:10px;
	  }
	  div
	  {
		align:center;
	  }
	  </style>
	  <script type="text/javascript">
	  var curdiv = "";
	  var checkarr=["sun_box","mon_box","tue_box","wed_box","thu_box","fri_box","sat_box"];
		function selectAll()
		{
			
			for(var i=0;i<checkarr.length;i++)
				document.getElementById(checkarr[i]).checked=true;
			
		}
		function unSelectAll()
		{
			for(var i=0;i<checkarr.length;i++)
				document.getElementById(checkarr[i]).checked=false;
		}
		function addMins(id)
		{
			var selobj = document.getElementById(id);
			if(id=="week_mins" || id=='month_mins')
			{
				var option = document.createElement("option");
				option.text = "";
				option.value ="";
				selobj.add(option);
			}
			
			for(var i=0;i<60;i++)
			{
			 
				var option = document.createElement("option");
				if(i<10)
				{
					option.text = "0"+i;
					option.value = "0"+i;
				}
				else
				{
					option.text = i;
					option.value =i;
				}
				selobj.add(option);
			}
		}
		function addHrs(id)
		{
			var selobj = document.getElementById(id);
			if(id == "week_hrs" || id=='month_hrs')
			{
			var option = document.createElement("option");
			option.text = "";
			option.value ="";
			selobj.add(option);
			}
			for(var i=0;i<24;i++)
			{
			 
				var option = document.createElement("option");
				if(i<10)
				{
					option.text = "0"+i;
					option.value = "0"+i;
				}
				else
				{
					option.text = i;
					option.value =i;
				}
				selobj.add(option);
			}
		}
		function addMonths(id)
		{
			var selobj = document.getElementById(id);
			var option = document.createElement("option");
			option.text = "";
			option.value ="";
			selobj.add(option);
			for(var i=1;i<13;i++)
			{			 
				var option = document.createElement("option");
				if(i<10)
				{
					option.text = "0"+i;
					option.value = "0"+i;
				}
				else
				{
					option.text = i;
					option.value =i;
				}
				selobj.add(option);
			}
		}
		function setDates(id,monthid)
		{ 
			var dateobj = document.getElementById(id);
			var i, L = dateobj.options.length - 1;
		   for(i = L; i >= 0; i--) {
			  dateobj.remove(i);
		   }
			/* var month = document.getElementById(monthid).value;
			var range = 30;
			if(month == 2)
				range = 29;
			else if(month==1 || month==3 || month==5 || month==7 || month==8 || month==10 || month==12)
				range = 31; */
			
			var option = document.createElement("option");
			option.text = "";
			option.value ="";
			dateobj.add(option);
			for(var i=1;i<=range;i++)
			{
			 
				var option = document.createElement("option");
				if(i<10)
				{
					option.text = "0"+i;
					option.value = "0"+i;
				}
				else
				{
					option.text = i;
					option.value =i;
				}
				dateobj.add(option);
			}
		}
		function hideFields()
		{
			var seleobj=document.getElementById("schdle_type");
			var week_table=document.getElementById("week_table");
			var month_table=document.getElementById("month_table");
			if(seleobj.value=="Monthly")
			{
				month_table.style.display="";
				week_table.style.display="none";
			}
			else
			{
				month_table.style.display="none";
				week_table.style.display="";
			}
		}
		function hideSchRebtFields()
		{
			var enableobj = document.getElementById("sch_actrebt");
			var sch_div = document.getElementById("sch_div");
			if(enableobj.checked)
				sch_div.style.display="";		
			else
				sch_div.style.display="none";
			hideFields();
		}
		function setHrs(id,hours)
		{
			document.getElementById(id).value = hours;
		}
		function setMins(id,mins)
		{
			document.getElementById(id).value = mins;
		}
		function setMonth(id,months)
		{
			document.getElementById(id).value = months;
		}
		function setDate(id,date)
		{
			document.getElementById(id).value = date;
		}
		function validateReboot()
		{
		   var altmsg = "";
		   var sch_type = document.getElementById("schdle_type").value;
			/* if( document.getElementById("sch_actrebt").checked == false)
				altmsg += "Please enable scheduled reboot \n"; */
		   if(sch_type == "Weekly")
		   {
				if(document.getElementById("sch_actrebt").checked)
				{
				var any_day_chked = false;
				for(var i=0;i<checkarr.length;i++)
				{
					if(document.getElementById(checkarr[i]).checked)
					{
						any_day_chked = true;
						break;
					}
						
				}
				if(!any_day_chked)
					altmsg +="please select any one day of the week\n";
				
				var hrobj = document.getElementById("week_hrs");
				var minsobj = document.getElementById("week_mins");
				if(hrobj.value=="" && minsobj.value == "") {
					altmsg += "Hours should not be empty\n"
					altmsg += "Minutes should not be empty\n";
				}
				else if(hrobj.value !="")
				{
					if(minsobj.value == "")
						altmsg += "Minutes should not be empty\n";
				}
				else if(minsobj.value !="")
				{
					if(hrobj.value == "")
						altmsg += "Hours should not be empty\n";
				}
			}
		   }
		   else if(sch_type == "Monthly")
		   {
				//var monthobj = document.getElementById("months");
				var dateobj = document.getElementById("date");
				var hrobj = document.getElementById("month_hrs");
				var minsobj = document.getElementById("month_mins");
				//if(monthobj.value == "" && dateobj.value == "" && hrobj.value == "" && minsobj.value == "") {
				if(document.getElementById("sch_actrebt").checked)
				{
					if(dateobj.value == "" && hrobj.value == "" && minsobj.value == "") {
						//altmsg += "Months should not be empty\n";
						altmsg += "Date should not be empty\n";
						altmsg += "Hours should not be empty\n";
						altmsg += "Minutes should not be empty\n";
					}
					/* else if(monthobj.value != "")
					{
						if(dateobj.value == "")
							altmsg += "Date should not be empty\n";
						if(hrobj.value == "")
							altmsg += "Hours should not be empty\n";
						if(minsobj.value == "")
							altmsg += "Minutes should not be empty\n";
					} */
					else if(dateobj.value !="")
					{
						if(hrobj.value == "")
							altmsg += "Hours should not be empty\n";
						if(minsobj.value == "")
							altmsg += "Minutes should not be empty\n";
					}
					else if(hrobj.value !="")
					{
	
						if(dateobj.value == "")
							altmsg += "Date should not be empty\n";
						if(minsobj.value == "")
							altmsg += "Minutes should not be empty\n";
					}
					else if(minsobj.value !="")
					{
	
						if(dateobj.value == "")
							altmsg += "Date should not be empty\n";
						if(hrobj.value == "")
							altmsg += "Hours should not be empty\n";
					}
				
		   		}
			}
		   if (altmsg.trim().length == 0) return true;
		   else {
			  alert(altmsg);
			  return false;
			}
			
		}
		
	  </script>
   </head>
   <% String  secreb="";  %>
   <body>
      <form action="savedetails.jsp?page=reboot&slnumber=<%=slnumber%>" method="post" onsubmit="return validateReboot()">
      	<p class="style5" id="title" align="center">Schedule Reboot</p>
		<br/>
		<br/>
		<table width="600px" class="borderlesstab">
               <tbody>
			   <tr>
                    <th width="200px">Parameters</th>
                    <th width="200px">Configuration</th>
                     </tr>
				<!--  <tr>
                    <td >Reboot Now</td>
                    <td ><label class="switch" style="vertical-align:middle"><input type="checkbox" name="rebt_now" id="rebt_now" style="vertical-align:middle"><span class="slider round"></span></label></td>
                </tr> -->
				<tr>
				
				<%if(rebootinfoobj.containsKey("sch_rebt"))
						secreb = rebootinfoobj.getString("sch_rebt").equals("1")?"checked":""; %>
					<td >Scheduled Reboot</td>

					<td ><label class="switch" style="vertical-align:middle"><input type="checkbox" name="sch_actrebt" id="sch_actrebt" style="vertical-align:middle"  onclick="hideSchRebtFields()" <%=secreb%>><span class="slider round"></span></label></td>
				</tr>	
				</table>
				<br/><br/>
				<div id="sch_div" align="center"  style="margin:auto; padding: 10px;border: 1px solid black;width:400px;">
				<table width="600px"  class="borderlesstab" align="center" style="margin:0px;padding:0px">
				<% String sectype =rebootinfoobj!=null? (!rebootinfoobj.containsKey("schdle_type")?"":rebootinfoobj.getString("schdle_type")):""; 
                        %>
				<tr>  <!-- Modified this line  -->
                    <td width="300px">Schedule Type</td>
                    <td width="300px">
                    <select class="text" id="schdle_type" name="schdle_type" onchange="hideFields()">
                   <!--  <option value=""></option>-->
                        <option value="Monthly" <%if(sectype.equals("Monthly")){%>selected<%} %>>Monthly</option>
                        <option value="Weekly" <%if(sectype.equals("Weekly")){%>selected<%} %>>Weekly</option>
                    </select>
                    </td>
                </tr>
				</table>
				<table width="600px" align="center" class="borderlesstab" id="week_table" style="margin:0px;padding:0px">
               <tbody>
			   <tr>
			   
				<td><p id="title" >Day of the week</p></td>
				
				</tr>
				<tr>
				<%secreb="";if(rebsecweekobj.containsKey("sunday"))
					secreb = rebsecweekobj.getString("sunday").equals("1")?"checked":""; %>
				<td colspan="2"><input type="checkbox" id="sun_box"  name="sun_box" <%=secreb%> /><label>Sunday</label></td>
				</tr>
				<tr>
				<%secreb="";if(rebsecweekobj.containsKey("monday"))
					secreb = rebsecweekobj.getString("monday").equals("1")?"checked":""; %>
				<td colspan="2"><input type="checkbox" id="mon_box" name="mon_box" <%=secreb%> /><label>Monday</label></td>
				</tr>
				<tr>
				<%secreb="";if(rebsecweekobj.containsKey("tuesday"))
					secreb = rebsecweekobj.getString("tuesday").equals("1")?"checked":""; %>
				<td  ><input type="checkbox" id="tue_box" name="tue_box" <%=secreb%>/><label>Tuesday</label></td>
				<td><input type="button" id="all_btn" value="ALL" style="width:80px;height:20px;cursor:pointer" onclick="selectAll()"/></td>
				</tr>
				<tr>
				<%secreb="";if(rebsecweekobj.containsKey("wednesday"))
					secreb = rebsecweekobj.getString("wednesday").equals("1")?"checked":""; %>
				<td  ><input type="checkbox" id="wed_box" name="wed_box" <%=secreb%> /><label>Wednesday</label></td>
				<td ><input type="button"  id="none_btn" value="NONE" style="width:80px;height:20px;cursor:pointer" onclick="unSelectAll()"/></td>
				</tr>
				<tr>
				<%secreb="";if(rebsecweekobj.containsKey("thursday"))
					secreb = rebsecweekobj.getString("thursday").equals("1")?"checked":""; %>
				<td  colspan="2"><input type="checkbox" id="thu_box" name="thu_box" <%=secreb%>/><label>Thursday</label></td>
				</tr>
				<tr>
				<%secreb="";if(rebsecweekobj.containsKey("friday"))
					secreb = rebsecweekobj.getString("friday").equals("1")?"checked":""; %>
				<td colspan="2"><input type="checkbox" id="fri_box" name="fri_box" <%=secreb%> /><label>Friday</label></td>
				</tr>
				<tr>
				<%secreb="";if(rebsecweekobj.containsKey("saturday"))
					secreb = rebsecweekobj.getString("saturday").equals("1")?"checked":""; %>
				<td colspan="2"><input type="checkbox" id="sat_box" name="sat_box" <%=secreb%> /><label>Saturday</label></td>
				</tr>
				<tr>
				<% 
				hours =rebsecweekobj!=null? (!rebsecweekobj.containsKey("hours")?"":rebsecweekobj.getString("hours")):""; %>
				<td><label>Hours</label></td>
				<td><select class="text" id="week_hrs" name="week_hrs" value="<%=hours%>">
                    </select></td>
				</tr>
				<tr>
				<% minutes =rebsecweekobj!=null? (!rebsecweekobj.containsKey("minutes")?"":rebsecweekobj.getString("minutes")):""; %>
				<td><label>Minutes</label></td>
				<td><select class="text" id="week_mins" name="week_mins" value="<%=minutes%>" >
                    </select></td>
				</tr>
				</table>
				<table width="600px" class="borderlesstab" id="month_table" align="center">
               <tbody>
					<%-- <tr>
					<% month =rebsecmonobj!=null? (!rebsecmonobj.containsKey("months")?"":rebsecmonobj.getString("months")):""; %>
					<td><label>Month</label></td>
					<td><select class="text" id="months" name="months" onchange="setDates('date','months');" value="<%=month%>">
                    </select></td>
					</tr> --%>
					<tr>
					<%if(rebsecmonobj!=null)
						date = rebsecmonobj.containsKey("date")?rebsecmonobj.getString("date"):"";
					%>
					<td><label>Date</label></td>
					<td><select class="text" id="date" name="date" value="<%=date%>">
					<option value="1" >1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5" >5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<option value="10">10</option>
					<option value="11">11</option>
					<option value="12">12</option>
					<option value="13">13</option>
					<option value="14">14</option>
					<option value="15">15</option>
					<option value="16">16</option>
					<option value="17">17</option>
					<option value="18">18</option>
					<option value="19">19</option>
					<option value="20">20</option>
					<option value="21">21</option>
					<option value="22">22</option>
					<option value="23">23</option>
					<option value="24">24</option>
					<option value="25">25</option>
					<option value="26">26</option>
					<option value="27">27</option>
					<option value="28">28</option>
                    </select></td>
					</tr>
					<tr>
					<% monthhours =rebsecmonobj!=null? (!rebsecmonobj.containsKey("hours")?"":rebsecmonobj.getString("hours")):""; %>
					<td><label>Hours</label></td>
					<td><select class="text" id="month_hrs" name="month_hrs" value="<%=monthhours%>"></select></td></td>
					</tr>
					<tr>
					<% monthminutes =rebsecmonobj!=null? (!rebsecmonobj.containsKey("minutes")?"":rebsecmonobj.getString("minutes")):""; %>
					<td><label>Minutes</label></td>
					<td><select class="text" id="month_mins" name="month_mins" value="<%=monthminutes%>"></select></td> 
					</tr>
				</tbody>
				</table>
				</div>
				<br/>
				<div align="center"><input class="button" type="submit" id="Apply" value="Apply" style="display:inline block"></div>
		
      </form>
      <script type="text/javascript">
      addMins('week_mins');
	  addMins('month_mins');
	  addHrs('month_hrs');
	  addHrs('week_hrs');
	  setHrs("week_hrs","<%=hours%>");
	  setMins("week_mins","<%=minutes%>"); 

	  
	  <%--  setMonth("months","<%=month%>"); --%>
	  setHrs("month_hrs","<%=monthhours%>");
	  setMins("month_mins","<%=monthminutes%>"); 
	  
	  //setDates('date','months');
	  setDate("date","<%=date%>"); 
	  hideFields();
	  hideSchRebtFields();
      </script>
   </body>
</html>