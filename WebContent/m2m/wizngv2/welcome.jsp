<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Enumeration"%>
<html>
<head>
<meta http-equiv="pragma" content="no-cache"/>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Welcome</title>
<style type="text/css">
.style1
{ 
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	color: grey;
	font-size: 18px;
	font-weight: bold;
}
.style2 
{
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	color: #000000;
	font-size: 14px;
	font-weight: bold;
}
</style>
</head>
<% 
String version = request.getParameter("version"); 
Enumeration<String> params = request.getParameterNames();
%>
<body>
<div id=\"SecondsUntilExpire\">
<br><br>
<p align="center" class="style1">Welcome</p>
<p align="center" class="style1">To</p>
<p align="center" class="style1">WiZ NG <%if(version.toLowerCase().contains("wizng2el")) {%>EL<%} else if(version.toLowerCase().contains("wizng2es")){%>ES<%}%></p>
<br><br>
<p align="center" class="style2">For online Technical Details <a href="https://nomus.in/wiz/" target="_blank"><strong>Click Here</strong></a></p>
</div>
</body>
</html>
