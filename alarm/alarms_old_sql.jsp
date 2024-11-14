<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.hibernate.Session"%>
<%@page import="org.nomus.Role"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Hashtable"%>
<%@page language="java" contentType="text/html" session="true"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/bootstrap.jsp" flush="false" >
	<jsp:param name="title" value="Event List" />
	<jsp:param name="headTitle" value="List" />
	<jsp:param name="limenu" value="Alarms" />
	<jsp:param name="headTitle" value="M2M/Alarms" />
	
	<jsp:param name="breadcrumb" value="Alarms" />
</jsp:include>

 <%  
 SimpleDateFormat sdf = new SimpleDateFormat("EEE, d MMM YYYY hh:mm:ss aaa");
 int limit = request.getParameter("limit")==null? 20:Integer.parseInt(request.getParameter("limit"));
 String sorttype =  request.getParameter("sorttype")==null? "desc":request.getParameter("sorttype").equals("asc")?"asc":"desc";
 String sortby =  request.getParameter("sortby")==null? "id":request.getParameter("sortby");
 int pageno = request.getParameter("pageno")==null? 1:Integer.parseInt(request.getParameter("pageno")==""?"1":request.getParameter("pageno"));
 String fromdate = request.getParameter("fromdate") == null?"":request.getParameter("fromdate");
 String todate = request.getParameter("todate") == null?"":request.getParameter("todate");
 String slnumber = request.getParameter("slnumber") == null?"":request.getParameter("slnumber");
 String info_lbl = "";
 int start_row=0;
 int lastpage = 1; 
 
  User user =(User)session.getAttribute("loggedinuser");
  if(user.getRole().equals(Role.ADMIN)||  user.getRole().equals(Role.SUPERADMIN) || !user.getRole().equals(Role.VIEW))  { 
      ResultSet rs = null;
      Statement st = null;
      Connection con = null;	
      Session hibsession = null;
      try
      {
    	  String limitstr = (request.getParameter("limit") == null? "20" : request.getParameter("limit"));
    	  hibsession = HibernateSession.getDBSession();
    	  con = ((SessionImpl)hibsession).connection();
    	  st=con.createStatement();
		  boolean where_added =false;
		  String cntsql = "select count(*) from m2mnodeoutages";
    	  String sql = "select severity, slnumber, downtime, uptime,age(uptime,downtime) as persisttime from m2mnodeoutages"; 
		  if(slnumber.trim().length() > 0)
		  {
			  sql += " where slnumber = '"+slnumber+"'";
			  cntsql += " where slnumber = '"+slnumber+"'";
			  where_added=true;
		  }
		  if(fromdate.trim().length() > 0)
		  {
			  if(!where_added)
			  {
				  sql += " where";
				  cntsql += " where";
				  where_added = true;
			  }
			  else 
			  {
				  sql += " and";
				  cntsql += " and";
			  }
			  sql += " downtime >='"+getSqlDateFromat(fromdate)+"'";
			  cntsql += " downtime >='"+getSqlDateFromat(fromdate)+"'";
		  }
		  if(todate.trim().length() > 0)
		  {
			  if(!where_added)
			  {
				  sql += " where";
				  cntsql += " where";
				  where_added = true;
			  }
			  else 
			  {
				  sql += " and";
				  cntsql += " and";
			  }
			  sql += " downtime <=(date('"+getSqlDateFromat(todate)+"') + interval '1' day)";
			  cntsql += " downtime <=(date('"+getSqlDateFromat(todate)+"') + interval '1' day)";
		  }	  
		  sql += " order by "+sortby+" "+sorttype+" limit "+limit+" offset "+(limit*(pageno-1));	
		  rs = st.executeQuery(cntsql);
		  if(rs.next())
	      {
			  int rowcnt = rs.getInt(1);
			  lastpage = rowcnt/limit;
			  if(rowcnt%limit > 0)
				  lastpage++;
			  
			  start_row = limit*(pageno-1)+1;
			  info_lbl = start_row+" to to_cnt of "+rowcnt;
		  }
    	  rs = st.executeQuery(sql);
    	  Vector<Hashtable<String,String>> res_vec = new Vector<Hashtable<String,String>>();
    	  
    	  while(rs.next())
    	  {
    		  Hashtable<String,String> res_sh = new Hashtable<String,String>();
    		  res_sh.put("severity",rs.getString("severity"));
    		  res_sh.put("slnumber",rs.getString("slnumber"));
			  res_sh.put("downtime",sdf.format(rs.getTimestamp("downtime")));
    		  res_sh.put("uptime",rs.getTimestamp("uptime")==null?"":sdf.format(rs.getTimestamp("uptime")));
    		  res_sh.put("persisttime",rs.getString("persisttime")==null?"":rs.getString("persisttime"));
			  res_vec.add(res_sh);
		  }
		  if(info_lbl.length() > 0)
		  info_lbl = info_lbl.replace("to_cnt",(start_row-1)+res_vec.size()+"");
%>
<head>
	<link rel="stylesheet" href="/imission/css/jquery-ui.css">
	<link rel="stylesheet" href="/imission/css/style.css">
	<script src="/imission/js/jquery.js"></script>
	<script src="/imission/js/jquery-ui.js"></script>
	
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
html, body {margin: 1; height: 100%; overflow-y: hidden}
</style>
<script type="text/javascript">
$(function() {
        $( "#fromdate" ).datepicker({
            changeMonth: true,
            changeYear: true,
			dateFormat: 'dd/mm/yy'
        });
		$( "#todate" ).datepicker({
            changeMonth: true,
            changeYear: true,
			dateFormat: 'dd/mm/yy'
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
    if(!/^\d{1,2}\/\d{1,2}\/\d{4}$/.test(dateString))
        return false;

    // Parse the date parts to integers
    var parts = dateString.split("/");
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
	};
</script>
</head>


 <body>
	<nav>
<div style="display:inline;">
    &nbsp;
    Serial number : <input type="text" id="slnumber" value='<%=slnumber%>'/>
    
    &nbsp;&nbsp; From : <input type="text" class="datepicker" id="fromdate" name="fromdate" value='<%=fromdate%>' palceholder="dd-mm-yyyy"/>
    &nbsp;&nbsp; To : <input type="text"  class="datepicker" id="todate" name="todate"  value='<%=todate%>' palceholder="dd-mm-yyyy"/>
	<button class="btn btn-default" onclick="generateUrl('1');" style="display:inline;padding:2px;">Submit</button>

	<label  <%if(pageno<2){%>disable class="disabled"<%}else{%> class="page"<%}%>><a  <%if(pageno>1){%>onclick="sgenerateUrl('1','<%=sorttype%>','<%=sortby%>')"<%}%>> << </a></label>
	<label  <%if(pageno<2){%>disable class="disabled"<%}else{%> class="page"<%}%>><a  <%if(pageno>1){%>onclick="sgenerateUrl('<%=(pageno-1)%>','<%=sorttype%>','<%=sortby%>')"<%}%>><</a></label>
	<label> <%=info_lbl%></label>
	<label  <%if(pageno == lastpage){%>class="disabled"<%}else{%> class="page"<%}%>><a <%if(pageno != lastpage){%>onclick="sgenerateUrl('<%=(pageno+1)%>','<%=sorttype%>','<%=sortby%>')"<%}%>>></a></label>
    <label  <%if(pageno == lastpage){%>class="disabled"<%}else{%> class="page"<%}%>><a <%if(pageno != lastpage){%>onclick="sgenerateUrl('<%=(lastpage)%>','<%=sorttype%>','<%=sortby%>')"<%}%>>>></a></label>
    </div>
	<div style="display:inline;float:right;margin-top:12px;">
    Results per page : 	
    <select id="limit">
    <option value="20" <%if(limit==20){%>selected<%}%>>20</option>
    <option value="50" <%if(limit==50){%>selected<%}%>>50</option>
    <option value="100" <%if(limit==100){%>selected<%}%>>100</option>
    </select>
    </div>	
	</nav>
	<div style="overflow-y:scroll; height:62vh">
<table id="tab" class="table table-condensed severity">
	<thead id="sticky">
		<tr>
			<th width="10%"><%if(sortby.equals("severity")){%><img <%if(sorttype.equals("asc")){%>src="imission/images/arrowup.gif"<%}else{%> src="imission/images/arrowdown.gif"<%}%>alt="Severity Sort" vspace="0" hspace="0" border="0"/><%}%><label class="pointer" onclick="makelink('severity','<%=sorttype%>','<%=sortby%>')">Severity</label></th>
			<th width="19%"><%if(sortby.equals("slnumber")){%><img <%if(sorttype.equals("asc")){%>src="imission/images/arrowup.gif"<%}else{%> src="imission/images/arrowdown.gif"<%}%>alt="Severity Sort" vspace="0" hspace="0" border="0"/><%}%><label class="pointer" onclick="makelink('slnumber','<%=sorttype%>','<%=sortby%>')">Serial No</label></th>
			<th width="19%"><%if(sortby.equals("downtime")){%><img <%if(sorttype.equals("asc")){%>src="imission/images/arrowup.gif"<%}else{%> src="imission/images/arrowdown.gif"<%}%>alt="Severity Sort" vspace="0" hspace="0" border="0"/><%}%><label class="pointer" onclick="makelink('downtime','<%=sorttype%>','<%=sortby%>')">Outage Time</label></th>
			<th width="25%"><%if(sortby.equals("uptime")){%><img <%if(sorttype.equals("asc")){%>src="imission/images/arrowup.gif"<%}else{%> src="imission/images/arrowdown.gif"<%}%>alt="Severity Sort" vspace="0" hspace="0" border="0"/><%}%><label class="pointer" onclick="makelink('uptime','<%=sorttype%>','<%=sortby%>')">Recover Time</label></th>
			<th width="25%"><label>Persistent Time</label></th>
			<!-- <th width="15%"><label onclick="goToUrl('Time')">service</label>></th> -->
		</tr>
	</thead>

	<% for(int i=0;i<res_vec.size();i++){
		Hashtable<String,String> res_sh = res_vec.get(i);
	%>
	    <tbody id="rowdata">
         <tr valign="top" class="severity-<%=res_sh.get("severity")%>">
         	<td class="divider bright">
			<%=res_sh.get("severity")%>
         	</td>
         	<td>
         	<%=res_sh.get("slnumber")%>
         	</td>
         	<td>
         	<%=res_sh.get("downtime")%>
         	</td>
        	 <td>
        	 <%=res_sh.get("uptime")%>
         	</td>
			 <td>
        	 <%=res_sh.get("persisttime")%>
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
    	  if(st != null)
    		  st.close();
    	  if(rs != null)
    		  rs.close();
      }
}
      %>
 </table>
 </div>
 <%!
 private String getSqlDateFromat(String datestr)
 {
	 try
	 {
			SimpleDateFormat sdf = new SimpleDateFormat("dd/mm/yyyy");
			SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-mm-dd");
			return sdf1.format(sdf.parse(datestr));
	 }
	 catch(Exception e)
	 {
		 return "";
	 }
 }
 %>
 </body>
 <jsp:include page="/bootstrap-footer.jsp" flush="false" />  