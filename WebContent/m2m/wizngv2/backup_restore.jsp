<html>
   <head>
      <meta http-equiv="pragma" content="no-cache">
      <script type="text/javascript" src="js/fileupload.js"></script>
      <style></style>
      <style type="text/css">
.style1 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	color: black;
	font-size: 24px;
	font-weight: bold;
}

.style2 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	color: #000000;
	font-size: 16px;
	font-weight: bold;
}

body {
	background-color: #FAFCFD;
}

.button {
	display: inline;
	border-radius: 6px;
	background-color: grey;
	color: #ffffff;
	font-weight: bold;
	box-shadow: 1px 2px 4px 0 rgba(0, 0, 0, 0.08);
	padding: 6px 12px;
	border: 0;
	margin: 20px;
	cursor: pointer;
}
</style>
      <script type="text/javascript">
	  function ShowGenerate() {
	var alertmsg = "Please click on 'Generate Archieve' to create backup of current configuration files.\n";
	alertmsg += "And try again for Download .. ";
	alert(alertmsg);
}
	  </script>
   </head>
   <body>
      <p>&nbsp;</p>
      <hr noshade="" color="grey">
      <p>&nbsp;</p>
      <p class="style1">&nbsp;&nbsp;&nbsp;&nbsp;Backup</p>
      <p class="style2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To download a tar archieve of the current configuration files.</p>
      <form id="Backup" action="" method="post" onsubmit="">
         <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Download backup&nbsp;&nbsp;<input type="submit" name="archieve" value="Generate Archieve" style="display:inline block" class="button"><input type="button" name="Download" value="Download" style="display:inline block" class="button" onclick="ShowGenerate()"></p>
      </form>
      <p>&nbsp;</p>
      <p class="style1">&nbsp;&nbsp;&nbsp;&nbsp;Restore</p>
      <p class="style2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To restore configuration files, you can upload a previously generated backup archieve here.</p>
      <form id="Restore" action="" enctype="multipart/form-data" method="post" onsubmit="">
         <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Restore backup&nbsp;&nbsp;&nbsp;&nbsp;<input type="file" id="configUpload" name="configUpload" accept=".tar.gz" style="display:inline block" onchange="configSelected()"><input type="button" name="Upload" value="Upload" style="display:inline block" class="button" onclick="configUploadFile()"></p>
      </form>
      <p id="configSize"></p>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<progress id="configProgressBar" value="0" max="100" style="width:600px;display:none;"></progress>
      <p id="configProgressNo"></p>
      <p>&nbsp;</p>
      <div id="process" hidden="">
         <p class="style2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The backup archieve was uploaded. Click on "Proceed" to restore the backup.</p>
         <form action="" method="post" onsubmit="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" name="Proceed" value="Proceed" class="button"><input type="hidden" id="fileName" name="fileName" value=""></form>
      </div>
      <hr noshade="" color="grey">
   </body>
</html>