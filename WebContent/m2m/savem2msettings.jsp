
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.*"%>

<%
   Properties props = null;
   BufferedWriter bw = null;
   FileWriter fw = null;
   String message = "M2M Settings are saved successfully.";
  	 try{
  		fw = new FileWriter("m2m.properties");
  		
  		bw = new BufferedWriter(fw);
  		Vector<String> props_vec = new Vector<String>();
  		Enumeration<String> paramlist =  request.getParameterNames();
  		while(paramlist.hasMoreElements())
  		{
  			String param = paramlist.nextElement();
  			bw.write(param+"="+request.getParameter(param));
  			bw.newLine();
  		}
  		
  	} catch (Exception e) {
		message = "Failed to Save.";
  		e.printStackTrace();
  	}
	finally{
		if(bw != null)
			bw.close();
		if(fw != null)
			fw.close();
	}
  	response.sendRedirect("/imission/message.jsp?status="+message);
  %>