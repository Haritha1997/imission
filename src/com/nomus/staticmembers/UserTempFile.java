package com.nomus.staticmembers;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Properties;

import org.apache.commons.io.FileUtils;

import com.nomus.m2m.pojo.User;

public class UserTempFile {
	public static  File getUserTempDir(User user,String type)
	{
		Properties props = M2MProperties.getM2MProperties();
		File temp_file = new File(props.getProperty("tlsconfigspath")+File.separator+"temp"+File.separator+user.getId()+File.pathSeparator+File.separator+type);
		if(!temp_file.exists())
			   temp_file.mkdirs();
		return temp_file;
	}

	public static void clearDir(File temp_file) {
		// TODO Auto-generated method stub
		for(File file : temp_file.listFiles())
		{
			if(file.isDirectory())
				try {
					FileUtils.deleteDirectory(file);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			else
				file.delete();
		}
	}
	public static void createOrRemoveTempBulkEditFiles(User user,String is_bulkedit) throws Exception
	{
		File bulkedit_dir = UserTempFile.getUserTempDir(user, "Bulk-Edit");
	    File bulkfile = new File(bulkedit_dir.getAbsolutePath()+File.separator+"bulkedit.txt");
		if(is_bulkedit.equals("true"))
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
	}
	
}
