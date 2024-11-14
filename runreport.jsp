
<jsp:include page="/bootstrap.jsp" flush="false">
    <jsp:param name="title" value="Reports" />
    <jsp:param name="headTitle" value="Reports" />
    <jsp:param name="location" value="report" />
    <jsp:param name="breadcrumb" value="Reports" />
</jsp:include>

<style type="text/css">

[type="date"]::-webkit-inner-spin-button {
  display: none;
}
[type="date"]::-webkit-calendar-picker-indicator {
  opacity: 0;
}

label {
  display: inline;
}
input {
  text-align:middle;
  border: 1px solid #c4c4c4;
  border-radius: 5px;
  background-color: #fff;
  padding: 3px 5px;
  box-shadow: inset 0 3px 6px rgba(0,0,0,0.1);
  width: 190px;
}


</style>
<div class="row">
    <div class="col-md-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Run Online Report</h3>
            </div>
            <div class="panel-body">
                <form id="parameters" class="form-horizontal" role="form" action="m2m/generateexcelreport.jsp?reptype=devicestatus" method="post">
                    <div class="form-group">
                        <div class="col-md-6">
                            <label for="formatSelect">Select Dates:</label><br/><br/><br/>
                             From : <input type="date" name="fromdate" required />
							 To : <input type="date" name="todate" required />
                        </div>

                    </div>

                    <div class="form-group">
                        <div class="col-md-2">
                            <input type="submit" class="btn btn-default" value="run report" id="run">&nbsp;
                        </div>
                    </div>

                </form>
            </div>
        </div>

    </div>
</div>
<jsp:include page="/bootstrap-footer.jsp" flush="false" />