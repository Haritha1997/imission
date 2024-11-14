<%@page import="com.nomus.m2m.pojo.OrganizationData"%>
<%@page import="com.nomus.m2m.dao.OrganizationDataDao"%>
<%@page import="com.nomus.staticmembers.DateTimeUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.nomus.m2m.pojo.Organization"%>
<%@page import="com.nomus.m2m.dao.OrganizationDao"%>
<%@page import="com.nomus.m2m.pojo.LoadBatch"%>
<%@page import="java.util.List"%>
<%@page import="com.nomus.m2m.dao.LoadBatchDao"%>

<%
	String orgname = request.getParameter("organName") == null ? "" : request.getParameter("organName");
	Date date = DateTimeUtil.getOnlyDate(new Date());
%>
<jsp:include page="/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="M2M Configuration" />
	<jsp:param name="headTitle" value="M2M Configuration" />
</jsp:include>
<head>
<link rel="stylesheet" href="/imission/css/jquery-ui.css">
<style type="text/css">


th,td {
	padding-left: 10px;
}
th,#coldata
{
	
	max-width:10%;
	width:10%;
}
#borderbot {
	width: 100%;
	height: 100%;
}

.red {
	color: #E55451;
}

.orange {
	color: orange;
}
.green
{
	color: #7BC342;
}
.black
{
	color: #000000;
}
.fa-plus
{
	font-weight:normal;
	font-size:8px;
	color:#7BC342;
	border:1px solid #7BC342;
}
.fa-minus
{
	font-weight:normal;
	font-size:8px;
	color:#7BC342;
	border:1px solid #7BC342;
}
#tab th label
{

}
#rowdata
{
	display:none;
}
.seltab
{
	border:1px solid #7BC342;
	margin-top:10px;
	margin-bottom:10px;
}
.seltab thead
{
	background-color: grey;
}
.seltab thead th
{
	color:white;
}
.panel
{
border: none;
}
.dropdown {
  position: relative;
  display: inline-block;
  float:right;
  top:1px;
  right:20px
}
.dropdown-content {
  display: none;
  position: absolute;
  background-color: #f1f1f1;
  z-index: 2;
}

.dropdown-content a {
  color: green;
  text-decoration: none;
  display: block;
}

.dropdown-content a:hover {background-color: #ddd;}

.dropdown:hover .dropdown-content {display: block;}
.content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 500px;
            height: 300px;
            background-color: #e8eae6;
            box-sizing: border-box;
            z-index: 100;
            display: none;
            /*to hide popup initially*/
        }
</style>
<script type="text/javascript">
function expandOrCompress(thid) 
{
	var theadobj = document.getElementById(thid+"head");
	var table = document.getElementsByClassName(thid+"tab")[0];
	if(theadobj.className == "fa fa-plus")
	{
		$("."+thid+"row").show();
		theadobj.className = 'fa fa-minus';
		if(!table.className.includes('seltab'))
		table.className = table.className +' seltab';
	}
	else if(theadobj.className == "fa fa-minus")
	{
		$("."+thid+"row").hide();
		theadobj.className = "fa fa-plus";
		table.className = table.className.replace(' seltab','');
	}
}
function expand(thid)// this function is used in boorstap.jsp so dont delete 
{
	var theadobj = document.getElementById(thid+"head");
	var table = document.getElementsByClassName(thid+"tab")[0];
	$("."+thid+"row").show();
	theadobj.className = 'fa fa-minus';
	if(!table.className.includes('seltab'))
		table.className = table.className +' seltab';
}
function compress(thid)// this function is used in boorstap.jsp so dont delete 
{
	var theadobj = document.getElementById(thid+"head");
	var table = document.getElementsByClassName(thid+"tab")[0];
	$("."+thid+"row").hide();
	theadobj.className = "fa fa-plus";
	table.className = table.className.replace(' seltab','');
}
function downloadBatchList(orgname)
{
	const form = document.createElement('form');
	form.method = 'post';
	form.action = "DownloadBatch?orgName="+orgname;
	document.body.appendChild(form);
 	form.submit(); 
}
</script>
</head>
<body>
	<div>
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title"><label style="margin-right:100px">
					Organization Name&emsp;:&emsp;
					<%=orgname%> </label>
					<label > Total Nodes &emsp;:&emsp;</label>
					<label  id="tnodect"> </label></h3>
			</div>
		</div>
	</div>
	<div class="dropdown">
     <img title="Download" src="/imission/images/excel_icon.png" style="width:30px;height:20px" onclick="downloadBatchList('<%=orgname%>')"></img>
    </div>
			<br />

			<%
				OrganizationDao orgdao = new OrganizationDao();
				OrganizationDataDao orgdatadao = new OrganizationDataDao();
				Organization selorg = orgdao.getOrganization(orgname);
				LoadBatchDao loaddao = new LoadBatchDao();
				List<LoadBatch> batchlist = selorg.getLoadBatchList();
				int tnodect = 0;
				for (LoadBatch batch : batchlist) {
					List<OrganizationData> orgdatalist = batch.getOrgdatalist();
					int count=0;
					int daysdiff = DateTimeUtil.getDaysDiff(date,batch.getValidUpTo());
					String status = (daysdiff < 0)?"Expired":(daysdiff < 30)?"About to Expire":"Active";
			%>
			<table  id="tab" class="<%=batch.getId()%>tab" width="98%" style="float: left;margin-bottom:50px" >
			<thead>
				<tr id="batchdiv" <%if ( daysdiff < 0) {%> class="red" <%} else if(daysdiff < 30) {%> class="orange" <%} else {%> class="green" <%} %>  id="stickyposition">
					<th colspan="2" style="min-width:20%">
					<label>BatchName&emsp;:&emsp;<%=batch.getBatchName()%></label>
					</th>
					<th colspan="2" style="min-width:20%">
					<label>ValidUpto&emsp;:&emsp;<%=DateTimeUtil.getDateString(batch.getValidUpTo())%></label>
					</th>
					<th colspan="2" style="min-width:20%">
					<label>No of nodes&emsp;:&emsp;<%=orgdatalist.size() %></label>
					</th>
					<th colspan="2" style="min-width:20%">
					<label>Status&emsp;:&emsp;<%=status%></label>
					</th>
					<th colspan="2" style="min-width:20%">
					<span id="<%=batch.getId()%>head" class="fa fa-plus" onclick="expandOrCompress('<%=batch.getId()%>')"></span>
					</th>
					<th>
					<%for(int i=8;i<10;i++) {%>
					<th>
					</th>
					<% } %>
				</tr>
				</thead>
				<tbody>
				<tr>
				</tr>
				<tr id="rowdata" class="<%=batch.getId()%>row">
					<th colspan="8" >
						<label style="margin:10px 0px 10px 0px">Node Serial Numbers : </label>
					<th>
				</tr>
				<% for (OrganizationData orgdata : orgdatalist) {
							if (count % 10 == 0) {
				%>
					
					<tr id="rowdata" class="<%=batch.getId()%>row">
						<%
						}
						%>
						<td id="coldata">
						<%String orgstats = orgdata.getStatus();%>
						<label <%if(orgstats.equalsIgnoreCase("fault") || orgstats.equalsIgnoreCase("manual")) { %> class="red" <%} else { %> class="black" <%}%> title="<%=orgstats%>" style="cursor:pointer"><%=orgdata.getSlnumber()%></label>
						</td>
						<%
							tnodect++;
							count++;
							}
				        if(count%10 != 0)
						for(int i=(count)%10;i<10;i++)
						{
						%>
						<td></td>
						<%} %>
					</tr>
				</tbody>	
			</table>
			<%
				}
			%>
		</div>
	</div>
</body>
<script>
document.getElementById('tnodect').innerHTML = '<%=tnodect%>'
</script>
<jsp:include page="/bootstrap-footer.jsp" flush="false" />