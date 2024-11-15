var curdiv="";
var curlist="";
var old_ipvals="";
var old_portvals="";
var old_trckval="";
var altmsg ="";
var perdiv = "";
function showDivision(divname,sellist)
{
	try{
        curdiv=divname;
	    curlist=sellist;
        if(sellist == "confglist")
            var divname_arr = ["globalconf","interfaces_config","members_config","policies_config","rulesconf","interfacetable","rulesdiv"];
        var list = document.getElementsByClassName(sellist);
        for(var i=0;i<divname_arr.length;i++)
        {
            if(divname == divname_arr[i])
		    {
                document.getElementById(divname_arr[i]).style.display = "";
                if(sellist == "confglist")
                {
                    document.getElementById('loadivconfpage').value = divname;
                }
               if(divname == "interfacetable")
				    list[1].id="hilightthis";
                if(divname == "rulesdiv")
                  list[4].id="hilightthis";
                if(i<5)
				    list[i].id="hilightthis";
            }
            else
            {		
                document.getElementById(divname_arr[i]).style.display = "none";
                if(i<5)
			    list[i].id="";
            }
        }
        if(curdiv!="rulesdiv" && perdiv=="rulesdiv")
        		document.getElementById("rulname").value = "";
    }
    catch(e){
        alert(e);
    }
}

function checkDuplicatesAndloadbalpage(instid,addinstance,tablename,tableid,slnumber,version)
{
   
    var newinstid=document.getElementById(instid);
    var newinstval="";
    newinstval=newinstid.value;
    if(addinstance)
	{
		if(duplicateInstanceNamesExists(instid,tablename,tableid))
			return false;
        if(tablename == "Members" && duplicateInstanceNamesExists(instid,'Members','Interfaces'))
            return false;
        if(tablename == "Members" && duplicateInstanceNamesExists(instid,'Members','Policies'))
            return false;
        if(tablename == "Members" && duplicateInstanceNamesExists(instid,'Members','Rules'))
            return false;

        if(tablename == "Policies" && duplicateInstanceNamesExists(instid,'Policies','Interfaces'))
            return false;
        if(tablename == "Policies" && duplicateInstanceNamesExists(instid,'Policies','Members'))
            return false;
        if(tablename == "Policies" && duplicateInstanceNamesExists(instid,'Policies','Rules'))
            return false;

        if(tablename == "Rules" && duplicateInstanceNamesExists(instid,'Rules','Interfaces'))
            return false;
        else if(tablename == "Rules" && duplicateInstanceNamesExists(instid,'Rules','Policies'))
            return false;
        else if(tablename == "Rules" && duplicateInstanceNamesExists(instid,'Rules','Members'))
            return false;
		if (newinstval == "" && addinstance)
		{ 
			alert("New Instance Name should not be empty");
			newinstid.style.outline ="thin solid red";
			return false;
		}
	}
    if(tablename == "Rules")
        addAndEditCode('Rules','add',0,'ruleid','rulesdiv',slnumber,version);
   	if(tablename == "Policies")
        addAndEditCode('Policies','poliadd',0,'policeid','policies_config',slnumber,version);
    if(tablename == "Members")
        addAndEditCode('Members','menbadd',0,'memebeid','members_config',slnumber,version);
}
function clearOldData(inputid,tabid)
{
	//to delete all rows except first row and clear all data in first row of trackip table.(dont change this code) //guru
	document.getElementById(inputid).value = "";
	var tabele = document.getElementById(tabid);
	var rows = tabele.rows;
	for(var i = rows.length-1;i>=0;i--)
		rows[i].cells[1].children[0].children[2].click();  // click on X symbol to remove the row
	if(tabid=="trackiptab")
	{
		intfpulsbtn = 0;
		addRulesRow(intfpulsbtn,"trackiptab");
	}
	else
	{
		rudesaddbtn=0;
		addRulesRow(rudesaddbtn,"destaddrtab");
	}
}
function addAndEditCode(tablename,action,index,instaname,divid,slnumber,version)
{
	try
	{
    var table = document.getElementById(tablename); 
    var tablerows = table.rows;
    if(tablename == "Interfaces")
    {
    	clearOldData('intname','trackiptab');  //intname is the input field in edit interface div
        var tablid = document.getElementById("interfaces_config"); 
        var divtab = document.getElementById("interfacetable");
        divtab.style.display = "";
        tablid.style.display = "none";
            if(action == 'edit')
            {
                var vals = document.getElementById("intconfig_val"+index).value.split(', ');
                document.getElementById("intname").value=vals[0];
                if(vals[1].includes(" "))
                {
                    var trackipvals=vals[1].split(" ");
                    for(var i=0;i<trackipvals.length;i++)
                    {
                    	if(i>0)
                        	addRulesRow(i,"trackiptab");
                        document.getElementById("trackip"+(i+1)).value=trackipvals[i];
                    }
                }
                else
                    document.getElementById("trackip1").value=vals[1];

                
                // document.getElementById("trackip1").value= vals[1];
                document.getElementById("trackreblity").value=vals[2];
                document.getElementById("intract").checked=vals[3];
                document.getElementById("pingcunt").value=vals[4];
                document.getElementById("pingtiout").value=vals[5];
                document.getElementById("pingintvl").value=vals[6];
                document.getElementById("intrfdwn").value=vals[7];
                document.getElementById("intrfup").value=vals[8];
                document.getElementById("family").value=vals[9];
              }
        var rowinstname = document.getElementById(instaname).value;
        // location.href = "Interface_Config_Page?editinstancename="+rowinstname;
          
    }
    if(tablename == "Rules")
    {
        var tablid = document.getElementById("rulesconf"); 
        var divtab = document.getElementById("rulesdiv");
        divtab.style.display = "";
        tablid.style.display = "none";
        if(action == 'add')
        {
         clearOldData('rulname','destaddrtab');
            document.getElementById("rulname").value=document.getElementById(instaname).value;
            var protoval=document.getElementById("protocol").value="all";
            document.getElementById("destaddr1").value="";
            document.getElementById("dport").value="";
            var addtckyval = document.getElementById("sticky").value="No";
            var addstckytime= document.getElementById("stickrow");
             document.getElementById("poliassign").value="";
            var depotobj = document.getElementById("dport_row");
            if(protoval=="all")
            	depotobj.style.display="none";
            if(addtckyval=="Yes")
            {
                addstckytime.style.display="";
                document.getElementById("stimeout").value="600";
            }
            else
            {
                addstckytime.style.display="none";
                document.getElementById("stimeout").value="";
             }
            var instname = document.getElementById(instaname).value;
        }
         //rulname is the input field in edit rules div
            if(action == 'edit')
            {
             clearOldData('rulname','destaddrtab');
                var vals = document.getElementById("rulesrow_val"+index).value.split(', ');
                document.getElementById("rulname").value=vals[0];
                document.getElementById("poliassign").value=vals[1];
                document.getElementById("protocol").value=vals[2];
                if(vals[2]=="tcp"||vals[2]=="udp")
                {
               		document.getElementById("dport_row").style.display="";
                	document.getElementById("dport").value=vals[6];
                }
                else
                	document.getElementById("dport_row").style.display="none";
                if(vals[3].includes(" "))
                {
                    var ipvals=vals[3].split(" ");
                    for(var i=0;i<ipvals.length;i++)
                    {
                    	if(i>0)
                        	addRulesRow(i,"destaddrtab");
                        document.getElementById("destaddr"+(i+1)).value=ipvals[i];
                    }
                }
                else
                    document.getElementById("destaddr1").value=vals[3];
                var stckyval = document.getElementById("sticky").value=vals[4];
                var stckytime= document.getElementById("stickrow");
                if(stckyval=="Yes")
                {
                    stckytime.style.display="";
                    document.getElementById("stimeout").value=vals[5];
                }
                else
                    stckytime.style.display="none";
            }
        var rowinstname = document.getElementById(instaname).value;
    }
    if(tablename="Members")
    {
        if(action == "menbadd")
        {
            var memeb_name = document.getElementById(instaname).value;
            var last_ind;
            if(parseInt(document.getElementById("Memberscount").value)==1)
            	last_ind = parseInt(document.getElementById("Memberscount").value);
            else
            	last_ind = parseInt(document.getElementById("Memberscount").value)-1;
	      	addRow('Members',slnumber,version);
            document.getElementById("membname"+last_ind).value=memeb_name;
            document.getElementById(instaname).value="";
            location.href = "savedetails.jsp?slnumber="+slnumber+"&page=members_config&mpname="+encodeURIComponent(memeb_name)+"&action=menbadd";
        }

    }
    if(tablename="Policies")
    {
        if(action == "poliadd")
        {
            var ploi_name = document.getElementById(instaname).value;
            var last_ind;
            if(parseInt(document.getElementById("policiesconfigcount").value)==1)
            	last_ind = parseInt(document.getElementById("policiesconfigcount").value);
            else
            	last_ind = parseInt(document.getElementById("policiesconfigcount").value)-1;
            //alert("calling add row from addAndEdit function ");
	     	addRow('Policies',slnumber,version);
           document.getElementById("policname"+last_ind).value=ploi_name;
           document.getElementById(instaname).value="";
           location.href = "savedetails.jsp?slnumber="+slnumber+"&page=policies_config&mpname="+encodeURIComponent(ploi_name)+"&action=poliadd";
        }
    }
    }
    catch(e)
    {
    alert(e);
    }
}

function editbtn(tablename,index,instname,version,slnumber)
{
	perdiv="rulesdiv";
    if(tablename == "Interfaces")
        addAndEditCode('Interfaces','edit',index,instname,slnumber,version);
    if(tablename == "Rules")
        addAndEditCode('Rules','edit',index,instname,slnumber,version);
}

function duplicateInstanceNamesExists(id,curtabid,comparetabid)
{
	altmsg ="";
	var name="";
    counter = 0;
    if(curtabid == "Rules"|| curtabid == "Policies" || curtabid == "Members")
    counter++;
	var dupexists=false;
    var table = document.getElementById(curtabid);
	var rowcnt = table.rows.length;
	var obj=document.getElementById(id);
	var name=obj;
	if(name.value == "")
	{
		obj.style.outline ="thin solid red";				
		obj.title="New Instance Name should not be empty";
	}
	else
	{
		obj.title="";
	}

    var displaystr = "New Instance Name";
    var loadbaltab=document.getElementById(comparetabid);
    var rowsize=loadbaltab.rows.length;
    for(var i=1;i<rowsize;i++)
    {
        var insname=loadbaltab.rows[i].cells[1].children[0];
        if(insname.value == name.value && insname.value != "")
        {
            if(curtabid == comparetabid)
                counter++;
            if(counter == 2 || curtabid != comparetabid)
            {
            	altmsg += name.value+" already exists in "+comparetabid;
                alert(name.value+" already exists in "+comparetabid);
                name.value="";
                dupexists= true;
                document.getElementById(id).style.outline="thin solid red";
                break;
            }
        }
    }
        
	return dupexists;
}

function validcheckAlphaNUmeric(id,labelid,tablename,tableid)
{
	altmsg = "";
    var memobj = document.getElementById(id);
    var regex=/^([a-zA-Z0-9_]+)$/;
    if(!memobj.value.match(regex) && memobj.value.length != 0)
    {
    	altmsg += "Special characters are not allowed except  '_'";
        alert("Special characters are not allowed expect  '_'");
        memobj.value="";
        memobj.style.outline="thin solid red";
        return false;
    }
    else
        memobj.style.outline="initial";
    return true;
}

//addrow and fillrow
function CheckNamevalidAndDuplicates(id,name,tablename,tableid,showemtpopup,slnumber,version)
{
    prevdiv="rulesdiv";
    var insobj = document.getElementById(id);
    var insval = insobj.value;

    if(!isEmpty(id,name))
    {
        if(showemtpopup)
            alert(name+" should not be empty");
        insobj.style.outline ="thin solid red";
        return;
    }
    else
        insobj.style.outline ="initial";

    if(tablename == "Rules")
    {
        var rultable = document.getElementById("Rules");
        var rulcount = rultable.rows;
        if(rulcount.length == 21)
        {
            alert("Maximum 20 rows are allowed in Rules");
            return false;
        }
    }
    if(tablename == "Members")
    {
        var memtable = document.getElementById("Members");
        var memcount = memtable.rows;
        if(memcount.length == 21)
        {
            alert("Maximum 20 rows are allowed in Members");
            return false;
        }
    }
    if(tablename == "Policies")
    {
        var poltable = document.getElementById("Policies");
        var polcount = poltable.rows;
        if(polcount.length == 21)
        {
            alert("Maximum 20 rows are allowed in Policies");
            return false;
        }
    }
    if(!validcheckAlphaNUmeric(id,name,tablename,tableid))
    	return;
    checkDuplicatesAndloadbalpage(id,true,tablename,tableid,slnumber,version);
}
function addRow(tablename,slnumber,version)
{
    var table = document.getElementById(tablename); 
	var iprows = table.rows.length; 
    if (tablename == "Interfaces") 
	{
        if (iprows == 21) 
		{ 
			alert("Maximum 20 rows are allowed in Interface"); 
			return false;
		}
        if (iprows == 1)
        document.getElementById("intconfigcount").value = iprows; 
        iprows = document.getElementById("intconfigcount").value; 
        document.getElementById("intconfigcount").value = Number(iprows)+1;
        var row = "<tr align=\"center\" id=\"interfcunt"+iprows+"\">"+
        "<td style=\"text-align: center; vertical-align: middle;\">"+iprows+"</td>"+
        "<td><input type=\"text\" style=\"min-width:100px;max-width:100px;\" id=\"interfname"+iprows+"\" name=\"interfname"+iprows+"\" class=\"text\" readonly></td>"+
        "<td><input type=\"text\" style=\"min-width:100px;max-width:100px;\" id=\"tracip"+iprows+"\" name=\"tracip"+iprows+"\" class=\"text\" onfocusout=\"validateIPOnly('tracip"+iprows+"',true,'Tracking IP')\" onmouseover=\"setTitle(this)\" readonly></input></td>"+
        "<td><input type=\"text\" style=\"min-width:100px;max-width:100px;\" id=\"tracrealiblty"+iprows+"\" name=\"tracrealiblty"+iprows+"\" class=\"text\" readonly></td>"+
        "<td><label class=\"switch\" style=\"vertical-align:middle\"><input type=\"checkbox\" name=\"enablact"+iprows+"\" id=\"enablact"+iprows+"\" style=\"vertical-align:middle\" readonly disabled><span class=\"slider round\" readonly disabled></span></label></td>"+
		"<td><button type=\"button\" id=\"iteditrw"+iprows+"\" name=\"iteditrw"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"editbtn('"+tablename+"',"+iprows+",'interfname"+iprows+"','"+version+"','"+slnumber+"')\">Edit <i class='fas fa-edit' style='font-size:12px;color:white'></i></button></td>"+
        "<td hidden>"+iprows+"</td>"+
        "<td hidden><input hidden id=\"intconfig_val"+iprows+"\"/></td>"
        "</tr>"; 
		$('#Interfaces').append(row); 
        reindexTable('Interfaces');		
    }
	else if(tablename == "Members")
	{
		if (iprows == 21) 
		{ 
			alert("Maximum 20 rows are allowed in Members"); 
			return false;
		}
        if (iprows == 1)
        document.getElementById("Memberscount").value = iprows; 
        iprows = document.getElementById("Memberscount").value;
        document.getElementById("Memberscount").value = Number(iprows)+1;
        var row = "<tr align=\"center\" id=\"membrcunt"+iprows+"\">"+
        "<td style=\"text-align: center; vertical-align: middle;\">"+iprows+"</td>"+
        "<td><input type=\"text\" style=\"min-width:100px;max-width:100px;\" id=\"membname"+iprows+"\" name=\"membname"+iprows+"\" class=\"text\" onkeypress=\"return avoidSpace(event)\" readonly></td>"+//
        "<td><select style=\"min-width:130px;max-width:130px;\" name=\"intlist"+iprows+"\" id=\"intlist"+iprows+"\" class=\"text\"><option value=\"wan\">wan</option><option value=\"cellular\">cellular</option></td>"+
        "<td><input type=\"number\" class=\"text\" min=\"1\" max=\"255\" placeholder=\"1-255\" value=\"5\" style=\"min-width:60px;max-width:60px;\" id=\"metric"+iprows+"\" name=\"metric"+iprows+"\" onkeypress=\"return avoidSpace(event) && avoidEnter(event)\" onfocusout=\"validateRange('metric"+iprows+"',true,'Metric')\"></td>"+
        "<td><input type=\"number\" class=\"text\" min=\"1\" max=\"255\" placeholder=\"1-255\" value=\"5\" style=\"min-width:60px;max-width:60px;\" id=\"weight"+iprows+"\" name=\"weight"+iprows+"\" onkeypress=\"return avoidSpace(event) && avoidEnter(event)\" onfocusout=\"validateRange('weight"+iprows+"',true,'Weight')\"></td>"+
		"<td><image style=\"cursor:pointer;margin-bottom:10px\" id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"30\" height=\"22\" align=\"center\" title=\"Delete\" onclick=\"deleteLoadBalncRecord('membname"+iprows+"','membrcunt"+iprows+"','Members','"+slnumber+"')\"></image></td>"+
        "<td hidden>"+iprows+"</td>"+
        "<td hidden><input hidden id=\"membersrow_val"+iprows+"\"/></td>"
        "</tr>"; 
		$('#Members').append(row); 
        reindexTable('Members');	
	}
	else if(tablename == "Policies")
	{
		if (iprows == 21) 
		{ 
			alert("Maximum 20 rows are allowed in Policies"); 
			return false;
		}
        if (iprows == 1)
        document.getElementById("policiesconfigcount").value = iprows; 
        iprows = document.getElementById("policiesconfigcount").value; 
        document.getElementById("policiesconfigcount").value = Number(iprows)+1;
        var row = "<tr align=\"center\" id=\"policicunt"+iprows+"\">"+
        "<td style=\"text-align: center; vertical-align: middle;\">"+iprows+"</td>"+
        "<td><input type=\"text\" style=\"min-width:120px;max-width:120px;\" maxlength=\"15\" id=\"policname"+iprows+"\" name=\"policname"+iprows+"\" class=\"text\" onkeypress=\"return avoidSpace(event) && avoidEnter(event)\" readonly></td>"+
        "<td><div onmouseover=\"getMemberNames('memassign_instance"+iprows+"')\"><select id=\"memassign_instance"+iprows+"\"  name=\"memassign_instance"+iprows+"\" class=\"text\" multiple=\"multiple\"></select></div></td>"+
        "<td><select style=\"min-width:150px;max-width:150px;\" name=\"lastrepot"+iprows+"\" id=\"lastrepot"+iprows+"\" class=\"text\"><option value=\"1\">Unreachable(Reject)</option><option value=\"2\">Blackhole(Drop)</option><option value=\"3\">Default(Main Routing Table)</option></td>"+
		"<td><image style=\"cursor:pointer;margin-bottom:10px\" id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"30\" height=\"22\" align=\"center\" title=\"Delete\" onclick=\"deleteLoadBalncRecord('policname"+iprows+"','policicunt"+iprows+"','Policies','"+slnumber+"')\"></image></td>"+
        "<td hidden>"+iprows+"</td>"+
        "<td hidden><input hidden id=\"policierow_val"+iprows+"\"/></td>"+
        "</tr>"; 
		$('#Policies').append(row); 
        getMemberNames('memassign_instance'+iprows);
        reindexTable('Policies');	
	}
	else if(tablename == "Rules")
	{
		if (iprows == 21) 
		{ 
			alert("Maximum 20 rows are allowed in Rules"); 
			return false;
		}
        if (iprows == 1)
        document.getElementById("Rulescount").value = iprows; 
        iprows = document.getElementById("Rulescount").value; 
        document.getElementById("Rulescount").value = Number(iprows)+1;
        var row = "<tr align=\"center\" id=\"rulescunt"+iprows+"\">"+
        "<td style=\"text-align: center; vertical-align: middle;\">"+iprows+"</td>"+
        "<td><input type=\"text\" style=\"min-width:150px;max-width:150px;\" id=\"rulename"+iprows+"\" name=\"rulename"+iprows+"\" class=\"text\" readonly></td>"+
		"<td><input type=\"text\" class=\"text\" style=\"min-width:150px;max-width:150px;\" id=\"ruleassign"+iprows+"\" name=\"ruleassign"+iprows+"\" readonly></td>"+
		"<td><button type=\"button\" id=\"editrw"+iprows+"\" name=\"editrw"+iprows+"\" class=\"button1\" align=\"left\" onclick=\"editbtn('"+tablename+"',"+iprows+",'rulename"+iprows+"','"+version+"','"+slnumber+"')\">Edit <i class='fas fa-edit' style='font-size:12px;color:white'></i></button>"+
		"<image style=\"cursor:pointer;margin-bottom:10px\" id=\"delrw"+iprows+"\" name=\"delrw"+iprows+"\" src=\"images/delete.png\" width=\"30\" height=\"22\" align=\"center\" title=\"Delete\" onclick=\"deleteLoadBalncRecord('rulename"+iprows+"','rulescunt"+iprows+"','Rules','"+slnumber+"')\"></image></td>"+
        "<td hidden>"+iprows+"</td>"+
        "<td hidden><input hidden id=\"rulesrow_val"+iprows+"\"/></td>"
        "</tr>"; 
		$('#Rules').append(row); 
        reindexTable('Rules');	
	}
}

function fillInterfacerow(rowid,interfname,tracip,tracrealiblty,enablact,pingcunt,pingtime,pingintr,intdwon,intup,ipfamily)
{
    document.getElementById("enablact"+rowid).checked=enablact;
    document.getElementById("interfname"+rowid).value=interfname;
    document.getElementById("tracip"+rowid).value=tracip;
    document.getElementById("tracrealiblty"+rowid).value=tracrealiblty;
    var val=document.getElementById("intconfig_val"+rowid).value=interfname+", "+tracip+", "+tracrealiblty+", "+enablact+", "+pingcunt+", "+pingtime+", "+pingintr+", "+intdwon+", "+intup+", "+ipfamily;
}

function fillmemberow(rowid,memname,interflist,metric,weight)
{
    document.getElementById("membname"+rowid).value=memname;
    var memnameobj = document.getElementById("membname"+rowid);
    if(memnameobj.value.trim()=="")
        memnameobj.readOnly = false; 
    else if(memnameobj.value.trim()!="")
        memnameobj.readOnly = true;
    document.getElementById("intlist"+rowid).value=interflist;
    document.getElementById("metric"+rowid).value=metric;
    document.getElementById("weight"+rowid).value=weight;
    document.getElementById("membersrow_val"+rowid).value=memname+", "+interflist+", "+metric+", "+weight;
}

function fillpolicierow(rowid,poliname,memeassignstr,lastrepo)
{
    document.getElementById("policname"+rowid).value=poliname;
    var polinameobj = document.getElementById("policname"+rowid);
    if(polinameobj.value.trim()=="")
        polinameobj.readOnly = false; 
    else if(polinameobj.value.trim()!="")
        polinameobj.readOnly = true;
    document.getElementById("lastrepot"+rowid).value=lastrepo;
    var membassiobj = document.getElementById("memassign_instance"+rowid);
    var membchilds = membassiobj.childNodes;
    var hid_btn_obj = membassiobj.parentNode.childNodes[1].childNodes[0];
    var hid_span = hid_btn_obj.childNodes[0];
    var mem_hid_UL_obj = membassiobj.parentNode.childNodes[1].childNodes[1];
    var ul_childs = mem_hid_UL_obj.childNodes;  // to get ul childs
    var mem_as_vals =  memeassignstr.split(",");
    if(mem_as_vals.length == 1)
        hid_span.innerHTML = mem_as_vals[0];
    else if(mem_as_vals.length > 1)
    {
        if(mem_as_vals.length == membchilds.length)
             hid_span.innerHTML = "All selected ("+mem_as_vals.length+")";
        else
            hid_span.innerHTML = mem_as_vals.length+" selected";
    }
    for(var i=0;i<mem_as_vals.length;i++){
        var val = mem_as_vals[i];
        for(var j=0;j<membchilds.length;j++)
        {
            var childobj = membchilds[j];
            if(childobj.innerHTML == val)
            {
                childobj.selected = 'true';
                ul_childs[j].class ="active";
                ul_childs[j].childNodes[0].childNodes[0].childNodes[0].checked = true;
                if(hid_btn_obj.title == "None selected")
                    hid_btn_obj.title = "";
                if(hid_btn_obj.title != "")
                    hid_btn_obj.title +=",";
        
                hid_btn_obj.title +=val;
                break;
            }
        }

    }
    document.getElementById("policierow_val"+rowid).value=poliname+", "+memeassignstr+", "+lastrepo;
}

function fillrulesrow(rowid,roulename,policassgin,protocal,destaddr,sticky,stittimeout,destport)
{
    document.getElementById("rulename"+rowid).value=roulename;
    document.getElementById("ruleassign"+rowid).value=policassgin;
    document.getElementById("rulesrow_val"+rowid).value=roulename+", "+policassgin+", "+protocal+", "+destaddr+", "+sticky+", "+stittimeout+", "+destport;
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

function addRulesRow(rowid,tableid)
{
    try{
        if(tableid =="trackiptab")
        {
            var table = document.getElementById(tableid);
            if(table.rows.length >=2)
            {
                alert("Max 2 rows are allowed");
                return;
            }
            intfpulsbtn++;
            var remove=document.getElementById("removebtn"+rowid);
            var add=document.getElementById("addbtn"+rowid);
            if(add != null)
            add.style.display="none";
            if(remove != null)
            remove.style.display ="inline";
            $("#"+tableid).append("<tr id=\"netr"+intfpulsbtn+"\"><td><div>Tracking IP</div></td><td width=\"305px\"><div><input type=\"text\" class=\"text\" id=\"trackip"+intfpulsbtn+"\" name=\"trackip"+intfpulsbtn+"\" style='position: relative; left: 3px;display:inline block' placeholder=\"192.168.1.0\" onkeypress=\"return avoidSpace(event) && avoidEnter(event)\"  onfocusout=\"validateIPOnly('trackip"+intfpulsbtn+"',true,'Tracking IP')\"><label class=\"add\" id=\"addbtn"+intfpulsbtn+"\" style=\"font-size: 17px; margin-left:7px;color:green;display: inline;\" onclick=\"addRulesRow("+intfpulsbtn+",'"+tableid+"')\">+</label><label class=\"remove\" style=\"display: inline; font-size: 15px;margin-left:5px; color:red;\" id=\"removebtn"+intfpulsbtn+"\" onclick=\"deleteRuletrkTableRow("+intfpulsbtn+",'"+tableid+"')\">x</label><input id=\"row"+intfpulsbtn+"\" value=\""+intfpulsbtn+"\" hidden=\"\"></div></td></tr>");
            document.getElementById("trackcunt").value = intfpulsbtn;
            adjtabFircol(tableid,'Tracking IP');
        }
        else if(tableid == "destaddrtab")
        {
            var table = document.getElementById(tableid);
            if(table.rows.length >=2)
            {
                alert("Max 2 rows are allowed");
                return;
            }
            rudesaddbtn++;
            var remove=document.getElementById("destremovebtn"+rowid);
            var add=document.getElementById("destaddbtn"+rowid);
            if(add != null)
            add.style.display="none";
            if(remove != null)
            remove.style.display ="inline";
            $("#"+tableid).append("<tr id=\"destr"+rudesaddbtn+"\"><td><div>Destination Address</div></td><td width=\"305px\"><div><input type=\"text\" class=\"text\" id=\"destaddr"+rudesaddbtn+"\" name=\"destaddr"+rudesaddbtn+"\" style='position: relative; left: 3px;display:inline block' onkeypress=\"return avoidSpace(event) && avoidEnter(event)\" placeholder=\"192.168.1.0\" onfocusout=\" validateIPOnly('destaddr"+rudesaddbtn+"',false,'Destination Address')\"><label class=\"add\" id=\"destaddbtn"+rudesaddbtn+"\" style=\"font-size: 17px; margin-left:7px;color:green;display: inline;\" onclick=\"addRulesRow("+rudesaddbtn+",'"+tableid+"')\">+</label><label class=\"remove\" style=\"display: inline; font-size: 15px;margin-left:5px; color:red;\" id=\"destremovebtn"+rudesaddbtn+"\" onclick=\"deleteRuletrkTableRow("+rudesaddbtn+",'"+tableid+"')\">x</label><input id=\"row"+rudesaddbtn+"\" value=\""+rudesaddbtn+"\" hidden=\"\"></div></td></tr>");
            document.getElementById("destcount").value = rudesaddbtn;
            adjtabFircol(tableid,'Destination Address');
        }
    }
    catch(e)
    {
        alert(e);
    }
}

function filltrackiprow(rowid,trackip)
{
    document.getElementById("trackip"+rowid).value=trackip;
}

function filldestiporow(rowid,destipadd)
{
    document.getElementById("destaddr"+rowid).value=destipadd;
}
function deleteRuletrkRow(rowid,tableid)
{
	
	if(tableid =="trackiptab")
    {
        var ele = document.getElementById("netr"+rowid);
	    $('table#'+tableid+' tr#netr'+rowid).remove();
        adjtabFircol(tableid,'Tracking IP');
    }
    if(tableid =="destaddrtab")
    {
        var ele = document.getElementById("destr"+rowid);
        $('table#'+tableid+' tr#destr'+rowid).remove();
        adjtabFircol(tableid,'Destination Address');
    }
}
function deleteRuletrkTableRow(row,tableid)
{
	deleteRuletrkRow(row,tableid);
	findRulesLastRowAndDisplayRemoveIcon(tableid);
	if(tableid =="trackiptab")
        adjtabFircol(tableid,'Tracking IP');
    if(tableid =="destaddrtab")
        adjtabFircol(tableid,'Destination Address');
}
function findRulesLastRowAndDisplayRemoveIcon(tableid)
{
	var table = document.getElementById(tableid);
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[1].childNodes[0].childNodes[1];
	var removeobj = lastrow.cells[1].childNodes[0].childNodes[2];
	addobj.style.display="inline";
	if(table.rows.length > 2) 
		removeobj.style.display="inline";
		
	else if(table.rows.length == 2)
		removeobj.style.display="none";
}
function adjtabFircol(tabname,setname)
{
	var table = document.getElementById(tabname);
	var rows = table.rows;
	var index = 1;
	for(var i=index-1;i<rows.length;i++)
	{
		if(i==index-1)
		{
			rows[i].cells[0].innerHTML = setname;
	    }
		else
		{
			rows[i].cells[0].innerHTML = "";
		}
	}
	if(rows.length == (index))
	{
		rows[index-1].cells[1].childNodes[0].childNodes[1].style.display="";
		rows[index-1].cells[1].childNodes[0].childNodes[2].style.display="none";
	}
}

function deleteLoadBalncRecord(instid,rowid,tablename,slnumber)
{
    try{
        var instname = document.getElementById(instid);
        var instval = instname.value.trim();
        if(tablename == "Members")
        {
            var politable = document.getElementById("Policies");
            var polirow = politable.rows;
            var memassignused = false;
            for(var j=1;j<polirow.length;j++)
            { 
                var membassignobj = polirow[j].cells[2].childNodes[0].childNodes[0];
                var selectedArray = new Array();
                var count = 0;
                for(var i=0;i<membassignobj.options.length;i++)
                {
                    if(membassignobj.options[i].selected)
                    {
                        selectedArray[count] = membassignobj.options[i].value;
                        count++; 
                    }
                }
                if(membassignobj!=null && selectedArray.includes(instval))
                {
                    alert(instval+" Already Selected in Policies");
                    memassignused = true;
                    break;
                }
            }
            if(!memassignused)
	            location.href = "savedetails.jsp?slnumber="+slnumber+"&page=members_config&delinstname="+encodeURIComponent(instval)+"&action=delete";
        }
        else if(tablename == "Policies")
        {
            var tablerules = document.getElementById("Rules");
            var tablerulrows = tablerules.rows;
            var ruleused = false;
            for(var k=1;k<tablerulrows.length;k++)
            {
                var rulesassobj = tablerulrows[k].cells[2].childNodes[0];
                if(rulesassobj!=null && instval ==  rulesassobj.value.trim() && instval!="")
                {
                    alert(instval+" Already Selected in Rules");
                    ruleused = true;
                    break;
                }
            }
            if(!ruleused)
	            location.href = "savedetails.jsp?slnumber="+slnumber+"&page=policies_config&delinstname="+encodeURIComponent(instval)+"&action=delete";
        }
        else
        		location.href = "savedetails.jsp?slnumber="+slnumber+"&page=rulesconf&delinstname="+encodeURIComponent(instval)+"&action=delete";
    }catch(e){
        alert(e);
    }
}


//overall validation

/*function Loadbalancing()
{
	if(altmsg.trim().length > 0)
    {
        altmsg = "";
        return false;
    }
    var enableobj = document.getElementById("intract");
    var golobalact = document.getElementById("globalact");
    try{
    	var table = document.getElementById("trackiptab");
        var tabletrkrow = table.rows;
        var track_ip_arr = []; 
        for(var i=0;i<tabletrkrow.length;i++)
        {
            var tracipcols = tabletrkrow[i].cells;
            var trackipobj = tracipcols[1].childNodes[0].childNodes[0];
            var trackval = trackipobj.value.trim();
            valid = validateIPOnly(trackipobj.id,true,'Tracking Ip'); 
            if(!valid)
            {
                if(trackval=="")
                    altmsg+="Tracking Ip "+(i+1)+" should not be empty in Interface\n";
                else
                    altmsg+="Tracking Ip "+(i+1)+" not valid in Interface\n";
            }
            if(valid)
            {
                for(j=0;j<track_ip_arr.length;j++)
                {
                    if(track_ip_arr[j].value.trim() == trackval)
                    {
                        trackipobj.style.outline = "thin solid red";
                        track_ip_arr[j].style.outline = "thin solid red";
                        altmsg+="Duplicate Tracking Ip "+trackval+" in Interface\n";
                        break;
                    }
                }
                if(j==track_ip_arr.length)
                    track_ip_arr.push(trackipobj);
            }
            if(tabletrkrow.length<tracreliaval)
            {
                if (!altmsg.includes("Tracking Reliability should not be greater than number of Tracking IP"))
                    altmsg+="Tracking Reliability should not be greater than number of Tracking IP\n";
            }
        }
        if(enableobj.checked)
        {
            var trackreli = document.getElementById("trackreblity");
            var tracreliaval = trackreli.value.trim();
            var pingcunt = document.getElementById("pingcunt");
            var pingtimout = document.getElementById("pingtiout");
            var pinginter = document.getElementById("pingintvl");
            var intfdown = document.getElementById("intrfdwn");
            var intup = document.getElementById("intrfup");
            var valid = validateRange('trackreblity',true,'Tracking Reliability');
            if(!valid)
            {
                if(tracreliaval=="")
                    altmsg+="Tracking Reliability should not be empty in Interface\n";
                else
                    altmsg+="Tracking Reliability not valid in Interface\n";
            }
            valid = validateRange('pingcunt',true,'Ping Count');
            if(!valid)
            {
                if(pingcunt.value.trim()=="")
                    altmsg+="Ping Count should not be empty in Interface\n";
                else
                    altmsg+="Ping Count not valid in Interface\n";
            }
            valid = validateRange('pingtiout',true,'Ping Timeout');
            if(!valid)
            {
                if(pingtimout.value.trim()=="")
                    altmsg+="Ping Timeout should not be empty in Interface\n";
                else
                    altmsg+="Ping Timeout not valid in Interface\n";
            }
            valid = validateRange('pingintvl',true,'Ping Interval');
            if(!valid)
            {
                if(pinginter.value.trim()=="")
                    altmsg+="Ping Interval not be empty in Interface\n";
                else
                    altmsg+="Ping Interval not valid in Interface\n";
            }
            valid = validateRange('intrfdwn',true,'Interface Down');
            if(!valid)
            {
                if(intfdown.value.trim()=="")
                    altmsg+="Interface Down should not be empty in Interface\n";
                else
                    altmsg+="Interface Down not valid in Interface\n";
            }
            valid = validateRange('intrfup',true,'Interface Up');
            if(!valid)
            {
                if(intup.value.trim()=="")
                    altmsg+="Interface Up should not be empty in Interface\n";
                else
                    altmsg+="Interface Up  not valid in Interface\n";
            }
        }

        // member page 
        var table = document.getElementById("Members");
        var tablememrow = table.rows;
        for(var i=1;i<tablememrow.length;i++)
        {
            var cols = tablememrow[i].cells;
            var memname = cols[1].childNodes[0];
            var i_memnameval = memname.value.trim();
            var insfassi = cols[2].childNodes[0];
            var i_insfassi = insfassi.value.trim();
            var metric = cols[3].childNodes[0];
            var i_metricval = metric.value.trim();
            var weight = cols[4].childNodes[0];
            var i_weightval = weight.value.trim();
            valid = isAlphaNumberic(memname.id);
		    if(!valid)
		    {
		        if(i_memnameval== "")
		            altmsg+="Member Name in the row "+i+" should not be empty in Members\n";
		        else
		            altmsg+="Member Name in the row "+i+" is not valid in Members\n";
		    }
            valid = validateRange(metric.id,true,'Metric');
            if(!valid)
            {
                if(i_metricval == "")
                    altmsg+="metric row "+i+" should not be empty in Members\n";
                else
                    altmsg+="metric row "+i+" not valid in Members\n";
            }
            valid = validateRange(weight.id,true,'Weight');
            if(!valid)
            {
                if(i_weightval == "")
                    altmsg+="weight "+i+" should not be empty in Members\n";
                else
                    altmsg+="weight row "+i+" not valid in Members\n";
            }
            for(var j=1;j<tablememrow.length;j++)
            {
                var colls = tablememrow[j].cells;
                var j_memname =colls[1].childNodes[0];
                var j_memnameval = j_memname.value.trim();
                var j_insfassi =colls[2].childNodes[0];
                var j_insfassival = j_insfassi.value.trim();
                var j_metric = colls[3].childNodes[0];
                var j_metricval = j_metric.value.trim();
                var j_weight = colls[4].childNodes[0];
                var j_weightval = j_weight.value.trim();
                if(i_memnameval == j_memnameval && j_memnameval!="" && i!=j)
                {
                    if(!altmsg.includes(j_memnameval+" alredy exists in Members"))
                        altmsg += j_memnameval+" alredy exists in Members\n";
                    memname.style.outline="thin solid red";
                    j_memname.style.outline="initial";
                }
                if(i_insfassi==j_insfassival && i_metricval==j_metricval && i_weightval==j_weightval && j_metricval!="" && j_weightval!="" && i!=j)
                {
                    if(!altmsg.includes("For Same Interface ("+j_insfassival+") Metric and Weight should not be same"))
                        altmsg +="For Same Interface ("+j_insfassival+") Metric and Weight should not be same\n";
                }
            }
        }

        //policy page
        var table = document.getElementById("Policies");
        var tablepolirow = table.rows;
        for(var i=1;i<tablepolirow.length;i++)
        {
            var cols = tablepolirow[i].cells;
            var poliname = cols[1].childNodes[0];
            var memberassign = cols[2].childNodes[0].childNodes[0];
            var selectedOptions = [];
            var i_polinamval = poliname.value.trim();
            var valid = isAlphaNumberic(poliname.id);
            if(!valid)
            {
                if(poliname.value.trim()=="")
                    altmsg+="Policie Name in the row "+i+" should not be empty in Policies\n";
                else
                    altmsg+="Policie Name in the row "+i+" is not valid in Policies\n";
            }
            //for check boxes
            for(var k = 0; k < memberassign.options.length; k++) 
            {
                if(memberassign.options[k].selected) 
                    selectedOptions.push(memberassign.options[k].value);
            }
            if(!(selectedOptions.length == 2)) 
                altmsg+="Select exactly two options under Members Assigned of the row "+i+" in Policies\n";
            
            //duplicate in policy 
            for(var j=1;j<tablepolirow.length;j++)
            {
                var cools = tablepolirow[j].cells;
                var j_poliname = cools[1].childNodes[0];
                var j_polinamval = j_poliname.value.trim();
                if(i_polinamval == j_polinamval && j_polinamval!="" && i!=j)
                {
                    if(!altmsg.includes(j_polinamval+" alredy exists in Policies"))
                        altmsg += j_polinamval+" alredy exists in Policies\n";
                    poliname.style.outline="thin solid red";
                    j_poliname.style.outline="initial";
                }
            }
        }

        // rules page
        var table = document.getElementById("destaddrtab");
        var tabledesrow = table.rows;
        var dest_addr_arr = [];
        for(var i=0;i<tabledesrow.length;i++)
        {
            var descols = tabledesrow[i].cells;
            var destaddrobj = descols[1].childNodes[0].childNodes[0];
            var destaddrval =destaddrobj.value.trim();
            var destipvaild = validateIPOnly(destaddrobj.id,true,'Destination Address');
            if(!destipvaild)
            {
                if(destaddrval!="")
                    altmsg +="Destination Address row "+(i+1)+" not vaild\n";
                else
                    destaddrobj.style.outline="initial";
            }
            if(destipvaild)
            {
                for(dest=0;dest<dest_addr_arr.length;dest++)
                {
                    if(dest_addr_arr[dest].value == destaddrval)
                    {
                        destaddrobj.style.outline = "thin solid red";
                        dest_addr_arr[dest].style.outline = "thin solid red";
                        altmsg += "Duplicate Destination Address "+destaddrval+" in Rules\n";
                        break;
                    }
                }
                if(dest==dest_addr_arr.length)
                    dest_addr_arr.push(destaddrobj);
            }
        }
        
        var sticyval = document.getElementById("sticky").value.trim();
        if(sticyval == "Yes")
        {
            var stictimeobj = document.getElementById("stimeout");
            if(stictimeobj.value.trim() == "")
            {
                altmsg += "Sticky Timeout should not be empty in Rules\n";
                stictimeobj.style.outline="thin solid red";
            }
            else
                stictimeobj.style.outline="initial";
        }
        
        var rulinstobj = document.getElementById("rulname");
        if(rulinstobj.value.trim()!="")
        {
	        var poliasobj = document.getElementById("poliassign");
	        if(poliasobj.value.trim()=="")
	        {
	            altmsg += "Policy Assigned should not be empty in Rules\n";
	            poliasobj.style.outline="thin solid red";
	        }
	        else
	            poliasobj.style.outline="initial";
	    }
       	var depoobj = document.getElementById("dport");
        var number_comma = "^[0-9:]+$";
        var depoval = depoobj.value.trim();
        var deposplit = depoval.split(",");

        if(depoval != "")
        {
            if(depoval.endsWith(",") || depoval.startsWith(","))
            {
                altmsg += "port number should not starts or ends with ','\n";
                depoobj.style.outline="thin solid red";
            }
            else
            {
                for(var i=0;i<deposplit.length;i++)
                {
                    if(deposplit[i].length==0)
                    {
                       altmsg += deposplit[i]+"Any one of the port numbers should not be  empty\n";
                       depoobj.style.outline="thin solid red";
                       break;
                    }    
                    var in_vaild = deposplit[i].match(number_comma);
                    if(deposplit[i]!="")
                    {
                        if((!in_vaild) || (deposplit[i]<0) ||( deposplit[i]>65535) )
                        {
                            altmsg += deposplit[i]+" Port number is not valid\n";
                            depoobj.style.outline="thin solid red";
                        }
                        else if(deposplit[i].includes(":"))
                        {
                            var deoslit = deposplit[i].split(":");
                            if(deoslit[0]<0 || deoslit[0]>65535)
                            {
                                altmsg += "Port number "+deoslit[0]+" is not valid\n";
                                depoobj.style.outline="thin solid red";
                            }
                            else
                            {
                                if(parseInt(deoslit[0])>=parseInt(deoslit[1]))
                                {
                                    altmsg += deoslit[0]+" should not be greater than or equal to"+deoslit[1]+"\n";
                                    depoobj.style.outline="thin solid red";
                                }
                                else if(deoslit[1]<0 || deoslit[1]>65535)
                                {
                                    altmsg += "Port number "+deoslit[1]+" is not valid\n";
                                    depoobj.style.outline="thin solid red";
                                }

                            }
                        }
                        else
                            depoobj.style.outline="initial";
                    }
                }
            }
        }
       
        

    }catch(e)
    {
        alert(e);
    }
    if (altmsg.trim().length == 0) 
        return true;
    else {
      alert(altmsg);
      altmsg = "";
      return false;
    }
}
*/
function stickyhide()
{
    var stickyobj = document.getElementById("sticky");
    var stictimerow= document.getElementById("stickrow");
    var stictime= document.getElementById("stimeout");
    if(stickyobj.value == "Yes")
    {
        stictimerow.style.display = "";
        stictime.value="600";
    }
    else
        stictimerow.style.display = "none";
}

function isAlphaNumberic(id)
{
	var idobj = document.getElementById(id);
	var val = idobj.value;
	var regex=/^([a-zA-Z0-9_]+)$/;
	if(val.match(regex))
    {
        idobj.style.outline = "initial";
        return true;
    }
	idobj.style.outline = "thin solid red";
	return false;
}

//dropdowncheckbox  // dont use this guru
function mouseInAction(rowid)
{
	//getMemberNames('memassign_instance'+rowid);
}

function getMemberNames(polmemassginid)
{
	try
	{
        var table = document.getElementById("Policies")
        var policyrow = table.rows
        selobj = document.getElementById(polmemassginid);
        const namap = new Map();
        for(var i = selobj.options.length-1; i >= 0; i--)
        {
            var opt = selobj.options[i];
            if(opt.selected)
            namap.set(opt.value,opt.value);
            selobj.remove(i);
        }
        var Policyrowval="";
        var display =selobj.style.display;
        var memconftab = document.getElementById('Members');
        var memrows = memconftab.rows;
          
        for(var i=1;i<memrows.length;i++)
        {
            var memnameobj = memrows[i].cells[1].childNodes[0];
            if(memnameobj.value.trim()!="")
            {
                if(memnameobj != null)
                {
                    var opt = document.createElement('option');
                    opt.value = memnameobj.value;
                    opt.innerHTML = memnameobj.value;
                    if(namap.get(opt.value) != null)
                    	opt.selected = 'true';
                    selobj.appendChild(opt);
                }
            }
        }
        $('#'+polmemassginid).multiselect({
            buttonWidth: '175px',
            numberDisplayed:1,
            nSelectedText: 'selected',
            nonSelectedText: 'None selected',
        });
    }
	catch(e)
	{
		alert(e);
	}
}

//rules dropdown list 

function addPoliassignName(id,opt)
{
    $('#'+id).append("<option value="+opt+">"+opt+"</option>"); 
}
function setPoliassignName(id,opt)
{
    document.getElementById(id).value = opt; 
}

function destporthide()
{
    var depotobj = document.getElementById("dport_row");
    var protoobj = document.getElementById("protocol");
    if(protoobj.value.trim() == "tcp" || protoobj.value.trim() == "udp")
        depotobj.style.display="";
    else
        depotobj.style.display="none";
}




//individual overall validation
function validateInterfaces()
{
    if(altmsg.trim().length > 0)
    {
        altmsg = "";
        return false;
    }
    var enableobj = document.getElementById("intract");
    var golobalact = document.getElementById("globalact");
    // var altmsg = "";
    try{
        var trackreli = document.getElementById("trackreblity");
        var tracreliaval = trackreli.value.trim();
        if(!enableobj.checked)
            var check_empty = false;
        else
            check_empty = true;
        var table = document.getElementById("trackiptab");
        var tabletrkrow = table.rows;
        var track_ip_arr = []; 
        for(var i=0;i<tabletrkrow.length;i++)
        {
            var tracipcols = tabletrkrow[i].cells;
            var trackipobj = tracipcols[1].childNodes[0].childNodes[0];
            var trackval = trackipobj.value.trim();
            valid = validateIPOnly(trackipobj.id,check_empty,'Tracking Ip'); 
            if(!valid)
            {
                if(trackval=="")
                    altmsg+="Tracking Ip in the row "+(i+1)+" should not be empty\n";
                else
                    altmsg+="Tracking Ip in the row "+(i+1)+" is not valid\n";
            }
            if(valid)
            {
                for(var j=0;j<track_ip_arr.length;j++)
                {
                    if(track_ip_arr[j].value.trim() == trackval && trackval!="")
                    {
                        trackipobj.style.outline = "thin solid red";
                        track_ip_arr[j].style.outline = "thin solid red";
                        altmsg+="Duplicate Tracking IP "+trackval+"\n";
                        break;
                    }
                }
                if(j==track_ip_arr.length)
                    track_ip_arr.push(trackipobj);
            }
            if(tabletrkrow.length<tracreliaval && check_empty && trackval!="")
            {
                if (!altmsg.includes("Tracking Reliability should not be greater than number of rows in Tracking IP"))
                {
                    altmsg+="Tracking Reliability should not be greater than number of rows in Tracking IP\n";
                    trackreli.style.outline="thin solid red";
                }
                
                // break; 
            }
        }
        var pingcunt = document.getElementById("pingcunt");
        var pingtimout = document.getElementById("pingtiout");
        var pinginter = document.getElementById("pingintvl");
        var intfdown = document.getElementById("intrfdwn");
        var intup = document.getElementById("intrfup");
        if(enableobj.checked)
        {
            if (!altmsg.includes("Tracking Reliability should not be greater than number of rows in Tracking IP"))
            {
                var valid = validateRange('trackreblity',true,'Tracking Reliability');
                if(!valid)
                {
                    if(tracreliaval=="")
                        altmsg+="Tracking Reliability should not be empty\n";
                    else
                        altmsg+="Tracking Reliability is not valid\n";
                }
            }
            
            valid = validateRange('pingcunt',true,'Ping Count');
            if(!valid)
            {
                if(pingcunt.value.trim()=="")
                    altmsg+="Ping Count should not be empty\n";
                else
                    altmsg+="Ping Count is not valid\n";
            }
            valid = validateRange('pingtiout',true,'Ping Timeout');
            if(!valid)
            {
                if(pingtimout.value.trim()=="")
                    altmsg+="Ping Timeout should not be empty\n";
                else
                    altmsg+="Ping Timeout is not valid\n";
            }
            valid = validateRange('pingintvl',true,'Ping Interval');
            if(!valid)
            {
                if(pinginter.value.trim()=="")
                    altmsg+="Ping Interval not be empty\n";
                else
                    altmsg+="Ping Interval is not valid\n";
            }
            valid = validateRange('intrfdwn',true,'Interface Down');
            if(!valid)
            {
                if(intfdown.value.trim()=="")
                    altmsg+="Interface Down should not be empty\n";
                else
                    altmsg+="Interface Down is not valid\n";
            }
            valid = validateRange('intrfup',true,'Interface Up');
            if(!valid)
            {
                if(intup.value.trim()=="")
                    altmsg+="Interface Up should not be empty\n";
                else
                    altmsg+="Interface Up is not valid\n";
            }
        }
        else
        {
            trackreli.style.outline="initial";
            pingcunt.style.outline="initial";
            pingtimout.style.outline="initial";
            pinginter.style.outline="initial";
            intfdown.style.outline="initial";
            intup.style.outline="initial";
        }

    }catch(e)
    {
        alert(e);
    }
    if (altmsg.trim().length == 0) 
        return true;
    else {
      alert(altmsg);
      altmsg ="";
      return false;
    }
}



function validateMembers()
{
    altmsg = "";
    try{
        // member page 
        var table = document.getElementById("Members");
        var tablememrow = table.rows;
        for(var i=1;i<tablememrow.length;i++)
        {
            var cols = tablememrow[i].cells;
            var memname = cols[1].childNodes[0];
            var i_memnameval = memname.value.trim();
            var insfassi = cols[2].childNodes[0];
            var i_insfassi = insfassi.value.trim();
            var metric = cols[3].childNodes[0];
            var i_metricval = metric.value.trim();
            var weight = cols[4].childNodes[0];
            var i_weightval = weight.value.trim();
            instobj = isAlphaNumberic(memname.id);
            if(!instobj)
            {
                if(i_memnameval== "")
                    altmsg+="Member Name in the row "+i+" should not be empty\n";
                else
                    altmsg+="Member Name in the row "+i+" is not valid\n";
            }
            valid = validateRange(metric.id,true,'Metric');
            if(!valid)
            {
                if(i_metricval == "")
                    altmsg+="Metric in the row "+i+" should not be empty\n";
                else
                    altmsg+="Metric in the row "+i+" is not valid\n";
            }
            valid = validateRange(weight.id,true,'Weight');
            if(!valid)
            {
                if(i_weightval == "")
                    altmsg+="Weight in the row "+i+" should not be empty\n";
                else
                    altmsg+="Weight in the row "+i+" is not valid\n";
            }
            for(var j=1;j<tablememrow.length;j++)
            {
                var colls = tablememrow[j].cells;
                var j_memname =colls[1].childNodes[0];
                var j_memnameval = j_memname.value.trim();
                var j_insfassi =colls[2].childNodes[0];
                var j_insfassival = j_insfassi.value.trim();
                var j_metric = colls[3].childNodes[0];
                var j_metricval = j_metric.value.trim();
                var j_weight = colls[4].childNodes[0];
                var j_weightval = j_weight.value.trim();
                if(i_memnameval == j_memnameval && j_memnameval!="" && i!=j)
                {
                    if(!altmsg.includes(j_memnameval+" alredy exists"))
                        altmsg += j_memnameval+" alredy exists\n";
                    memname.style.outline="thin solid red";
                    j_memname.style.outline="initial";
                }
                if(i_insfassi==j_insfassival && i_metricval==j_metricval && i_weightval==j_weightval && j_metricval!="" && j_weightval!="" && i!=j)
                {
                    if(!altmsg.includes("Metric and Weight should not be same when Interfaces are same"))
                        altmsg +="Metric and Weight should not be same when Interfaces are same\n";
                    metric.style.outline="thin solid red";
                    weight.style.outline="thin solid red";
                }
            }
        }
    }catch(e){
        alert(e);
    }
    if (altmsg.trim().length == 0) 
        return true;
    else {
      alert(altmsg);
      altmsg ="";
      return false;
    }
}

function validatePolicy()
{
    altmsg="";
    try{
        //policy page
        var table = document.getElementById("Policies");
        var tablepolirow = table.rows;
        for(var i=1;i<tablepolirow.length;i++)
        {
            var cols = tablepolirow[i].cells;
            var poliname = cols[1].childNodes[0];
            var memberassign = cols[2].childNodes[0].childNodes[0];
            var selectedOptions = [];
            var i_polinamval = poliname.value.trim();
            var valid = isAlphaNumberic(poliname.id);
            if(!valid)
            {
                if(poliname.value.trim()=="")
                    altmsg+="Policy Name in the row "+i+" should not be empty\n";
                else
                    altmsg+="Policy Name in the row "+i+" is not valid\n";
            }
            //for check boxes
            for(var k = 0; k < memberassign.options.length; k++) 
            {
                if(memberassign.options[k].selected) 
                    selectedOptions.push(memberassign.options[k].value);
            }
            if(selectedOptions.length == 0)
                altmsg+="Please select atleast one option from the Members Assigned in the row "+i+"\n";
            
            //duplicate in policy 
            for(var j=1;j<tablepolirow.length;j++)
            {
                var cools = tablepolirow[j].cells;
                var j_poliname = cools[1].childNodes[0];
                var j_polinamval = j_poliname.value.trim();
                if(i_polinamval == j_polinamval && j_polinamval!="" && i!=j)
                {
                    if(!altmsg.includes(j_polinamval+" alredy exists"))
                        altmsg += j_polinamval+" alredy exists\n";
                    poliname.style.outline="thin solid red";
                    j_poliname.style.outline="initial";
                }
            }
        }
    }catch(e)
    {
        alert(e);
    }
    if (altmsg.trim().length == 0) 
    return true;
    else {
        alert(altmsg);
        altmsg ="";
        return false;
    }
}



var number_comma = "^[0-9:]+$";
var valid_single_port_arr=[];
var valid_range_port_arr=[];
var duplicatePorts = [];
var duplicateRanges = [];
var invalidPorts = [];
var invalidRangemsg = [];
var overlapmsg="";
function sortRange(valid_range_port_arr)
{
    for(var i=0;i<valid_range_port_arr.length;i++)
    {
        for(var j=i;j<valid_range_port_arr.length;j++)
        {
            var porti = valid_range_port_arr[i];
            var portj = valid_range_port_arr[j];
            var porti_arr = porti.split(":");
            var portj_arr = portj.split(":");
            if((parseInt(porti_arr[0]) <= parseInt(portj_arr[0]) && parseInt(porti_arr[1]) >= parseInt(portj_arr[1])) 
                || (parseInt(porti_arr[0]) > parseInt(portj_arr[0]) && parseInt(porti_arr[1]) >= parseInt(portj_arr[1])))
            {

                valid_range_port_arr[i] = portj;
                valid_range_port_arr[j] = porti;
            }
        }
    }
}
function checkPortOverlaps(currange,pos)
{
    // alert("currange: "+currange+" pos: "+pos);
    var port_overlaps="";
    var cur_port_rng = currange.split(":");
    for(var i=0;i<valid_single_port_arr.length;i++)
    {
        var chk_port = valid_single_port_arr[i];
        if((parseInt(cur_port_rng[0])<=parseInt(chk_port)) && (parseInt(chk_port) <=parseInt(cur_port_rng[1])))// 
        {
            //if(overlapmsg.length > 0)
                //overlapmsg +=", ";
            if(!(overlapmsg.includes(chk_port+",") || overlapmsg.includes(chk_port+" ")))
            {
            if(port_overlaps.length > 0)
                port_overlaps +=",";
            port_overlaps += chk_port;
            }   
        }
    }

    for(var i=0;i<pos;i++)
    {
        var chk_port = valid_range_port_arr[i];
        var chk_port_rge = chk_port.split(":");
        if(((parseInt(cur_port_rng[0])<=parseInt(chk_port_rge[0]) && parseInt(chk_port_rge[0]) <=parseInt(cur_port_rng[1])) || 
                        (parseInt(chk_port_rge[0]) <= parseInt(cur_port_rng[0]) && parseInt(cur_port_rng[0]) <= parseInt(chk_port_rge[1]))))
        {
            if(!(overlapmsg.includes(chk_port+",") || overlapmsg.includes(chk_port+" ")))
            {
                if(port_overlaps.length > 0)
                    port_overlaps +=",";
                port_overlaps += chk_port;
            }   
        }
    }

    if(port_overlaps.length > 0)
    {
        if(overlapmsg.length > 0)
            overlapmsg += ", ";
        overlapmsg += port_overlaps;
        if(port_overlaps.includes(','))
            overlapmsg += " are "; 
        else
            overlapmsg += " is ";
        overlapmsg += "overlaps with "+currange; 

    }
    
    return false;
}
function validateRules()
{
    valid_single_port_arr=[];
    valid_range_port_arr=[];
    duplicatePorts = [];
    duplicateRanges = [];
    invalidPorts = [];
    invalidRangemsg = [];
    dest_addr_arr = [];
    altmsg="";
    overlapmsg="";
    try{
        // rules page
        var table = document.getElementById("destaddrtab");
        var tabledesrow = table.rows;
        var dest_addr_arr = [];
        for(var i=0;i<tabledesrow.length;i++)
        {
            var descols = tabledesrow[i].cells;
            var destaddrobj = descols[1].childNodes[0].childNodes[0];
            var destaddrval =destaddrobj.value.trim();
            var destipvaild = validateIPOnly(destaddrobj.id,true,'Destination Address');
            if(!destipvaild)
            {
                if(destaddrval!="")
                    altmsg +="Destination Address in the row "+(i+1)+" not vaild\n";
                else
                    destaddrobj.style.outline="initial";
            }
            if(destipvaild)
            {
                for(dest=0;dest<dest_addr_arr.length;dest++)
                {
                    if(dest_addr_arr[dest].value == destaddrval)
                    {
                        destaddrobj.style.outline = "thin solid red";
                        dest_addr_arr[dest].style.outline = "thin solid red";
                        altmsg += "Duplicate Destination Address "+destaddrval+"\n";
                        break;
                    }
                }
                if(dest==dest_addr_arr.length)
                    dest_addr_arr.push(destaddrobj);
            }
        }

        var sticyval = document.getElementById("sticky").value.trim();
        if(sticyval == "Yes")
        {
            var stictimeobj = document.getElementById("stimeout");
            if(stictimeobj.value.trim() == "")
            {
                altmsg += "Sticky Timeout should not be empty\n";
                stictimeobj.style.outline="thin solid red";
            }
            else
                stictimeobj.style.outline="initial";
        }
        
        var depoobj = document.getElementById("dport");
        depoobj.style.outline = "initial";
        var depoval = depoobj.value.trim();
        var deposplit = depoval.split(",");
        if (depoval != "") {
            if (depoval.endsWith(",") || depoval.startsWith(",") || depoval.endsWith(":") || depoval.startsWith(":")) {
                altmsg += "Port number should not starts with and ends with ',' or ':'\n";
                depoobj.style.outline = "thin solid red";
            } 
            // else if(depoval.endsWith(":") || depoval.startsWith(":")) {
            //     altmsg += "port number should not start or end with ':'\n";
            //     depoobj.style.outline="thin solid red";
            // }
            else {
                for (var i = 0; i < deposplit.length; i++) 
                {
                    if ((deposplit[i].length == 0) && (!altmsg.includes("Port number should not be empty"))) {
                        altmsg += "Port number should not be empty\n";
                        depoobj.style.outline = "thin solid red";
                        continue;
                    }
                    var in_valid = deposplit[i].match(number_comma);
                    if (deposplit[i] != "") 
                    {

                        if (!in_valid) {
                            invalidPorts.push(deposplit[i]);
                        } else {
                            
                            var portRange = deposplit[i].split(":");
                            if(portRange.length == 2) {
                                var startPort = parseInt(portRange[0]);
                                var endPort = parseInt(portRange[1]);

                                if((deposplit[i].startsWith(':') || deposplit[i].endsWith(':')))
                                {
                                    if((!altmsg.includes("Start range and end range should not be empty in Port Range")))
                                    {
                                        altmsg += "Start range and end range should not be empty in Port Range\n";
                                        depoobj.style.outline = "thin solid red";
                                    }
                                    continue;
                                }
                                
                                if (startPort < 1 || startPort > 65535 || endPort < 1 || endPort > 65535) {
                                     if(!invalidRangemsg.includes(deposplit[i]))
                                        invalidRangemsg.push(deposplit[i]);
                                    depoobj.style.outline = "thin solid red";
                                    continue;
                                } 
                                else if ((startPort > endPort) && (!altmsg.includes("Start range should not be greater than end range in Destination Port"))) {
                                    altmsg += "Start range should not be greater than end range in Destination Port \n";
                                    depoobj.style.outline = "thin solid red";
                                    continue;
                                }
                                else if((startPort == endPort) && (!altmsg.includes("Start and end range of the port should not same in Destination Port")))
                                {
                                    altmsg += "Start and end range of the port should not same in Destination Port\n";
                                    depoobj.style.outline = "thin solid red";
                                    continue;
                                }
                            }
                            else if(portRange.length > 2)
                            {
                                invalidPorts.push(deposplit[i]);
                                depoobj.style.outline = "thin solid red";
                                continue;
                            }

                            var portNumber = parseInt(deposplit[i]);
                            if ((portNumber < 1 || portNumber > 65535) && (!altmsg.includes("Port number should be in the range '1-65535'"))) {
                                altmsg += "Port number should be in the range '1-65535'\n";
                                depoobj.style.outline = "thin solid red";
                                continue;
                            }
                            if ((valid_single_port_arr.includes(deposplit[i]) || valid_range_port_arr.includes(deposplit[i])) && (!duplicatePorts.includes(deposplit[i]))) {
                                duplicatePorts.push(deposplit[i]);
                                continue;
                            } 
                            else
                            { 
                                if(deposplit[i].includes(":"))
                                    valid_range_port_arr.push(deposplit[i]);
                                else
                                    valid_single_port_arr.push(deposplit[i]);
                            }
                   
                            // if(checkPortOverlaps(deposplit[i]))
                            // {
                            //     depoobj.style.outline = "thin solid red";
                            // }
                        }
                    }
                }
                sortRange(valid_range_port_arr);
                // alert("range arr : "+valid_range_port_arr);
                for(var i=valid_range_port_arr.length-1;i>=0;i--)
                {
                    checkPortOverlaps(valid_range_port_arr[i],i);
                    depoobj.style.outline = "thin solid red";
                }
                if(overlapmsg!="")
                {
                    altmsg += overlapmsg+"\n";
                }
            }
        }
        
        // Print all duplicate port numbers and ranges in a single line
        if (duplicatePorts.length > 0 || duplicateRanges.length > 0 || invalidPorts.length > 0 || invalidRangemsg.length>0) {
            if (duplicatePorts.length > 1) 
                altmsg += "Destination ports " + duplicatePorts.join(", ") + " already exists\n";
            if (duplicatePorts.length == 1) 
                altmsg += "Destination port " + duplicatePorts.join(", ") + " already exists\n";
            if (duplicateRanges.length > 0) 
                altmsg += "Port ranges " + duplicateRanges.join(", ") + " are Overlaps\n";
            if (invalidPorts.length > 1)
                altmsg += "Destination Ports "+invalidPorts.join(", ")+" are Invalid\n";
            if (invalidPorts.length == 1)
                altmsg += "Destination Port "+invalidPorts.join(", ")+" is Invalid\n";
            if(invalidRangemsg.length >1)
                altmsg += "Port number range " + invalidRangemsg.join(", ") + " are not valid\n";
            if(invalidRangemsg.length == 1)
                altmsg += "Port number range " + invalidRangemsg.join(", ") + " is not valid\n";


            depoobj.style.outline = "thin solid red";
        }
        
        var rulinstobj = document.getElementById("rulname");
        if(rulinstobj.value.trim()!="")
        {
            var poliasobj = document.getElementById("poliassign");
            if(poliasobj.value.trim()=="")
            {
                altmsg += "Policy Assigned should not be empty\n";
                poliasobj.style.outline="thin solid red";
            }
            else
                poliasobj.style.outline="initial";
        }

    }catch(e){
        alert(e);
    }
    if (altmsg.trim().length == 0) 
    return true;
    else {
        alert(altmsg);
        altmsg ="";
        return false;
    }
}
















