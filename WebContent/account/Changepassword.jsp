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
	function detailUser(userID) {
		document.allUsers.action = "/imission/user/userDetail.jsp?userID=" + userID;
		document.allUsers.submit();

	}
	function ChangePassword(userID, fetchtype) {
		if (fetchtype == "active") {
			document.allUsers.action = "/imission/account/newPassword.jsp?userid=" + userID;
			document.allUsers.userID.value = userID;
			document.allUsers.submit();
		} 
	}
</script>
</head>

<form method="post" name="allUsers">
	<input type="hidden" name="redirect" /> 
	<input type="hidden" name="userID" />
	<input type="hidden" name="newID" /> 
	<input type="hidden" name="password" />
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
					<th width="10%">ResetPassword</th>
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
					if (!user.getRole().equals(UserRole.SUPERADMIN)||user.getId()==curuser.getId()) {
					%>
					<td><a id="<%="users(" + user.getId() + ").doModify"%>"
						href="javascript:ChangePassword('<%=user.getId()%>','<%=fetchtype%>')">
							<i class="fa fa-edit fa-2x"></i>
					</a></td>
					<%} else {%>
					<td><i class="fa fa-edit fa-2x"
						onclick="alert('Sorry, this Superuser Cannot be Edited.')"></i></td>
					<% }	
					%>
					
					<%
						}
					else {
						%>
						<td><a id="<%="users(" + user.getId() + ").doModify"%>"
							href="javascript:ChangePassword('<%=user.getId()%>','<%=fetchtype%>')">
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

<%if(status.trim().length() > 0){%>
<script>
alert('<%=status%>');
</script>
<%status="";} %>
<jsp:include page="/bootstrap-footer.jsp" flush="false" />
