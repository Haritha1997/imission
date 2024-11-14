
<jsp:include page="/bootstrap.jsp" flush="false">
  <jsp:param name="title" value="Reports" />
  <jsp:param name="headTitle" value="Reports" />
  <jsp:param name="limenu" value="Reports" />
  <jsp:param name="lisubmenu" value="Reports" />
  <jsp:param name="breadcrumb" value="run"/>
</jsp:include>

<head>
<style type="text/css">
body {
	overflow: hidden;
}

.scheduleicon {
	width: 35px;
	height: 30px;
	display: block;
}
</style>
</head>

<body>
	<div class="row">
		<div class="col-md-12">
			<div class="panel panel-default">

				<table class="table table-condensed">
					<thead>
						<tr>
							<th>Name</th>
							<th>Description</th>
							<!-- <th>Action</th> -->
						</tr>
					</thead>
					<tbody>
						<tr>
							<td width="25%"><a
								href="onlineReport.jsp?lisubmenu=Reports&amp;reportId=local_Device-Uptime"
								title="Execute this report instantly">Uptime</a></td>
							<td>Overview of Online/Offline Router Uptime,Tunnel
								Uptime</td>
						</tr>
						<tr>
							<td width="25%"><a
								href="onlineReport.jsp?lisubmenu=Reports&amp;reportId=local_State-Change"
								title="Execute this report instantly">State Change</a></td>
							<td>Overview of Down Time,Down Duration,UP Time along with
								Total UP Time and Down Time Details</td>

						</tr>
						<tr>
							<td width="25%"><a
								href="onlineReport.jsp?lisubmenu=Reports&amp;reportId=local_Inventory-Report"
								title="Execute this report instantly">Inventory</a></td>
							<td>Overview of Node Name,Loopback IP Serial Number,Firmware
								Version,Location,Module Name,Module Revision,Discovered At and
								Status Details</td>
						</tr>
						<tr>
							<td width="25%"><a
								href="onlineReport.jsp?lisubmenu=Reports&amp;reportId=Data-Usage-Report"
								title="Execute this report instantly">Data Usage</a></td>
							<td>Overview of Upload/Download Data Usage of Both SIM Cards on Daily, Weekly and Monthly basis</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>

<jsp:include page="/bootstrap-footer.jsp" flush="false" />	

</body>
