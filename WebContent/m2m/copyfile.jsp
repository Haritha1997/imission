

<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="org.apache.commons.fileupload.servlet.*"%>
<%@ page import="org.apache.commons.io.output.*"%>
<jsp:include page="/bootstrap.jsp" flush="false" >
   <jsp:param name="title" value="M2M" />
   <jsp:param name="headTitle" value="M2M" />
  </jsp:include>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type = "text/javascript">
	function displayMesssage(msg)
	{
		alert(msg);
	}
	function goToUrl()
	{
		window.location.href = "m2m/m2m.jsp";
	}
	</script>
    
</head>

	<%
			File file;
			int maxFileSize = 5000 * 1024;
			int maxMemSize = 5000 * 1024;
			Properties props = M2MProperties.getM2MProperties();
			
			String filePath = props.getProperty("httpserverpath").toString();
			String loadpath = props.getProperty("tlsconfigspath").toString();
			File configsfile = new File(loadpath);
			if(!configsfile.exists())
				configsfile.mkdir();
			loadpath += "/load";
			File loaddir = new File(loadpath);
			if(!loaddir.exists())
				loaddir.mkdir();
			String contentType = request.getContentType();
			if ((contentType.indexOf("multipart/form-data") >= 0)) {

		DiskFileItemFactory factory = new DiskFileItemFactory();
		factory.setSizeThreshold(maxMemSize);
		factory.setRepository(new File("c:\\temp"));
		ServletFileUpload upload = new ServletFileUpload(factory);
		upload.setSizeMax(maxFileSize);

		try {
			List fileItems = upload.parseRequest(request);
			Iterator i = fileItems.iterator();
			while (i.hasNext()) {
				FileItem fi = (FileItem) i.next();
				
				if (!fi.isFormField()) {
					String fieldName = fi.getFieldName();
					String fileName = fi.getName();
					boolean isInMemory = fi.isInMemory();
					long sizeInBytes = fi.getSize();
					if(fileName != null && sizeInBytes>0 && fileName.trim().length() > 0)
					{
							file = new File(loadpath + "/" + fileName);
							fi.write(file);
							out.println("Uploaded Filename: " + loadpath +"/"+ fileName + "<br>");
						}
					} else {
						String name = fi.getFieldName();
						String value = fi.getString();
						System.out.println(" name is : " + name + " value is : "+value);
						loadpath += "/"+value;
						File dir = new File(loadpath);
						if (!dir.exists()) {
							dir.mkdir();
						}
					}
				}
			%>
				<script>
					displayMesssage("File uploaded successfully");
				</script>
			<%	
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		} else {
			%>
			<script>
				displayMesssage("No file uploaded");
			</script>
			<%			
		}
		%>
		<script>
				goToUrl("m2m.jsp");
		</script>
	
</html>

