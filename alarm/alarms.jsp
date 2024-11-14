<%@page import="com.nomus.m2m.pojo.Organization"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.util.Properties"%>
<%@page import="com.nomus.staticmembers.DateTimeUtil"%>
<%@page import="com.nomus.m2m.dao.M2MNodeOtagesDao"%>
<%@page import="com.nomus.m2m.pojo.M2MNodeOtages"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.hibernate.Session"%>
<%@page import="org.nomus.Role"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page language="java" contentType="text/html" session="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/bootstrap.jsp" flush="false" >
	<jsp:param name="title" value="Event List" />
	<jsp:param name="headTitle" value="List" />
	<jsp:param name="limenu" value="Alarms" />
	<jsp:param name="headTitle" value="M2M/Alarms" />
	<jsp:param name="breadcrumb" value="Alarms" />
</jsp:include>

 <%  
 int limit = request.getParameter("limit")==null? 20:Integer.parseInt(request.getParameter("limit"));
 String sorttype =  request.getParameter("sorttype")==null? "desc":request.getParameter("sorttype").equals("asc")?"asc":"desc";
 String sortby =  request.getParameter("sortby")==null? "updateTime":request.getParameter("sortby");
 int pageno = request.getParameter("pageno")==null? 1:Integer.parseInt(request.getParameter("pageno")==""?"1":request.getParameter("pageno"));
 String fromdate = request.getParameter("fromdate") == null?"":request.getParameter("fromdate");
 String todate = request.getParameter("todate") == null?"":request.getParameter("todate");
 String slnumber = request.getParameter("slnumber") == null?"":request.getParameter("slnumber");
 String info_lbl = "";
 int start_row=0;
 int lastpage = 1; 
 
 String limitstr = (request.getParameter("limit") == null? "20" : request.getParameter("limit"));
 HashMap<String,String> params_hm = new HashMap<String,String>();
 params_hm.put("sorttype",sorttype);
 params_hm.put("limit",limit+"");
 params_hm.put("sortby",sortby);
 params_hm.put("pageno",pageno+"");
 params_hm.put("fromdate",fromdate);
 params_hm.put("todate",todate);
 params_hm.put("slnumber",slnumber);
 
  User user =(User)session.getAttribute("loggedinuser");	
      Session hibsession = null;
      try
      {
    	  hibsession = HibernateSession.getDBSession();
		  boolean where_added =false;
		  M2MNodeOtagesDao alarmdao = new M2MNodeOtagesDao();
		  List<M2MNodeOtages> alarmlist = alarmdao.getAlarmsList(user, params_hm);
		  
		  if(alarmlist.size() > 0)
	      {
			  int totalarms = alarmdao.getTotalAlarms();
			  lastpage = totalarms/limit;
			  if(totalarms%limit > 0)
				  lastpage++;
			  
			  start_row = limit*(pageno-1)+1;
			  info_lbl = start_row+" to to_cnt of "+totalarms;
		  }
    	  
		  if(info_lbl.length() > 0)
		  info_lbl = info_lbl.replace("to_cnt",(start_row-1)+alarmlist.size()+"");
		  Organization selorg =user.getOrganization();
			String refresh = selorg.getRefresh();
			int refreshtime = selorg.getRefreshTime();
%>
<head>
	<link rel="stylesheet" href="/imission/css/jquery-ui.css">
	<link rel="stylesheet" href="/imission/css/style.css">
	<script src="/imission/js/jquery.js"></script>
	<script src="/imission/js/jquery-ui.js"></script>
	<script type="text/javascript" src="/imission/m2m/wizngv2/js/common.js"></script>
	
<style type="text/css">

.pointer
{
cursor: pointer;
}
.page
{
	color:black;
	min-width:20px;
	width:20px;
	margin:10px;
	background-color:#AACE77;
	padding:2px;
	text-align:center;
	font-weight:bold;
}
.page a{
	color:black;
	text-decoration:none;
	cursor:pointer;
	font-weight:bold;
}
.disabled
{
	background-color:#ddd;
	color:black;
	min-width:20px;
	width:20px;
	margin:10px;
	padding:2px;
	text-align:center;
	font-weight:bold;
}
.disabled a{
	color:black;
	text-decoration:none;
	cursor:pointer;
	font-weight:bold;
}
#sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0px;
  z-index: 1;
}
th
{
  background-color: #7BC342;
}
html, body {margin: 1; height: 100%; overflow-y: hidden}
</style>
<script type="text/javascript">
var ctrlKeyDown = false;
function disableF5(e) 
{ 
	if ((e.which || e.keyCode) == 116 || ((e.which || e.keyCode) == 82 && ctrlKeyDown)) 
		e.preventDefault(); 
	else if ((e.which || e.keyCode) == 17) {
        // Pressing  only Ctrl
        ctrlKeyDown = true;
    }
};
$(document).on("keydown", disableF5);
$(function() {
        $( "#fromdate" ).datepicker({
            changeMonth: true,
            changeYear: true,
			dateFormat: 'dd-mm-yy'
        });
		$( "#todate" ).datepicker({
            changeMonth: true,
            changeYear: true,
			dateFormat: 'dd-mm-yy'
        });
    });
	function sgenerateUrl(pageno,sorttype,sortby)
	{
		var limit = document.getElementById("limit").value;
		var fromdateobj= document.getElementById("fromdate");
		var todateobj = document.getElementById("todate");
		var slnumber = document.getElementById("slnumber").value;
        var altmsg = validateDates(fromdateobj,todateobj);
		if(altmsg.length > 0)
		{
			alert(altmsg);
			return false;
		}
		var link = getLink(limit,fromdateobj,todateobj);
		if(slnumber.trim().length > 0)
			link +="&slnumber="+slnumber;
		link += "&sortby="+sortby+"&sorttype="+sorttype;
		document.location.href = link+"&pageno="+pageno;
	}
	function generateUrl(pageno)
	{
		var limit = document.getElementById("limit").value;
		var fromdateobj= document.getElementById("fromdate");
		var todateobj = document.getElementById("todate");
		var slnumber = document.getElementById("slnumber").value.trim();
        var altmsg = validateDates(fromdateobj,todateobj);
		if(altmsg.length > 0)
		{
			alert(altmsg);
			return false;
		}
		var link = getLink(limit,fromdateobj,todateobj);
		if(slnumber.trim().length > 0)
			link +="&slnumber="+slnumber;
		document.location.href = link+"&pageno="+pageno;
	}
	function validateDates(fromdateobj,todateobj)
	{
		var altmsg = "";
		if(!isValidDate(fromdateobj.value) && fromdateobj.value.trim().length > 0)
		{
			fromdateobj.style.border = "thin solid red";
			altmsg += "From date is not Valid\n";
		}
		else
			fromdateobj.style.border = "";
	    if(!isValidDate(todateobj.value) && todateobj.value.trim().length > 0 )
		{
			todateobj.style.border = "thin solid red";
			altmsg +="To date is not Valid";
		}
		else
			todateobj.style.border = "";

		return altmsg;
	}
	function makelink(sortby,sorttype,cursortby)
	{
		var limit = document.getElementById("limit").value;
		var fromdateobj= document.getElementById("fromdate");
		var todateobj = document.getElementById("todate");	
		var slnumber = document.getElementById("slnumber").value;

        var altmsg = validateDates(fromdateobj,todateobj);
		if(altmsg.length > 0)
		{
			alert(altmsg);
			return false;
		}
		var link = getLink(limit,fromdateobj,todateobj);
		if(slnumber.trim().length>0)
			link +="&slnunmber="+slnumber;
		link += "&sortby="+sortby;
		if(sortby == cursortby)
		{
			if(sorttype == "asc")
				sorttype = "desc";
			else
				sorttype = "asc";
			link += "&sorttype="+sorttype;
		}
		document.location.href = link;	
	}
	function getLink(limit,fromdateobj,todateobj)
	{
		var link = "alarms.jsp?limit="+limit;
		var serialno = document.getElementById("slnumber");
		if(fromdateobj.value.trim().length > 0)
			link += "&fromdate="+fromdateobj.value;
		if(todateobj.value.trim().length > 0)
			link += "&todate="+todateobj.value;
		
		return link;
	}
	function isValidDate(dateString)
	{
    // First check for the pattern
    //if(!/^\d{1,2}\/\d{1,2}\/\d{4}$/.test(dateString))
    if(!/^\d{1,2}-\d{1,2}-\d{4}$/.test(dateString))
        return false;

    // Parse the date parts to integers
    var parts = dateString.split("-");
    var day = parseInt(parts[0], 10);
    var month = parseInt(parts[1], 10);
    var year = parseInt(parts[2], 10);

    // Check the ranges of month and year
    if(year < 0 || month == 0 || month > 12)
        return false;

    var monthLength = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];

    // Adjust for leap years
    if(year % 400 == 0 || (year % 100 != 0 && year % 4 == 0))
        monthLength[1] = 29;

    // Check the range of the day
    return day > 0 && day <= monthLength[month - 1];
	}
	<%-- function dorefresh()
	{
		var refobj = document.getElementById("refresh");
		if(refobj.checked)
		{
			var m = document.createElement('meta');
			  m.setAttribute("http-equiv","refresh");
			  m.setAttribute("content",'<%=refreshtime%>');
			  m.setAttribute("id","metatag");
			  document.head.appendChild(m);
		}
		else
		{
			 var meta = document.getElementById("metatag");
			 document.head.removeChild(meta);
		}
		
	} --%>
</script>
</head>


 <body>
 <table class="borderlesstab" style="width:100%">
	<tr>
		<td>
			<nav>
		<div style="display:inline;width:100%;">
		    &nbsp;
		    Serial number : <input type="text" id="slnumber" maxlength="14" value='<%=slnumber%>'/>
		    &nbsp;&nbsp; From : <input type="text" class="datepicker" id="fromdate" name="fromdate" value='<%=fromdate%>' placeholder="dd-mm-yyyy"/>
		    &nbsp;&nbsp; To : <input type="text"  class="datepicker" id="todate" name="todate"  value='<%=todate%>' placeholder="dd-mm-yyyy"/>
			<button class="btn btn-default" onclick="generateUrl('1');" style="display:inline;padding:2px;">Submit</button>
			<label  <%if(pageno<2){%>disable class="disabled"<%}else{%> class="page"<%}%>><a  <%if(pageno>1){%>onclick="sgenerateUrl('1','<%=sorttype%>','<%=sortby%>')"<%}%>> << </a></label>
			<label  <%if(pageno<2){%>disable class="disabled"<%}else{%> class="page"<%}%>><a  <%if(pageno>1){%>onclick="sgenerateUrl('<%=(pageno-1)%>','<%=sorttype%>','<%=sortby%>')"<%}%>><</a></label>
			<label> <%=info_lbl%></label>
			<label  <%if(pageno == lastpage){%>class="disabled"<%}else{%> class="page"<%}%>><a <%if(pageno != lastpage){%>onclick="sgenerateUrl('<%=(pageno+1)%>','<%=sorttype%>','<%=sortby%>')"<%}%>>></a></label>
		    <label  <%if(pageno == lastpage){%>class="disabled"<%}else{%> class="page"<%}%>><a <%if(pageno != lastpage){%>onclick="sgenerateUrl('<%=(lastpage)%>','<%=sorttype%>','<%=sortby%>')"<%}%>>>></a></label>
		   <%--  Refresh : 
		    <label class="switch" style="vertical-align:middle;padding-right:10px;"><input type="checkbox" id="refresh" name="refresh" style="vertical-align:middle" onclick="dorefresh()" <%if(refresh != null && refresh.equals("yes")) {%> checked <%} %>></label> --%>
		    Results per page : 	
		    <select id="limit">
		    <option value="20" <%if(limit==20){%>selected<%}%>>20</option>
		    <option value="50" <%if(limit==50){%>selected<%}%>>50</option>
		    <option value="100" <%if(limit==100){%>selected<%}%>>100</option>
		    </select>
		    </div>
			</nav>
		</td>
	</tr>
</table>
	<div style="overflow-y:scroll; height:62vh;">
<table id="tab" class="table table-condensed severity" style="max-width:100%">
	<thead id="sticky">
		<tr>
			<th width="8%" ><%if(sortby.equals("severity")){%><img <%if(sorttype.equals("asc")){%>src="/imission/images/arrowup.gif"<%}else{%> src="/imission/images/arrowdown.gif"<%}%>alt="" vspace="0" hspace="0" border="0"/><%}%><label class="pointer" onclick="makelink('severity','<%=sorttype%>','<%=sortby%>')">Severity</label></th>
			<th width="12%"><%if(sortby.equals("slnumber")){%><img <%if(sorttype.equals("asc")){%>src="/imission/images/arrowup.gif"<%}else{%> src="/imission/images/arrowdown.gif"<%}%>alt="" vspace="0" hspace="0" border="0"/><%}%><label class="pointer" onclick="makelink('slnumber','<%=sorttype%>','<%=sortby%>')">Serial No</label></th>
			<th width="34%"><label>Alarms Info</label></th>
			<th width="14%"><%if(sortby.equals("downtime")){%><img <%if(sorttype.equals("asc")){%>src="/imission/images/arrowup.gif"<%}else{%> src="/imission/images/arrowdown.gif"<%}%>alt="" vspace="0" hspace="0" border="0"/><%}%><label class="pointer" onclick="makelink('downtime','<%=sorttype%>','<%=sortby%>')">Alarm Time</label></th>
			<th width="14%"><%if(sortby.equals("uptime")){%><img <%if(sorttype.equals("asc")){%>src="/imission/images/arrowup.gif"<%}else{%> src="/imission/images/arrowdown.gif"<%}%>alt="" vspace="0" hspace="0" border="0"/><%}%><label class="pointer" onclick="makelink('uptime','<%=sorttype%>','<%=sortby%>')">Recover Time</label></th>
			<th width="18%"><label>Persistent Time</label></th>
			<!-- <th width="15%"><label onclick="goToUrl('Time')">service</label>></th> -->
		</tr>
	</thead>

	<% for(M2MNodeOtages alarm :  alarmlist){
	%>
	    <tbody id="rowdata">
         <tr valign="top" class="severity-<%=alarm.getSeverity()%>">
         	<td class="divider bright">
			<%=alarm.getSeverity()%>
         	</td>
         	<td>
         	<%=alarm.getSlnumber()%>
         	</td>
         	<td><%=alarm.getAlarmInfo()==null?"":alarm.getAlarmInfo()%></td>
         	<td>
         	<%=alarm.getDowntime()==null?(alarm.getUpdateTime()==null?"":alarm.getUpdateTime()):alarm.getDowntime()%>
         	</td>
        	 <td>
        	 <%=alarm.getUptime()==null?"":alarm.getUptime()%>
         	</td>
			 <td>
        	 <%=DateTimeUtil.getPersistentDTime(alarm.getDowntime()==null?(alarm.getUpdateTime()==null?null:alarm.getUpdateTime()):alarm.getDowntime(),alarm.getUptime())%>
         	</td>
         </tr>
         </tbody>		 
      <%}
      }
      catch(Exception e)
      {
    	  e.printStackTrace();
      }
      finally
      {
    	  if(hibsession != null)
    		  hibsession.close();
      }
      %>
 </table>
 </div>
 <script>
 //dorefresh();
 </script>
 </body>
 <jsp:include page="/bootstrap-footer.jsp" flush="false" />  