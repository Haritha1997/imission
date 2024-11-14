<%@page import="com.nomus.m2m.view.Organization"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.nomus.staticmembers.DateTimeUtil"%>
<%@page import="com.nomus.m2m.dao.OrganizationDao"%>
<%@page import="com.nomus.m2m.dao.UserDao"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.nomus.staticmembers.UserRole"%>
<%@page import="com.nomus.m2m.view.ChildUser"%>
<%@page import="com.nomus.m2m.view.Admin"%>
<%@page import="com.nomus.m2m.view.SuperAdmin"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<jsp:include page="/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="Organization Tree" />
	<jsp:param name="breadcrumb" value="run"/>
</jsp:include>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<script src="/imission/js/Chart.min.js"></script>
<style type="text/css">
canvas
{
	min-height:60%;
	max-height:60%;
	min-width:100%;
	max-width:100%;
	height:260px;
}
#middiv
{
  padding-top:10%;
  padding-bottom:10%;
}
#pad20
{
 margin-top: 5px;
 font-size: 14px;
 margin-left: 25%;
}
#rightlab
{
min-width : 80px;
text-align: right;
font-size: 14px;
}
#userchart
{
height:260px; 
width:100%; 
float:center;
margin-bottom:20px;
}
.green
{
color: #7BC342;
}
.red
{
color: rgba(254,39,18,0.85);
}
.blue
{
 color: rgba(25,116,208,0.85);	
}
.orange
{
	color: #FF8533;
}
ul {
  padding-left:20px;
  list-style: none;
}
.tree li li
{
	content:'-';
	display : block;
  	list-style-type: none;
  	border-left: 1px dotted #000;
 	 margin-left: 1em;
}
.tree li label,.tree li img
{
	cursor:pointer;
}


/* .borderlist
{
	border : 1px solid #7BC342;
	border-radius: 5px;
	min-width : 100px;
	width : 240px;
	max-width : 600px;
	font-size: 15px;
	text-align: center;
	background-color: #eee;
} */
ul ul div::before {
   padding-left:60px;
}
ul ul ul div::before {
   padding-left:80px;
}
p
{
cursor:pointer;	
}
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
</style>
<script type="text/javascript">
var orgusermap = new Map();
var userchart;
function addOrgUserData(orgname,actuct,deluct,expuct)
{
	orgusermap.set(orgname,actuct+","+deluct+","+expuct);
}
function createUserchart()
{
	var orgobj = document.getElementById("selorg");
	var usrstatdata;
	document.getElementById("orglbl").innerHTML = orgobj.value;
	if(orgobj.value == "")
		usrstatdata = orgusermap.get(" ");
	else
		usrstatdata = orgusermap.get(orgobj.value);
	var usrstadarr = usrstatdata.split(",");
	userchart.data.datasets[0].data=[usrstadarr[0],usrstadarr[1],usrstadarr[2]];
	userchart.update();
}
function expandOrCollapse(id)
{
	var obj = document.getElementById(id);
	 if (obj.style.display === "block" || obj.style.display === "") {
		 obj.style.display = "none";
	    } else {
	    	obj.style.display = "block";
	    }
}
function createChart(id,active,inactive,expired)
{
	if(id=="orgchart") {
		chart = new Chart(document.getElementById(id), {
		    type: 'pie',
			startAngle: 180,
		    data: {
		      labels: ["Active","Expired"],
		      datasets: [{
		        backgroundColor: ["#7BC342","rgba(254,39,18,0.85)"],
		        data: [active,inactive]
		      }]
		    },
		    options: {
		      title: {
		        display: true
		      }
		    }
		});	
	}
	else if(id=="userchart")
	{
		userchart = new Chart(document.getElementById(id), {
		    type: 'pie',
			startAngle: 180,
		    data: {
		      labels: ["Active","Deleted","Expired"],
		      datasets: [{
		        backgroundColor: ["#7BC342","#FF8533","rgba(254,39,18,0.85)"],
		        data: [active,inactive,expired]
		      }]
		    },
		    options: {
		      title: {
		        display: true,
		      }
		    }
		});	
	}
}
</script>
</head>
<body>

	<table width="100%" align="center" id="dashtab" name="dashtab">
	<tr>
	<td style="float:left; padding-right:5px;" width="40%">
	<div style="height:300px;">
	<table id="orgtree" name="orgtree" class="tab">
	<% 
		HashMap<String,String> roleshm = UserRole.getAllRoles();
		List<Organization> orglist = (List<Organization>)request.getAttribute("orglist");
		int totausrcnt = 0;
		int totinausrcnt = 0;
		int totexpusrcnt = 0;
		int totaorgcnt = 0;
		int totinaorgcnt = 0;
		for(Organization selorg : orglist)
		{
			int acuserct=0;
			int expuserct=0;
			int deluserct=0;
			boolean orgexp = false;
		%>
			<ul class="tree">
			  <li>
				<img onclick="expandOrCollapse('<%=selorg.getName()%>')" src="/imission/images/org.png" alt="orglogo" title="Organization"/>
				<%if(DateTimeUtil.isExpired(selorg.getValidUpTo())) { 
					totinaorgcnt++;
					orgexp = true;
				%>
				<label onclick="expandOrCollapse('<%=selorg.getName()%>')" class="borderlist" title="Organization"><span class="red"><%=selorg.getName().toUpperCase()%></span></label>
				<%} else { 
					totaorgcnt++;
				%>
				<label onclick="expandOrCollapse('<%=selorg.getName()%>')" class="borderlist" title="Organization"><%=selorg.getName().toUpperCase()%></label>
				<%} %>
				<span style="padding-left:5px" title="View Organization Data"><a href="/imission/account/orgbatchdata.jsp?organName=<%=selorg.getName()%>"><img src="/imission/images/info.png" style="width:20px;height:15px"></a></span>
				
				<div style="display:none;" id="<%=selorg.getName()%>">
				<%for(SuperAdmin sa : selorg.getUserlist())
				{
					if(orgexp)
					{
						expuserct++;
						totexpusrcnt++;
					}
					else
					{
						acuserct++;
						totausrcnt++;
					}
					
				%>
				    	<ul class="tree">
							<li>
								<img onclick="expandOrCollapse('<%=sa.getUser().getId()%>')" src="/imission/images/suadmin.png" alt="superadminlogo" title="<%=roleshm.get(sa.getUser().getRole())%>"/>
								<label class="borderlist"  title="<%=roleshm.get(sa.getUser().getRole())%>" onclick="expandOrCollapse('<%=sa.getUser().getId()%>')"><%=sa.getUser().getUsername().toUpperCase()%><%-- &nbsp;&nbsp;(<%=roleshm.get(sa.getUser().getRole())%>) --%></label>
								<div style="display:block;" id="<%=sa.getUser().getId()%>">
								
								<%for(Admin admin : sa.getChildlist())
									{
									if(orgexp)
									{
										expuserct++;
										totexpusrcnt++;
									}
									else if(admin.getUser().getStatus().equals("deleted"))
									{
										deluserct++;
										totinausrcnt++;
										
									}
									else
									{
										acuserct++;
										totausrcnt++;
									}
									%>
										<ul class="tree">
											<li>
												<%if(admin.getUser().getRole().equals(UserRole.ADMIN)) {%>
												<img onclick="expandOrCollapse('<%=admin.getUser().getId()%>')" src="/imission/images/admin.png" alt="adminlogo" title="<%=roleshm.get(admin.getUser().getRole())%>"/>
												<%} 
												else if(admin.getUser().getRole().equals(UserRole.SUPERVISOR)) {%>
													<img onclick="expandOrCollapse('<%=admin.getUser().getId()%>')"  src="/imission/images/org_user.png" alt="user" width="20" height="15" title="<%=roleshm.get(admin.getUser().getRole())%>"></img>
												<%} else if(admin.getUser().getRole().equals(UserRole.MONITOR)) {%>
													<img onclick="expandOrCollapse('<%=admin.getUser().getId()%>')"  src="/imission/images/eye.png" alt="user" width="20" height="15" title="<%=roleshm.get(admin.getUser().getRole())%>"></img>
												<%} 
												if(admin.getUser().getStatus()!=null && admin.getUser().getStatus().equals("deleted")) {%>
												<label class="borderlist" title="<%=roleshm.get(admin.getUser().getRole())%>" onclick="expandOrCollapse('<%=admin.getUser().getId()%>')"><span class="orange"><%=admin.getUser().getUsername().toUpperCase()%></span><%-- &nbsp;&nbsp;(<%=roleshm.get(admin.getUser().getRole())%>) --%></label>
												<% 
												} else{
													
												%>
												<label class="borderlist" title="<%=roleshm.get(admin.getUser().getRole())%>" onclick="expandOrCollapse('<%=admin.getUser().getId()%>')"><%=admin.getUser().getUsername().toUpperCase()%><%-- &nbsp;&nbsp;(<%=roleshm.get(admin.getUser().getRole())%>) --%></label>
												<%} %>
												
												<div style="display:block;" id="<%=admin.getUser().getId()%>">
													<%for(ChildUser user : admin.getChildlist())
													{
														if(orgexp)
														{
															expuserct++;
															totexpusrcnt++;
														}
														else if(user.getUser().getStatus().equals("deleted"))
														{
															deluserct++;
															totinausrcnt++;
														}
														else
														{
															acuserct++;
															totausrcnt++;
														}
													%>
														<ul class="tree">
															<li>
																 <%if(user.getUser().getRole().equals(UserRole.SUPERVISOR)) {%>
																	<img class="imgicon" src="/imission/images/org_user.png" alt="user" width="20" height="15" title="<%=roleshm.get(user.getUser().getRole())%>"></img>
																<%} else if(user.getUser().getRole().equals(UserRole.MONITOR)) {%>
																<img class="imgicon" src="/imission/images/eye.png" alt="user" width="20" height="15" title="<%=roleshm.get(user.getUser().getRole())%>"></img>
																<%} if(user.getUser().getStatus()!=null &&  user.getUser().getStatus().equals("deleted")) {
																%>
																<label class="borderlist" title="<%=roleshm.get(user.getUser().getRole())%>"><span class="orange"><%=user.getUser().getUsername().toUpperCase()%></span><%-- &nbsp;&nbsp;(<%=roleshm.get(user.getUser().getRole())%>) --%></label>
																<%} else{ 
																%>
																<label class="borderlist" title="<%=roleshm.get(user.getUser().getRole())%>"><%=user.getUser().getUsername().toUpperCase()%><%-- &nbsp;&nbsp;(<%=roleshm.get(user.getUser().getRole())%>) --%></label>
																<%} %>
															</li>
														</ul>
													<%}%>
												</div>
											</li>
										</ul>
									<%}%>
																	
								</div>
							</li>
						</ul>
				<%}%>
				</div>
			</li>
		</ul>
		<script>
			addOrgUserData('<%=selorg.getName()%>',<%=acuserct%>,<%=deluserct%>,<%=expuserct%>);
		</script>
	<%
		}%>
	</table>
	</div>
	</td>
	<td width="60%" style="float: left">
	<div style="height:400px;">
	<table id="orgtab" width="95%">
		<tr>
		<td style="padding-right:5px;" width="45%">
		<table width="100%" class="tab">
			<tr>
				<th>Organizations</th>
			</tr>
			<tr>
				<td><label style="margin-right:20px">Organization </label>
				<select type="text" id="selorg" name="selorg" style="min-width: 170px; min-height: 25px;margin-top:8px;" onchange="createUserchart()">
				<option value=""></option>
				<% for(Organization selorg : orglist) {%>
					<option value="<%=selorg.getName()%>"><%=selorg.getName()%></option>
				<%} %>
				</select>
					<canvas align="center" id="orgchart" style="height:260px; width:100%; float:center;margin-bottom:20px;"></canvas>
				</td>
			</tr>
		</table>
		</td>
		<td style="padding-right:5px;" width="45%">
		<table width="100%" class="tab">
			<tr>
				<th>Users</th>
			</tr>
			
			<tr>
				<td>
					<div align="center"><label  id="orglbl"  style="text-align:center;min-width: 170px; min-height: 20px;margin-top:8px;"></label></div>
					<canvas align="center" id="userchart" style="height:260px; width:100%; float:center;margin-bottom:20px;"></canvas>
				</td>
			</tr>
		</table>
		</td>
		</tr>
	</table>
	</div>
		
	</td>
	</tr>
	</table>
	
</body>
<script type="text/javascript">
<% UserDao udao = new UserDao();
List<User> userlist = new ArrayList<User>();
OrganizationDao orgdao =new OrganizationDao();
%>
addOrgUserData(" ",<%=totausrcnt%>,<%=totinausrcnt%>,<%=totexpusrcnt%>);
createChart('orgchart','<%=totaorgcnt%>','<%=totinaorgcnt%>');
createChart('userchart',<%=totausrcnt%>,<%=totinausrcnt%>,<%=totexpusrcnt%>);
</script>
<jsp:include page="/bootstrap-footer.jsp" flush="false" />	
</html>