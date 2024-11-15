<!DOCTYPE html><html><head><meta http-equiv="pragma" content="no-cache"/><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
#saveimg{
    background-image: url(save.png); /* 16px x 16px */
    background-color: transparent; /* make the button transparent */
    background-repeat: no-repeat;  /* make the background image appear only once */
    background-position: 0px 0px;  /* equivalent to 'top left' */
    border: none;           /* assuming we don't want any borders */
    cursor: pointer;        /* make the cursor like hovering over an <a> element */
    height: 100px;           /* make this the size of your image */
    padding-left: 100px;     /* make text start to the right of the image */
    vertical-align: middle; /* align the text vertically centered */
}
*{
	padding:0px 0px 0px 0px;
	margin:0.15px;
	border-radius:2px;
}
body
{
	font-family:Times New Roman;
	background:#F8F8F8;
}
nav.vertical
{
	width:280px;
	position:absolute;
	background:#D5DBdB;
}
nav.vertical ul
{
	list-style: none;
}
nav.vertical li
{
	position:relative;
	line-height:4px;
	padding-left:5px;
}
nav.vertical a
{
	display:block;
	color:#000000;
	text-decoration:none;
	padding:8px 12px;
}
nav.vertical li:hover > span> a 
{
	background: #fff;
	color: #000;
}
nav.vertical ul ul
{
	background:rgba(0,0,0,0.01);
	padding-left:10px;
	overflow:hidden;
	display:none;
}
.first
{
	font-size:18px;
	font-weight: bold;
}
.second
{
	font-size:16px;
}
.third,.fourth
{
	font-size:14px;
}
nav.vertical ul li a.active
{
background:#85929E;
}
</style>
<title>GW e RB</title>
<script src="/js/option_bind.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">
document.createElement("nav"); 
function openInFrame(url)
{
	if(url=="Logout.jsp")
	{
		top.top.location = url;
	}
	else
	{
		top.frames['WelcomeFrame'].location.href = url;
	}
}
</script>
</head><body>
<%String slnumber=request.getParameter("slnumber");
  String versionstr=request.getParameter("version");
  double version = 1.5;
  try
  {
  	 version = Double.parseDouble(versionstr.substring(versionstr.toLowerCase().indexOf("rev")+3));
  }
  catch(Exception e)
  {
  }
%>
<nav class="vertical"><ul>
<li><span class="first"><a href="#/">Network  +</a></span>
<ul>
<li><span class="first"><a href="#/">IP Config +</a></span>
<ul>
<li><span class="first"><a href="#/">Address Config +</a></span>
<ul>
<li><span class="second"><a href='javascript:openInFrame("eth0.jsp?slnumber=<%=slnumber%>")'>ETH 0</a></span></li>
<li><span class="second"><a href='javascript:openInFrame("wan.jsp?slnumber=<%=slnumber%>")'>WAN</a></span></li>
<li><span class="second"><a href='javascript:openInFrame("loopback.jsp?slnumber=<%=slnumber%>")'>Loopback IP</a></span></li>
<li><span class="second"><a href='javascript:openInFrame("dialer.jsp?slnumber=<%=slnumber%>")'>Dialer</a></span></li>
</ul>
</li>
<li><span class="first"><a href="#/">NAT Config+</a></span>
<ul>
<li><span class="second"><a href='javascript:openInFrame("nat.jsp?slnumber=<%=slnumber%>")'>NAT</a></span></li>
<li><span class="second"><a href='javascript:openInFrame("portforward.jsp?slnumber=<%=slnumber%>")'>Port Forwarding</a></span></li>
</ul>
</li>
<li><span class="first"><a href='javascript:openInFrame("dns.jsp?slnumber=<%=slnumber%>")'>DNS</a></span></li>
<li><span class="first"><a href="#/">SNMP Config+</a></span>
<ul>
<li><span class="second"><a href='javascript:openInFrame("snmp.jsp?slnumber=<%=slnumber%>")'>System</a></span></li>
<li><span class="second"><a href='javascript:openInFrame("traps.jsp?slnumber=<%=slnumber%>")'>Traps</a></span></li>
</ul>
</li>

<li><span class="first"><a href="#/">IPSEC Config+</a></span>
<ul>
<li><span class="second"><a href='javascript:openInFrame("ipsec_select.jsp?slnumber=<%=slnumber%>&version=<%=versionstr%>")'>IPSec</a></span></li>
<li><span class="second"><a href='javascript:openInFrame("ipsec_tracking.jsp?slnumber=<%=slnumber%>&version=<%=versionstr%>")'>IPSec Tracking</a></span></li>
<li><span class="second"><a href='javascript:openInFrame("autofallback.jsp?slnumber=<%=slnumber%>&version=<%=versionstr%>")'>Auto-fallback</a></span></li>
<!-- <li><span class="second"><a href='javascript:openInFrame("domainnamestatus.jsp?slnumber=<%=slnumber%>")'>Domain Name Status</a></span></li> -->
</ul>
</li>


<li><span class="first"><a href='javascript:openInFrame("sla.jsp?slnumber=<%=slnumber%>")'>IP SLA</a></span></li>
<li><span class="first"><a href='javascript:openInFrame("m2m_config.jsp?slnumber=<%=slnumber%>")'>M2M Config</a></span></li>
<li><span class="first"><a href='javascript:openInFrame("static_routing.jsp?slnumber=<%=slnumber%>")'>Static Routing</a></span></li>
</ul>
</li>
<%if(versionstr.trim().endsWith("1.8.1")) {%>
<li><span class="first"><a href='javascript:openInFrame("cellular1.8.1.jsp?slnumber=<%=slnumber%>&version=<%=versionstr%>")'>Cellular</a></span></li>
<%} else {%>
<li><span class="first"><a href='javascript:openInFrame("cellular.jsp?slnumber=<%=slnumber%>&version=<%=versionstr%>")'>Cellular</a></span></li>
<%}%>
<li><span class="first"><a href='javascript:openInFrame("sms_config.jsp?slnumber=<%=slnumber%>")'>SMS Config</a></span></li>
<li><span class="first"><a href='javascript:openInFrame("http_config.jsp?slnumber=<%=slnumber%>")'>HTTP Config</a></span></li>
<%if(versionstr.trim().endsWith("1.8.1")) {%>
<li><span class="first"><a href='javascript:openInFrame("dhcpserver.jsp?slnumber=<%=slnumber%>")'>DHCP Server</a></span></li>
<%} else if(versionstr.trim().endsWith("1.8")){%>
<li><span class="first"><a href='javascript:openInFrame("dhcpserver.jsp?slnumber=<%=slnumber%>")'>DHCP Server</a></span></li>
<%}%>
<!-- <li><span class="first"><a href="#/">Diagnostics+</a></span>
<ul>
<li><span class="second"><a href='javascript:openInFrame("/cgi/Nomus.cgi?cgi=ping.cgi")'>Ping</a></span></li>
<li><span class="second"><a href='javascript:openInFrame("/cgi/Nomus.cgi?cgi=Traceroute.cgi")'>TraceRoute</a></span></li>
</ul>
</li>-->
</ul>
</li>
<li><span class="first"><a href="#/">System+</a></span>
<ul>
<%if(versionstr.trim().endsWith("1.8.1")) {%>
<li><span class="second"><a href='javascript:openInFrame("time_date1.8.1.jsp?slnumber=<%=slnumber%>&version=<%=versionstr%>")'>Clock</a></span></li>
<%} else if(versionstr.trim().endsWith("1.8")){%>
<li><span class="second"><a href='javascript:openInFrame("time_date.jsp?slnumber=<%=slnumber%>&version=<%=versionstr%>")'>Date And Time Config</a></span></li>
<%}%>
<li><span class="second"><a href='javascript:openInFrame("user_config.jsp?slnumber=<%=slnumber%>")'>Users</a></span></li>
<!--<li><span class="second"><a href='javascript:openInFrame("/cgi/Nomus.cgi?cgi=reboot.cgi")'>Reboot</a></span></li>-->
<li><span class="second"><a href='javascript:openInFrame("product_type.jsp?slnumber=<%=slnumber%>")'>Product Type</a></span></li>
<!--<li><span class="second"><a href='javascript:openInFrame("/cgi/Nomus.cgi?cgi=Factory.cgi")'>Factory Defaults</a></span></li>
<li><span class="first"><a href="#/">Firmware Upgrade+</a></span>
<ul>
<li><span class="second"><a href='javascript:openInFrame("/cgi/Nomus.cgi?cgi=Firmware.cgi")'>SCP File Transfer</a></span></li>

<li><span class="second"><a href='javascript:openInFrame("/cgi/Nomus.cgi?cgi=HttpFileTransfer.cgi")'>HTTP File Transfer</a></span></li>
</ul>
</li>-->
</ul>
</li>
<%if(versionstr.endsWith("1.8.1") || version >=1.7){%>
<li><span class="first"><a href="#/">Status+</a></span>
<ul>
<!--<li><span class="second"><a href='javascript:openInFrame("/cgi/Nomus.cgi?cgi=Status.cgi")'>System</a></span></li>
<li><span class="second"><a href='javascript:openInFrame("/cgi/Nomus.cgi?cgi=DataUsage.cgi")'>Data Usage</a></span></li>-->
<li><span class="second"><a href='javascript:openInFrame("ipsecstatus.jsp?slnumber=<%=slnumber%>")'>IPsec Status</a></span></li>
<!--<li><span class="second"><a href='javascript:openInFrame("/cgi/Nomus.cgi?cgi=dhcpstatus.cgi")'>DHCP</a></span></li>-->
</ul>
</li>
<%}%>
<!--<li><span class="first"><a href="#/">Debugs+</a></span>
<ul>
<li><span class="second"><a href='javascript:openInFrame("/cgi/Nomus.cgi?cgi=Debug_Activation.cgi")'>Activation</a></span></li>	
<li><span class="second"><a href='javascript:openInFrame("/cgi/Nomus.cgi?cgi=PPP_Debugs.cgi")'>PPP</a></span></li>
<li><span class="second"><a href='javascript:openInFrame("/cgi/Nomus.cgi?cgi=IPSEC_Debugs.cgi")'>IPSec</a></span></li>
<li><span class="second"><a href='javascript:openInFrame("/cgi/Nomus.cgi?cgi=m2mlogs.cgi")'>M2M</a></span></li>
</ul>
</li>-->
<!-- <li><span class="first"><a href='javascript:openInFrame("Logout.jsp?slnumber=<%=slnumber%>")'>Exit</a></span></li> -->

</body>
<script language="javascript" type="text/javascript">
var allSpan = document.getElementsByTagName('SPAN');
for(var i = 0; i < allSpan.length; i++)
{
	allSpan[i].onclick=function()
	{
		if(this.parentNode)
		{
			var childList = this.parentNode.getElementsByTagName('ul');
			for(var j = 0; j< childList.length;j++)
			{
				var currentState = childList[j].style.display;
				if(currentState=="none" || currentState =="")
				{
					childList[j].style.display="block";
					this.innerHTML=this.innerHTML.replace("+","-");
					break;
				}
				else
				{
					childList[j].style.display="none";
					this.innerHTML=this.innerHTML.replace("-","+");
					break;
				}
			}
		}
	}
}
</script>
</html>
