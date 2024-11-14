<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css" href="css/style.css">
      <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script> 
	  <script type="text/javascript" src="js/manual6in4.js"></script>	  
	  <script type="text/javascript" src="js/common.js"></script> 
</head>
<body>
<form action="Nomus.cgi?cgi=manual6in4EditProcess=tunnelM1.cgi" method="post" onsubmit="return validateGre()">
         <br>         
         <p id="forwardedit" class="style5" align="center">Manual6in4</p>
         <br>         
         <table class="borderlesstab" id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="200px">Parameters</th>
                  <th width="200px">Configuration</th>
               </tr>
               <tr>
                  <td>Enabled</td>
                  <td><label class="switch" style="vertical-align:middle">				<input type="checkbox" id="enable" name="enable" style="vertical-align:middle">				<span class="slider round"></span></label></td>
               </tr>
               <tr>               </tr>
               <tr>
                  <td>Tunnel Source</td>
                  <td>
                     <select class="text" id="proto" name="proto">
                        <option value="1">Eth1</option>
                        <option value="2">Dialer</option>
                        <option value="3">Cellular</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Remote End Point IPAddress</td>
                  <td><input type="text" class="text" id="rem_ipaddress" name="rem_ipaddress" value="" onfocusout="validateIP('rem_ipaddress',true,'Remote End Point IPAddress')"></td>
               </tr>
               <tr>
                  <td>MTU</td>
                  <td><input type="number" name="mtu" id="mtu" min="1" max="1500" value="" placeholder="(0-1500)" class="text" onkeypress="return avoidSpace(event)" onfocusout="">               </td>
               </tr>
               <tr>
                  <td>TTL</td>
                  <td><input type="number" name="ttl" id="ttl" min="1" max="255" value="" placeholder="(0-255)" class="text" onkeypress="return avoidSpace(event)" onfocusout="">               </td>
               </tr>
               <tr>
                  <td>Keep Alive</td>
                  <td><label class="switch" style="vertical-align:middle">				<input type="checkbox" id="Keep_alive" name="Keep_alive" style="vertical-align:middle">				<span class="slider round"></span></label></td>
               </tr>
               <tr>
                  <td>Keep Alive Interval</td>
                  <td><input type="number" name="keep_alive_interval" id="keep_alive_interval" min="0" max="32365" value="" placeholder="(0-32365)" class="text" onkeypress="return avoidSpace(event)">               </td>
               </tr>
            </tbody>
         </table>
         <br><br>         
         <p class="style5" align="center">Tunnel Settings</p>
         &nbsp;		  
         <div id="tunnel_setting" style="margin:0px;" align="center">
            <table class="borderlesstab" style="width:400px;" id="tunnelsetting" align="center">
               <tbody>
                  <tr>
                     <th width="200">Parameters</th>
                     <th width="200">Configuration</th>
                  </tr>
                  <tr>
                     <td>Tunnel IPv6 Address</td>
                     <td><input type="text" class="text" id="lcl_ipv6_address" name="lcl_ipv6_address" value="" onfocusout="validateIPV6('lcl_ipv6_address',true,'Tunnel IPv6 Address')"></td>
                  </tr>
               </tbody>
            </table>
         </div>
         <br><br>         
         <p class="style5" align="center">Routing Settings</p>
         &nbsp;		  
         <div id="tunnel_setting" style="margin:0px;" align="center">
            <table class="borderlesstab" style="width:400px;" id="tunnelsetting" align="center">
               <tbody>
                  <tr>
                     <th width="200">Parameters</th>
                     <th width="200">Configuration</th>
                  </tr>
                  <tr>
                     <td>Target IPV6 network</td>
                     <td><input type="text" class="text" id="rem_ipv6_ipaddress" name="rem_ipv6_ipaddress" value="" onfocusout="validateIPV6('rem_ipv6_ipaddress',true,'Target IPV6 network')"></td>
                  </tr>
                  <tr>
                     <td>IPV6 Gatway</td>
                     <td><input type="text" class="text" id="ipv6_gateway" name="ipv6_gateway" value="" onfocusout="validateIPv6gateway('ipv6_gateway',true,'IPV6 Gatway')"></td>
                  </tr>
               </tbody>
            </table>
         </div>
         <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"></div>
      </form>
</body>
</html>