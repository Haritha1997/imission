<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="com.nomus.staticmembers.UserTempFile"%>
<%@page import="com.nomus.staticmembers.FileExtracter"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.nio.file.StandardCopyOption"%>
<%@page import="java.nio.file.Path"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.zip.ZipFile"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.util.zip.ZipEntry"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.File"%>
<%@page import="java.util.zip.ZipInputStream"%>
<%@page import="org.apache.commons.io.FileUtils"%>

<%
  String slnumber=request.getParameter("slnumber");
  String version = request.getParameter("version");
  String is_bulkiedit = request.getParameter("bulkedit")==null?"false":request.getParameter("bulkedit"); 
  User user = (User)request.getSession().getAttribute("loggedinuser");
try {
	UserTempFile.createOrRemoveTempBulkEditFiles(user,is_bulkiedit);
	FileExtracter.extractAndCopyConfig(slnumber);
} catch (Exception e) {
    e.printStackTrace();
}
%>
<html>
<head>
<meta http-equiv="pragma" content="no-cache">
<link rel="shortcut icon" href="images/favicon.png">
<title>
Nomus WiZ</title>
<meta http-equiv="The JavaScript Source" content="no-cache">
</head>
<frameset rows="82,*" cols="*" framespacing="10" frameborder="yes" style="height:20%" border="1" bordercolor="#336699" onload="WindowPageLoad();">
<frame name="titleframe" scrolling="no" style="height:20%" noresize="" target="contents" src="titleFrame.jsp?slnumber=<%=slnumber%>&version=<%=version%>">
<frameset rows="*" cols="200,*" frameborder="yes" border="1" bordercolor="#336699">
<frame name="SideMenuFrame" target="main" src="sidepane.jsp?slnumber=<%=slnumber%>&version=<%=version%>">
<!--<frameset rows="60,*" cols="*" frameborder="no" noresize="" name="menubar">-->
<frame id="iFrameID" style="position:fixed;height:15%" target="submenu" scrolling="no" src="submenu.jsp?slnumber=<%=slnumber%>&version=<%=version%>" name="menubarFrame"/>
<frame id="displayframe" style="height:75%" name="displayframe" src="welcome.jsp?slnumber=<%=slnumber%>&version=<%=version%>"/>
</frameset>
</frameset>
</html>
