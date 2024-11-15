
function avoidSpace(event)
{
	var k = event ? event.which : window.event.keyCode;
	if (k == 32)
	{
		alert("space is not allowed");
		return false;
	}
}

function adjtabFirstcolumn(tabname,setname)
{
	var table = document.getElementById(tabname);
	var rows = table.rows;
	var index = 0;
	if(tabname == "WiZConf")
		index = 4;
	for(var i=index;i<rows.length;i++)
	{
		if(i==index)
		{
			rows[i].cells[0].childNodes[0].innerHTML = setname;
   		}
		else
		{
			rows[i].cells[0].childNodes[0].innerHTML = "";
		}
	}
}

function deleteRow(rowid)
{
	var ele = document.getElementById("ntprow"+rowid);
	$('table#WiZConf tr#ntprow'+rowid).remove();

}

function deletetableRow(row)
{
	deleteRow(row);
	findLastRowAndDisplayRemoveIcon();
	adjtabFirstcolumn('WiZConf','NTP Servers');
}

function addIPRowAndChangeIcon(rowid)
{
	var table = document.getElementById("WiZConf");
	if(table.rows.length >=9)
	{
		alert("Max 5 rows are allowed");
		return;
	}
	ntprows++;
	var remove=document.getElementById("remove"+rowid);
	var add=document.getElementById("add"+rowid);
	if(add != null)
		add.style.display="none";
	if(remove != null)
		remove.style.display ="inline";
/*
	$("#WiZConf").append("<tr id='ntprow"+ntprows+"'><td><div>NTP Servers</div></td><td><div><input type='text' class='text' id='servers"+ntprows+"' name='servers"+ntprows+"' onkeypress='return avoidSpace(event);' style='display:inline block;' onfocusout=\"validatenameandip('servers"+ntprows+"',true,'NTP Servers')\"></input><label class='add' id='add"+ntprows+"' style='display:inline block;' onclick='addIPRowAndChangeIcon("+ntprows+")'>+</label><label class='remove' style='display:inline;' id='remove"+ntprows+"' onclick='deletetableRow("+ntprows+")'>x</label><input hidden id='row"+ntprows+"' value='"+ntprows+"'></div></td></tr>");
*/
	$("#WiZConf").append("<tr id='ntprow"+ntprows+"'><td><div>NTP Servers</div></td><td><div><input type='text' class='text' id='servers"+ntprows+"' name='servers"+ntprows+"' onkeypress='return avoidSpace(event);' style='display:inline block;' onfocusout=\"validatenameandip('servers"+ntprows+"',true,'NTP Servers')\"></input><i class='fa fa-plus' id='add"+ntprows+"' style='font-size:10px; margin-left:5px;color:green;display:inline block;' onclick='addIPRowAndChangeIcon("+ntprows+")'></i><i class='fa fa-close' style='font-size:10px; margin-left:5px; color:red;display:inline;' id='remove"+ntprows+"' onclick='deletetableRow("+ntprows+")'></i><input hidden id='row"+ntprows+"' value='"+ntprows+"'></div></td></tr>");
	setNtpServerRowCnt();
	adjtabFirstcolumn('WiZConf','NTP Servers');
}

function findLastRowAndDisplayRemoveIcon()
{
	var table = document.getElementById("WiZConf");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[1].childNodes[0].childNodes[1];
	var removeobj = lastrow.cells[1].childNodes[0].childNodes[2];
		addobj.style.display="inline";
	if(table.rows.length > 5)
		removeobj.style.display="inline";
	else if(table.rows.length == 5)
		removeobj.style.display="none";
}

function fillIProw(rowid,ntpservers)
{
	document.getElementById('servers'+rowid).value=ntpservers;
}
function setNtpServerRowCnt()
{
	document.getElementById("ntprows").value = ntprows;
}