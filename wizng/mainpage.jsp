<%@page import="com.nomus.staticmembers.M2MProperties"%>
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

<%String slnumber=request.getParameter("slnumber");
  String version = request.getParameter("version");
  String is_bulkiedit = request.getParameter("bulkedit")==null?"false":request.getParameter("bulkedit"); 
 
 //int BUFFER_SIZE = 4096;
Properties m2mprops = M2MProperties.getM2MProperties();
String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
String zipFilePath = slnumpath+File.separator+m2mprops.getProperty("targetfilename");
 File desDir = new File(slnumpath+File.separator+"WiZ_NG");
 if(!desDir.exists())
	 desDir.mkdir();
 File bulkedit_dir = new File(m2mprops.getProperty("tlsconfigspath")+File.separator+"Bulk-Edit");
 File bulkfile = new File(slnumpath+File.separator+"bulkedit.txt");
 if(is_bulkiedit.equals("true"))
 {
	 
	 if(!bulkedit_dir.exists())
		 bulkedit_dir.mkdir();
	 
	 FileWriter fw = null;
	 BufferedWriter bw = null;
	 try
	 {
		 fw = new FileWriter(bulkfile);
		 bw = new BufferedWriter(fw);
		 bw.write("bulkedit=true");
	 }
	 catch(Exception e)
	 {
		 
	 }
	 finally
	 {
		 if(bw != null)
			 bw.close();
		 if(fw != null)
			 fw.close();
	 }
 }
 else
 {
	 bulkfile.delete();
	 FileUtils.deleteDirectory(bulkedit_dir);
 }

try {
    // Open the zip file
    ZipFile zipFile = new ZipFile(zipFilePath);
    Enumeration<?> enu = zipFile.entries();
    while (enu.hasMoreElements()) {
        ZipEntry zipEntry = (ZipEntry) enu.nextElement();

        String name = zipEntry.getName();
		if(!name.contains(desDir.getAbsolutePath()))
			name = desDir.getAbsolutePath()+File.separator+name;
        long size = zipEntry.getSize();
        long compressedSize = zipEntry.getCompressedSize();

        // Do we need to create a directory ?
        File file = new File(name);
        
        if (name.endsWith("/")) {
            file.mkdirs();
            continue;
        } 
        
        File parent = file.getParentFile();
        if (parent != null) {
            parent.mkdirs();
        }

        // Extract the file
        InputStream is = zipFile.getInputStream(zipEntry);
        FileOutputStream fos = new FileOutputStream(file);
        byte[] bytes = new byte[1024];
        int length;
        while ((length = is.read(bytes)) >= 0) {
            fos.write(bytes, 0, length);
        }
        is.close();
        fos.close();

    }
    zipFile.close();
    File desfile = new File(slnumpath+File.separator+"Config.json");
    //File statupdir = new File(desDir.getAbsolutePath()+File.separator+"Startup_Configurations");
    File srcfile = new File(desDir.getAbsolutePath()+File.separator+"Startup_Configurations"+File.separator+"Config.json");
    Files.copy(srcfile.toPath(), desfile.toPath(),StandardCopyOption.REPLACE_EXISTING);
} catch (IOException e) {
    e.printStackTrace();
}
%>
<html>
   <head>
      <meta http-equiv="pragma" content="no-cache">
      <link rel="shortcut icon" href="/images/favicon.png">
      <title><%=slnumber%></title>
      <meta http-equiv="The JavaScript Source" content="no-cache">
      <meta name="description" content="site">
   </head>
   <frameset name="window" rows="112,*" cols="*" framespacing="3" frameborder="yes" border="3" bordercolor="#336699">
      <frame name="Banner" scrolling="no" noresize="" target="contents" src="titleFrame.jsp?slnumber=<%=slnumber%>">
      <frameset rows="*" cols="270,*" framespacing="3" frameborder="yes" border="2" bordercolor="#336699">
         <frame name="SideMenuFrame" target="main" src="sidepane.jsp?slnumber=<%=slnumber%>&version=<%=version%>">
         <frame id="iFrameID" target="welcomedata" src="wizwelcome.jsp" name="WelcomeFrame" noresize="">
         <frameset rows="*" cols="*" framespacing="3" frameborder="yes" border="2" bordercolor="#336699"></frameset>
      </frameset>
   </frameset>
</html>

