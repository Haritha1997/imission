function showDivision(divname)
{
	var divname_arr = ["systempage","trapspage"];
        var list = document.getElementById("snmpconfigdiv");
        var childs = list.children;

	for(var i=0;i<divname_arr.length;i++)
	{
		if (divname == divname_arr[i]) {
			document.getElementById(divname_arr[i]).style.display = "inline";
			childs[i].children[0].id = "hilightthis";
		}
		else {
			document.getElementById(divname_arr[i]).style.display = "none";
			childs[i].children[0].id = "";
		}
	}
}

function validateSubnetMask(id,checkempty,name)
{
	var ipele=document.getElementById(id);
	if(ipele.readOnly == true) 
	{ 
		ipele.style.outline="initial"; 
		ipele.title=""; return true; 
	}
	var ipformat=/^(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$/;
	var ipaddr = ipele.value; if(ipaddr=="")
	{
		if(checkempty)
		{
			ipele.style.outline ="thin solid red";
			ipele.title=name+" should not be empty";
			return false;
		}
		else
		{
			ipele.style.outline="initial";
			ipele.title=""; return true;
		}
	}	
	else if(!ipaddr.match(ipformat))
	{
		ipele.style.outline="thin solid red";
		ipele.title="Invalid "+name; return false;
	}
	else
	{
		ipele.style.outline ="initial"; ipele.title = ""; return true;
	}
}
 
function validateIP(id, checkempty, name)
{
	var ipele = document.getElementById(id);
	if(ipele.readOnly == true)
	{
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
	var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
	var ipaddr = ipele.value;
	if (ipaddr == "")
	{
		if (checkempty)
		{
			ipele.style.outline = "thin solid red";
			ipele.title = name + " should not be empty";
			return false;
		}
		else
		{
			ipele.style.outline = "initial";
			ipele.title = ""; 
			return true;
		}
	}
	else if (!ipaddr.match(ipformat) || ipaddr == "255.255.255.255" )
	{
		ipele.style.outline = "thin solid red";
		ipele.title = "Invalid " + name; 
		return false;
	}
	else
	{
		ipele.style.outline = "initial"; ipele.title = ""; 
		return true;
	}
}

function avoidSpace(event)
{
	var k = event ? event.which : window.event.keyCode;
	if (k == 32)
	{
		alert("space is not allowed");
		return false;
	}
}

function validateLengthRange(id, checkempty, minlength, maxlength, name) 
{
	var ipele = document.getElementById(id);
	if (ipele.readOnly == true) 
	{
		ipele.style.outline = "initial";
		ipele.title = "";
		return true;
	}
	var userinput = ipele.value;
	if (userinput == "") 
	{
		if (checkempty) 
		{
			ipele.title = name + " should not be empty";
			return false;
		} 
		else 
		{
			ipele.style.outline = "initial";
			ipele.title = "";
			return true;
		}
	} 
	else if (userinput.length <= maxlength) 
	{
                if (userinput.length > 125) {
			for (var i = 0; i < userinput.length; i++) {
				var ch = userinput.charCodeAt(i);
				if (((ch >= 0) && (ch <= 47)) || ((ch >= 58) && (ch <= 64)) || ((ch >= 91) && (ch <= 96)) || ((ch >= 123) && (ch <= 127))) {
					ipele.title = "! Only 125 special charaters are allowed";
					return false;
				}
			}
		} 

		ipele.style.outline = "initial";
		ipele.title = "";
		return true;		
	} 
	else 
	{
		ipele.style.outline = "thin solid red";
		ipele.title = "Please Enter input in " + name + " between " + minlength + " and " + maxlength + " characters";
		return false;
	}
}

function isEmpty(id,name)
{
	var ele=document.getElementById(id);
	var val=ele.value;
	if(val == "")
	{
		ele.style.outline= "thin solid red";
		ele.title=name+" should not be empty";
		return false;
	}
	else
	{
		ele.style.outline="initial";
		ele.title="";
		return true;
	}
}

function adjtabFirstcolumn(tabname,setname)
{
	var table = document.getElementById(tabname);
	var rows = table.rows;
	var index = 0;
	if(tabname == "managerconf")
		index = 2;
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
	var ele = document.getElementById("mngcnfrow"+rowid);
	$('table#managerconf tr#mngcnfrow'+rowid).remove();
}
function deletetableRow(row)
{
	deleteRow(row);
	findLastRowAndDisplayRemoveIcon();
	adjtabFirstcolumn('managerconf','Manager Configuration');
}

function addIPRowAndChangeIcon(rowid)
{
	var table = document.getElementById("managerconf");
	if(table.rows.length >=7)
	{
		alert("Max 5 rows are allowed");
		return;
	}
	mngcnfrows++;
	var remove=document.getElementById("remove"+rowid);
	var add=document.getElementById("add"+rowid);
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline";
/*
	$("#managerconf").append("<tr id='mngcnfrow"+mngcnfrows+"'><td><div>Manager Configuration</div></td><td><div><input type='text' class='text' id='manager"+mngcnfrows+"' name='manager"+mngcnfrows+"' onkeypress='return avoidSpace(event);' style='display:inline block;' onfocusout=\"validatenameandip('manager"+mngcnfrows+"',true,'Manager Configuration')\"></input><label class='add' id='add"+mngcnfrows+"' style='display:inline block;' onclick='addIPRowAndChangeIcon("+mngcnfrows+")'>+</label><label class='remove' style='display:inline;' id='remove"+mngcnfrows+"' onclick='deletetableRow("+mngcnfrows+")'>x</label><input hidden id='row"+mngcnfrows+"' value='"+mngcnfrows+"'></div></td></tr>");
*/
	$("#managerconf").append("<tr id='mngcnfrow"+mngcnfrows+"'><td><div>Managers</div></td><td><div><input type='text' class='text' id='manager"+mngcnfrows+"' name='manager"+mngcnfrows+"' onkeypress='return avoidSpace(event);' style='display:inline block;' onfocusout=\"validatenameandip('manager"+mngcnfrows+"',true,'Managers ')\"></input><i class='fa fa-plus' id='add"+mngcnfrows+"' style='font-size:10px; margin-left:5px;color:green; display:inline block;' onclick='addIPRowAndChangeIcon("+mngcnfrows+")'></i><i class='fa fa-close' style='font-size:10px; margin-left:5px; color:red;display:inline;' id='remove"+mngcnfrows+"' onclick='deletetableRow("+mngcnfrows+")'></i><input hidden id='row"+mngcnfrows+"' value='"+mngcnfrows+"'></div></td></tr>");
	settrapIpRowCnt();
	adjtabFirstcolumn('managerconf','Managers');
}

function findLastRowAndDisplayRemoveIcon()
{
	var table = document.getElementById("managerconf");
	var lastrow = table.rows[table.rows.length-1];
	
	var addobj = lastrow.cells[1].childNodes[0].childNodes[1];
	
	var removeobj = lastrow.cells[1].childNodes[0].childNodes[2];
	
	addobj.style.display="inline";
	if(table.rows.length > 3)
		removeobj.style.display="inline";
	else if(table.rows.length == 3)
		removeobj.style.display="none";
}

function fillIProw(rowid,trapmanager)
{
	document.getElementById('manager'+rowid).value=trapmanager;
}
function settrapIpRowCnt()
{
	document.getElementById("trapiprows").value = mngcnfrows;
}
