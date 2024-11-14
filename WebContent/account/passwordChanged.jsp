
<%@page language="java"
	contentType="text/html"
	session="true"
%>
<jsp:include page="/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Password Changed" />
  <jsp:param name="headTitle" value="Password Changed" />
  <jsp:param name="breadcrumb" value="<a href='account/selfService/index.jsp'>Self-Service</a>" />
  <jsp:param name="breadcrumb" value="Password Changed" />
</jsp:include>

<h3>Password changed successfully.</h3>

<jsp:include page="/bootstrap-footer.jsp" flush="false" />

