
<%@ taglib prefix='c' uri='http://java.sun.com/jsp/jstl/core' %>
<%@page import="com.nomus.staticmembers.UserRole"%>
<%@page import="com.nomus.m2m.dao.UserDao"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<jsp:include page="bootstrap.jsp" flush="false">
  <jsp:param name="title" value="Log out" />
  <jsp:param name="nonavbar" value="true" />
</jsp:include>
<div class="row">
  <div class="col-md-4">
    <h2>Password Expired .</h2>
    <p>Click here to <a href="resetpassword.jsp"><strong>Reset the Password</strong></a>.</p>
  </div>
</div>

<hr />

<jsp:include page="bootstrap-footer.jsp" flush="false" />
