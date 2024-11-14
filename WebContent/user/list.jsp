<%@page import="com.nomus.staticmembers.UserRole"%>
<%@page import="com.nomus.m2m.dao.UserDao"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page language="java" contentType="text/html" session="true"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.lang.Exception"%>
<%@page import="java.lang.Integer"%>
<%@page import="java.util.List"%>


<jsp:include page="/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="User Configuration" />
	<jsp:param name="headTitle" value="List" />
	<jsp:param name="headTitle" value="Users" />
	<jsp:param name="headTitle" value="Admin" />
	<jsp:param name="breadcrumb"
		value="<a href='admin/index.jsp'>Admin</a>" />
	<jsp:param name="breadcrumb"
		value="<a href='admin/userGroupView/index.jsp'>Users and Groups</a>" />
	<jsp:param name="breadcrumb" value="User List" />
</jsp:include>

<%
	User curuser = (User) session.getAttribute("loggedinuser");
	String fetchtype = request.getParameter("fetchtype") == null ? "active" : request.getParameter("fetchtype");
	String status = "";
	if(session.getAttribute("status") != null)
	{
		status = session.getAttribute("status").toString();
		session.removeAttribute("status");
	}
%>
<head>
<script src="/imission/js/jquery.js"></script>
<script src="/imission/js/jquery-ui.js"></script>
<script src="/imission/js/jquery-1.4.2.min.js"></script>
<style type="text/css">
 
.borderlesstab td
{
    text-align: left;
	padding: 12px;
}
.table td div
{
	margin-left:10px;
}
.table th {
	height: 30px;
}
.table th div{
 padding-left:10px;
 }
.btn {
	margin-right: 20px;
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
</style>
<script type="text/javascript">
	$.noConflict();
	function togglePopup(type) {
		clearRecoverFormData();
		if (type == "cancel") {
			$(".content").toggle();
			return;
		}
	}
	function clearRecoverFormData() {
		document.getElementById("user_name").value = "";
		document.getElementById("user_org").value = "";
	}
	function addNewUser() {
		<%-- <%
		UserDao udao = new UserDao();
		List<User> allusers = udao.getAllOrgUsers(curuser.getOrganization());
		User usr= udao.getUsers(curuser.getOrganization());
		if(usr.getOrganization().getUserlimit() == allusers.size()) {%>
			alert("Users limit completed... We cannot create any users for this organization...");
		<%} 
		else {%> --%>
		document.allUsers.action = "/imission/user/newUser.jsp?action=new";
			document.allUsers.submit();
	<%-- 	<%}%> --%>
	}

	function detailUser(userID) {
		document.allUsers.action = "/imission/user/userDetail.jsp?userID=" + userID;
		document.allUsers.submit();

	}

	function deleteUser(userID) {
		document.allUsers.action = "UserController?action=delete&userID="+ userID;
		document.allUsers.submit();
	}

	function modifyUser(userID, fetchtype) {
		if (fetchtype == "active") {
			document.allUsers.action = "/imission/user/modifyUser.jsp?userID=" + userID;
			document.allUsers.userID.value = userID;
			document.allUsers.submit();
		} 
		else {
			const form = document.getElementById("recover_form");
			document.getElementById("user_name").value = document
						.getElementById("username" + userID).innerHTML.trim();
			
			document.getElementById("user_org").value = document
						.getElementById("organization" + userID).innerHTML.trim();

			var useridobj = document.getElementById("userID");
				if (useridobj == null) {
					useridobj = document.createElement("input");
					useridobj.type = "hidden";
					useridobj.name = "userID";
					useridobj.id = "userID";
					useridobj.value = userID;
					form.appendChild(useridobj);
				} 
				else
					useridobj.value = userID;
				
				$(".content").toggle();
			}
	}

	/* function renameUser(userID) {
		document.allUsers.userID.value = userID;
		var newID = prompt("Enter new name for user.", userID);

		if (newID != null && newID != "") {
			document.allUsers.newID.value = newID;
			document.allUsers.action = "user/renameUser";
			document.allUsers.submit();
		}
	} */
	function goToUrl(url) {
		window.location.href = url;
	}
	function recoverUser() {
		const form = document.getElementById("recover_form");
		form.action = "UserController?action=recover";
		form.submit();
		$(".content").toggle();
	}
</script>
</head>

<form method="post" name="allUsers">
	<input type="hidden" name="redirect" /> 
	<input type="hidden" name="userID" />
	<input type="hidden" name="newID" /> 
	<input type="hidden" name="password" />

	<p>
		Click on the <i>User ID</i> link to view detailed information about a
		user.
	</p>
	<%
		if (fetchtype.equals("active")) {
	%>
	<p>
		<input type="button" style="width: 150px; text-align: center"
			value="Inactive Users" class="btn btn-default"
			onclick="goToUrl('list.jsp?fetchtype=inactive')"></input> 
		<a id="doNewUser" href="javascript:addNewUser()">
		 <i
			class="fa fa-plus-circle fa-2x"></i> Add new user
		</a>
	</p>
	<%
		} else if (fetchtype.equals("inactive")) {
	%>
	<input type="button" style="width: 150px; text-align: center"
		value="Active Users" class="btn btn-default"
		onclick="goToUrl('list.jsp?fetchtype=active')"></input> <br /> <br />
	<%
		}
	%>

	<div class="panel panel-default">
		<table class="table" >
			<thead>
				<tr>
					
					<th width="15%;"><div>Username</div></th>
					<th width="15%"><div>Role</div></th>
					<th width="15%"><div>Email</div></th>
					<%if(curuser.getRole().equals(UserRole.SUPERADMIN)){%>
					<th width="15%"><div>Under</div></th>
					<%} %>
					<th width="15%"><div>Organization</div></th>
					<%
						if (fetchtype.equals("active")) {
					%>
					<th width="10%">Edit</th>
					<%if(!curuser.getRole().equals(UserRole.MAINADMIN)){%>
					<th width="10%">Delete</th>
					<%
					}} else {
					%>
					<th width="10%">Recover</th>
					<%
						}
					%>
				</tr>
			</thead>
			<tbody>
				<%
 					HashMap<String,String> 	roles_hm = UserRole.getAllRoles();
					int row = 0;
					UserDao userdao = new UserDao();
					List<User> userlist = null;
					userlist = userdao.getUsersList(curuser, fetchtype);
					for (User user : userlist) {
						String email = user.getEmail();
				%>
			
				<tr id="user-<%=user.getId()%>">
					<td>
						<div id="username<%=user.getId()%>"><%=user.getUsername()%></div>
					</td>
					<td>
						<div id="sel_role<%=user.getId()%>"><%=roles_hm.get(user.getRole())%></div>
					</td>
					<td>
						<div id="<%="users(" + user.getId() + ").email"%>">
							<%=((email == null || email.equals("")) ? "&nbsp;" : email)%>
						</div>
					</td>
					<%if((curuser.getRole().equals(UserRole.SUPERADMIN))){%>
					<td>
						<div><%=(user.getUnder()==null)?"":user.getUnder().getUsername()%></div>
					</td>
					<%} %>
					<td>
						<div id="organization<%=user.getId()%>">
							<%
								if (user.getOrganization() != null) {
							%>
							<%=user.getOrganization().getName()%>
							<%
								}
							%>
						</div>
					</td>
					<%
					if (fetchtype.equals("active")) {
					if (curuser.getRole().equals(UserRole.MAINADMIN) || user.getId() == curuser.getId() || !user.getRole().equals(UserRole.SUPERADMIN)) {
					%>
					<td><a id="<%="users(" + user.getId() + ").doModify"%>"
						href="javascript:modifyUser('<%=user.getId()%>','<%=fetchtype%>')">
							<i class="fa fa-edit fa-2x"></i>
					</a></td>
					<%} else {%>
					<td><i class="fa fa-edit fa-2x"
						onclick="alert('Sorry, this Superuser Cannot be Edited.')"></i></td>
					<% }	
						if ((user.getId() != curuser.getId()) && !user.getRole().equals(UserRole.SUPERADMIN)) {
					%>
					<td><a id="<%="users(" + user.getId() + ").doDelete"%>"
						href="javascript:deleteUser('<%=user.getId()%>')"
						onclick="return confirm('Are you sure you want to delete the user <%=user.getUsername()%>?')"><i
							class="fa fa-trash-o fa-2x"></i></a></td>
					<%
						} else if(!curuser.getRole().equals(UserRole.MAINADMIN)){
					%>
					<td><i class="fa fa-trash-o fa-2x"
						onclick="alert('Sorry, the admin user cannot be deleted.')"></i></td>
					<%
						}
					%>
					<%
						}
					else {
					%>
					<td><a id="<%="users(" + user.getId() + ").doModify"%>"
						href="javascript:modifyUser('<%=user.getId()%>','<%=fetchtype%>')">
							<i class="fa fa-edit fa-2x"></i>
					</a></td>
					<%
						}
					%>
				</tr>

				<%
					row++;
					}
				%>
			</tbody>
		</table>
	</div>
	<!-- panel -->
</form>
<div class="content">
	<form id="recover_form" action="UserController" method="post">
		<h2>
			<b><center>User</b>
			<center>
		</h2>
		<table class="borderlesstab" align="center">
			<tr>
				<td><label for="Type" style="min-width: 125px;">Username</label>
				</td>
				<td><input type="text" id="user_name" name="user_name"
					style="min-width: 170px; min-height: 25px;"
					<%if (fetchtype.equals("inactive")) {%> readonly <%}%> /> 
				</td>
			</tr>
			<tr>
				<td><label for="Parameter" style="min-width: 125px;">Organization</label>
				</td>
				<td><input type="text" id="user_org" name="user_org"
					style="min-width: 170px; min-height: 25px;"
					<%if (fetchtype.equals("inactive")) {%> readonly <%}%>></input></td>

			</tr>
		</table>
		<br /> <br />

		<div align="center">
			<input type="submit" <%if (fetchtype.equals("inactive")) {%> value="Recover" onclick="recoverUser();"<%} else {%> value="Submit" <%}%> class="btn btn-default"></input> 
				<input type="button" value="Cancel" class="btn btn-default"
					onclick="togglePopup('cancel')"></input>
					
		</div>
	</form>
</div>
<%if(status.trim().length() > 0){%>
	<script>
	alert('<%=status%>');
	</script>
	<%status="";
} %>
<jsp:include page="/bootstrap-footer.jsp" flush="false" />
