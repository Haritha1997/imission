function firmwareSelected() {
	var file = document.getElementById('firmwareUpload').files[0];
	if (file) {
		if (file.size > 1024 * 1024 * 100) {
        		alert("File size exceeds 100 MB.");
            	document.getElementById('firmwareUpload').value = "";
           	document.getElementById('firmwareSize').style.display = "none";
		    	return false;
		}
        	var fileSize = 0;
        	if (file.size > 1024 * 1024)
        		fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString() + 'MB';
        	else
          	fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB';

		document.getElementById('firmwareSize').style.display = "";
        	document.getElementById('firmwareSize').innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;File size : ' + fileSize;
	}
}

function configSelected() {
	var file = document.getElementById('configUpload').files[0];
	if (file) {
		if (file.size > 1024 * 1024 * 2) {
			alert("File size exceeds 2 MB.");
			document.getElementById('configUpload').value = "";
			document.getElementById('configSize').style.display = "none";
		    	return false;
		}
        	var fileSize = 0;
        	if (file.size > 1024 * 1024)
        		fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString() + 'MB';
        	else
          	fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB';

		document.getElementById('configSize').style.display = "";
        	document.getElementById('configSize').innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;File size : ' + fileSize;
	}
}

function firmwareUploadFile() {
	var file = document.getElementById('firmwareUpload').files[0];
	if (!file) {
		alert("Please select the file and click on Upload !!");
		return false;
	}
	document.getElementById('firmwareProgressBar').style.display = "";
	var fd = new FormData();
	fd.append("firmwareUpload", document.getElementById('firmwareUpload').files[0]);
	var xhr = new XMLHttpRequest();
	xhr.upload.addEventListener("progress", firmwareUploadProgress, false);
	xhr.addEventListener("load", firmwareUploadComplete, false);
	xhr.addEventListener("error", uploadFailed, false);
	xhr.addEventListener("abort", uploadCanceled, false);
	xhr.open("POST", "Nomus.cgi?cgi=FileUpload.cgi");
	xhr.send(fd);
}

function configUploadFile() {
	var file = document.getElementById('configUpload').files[0];
	if (!file) {
		alert("Please select the file and click on Upload !!");
		return false;
	}
	document.getElementById('configProgressBar').style.display = "";
	var fd = new FormData();
	fd.append("configUpload", document.getElementById('configUpload').files[0]);
	var xhr = new XMLHttpRequest();
	xhr.upload.addEventListener("progress", configUploadProgress, false);
	xhr.addEventListener("load", configUploadComplete, false);
	xhr.addEventListener("error", uploadFailed, false);
	xhr.addEventListener("abort", uploadCanceled, false);
	xhr.open("POST", "Nomus.cgi?cgi=FileUpload.cgi");
	xhr.send(fd);
}

function firmwareUploadProgress(evt) {
	if (evt.lengthComputable) {
		var percentComplete = Math.round(evt.loaded * 100 / evt.total);
        	document.getElementById('firmwareProgressBar').value = percentComplete;
		document.getElementById('firmwareProgressNo').innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + percentComplete.toString() + '% uploaded...please wait.';
	} else {
		document.getElementById('firmwareProgressNo').innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unable to compute.';
    	}
}

function configUploadProgress(evt) {
	if (evt.lengthComputable) {
		var percentComplete = Math.round(evt.loaded * 100 / evt.total);
        	document.getElementById('configProgressBar').value = percentComplete;
       		document.getElementById('configProgressNo').innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + percentComplete.toString() + '% uploaded...please wait.';
	} else {
		document.getElementById('configProgressNo').innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unable to compute.';
	}
}

function firmwareUploadComplete(evt) {
	var div = document.getElementById("process");  
	div.style.display = "block";

	/* This event is raised when the server send back a response */
	if (evt.target.readyState == 4 && evt.target.status == 200) {
    		alert(evt.target.responseText);

		var fileName = document.getElementById("firmwareUpload").files[0].name;
		document.getElementById('fileName').value = fileName;

		document.getElementById('firmwareUpload').value = "";
		document.getElementById('firmwareSize').style.display = "none";
		document.getElementById('firmwareProgressBar').style.display = "none";
		document.getElementById('firmwareProgressNo').style.display = "none";
  	} else {
		window.location.replace(evt.target.responseText);
	}
}

function configUploadComplete(evt) {
	var div = document.getElementById("process");  
	div.style.display = "block";

	/* This event is raised when the server send back a response */
	if (evt.target.readyState == 4 && evt.target.status == 200) {
    		alert(evt.target.responseText);

		var fileName = document.getElementById("configUpload").files[0].name;
		document.getElementById('fileName').value = fileName;

		document.getElementById('configUpload').value = "";
		document.getElementById('configSize').style.display = "none";
		document.getElementById('configProgressBar').style.display = "none";
		document.getElementById('configProgressNo').style.display = "none";
  	} else {
		window.location.replace(evt.target.responseText);
	}
}

function uploadFailed(evt) {
	alert("There was an error attempting to upload the file.");
}

function uploadCanceled(evt) {
	alert("The upload has been canceled by the user or the browser dropped the connection.");
}
