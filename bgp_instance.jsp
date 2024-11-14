<html>
   <head>
      <link rel="stylesheet" type="text/css" href="css/style.css">
    
   </head>
   <body>
   <form action="" method="post">
    <br>
         <p align="center" id="forwardedit" class="style5">BGP Instance</p>
         <br>
		 <table class="borderlesstab" id="WiZConf" align="center">
            <tbody>
               <tr>
                  <th width="200px">Parameters</th>
                  <th width="200px">Configuration</th>
               </tr>
			   <tr>
			   <td>Enable</td>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="enable" name="enable" style="vertical-align:middle"><span class="slider round"></span></label></td>
               </tr>
			   <tr>
			   <td>As </td>
			   <td><input type="text" class="text" id="as" name="as" value="" ></td>
			   </tr>
			   <tr>
			   <td>BGP Router ID </td>
			   <td><input type="text" class="text" id="bgp_id" name="bgp_id" onfocusout="validateIP('bgp_id',true,'BGP Router ID')"></td>
               
			   </tr>
			   <tr>
			   <td>Network</td>
			   <td><input type="number" class="text" id="net" name="net" min="1" max="20" placeholder="(0-20)" onfocusout="validateRange('net',true,'Network')"></td>
               
			   </tr>
			   <tr>
			   <td>Redistribution Options</td>
			   <td>
			    <select class="text" id="proto" name="proto">
                        <option value="connected" >connected</option>
                        <option value="Kernel">Kernel</option>
                        <option value="OSPF">OSPF</option>
						<option value="STATIC">STATIC</option>
                     </select>
                  </td>
               </tr>
			   <tr>
			   <td>Deterministic MED</td>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="enable" name="enable" style="vertical-align:middle"><span class="slider round"></span></label></td>
               </tr>
			   
			   
			</tbody>
			</table>
			<div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button">
			<input type="submit" value="Save &amp; Apply" name="Save" style="display:inline block" class="button"></div>

			</form>
			</body>
			</html>