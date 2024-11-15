function addRow(tablename,slnumber,version)
{
	var table = document.getElementById(tablename);
	var iprows = table.rows.length;
	if(tablename == "zerotiertb")
	{
		if(iprows == 11)
		{
			alert("Maximum 10 rows are allowed")
			return false
		}
		if(iprows == 1)
			document.getElementById("zerotierconf").value = iprows;
		iprows = document.getElementById("zerotierconf").value;
		document.getElementById("zerotierconf").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id=\"zerotiertr"+iprows+"\">"+
		"<td style=\"text-align: center; vertical-align: middle;\">"+iprows+"</td>"+
		"<td><input type=\"text\" style=\"min-width:120px;max-width:120px;\" class=\"text\" id=\"name"+iprows+"\" name=\"name"+iprows+"\" maxlength=\"34\" onkeypress=\"return avoidSpace(event) && avoidEnter(event)\" onmouseover=\"setTitle(this)\"></td>"+
		"<td><input type=\"text\" style=\"min-width:120px;max-width:120px;\" class=\"text\" id=\"networkid"+iprows+"\" name=\"networkid"+iprows+"\" onkeypress=\"return avoidSpace(event) && avoidEnter(event)\" maxlength=\"16\" onmouseover=\"setTitle(this)\"></td>"+
		"<td><label class=\"switch\"><input type=\"checkbox\" id=\"activation"+iprows+"\" name=\"activation"+iprows+"\"  checked onclick=\"actilink('activation"+iprows+"')\"><span class=\"slider round\"></span></input></label></td>"+
		"<td><input type=\"checkbox\" style=\"margin: 10px;\" name=\"natclients"+iprows+"\"  id=\"natclients"+iprows+"\" checked></label></label>"+
		/*"<td><input type=\"text\" style=\"min-width:120px;max-width:120px;\" class=\"text\" id=\"ipaddr"+iprows+"\" name=\"ipaddr"+iprows+"\" readonly></td>"+*/
		"<td><image style=\"cursor:pointer\" id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"20\" height=\"22\" align=\"center\" title=\"Delete\" onclick=\"deleteZeroTierpage('zerotiertr"+iprows+"','"+slnumber+"','"+version+"');\"></image></td>"+
		"<td hidden>0</td>"+
		"<td hidden>"+iprows+"</td>"+
		"</tr>";
		$('#zerotiertb').append(row);
	}
	else
	{
		alert("no add row");
	}
	reindexTable();
	var height = table.rows[1].cells[0].offsetHeight;
	window.scrollBy(0,0);
}

function reindexTable()
{ 
	var table = document.getElementById('zerotiertb'); 
	var rowCount = table.rows.length;
	for (var i = 1; i < rowCount; i++) 
	{ 
		var row = table.rows[i]; 
		row.cells[0].innerHTML = i; 
	} 
}

function fillrow(rowid, name, networkid, activation, natclients){
	document.getElementById("name"+rowid).value = name;
	document.getElementById('networkid'+rowid).value = networkid;
	document.getElementById("activation"+rowid).checked = activation;
	document.getElementById("natclients"+rowid).checked = natclients;
	/*document.getElementById('ipaddr'+rowid).value = ipaddr;*/
}

function deleteRow(rowid) 
{
	document.getElementById(rowid).remove();
	reindexTable();
}
function deleteZeroTierpage(id,slnumber,version)
{
	document.getElementById(id).remove();
	reindexTable();
	/*var name = document.getElementById(id).value;
	 var table = document.getElementById("zerotiertb"); 
	 location.href = "savedetails.jsp?slnumber="+slnumber+"&page=ZeroTier&name="+encodeURIComponent(name)+"&action=delete"+"&zerotierconf="+rowcnt;*/
}
/*function deleteZeroTierpage(el)
{

	while (el.parentNode && el.tagName.toLowerCase() != 'tr') 
	{
		el = el.parentNode;
	}
	if (el.parentNode && el.parentNode.rows.length > 1) 
	{
		el.parentNode.removeChild(el);
	}
	reindexTable();
}*/