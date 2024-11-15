<jsp:include page="/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Excel Reports" />
  <jsp:param name="headTitle" value="Excel Reports" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>Admin</a>" />
  <jsp:param name="breadcrumb" value="Excel Reports" />
  <jsp:param name="enableExtJS" value="false"/>
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
                        <div class="panel-heading">
                            <h3 class="panel-title">Local Report Repository</h3>
                        </div>
                        <table class="table table-condensed">
                            <thead>
                            <tr>
                                <th>Name</th>
                                <th>Description</th>
                                <th colspan="3" style="width: 1px; text-align: center;">Action</th>
                            </tr>
                            </thead>
                                
                            
                                <tbody><tr>
                                   
                            
                                <tr>
                                    <td width="25%">Inventory report</td>
                                    <td>Global overview of  Loopback IP, Serial Number and Firmware version </td>
									<td class="o-report-online"><a href="m2m/generateexcelreport.jsp?reptype=inventory" title="Execute this report instantly" target="_blank"></a></td>                                                                                                                                                                  
                                </tr>                            
                                <tr>
                                    <td width="25%">Device Status report</td>
                                    <td>Global overview of  Online/Offline status,Router Uptime Details</td>
                                    <td class="o-report-online"><a href="m2m/runreport.jsp?reptype=devicestatus" title="Execute this report instantly" target="_blank"></a></td>                                                                       
                                </tr>
                            
                        </tbody></table>
                    </div>
                </div>
            </div>

        
    









  <!-- End of Content -->
  <div class="spacer"><!-- --></div>



  

  
    <!-- Footer -->

    <footer id="footer">
      <p>
       <!-- OpenNMS <a href="support/about.jsp">Copyright</a> &copy; 2002-2015
        <a href="http://www.opennms.com/">The OpenNMS Group, Inc.</a>
        OpenNMS&reg; is a registered trademark of
        <a href="http://www.opennms.com">The OpenNMS Group, Inc.</a>--><!--anusha-->
		<b>iMission</b> Copyright © 2018 by <a href="https://nomus.in/">Nomus Comm-Systems Private Limited</a>.All rights reserved.
		
      </p>
    </footer>
  





</div><!-- id="content" class="container-fluid" -->





<iframe src="javascript:''" id="coreweb" style="position: absolute; width: 0px; height: 0px; border: medium none;" tabindex="-1"></iframe></body></html>