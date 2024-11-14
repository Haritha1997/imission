<%@page import="com.nomus.m2m.dao.LicDao"%>
<%@page import="com.nomus.m2m.pojo.License"%>
<%@page import="org.jfree.ui.about.Licences"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page language="java"
	contentType="text/html"
	session="true"
	import="java.io.File"
%>
<%  User user = (User) session.getAttribute("loggedinuser");
	LicDao ldao = new LicDao(); 
	License lic = ldao.getLicenseDetails(); 
	
	String licenseto=lic!=null&&lic.getOrgName()!=null?lic.getOrgName():"";
%>
<head>
<link rel="stylesheet" type="text/css" href="/imission/css/opennms-theme.css" media="screen" />
<style>
   #footer {
   position:fixed;
   bottom:0;
   width:100%;
   height:50px;
   text-align:left;
      /* Height of the footer */
  /*  //margin-left:10px; */
 
}
 </style>
</head>
  <div id="paddingupdiv">
  <div class="spacer" style="padding-top:60px;"><!-- --></div>


<c:choose>
  <c:when test="${param.quiet == 'true'}">
    <!-- Not displaying footer -->
  </c:when>

  <c:otherwise>
    <!-- Footer -->

    <footer id="footer">
      <p>
		<label style="align:left;padding-left:1%;"></label><b>iMission</b> 2024 by <a href="https://nomus.in/" target="_blank">Nomus Comm-Systems Private Limited</a>.All rights reserved.</label>
     	<label style="float:right;padding-right: 1%;text-align:right"><b ><%if(licenseto.length()>0){%>Licensed To <a><%=licenseto%></a><%}%></b></label> 
		 <!-- <b></b> Copyright &copy; 2024 by <a href="https://nomus.in/" target="_blank">Secured Industrial Temperature Management</a>.All rights reserved. -->
      </p>
    </footer>
  </c:otherwise>
</c:choose>

<%
  File extraIncludes = new File(request.getSession().getServletContext().getRealPath("includes") + File.separator + "custom-footer");
  if (extraIncludes.exists()) {
	  for (File file : extraIncludes.listFiles()) {
		  if (file.isFile()) {
			  pageContext.setAttribute("file", "custom-footer/" + file.getName());
%>
<jsp:include page="${file}" />
<%
		  }
	 }
	  
  }
%>

<%-- This </div> tag is unmatched in this file (its matching tag is in the
     header), so we hide it in a JSP code fragment so the Eclipse HTML
     validator doesn't complain.  See bug #1728. --%>
<%= "</div>" %><!-- id="content" class="container-fluid" -->

<%-- The </body> and </html> tags are unmatched in this file (the matching
     tags are in the header), so we hide them in JSP code fragments so the
     Eclipse HTML validator doesn't complain.  See bug #1728. --%>
</div>
<%= "</body>" %>
<%= "</html>" %>
