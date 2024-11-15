<%
String slnumber=request.getParameter("slnumber");
%>
<html>
<head>
<meta http-equiv="pragma" content="no-cache"/>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>
Banner</title>
<style type="text/css">
.style2 {font-size: 24px; font-weight: bold; font-family: Arial, Helvetica, sans-serif; text-align: center;padding-left:10em;}.style6 {font-family: Verdana; font-size: 36px; font-weight: bold; color: #C6110D;padding-left:34%;}</style>
<script src="/js/option_bind.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">
function openInFrame(url)
{
	if(url=="/cgi/Nomus.cgi?cgi=Logout.cgi")
	{
		top.top.location = url;
	}
	else
	{
		top.frames['WelcomeFrame'].location.href = url;
	}
}
</script>
</head>
<body>
<table width="98%" height="100%" border="0">
<tr>
<td width="20%" rowspan="2" align="center" valign="middle">
<img src="images/Logo.JPG" width="306" height="78">
</td>
<td height="28" rowspan="2" style=="min-width:75%;" valign="middle" align="left">
<div style="align:left"><label class="style6" style="color:black;">Wi<label><label style="color:#C6110D;">Z<label> 
<label height="40%"s style="margin-left:1s%; color:black;font-family:Times New Roman;font-size:16px;">WIRELESS ACCESS ROUTER</label></div></td>
<td valign="bottom" align="center">
<span align="center"><a style="outline:none; valign:bottom;cursor:pointer" href='javascript:openInFrame("dosave.jsp?slnumber=<%=slnumber%>")'><img src="images/save.png" width="45px" height="45px"/></a></span>
</td>
</tr>
</table>
</body>
</html>




