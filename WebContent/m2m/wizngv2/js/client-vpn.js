$(document).ready(function () 
{
    $('#proto').multiselect
    ({
    buttonWidth: '150px',
    numberDisplayed: 2,
    });
});

var filenameid;
var tableid;
var insnameid;
function setSelectedFileName(event,filetfid,tableid) 
{
try{
  var filesobj = event.target;
  var selfilename = $(filesobj).prop("files")[0].name;
  var fileList = event.target.files;
  var tablesobj = $("#"+tableid);
  var tab = tablesobj[0];
  var rowslen = tab.rows.length;
  var curfieslen = rowslen-4;
    for (var i = 0; i < fileList.length; i++)
    {
      //if(isDuplicateExists(tab.rows,fileList[i].name.trim()))
			$('#'+filetfid).val(selfilename);
    }
    }catch(e){alert(e)}
}

function isDuplicateExists(rows,filelblid)
{
try{
	for(var i=4;i<rows.length;i++)
	{
		var afname = rows[i].cells[0].children[0].innerHTML.trim();
		if(afname == filelblid)
    	{
    		alert(afname +" already exists.."); 
		  	return false;
    	}
	    if(rows.length>=7)
		{		
			alert("Maximum 3 files must be selected..");
			return false;
		}
		//return true;
	}
	return true;
	}catch(e){alert(e)}
}

function cancelFileSelection(filetfid) {
  var fileInput = $('#'+filetfid);
  fileInput.val("");
  var fileNameDisplay = $('#'+filetfid);
  fileNameDisplay.val("No file selected");
}

// over all  validation 
function validateClient()
{
try{
    var altmsg="";
    var rmtaddr = document.getElementById("remoteaddress");
    var valid= validatedualIP('remoteaddress',true,'Remote Address',true);
    if(!valid)
    {
        if(rmtaddr.value.trim() == "")
            altmsg += "Remote Address should not be empty\n";
        else
            altmsg += "Remote Address is not valid\n";
    }

    var rmtport = document.getElementById("remoteport");
    valid = validateRange('remoteport',true,'Remote Port');
    if(!valid){
      if(rmtport.value.trim() == "")
            altmsg += "Remote port should not be empty\n";
        else
            altmsg += "Remote port is not valid\n";
    } 
     // TLS Authentication alert and hmac Authentication alert
    var activaidobj = document.getElementById("mainact");
    var tlsauthobj = document.getElementById("tlsactivation");
    var caobj = document.getElementById("catabselfile");
    var certobj = document.getElementById("certtabselfile");
    var keyobj = document.getElementById("keytabselfile");
    var hmacauthobj = document.getElementById("hmacauth");
    var hmacinpobj = document.getElementById("hmactabselfile");
    if(activaidobj.checked == true)
    {
      // if part of tls Authentication
      if(tlsauthobj.checked == true)
      {
        if(caobj.value.trim() == '')
        {
          altmsg += "please select the file Certificate Authority(CA) \n";
          caobj.style.outline = "thin solid red";
        }
        else
          caobj.style.outline = "initial";
        if(certobj.value.trim() == '')
        {
          altmsg += "please select the file Certificate (CERT) \n";
          certobj.style.outline = "thin solid red";
        }
        else
          certobj.style.outline = "initial";
        if(keyobj.value.trim() == '')
        {
          altmsg += "please select the file Key Certificate \n"; 
          keyobj.style.outline = "thin solid red";
        }
        else
          keyobj.style.outline = "initial";
        // hmac Authentication 
        if(hmacauthobj.checked == true)
        {
          if(hmacinpobj.value.trim() == '')
          {
            altmsg += "please select the file HMAC Secret \n";
            hmacinpobj.style.outline = "thin solid red";
          }
          else
            hmacinpobj.style.outline = "initial";
        }
        else
        {
          if(hmacinpobj.value.trim() != '')
          {
            altmsg += "please enable the Additional HMAC Authentication \n";
            hmacinpobj.style.outline = "thin solid red";
          }
          else
            hmacinpobj.style.outline = "initial";
        }   
      }
      // else part of tls Authentication 
      else
      {
        if(caobj.value.trim() != '')
        {
          altmsg += "please enable the TLS Authentication (CA) \n";
          caobj.style.outline = "thin solid red";
        }
        else
          caobj.style.outline = "initial";
        if(certobj.value.trim() != '')
        {
          altmsg += "please enable the TLS Authentication (CERT) \n";
          certobj.style.outline = "thin solid red";
        }
        else
          certobj.style.outline = "initial";
        if(keyobj.value.trim() != '')
        {
          altmsg += "please enable the TLS Authentication (key) \n"; 
          keyobj.style.outline = "thin solid red";
        }
        else
          keyobj.style.outline = "initial";
        if(hmacinpobj.value.trim() != '')
        {
          altmsg += "please enable the TLS Authentication (HMAC) \n";
          hmacinpobj.style.outline = "thin solid red";
        }
        else
          hmacinpobj.style.outline = "initial";
      }
      
      // user name password alert
      var userpassobj = document.getElementById("userpassactivation");
      var usrinpobj = document.getElementById("uptabselfile");
      if(userpassobj.checked == true)
      {
        if(usrinpobj.value.trim() == '')
        {
          altmsg += "please select the file user name password \n";
          usrinpobj.style.outline = "thin solid red";
        }
        else
          usrinpobj.style.outline = "initial";
      }
      else
      {
        if(usrinpobj.value.trim() != '')
        {
          altmsg += "please enable the User Pass Authentication \n";
          usrinpobj.style.outline = "thin solid red";
        }
        else
          usrinpobj.style.outline = "initial"; 
      }
      // alive time alerts
      var alivintmobj = document.getElementById("keepalive");
      var alivtimeobj = document.getElementById("timeout");
      if((alivintmobj.value.trim() == '') && (!alivtimeobj.value.trim() == ''))
      {
        altmsg += "Alive Time Interval should not be empt \n";
        alivintmobj.style.outline = "thin solid red";
      }
      if((alivtimeobj.value.trim() == '') && (!alivintmobj.value.trim() == ''))
      {
        altmsg += "Alive Time Out should not be empty\n";
        alivtimeobj.style.outline = "thin solid red";
      }
    }
    if (altmsg.trim().length == 0) 
        return "";
    else {
        alert(altmsg);
        return false;
    }
    }catch(e){alert(e);}
}

function directionshow()
{
  if($("#hmacauth").is(":checked"))
  {
    $("#dircb").show();
    $("#dirlbl").show();
  }
  else
  {
    $("#dircb").hide();
    $("#dirlbl").hide();
}
}

function compressshow(){
  if($("#compress").is(":checked")){
    $("#algorow").show();
    $("#algorithm").show();
  }
  else
  {
    $("#algorow").hide();
    $("#algorithm").hide();
  }
}

function pskstaticshow()
{
  if($("#staticpsk").is(":checked"))
  {
    $("#pskdir").show();
    $("#pskcb").show();
  }
  else
  {
    $("#pskdir").hide();
    $("#pskcb").hide();
  }
}

function configUploadProgress(evt,progrid) {
	if (evt.lengthComputable) {
		var percentComplete = Math.round(evt.loaded * 100 / evt.total);
        	document.getElementById(progrid).value = percentComplete;
        		//document.getElementById('configProgressNo').innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + percentComplete.toString() + '% uploaded...please wait.';
	 } else {
	 	//document.getElementById('configProgressNo').innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unable to compute.';
	 }
}


function configUploadComplete(evt) {

/*try{
  var tableobj = document.getElementById(tableid);
  var instancename = document.getElementById(insnameid).value;
  alert("file uploaded successfully");
   var slnumber = document.getElementById('slnumber').value;
      var version = document.getElementById('version').value;
      if(insnameid=='name')
      		location.href ="client-vpn.jsp?name="+encodeURIComponent(instancename)+"&slnumber="+slnumber+"&version="+version;
      else
      		location.href ="pointtopoint.jsp?name="+encodeURIComponent(instancename)+"&slnumber="+slnumber+"&version="+version;
	if (evt.target.readyState == 4 && evt.target.status == 200) {
    		alert(evt.target.responseText);
      var fileName = document.getElementById(fileid).files[0].name;
      document.getElementById(filenameid).value = fileName;
      document.getElementById(fileid).value = "";
      document.getElementById(progrid).style.display = "none";
      var slnumber = document.getElementById('slnumber').value;
      var version = document.getElementById('version').value;
      
      window.location.href = "savedetails.jsp?page=clientvpn&slnumber="+slnumber+"&version="+version+"&uploadfile="+tableobj.id+"-"+instancename.value+"";
      } else {
      window.location.replace(evt.target.responseText);
	} 

  }catch(e){alert(e)} */
}

function uploadFailed(evt) {
	alert("There was an error attempting to upload the file.");
}

function uploadCanceled(evt) {
	alert("The upload has been canceled by the user or the browser dropped the connection.");
}

function configUploadFile(fileid,progrid,lfilenameid,ltableid,linsnameid,certpath,dest) {
try
{
  filenameid = lfilenameid;
  tableid = ltableid;
  insnameid = linsnameid;
	var file = document.getElementById(fileid).files[0];
	var selfile=document.getElementById(lfilenameid).value.toLowerCase();
	if (!file) {
		alert("Please select the file and click on Upload !!");
		return false;
	}
	
	else if((fileid=='catabfile'||fileid=='certtabfile')&&!selfile.endsWith(".crt"))
	{
		alert("Please select .crt file and click on Upload !!");
		return false;
	}
	else if((fileid=='keytabfile'||fileid=='hmactabfile' || fileid=='pasktabfile')&&!selfile.endsWith(".key"))
	{
		alert("Please select .key file and click on Upload !!");
		return false;
	}
	else if(fileid=='uptabfile'&&!selfile.endsWith(".auth"))
	{
		alert("Please select .auth file and click on Upload !!");
		return false;
	}
	document.getElementById(progrid).style.display = "";
	//var fd = new FormData();
	let form = document.createElement("form");
	form.setAttribute('method',"post");	
	form.setAttribute('enctype',"multipart/form-data");
	form.setAttribute('action',"/imission/FileUploadController");
	
	form.appendChild(document.getElementById(fileid));
	
	//fd.append(fileid, document.getElementById(fileid).files[0]);
	
	var des = document.createElement("input");
	des.setAttribute('type',"hidden");
	des.setAttribute('name',"destination");
	if(dest=="ca")
		des.setAttribute("value",certpath+"/openvpn");
	else
		des.setAttribute("value",certpath+"/openvpn/"+dest);
	
	form.appendChild(des);	
	
	var redirect = document.createElement("input");
	redirect.setAttribute('type',"hidden");
	redirect.setAttribute('name',"redirectto");
	if(insnameid=='name')
		redirect.setAttribute("value","client-vpn.jsp");
	else
		redirect.setAttribute("value","pointtopoint.jsp");
	form.appendChild(redirect);	
	//var instname = document.getElementById(insnameid).value;
	var slnumber = document.getElementById('slnumber').value;
    var version = document.getElementById('version').value;
	form.appendChild(document.getElementById(insnameid));
	
	var slnumele = document.createElement("input");
	slnumele.setAttribute('type',"hidden");
	slnumele.setAttribute('name',"slnumber");
	slnumele.setAttribute("value",slnumber);
	form.appendChild(slnumele);
	
	var versonele = document.createElement("input");
	versonele.setAttribute('type',"hidden");
	versonele.setAttribute('name',"version");
	versonele.setAttribute("value",version);
	form.appendChild(versonele);
	
	//var xhr = new XMLHttpRequest();
	//xhr.upload.addEventListener("progress", configUploadProgress, false);
	//xhr.addEventListener("load", configUploadComplete, false);
	//xhr.addEventListener("error", uploadFailed, false);
	//xhr.addEventListener("abort", uploadCanceled, false);
	//xhr.open("POST", "/imission/FileUploadController");
	//xhr.send(fd);
	document.getElementsByTagName('body')[0].appendChild(form);
	form.submit();
	}
	catch(e)
	{
	alert(e)
	}
		
}
function saveFile(url, filename) {
alert("in the fun ")
 
}
//show files
function toggleTableRows(tableid)
{
  $("#"+tableid+" tbody tr.hiderow").toggle();
}

function selectfile(filelblid,texfel,selbtnid,selblname){
  try
  {
    var selblele = document.getElementById(selblname);
    var texfelele = document.getElementById(texfel);
    var buttonele = document.getElementById(selbtnid);
    if(buttonele.value == 'select')
    {
        if(texfelele.value.trim() == '')
        {
          selblele.innerHTML = 'selected';
          texfelele.value = document.getElementById(filelblid).innerHTML;
          buttonele.value = 'Deselect';
          buttonele.style.color = '#9370DB';
          buttonele.style.border= '1px solid #7B68EE';

        }
        else{
          alert("please deselect the file "+texfelele.value)
        }
    }
    else 
    {
        selblele.innerHTML = '';
        texfelele.value = '';
        buttonele.value = 'select';
        buttonele.style.color = '#366903';
        buttonele.style.border = '1px solid #c4dfb9';
    }
  }catch(e)
  {
    alert(e);
  }
}

function deselectfile(lblid){
  document.getElementById(lblid).innerHTML = '';
}

function deletefile(lblid,fillabid,selblid,delfile,slnumber,version,pagename,instname,filetype){
  var deleobj = document.getElementById(lblid);
  var selbobj = document.getElementById(selblid).value;
  var filelabele = document.getElementById(fillabid).innerHTML;
  pagename="wizngv2/"+pagename;
  if(selbobj=="Deselect")
    alert("This file "+ filelabele +" is already selected! ");
 else 
     window.location.href = "/imission/FileDeleteController?delpath="+delfile+"&slnumber="+slnumber+"&version="+version+"&page="+pagename+"&name="+instname+"&filetype="+filetype;
}


//add row adding 

function addRow(tableid,opvenid,delfile,slnumber,version,pagename,instname,filetype) 
{
	var table = document.getElementById(tableid);
	var tabrows = table.rows.length;   
  
  var iprows = 1;
  if(tabrows==4)
      document.getElementById(opvenid).value = 1;
  iprows = document.getElementById(opvenid).value;
  document.getElementById(opvenid).value = Number(iprows)+1;
  if(tabrows==7)
  {
    alert("Maximum 3 Entries are allowed");
    return false;
  }
  var row = "<tr class='hiderow'>"+
      "<td colspan=\"2\"><label id=\""+tableid+"filname"+iprows+"\" name=\""+tableid+"filname"+iprows+"\"></label></td>"+
      "<td><input type=\"button\" class=\"selbtn\" id=\""+tableid+"selbtn"+iprows+"\" name=\""+tableid+"selbtn"+iprows+"\" value=\"select\" onclick=\"selectfile('"+tableid+"filname"+iprows+"','"+tableid+"selfile','"+tableid+"selbtn"+iprows+"','"+tableid+"selblid"+iprows+"')\"><label id=\""+tableid+"selblid"+iprows+"\"  name=\""+tableid+"selblid"+iprows+"\" style=\"margin-left: 20px;\"></label></td>"+
      "<td colspan=\"2\"><input type=\"button\" value=\"Delete\" class=\"delete\" onclick=\"deletefile('"+tableid+"selfile"+iprows+"','"+tableid+"filname"+iprows+"','"+tableid+"selbtn"+iprows+"','"+delfile+"','"+slnumber+"','"+version+"','"+pagename+"','"+instname+"','"+filetype+"')\"></td>"+
      "<td hidden>0</td>"+
      "<td hidden>"+iprows+"</td>"+
      "</tr>";
  $('#'+tableid).append(row); 
    var height = table.rows[1].cells[0].offsetHeight;
    window.scrollBy(0,height);
}

function fillrow(tabid,filename)
{
  var curindex = document.getElementById(tabid+"opvpconf").value-1;
	document.getElementById(tabid+"filname"+curindex).innerHTML=filename;
}


/*function setStatus(tableid)
{
  var table = document.getElementById(tableid);
  var rows = table.rows;
  var filinobj = document.getElementById(tableid+"selfile");
  for(var i= 4;i<rows.length;i++)
  {
    var filname = rows[i].cells[0].children[0].innerHTML.trim();
    if(filinobj.value.trim() == filname)
    {
      rows[i].cells[1].children[0].value = 'Deselect';
      rows[i].cells[1].children[1].innerHTML = 'selected';
      break;
    }
  }
}*/
function tlsact()
{
  if($("#tlsactivation").is(":checked"))
  {
    $('#addhmacauth').show();
    $("#hmacact").show();
  }
  else
  {
    $('#addhmacauth').hide();
    $("#hmacact").hide();
    $('#hmacauth').prop('checked', false);
  }
}


function setStatus(tableid)
{
  var table = document.getElementById(tableid);
  var rows = table.rows;
  var filinobj = document.getElementById(tableid+"selfile");
  for(var i= 4;i<rows.length;i++)
  {
    var filname = rows[i].cells[0].children[0].innerHTML.trim();
    if(filinobj.value.trim() == filname)
    {
      rows[i].cells[1].children[0].value = 'Deselect';
      rows[i].cells[1].children[1].innerHTML = 'selected';
      break;
    }
  }
}

// point to point validation here
var netlistrow=0;
function addpeerRoutRow(rowid){
	var table = document.getElementById("pointtable");
	if(table.rows.length >=36)
	{
		alert("Max 25 rows are allowed");
		return;
	}
	netlistrow++;
	var remove=document.getElementById("removenetrklist"+rowid);
	var add=document.getElementById("addnetrklist"+rowid);
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline";
	$("#pointtable").append("<tr id=\"netlistr"+netlistrow+"\"><td>Peer Network</td><td><input type=\"text\" class=\"text\" id=\"network"+netlistrow+"\" name=\"network"+netlistrow+"\" placeholder=\"192.168.1.0\" onkeypress=\"return avoidSpace(event)\" onfocusout=\"validateIP('network"+netlistrow+"',true,'Network')\"></td><td><input type=\"text\" class=\"text\" id=\"subnetmask"+netlistrow+"\" name=\"subnetmask"+netlistrow+"\" placeholder=\"255.255.255.0\" onkeypress=\"return avoidSpace(event)\" onfocusout=\"validateSubnetMask('subnetmask"+netlistrow+"',true,'Subnet Mask')\"><label class=\"add\" id=\"addnetrklist"+netlistrow+"\" style=\"font-size: 17px; margin-left:7px;color:green;display: inline;\" onclick=\"addpeerRoutRow("+netlistrow+")\">+</label><label class=\"remove\" style=\"display: inline; font-size: 15px;margin-left:5px; color:red;\" id=\"removenetrklist"+netlistrow+"\" onclick=\"deleteNetrkListTableRow("+netlistrow+")\">x</label><input id=\"row"+netlistrow+"\" value=\""+netlistrow+"\" hidden=\"\"></td><td></td></tr>");
	document.getElementById("addpointtopoint").value = netlistrow;
	adjtabFircol('pointtable');
}

function deleteNetrkListTableRow(row)
{
	
	deleteNetrkListRow(row);
	findNetListLastRowAndDisplayRemoveIcon();
	adjtabFircol('pointtable');
	
}
function deleteNetrkListRow(rowid)
{
	var ele = document.getElementById("netlistr"+rowid);
	$('table#pointtable tr#netlistr'+rowid).remove();
  adjtabFircol('pointtable');
	
}

function findNetListLastRowAndDisplayRemoveIcon()
{
	var table = document.getElementById("pointtable");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[2].childNodes[1];
	var removeobj = lastrow.cells[2].childNodes[2];
	addobj.style.display="inline";
	if(table.rows.length >14) 
		removeobj.style.display="inline";
		
	else if(table.rows.length ==14)
		removeobj.style.display="none";
}
function adjtabFircol(tabname)
{
	var table = document.getElementById(tabname);
	var rows = table.rows;
  var lastrow = table.rows[table.rows.length-1];
	var removeobj = lastrow.cells[2].childNodes[2];
		
	if(table.rows.length <=14)
		removeobj.style.display="none";
	
	var index = 0;
	if(tabname == "pointtable")
		index = 1;
	if(rows.length == (index+1))
	{
		rows[index].cells[2].childNodes[1].style.display="inline";
		rows[index].cells[2].childNodes[2].style.display="none";
	}
	
} 
function fillpeerRoutRow(rowid,networkip,subnetmaskip)
{
	document.getElementById("network"+rowid).value=networkip;
	document.getElementById("subnetmask"+rowid).value=subnetmaskip;
}
function remoteandlocal(){
  var droprelo = document.getElementById("remotelocal");
  var remoobj = document.getElementById("remoterow");
  var lopotobj = document.getElementById("localrow");
  if(droprelo.value.trim() == "Remote")
  {
    remoobj.style.display = "";
    lopotobj.style.display = "none";
  }
  else 
  {
    remoobj.style.display = "none";
    lopotobj.style.display = "";
  }
}