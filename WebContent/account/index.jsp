
<%@page import="com.nomus.staticmembers.DateTimeUtil"%>
<%@page import="com.nomus.m2m.dao.OrganizationDataDao"%>
<%@page import="java.util.Set"%>
<%@page import="com.nomus.m2m.pojo.LoadBatch"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.nomus.staticmembers.Symbols"%>
<%@page import="com.nomus.m2m.pojo.Organization"%>
<%@page import="java.util.List"%>
<%@page import="com.nomus.m2m.dao.OrganizationDao"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="com.nomus.staticmembers.UserRole"%>
<%@page language="java"
	contentType="text/html"
	session="true"
%>

<%
	boolean canEdit = false;
	
	List<LoadBatch> orgbatchlist = null;
	String selorg = null;
	if(session.getAttribute("selorg") != null)
	{
		selorg = session.getAttribute("selorg").toString();
		session.removeAttribute("selorg");
	}
	if(session.getAttribute("orgbatchlist") != null)
	{
		orgbatchlist = (List<LoadBatch>)session.getAttribute("orgbatchlist");
		session.removeAttribute("orgbatchlist");
	}
	HashMap<String,String> batch_expiry_map = new HashMap<String,String>();
	User user = (User)session.getAttribute("loggedinuser"); 
    if (user.getRole().contains("admin"))
        canEdit = true;
    SimpleDateFormat formDate = new SimpleDateFormat("dd-MM-yyyy");
	String strDate = formDate.format(new Date());
	HashMap<String,String> org_batch_map = new HashMap<String,String>();
	int bid = 1;
	HashMap<String,HashMap<String,Integer>> org_info_map = new HashMap<String,HashMap<String,Integer>>();
%>

<jsp:include page="/bootstrap.jsp" flush="false">
  <jsp:param name="title" value="User Account" />
  <jsp:param name="headTitle" value="Settings" />
  <jsp:param name="operation" value="settings" />
  <jsp:param name="breadcrumb" value="User Account" />
</jsp:include>

<link rel="stylesheet" href="/imission/css/jquery-ui.css">
<style>
#bold{
	vertical-align:middle;
	margin-bottom:5px;
	font-weight:bold;
}
.borderlesstab td
{
	text-align : left;
}
.table th
{
  height: 30px;

}
th
{
  background-color: #7BC342;
}
li a
{
	text-decoration:none;
	cursor:pointer;
}
.borderlesstab td
{
	padding: 12px;
}
.btn
{
	margin-right: 20px;
} 
.content,.content1,.updatedatacontent  {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 500px;
    height: 400px;
    background-color: #e8eae6;
    box-sizing: border-box;
    z-index: 100;
    margin-top: 20px;
    display: none;
    /*to hide popup initially*/
}  
.content1 {
    height: 200px;
}  
.updatedatacontent {
    height: 350px;
}   
  
     
</style>
<script src="/imission/js/jquery.js"></script>
<script src="/imission/js/jquery-ui.js"></script>
<script src="/imission/js/jquery-1.4.2.min.js"></script>
<%
User user1 = (User)session.getAttribute("loggedinuser");
String actionstatus = request.getParameter("status");
if(actionstatus == null)
{
	if(session.getAttribute("status") != null)
	{
	 	actionstatus =  session.getAttribute("status").toString();
	 	session.removeAttribute("status");
	}
}
actionstatus = actionstatus==null?"":actionstatus;
 
String fetchtype = request.getParameter("fetchtype")==null?"active": request.getParameter("fetchtype");
%>
<script src="/imission/js/jquery.js"></script>
<script src="/imission/js/jquery-ui.js"></script>
<script src="/imission/js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/imission/m2m/wizngv2/js/common.js"></script>
<script type="text/javascript">
 let orgbatchmap = new Map();
 let orginfomap  = new Map();
 let batchid_expiry_map = new Map();
function showAlert(altdata,newline)
{
	altdata = altdata.replaceAll(newline,"\n");
	alert(altdata);
}
  function changePassword() {

	  <% if (canEdit) { %>
    document.selfServiceForm.action = "account/selfService/newPasswordEntry";
    document.selfServiceForm.submit();
<% } else { %>
	alert("The <%= user.getUsername()%> user is read-only!  Please have an administrator change your password.");
<% } %>
  }
  $.noConflict();
	function togglePopup(type) {
		 if(type == "cancel")
		 {
			 document.getElementById("organization").value = "";
			 document.getElementById("batname").value = "";
			$(".content").toggle();
			
			return;
		 }
		 else if(type == "viewcancel")
		{
			 document.getElementById("vieworg").value = "";
			 $(".content1").toggle();
				return; 
		}
	}
	function toggleUpdatePopup(type) {
		 if(type == "cancel")
		 {
			 document.getElementById("select_org").value = "";
			 document.getElementById("uporgbatname").value = ""; 
			 document.getElementById("batch_validupto").value = ""; 
			$(".updatedatacontent").toggle();
			return;
		 }
	}
	$(function() {
	    $( "#validupto" ).datepicker({
	        changeMonth: true,
	        changeYear: true,
	        minDate: 0,
			dateFormat: 'dd-mm-yy'
	    });
	});
	$(function() {
	    $( "#batch_validupto" ).datepicker({
	        changeMonth: true,
	        changeYear: true,
	        minDate: 0,
			dateFormat: 'dd-mm-yy'
	    });
	});
  function showfilePopup()
 {
		$(".content").toggle();
		$(".content1").hide();
		$(".updatedatacontent").hide();
 }
  function showViewfilePopup()
  {
	  	$(".content1").toggle();
		$(".content").hide();
		$(".updatedatacontent").hide();
  }
  function showorgBatchUpdatePopup()
  {
 		$(".updatedatacontent").toggle();
 		$(".content").hide();
		$(".content1").hide();
  }
 function saveOrganisationData()
 {
	 var altmsg = "";
	 const date = new Date();
		const yyyy = date.getFullYear();
		let mm = date.getMonth() + 1; // Months start at 0!
		let dd = date.getDate();

		if (dd < 10) dd = '0' + dd;
		if (mm < 10) mm = '0' + mm;

		const formattedToday = dd + '-' + mm + '-' + yyyy;
	 var organization = document.getElementById("organization").value;
	 var batchname = document.getElementById("batname").value;
	 var vaildDate = document.getElementById("validupto").value;
	 var selfile = document.getElementById("selfile").value.toLowerCase();
	 var parts1 = formattedToday.split("-");
		var parts2 = vaildDate.trim().split("-");
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
		if(organization.trim().length == 0)
			altmsg += "organization should not be empty\n";
		if(batchname.trim() == "")
			altmsg += "Batch Name should not be empty\n";
		if(vaildDate.trim() == "")
			altmsg += "Valid UpTo should not be empty\n";
		else if(!isValidDateFormat(vaildDate.trim()))
	    	altmsg+="Invalid Valid Upto!\n";
		else if(latest)
			altmsg += "Valid Upto Should Not Be less than current date!\n";
		if(!selfile.endsWith(".xls") && !selfile.endsWith(".xlsx"))
			altmsg += "Please select excel file\n";
		if(altmsg.trim().length>0)
		{
			alert(altmsg);
			return;
		}
		const form = document.getElementById("loadorg_form");
		form.submit();
		$(".content").toggle();
 }
 function setOrgBatchAndInfo()
 {
	 var org = document.getElementById("organization").value;
	 if(org.trim().length > 0)
	 {
		 document.getElementById("batname").value = orgbatchmap.get(org);
		 var info_map =  orginfomap.get(org);
		 var data = "Nodes Limit : "+info_map.get("nodelimit")+" &emsp;Current Nodes : "+info_map.get("current")+"&emsp;Remaining : "+info_map.get("remaining"); 
		 document.getElementById("orginfolbl").innerHTML = data;
		 document.getElementById('batchid').value = orgbatchmap.get(org+'batchid');
	 }
	 else
		 document.getElementById("orginfolbl").innerHTML="";
 }
 
 function saveUpdateOrganisationData()
 {
	 var altmsg = "";
	 const date = new Date();
		const yyyy = date.getFullYear();
		let mm = date.getMonth() + 1; // Months start at 0!
		let dd = date.getDate();

		if (dd < 10) dd = '0' + dd;
		if (mm < 10) mm = '0' + mm;

		const formattedToday = dd + '-' + mm + '-' + yyyy;
	 uporg = document.getElementById("select_org").value;
	 var upbatname = document.getElementById("uporgbatname").value;
	 var upvaildDate = document.getElementById("batch_validupto").value;
	 var parts1 = formattedToday.split("-");
		var parts2 = upvaildDate.trim().split("-");
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
		if(uporg.trim().length == 0)
			altmsg += "organization should not be empty\n";
		if(upbatname.trim() == "")
			altmsg += "Batch Name should not be empty\n";
		if(upvaildDate.trim() == "")
			altmsg += "Valid UpTo should not be empty\n";
		else if(!isValidDateFormat(upvaildDate.trim()))
	    	altmsg+="Invalid Valid Upto!\n";
		else if(latest)
			altmsg += "Valid Upto Should Not Be less than current date!\n";
		if(altmsg.trim().length>0)
		{
			alert(altmsg);
			return;
		}
		const form = document.getElementById("updateorg_form");
		form.submit();
		$(".updatedatacontent").toggle();
 }
 function getOrganizationBatches()
 {
	 if(document.getElementById('select_org').value.trim() == "")
		 return;
	 let form = document.getElementById('updateorg_form');
	 form.action = "getBatches";
	 form.submit();
 }
 function setBatchValidUpTo()
 {
	 var batchid = document.getElementById('uporgbatname').value.trim();
	 if(batchid != "")
	 document.getElementById('batch_validupto').value = batchid_expiry_map.get(batchid);
 }
 function setSelOrg(selorg)
 {
	if(selorg != 'null' && selorg != 'NULL')
	{
		 document.getElementById('select_org').value = selorg;	
	}
 }
 function gotoUrl()
 {
	 var orgname = document.getElementById("vieworg").value;
	 if(orgname.trim() == "")
		 alert("Organization should not be empty\n");
	 else
	 	location.href = "/imission/account/orgbatchdata.jsp?organName="+orgname;
 }
 
</script>

<div class="row">
  <div class="col-md-12">
    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title">Settings</h3>
      </div>
      <%if(user.getRole().equals(UserRole.MAINADMIN)){%>
      <!-- <div class="panel-body">
        <ul class="list-unstyled">
          <li><a style="text-decoration:none;" href="javascript:changePassword()">Change Password</a></li>
        </ul>
      </div> panel-body
      <div class="panel-body">
        <ul class="list-unstyled">
          <li><a style="" href="/imission/organization/organizationlist.jsp">Organization</a></li>
        </ul>
      </div> panel-body -->
      <!-- update org div start -->
       <div class="panel-body">
        <ul class="list-unstyled">
          <li><a style="text-decoration:none;"href="javascript:showfilePopup();" >Load Organization Data</a></li>  
        </ul>
      </div> <!-- panel-body -->
      
      <div class="content">
   <form id="loadorg_form" enctype="multipart/form-data" action=loadOrganizationData method="post">
   <h2>
			<b><center>Load Organization Data</b>
			<center>
		</h2>
		<table class="borderlesstab" align="center">
		<tbody>
			<tr>
					<td style="min-width: 150px;">Organization </td>				
				<td>
				<select type="text" id="organization" name="organization" style="min-width: 170px; min-height: 25px;" onchange="setOrgBatchAndInfo()">
				<option value=""></option>
				<%
		        	OrganizationDao orgdao = new OrganizationDao();
		        	List<Organization> orglist = null;
		        	orglist = orgdao.getOrganizationsList("all");
		           	for (Organization org : orglist) {
		           		List<LoadBatch> batchlist = org.getLoadBatchList();
		           		if(batchlist.size() > 0)
		           		{
		           			bid = batchlist.get(batchlist.size()-1).getBatchId()+1;
		           			org_batch_map.put(org.getName(),"batch"+bid);
		           			org_batch_map.put(org.getName()+"batchid",bid+"");
		           		}
		           		else
		           		{
		           			org_batch_map.put(org.getName(),"batch"+1);
		           			org_batch_map.put(org.getName()+"batchid",1+"");
		           		}
						OrganizationDataDao orgdatadao = new OrganizationDataDao();	
						HashMap<String,Integer> orgdatainfo = new HashMap<String,Integer>();
						int currentsize = orgdatadao.getCurrentOrgDataSize(org.getName());
						orgdatainfo.put("nodelimit",org.getNodesLimit());
						orgdatainfo.put("current",currentsize);
						orgdatainfo.put("remaining",org.getNodesLimit()-currentsize);
						org_info_map.put(org.getName(),orgdatainfo);
		         %>
					<option value="<%=org.getName()%>"><%=org.getName()%></option>
				<%}%>
				</select>
				</td>
			</tr>
			<tr>
				<td style="min-width: 150px;">Batch Name</td>
				<td>
					<input type="text" id="batname" style="min-width: 170px; min-height: 25px;" name="batname" value='' />
					<input type="hidden" id="batchid"  name="batchid" value="<%=bid%>">
				</td>
			</tr>
			<tr>
				<td style="min-width: 150px;">Valid Upto</td>
				<td>
					<input type="text" class="datepicker" id="validupto" style="min-width: 170px; min-height: 25px;" name="validupto" value='<%=strDate%>' placeholder="dd-mm-yyyy"/>
				</td>
			</tr>
			<tr>
			<td style="min-width: 150px;">Select File :&nbsp;</td>
			<td>
		<input type="file" style="display:inline;margin-right:6%" id="selfile"  name="selfile" />
			</td>
			</tr>
			<!-- <tr>
			<td colspan="2">
			<label id="orginfolbl"> </label>
			</td>
			</tr> -->
		</tbody>
   </table>
   <br/>
	<br/>
   <div align="center">
			<input type="button" value="Save" class="btn btn-default" onclick="saveOrganisationData()"  ></input> 
			<input type="button" value="Cancel" class="btn btn-default"  onclick="togglePopup('cancel')"></input>
			<a href="Orgdata.xls"><input type="button" value="Download Sample File" class="btn btn-default" style="width:180px"/></a>
		</div>
	</form>
</div><!-- load org div ends -->
<!-- update org div start -->
<div class="panel-body">
        <ul class="list-unstyled">
          <li><a style="text-decoration:none;"href="javascript:showorgBatchUpdatePopup();" >Update Organization Data</a></li>
        </ul>
      </div> <!-- panel-body -->
      
      <div class="updatedatacontent">
   <form id="updateorg_form"  action=UpdateOrganizationData method="post">
   <h2>
			<b><center>Update Organization Data</b>
			<center>
		</h2>
		<table class="borderlesstab" align="center">
		<tbody>
		
			<tr>
					<td style="min-width: 150px;">Organization </td>				
				<td>
				<select type="text" id="select_org" name="select_org" style="min-width: 170px; min-height: 25px;" onchange="getOrganizationBatches()">
				<option value=""></option>
				<%
		           	for (Organization orgobj : orglist) {
		           		List<LoadBatch> batchlist = orgobj.getLoadBatchList();
		           		if(batchlist.size() > 0)
		           			org_batch_map.put(orgobj.getName(),"batch"+(batchlist.get(batchlist.size()-1).getBatchId()+1));
		           			
		         %>
				<option value="<%=orgobj.getId()%>"><%=orgobj.getName()%></option>
				<%}%>
				</select>
				</td>
			</tr>
			<tr>
				<td style="min-width: 150px;">Batch Name</td>
				<td>
					<select type="text" id="uporgbatname" style="min-width: 170px; min-height: 25px;" name="uporgbatname" onchange="setBatchValidUpTo()">
					<option value=""></option>
						<%
						if(orgbatchlist != null)
						{
			           for (LoadBatch batchobj : orgbatchlist) {
			        	   batch_expiry_map.put(batchobj.getId()+"",DateTimeUtil.getDateString(batchobj.getValidUpTo()));
						%>
						<option value="<%=batchobj.getId()%>"><%=batchobj.getBatchName()%></option>
						<%}}%>
					</select>

				</td>
			</tr>
			<tr>
				<td style="min-width: 150px;">Valid Upto</td>
				<td>
					<input type="text" class="datepicker" id="batch_validupto" style="min-width: 170px; min-height: 25px;" name="batch_validupto" value='' placeholder="dd-mm-yyyy"/>
				</td>
			</tr>
		</tbody>
   </table>
   <br/>
	<br/>
   <div align="center">
			<input type="button" value="Save" class="btn btn-default" onclick="saveUpdateOrganisationData()"  ></input> 
			<input type="button" value="Cancel" class="btn btn-default"  onclick="toggleUpdatePopup('cancel')"></input>
		</div>
	</form>
</div>
<div class="panel-body">
        <ul class="list-unstyled">
          <li><a style="text-decoration:none;"href="javascript:showViewfilePopup();" >View Organization Data</a></li>  
        </ul>
      </div> <!-- panel-body -->
 <div class="content1">
 	<form id="viewOrgform" name="viewOrgform" method="post">
 		<h2>
			<b><center>View Organization Data</b>
			<center>
		</h2>
		<table class="borderlesstab" align="center">
		<tbody>
		
			<tr>
					<td style="min-width: 150px;">Organization </td>				
				<td>
				<select type="text" id="vieworg" name="vieworg" style="min-width: 170px; min-height: 25px;">
				<option value=""></option>
				<%
		        	orglist = orgdao.getOrganizationsList("all");
		           	for (Organization org : orglist) {
		         %>
					<option value="<%=org.getName()%>"><%=org.getName()%></option>
				<%}%>
				</select>
				</td>
			</tr>
			</tbody>
			</table>
			<br/>
			<div align="center">
			<input type="button" value="Submit" class="btn btn-default" onclick="gotoUrl()"></input> 
			<input type="button" value="Cancel" class="btn btn-default" onclick="togglePopup('viewcancel')"/>
			</div>
 	</form>
 
 </div>
<div class="panel-body">
        <ul class="list-unstyled">
          <li><a style="text-decoration:none;" href="/imission/m2m/m2msettings.jsp">M2M Settings</a></li>
        </ul>
      </div> <!-- panel-body -->
      
       <!--   <div class="panel-body">
	       <ul class="list-unstyled">
	         <li><a style="text-decoration:none;" href="/imission/m2m/temperature.jsp">Temperature Reading</a></li>
	       </ul>
 		</div>
      	
      -->
      <%}
	
      if(user.getRole().equals(UserRole.SUPERADMIN)||user.getRole().equals(UserRole.ADMIN)) {%>
        <div class="panel-body">
		        <ul class="list-unstyled">
		          <li><a style="text-decoration:none;" href="/imission/account/Changepassword.jsp">Change Password</a></li>
		        </ul>
		      </div>
		        <%} 
       if(!user.getRole().equals(UserRole.MAINADMIN)){%>
		       <div class="panel-body">
		        <ul class="list-unstyled">
		          <li><a style="text-decoration:none;" href="/imission/m2m/deletenodes.jsp">Delete Nodes</a></li>
		        </ul>
		      </div>
       <!-- <div class="panel-body">
        <ul class="list-unstyled">
          <li><a style="text-decoration:none;" href="/imission/m2m/colsettings.jsp">Column Settings</a></li>
        </ul>
      </div> --> <!-- panel-body -->
      <%}
      if(!user.getRole().equals(UserRole.MAINADMIN) && user.getRole().equals(UserRole.SUPERADMIN)) {
      %>
      	<div class="panel-body">
	        <ul class="list-unstyled">
	          <li><a style="text-decoration:none;" href="/imission/m2m/userm2msettings.jsp">User M2M Settings</a></li>
	        </ul>
      </div>
      <div class="panel-body">
	        <ul class="list-unstyled">
	          <li><a style="text-decoration:none;" href="/imission/licensedetails.jsp">License Details</a></li>
	        </ul>
      </div>
      <div class="panel-body">
	        <ul class="list-unstyled">
	          <li><a style="text-decoration:none;" href="/imission/backup.jsp">DataBase BackUp</a></li>
	        </ul>
      </div>
      <%} 
      if(!user.getRole().equals(UserRole.MAINADMIN) && !user.getRole().equals(UserRole.MONITOR)) {
      %>
      	<div class="panel-body">
	        <ul class="list-unstyled">
	          <li><a style="text-decoration:none;" href="/imission/m2m/downloadConfig.jsp">Download Config</a></li>
	        </ul>
      </div>
      <%} %>
      
    </div> <!-- panel -->
  </div> <!-- column -->
</div> <!-- row -->


<%if(actionstatus.trim().length() > 0){ %>
<script type="text/javascript">
	showAlert('<%=actionstatus%>','<%=Symbols.NEWLINE%>');
</script>
<%} %>
<%
 Set<String> keyset = org_batch_map.keySet();
  for(String key:keyset){%> 
  <script>
  	orgbatchmap.set('<%=key%>','<%=org_batch_map.get(key) %>');
  </script>
  <%}
    keyset = org_info_map.keySet();
  for(String key:keyset){
     HashMap<String,Integer> jinfomap = org_info_map.get(key);
  %> 
  	<script>
  	    var infomap = new Map();
  	    <%for(String ikey : jinfomap.keySet()){%>
  	  		infomap.set('<%=ikey%>','<%=jinfomap.get(ikey)%>');
  	  	<%}%> 
  	  	orginfomap.set('<%=key%>',infomap);
  	</script>
   <%} 
  keyset = batch_expiry_map.keySet();
    for(String key:keyset){
  %> 
  	<script>
		batchid_expiry_map.set('<%=key%>','<%=batch_expiry_map.get(key)%>');
  	</script>
   <%}
   if(orgbatchlist != null)
   {
   %>
   <script>
   showorgBatchUpdatePopup();
   setSelOrg('<%=selorg%>');
  </script>
   <%}%>
    
<jsp:include page="/bootstrap-footer.jsp" flush="false"/>
