<html>
   <head>
      <link rel="stylesheet" type="text/css" href="css/style.css">
	       
    
   </head>
   <body>
   <form action="" method="post">
    <br>
         <p align="center" id="forwardedit" class="style5">BGP Peer</p>
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
			   <td>Remote As</td>
			   <td><input type="text" class="text" id="rmt_as" name="rmt_as" value="" onfocusout="validateIP('rmt_as',true,'Remote As')"></td>
			   </tr>
			    <tr>
			   <td>Remote Address</td>
			   <td><input type="text" class="text" id="rmt_addr" name="rmt_addr" value="" onfocusout="validateIP('rmt_addr',true,'Remote Address')"></td>
			   </tr>
			    <tr>
			   <td>Remote Pur</td>
			   <td><input type="number" class="text" id="rmt_pur" name="rmt_pur" min="1" max="255" placeholder="(0-255)" onfocusout="validateRange("rmt_pur",true,"Remote Pur");" ></td>
			   </tr>
			    <tr>
			   <td>EBGP Multihub</td>
			   <td><input type="number" class="text" id="bgp_hub" name="bgp_hub" min="1" max="255" placeholder="(0-255)"  onfocusout="validateRange("bgp_hub",true,"EBGP Multihub")"></td>
			   </tr>
			    <tr>
                  <td>Default Originate</td>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="enable" name="enable" style="vertical-align:middle"><span class="slider round"></span></label></td>
               </tr>
			    <tr>
			   <td>Description</td>
			   <td><input type="text" class="text" id="desc" name="desc" value="" ></td>
			   </tr>
			   <td>Password</td>
			   <td><input type="password" class="text" id="pwd" name="pwd" value="" ></td>
			   </tr>
			   </tbody>
			   </table>
			   <div align="center"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button">
			   <input type="submit" value="Save &amp; Apply" name="Save" style="display:inline block" class="button"></div>

		 </form>
   </body>
   </html>