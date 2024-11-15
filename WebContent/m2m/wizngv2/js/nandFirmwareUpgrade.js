var dtbFile;
var zImageFile;
var ubifsFile;
var sha256File;
var currentFile;

function firmwareUploadSelectFile(titleHead, extension) {
	$("#dialog-confirm").dialog({
      		resizable: false,
      		height: "auto",
      		width: 700,
      		modal: true,
      		autoOpen: false, 
  		draggable: false,
		closeOnEscape: false,
      		title: titleHead,	 
        	open: function () { 
			var obj = $(this).text("");
			obj.html("<p id=\"showtext\"></p><input type=\"file\" style=\"display:none;\" id=\"firmwareUpload\" accept=\"\" name=\"firmwareUpload\" onchange=\"firmwareSelected()\"/>");
			$('.ui-dialog-buttonpane').find('button:contains("Cancel")').addClass('btn red');
			$('.ui-dialog-buttonpane').find('button:contains("Upload")').addClass('btn blue');
			$("#dialog-Upload").button("option", { disabled: true });
  			$('#firmwareUpload').attr("accept", extension);
		},
      		buttons: [
			{
        			text: 'Browse..',
        			class: 'btn blue',
				open: function() {
                        		$(this).css('margin-right','420px'); 
                  		},
				click: function() {
        				document.getElementById('firmwareUpload').click();
				}
        		},
			{
        			text: 'Cancel',
				click: function() {
        				$(this).dialog("close");
				}
        		},
			{
        			text: 'Upload',
				id: 'dialog-Upload',
				click: function() {
					firmwareUploadFile();
				}
        		}
      		]
    	});

	$("#dialog-confirm").dialog("open");
}

function firmwareSelected() {
	var file = document.getElementById('firmwareUpload').files[0];
	var fileName = file.name;
	var maxSize;

	if (fileName.split('.').pop() == "dtb")
		maxSize = 1;
	else if (fileName.split('.').pop() == "ubi")
		maxSize = 30;
	else if (fileName.split('.').pop() == "sha256")
		maxSize = 1;
	else
		maxSize = 8;

	if (file) {
		if (file.size > 1024 * 1024 * maxSize) {
		    	return false;
		}
        	if (file.size > 1024 * 1024)
        		fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString() + ' MB';
        	else
          		fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + ' KB';

		$("#showtext").html("Name: "+fileName+"<br/>Size: "+fileSize);
		$("#dialog-Upload").button("option", { disabled: false });
		currentFile = fileName;
	}
}

$(document).ready(function() {
	dtbFile=false;
	zImageFile=false;
	ubifsFile=false;
	sha256File=false;
	$("#dialog-confirm").dialog({
      		resizable: false,
      		height: "auto",
      		width: 700,
      		modal: true,
      		autoOpen: false, 
  		draggable: false,
		closeOnEscape: false,
    	});

	$("#dialog-progress").dialog({
      		resizable: false,
      		height: "auto",
      		width: 700,
      		modal: true,
      		autoOpen: false, 
  		draggable: false,
		closeOnEscape: false,
    	});

	$("#dialog-backup").dialog({
      		resizable: false,
      		height: "auto",
      		width: 700,
      		modal: true,
      		autoOpen: false, 
  		draggable: false,
		closeOnEscape: false,
      		create: function (event, ui) {
            		var pane = $(this).dialog("widget").find(".ui-dialog-buttonpane");
            		$("<label class='backup'><input id='backup' type='checkbox' selected/> Keep-Setting to retain current configuration</label>").prependTo(pane);
        	},
      		buttons: {
        		Remove: function() {
          			$(this).dialog("close");
        		},
        		Cancel: function() {
          			$(this).dialog("close");
        		}
      		}
    	});

	$("button.ui-dialog-titlebar-close").css({"display": "none"});

	$("#progressbar").progressbar({
		value: false,
            	change: function() {
 			$(".progress-label").text( $("#progressbar").progressbar("value") + "% uploaded...please wait." );
            	},

            	complete: function() {
            		$(".progress-label").text( "Uploading Completed...please wait." );
        	}
    	});
});

function firmwareUpload() {

	if (!sha256File) {
		firmwareUploadSelectFile("Upload a sha256 file ...", ".sha256")
		return;
	} 
	if (!ubifsFile) {
		firmwareUploadSelectFile("Upload a ubifs file ...", ".ubi")
		return;
	} 
	if (!dtbFile) {
		firmwareUploadSelectFile("Upload a dtb file ...", ".dtb")
		return;
	} 
	if (!zImageFile) {
		firmwareUploadSelectFile("Upload a zImage file ...", "*/zImage")
		return;
	} 

	$("#dialog-backup").dialog({
      		resizable: false,
      		height: "auto",
      		width: 700,
      		modal: true,
      		autoOpen: false, 
  		draggable: false,
		closeOnEscape: false,
      		title: "Firmware Upgradation",	 
        	open: function () { 
			var obj = $(this).text("The System firmware image was uploaded.\nClick on \"Proceed\" to start the flash procedure"); 
			obj.html(obj.html().replace(/\n/g,'<br/>'));
			$('.ui-dialog-buttonpane').find('button:contains("Proceed")').addClass('btn blue');
    			$( "#backup").prop('checked', true);
		},
      		buttons: {
        		Cancel: function() {
        			$(this).dialog("close");
        		},
        		Proceed: function() {
				var backup = $("input[id='backup']").is(':checked');
        			$(this).dialog("close");
				firmwareUpgradeProceed(backup);
        		}
      		}
    	});

	$("#dialog-backup").dialog("open");

}

function firmwareUploadFile() {
	var file = document.getElementById('firmwareUpload').files[0];
	if (!file) {
		alert("Please select the file and click on Upload !!");
		return false;
	}

	var fd = new FormData();
	fd.append("firmwareUpload", document.getElementById('firmwareUpload').files[0]);
	var xhr = new XMLHttpRequest();
	xhr.upload.addEventListener("progress", firmwareUploadProgress, false);
	xhr.addEventListener("load", firmwareUploadComplete, false);
	xhr.addEventListener("error", uploadFailed, false);
	xhr.addEventListener("abort", uploadCanceled, false);
	xhr.open("POST", "Nomus.cgi?cgi=FileUpload.cgi");
	xhr.send(fd);

	var filetitle = $("#dialog-confirm").dialog("option", "title");
	$("#dialog-confirm").dialog("close");

	$("#dialog-progress").dialog({
      		resizable: false,
      		height: "auto",
      		width: 700,
      		modal: true,
      		autoOpen: false, 
  		draggable: false,
		closeOnEscape: false,
      		title: filetitle,
    	});

	$(".progress-label").text( "Starting Upload..." );

	$("#dialog-progress").dialog("open");
}

function firmwareUploadProgress(evt) {
	if (evt.lengthComputable) {
		var percentComplete = Math.round(evt.loaded * 100 / evt.total);
		$("#progressbar").progressbar("value", percentComplete);
	} else {
 		$(".progress-label").text( "Unable to compute." );
	}
}

function firmwareUploadComplete(evt) {
	/* This event is raised when the server send back a response */
	if (evt.target.readyState == 4 && evt.target.status == 200) {

		if (currentFile.split('.').pop() == "dtb")
			dtbFile = currentFile;
		else if (currentFile.split('.').pop() == "ubi")
			ubifsFile = currentFile;
		else if (currentFile.split('.').pop() == "sha256")
			sha256File = currentFile;
		else
			zImageFile = currentFile;
		$("#dialog-progress").dialog("close");
		firmwareUpload();
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

function firmwareUpgradeProceed(backup) {

	$("#dialog-confirm").dialog({
      		resizable: false,
      		height: "auto",
      		width: 700,
      		modal: true,
      		autoOpen: false, 
  		draggable: false,
		closeOnEscape: false,
      		title: "Firmware Upgradation in progress ... ",
		open: function () { 
			var obj = $(this).text("");
			obj.html("<img style='vertical-align:middle' src='/icons/loading.gif' width='25' height='25'><span style='vertical-align:middle'>  Waiting for the opkg remove command to complete ...</span>");
		},
		buttons: {
		}
    	});

	$("#dialog-confirm").dialog("open");

	var xhr = new XMLHttpRequest();
	xhr.onreadystatechange = function() {
 		if (this.readyState == 4 && this.status == 200) {
			var responseText = this.responseText;
			$("#dialog-confirm").dialog("close");	
//			document.documentElement.innerHTML = responseText;	// Not calling body onload & java script functions
                      	$("html").html(responseText);				// Not calling body onload function
		};
	};
	xhr.open("POST", "Nomus.cgi?cgi=FirmwareUpgradeProcess.cgi");
    	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send('dtbFile='+dtbFile+'&zImageFile='+zImageFile+'&ubifsFile='+ubifsFile+'&sha256File='+sha256File+'&backup='+backup);
}



