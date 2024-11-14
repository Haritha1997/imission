<%@page import="com.nomus.m2m.pojo.License"%>
<%@page import="com.nomus.m2m.dao.LicDao"%>
<%@page import="com.nomus.m2m.pojo.SlNumbersRange"%>
<%@page import="com.nomus.m2m.dao.OrganizationDataDao"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.nomus.m2m.dao.UserDao"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Set"%>
<%@page import="com.nomus.staticmembers.UserRole"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.nomus.staticmembers.Symbols"%>
<%@page import="com.nomus.m2m.dao.NodedetailsDao"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="com.nomus.m2m.pojo.NodeDetails"%>
<%@page import="com.nomus.m2m.dao.OrganizationDao"%>
<%@page import="com.nomus.m2m.pojo.Organization"%>
<%@page import="java.util.List"%>
<%@page language="java" contentType="text/html" session="true"%>

<jsp:include page="/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="New User" />
	<jsp:param name="headTitle" value="New" />
	<jsp:param name="breadcrumb"
		value="<a href='imission/user/index.jsp'>Users and Groups</a>" />
	<jsp:param name="breadcrumb"
		value="<a href='/imission/user/list.jsp'>User List</a>" />
	<jsp:param name="breadcrumb" value="New User" />
</jsp:include>
<%
	User user = (User) session.getAttribute("loggedinuser");
	UserDao udao = new UserDao();
	SimpleDateFormat formDate = new SimpleDateFormat("dd-MM-yyyy");
	String strDate = formDate.format(new Date());
	String status = request.getParameter("status");
	String username = session.getAttribute("username")==null?"":session.getAttribute("username").toString();
	String password = session.getAttribute("pass1")==null?"":session.getAttribute("pass1").toString();
	String conpwd = session.getAttribute("pass2")==null?"":session.getAttribute("pass2").toString();
	String email = session.getAttribute("email")==null?"":session.getAttribute("email").toString();
	String role = session.getAttribute("sel_role")==null?"":session.getAttribute("sel_role").toString();
	String under = session.getAttribute("under")==null?"":session.getAttribute("under").toString();
	User curuser = udao.getUserByUsername(username);
	if(session.getAttribute("username")!=null)
		session.removeAttribute("username");
	if(session.getAttribute("pass1")!=null)
		session.removeAttribute("pass1");
	if(session.getAttribute("pass2")!=null)
		session.removeAttribute("pass2");
	if(session.getAttribute("email")!=null)
		session.removeAttribute("email");
	if(session.getAttribute("sel_role")!=null)
		session.removeAttribute("sel_role");
	if(session.getAttribute("under")!=null)
		session.removeAttribute("under");
	User selAdmin = null;
	if(under.length() > 0)
	selAdmin = udao.getUser(Integer.parseInt(under));
	User newUser = udao.getUserByUsername(username);
	/* if(username.length() > 0)
		newUser = udao.getUser(Integer.parseInt(username)); */
	/* List<User> userlist = udao.getUsersListUnderCurrentUser(user);
	int supcnt=0;
	int moncnt=0;
	for(User curuser : userlist)
	{
		if(curuser.getRole().equals(UserRole.SUPERVISOR))
			supcnt++;
		else if(curuser.getRole().equals(UserRole.MONITOR))
			moncnt++;
	}
	System.out.println("Supervisor count is : "+supcnt);
	System.out.println("Monitor count is : "+moncnt); */
	if(status == null)
	{
		if(session.getAttribute("status") != null)
		{
			status =  session.getAttribute("status").toString();
		 	session.removeAttribute("status");
		}
	}
	else
		session.removeAttribute("status");
	status = status==null?"":status;
	LicDao ldao = new LicDao();
	License lic = ldao.getLicenseDetails();
%>

<head>

<link rel="stylesheet" href="/imission/css/jquery-ui.css">
<link rel="stylesheet" href="/imission/css/style.css">
<script src="/imission/js/jquery.js"></script>
<script src="/imission/js/jquery-ui.js"></script>
<script type="text/javascript" src="/imission/m2m/wizngv2/js/common.js"></script>
<style>
.tab {
	border: 1px solid #ddd;
}

th {
	height: 30px;
	background-color: #7BC342;
	text-align: center;
}

td {
	padding-left: 10px;
}
#borderbot
{
width:100%;
height:100%;
background-color:white;

}
.btn {
	padding-left: 10px;
	padding-top:2px;
	padding-bottom:2px;
	margin-top:3px;
	width:80px;
}

.form-group {
	margin: 10px;
}

#slsearch,#locsearch
{	
	text-align:left;
	padding-left:23px;
	outline:none;
}
.noneditcb
{
	cursor: pointer;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  outline: 0;
  background: blue;
  height: 16px;
  width: 16px;
  border: 1px solid white;
  color: white;
}
#sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0px;
  z-index: 1;
}
#stickyposition
{
    position: -webkit-sticky;
  position: sticky;
  top: 30px;
  z-index: 1;
}
input[type="checkbox"] {
accent-color: #7BB342;
}
.content {
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 500px;
	height: 250px;
	background-color: #e8eae6;
	box-sizing: border-box;
	z-index: 100;
	overflow-y: scroll;
	display: none;
	/*to hide popup initially*/
}
#rangetab {
	margin-top: 20px;
	align: center; 
}
.Popup
{
    text-align:left;
    position: absolute;
    left: 85%;
    z-index:50;
    width: 180px;
    background-color: #DCDCDC;
    border:2px solid black;
    border-radius: 4%;
}
</style>
<script src="/imission/js/jquery.js"></script>
<script src="/imission/js/jquery-ui.js"></script>
<script src="/imission/js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/imission/m2m/wizngv2/js/common.js"></script>
<script type="text/javascript">
var stslnums="";
var stlocs="";
const ranmap = new Map();
function showOrHidePWDInfo(id) 
{
	var dialog = document.getElementById('pwdinfo');
	if(dialog.open)
		dialog.close();
	else
		dialog.show();
	return dialog;
}
function hideUnDiscoveMsg()
{
	document.getElementById('ndpara').style.display = 'none';
}
function showAlert(altdata,newline)
{
	altdata = altdata.replaceAll(newline,"\n");
	alert(altdata);
}
$.noConflict();
function togglePopup(type) {
	if (type == "cancel") {
		$(".content").toggle();
		return;
	}
}
$(function() {
    $( "#valid_upto" ).datepicker({
        changeMonth: true,
        changeYear: true,
        minDate: 0,
		dateFormat: 'dd-mm-yy'
    });
});
$(document).on('click', '.toggle1-password', function () {
	$(this).toggleClass("fa-eye fa-eye-slash");
	var input = $("#pass1");
	input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
});
$(document).on('click', '.toggle2-password', function () {
	$(this).toggleClass("fa-eye fa-eye-slash");
	var input = $("#pass2");
	input.attr('type') === 'password' ? input.attr('type', 'text') : input.attr('type', 'password')
});
function doFilter(tableid,searchid)
{  
	 var $cols = $('#'+tableid+' #rowdata #coldata');
     var val = $.trim($('#'+searchid).val()).replace(/ +/g, ' ').toLowerCase();
     $cols.show().filter(function() {
         var text = $(this).text().replace(/\s+/g, ' ').toLowerCase();
         return !~text.indexOf(val);
     }).hide();
     
}
function digitWithPlusOnly(e) {
    var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
    if ((keyCode == 45)||(keyCode >= 48 && keyCode <= 57)) {
        return true;
    }
    return false;
}
function setSelLocNodecolors()
{
	  var table = document.getElementById("loc_table");
		var tablerows = table.rows;
			for (var i = 2; i < tablerows.length; i++) {
			var cols = tablerows[i].cells;
			for(var k=0;k<cols.length;k++) {
				var obj = cols[k].childNodes[0];
				var nodecols= document.getElementsByClassName(obj.value);
				var nodecblist= document.getElementsByClassName(obj.value+"cb"); 
		 	    for (var j = 0; j < nodecols.length; j++) 
		 	    {
				 	 if(obj.checked)
				 	 {
			 	    	nodecols[j].style.backgroundColor="#98FB98";
				 		nodecblist[j].checked = true;
		 	    	 }
			 	 }
			}
		}
}
function unselslnumbers(startrange,endrange,delimeter)
{
	try
	{
		var table = document.getElementById("slnum_table");
		var tablerows = table.rows;
		for(var i=2;i<tablerows.length;i++)
	    {
			
			var cols = tablerows[i].cells;
			for(var k=0;k<cols.length;k++) {
				var obj = cols[k].childNodes[0];
				if(obj.value>=startrange && obj.value<=endrange)
				{
	  				obj.checked = false;
	  				stslnums=stslnums.replace(obj.value+delimeter,"");
	  			}
			}
	    }
	}
	catch(e){
		alert(e);
	}
}
function selslnumbers(startrange,endrange,delimeter)
{
	try
	{
	var table = document.getElementById("slnum_table");
	//var startrange = document.getElementById(startid).value;
	//var endrange = document.getElementById(endid).value;
	var tablerows = table.rows;
	for(var i=2;i<tablerows.length;i++)
    {
		
		var cols = tablerows[i].cells;
		for(var k=0;k<cols.length;k++) {
			var obj = cols[k].childNodes[0];
			if(obj.value>=startrange && obj.value<=endrange)
			{
  				obj.checked = true;
  				stslnums+=obj.value+delimeter;
  			}
		}
				
    }
	}
	catch(e){
		alert(e);
	}
	
}
  function validateFormInput() 
  {
	altmsg="";
	const date = new Date();
	const yyyy = date.getFullYear();
	let mm = date.getMonth() + 1; // Months start at 0!
	let dd = date.getDate();

	if (dd < 10) dd = '0' + dd;
	if (mm < 10) mm = '0' + mm;

	const formattedToday = dd + '-' + mm + '-' + yyyy;
    var id = new String(document.newUserForm.username.value);
    var usernameobj=document.getElementById("username");
    if(usernameobj.value.trim()=="")
    	altmsg+="Username Should Not be Empty!\n";
    else if(usernameobj.value.includes(" "))
    	altmsg += "Username Should Not Contain Spaces!\n";
	var passwordobj=document.getElementById("pass1");
	var cnfmpwd=document.getElementById("pass2");
	var validpwd=pwdCheck("pass1","NewUser");
	//var paswdformat="^(?=.*)"+ "(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])"+ "(?=.*[!@$^&*()])"+ "(?=\\S+$).{8,}$";

    if(passwordobj.value.trim()=="")
    	altmsg+="Password Should Not be Empty!\n";
    else if(passwordobj.value.includes(" "))
    	altmsg += "Password Should Not Contain Spaces!\n";
    else if(usernameobj.value.trim() !="" && passwordobj.value.toLowerCase().trim().startsWith(usernameobj.value.trim()))
    	altmsg += "Password should not start with Username!\n";
    else if(passwordobj.value.length<8)
    	altmsg+="Password must contain at least 8 or more characters!\n";
    else if(!validpwd)
    	altmsg+='Password must contain at least one number and one uppercase and lowercase letter and Use Special Characters except " , '+" :  , '  and  ;\n";
    else if(passwordobj.value.trim()!=""&&cnfmpwd.value.trim()=="")
    	altmsg+="Confirm Password Should Not be Empty!\n";
    else if (document.newUserForm.pass1.value != document.newUserForm.pass2.value)
    {
      altmsg+="Password  doesn't match!\n";
      document.newUserForm.pass1.value = "";
      document.newUserForm.pass2.value = "";
    }
    var emaildobj=document.getElementById("email");
    emailformat=/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    if(emaildobj.value.trim()=="")
    	altmsg+="Email Should Not be Empty!\n";
    else if(!emaildobj.value.match(emailformat))
    	altmsg+="Invalid Email!\n";
    else if(emaildobj.value.includes(" "))
      	altmsg += "Email Should Not Contain Spaces!\n";
    <%if(user.getRole().equals(UserRole.MAINADMIN)){%>
    	var	orgobj = document.getElementById("org_name");
    	var validobj = document.getElementById("valid_upto");
    	var nodelimit = document.getElementById("nodes_limit");
    	var noofusers = document.getElementById("no_of_users");
    	var parts1 = formattedToday.split("-");
    	var parts2 = validobj.value.trim().split("-");
    	var latest = false;
    	if (parseInt(parts1[2]) > parseInt(parts2[2])) {
    	    latest = true;
    	} else if (parseInt(parts1[2]) == parseInt(parts2[2])) {
    	    if (parseInt(parts1[1]) > parseInt(parts2[1])) {
    	        latest = true;
    	    } else if (parseInt(parts1[1]) == parseInt(parts2[1])) {
    	        if (parseInt(parts1[0]) > parseInt(parts2[0])) {
    	            latest = true;
    	        } 
    	    }
    	}
    	//var userobj = document.getElementById("no_of_users");
    	if(orgobj.value.trim() == "")
    		altmsg += "Organization Should Not Be Empty!\n";
    	else if(orgobj.value.includes(" "))
    		altmsg += "Organization Should Not Contain Spaces!\n";
    	if(validobj.value.trim() == "")
    		altmsg += "Valid Upto Should Not Be Empty!\n";
    	else if(!isValidDateFormat(validobj.value.trim()))
 	    	altmsg+="Invalid Valid Upto!\n";
    	else if(latest)
    		altmsg += "Valid Upto Should Not Be less than current date!\n";
    	 if(noofusers.value > 5)
    		altmsg += "No of Users cannot exceed 5!\n"; 
    	if(nodelimit.value.trim() == "")
    		altmsg += "Nodes Limit Should Not Be Empty!\n";
    	if(noofusers.value.trim() == "")
    		altmsg += "No of Users Should Not Be Empty!\n";
    <%}
    else if(user.getRole().equals(UserRole.SUPERADMIN))
{%>
var underobj = document.getElementById("under");
var selobj = document.getElementById("sel_role");
	if(underobj.value.trim() == "" && selobj.value!="admin")
		altmsg += "Under Should Not Be Empty!\n";
	
<%}%>
    if (altmsg.trim().length == 0)
    {
        document.getElementById("selloc").value = stlocs;
        document.getElementById("selslnums").value = stslnums;
    	return true;
    }
    else {
       alert(altmsg);
       return false;
    }
  }    
  function cancelUser()
  {
      window.location.href = "list.jsp";
  }
  function hideLocSlnums()
  {
	  var selobj=document.getElementById("sel_role");
	  var loctab=document.getElementById("loc_table");
	  var slnumtab=document.getElementById("slnum_table");
	  var underdivobj = document.getElementById("underdiv");
	  if(selobj.value == "superadmin")
	  {
		  loctab.style.display="none";
		  slnumtab.style.display="none";
	  }
	  else 
	  {
		  loctab.style.display="";
		  slnumtab.style.display="";
	  }
	  if(selobj.value == 'admin' || selobj.value == 'superadmin')
		  underdivobj.hidden = true;
	  else
		  underdivobj.hidden = false;
  }
  function setLocNodecolors(locobj,remove,delimeter)
  {
	  //alert("in the setLocNodecolors"+locobj+" "+remove);
		var nodecols= document.getElementsByClassName(locobj.value);
		var nodecblist= document.getElementsByClassName(locobj.value+"cb");
		
 	    for (var j = 0; j < nodecols.length; j++) 
 	    {
 	    	//alert("in the setLocNodecolors"+nodecols[j])
		 	 if(locobj.checked)
		 	{
	 	    	nodecols[j].style.backgroundColor="#98FB98";
	 	    	
		 	}
		 	 else
		 		nodecols[j].style.backgroundColor="white";
	 	 }
 	    for (var j = 0; j < nodecols.length; j++) 
 	    {
 	    	var val=nodecblist[j].value;
		 	 if(locobj.checked)
		 	{
		 		nodecblist[j].checked = true;
		 		//stslnums+=val+delimeter;
		 	}
		 	 else if(remove)
		 	 {
		 		nodecblist[j].checked = false;
		 		stslnums=stslnums.replace(val+delimeter,"");
		 	 }
	 	 }
  }
function checkBoxEvent(id,delimeter,type) {
	var ckbox = document.getElementById(id); 
	var val=ckbox.value;
	if(type=="slnumber")
	{
		if(ckbox.checked)
			stslnums+=val+delimeter;
		else
			stslnums=stslnums.replace(val+delimeter,"");
	}
	else if(type = "location")
	{
		if(ckbox.checked)
			stlocs+=val+delimeter;
		else
			stlocs=stlocs.replace(val+delimeter,"");
		setLocNodecolors(ckbox,true,delimeter);
	}
} 
function checkAll(tableid,searchid,delimeter)
{
	var table = document.getElementById(tableid);
	var tablerows = table.rows;
	var searchval = document.getElementById(searchid).value.toLowerCase();
		for (var i = 2; i < tablerows.length; i++) {
			var cols = tablerows[i].cells;
			for(var k=0;k<cols.length;k++) {
				var obj = cols[k].childNodes[0];
			 	 if(obj.value.toLowerCase().includes(searchval))
			 		 {
				  obj.checked = true;
				  if(tableid == 'loc_table')
					   {
			  		stlocs+=obj.value+delimeter;
			  		setLocNodecolors(obj,false,delimeter);
					   }
				   else
					   {
				  		stslnums+=obj.value+delimeter;
				  	//setLocNodecolors(obj,true,delimeter);
					   }
			 		 }
		}
	}
}
function uncheckAll(tableid,searchid,delimeter)
{
	try
	  {
	var table = document.getElementById(tableid);
	var tablerows = table.rows;
	var searchval = document.getElementById(searchid).value.toLowerCase();
	/* var startid = document.getElementById("startrange");
	var endid = document.getElementById("endrange");
	startid.value="";
	  endid.value=""; */
		for (var i = 2; i < tablerows.length; i++) {
			var cols = tablerows[i].cells;
			for(var k=0;k<cols.length;k++) {
				var obj = cols[k].childNodes[0];
			 	 if(obj.value.toLowerCase().includes(searchval))
			 	{
				  obj.checked = false;
				  if(tableid == 'loc_table')
				  	  {
				  		stlocs=stlocs.replace(obj.value+delimeter,"");
				  		setLocNodecolors(obj,true,delimeter);
				  	  }
				  	  else
				  	  {
				 	  	stslnums=stslnums.replace(obj.value+delimeter,"");
				 		setLocNodecolors(obj,false,delimeter);
				  	  }
			 	}
			 	 
		}
	}
}
catch(e)
{
	  alert(e);
}
//addRangeOptions('rangetab','range');
//$(".content").toggle();
}
function showRangesWindow()
{
	$(".content").toggle();
}
 function hideRangesWindow()
{
	$(".content").toggle();
} 
var rangerow=1;
function addStartEndRangesRow(rowid)
{
	var table=document.getElementById("rangetab");
	var remove=document.getElementById("delete"+rowid);
	var add=document.getElementById("add"+rowid);
	if(add != null)
	add.style.display="none";
	if(remove != null)
	remove.style.display ="inline";
	rangerow++;
	$("#rangetab").append("<tr id=\"startendr"+rangerow+"\"><td><input type=\"text\" id=\"startrange"+rangerow+"\" name=\"startrange"+rangerow+"\" placeholder=\"111-11111-11\" onkeypress=\"return digitWithPlusOnly(event)\" style=\"width:120px;\" value=\"\" onfocusout=\"validateSerialNum('startrange"+rangerow+"', false, 'Start Range')\" maxlength=\"14\" onkeyup=\"setSerialNumHyphen('startrange"+rangerow+"')\"/></td><td><input type=\"text\" id=\"endrange"+rangerow+"\" name=\"endrange"+rangerow+"\" placeholder=\"222-22222-22\" onkeypress=\"return digitWithPlusOnly(event)\" style=\"width:120px;\" value=\"\" onfocusout=\"validateSerialNum('endrange"+rangerow+"', false, 'End Range')\" maxlength=\"14\" onkeyup=\"setSerialNumHyphen('endrange"+rangerow+"')\"/></td><td><label class=\"btn btn-default\" name=\"add"+rangerow+"\" id=\"add"+rangerow+"\" style=\"width:60px;\" onclick=\"addStartEndRangesRow("+rangerow+")\">ADD</label></td><td><label class=\"btn btn-default\" name=\"delete"+rangerow+"\" id=\"delete"+rangerow+"\" style=\"width:60px;\" onclick=\"deleteStartEndRangesTabRow("+rangerow+",'<%=Symbols.DELIMITER%>')\">Delete</label></td><input id=\"row"+rangerow+"\" value=\""+rangerow+"\" hidden=\"\"></tr>");
	document.getElementById("addrange_rwcnt").value = rangerow;
	adjtabFircol('rangetab');
			
}
function deleteStartEndRangesTabRow(row,delimeter)
{
	var startrange= document.getElementById("startrange"+row).value.trim();
	var endrange= document.getElementById("endrange"+row).value.trim();
	if(startrange != "" && endrange != "")
	{
		var table = document.getElementById("slnum_table");
	  	var tablerows = table.rows;
	  	for(var i=2;i<tablerows.length;i++)
	      {
		  		var cols = tablerows[i].cells;
		  		for(var k=0;k<cols.length;k++) {
		  			var obj = cols[k].childNodes[0];
		  			
		  			if(obj.value>=startrange && obj.value<=endrange)
		  			{
		  				 obj.checked = false;
						 stslnums=stslnums.replace(obj.value+delimeter,"");
		  			}
		  		}
	      }
	  	
	 }
	
	deleteStartEndRangesRow(row);
	findStartEndRangesLastRowAndDisplayRemoveIcon();
	adjtabFircol('rangetab');	
}
function deleteStartEndRangesRow(rowid)
{
	$('table#rangetab tr#startendr'+rowid).remove();
	adjtabFircol('rangetab');
}
function findStartEndRangesLastRowAndDisplayRemoveIcon()
{
	var table = document.getElementById("rangetab");
	var rows = table.rows;
	var lastrow = table.rows[table.rows.length-1];
	var addobj = lastrow.cells[2].childNodes[0];
	var removeobj;
  	if(rows.length == 1)
  		addobj.style.display="inline";		
  	else
  		removeobj = lastrow.cells[3].childNodes[0];
	if(lastrow.length == 2)
	{
		addobj.style.display="inline";
		removeobj.style.diaplay="none";
	}
	else
	{
		addobj.style.display="inline";
		removeobj.style.diaplay="inline";
	}
}
function adjtabFircol(tablename)
{
	var table = document.getElementById(tablename);
	var rows = table.rows;
	var index = 0;
	if(tablename == "rangetab")
		index = 1;
	if(rows.length==(index+1))
	{
		rows[index].cells[2].childNodes[0].style.display="inline";
		rows[index].cells[3].childNodes[0].style.display="inline";
	}
}
function uncheckOldSlnums()
{
	var keys = ranmap.keys();
	for(var ct=0;ct < ranmap.size;ct++)
	{
		var key = keys.next().value;
		unselslnumbers(key,ranmap.get(key),'<%=Symbols.DELIMITER%>');
	}
	ranmap.clear();
}
function addRangeOptions(tabname,sel)
{
	<%-- uncheckAll('slnum_table','slsearch','<%=Symbols.DELIMITER%>'); --%>
	uncheckOldSlnums();
	setSelLocNodecolors();
	try
	{
	var table =  document.getElementById(tabname);
	var selobj = document.getElementById(sel);
	var rows = table.rows;
	const namap = new Map();
	
	for(var i=selobj.options.length-1;i>=0;i--)
		selobj.remove(i);
	var altmsg = "";
	for(var i=1;i<rows.length;i++)
	{
		var cols = rows[i].cells;
		var startobj = cols[0].childNodes[0];
		var endobj=cols[1].childNodes[0];
		startobjval= startobj.value.trim();
		endobjval= endobj.value.trim();
		var startvalid =validateSerialNum(startobj.id, false, "Start Range");
		if (!startvalid) {
			if (startobjval == "") 
				altmsg += "Start Range in the row  "+i+" should not be empty \n";
			else 
				altmsg += "Start Range in the row  "+i+"  is not valid \n";
			}
		var endvalid =validateSerialNum(endobj.id, false, "End Range");
		if (!endvalid) {
			if (endobjval == "") 
				altmsg += "End Range in the row  "+i+" should not be empty \n";
			else 
				altmsg += "End Range in the row  "+i+"  is not valid \n";
			}
		/* var startvalsp=startobj.value.split("-");
		var endvalsp=endobj.value.split("-"); 
		var startvalid=startvalsp.length== 3&&startvalsp[0].length==3&&startvalsp[1].length>=5&&startvalsp[2].length==2;
		//var startvalid=CheckSerialnumbersInValid.isvalidSerialnumbers(startobj.value);
		var endvalid=endvalsp.length== 3&&endvalsp[0].length==3&&endvalsp[1].length>=5&&endvalsp[2].length==2;  */
		/* if(startobj.value== "" && endobj.value== "")
		  	continue; */
	if(startvalid&&endvalid)
		{
			if(((startobjval== "") &&(endobjval!="")) ||  ((startobjval!= "") &&(endobjval== ""))) {
			  		altmsg+="Please configure both start range and end range\n";
			  		continue;
			}
	  		else if(startobj.value>endobj.value)
	  			{
	  				altmsg+="Invalid Range from "+startobjval+" to "+ endobjval+"\n";
			  		continue;
	  			}
			var startval_i = startobj.value;
			var endval_i = endobj.value;
			for(var j=1;j<rows.length;j++)
			{
				var jcols = rows[j].cells;
		  		var startobj_j = jcols[0].childNodes[0];
		  		var endobj_j = jcols[1].childNodes[0];
		  		var startval_j = startobj_j.value.trim();
		  		var endval_j = endobj_j.value.trim();
		  		if(startval_i!="" && endval_i!="" && (startval_i == startval_j) && (endval_i == endval_j) && (i!=j))
		  		{
		  			if(!altmsg.includes("Duplicate Ranges : "+startval_i+" and "+endval_i))
		  				altmsg +="Duplicate Ranges : "+startval_i+" and "+endval_i+"\n";
		  		}
				
			}
			if(startobjval&&endobjval)
			{
				namap.set(startobjval+" to "+endobjval,startobjval+" to "+endobjval);
				ranmap.set(startobjval,endobjval);
				selslnumbers(startobjval,endobjval,'<%=Symbols.DELIMITER%>');
				var opt = document.createElement('option');
				opt.value = startobjval+" to "+endobjval;
				opt.innerHTML = startobjval+" to "+endobjval;
				if(namap.get(opt.value) != null)
					opt.selected = 'true';
				selobj.appendChild(opt);
				startobj.style.outline = "initial";
				endobj.style.outline = "initial";
				var keys = ranmap.keys();
			}
			/* else
				{
				if(startvalid)
				 {
					altmsg +="Serial Number in the row  "+i+" is Invalid "+endobjval+"\n";
					endobj.style.outline = "thin solid red";
				 }
				else if(endvalid)
				 {
					altmsg +="Serial Number in the row  "+i+" is Invalid "+startobjval+"\n";
					startobj.style.outline = "thin solid red";
				 }
				else if(!startvalid&&!endvalid)
					{
					altmsg +="Serial Number in the row  "+i+" is Invalid "+startobjval+" and "+endobjval+"\n";
					startobj.style.outline = "thin solid red";
					endobj.style.outline = "thin solid red";
					}
				
		}
		 */	
		}
	}
	if(altmsg.trim().length > 0) {
      alert(altmsg);
      return false;
   }
	$(".content").toggle();
	}
	catch(e)
	{
		alert(e);
	}
}		
function getSelAdminUserProps(currole)
{
	var role = document.getElementById("sel_role").value;
	if(role == 'superadmin' || currole != 'superadmin')
		return;
	let form = document.getElementById("newUserForm");
	form.action = "getAdminProps?action=new";
	form.submit();
}
function setSerialNumHyphen(id)
{ 
	$("#"+id).on("keyup", function(event) {
		var limitField = $(this).val().trim().length;
		//var limit = "12";

		if (event.keyCode != 8) {
			var sl_value = $(this).val().trim().concat('-');
			switch(limitField) {
				case 3:
				case 9:
					$("#"+id).val(sl_value);
				break;
			}
		}

		/* if (limitField > limit) {
			$("#"+id).val($(this).val().trim().substring(0, limit));
		} */
	});
}
</script>
</head>
<div class="panel panel-default">
	<div class="panel-heading">
		<%
			if ("redo".equals(request.getParameter("action"))) {
		%>
		<h3 class="panel-title">
			The user
			<%=request.getParameter("username")%>
			already exists. Please type in a different user ID.
		</h3>
		<%
			} else {
		%>
		<h3 class="panel-title">Please enter a username and password
			below</h3>
		<%
			}
		%>
	</div>
	<div class="panel-body">
		<form class="form-horizontal" role="form" id="newUserForm"
			method="post" name="newUserForm" action="UserController?action=save"
			onsubmit="return validateFormInput();">
			<div class="form-group">
				<label for="username" class="col-sm-2 control-label">Username:</label>
				<div class="col-sm-4">
					<input id="username" type="text" name="username" value="<%=username%>" style="width:300px;background-color: white;cursor:auto"
						class="form-control" autocomplete="off"  readonly 
    onfocus="this.removeAttribute('readonly');" onkeypress="return avoidSpace(event)">
				</div>
				
				<%if(user.getRole().equals(UserRole.MAINADMIN)){%>
					<label for="organization" class="col-sm-2 control-label">Organization:</label>
					<div class="col-sm-3">
						<input type="text" id="org_name" name="org_name" style="width: 300px"
							class="form-control" onkeypress="return avoidSpace(event)" />
					</div> 
				<%} else if(user.getRole().equals(UserRole.SUPERADMIN)) {
					List<User> adminlist = udao.getActiveAdminUsers(user);%>
					<div id="underdiv" hidden>
						<label for="under" class="col-sm-2 control-label">Under:</label>
						<div class="col-sm-4">
							<select id="under" name="under" style="width: 300px" 
								class="form-control" onchange="getSelAdminUserProps('<%=user.getRole()%>')">
						   	<%for(User admin: adminlist)
						   	{
						    %>
								<option value=<%=admin.getId()%> <%if(under.equals(admin.getId()+"")){%>selected<%}%>><%=admin.getUsername()%></option>
							<%}%>	
							</select>
						</div>
					</div> 
				<%}%>
			</div>
			<div class="form-group">
				<label for="pass1" class="col-sm-2 control-label">Password:</label>
				<div class="col-sm-4">
					<input id="pass1" type="password" name="pass1" autocomplete="off"  readonly 
    onfocus="this.removeAttribute('readonly');" class="form-control col-sm-6" style="width:300px;background-color: white;cursor:auto" value="<%=password%>" onkeypress="return avoidSpace(event)" onkeyup="checkPwdStrength('pass1','pwdstr')" onfocusout="pwdCheck('pass1','NewUser');checkPwdStrength('pass1','pwdstr');"  />
				<span toggle="#password-field"  class="fa fa-fw fa-eye field_icon toggle1-password col-sm-3 control-label" ></span>
				 <img  src="/imission/m2m/wizngv2/images/i_sym.jpg" alt="i" title="Info" id="pwdshow" class="col-sm-1 control-label" style="padding-right:2px;" onclick="showOrHidePWDInfo('pwdinfo')"/>
					<dialog id="pwdinfo" class="Popup" style="border:1px dotted black;">  
						<p>Password must contain:</p><p>&#8226;Minimum 8 Characters</p><p>&#8226;One Numeric(0-9)</p><p>&#8226;One Uppercase Letter(A-Z)</p>
						<p>&#8226;One Lowercase Letter(a-z)</p><p>&#8226;One Special Character</p><p>&#8226;Excluded characters " ' : ? ;</p>
                     </dialog>
				<span id="pwdstr" class="col-sm-1 control-label" style="padding-right:2px;"></span>
				</div>
				<%if(user.getRole().equals(UserRole.MAINADMIN)){%>
					<label for="limit" class="col-sm-2 control-label">Nodes Limit:</label>
					<div class="col-sm-3">
						<input type="number" id="nodes_limit" name="nodes_limit" min="0" value="<%=lic.getNodeLimit() %>" max="<%=lic.getNodeLimit() %>" style="width:300px" onkeypress="return avoidSpace(event)"
							class="form-control" onfocusout="userDefaultValue()" />
					</div>
				<%}%>
			</div>
			<div class="form-group col1">
				<label for="pass2" class="col-sm-2 control-label">Confirm Password:</label>
				<div class="col-sm-4">
					<input id="pass2" type="password" name="pass2" value="<%=conpwd%>" autocomplete="off"  readonly 
    onfocus="this.removeAttribute('readonly');" class="form-control col-sm-6" style="width:300px;background-color: white;cursor:auto" onkeypress="return avoidSpace(event)"  title="Password must contain at least one number and one uppercase and lowercase letter and Special Character, and at least 8 or more characters"/>
					<span toggle="#password-field"  class="fa fa-fw fa-eye field_icon toggle2-password col-sm-3 control-label"></span>
				</div>
				<%if(user.getRole().equals(UserRole.MAINADMIN)){%>
					<label for="no_of_users" class="col-sm-2 control-label">No of Users:</label>
					<div class="col-sm-3">
						<input type="number"  min="0" value="2" id="no_of_users" name="no_of_users" class="form-control" style="width:300px" onkeypress="return avoidSpace(event)" />
					</div>
				<%}%>
			</div>
			<div class="form-group col1">
				<label for="email" class="col-sm-2 control-label">Email ID:</label>
				<div class="col-sm-4">
					<input id="email" type="text" name="email" value="<%=email%>" class="form-control" onkeypress="return avoidSpace(event)" style="width:300px">
				</div>
				<%if(user.getRole().equals(UserRole.MAINADMIN)){%>
					<label for="valid" class="col-sm-2 control-label">Organization Valid
						Upto:</label>
					<div class="col-sm-3">
						<!-- <input type="text" class="datepicker" id="valid_upto" name="valid_upto" />  -->
						<input type="text" class="form-control datepicker" id="valid_upto" name="valid_upto" value='<%=strDate%>' style="width:300px" placeholder="dd-mm-yyyy"/>
					</div>
				<%}%>
			</div>
			<div class="form-group col1">
				<label for="role" class="col-sm-2 control-label">Role:</label>
				<div class="col-sm-3">
					<select id="sel_role" name="sel_role" style="width:300px"
						class="form-control" onchange="hideLocSlnums();getSelAdminUserProps('<%=user.getRole()%>');">
				   <%HashMap<String,String> roles_hm = UserRole.getRolesHM(user);
				     Set<String> keyset = roles_hm.keySet();
				   	for(Object urole : keyset)
				   	{
				   %>
						<option value=<%=urole%> <%if(urole.equals(role)){%> selected<%}%> ><%=roles_hm.get(urole)%></option>
					<%}%>	
					</select>
				</div>
				<%if(!user.getRole().equals(UserRole.MAINADMIN)){%>
				<div>
					<div class="col-sm-7">
						<p id="ndpara"><b>Note: The brown colored serial numbers are not discovered yet.</b></p>
					</div>
				</div> 
				<%}%>	
			</div>
			
			<%if(!user.getRole().equals(UserRole.MAINADMIN)){%>
			<table width="100%" align="center" id="loc_sl_tab" name="loc_sl_tab">
				<tr>
					<td class="col-sm-5" style="float: left; padding-right: 5px;" >
						<div style="height:200px;overflow-y:scroll;scrollbar-width:thin;">	
						<table id="loc_table" width="100%" style="float: left;" class="tab" >
							
							<tr id="sticky">
								<th colspan="5">Location</th>
							</tr>
							<tr style="border:1px solid #7BC342; border-radius: 5px;" id="stickyposition">
								<th colspan="2">
								<div id="borderbot" style="float:left">
								<label style="float:left;padding-left:10px;"><label class="btn btn-default" name="loc_sel_all" id="loc_sel_all" onclick="checkAll('loc_table','locsearch','<%=Symbols.DELIMITER%>')">&nbsp;&nbsp;All</label>&nbsp;&nbsp;
								<label class="btn btn-default" name="loc_none" id="loc_none" onclick="uncheckAll('loc_table','locsearch','<%=Symbols.DELIMITER%>')">&nbsp;&nbsp;None</label></label>
								</div>
								</th>
								<th colspan="2">
									<div id="borderbot"class="input-icons" style="float:right;padding-right:5px;text-align: right">
										<span><i class="fa fa-search icon"></i><input class="input-field" type="text" title="search" id="locsearch"  style="width:150px;float:right;" onkeyup="doFilter('loc_table','locsearch')" onkeydown="doaction(event)"></span>
									</div>
								</th>
							</tr>
							
							<%
								NodedetailsDao ndao = new NodedetailsDao();
							
								List<String> loclist = null;
								if(selAdmin == null || role == null || role.equals(UserRole.ADMIN))
									loclist = ndao.getLocations(user);
								else
									loclist = ndao.getLocations(selAdmin);
								int count = 0;
								for (String location : loclist) {
									if (count % 4 == 0) {
										if (count != 1) {
								}
							%>
							
							<tr id="rowdata">
								<%
									}
								%>
								<td id="coldata" ><input type="checkbox" id="<%=location%>" name="<%=location%>" value="<%=location%>" onclick="checkBoxEvent('<%=location%>','<%=Symbols.DELIMITER%>','location')"> <label><%=location%></label>
								</td>
								<%
									count++;
									}
								%>
							</tr>
						</table>
						</div>
					</td>
					<td width="55%" style="float: left">
						<div style="height:200px;overflow-y:scroll;scrollbar-width:thin;">	
						<table id="slnum_table" width="100%" class="tab">
							<tr id="sticky">
								<th colspan="5">Serial Numbers</th>
							</tr>
							<tr style="border:1px solid #7BC342; border-radius: 5px;" id="stickyposition">
								<th colspan="4">
								<div id="borderbot" style="float:left">
								<label style="float:left;padding-left:10px;">
									<label class="btn btn-default" name="sl_sel_all" id="sl_sel_all" onclick="checkAll('slnum_table','slsearch','<%=Symbols.DELIMITER%>')">&nbsp;&nbsp;All</label>&nbsp;&nbsp;
									<label class="btn btn-default" name="sl_none" id="sl_none" onclick="uncheckAll('slnum_table','slsearch','<%=Symbols.DELIMITER%>')">&nbsp;&nbsp;None</label></label>&nbsp;&nbsp;
									
									<label class="btn btn-default" name="addrange" id="addrange" style="margin-bottom:5px;" onclick="showRangesWindow()">&nbsp;&nbsp;Add Range</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<label>Range:</label>&nbsp;&nbsp;<select class="text" id="range" style="min-width:120px;max-width:120px;margin-top:3px;">
									</select>
									</div>
								</th>
								<th colspan="1">
									<div id="borderbot" class="input-icons" style="float:right;padding-right:5px;text-align: right">
										<span><i class="fa fa-search icon"></i><input class="input-field" type="text" title="search" id="slsearch" style="width:150px;float:right;" onkeyup="doFilter('slnum_table','slsearch')" onkeydown="doaction(event)"></span>
									</div>
								</th>
							</tr>
		
							<%
								List<String> slnumlist = new ArrayList<String>();
								NodedetailsDao nodao = new NodedetailsDao();
								OrganizationDataDao orgdao = new OrganizationDataDao();
								List<NodeDetails> nodelist = null;
								if(selAdmin == null || role == null || role.equals(UserRole.ADMIN))
									nodelist = ndao.getAllNodeList(user);
								else
									nodelist = ndao.getAllNodeList(selAdmin);
								int count1 = 0;
								
								for (NodeDetails node : nodelist) {
									slnumlist.add(node.getSlnumber());
									if (count1 % 5 == 0) {
										if (count1 != 1) {
								}
							%>
							<tr id="rowdata">
								<%
									}
								%>
								<td id="coldata" ><input type="checkbox" id="<%=node.getId()%>" onclick="return false"
									name="<%=node.getId()%>" class="<%=node.getLocation()%>cb" value="<%=node.getSlnumber()%>"
									onclick="checkBoxEvent('<%=node.getId()%>','<%=Symbols.DELIMITER%>','slnumber')" /> <label class="<%=node.getLocation()%>"><%=node.getSlnumber()%></label>
								</td>
								<%
									count1++;
									}%>
									</tr>
								
									<% 
									List<String> snumlist = new ArrayList<String>();
									if(selAdmin == null || role == null || role.equals(UserRole.ADMIN))
										snumlist = orgdao.getUnDiscoveredSlNums(user, slnumlist);
									else
										snumlist = orgdao.getUnDiscoveredSlNums(selAdmin, slnumlist);
									if(snumlist.size()== 0){%>
										<script>
											hideUnDiscoveMsg();
										</script>
									<%}
									int count2 = 0;
									for(String slnum : snumlist)
									{
										if (count2 % 5 == 0) {
											if (count2 != 1) {
									}
								%>
								<tr id="rowdata">
									<%
										}
									%>
									<td id="coldata" ><input type="checkbox" id="<%=slnum%>" value="<%=slnum%>" onclick="return false" onclick="checkBoxEvent('<%=slnum%>','<%=Symbols.DELIMITER%>','slnumber')"/>  <label style="color:brown;background-color:#D3D3D3;"><%=slnum%></label>
									</td>
									<%
									count2++;
										}%>
										</tr>
							
						</table>
						</div>
					</td>
				</tr>
			</table>
			<%}%>	
			
			<div class="form-group">
				<div class="col-sm-offset-2 col-sm-10">
					<div class="col-sm-offset-2 col-sm-10">
					<div class="btn-group" role="group" style="padding-right: 20px;">
						<button type="submit" class="btn btn-default">Submit</button>
					</div>
					<div class="btn-group" role="group">
						<button type="button" class="btn btn-default"
							onclick="cancelUser()">Cancel</button>
					</div>
				</div>
			</div>
			<input type="hidden" id="selslnums" name="selslnums" />
			<input type="hidden" id="selloc" name="selloc" />
	
<!-- panel -->
		<div class="content" id="addrangediv">
				<input type="hidden" id="addrange_rwcnt" name="addrange_rwcnt" value="0">
				<table id="rangetab" align="center">
					<tr>
					<td><label>Start Range</label></td>
					<td><label>End Range</label></td>
					<td><label class="btn btn-default" name="add1" id="add1" onclick="addStartEndRangesRow(1)">ADD</label></td>
					</tr>
				</table>
				<div align="center" style="margin-top:10px">
					<input type="button"  value="Ok" class="btn btn-default" onclick="addRangeOptions('rangetab','range')"></input> 
					<!-- <input type="button" value="Cancel" class="btn btn-default" onclick="togglePopup('cancel')"></input> -->
				</div>
		</div>
	</form>
	</div>
	<!-- panel-body -->
</div>

<script type="text/javascript">
	hideLocSlnums();
	//setLocNodecolors(ckbox,true,delimeter);
	//
	addStartEndRangesRow(rangerow);
</script>
<%if(status.trim().length() > 0){ %>
<script type="text/javascript">
	showAlert('<%=status%>','<%=Symbols.NEWLINE%>');
</script>
<%} %>
<jsp:include page="/bootstrap-footer.jsp" flush="false" />
