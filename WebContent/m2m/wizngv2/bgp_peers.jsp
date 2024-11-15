<html>
   <head>
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <link href="css/fontawesome.css" rel="stylesheet">
      <link href="css/solid.css" rel="stylesheet">
      <link href="css/v4-shims.css" rel="stylesheet">	 
	  <style>
	  
	  #act_icon
	  {
	  padding-right:10;
	  color:#7B68EE;
	  cursor:pointer;
	  }
	  #new_icon {
	  padding-right:10;
	  color:#DE3163;
	  cursor:pointer;
	  }
	  </style>
      
   </head>
   <body>
      <form action="" method="post" onsubmit="">
         <br>
         <blockquote>
            <p class="style5" align="center">BGP Peers</p>
         </blockquote>
         <br><input type="text" id="grerwcnt" name="grerwcnt" value="1" hidden="">
         <table class="borderlesstab" id="WiZConff" style="width:800px;" align="center">
            <tbody>
               <tr>
                  <th  width="15%" >Name</th>
                  <th  width="20%" >Remote As</th>
                  <th  width="20%" >Remote Address</th>
                  <th  width="15%" >Status</th>
                  <th  width="15%" >Action</th>
				  <th  width="15%" >New</th>

               </tr>
			   <tr>
			   <td><input type="text" class="text" id="ins_name" name="ins_name"></td>
			   <td><input type="text" class="text" id="rtm_as" name="rtm_as" maxlength="32" ></td>
			   <td><input type="text" class="text" id="rtm_addr" name="rtm_addr" maxlength="32" ></td>
			   <td><label class="switch" style="vertical-align:middle"><input type="checkbox" id="enable" name="enable" style="vertical-align:middle"><span class="slider round"></span></label></td>
			   <td><i id="act_icon" class="fa fa-edit"  onclick="editBgp()"></i>
			   <i id="act_icon" class="fa fa-trash-o"  onclick="deleteBgp()"></i></td>
			   <td><i id="new_icon" class="fas fa-plus" onclick="addBgp()" ></i></td>

			   </tr>
            </tbody>
         </table>
         
         <div align="center"><input type="submit" name="Apply" value="Apply" class="button"><input type="submit" name="Save" value="Save &amp; Apply" class="button"></div>
      </form>
   </body>