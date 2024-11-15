var curpageno=1;
var prev_fil_name="";
var prev_max_rows="";

function pagination(pageno) {
	curpageno = pageno;
	var tot_ma_rows=0;
	var net_dis_rows=0;
	var filter = document.getElementById("Search").value.toUpperCase();
	var max_row_cnt = document.getElementById("dis_row_cnt").value;
	var url = new URL(window.location.href);
	var table = document.getElementById("packages");
	var tr = table.getElementsByTagName("tr");
	var start_row = max_row_cnt*(pageno-1)+1;
	for (i = 0; i < tr.length; i++) {
		td = tr[i].getElementsByTagName("td")[0];
		if (td) {
			txtValue = td.textContent || td.innerText;
			if (txtValue.toUpperCase().indexOf(filter) > -1) {
				tot_ma_rows++;
				if (tot_ma_rows >= start_row && tot_ma_rows <(start_row+parseInt(max_row_cnt))) {
					tr[i].style.display = "";
					net_dis_rows++;
				} else
					tr[i].style.display = "none";
			} else
				tr[i].style.display = "none";
		}
	}
	var pages = parseInt(tot_ma_rows/max_row_cnt);;
	if (tot_ma_rows%max_row_cnt > 0)
		pages ++;		
	var lbl_val = (start_row) +" to "+(start_row+net_dis_rows-1)+" of "+tot_ma_rows;
	setPageRangeLabels(lbl_val,pages);		
}

function setPageRangeLabels(lbl_val,pages) {
	document.getElementById("cnt_dis_lbl").innerHTML = lbl_val;
	var ltlbl = document.getElementById("ltlbl");
	var dltlbl = document.getElementById("dltlbl");
	var gtlbl = document.getElementById("gtlbl");
	var dgtlbl = document.getElementById("dgtlbl");

	if (curpageno == 1) {
		ltlbl.style.background='#FFF';
		dltlbl.style.background='#FFF';
		ltlbl.setAttribute('onclick','pagination('+curpageno+')');
	} else {
		ltlbl.style.background='linear-gradient(to right, #CCCCCC 0%, #2c3e50 100%)';
		dltlbl.style.background='linear-gradient(to right, #CCCCCC 0%, #2c3e50 100%)';
		ltlbl.setAttribute('onclick','pagination('+(curpageno-1)+')');
	}

	if(curpageno == pages) {
		gtlbl.style.background='#FFF';
		dgtlbl.style.background='#FFF';
		gtlbl.setAttribute('onclick','pagination('+curpageno+')');
		dgtlbl.setAttribute('onclick','pagination('+curpageno+')');
	} else {
		gtlbl.style.background='linear-gradient(to right, #CCCCCC 0%, #2c3e50 100%)';
		dgtlbl.style.background='linear-gradient(to right, #CCCCCC 0%, #2c3e50 100%)';
		gtlbl.setAttribute('onclick','pagination('+(curpageno+1)+')');
		dgtlbl.setAttribute('onclick','pagination('+pages+')');
	}	
}

function filterFunction() {
	var  filter = document.getElementById("Search").value.toUpperCase();
	var max_row_cnt = document.getElementById("dis_row_cnt").value;

	if (prev_fil_name != filter || max_row_cnt != prev_max_rows) {
		prev_fil_name = filter;
		prev_max_rows = max_row_cnt;
		curpageno = 1;
	}

	pagination(curpageno);
}
/*
function filterFunction() {
	var input, filter, table, tr, td, i, txtValue;
	input = document.getElementById('Search');
	filter = input.value.toUpperCase();
	table = document.getElementById('packages');
	tr = table.getElementsByTagName('tr');
	for (i = 0; i < tr.length; i++) {
		td = tr[i].getElementsByTagName('td')[0];
		if (td) {
			txtValue = td.textContent || td.innerText;
			if (txtValue.toUpperCase().indexOf(filter) > -1) {
				tr[i].style.display = "";
			} else {
				tr[i].style.display = "none";
			}
		}
	}
}
*/
$(document).ready(function() {
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

	$("#dialog-remove").dialog({
      		resizable: false,
      		height: "auto",
      		width: 700,
      		modal: true,
      		autoOpen: false, 
  		draggable: false,
		closeOnEscape: false,
      		create: function (event, ui) {
            		var pane = $(this).dialog("widget").find(".ui-dialog-buttonpane");
            		$("<label class='autoremove'><input id='autoremove' type='checkbox'/> Automatically remove unused dependencies</label>").prependTo(pane);
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

   	$("input[id^='Remove']").click(function() {
    		var pkgname = $(this).attr("name");
    		var version = $(this).attr("version");
		$("#dialog-remove").dialog({
      			resizable: false,
      			height: "auto",
      			width: 700,
      			modal: true,
      			autoOpen: false, 
  			draggable: false,
			closeOnEscape: false,
      			title: "Remove package "+pkgname+"?",	 
        		open: function () { 
				$(this).text("Version: "+version); 
				$('.ui-dialog-buttonpane').find('button:contains("Remove")').addClass('btn red');
			},
      			buttons: {
        			Cancel: function() {
          				$(this).dialog("close");
        			},
        			Remove: function() {
					var autoremove = $("input[id='autoremove']").is(':checked');
          				$(this).dialog("close");
					opkgRemoveFile(pkgname, autoremove);
        			}
      			}
    		});

		$("#dialog-remove").dialog("open");
	});

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

function opkgSelected() {
	var file = document.getElementById('opkgUpload').files[0];
	if (file) {
		if (file.size > 1024 * 1024 * 30) {
			alert("File size exceeds 30 MB.");
			document.getElementById('opkgUpload').value = "";
		    	return false;
		}
        	var fileSize = 0;
        	if (file.size > 1024 * 1024)
        		fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString() + ' MB';
        	else
          		fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + ' KB';


		$("#dialog-confirm").dialog({
      			resizable: false,
      			height: "auto",
      			width: 700,
      			modal: true,
      			autoOpen: false, 
  			draggable: false,
			closeOnEscape: false,
      			title: "Uploading a file ... ",	 
        		open: function () { 
				var obj = $(this).text("Name : "+file.name+"\nSize : "+fileSize);
				obj.html(obj.html().replace(/\n/g,'<br/>'));
				$('.ui-dialog-buttonpane').find('button:contains("Cancel")').addClass('btn red');
				$('.ui-dialog-buttonpane').find('button:contains("Upload")').addClass('btn blue');
			},
      			buttons: {
        			Cancel: function() {
          				$(this).dialog("close");
        			},
        			Upload: function() {
          				$(this).dialog("close");
					opkgUploadFile();
        			}
      			}
    		});

		$("#dialog-confirm").dialog("open");
	}
}

function opkgUploadFile() {
	var file = document.getElementById('opkgUpload').files[0];
	if (!file) {
		alert("Please select the file and click on Upload !!");
		return false;
	}

	var fd = new FormData();
	fd.append("opkgUpload", document.getElementById('opkgUpload').files[0]);
	var xhr = new XMLHttpRequest();
	xhr.upload.addEventListener("progress", opkgUploadProgress, false);
	xhr.addEventListener("load", opkgUploadComplete, false);
	xhr.addEventListener("error", uploadFailed, false);
	xhr.addEventListener("abort", uploadCanceled, false);
	xhr.open("POST", "Nomus.cgi?cgi=FileUpload.cgi");
	xhr.send(fd);

	$("#dialog-progress").dialog({
      		resizable: false,
      		height: "auto",
      		width: 700,
      		modal: true,
      		autoOpen: false, 
  		draggable: false,
		closeOnEscape: false,
      		title: "Uploading a file ... ",	 
    	});

	$(".progress-label").text( "Starting Upload..." );

	$("#dialog-progress").dialog("open");
}

function opkgUploadProgress(evt) {
	if (evt.lengthComputable) {
		var percentComplete = Math.round(evt.loaded * 100 / evt.total);
		$("#progressbar").progressbar("value", percentComplete);
	} else {
 		$(".progress-label").text( "Unable to compute." );
	}
}

function opkgUploadComplete(evt) {
	/* This event is raised when the server send back a response */
	if (evt.target.readyState == 4 && evt.target.status == 200) {


		var fileName = document.getElementById("opkgUpload").files[0].name;
		document.getElementById('opkgUpload').value = "";

		$("#dialog-confirm").dialog({
      			resizable: false,
      			height: "auto",
      			width: 700,
      			modal: true,
      			autoOpen: false, 
  			draggable: false,
			closeOnEscape: false,
      			title: "Manually install package",	 
        		open: function () { 
				var obj = $(this).text(evt.target.responseText);
				obj.html(obj.html().replace(/\n/g,'<br/>'));
				$('.ui-dialog-buttonpane').find('button:contains("Cancel")').addClass('btn red');
				$('.ui-dialog-buttonpane').find('button:contains("Install")').addClass('btn blue');
			},
      			buttons: {
        			Cancel: function() {
          				$(this).dialog("close");
        			},
        			Install: function() {
          				$(this).dialog("close");
					opkgInstallFile(fileName);
        			}
      			}
    		});
		$("#dialog-progress").dialog("close");
		$("#dialog-confirm").dialog("open");
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

function opkgInstallFile(fileName) {

	$("#dialog-confirm").dialog({
      		resizable: false,
      		height: "auto",
      		width: 700,
      		modal: true,
      		autoOpen: false, 
  		draggable: false,
		closeOnEscape: false,
      		title: "Executing package manager",
		open: function () { 
			var obj = $(this).text("");
			obj.html("<img style='vertical-align:middle' src='/icons/loading.gif' width='25' height='25'><span style='vertical-align:middle'>  Waiting for the opkg install command to complete ...</span>");
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
			
			$("#dialog-confirm").dialog({
		      		resizable: false,
		      		height: "auto",
		      		width: 700,
		      		modal: true,
		      		autoOpen: false, 
		  		draggable: false,
				closeOnEscape: false,
		      		title: "Executing package manager",
				open: function () { 
					var obj = $(this).text(responseText);
					obj.html(obj.html().replace(/\n/g,'<br/>'));
					$('.ui-dialog-buttonpane').find('button:contains("Dismiss")').addClass('btn red');
				},
	      			buttons: {
					Dismiss: function() {
		  				$(this).dialog("close");
						location.reload();
					},
	      			}	 
		    	});

			$("#dialog-confirm").dialog("open");
		};
	};
	xhr.open("POST", "Nomus.cgi?cgi=SoftwareProcess.cgi");
    	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send('Install='+fileName);
}


function opkgRemoveFile(fileName, autoremove) {

	$("#dialog-confirm").dialog({
      		resizable: false,
      		height: "auto",
      		width: 700,
      		modal: true,
      		autoOpen: false, 
  		draggable: false,
		closeOnEscape: false,
      		title: "Executing package manager",
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
			
			$("#dialog-confirm").dialog({
		      		resizable: false,
		      		height: "auto",
		      		width: 700,
		      		modal: true,
		      		autoOpen: false, 
		  		draggable: false,
				closeOnEscape: false,
		      		title: "Executing package manager",
				open: function () { 
					var obj = $(this).text(responseText);
					obj.html(obj.html().replace(/\n/g,'<br/>'));
					$('.ui-dialog-buttonpane').find('button:contains("Dismiss")').addClass('btn red');
				},
	      			buttons: {
					Dismiss: function() {
		  				$(this).dialog("close");
						location.reload();
					},
	      			}	 
		    	});

			$("#dialog-confirm").dialog("open");
		};
	};
	xhr.open("POST", "Nomus.cgi?cgi=SoftwareProcess.cgi");
    	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send('Remove='+fileName+'&autoremove='+autoremove);
}


