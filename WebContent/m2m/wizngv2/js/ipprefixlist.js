function addRow(tablename,slnumber,version) 
{ 

	var table = document.getElementById(tablename); 
	var iprows = table.rows.length;
	//var newssid=document.getElementById("ssid");
	//var newinstval="";
	if (tablename == "prefixlisttab") 
	{ 
     //if(newinstval == "")
		//{ 
			//newssid.style.outline ="thin solid red";
			//return false;
		//}
	  
		if (iprows == 11) 
		{ 
			alert("Maximum 10 rows are allowed in Prefixlist"); 
			return false; 
		} 
		if (iprows == 1) 
		document.getElementById("prefixlistcnt").value = iprows; 
		iprows = document.getElementById("prefixlistcnt").value; 
		document.getElementById("prefixlistcnt").value = Number(iprows)+1;
		var row = "<tr align=\"center\" id='prefixlistrows"+iprows+"' >"+
		"<td>"+iprows+"</td>"+
		"<td><input type=\"text\" readonly class=\"text\" id=\"prefixname"+iprows+"\" name=\"prefixname"+iprows+"\" maxlength=\"32\" value=\"\"/> </td>"+
		"<td><input type=\"text\" readonly class=\"text\" id=\"records"+iprows+"\" name=\"records\" maxlength=\"32\" value=\"\"/> </td>"+
		"<td><label class=\"switch\"><input type=\"checkbox\" id=\"activation"+iprows+"\" name=\"activation"+iprows+"\" checked><span class=\"slider round\"></span></input></label></td>"+
		"<td><button type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"editPrefixList("+iprows+",'"+version+"')\">Edit <i class='fas fa-edit' style='font-size:12px;color:white'></i></button>"+
		"<image id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"30\" height=\"22\" align=\"right\" title=\"Delete\" onclick=\"deleteprefixlistpage('prefixname"+iprows+"','"+slnumber+"','"+version+"');\"></image></td>"+
		
		"<td hidden>0</td>"+
		"<td hidden><input hidden id=\"prefixlist_val"+iprows+"\"/></td>"
		"</tr>"; 
		$('#prefixlisttab').append(row); 
		reindexTable('prefixlisttab');		
	} 
	var height = table.rows[1].cells[0].offsetHeight;
	window.scrollBy(0,height);
}
function reindexTable(tablename)
{ 
	var table = document.getElementById(tablename); 
	var rowCount = table.rows.length;
	for (var i = 1; i < rowCount; i++) 
	{ 
		var row = table.rows[i]; 
		row.cells[0].innerHTML = i; 
	} 
}
function addNewPrefixList(id,addinstance,slnumber,version)
{
	var prelistdiv = document.getElementById("prefixlistdiv");
	var addprelistdiv = document.getElementById("add_prefixlist");
	var newInsname = document.getElementById("nwinstname");
	var newinstval="";
	if (addinstance)
	{
	if(duplicateInstanceNamesExists("nwinstname","prefixlisttab"))
		{
			return ;
		}
		newinstval=newInsname.value;
		if (newinstval == "")
		{ 
			alert("New Instance Name should not be empty");
			newInsname.style.outline ="thin solid red";
			return false;
		}
	}	
		var prefname = document.getElementById(id).value;
		//window.location = "edit_prefixlist.html?action=new&name="+prefname;
		location.href = "edit_ipprefixlist.jsp?prefixname="+encodeURIComponent(prefname)+"&slnumber="+slnumber+"&version="+version;
}
function editPrefixList(index,version)
{
	var prefname = document.getElementById("prefixname"+index).value;
	var slnumber = document.getElementById("slno").value;
	location.href ="edit_ipprefixlist.jsp?prefixname="+encodeURIComponent(prefname)+"&slnumber="+slnumber+"&version="+version;
	//window.location = "edit_prefixlist.html?action=edit&name="+prefname;
}


function deleteRows(rowid,tablename)
{
	 document.getElementById(rowid).remove();
}
function fillPrefixList(rowid,name,record,stats)
{
	document.getElementById("prefixname"+rowid).value=name;
	document.getElementById("records"+rowid).value=record;
	document.getElementById("activation"+rowid).checked = stats;
	//document.getElementById("prefixlist_val"+rowid).value = name+" ,"+record+" ,"+stats;
	//var rowdata = document.getElementById("prefixlist_val"+rowid);	
	//rowdata.value=name+", "+stat+", "+summ+", "+asset;//document.getElementById("bgprow_val"+rowid).value=name+", "+desc+", "+passw+", "+kpalitimer+", "+holdtimer+", "+upsrc+", "+deforg+", "+passive+", "+ttlcheck+", "+ttlhops+", "+nexthop+", "+refclient+", "+serclient;
}
function addNetListRow(rowid){
	var table = document.getElementById("add_prefixlisttab");
	if(table.rows.length >=28)
	{
		alert("Max 25 rows are allowed");
		return;
	}
		netlistrow++;
		recordscnt++;
	var remove=document.getElementById("removenetrklist"+rowid);
	var add=document.getElementById("addnetrklist"+rowid);
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline";

	$("#add_prefixlisttab").append("<tr id=\"netlistr"+netlistrow+"\"><td width=\"150px\"><div>Network List</div></td><td><div><input type=\"text\" class=\"text\" id=\"network"+netlistrow+"\" name=\"network"+netlistrow+"\" onkeypress=\"return avoidSpace(event);\" placeholder=\"Network Ip\" onfocusout=\"validateCIDRNotation('network"+netlistrow+"',true,'Network')\" /><input type=\"number\" style=\"min-width:100px;max-width:100px;margin-left:10px;margin-right:10px\"  class=\"text\" id=\"start_range"+netlistrow+"\" name=\"start_range"+netlistrow+"\" min=\"0\" max=\"32\" value=\"\" placeholder=\"Start Range\" onkeypress=\"return avoidSpace(event)\"/><input type=\"number\" style=\"min-width:100px;max-width:100px;margin-right:10px\"  class=\"text\" id=\"end_range"+netlistrow+"\" name=\"end_range"+netlistrow+"\" min=\"0\" max=\"32\" value=\"\" placeholder=\"End Range\" onkeypress=\"return avoidSpace(event)\"/><select style=\"min-width:100px;max-width:100px;\" name=\"preaccess"+netlistrow+"\"  class=\"text\" id=\"preaccess"+netlistrow+"\"><option value=\"permit\">Permit</option><option value=\"deny\">Deny</option></select><label class=\"add\" id=\"addnetrklist"+netlistrow+"\" style=\"font-size: 17px; margin-left:7px;color:green;display: inline;\" onclick=\"addNetListRow("+netlistrow+")\">+</label><label class=\"remove\" style=\"display: inline; font-size: 15px;margin-left:5px; color:red;\" id=\"removenetrklist"+netlistrow+"\" onclick=\"deleteNetrkListTableRow("+netlistrow+")\">x</label><input id=\"row"+netlistrow+"\" value=\""+netlistrow+"\" hidden=\"\"></div></td></tr>");
	document.getElementById("add_prefixlist_rwcnt").value = netlistrow;
	document.getElementById("records").value = recordscnt;
	adjtabFircol('add_prefixlisttab','Network List');
}
function deleteNetrkListRow(rowid)
{
	var ele = document.getElementById("netlistr"+rowid);
	$('table#add_prefixlisttab tr#netlistr'+rowid).remove();
	document.getElementById("records").value = recordscnt-1;
	adjtabFircol('add_prefixlisttab','Network List');
	
}
function deleteNetrkListTableRow(row)
{
	
	deleteNetrkListRow(row);
	findNetListLastRowAndDisplayRemoveIcon();
	adjtabFircol('add_prefixlisttab','Network List');
	
}
function findNetListLastRowAndDisplayRemoveIcon()
{
	var table = document.getElementById("add_prefixlisttab");
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[1].childNodes[0].childNodes[4];
	var removeobj = lastrow.cells[1].childNodes[0].childNodes[5];
	addobj.style.display="inline";
	if(table.rows.length > 28) 
		removeobj.style.display="inline";
		
	else if(table.rows.length == 28)
		removeobj.style.display="none";
}
function adjtabFircol(tabname,setname)
{
	var table = document.getElementById(tabname);
	var rows = table.rows;
	
	var index = 0;
	if(tabname == "add_prefixlisttab")
		index = 3;
	
	
	for(var i=index;i<rows.length;i++)
	{
			rows[i].cells[0].innerHTML = setname;//modified this line
	}
	if(rows.length == (index+1))
	{
		rows[index].cells[1].childNodes[0].childNodes[4].style.display="inline";
		rows[index].cells[1].childNodes[0].childNodes[5].style.display="none";
	}
	
}
function validateCIDRNotation(id, checkempty, name)
{
	var ipele = document.getElementById(id);
	var value = ipele.value;
	if (value == "") 
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
			ipele.title = ""; return true;
		}
	}

	if(value.includes("/"))
	{
		var ipsplitarr = value.split("\/");
		if(ipsplitarr.length != 2)
		{
			ipele.style.outline = "thin solid red";
			ipele.title = "Invalid CIDR format" + name; 			
			return false;
		}
		var proceed = validateIPByValue(ipsplitarr[0],checkempty);
		var valid = false;
		if(proceed)
		{
			var network = ipsplitarr[1];
			if(network >= 0 && network<=32)
				valid = true;
		}
		if(valid)
		{
			ipele.style.outline = "initial"; 
			ipele.title = ""; 
			return true;
		}
		else
		{
			ipele.style.outline = "thin solid red";
			ipele.title = "Invalid " + name; 			
			return false;
		}
	}
	else
	{
		ipele.style.outline = "thin solid red";
		ipele.title = "Invalid CIDR format" + name; 			
		return false;
	}
}
function getSuffix(value)
{
	var network;
	if(value.includes("/"))
	{
		var ipsplitarr = value.split("\/");
		network = parseInt(ipsplitarr[1]);
	}
	return network;
}
function duplicateInstanceNamesExists(id,tablename)
{
	//alert("in the duplicateInstanceNamesExists nwinstname " + id +" "+tablename);
	var dupexists=false;
    var table = document.getElementById(tablename);
	var rowcnt = table.rows.length;
	var obj=document.getElementById(id);
	var name=obj.value;
	if(name == "")
	{
		obj.style.outline ="thin solid red";
		if(tablename == "prefixlisttab")				
		obj.title="New Instance Name  should not be empty";
	}
	else
	{
		obj.title="";
	}
	if(tablename == "prefixlisttab")
	{
		var displaystr = "New Instance Name";
		var bgppeertab=document.getElementById("prefixlisttab");
		var rowsize=bgppeertab.rows.length;
		for(var i=1;i<rowsize;i++)
		{
			var insname=bgppeertab.rows[i].cells[1].children[0].value;
			if(insname == name && insname != "")
			{
				alert(name+" already exists");
				dupexists= true;
				document.getElementById(id).style.outline="thin solid red";
				break;
			}
		}
	}
	return dupexists;
}
function fillNetListRow(rowid,networkip,srange,erange,access)
{
	document.getElementById("network"+rowid).value=networkip;
	document.getElementById("start_range"+rowid).value=srange;
	document.getElementById("end_range"+rowid).value=erange;
	document.getElementById("preaccess"+rowid).value=access;
	//document.getElementById("prefixlist_val"+rowid).value = name+" ,"+record+" ,"+stats;
}
function deleteprefixlistpage(id,slnumber,version)
{
 var prename=document.getElementById(id).value;
location.href = "savedetails.jsp?slnumber="+slnumber+"&page=ipprefixlist&prefixname="+encodeURIComponent(prename)+"&version="+version+"&action=delete";
}
/*function deletePrefixListRow(el,id)
{
	//alert("in the deletePeerRecordrow"+id);
    var prefixname=document.getElementById(id).value;
   	while (el.parentNode && el.tagName.toLowerCase() != 'tr') 
	{
        el = el.parentNode;
    	}
    	if (el.parentNode && el.parentNode.rows.length > 1) 
	{
        el.parentNode.removeChild(el);
    }
	reindexTable('prefixlisttab');
	location.href = "Nomus.cgi?cgi=DeletePrefixListRow="+prefixname+".cgi";
}*/