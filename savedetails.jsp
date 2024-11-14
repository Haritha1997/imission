<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.apache.tomcat.dbcp.pool2.impl.BaseGenericObjectPool"%>
<%@page import="com.fasterxml.jackson.databind.jsonFormatVisitors.JsonObjectFormatVisitor"%>
<%@page import="javax.swing.event.SwingPropertyChangeSupport"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="com.nomus.staticmembers.InterfaceOverlaps"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="org.apache.commons.net.util.SubnetUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Set"%>
<%@page import="java.awt.SecondaryLoop"%>
<%@page import="java.sql.Savepoint"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.Vector"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>
<head>
<script type="text/javascript" src="js/common.js"></script>
</head>
<!--

//-->
</script>
<%
   JSONObject wizjsonnode = null;
   String overlapintf = ""; 
   JSONObject cellularobj = null;
   JSONObject sim1obj = null;
   JSONObject sim2obj = null;
   JSONObject sim1dataobj = null;
   JSONObject sim2dataobj = null;
 
   File jsonfile = null;
   String instname="";
   boolean internal_err = false;
   BufferedReader jsonfilebr = null;   
   String slnumber=request.getParameter("slnumber");
   String pagename=request.getParameter("page");
   String fmversion=request.getParameter("version");
   String procpage = "";
   String showdiv = "";
   String peername="";
   String intfacename="";
   int save_val = 0;
   final  int LANCONFIG = 1;
   final  int WANCONFIG = 2;
   final  int LOOPBACK= 3;
   final  int NAT = 4;
   final  int PORT_FARWARD = 5;
   final  int CELLULAR = 6;
   final  int DEFAULT_CONFIG = 7;
   final  int SAVE_CONFIG = 8;
   final  int IPSEC_CONFIG= 9;
   final  int IPSLA_CONFIG = 10;
   final  int SMS_CONFIG = 11;
   final  int FW_UPGRADE= 12;
   final  int REBOOT = 13;
   final  int PWD_CONFIG = 14;
   final  int SNMP_CONFIG = 15;
   final  int TRAP_CONFIG = 16;
   final  int ADDUSER = 17;
   final  int DELUSER = 18;
   final  int EDITUSER = 19;
   final  int HTTPPORT = 20;
   final  int DNS = 21;
   final  int IPSECTRACK = 22;
   final  int DIALER = 23;
   final  int PRODUCT_TYPE = 24;
   final  int STATIC_ROUTING = 25;
   final  int AUTOFALLBACK = 26;
   final  int IPSEC_DELETE = 27;
   final  int IPSEC_APPLY = 28;
   final int M2M_CONFIG = 29;
   final int DHCP_CONFIG = 30;
   final int DATE_TIME = 31;
   final  int LAST = 32;
   final  int GENERALSETTINGS = 33;
   final  int SYSTEM = 34;
   final  int LOGGING = 35;
   final  int TRAFFICRULES = 36;
   final int HTTP = 37;
   final int NTP_CONFIG = 38;
   final int REMOTE=39;
   final int SMSCONFIG=40;
   final int PWD=41;
   final int SEH_REBOOT=42;
   final int WIFI_CONFIG=43;
   final int DYNAMIC_ROUTING=44;
   final int IPPREFIXLIST=45;
   final int BGP=46;
   final int OPENVPN=47;
   final int ZEROTIER=48;
   final int GRE=49;
   final int LOADBALANCING=50;
   if(slnumber != null && slnumber.trim().length() > 0 && pagename != null)
   {
	   Properties m2mprops = M2MProperties.getM2MProperties();
	   String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
	   jsonfile = new File(slnumpath+File.separator+"Config.json");
	   jsonfilebr = new BufferedReader(new FileReader(jsonfile));
	   StringBuilder jsonbuf = new StringBuilder("");
	   String jsonString="";
	   try
	   {
   		  while((jsonString = jsonfilebr.readLine())!= null)
   			  jsonbuf.append( jsonString );
			
		  wizjsonnode= JSONObject.fromObject(jsonbuf.toString());
	   }
	   catch(Exception e)
	   {
		   e.printStackTrace();
		   internal_err = true;
	   }
	   finally
	   {
		   if(jsonfilebr != null)
			   jsonfilebr.close();
	   }
   }
%>
<html>
<head>
<script type="text/javascript">
function goToPage(page,errorname,msg,slnumber)
{
	//alert("proc page is "+page+" and error is : "+msg);
	if (page.includes("tunnelconfig") || page.includes("user_config") 
		|| page.includes("time_date") || page.includes("cellular")) {
			if (errorname.length > 0) {
				var url = page + "&" + errorname + "=" + msg + "&slnumber="
						+ slnumber;
				//alert("url is "+url);
				top.frames[3].src = url;
				this.src = url;
			} else {
				//op.frames[3].src = page + "&slnumber="+ slnumber;
				top.frames[3].src = page + "&slnumber="
				+ slnumber;
				this.src = page + "&slnumber="+ slnumber;
			}
		} else {
			if (errorname.length > 0) {
				var url = page + "?" + errorname + "=" + msg + "&slnumber="
						+ slnumber;
				top.frames[3].src = url;
				this.src = url;
			} else {
				top.frames[3].src = page + "?slnumber="+ slnumber;
				this.src = page + "&slnumber="+ slnumber;
			}
		}
	}
</script>
</head>
<% 
   String errmsg = "";
   if(wizjsonnode != null && !internal_err)
   {   
	   if(pagename.equals("lanconfig"))
	   {
		   procpage = "lanconfig.jsp";
		   save_val = LANCONFIG;
		   JSONObject lanobj = wizjsonnode.getJSONObject("network").getJSONObject("interface:lan");
		   JSONObject landhcpobj = wizjsonnode.getJSONObject("dhcp").getJSONObject("dhcp:lan");
		   JSONObject dnsdhcpobj = wizjsonnode.getJSONObject("dhcp").getJSONObject("dnsmasq:dnsmasq");
		   String ipv4gateway = request.getParameter("ipv4gw");
		   String ipv4broadcast = request.getParameter("ipv4bc");
		   String lanmtu = request.getParameter("mtu");
		   String lanmetric = request.getParameter("metric");
		   String ipv6asgnlth = request.getParameter("ipv6asl");
		   String ipv6cuslen = request.getParameter("assl");
		   String ipv6address = request.getParameter("ipv6adrs");
		   String ipv6gateway = request.getParameter("ipv6gw");
		   String ip6hint=request.getParameter("ipv6agnthnt");
		   String ulaprefix = request.getParameter("ulapfx");
		   
		   String dhcpact = request.getParameter("dhcpActvtn");
		   String dhcpstart = request.getParameter("start");
		   String dhcplimit = request.getParameter("limit");
		   String dhcplestime = request.getParameter("leasetime");
		   String dyndhcp = request.getParameter("dynamicdhcp");
		   String dhcpfrc = request.getParameter("force");
		   String dhcpdns = request.getParameter("dns");
		   String dhcpntmask = request.getParameter("netmask");
		   
           int laniprows = Integer.parseInt(request.getParameter("laniprows"));
           int dnsrows = Integer.parseInt(request.getParameter("dnsrows"));
           int dnsancrows =Integer.parseInt(request.getParameter("dnsancrows"));
           JSONArray lanip_arr = lanobj.getJSONArray("ipaddr");
           JSONArray dns_arr = null;
           JSONArray dns_anc_arr = null;
           
		   if(lanobj.containsKey("dns"))
			   dns_arr = lanobj.getJSONArray("dns");
		   else
			   dns_arr = new JSONArray();
			if(landhcpobj.containsKey("ancdns")) 
				dns_anc_arr = landhcpobj.getJSONArray("ancdns");
			else
				dns_anc_arr = new JSONArray();
		   
           for(int i=lanip_arr.size()-1;i>=0;i--)
           {
        	   lanip_arr.remove(i);
           }
           for(int i=dns_arr.size()-1;i>=0;i--)
           {
        	   dns_arr.remove(i);
           }
           for(int i=dns_anc_arr.size()-1;i>=0;i--)
        	   dns_anc_arr.remove(i);
		   for(int i=2;i<=laniprows;i++)
		   {
			   String ipaddr = request.getParameter("lanip"+i);
			   String subnet = request.getParameter("lansn"+i);
			 
			   if(ipaddr != null && subnet !=null)
			   {
				   if(ipaddr.length() > 0 && subnet.length() > 0 &&(overlapintf = InterfaceOverlaps.getOVerlapingInterface(ipaddr, "lanconfig", wizjsonnode, overlapintf, subnet)).length() > 0)
				   { 
					   errmsg += ipaddr+"/"+subnet+" is a superset to "+overlapintf+"\n";
				   %>
               <script>
				    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
					 </script>
                   <%} 
				     else if(ipaddr.length()>0 && subnet.length() > 0 &&(overlapintf = InterfaceOverlaps.getIPNetworks(ipaddr, "lanconfig", wizjsonnode, overlapintf, subnet,null)).length() > 0)
				     {
					   errmsg += "\'"+ipaddr+"/"+subnet+"\' and "+overlapintf+" are same networks \n";
				   %>
                    <script>
				    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
					 </script>
<%   }
				   else
				   {
					   SubnetUtils sutils = new SubnetUtils(ipaddr,subnet);
						lanip_arr.add(sutils.getInfo().getCidrSignature());
				   }
			 }
		   }
		   for(int i=5;i<=dnsrows;i++)
		   {
			   String dns = request.getParameter("servers"+i);
			   if(dns != null && dns.trim().length() > 0)
			   dns_arr.add(dns);
		   }
		   
			if(ipv4gateway == null || ipv4gateway.length() ==0)
			{
				if(lanobj.containsKey("gateway"))
					lanobj.remove("gateway");
			}
			else			   
			   lanobj.put("gateway",ipv4gateway);
		   if(ipv4broadcast == null || ipv4broadcast.length() ==0)
		   {
			   if(lanobj.containsKey("broadcast"))
				   lanobj.remove("broadcast");
		   }
		   else
			   lanobj.put("broadcast", ipv4broadcast);
		   if(lanmtu == null || lanmtu.length() == 0)
		   {
			   if(lanobj.containsKey("mtu"))
				lanobj.remove("mtu");
		   }
		   else
			   lanobj.put("mtu", lanmtu);
		   if(lanmetric == null || lanmetric.length() == 0)
		   {
			   if(lanobj.containsKey("metric"))
				lanobj.remove("metric");
		   }
		   else
			   lanobj.put("metric", lanmetric);
	    	if(ipv6asgnlth == null || ipv6asgnlth.length() == 0)
			{
				if(lanobj.containsKey("ip6asgn"))
					lanobj.remove("ip6asgn");
			}
	    	else
	    		lanobj.put("ip6asgn",ipv6asgnlth.equals("custom")?ipv6cuslen:ipv6asgnlth);
		    	
			if(ipv6address == null || ipv6address.length() == 0)
			{
				if(lanobj.containsKey("ip6addr"))
					lanobj.remove("ip6addr");
			}
			else
				lanobj.put("ip6addr",ipv6address);
			if(ipv6gateway == null || ipv6gateway.length() == 0)
			{
				if(lanobj.containsKey("ip6gw"))
					lanobj.remove("ip6gw");
			}
			else
				lanobj.put("ip6gw",ipv6gateway);
			if(ulaprefix == null || ulaprefix.length() == 0)
			{
				if(lanobj.containsKey("ulaprefix"))
					lanobj.remove("ulaprefix");
			}
			else
				lanobj.put("ulaprefix",ulaprefix);
			if(ip6hint == null || ip6hint.length() == 0)
			{
				if(lanobj.containsKey("ip6hint"))
					lanobj.remove("ip6hint");
			}
			else
				lanobj.put("ip6hint",ip6hint);
			   lanobj.put("ipaddr", lanip_arr);
			   
			   if(dns_arr.size() > 0)
			   lanobj.put("dns", dns_arr);
			   
		   if(dhcpact!=null)
			   landhcpobj.put("ip4activation","1");
		   else
			   landhcpobj.put("ip4activation","0");
		   
		   if(dhcpstart == null || dhcpstart.length() == 0)
		   {
			   if(landhcpobj.containsKey("start"))
				landhcpobj.remove("start");
		   }
		   else
			   landhcpobj.put("start", dhcpstart);
		   if(dhcplimit == null || dhcplimit.length() == 0)
		   {
			   if(landhcpobj.containsKey("limit"))
				landhcpobj.remove("limit");
		   }
		   else
			   landhcpobj.put("limit", dhcplimit);
		   if(dhcplestime == null || dhcplestime.length()==0)
			   landhcpobj.remove("leasetime");
		   else
			   landhcpobj.put("leasetime", dhcplestime);
			   if(dyndhcp!=null)
				landhcpobj.put("dynamicdhcp","1");  
				else
			   landhcpobj.remove("dynamicdhcp");	
				if(dhcpfrc!=null)
				landhcpobj.put("force","1");
				else
			   landhcpobj.put("force","0");
			if(dhcpdns!=null)
				dnsdhcpobj.put("noreslov","0");
			else
				dnsdhcpobj.put("noreslov","1");
			if(dhcpntmask == null || dhcpntmask.length() == 0)
			{
				if(landhcpobj.containsKey("netmask"))
				landhcpobj.remove("netmask");
			}
			else
			   landhcpobj.put("netmask", dhcpntmask);
			for(int i=8;i<=dnsancrows;i++)
			   {
				   String ancdns = request.getParameter("ip6dns"+i);
				   if(ancdns != null && ancdns.trim().length() > 0)
					   dns_anc_arr.add(ancdns);
			   }
			if(dns_anc_arr.size() > 0)
				   lanobj.put("ancdns", dns_anc_arr);
			   BufferedWriter jsonWriter = null;
			   try
			   {
					jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					jsonWriter.write(wizjsonnode.toString(2));
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
		   }
		   else if(pagename.equals("wanconfig"))
		   {
				procpage = "wanconfig.jsp";
				save_val = WANCONFIG;
				JSONObject wanobj = wizjsonnode.getJSONObject("network").getJSONObject("interface:wan");
				JSONObject generalsetobj = wizjsonnode.getJSONObject("firewall");
				JSONArray interfacesetarr = generalsetobj.getJSONArray("zone")==null ? new JSONArray(): generalsetobj.getJSONArray("zone");
				JSONObject interfacesetwanobj = interfacesetarr.get(0)==null ? new JSONObject(): (JSONObject)interfacesetarr.get(1);	
				String wanact = request.getParameter("activation");
				String intfType=request.getParameter("device");
				JSONArray wandevicearr=new JSONArray();
				if(interfacesetwanobj.containsKey("device"))
					interfacesetwanobj.remove("device");
				if(wanact!=null)
					wanobj.put("enabled","1");
					else
						wanobj.put("enabled","0");
				if(intfType!=null)
					wanobj.put("intfType",intfType);
				if(intfType.equals("eth1"))
				{
					wanobj.put("ifname","eth1");
					wandevicearr.add("eth1");
					interfacesetwanobj.put("device",wandevicearr);
				}
				else
				{
					wanobj.put("ifname","eth0.2");
					wandevicearr.add("eth0.2");
					interfacesetwanobj.put("device",wandevicearr);
				}
				String wanproto = request.getParameter("wanproto");
				wanobj.put("proto", wanproto.length()>0?wanproto:wanobj.getString("proto"));
				String statickeys[] = {"ipaddr","gateway","broadcast","mtu","metric","dns","ip6asgn","ip6addr","ip6gw","ip6hint"};
				String dhcpkeys[] = {"hostname","clientid","vendorid","mtu","metric","defaultroute","peerdns","dns"};
				String pppoekeys[] = {"username","password","auth","ac","service","mtu","metric","defaultroute","peerdns","dns"};
				String dhcp6keys[] = {"mtu","metric","peerdns","dns"};
 				if(wanproto.equals("static"))
				{
					
					for(int i=0;i<dhcpkeys.length;i++)
					{
						if(wanobj.containsKey(dhcpkeys[i]))
						{
							wanobj.remove(dhcpkeys[i]);
						}
					}
					for(int i=0;i<pppoekeys.length;i++)
					{
						if(wanobj.containsKey(pppoekeys[i]))
						{
							wanobj.remove(pppoekeys[i]);
						}
					}
					for(int i=0;i<dhcp6keys.length;i++)
					{
						if(wanobj.containsKey(dhcp6keys[i]))
						{
							wanobj.remove(dhcp6keys[i]);
						}
					}
					String staipv4gw = request.getParameter("ipv4gw");
					String stabrcast = request.getParameter("ipv4bc");
					String stamtu = request.getParameter("staticmtu");
					String stametric = request.getParameter("staticmetric");
					String staip6asgn = request.getParameter("ipv6asl");
					String staip6addr = request.getParameter("ipv6adrs");
					String staip6gw = request.getParameter("ipv6gw");
					String ipv6hint = request.getParameter("ipv6agnthnt");
					
					int waniprows = Integer.parseInt(request.getParameter("waniprows"));
					int dnsstarows = Integer.parseInt(request.getParameter("dnsstarows"));
					JSONArray wanip_arr = null;
					if(wanobj.containsKey("ipaddr"))
					wanip_arr = wanobj.getJSONArray("ipaddr");
					else
						wanip_arr = new JSONArray();
					JSONArray sta_dns_arr = null;
					if(wanobj.containsKey("dns") && wanproto.equals("static"))
					sta_dns_arr = wanobj.getJSONArray("dns");
					else
					sta_dns_arr = new JSONArray();
		   
					for(int i=wanip_arr.size()-1;i>=0;i--)
					{
						wanip_arr.remove(i);
					}
					for(int i=sta_dns_arr.size()-1;i>=0;i--)
					{
						sta_dns_arr.remove(i);
					}
					for(int i=2;i<=waniprows;i++)
					{
						String ipaddr = request.getParameter("wanip"+i);
						String subnet = request.getParameter("wansn"+i);
			   
						if(ipaddr != null && subnet!=null && ipaddr.trim().length() > 6 && subnet.trim().length() >8)
						{
						 if(ipaddr.length() > 0 && subnet.length() > 0 &&(overlapintf = InterfaceOverlaps.getOVerlapingInterface(ipaddr, "wanconfig", wizjsonnode, overlapintf, subnet)).length() > 0)
						   { 
							 errmsg += ipaddr+"/"+subnet+" is a superset to "+overlapintf+"\n";
						   %>
<script>
						    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
							 </script>
<%} 
						 else if(ipaddr.length()>0 && subnet.length() > 0 &&(overlapintf = InterfaceOverlaps.getIPNetworks(ipaddr, "wanconfig", wizjsonnode, overlapintf, subnet,wanact)).length() > 0)
						   {
							   errmsg += "'"+ipaddr+"/"+subnet+"' and "+overlapintf+" are same networks \n";
							   %>
<script>
						    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
						    
							 </script>
<%   }
						 else
						 {
							 SubnetUtils sutils = new SubnetUtils(ipaddr,subnet);
							 wanip_arr.add(sutils.getInfo().getCidrSignature());
						 }
						 }
					}
					for(int i=5;i<=dnsstarows;i++)
					{
						String dns = request.getParameter("serversstatic"+i);
						if(dns != null && dns.trim().length() > 0)
						sta_dns_arr.add(dns);
					}
					
					if(staipv4gw == null || staipv4gw.length() ==0)
					{
						if(wanobj.containsKey("gateway"))
						wanobj.remove("gateway");
					}
					else			   
					wanobj.put("gateway",staipv4gw);
				
					if(stabrcast == null || stabrcast.length() ==0)
					{
						if(wanobj.containsKey("broadcast"))
						wanobj.remove("broadcast");
					}
					else
					wanobj.put("broadcast", stabrcast);
				
					if(stamtu == null || stamtu.length() == 0)
					{	
						if(wanobj.containsKey("mtu"))
						wanobj.remove("mtu");
					}
					else
					wanobj.put("mtu", stamtu);
				
					if(stametric == null || stametric.length() == 0)
					{
						if(wanobj.containsKey("metric"))
						wanobj.remove("metric");
					}
					else
					wanobj.put("metric", stametric);
					if(staip6asgn == null || staip6asgn.length() == 0)
					{
						if(wanobj.containsKey("ip6asgn"))
							wanobj.remove("ip6asgn");
					}
					else
						wanobj.put("ip6asgn", staip6asgn);
					if(staip6addr == null || staip6addr.length() == 0)
					{
						if(wanobj.containsKey("ip6addr"))
							wanobj.remove("ip6addr");
					}
					else
						wanobj.put("ip6addr", staip6addr);
					if(staip6gw == null || staip6gw.length() == 0)
					{
						if(wanobj.containsKey("ip6gw"))
							wanobj.remove("ip6gw");
					}
					else
						wanobj.put("ip6gw", staip6gw);
					if(ipv6hint == null || ipv6hint.length() == 0)
					{
						if(wanobj.containsKey("ip6hint"))
							wanobj.remove("ip6hint");
					}
					else
						wanobj.put("ip6hint", ipv6hint);
					wanobj.put("ipaddr", wanip_arr);
					if(sta_dns_arr.size() > 0)
					wanobj.put("dns", sta_dns_arr);
		   
				}
				else if(wanproto.equals("dhcp"))
				{
					
					for(int i=0;i<statickeys.length;i++)
					{
						if(wanobj.containsKey(statickeys[i]))
						{
							wanobj.remove(statickeys[i]);
						}
					}
					
					for(int i=0;i<pppoekeys.length;i++)
					{
						if(wanobj.containsKey(pppoekeys[i]))
						{
							wanobj.remove(pppoekeys[i]);
						}
					}
					for(int i=0;i<dhcp6keys.length;i++)
					{
						if(wanobj.containsKey(dhcp6keys[i]))
						{
							wanobj.remove(dhcp6keys[i]);
						}
					}
					
					String hostname = request.getParameter("hostname");
					String clientid = request.getParameter("clientid");
					String vendorid = request.getParameter("vendorid");
					String dhcpmtu = request.getParameter("dhcpmtu");
					String dhcpmetric = request.getParameter("dhcpmetric");
					String defaultroute = request.getParameter("dhcpdfltrte");
					String dhcpcusdns = request.getParameter("dhcpautodns");
					
					int dnsdhcprows = Integer.parseInt(request.getParameter("dnsdhcprows"));
					JSONArray dhcp_dns_arr = null;
					if(wanobj.containsKey("dns") && wanproto.equals("dhcp"))
					dhcp_dns_arr = wanobj.getJSONArray("dns");
					else
					dhcp_dns_arr = new JSONArray();
					
					for(int i=dhcp_dns_arr.size()-1;i>=0;i--)
					{
						dhcp_dns_arr.remove(i);
					}
					
					for(int i=8;i<=dnsdhcprows;i++)
					{
						String dns = request.getParameter("serversdhcp"+i);
						if(dns != null && dns.trim().length() > 0)
						dhcp_dns_arr.add(dns);
					}
					
					if(hostname == null || hostname.length() ==0)
					{
						if(wanobj.containsKey("hostname"))
						wanobj.remove("hostname");
					}
					else			   
					wanobj.put("hostname",hostname);
				
					if(clientid == null || clientid.length() ==0)
					{
						if(wanobj.containsKey("clientid"))
						wanobj.remove("clientid");
					}
					else			   
					wanobj.put("clientid",clientid);
				
					if(vendorid == null || vendorid.length() ==0)
					{
						if(wanobj.containsKey("vendorid"))
						wanobj.remove("vendorid");
					}
					else			   
					wanobj.put("vendorid",vendorid);
				
					if(dhcpmtu == null || dhcpmtu.length() ==0)
					{
						if(wanobj.containsKey("mtu"))
						wanobj.remove("mtu");
					}
					else			   
					wanobj.put("mtu",dhcpmtu);
				
					if(dhcpmetric == null || dhcpmetric.length() ==0)
					{
						if(wanobj.containsKey("metric"))
						wanobj.remove("metric");
					}
					else			   
					wanobj.put("metric",dhcpmetric);
				
					if(defaultroute!=null)
					wanobj.put("defaultroute","1");
					else
					wanobj.put("defaultroute","0");
					
					if(dhcpcusdns!=null)
					wanobj.put("peerdns","1");
					else
					wanobj.put("peerdns","0");
				
					if(dhcp_dns_arr.size() > 0)
					wanobj.put("dns", dhcp_dns_arr);
				
				}
				
				else if(wanproto.equals("pppoe"))
				{
					
					for(int i=0;i<statickeys.length;i++)
					{
						if(wanobj.containsKey(statickeys[i]))
						{
							wanobj.remove(statickeys[i]);
						}
					}
					
					for(int i=0;i<dhcpkeys.length;i++)
					{
						if(wanobj.containsKey(dhcpkeys[i]))
						{
							wanobj.remove(dhcpkeys[i]);
						}
					}
					for(int i=0;i<dhcp6keys.length;i++)
					{
						if(wanobj.containsKey(dhcp6keys[i]))
						{
							wanobj.remove(dhcp6keys[i]);
						}
					}
					wanobj.remove("ipaddr");
					String username = request.getParameter("uname");
					String password = request.getParameter("pass");
					String pppauth = request.getParameter("ppp_auth");
					String acsct = request.getParameter("accessConcent");
					String servicename = request.getParameter("service");
					String pppmtu = request.getParameter("pppoemtu");
					String pppmetric = request.getParameter("pppoemetric");
					String deftroute = request.getParameter("pppoedfltrte");
					String pppcusdns = request.getParameter("dnsauto2");
					
					int dnspppoerows = Integer.parseInt(request.getParameter("dnspppoerows"));
					JSONArray pppoe_dns_arr = null;
					if(wanobj.containsKey("dns") && wanproto.equals("pppoe"))
					pppoe_dns_arr = wanobj.getJSONArray("dns");
					else
					pppoe_dns_arr = new JSONArray();
					
					for(int i=pppoe_dns_arr.size()-1;i>=0;i--)
					{
						pppoe_dns_arr.remove(i);
					}
					
					for(int i=10;i<=dnspppoerows;i++)
					{
						String dns = request.getParameter("serverspppoe"+i);
						if(dns != null && dns.trim().length() > 0)
						pppoe_dns_arr.add(dns);
					}
					
					
					if(username == null || username.length() ==0)
					{
						if(wanobj.containsKey("username"))
						wanobj.remove("username");
					}
					else			   
					wanobj.put("username",username);
				
					if(password == null || password.length() ==0)
					{
						if(wanobj.containsKey("password"))
						wanobj.remove("password");
					}
					else			   
					wanobj.put("password",password);
				
					wanobj.put("auth", pppauth.length()>0?pppauth:wanobj.getString("auth"));
				
					if(acsct == null || acsct.length() ==0)
					{
						if(wanobj.containsKey("ac"))
						wanobj.remove("ac");
					}
					else			   
					wanobj.put("ac",acsct);
				
					if(servicename == null || servicename.length() ==0)
					{
						if(wanobj.containsKey("service"))
						wanobj.remove("service");
					}
					else			   
					wanobj.put("service",servicename);
				
					if(pppmtu == null || pppmtu.length() ==0)
					{
						if(wanobj.containsKey("mtu"))
						wanobj.remove("mtu");
					}
					else			   
					wanobj.put("mtu",pppmtu);
				
					if(pppmetric == null || pppmetric.length() ==0)
					{
						if(wanobj.containsKey("metric"))
						wanobj.remove("metric");
					}
					else			   
					wanobj.put("metric",pppmetric);
				
					if(deftroute!=null)
					wanobj.put("defaultroute","1");
					else
					wanobj.put("defaultroute","0");
					
					if(pppcusdns!=null)
					wanobj.put("peerdns","1");
					else
					wanobj.put("peerdns","0");
				
					if(pppoe_dns_arr.size() > 0)
					wanobj.put("dns", pppoe_dns_arr);
				
				}
				else if(wanproto.equals("dhcpv6"))
				{
					for(int i=0;i<statickeys.length;i++)
					{
						if(wanobj.containsKey(statickeys[i]))
						{
							wanobj.remove(statickeys[i]);
						}
					}
					
					for(int i=0;i<dhcpkeys.length;i++)
					{
						if(wanobj.containsKey(dhcpkeys[i]))
						{
							wanobj.remove(dhcpkeys[i]);
						}
					}
					for(int i=0;i<pppoekeys.length;i++)
					{
						if(wanobj.containsKey(pppoekeys[i]))
						{
							wanobj.remove(pppoekeys[i]);
						}
					}
					wanobj.remove("ipaddr");
					String dhcp6mtu = request.getParameter("dhcp6cmtu");
					String dhcp6metric = request.getParameter("dhcp6cmetric");
					String dhcp6dns = request.getParameter("dnssvractv");
					int dnsdhcp6rows = Integer.parseInt(request.getParameter("dnsdhcp6rows"));
					JSONArray dhcp6_dns_arr = null;
					if(wanobj.containsKey("dns") && wanproto.equals("dhcpv6"))
						dhcp6_dns_arr = wanobj.getJSONArray("dns");
					else
						dhcp6_dns_arr = new JSONArray();
					
					for(int i=dhcp6_dns_arr.size()-1;i>=0;i--)
					{
						dhcp6_dns_arr.remove(i);
					}
					
					for(int i=1;i<=dnsdhcp6rows;i++)
					{
						String dns = request.getParameter("serversdhcp6c"+i);
						if(dns != null && dns.trim().length() > 0)
							dhcp6_dns_arr.add(dns);
					}
					if(dhcp6mtu == null || dhcp6mtu.length() ==0)
					{
						if(wanobj.containsKey("mtu"))
						wanobj.remove("mtu");
					}
					else			   
					wanobj.put("mtu",dhcp6mtu);
				
					if(dhcp6metric == null || dhcp6metric.length() ==0)
					{
						if(wanobj.containsKey("metric"))
						wanobj.remove("metric");
					}
					else			   
					wanobj.put("metric",dhcp6metric);
					if(dhcp6dns!=null)
						wanobj.put("peerdns","1");
					else
						wanobj.remove("peerdns");
					if(dhcp6_dns_arr.size() > 0)
						wanobj.put("dns", dhcp6_dns_arr);
				}
			   //setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
					jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					jsonWriter.write(wizjsonnode.toString(2));
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
		   }
		   
		   else if(pagename.equals("loopback"))
			{
			   procpage = "loopback.jsp";
			   save_val = LOOPBACK;
			   JSONObject loopbackobj = wizjsonnode.getJSONObject("network").getJSONObject("interface:loopback");

			   String activation = request.getParameter("loopback");
			   
			   int loopbackiprows = Integer.parseInt(request.getParameter("loopbackiprows"));
			   int loopipv6rows = Integer.parseInt(request.getParameter("loopbackipv6rows"));
			   JSONArray loopback_ip_arr = loopbackobj.getJSONArray("ipaddr");
			   JSONArray loopback_ipv6_arr = new JSONArray();
			   if(loopbackobj.get("ip6addr") != null)
				   loopback_ipv6_arr = loopbackobj.getJSONArray("ip6addr");	
			   
			   for(int i=loopback_ip_arr.size()-1;i>=0;i--)
			   {
				   loopback_ip_arr.remove(i);
			   }
			   for(int i=2;i<=loopbackiprows;i++)
			   {
				   String ipaddr = request.getParameter("lanip"+i);
				   String subnet = request.getParameter("lansn"+i);
				   
				   if(ipaddr != null && subnet!=null && ipaddr.trim().length() > 6 && subnet.trim().length() > 8)
				   {
				   if(ipaddr.length() > 0 && subnet.length() > 0 &&(overlapintf = InterfaceOverlaps.getOVerlapingInterface(ipaddr, "loopback", wizjsonnode, overlapintf, subnet)).length() > 0)
				   { 
					   errmsg += ipaddr+"/"+subnet+" is a superset to "+overlapintf+"\n";
				   %>
<script>
				    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
					 </script>
<%} 
				   else if(ipaddr.length()>0 && subnet.length() > 0 &&(overlapintf = InterfaceOverlaps.getIPNetworks(ipaddr, "loopback", wizjsonnode, overlapintf, subnet,activation)).length() > 0)
				   {
					   errmsg += "'"+ipaddr+"/"+subnet+"' and "+overlapintf+" are same networks \n";
					   %>
<script>
				    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
					 </script>
<%   }
				   else
				   {
					   SubnetUtils sutils = new SubnetUtils(ipaddr,subnet);
						loopback_ip_arr.add(sutils.getInfo().getCidrSignature());
				   }
				   }
			    }
			    if(activation !=null)
				   loopbackobj.put("enabled","1");
			    else
			    {
				   if(loopbackobj.get("enabled") != null)
					   loopbackobj.put("enabled","0");
			    }
			   
				   loopbackobj.put("ipaddr", loopback_ip_arr);
				    for(int i=loopback_ipv6_arr.size()-1;i>=0;i--)
				   {
				    	loopback_ipv6_arr.remove(i);
				   }
				   for(int i=2;i<=loopipv6rows;i++)
				   {
					   String ipv6addr = request.getParameter("IPV6"+i);
					   
					   if(ipv6addr != null && ipv6addr.trim().length() != 0)
						   loopback_ipv6_arr.add(ipv6addr);
				   }
				   loopbackobj.put("ip6addr", loopback_ipv6_arr);
			   
				   BufferedWriter jsonWriter = null;
				   try
				   {
						jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
						jsonWriter.write(wizjsonnode.toString(2));
				   }
				   catch(Exception e)
				   {
					   e.printStackTrace();
					   internal_err = true;
				   }
				   finally
				   {
					   if(jsonWriter != null)
					   jsonWriter.close();
				   }
			}
		   
		   else if(pagename.equals("cellular"))
			{
				procpage = "cellular.jsp";
				save_val = CELLULAR;
				JSONObject Sim1obj = wizjsonnode.getJSONObject("cellular").getJSONObject("SIM:sim1");
				JSONObject Sim2obj = wizjsonnode.getJSONObject("cellular").getJSONObject("SIM:sim2");
				JSONObject Simswitchobj = wizjsonnode.getJSONObject("cellular").getJSONObject("common:common");
				JSONObject datausageobj=wizjsonnode.containsKey("DataUsage")?wizjsonnode.getJSONObject("DataUsage"):new JSONObject();
				JSONObject bandwidthobj=datausageobj.containsKey("remaining:bandwidth")?datausageobj.getJSONObject("remaining:bandwidth"):new JSONObject();
				//SIM1 
				String sim1act = request.getParameter("sim1actvn");
				String sim1proto = request.getParameter("sim1cnctntype");
				Sim1obj.put("protocol", sim1proto.length()>0?sim1proto:Sim1obj.getString("protocol"));
				//String sim1pppauth = request.getParameter("sim1pppauth");
				//Sim1obj.put("auth", sim1pppauth.length()>0?sim1pppauth:Sim1obj.getString("auth"));
				String sim1version = request.getParameter("sim1ipversion");
				Sim1obj.put("ipversion", sim1version.length()>0?sim1version:Sim1obj.getString("ipversion"));
					String sim1uname = request.getParameter("sim1usrname");
					String sim1pwd = request.getParameter("sim1pwd");
					//String sim1dialno = request.getParameter("sim1dialno");
					String sim1apn = request.getParameter("sim1apn");
					String sim1autoapn = request.getParameter("sim1autoapn");
					String sim1pincode = request.getParameter("sim1pincode");
					String sim1nw = request.getParameter("sim1ntwrk");
					Sim1obj.put("mode", sim1nw.length()>0?sim1nw:Sim1obj.getString("mode"));
					String sim1mtu = request.getParameter("sim1mtu");
					String sim1metric = request.getParameter("sim1metric");
					String sim1dfltrte = request.getParameter("sim1dfltrte");
					String sim1autodns = request.getParameter("sim1autodns");
					
					int sim1dnsrows = Integer.parseInt(request.getParameter("sim1dnsrows"));
					JSONArray sim1_dns_arr = null;
					if(Sim1obj.containsKey("dns"))
					sim1_dns_arr = Sim1obj.getJSONArray("dns");
					else
					sim1_dns_arr = new JSONArray();
				
					for(int i=sim1_dns_arr.size()-1;i>=0;i--)
					{
						sim1_dns_arr.remove(i);
					}
					for(int i=14;i<=sim1dnsrows;i++)
					{
						String dns = request.getParameter("sim1customdns"+i);
						if(dns != null && dns.trim().length() > 0)
						sim1_dns_arr.add(dns);
					}
					
					if(sim1act!=null)
						Sim1obj.put("enabled","1");
					else
						Sim1obj.put("enabled","0");
				
					if(sim1uname == null || sim1uname.length() ==0)
					{
						if(Sim1obj.containsKey("username"))
							Sim1obj.remove("username");
					}
					else			   
						Sim1obj.put("username",sim1uname);
				
					if(sim1pwd == null || sim1pwd.length() ==0)
					{
						if(Sim1obj.containsKey("password"))
						Sim1obj.remove("password");
					}
					else			   
						Sim1obj.put("password",sim1pwd);
					
					/* if(sim1dialno == null || sim1dialno.length() ==0)
					{
						if(Sim1obj.containsKey("dialnumber"))
						Sim1obj.remove("dialnumber");
					}
					else			   
					Sim1obj.put("dialnumber",sim1dialno);  */
				
					if(sim1apn == null || sim1apn.length() ==0)
					{
						if(Sim1obj.containsKey("apn"))
						Sim1obj.remove("apn");
					}
					else			   
					Sim1obj.put("apn",sim1apn);
				
					if(sim1autoapn!=null)
					Sim1obj.put("autoapn","1");
					else
					Sim1obj.put("autoapn","0");
				
					if(sim1pincode == null || sim1pincode.length() ==0)
					{
						if(Sim1obj.containsKey("pincode"))
						Sim1obj.remove("pincode");
					}
					else			   
					Sim1obj.put("pincode",sim1pincode);
				
					if(sim1mtu == null || sim1mtu.length() ==0)
					{
						if(Sim1obj.containsKey("mtu"))
							Sim1obj.remove("mtu");
					}
					else			   
					Sim1obj.put("mtu",sim1mtu);
				
					if(sim1metric == null || sim1metric.length() ==0)
					{
						if(Sim1obj.containsKey("metric"))
						Sim1obj.remove("metric");
					}
					else			   
					Sim1obj.put("metric",sim1metric);
				
					if(sim1dfltrte!=null)
					Sim1obj.put("defaultroute","1");
					else
					Sim1obj.put("defaultroute","0");
				
					if(sim1autodns!=null)
					Sim1obj.put("autodns","1");
					else
					Sim1obj.put("autodns","0");
				
				if(sim1proto.equals("DHCP"))
				{
					/*if(sim1dialno == null || sim1dialno.length() ==0)
					{
						if(Sim1obj.containsKey("dialnumber"))
						Sim1obj.remove("dialnumber");
					}
					else			   
					Sim1obj.put("dialnumber",sim1dialno); */
				}
				
				if(sim1_dns_arr.size() > 0)
					Sim1obj.put("dns", sim1_dns_arr);	
					
				//Sim2

				String sim2act = request.getParameter("sim2actvn");
				String sim2proto = request.getParameter("sim2cnctntype");
				Sim2obj.put("protocol", sim2proto.length()>0?sim2proto:Sim2obj.getString("protocol"));
				//String sim2pppauth = request.getParameter("sim2pppauth");
				//Sim2obj.put("auth", sim2pppauth.length()>0?sim2pppauth:Sim2obj.getString("auth"));
				String sim2version = request.getParameter("sim2ipversion");
				Sim2obj.put("ipversion", sim2version.length()>0?sim2version:Sim2obj.getString("ipversion"));
					String sim2uname = request.getParameter("sim2usrname");
					String sim2pwd = request.getParameter("sim2pwd");
					String sim2dialno = request.getParameter("sim2dialno");
					String sim2apn = request.getParameter("sim2apn");
					String sim2autoapn = request.getParameter("sim2autoapn");
					String sim2pincode = request.getParameter("sim2pincode");
					String sim2nw = request.getParameter("sim2ntwrk");
					Sim2obj.put("mode", sim2nw.length()>0?sim2nw:Sim2obj.getString("mode"));
					String sim2mtu = request.getParameter("sim2mtu");
					String sim2metric = request.getParameter("sim2metric");
					String sim2dfltrte = request.getParameter("sim2dfltrte");
					String sim2autodns = request.getParameter("sim2autodns");
					
					int sim2dnsrows = Integer.parseInt(request.getParameter("sim2dnsrows"));
					JSONArray sim2_dns_arr = null;
					if(Sim2obj.containsKey("dns"))
					sim2_dns_arr = Sim2obj.getJSONArray("dns");
					else
					sim2_dns_arr = new JSONArray();
				
					for(int i=sim2_dns_arr.size()-1;i>=0;i--)
					{
						sim2_dns_arr.remove(i);
					}
					for(int i=14;i<=sim2dnsrows;i++)
					{
						String dns = request.getParameter("sim2customdns"+i);
						if(dns != null && dns.trim().length() > 0)
						sim2_dns_arr.add(dns);
					}
				
					if(sim2act!=null)
						Sim2obj.put("enabled","1");
					else
						Sim2obj.put("enabled","0");
				
					if(sim2uname == null || sim2uname.length() ==0)
					{
						if(Sim2obj.containsKey("username"))
						Sim2obj.remove("username");
					}
					else			   
					Sim2obj.put("username",sim2uname);
				
					if(sim2pwd == null || sim2pwd.length() ==0)
					{
						if(Sim2obj.containsKey("password"))
						Sim2obj.remove("password");
					}
					else			   
					Sim2obj.put("password",sim2pwd);
					
					/* if(sim2dialno == null || sim2dialno.length() ==0)
					{
						if(Sim2obj.containsKey("dialnumber"))
						Sim2obj.remove("dialnumber");
					}
					else			   
					Sim2obj.put("dialnumber",sim2dialno); */
				
					if(sim2apn == null || sim2apn.length() ==0)
					{
						if(Sim2obj.containsKey("apn"))
						Sim2obj.remove("apn");
					}
					else			   
					Sim2obj.put("apn",sim2apn);
				
					if(sim2autoapn!=null)
					Sim2obj.put("autoapn","1");
					else
					Sim2obj.put("autoapn","0");
				
					if(sim2pincode == null || sim2pincode.length() ==0)
					{
						if(Sim2obj.containsKey("pincode"))
						Sim2obj.remove("pincode");
					}
					else			   
					Sim2obj.put("pincode",sim2pincode);
				
					if(sim2mtu == null || sim2mtu.length() ==0)
					{
						if(Sim2obj.containsKey("mtu"))
						Sim2obj.remove("mtu");
					}
					else			   
					Sim2obj.put("mtu",sim2mtu);
				
					if(sim2metric == null || sim2metric.length() ==0)
					{
						if(Sim2obj.containsKey("metric"))
						Sim2obj.remove("metric");
					}
					else			   
					Sim2obj.put("metric",sim2metric);
				
					if(sim2dfltrte!=null)
					Sim2obj.put("defaultroute","1");
					else
					Sim2obj.put("defaultroute","0");
				
					if(sim2autodns!=null)
					Sim2obj.put("autodns","1");
					else
					Sim2obj.put("autodns","0");
				
				if(sim2proto.equals("DHCP"))
				{
					/* if(sim2dialno == null || sim2dialno.length() ==0)
					{
						if(Sim2obj.containsKey("dialnumber"))
						Sim2obj.remove("dialnumber");
					}
					else			   
					Sim2obj.put("dialnumber",sim2dialno); */
				}
				
				if(sim2_dns_arr.size() > 0)
					Sim2obj.put("dns", sim2_dns_arr);
				
				//SIM Switch
				/* Map<String,String[]> parammap =  request.getParameterMap();
				
				Set<String> parmset = parammap.keySet();
				for(String param : parmset)
					System.out.println("parameter : "+param+" , value is : "+parammap.get(param)); */
				
				String prisim = request.getParameter("psim");
				Simswitchobj.put("master", prisim.length()>0?prisim:Simswitchobj.getString("master"));
				String noretries = request.getParameter("retries");
				String rechkmaster = request.getParameter("recheckmaster");
				String bwact=request.getParameter("actid");
				String sigqutyact=request.getParameter("sqid");
				String dailyact=request.getParameter("daily");
				String monthlyact=request.getParameter("month");
				String dailylimsim1=request.getParameter("limitSim1");
				String dailylimsim2=request.getParameter("limitSim2");
				String moncleansim1=request.getParameter("dateSim1");
				String moncleansim2=request.getParameter("dateSim2");
				if(rechkmaster!=null)
				Simswitchobj.put("recheck","1");
				else
				Simswitchobj.put("recheck","0");
				String recheckpri = request.getParameter("recheckTime");
				
				if(noretries == null || noretries.length() ==0)
					{
						if(Simswitchobj.containsKey("retries"))
						Simswitchobj.remove("retries");
					}
				else			   
					Simswitchobj.put("retries",noretries);
				
				if(recheckpri == null || recheckpri.length() ==0)
					{
						if(Simswitchobj.containsKey("recheckTime"))
							Simswitchobj.put("recheckTime","");
					}
				else			   
					Simswitchobj.put("recheckTime",recheckpri);
				if(sigqutyact!=null)
					Simswitchobj.put("signalquality","1");
				else
					Simswitchobj.put("signalquality","0");
				if(bwact!=null)
					bandwidthobj.put("DataLimit_Exceeded","1");
				else
					bandwidthobj.put("DataLimit_Exceeded","0");
				if(dailyact!=null)
					bandwidthobj.put("DailyLimit","1");
				else
					bandwidthobj.put("DailyLimit","0");
				if(monthlyact!=null)
					bandwidthobj.put("MonthlyLimit","1");
				else
					bandwidthobj.put("MonthlyLimit","0");
				if(dailylimsim1!=null)
					bandwidthobj.put("MaxDataLimit0",dailylimsim1);
				if(dailylimsim2!=null)
					bandwidthobj.put("MaxDataLimit1",dailylimsim2);
				if(moncleansim1!=null)
					bandwidthobj.put("DoMToClean0",moncleansim1);
				if(moncleansim2!=null)
					bandwidthobj.put("DoMToClean1",moncleansim2);
			   //setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
					jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					jsonWriter.write(wizjsonnode.toString(2));
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			}
			else if(pagename.equals("m2mconfig")) 
			{
				procpage = "m2mconfig.jsp";
				save_val = M2M_CONFIG;
				JSONObject m2mobj = wizjsonnode.getJSONObject("m2m").getJSONObject("m2m:m2m");
				
				String m2mact = request.getParameter("activation");
				String m2mintf = request.getParameter("interface");
				m2mobj.put("interface", m2mintf.length()>0?m2mintf:m2mobj.getString("interface"));
				String m2mservr = request.getParameter("server");
				String m2mservrport = request.getParameter("port");
				String m2mpollout = request.getParameter("pollout");
				String m2mtretryout = request.getParameter("timeout");
				String m2mmodelno = request.getParameter("model");
				
				if(m2mact!=null)
					m2mobj.put("enabled","1");
				else
					m2mobj.put("enabled","0");
				
				if(m2mservr == null || m2mservr.length() ==0)
					{
						if(m2mobj.containsKey("server"))
						m2mobj.remove("server");
					}
					else			   
					m2mobj.put("server",m2mservr);
				
				if(m2mservrport == null || m2mservrport.length() ==0)
					{
						if(m2mobj.containsKey("port"))
						m2mobj.remove("port");
					}
					else			   
					m2mobj.put("port",m2mservrport);
				
				if(m2mpollout == null || m2mpollout.length() ==0)
					{
						if(m2mobj.containsKey("pollout"))
						m2mobj.remove("pollout");
					}
					else			   
					m2mobj.put("pollout",m2mpollout);
				
				if(m2mtretryout == null || m2mtretryout.length() ==0)
					{
						if(m2mobj.containsKey("timeout"))
						m2mobj.remove("timeout");
					}
					else			   
					m2mobj.put("timeout",m2mtretryout);
				
				if(m2mmodelno == null || m2mmodelno.length() ==0)
					{
						if(m2mobj.containsKey("model"))
						m2mobj.remove("model");
					}
					else			   
					m2mobj.put("model",m2mmodelno);
			   
			   //setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
					jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					jsonWriter.write(wizjsonnode.toString(2));
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			}
			else if(pagename.equals("system")) 
			{
				procpage = "system.jsp";
				save_val = SYSTEM;
				//Snmp json node
				JSONObject snmpobj =  wizjsonnode.containsKey("snmpd")?wizjsonnode.getJSONObject("snmpd"):new JSONObject();
				JSONArray snmpsys = snmpobj.containsKey("system")?snmpobj.getJSONArray("system"):new JSONArray();
				JSONObject sysobj=new JSONObject();
				for(int i=0;i<snmpsys.size();i++)
				  sysobj=(JSONObject)snmpsys.get(i);
				//ends
				JSONObject systemobj =  wizjsonnode.getJSONObject("system");
				JSONObject syssnmppage =  systemobj.getJSONArray("system")==null ? new JSONObject():systemobj.getJSONObject("snmp:snmp");
				JSONArray systemarr = systemobj.getJSONArray("system")==null ? new JSONArray(): systemobj.getJSONArray("system");	
				JSONObject systempage = null;
				if(systemarr == null)
					systemarr = new JSONArray();
				if(systemarr.size() > 0)
					systempage = systemarr.get(0)==null ? new JSONObject(): (JSONObject)systemarr.get(0);
				else
					systempage = new JSONObject();
				if(syssnmppage.isNullObject())
					syssnmppage = new JSONObject();
				
				String syshostname = request.getParameter("hostname");
				/* String systimefrmt = request.getParameter("tformat");
				String systimezone = request.getParameter("timezone"); */
				if(syshostname != null && syshostname.length() > 0)
				{
					systempage.put("hostname",syshostname);
					syssnmppage.put("sysName",syshostname);
					sysobj.put("sysName",syshostname);
				}
				else
				{
					systempage.put("hostname","");
					syssnmppage.put("sysName","");
					sysobj.put("sysName","");
				}
					
				/* if(systimefrmt != null && systimefrmt.length() > 0)
					systempage.put("timeformat",systimefrmt);
				else if(systempage.containsKey("timeformat"))
					systempage.remove("timeformat");
				
				if(systimezone != null && systimezone.length() > 0)
					systempage.put("zonename",systimezone);
				else if(systempage.containsKey("zonename"))
					systempage.remove("zonename"); */
				
			   //setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
					jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					jsonWriter.write(wizjsonnode.toString(2));
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			}
			else if(pagename.equals("logging")) 
			{
				procpage = "logging.jsp";
				save_val = LOGGING;
				String syslog = "/syslog/system.log";
				JSONObject systemobj =  wizjsonnode.getJSONObject("system");
				JSONArray systemarr = systemobj.getJSONArray("system")==null ? new JSONArray(): systemobj.getJSONArray("system");	
				JSONObject systempage = systemarr.get(0)==null ? new JSONObject(): (JSONObject)systemarr.get(0);
				String lcllogging = request.getParameter("logging");
				String buffersize = request.getParameter("logbufrsize");
				String rmtlogging = request.getParameter("log_remote");
				String extlogserver = request.getParameter("logserver");
				String extlogserverport = request.getParameter("logservrport");		
				String extlogserverproto = request.getParameter("logservrprotocol");			
				String logoutputlvl = request.getParameter("logotptlvl");			
				String cronloglvl = request.getParameter("cronloglevl");			
				String cellularppplog = request.getParameter("ppploglevel");
				String wanpppoelog = request.getParameter("pppoeloglevel");
				String ipseclog = request.getParameter("ipsecloglevel");

				if(lcllogging!=null)
				systempage.put("log_file","/syslog/system.log");
				else
				systempage.remove("log_file");
			
				if(buffersize == null || buffersize.length() ==0)
				{
					if(systempage.containsKey("log_size"))
					systempage.remove("log_size");
				}
				else			   
				systempage.put("log_size",buffersize);
			
				if(rmtlogging!=null)
				systempage.put("log_remote","1");
				else
				systempage.put("log_remote","0");
			   
			   if(extlogserver == null || extlogserver.length() ==0)
				{
					if(systempage.containsKey("log_ip"))
					systempage.remove("log_ip");
				}
				else			   
				systempage.put("log_ip",extlogserver);
			
				if(extlogserverport == null || extlogserverport.length() ==0)
				{
					if(systempage.containsKey("log_port"))
					systempage.remove("log_port");
				}
				else			   
				systempage.put("log_port",extlogserverport);
			   
			   systempage.put("log_proto", extlogserverproto.length()>0?extlogserverproto:systempage.getString("log_proto"));
			   systempage.put("conloglevel", logoutputlvl.length()>0?logoutputlvl:systempage.getString("conloglevel"));
			   systempage.put("cronloglevel", cronloglvl.length()>0?cronloglvl:systempage.getString("cronloglevel"));
			   
			   if(cellularppplog!=null)
				systempage.put("ppploglevel","1");
				else
				systempage.put("ppploglevel","0");
			
				if(wanpppoelog!=null)
				systempage.put("pppoeloglevel","1");
				else
				systempage.put("pppoeloglevel","0");
			
				systempage.put("ipsecloglevel", ipseclog.length()>0?ipseclog:systempage.getString("ipsecloglevel"));
			   
			   //setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
					jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					jsonWriter.write(wizjsonnode.toString(2));
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			}
			else if(pagename.equals("generalsettings")) 
			{
				procpage = "generalsettings.jsp";
				save_val = GENERALSETTINGS;
				boolean newobj=false;
				JSONObject generalsetobj = wizjsonnode.getJSONObject("firewall");
				JSONArray generalsetarr = generalsetobj.getJSONArray("defaults")==null ? new JSONArray(): generalsetobj.getJSONArray("defaults");
				JSONObject generalsetpage = generalsetarr.get(0)==null ? new JSONObject(): (JSONObject)generalsetarr.get(0);
				JSONArray interfacesetarr = generalsetobj.getJSONArray("zone")==null ? new JSONArray(): generalsetobj.getJSONArray("zone");
				JSONObject interfacesetlanobj = interfacesetarr.get(0)==null ? new JSONObject(): (JSONObject)interfacesetarr.get(0);	
				JSONObject interfacesetwanobj = interfacesetarr.get(0)==null ? new JSONObject(): (JSONObject)interfacesetarr.get(1);	
				JSONObject interfacesetcellularobj = interfacesetarr.get(0)==null ? new JSONObject(): (JSONObject)interfacesetarr.get(2);
				JSONObject zerotierobj=wizjsonnode.containsKey("zerotier")?wizjsonnode.getJSONObject("zerotier"):new JSONObject();
				JSONObject ztsample_configobj=zerotierobj.containsKey("zerotier:sample_config")?zerotierobj.getJSONObject("zerotier:sample_config"):new JSONObject();
				String enable=ztsample_configobj.containsKey("enabled")?ztsample_configobj.getString("enabled"):"";
				if(enable.equals("1"))
				{
				JSONObject interfacesetzerotireobj=interfacesetarr.size()==3&&interfacesetarr.get(0)==null?new JSONObject():(interfacesetarr.size()>3&&interfacesetarr.get(3)!=null)?(JSONObject)interfacesetarr.get(3):new JSONObject();	
				if(interfacesetzerotireobj.isEmpty())
					newobj=true;
				String zerotierinput = request.getParameter("inputZeroTier");
			   String zerotieroutput = request.getParameter("outputZeroTier");
			   String zerotierforward = request.getParameter("forwardZeroTier");
			   String zerotiermasq = request.getParameter("masqZeroTier");
			   interfacesetzerotireobj.put("input", zerotierinput.length()>0?zerotierinput:interfacesetzerotireobj.getString("input"));
				interfacesetzerotireobj.put("output", zerotieroutput.length()>0?zerotieroutput:interfacesetzerotireobj.getString("output"));
				interfacesetzerotireobj.put("forward", zerotierforward.length()>0?zerotierforward:interfacesetzerotireobj.getString("forward"));
				if(zerotiermasq!=null)
					interfacesetzerotireobj.put("masq","1");
				else
					interfacesetzerotireobj.put("masq","0");
				
			   //setSaveIndex(wizjsonnode,save_val);
			   if(newobj)
			   {
				   interfacesetzerotireobj.put("name", "zt0");
				   interfacesetzerotireobj.put("network", "zt0");
				   interfacesetarr.add(interfacesetzerotireobj);
			   }
				}
			   String synfld = request.getParameter("firewallprot");
			   String synfldrate = request.getParameter("synflood_rate");
			   String synfldburst = request.getParameter("synflood_burst");
			   String invalidpcts = request.getParameter("invalidpack");
			   String input = request.getParameter("input");
			   String output = request.getParameter("output");
			   String forward = request.getParameter("forward");
			   
			   String laninput = request.getParameter("inputLAN");
			   String lanoutput = request.getParameter("outputLAN");
			   String lanforward = request.getParameter("forwardLAN");
			   String lanmasq = request.getParameter("masqLAN");
			   String waninput = request.getParameter("inputWAN");
			   String wanoutput = request.getParameter("outputWAN");
			   String wanforward = request.getParameter("forwardWAN");
			   String wanmasq = request.getParameter("masqWAN");
			   
			   String cellularinput = request.getParameter("inputCellular");
			   String cellularoutput = request.getParameter("outputCellular");
			   String cellularforward = request.getParameter("forwardCellular");
			   String cellularmasq = request.getParameter("masqCellular");
			   
			   
			   if(synfld!=null)
				generalsetpage.put("syn_flood","1");
				else
				generalsetpage.put("syn_flood","0");
			
				if(synfldrate == null || synfldrate.length() ==0)
				{
					if(generalsetpage.containsKey("synflood_rate"))
					generalsetpage.remove("synflood_rate");
				}
				else			   
				generalsetpage.put("synflood_rate",synfldrate);
			
				if(synfldburst == null || synfldburst.length() ==0)
				{
					if(generalsetpage.containsKey("synflood_burst"))
					generalsetpage.remove("synflood_burst");
				}
				else			   
				generalsetpage.put("synflood_burst",synfldburst);
			
				if(invalidpcts!=null)
				generalsetpage.put("drop_invalid","1");
				else
				generalsetpage.put("drop_invalid","0");
			
				generalsetpage.put("input", input.length()>0?input:generalsetpage.getString("input"));
				generalsetpage.put("output", output.length()>0?output:generalsetpage.getString("output"));
				generalsetpage.put("forward", forward.length()>0?forward:generalsetpage.getString("forward"));
				
				interfacesetlanobj.put("input", laninput.length()>0?laninput:interfacesetlanobj.getString("input"));
				interfacesetlanobj.put("output", lanoutput.length()>0?lanoutput:interfacesetlanobj.getString("output"));
				interfacesetlanobj.put("forward", lanforward.length()>0?lanforward:interfacesetlanobj.getString("forward"));
				if(lanmasq!=null)
				interfacesetlanobj.put("masq","1");
				else
				interfacesetlanobj.put("masq","0");
				if(waninput!=null)
				{
					interfacesetwanobj.put("input", waninput.length()>0?waninput:interfacesetwanobj.getString("input"));
					interfacesetwanobj.put("output", wanoutput.length()>0?wanoutput:interfacesetwanobj.getString("output"));
					interfacesetwanobj.put("forward", wanforward.length()>0?wanforward:interfacesetwanobj.getString("forward"));
				}
				if(wanmasq!=null)
				interfacesetwanobj.put("masq","1");
				else
				interfacesetwanobj.put("masq","0");
				
				interfacesetcellularobj.put("input", cellularinput.length()>0?cellularinput:interfacesetcellularobj.getString("input"));
				interfacesetcellularobj.put("output", cellularoutput.length()>0?cellularoutput:interfacesetcellularobj.getString("output"));
				interfacesetcellularobj.put("forward", cellularforward.length()>0?cellularforward:interfacesetcellularobj.getString("forward"));
				if(cellularmasq!=null)
				interfacesetcellularobj.put("masq","1");
				else
				interfacesetcellularobj.put("masq","0");
				
			   BufferedWriter jsonWriter = null;
			   try
			   {
					jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					jsonWriter.write(wizjsonnode.toString(2));
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			}
			else if(pagename.equals("edit_natrules") || pagename.equals("natrules")) 
			{
				boolean isnewobj = true;
				String instancename = request.getParameter("instancename");
				String action = request.getParameter("action")==null?"":request.getParameter("action");
				if(pagename.equals("edit_natrules"))
					procpage = "natrules.jsp";	
					//procpage = "edit_natrules.jsp";
				else
					procpage = "natrules.jsp";
				save_val = NAT;
				JSONObject firewall =  wizjsonnode.containsKey("firewall")?wizjsonnode.getJSONObject("firewall"):new JSONObject();
				JSONArray edit_natrules_arr =  wizjsonnode.containsKey("firewall")?(wizjsonnode.getJSONObject("firewall").containsKey("nat")?wizjsonnode.getJSONObject("firewall").getJSONArray("nat"):new JSONArray()):new JSONArray();
				JSONObject edit_natrulesobj = new JSONObject();
				JSONArray reindexedit_natrules_arr=new JSONArray();
				int obj_index = -1;
			    for(int i=0;i<edit_natrules_arr.size();i++)
				{
					JSONObject tempobj = edit_natrules_arr.getJSONObject(i);
					if(tempobj.getString("name").equals(instancename))
					{
						edit_natrulesobj = tempobj;
						isnewobj = false;
						obj_index = i;
						break;
					}
				}
				
				if(action.equals("delete") && pagename.equals("natrules"))
				{
					if(obj_index != -1)
					edit_natrules_arr.remove(obj_index);
				}
				else if(pagename.equals("natrules")) {
					int natrows = Integer.parseInt(request.getParameter("trafficrwcnt"));
					String activation=null;
					String instncename= null;
					int natind = 0;
					int index=0;
					String arr[]=null;
					for(int j=1;j<natrows;j++)
						{
							instncename = request.getParameter("instancename"+j);
							
							if(instncename == null)
								continue;
								activation = request.getParameter("activation"+j);
							if(activation==null)
								edit_natrules_arr.getJSONObject(natind++).put("enabled","0");
							else
								edit_natrules_arr.getJSONObject(natind++).put("enabled","1");
						}
				}
				else if(pagename.equals("edit_natrules")){
					/* Enumeration<String> params = request.getParameterNames();
					while(params.hasMoreElements())
					{
						System.out.println(params.nextElement());
					} */
					String activation = request.getParameter("activation");
					
					String outintf = request.getParameter("outbound");
					String protocol_arr[] = request.getParameterValues("proto");
					if(protocol_arr == null)
						protocol_arr = new String[0];
					String srcip = request.getParameter("sipaddress");
					String srcport = request.getParameter("s_port");
					String desip = request.getParameter("dipaddress");
					String desport = request.getParameter("d_port"); 
					action = request.getParameter("action"); 
					String rewrtip = request.getParameter("rewriteip");
					String rewrtport = request.getParameter("rewriteport");
					
					if(activation==null)
					edit_natrulesobj.put("enabled","0");
					else
					edit_natrulesobj.put("enabled","1");
				
					edit_natrulesobj.put("name", instancename.length()>0?instancename:edit_natrulesobj.getString("name"));
					//edit_natrulesobj.put("proto", protocol.length()>0?protocol:edit_natrulesobj.getString("proto"));
					JSONArray json_proto_arr= new JSONArray();
					if(edit_natrulesobj.containsKey("proto"))
					{
						if(protocol_arr.length==0)
						edit_natrulesobj.remove("proto");				
					}
					for(String protocol : protocol_arr)
						json_proto_arr.add(protocol);
					edit_natrulesobj.put("proto",json_proto_arr);
					edit_natrulesobj.put("src", outintf.length()>0?outintf:edit_natrulesobj.getString("src"));
					
					if(srcip == null || srcip.length() ==0)
					{
						if(edit_natrulesobj.containsKey("src_ip"))
						edit_natrulesobj.remove("src_ip");
					}
					else			   
					edit_natrulesobj.put("src_ip",srcip);
				
					if(srcport == null || srcport.length() ==0)
					{
						if(edit_natrulesobj.containsKey("src_port"))
						edit_natrulesobj.remove("src_port");
					}
					else			   
					edit_natrulesobj.put("src_port",srcport);
				
					if(desip == null || desip.length() ==0)
					{
						if(edit_natrulesobj.containsKey("dest_ip"))
						edit_natrulesobj.remove("dest_ip");
					}
					else			   
					edit_natrulesobj.put("dest_ip",desip);
				
					if(desport == null || desport.length() ==0)
					{
						if(edit_natrulesobj.containsKey("dest_port"))
						edit_natrulesobj.remove("dest_port");
					}
					else			   
					edit_natrulesobj.put("dest_port",desport);
				
					edit_natrulesobj.put("target", action.length()>0?action:edit_natrulesobj.getString("target"));
					
					if(rewrtip == null || rewrtip.length() ==0)
					{
						if(edit_natrulesobj.containsKey("snat_ip"))
						edit_natrulesobj.remove("snat_ip");
					}
					else			   
					edit_natrulesobj.put("snat_ip",rewrtip);
				
					if(rewrtport == null || rewrtport.length() ==0)
					{
						if(edit_natrulesobj.containsKey("snat_port"))
						edit_natrulesobj.remove("snat_port");
					}
					else			   
					edit_natrulesobj.put("snat_port",rewrtport);
				   
				   if(isnewobj)
					{
						edit_natrules_arr.add(edit_natrulesobj);
					}
				   
				   //setSaveIndex(wizjsonnode,save_val);
				}
			   BufferedWriter jsonWriter = null;
			   firewall.put("nat",edit_natrules_arr);
			   wizjsonnode.put("firewall",firewall);
			   try
			   {
					jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					jsonWriter.write(wizjsonnode.toString(2));
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			}
			else if(pagename.equals("edit_trafficrules")  || pagename.equals("trafficrules")) 
			{
				boolean isnewobj = true;
				String instancename = request.getParameter("instancename");
				String action = request.getParameter("action")==null?"":request.getParameter("action");
				if(pagename.equals("edit_trafficrules"))
					procpage = "trafficrules.jsp"; 
					//procpage = "edit_trafficrules.jsp";
				else
					procpage = "trafficrules.jsp";
				save_val = TRAFFICRULES;
				JSONArray edit_trafficrules_arr =  wizjsonnode.containsKey("firewall")?(wizjsonnode.getJSONObject("firewall").containsKey("rule")?wizjsonnode.getJSONObject("firewall").getJSONArray("rule"):new JSONArray()):new JSONArray();
			    JSONObject edit_trafficrulespage = new JSONObject();
				int obj_index = -1;
			    for(int i=0;i<edit_trafficrules_arr.size();i++)
				{
					JSONObject tempobj = edit_trafficrules_arr.getJSONObject(i);
					if(tempobj.getString("name").equals(instancename))
					{
						edit_trafficrulespage = tempobj;
						isnewobj = false;
						obj_index = i;
						break;
					}
				}
				if(action.equals("delete") && pagename.equals("trafficrules"))
				{
					if(obj_index != -1)
					edit_trafficrules_arr.remove(obj_index);
				}
				else if(pagename.equals("trafficrules"))
				{
					int trafficrows = Integer.parseInt(request.getParameter("trafficrwcnt"));
					String activation=null;
					String instncename= null;
					String trafaction = null;
					int trafind=0;
					for(int i=1;i<trafficrows;i++)
					{
						instncename = request.getParameter("instancename"+i);
						if(instncename == null)
							continue;
						trafaction = request.getParameter("action"+i);
						edit_trafficrules_arr.getJSONObject(trafind).put("target", trafaction.length()>0?trafaction:edit_trafficrulespage.getString("target"));
						activation = request.getParameter("activation"+i);
						if(activation == null)
							edit_trafficrules_arr.getJSONObject(trafind).put("enabled","0");
						else
							edit_trafficrules_arr.getJSONObject(trafind).put("enabled","1");
						trafind++;
					}
					
				}
				else if(pagename.equals("edit_trafficrules"))
				{
					String activation = request.getParameter("activation");
					
					String protocol_arr[] = request.getParameterValues("proto");
					if(protocol_arr == null)
						protocol_arr = new String[0];
					String icmptype_arr[] = request.getParameterValues("matchicmp")==null?new String[0]:request.getParameterValues("matchicmp");
					String srcintf = request.getParameter("sinterface");
					String srcip = request.getParameter("sipaddress");
					String srcport = request.getParameter("s_port");
					String srcmac = request.getParameter("smacaddress");
					String desintf = request.getParameter("dinterface");
					String desip = request.getParameter("dipaddress");
					String desport = request.getParameter("d_port"); 
					action = request.getParameter("action"); 
					
					if(activation!=null)
					edit_trafficrulespage.put("enabled","1");
					else
					edit_trafficrulespage.put("enabled","0");
				
					edit_trafficrulespage.put("name", instancename.length()>0?instancename:edit_trafficrulespage.getString("name"));
					JSONArray json_proto_arr= new JSONArray();
					if(edit_trafficrulespage.containsKey("proto"))
					{
						if(protocol_arr.length==0)
							edit_trafficrulespage.remove("proto");				
					}
					for(String protocol : protocol_arr)
						json_proto_arr.add(protocol);
				
					edit_trafficrulespage.put("proto",json_proto_arr);
					
					JSONArray json_icmptype_arr = new JSONArray();
					for(String icmptype : icmptype_arr)
					json_icmptype_arr.add(icmptype);
				
					edit_trafficrulespage.put("icmp_type",json_icmptype_arr);
					if(srcintf ==null || srcintf.length() ==0)
					{
						if(edit_trafficrulespage.containsKey("src"))
							edit_trafficrulespage.remove("src");
					}
					else
						edit_trafficrulespage.put("src", srcintf.length()>0?srcintf:edit_trafficrulespage.getString("src"));

					if(srcip == null || srcip.length() ==0)
					{
						if(edit_trafficrulespage.containsKey("src_ip"))
						edit_trafficrulespage.remove("src_ip");
					}
					else			   
					edit_trafficrulespage.put("src_ip",srcip);
				
					if(srcport == null || srcport.length() ==0)
					{
						if(edit_trafficrulespage.containsKey("src_port"))
						edit_trafficrulespage.remove("src_port");
					}
					else			   
					edit_trafficrulespage.put("src_port",srcport);
					
					if(srcmac == null || srcmac.length() ==0)
					{
						if(edit_trafficrulespage.containsKey("src_mac"))
						edit_trafficrulespage.remove("src_mac");
					}
					else			   
					edit_trafficrulespage.put("src_mac",srcmac);
					if(desintf ==null || desintf.length() ==0)
					{
						if(edit_trafficrulespage.containsKey("dest"))
							edit_trafficrulespage.remove("dest");
					}
					else
						edit_trafficrulespage.put("dest", desintf.length()>0?desintf:edit_trafficrulespage.getString("dest"));
				
					if(desip == null || desip.length() ==0)
					{
						if(edit_trafficrulespage.containsKey("dest_ip"))
						edit_trafficrulespage.remove("dest_ip");
					}
					else			   
					edit_trafficrulespage.put("dest_ip",desip);
				
					if(desport == null || desport.length() ==0)
					{
						if(edit_trafficrulespage.containsKey("dest_port"))
						edit_trafficrulespage.remove("dest_port");
					}
					else			   
					edit_trafficrulespage.put("dest_port",desport);
				
					edit_trafficrulespage.put("target", action.length()>0?action:edit_trafficrulespage.getString("target"));
					
				   if(isnewobj)
					{
						edit_trafficrules_arr.add(edit_trafficrulespage);
					}
				   
				   //setSaveIndex(wizjsonnode,save_val);
				}
				JSONObject firewall =  wizjsonnode.containsKey("firewall")?wizjsonnode.getJSONObject("firewall"):new JSONObject();
				firewall.put("rule",edit_trafficrules_arr);
				wizjsonnode.put("firewall",firewall);
			   BufferedWriter jsonWriter = null;
			   try
			   {
					jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					jsonWriter.write(wizjsonnode.toString(2));
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			}
			else if(pagename.equals("edit_portforward") || pagename.equals("portforward")) 
			{
				boolean isnewobj = true;
				String instancename = request.getParameter("instancename");
				String action = request.getParameter("action")==null?"":request.getParameter("action");
				if(pagename.equals("edit_portforward"))
					procpage = "portforward.jsp";
					//procpage = "edit_portforward.jsp";
				else
					procpage = "portforward.jsp";
				save_val = PORT_FARWARD;
				JSONArray edit_portfrwd_arr =  wizjsonnode.containsKey("firewall")?(wizjsonnode.getJSONObject("firewall").containsKey("redirect")?wizjsonnode.getJSONObject("firewall").getJSONArray("redirect"):new JSONArray()):new JSONArray();
				JSONObject edit_portfrwdpage = new JSONObject();
				int obj_index = -1;
			    for(int i=0;i<edit_portfrwd_arr.size();i++)
				{
					JSONObject tempobj = edit_portfrwd_arr.getJSONObject(i);
					if(tempobj.getString("name").equals(instancename))
					{
						edit_portfrwdpage = tempobj;
						isnewobj = false;
						obj_index = i;
						break;
					}
				}
				if(action.equals("delete") && pagename.equals("portforward"))
				{
					if(obj_index != -1)
					edit_portfrwd_arr.remove(obj_index);
				}
				else if(pagename.equals("portforward"))
				{
					int portfrdrows = Integer.parseInt(request.getParameter("portrwcnt"));
					int portind=0;
					for(int i=1;i<portfrdrows;i++)
					{
						String instncename = request.getParameter("instancename"+i);
						/* if(instncename == null)
							continue; */
						String protocol_arr[] = request.getParameterValues("protocol"+i);
						JSONArray json_proto_arr = new JSONArray();
						for(String protocol : protocol_arr)
							json_proto_arr.add(protocol);
						edit_portfrwd_arr.getJSONObject(portind).put("proto", json_proto_arr);
						String extrnl_port = request.getParameter("extport"+i);
						if(extrnl_port == null || extrnl_port.length() ==0)
						{
							if(edit_portfrwd_arr.getJSONObject(portind).containsKey("src_dport"))
								edit_portfrwd_arr.getJSONObject(portind).remove("src_dport");
						}
						else			   
							edit_portfrwd_arr.getJSONObject(portind).put("src_dport",extrnl_port);
						String inter_ip = request.getParameter("IntIP"+i);
						if(inter_ip == null || inter_ip.length() ==0)
						{
							if(edit_portfrwd_arr.getJSONObject(portind).containsKey("dest_ip"))
								edit_portfrwd_arr.getJSONObject(portind).remove("dest_ip");
						}
						else			   
							edit_portfrwd_arr.getJSONObject(portind).put("dest_ip",inter_ip);
						String int_port = request.getParameter("intport"+i);
						if(int_port == null || int_port.length() ==0)
						{
							if(edit_portfrwd_arr.getJSONObject(portind).containsKey("dest_port"))
								edit_portfrwd_arr.getJSONObject(portind).remove("dest_port");
						}
						else			   
							edit_portfrwd_arr.getJSONObject(portind).put("dest_port",int_port);
						String activation = request.getParameter("activation"+i);
						if(activation == null)
							edit_portfrwd_arr.getJSONObject(portind).put("enabled","0");
						else
							edit_portfrwd_arr.getJSONObject(portind).put("enabled","1");
						portind++;
					}
				}
				else if(pagename.equals("edit_portforward"))
				{
					String activation = request.getParameter("activation");
					String protocol_arr[] = request.getParameterValues("proto");
					String srcintf = request.getParameter("sinterface");
					String srcip = request.getParameter("sipaddress");
					String srcport = request.getParameter("s_port");
					String desintf = request.getParameter("int_interface");
					String desip = request.getParameter("intipaddress");
					String desport = request.getParameter("i_port"); 
					String extip = request.getParameter("eipaddress"); 
					String extport = request.getParameter("e_port"); 
					
					if(activation!=null)
					edit_portfrwdpage.put("enabled","1");
					else
					edit_portfrwdpage.put("enabled","0");
					edit_portfrwdpage.put("name", instancename.length()>0?instancename:edit_portfrwdpage.getString("name"));
					
					JSONArray json_proto_arr = new JSONArray();
					for(String protocol : protocol_arr)
					json_proto_arr.add(protocol);
					
					edit_portfrwdpage.put("proto",json_proto_arr);
					
					edit_portfrwdpage.put("src", srcintf.length()>0?srcintf:edit_portfrwdpage.getString("src"));
					if(srcip == null || srcip.length() ==0)
					{
						if(edit_portfrwdpage.containsKey("src_ip"))
						edit_portfrwdpage.remove("src_ip");
					}
					else			   
					edit_portfrwdpage.put("src_ip",srcip);
					
					if(srcport == null || srcport.length() ==0)
					{
						if(edit_portfrwdpage.containsKey("src_port"))
						edit_portfrwdpage.remove("src_port");
					}
					else			   
					edit_portfrwdpage.put("src_port",srcport);
					
					edit_portfrwdpage.put("dst", desintf.length()>0?desintf:edit_portfrwdpage.getString("dst"));
					
					if(desip == null || desip.length() ==0)
					{
						if(edit_portfrwdpage.containsKey("dest_ip"))
						edit_portfrwdpage.remove("dest_ip");
					}
					else			   
					edit_portfrwdpage.put("dest_ip",desip);
					
					if(desport == null || desport.length() ==0)
					{
						if(edit_portfrwdpage.containsKey("dest_port"))
						edit_portfrwdpage.remove("dest_port");
					}
					else			   
					edit_portfrwdpage.put("dest_port",desport);
					
					if(extip == null || extip.length() ==0)
					{
						if(edit_portfrwdpage.containsKey("src_dip"))
						edit_portfrwdpage.remove("src_dip");
					}
					else			   
					edit_portfrwdpage.put("src_dip",extip);
					
					if(extport == null || extport.length() ==0)
					{
						if(edit_portfrwdpage.containsKey("src_dport"))
						edit_portfrwdpage.remove("src_dport");
					}
					else			   
					edit_portfrwdpage.put("src_dport",extport);
				
					if(isnewobj)
					{
						edit_portfrwd_arr.add(edit_portfrwdpage);
					}
				   //setSaveIndex(wizjsonnode,save_val);
				} 
				JSONObject firewall =  wizjsonnode.containsKey("firewall")?wizjsonnode.getJSONObject("firewall"):new JSONObject();
				firewall.put("redirect",edit_portfrwd_arr);
				wizjsonnode.put("firewall",firewall);
			   BufferedWriter jsonWriter = null;
			   try
			   {
					jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					jsonWriter.write(wizjsonnode.toString(2));
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			}
			else if(pagename.equals("static_routing"))
			{
				procpage ="static_routing.jsp";
				save_val=STATIC_ROUTING;
				int st_route_rcnt = Integer.parseInt(request.getParameter("routesrwcnt"));
				JSONArray route_arr =  wizjsonnode.containsKey("network")?(wizjsonnode.getJSONObject("network").containsKey("route")?wizjsonnode.getJSONObject("network").getJSONArray("route"):new JSONArray()):new JSONArray();
				for(int i=route_arr.size()-1;i>=0;i--) // remove only static route data. don't remove all 
				{
					JSONObject routeobj = route_arr.getJSONObject(i);
					if(routeobj.keySet().size()== 0)
					{
						route_arr.remove(routeobj);
					}
					else if(routeobj.containsKey("interface"))
					{
						String intface = routeobj.getString("interface");
						if(!intface.startsWith("tunnel"))
							route_arr.remove(routeobj);
					}
					
				}
				for(int i=1;i<st_route_rcnt;i++)
				{
					
					String  inter_face = request.getParameter("interface"+i);
					
					String  target = request.getParameter("target"+i);
					String  netmask = request.getParameter("netmask"+i);
					String  gateway = request.getParameter("gateway"+i);
					String  metric = request.getParameter("metric"+i);
					String  mtu = request.getParameter("mtu"+i);
					JSONObject route_obj = new JSONObject();
			
					if(inter_face != null && inter_face.trim().length() > 0)
					{
						route_obj.put("interface",inter_face);
					}
					if(target != null && target.trim().length() > 0)
					{					
						route_obj.put("target",target);
					}
					if(netmask != null && netmask.trim().length() > 0)
					{					
						route_obj.put("netmask",netmask);
					}
					if(gateway != null && gateway.trim().length() > 0)
					{					
						route_obj.put("gateway",gateway);
					}
					if(metric != null && metric.trim().length() > 0)
					{					
						route_obj.put("metric",metric);
					}
				 	if(mtu != null && mtu.trim().length() > 0)
					{					
						route_obj.put("mtu",mtu);
					}
				if(route_obj.containsKey("interface"))
					route_arr.add(route_obj);	
			}
			wizjsonnode.getJSONObject("network").put("route",route_arr);
			BufferedWriter jsonWriter = null;
			try
			{
				jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
				jsonWriter.write(wizjsonnode.toString(2));
			}
			catch(Exception e)
			{
				e.printStackTrace();
				internal_err = true;
			}
			finally
			{
				if(jsonWriter != null)
				jsonWriter.close();
			}
			}
			else if(pagename.equals("dhcp"))
			{
					procpage ="dhcp.jsp";
					save_val = DHCP_CONFIG;
					int st_lease_rcnt = Integer.parseInt(request.getParameter("routesrwcnt"));
					JSONArray static_lease_arr =  wizjsonnode.containsKey("dhcp")?(wizjsonnode.getJSONObject("dhcp").containsKey("host")?wizjsonnode.getJSONObject("dhcp").getJSONArray("host"):new JSONArray()):new JSONArray();
					for(int i=static_lease_arr.size()-1;i>=0;i--)
					{
						static_lease_arr.remove(i);
					}
					for(int i=1;i<st_lease_rcnt;i++)
					{
						String  hostname = request.getParameter("hostname"+i);
						String  ipaddress  = request.getParameter("ipaddress"+i);
						String  macaddress = request.getParameter("macaddress"+i);
						String  leasetime = request.getParameter("leasetime"+i);
						JSONObject lease_obj = new JSONObject();
				
						if(hostname != null)
						{
							lease_obj.put("name",hostname);
						}
						if(ipaddress != null && ipaddress.trim().length() > 0)
						{					
							lease_obj.put("ip",ipaddress);
						}
						if(macaddress != null && macaddress.trim().length() > 0)
						{
							lease_obj.put("mac",macaddress);
						}
						if(leasetime != null && leasetime.trim().length() > 0)
						{
							lease_obj.put("leasetime",leasetime);
						}
					if(lease_obj.containsKey("name"))
					static_lease_arr.add(lease_obj);	
				}
				wizjsonnode.getJSONObject("dhcp").put("host",static_lease_arr);
				BufferedWriter jsonWriter = null;
				try
				{
					jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					jsonWriter.write(wizjsonnode.toString(2));
				}
				catch(Exception e)
				{
					e.printStackTrace();
					internal_err = true;
				}
				finally
				{
					if(jsonWriter != null)
					jsonWriter.close();
				}
			}
			
			else if(pagename.equals("http"))
			{
			   procpage = "http.jsp";
			   save_val = HTTP;
			   JSONObject httpobj =wizjsonnode.getJSONObject("apache").getJSONObject("apache:defaults");
			   String httpact = request.getParameter("activation");
			   String httplisten_port = request.getParameter("port");
			   String httpsession_timeout = request.getParameter("stimer");
			   String httprefresh_timeout = request.getParameter("rtimer");
			   if(httpact!=null)
				   httpobj.put("enable_https","1");
			   else
				   httpobj.put("enable_https","0");
			   
			   if(httplisten_port == null || httplisten_port.length() == 0)
				{
					if(httpobj.containsKey("listen_port"))
					httpobj.remove("listen_port");
				}
				else
				httpobj.put("listen_port", httplisten_port);
				if(httpsession_timeout == null || httpsession_timeout.length() == 0)
				{
					if(httpobj.containsKey("session_timeout"))
					httpobj.remove("session_timeout");
				}
				else
			   httpobj.put("session_timeout", httpsession_timeout);
				if(httprefresh_timeout == null || httprefresh_timeout.length() == 0)
				{
					if(httpobj.containsKey("refresh_timeout"))
					httpobj.remove("refresh_timeout");
				}
				else
			   httpobj.put("refresh_timeout", httprefresh_timeout);
			   //setSaveIndex(wizjsonnode,save_val);
			   BufferedWriter jsonWriter = null;
			   try
			   {
				   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
				   jsonWriter.write(wizjsonnode.toString(2));
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }
			   
	   }
	   //SNMP starts
	   else if(pagename.equals("snmp"))
	   {
			   procpage = "snmp.jsp";
			   save_val = SNMP_CONFIG;
			   //System jsonnode
			   JSONObject systemobj =  wizjsonnode.getJSONObject("system");
			   JSONObject syssnmppage =  systemobj.getJSONArray("system")==null ? new JSONObject():systemobj.getJSONObject("snmp:snmp");
			   JSONArray systemarr = systemobj.getJSONArray("system")==null ? new JSONArray(): systemobj.getJSONArray("system");	
			   JSONObject systempage = new JSONObject();
			   for(int i=0;i<systemarr.size();i++)
				   systempage=(JSONObject)systemarr.get(i);
			   //ends
			  JSONObject snmpobj =  wizjsonnode.containsKey("snmpd")?wizjsonnode.getJSONObject("snmpd"):new JSONObject();
			  JSONArray snmpsys = snmpobj.containsKey("system")?snmpobj.getJSONArray("system"):new JSONArray();
			  JSONObject snmpdef=snmpobj.containsKey("default:default")?snmpobj.getJSONObject("default:default"):new JSONObject();
			  JSONObject trapcomm=snmpobj.containsKey("trapcommunity:trapcommunity")?snmpobj.getJSONObject("trapcommunity:trapcommunity"):new JSONObject();
			  JSONArray engineidarr = snmpobj.containsKey("engineid")?snmpobj.getJSONArray("engineid"):new JSONArray();
			  JSONObject cruserobj =  snmpobj.containsKey("createUser:createUser")?snmpobj.getJSONObject("createUser:createUser"):new JSONObject();
			  JSONArray trapsink = new JSONArray();
			  JSONArray trap2sink = new JSONArray();
			  JSONObject sysobj=new JSONObject();
			  JSONObject userobj=new JSONObject();
			  JSONObject readcomm=new JSONObject();
			  JSONObject writecomm=new JSONObject();
			  JSONObject grpv1pubobj=new JSONObject();
			  JSONObject grpv1priobj=new JSONObject();
			  JSONObject grpv2pubobj=new JSONObject();
			  JSONObject grpv2priobj=new JSONObject();
			  JSONObject acspubobj=new JSONObject();
			  JSONObject acspriobj=new JSONObject();
			  JSONObject trapsinkobj=new JSONObject();
			  JSONObject trap2sinkobj=new JSONObject();
			  JSONObject trapsess=new JSONObject();
			  JSONObject engineidobj=new JSONObject();
			  JSONArray json_snmpverval_arr= new JSONArray(); 
			  JSONArray json_trapverval_arr= new JSONArray();
			  for(int i=0;i<snmpsys.size();i++)
				  sysobj=(JSONObject)snmpsys.get(i);
			  for(int i=0;i<engineidarr.size();i++)
				  engineidobj=(JSONObject)engineidarr.get(i);
			  //snmp
			   String snmpact = request.getParameter("activation");
			   String snmpverval_arr[] = request.getParameterValues("snmpVersion");
			   if(snmpverval_arr == null)
					snmpverval_arr = new String[0];
			   String ipver = request.getParameter("snmpipver"); 
			   String syscont = request.getParameter("syscntct");
			   String sysname = request.getParameter("sysname");
			   String sysloc = request.getParameter("syslct");
			   String readcom = request.getParameter("rdcmty");
			   String writecom = request.getParameter("wrcmty");
			   String user = request.getParameter("user"); 
			   String mode = request.getParameter("secmode");
			   String auth = request.getParameter("authentication");
			   String encry= request.getParameter("encryption");
			   String authpwd = request.getParameter("authpwd");
			   String encrypwd = request.getParameter("encrypwd");
			   //trap
			   String trapverval_arr[] = request.getParameterValues("trapVersion");
			   if(trapverval_arr == null)
				   trapverval_arr = new String[0];
			   String trapcom = request.getParameter("trapcmty");
			   String coldact = request.getParameter("coldstart"); 
			   String authact= request.getParameter("authtrapenable"); 
			   String linkupdwnact = request.getParameter("linkUpDownNotifications"); 
			   String trapact= request.getParameter("trapActvtn"); 
			   String manager= request.getParameter("manager"); 
			   boolean snmpv1=false;
			   boolean snmpv2c=false;
			   boolean snmpv3=false;
			   boolean trapv1=false;
			   boolean trapv2c=false;
			   boolean trapv3=false;
				
			  // if(snmpact!=null)
				int enginecnt=0;
			   int newenginecnt;
			   String newengineidval="";
			   String engine="";
			   String trapsessionset="";
			   String oldencrypwd=cruserobj.get("encryptpass")!=null?cruserobj.get("encryptpass").toString():"";
			   String oldauthpwd=cruserobj.get("authpass")!=null?cruserobj.get("authpass").toString():"";
			   //removing vals before adding 
			   snmpobj.remove("createUser:createUser");
			   snmpobj.remove("com2sec6:public6");
			   snmpobj.remove("com2sec6:private6");
		  	   snmpobj.remove("group:public6_v1");
	  		   snmpobj.remove("group:private6_v1");
	  		   snmpobj.remove("group:public6_v2c");
	  		   snmpobj.remove("group:private6_v2c");
	  		   snmpobj.remove("access:public6_access");
		  	   snmpobj.remove("access:private6_access");
		  	   snmpobj.remove("com2sec:public");
		  	   snmpobj.remove("com2sec:private");
	  		   snmpobj.remove("group:public_v1");
	  		   snmpobj.remove("group:private_v1");
	  		   snmpobj.remove("group:public_v2c");
	  		   snmpobj.remove("group:private_v2c");
	  		   snmpobj.remove("access:public_access");
		  	   snmpobj.remove("access:private_access");
		  	   snmpobj.remove("trapsink");
		  	   snmpobj.remove("trap2sink");
			   snmpobj.remove("trapsess:trapsess");
			   trapcomm.remove("community");
			   engineidobj.remove("engineid");
			   //ends 
			   if(snmpact!=null)
				   snmpdef.put("snmpactivation","1");
			   else
				   snmpdef.put("snmpactivation","0");
			   if(ipver!=null)
				   snmpdef.put("ipversion",ipver);
			   else
				   snmpdef.put("ipversion","ipv4");
			   if(syscont!=null)
			   {
				   sysobj.put("sysContact",syscont);
				   syssnmppage.put("sysContact", syscont);
			   }
			   else
			   {
				   sysobj.put("sysContact","");
				   syssnmppage.put("sysContact","");
			   }
			   if(sysname!=null)
			   {
				   sysobj.put("sysName",sysname);
				   systempage.put("hostname",sysname);
				   syssnmppage.put("sysName",sysname);
			   }
			   else
			   {
				   sysobj.put("sysName","");
				   systempage.put("hostname","");
				   syssnmppage.put("sysName","");
			   }
			   if(sysloc!=null)
			   {
				   sysobj.put("sysLocation",sysloc);
				   syssnmppage.put("sysLocation",sysloc);
			   }
			   else
			   {
				   sysobj.put("sysLocation",""); 
				   syssnmppage.put("sysLocation","");
			   }
			   snmpobj.put("system",snmpsys);
			   if(snmpdef.containsKey("snmpversion"))
					snmpdef.remove("snmpversion");
			   for(String snmpverval : snmpverval_arr)
			   {
				   if(snmpverval.equals("v1"))
					   snmpv1=true;
				   else if(snmpverval.equals("v2c"))
					   snmpv2c=true;
				   else if(snmpverval.equals("usm"))
				   {
					   snmpv3=true;
					  if(snmpdef.containsKey("enginecount")) 
					  {
					  	enginecnt=Integer.parseInt(snmpdef.get("enginecount").toString()); 
					  }
					  else
						  enginecnt = -1;
				   }
				   else
				   {
					   snmpv1=true;
					   snmpv2c=true;
					   snmpv3=true;
				   }
					json_snmpverval_arr.add(snmpverval);
			   }
			   snmpdef.put("snmpversion",json_snmpverval_arr);
			   
			   if(snmpdef.containsKey("trapversion"))
					snmpdef.remove("trapversion");
			   
			   for(String trapverval : trapverval_arr)
			   {
				   if(trapverval.equals("v1"))
					   trapv1=true;
				   else if(trapverval.equals("v2c"))
					   trapv2c=true;
				   else if(trapverval.equals("usm"))
					   trapv3=true;
				   else
				   {
					   trapv1=true;
					   trapv2c=true;
					   trapv3=true;
				   }
				   json_trapverval_arr.add(trapverval);
			   }
			   snmpdef.put("trapversion",json_trapverval_arr);
			   
			   if(trapact!=null)
				   snmpdef.put("trapActivation","1");
			   else
				   snmpdef.put("trapActivation","0");
			  if(manager!=null &&trapact!=null)
				   snmpdef.put("host", manager);
			   else
				   snmpdef.remove("host");
			   if(snmpact!=null) //snmpact check strats
			   {
				   if((snmpv1||snmpv2c))
				   {
					   if(ipver.equals("ipv4") ||ipver.equals("Dual"))
						{
							  readcomm.put("secname","ro");
							  readcomm.put("source","default");
							  readcomm.put("community",readcom);
						  	  snmpobj.put("com2sec:public",readcomm);
						  	 
						  	  writecomm.put("secname","rw");
						  	  writecomm.put("source","default");
						  	  writecomm.put("community",writecom);
						  	  snmpobj.put("com2sec:private",writecomm);
						  	  
						  	  if(snmpv1)
						  	  {
						  		 grpv1pubobj.put("secname","ro"); 
						  		 grpv1pubobj.put("group","public"); 
						  		 grpv1pubobj.put("version","v1"); 
						  		 
						  		 grpv1priobj.put("secname","rw"); 
						  		 grpv1priobj.put("group","private"); 
						  		 grpv1priobj.put("version","v1"); 
						  		 
						  		 snmpobj.put("group:public_v1",grpv1pubobj);
						  		 snmpobj.put("group:private_v1",grpv1priobj);
						  	  }
						  	 if(snmpv2c)
						  	  {
						  		 grpv2pubobj.put("secname","ro"); 
						  		 grpv2pubobj.put("group","public"); 
						  		 grpv2pubobj.put("version","v2c"); 
						  		 
						  		 grpv2priobj.put("secname","rw"); 
						  		 grpv2priobj.put("group","private"); 
						  		 grpv2priobj.put("version","v2c"); 
						  		 
						  		 snmpobj.put("group:public_v2c",grpv2pubobj);
						  		 snmpobj.put("group:private_v2c",grpv2priobj);
						  	  }
						  	 acspubobj.put("group","public");
						  	 acspubobj.put("context","none");
						  	 acspubobj.put("version","any");
						  	 acspubobj.put("level","noauth");
						  	 acspubobj.put("prefix","exact");
						  	 acspubobj.put("read","all"); 
						  	 acspubobj.put("write","none");
						  	 acspubobj.put("notify","none");
						  	 
						  	 acspriobj.put("group","private");
						  	 acspriobj.put("context","none");
						  	 acspriobj.put("version","any");
						  	 acspriobj.put("level","noauth");
						  	 acspriobj.put("prefix","exact");
						  	 acspriobj.put("read","all"); 
						  	 acspriobj.put("write","all");
						  	 acspriobj.put("notify","all");
						  	 
						  	 snmpobj.put("access:public_access",acspubobj);
						  	 snmpobj.put("access:private_access",acspriobj);
						}
						if(ipver.equals("ipv6") ||ipver.equals("Dual"))
						{
							  
						  readcomm.put("secname","ro");
						  readcomm.put("source","default");
						  readcomm.put("community",readcom);
					  	  snmpobj.put("com2sec6:public6",readcomm);
					  	 
					  	  writecomm.put("secname","rw");
					  	  writecomm.put("source","default");
					  	  writecomm.put("community",writecom);
					  	  snmpobj.put("com2sec6:private6",writecomm);
					  	 
					  	  if(snmpv1)
					  	  {
					  		 grpv1pubobj.put("secname","ro"); 
					  		 grpv1pubobj.put("group","public6"); 
					  		 grpv1pubobj.put("version","v1"); 
					  		 
					  		 grpv1priobj.put("secname","rw"); 
					  		 grpv1priobj.put("group","private6"); 
					  		 grpv1priobj.put("version","v1"); 
					  		 
					  		 snmpobj.put("group:public6_v1",grpv1pubobj);
					  		 snmpobj.put("group:private6_v1",grpv1priobj);
					  	  }
					  	 if(snmpv2c)
					  	  {
					  		 grpv2pubobj.put("secname","ro"); 
					  		 grpv2pubobj.put("group","public6"); 
					  		 grpv2pubobj.put("version","v2c"); 
					  		 
					  		 grpv2priobj.put("secname","rw"); 
					  		 grpv2priobj.put("group","private6"); 
					  		 grpv2priobj.put("version","v2c"); 
					  		 
					  		 snmpobj.put("group:public6_v2c",grpv2pubobj);
					  		 snmpobj.put("group:private6_v2c",grpv2priobj);
					  	  }
					  	 acspubobj.put("group","public6");
					  	 acspubobj.put("context","none");
					  	 acspubobj.put("version","any");
					  	 acspubobj.put("level","noauth");
					  	 acspubobj.put("prefix","exact");
					  	 acspubobj.put("read","all"); 
					  	 acspubobj.put("write","none");
					  	 acspubobj.put("notify","none");
					  	 
					  	 acspriobj.put("group","private6");
					  	 acspriobj.put("context","none");
					  	 acspriobj.put("version","any");
					  	 acspriobj.put("level","noauth");
					  	 acspriobj.put("prefix","exact");
					  	 acspriobj.put("read","all"); 
					  	 acspriobj.put("write","all");
					  	 acspriobj.put("notify","all");
					  	 
					  	 snmpobj.put("access:public6_access",acspubobj);
					  	 snmpobj.put("access:private6_access",acspriobj);
					   }
					}
			   }//end of snmpact if
			   if((snmpact!=null&&snmpv3)||(trapact!=null &&  trapv3))
			   {
				   //add createUser
				   userobj.put("v3user",user);
				   if((oldencrypwd==null)||(oldauthpwd==null)||!oldauthpwd.equals(authpwd) ||!oldencrypwd.equals(encrypwd))
				   {
					   if(enginecnt != -1)
					   {
						   newenginecnt=enginecnt+1;
						   newengineidval=String.format("%04x",newenginecnt);
						   engine=snmpdef.get("EngineId").toString().replaceFirst(".{4}$",newengineidval);
						   enginecnt=newenginecnt;
					   }
				   }
				   else
					   engine=snmpdef.get("EngineId").toString();
				   if(mode.equals("priv"))
				   {
				   userobj.put("level",mode);
				   userobj.put("encryption",encry);
				   userobj.put("authentication",auth);
				   userobj.put("encryptpass",encrypwd);
				   userobj.put("authpass",authpwd);
				   }
				   else if(mode.equals("auth"))
				   {
					   userobj.put("level",mode);
					   userobj.put("authentication",auth);
					   userobj.put("authpass",authpwd);
				   }
				   else
					   userobj.put("level","none");
				   snmpobj.put("createUser:createUser",userobj);
				   if(snmpv3)
				   {
					   engineidobj.put("engineid",engine);
					   snmpdef.put("EngineId", engine);
					   if(enginecnt != -1)
					   		snmpdef.put("enginecount",String.valueOf(enginecnt));
				   }
				   if(trapv3)
				   {
					   if(mode.equals("priv"))
						   trapsessionset="-v 3 -e 0x"+engine+" -u "+user+" -a "+auth+" -A "+authpwd+" -l authpriv -x "+encry+" -X "+encrypwd+" udp:"+manager+":162";
					   else if(mode.equals("auth"))
						   trapsessionset="-v 3 -e 0x"+engine+" -u "+user+" -a "+auth+" -A "+authpwd+" -l authnopriv  udp:"+manager+":162";
					   else
						   trapsessionset="-v 3 -e 0x"+engine+ " -u "+user+" -l noauthnopriv  udp:"+manager+":162";
					  trapsess.put("trapsess",trapsessionset);
					  snmpobj.put("trapsess:trapsess",trapsess);
				   }
			   }//end of snmpv3  creation
			   if(trapact!=null)
			   {
				   if(trapv1||trapv2c)
				   {
					   trapcomm.put("community",trapcom);
					   if(trapv1)
					   {
						   trapsinkobj.put("community","public");
						   trapsinkobj.put("host",manager);
						   trapsinkobj.put("port","162");
						   trapsink.add(trapsinkobj);
						   snmpobj.put("trapsink",trapsink);
					   }
					   if(trapv2c)
					   {
						   trap2sinkobj.put("community","secret");
						   trap2sinkobj.put("host",manager);
						   trap2sinkobj.put("port","162");
						   trap2sink.add(trap2sinkobj);
						   snmpobj.put("trap2sink",trap2sink);
					   }
				   }
			   }//end of trapact if
			  
			   BufferedWriter jsonWriter = null;
				   try
				   {
					   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					   jsonWriter.write(wizjsonnode.toString(2));
				   }
				   catch(Exception e)
				   {
					   e.printStackTrace();
					   internal_err = true;
				   }
				   finally
				   {
					   if(jsonWriter != null)
					   jsonWriter.close();
				   }
			}
	   
	   //SNMP Ends 
	   
			else if(pagename.equals("ntp"))
			{
					procpage = "ntp.jsp";
					save_val = NTP_CONFIG;
					JSONObject ntpobj =  wizjsonnode.getJSONObject("system").getJSONObject("timeserver:ntp");
					String ntppact = request.getParameter("activation");
					String ntpenableser = request.getParameter("enable_server");
					String ntpdhcpact = request.getParameter("use_dhcp");
					int ntprows = Integer.parseInt(request.getParameter("ntprows"));
					JSONArray ntp_arr = ntpobj.getJSONArray("server");
					for(int i=ntp_arr.size()-1;i>=0;i--)
					{
						ntp_arr.remove(i);
					}
					for(int i=2;i<=ntprows;i++)
					{
						String ntpaddr = request.getParameter("servers"+i);
						if(ntpaddr!=null && ntpaddr.trim().length() > 0)
						{
							ntp_arr.add(ntpaddr); 
						}
						
					}
					if(ntppact!=null)
						ntpobj.put("enabled","1");
					else
						ntpobj.put("enabled","0");
					if(ntpenableser == null || ntpenableser.length() == 0)
					{
						if(ntpobj.containsKey("enable_server"))
						ntpobj.remove("enable_server");
					}
					else
						ntpobj.put("enable_server", ntpenableser);
					if(ntpdhcpact==null)
						ntpobj.remove("use_dhcp");
					else
						ntpobj.put("use_dhcp","1");
				   
				   //setSaveIndex(wizjsonnode,save_val);
				   BufferedWriter jsonWriter = null;
				   try
				   {
					   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					   jsonWriter.write(wizjsonnode.toString(2));
				   }
				   catch(Exception e)
				   {
					   e.printStackTrace();
					   internal_err = true;
				   }
				   finally
				   {
					   if(jsonWriter != null)
					   jsonWriter.close();
				   }
			}
			
			else if(pagename.equals("edit_ipsec") || pagename.equals("ipsec")) 
			{
				if(pagename.equals("edit_ipsec"))
				{
					//procpage = "edit_ipsec.jsp";
					procpage = "ipsec.jsp";
				}
				else 
					procpage = "ipsec.jsp";
				save_val = IPSEC_CONFIG;
				JSONObject ipsec_inst_obj = new JSONObject();
				JSONObject ipsec_obj =  wizjsonnode.containsKey("ipsec")?wizjsonnode.getJSONObject("ipsec"):new JSONObject();
				//JSONObject ipsec_info_obj =  wizjsonnode.containsKey("ipsecInfo")?wizjsonnode.getJSONObject("ipsecInfo"):new JSONObject();
				String instancename = request.getParameter("instancename")==null?"":request.getParameter("instancename");
				String action = request.getParameter("action")==null?"":request.getParameter("action");
				
				if(action.equals("delete") && ipsec_obj.containsKey("remote:"+instancename))
				{
					JSONObject old_ipsec_inst_obj = ipsec_obj.getJSONObject("remote:"+instancename);
					JSONObject tunnel_trans_obj = null;
					if(old_ipsec_inst_obj.containsKey("tunnel"))
						tunnel_trans_obj = ipsec_obj.getJSONObject("tunnel:"+instancename+"_tunnel");
					else if(old_ipsec_inst_obj.containsKey("transport"))
						tunnel_trans_obj=ipsec_obj.getJSONObject("transport:"+instancename+"_transport");
						
					if(tunnel_trans_obj != null)
					{			
						String p1_prop_value = ipsec_obj.containsKey("p1_proposal:"+instancename+"_p1")?ipsec_obj.getString("p1_proposal:"+instancename+"_p1"):null;
						String p2_prop_value = ipsec_obj.containsKey("p2_proposal:"+instancename+"_p2")?ipsec_obj.getString("p2_proposal:"+instancename+"_p2"):null;
						if(p1_prop_value != null)
							ipsec_obj.remove("p1_proposal:"+instancename+"_p1");
						if(p2_prop_value != null)
							ipsec_obj.remove("p2_proposal:"+instancename+"_p2");
						
						ipsec_obj.remove("tunnel:"+instancename+"_tunnel");
						ipsec_obj.remove("transport:"+instancename+"_transport");
					}
					
					ipsec_obj.remove("remote:"+instancename);
					/* if(ipsec_info_obj.containsKey("status:"+instancename))
						ipsec_info_obj.remove("status:"+instancename); */
				}
				else if(pagename.equals("ipsec"))
				{
					int ipsecrows = Integer.parseInt(request.getParameter("ipsecrwcnt"));
					JSONObject ipsec_inst_objs=null;
					for(int i=1;i<ipsecrows;i++)
					{
						String ipsec_instancename = request.getParameter("instancename"+i);
						ipsec_inst_objs = ipsec_obj.containsKey("remote:"+ipsec_instancename)?ipsec_obj.getJSONObject("remote:"+ipsec_instancename):new JSONObject();
						String extmode = request.getParameter("exmode"+i);
						if(extmode == null || extmode.length() ==0)
						{
							if(ipsec_inst_objs.containsKey("exchange_mode"))
								ipsec_inst_objs.remove("exchange_mode");
						}
						else			   
							ipsec_inst_objs.put("exchange_mode",extmode);
						String ipsec_authmode = request.getParameter("authmode"+i);
						if(ipsec_authmode == null || ipsec_authmode.length() ==0)
						{
							if(ipsec_inst_objs.containsKey("authentication"))
								ipsec_inst_objs.remove("authentication");
						}
						else			   
							ipsec_inst_objs.put("authentication",ipsec_authmode);
						String activaton = request.getParameter("activation"+i);
						if(activaton!=null)
							ipsec_inst_objs.put("enabled","1");
							else
								ipsec_inst_objs.put("enabled","0");
					}
					
				}
				else if(pagename.equals("edit_ipsec")){
					String remoteend ="";
					String activation = request.getParameter("activation");
					instancename = request.getParameter("instancename");
					String localend= request.getParameter("localend");
					String localId = request.getParameter("localId");
					String remoteId = request.getParameter("remoteId");
					String ipsecmode = request.getParameter("ipsecmode");
					String oplevel = request.getParameter("oplevel");
					String backup = request.getParameter("bckupref");
					String authmode = request.getParameter("authmode");
					/* if(authmode!=null)
					{ */
					if(authmode.equals("1"))
						remoteend = request.getParameter("remoteend");
					else
						remoteend = request.getParameter("rmtendpt");
					//}
					String exmode = request.getParameter("exmode"); 
					String rbipsec = request.getParameter("rbipsec");
					String natt = request.getParameter("natt");
					String preshared_key = request.getParameter("preshared_key");
					String ISAKMP_enc = request.getParameter("ISAKMP_enc");
					String ISAKMP_hash = request.getParameter("ISAKMP_hash");
					String ISAKMP_grp = request.getParameter("ISAKMP_grp");
					String ISAKMP_lifetime = request.getParameter("ISAKMP_lifetime");
					String IPsec_enc = request.getParameter("IPsec_enc");
					String IPsec_hash = request.getParameter("IPsec_hash");
					String PFS_grp = request.getParameter("PFS_grp");
					String IPsec_lifetime = request.getParameter("IPsec_lifetime");
					String DPD_status = request.getParameter("DPD_status");
					String DPD_Int = request.getParameter("DPD_Int");
					String DPD_to = request.getParameter("DPD_to");
					String lanbypas = request.getParameter("lanbypas");
					String tracking = request.getParameter("tracking");
					String trackip = request.getParameter("trackip");
					String srcintfce = request.getParameter("srcintfce");
					String srcintfceCustom = request.getParameter("interface");
					String interval = request.getParameter("interval");
					String retries = request.getParameter("retries");
					String trackfailure = request.getParameter("trackfailure");
					JSONObject ipsec_tun_trans_obj = new JSONObject();
					JSONObject ipsec_p1_prop_obj = new JSONObject();
					JSONObject ipsec_p2_pro_obj = new JSONObject();
					String ipsec_tun_trans_obj_key = "";
					
				ipsec_inst_obj = ipsec_obj.containsKey("remote:"+instancename)?ipsec_obj.getJSONObject("remote:"+instancename):new JSONObject();
				ipsec_p1_prop_obj =ipsec_obj.containsKey("p1_proposal:"+instancename+"_p1")?ipsec_obj.getJSONObject("p1_proposal:"+instancename+"_p1"):new JSONObject();
				ipsec_p2_pro_obj =ipsec_obj.containsKey("p2_proposal:"+instancename+"_p2 ")?ipsec_obj.getJSONObject("p2_proposal:"+instancename+"_p2 "):new JSONObject();
				ipsec_tun_trans_obj = ipsec_obj.containsKey("tunnel:"+instancename+"_tunnel")?ipsec_obj.getJSONObject("tunnel:"+instancename+"_tunnel"):new JSONObject();
				
				int lcliprows = Integer.parseInt(request.getParameter("lcliprows"));
				JSONArray loc_nw_arr = ipsec_tun_trans_obj.containsKey("local_subnet")?ipsec_tun_trans_obj.getJSONArray("local_subnet"):new JSONArray();
				for(int i=loc_nw_arr.size()-1;i>=0;i--)
				{
					loc_nw_arr.remove(i);
				}
				for(int i=1;i<=lcliprows;i++)
				{
					String ipaddr = request.getParameter("lanip"+i);
					String subnet = request.getParameter("lansn"+i);
					if(ipaddr!= null && subnet!=null && ipaddr.length() > 0 && subnet.length() > 0)
					{
						try{
							SubnetUtils sutils = new SubnetUtils(ipaddr,subnet);						
							loc_nw_arr.add(sutils.getInfo().getCidrSignature());
						}
						catch(Exception e)
						{
							e.printStackTrace();
						}
					}
				}
				
				int rmtiprows = Integer.parseInt(request.getParameter("rmtiprows"));
				JSONArray rem_nw_arr = ipsec_tun_trans_obj.containsKey("remote_subnet")?ipsec_tun_trans_obj.getJSONArray("remote_subnet"):new JSONArray();
				for(int i=rem_nw_arr.size()-1;i>=0;i--)
				{
					rem_nw_arr.remove(i);
				}
				for(int i=1;i<=rmtiprows;i++)
				{
					String ipaddr = request.getParameter("rmip"+i);
					String subnet = request.getParameter("rmsn"+i);
			   
					if(ipaddr!= null && subnet!=null && ipaddr.length() > 0 && subnet.length() > 0)
					{
						try
						{
							SubnetUtils sutils = new SubnetUtils(ipaddr,subnet);
							rem_nw_arr.add(sutils.getInfo().getCidrSignature());
						}
						catch(Exception e)
						{
							e.printStackTrace();
						}
					}
				}
				
				int bypassiprows = Integer.parseInt(request.getParameter("bypassiprows"));
				JSONArray bypass_nw_arr = ipsec_tun_trans_obj.containsKey("bypass_subnet")?ipsec_tun_trans_obj.getJSONArray("bypass_subnet"):new JSONArray();
				
				for(int i=bypass_nw_arr.size()-1;i>=0;i--)
				{
					bypass_nw_arr.remove(i);
				}
				for(int i=1;i<=bypassiprows;i++)
				{
					String ipaddr = request.getParameter("bypasip"+i);
					String subnet = request.getParameter("bypassn"+i);
			   
					if(ipaddr!= null && subnet!=null && ipaddr.length() > 0 && subnet.length() > 0)
					{
						try
						{
						SubnetUtils sutils = new SubnetUtils(ipaddr,subnet);
						bypass_nw_arr.add(sutils.getInfo().getCidrSignature());
						}
						catch(Exception e)
						{
							e.printStackTrace();
						}
					}
				}

				if(loc_nw_arr.size() == 0)
					ipsec_tun_trans_obj.remove("local_subnet");
				else	
					ipsec_tun_trans_obj.put("local_subnet", loc_nw_arr);
				
				if(rem_nw_arr.size() == 0)
					ipsec_tun_trans_obj.remove("remote_subnet");
				else	
				ipsec_tun_trans_obj.put("remote_subnet", rem_nw_arr);
			
				if(bypass_nw_arr.size() == 0)
					ipsec_tun_trans_obj.remove("bypass_subnet");
				else 
				{
					if(lanbypas != null)
						ipsec_tun_trans_obj.put("bypass_subnet", bypass_nw_arr);
					else
						ipsec_tun_trans_obj.remove("bypass_subnet");
				}
				
				ipsec_inst_obj.put("tunnel", instancename+"_tunnel");
				if(localend == null || localend.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("local_gateway"))
					ipsec_inst_obj.remove("local_gateway");
				}
				else			   
				ipsec_inst_obj.put("local_gateway",localend);
				if(remoteend == null || remoteend.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("gateway"))
					ipsec_inst_obj.remove("gateway");
				}
				else			   
				ipsec_inst_obj.put("gateway",remoteend);
				
				if(localId == null || localId.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("local_identifier"))
					ipsec_inst_obj.remove("local_identifier");
				}
				else			   
				ipsec_inst_obj.put("local_identifier",localId);
				
				if(remoteId == null || remoteId.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("remote_identifier"))
					ipsec_inst_obj.remove("remote_identifier");
				}
				else			   
				ipsec_inst_obj.put("remote_identifier",remoteId);
					
				if(ipsecmode.equals("tunnel"))
				{
					if(ipsec_inst_obj.containsKey("transport"))
						ipsec_inst_obj.remove("transport");
					if(ipsec_obj.containsKey("transport:"+instancename+"_transport"))
						ipsec_obj.remove("transport:"+instancename+"_transport");
					ipsec_inst_obj.put("tunnel",instancename+"_tunnel");
					ipsec_tun_trans_obj_key	= "tunnel:"+instancename+"_tunnel";
				}
				else if(ipsecmode.equals("transport"))
				{
					if(ipsec_inst_obj.containsKey("tunnel"))
						ipsec_inst_obj.remove("tunnel");
					if(ipsec_obj.containsKey("tunnel:"+instancename+"_tunnel"))
						ipsec_obj.remove("tunnel:"+instancename+"_tunnel");
					ipsec_inst_obj.put("transport",instancename+"_transport");
					ipsec_tun_trans_obj_key	= "transport:"+instancename+"_transport";
				}
				
				if(oplevel == null || oplevel.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("operation_level"))
					ipsec_inst_obj.remove("operation_level");
				}
				else
				{
					ipsec_inst_obj.put("operation_level",oplevel);
					if(oplevel.equals("main") )
					{
						if(ipsec_inst_obj.containsKey("backup_reference"))
						ipsec_inst_obj.remove("backup_reference");
					}
					else if(backup == null || backup.length() ==0)
					{
						if(ipsec_inst_obj.containsKey("backup_reference"))
							ipsec_inst_obj.remove("backup_reference");
					}
					else
						ipsec_inst_obj.put("backup_reference",backup);
				}
				/* if(backup == null || backup.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("backup_reference"))
					ipsec_inst_obj.remove("backup_reference");
				}
				else			   
				ipsec_inst_obj.put("backup_reference",oplevel); */
				
				if(authmode == null || authmode.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("authentication"))
					ipsec_inst_obj.remove("authentication");
				}
				else			   
				ipsec_inst_obj.put("authentication",authmode);
				
				if(exmode == null || exmode.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("exchange_mode"))
					ipsec_inst_obj.remove("exchange_mode");
				}
				else			   
				ipsec_inst_obj.put("exchange_mode",exmode);
				
				if(preshared_key == null || preshared_key.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("pre_shared_key"))
					ipsec_inst_obj.remove("pre_shared_key");
				}
				else			   
				ipsec_inst_obj.put("pre_shared_key",preshared_key);
				
				if(ISAKMP_enc == null || ISAKMP_enc.length() ==0)
				{
					if(ipsec_p1_prop_obj.containsKey("encryption_algorithm"))
					ipsec_p1_prop_obj.remove("encryption_algorithm");
				}
				else			   
				ipsec_p1_prop_obj.put("encryption_algorithm",ISAKMP_enc);
				
				if(ISAKMP_hash == null || ISAKMP_hash.length() ==0)
				{
					if(ipsec_p1_prop_obj.containsKey("hash_algorithm"))
					ipsec_p1_prop_obj.remove("hash_algorithm");
				}
				else			   
				ipsec_p1_prop_obj.put("hash_algorithm",ISAKMP_hash);
			
				if(ISAKMP_grp == null || ISAKMP_grp.length() ==0)
				{
					if(ipsec_p1_prop_obj.containsKey("dh_group"))
					ipsec_p1_prop_obj.remove("dh_group");
				}
				else			   
				ipsec_p1_prop_obj.put("dh_group",ISAKMP_grp);
				
				if(ISAKMP_lifetime == null || ISAKMP_lifetime.length() ==0)
				{
					if(ipsec_p1_prop_obj.containsKey("ikelifetime"))
					ipsec_p1_prop_obj.remove("ikelifetime");
				}
				else			   
				ipsec_p1_prop_obj.put("ikelifetime",ISAKMP_lifetime);
				
				if(IPsec_enc == null || IPsec_enc.length() ==0)
				{
					if(ipsec_p2_pro_obj.containsKey("encryption_algorithm"))
					ipsec_p2_pro_obj.remove("encryption_algorithm");
				}
				else			   
				ipsec_p2_pro_obj.put("encryption_algorithm",IPsec_enc);
				
				if(IPsec_hash == null || IPsec_hash.length() ==0)
				{
					if(ipsec_p2_pro_obj.containsKey("authentication_algorithm"))
					ipsec_p2_pro_obj.remove("authentication_algorithm");
				}
				else			   
				ipsec_p2_pro_obj.put("authentication_algorithm",IPsec_hash);
			
				if(PFS_grp == null || PFS_grp.length() ==0)
				{
					if(ipsec_p2_pro_obj.containsKey("pfs_group"))
						ipsec_p2_pro_obj.remove("pfs_group");
					if(ipsec_p2_pro_obj.containsKey("pfs"))
						ipsec_p2_pro_obj.remove("pfs");
				}
				else if(PFS_grp.equals("disable"))
				{
					ipsec_p2_pro_obj.put("pfs_group",PFS_grp);
					ipsec_p2_pro_obj.put("pfs","no");
				}
				else
				{
					ipsec_p2_pro_obj.put("pfs_group",PFS_grp);
					ipsec_p2_pro_obj.put("pfs","yes");
				}
			
				if(IPsec_lifetime == null || IPsec_lifetime.length() ==0)
				{
					if(ipsec_p2_pro_obj.containsKey("lifetime"))
					ipsec_p2_pro_obj.remove("lifetime");
				}
				else			   
				ipsec_p2_pro_obj.put("lifetime",IPsec_lifetime);
			
				if(DPD_status == null || DPD_status.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("dpdaction"))
					ipsec_inst_obj.remove("dpdaction");
				}
				else			   
				ipsec_inst_obj.put("dpdaction",DPD_status);
			
				if(DPD_Int == null || DPD_Int.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("dpddelay"))
					ipsec_inst_obj.remove("dpddelay");
				}
				else			   
				ipsec_inst_obj.put("dpddelay",DPD_Int);
			
				if(DPD_to == null || DPD_to.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("dpdtimeout"))
					ipsec_inst_obj.remove("dpdtimeout");
				}
				else			   
				ipsec_inst_obj.put("dpdtimeout",DPD_to);
			
				if(trackip == null || trackip.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("trackip"))
					ipsec_inst_obj.remove("trackip");
				}
				else			   
				ipsec_inst_obj.put("trackip",trackip);
			
				if(srcintfce == null || srcintfce.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("tracksource"))
					ipsec_inst_obj.remove("tracksource");
				}
				else			   
				ipsec_inst_obj.put("tracksource",srcintfce.equals("custom")?srcintfceCustom:srcintfce);
			
				if(interval == null || interval.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("interval"))
					ipsec_inst_obj.remove("interval");
				}
				else			   
				ipsec_inst_obj.put("interval",interval);
			
				if(retries == null || retries.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("retries"))
					ipsec_inst_obj.remove("retries");
				}
				else			   
				ipsec_inst_obj.put("retries",retries);
			
				if(trackfailure == null || trackfailure.length() ==0)
				{
					if(ipsec_inst_obj.containsKey("trackfailure"))
					ipsec_inst_obj.remove("trackfailure");
				}
				else			   
				ipsec_inst_obj.put("trackfailure",trackfailure);
				if(activation!=null)
				ipsec_inst_obj.put("enabled","1");
				else
				ipsec_inst_obj.put("enabled","0");
				
				/* if(authmode.equals("1"))
				{
					if(rbipsec==null)
						ipsec_inst_obj.put("auto","start");
					else
						ipsec_inst_obj.put("auto","route");
				}
				else */
					ipsec_inst_obj.put("auto","add");
				
				if(natt!=null)
					ipsec_inst_obj.put("mobike","yes");
				else
					ipsec_inst_obj.put("mobike","no");
				
				if(lanbypas!=null)
				ipsec_tun_trans_obj.put("bypass","1");
				else
				ipsec_tun_trans_obj.put("bypass","0");
			
				if(tracking!=null)
				ipsec_inst_obj.put("tracking","1");
				else
				ipsec_inst_obj.put("tracking","0");
				
				ipsec_obj.put("remote:"+instancename,ipsec_inst_obj);
				ipsec_obj.put(ipsec_tun_trans_obj_key,ipsec_tun_trans_obj);
				ipsec_obj.put("p1_proposal:"+instancename+"_p1",ipsec_p1_prop_obj);
				ipsec_obj.put("p2_proposal:"+instancename+"_p2",ipsec_p2_pro_obj);

			   //setSaveIndex(wizjsonnode,save_val);
			   //wizjsonnode.getJSONObject("ipsec").put("ipsec",ipsec_obj);
			   
		   		wizjsonnode.put("ipsec",ipsec_obj);
		   		 //JSONObject ipsec_ins_info_obj = null;
			   	//if(!ipsec_info_obj.containsKey("status:"+instancename))
			   		//ipsec_ins_info_obj = new JSONObject();
			   	//else
			   		//ipsec_ins_info_obj = ipsec_info_obj.getJSONObject("status:"+instancename);
			   	
				//ipsec_ins_info_obj.put("active",(oplevel != null && oplevel.equals("main"))?"1":0);
				//ipsec_ins_info_obj.put("instance",instancename);
				//ipsec_info_obj.put("status:"+instancename,ipsec_ins_info_obj); 
			}	
			   BufferedWriter jsonWriter = null;
			   try
			   {
					jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					jsonWriter.write(wizjsonnode.toString(2));
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
				   internal_err = true;
			   }
			   finally
			   {
				   if(jsonWriter != null)
				   jsonWriter.close();
			   }			
			}
			else if(pagename.equals("healthcheck"))
			{
			    procpage="healthcheck.jsp";
				save_val = REMOTE;
				JSONObject remotepingobj =  wizjsonnode.getJSONObject("remoteping");
				JSONObject remconfigobj =  remotepingobj.getJSONObject("remoteping:configinfo");
				String remenb = request.getParameter("ena/dis");
				String remhealth = request.getParameter("healthchkon");
				String remact = request.getParameter("actfail");
				String rempri = request.getParameter("pinterface");
				String remsec = request.getParameter("sinterface");
				String remip1 = request.getParameter("remip1");
				String remip2 = request.getParameter("remip2");
				String remint = request.getParameter("interval");
				String remtime = request.getParameter("tout");
				String remcyls = request.getParameter("cycles");
				String remsucc = request.getParameter("susper");
				if(remenb==null)
					remconfigobj.remove("enabled");
				if(remhealth==null || remhealth.trim().length() == 0)
					remconfigobj.remove("healthchkon");
				if(remact==null || remact.trim().length() == 0 )
					remconfigobj.remove("action");
				if(remenb!=null && remhealth!=null && remact!=null)
				{
					if(InterfaceOverlaps.IsSimsActive(wizjsonnode) && remenb.equals("on") && remhealth.equals("Cellular") && remact.equals("SIMShift"))
					{
							procpage = "healthcheck.jsp";
							errmsg ="SIM Shift Failed !! Both SIMs are not activated ..";
							 %>
<script>
						    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
							 </script>
<% }
						else
						{
							remconfigobj.put("enabled","on");
							remconfigobj.put("healthchkon",remhealth);
							remconfigobj.put("action",remact);
						}
				   } 
				else
				{
					remconfigobj.put("healthchkon",remhealth);
					remconfigobj.put("action",remact);
				}
					
						
				if(rempri==null || rempri.trim().length() == 0)
					remconfigobj.remove("primary");
				else
					remconfigobj.put("primary",rempri);
				if(remsec==null || remsec.trim().length() == 0)
					remconfigobj.remove("secondary");
				else
					remconfigobj.put("secondary",remsec);
				
				if(remip1==null || remip1.trim().length() == 0)
					remconfigobj.remove("remote1");
				else
					remconfigobj.put("remote1",remip1);
				
				if(remip2==null || remip2.trim().length() == 0)
					remconfigobj.remove("remote2");
				else
					remconfigobj.put("remote2",remip2);
				
				if(remint==null || remint.trim().length() == 0)
					remconfigobj.remove("interval");
				else
					remconfigobj.put("interval",remint);
				
				if(remtime==null || remtime.trim().length() == 0)
					remconfigobj.remove("timeout");
				else
					remconfigobj.put("timeout",remtime);
				if(remcyls==null || remcyls.trim().length() == 0)
					remconfigobj.remove("cycles");
				else
					remconfigobj.put("cycles",remcyls);
				if(remsucc==null|| remsucc.trim().length() == 0 )
					remconfigobj.remove("success");
				else
					remconfigobj.put("success",remsucc);
				//remotepingobj.put("remoteping:configinfo:",remconfigobj);
				
				remotepingobj.put("remoteping:configinfo",remconfigobj);
				wizjsonnode.put("remoteping",remotepingobj);
				 BufferedWriter jsonWriter = null;
				   try
				   {
					   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					   jsonWriter.write(wizjsonnode.toString(2));
				   }
				   catch(Exception e)
				   {
					   e.printStackTrace();
					   internal_err = true;
				   }
				   finally
				   {
					   if(jsonWriter != null)
					   jsonWriter.close();
				   }
			}
			else if(pagename.equals("smsconfig"))
			{
				procpage="smsconfig.jsp";
				save_val = SMSCONFIG;
				JSONObject smsconfig_obj =  wizjsonnode.getJSONObject("cellular").getJSONObject("SMS:sms");
				String sim1num = request.getParameter("Srcmn1");
				String sim2num = request.getParameter("Srcmn2");
				String sim3num = request.getParameter("Srcmn3");
				String sim1cmn = request.getParameter("Sim1cmn");
				String sim2cmn = request.getParameter("Sim2cmn");
				String cold_warmstart = request.getParameter("cold_warmstart");
				String linkud = request.getParameter("linkud");
				if(sim1num == null || sim1num.length() ==0)
				{
					if(smsconfig_obj.containsKey("Srcmn1"))
						smsconfig_obj.remove("Srcmn1");
				}
				else			   
					smsconfig_obj.put("Srcmn1",sim1num);
				if(sim2num == null || sim2num.length() ==0)
				{
					if(smsconfig_obj.containsKey("Srcmn2"))
						smsconfig_obj.remove("Srcmn2");
				}
				else			   
					smsconfig_obj.put("Srcmn2",sim2num);
				if(sim3num == null || sim3num.length() ==0)
				{
					if(smsconfig_obj.containsKey("Srcmn3"))
						smsconfig_obj.remove("Srcmn3");
				}
				else			   
					smsconfig_obj.put("Srcmn3",sim3num);
				
				if(sim1cmn == null || sim1cmn.length() ==0)
				{
					if(smsconfig_obj.containsKey("Sim1cmn"))
						smsconfig_obj.remove("Sim1cmn");
				}
				else			   
					smsconfig_obj.put("Sim1cmn",sim1cmn);
				
				if(sim2cmn == null || sim2cmn.length() ==0)
				{
					if(smsconfig_obj.containsKey("Sim2cmn"))
						smsconfig_obj.remove("Sim2cmn");
				}
				else			   
					smsconfig_obj.put("Sim2cmn",sim2cmn);
				if(cold_warmstart == null || cold_warmstart.length() ==0)
					smsconfig_obj.put("cold_warmstart","0");
				else			   
					smsconfig_obj.put("cold_warmstart","1");
				if(linkud == null || linkud.length() ==0)
					smsconfig_obj.put("linkud","0");
				else			   
					smsconfig_obj.put("linkud","1");
				BufferedWriter jsonWriter = null;
				   try
				   {
					   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					   jsonWriter.write(wizjsonnode.toString(2));
				   }
				   catch(Exception e)
				   {
					   e.printStackTrace();
					   internal_err = true;
				   }
				   finally
				   {
					   if(jsonWriter != null)
					   jsonWriter.close();
				   }
			}
			else if(pagename.equals("edit_password") || pagename.equals("password")) 
			{
				boolean isnewobj = true;
				String username = request.getParameter("username");
				String action = request.getParameter("action")==null?"":request.getParameter("action");
				String new_pass = request.getParameter("newPassword");
				//String action = request.getParameter("action")==null?"":request.getParameter("action");
				if(pagename.equals("edit_password"))
					procpage = "password.jsp";//procpage = "edit_password.jsp";
				else
					procpage = "password.jsp";
				save_val = PWD;
				JSONArray edit_pwd_arr =  wizjsonnode.containsKey("htpasswd_decrypt")?(wizjsonnode.getJSONObject("htpasswd_decrypt").containsKey("credentials")?wizjsonnode.getJSONObject("htpasswd_decrypt").getJSONArray("credentials"):new JSONArray()):new JSONArray();
				JSONObject edit_pwdpage = new JSONObject();
				int obj_index = -1;
			    for(int i=0;i<edit_pwd_arr.size();i++)
				{
					JSONObject tempobj = edit_pwd_arr.getJSONObject(i);
					if(tempobj.getString("username").equals(username))
					{
						edit_pwdpage = tempobj;
						isnewobj = false;
						obj_index = i;
						break;
					}
				}
				if(action.equals("delete") && pagename.equals("password"))
				{
					if(obj_index != -1)
						edit_pwd_arr.remove(obj_index);
				}
				else if(action.equals("edituser"))
				{
					String cur_pass = request.getParameter("currentPassword");
					if(obj_index != -1)
					{
						JSONObject userObj = edit_pwd_arr.getJSONObject(obj_index);
						if(cur_pass != null)
						{
							if(cur_pass.trim().length() > 0)
							{
								if(userObj.getString("password").equals(cur_pass))
								{
									userObj.put("password",new_pass);
								}
								else
								{
									procpage = "edit_password.jsp";
									errmsg = "Invalid Current Password&username="+username;
								}
							}
						}
					}
				}
				else if(action.equals("adduser"))
				{
					JSONObject userObj = new JSONObject();
					userObj.put("username",username);
					userObj.put("password",new_pass);
					edit_pwd_arr.add(userObj);
				}
	   		} 
			else if(pagename.equals("reboot"))
			{
			    procpage="reboot.jsp";
				save_val = SEH_REBOOT;
				JSONObject sysobj = wizjsonnode.containsKey("system")?wizjsonnode.getJSONObject("system"):new JSONObject();
				JSONObject rebinfoobj = sysobj.containsKey("reboot:info")?sysobj.getJSONObject("reboot:info"):new JSONObject();
				JSONObject rebsectypeweekobj = sysobj.containsKey("sch_rebt:Weekly")?sysobj.getJSONObject("sch_rebt:Weekly"):new JSONObject();
  				JSONObject rebsectypemonobj=sysobj.containsKey("sch_rebt:Monthly")?sysobj.getJSONObject("sch_rebt:Monthly"):new JSONObject();
				String rebsec= request.getParameter("sch_actrebt");
				String rebtype = request.getParameter("schdle_type");
				String rebweeksun = request.getParameter("sun_box");
				String rebweekmon = request.getParameter("mon_box");
				String rebweektue = request.getParameter("tue_box");
				String rebweekweb = request.getParameter("wed_box");
				String rebweekthr = request.getParameter("thu_box");
				String rebweekfri = request.getParameter("fri_box");
				String rebweeksat = request.getParameter("sat_box");
				String rebweekhrs = request.getParameter("week_hrs");
				String rebweekmin = request.getParameter("week_mins");
				//String rebmonths = request.getParameter("months");
				String rebmondate = request.getParameter("date");
				String rebmonhrs = request.getParameter("month_hrs");
				String rebmonmin = request.getParameter("month_mins");
				if(rebsec==null)
				{
					sysobj.remove("reboot:info");
					sysobj.remove("sch_rebt:Weekly");
					sysobj.remove("sch_rebt:Monthly");
					rebtype="";
				}
				else if(rebtype.equals("Monthly"))
					sysobj.remove("sch_rebt:Weekly");
				else if(rebtype.equals("Weekly"))
					sysobj.remove("sch_rebt:Monthly");	
					
				if(rebsec==null)
					rebinfoobj.put("sch_rebt","0");
				else
					rebinfoobj.put("sch_rebt","1");
				if(rebtype==null || rebtype.trim().isEmpty() || rebsec == null)
					rebinfoobj.put("schdle_type","");
				else
					rebinfoobj.put("schdle_type",rebtype);
				if(rebtype.equals("Weekly"))
				{
				if(rebweeksun==null)
					rebsectypeweekobj.put("sunday","0");
				else
					rebsectypeweekobj.put("sunday","1");
				
				if(rebweekmon==null)
					rebsectypeweekobj.put("monday","0");
				else
					rebsectypeweekobj.put("monday","1");
				if(rebweektue==null)
					rebsectypeweekobj.put("tuesday","0");
				else
					rebsectypeweekobj.put("tuesday","1");
				
				if(rebweekweb==null)
					rebsectypeweekobj.put("wednesday","0");
				else
					rebsectypeweekobj.put("wednesday","1");
				
				if(rebweekthr==null)
					rebsectypeweekobj.put("thursday","0");
				else
					rebsectypeweekobj.put("thursday","1");
				
				if(rebweekfri==null)
					rebsectypeweekobj.put("friday","0");
				else
					rebsectypeweekobj.put("friday","1");
				
				if(rebweeksat==null)
					rebsectypeweekobj.put("saturday","0");
				else
					rebsectypeweekobj.put("saturday","1");
				if(rebweekhrs==null||rebweekhrs.trim().isEmpty())
					rebsectypeweekobj.remove("hours");
				else
					rebsectypeweekobj.put("hours",rebweekhrs);
				if(rebweekmin==null||rebweekmin.trim().isEmpty())
					rebsectypeweekobj.remove("minutes");
				else
					rebsectypeweekobj.put("minutes",rebweekmin);
				}
				// months type
				else if(rebtype.equals("Monthly"))
				{
				/* if(rebmonths==null ||rebmonths.trim().isEmpty())
					rebsectypemonobj.remove("months");
				else
					rebsectypemonobj.put("months",rebmonths); */
				if(rebmondate==null||rebmondate.trim().isEmpty())
					rebsectypemonobj.remove("date");
				else
					rebsectypemonobj.put("date",rebmondate);
				if(rebmonhrs==null ||rebmonhrs.trim().isEmpty())
					rebsectypemonobj.remove("hours");
				else
					rebsectypemonobj.put("hours",rebmonhrs);
				if(rebmonmin==null||rebmonmin.trim().isEmpty())
					rebsectypemonobj.remove("minutes");
				else
					rebsectypemonobj.put("minutes",rebmonmin);
				}
				if(rebsec!=null){
					
				sysobj.put("reboot:info",rebinfoobj);
				if(rebtype.equals("Weekly"))
					sysobj.put("sch_rebt:Weekly",rebsectypeweekobj);
				else if(rebtype.equals("Monthly"))
					sysobj.put("sch_rebt:Monthly",rebsectypemonobj);
				wizjsonnode.put("system",sysobj);
				}
				 BufferedWriter jsonWriter = null;
				   try
				   {
					   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
					   jsonWriter.write(wizjsonnode.toString(2));
				   }
				   catch(Exception e)
				   {
					   e.printStackTrace();
					   internal_err = true;
				   }
				   finally
				   {
					   if(jsonWriter != null)
					   jsonWriter.close();
				   }
			}
			else if(pagename.equals("wificonfig")||pagename.equals("edit_wificonfig"))
			{
				 //WIFI_CONFIG
				boolean isnewobj = true;
				String ssname = request.getParameter("essid");
				String action = request.getParameter("action")==null?"":request.getParameter("action");
				procpage = "wificonfig.jsp";
				save_val = WIFI_CONFIG;
				JSONObject lanobj=wizjsonnode.getJSONObject("network").getJSONObject("interface:lan");
				JSONObject edit_wifi=wizjsonnode.containsKey("wireless")?wizjsonnode.getJSONObject("wireless"):new JSONObject();
				JSONObject edit_wifidev_arr=edit_wifi.containsKey("wifi-device:radio0")?edit_wifi.getJSONObject("wifi-device:radio0"):new JSONObject();
				JSONArray edit_wifiint_arr =  edit_wifi.containsKey("wifi-iface")?edit_wifi.getJSONArray("wifi-iface"):new JSONArray();
				JSONObject editwifipage = new JSONObject();
				int obj_index = -1;
			 	for(int i=0;i<edit_wifiint_arr.size();i++)
				{
					JSONObject tempobj =(JSONObject )edit_wifiint_arr.get(i);
					if(tempobj.getString("ssid").equals(ssname))
					{
						editwifipage = tempobj;
						isnewobj = false;
						obj_index = i;
						break;
					}
				}
				if(action.equals("delete") &&edit_wifi.containsKey("wifi-device:radio0"))
				{
					if(obj_index !=-1){
						edit_wifidev_arr.put("disabled","1");
						edit_wifidev_arr.put("hwmode","11g");
						edit_wifidev_arr.put("htmode","HT20");
						edit_wifidev_arr.put("channel","11");
						edit_wifidev_arr.put("txpower","20");
						lanobj.put("type","none");
						lanobj.put("brlan","0");
						edit_wifi.remove("wifi-iface");
					}
				}
				else if(pagename.equals("wificonfig"))
				{
					int wifirows = Integer.parseInt(request.getParameter("wificnt"));
					int wifiind=0;
					for(int i=1;i<wifirows;i++)
					{
						String sname = request.getParameter("ss_id"+i);
						String activation = request.getParameter("activation"+i);
						if(activation != null)
						{
							edit_wifidev_arr.put("disabled","0");
							lanobj.put("type","bridge");
							lanobj.put("brlan","1");
						}
						else
						{
							edit_wifidev_arr.put("disabled","1");
							lanobj.put("type","none");
							lanobj.put("brlan","0");
						}
						wifiind++;
					}
				}
				else if(pagename.equals("edit_wificonfig"))
				{
					String activation = request.getParameter("activation");
					String mode = request.getParameter("oprfrcymode");
					String chan = request.getParameter("oprfrcychannel");
					String twpwr = request.getParameter("trans_pow");
					String encry = request.getParameter("selencryption"); 
					String cipher = request.getParameter("cipher"); 
					String key = request.getParameter("key"); 
					String network_check = request.getParameter("network_check"); 
					String encipval="";
					switch(encry)
					{
					   case "3":
						   encry="psk" ;
						   break;
					   case "4":
						   encry="psk2" ;
						   break;
					   case "5":
						   encry="psk-mixed" ;
						   break;
					   case "6":
							encry="none";	
							break;
					}
					switch(cipher)
					{
					   case "1":
						   cipher="ccmp" ;
						   break;
					   case "2":
						   cipher="tkip" ;
						   break;
					   case "3":
						   cipher="tkip+ccmp";
						   break;
					}
					if(!encry.equals("none"))
						 encipval=encry.concat("+"+cipher);
					editwifipage.put("ssid",ssname);
					editwifipage.put("device","radio0");
					editwifipage.put("mode","ap");
					
					if(activation!=null)
					{
						edit_wifidev_arr.put("disabled","0");
						lanobj.put("type","bridge");
						lanobj.put("brlan","1");
					}
					else
					{
						edit_wifidev_arr.put("disabled","1");
						lanobj.put("type","none");
						lanobj.put("brlan","0");
					}
					if(mode!=null)
					{ 
						if(mode.equals("11g/n"))
						{
							edit_wifidev_arr.put("hwmode","11g");
							edit_wifidev_arr.put("htmode","HT20");
						}
						else
						{
							edit_wifidev_arr.put("hwmode",mode);
							edit_wifidev_arr.remove("htmode");
						}
					}
					else
						edit_wifidev_arr.put("hwmode","");
					if(chan!=null)
						edit_wifidev_arr.put("channel",chan);
					else
						edit_wifidev_arr.put("channel","");
					if(twpwr!=null)
						edit_wifidev_arr.put("txpower",twpwr);
					else
						edit_wifidev_arr.put("txpower","");
					if(encipval!=null&&!encry.equals("none"))
							editwifipage.put("encryption",encipval);
					else if(encry.equals("none"))
							editwifipage.put("encryption",encry);
					else
						editwifipage.put("encryption","");
					if(key!=null&&!encry.equals("none"))
						editwifipage.put("key",key);
					if(network_check!=null)
						editwifipage.put("network","lan");
					if(isnewobj)
						{
							 edit_wifiint_arr.add(editwifipage);
							 edit_wifi.put("wifi-device:radio0", edit_wifidev_arr);
							 edit_wifi.put("wifi-iface", edit_wifiint_arr);
						} 
				} 
				   BufferedWriter jsonWriter = null;
				   wizjsonnode.put("wireless",edit_wifi);
				   try
				   {
						jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
						jsonWriter.write(wizjsonnode.toString(2));
				   }
				   catch(Exception e)
				   {
					   e.printStackTrace();
					   internal_err = true;
				   }
				   finally
				   {
					   if(jsonWriter != null)
					   jsonWriter.close();
				   }	
			}//elseif end
			
			//DYNAMIC_ROUTING Start
			else if(pagename.equals("ospfv2") ||pagename.equals("ospfv3"))
			{
				 //OSPFV2
				save_val = DYNAMIC_ROUTING;
				procpage="dynamic_routing.jsp";
		//ospfv2 starts here
			if(pagename.equals("ospfv2"))
			 {
				JSONObject ospfobj =  wizjsonnode.containsKey("ospf")?wizjsonnode.getJSONObject("ospf"):new JSONObject();
				
				JSONObject ospfdefobj=ospfobj.containsKey("global:daemon")?ospfobj.getJSONObject("global:daemon"):new JSONObject();
				JSONArray redisarr = ospfdefobj.containsKey("Redistribute")?ospfdefobj.getJSONArray("Redistribute"):new JSONArray();
				JSONArray areaarr = ospfdefobj.containsKey("Area")?ospfdefobj.getJSONArray("Area"):new JSONArray();
				JSONObject ospfnwobj =  ospfobj.containsKey("net:network")?ospfobj.getJSONObject("net:network"):new JSONObject();
				JSONArray nwarr=  ospfnwobj.containsKey("Network")?ospfnwobj.getJSONArray("Network"):new JSONArray();
				JSONObject ospfeth0obj = ospfobj.containsKey("interface:Eth0")?ospfobj.getJSONObject("interface:Eth0"):new JSONObject();
				JSONObject ospfeth1obj = ospfobj.containsKey("interface:Eth1")?ospfobj.getJSONObject("interface:Eth1"):new JSONObject();
				int retrirows = Integer.parseInt(request.getParameter("redistributecnt"));
				int arearows = Integer.parseInt(request.getParameter("areacnt"));
				int nwrows = Integer.parseInt(request.getParameter("netwrkrwcnt"));
				String subdivpage=request.getParameter("subdivpage");
				showdiv=subdivpage;
				String nwareavals="";
				//instance vals start
				String en=request.getParameter("intf_ospfv2");
				String autoroute=request.getParameter("ospf_autocheck");
				String routeid=request.getParameter("ospf_routerid");
				String admdis=request.getParameter("adm_dis");
				String def_metric=request.getParameter("deflt_metric");
				String autocostref=request.getParameter("ref_bw");
				String definfo=request.getParameter("dfo");
				String defalwys=request.getParameter("dfo_alw");
				if(en!=null)
					ospfdefobj.put("Ospf4","enable"); 
				else
					ospfdefobj.remove("Ospf4");
				if(autoroute!=null)
				{
					ospfdefobj.put("auto_routerid","on");
					ospfdefobj.remove("routerid");
				}
				if(routeid!=null)
				{
					ospfdefobj.put("routerid",routeid);
					ospfdefobj.remove("auto_routerid");
				}
				if(admdis ==null || admdis.trim().length()==0)
					ospfdefobj.put("adm_dis","110");
				else
					ospfdefobj.put("adm_dis",admdis);
				if(def_metric ==null || def_metric.trim().length()==0)
					ospfdefobj.put("deflt_metric","12");
				else
					ospfdefobj.put("deflt_metric",def_metric);
				if(autocostref ==null || autocostref.trim().length()==0)
					ospfdefobj.put("ref_bw","100");
				else
					ospfdefobj.put("ref_bw",autocostref);
				if(definfo!=null)
					ospfdefobj.put("dfo","on");
				else
					ospfdefobj.remove("dfo");
				if(defalwys!=null)
					ospfdefobj.put("dfo_alw","on");
				else
					ospfdefobj.remove("dfo_alw");
				for(int i=redisarr.size()-1;i>=0;i--)
				{
					redisarr.remove(i);
				}
				for(int i=1;i<retrirows;i++)
				{
					String reslinks = request.getParameter("links"+i);
					String resmetric_type = request.getParameter("metric_type"+i);
					String resmetric = request.getParameter("metric"+i);
					String resopts="";
					if(reslinks!=null&& resmetric_type!=null&&resmetric!=null)
					{
						if(reslinks.equals("Static Routes"))
								reslinks="kernel";
						else if(reslinks.equals("Connected Routes"))
								reslinks="connected";
						else
							reslinks="bgp";
					
					if(resmetric_type.equals("type1"))
						resmetric_type="1";
					else
						resmetric_type="2";
					if(resmetric.isEmpty())
						resmetric="-";
					resopts=reslinks.concat("/"+resmetric_type+"/"+resmetric);
					redisarr.add(resopts);
					}
				}
				 ospfdefobj.put("Redistribute", redisarr);
				//instance vals ends
				//network vals start
				for(int i=nwarr.size()-1;i>=0;i--)
					nwarr.remove(i);
				for(int i=1;i<nwrows;i++)
				{
					String ipaddr = request.getParameter("network"+i);
					String subnet = request.getParameter("network_subnet"+i);
					String area = request.getParameter("area"+i);
					String ipval="";
					String nwvals="";
					if(ipaddr!=null&&subnet!=null&&area!=null)
					{
						SubnetUtils sutils = new SubnetUtils(ipaddr,subnet);
						ipval=sutils.getInfo().getCidrSignature();
						nwvals=sutils.getInfo().getCidrSignature().concat("/"+area);
						nwarr.add(nwvals);
						//nwareavals+=area;
					}
				}
					ospfnwobj.put("Network", nwarr);
				//network vals ends
				//eth0 vals starts
				String eth0pass=request.getParameter("e0passive_int");
				String eth0hloint=request.getParameter("e0heloIntrvl");
				String eth0deadint=request.getParameter("e0deadIntrvl");
				String eth0auth=request.getParameter("e0authentication");
				String eth0pwd=request.getParameter("e0pwd");
				String eth0nw_type=request.getParameter("e0ospf_network_type");
				String eth0autointrcost=request.getParameter("e0intrfcost_check");
				String eth0intrcost=request.getParameter("e0intrfcost");
				String eth0routepri=request.getParameter("e0router_priority");
				String e0keyid=request.getParameter("e0keyid");
				if(eth0pass!=null)
					ospfeth0obj.put("passive","on");
				else
					ospfeth0obj.remove("passive");
				if(eth0hloint ==null ||eth0hloint.trim().length()==0)
					ospfeth0obj.put("hello_time","10");
				else
					ospfeth0obj.put("hello_time",eth0hloint);
				if(eth0deadint ==null ||eth0deadint.trim().length()==0)
					ospfeth0obj.put("dead_time","40");
				else
					ospfeth0obj.put("dead_time",eth0deadint);
				if(eth0auth!=null)
					ospfeth0obj.put("authentication", eth0auth);
				else
					ospfeth0obj.put("authentication","disabled");
				if(eth0pwd ==null ||eth0pwd.trim().length()==0 )
					ospfeth0obj.remove("password");
				else
					ospfeth0obj.put("password", eth0pwd);
				if(e0keyid!=null)
					ospfeth0obj.put("md5_key", e0keyid);
				if(eth0nw_type!=null)
					ospfeth0obj.put("network_type", eth0nw_type);
				else
					ospfeth0obj.put("network_type","broadcast");
				if(eth0autointrcost!=null)
					ospfeth0obj.put("auto_cost","on");
				else
					ospfeth0obj.remove("auto_cost");
				if(eth0intrcost ==null ||eth0intrcost.trim().length()==0)
					ospfeth0obj.remove("cost_value");
				else
					ospfeth0obj.put("cost_value",eth0intrcost);
				if(eth0routepri ==null ||eth0routepri.trim().length()==0)
					ospfeth0obj.remove("priority");
				else
					ospfeth0obj.put("priority",eth0routepri);
				//eth0 vals ends
				//eth1 vals starts
				String eth1pass=request.getParameter("e1passive_int");
				String eth1hloint=request.getParameter("e1heloIntrvl");
				String eth1deadint=request.getParameter("e1deadIntrvl");
				String eth1auth=request.getParameter("e1authentication");
				String eth1pwd=request.getParameter("e1pwd");
				String eth1nw_type=request.getParameter("e1ospf_network_type");
				String eth1autointrcost=request.getParameter("e1intrfcost_check");
				String eth1intrcost=request.getParameter("e1intrfcost");
				String eth1routepri=request.getParameter("e1router_priority");
				String e1keyid=request.getParameter("e1keyid");
				if(eth1pass!=null)
					ospfeth1obj.put("passive","on");
				else
					ospfeth1obj.remove("passive");
				if(eth1hloint ==null ||eth1hloint.trim().length()==0)
					ospfeth1obj.put("hello_time","10");
				else
					ospfeth1obj.put("hello_time",eth1hloint);
				if(eth1deadint ==null ||eth1deadint.trim().length()==0)
					ospfeth1obj.put("dead_time","40");
				else
					ospfeth1obj.put("dead_time",eth1deadint);
				if(eth1auth!=null)
					ospfeth1obj.put("authentication", eth1auth);
				else
					ospfeth1obj.put("authentication","disabled");
				if(eth1pwd ==null ||eth1pwd.trim().length()==0 )
					ospfeth1obj.remove("password");
				else
					ospfeth1obj.put("password", eth1pwd);
				if(e1keyid!=null)
					ospfeth1obj.put("md5_key", e1keyid);
				if(eth1nw_type!=null)
					ospfeth1obj.put("network_type", eth1nw_type);
				else
					ospfeth1obj.put("network_type","broadcast");
				if(eth1autointrcost!=null)
					ospfeth1obj.put("auto_cost","on");
				else
					ospfeth1obj.remove("auto_cost");
				if(eth1intrcost ==null ||eth1intrcost.trim().length()==0)
					ospfeth1obj.remove("cost_value");
				else
					ospfeth1obj.put("cost_value",eth1intrcost);
				if(eth1routepri ==null ||eth1routepri.trim().length()==0)
					ospfeth1obj.remove("priority");
				else
					ospfeth1obj.put("priority",eth1routepri);
				//eth1 vals ends
				//area vals starts
				for(int i=areaarr.size()-1;i>=0;i--)
					areaarr.remove(i);
				for(int i=1;i<arearows;i++)
				{
					String areaid = request.getParameter("area_id"+i);
					String area_type = request.getParameter("area_type"+i);
					String areasum_int = request.getParameter("sum_int"+i);
					String areaopts="";
					if(areaid != null &&area_type!= null&&areasum_int!= null)
					{
						if(area_type.equals("Stub"))
							area_type="stub";
						else if(area_type.equals("Totally Stub"))
							area_type="totally-stub";
						else if(area_type.equals("NSSA"))
							area_type="nssa";
						else if(area_type.equals("Totally NSSA"))
							area_type="totally-nssa";
						else 
							 area_type="@";
						if(areaid.equals("0"))
							area_type="@";
						if(areasum_int.isEmpty())
							areasum_int="@";
						areaopts=areaid.concat("|"+area_type+"|"+areasum_int);
						areaarr.add(areaopts);
					}
				}
				 ospfdefobj.put("Area", areaarr);
				//area vals ends
				 ospfobj.put("global:daemon", ospfdefobj);
				 ospfobj.put("net:network", ospfnwobj);
				 ospfobj.put("interface:Eth0",ospfeth0obj);
				 ospfobj.put("interface:Eth1",ospfeth1obj);
				 wizjsonnode.put("ospf",ospfobj);
				//ospfv2 ends
			 }
			//ospfv3 Starts here
			else if(pagename.equals("ospfv3"))
			{
		        JSONObject ospf3obj =  wizjsonnode.containsKey("ospf6")?wizjsonnode.getJSONObject("ospf6"):new JSONObject();
				JSONObject ospf3defobj=ospf3obj.containsKey("global:daemon")?ospf3obj.getJSONObject("global:daemon"):new JSONObject();
				JSONArray v3redisarr = ospf3defobj.containsKey("Redistribute")?ospf3defobj.getJSONArray("Redistribute"):new JSONArray();
				JSONArray v3areaarr = ospf3defobj.containsKey("Area")?ospf3defobj.getJSONArray("Area"):new JSONArray();
				JSONArray v3intfacearr=  ospf3defobj.containsKey("Interface")?ospf3defobj.getJSONArray("Interface"):new JSONArray();
				JSONObject ospf3eth0obj = ospf3obj.containsKey("interface:Eth0")?ospf3obj.getJSONObject("interface:Eth0"):new JSONObject();
				JSONObject ospf3eth1obj = ospf3obj.containsKey("interface:Eth1")?ospf3obj.getJSONObject("interface:Eth1"):new JSONObject();
				int intfacerows = Integer.parseInt(request.getParameter("intfv3rwcnt"));
				int v3arearows = Integer.parseInt(request.getParameter("areav3cnt"));
				String subdivpage=request.getParameter("ospf3_subdivpage");
				showdiv=subdivpage;
				//instance vals start
				String v3en=request.getParameter("intf_ospf_v3");
				String v3autoroute=request.getParameter("ospf_autocheck_v3");
				String v3routeid=request.getParameter("ospf_routerid_v3");
				String v3admdis=request.getParameter("adm_dis_v3");
				String v3refbw=request.getParameter("ref_bw_v3");
				String retribte_arr[] = request.getParameterValues("protos");
				if(retribte_arr == null)
					retribte_arr = new String[0];
				if(v3en!=null)
					ospf3defobj.put("Ospf6","enable");
				else
					ospf3defobj.remove("Ospf6");
				if(v3autoroute!=null)
				{
					ospf3defobj.put("auto_routerid","on");
					ospf3defobj.remove("routerid");
				}
				if(v3routeid!=null)
				{
					ospf3defobj.put("routerid",v3routeid);
					ospf3defobj.remove("auto_routerid");
				}
				if(v3admdis ==null ||v3admdis.trim().length()==0)
					ospf3defobj.put("adm_dis","110");
				else
					ospf3defobj.put("adm_dis",v3admdis);
				if(v3refbw ==null || v3refbw.trim().length()==0)
					ospf3defobj.put("ref_bw","100");
				else
					ospf3defobj.put("ref_bw",v3refbw);
				if(ospf3defobj.containsKey("Redistribute"))
					ospf3defobj.remove("Redistribute");
				JSONArray json_proto_arr = new JSONArray();
				for(String val : retribte_arr)
					json_proto_arr.add(val);	
				ospf3defobj.put("Redistribute",json_proto_arr);
				//instance vals ends
				//interface vals starts
				for(int i=v3intfacearr.size()-1;i>=0;i--)
					v3intfacearr.remove(i);
				for(int i=1;i<intfacerows;i++)
				{
					String intfceval = request.getParameter("intfce"+i);
					String areaval = request.getParameter("intfarea"+i);
					String intface="";
					if(intfceval!=null&&areaval!=null)
					{
						if(intfceval.equals("loopback"))
							intfceval="lo";
						intface=intfceval.concat("/0.0.0."+areaval);
					    v3intfacearr.add(intface);
					}
				}
				ospf3defobj.put("Interface", v3intfacearr);
				//interface vals ends
				//eth0 vals starts
				String v3eth0pass=request.getParameter("e0passive_int_v3");
				String v3eth0hloint=request.getParameter("e0heloIntrvl_v3");
				String v3eth0deadint=request.getParameter("e0deadIntrvl_v3");
				String v3eth0nw_type=request.getParameter("e0ospf_network_type_v3");
				String v3eth0autointrcost=request.getParameter("e0intrfcost_check_v3");
				String v3eth0intrcost=request.getParameter("e0intrfcost_v3");
				String v3eth0routepri=request.getParameter("e0router_priority_v3");
				if(v3eth0pass!=null)
					ospf3eth0obj.put("passive","on");
				else
					ospf3eth0obj.remove("passive");
				if(v3eth0hloint ==null ||v3eth0hloint.trim().length()==0)
					ospf3eth0obj.put("hello_time","10");
				else
					ospf3eth0obj.put("hello_time",v3eth0hloint);
				if(v3eth0deadint ==null ||v3eth0deadint.trim().length()==0)
					ospf3eth0obj.put("dead_time","40");
				else
					ospf3eth0obj.put("dead_time",v3eth0deadint);
				if(v3eth0nw_type!=null)
					ospf3eth0obj.put("network_type",v3eth0nw_type);
				else
					ospf3eth0obj.put("network_type","broadcast");
				if(v3eth0autointrcost!=null)
					ospf3eth0obj.put("auto_cost","on");
				else
					ospf3eth0obj.remove("auto_cost");
				if(v3eth0intrcost ==null ||v3eth0intrcost.trim().length()==0)
					ospf3eth0obj.remove("cost_value");
				else
					ospf3eth0obj.put("cost_value",v3eth0intrcost);
				if(v3eth0routepri ==null ||v3eth0routepri.trim().length()==0)
					ospf3eth0obj.remove("priority");
				else
					ospf3eth0obj.put("priority",v3eth0routepri);
				//eth0 vals ends
				//eth1 vals starts
				String v3eth1pass=request.getParameter("e1passive_int_v3");
				String v3eth1hloint=request.getParameter("e1heloIntrvl_v3");
				String v3eth1deadint=request.getParameter("e1deadIntrvl_v3");
				String v3eth1nw_type=request.getParameter("e1ospf_network_type_v3");
				String v3eth1autointrcost=request.getParameter("e1intrfcost_check_v3");
				String v3eth1intrcost=request.getParameter("e1intrfcost_v3");
				String v3eth1routepri=request.getParameter("e1router_priority_v3");
				if(v3eth1pass!=null)
					ospf3eth1obj.put("passive","on");
				else
					ospf3eth1obj.remove("passive");
				if(v3eth1hloint ==null ||v3eth1hloint.trim().length()==0)
					ospf3eth1obj.put("hello_time","10");
				else
					ospf3eth1obj.put("hello_time",v3eth1hloint);
				if(v3eth1deadint ==null ||v3eth1deadint.trim().length()==0)
					ospf3eth1obj.put("dead_time","40");
				else
					ospf3eth0obj.put("dead_time",v3eth0deadint);
				if(v3eth1nw_type!=null)
					ospf3eth1obj.put("network_type", v3eth1nw_type);
				else
					ospf3eth1obj.put("network_type","broadcast");
				if(v3eth1autointrcost!=null)
					ospf3eth1obj.put("auto_cost","on");
				else
					ospf3eth1obj.remove("auto_cost");
				if(v3eth1intrcost ==null ||v3eth1intrcost.trim().length()==0)
					ospf3eth1obj.remove("cost_value");
				else
					ospf3eth1obj.put("cost_value",v3eth1intrcost);
				if(v3eth1routepri ==null ||v3eth1routepri.trim().length()==0)
					ospf3eth1obj.remove("priority");
				else
					ospf3eth1obj.put("priority",v3eth1routepri);
				//eth1 vals ends
				//area vals starts
				for(int i=v3areaarr.size()-1;i>=0;i--)
					v3areaarr.remove(i);
				for(int i=1;i<v3arearows;i++)
				{
					String v3areaid = request.getParameter("area_id_v3"+i);
					String v3area_type = request.getParameter("area_type_v3"+i);
					String v3areasum_int = request.getParameter("sum_int_v3"+i);
					String v3areaopts="";
					if(v3area_type==null)
						v3area_type="-";
					if(v3areaid!=null&&v3area_type!=null&&v3areasum_int!= null)
					{
						if(v3area_type.equals("Stub"))
							v3area_type="stub";
						else if(v3area_type.equals("Totally Stub")) 
							v3area_type="totally-stub";
						else
							v3area_type="@";
						if(v3areaid.equals("0"))
							v3area_type="@";
						if(v3areasum_int.isEmpty())
							v3areasum_int="@";
						v3areaopts=v3areaid.concat("|"+v3area_type+"|"+v3areasum_int);
						v3areaarr.add(v3areaopts);
					}
				}
				 ospf3defobj.put("Area",v3areaarr);
				//area vals ends
				 ospf3obj.put("global:daemon", ospf3defobj);
				 ospf3obj.put("interface:Eth0",ospf3eth0obj);
				 ospf3obj.put("interface:Eth1",ospf3eth1obj);
				 wizjsonnode.put("ospf6",ospf3obj);
			}//ospfv3 ends 
				   BufferedWriter jsonWriter = null;
				   try
				   {
						jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
						jsonWriter.write(wizjsonnode.toString(2));
				   }
				   catch(Exception e)
				   {
					   e.printStackTrace();
					   internal_err = true;
				   }
				   finally
				   {
					   if(jsonWriter != null)
					   jsonWriter.close();
				   }	
			}//DYNAMIC_ROUTING  End
			//BGP Starts
			else if(pagename.equals("bgp_instance") ||pagename.equals("path_summarization") ||pagename.equals("add_pathsum"))
			{
				 //OSPFV2
				save_val = BGP;
				procpage="dynamic_routing.jsp";
			   	JSONObject bgpobj =  wizjsonnode.containsKey("bgp")?wizjsonnode.getJSONObject("bgp"):new JSONObject();
				JSONObject bgpdefobj=bgpobj.containsKey("global:dae_mon")?bgpobj.getJSONObject("global:dae_mon"):new JSONObject();
				JSONArray json_proto_arr= new JSONArray();
			//bgp instance starts here
			
			if(pagename.equals("bgp_instance"))
			 {
				showdiv="bgp_instance";
				JSONArray bgpredisarr = bgpdefobj.containsKey("Redistribute")?bgpdefobj.getJSONArray("Redistribute"):new JSONArray();
				//JSONArray bgpnwarr=  bgpdefobj.containsKey("Network")?bgpdefobj.getJSONArray("Network"):new JSONArray();
				JSONArray bgpnwarr= bgpdefobj.containsKey("Network")?bgpdefobj.getJSONArray("Network"):new JSONArray();
				int nwrows = Integer.parseInt(request.getParameter("bgpnwcnt"));
				String en=request.getParameter("ins_enable");
				String autoroute=request.getParameter("bgp_autocheck");
				String routeid=request.getParameter("bgp_routerid");
				String sysnum=request.getParameter("sysnum");
				String admdis=request.getParameter("admindis");
				String ibgp_admdis=request.getParameter("ibgp_admindis");
				String proto_arr[] = request.getParameterValues("proto");
				if(proto_arr == null)
					proto_arr = new String[0];
				if(en!=null)
					bgpdefobj.put("BGP","enable");
				else
					bgpdefobj.remove("BGP");
				if(autoroute!=null)
				{
					bgpdefobj.put("bgp_autocheck","on");
					bgpdefobj.remove("bgp_routerid");
				}
				if(routeid!=null)
				{
					bgpdefobj.put("bgp_routerid",routeid);
					bgpdefobj.remove("bgp_autocheck");
				}
				if(sysnum==null ||sysnum.trim().length() == 0)
					bgpdefobj.remove("sysnum");
				else
					bgpdefobj.put("sysnum",sysnum);
				if(admdis==null ||admdis.trim().length() == 0)
					bgpdefobj.put("admindis","20");
				else
					bgpdefobj.put("admindis",admdis);
				if(ibgp_admdis ==null||ibgp_admdis.trim().length() == 0)
					bgpdefobj.put("ibgp_admindis","200");
				else
					bgpdefobj.put("ibgp_admindis",ibgp_admdis);
				if(bgpdefobj.containsKey("Redistribute"))
				{
					if(proto_arr.length==0)
						bgpdefobj.remove("Redistribute");				
				}
				for(String protocol : proto_arr)
					json_proto_arr.add(protocol);
				bgpdefobj.put("Redistribute",json_proto_arr);
				
				for(int i=bgpnwarr.size()-1;i>=0;i--)
				{
					bgpnwarr.remove(i);
				}
				for(int i=7;i<=nwrows;i++)
				{
					String ipaddr = request.getParameter("bgp_netk"+i);
					if(ipaddr!=null &&ipaddr.trim().length()>0)
						bgpnwarr.add(ipaddr);
				}
					bgpdefobj.put("Network",bgpnwarr);
			//instance vals ends
			 }
				//pathSummConfig vals starts
		else
		{
			showdiv="path_summarization";
			JSONArray bgppathsumarr=  bgpdefobj.containsKey("path_summ")?bgpdefobj.getJSONArray("path_summ"):new JSONArray();
			String name = request.getParameter("name");
			String action = request.getParameter("action")==null?"":request.getParameter("action");
			int index = request.getParameter("index")==null?-1:(Integer.parseInt(request.getParameter("index")));
			if(pagename.equals("path_summarization"))
			{
				if(action.equals("delete")&&name!=null)
				{
					for(int i=0;i<bgppathsumarr.size();i++)
					{
						String namevals = bgppathsumarr.get(i).toString();
						if(namevals.contains(name))
						{
							bgppathsumarr.remove(namevals);
							break;
						}
					}
				}
				else
				{
					int pathsumrows = Integer.parseInt(request.getParameter("bgp_pathsum_rwcnt"));
					String activation=null;
					for(int j=0;j<pathsumrows-1;j++)
					{
						activation = request.getParameter("path_main_enable"+(j+1));
						activation=activation!=null?"1":"0";
						String pathsumval = bgppathsumarr.get(j).toString();
						pathsumval = activation+pathsumval.substring(1);
						bgppathsumarr.remove(j);
						bgppathsumarr.add(j, pathsumval);
					}
				}
			}
			else if(pagename.equals("add_pathsum"))
			{
		 		showdiv="add_pathsum";
				String pathen=request.getParameter("summ_enable");
				String pathaddre=request.getParameter("summ_addr");
				String pathsumonly=request.getParameter("summ_flag");
				String pathasset=request.getParameter("summ_as_flag");
				String pathsummvals="";
				pathen=pathen!=null?"1":"0";
				pathsumonly=pathsumonly!=null?"1":"0";
				pathasset=pathasset!=null?"1":"0";
				pathsummvals=pathen.concat("-"+pathaddre+"-"+pathsumonly+"-"+pathasset);
				if(action.equals("add"))
					bgppathsumarr.add(pathsummvals);
				else
				{
						String pathsumval = bgppathsumarr.get(index-1).toString();
						bgppathsumarr.remove(index-1);
						bgppathsumarr.add(index-1, pathsummvals);
				}
				//PathSummConfig vals ends
			}
			bgpdefobj.put("path_summ", bgppathsumarr);
		}
			
			bgpobj.put("global:dae_mon", bgpdefobj);
			wizjsonnode.put("bgp",bgpobj);
				   BufferedWriter jsonWriter = null;
				   try
				   {
						jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
						jsonWriter.write(wizjsonnode.toString(2));
				   }
				   catch(Exception e)
				   {
					   e.printStackTrace();
					   internal_err = true;
				   }
				   finally
				   {
					   if(jsonWriter != null)
					   jsonWriter.close();
				   }	
			}
			else if(pagename.equals("bgp_peers") ||pagename.equals("add_bgppeer")||pagename.equals("add_bgppeersetteings")||pagename.equals("add_bgppath")
					|| pagename.equals("bgppeersettingsdiv")|| pagename.equals("path_filtering"))
			{
				 //BGP 
				save_val = BGP;
				procpage="dynamic_routing.jsp";
				String  name="";
				String action = request.getParameter("action")==null?"":request.getParameter("action");
			   	JSONObject bgpobj =  wizjsonnode.containsKey("bgp")?wizjsonnode.getJSONObject("bgp"):new JSONObject();
			   	JSONObject 	bgppeerrecord = null;
			//bgp peer records starts here
			if(pagename.equals("bgp_peers"))
			{
				showdiv="bgp_peers";
				name=request.getParameter("name");
				if(action.equals("delete")&&name!=null)
					bgpobj.remove("Peer_Records:"+name);
				else
				{
					int peerrows = Integer.parseInt(request.getParameter("bgp_peers_rwcnt"));
					for(int i=1;i<peerrows;i++)
					{
						String bgpname=request.getParameter("bgpname"+i);
						String activation = request.getParameter("main_en"+i);
						bgppeerrecord=bgpobj.containsKey("Peer_Records:"+bgpname)?bgpobj.getJSONObject("Peer_Records:"+bgpname):new JSONObject();
						if(activation!= null)
							bgppeerrecord.put("bgp_peer_en","on");
						else
							bgppeerrecord.remove("bgp_peer_en");
					}
				}
				
			}
			else if(pagename.equals("add_bgppeer"))
			 {
				showdiv="add_bgppeer";
				name=request.getParameter("peername");
				peername=name;
				bgppeerrecord=bgpobj.containsKey("Peer_Records:"+name)?bgpobj.getJSONObject("Peer_Records:"+name):new JSONObject();
			   	JSONArray recordsarr=bgppeerrecord.containsKey("Records")?bgppeerrecord.getJSONArray("Records"):new JSONArray();
			   	JSONObject bgpdefobj=bgpobj.containsKey("global:dae_mon")?bgpobj.getJSONObject("global:dae_mon"):new JSONObject();
			   	int remrows=Integer.parseInt(request.getParameter("bgpremnumcnt"));
			 	int neighrows=Integer.parseInt(request.getParameter("bgpneighnumcnt"));
				String peeren=request.getParameter("bgp_peer_en");
				String autosys=bgpdefobj.containsKey("sysnum")?bgpdefobj.getString("sysnum"):null;
				if(autosys==null)
				{
					errmsg+= "First Save the Autonomous System Number in Instance\n";
				%>
				   <script>
 						goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
  				  </script>
			   <%}
				else
			    {
					String bgptype="";
					if(peeren!=null)
						bgppeerrecord.put("bgp_peer_en","on");
					else
						bgppeerrecord.remove("bgp_peer_en");
					if(name!=null)
						bgppeerrecord.put("peername",name);
					else
						bgppeerrecord.remove("peername");
					
					for(int i=recordsarr.size()-1;i>=0;i--)
						recordsarr.remove(i);
					for(int i=2;i<=remrows;i++)
					{
						String remsys = request.getParameter("bgp_remsys"+i);
						String remsysarr="";
						if(remsys!=null)
						{
							if(autosys.equals(remsys))
								bgptype+="Ibgp";	
							else
								bgptype+="Ebgp";
							if(bgptype.contains("Ibgp")&&bgptype.contains("Ebgp"))
							{
									errmsg += "All Members must be either Internal or External  \n";
						   %>
						   <script>
				   				    goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				   			</script>
						   <%}
							else
							{
								for(int j=1;j<=neighrows;j++)
								{
									String neiaddre=request.getParameter("bgp_remsys"+i+"nei"+j);
									if(neiaddre!=null )
										recordsarr.add(remsys.concat("-"+neiaddre));
								}
							}
						}
							
					}

						if(errmsg.isEmpty())
						{
							bgppeerrecord.put("bgp_type","Ebgp");
							bgppeerrecord.put("Records",recordsarr);
							bgpobj.put("Peer_Records:"+name,bgppeerrecord);
						}
				}
			//peerrecords vals ends
			 }
			else if(pagename.equals("bgppeersettingsdiv"))
				showdiv="bgppeersettingsdiv";
			else if(pagename.equals("add_bgppeersetteings"))
			 {
				showdiv="add_bgppeersetteings";
				name=request.getParameter("peer_records");
				peername=name;
				bgppeerrecord=bgpobj.containsKey("Peer_Records:"+name)?bgpobj.getJSONObject("Peer_Records:"+name):new JSONObject();
				String des=request.getParameter("description");
				String pwd=request.getParameter("peer_password");
				String kepalivetme=request.getParameter("keep_timer");
				String hldtime=request.getParameter("hold_timer");
				String udurc=request.getParameter("update_source");
				String deforg=request.getParameter("default_org");
				String passive=request.getParameter("passive");
				String ttlauto=request.getParameter("ttl_check");
				String ttlval=request.getParameter("ttl_hops");
				String nxthop=request.getParameter("nexthop_self");
				String refclient=request.getParameter("reflector_client");
				String severclient=request.getParameter("server_client");
				if(name!=null)
					bgppeerrecord.put("peername",name);
				if(!des.isEmpty())
					bgppeerrecord.put("description",des);
				else
					bgppeerrecord.remove("description");
				if(!pwd.isEmpty())
					bgppeerrecord.put("password",pwd);
				else
					bgppeerrecord.remove("password");
				if(kepalivetme!=null)
					bgppeerrecord.put("keep_timer",kepalivetme);
				else
					bgppeerrecord.put("keep_timer","60");
				if(hldtime!=null)
					bgppeerrecord.put("hold_timer",hldtime);
				else
					bgppeerrecord.put("hold_timer","180");
				if(!udurc.isEmpty())
					bgppeerrecord.put("update_source",udurc);
				else
					bgppeerrecord.remove("update_source");
				if(deforg!=null)
					bgppeerrecord.put("default_org","on");
				else
					bgppeerrecord.remove("default_org");
				
				if(passive!=null)
					bgppeerrecord.put("passive","on");
				else
					bgppeerrecord.remove("passive");
				if(ttlauto!=null)
				{
					bgppeerrecord.put("ttl_check","on");
					bgppeerrecord.put("ttl_hops",ttlval);
				}
				else
				{
					bgppeerrecord.remove("ttl_check");
					bgppeerrecord.remove("ttl_hops");
				}
				if(nxthop!=null)
					bgppeerrecord.put("nexthop_self","on");
				else
					bgppeerrecord.remove("nexthop_self");
				if(refclient!=null)
					bgppeerrecord.put("reflector_client","on");
				else
					bgppeerrecord.remove("reflector_client");
				if(severclient!=null)
					bgppeerrecord.put("server_client","on");
				else
					bgppeerrecord.remove("server_client");
				bgpobj.put("Peer_Records:"+name,bgppeerrecord);
			//settings  vals ends
			 }
			//path filtering
			else if(pagename.equals("path_filtering"))
				showdiv="path_filtering";
			else if(pagename.equals("add_bgppath"))
			 {
				showdiv="add_bgppath";
				name=request.getParameter("path_peer_records");
				peername=name;
				bgppeerrecord=bgpobj.containsKey("Peer_Records:"+name)?bgpobj.getJSONObject("Peer_Records:"+name):new JSONObject();
				String ipprefix=request.getParameter("path_prefix_list");
				String direc=request.getParameter("path_direction");
				if(name!=null)
					bgppeerrecord.put("peername",name);
				if(ipprefix!=null)
					bgppeerrecord.put("prefix_list",ipprefix);
				else
					bgppeerrecord.remove("prefix_list");
				if(direc!=null)
				{
					if(direc.equals("Inbound"))
						direc="in";
					else
						direc="out";
					bgppeerrecord.put("path_direction",direc);
				}
				else
					bgppeerrecord.remove("path_direction");
				bgpobj.put("Peer_Records:"+name,bgppeerrecord);
			 }
			if(errmsg.length()<0)
				wizjsonnode.put("bgp",bgpobj);
			//path filtering ends
				   BufferedWriter jsonWriter = null;
				   try
				   {
						jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
						jsonWriter.write(wizjsonnode.toString(2));
				   }
				   catch(Exception e)
				   {
					   e.printStackTrace();
					   internal_err = true;
				   }
				   finally
				   {
					   if(jsonWriter != null)
					   jsonWriter.close();
				   }	
			}
			//BGP ends 
			 //ipprefix list starts 
	
	else if(pagename.equals("ipprefixlist")  || pagename.equals("edit_ipprefixlist")) 
	{
		boolean isnewobj = true;
		String prefixname = request.getParameter("prefixname");
		String name=request.getParameter("name");
		String action = request.getParameter("action")==null?"":request.getParameter("action");
		procpage = "ipprefixlist.jsp";
		save_val = IPPREFIXLIST;
		JSONObject ipprefixobj = wizjsonnode.containsKey("ipprefix")?wizjsonnode.getJSONObject("ipprefix"):new JSONObject();
		JSONObject edit_ipprefixobj = ipprefixobj.containsKey("List:"+prefixname)?ipprefixobj.getJSONObject("List:"+prefixname):new JSONObject();
		JSONArray prefixnwrk=edit_ipprefixobj.containsKey("Network")?edit_ipprefixobj.getJSONArray("Network"):new JSONArray();
		JSONObject bgpobj= wizjsonnode.containsKey("bgp")?wizjsonnode.getJSONObject("bgp"):new JSONObject();
		int obj_index = -1;
		String prefixopts="";
	    for(int i=0;i<edit_ipprefixobj.size();i++)
		{
	    	if(ipprefixobj.containsKey("List:"+prefixname))
			{
				isnewobj = false;
				obj_index = i;
				break;
			}
		}
		if(action.equals("delete") && pagename.equals("ipprefixlist"))
		{
			int i=0;
			Iterator<String> keys =bgpobj.keys();
		    while(keys.hasNext())
			{
				String ckey = keys.next();
				if(ckey.contains("Peer_Records:")){
				JSONObject peerred_obj = bgpobj.getJSONObject(ckey);
				String prefixopt="";
				if(peerred_obj.containsKey("prefix_list")){
					prefixopt = peerred_obj.getString("prefix_list");
				}
				i++;
				prefixopts +=prefixopt;
				}
			}
		    if(prefixopts.contains(prefixname))
		    {
				errmsg+= prefixname +" Already Selected in Path Filtering of BGP4 ";
				 %>
				   <script>
				   		goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
				   </script>
			<%}
		    else if(obj_index != -1)
				ipprefixobj.remove("List:"+prefixname);
		}
		else if(pagename.equals("ipprefixlist"))
		{
			int ipprefixrows = Integer.parseInt(request.getParameter("prefixlistcnt"));
		    JSONObject newedit_obj=null;
			for(int i=1;i<ipprefixrows;i++)
			{
				String nameval=request.getParameter("prefixname"+i);
				String activation = request.getParameter("activation"+i);
				newedit_obj=ipprefixobj.containsKey("List:"+nameval)?ipprefixobj.getJSONObject("List:"+nameval):new JSONObject();
				if(activation != null)
					newedit_obj.put("Instance","Enable");
				else
					newedit_obj.remove("Instance");
			}
		}
		else if(pagename.equals("edit_ipprefixlist"))
		{
			int ipnwrows = Integer.parseInt(request.getParameter("add_prefixlist_rwcnt"));
			int recordscnt = Integer.parseInt(request.getParameter("records"));
			String enable= request.getParameter("actvn");
			String listname= request.getParameter("prefixlistname");
			String prefixlist="List:"+listname;
			edit_ipprefixobj.put("Records",String.valueOf(recordscnt));
			if(enable!=null)
				edit_ipprefixobj.put("Instance","Enable");
			else
				edit_ipprefixobj.remove("Instance");
			for(int i=prefixnwrk.size()-1;i>=0;i--)
			{
				prefixnwrk.remove(i);
			}
			for(int i=3;i<=ipnwrows;i++)
			{
				String ipval = request.getParameter("network"+i);
				String startran = request.getParameter("start_range"+i);
				String endran = request.getParameter("end_range"+i);
				String perorden = request.getParameter("preaccess"+i);
				String prefixnwopts="";
				if(ipval!=null&&startran!=null&&endran!= null&&perorden!= null)
				{
					if(startran.isEmpty())
						startran="@";
					if(endran.isEmpty())
						endran="@";
					prefixnwopts=ipval.concat("-"+startran+"-"+endran+"-"+perorden);
					prefixnwrk.add(prefixnwopts);
				}
			}
			 edit_ipprefixobj.put("Network",prefixnwrk);
		   if(isnewobj)
		   {
			   ipprefixobj.put("List:"+listname,edit_ipprefixobj);
			   wizjsonnode.put("ipprefix",ipprefixobj);
		   }
		}
	   BufferedWriter jsonWriter = null;
	   try
	   {
			jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			jsonWriter.write(wizjsonnode.toString(2));
	   }
	   catch(Exception e)
	   {
		   e.printStackTrace();
		   internal_err = true;
	   }
	   finally
	   {
		   if(jsonWriter != null)
		   jsonWriter.close();
	   }
	}
	//ipprefixlist ends
	
	//openvpn starts
	else if(pagename.equals("openvpn")  || pagename.equals("clientvpn")||pagename.equals("pointtopoint")) 
	{
		boolean isnewobj = true;
		String name=request.getParameter("name");
		String action = request.getParameter("action")==null?"":request.getParameter("action");
		procpage = "openvpn.jsp";
		save_val = OPENVPN;
		JSONObject openvpnobj = wizjsonnode.containsKey("openvpn")?wizjsonnode.getJSONObject("openvpn"):new JSONObject();
		JSONObject edit_openvpnobj = openvpnobj.containsKey("openvpn:"+name)?openvpnobj.getJSONObject("openvpn:"+name):new JSONObject();
		JSONArray tls_ciphers_arr= new JSONArray(); 
		int obj_index = -1;
	    for(int i=0;i<edit_openvpnobj.size();i++)
		{
	    	if(openvpnobj.containsKey("openvpn:"+name))
			{
				isnewobj = false;
				obj_index = i;
				break;
			}
		}
		if(action.equals("delete") && pagename.equals("openvpn"))
		{
			if(obj_index != -1)
				openvpnobj.remove("openvpn:"+name);
		}
		else if(pagename.equals("openvpn"))
		{
			int rows = Integer.parseInt(request.getParameter("opvpconf"));
		    JSONObject newedit_obj=null;
			for(int i=1;i<rows;i++)
			{
				String nameval=request.getParameter("name"+i);
				String protocal=request.getParameter("protocal"+i);
				String remoteaddress = request.getParameter("remoteaddress"+i);
				String remoteport = request.getParameter("remoteport"+i);
				String activation = request.getParameter("activation"+i);
				String iconval=request.getParameter("icontext"+i);
				newedit_obj=openvpnobj.containsKey("openvpn:"+nameval)?openvpnobj.getJSONObject("openvpn:"+nameval):new JSONObject();
				if(protocal != null)
					newedit_obj.put("proto",protocal);
				else
					newedit_obj.remove("proto");
				if(remoteaddress != null&&remoteport!=null)
				{
					newedit_obj.put("remote",remoteaddress+" "+remoteport);
					if(remoteaddress.equals("Local"))
						newedit_obj.put("port",remoteport);
				}
				else
					newedit_obj.remove("remote");
				if(activation != null)
				{
					newedit_obj.put("enabled","1");
					newedit_obj.put("connect","-1");
				}
				else
				{
					newedit_obj.remove("enabled");
					newedit_obj.remove("connect");
				}
			}
		}
		else if(pagename.equals("clientvpn"))
		{
			procpage = "client-vpn.jsp";
			String activation = request.getParameter("mainact");
			String openvpnname = request.getParameter("name");
			instname = openvpnname;
			String remoteaddress = request.getParameter("remoteaddress");
			String remoteport = request.getParameter("remoteport");
			String protocol = request.getParameter("protocol"); 
			String commonname = request.getParameter("commonname"); 
			String tlsactivation = request.getParameter("tlsactivation");
			String hmacauth = request.getParameter("hmacauth");
			
			String userpassactivation = request.getParameter("userpassactivation");
			String tls_ciphers[] = request.getParameterValues("proto");
			   if(tls_ciphers == null)
				   tls_ciphers = new String[0];
			String cipher = request.getParameter("cipher"); 
			String hmacalgor = request.getParameter("hmacalgor"); 
			String compress = request.getParameter("compress");
			String algorithm = request.getParameter("algorithm");
			String tlskey = request.getParameter("tlskey");
			String keepalive = request.getParameter("keepalive"); 
			String timeout = request.getParameter("timeout");
			String catabselfile=request.getParameter("catabselfile");
			String certtabselfile=request.getParameter("certtabselfile");
			String keytabselfile=request.getParameter("keytabselfile");
			String hmactabselfile=request.getParameter("hmactabselfile");
			String uptabselfile=request.getParameter("uptabselfile");
			if(activation!=null)
				edit_openvpnobj.put("enabled","1");
			else
			{
				edit_openvpnobj.remove("enabled");
				if(edit_openvpnobj.containsKey("connect"))
					edit_openvpnobj.remove("connect");
			}
			if(openvpnname!=null)
				edit_openvpnobj.put("instance",openvpnname);
			if(remoteaddress!=null && remoteport!=null)
				edit_openvpnobj.put("remote",remoteaddress+" "+remoteport);
			else
				edit_openvpnobj.remove("remote");
			if(protocol!=null)
				edit_openvpnobj.put("proto",protocol);
			if(commonname!=null&&commonname.length()>0)
				edit_openvpnobj.put("verify_x509_name",commonname+" name");
			else
				edit_openvpnobj.remove("verify_x509_name");
			if(tlsactivation!=null)
			{
				edit_openvpnobj.put("tls_client","1");
				if(hmacauth!=null)
					edit_openvpnobj.put("hmac_auth","1");
				else
					edit_openvpnobj.remove("hmac_auth");
				edit_openvpnobj.put("remote_cert_tls","server");
			}
			else
			{
				edit_openvpnobj.remove("tls_client");
				edit_openvpnobj.remove("remote_cert_tls");
				edit_openvpnobj.remove("hmac_auth");
			}
			if(userpassactivation!=null)
				edit_openvpnobj.put("user_auth","1");
			else
				edit_openvpnobj.remove("user_auth");
			
			if(hmacalgor!=null)
				edit_openvpnobj.put("auth",hmacalgor);
			else
				edit_openvpnobj.remove("auth");
			if(edit_openvpnobj.containsKey("tls_cipher"))
				edit_openvpnobj.remove("tls_cipher");
		   for(String cipherval : tls_ciphers)
		   {
				tls_ciphers_arr.add(cipherval);
		   }
		   edit_openvpnobj.put("tls_cipher",tls_ciphers_arr);
			if(cipher!=null)
				edit_openvpnobj.put("cipher",cipher);
			if(compress!=null)
				edit_openvpnobj.put("compress",algorithm.equals("LZ4-V2")?"lz4-v2":algorithm.equals("LZ4")?"lz4":"lzo");
			else 
				edit_openvpnobj.remove("compress");
			if(tlskey!=null)
				edit_openvpnobj.put("reneg_sec",tlskey);
			else
				edit_openvpnobj.remove("reneg_sec");
			if(keepalive!=null && timeout!=null)
				edit_openvpnobj.put("keepalive",keepalive+" "+timeout);
			else
				edit_openvpnobj.remove("keepalive");
			if(catabselfile!=null&&catabselfile.length()>0)
				edit_openvpnobj.put("ca","/etc/openvpn/"+catabselfile);
			else
				edit_openvpnobj.remove("ca");
			if(certtabselfile!=null&&certtabselfile.length()>0)
				edit_openvpnobj.put("cert","/etc/openvpn/client/"+certtabselfile);
			else
				edit_openvpnobj.remove("cert");
			if(keytabselfile!=null&&keytabselfile.length()>0)
				edit_openvpnobj.put("key","/etc/openvpn/client/"+keytabselfile);
			else
				edit_openvpnobj.remove("key");
			if(hmactabselfile!=null&&hmactabselfile.length()>0)
				edit_openvpnobj.put("tls_auth","/etc/openvpn/hmac/"+hmactabselfile);
			else
				edit_openvpnobj.remove("tls_auth");
			if(uptabselfile!=null&&uptabselfile.length()>0)
				edit_openvpnobj.put("auth_user_pass","/etc/openvpn/user/"+uptabselfile);
			else
				edit_openvpnobj.remove("auth_user_pass");
			if(isnewobj)
				{
				 //default config 
				   edit_openvpnobj.put("configuration", "Client To Server");
				   edit_openvpnobj.put("reset", "0");
				   edit_openvpnobj.put("instance", openvpnname);
				   edit_openvpnobj.put( "client", "1");
				   edit_openvpnobj.put( "dev", "tun");
				   edit_openvpnobj.put("persist_key", "1");
				   edit_openvpnobj.put("persist_tun", "1");
				   edit_openvpnobj.put("verb", "3");
				   if(activation!=null)
				   		edit_openvpnobj.put("connect", "-1");
				   edit_openvpnobj.put("save", "1");
				   edit_openvpnobj.put("log_append", "/var/log/"+instname+".log");
				   openvpnobj.put("openvpn:"+openvpnname,edit_openvpnobj);
				   wizjsonnode.put("openvpn",openvpnobj);
				} 
		}
		else if(pagename.equals("pointtopoint"))
		{
			procpage="pointtopoint.jsp";
			JSONArray route_arr=edit_openvpnobj.containsKey("route")?edit_openvpnobj.getJSONArray("route"):new JSONArray();
			int pointtabrows = Integer.parseInt(request.getParameter("addpointtopoint"));
			String activation = request.getParameter("mainact");
			String pointname = request.getParameter("inst_name");
			instname = pointname;
			String remoteaddress = request.getParameter("remoteaddress");
			String remoteport = request.getParameter("remoteport");
			String localipconfig = request.getParameter("ifconfig");
			String config_mode = request.getParameter("remotelocal");
			String remipconfig = request.getParameter("ifconfig1");
			String static_auth = request.getParameter("static_auth");
			String static_dir = request.getParameter("static_dir");
			String hmacalgor = request.getParameter("hmac_algor");
			String protocol = request.getParameter("protocol");
			String cipher = request.getParameter("cipher");
			String compress = request.getParameter("compress");
			String algorithm = request.getParameter("algorithm");
			String keepalive = request.getParameter("keepalive");
			String timeout = request.getParameter("timeout");
			String pasktabselfile = request.getParameter("pasktabselfile");
			String localport = request.getParameter("localport");
			if(activation!=null)
				edit_openvpnobj.put("enabled","1");
			else
			{
				edit_openvpnobj.remove("enabled");
				if(edit_openvpnobj.containsKey("connect"))
					edit_openvpnobj.remove("connect");
			}
			if(protocol!=null)
				edit_openvpnobj.put("proto",protocol);
			if(pasktabselfile != null && pasktabselfile.length()>0)
				edit_openvpnobj.put("secret","/etc/openvpn/psk/"+pasktabselfile);
			else
				edit_openvpnobj.remove("secret");
			if(localipconfig != null && remipconfig != null)
				edit_openvpnobj.put("ifconfig",localipconfig+" "+remipconfig);
			else
				edit_openvpnobj.remove("ifconfig");
			if(static_auth!=null)
				edit_openvpnobj.put("static_auth","1");
			else
				edit_openvpnobj.remove("static_auth");
			if(static_dir!=null)
				edit_openvpnobj.put("static_dir",static_dir);
			if(config_mode!=null)
				edit_openvpnobj.put("configmode",config_mode.toLowerCase());
			if(config_mode.equalsIgnoreCase("remote")) {
				if(remoteaddress!=null && remoteport!=null)
					edit_openvpnobj.put("remote",remoteaddress+" "+remoteport);
				else
					edit_openvpnobj.remove("remote");
			}
			if(config_mode.equalsIgnoreCase("local")) {
				if(localport!=null)
				{
					edit_openvpnobj.put("port",localport);
					edit_openvpnobj.put("remote","Local "+localport);
				}
				else
					edit_openvpnobj.remove("port");
			}
			if(keepalive!=null && timeout != null)
				edit_openvpnobj.put("keepalive",keepalive+" "+timeout);
			else
				edit_openvpnobj.remove("keepalive");
			if(cipher!=null)
				edit_openvpnobj.put("cipher",cipher);
			else
				edit_openvpnobj.remove("cipher");
			if(compress!=null)
				edit_openvpnobj.put("compress",algorithm);
			else
				edit_openvpnobj.remove("compress");
			if(hmacalgor!=null)
				edit_openvpnobj.put("auth",hmacalgor);
			else
				edit_openvpnobj.remove("auth");
			if(cipher!=null)
				edit_openvpnobj.put("cipher",cipher);
			else
				edit_openvpnobj.remove("cipher");
			for(int i=route_arr.size()-1;i>=0;i--)
			{
				route_arr.remove(i);
			}
			for(int i=1;i<=pointtabrows;i++)
			{
				String nwk = request.getParameter("network"+i);
				String subnet = request.getParameter("subnetmask"+i);
				String routeval="";
				if(nwk != null &&subnet!= null &&nwk.length()>0&&subnet.length()>0)
				{
					
					routeval=nwk.concat(" "+subnet+" vpn_gateway");
					route_arr.add(routeval);
				}
			}
			if(route_arr.size()>0)
				 edit_openvpnobj.put("route", route_arr);
			if(isnewobj)
			{
			 //default config 
			   edit_openvpnobj.put("configuration", "Point To Point");
			   edit_openvpnobj.put("reset", "0");
			   edit_openvpnobj.put("instance", pointname);
			   //edit_openvpnobj.put( "client", "1");
			   edit_openvpnobj.put( "dev", "tun");
			   edit_openvpnobj.put("persist_key", "1");
			   edit_openvpnobj.put("persist_tun", "1");
			   edit_openvpnobj.put("verb", "3");
			   if(activation!=null)
			   		edit_openvpnobj.put("connect", "-1");
			   edit_openvpnobj.put("save", "1");
			   edit_openvpnobj.put("log_append", "/var/log/"+instname+".log");
			   openvpnobj.put("openvpn:"+pointname,edit_openvpnobj);
			   wizjsonnode.put("openvpn",openvpnobj);
			} 
		}
	   BufferedWriter jsonWriter = null;
	   try
	   {
			jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			jsonWriter.write(wizjsonnode.toString(2));
	   }
	   catch(Exception e)
	   {
		   e.printStackTrace();
		   internal_err = true;
	   }
	   finally
	   {
		   if(jsonWriter != null)
		   jsonWriter.close();
	   }
	}
	//openvpn ends
	
	//zerotire starts
	else if(pagename.equals("ZeroTier")) 
	{
		procpage = "zerotire.jsp";
		save_val = ZEROTIER;
		String secret="";
		String action=request.getParameter("action")==null?"":request.getParameter("action");
		String name=request.getParameter("name")==null?"":request.getParameter("name");
		int zero_tier_rcnt = request.getParameter("zerotierconf")==null?-1:Integer.parseInt(request.getParameter("zerotierconf"));
		JSONObject ztjsonobj = wizjsonnode.containsKey("zerotier")?wizjsonnode.getJSONObject("zerotier"):new JSONObject();
		JSONObject ztsampleobj = ztjsonobj.containsKey("zerotier:sample_config")?ztjsonobj.getJSONObject("zerotier:sample_config"):new JSONObject();
		JSONArray edit_portfrwd_arr =  wizjsonnode.containsKey("firewall")?(wizjsonnode.getJSONObject("firewall").containsKey("redirect")?wizjsonnode.getJSONObject("firewall").getJSONArray("redirect"):new JSONArray()):new JSONArray();
		boolean zt0exits=false;
		for(int j = 0; j<edit_portfrwd_arr.size(); j++)
		{
			JSONObject edit_portforwardobj=edit_portfrwd_arr.getJSONObject(j);
			String srcintface=edit_portforwardobj.containsKey("src")?edit_portforwardobj.getString("src"):"lan";
			String desintface=edit_portforwardobj.containsKey("dst")?edit_portforwardobj.getString("dst"):"lan";
			if(srcintface.equals("zt0")||desintface.equals("zt0"))
				zt0exits=true;
		}
		JSONArray joinarr=new JSONArray();
		int intterval=0;
			if(ztsampleobj.containsKey("secret"))
				 secret=ztsampleobj.getString("secret");
			if(!zt0exits)
				wizjsonnode.remove("zerotier");
			JSONObject zerotierobj=new JSONObject();
			JSONObject addzerotireobj=new JSONObject();
			JSONObject samzerotireobj=new JSONObject();
			for(int i = 1; i<zero_tier_rcnt; i++){
				String  ztname = request.getParameter("name"+i);
				String  networkid  = request.getParameter("networkid"+i);
				String  activation = request.getParameter("activation"+i);
				String  natclients = request.getParameter("natclients"+i);
				if(activation==null&&zt0exits)
				{
					if(zt0exits)
					{
						errmsg+=" ZeroTire is used  in PortForwards of Firewall ";
						 %>
						   <script>
						   		goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');
						   </script>
					<%}
				}
				else
				{
					if(networkid!=null&&networkid.length()>0)
						addzerotireobj.put("networkid",networkid);
					if(activation!=null&&activation.length()>0){
						addzerotireobj.put("activation","1");
						intterval++;
						if(!samzerotireobj.containsKey("enabled"))
					 		samzerotireobj.put("enabled", "1");
						if(!samzerotireobj.containsKey("nat"))
					 		samzerotireobj.put("nat", "1");
						joinarr.add(networkid);
					}
					else
					{
						wizjsonnode.remove("zerotier");
						addzerotireobj.put("activation","0");
						
						if(samzerotireobj.containsKey("nat"))
					 		samzerotireobj.remove("nat");
					}
					if(natclients!=null&&natclients.length()>0)
						addzerotireobj.put("natclient","1");
					else
						addzerotireobj.put("natclient","0");
					if(ztname!=null)
					   zerotierobj.put("zerotier:"+ztname,addzerotireobj);
			} }
			if(!zt0exits)
			{
				samzerotireobj.put("led", "0");
				samzerotireobj.put("interface", String.valueOf(intterval));
				if(joinarr.size()>0)
				{
					samzerotireobj.put("join", joinarr);
					if(samzerotireobj.containsKey("enabled"))
				 		samzerotireobj.put("enabled","1");
				}
				else
					samzerotireobj.put("enabled","0");
				samzerotireobj.put("secret", secret);
				zerotierobj.put("zerotier:sample_config",samzerotireobj);
				wizjsonnode.put("zerotier", zerotierobj);
			}
		//}
	   BufferedWriter jsonWriter = null;
	   try
	   {
			jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			jsonWriter.write(wizjsonnode.toString(2));
	   }
	   catch(Exception e)
	   {
		   e.printStackTrace();
		   internal_err = true;
	   }
	   finally
	   {
		   if(jsonWriter != null)
		   jsonWriter.close();
	   }
	}
	//zerotire ends
	
	//gre starts
	else if(pagename.equals("gre")||pagename.equals("edit_gre")) 
	{
		procpage = "gre.jsp";
		save_val = GRE;
		boolean isnewobj = true;
		String grename = request.getParameter("grename");
		String action = request.getParameter("action")==null?"":request.getParameter("action");
		JSONObject nwobj=wizjsonnode.containsKey("network")?wizjsonnode.getJSONObject("network"):new JSONObject();
		JSONObject tuninfo=nwobj.containsKey("info:tuninfo")?nwobj.getJSONObject("info:tuninfo"):new JSONObject();
		String grecnt=tuninfo.containsKey("grecnt")?tuninfo.getString("grecnt"):"";
		JSONObject editgreobj=nwobj.containsKey("interface:"+grename)?nwobj.getJSONObject("interface:"+grename):new JSONObject();
		String tunnelname=editgreobj.containsKey("tunnel")?editgreobj.getString("tunnel"):"";
		JSONObject tunnelobj=nwobj.containsKey("interface:"+tunnelname)?nwobj.getJSONObject("interface:"+tunnelname):new JSONObject();
		JSONArray route_arr=nwobj.containsKey("route")?nwobj.getJSONArray("route"):new JSONArray();
		JSONObject routetunnelobj=new JSONObject();
		for(int i=0;i<route_arr.size();i++)
		{
			routetunnelobj=route_arr.getJSONObject(i);
        	if(routetunnelobj.keySet().size() == 0 || (routetunnelobj.containsKey("interface") && routetunnelobj.getString("interface").equals(tunnelname)))
        	{
        		route_arr.remove(routetunnelobj);
        		i--;
        	}
        	else
        		routetunnelobj=new JSONObject();
		}
		int obj_index = -1;
	    for(int i=0;i<editgreobj.size();i++)
		{
	    	if(nwobj.containsKey("interface:"+grename))
			{
				isnewobj = false;
				obj_index = i;
				break;
			}
		}
		if(action.equals("delete") && pagename.equals("gre"))
		{
			int del_ind = request.getParameter("row")==null?-1:Integer.parseInt(request.getParameter("row"));
			int rowcnt = request.getParameter("rowcnt")==null?-1:Integer.parseInt(request.getParameter("rowcnt"));
			if(obj_index != -1)
			{
				nwobj.remove("interface:"+grename);
				nwobj.remove("interface:"+tunnelname);
			    tuninfo.put("grecnt", String.valueOf(rowcnt-2));
			   HashMap <String , JSONObject> gre_hm = new HashMap<String,JSONObject>();
			   ArrayList<String> tunnel_keys = new ArrayList<String>(); 
			   Set<String> keyset = nwobj.keySet();
			   for(String key : keyset)
			   {
				   if(key.contains("interface:"))
				   {
					   JSONObject jsonobj = nwobj.getJSONObject(key);
					   if(jsonobj.has("tunnel") && jsonobj.has("proto"))
						   gre_hm.put(key,jsonobj);
					   else if(jsonobj.has("ifname") && jsonobj.has("proto") && jsonobj.has("connected"))
						   tunnel_keys.add(key);
				   }
			   }
			   for(int i=route_arr.size()-1;i>=0;i--)
			   {
				   JSONObject routetunobj = route_arr.getJSONObject(i);
				   if(routetunobj.getString("interface").startsWith("tunnel"))
				   {   
					   String tun_name = routetunobj.getString("interface");
					   int lastind = Integer.parseInt(tun_name.substring(tun_name.length()-1,tun_name.length()));
					   if(lastind > del_ind)
					   {
						   lastind--;
						   routetunobj.put("interface", "tunnel"+lastind); 
						   route_arr.remove(i);
						   route_arr.add(i, routetunobj);
					   }
				   }
			   }
			   for(String key : gre_hm.keySet())
			   {
				   try
				   {
					   JSONObject greobj = nwobj.getJSONObject(key);
					   String tun_name = greobj.getString("tunnel");
					   int lastind = Integer.parseInt(tun_name.substring(tun_name.length()-1,tun_name.length()));
					   if(lastind > del_ind)
					   {
						   lastind--;
						   greobj.put("tunnel", "tunnel"+lastind); 
						   nwobj.put(key, greobj);
					   }
					   
				   }
				   catch(Exception e)
				   {
					   e.printStackTrace();
				   }
			   }
			   for(String tun_key : tunnel_keys)
			   {
				   try
				   {
					   String keystr = tun_key.substring(0,tun_key.length()-1);
					   int ind = Integer.parseInt(tun_key.substring(tun_key.length()-1,tun_key.length()));
					   if(ind > del_ind)
					   {
						   JSONObject tunobj = nwobj.getJSONObject(tun_key);
						   nwobj.remove(tun_key);
						   ind--;
						   String updated_key = keystr+ind;
						   nwobj.put(updated_key,tunobj);
					   }
				   }
				   catch(Exception e)
				   {
					   e.printStackTrace();
				   }
			   }
			    
			}
		}
		else if(pagename.equals("gre"))
		{
			int grerows = Integer.parseInt(request.getParameter("grerwcnt"));
		    JSONObject newedit_greobj=null;
		    JSONObject newtunnobj=null;
			for(int i=1;i<=grerows;i++)
			{
				String ogrename=request.getParameter("instancename"+i);
				String act = request.getParameter("activation"+i);
				newedit_greobj=nwobj.containsKey("interface:"+ogrename)?nwobj.getJSONObject("interface:"+ogrename):new JSONObject();
				String oldtun=newedit_greobj.containsKey("tunnel")?newedit_greobj.getString("tunnel"):"";
				newtunnobj=nwobj.containsKey("interface:"+oldtun)?nwobj.getJSONObject("interface:"+oldtun):new JSONObject();
				if(act != null)
					newedit_greobj.put("enabled","1");
				else
					newedit_greobj.put("enabled","0");
			}
		}
		else if(pagename.equals("edit_gre"))
		{
			String enable = request.getParameter("enable");
			String tunsrc=request.getParameter("tunnelsrcsel");
			String tunsrcCustom = request.getParameter("tunlsrc");
			String remendpnt=request.getParameter("rem_ipaddress");
			String mtu=request.getParameter("mtu");
			String ttl=request.getParameter("ttl");
			String inbundkey=request.getParameter("inbkey");
			String outbundkey=request.getParameter("outbkey");
			String kpalive=request.getParameter("keep_alive");
			String kpaliinter=request.getParameter("keep_alive_interval");
			String kpaliretr=request.getParameter("keep_alive_retries");
			String tunipaddr=request.getParameter("lcl_ipaddress");
			String tunnetmask=request.getParameter("lcl_netmask");
			String targw=request.getParameter("gateway");
			String tarmetric=request.getParameter("metric");
			int rows = request.getParameter("rows")==null?-1:Integer.parseInt(request.getParameter("rows"));
			int tarrows = Integer.parseInt(request.getParameter("tarrows"));
			String ipaddr="";
			if(tunsrc.equals("lan"))
			{
				JSONObject lanobj = wizjsonnode.getJSONObject("network").getJSONObject("interface:lan");
				if(lanobj.containsKey("ipaddr"))
				{
					JSONArray  laniparr=lanobj.getJSONArray("ipaddr");
					SubnetUtils utils = new SubnetUtils(laniparr.getString(0));
					ipaddr=utils.getInfo().getAddress();
					editgreobj.put("ipaddr", ipaddr);
				}
			}
			else if(tunsrc.equals("wan"))
			{
				JSONObject wanobj = wizjsonnode.getJSONObject("network").getJSONObject("interface:wan");
				if(wanobj.containsKey("ipaddr"))
				{
					JSONArray  waniparr =wanobj.getJSONArray("ipaddr");
					SubnetUtils utils = new SubnetUtils(waniparr.getString(0));
					ipaddr=utils.getInfo().getAddress();
					editgreobj.put("ipaddr", ipaddr);
				}
			}
			else if(tunsrc.equals("loopback"))
			{
				JSONObject lpbkobj = wizjsonnode.getJSONObject("network").getJSONObject("interface:loopback");
				if(lpbkobj.containsKey("ipaddr"))
				{
					JSONArray  lpbkiparr=lpbkobj.getJSONArray("ipaddr");
					SubnetUtils utils = new SubnetUtils(lpbkiparr.getString(0));
					ipaddr=utils.getInfo().getAddress();
					editgreobj.put("ipaddr", ipaddr);
				}
			}
			if(enable!=null)
				editgreobj.put("enabled","1");
			else
				editgreobj.put("enabled","0");
			if(tunsrc == null || tunsrc.length() ==0)
			{
				if(editgreobj.containsKey("srcif"))
					editgreobj.remove("srcif");
			}
			else			   
				editgreobj.put("srcif",tunsrc.equals("6")?tunsrcCustom:tunsrc);
			if(tunsrc.equals("cellular"))
				editgreobj.put("ipaddr", "cellular");
			if(remendpnt!=null&&remendpnt.length()>0)
				editgreobj.put("peeraddr",remendpnt);
			if(mtu!=null&&mtu.length()>0)
				editgreobj.put("mtu",mtu);
			else
				editgreobj.remove("mtu");
			if(ttl!=null&&ttl.length()>0)
				editgreobj.put("ttl",ttl);
			else
				editgreobj.remove("ttl");
			if(inbundkey!=null&&inbundkey.length()>0)
				editgreobj.put("ikey",inbundkey);
			else
				editgreobj.remove("ikey");
			if(outbundkey!=null&&outbundkey.length()>0)
				editgreobj.put("okey",outbundkey);
			else
				editgreobj.remove("okey");
			if(kpalive!=null)
				tunnelobj.put("keepalive","enable");
			else
				tunnelobj.put("keepalive","disable");
			if(kpaliinter!=null&&kpaliinter.length()>0)
				tunnelobj.put("keepalive_int",kpaliinter);
			else
				tunnelobj.remove("keepalive_int");
			if(kpaliretr!=null&&kpaliretr.length()>0)
				tunnelobj.put("keepalive_retries",kpaliretr);
			else
				tunnelobj.remove("keepalive_retries");
			if(tunipaddr!=null&&tunipaddr.length()>0)
				tunnelobj.put("ipaddr",tunipaddr);
			else
				tunnelobj.remove("ipaddr");
			if(tunnetmask!=null&&tunnetmask.length()>0)
				tunnelobj.put("netmask",tunnetmask);
			else
			 	tunnelobj.remove("netmask");
			for(int i=2;i<=tarrows;i++)
			{
				String taripaddr = request.getParameter("rem_subnet_ipaddress"+i);
				String tarnetmask = request.getParameter("rem_subnet_netmask"+i);
				if(isnewobj)
					routetunnelobj.put("interface","tunnel"+rows);
				else
					routetunnelobj.put("interface",tunnelname);
				if(taripaddr!=null&&taripaddr.length()>0)
					routetunnelobj.put("target",taripaddr);
				if(tarnetmask!=null&&tarnetmask.length()>0)
					routetunnelobj.put("netmask",tarnetmask);
				if(taripaddr!=null&&tarnetmask!=null&&taripaddr.length()>0&&tarnetmask.length()>0)
				{
					if(targw!=null&&targw.length()>0)
						routetunnelobj.put("gateway",targw);
					if(tarmetric!=null&&tarmetric.length()>0)
						routetunnelobj.put("metric",tarmetric);
					route_arr.add(routetunnelobj);
				}
			}
			if(isnewobj)
				{
					 tuninfo.put("grecnt", String.valueOf(rows));
					 nwobj.put("info:tuninfo",tuninfo);
					 editgreobj.put("tunnel","tunnel"+rows);
					 editgreobj.put("proto","gre");
					 nwobj.put("interface:"+grename, editgreobj);
					 tunnelobj.put("ifname","@"+grename);
					 tunnelobj.put("proto","static");
					 tunnelobj.put("connected","1");
					 nwobj.put("interface:"+"tunnel"+rows, tunnelobj);
				} 
		}
	   BufferedWriter jsonWriter = null;
	   try
	   {
			jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			jsonWriter.write(wizjsonnode.toString(2));
	   }
	   catch(Exception e)
	   {
		   e.printStackTrace();
		   internal_err = true;
	   }
	   finally
	   {
		   if(jsonWriter != null)
		   jsonWriter.close();
	   }
	}
	//gre ends
	
	//clientvpn starts
	/* else if(pagename.equals("clientvpn"))
	{
		String savedtab = request.getParameter("uploadfile");
		if(savedtab != null)
		{
				
		}
		else
		{
			
		}
	} */
	//clientvpn ends
	//loadbalancing starts
	else if(pagename.equals("loadbalancing") || pagename.equals("interfacetable") || pagename.equals("members_config") || pagename.equals("policies_config") || pagename.equals("rulesconf") || pagename.equals("rulesdiv")) 
	{
		procpage = "loadbalancing.jsp";
		save_val = LOADBALANCING;
		String action = request.getParameter("action")==null?"":request.getParameter("action");
		String  mpname =request.getParameter("mpname")==null?"":request.getParameter("mpname");
		String  delinstname =request.getParameter("delinstname")==null?"":request.getParameter("delinstname");
		JSONObject mwan3obj=wizjsonnode.containsKey("mwan3")?wizjsonnode.getJSONObject("mwan3"):new JSONObject();
		if(pagename.equals("loadbalancing"))
		{
			JSONObject globalsobj=mwan3obj.containsKey("globals:globals")?mwan3obj.getJSONObject("globals:globals"):new JSONObject();	
			String enabled=request.getParameter("globalact");
			if(enabled!=null)
				globalsobj.put("enabled", "1");
			else
				globalsobj.remove("enabled");
		}
		else if(pagename.equals("interfacetable"))
		{
			showdiv="interfacetable";
			intfacename=request.getParameter("intname");
			JSONObject intfaceobj=mwan3obj.containsKey("interface:"+intfacename)?mwan3obj.getJSONObject("interface:"+intfacename):new JSONObject();
			JSONArray trackiparr=intfaceobj.containsKey("track_ip")?intfaceobj.getJSONArray("track_ip"):new JSONArray();
			String intract=request.getParameter("intract");
			String trackreblity=request.getParameter("trackreblity");
			String pingcunt=request.getParameter("pingcunt");
			String pingtiout=request.getParameter("pingtiout");
			String pingintvl=request.getParameter("pingintvl");
			String intrfdwn=request.getParameter("intrfdwn");
			String intrfup=request.getParameter("intrfup");
			String family=request.getParameter("family");
			int iprows=Integer.parseInt(request.getParameter("trackcunt"));
			if(intract!=null)
				intfaceobj.put("enabled","1");
			else
				intfaceobj.put("enabled","0");
			for(int i=trackiparr.size()-1;i>=0;i--)
				trackiparr.remove(i);
			for(int i=1;i<=iprows;i++)
			{
				String trackip=request.getParameter("trackip"+i);
				if(trackip!=null&&trackip.length()>0)
					trackiparr.add(trackip);
			}
			intfaceobj.put("track_ip", trackiparr);
			if(trackreblity!=null)
				intfaceobj.put("reliability",trackreblity);
			else
				intfaceobj.remove("reliability");
			if(pingcunt!=null)
				intfaceobj.put("count",pingcunt);
			else
				intfaceobj.remove("count");
			if(pingtiout!=null)
				intfaceobj.put("timeout",pingtiout);
			else
				intfaceobj.remove("timeout");
			if(pingintvl!=null)
				intfaceobj.put("interval",pingintvl);
			else
				intfaceobj.remove("interval");
			if(intrfdwn!=null)
				intfaceobj.put("down",intrfdwn);
			else
				intfaceobj.remove("down");
			if(intrfup!=null)
				intfaceobj.put("up",intrfup);
			else
				intfaceobj.remove("up");
			if(family!=null)
				intfaceobj.put("family",family);
			else
				intfaceobj.remove("family");
		}
		//members page
		else if(pagename.equals("members_config"))
		{
			showdiv="members_config";
			JSONObject memberobj=new JSONObject();
			if(action.equals("delete"))
				mwan3obj.remove("member:"+delinstname);
			else if(action.equals("menbadd"))
			{
				memberobj.put("interface", "wan");
		        memberobj.put("metric", "1");
		        memberobj.put("weight", "1");
				mwan3obj.put("member:"+mpname,memberobj);
			}
			else
			{
				int memrows=Integer.parseInt(request.getParameter("Memberscount"));
				for(int i=1;i<=memrows;i++)
				{
					String memname=request.getParameter("membname"+i);
					if(memname!=null&&memname.length()>0)
					{
						 memberobj=mwan3obj.containsKey("member:"+memname)?mwan3obj.getJSONObject("member:"+memname):new JSONObject();
						boolean newobj=true;
						if(mwan3obj.containsKey("member:"+memname))
							newobj=false;
						String intfaceassen=request.getParameter("intlist"+i);
						String metric=request.getParameter("metric"+i);
						String weight=request.getParameter("weight"+i);
						if(intfaceassen!=null)
							memberobj.put("interface",intfaceassen);
						else 
							memberobj.remove("interface");
						if(metric!=null)
							memberobj.put("metric",metric);
						else 
							memberobj.remove("metric");
						if(weight!=null)
							memberobj.put("weight",weight);
						else 
							memberobj.remove("weight");
						if(newobj)
							mwan3obj.put("member:"+memname,memberobj);
					}
				}
			}
		}
		//policies page
		else if(pagename.equals("policies_config"))
		{
			showdiv="policies_config";
			JSONObject policyobj=new JSONObject();
			JSONArray memassenarr=new JSONArray();
			if(action.equals("delete"))
				mwan3obj.remove("policy:"+delinstname);
			else if(action.equals("poliadd"))
			{
		       policyobj.put("last_resort", "default");
		       mwan3obj.put("policy:"+mpname,policyobj);
			}
			else
			{
				int polirows=Integer.parseInt(request.getParameter("policiesconfigcount"));
				for(int i=1;i<=polirows;i++)
				{
					String poliname=request.getParameter("policname"+i);
					if(poliname!=null&&poliname.length()>0)
					{
						policyobj=mwan3obj.containsKey("policy:"+poliname)?mwan3obj.getJSONObject("policy:"+poliname):new JSONObject();
						memassenarr=policyobj.containsKey("use_member")?policyobj.getJSONArray("use_member"):new JSONArray();
						boolean newobj=true;
						if(mwan3obj.containsKey("policy:"+poliname))
							newobj=false;
						String lastresort=request.getParameter("lastrepot"+i);
						String memassen_arr[] = request.getParameterValues("memassign_instance"+i);
						if(memassen_arr == null)
							memassen_arr = new String[0];
						for(int j=memassenarr.size()-1;j>=0;j--)
							memassenarr.remove(j);
						for(String memassenval : memassen_arr)
							   memassenarr.add(memassenval);
						policyobj.put("use_member",memassenarr);
						if(lastresort!=null)
						{
							lastresort=lastresort.equals("1")?"unreachable":lastresort.equals("2")?"blackhole":"default";
							policyobj.put("last_resort",lastresort);
						}
						else 
							policyobj.remove("last_resort");
						if(newobj)
							mwan3obj.put("policy:"+poliname,policyobj);
					}
				}
			}
		}
		//rules page
		else if(pagename.equals("rulesconf"))
		{
			showdiv="rulesconf";
			if(action.equals("delete"))
				mwan3obj.remove("rule:"+delinstname);
		}
		else if(pagename.equals("rulesdiv"))
		{
			showdiv="rulesdiv";
			String rulename=request.getParameter("rulname");
			intfacename=rulename;
			boolean newobj=false;;
			JSONObject ruleobj=mwan3obj.containsKey("rule:"+rulename)?mwan3obj.getJSONObject("rule:"+rulename):new JSONObject();
			if(ruleobj.isEmpty())
				newobj=true;
			String protocol=request.getParameter("protocol");
			String dport=request.getParameter("dport");
			String sticky=request.getParameter("sticky");
			String stimeout=request.getParameter("stimeout");
			String poliassign=request.getParameter("poliassign");
			int destiprows=Integer.parseInt(request.getParameter("destcount"));
			String dest_ip="";
			if(protocol!=null)
				ruleobj.put("proto",protocol);
			else
				ruleobj.remove("proto");
			for(int i=1;i<=destiprows;i++)
			{
				String destaddr=request.getParameter("destaddr"+i);
				if(destaddr!=null&&destaddr.length()>0)
				{
						if(dest_ip.isEmpty())
							dest_ip=dest_ip.concat(destaddr);
						else
							dest_ip=dest_ip.concat(","+destaddr);
				}
					
			}
			if(dest_ip!=null&&dest_ip.length()>0)
				ruleobj.put("dest_ip", dest_ip);
			else
				ruleobj.remove("dest_ip");
			if(dport!=null&&dport.length()>0)
				ruleobj.put("dest_port",dport);
			else
				ruleobj.remove("dest_port");
			if(sticky!=null&&sticky.length()>0&&sticky.equals("Yes"))
				ruleobj.put("sticky","1");
			else
				ruleobj.remove("sticky");
			if(stimeout!=null&&stimeout.length()>0&&sticky.equals("Yes"))
				ruleobj.put("timeout",stimeout);
			else
				ruleobj.remove("timeout");
			if(poliassign!=null)
				ruleobj.put("use_policy",poliassign);
			else
				ruleobj.remove("use_policy");
			if(newobj)
				mwan3obj.put("rule:"+rulename,ruleobj);
		}
		BufferedWriter jsonWriter = null;
		 try
		 {
			jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
			jsonWriter.write(wizjsonnode.toString(2));
		 }
		 catch(Exception e)
		 {
			  e.printStackTrace();
			  internal_err = true;
		 }
		 finally
		 {
			  if(jsonWriter != null)
			  jsonWriter.close();
		 }
	}
	   
	//loadbalancing ends
   }

  if(errmsg.length() == 0)
  {
	   BufferedWriter jsonWriter = null;
	   try
	   {
		   if(wizjsonnode.containsKey("ospfbk"))
		   {
			   JSONObject ospfbkobj =  wizjsonnode.getJSONObject("ospfbk");
			   Iterator keys = ospfbkobj.keys();
			   while(keys.hasNext())
					ospfbkobj.remove((String)ospfbkobj.keys().next());
			   wizjsonnode.put("ospfbk",ospfbkobj);
		   }
		   if(wizjsonnode.containsKey("ospf6bk"))
		   {
			   JSONObject ospf6bkobj =  wizjsonnode.getJSONObject("ospf6bk");
			   Iterator keys = ospf6bkobj.keys();
			   while(keys.hasNext())
					ospf6bkobj.remove((String)ospf6bkobj.keys().next());
			   wizjsonnode.put("ospf6bk",ospf6bkobj);
		   }
		   jsonWriter = new BufferedWriter(new FileWriter(jsonfile));
		   jsonWriter.write(wizjsonnode.toString(2));
	   }
	   catch(Exception e)
	   {
		   e.printStackTrace();
		   internal_err = true;
	   }
	   finally
	   {
		   if(jsonWriter != null)
		   jsonWriter.close();
	   }
  }
   if(internal_err)
   {
	   response.sendRedirect("error.jsp?error=Internal Error...");
   %>
<!--  <script>
   goToPage("error.jsp","error","Internal Error...","");
   </script> -->
<%}else if(errmsg.length() > 0 && procpage!="dynamic_routing.jsp"){
	   response.sendRedirect(procpage+"?slnumber="+slnumber+"&error="+errmsg+"&version="+fmversion);
   %>
<!--   <script>
   goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');		
   </script>-->
<%}else if(procpage=="dynamic_routing.jsp" || procpage=="loadbalancing.jsp"){
	if(showdiv=="add_bgppeer"||showdiv=="add_bgppeersetteings" || showdiv=="add_bgppath")
		response.sendRedirect(procpage+"?slnumber="+slnumber+"&error="+errmsg+"&version="+fmversion+"&showdiv="+showdiv+"&peername="+peername);
	else if(showdiv=="interfacetable"|| showdiv=="rulesdiv")
		response.sendRedirect(procpage+"?slnumber="+slnumber+"&error="+errmsg+"&version="+fmversion+"&showdiv="+showdiv+"&intfacename="+intfacename);
	else
		response.sendRedirect(procpage+"?slnumber="+slnumber+"&error="+errmsg+"&version="+fmversion+"&showdiv="+showdiv);
	   %>
	<!--   <script>
	   goToPage('<%=procpage%>',"error",'<%=errmsg%>','<%=slnumber%>');		
	   </script>-->
	<%}
	else if(procpage=="client-vpn.jsp"||procpage=="pointtopoint.jsp")
	{
		response.sendRedirect(procpage+"?slnumber="+slnumber+"&error="+errmsg+"&version="+fmversion+"&name="+URLEncoder.encode(instname, StandardCharsets.UTF_8.toString()));
	}
	else {
	   response.sendRedirect(procpage+"?slnumber="+slnumber+"&version="+fmversion);
   %>
<!--  <script>
   goToPage('<%=procpage%>',"","",'<%=slnumber%>');
   </script> -->
<%
}
%>

</html>