<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="css/style.css"/>
<style type="text/css">
.style2 {
	font-size: 24px;
	font-weight: bold;
	font-family: Arial, Helvetica, sans-serif;
	text-align: center;
	padding-left: 10em;
}

.style6 {
	font-family: Verdana;
	font-size: 30px;
	font-weight: bold;
	color: #C6110D;
	padding-left: 28%;
}
</style>
<script type = "text/javascript">
function loadFunction()
{
const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);
var menuname = urlParams.get('menu');
showmenu(menuname);
}
    
	function showmenu(menuname) {
		var menu = document.getElementById(menuname);
		menu.style.display = "inline";
	}
	function showsubmenu(menuname)
	{
		var submen2arr = ["cellularmenu","ethernetmenu","firewalmenu","servpnmenu","managementmenu",
		"stavpnmenu","debugmenu"];
		//alert("menu name is : "+menuname);
		for(var i=0;i<submen2arr.length;i++)
		{
			if(submen2arr[i] != menuname)
			{
			document.getElementById(submen2arr[i]).style.display = "none";
			}
			else
			{
			  document.getElementById(submen2arr[i]).style.display = "inline";
			}
		}
		
	}
	
function openInFrame(url)
{
	if(url=="/cgi/Nomus.cgi?cgi=")
	{
		top.top.location = url;
	}
	else
	{
		//top.frames['WelcomeFrame'].location.href = url;
		top.location.href = url;
	}
}
</script>
</head>
<%
String slnumber=request.getParameter("slnumber");
String version = request.getParameter("version");
%>
<body onload="loadFunction()">
<table width="98%" height="100%" border="0">
<tr>
<td width="20%" align="center" valign="top">
<img src="images/Logo.jpg" width="250" height="45d">
</td>
<td height="24" style="min-width:75%;" valign="top" align="left">
<div style="align:left;margin-top:10px;"><label class="style6" style="color:black;">Wi<label style="color:#C6110D;">Z </label> <label> NG <%if(version.toLowerCase().contains("wizng2el")) {%>EL<%}else if(version.toLowerCase().contains("wizng2es")) {%>ES<%}%></label>
<label height="40%"s style="margin-left:1s%; color:black;font-family:Times New Roman;font-size:16px;">WIRELESS ACCESS ROUTER</label></div></td>
<td valign="bottom" align="center">
<span align="center"><a style="outline:none; valign:bottom;cursor:pointer" href='javascript:openInFrame("/imission/m2m/SaveEditConfiguration?slnumber=<%=slnumber%>")'><img src="/imission/images/save.png" width="45px" height="45px"/></a></span>
</td>
</td>
</tr>
</table>

	<!-- <div>
		<ul>
			<li id="li" class="active"><a onclick="showmenu('networkmenu')">Network</a></li>
			<li><a onclick="showmenu('servicesmenu')">Services</a></li>
			<li><a onclick="showmenu('diagmenu')">Diagnostics</a></li>
			<li><a onclick="showmenu('sysmenu')">System</a></li>
			<li><a onclick="showmenu('statusmenu')">Status</a></li>
			<li><a href="#">Logout</a></li>
		</ul>
	</div>
 -->
</body>
</html>