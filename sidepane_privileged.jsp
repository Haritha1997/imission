<head>
<link rel="stylesheet" href="/css/style.css"/>
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
  parent.titleframe.location.href = "titleFrame.html?menu="+menuname;
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
<li onclick="hilightthis(this)"><a href="submenu_privileged.html?menu=networkmenu"  target="menubarFrame">Network</a></li>
<li onclick="hilightthis(this)"><a href="submenu_privileged.html?menu=servicesmenu" onclick="focus(this);" target="menubarFrame">Services</a></li>
<li onclick="hilightthis(this)"><a href="submenu_privileged.html?menu=diagmenu" onclick="focus(this);" target="menubarFrame">Diagnostics</a></li>
<li onclick="hilightthis(this)"><a href="submenu_privileged.html?menu=sysmenu" onclick="focus(this);" target="menubarFrame">System</a></li>
<li onclick="hilightthis(this)"><a href="submenu_privileged.html?menu=statusmenu" onclick="focus(this);" target="menubarFrame">Status</a></li>
<!--<li><label onclick="showmenu('servicesmenu')"><a>Services</a></label></li>
<li><label onclick="showmenu('diagmenu')"><a>Diagnostics</a></label></li>
<li><label onclick="showmenu('sysmenu')"><a>System</a></label></li>
<li><label onclick="showmenu('statusmenu')"><a>Status</a></label></li> -->
<li onclick="hilightthis(this)"><a href="/logout" onclick="focus(this);" target=_top>Logout</a></li></ul>
