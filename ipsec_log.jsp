

<html>
   <head>
      <meta http-equiv="pragma" content="no-cache">
      <link href="css/fontawesome.css" rel="stylesheet">
      <link href="css/solid.css" rel="stylesheet">
      <link href="css/v4-shims.css" rel="stylesheet">
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <script type="text/javascript">
	  function loadDoc() {
	document.getElementById("text").scrollTop = document.getElementById("text").scrollHeight;
}

function saveTextAsFile(textToWrite, fileNameToSaveAs) {
	var textFileAsBlob = new Blob([textToWrite], {
		type: 'text/plain'
	});
	var downloadLink = document.createElement("a");
	downloadLink.download = fileNameToSaveAs;
	downloadLink.innerHTML = "Download File";
	if (window.webkitURL != null) {
		downloadLink.href = window.webkitURL.createObjectURL(textFileAsBlob);
	} else {
		downloadLink.href = window.URL.createObjectURL(textFileAsBlob);
		downloadLink.onclick = destroyClickedElement;
		downloadLink.style.display = "none";
		document.body.appendChild(downloadLink);
	}
	downloadLink.click();
}
	  </script>
      <style></style>
   </head>
   <%
String slnumber=request.getParameter("slnumber");
%>
   <body onload="loadDoc();">
      <center>
         <div>
            <p class="style1" align="center">IPSec Log</p>
            <br>
         </div>
         <textarea id="text" name="text" align="center" cols="100" rows="25" style="font-size:12px" readonly="readonly" wrap="off"></textarea>
         <div>
            <form action="savedetails.jsp?page=ipsec_log&slnumber=<%=slnumber%>" method="post" onsubmit=""><button type="submit" id="Refresh" name="Refresh" class="button">Refresh &nbsp;<i class="fa fa-refresh" aria-hidden="true" style="display:inline;font-size:10px;color:white"></i></button><label class="button" style="font-size:13.5px;font-family: Arial, Helvetica, sans-serif;font-weight:bold;" onclick="saveTextAsFile(text.value,'IPSec-WiZ_NG-01-January-2000.log')">Export Log &nbsp;<i class="fa fa-download" aria-hidden="true" style="display:inline;font-size:10px; color:white"></i></label></form>
         </div>
      </center>
   </body>
</html>