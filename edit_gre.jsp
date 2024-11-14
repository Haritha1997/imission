<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.apache.commons.net.util.SubnetUtils"%>
<%@page import="java.net.NetworkInterface"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>
 <%
        String grename = request.getParameter("grename")==null?"":request.getParameter("grename");
 		int rows = request.getParameter("rows")==null?-1:Integer.parseInt(request.getParameter("rows"));
 		String slnumber=request.getParameter("slnumber");
 		String version=request.getParameter("version");
		String errorstr = request.getParameter("error");  
		JSONObject wizjsonnode = null;
		JSONObject nwobj=null;
		JSONObject greobj=null;
		String tunnelname="";
		JSONObject tunnelobj=null;
		JSONArray routeobj=null;
		BufferedReader jsonfile = null;  
		boolean enabled = false;
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
				nwobj=wizjsonnode.containsKey("network")?wizjsonnode.getJSONObject("network"):new JSONObject();
				greobj=nwobj.containsKey("interface:"+grename)?nwobj.getJSONObject("interface:"+grename):new JSONObject();
				tunnelname=greobj.containsKey("tunnel")?greobj.getString("tunnel"):"";
		   		tunnelobj=nwobj.containsKey("interface:"+tunnelname)?nwobj.getJSONObject("interface:"+tunnelname):new JSONObject();
		   		routeobj=nwobj.containsKey("route")?nwobj.getJSONArray("route"):new JSONArray();
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
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <link href="css/solid.css" rel="stylesheet">
      <link href="css/v4-shims.css" rel="stylesheet">
      <link href="css/fontawesome.css" rel="stylesheet">
      <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
      <script type="text/javascript" src="js/gre.js"></script>
	  <script type="text/javascript" src="js/common.js"></script>
	  <script type="text/javascript">
	  var iprows=1;
	  var tarrows=1;
	  </script>
	  
   </head>
   <body>
      <form action="savedetails.jsp?page=edit_gre&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="return validateGre()">
         <br>
         <p align="center" id="greedit" class="style5">GRE</p>
         <br>
         <table class="borderlesstab" id="GREtab3" align="center">
         <input type="hidden" id="iprows" name="iprows" value="1"/>
          <input type="hidden" id="rows" name="rows" value="<%=rows%>"/>
            <tbody>
               <tr>
                  <th width="200px">Parameters</th>
                  <th width="200px">Configuration</th>
               </tr>
               <tr>
                  <td>Enabled</td>
                  <%String enable=greobj!=null?greobj.containsKey("enabled")?greobj.getString("enabled").equals("1")?"checked":"":"":""; %>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="enable" name="enable" <%=enable%> style="vertical-align:middle"><span class="slider round"></span></label></td>
               </tr>
               <tr>
                  <td>Instance Name</td>
                  <td><input type="text" class="text" id="grename" name="grename" value="<%=grename%>" readonly></td>
               </tr>
               <tr>
                  <td>Tunnel Source</td>
                  <td>
                     <div>
                     <%String tunsrc=greobj!=null?greobj.containsKey("srcif")?greobj.getString("srcif"):"":""; %>
                        <select class="text" id="tunnelsrcsel" name="tunnelsrcsel" onchange="selectGRECustom('tunnelsrcsel')">
                           <!-- <option value="Eth1" selected="">Eth1</option>
                           <option value="Dialer">Dialer</option> -->
                           <option value="lan" <%if(tunsrc.equals("lan")){%>selected<%} %>>LAN</option>
                           <option value="wan" <%if(tunsrc.equals("wan")){%>selected<%} %>>WAN</option>
                           <option value="loopback" <%if(tunsrc.equals("loopback")){%>selected<%} %>>Loopback</option>
                           <option value="cellular" <%if(tunsrc.equals("cellular")){%>selected<%} %>>Cellular</option>
                          <!--  <option value="Any" selected="">Any</option> -->
                           <option value="6" <%if(!tunsrc.equals("lan")&&!tunsrc.equals("wan")&&!tunsrc.equals("loopback")&&!tunsrc.equals("cellular")&&tunsrc.trim().length()>0){%>selected<%} %>>Custom</option>
                        </select>
                     </div>
                     <div>
                     <%if(!tunsrc.equals("lan")&&!tunsrc.equals("wan")&&!tunsrc.equals("loopback")&&!tunsrc.equals("cellular")&&tunsrc.trim().length()>0) {%>
                        <input id="tunlsrc" type="text" value="<%=tunsrc%>" class="text" list="configurations" onmouseover="setTitle(this)" onfocusout="validOnshowGREComboBox('tunlsrc','Tunnel Source')" onkeypress="return avoidSpace(event)">
                     	<script>
                     			selectGRECustom('tunnelsrcsel');
                        </script>
                     <%}else {%>
                            <input hidden="" id="tunlsrc" type="text" value="" class="text" list="configurations" onmouseover="setTitle(this)" onfocusout="validOnshowGREComboBox('tunlsrc','Tunnel Source')" onkeypress="return avoidSpace(event)">
                     <%}%>
                        <datalist id="configurations"></datalist>
                     </div>
                  </td>
               </tr>
               <tr>
               <td>Remote End Point</td>
               <%String remendpnt=greobj!=null?greobj.containsKey("peeraddr")?greobj.getString("peeraddr"):"":"";%>
               <td><input type="text" class="text" id="rem_ipaddress" name="rem_ipaddress" value="<%=remendpnt%>"  onfocusout="validateIPOnly('rem_ipaddress',true,'Remote End Point IPAddress')" onkeypress="return avoidSpace(event)"></td>
               </tr>
			   <tr>
               <td>MTU</td>
                <%String mtu=greobj!=null?greobj.containsKey("mtu")?greobj.getString("mtu"):"":""; %>
               <td><input type="number" name="mtu" id="mtu" min="1" max="1500" placeholder="(1-1500)" value="<%=mtu%>" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('mtu',true,'MTU')"/>
               </td>
               </tr>
			   <tr>
               <td>TTL</td>
               <%String ttl=greobj!=null?greobj.containsKey("ttl")?greobj.getString("ttl"):"":""; %>
               <td><input type="number" name="ttl" id="ttl" min="1" max="255" placeholder="(1-255)" class="text" value="<%=ttl%>" onkeypress="return avoidSpace(event)" onfocusout="validateRange('ttl',true,'TTL')"/>
               </td>
               </tr>
               <tr>
               <td>Inbound key</td>
               <%String inbundkey=greobj!=null?greobj.containsKey("ikey")?greobj.getString("ikey"):"":""; %>
               <td><input type="number" name="inbkey" id="inbkey" min="1" max="4294967295" placeholder="(1-4294967295)" value="<%=inbundkey%>" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('inbkey',true,'Inbound key')"/>
               </td>
                </tr>
                <tr>
                  <td>Outbound key</td>
                  <%String outbundkey=greobj!=null?greobj.containsKey("okey")?greobj.getString("okey"):"":""; %>
                  <td><input type="number" name="outbkey" id="outbkey" min="1" max="4294967295" placeholder="(1-4294967295)" value="<%=outbundkey%>" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('outbkey',true,'Outbound key')"/>
                  </td>
                </tr>
            <tr>
               <td>Keep Alive</td>
                <%String kpalive=tunnelobj!=null?tunnelobj.containsKey("keepalive")?tunnelobj.getString("keepalive").equals("enable")?"checked":"":"":""; %>
               <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="keep_alive" name="keep_alive" <%=kpalive%> style="vertical-align:middle"><span class="slider round"></span></label></td>
            </tr>
			   <tr>
               <td>Keep Alive Interval (Secs)</td>
               <%String kpaliinter=tunnelobj!=null?tunnelobj.containsKey("keepalive_int")?tunnelobj.getString("keepalive_int"):"":""; %>
               <td><input type="number" name="keep_alive_interval" id="keep_alive_interval" min="1" max="3600" placeholder="(1-3600)" value="<%=kpaliinter%>" class="text" onkeypress="return avoidSpace(event)"/>
               </td>
            </tr>
            <tr>
               <td>Keep Alive Retries (Secs)</td>
               <%String kpaliretr=tunnelobj!=null?tunnelobj.containsKey("keepalive_retries")?tunnelobj.getString("keepalive_retries"):"":""; %>
               <td><input type="number" name="keep_alive_retries" id="keep_alive_retries" min="1" max="255" placeholder="(1-255)" value="<%=kpaliretr%>" class="text" onkeypress="return avoidSpace(event)"/>
               </td>
            </tr>
            
            </tbody>
         </table>
		 <br><br>
         <p class="style5" align="center">Tunnel Settings</p>&nbsp;
		  <div id="tunnel_setting" align="center" style="margin:0px;">
         <table class="borderlesstab"  style="width:400px;"  align="center" id="tunnelsetting">
            <tbody>
               <tr>
                  <th width="200">Parameters</th>
                  <th width="200">Configuration</th>
               </tr>
               <tr>
                     <td>Tunnel IPv4 Addresss</td>
                     <%String tunipaddr=tunnelobj!=null?tunnelobj.containsKey("ipaddr")?tunnelobj.getString("ipaddr"):"":""; %>
                     <td><input type="text" class="text" id="lcl_ipaddress" name="lcl_ipaddress" value="<%=tunipaddr%>" onfocusout="validateIP('lcl_ipaddress',true,'Tunnel IPv4 Addresss')" onkeypress="return avoidSpace(event)"></td>
                  </tr>
                  <tr>
                     <td>Tunnel IPv4 Netmask</td>
                     <%String tunnetmask=tunnelobj!=null?tunnelobj.containsKey("netmask")?tunnelobj.getString("netmask"):"":""; %>
                     <td><input type="text" class="text" id="lcl_netmask" name="lcl_netmask" value="<%=tunnetmask%>" onfocusout="validateSubnetMask('lcl_netmask',true,'Tunnel IPv4 Netmask')" onkeypress="return avoidSpace(event)"></td>
                  </tr>
            </tbody>
         </table>
		 </div>
		 <br><br>
         <p class="style5" align="center">Routing Settings</p>&nbsp;
		  <div id="tunnel_setting" align="center" style="margin:0px;">
         <table class="borderlesstab"  style="width:400px;"  align="center" id="routesetting1">
         <input type="hidden" id="tarrows" name="tarrows" value="1"/>
            <tbody>
               <tr>
                  <th width="200">Parameters</th>
                  <th width="200">Configuration</th>
               </tr>
            </tbody>
            <%
            String  target ="";
            String  tarnetmask="";
            String targw="";
            String tarmetric="";
            for(int i=0;i<routeobj.size();i++)
            {
            	JSONObject routetunnelobj=routeobj.getJSONObject(i);
            	if(routetunnelobj.containsKey("interface") && routetunnelobj.getString("interface").equals(tunnelname))
            	{
            		target = routetunnelobj.containsKey("target")? routetunnelobj.getString("target"):"";
        			tarnetmask = routetunnelobj.containsKey("netmask")? routetunnelobj.getString("netmask"):"";
        			targw = routetunnelobj.containsKey("gateway")? routetunnelobj.getString("gateway"):"";
        			tarmetric = routetunnelobj.containsKey("metric")? routetunnelobj.getString("metric"):"1";
        			if(target.length()>0||tarnetmask.length()>0){%>
        			<script> 
        	         addIPRowAndChangeIcon(tarrows);
        	         fillIProw(tarrows,'<%=target%>','<%=tarnetmask%>');
        			</script>
        			<%	
        			}
            	}
            }
            if(target.isEmpty()&&tarnetmask.isEmpty()&& targw.isEmpty()&&tarmetric.isEmpty())
            {%>
       			<script> 
       				addIPRowAndChangeIcon(tarrows);		 
       	        	fillIProw('2','','');
       			</script>
       			<%	
            }
           %>
         </table>
         <table class="borderlesstab"  style="width:400px;"  align="center" id="routesetting2">
            <tbody>
                <tr>
                    <td width="200">IPV4 Gateway</td>
                    <td width="200"><input type="text" class="text" id="gateway" name="gateway" value="<%=targw%>" onfocusout="validateIPOnly('gateway',true,'IPV4 Gateway')" onkeypress="return avoidSpace(event)"></td>
                </tr>
                <tr>
                  <td>Metric</td>
                  <td><input type="number" name="metric" id="metric" min="1" max="255" value="<%=tarmetric%>" placeholder="(1-255)" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('metric',true,'Metric')"/>
                  </td>
                </tr>
            </tbody>
         </table>
		 </div>
      <div align="center"><input type="button" value="Back to Overview" name="back" style="display:inline block" class="button" onclick="gotogre('<%=slnumber%>','<%=version%>')"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"></div>
      </form>
   </body>
</html>
