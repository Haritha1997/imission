

<%@page import="com.nomus.staticmembers.UserRole"%>
<%@page import="com.nomus.staticmembers.QueryGenerator"%>
<%@page import="org.hibernate.Session"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.*"%>
<%@page import="java.text.SimpleDateFormat"%>

<% 
    String nodename = null ;
	String loopbackip =null;
	 SimpleDateFormat sdf = new SimpleDateFormat("EEE, d MMM YYYY hh:mm:ss aaa");
    int row=1;
    String reportId = request.getParameter("reportId");
	String reporttype= request.getParameter("type")==null?"":request.getParameter("type");
	User user = (User)session.getAttribute("loggedinuser");
%>
<jsp:include page="/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="Reports" />
	<jsp:param name="headTitle" value="Activity List" />
	<jsp:param name="limenu" value="Reports" />
	<jsp:param name="lisubmenu"
		value="<%=request.getParameter(\"lisubmenu\")%>" />
</jsp:include>

<head>
<link rel="stylesheet" href="css/jquery-ui.css">
<script src="js/jquery.js"></script>
<script src="js/jquery-ui.js"></script>
<style type="text/css">
.select {
	min-width: 100px;
	max-width: 105px;
}

th div {
	cursor: pointer;
}

.iconsdiv img {
	width: 20px;
	height: 20px;
}

#sticky {
	position: -webkit-sticky;
	position: sticky;
	top: 0;
	z-index: 1;
}

html, body {
	margin: 1;
	height: 100%;
	overflow-y: hidden
}

#exportimg {
	width: 20px;
	height: 20px;
}
</style>
<script type="text/javascript">
var display = false;
$(function() {
        $( "#fromdate" ).datepicker({
            changeMonth: true,
            changeYear: true,
			dateFormat: 'dd-mm-yy'
        });
		$( "#todate" ).datepicker({
            changeMonth: true,
            changeYear: true,
			dateFormat: 'dd-mm-yy'
        });
    });
     function setorderby(orderby,prevorderby,prevordertype)
    {
    	var ordertype = "asc";
    	if(orderby == prevorderby)
    	{
    		if(prevordertype == "asc")
    			ordertype = "desc";
    	}
			var form = document.getElementById("reportform");
    		var input = document.createElement('input');
    	    input.setAttribute('name', 'orderby');
    	    input.setAttribute('value',orderby);
    	    input.setAttribute('type','hidden');
    	    form.appendChild(input);
			
    	    var type = document.createElement('input');
    	    type.setAttribute('name', 'ordertype');
    	    type.setAttribute('value',ordertype);
    	    type.setAttribute('type', 'hidden');
    	    form.appendChild(type);
    	    form.submit();
    }
function exportReport(format)
{
	var reportid = document.getElementById("reportId").value;
	var form = document.getElementById("reportform");
	var defaction = form.action;
	form.action = "/imission/report/runreport?reportid="+reportid+"&format="+format;
	form.submit();
	form.action = defaction;
}
function displayFormats()
{
	if(display)
	{
		display = false;
		document.getElementById("pdficonid").style.display = "none";
		document.getElementById("exceliconid").style.display = "none";		
	}
	else{
		display = true;
		document.getElementById("pdficonid").style.display = "";
		document.getElementById("exceliconid").style.display = "";
	}
}
function showOrHideInput(id)
{
	var option = document.getElementById(id).value;
	
	if(id == "nodesel")
	{
		if(option == "single")
		{
			document.getElementById("choose").style.display = "";
			document.getElementById("chooseinput").style.display = "";
		}
		else
		{
			document.getElementById("choose").style.display = "none";
			document.getElementById("chooseinput").style.display = "none";
		}
	}else if(id == "timeperiod")
	{
		if(option == "custom")
			document.getElementById("daterangeid").style.display = "inline";
		else
			document.getElementById("daterangeid").style.display = "none";
	}
}
function generateReport(type,repid)
{
	const form = document.createElement('form');
	form.method = 'post';
	form.action = "generateActivityReport";
	const field1 = document.createElement('input');

	field1.type = 'hidden';
	field1.name = 'activitytype';
	field1.value = type;
	form.appendChild(field1);
	const field2 = document.createElement('input');
	field2.type = 'hidden';
	field2.name = 'reportid';
	field2.value = repid;
	form.appendChild(field2);
	document.body.appendChild(form);
 	form.submit(); 
}
</script>
</head>
<form method="post" id="reportform" action="report/runreport">
	<input hidden id="reportId" name="reportId" value="<%=reportId%>" />
	<div class="row">
		<div class="col-md-12">
			<div class="panel-heading">
				<h3 class="panel-title" <%if(reportId.equals("Bulk-Config"))%>>
					Bulk Config
					<%if(reportId.equals("Bulk-Upgrade"))%>>Bulk Upgrade
					<%if(reportId.equals("Bulk-Reboot"))%>>Bulk Reboot
					<%if(reportId.equals("All-Devices"))%>>All Devices
				</h3>
			</div>
			<div class="panel-body">
				<%if(reportId.equals("All-Devices")){%>
				<div class="iconsdiv"
					style="max-width: 15vh; width: 15vh; float: right">
					<img onclick="displayFormats()" style="float: right;"
						title="Export" src="/imission/images/export_icon.png"></img>
					<img id="pdficonid" style="display:none;position;absolute" title="PDF" src="/imission/images/pdf_icon.png" onclick="exportReport('PDF')"></img>
					<img id="exceliconid" style="display:none;position;absolute" title="Excel" src="/imission/images/excel_icon.png" onclick="exportReport('EXCEL')"></img>
				</div>
				<%}%>
			</div>
			<div
				style="overflow-y: scroll; height: 62vh; background-color: white;">
				<table class="table table-condensed" id="tab">
					<thead id="sticky">
						<tr>
							<% if(reportId.equals("Bulk-Config")||reportId.equals("Bulk-Upgrade")||reportId.equals("Bulk-Reboot")){%>
							<th><div valign="middle">Time</div></th>
							<% if(reportId.equals("Bulk-Config")){%>
							<th><div valign="middle">Type</div></th>
							<%}%>
							<th><div valign="middle">Status</div></th>
							<th><div valign="middle">Status Info</div></th>
							<th><div valign="middle">Export Report</div></th>
							<%}
		if(reportId.equals("All-Devices")){%>
							<th width="7%"><div valign="middle">Node Label</div></th>
							<th width="8%"><div valign="middle">Connected IP</div></th>
							<th width="8%"><div valign="middle">Serial Number</div></th>
							<th width="8%"><div valign="middle">IMEI NO</div></th>
							<th width="6%"><div valign="middle">Location</div></th>
							<th width="7%"><div valign="middle">Config</div></th>
							<th width="7%"><div valign="middle">Upgrade</div></th>
							<th width="7%"><div valign="middle">Reboot</div></th>
							<%}%>
						</tr>
					</thead>
					<%
		Connection conn = null;
		Statement stmt= null;
		ResultSet rs = null;
		Statement stmt1 = null;
		ResultSet rs1 = null;
		Session hibsession = null;
		String slnumstr = QueryGenerator.getSlNumberStr(user);
		String locstr = QueryGenerator.getLocationsStr(user);
		String merged_qry = "prefix.organization ='" + user.getOrganization().getName() + "'";
		boolean and_added = false;
		if(!user.getRole().equals(UserRole.SUPERADMIN))
		{
			if (slnumstr.length() > 0) {
				and_added = true;
				merged_qry += "and ( " + slnumstr;
			}
			if (locstr.length() > 0) {
				if (!and_added)
					merged_qry += "and";
				else
					merged_qry += "or";
				merged_qry += locstr;
			}
			if (slnumstr.length() > 0)
				merged_qry += ")";
			}
		try
		{    
			hibsession = HibernateSession.getDBSession();
			conn = ((SessionImpl)hibsession).connection();
			stmt = conn.createStatement();
			stmt1 = conn.createStatement();
			
			String comments = "";//user.getUserComments();
			String qry = "select slnumber,ipaddress,imeinumber,nodelabel,location,(case when (lastconfig is not null and lastconfig > lastexport) then lastconfig  else lastexport end)  as lastconfig,lastreboot,lastupgrade from Nodedetails where "+merged_qry.replace("prefix.", "");
			if(reportId.equals("Bulk-Config")||reportId.equals("Bulk-Upgrade")||reportId.equals("Bulk-Reboot"))
			{
				qry = "select * from bulkactivity";
				if(!user.getRole().equals(UserRole.MAINADMIN))
					qry +=" where organization = '"+user.getOrganization().getName()+"'";
				if(user.getRole().equals(UserRole.ADMIN))
					qry +=" and (createdby_id = "+user.getId()+" or superior_id = "+user.getId()+" )";
				else if(user.getRole().equals(UserRole.SUPERVISOR) || user.getRole().equals(UserRole.MONITOR))
					qry +=" and createdby_id = "+user.getId();
				if(reporttype.equals("Edit"))
					qry += " and configtype in ('Edit','Export')";
				else 
					qry += " and configtype='"+reporttype+"'";
				
			}
			else{
			//if(comments.trim().length() != 0 && !comments.equalsIgnoreCase("all") && reportId.equals("All-Devices"))
			//	qry += " where slnumber in('"+user.getSlnumberlist().to replace(",","','")+"') order by slnumber";
			//}
				if(comments.trim().length() != 0 && !comments.equalsIgnoreCase("all") && reportId.equals("All-Devices"))
						qry += " order by slnumber";
					}
			
			rs=stmt.executeQuery(qry);
            while(rs.next())
			{	

    if(reportId.equals("All-Devices")){%>
					<tbody id="rowdata">

						<tr>
							<!-- Node Label -->
							<td>
								<%
		nodename = rs.getString("nodelabel");
		if(nodename == null)
		{
			out.print("NA");
		}
		else{
			out.print(nodename);
		}	
	%>
							</td>
							<!-- Loopback IP -->
							<td>
								<%
	loopbackip  = rs.getString("ipaddress");
	if(loopbackip == null)
	{
		out.print("-");
	}
	else{
		out.print(loopbackip);
	}	
%>
							</td>
							<!-- Device Serial Number -->
							<td>
								<%
		String deviceserialno = rs.getString("slnumber");
		if(deviceserialno == null || deviceserialno.equalsIgnoreCase("NA") || deviceserialno.equalsIgnoreCase("noSuchObject"))
		{
			out.print("");
		}
		else{
			out.print(deviceserialno);
		}	
	%>
							</td>
							<!-- IMEI Number -->
							<td>
								<%
		String imeino = rs.getString("imeinumber");
		if(imeino == null)
		{
			out.print("");
		}
		else{
			out.print(imeino);
		}	
	%>

							</td>
							<!-- Location -->
							<td>
								<%
		String location = rs.getString("location");
		if(location!= null)
		{
			out.print(location);
		}
		else
		 out.print("");
   
  %>
							</td>
							<!-- Config -->
							<td>
								<%
		
	    String lastconfig = rs.getString("lastconfig");
		if(lastconfig != null)
		{
			out.print(lastconfig);
		}
		else
		 out.print("");
		
   
  %>
							</td>
							<!-- Upgrade -->
							<td>
								<%
		
		String lastupgrade = rs.getString("lastupgrade");
		if(lastupgrade != null)
		{
			out.print(lastupgrade);
		}
		else
		 out.print("");
		
   
  %>
							</td>
							<!-- Reboot -->
							<td>
								<%
		
		String lastreboot = rs.getString("lastreboot");
		if(lastreboot != null)
		{
			out.print(lastreboot);
		}
		else
		 out.print("");
  %>
							</td>
						</tr>
						<% }else{
		String configid = rs.getString("configid"); 
		String selqry = "select (select count(status) from bulkactivitydetails where status='InProgress' and configid='"+configid+"') as inprogress,"+
				"(select count(status) from bulkactivitydetails where status='Success' and configid='"+configid+"') as success,"+
		         "(select count(status) from bulkactivitydetails where status='Fail' and configid='"+configid+"') as fail from bulkactivity where configid='"+configid+"'";
		rs1 = stmt1.executeQuery(selqry);
		String status_info = "InProgress : 0, Success : 0, Fail : 0";
		if(rs1.next())
		{
			status_info = "InProgress : "+rs1.getString(1)+", Success : "+rs1.getString(2)+", Fail : "+rs1.getString(3);
		} 
		%>
						<tr>
							<td>
								<%
		String configtime = sdf.format(rs.getTimestamp("configtime"));
		if(configtime != null)
		{
			out.print(configtime);
		}
		else
		 out.print("");
 		%>
							</td>
							<% if(reportId.equals("Bulk-Config")){%>
							<td>
								<%
		String configtype = rs.getString("configtype");
		if(configtype != null)
		{
			out.print(configtype);
		}
		else
		 out.print("");
 		%>
							</td>
							<%}%>
							<td>
								<%
		String status = rs.getString("status");
		if(status != null)
		{
			out.print(status);
		}
		else
		 out.print("");
 		%>
							</td>
							<td><%=status_info %></td>
							<td><img id="exportimg" title="Export"
								src="/imission/images/export_icon.png"
								onclick="generateReport('<%=reporttype%>','<%=configid%>')" />
							</td>
						</tr>

						<%}
		}
		}
		catch(Exception e)
		{
			e.printStackTrace();	
	    }
		finally
		{
		try{
			if(hibsession != null)
				hibsession.close();
			if(stmt != null && !stmt.isClosed())
				stmt.close();
			if(rs != null && !rs.isClosed())
				rs.close();	
			if(stmt1 != null && !stmt1.isClosed())
				stmt1.close();	
			if(rs1 != null && !rs1.isClosed())
				rs1.close();				
					}
		catch(Exception e)
		  {
			e.printStackTrace();
		  }
		}
     %>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</form>
<jsp:include page="/bootstrap-footer.jsp" flush="false" />
