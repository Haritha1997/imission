
<%@page import="com.nomus.m2m.dao.M2MDetailsDao"%>
<%@page import="com.nomus.m2m.pojo.M2MDetails"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.*"%>
<%@page language="java"
	contentType="text/html"
	session="true"
%>
<jsp:include page="/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="M2M Configuration" />
	<jsp:param name="headTitle" value="M2M Configuration" />
</jsp:include>

<%
  	String httpserverpath = null;
  	int port = 0;
  	String tlsconfigspath = null;
  	String firmwaredir = null;
  	String enabledebug = null;
  	int readtimeout = 0;
  	int daysforinactive = 0;
  	String mailusername = null;
  	String mailpassword = null;
  	M2MDetailsDao m2mdao = new M2MDetailsDao();
  	M2MDetails m2mdls = m2mdao.getM2MDetails(1);
  	if(m2mdls != null)
  	{
	  	port = m2mdls.getPort() == 0 ? 2222 : m2mdls.getPort();
	  	httpserverpath = m2mdls.getHttpserverpath()==null ? "" :m2mdls.getHttpserverpath();
	  	tlsconfigspath = m2mdls.getTlsconfigspath()==null ? "" :m2mdls.getTlsconfigspath();
	  	firmwaredir = m2mdls.getFirmwaredir()==null ? "" :m2mdls.getFirmwaredir();
	  	enabledebug = m2mdls.getEnabledebug()==null ? "" :m2mdls.getEnabledebug();
	  	readtimeout =m2mdls.getReadtimeout() == 0 ? 10 : m2mdls.getReadtimeout();
	  	daysforinactive = m2mdls.getDaysforinactive() == 0 ? 2 : m2mdls.getDaysforinactive();
	  	mailusername = m2mdls.getUsername()==null ? "" : m2mdls.getUsername();
	  	mailpassword = m2mdls.getPassword()==null ? "" : m2mdls.getPassword();
	  	
  	}
  %>
  <script type="text/javascript">
  function validateM2MConfig() 
  {
	  var altmsg="";
	  var portobj=document.getElementById("port");
	  var httpserpathobj=document.getElementById("httpserverpath");
	  var tlsconobj=document.getElementById("tlsconfigspath");
	  var firmdirobj=document.getElementById("firmwaredir");
	  var rdtmoutobj=document.getElementById("readtimeout");
	  var inactdaysobj=document.getElementById("daysforinactive");
	  var numformat=/^[0-9]+$/;
	  if(portobj.value.trim()=="")
	  {
	  	altmsg+="Port Number Should Not be Empty!\n";
	  	portobj.style.outline="thin solid red";
	  }
	  else if(!portobj.value.match(numformat)||portobj.value<1||portobj.value>65535)
	  {
		  altmsg+="Invalid Port Number!\n";
		  portobj.style.outline="thin solid red";
	  }
	  if(httpserpathobj.value.trim()=="")
	  {
		  	altmsg+="HTTP Server Path Should Not be Empty!\n";
		  	httpserpathobj.style.outline="thin solid red";
	  }
	  if(tlsconobj.value.trim()=="")
	  {
		  	altmsg+="TLS Configuration Path Should Not be Empty!\n";
		  	tlsconobj.style.outline="thin solid red";
	  }
	  if(firmdirobj.value.trim()=="")
	  {
		  	altmsg+="Firmware Directory Path Should Not be Empty!\n";
		  	firmdirobj.style.outline="thin solid red";
	  }
	  if(rdtmoutobj.value.trim()=="")
	  {
		  	altmsg+="Read Timeout Should Not be Empty!\n";
		  	rdtmoutobj.style.outline="thin solid red";
	  }
	  else if(!rdtmoutobj.value.match(numformat))
	  {
		  altmsg+="Invalid Read Timeout!\n";
		  rdtmoutobj.style.outline="thin solid red";
	  }
	  if(inactdaysobj.value.trim()=="")
	  {
		  	altmsg+="Down time For Inactive Should Not be Empty!\n";
		  	inactdaysobj.style.outline="thin solid red";
	  }
	  else if(!inactdaysobj.value.match(numformat))
	  {
		  altmsg+="Invalid Down time For Inactive!\n";
		  inactdaysobj.style.outline="thin solid red";
	  }
	  if (altmsg.trim().length == 0) 
		  return true;
	  else 
	  {
		alert(altmsg);
		return false;
	  }
}
</script>
<body>

	<form class="form-horizontal" method="post"
		action="savem2msettings" onsubmit="return validateM2MConfig()">
		<div class="row top-buffer">
			<div class="col-md-4">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">M2M Configuration Settings</h3>
					</div>
					<div class="panel-body">
						<div class="form-group">
							<label for="port" class="col-sm-6 control-label">Port
								Number:</label>
							<div class="col-sm-6">
								<input name="port" id="port"
									value="<%=port%>" min="1" max="65535"></input>
							</div>
						</div>
						<div class="form-group">
							<label for="httpserverpath" class="col-sm-6 control-label">HTTP
								Server Path :</label>
							<div class="col-sm-6">
								<input name="httpserverpath"  id="httpserverpath"
									value="<%=httpserverpath%>"></input>
							</div>
						</div>
						<div class="form-group">
							<label for="tlsconfigspath" class="col-sm-6 control-label">TLS
								Configuration Path :</label>
							<div class="col-sm-6">
								<input name="tlsconfigspath" id="tlsconfigspath"
									value="<%=tlsconfigspath%>"></input>
							</div>
						</div>
						<div class="form-group">
							<label for="firmwaredir" class="col-sm-6 control-label">Firmware
								Directory Path :</label>
							<div class="col-sm-6">
								<input name="firmwaredir" id="firmwaredir"
									value="<%=firmwaredir%>"></input>
							</div>
						</div>
						<div class="form-group">
							<label for="readtimeout" class="col-sm-6 control-label">Read
								Timeout (mins) :</label>
							<div class="col-sm-6">
								<input name="readtimeout" id="readtimeout"
									value="<%=readtimeout%>"></input>
							</div>
						</div>
						<div class="form-group">
							<label for="daysforinactive" class="col-sm-6 control-label">Down
								time For Inactive (Days) :</label>
							<div class="col-sm-6">
								<input name="daysforinactive" id="daysforinactive"
									value="<%=daysforinactive%>"></input>
							</div>
						</div>
						<!-- form-group -->
						<div class="panel-footer" align="center">
							<button align="center" type="submit" class="btn btn-default">Submit</button>
						</div>
					</div>
				</div>

			</div>
		</div>

	</form>
</body>

<jsp:include page="/bootstrap-footer.jsp" flush="false" />
