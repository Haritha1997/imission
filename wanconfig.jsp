<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="org.apache.commons.net.util.SubnetUtils"%>
<%@page import="java.net.NetworkInterface"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

 <%
   JSONObject wizjsonnode = null;
   JSONObject wanobj = null;
   JSONArray  waniparr = null;
   JSONArray  stadnsarr = null;
   JSONArray  dhcpdnsarr = null;
   JSONArray  pppoednsarr = null;
   JSONArray dhcp6dnsarr = null;
   BufferedReader jsonfile = null;  
	String wanproto = "";  
	String intfType="eth1";
	String ppp_auth = "";  
	String peerdns = "";
   		String slnumber=request.getParameter("slnumber");
		String errorstr = request.getParameter("error");
   if(slnumber != null && slnumber.trim().length() > 0)
   {
	   Properties m2mprops = M2MProperties.getM2MProperties();
	   String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
	   jsonfile = new BufferedReader(new FileReader(new File(slnumpath+File.separator+"Config.json")));
	   StringBuilder jsonbuf = new StringBuilder("");
	   String jsonString="";
	   try
	   {
			while((jsonString = jsonfile.readLine())!= null)
   			jsonbuf.append( jsonString );
			wizjsonnode= JSONObject.fromObject(jsonbuf.toString());
   		
			wanobj =  wizjsonnode.getJSONObject("network").getJSONObject("interface:wan");
			wanproto = wanobj.getString("proto");
			if(wanobj.containsKey("intfType"))
				intfType = wanobj.getString("intfType");
			if(wanobj.containsKey("auth"))
			ppp_auth = wanobj.getString("auth");
			else
				ppp_auth ="any";
			if((wanobj.containsKey("peerdns")))
				peerdns=wanobj.getString("peerdns").equals("1")?"checked":"";
			else
				peerdns="checked";
			if(wanobj != null)
			{
				if(wanobj.containsKey("ipaddr"))
				waniparr = wanobj.getJSONArray("ipaddr");			
				if(wanobj.containsKey("dns") && wanproto.equals("static"))
				stadnsarr   = wanobj.getJSONArray("dns");
				if(wanobj.containsKey("dns") && wanproto.equals("dhcp"))
				dhcpdnsarr   = wanobj.getJSONArray("dns");
				if(wanobj.containsKey("dns") && wanproto.equals("pppoe"))
				pppoednsarr   = wanobj.getJSONArray("dns");
				if(wanobj.containsKey("dns") && wanproto.equals("dhcpv6"))
					dhcp6dnsarr = wanobj.getJSONArray("dns");
			}
			
			if(waniparr == null)
				waniparr = new JSONArray();
			if(stadnsarr == null)
				stadnsarr = new JSONArray();
			if(dhcpdnsarr == null)
				dhcpdnsarr = new JSONArray();
			if(pppoednsarr == null)
				pppoednsarr = new JSONArray();
			if(dhcp6dnsarr == null)
				dhcp6dnsarr = new JSONArray();
			
	   }
	   catch(Exception e)
	   {
		   e.printStackTrace();
	   }
	   finally
	   {
		   if(jsonfile != null)
			   jsonfile.close();
	   }
   }
%>
<html>
   <head>
      <link href="css/fontawesome.css" rel="stylesheet">
      <link href="css/solid.css" rel="stylesheet">
      <link href="css/v4-shims.css" rel="stylesheet">
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
      <script type="text/javascript" src="js/common.js"></script>
      <script type="text/javascript" src="js/wan.js"></script>
      <script type="text/javascript">
      function showErrorMsg(errormsg)
      {
      	alert(errormsg.replace("and", "&"));
      }
var iprows = 1;
var customdnspppoe = 9;
var customdnsdhcp = 8;
var customdnsstatic = 4;
var customdnsdhcp6c = 0;

function validatewanIpConfig() {
	
	try
	{
    var alertmsg = "";
    var table = document.getElementById("WiZConf");
    var rows = table.rows;
    var selobj = document.getElementById('wanproto');
    var protocol = selobj.options[selobj.selectedIndex].text;
    var actobj = document.getElementById("activation");
    var check_empty=true;
    if(!actobj.checked)
    	check_empty=false;
    if (protocol == 'Static Address') {
    	const waniparrobj = [];
		const wannmobj = [];
		const wannetwk=[];
		const wanbdcast=[];
		var curnetwork = "";
		var curbdcast="";
		
        var table = document.getElementById("statictab");
        var rows = table.rows;
        for (var i = 0; i < rows.length; i++) {
            var cols = rows[i].cells;
            var ipaddress = cols[1].childNodes[0].childNodes[0];
            var subnet = cols[1].childNodes[2].childNodes[0];
            var valid = validateIPOnly(ipaddress.id, check_empty, "IPv4 Address");
            var ipvalid=valid;
            if (!valid) {
                alertmsg += (i + 1);
                if (i == 0) alertmsg += "st";
                else if (i == 1) alertmsg += "nd";
                else if (i == 2) alertmsg += "rd";
                else alertmsg += "th";
                if (ipaddress.value.trim() == "") 
                	alertmsg += " IPv4 Address should not be empty\n";
                else 
                	alertmsg += " IPv4 Address is not valid\n";
            }
            valid = validateSubnetMask(subnet.id, check_empty, "Subnet Address");
            var netvalvalid=valid;
            if (!valid) {
                alertmsg += (i + 1);
                if (i == 0) alertmsg += "st";
                else if (i == 1) alertmsg += "nd";
                else if (i == 2) alertmsg += "rd";
                else alertmsg += "th";
                if (subnet.value.trim() == "") 
                	alertmsg += " IPv4 Subnet Address should not be empty\n";
                else 
                	alertmsg += " IPv4 Subnet Address is not valid\n";
            }
            valid = false;
	        if(ipvalid && netvalvalid && (ipaddress.value.trim() != ""))
	    	{
	    		var network = getNetwork(ipaddress.value,subnet.value);
				var broadcast = getBroadcast(network,subnet.value);
				if(ipaddress.value == network)
				{
					alertmsg += (i + 1);
					if (i == 0) alertmsg += "st";
					else if (i == 1) alertmsg += "nd";
					else if (i == 2) alertmsg += "rd";
					else alertmsg += "th";
					alertmsg += " IPv4 Address "+ipaddress.value+" should not be Network\n";
					ipaddress.style.outline = "thin solid red";
					ipaddress.title =  "IPv4 Address should not be Network";
				}
				else if(ipaddress.value == broadcast)
				{
					alertmsg += (i + 1);
					if (i == 0) alertmsg += "st";
					else if (i == 1) alertmsg += "nd";
					else if (i == 2) alertmsg += "rd";
					else alertmsg += "th";
					alertmsg += " IPv4 Address "+ipaddress.value+" should not be Broadcast\n";
					ipaddress.style.outline = "thin solid red";
					ipaddress.title =  "IPv4 Address should not be Broadcast";
				}
				else
				{
					valid = true;
					wannetwk.push(network);
					wanbdcast.push(broadcast);
					curnetwork = network;
					curbdcast = broadcast;
				}
	    	}
			if(valid == true)
			{
				for(var l=0;l<waniparrobj.length;l++)
				{
					//var network1 = getNetwork(waniparrobj[l].value,wannmobj[l].value);
					//var broadcast1 = getBroadcast(network1,wannmobj[l].value);
					var network1 = wannetwk[l];
					var broadcast1 = wanbdcast[l];
					if((isGraterOrEquals(curnetwork,network1) && !isGraterOrEquals(curnetwork,broadcast1)) || (isGraterOrEquals(network1, curnetwork) && !isGraterOrEquals(network1,curbdcast)))
					{
						alertmsg += ipaddress.value+" overlaps with "+waniparrobj[l].value+".\n";
						
						ipaddress.style.outline = "thin solid red";
						waniparrobj[l].style.outline = "thin solid red";
						ipaddress.title = "overlaps with "+waniparrobj[l].value;
						waniparrobj[l].title = "overlaps with "+ipaddress.value;
						break;
					}
				 }
				waniparrobj.push(ipaddress);
				wannmobj.push(subnet);
			}
    	}
        var statable = document.getElementById("staticdns");
        var starows = statable.rows;
        var ipgw = document.getElementById("ipv4gw");
        valid = validateIPOnly("ipv4gw", false, "IPv4 Gateway");
        if (!valid) {
            if (ipgw.value.trim() == "") alertmsg += "IPv4 Gateway should not be empty\n";
            else alertmsg += "IPv4 Gateway is not valid\n";
        }
        else if(ipgw.value.trim() != "")
    	{
        	var is_exists = false;
       		var l=0;
       		for(l=0;l<wannetwk.length;l++)
       		{	
       			if(wannetwk[l] == ipgw.value)
       			{
       				alertmsg += "IPv4 Gateway should not be the network "+wannetwk[l]+" of WAN IP Address "+waniparrobj[l].value+"\n";
       				ipgw.style.outline = "thin solid red";
       				ipgw.title = "IPv4 Gateway should not be the network "+wannetwk[l]+" of WAN IP Address "+waniparrobj[l].value+"\n";
       				break;
       			}
       			else if(waniparrobj[l].value == ipgw.value)
       			{
       				alertmsg += "IPv4 Gateway should not be the WAN IP Address "+waniparrobj[l].value+"\n";
       				ipgw.style.outline = "thin solid red";
       				ipgw.title = "IPv4 Gateway should not be the WAN IP Address "+waniparrobj[l].value+"\n";
       				break;
       			}
       			else if(wanbdcast[l] == ipgw.value)
       			{
       				alertmsg += "IPv4 Gateway should not be the Broadcast "+wanbdcast[l]+" of WAN IP Address "+waniparrobj[l].value+"\n";
       				ipgw.style.outline = "thin solid red";
       				ipgw.title = "IPv4 Gateway should not be the Broadcast "+wanbdcast[l]+" of WAN IP Address "+waniparrobj[l].value+"\n";
       				break;
       			}
       			else if(wannmobj[l].value == ipgw.value)
       			{
       				alertmsg += "IPv4 Gateway should not be the WAN Subnet "+wannmobj[l].value+"\n";
       				ipgw.style.outline = "thin solid red";
       				ipgw.title = "IPv4 Gateway should not be the WAN Subnet "+wannmobj[l].value+"\n";
       				break;
       			}
       			else if(waniparrobj[l].value == ipgw.value)
       			{
       				ipgw.title = "IPv4 Gateway should not be "+waniparrobj[l].value+" as this is WAN IP address\n";
       				alertmsg += ipgw.title;
       				ipgw.style.outline = "thin solid red";
       				break;
       			}
       			else if(!is_exists && (isGraterOrEquals(ipgw.value,wannetwk[l]) && !isGraterOrEquals(ipgw.value,wanbdcast[l])))
       				is_exists = true;

       		}
       		if(!is_exists && l == wannetwk.length)
       		{
       			ipgw.title = "IPv4 Gateway should be in the given WAN Networks\n";
       			alertmsg += ipgw.title;
       			ipgw.style.outline = "thin solid red";
       		}
    	}
        var ipbc = document.getElementById("ipv4bc");
        valid = validateIpWithAllRange("ipv4bc", false, "IPv4 Broadcast");
        if (!valid) {
            if (ipbc.value.trim() == "") alertmsg += "IPv4 Broadcast should not be empty\n";
            else alertmsg += "IPv4 Broadcast is not valid\n";
        }
        else  if (ipbc.value.trim() != "")
    	{
    		var is_exists= false;
    		for(var m=0;m<wannetwk.length;m++)
    		{	
    			if(wanbdcast[m] == ipbc.value)
    			{
    				is_exists = true;
    				break;
    			}
    		}
    		if(!is_exists)
    		{
    			ipbc.title = "IPv4 Broadcast Address should be one of the given WAN Broadcast Addresses\n";
    			alertmsg += ipbc.title;
    			ipbc.style.outline = "thin solid red";
    		}
    	}
        var mtu = document.getElementById("staticmtu");
        var valid = validateRange("staticmtu", false, "MTU");
        if (!valid) {
            if (mtu.value.trim() == "") alertmsg += "MTU should not be empty\n";
            else alertmsg += "MTU is not valid\n";
        }
        var metric = document.getElementById("staticmetric");
        var valid = validateRange("staticmetric", false, "Metric");
        if (!valid) {
            if (metric.value.trim() == "") alertmsg += "Metric should not be empty\n";
            else alertmsg += "Metric is not valid\n";
        }
        var custom_dns_arr=[];
        for (var i = 4; i < starows.length; i++) {
            var cols = starows[i].cells;
            var customstadns = cols[1].childNodes[0].childNodes[0];
            var valid = validatedualIP(customstadns.id, false, "Custom DNS Servers",false);
           // if (!valid) 
    		//{
    			//alert(ipele.value);
    		    //valid=validateIPv6(customstadns.id, true, "Custom DNS Server",false);
    			//alert(ipele.value);
    			if(!valid)
    			{
    				if (customstadns.value.trim() == "") 
    					alertmsg += "Custom DNS Server-" + (i - 3) + " should not be empty\n";
    				else 
    					alertmsg += "Custom DNS Server-" + (i - 3) + " is not valid\n";
    			}
    			
    		//}
           else if (customstadns.value.trim() != "") {
            if(valid)
    		{
    			for(ct=0;ct<custom_dns_arr.length;ct++)
    			{
    				if(custom_dns_arr[ct].value == customstadns.value)
    				{
    					customstadns.style.outline = "thin solid red";
    					customstadns.title="Duplicate Custom DNS Server "+customstadns.value;
    					custom_dns_arr[ct].style.outline = "thin solid red";
    					custom_dns_arr[ct].title = customstadns.title;
    					alertmsg += customstadns.title+"\n";
    					break;
    				}
    			}
    			if(ct==custom_dns_arr.length)
    				custom_dns_arr.push(customstadns);
    		}
        }
        }
        var ipv6addr = document.getElementById("ipv6adrs");
        valid = validateIPv6("ipv6adrs", false, "IPv6 Address",check_empty);
        if (!valid) {
            if (ipv6addr.value.trim() == "") alertmsg += " IPv6 Address should not be empty\n";
            else alertmsg += " IPv6 Address is not valid\n";
        }
        var ipv6gateway = document.getElementById("ipv6gw");
        valid = validateIPv6("ipv6gw", false, "IPv6 Gateway");
        if (!valid) {
            if (ipv6gateway.value.trim() == "") alertmsg += "IPv6 Gateway should not be empty\n";
            else alertmsg += "IPv6 Gateway is not valid\n";
        }
        var ipv6aslength = document.getElementById("ipv6asl");
        var ipv6asshint = document.getElementById("ipv6agnthnt");
        var assl = document.getElementById("assl");
        if (ipv6aslength.value.trim() == "64") {
            if (ipv6asshint.value.trim() == "") {
                alertmsg += "IPv6 assignment hint should not be empty\n";
                ipv6asshint.style.outline = "thin solid red";
            }
        } else if (ipv6aslength.value.trim() == "custom") {
            valid = validOnshowWanComboBox('ipv6asgmnt', 'IPv6 assignment length', 'assl');
            if (!valid) {
                if (assl.value.trim() == "") alertmsg += " IPv6 assignment length should not be empty\n";
                else alertmsg += " IPv6 assignment length is not valid\n";
            }
            if (ipv6asshint.value.trim() == "") {
                alertmsg += "IPv6 assignment hint should not be empty\n";
                ipv6asshint.style.outline = "thin solid red";
            }
        }
    } else if (protocol == 'DHCP Client') {
        var dhcptable = document.getElementById("dhcptab");
        var dhcprows = dhcptable.rows;
        var dhcpdns = document.getElementById("dhcpautodns");
        
      //code here
      if (dhcpdns.checked == false) {
        	var cust_dhcp_dns_arr=[];
        for (var i = 6; i < dhcprows.length; i++) {
            var cols = dhcprows[i].cells;
            var customdhcpdns = cols[1].childNodes[0].childNodes[0];
            var valid = validatedualIP(customdhcpdns.id, false, "Custom DNS Servers",false);
   			if(!valid)
   			{
   				if (customdhcpdns.value.trim() == "") 
   					alertmsg += "Custom DNS Server-" + (i - 5) + " should not be empty\n";
   				else 
   					alertmsg += "Custom DNS Server-" + (i - 5) + " is not valid\n";
   			}
   			else if (customdhcpdns.value.trim() == ""){
            if(valid)
    		{
    			for(ct=0;ct<cust_dhcp_dns_arr.length;ct++)
    			{
    				if(cust_dhcp_dns_arr[ct].value == customdhcpdns.value)
    				{
    					customdhcpdns.style.outline = "thin solid red";
    					customdhcpdns.title="Duplicate Custom DNS Server "+customdhcpdns.value;
    					cust_dhcp_dns_arr[ct].style.outline = "thin solid red";
    					cust_dhcp_dns_arr[ct].title = customdhcpdns.title;
    					alertmsg += customdhcpdns.title+"\n";
    					break;
    				}
    			}
    			if(ct==cust_dhcp_dns_arr.length)
    				cust_dhcp_dns_arr.push(customdhcpdns);
    		}
        }
      }
      }    
       /*  if (dhcpdns.checked == false) {
        	var cust_dhcp_dns_arr=[];
            for (var i = 7; i < dhcprows.length; i++) {
                var cols = dhcprows[i].cells;
                var customdhcpdns = cols[1].childNodes[0].childNodes[0];
                var valid = validateIPOnly(customdhcpdns.id, true, "Custom DNS Servers");
                if (!valid) {
                    if (customdhcpdns.value.trim() == "") 
                    	alertmsg += "Custom DNS Server-" + (i - 6) + " should not be empty\n";
                    else 
                    	alertmsg += "Custom DNS Server-" + (i - 6) + " is not valid\n";
                }
            }
        } */
        var dhcpmtu = document.getElementById("dhcpmtu");
        var valid = validateRange("dhcpmtu", false, "MTU");
        if (!valid) {
            if (dhcpmtu.value.trim() == "") alertmsg += "MTU should not be empty\n";
            else alertmsg += "MTU is not valid\n";
        }
        var dhcpmetric = document.getElementById("dhcpmetric");
        var valid = validateRange("dhcpmetric", false, "Metric");
        if (!valid) {
            if (dhcpmetric.value.trim() == "") alertmsg += "Metric should not be empty\n";
            else alertmsg += "Metric is not valid\n";
        }
    } 
	else if (protocol == 'PPPoE') {
		
        var ppptable = document.getElementById("pppoetab");
        var ppprows = ppptable.rows;	
        var pppdns = document.getElementById("dnsauto2");
       //code2 here
        if (pppdns.checked == false) {
        	var cust_pppoe_dns_arr=[];
        	for (var i = 8; i < ppprows.length; i++) {
                var cols = ppprows[i].cells;
                var custompppdns = cols[1].childNodes[0].childNodes[0];
                var valid = validatedualIP(custompppdns.id, false, "Custom DNS Servers",false);
                if (!valid) {
                    if (custompppdns.value.trim() == "") 
                    	alertmsg += "Custom DNS Server-" + (i - 7) + " should not be empty\n";
                    else 
                    	alertmsg += "Custom DNS Server-" + (i - 7) + " is not valid\n";
                }
            if(valid)
    		{
    			for(ct=0;ct<cust_pppoe_dns_arr.length;ct++)
    			{
    				if(cust_pppoe_dns_arr[ct].value == custompppdns.value)
    				{
    					custompppdns.style.outline = "thin solid red";
    					custompppdns.title="Duplicate Custom DNS Server "+custompppdns.value;
    					cust_pppoe_dns_arr[ct].style.outline = "thin solid red";
    					cust_pppoe_dns_arr[ct].title = custompppdns.title;
    					alertmsg += custompppdns.title+"\n";
    					break;
    				}
    			}
    			if(ct==cust_pppoe_dns_arr.length)
    				cust_pppoe_dns_arr.push(custompppdns);
    		}
        }
      }
        
       /*  if (pppdns.checked == false) {
            for (var i = 9; i < ppprows.length; i++) {
                var cols = ppprows[i].cells;
                var custompppdns = cols[1].childNodes[0].childNodes[0];
                var valid = validateIPOnly(custompppdns.id, true, "Custom DNS Servers");
                if (!valid) {
                    if (custompppdns.value.trim() == "") alertmsg += "Custom DNS Server-" + (i - 8) + " should not be empty\n";
                    else alertmsg += "Custom DNS Server-" + (i - 8) + " is not valid\n";
                }
            }
        } */					
        var pppoemtu = document.getElementById("pppoemtu");
        var valid = validateRange("pppoemtu", false, "MTU");
        if (!valid) {
            if (pppoemtu.value.trim() == "") alertmsg += "MTU should not be empty\n";
            else alertmsg += "MTU is not valid\n";
        }
        var pppoemetric = document.getElementById("pppoemetric");
        var valid = validateRange("pppoemetric", false, "Metric");
        if (!valid) {
            if (pppoemetric.value.trim() == "") alertmsg += "Metric should not be empty\n";
            else alertmsg += "Metric is not valid\n";
        }
        var ppp_auth = document.getElementById("ppp_auth").value;
        if(actobj.checked) {
		var useridobj = document.getElementById("uname");
		if(useridobj.value.trim() == "" && ppp_auth !="none")
			{
			alertmsg +="Username should not be empty..\n";
			useridobj.style.outline = "thin solid red";
			useridobj.title = "Username should not be empty";
			}
			else {
				useridobj.style.outline="initial";
				useridobj.title = "";
			}
			var pwdobj = document.getElementById("pass");
		if(pwdobj.value.trim() == "" && ppp_auth !="none")
			{
			alertmsg +="Password should not be empty..\n";
			pwdobj.style.outline = "thin solid red";
			pwdobj.title = "Password should not be empty";
			}
			else {
				pwdobj.style.outline="initial";
				pwdobj.title = "";
			}
        }
    }
	
    if (alertmsg.trim().length == 0) return true;
    else {
        alert(alertmsg);
        return false;
    }
	}
	catch(e)
	{
		alert(e);
	}
}
$(document).on('click', '.toggle-password', function() {
    $(this).toggleClass("fa-eye fa-eye-slash");
    var input = $("#pass");
    input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
});
</script>
</head>
<body>
	<form action="savedetails.jsp?page=wanconfig&slnumber=<%=slnumber%>" method="post" onsubmit="return validatewanIpConfig()">
   <br>
   <input type="hidden" id="waniprows" name="waniprows" value="1"/>
		 <input type="hidden" id="dnsstarows" name="dnsstarows" value="4"/>
		 <input type="hidden" id="dnsdhcprows" name="dnsdhcprows" value="7"/>
		 <input type="hidden" id="dnspppoerows" name="dnspppoerows" value="10"/>
		 <input type="hidden" id="dnsdhcp6rows" name="dnsdhcp6rows" value="0">
   <p class="style5" id="wan" align="center">WAN IP Configuration</p>
   <br>
   <table class="borderlesstab" id="WiZConf" style="width:400px;" align="center">
      <tbody>
         <tr>
            <th width="200px">Parameters</th>
            <th width="200px">Configuration</th>
         </tr>
         <tr>
            <td>Activation</td>
            <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="activation" name="activation" style="vertical-align:middle" <%if((wanobj.containsKey("enabled") && wanobj.getString("enabled").equals("1"))) {%> checked <%}%>><span class="slider round"></span></label></td>
         </tr>
         <tr>
            <td>MAC Address</td>
            <td style="position:relative; left:4px;" id="wanmacaddr" name="wanmacaddr"><%=wanobj == null?"":wanobj.get("macaddr")==null?"":wanobj.getString("macaddr")%></td>
         </tr>
         <tr>
             <td>Device</td>
             <td><select name="device" id="device" class="text">
                <option value="eth1"<%if(intfType.equals("eth1")){%>selected<%}%>>Eth1</option>
                <option value="1"<%if(intfType.equals("1")){%>selected<%}%>>FE0-0</option>
               <option value="2"<%if(intfType.equals("2")){%>selected<%}%>>FE0-1</option>
               <option value="4"<%if(intfType.equals("4")){%>selected<%}%>>FE0-2</option>
               <option value="8"<%if(intfType.equals("8")){%>selected<%}%>>FE0-3</option>
             </select></td>
         </tr>
         <tr>
            <td>Protocol</td>
            <td>
               <select class="text" id="wanproto" name="wanproto" onchange="displayActiveTable('wanproto');">
                   <option value="static" <%if(wanproto.equals("static")){%>selected<%}%>>Static Address</option>
                        <option value="dhcp" <%if(wanproto.equals("dhcp")){%>selected<%}%>>DHCP Client</option>
                        <option value="pppoe" <%if(wanproto.equals("pppoe")){%>selected<%}%>>PPPoE</option>
                        <option value="dhcpv6" <%if(wanproto.equals("dhcpv6")) {%>selected<%}%>>DHCPv6 Client</option>
               </select>
            </td>
         </tr>
      </tbody>
   </table>
   <table class="borderlesstab" id="statictab" style="width: 400px; display: table;" align="center">
      <tbody>
         
      </tbody>
   </table>
   <table class="borderlesstab" id="staticdns" style="width: 400px; display: table;" align="center">
      <tbody>
         <tr>
            <td width="200px">IPv4 Gateway</td>
            <td width="200px"><input type="text" class="text" id="ipv4gw" name="ipv4gw" value="<%=wanobj == null?"":wanobj.get("gateway")==null?"":wanobj.getString("gateway")%>" maxlength="256" onkeypress="return avoidSpace(event)" onfocusout="validateIP('ipv4gw',false,'IPv4 Gateway')"></td>
         </tr>
         <tr>
            <td width="200px">IPv4 Broadcast</td>
            <td width="200px"><input type="text" class="text" id="ipv4bc" name="ipv4bc" value="<%=wanobj == null?"":wanobj.get("broadcast")==null?"":wanobj.getString("broadcast")%>" maxlength="256" onkeypress="return avoidSpace(event)" onfocusout="validateIP('ipv4bc',false,'IPv4 Broadcast')"></td>
         </tr>
         <tr>
            <td width="200px">MTU</td>
            <td width="200px"><input type="number" class="text" id="staticmtu" name="staticmtu" value="<%=wanobj == null?"":wanobj.get("mtu")==null?"":wanobj.getString("mtu")%>" min="1" max="9000" placeholder="1500" onkeypress="return avoidSpace(event)" onfocusout="validateRange('mtu',false,'MTU')"></td>
         </tr>
         <tr>
            <td width="200px">Metric</td>
            <td width="200px"><input type="number" class="text" id="staticmetric" name="staticmetric" value="<%=wanobj == null?"":wanobj.get("metric")==null?"":wanobj.getString("metric")%>" min="0" max="255" placeholder="0" onkeypress="return avoidSpace(event)" onfocusout="validateRange('metric',false,'Metric')"></td>
         </tr>
         
      </tbody>
   </table>
   <table class="borderlesstab" style="width: 400px; display: table;" id="ipv6config" align="center">
      <tbody>
         <tr>
            <td>IPv6 assignment length</td>
            <td>
               <div>
                  <select id="ipv6asl" name="ipv6asl" value="<%=wanobj == null?"":wanobj.get("ip6asgn") == null ?"":wanobj.getString("ip6asgn") %>"onchange="IPv6Assignment('ipv6asl')">
                     <option value="disable" selected="">disable</option>
                     <option value="64">64</option>
                     <option value="custom">custom</option>
                  </select>
               </div>
               <input type="hidden" id="assl" name="assl">
               <div>
                  <input style="display:none;" id="ipv6asgmnt" type="text" class="text" list="configurations" onkeypress="return event.charCode >= 48 &amp;&amp; event. charCode <= 57" onfocusout="validOnshowWanComboBox('ipv6asgmnt','IPv6 assignment length','assl')">
                  <datalist id="configurations">
                     <option>disable</option>
                     <option>64</option>
                     <option>custom</option>
                  </datalist>
               </div>
            </td>
         </tr>
         <tr id="ipv6address">
            <td width="200">IPv6 Address</td>
            <td width="200"><input type="text" name="ipv6adrs" value="<%=wanobj==null?"":wanobj.get("ip6addr") == null?"":wanobj.getString("ip6addr") %>" id="ipv6adrs" maxlength="255" class="text" onkeypress="return IPV6avoidSpace(event)" onfocusout="validateIPv6('ipv6adrs',false,'IPv6 Address',true)"></td>
         </tr>
         <tr id="ipv6gateway">
            <td width="200">IPv6 Gateway</td>
            <td width="200"><input type="text" name="ipv6gw" id="ipv6gw" value="<%=wanobj==null?"":wanobj.get("ip6gw") == null?"":wanobj.getString("ip6gw") %>" maxlength="256" class="text" onkeypress="return IPV6avoidSpace(event)" onfocusout="validateIPv6('ipv6gw',false,'IPv6 Gateway')"></td>
         </tr>
         <tr id="ipv6hint" style="display:none;">
            <td width="200">IPv6 assignment hint</td>
            <td width="200"><input type="text" name="ipv6agnthnt" id="ipv6agnthnt" value="<%=wanobj==null?"":wanobj.get("ip6hint") == null?"":wanobj.getString("ip6hint") %>" maxlength="256" class="text" onkeypress="return avoidSpace(event)" onfocusout="isEmpty('ipv6agnthnt','IPv6 assignment hint')"></td>
         </tr>
      </tbody>
   </table>
   <table class="borderlesstab" id="pppoetab" style="display: none;" align="center">
      <tbody>
         <tr>
            <td width="200px">UserName</td>
            <td width="200px"><input type="text" class="text" id="uname"  name="uname" maxlength="256" onkeypress="return avoidSpace(event)" value="<%=wanobj == null?"":wanobj.get("username")==null?"":wanobj.getString("username")%>"style="display:inline block;"></td>
         </tr>
         <tr>
            <td width="200px">Password</td>
            <td width="200px"><input type="password" class="text" id="pass" name="pass" maxlength="256" onkeypress="return avoidSpace(event)" value="<%=wanobj == null?"":wanobj.get("password")==null?"":wanobj.getString("password")%>" style="display:inline block"><span toggle="#password-field" class="fa fa-fw fa-eye field_icon toggle-password"></span></td>
         </tr>
         <tr>
            <td width="200px">PPP Authentication</td>
            <td width="200px">
               <select name="ppp_auth" id="ppp_auth">
                  <option value="pap" <%if(ppp_auth.equals("pap")){%>selected<%}%>>PAP</option>
                        <option value="chap" <%if(ppp_auth.equals("chap")){%>selected<%}%>>CHAP</option>
                        <option value="any" <%if(ppp_auth.equals("any")){%>selected<%}%>>Any</option>
                        <option value="none" <%if(ppp_auth.equals("none")){%>selected<%}%>>None</option>
               </select>
            </td>
         </tr>
         <tr>
            <td title="Specifies the Access Concentrator to connect to. If unset, pppd uses the first discovered one">Access Concentrator</td>
            <td><input type="text" class="text" id="accessConcent" name="accessConcent" value="<%=wanobj == null?"":wanobj.get("ac")==null?"":wanobj.getString("ac")%>" maxlength="256" placeholder="auto" onkeypress="return avoidSpace(event);" style="display:inline block;"></td>
         </tr>
         <tr>
            <td title="Specifies the Service Name to connect to. If unset, pppd uses the first discovered one">Service Name</td>
            <td><input type="text" class="text" id="service" name="service" value="<%=wanobj == null?"":wanobj.get("service")==null?"":wanobj.getString("service")%>" maxlength="256" placeholder="auto" onkeypress="return avoidSpace(event);" style="display:inline block;"></td>
         </tr>
         <tr>
            <td>MTU</td>
            <td><input type="number" name="pppoemtu" id="pppoemtu" class="text" value="<%=wanobj == null?"":wanobj.get("mtu")==null?"":wanobj.getString("mtu")%>" placeholder="1500" min="1" max="9000" onkeypress="return avoidSpace(event)" onfocusout="validateRange('pppoemtu',false,'MTU')"></td>
         </tr>
         <tr>
            <td>Metric</td>
            <td><input type="number" name="pppoemetric" id="pppoemetric" placeholder="0" value="<%=wanobj == null?"":wanobj.get("metric")==null?"":wanobj.getString("metric")%>" min="0" max="255" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('pppoemetric',false,'Metric')"></td>
         </tr>
        <%--  <tr>
            <td>Default Route</td>
            <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="pppoedfltrte" id="pppoedfltrte" style="vertical-align:middle"<%if((wanobj.containsKey("defaultroute") && wanobj.getString("defaultroute").equals("1"))) {%> checked <%}%>><span class="slider round"></span></label></td>
         </tr> --%>
         <tr>
            <td>Obtain DNS Servers Automatically</td>
            <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="dnsauto2" id="dnsauto2" style="vertical-align:middle" onchange="hidePppCustomDns('pppoetab','dnsauto2')" <%=peerdns%>><span class="slider round"></span></label></td>
         </tr>
      </tbody>
   </table>
   <table class="borderlesstab" id="dhcptab" style="display: none;" align="center">
      <tbody>
         <tr>
            <td title="Hostname to send when requesting DHCP" width="200px">Hostname</td>
            <td width="200px"><input type="text" class="text" id="hostname" name="hostname"  value="<%=wanobj == null?"":wanobj.get("hostname")==null?"":wanobj.getString("hostname")%>" maxlength="32" onkeypress="return avoidSpace(event);" style="display:inline block;"></td>
         </tr>
         <tr>
            <td title="Client ID to send when requesting DHCP">Client ID</td>
            <td><input type="text" class="text" id="clientid" name="clientid" value="<%=wanobj == null?"":wanobj.get("clientid")==null?"":wanobj.getString("clientid")%>" maxlength="32" onkeypress="return avoidSpace(event);" style="display:inline block;"></td>
         </tr>
         <tr>
            <td title="Vendor Class to send when requesting DHCP">Vendor Class</td>
            <td><input type="text" class="text" id="vendorid" name="vendorid" value="<%=wanobj == null?"":wanobj.get("vendorid")==null?"":wanobj.getString("vendorid")%>" maxlength="32" onkeypress="return avoidSpace(event);" style="display:inline block;"></td>
         </tr>
         <tr>
            <td>MTU</td>
            <td><input type="number" name="dhcpmtu" id="dhcpmtu" class="text" value="<%=wanobj == null?"":wanobj.get("mtu")==null?"":wanobj.getString("mtu")%>" placeholder="1500" min="1" max="9000" onkeypress="return avoidSpace(event)" onfocusout="validateRange('dhcpmtu',false,'MTU')"></td>
         </tr>
         <tr>
            <td>Metric</td>
            <td><input type="number" name="dhcpmetric" id="dhcpmetric" placeholder="0" value="<%=wanobj == null?"":wanobj.get("metric")==null?"":wanobj.getString("metric")%>" min="0" max="255" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('dhcpmetric',false,'Metric')"></td>
         </tr>
        <%--  <tr>
            <td>Default Route</td>
            <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="dhcpdfltrte" id="dhcpdfltrte" style="vertical-align:middle" <%if((wanobj.containsKey("defaultroute") && wanobj.getString("defaultroute").equals("1"))) {%> checked <%}%>><span class="slider round"></span></label></td>
         </tr> --%>
         <tr>
            <td>Obtain DNS Servers Automatically</td>
            <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="dhcpautodns" id="dhcpautodns" style="vertical-align:middle" onchange="hideDhcpCustomDns('dhcptab','dhcpautodns')" <%=peerdns%>><span class="slider round"></span></label></td>
         </tr>
      </tbody>
   </table>
   <table class="borderlesstab" id="dhcp6c" style="display: none;" align="center">
      <tbody>
         <tr>
            <td>MTU</td>
            <td><input type="number" style="float: right;margin-right:38px;" name="dhcp6cmtu" id="dhcp6cmtu" class="text" placeholder="1500" value="<%=wanobj == null?"":wanobj.get("mtu")==null?"":wanobj.getString("mtu")%>" min="1" max="9000" onkeypress="return avoidSpace(event)" onfocusout="validateRange('dhcp6cmtu',true,'MTU')"></td>
         </tr>
         <tr>
            <td>Metric</td>
            <td><input type="number" style="float: right;margin-right:38px;" name="dhcp6cmetric" id="dhcp6cmetric" placeholder="0" value="<%=wanobj == null?"":wanobj.get("metric")==null?"":wanobj.getString("metric")%>" min="0" max="255" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('dhcp6cmetric',true,'Metric')"></td>
         </tr>
         <tr>
            <td>Request IPV6-Address</td>
            <td>
               <select name="reqipv6add" id="reqipv6add" class="text" style="float: right;margin-right:42px;">
                  <option value="disabled">Disabled</option>
                  <option value="try">Try</option>
                  <option value="force">Force</option>
               </select>
            </td>
         </tr>
         <tr>
            <td>Request IPV6-Prefix of Length</td>
            <td>
               <div>
                  <select name="reqipv6prelen" id="reqipv6prelen" class="text" style="float:right;margin-right:38px;" onchange="IPv6prefixlength('reqipv6prelen')">
                     <option value="auto" selected>Auto</option>
                     <option value="disabled">Disable</option>
                     <option value="custom">Custom</option>
                  </select>
               </div>
               <input type="hidden" id="cusmlen" name="cusmlen">
               <div>
                  <input id="ipv6prelength" type="text" class="text" list="reqipv6len" onkeypress="return event.charCode >= 48 &amp;&amp; event.charCode <= 57" onfocusout="validOnshowWanComboBox('ipv6prelength','IPV6-Prefix of Length','cusmlen')" hidden="">
                  <datalist id="reqipv6len">
                  </datalist>
               </div>
            </td>
         </tr>
         <tr>
            <td>Use DNS Servers advertised by peer</td>
            <td><label class="switch"><input type="checkbox" id="dnssvractv" name="dnssvractv" onchange="activateDNSServer('dnssvractv')" <%=peerdns%>><span class="slider round"></span></label></td>
         </tr>
         <tr></tr>
      </tbody>
   </table>
   <table class="borderlesstab" id="dhcp6c1" style="display: none;" align="center">
      <tbody>
         <!-- <tr id="cusdnsdhcp6c1">
            <td>
               <div>Custom DNS Server</div>
            </td>
            <td style="padding-left:50px;">
               <div><input type="text" class="text" id="serversdhcp6c1" name="serversdhcp6c1" style="display:inline block;" onkeypress="return avoidSpace(event);" onfocusout="validateIPv6('serversdhcp6c1',true,'Custom DNS Server')"><label class="add" id="adddhcp6c1" style="display: inline;" onclick="addIPRowAndChangeIcondhcp6c(1)">+</label><label class="remove" style="display: none;" id="removedhcp6c1" onclick="deletetableRowdhcp6c()">x</label><input id="row1" value="1" hidden=""></div>
            </td>
         </tr> -->
      </tbody>
   </table>
   <div align="center"><input type="submit" name="Apply" value="Apply" style="display:inline block" class="button"></div>
</form>
 <%
   	if(errorstr != null && errorstr.trim().length() > 0)
			{%>
		     <script>
			 showErrorMsg("<%=errorstr%>");
			 </script>
			<%}

	  if(waniparr.size()>0)
	  {
      for(int i=0;i<waniparr.size();i++)
      {   	 
		 String cidr_ip =  waniparr.getString(i);
		 SubnetUtils utils = new SubnetUtils(cidr_ip);
		 utils.setInclusiveHostCount(true);
		 String row = i+1+"";
		 %>
		 <script>		
		 addIPRowAndChangeIcon('statictab','<%=(i+1)%>');		 
		 fillIProw('<%=(i+2)%>','<%=utils.getInfo().getAddress()%>','<%=utils.getInfo().getNetmask()%>');
		 </script>
		<% 
      }
	  }
	  else
	  {
		 %>
		 <script>		
		 addIPRowAndChangeIcon('statictab','1');		 
		 </script>
		<%  
	  }
	  if(stadnsarr.size() > 0)
	  {
      for(int i=0;i<stadnsarr.size();i++)
      {
		 String dns =  stadnsarr.getString(i);
		 %>
		 <script>		
		 addIPRowAndChangeIconstatic(customdnsstatic);		 
		 fillIProwstatic(customdnsstatic,'<%=dns%>');
		 </script>
		<% 
      }
	  }
	  else{%>
		  <script>		
		 addIPRowAndChangeIconstatic(customdnsstatic);	 
		 </script>
	  <%}
	  
	  if(dhcpdnsarr.size() > 0)
	  {

      for(int i=0;i<dhcpdnsarr.size();i++)
      {
		 String dns =  dhcpdnsarr.getString(i);
		 %>
		 <script>		
		 addIPRowAndChangeIcondhcp(customdnsdhcp);		 
		 fillIProwdhcp(customdnsdhcp,'<%=dns%>');
		 </script>
		<% 
      }
	  }
	  else{%>
		  <script>		
		 addIPRowAndChangeIcondhcp(customdnsdhcp);	 
		 </script>
	  <%}
	  if(pppoednsarr.size() > 0)
	  {
      for(int i=0;i<pppoednsarr.size();i++)
      {
		 String dns =  pppoednsarr.getString(i);
		 %>
		 <script>		
		 addIPRowAndChangeIconpppoe(customdnspppoe);		 
		 fillIProwpppoe(customdnspppoe,'<%=dns%>');
		 </script>
		<% 
      }
	  }
	  else{%>
		  <script>		
		 addIPRowAndChangeIconpppoe(customdnspppoe);	 
		 </script>
	  <%}
	  if(dhcp6dnsarr.size() > 0)
	  {
		  for(int i=0;i<dhcp6dnsarr.size();i++)
		  {
			  String dns = dhcp6dnsarr.getString(i);
	%>
	<script type="text/javascript">
		addIPRowAndChangeIcondhcp6c(customdnsdhcp6c);
		fillIProwdhcp6c(customdnsdhcp6c,'<%=dns%>');
	</script>
		<%
		  }
	  }
      else { %>
      	<script>		
      	addIPRowAndChangeIcondhcp6c(customdnsdhcp6c);	 
		 </script>
		<%}%>
	  
      <script>
	  displayActiveTable('wanproto');
	  IPv6Assignment('ipv6asl');
	  IPv6prefixlength('reqipv6prelen');
	  activateDNSServer('dnssvractv');
	  //addIPRowAndChangeIcondhcp6c(0);
	  findLastRowAndDisplayRemoveIcondhcp6c();
	  findLastRowAndDisplayRemoveIcon();
	  findLastRowAndDisplayRemoveIconstatic();
	  findLastRowAndDisplayRemoveIcondhcp();
	  findLastRowAndDisplayRemoveIconpppoe();
	  hideDhcpCustomDns('dhcptab','dhcpautodns');
	  hidePppCustomDns('pppoetab','dnsauto2');
	  </script>
   </body>
</html>