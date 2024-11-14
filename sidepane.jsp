<%
  String slnumber=request.getParameter("slnumber");
  String version=request.getParameter("version");
%>
<html>
<head>
<link rel="stylesheet" href="css/style.css"/>
<style type="text/css">
li a{
width : 100%;
text-decoration:none;
}
ul{
hirizontal-align:left;
list-style-type:none;
}
ul li{
hirizontal-align:left;
}
</style>
<script type="text/javascript">
function showmenu(menuname)
{
  parent.titleframe.location.href = "titleFrame.jsp?menu="+menuname;
}
function hilightthis(obj)
{
  	var list = document.getElementsByTagName("a");
	for(var i=0;i<list.length;i++)
	{
	list[i].id="";
	}
	obj.childNodes[0].id="hilightthis";
}
</script>
</head>
<ul class="mainmenu" id="mainmenu">
<li onclick="hilightthis(this)"><a href="submenu.jsp?menu=networkmenu&slnumber=<%=slnumber%>&version=<%=version%>"  target="menubarFrame">Network</a></li>
<li onclick="hilightthis(this)"><a href="submenu.jsp?menu=servicesmenu&slnumber=<%=slnumber%>&version=<%=version%>" onclick="focus(this);" target="menubarFrame">Services</a></li>
<!-- <li onclick="hilightthis(this)"><a href="submenu.jsp?menu=diagmenu&slnumber=<%=slnumber%>&version=<%=version%>" onclick="focus(this);" target="menubarFrame">Diagnostics</a></li>  -->
<li onclick="hilightthis(this)"><a href="submenu.jsp?menu=sysmenu&slnumber=<%=slnumber%>&version=<%=version%>" onclick="focus(this);" target="menubarFrame">Control</a></li>
<!-- <li onclick="hilightthis(this)"><a href="submenu.jsp?menu=statusmenu&slnumber=<%=slnumber%>&version=<%=version%>" onclick="focus(this);" target="menubarFrame">Status</a></li>  -->
<!--<li><label onclick="showmenu('servicesmenu')"><a>Services</a></label></li>
<li><label onclick="showmenu('diagmenu')"><a>Diagnostics</a></label></li>
<li><label onclick="showmenu('sysmenu')"><a>System</a></label></li>
<li><label onclick="showmenu('statusmenu')"><a>Status</a></label></li> -->
</ul>
</html>