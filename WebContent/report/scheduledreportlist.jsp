
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.nomus.m2m.dao.M2MSchReportsDao"%>
<%@page import="com.nomus.m2m.pojo.M2MSchReports"%>
<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.hibernate.Session"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.nomus.m2m.pojo.User"%>

<jsp:include page="/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="Reports" />
	<jsp:param name="headTitle" value="Schedule Reports List" />
	<jsp:param name="limenu" value="Reports" />
	<jsp:param name="lisubmenu" value="Schedule Reports" />
	<jsp:param name="breadcrumb" value="run" />
</jsp:include>
<head>
<script type="text/javascript">
function deleteSelected()
{ 
  const form = document.createElement('form');
  form.method = 'post';
  form.action = "deleteScheduleReports";
  
   var cnt = document.getElementById("cnt").value;
   var delids="";
   for(var i=1;i<=cnt;i++)
	{
	   if(document.getElementById("checkbox"+i).checked)
	   {
	     if(delids.length > 0)
	    	 delids +="','";
	     delids += document.getElementById("id"+i).value;
	   }
	}
   const hiddenField = document.createElement('input');
      hiddenField.type = 'hidden';
      hiddenField.name = 'ids';
      hiddenField.value = delids;
  
  if(delids.length > 0)
  {
    form.appendChild(hiddenField);
 	document.body.appendChild(form);
  	form.submit();
  }
}
</script>
</head>
<%
int cnt=0;
User user = (User)session.getAttribute("loggedinuser");
%>
<div>
	<table id="tab" class="table table-condensed" height="99%">
		<thead id="sticky">
			<tr>
				<th width="20%">Name</th>
				<th width="20%">Next Fire Time</th>
				<th width="30%">Report Parameters</th>
				<th width="10%">Select</th>
			</tr>
		</thead>
		<tbody id="rowdata">
			<%
			try
			      {
					M2MSchReportsDao schdao = new M2MSchReportsDao();
				    List<M2MSchReports> schlist = schdao.getM2MSchReports(user);
				for (M2MSchReports m2mschrep : schlist) {
					cnt++;
			%>
			<tr>
				<td class="divider bright"><%=m2mschrep.getName()%></td>
				<td><%=m2mschrep.getNextfiretime()%></td>
				<td>
					<table class="borderlesstab">
						<tr>
							<td style="min-width: 30%; max-width: 30%">Format</td>
							<td style="min-width: 60%; max-width: 70%">:&nbsp;<%= m2mschrep.getFormat()%></td>
						</tr>
						<!-- <tr>
         	  	  <td style="min-width:30%;max-width:30%">Filter</td>
         	  	  <td style="min-width:60%;max-width:70%">:&nbsp;</td>
         	  </tr>
         	  <tr>
         	  	  <td style="min-width:30%;max-width:30%">Filter Value</td>
         	  	  <td style="min-width:60%;max-width:70%">:&nbsp;</td>
         	  </tr> -->
						<tr>
							<td style="min-width: 30%; max-width: 30%">Type</td>
							<td style="min-width: 60%; max-width: 70%">:&nbsp;<%=m2mschrep.getNodetype()%></td>
						</tr>
						<tr>
							<td style="min-width: 30%; max-width: 30%">Schedule type</td>
							<td style="min-width: 60%; max-width: 70%">:&nbsp;<%=m2mschrep.getTimeperiod().replace("last","")%></td>
						</tr>
						<tr>
							<td style="min-width: 30%; max-width: 30%">Email</td>
							<td style="min-width: 60%; max-width: 70%">:&nbsp;<%=m2mschrep.getEmail()%></td>
						</tr>
					</table>

				</td>
				<td><input type="checkbox" id="checkbox<%=cnt%>"
					name="checkbox<%=cnt%>"></input><input type="hidden"
					id="id<%=cnt%>" name="id<%=cnt%>" value="<%=m2mschrep.getId()%>"></input>
				</td>
			</tr>

			<%}
      }
      catch(Throwable e)
      {
    	  e.printStackTrace();
      }
      finally
      {
      }
      %>
		</tbody>
	</table>
	<input type="hidden" id="cnt" value="<%=cnt%>" />
	<button class="btn btn-default" onclick="deleteSelected()">Delete</button>
</div>
<jsp:include page="/bootstrap-footer.jsp" flush="false" />
