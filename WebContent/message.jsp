<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Vector"%>
<%@page language="java" contentType="text/html" session="true" %>
  <%@page import="java.io.File"%>
  <jsp:include page="bootstrap.jsp" flush="false" >
   
   <jsp:param name="headTitle" value="Message" />
   </jsp:include>
      
	<%
	String message = request.getParameter("status");
	%>

   <%-- <h3><%=message%></h3> --%>
  
   <%if(message.trim().equals("Link send to mail Successfully..Plz Check Once..")) {%>
   		 <p style="font-size:16px;font-family: serif;"><h3><%=message%></h3>Click here to <a href="login.jsp"><strong>log in</strong></a></p>
   	<%}else if(message.trim().equals("Unable to send the mail")) {%>
   		 <p style="font-size:16px;font-family: serif;"><h3><%=message%></h3>Please Check internet and try again.Click here to resend link <a href="forgotpwd.jsp"><strong>log in</strong></a></p>
   	<%} else {%>
   	<h3><%=message%></h3>
   	<%} %>
   <jsp:include page="bootstrap-footer.jsp" flush="false" />