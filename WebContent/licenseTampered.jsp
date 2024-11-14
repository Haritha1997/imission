<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Vector"%>
<%@page language="java" contentType="text/html" session="true" %>
  <%@page import="java.io.File"%>
  <jsp:include page="bootstrap.jsp" flush="false" >
   
   <jsp:param name="headTitle" value="Message" />
   </jsp:include>
      
	<p style="font-size:16px;font-family: serif;">License Tampered... Please go to<a href="licensedetails.jsp"> License Details<strong></strong></a> to verify.</p>
   <jsp:include page="bootstrap-footer.jsp" flush="false" />