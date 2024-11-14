
<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.hibernate.Session"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<% 
   Calendar cal = Calendar.getInstance();
   SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
   Date fromday = cal.getTime();
   cal.add(Calendar.DAY_OF_MONTH, 1);
   Date today = cal.getTime();
   String reportId = request.getParameter("reportId");
   String format = request.getParameter("format")==null?"PDF":request.getParameter("format");
   String choose = request.getParameter("choose")==null?"slnumber":request.getParameter("choose");
   String chooseinput = request.getParameter("chooseinput")==null?"":request.getParameter("chooseinput");
   String nodesel = request.getParameter("nodesel")==null?"all":request.getParameter("nodesel");
   String timeperiod = request.getParameter("timeperiod")==null?"today":request.getParameter("timeperiod");
   String fromdate = request.getParameter("fromdate")==null?sdf.format(fromday):request.getParameter("fromdate");
   String todate = request.getParameter("todate")==null?sdf.format(today):request.getParameter("todate");
   String orderby = request.getParameter("orderby")==null?"slnumber":request.getParameter("orderby");
   String ordertype = request.getParameter("ordertype")==null?"asc":request.getParameter("ordertype");
   String statustype = nodesel.equals("all")?"'up','down','inactive'": nodesel.equals("down")?"'down','inactive'":"'up'";
%>
<jsp:include page="/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Reports" />
  <jsp:param name="limenu" value="Inventory" />
  <jsp:param name="breadcrumb" value="<a href='report/database/index.htm'>Database</a>" />
  <jsp:param name="breadcrumb" value="<a href='report/database/reportList.htm'>List Reports</a>" />
  <jsp:param name="breadcrumb" value="run"/>
</jsp:include>

<head>
<link rel="stylesheet" href="css/jquery-ui.css">
<script src="js/jquery.js"></script>
<script src="js/jquery-ui.js"></script>
<style type="text/css">
.select{
	min-width:105px;
	max-width:105px;
}
th div 
{
	cursor:pointer;
}
#lightgerydiv
{
	position:relative;
	height:16px;
	background-color:#D9D9D9;
	text-align:center;
	font-weight:bold;
}
#greendiv
{
	height:16px;
	background-color:#aed581;
}

#reddiv
{
	height:16px;
	background-color:#FF6666;
}
#tab tr{
	border-bottom:1px solid #DDDDDD;
}
.iconsdiv img
{
	width:20px;
	height:20px;
}
#sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0;
  z-index: 1;
}
html, body {margin: 1; height: 100%; overflow-y: hidden}
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
	form.action = "runreport?reportid="+reportid+"&format="+format;
	form.submit();
	form.action = defaction;
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
			document.getElementById("daterangeid").style.display = "";
		else
			document.getElementById("daterangeid").style.display = "none";
	}
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
</script>
</head>

<form method="post" id="reportform" action="report/Inventory.jsp?reportId=<%=reportId%>">
<input hidden id="reportId" name="reportId" value="<%=reportId%>"/>
<div>
    <div>
        <div>
            <div class="panel-heading">
                <h3 class="panel-title"><%=reportId.replace("local_","")%></h3>
            </div>
            <div class="panel-body">
                        <!-- <div class="form-group">
                            <div class="col-md-1">
							<label> Format : </label>                    
                            </div>
							<div class="col-md-1">
							<select name="format" class="select">
								<option value="PDF" >PDF</option>
								<option value="EXCEL" <%if(format.equals("EXCEL")){%>selected <%}%>>EXCEL</option>
							</select>
							</div>
                        </div> -->	
						<div class="iconsdiv" style="max-width:15vh;width:15vh;float:right">
							<img onclick="displayFormats()" title="Export" src="/imission/images/export_icon.png"></img>
							<img id="pdficonid" style="display:none;position;absolute" title="PDF" src="/imission/images/pdf_icon.png" onclick="exportReport('PDF')"></img>
							<img id="exceliconid" style="display:none;position;absolute" title="Excel" src="/imission/images/excel_icon.png" onclick="exportReport('EXCEL')"></img>
							</div>
			</div>
             <%if(reportId.equals("local_Device-Uptime") || reportId.equals("local_State-Change")){%>
			<div class="panel-body">
                <%if(reportId.equals("local_Device-Uptime") ) {%> 			
                <div class="form-group">
                            <div class="col-md-1">
							<label> Select : </label>
							</div>
							<div class="col-md-1" >
                                <select id="nodesel" name="nodesel" class="select" onchange="showOrHideInput('nodesel')">
								<option value="all">All</option>
								<option value="up" <%if(nodesel.equals("up")){%>selected<%}%>>Monitored</option>
								<option value="down" <%if(nodesel.equals("down")){%>selected<%}%>>Down</option>
								<option value="single" <%if(nodesel.equals("single")){%>selected<%}%>>Single</option>
								</select>
                            </div>
							<div class="col-md-4" style="display:inline">
                            <select id="choose" name="choose" class="select" style="display:none;margin-right:4%;min-width:110px">
							   <option value="slnumber">Serial Number</option>
                               <option value="loopbackip" <%if(choose.equals("loopbackip")){%>selected<%}%> >Loopback IP</option>             
                            </select>
                            <input type="text" id="chooseinput" name="chooseinput" value="<%=chooseinput%>" style="display:none"></input>
							</div>
                    </div>
					
					<%} else if( reportId.equals("local_State-Change")) {%>
					<div class="form-group">
						<div class="col-md-1">
							<label> Select : </label>
						</div>
						<div class="col-md-1" >
                            <select id="choose" name="choose" class="select">
							<option value="slnumber">Serial Number</option>
							<option value="ipaddress" <%if(choose.equals("ipaddress")){%>selected<%}%>>IP Address</option>
							<option value="nodelabel" <%if(choose.equals("nodelabel")){%>selected<%}%>>Node Name</option>
							</select>
                        </div>
						<div class="col-md-1" style="display:inline">                     
                            <input type="text" id="chooseinput" name="chooseinput" style="width:120px" value="<%=chooseinput%>"></input>
						</div>                        
					</div>
					<%} %>
				</div>
					<div class="panel-body">			 
						<div class="form-group">
                            <div class="col-md-1">
							<label > Time Period : </label>
							</div>
							<div class="col-md-1" >
                                <select  id="timeperiod" name="timeperiod" class="select" onchange="showOrHideInput('timeperiod')">
								<option value="today">Today</option>
								<option value="yesterday" <%if(timeperiod.equals("yesterday")){%>selected<%}%>>Yesterday</option>
								<option value="lastweek" <%if(timeperiod.equals("lastweek")){%>selected<%}%>>Last Week</option>
								<option value="lastmonth" <%if(timeperiod.equals("lastmonth")){%>selected<%}%>>Last Month</option>
								<option value="lastquarter" <%if(timeperiod.equals("lastquarter")){%>selected<%}%>>Last Quarter</option>
								<option value="custom" <%if(timeperiod.equals("custom")){%>selected<%}%>>Custom</option>
								</select>
                            </div>
							<div class="col-md-5" id="daterangeid" style="display:none">
							<label style="min-width:110px;margin-right:3%"> Date Range : </label>
                            <input type="text" value="<%=fromdate%>" class="datepicker" id="fromdate" name="fromdate" class="select" style="margin-right:4%;"></input>
                            <input type="text" value="<%=todate%>" class="datepicker" id="todate" name="todate"></input>
							</div>
                        </div>
					</div>		
             <% }%>
			 </div>
			 </div>
			<div style="overflow-y:scroll; height:62vh;background-color:white;">
			<table class="table table-bordered" id="tab" width="100%">
	  <thead id="sticky">	  
	  	<tr>
	  <%if(reportId.equals("local_Inventory-Report"))
		  {%>
					 <th ><div valign="middle" onclick="setorderby('nodelabel','<%=orderby%>','<%=ordertype%>')">
					   Node Name
					   </div></th>
					<th><div valign="middle" onclick="setorderby('loopbackip','<%=orderby%>','<%=ordertype%>')">
					    Loopback IP
					</div></th>
					<th ><div valign="middle" onclick="setorderby('slnumber','<%=orderby%>','<%=ordertype%>')">
					    Serial Number
					</div></th>
					<th ><div valign="middle" onclick="setorderby('fwversion','<%=orderby%>','<%=ordertype%>')">
					    Firmware Version
					</div></th>
					<th ><div valign="middle" onclick="setorderby('location','<%=orderby%>','<%=ordertype%>')">
					    Location
					</div></th>
					<th ><div valign="middle" onclick="setorderby('modulename','<%=orderby%>','<%=ordertype%>')">
					     Module Name
					</div></th>
					<th><div valign="middle" onclick="setorderby('revision','<%=orderby%>','<%=ordertype%>')">
					     Module Revision
					</div></th>
					<th ><div valign="middle" onclick="setorderby('createdtime','<%=orderby%>','<%=ordertype%>')">
					     Discovered At
					</div></th>
					<th><div valign="middle" onclick="setorderby('status','<%=orderby%>','<%=ordertype%>')">
					     Status
					</div></th>
					<%} else if(reportId.equals("local_Device-Uptime")){%>
						<th ><div valign="middle" onclick="setorderby('nodelabel','<%=orderby%>','<%=ordertype%>')">
						Node Name
					   </div></th>
					   <th ><div valign="middle" onclick="setorderby('loopbackip','<%=orderby%>','<%=ordertype%>')">
					   IP Address
					   </div></th>
					   <th ><div valign="middle" onclick="setorderby('slnumber','<%=orderby%>','<%=ordertype%>')">
					   Serial Number
					   </div></th>
					   <th ><div valign="middle" onclick="setorderby('downper','<%=orderby%>','<%=ordertype%>')">
					   Down%
					   </div></th>
					   <th ><div valign="middle" onclick="setorderby('downper','<%=orderby%>','<%=ordertype%>')">
					   Down Duration
					   </div></th>
					   <th ><div valign="middle" onclick="setorderby('downper','<%=orderby%>','<%=ordertype%>')">
					   Up%
					   </div></th>
					   <th ><div valign="middle" onclick="setorderby('downper','<%=orderby%>','<%=ordertype%>')">
					   Up Duration
					   </div></th>
					<%}%>
				    </tr>
		</thead>
		<tbody id="rowdata">				
<%
		Connection conn = null;
		Statement stmt= null;
		ResultSet rs = null;
		Session hibsession = null;	  
	      try
		      {
			    	hibsession = HibernateSession.getDBSession();
			    	conn = ((SessionImpl)hibsession).connection();
					stmt = conn.createStatement();
					String qry="";
					if(reportId.equals("local_Inventory-Report"))
					{
						qry = "select nodelabel ,loopbackip, slnumber , fwversion,location, modulename, revision, createdtime, status from  Nodedetails order by "+orderby+" "+ordertype;
					rs=stmt.executeQuery(qry);
	            while(rs.next())
				{	
				%>
				
				<tr>
					<td>
					<%=rs.getString("nodelabel")==null?"":rs.getString("nodelabel")%>
					</td>
					<td>
					<%=rs.getString("loopbackip")==null?"":rs.getString("loopbackip")%>
					</td>
					<td>
					<%=rs.getString("slnumber")==null?"":rs.getString("slnumber")%>
					</td>
					<td>
					<%=rs.getString("fwversion")==null?"":rs.getString("fwversion")%>
					</td>
					<td>
					<%=rs.getString("location")==null?"":rs.getString("location")%>
					</td>
					<td>
					<%=rs.getString("modulename")==null?"":rs.getString("modulename")%>
					</td>
					<td>
					<%=rs.getString("revision")==null?"":rs.getString("revision")%>
					</td>
					<td>
					<%=rs.getString("createdtime")==null?"":rs.getString("createdtime")%>
					</td>
					<td>
					<%=rs.getString("status")==null?"":rs.getString("status").replace("up","Active").replace("down","Down").replace("inactive","Inactive")%>
					</td>
				</tr>
				<%}
				}
				else if(reportId.equals("local_Device-Uptime"))
				{
					qry = "select nd.nodelabel as nodelabel,nd.loopbackip as loopbackip,nout.slnumber as slnumber,"+
							"EXTRACT(EPOCH FROM (to_timestamp('"+todate+"','DD-MM-YYYY')-to_timestamp('"+fromdate+"','DD-MM-YYYY'))) as total_time_sec,"+ 
							"sum(EXTRACT(EPOCH FROM (COALESCE(nout.uptime,to_timestamp('"+todate+"','DD-MM-YYYY'),nout.uptime)-nout.downtime))) as downper  from m2mnodeoutages nout inner join nodedetails nd on nd.slnumber = nout.slnumber where nd.status in ("+statustype+") and nd."+choose+" like '%"+chooseinput+"%' and nout.downtime between to_date('"+fromdate+"' ,'DD-MM-YYYY') and to_date('"+todate+"','DD-MM-YYYY')  group by nout.slnumber,nd.nodelabel,nd.loopbackip"+ 
							" union select nd.nodelabel as nodelabel,nd.loopbackip as loopbackip,nout.slnumber as slnumber ,EXTRACT(EPOCH FROM (to_timestamp('"+todate+"','DD-MM-YYYY')-to_timestamp('"+fromdate+"','DD-MM-YYYY'))) as total_time_sec,0 as downper"+
							" from m2mnodeoutages nout inner join nodedetails nd on nd.slnumber = nout.slnumber where nd.status in ("+statustype+") and nd."+choose+" like  '%"+chooseinput+"%' and nout.downtime <  to_date('"+fromdate+"' ,'DD-MM-YYYY') or nout.downtime > to_date('"+todate+"','DD-MM-YYYY')"+
							" and nout.slnumber not in(select slnumber from m2mnodeoutages where downtime between to_date('"+fromdate+"' ,'DD-MM-YYYY') and to_date('"+todate+"','DD-MM-YYYY'))"+
							" group by nout.slnumber,nd.nodelabel,nd.loopbackip order by "+orderby+" "+ordertype;
				System.out.println(qry);
				rs=stmt.executeQuery(qry);
				 DecimalFormat df = new DecimalFormat("##.##");
	            while(rs.next())
				{	
	            	double tot_sec = rs.getDouble("total_time_sec");
	                double downsec = rs.getDouble("downper");
					double downperdou = (downsec/tot_sec)*100;
					double upperdou  = ((tot_sec-downsec)/tot_sec)*100;
	                String down_per = df.format(downperdou);
	                String up_per = df.format(upperdou);
	                String down_dur = (long) (downsec/(24*3600))+" days "+
	                        (long)(downsec/3600)%24+" hours "+ 
	                        (long)(downsec/60)%(60)+" min";
	                String up_dur = (long)(tot_sec-downsec) /(24*3600)+" days "+
	                        ((long)(tot_sec-downsec)/3600)%24+" hours "+
	                        ((long)(tot_sec-downsec)/60)%(60)+" min";
				%>
				<tr>
					<td align="center" width="14%">
					<%=rs.getString("nodelabel")==null?"":rs.getString("nodelabel")%>
					</td>
					<td align="center" width="14%">
					<%=rs.getString("loopbackip")==null?"":rs.getString("loopbackip")%>
					</td>
					<td align="center" width="14%">
					<%=rs.getString("slnumber")==null?"":rs.getString("slnumber")%>
					</td>
					<td align="center" width="14%">
					<div id="lightgerydiv">
					<div id="reddiv" style="width:<%=downperdou%>%;"> 
					<div style="position:absolute; left:0; top:0; text-align:center; width:100%; color:#000000"><%=down_per%>%</div>
					</div>
					</div>
					</td>
					<td align="center" width="14%">
					<%=down_dur%>
					</td>
					<td align="center" width="14%">
					<div id="lightgerydiv">				
					<div id="greendiv" style="width:<%=upperdou%>%;">
					<div style="position:absolute; left:0; top:0; text-align:center; width:100%; color:#000000"><%=up_per%>%</div>		
					</div>
					</div>
					</td>
					<td align="center" width="14%">
					<%=up_dur%>
					</td>
				</tr>
				<%}
				}
			}catch(Exception e)
				{
				e.printStackTrace();
				}
			finally
			{
				if(hibsession != null)
		    		hibsession.close();
				
					
				if(stmt != null)
					stmt.close();
				if(rs != null)
					rs.close();
			}%>
			</tbody>
			</table>
        </div>
		</div>
</form>

<jsp:include page="/bootstrap-footer.jsp" flush="false" />
