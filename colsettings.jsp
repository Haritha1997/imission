<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<jsp:include page="/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="Column Settings" />
	<jsp:param name="headTitle" value="New" />
	<jsp:param name="breadcrumb" value="Column Settings" />
</jsp:include>
<!DOCTYPE html>
<html>
	<head>
	<link rel="stylesheet" href="/imission/css/jquery-ui.css">
	<link rel="stylesheet" href="/imission/css/style.css">
	<script src="/imission/js/jquery.js"></script>
	<script src="/imission/js/jquery-ui.js"></script>
	<style>
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
		.btn {
	padding-left: 10px;
	padding-top:2px;
	padding-bottom:2px;
	margin-top:4px;
}
#confsearch,#viewsearch
{	
	text-align:left;
	padding-left:23px;
	outline:none;
}
.form-group {
	margin: 10px;
}
	</style>
	<script type="text/javascript">
	function doFilter(tableid,searchid)
	{  
		 var $cols = $('#'+tableid+' #rowdata #coldata');
	     var val = $.trim($('#'+searchid).val()).replace(/ +/g, ' ').toLowerCase();
	     $cols.show().filter(function() {
	         var text = $(this).text().replace(/\s+/g, ' ').toLowerCase();
	         return !~text.indexOf(val);
	     }).hide();
	     
	}
	function checkAll(tableid,searchid)
	{
		var table = document.getElementById(tableid);
		var tablerows = table.rows;
		var searchval = document.getElementById(searchid).value.toLowerCase();
			for (var i = 2; i < tablerows.length; i++) {
				var cols = tablerows[i].cells;
				for(var k=0;k<cols.length;k++) {
					var obj = cols[k].childNodes[0];
				 	 if(obj.value.toLowerCase().includes(searchval))
					  obj.checked = true;
			}
		}
	}
	function uncheckAll(tableid,searchid)
	{
		var table = document.getElementById(tableid);
		var tablerows = table.rows;
		var searchval = document.getElementById(searchid).value.toLowerCase();
			for (var i = 2; i < tablerows.length; i++) {
				var cols = tablerows[i].cells;
				for(var k=0;k<cols.length;k++) {
					var obj = cols[k].childNodes[0];
				 	 if(obj.value.toLowerCase().includes(searchval))
					  obj.checked = false;
			}
		}
	}
	function CancleCols()
	{
		window.location.href = "/imission/account/index.jsp";
	}
	</script>
	</head>
	<body>
	<form id="colsetform" class="form-horizontal" method="post" action="userColumnsController">
	<table width="100%" align="center" id="col_setting" name="col_setting">
		<tr>
			<td class="col-sm-5" style="float: left; padding-right: 5px;">
				<table class="tab" width="100%" id="config_col" name="config_col">
					<tr>
						<th colspan="4">Configuration Columns</th>
					</tr>
					<tr  style="border:1px solid #7BC342; border-radius: 25px;">
								<td colspan="2"><label><label class="btn btn-default" name="conf_sel_all" id="conf_sel_all" onclick="checkAll('config_col','confsearch')">&nbsp;&nbsp;All</label>&nbsp;&nbsp;
								<label class="btn btn-default" name="conf_none" id="conf_none" onclick="uncheckAll('config_col','confsearch')">&nbsp;&nbsp;None</label></label></td>
								<td colspan="2" style="text-align:center;">
									<div class="input-icons" style="float:right;padding-right:5px">
										<i class="fa fa-search icon"></i><input class="input-field" type="text" title="search" id="confsearch"  style="width:150px;" onkeyup="doFilter('config_col','confsearch')" onkeydown="doaction(event)">
									</div>
								</td>
							</tr>
					<% String labelname_arr[]={"config_colimeinumber","config_colipaddress","config_colslnumber","config_colnodelabel","config_collocation","config_coluptime","config_colstatus","config_colfwversion","config_colsignalstrength","config_colloopbackip","config_colrouteruptime","config_colactivesim","config_colnetwork","config_colcpuutil","config_colmemoryutil","config_colmodelnumber","config_colport1","config_colport2","config_colport3","config_colport4","config_colcellid","config_colmhversion","config_coldhversion","config_colmodulename","config_colnwband","config_coliccid"};
						int count = 0;
						for (String labelname : labelname_arr) {
							if (count % 3 == 0) {
								if (count != 1) {
						}
					%>
									
									<tr id="rowdata">
										<%
											}
										%>
										<td id="coldata"><input type="checkbox" id="<%=labelname%>" name="<%=labelname%>" value="<%=labelname%>"> <label><%=labelname%></label>
										</td>
										<%
											count++;
											}
										%>
									</tr>
				</table>
			</td>
			<td class="col-sm-5" style="float: left; padding-right: 5px;">
				<table class="tab" width="100%" id="view_col" name="view_col">
					<tr>
						<th colspan="4">View Columns</th>
					</tr>
					<tr  style="border:1px solid #7BC342; border-radius: 25px;">
								<td colspan="2"><label><label class="btn btn-default" name="view_sel_all" id="view_sel_all" onclick="checkAll('view_col','viewsearch')">&nbsp;&nbsp;All</label>&nbsp;&nbsp;
								<label class="btn btn-default" name="view_none" id="view_none" onclick="uncheckAll('view_col','viewsearch')">&nbsp;&nbsp;None</label></label></td>
								<td colspan="2" style="text-align:center;">
									<div class="input-icons" style="float:right;padding-right:5px">
										<i class="fa fa-search icon"></i><input class="input-field" type="text" title="search" id="viewsearch"  style="width:150px;" onkeyup="doFilter('view_col','viewsearch')" onkeydown="doaction(event)">
									</div>
								</td>
							</tr>
					<% String viewlabelname_arr[]={"view_colimeinumber","view_colipaddress","view_colslnumber","view_colnodelabel","view_collocation","view_coluptime","view_colstatus","view_colfwversion","view_colsignalstrength","view_colloopbackip","view_colrouteruptime","view_colactivesim","view_colnetwork","view_colcpuutil","view_colmemoryutil","view_colmodelnumber","view_colport1","view_colport2","view_colport3","view_colport4","view_colcellid","view_colmhversion","view_coldhversion","view_colmodulename","view_colnwband","view_coliccid"};
						count = 0;
						for (String labelname : viewlabelname_arr) {
							if (count % 3 == 0) {
								if (count != 1) {
						}
					%>
						<tr id="rowdata">
							<%
								}
							%>
							<td id="coldata"><input type="checkbox" id="<%=labelname%>" name="<%=labelname%>" value="<%=labelname%>"> <label><%=labelname%></label>
							</td>
							<%
								count++;
								}
							%>
						</tr>
				</table>
			</td>
		</tr>
	</table>
	<br/>
	<div class="form-group">
				<div class="col-sm-offset-2 col-sm-10">
					<div class="btn-group" role="group" style="padding-right: 20px;">
						<button type="submit" class="btn btn-default">Submit</button>
					</div>
					<div class="btn-group" role="group">
						<button type="button" class="btn btn-default" onclick="CancleCols()">Cancel</button>
					</div>
				</div>
	</div>
	</form>
	</body>
</html>
<jsp:include page="/bootstrap-footer.jsp" flush="false" />