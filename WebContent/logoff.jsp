
<%@ taglib prefix='c' uri='http://java.sun.com/jsp/jstl/core' %>

<jsp:include page="bootstrap.jsp" flush="false">
  <jsp:param name="title" value="Log out" />
  <jsp:param name="nonavbar" value="true" />
</jsp:include>
<%
HttpServletResponse httpresponse = (HttpServletResponse) response;
httpresponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
httpresponse.setHeader("Pragma", "no-cache"); // HTTP 1.0.
httpresponse.setDateHeader("Expires", 0);
%>
<div class="row">
  <div class="col-md-4">
    <h2>You have been logged out.</h2>
    <p>You may <a href="login.jsp"><strong>log in</strong></a> again.</p>
  </div>
</div>

<hr />

<jsp:include page="bootstrap-footer.jsp" flush="false" />
