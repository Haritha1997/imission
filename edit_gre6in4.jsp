<html>
   <head>
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
      <script type="text/javascript" src="js/gre6in4.js"></script>
   </head>
   <body>
      <form action="" method="post" onsubmit="return validateGre()">
         <br>
         <p align="center" id="forwardedit" class="style5">GRE6in4</p>
         <br>
         <table class="borderlesstab" id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="200px">Parameters</th>
                  <th width="200px">Configuration</th>
               </tr>
               <tr>
                  <td>Enabled</td>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="enable" name="enable" style="vertical-align:middle"><span class="slider round"></span></label></td>
               </tr>
               <tr>
                  <td>Tunnel Source</td>
                  <td>
                     <select class="text" id="proto" name="proto">
                        <option value="Eth1" selected="">Eth1</option>
                        <option value="Dialer">Dialer</option>
                        <option value="Cellular">Cellular</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>Remote End Point IPAddress</td>
                  <td><input type="text" class="text" id="rem_ipaddress" name="rem_ipaddress" value=""  onfocusout="validateIP('rem_ipaddress',true,'Remote End Point IPAddress')"></td>
               </tr>
			   <tr>
               <td>MTU</td>
               <td><input type="number" name="mtu" id="mtu" min="1" max="1500" placeholder="(0-1500)" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('mtu',true,'MTU')"/>
               </td>
               </tr>
			   <tr>
               <td>TTL</td>
               <td><input type="number" name="ttl" id="ttl" min="1" max="255" placeholder="(0-255)" class="text" onkeypress="return avoidSpace(event)" onfocusout="validateRange('ttl',true,'TTL')"/>
               </td>
               </tr>
			    <tr>
                  <td>Keep Alive</td>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="keep_alive" name="keep_alive" style="vertical-align:middle"><span class="slider round"></span></label></td>
               </tr>
			   <tr>
               <td>Keep Alive Interval</td>
               <td><input type="number" name="keep_alive_interval" id="keep_alive_interval" min="0" max="32365" placeholder="(0-32365)" class="text" onkeypress="return avoidSpace(event)"/>
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
                  <td>Local Gre IPv6 Address</td>
                  <td><input type="text" class="text" id="lcl_ipv6_address" name="lcl_ipv6_address" value=""  onfocusout="validateIPV6('lcl_ipv6_address',true,'Local Gre IPv6 IPAddresss')"></td>
               </tr>
			   
            </tbody>
         </table>
		 </div>
		 <br><br>
         <p class="style5" align="center">Routing Settings</p>&nbsp;
		  <div id="tunnel_setting" align="center" style="margin:0px;">
         <table class="borderlesstab"  style="width:400px;"  align="center" id="tunnelsetting">
            <tbody>
               <tr>
                  <th width="200">Parameters</th>
                  <th width="200">Configuration</th>
               </tr>
               <tr>
                  <td>Remote Subnet IPV6 network</td>
                  <td><input type="text" class="text" id="rem_ipv6_ipaddress" name="rem_ipv6_ipaddress" value=""  onfocusout="validateIPV6('rem_ipv6_ipaddress',true,'Remote IPv6 IPAddress')"></td>
               </tr>
			   
            </tbody>
         </table>
		 </div>
		 
         <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"><input type="submit" value="Save &amp; Apply" name="Save" style="display:inline block" class="button"></div>
      </form>
   </body>
</html>