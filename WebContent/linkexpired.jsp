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
	<%if(message.trim().equals("Link Expired")) {%>
   		<p style="font-size:16px;font-family: serif;">This Link is Expired..Click here to <a href="forgotpwd.jsp"> <strong>Reset Password</strong></a> again.</p>
   <%}else if(message.trim().equals("Password Updated Successfully")) {%>	
   		 <p style="font-size:16px;font-family: serif;"><h3><%=message%></h3>Click here to <a href="login.jsp"><strong>log in</strong></a> again.</p>
   <%}else if(message.trim().equals("Reset Link sent to mail Successfully..Check mail once..")) {%>	
   		 <p style="font-size:16px;font-family: serif;"><h3><%=message%></h3>Click here to <a href="login.jsp"><strong>log in</strong></a> again.</p>
   	<%}else if(message.trim().equals("Unable to sent the mail")) {%>	
   		 <p style="font-size:16px;font-family: serif;"><h3><%=message%></h3>Click here to <a href="login.jsp"><strong>log in</strong></a> again.</p>
   	<%}%>
   <jsp:include page="bootstrap-footer.jsp" flush="false" />