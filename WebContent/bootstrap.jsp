<%@page import="com.nomus.m2m.pojo.Organization"%>
<%@page import="com.nomus.staticmembers.UserRole"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="com.nomus.staticmembers.DateTimeUtil"%>
<%@page language="java"
	contentType="text/html"
	session="true"
	import="java.util.Map"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<%
	String url = ((HttpServletRequest)request).getRequestURL().toString();
	String limenu = "nolimenu";
	String curpage="";
	String lisubmenu = request.getParameter("lisubmenu")==null?"":request.getParameter("lisubmenu");
	String reportid = request.getParameter("reportId")==null?"":request.getParameter("reportId");
	if(request.getParameter("limenu")!=null)
		limenu = request.getParameter("limenu");
	else if(url.contains("orgtree.jsp"))
	    limenu ="organizationTree";
	else if(url.contains("dashboard.jsp"))
	{
	    limenu ="Dashboard";
	    curpage ="dashboard.jsp";
	}
	if(url.contains("redirectuserpassword.jsp")||url.contains("resetpassword.jsp"))
		curpage ="redirectuserpassword";
	else if(url.contains("linkexpired.jsp"))
		curpage ="linkexpired";
	else if(url.contains("message.jsp"))
		curpage="message";
	else if(url.contains("orgupdate.jsp"))
		curpage="orgupdate";
	else if(url.contains("node.jsp"))
		curpage="node";
	if(url.contains("orgbatchdata.jsp"))
		curpage="orgbatchdata";
	if(url.contains("m2m.jsp"))
		curpage = "m2m.jsp";
	String username = session.getAttribute("loggedinuser") ==null?"":((User)session.getAttribute("loggedinuser")).getUsername();
	String resetusername = session.getAttribute("resetuser") ==null?"":((User)session.getAttribute("resetuser")).getUsername();
	User user = (User) session.getAttribute("loggedinuser");
	User resetuser = (User) session.getAttribute("resetuser");
	String refresh_page =  request.getParameter("refreshpage");
	if(refresh_page != null)
		session.setAttribute("refresh_page", refresh_page);
	Organization selorganization=null;
	String dbrefresh="";  // refresh value from database
	String htrefresh="no";  //refresh value from http param
	int refreshtime=0;
	if(user != null)
	{
		selorganization =user.getOrganization();
		if(selorganization != null)
		{
			dbrefresh = selorganization.getRefresh();
			refreshtime = selorganization.getRefreshTime();
		   	if(session.getAttribute("refresh_page") != null)
		   		htrefresh = (String)session.getAttribute("refresh_page");
		   	else if(dbrefresh.equals("yes"))
				htrefresh = "yes";
		}
		
	}
%>
<!DOCTYPE html>
<head>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" /> 
<meta http-equiv="Expires" content="0" />
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>
    <c:forEach var="headTitle" items="${paramValues.headTitle}">
	<c:out value="${headTitle}" escapeXml="false"/> |
    </c:forEach>
   Imission Web Console
</title>
<meta http-equiv="Content-type" content="text/html; charset=utf-8" />
  <meta http-equiv="Content-Style-Type" content="text/css"/>
  <meta http-equiv="Content-Script-Type" content="text/javascript"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width">
  <script type="text/javascript" src="/imission/js/jquery-1.4.2.min.js"></script>

  <!-- Set GWT property to get browsers locale -->
  <meta name="gwt:property" content="locale=<%=request.getLocale()%>">

  <c:forEach var="meta" items="${paramValues.meta}">
    <c:out value="${meta}" escapeXml="false"/>
  </c:forEach>
<!--  ${nostyles} -->
 <c:if test="${param.nostyles != 'true' }">
    <link rel="stylesheet" type="text/css" href="/imission/css/bootstrap.css" media="screen"/>
    <link rel="stylesheet" type="text/css" href="/imission/css/opennms-theme.css" media="screen" />
    <link rel="stylesheet" type="text/css" href="/imission/css/font-awesome-4.3.0/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="/imission/css/print.css" media="print"/>
  <!--   <link href="/imission/css/solid.css" rel="stylesheet">
<link href="/imission/css/v4-shims.css" rel="stylesheet"> -->
<!-- <link rel="stylesheet" type="text/css" href="/imission/css/style.css"> -->
    
  </c:if>
	<link rel="shortcut icon" href="/imission/images/i_sym.png"/>
<style>
img
{
	cursor:pointer;
	padding-right:5px;
}
html {
  scroll-behavior: smooth;
}
body{
	 margin:3px;
}
.header
{
     padding: 0rem;
     text-align: center;
	 min-height:124px;
}
#topnav 
	{
		background-color: #7BC342;
	}
#topnav a 
	{
		float: left;
		display: block;
		text-align: center;
		padding: 6px 20px;
		text-decoration: none;
		font-size: 14px;
		color:black;
		min-width:120px;	
	}
#topnav a:hover 
	{
		background-color: #ddd;
		border-radius:5px;
		border: 1px solid green;
		color: black;
	}
#topnav a.active
	{
		background-color:#f2f2f2;
		color: black;
		border: 1px solid green;
		border-radius:5px;
	}
	ul {
  list-style-type: none;
  margin: 0;	
  padding: 0;
  overflow: hidden;
}

li {
  display: inline;
  min-width:120px;
}

.sticky {
  position: sticky;
  min-width:35px;
  position: -webkit-sticky;
  top: 0;
  z-index:99;
  width: 100%;
}
#nav a 
	{
		float: left;
		text-decoration:none;
		display: block;
		text-align: center;
		padding :5px 20px;
		font-size: 13px;
		color:black;
		min-width:120px;
	}
#nav a:hover 
	{
		background-color: #ddd;
		color: black;
	}
#nav a.active 
	{
		text-decoration:underline;
		text-decoration-color:#7BC342;
        text-decoration-thickness: 2px;
		text-underline-position: under;
	}
#confgtn a ,#repdiv a
	{
		float: left;
		text-decoration:none;
		text-align:center;
		padding: 5px 20px;
		font-size: 13px;
		color:black;
		min-width:120px;
	}
#confgtn a:hover ,#repdiv a:hover
	{
		background-color: #ddd;
		color: black;
	}
#confgtn a.active,#repdiv a.active
	{
		text-decoration:underline;
		text-decoration-color:#7BC342;
        text-decoration-thickness: 2px;
		text-underline-position: under;
	}
	
.input-icons i {
	position: absolute;	
}
	  
.icon {
	padding: 6px;
	color:#7BC342;
	font-size:16px;
	width:20px;
	vertical-align:middle;
}
.imgicon{
	padding-bottom:10;
}
.input-field {
	width: 98%;
	height:20px;
	margin:3px; 
	border: 1px solid green;
	border-radius:5px;
	text-align:left;
}
#search
{	
	text-align:left;
	padding-left:23px;
	outline:none;
}
.slopediv
{
	float:left;
	height:28;
	border-left:40px solid #7BC342;
	border-top: 50px solid  transparent;
}
#nomusfont
{
	font-family : "BankGothic Md BT";
}
#redfont
{
	font-size:16px;
	font-weight:normal;
	color:red;
}
.lfont
{
	font-size:8.8px;
	
}
.hfont
{
	font-size:10.8px;
}
.slider {
	position: absolute;
  	cursor: pointer;
  	top: 0;
  	left: 0;
  	right: 0;
  	bottom: 0;
  	background-color: #ccc;
  	-webkit-transition: .4s;
  	transition: .4s;
}

.slider:before {
  	position: absolute;
  	content: "";
  	height: 10px;
  	width: 10px;
  	left: 4px;
  	bottom: 3px;
  	background-color: white;
  	-webkit-transition: .4s;
  	transition: .4s;
}

input:checked + .slider {
  	background-color: #50c878;
  	box-shadow: none;
}

input:focus + .slider {
	box-shadow: 0 0 0 0;
}

input:checked + .slider:before {
	-webkit-transform: translateX(16px);
  	-ms-transform: translateX(16px);
  	transform: translateX(16px);
}

/* Rounded sliders */
.slider.round {
  border-radius: 34px;
}

.slider.round:before {
  border-radius: 50%;
}
.switch {
	position: relative;
	display: inline-block;
  	width: 35px;
  	height: 16px;  
}

.switch:focus 
{
	box-shadow: none;
}

.switch input { 
	opacity: 0;
  	width: 0;
  	height: 0;
}
</style>
<script type = "text/javascript">
/*window.onscroll = function() {myFunction()};
var navbar = document.getElementById("topnav");
var sticky = navbar.offsetTop;

function myFunction() {
  if (window.pageYOffset >= sticky) {
    navbar.classList.add("sticky")
  } else {
    navbar.classList.remove("sticky");
  }
}*/

function Logout()
{
	 var confirmBox=confirm("Are you sure you want to Logout?");
	 if(confirmBox==true)
	 {
		 window.location.href="/imission/LogoutController";
	 }
}
function UserConfig()
{
	 window.location.href="/imission/user/list.jsp";
}
function Settings()
{
	  window.location.href="/imission/account/index.jsp";
}

function showconfigitems(menuname)
{
	var configitems=document.getElementById("confgtn");
	var dshbrdlisubmenu=document.getElementById("nav");
	var repdiv=document.getElementById("repdiv");
	if(menuname == "Configuration")
	{
	configitems.style.display="inline";
	dshbrdlisubmenu.style.display="none";
	repdiv.style.display="none";
	}
	else if(menuname == "Dashboard")
	{
	configitems.style.display="none";
	dshbrdlisubmenu.style.display="inline";
	repdiv.style.display="none";
	}
	else if(menuname == "Reports")
	{
	if(configitems!=null)
	{
	configitems.style.display="none";
	dshbrdlisubmenu.style.display="none";
	repdiv.style.display="inline";
	}
		else
			{
			//configitems.style.display="none";
			dshbrdlisubmenu.style.display="none";
			repdiv.style.display="inline";
			}
	}
	else{
		if(configitems!=null)
		{
			configitems.style.display="none";
			dshbrdlisubmenu.style.display="none";
			repdiv.style.display="none";
		}
		else
		{
		//configitems.style.display="none";
		dshbrdlisubmenu.style.display="none";
		//repdiv.style.display="none";
		}
	}
}
function doFilter(page)
{  
	
	 var val = $.trim($('#search').val()).replace(/ +/g, ' ').toLowerCase();
	if(page == 'orgbatchdata')
	{
		try{
		 /* var $rows = $('#tab #rowdata');
	        //var val = $.trim($('#search').val()).replace(/ +/g, ' ').toLowerCase();
	        $rows.show().filter(function() {
	            var text = $(this).text().replace(/\s+/g, ' ').toLowerCase();
	            if(!(!~text.indexOf(val) || !val.trim().length > 0))
	            {
	            	alert(text+" \nvalue is :"+value)
	            	expand(this.className.replace('row',''));
	            }
	            else
	            	compress(this.className.replace('row',''));
	            return !~text.indexOf(val) || !val.trim().length > 0;
	        }).hide(); */
	        val = val.trim();
	    	var tabs = document.getElementsByTagName('table');
	    	for(var i=0;i<tabs.length;i++)
	    	{
	    		var sel = 0;
	    		var tab = tabs[i];
	    		var rows= tab.rows;
	    		expand(tab.className.replace('tab','').replace(' seltab',''));
	    		for(var c=0;c<rows.length;c++)
	    		{
	    			row = rows[c];
	    			if(row.id != "rowdata")
	    				continue;
	    			var cols = row.cells;
	    			var rowdata="";
	    			for(var b=0;b<cols.length;b++)
	    			{
	    				if(cols[b].children.length > 0 && !cols[b].children[0].innerHTML.includes("Node Serial Numbers :"))
	    					rowdata += cols[b].children[0].innerHTML+"            ";
	    			}
	    			if(rowdata.includes(val) && val.length > 0)
	    			{
	    				sel++;
	    				row.style.display='table-row';
	    				//alert(this.className.replace('row',''));
	    				//expand(this.className.replace('row',''));
	    			}
	    			else
	    				row.style.display='none';
	    			
	    		}
	    		if(sel == 0)
	    			compress(tab.className.replace('tab','').replace(' seltab',''));
	    	}
		}
		catch(e)
		{
			alert(e);
		}
	}
	else if(page == 'm2m.jsp')
	{
		try
		{
			var tab =document.getElementById('tab');
			rows = tab.rows;
			for(var i=1; i<rows.length;i++)
			{
				var matched = false;
				for(var j=0;j<7;j++)
				{
					//alert(rows[i].cells[j].innerHTML.replace(/\s+/g, ' ').toLowerCase());
					if(rows[i].cells[j].innerHTML.replace(/\s+/g, ' ').toLowerCase().includes(val))
					{
						rows[i].style.display = "";
						matched = true;
						break;
					}
				}
				if(!matched)
				{
					var cellen = rows[i].cells.length;
					if(rows[i].cells[cellen-1].innerHTML.replace(/\s+/g, ' ').toLowerCase().includes(val))
						matched = true;
				}
				if(matched)
					continue;
				rows[i].style.display = "none";	 
			}
		}
		catch(e)
		{
			alert(e);
		}
	}

	
	else
	{
		if(page=='dashboard.jsp')
			var $rows = $('#heatmaptab #rowdata');
		else
        	var $rows = $('#tab #rowdata');
        //var val = $.trim($('#search').val()).replace(/ +/g, ' ').toLowerCase();
        $rows.show().filter(function() {
            var text = $(this).text().replace(/\s+/g, ' ').toLowerCase();
            //alert("text is : "+text+"search string : "+val);
            //alert(!~text.indexOf(val));
            return !~text.indexOf(val);
        }).hide();
	}
}
function doaction(e)
{
	if(e.keyCode == 13){
          var val = $.trim($('#search').val()).replace(/ +/g, ' ').toLowerCase();
		  if(val.length == 12 && val.indexOf("-")==3 && val.indexOf("-",4) == 9 && val.split("-").length == 3)
		  {
			  
			  window.location.href = "m2m/node.jsp?slnumber="+val;
		  }
    }
}
function dorefresh(submit)
{
	var url = window.location.href;
	var refobj = document.getElementById("refresh");
	var checked = false;
	if(refobj.checked)
	{
		var m = document.createElement('meta');
		 m.setAttribute("http-equiv",'<%=dbrefresh.equalsIgnoreCase("yes")?"refresh":""%>');
		  m.setAttribute("content",'<%=refreshtime%>');
		  m.setAttribute("id","metatag");
		  document.head.appendChild(m);
		  checked = true;
	}
	/* else
	{
		 var meta = document.getElementById("metatag");
		 if(meta.id != null)
			 document.head.removeChild(meta);
	} */
	
    if(submit)
	{
		let form = document.createElement("form");
		form.setAttribute("method", "post");
		form.setAttribute("action" , url);
		document.body.appendChild(form);
		let refresh = document.createElement("input");
		refresh.name = "refreshpage";
		refresh.display="none";
		refresh.value = checked == true?"yes":"no";
		form.appendChild(refresh);
		form.submit();
	}
}
</script>
</head>
<body>

<div class="header sticky" style="border-bottom: 3px solid #ddd;margin-bottom:5px;background-color:white;">
<div>

<!-- <img src="/imission/images/iMission2.jpg" alt="imissionlogo" width="150" style="float:left;max-height:50px;"/> -->
	<img src="/imission/images/imission_logo.jpg" alt="imissionlogo" width="210" style="float:left;max-height:70px;padding-left:0.5%" />
	<div align="right">
       <div style="max-width:312px;min-width:312px;padding-top:2px;">
		   <div align="left">	   
		   <!-- <img src="/imission/images/nomus_logo.jpg"  alt="nomuslogo" width="320" height="80"/> -->
		   <img src="/imission/images/nomus_logo.jpg"  alt="nomuslogo" width="320" height="70px"/>
		   </div>
		   <!-- <div id="nomusfont">
				<div id="redfont">
					NOMUS COMM-SYSTEMS PVT. LTD.
				</div>
				<div align="right" class="lfont" style="letter-spacing: -0.2px;">
					<label class="hfont">E</label>NERGIZE <label class="hfont">Y</label>OUR <label class="hfont">N</label>ETWORK
				</div>
			</div> -->
		</div>
	</div>
</div>
<div id="topnav" style="background-image: url(images/headerbg.jpg); background-repeat:repeat;">
<ul class="lisubmenu">
<%-- <%if(curpage=="redirectuserpassword") {%>
 <li><a href="/imission/resetpassword.jsp" ></a></li><%} %> --%>
 <%if(user != null) {%>
    <li><%if(curpage!="redirectuserpassword"&&curpage!="linkexpired") {%><a <%if(limenu.equals("Dashboard") || limenu.length()==0 ||limenu.equals("organizationTree")){%>class="active"<%}%> <%if(user.getRole().equals(UserRole.MAINADMIN)){ %>href="/imission/organizationTree"<%}else { %>href="/imission/dashboard.jsp" <%}%>>Dashboard</a><%}%></li>
	<%if(!user.getRole().equals(UserRole.MAINADMIN) &&curpage!="redirectuserpassword"&&curpage!="linkexpired") {%>
	    <%if(!user.getRole().equals(UserRole.MONITOR)) {%>
	    	<li><a <%if(limenu.equals("Configuration")){%>class="active"<%}%> href="/imission/m2m/m2m.jsp?lisubmenu=Edit" id="config">Configuration</a></li>
	    <%}%>
		<li><a <%if(limenu.equals("Reports")){%>class="active"<%}%> href="/imission/report/reportlist.jsp" id="reports">Reports</a></li>
		<li><a <%if(limenu.equals("Alarms")){%>class="active"<%}%> href="/imission/m2m/alarm/alarms.jsp" id="alarms">Alarms</a></li>
		<li><a <%if(limenu.equals("Events")){%>class="active"<%}%> href="/imission/m2m/event/events.jsp">Events</a></li>
 	<%}}else{%>
    	<li><a>&nbsp;</a></li>
    <%} %>
<div style="width:308px;
		height:25px;
		float:right;
		padding-right:5px;
		padding-bottom:10px;
		background-color:white;">
<label class="slopediv"></label>
<label align="right" style="float:right">
<% if(curpage!="linkexpired") {%>
<label style="color:#7BC342;font-size: 11px;font-weight:bold; padding-top: 3px"><%=username%></label>&nbsp;
<%} if(curpage!="redirectuserpassword"&&curpage!="linkexpired") {%>
<%if(user != null && !user.getRole().equals(UserRole.SUPERVISOR) && !user.getRole().equals(UserRole.MONITOR)) {%>
	<img class="imgicon" src="/imission/images/user.jpg" alt="user" width="25" height="20" title="User Config" onclick="UserConfig()"></img>
<%} %>
<% if(user != null && !user.getRole().equals(UserRole.MONITOR)) {%>
	<img class="imgicon" src="/imission/images/settings.png" alt="settings" width="25" height="20" title="Settings" onclick="Settings()"/>
<%}}%>
<% if(curpage!="linkexpired") {%>
<img class="imgicon" src="/imission/images/logout.jpg"  alt="logout" width="25" height="20" title="Logout" onclick="Logout()"/>
<%} %>
</label>
</div>
</ul>
</div>
<% if(curpage!="redirectuserpassword"&&curpage!="linkexpired") {%>
<div style="width:290px;float:right;">
        <div class="input-icons">
			<i class="fa fa-search icon"></i>
            <input class="input-field" type="text" title="search" id="search" onkeyup="doFilter('<%=curpage%>')" <%if(limenu.equals("Dashboard")) {%>onkeydown="doaction(event)" <%} %>>
        </div>
 </div>
 <%if(curpage!="orgupdate") {%>
<div style="float:right;margin-top:3px;padding-right:50px">
<%  if((dbrefresh.toLowerCase().equals("yes")) && (limenu.equals("Dashboard") || limenu.equals("Configuration") || limenu.equals("Alarms") || limenu.equals("Events") || curpage.equals("node")) ) {%>
  Refresh :
<label class="switch" style="vertical-align:middle"><input type="checkbox" id="refresh" name="refresh" style="vertical-align:middle" onclick="dorefresh(true)" <%if(htrefresh != null && htrefresh.equals("yes")) {%> checked <%} %>><span class="slider round"></span></label>
<%} %>
</div>
  <%}}%>
<div id="nav">
<ul>
	 
	   <li><a <%if(lisubmenu.equals("Overview") || lisubmenu.length()==0 ){%>class="active"<%}%>  href="/imission/dashboard.jsp">Overview</a></li>
	   <%if(user != null && !user.getRole().equals(UserRole.MAINADMIN)) {%>
		   <li><a <%if(lisubmenu.equals("Active")){%>class="active"<%}%>  href="/imission/index.jsp?type=active&lisubmenu=Active">Active</a></li>
		   <li><a <%if(lisubmenu.equals("Down")){%>class="active"<%}%>  href="/imission/index.jsp?type=down&lisubmenu=Down">Down</a></li>
		   <li><a <%if(lisubmenu.equals("In Active")){%>class="active"<%}%> style="padding-left:35px;"  href="/imission/index.jsp?type=inactive&lisubmenu=In Active">In Active</a></li>
		   <li><a <%if(lisubmenu.equals("Deleted")){%>class="active"<%}%> style="padding-left:35px;"  href="/imission/m2m/deletedNodes.jsp?lisubmenu=Deleted">Deleted</a></li>
	   <%}%>
  </ul>
</div>

<%if(user != null && !user.getRole().equals(UserRole.MAINADMIN)) {%>
	<%if(!user.getRole().equals(UserRole.MONITOR)) {%>
		<div id="confgtn" hidden>	
		<ul id="configlisubmenu">
			   <li><a <%if(lisubmenu.equals("Edit") || lisubmenu.length()==0){%>class="active"<%}%> href="/imission/m2m/m2m.jsp?configtype=edit&lisubmenu=Edit">Edit</a></li>
			   <li><a <%if(lisubmenu.equals("Export")){%>class="active"<%}%> href="/imission/m2m/m2m.jsp?configtype=export&lisubmenu=Export">Export</a></li>
			   <li><a <%if(lisubmenu.equals("FW Upgrade")){%>class="active"<%}%>href="/imission/m2m/m2m.jsp?configtype=firmwareupgrade&lisubmenu=FW Upgrade">FW Upgrade</a></li>
			   <li><a <%if(lisubmenu.equals("Reboot")){%>class="active"<%}%> href="/imission/m2m/m2m.jsp?configtype=reboot&lisubmenu=Reboot">Reboot</a></li>
			   <li><a <%if(lisubmenu.equals("Organization Update")){%>class="active"<%}%> href="/imission/m2m/orgupdate.jsp">Organization Update</a></li>
		</ul>
		</div>
	<%}%>
	<div id="repdiv" hidden>	
	<ul id="replisubmenu">
		   <li><a <%if(lisubmenu.equals("Reports") || lisubmenu.length()==0){%>class="active"<%}%> href="/imission/report/reportlist.jsp?lisubmenu=Reports">Reports</a></li>
		   <li><a <%if(lisubmenu.equals("Schedule Reports")){%>class="active"<%}%> href="/imission/report/scheduledreportlist.jsp">Schedule Reports</a></li>
		   <li><a <%if(lisubmenu.equals("Activity")){%>class="active"<%}%> href="/imission/activity/activitylist.jsp?lisubmenu=Activity">Activity</a></li>
	</ul>
	</div>
<%}%>
</div>
<script type="text/javascript">
	showconfigitems('<%=limenu%>');
	<%if((dbrefresh.toLowerCase().equals("yes")) && (limenu.equals("Dashboard") || limenu.equals("Configuration") || limenu.equals("Alarms") || limenu.equals("Events") || curpage.equals("node")) ) {%>
		dorefresh(false);
	<%}%>
</script>
</body>