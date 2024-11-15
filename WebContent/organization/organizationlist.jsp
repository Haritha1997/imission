<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="com.nomus.m2m.dao.OrganizationDao"%>
<%@page import="com.nomus.m2m.pojo.Organization"%>
<%@page language="java" contentType="text/html" session="true"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.lang.Exception"%>
<%@page import="java.lang.Integer"%>
<%@page import="java.util.List"%>


<jsp:include page="/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="Organization List" />
	<jsp:param name="headTitle" value="Organization" />
	<jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>Admin</a>" />
</jsp:include>
<%
	User user = (User)session.getAttribute("loggedinuser");
	String actionstatus = request.getParameter("status");
	actionstatus = actionstatus==null?"":actionstatus;
	String fetchtype = request.getParameter("fetchtype")==null?"active": request.getParameter("fetchtype");
%>
<script src="/imission/js/jquery.js"></script>
<script src="/imission/js/jquery-ui.js"></script>
<script src="/imission/js/jquery-1.4.2.min.js"></script>
<style type="text/css">
.borderlesstab td
{
	text-align : left;
}
.table th
{
  height: 30px;
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
    display: none;
    /*to hide popup initially*/
}
.borderlesstab td
{
	padding: 12px;
}
.btn
{
	margin-right: 20px;
}   
</style>
<script type="text/javascript">

	$.noConflict();
	function togglePopup(type) {
		clearOrgFormData();
		 if(type == "cancel")
		 {
			$(".content").toggle();
			return;
		 }
	}
	function clearOrgFormData()
	{
		document.getElementById("org_name").value="";
		document.getElementById("org_address").value="";
	}
	function showOrgPopup(action,id)
	{
		 const form = document.getElementById("org_form");
		 var input = document.getElementById("action");
		 var uorgid = document.getElementById("updateorgid");
		 if(input==null)
		 {
			 input = document.createElement("input");
	         input.type = "hidden";
	         input.name = "action";
	         input.id = "action";
	         input.value = action;
	         form.appendChild(input);
		 }
		 else
			 input.value = action;
		 if(action == "update")
		 {
			 document.getElementById("org_name").value=document.getElementById("orgname"+id).innerHTML.trim();
			 document.getElementById("org_address").value=document.getElementById("orgaddress"+id).innerHTML.trim();
			 if(uorgid == null)
			 {
				 uorgid = document.createElement("input");
				 uorgid.type = "hidden";
				 uorgid.name = "updateorgid";
				 input.id = "updateorgid";
				 uorgid.value = id;
				 form.appendChild(uorgid);
			 }
			 else
				 input.value = action;
		 }
         
		$(".content").toggle();
	}
	function saveOrganisation()
	{
		var organization = document.getElementById("org_name").value;
		if(organization.trim().length == 0)
		{
			alert("organization should not be empty");
			return;
		}
		const form = document.getElementById("org_form");
		form.submit();
		$(".content").toggle();
	}
	function deleteOrganization(id)
	{
		document.getElementById("org_name").value=document.getElementById("orgname"+id).innerHTML.trim();
		document.getElementById("org_address").value=document.getElementById("orgaddress"+id).innerHTML.trim();
		const form = document.getElementById("org_form");
		var input = document.getElementById("action");
		var uorgid = document.getElementById("updateorgid");
		 
		if(input == null)
		{
			input = document.createElement("input");
	        input.type = "hidden";
	        input.name = "action";
	        input.id = "action";
	        form.appendChild(input);
		}
        input.value = 'delete';
        if(uorgid == null)
        {
	        uorgid = document.createElement("input");
			uorgid.type = "hidden";
			uorgid.name = "updateorgid";
			input.id = "updateorgid";
			form.appendChild(uorgid);
        }
		uorgid.value=id;
        form.submit();
	}
	function goToUrl(url)
	{
		window.location.href = url;
	}
</script>


<form method="post" name="organizationlist">
	<input type="hidden" name="redirect" /> <input type="hidden"
		name="OrganizationID" /> <input type="hidden" name="newID" /> <input
		type="hidden" name="password" />
	<%if(fetchtype.equals("active")) {%>
	<p>
	<input type="button" style="width:150px;padding-right: 100px" value="Inactive Organizations" class="btn btn-default" onclick="goToUrl('organizationlist.jsp?fetchtype=inactive')"></input>
		<a id="doNewOrganization" href="javascript:showOrgPopup('save','-1')"> <i
			class="fa fa-plus-circle fa-2x"></i> Add new Organization
		</a>
	
	</p>
	<%} else if(fetchtype.equals("inactive")){%>
	<input type="button" style="width:150px" value="Active Organizations" class="btn btn-default" onclick="goToUrl('organizationlist.jsp?fetchtype=active')"></input>
	<br/><br/>
	<%} %>

	<div class="panel panel-default">
		<table class="table" id="tab">
			<thead>
				<tr>
				<% if(fetchtype.equals("active")){%>
					<th width="10%">Delete</th>
					<th width="10%">Modify</th>
				<% } else {%>
					<th width="10%">Recover</th>
					<%}%>
					<th width="15%">Organization Name</th>
					<th width="15%">Address</th>
					<th width="15%">Status</th>
				</tr>
			</thead>
			<tbody >
				<% 
           	int row = 0;
        	OrganizationDao Organizationdao = new OrganizationDao();
        	List<Organization> Organizationlist = null;
        		Organizationlist = Organizationdao.getOrganizationsList(fetchtype);
           	for (Organization org : Organizationlist) {
         %>
				<tr id="rowdata">
				   <% if(fetchtype.equals("active")){%>
					<td><a
						id="<%= "Organizations("+org.getId()+").doDelete" %>"
						href="javascript:deleteOrganization('<%=org.getId()%>')"
						onclick="return confirm('Are you sure you want to delete the Organization <%=org.getName()%>?')"><i
							class="fa fa-trash-o fa-2x"></i></a></td>
					<%}%>		
					<td><a
						id="<%= "Organizations("+org.getId()+").doModify" %>"
						href="javascript:showOrgPopup('update','<%=org.getId()%>')"><i
							class="fa fa-edit fa-2x"></i></a>
					</td>
					<td>
						<div id="orgname<%=org.getId()%>">
							<%=org.getName()%>
						</div>
					</td>
					<td>
						<div id="orgaddress<%=org.getId()%>">
							<%=org.getAddress() %>
						</div>
					</td>
					<td>
						<div id="<%= "Organizations("+org.getId()+").status" %>">
							<%=org.getStatus() %>
						</div>
					</td>
				</tr>

				<% row++;
            } %>
			</tbody>
		</table>
	</div>
	<!-- panel -->
</form>

<div class="content">
   <form id="org_form" action=organizationContoller method="post">
		<h2>
			<b><center>Organization</b>
			<center>
		</h2>
		<table class="borderlesstab" align="center">
			<tr>
				<td>
					<label for="Type" style="min-width: 125px;">Name</label>
				</td>
				<td>
				<input type="text" id="org_name" name="org_name" style="min-width: 170px; min-height: 25px;" <%if(fetchtype.equals("inactive")) {%> readonly<%}%>/>
				</td>
			</tr>
			<tr>
				<td>	
					<label for="Parameter" style="min-width: 125px;">Address</label>
				</td>
				<td>
					<input type="text" id="org_address" name="org_address" style="min-width: 170px; min-height: 25px;" <%if(fetchtype.equals("inactive")) {%> readonly<%}%>></input>
				</td>
			</tr>
		</table>
		<br/>
		<br/>
		
		<div align="center">
			<input type="button" <%if(fetchtype.equals("inactive")) {%> value="Recover"<%} else {%>value="Submit"<%} %> class="btn btn-default" onclick="saveOrganisation()"></input> 
			<input type="button" value="Cancel" class="btn btn-default" onclick="togglePopup('cancel')"></input>
		</div>
	</form>
</div>
<%if(actionstatus.trim().length() > 0)
{%>
	<script>
		alert('<%=actionstatus%>');
	</script>
<%}%>
<jsp:include page="/bootstrap-footer.jsp" flush="false" />
