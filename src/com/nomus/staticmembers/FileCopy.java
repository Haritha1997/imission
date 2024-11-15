package com.nomus.staticmembers;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.http.Part;

public class FileCopy {

	public static boolean copyFile(Part filePart,String targetfilename)
	  {
	      //String strTmp = System.getProperty("java.io.tmpdir");
	      OutputStream out = null;
	      InputStream filecontent = null;
	      File testfile = null;
	      boolean status = true;
	      
	      testfile = new File(targetfilename);
	      if(testfile.exists())
	    	  testfile.delete();
	      try {
	          out = new FileOutputStream(testfile);
	          filecontent = filePart.getInputStream();
	          int read = 0;
	          final byte[] bytes = new byte[1024];

	          while ((read = filecontent.read(bytes)) != -1) {
	              out.write(bytes, 0, read);
	          }
	      } catch (IOException fne) {
	          fne.printStackTrace();
	          status = false;
	      } finally {
	          if (out != null) {
	              try {
	                  out.close();
	              } catch (Exception e) {
	                  // TODO Auto-generated catch block
	                  e.printStackTrace();
	              }
	          }
	          if (filecontent != null) {
	              try {
	                  filecontent.close();
	              } catch (Exception e) {
	                  // TODO Auto-generated catch block
	                  status = false;
	                  e.printStackTrace();
	              }
	          }
	      }
	      return status;   
	  }
}
