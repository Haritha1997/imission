<jsp:include page="/bootstrap.jsp" flush="false">
  <jsp:param name="title" value="Reports" />
  <jsp:param name="headTitle" value="Activity List" />
   <jsp:param name="limenu" value="Reports"/>
   <jsp:param name="lisubmenu" value="<%=request.getParameter(\"lisubmenu\")%>"/>
  </jsp:include>

<script type="text/javascript">
if (window.location != window.parent.location) {
  // Hide the header
  $("#header").hide();
  // Remove any padding from the body
  $("body.fixed-nav").attr('style', 'padding-top: 0px !important');
}
</script>
                <div class="row">
                    <div class="col-md-12">
                    <div class="panel panel-default">                    
                        <table class="table table-condensed">
                            <thead>
                            <tr>
                                <th>Name</th>
                                <th>Description</th>
                                <!--<th colspan="2" style="width: 1px; text-align: center;">Action</th>-->
                            </tr>
                            </thead>
                                
                               <tbody>
                                   <!-- <tr>
                                    <td width="25%"><a style="text-decoration:none;" href="/imission/activity/bulkoperations.jsp?lisubmenu=Activity&reportId=Bulk-Config&type=Edit">Bulk Config</a></td>
                                    <td>overview of Serial Number,IMEI NO,Status and Timestamp of Bulk Configuration.</td>
									<td class="o-report-online"><a href="/imission/report/onlineReport.jsp?lisubmenu=Activity&reportId=Bulk-Config" title="Execute this report instantly" target="_blank"></a></td>
                                    <td class="o-report-schedule"><a href="" title="Create a schedule for this report"  target="_blank"></a></td>									
                                </tr>    -->                         
								<tr>
                                    <td width="25%"><a style="text-decoration:none;"  href="/imission/activity/bulkoperations.jsp?lisubmenu=Activity&reportId=Bulk-Upgrade&type=Upgrade">Bulk Upgrade</a></td>
                                    <td>overview of Serial Number,IMEI NO,Status and Timestamp of Bulk Upgradation.</td>
                                    <!--<td class="o-report-online"><a href="/imission/report/onlineReport.jsp?lisubmenu=Activity&reportId=Bulk-Upgrade" title="Execute this report instantly" target="_blank"></a></td> 
                                    <td class="o-report-schedule"><a href="" title="Create a schedule for this report"  target="_blank"></a></td>-->									
                                </tr>
								<tr>
                                    <td width="25%"><a style="text-decoration:none;" href="/imission/activity/bulkoperations.jsp?lisubmenu=Activity&reportId=Bulk-Reboot&type=Reboot">Bulk Reboot</a></td>
                                    <td>overview of Serial Number,IMEI NO,Status and Timestamp of Bulk Reboot.</td>
									<!--<td class="o-report-online"><a href="/imission/report/onlineReport.jsp?lisubmenu=Activity&reportId=Bulk-Reboot" title="Execute this report instantly" target="_blank"></a></td>
									<td class="o-report-schedule"><a href="" title="Create a schedule for this report"  target="_blank"></a></td>-->
                                </tr>
								<tr>
                                    <td width="25%"><a style="text-decoration:none;" href="/imission/activity/bulkoperations.jsp?lisubmenu=Activity&reportId=All-Devices">All Devices</a></td>
                                    <td>overview of Node Label,Loopback IP Address,Serial Number,IMEI NO,Location,Status and Timestamp of Config,Upgrade and Reboot.</td>
									<!--<td class="o-report-online"><a href="/imission/report/onlineReport.jsp?lisubmenu=Activity&reportId=All-Devices" title="Execute this report instantly" target="_blank"></a></td>
									<td class="o-report-schedule"><a href="" title="Create a schedule for this report"  target="_blank"></a></td>-->
                                </tr>
                        </tbody></table>
                    </div>
                </div>
            </div>
<jsp:include page="/bootstrap-footer.jsp" flush="false" />