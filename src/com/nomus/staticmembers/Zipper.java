package com.nomus.staticmembers;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

public class Zipper {  // This class is not used right now

	public void zipDir(String dir2zip, ZipOutputStream zos,String slnumpath) 
	{
		try 
		{ 
			File zipDir  = new File(dir2zip);
			String[] dirList = zipDir.list();

			byte[] readBuffer = new byte[2156]; 
			int bytesIn = 0; 
			for(int i=0; i<dirList.length; i++) 
			{ 
				File f = new File(zipDir, dirList[i]); 
				if(f.isDirectory()) 
				{ 
					String filePath = f.getPath(); 
					zipDir(filePath, zos,slnumpath); 
					continue; 
				} 
				FileInputStream fis = new FileInputStream(f);
				//System.out.println("file path is : "+f.getPath()+"    "+slnumpath.replace("/","\\")+File.separator+"WiZ_NG"+File.separator);
				ZipEntry anEntry = new ZipEntry(f.getAbsolutePath().replace(slnumpath.replace("/","\\")+File.separator+"WiZ_NG"+File.separator,"")); 
				//place the zip entry in the ZipOutputStream object 
				zos.putNextEntry(anEntry);
				while((bytesIn = fis.read(readBuffer)) != -1) 
				{ 
					zos.write(readBuffer, 0, bytesIn); 
				} 
				fis.close(); 
			} 
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}    
	}
	public void unzipFile(File testfile,File targetdir)
    {
        try {
            // Open the zip file
            ZipFile zipFile = new ZipFile(testfile.getAbsolutePath());
            Enumeration<?> enu = zipFile.entries();
            File desDir = new File(targetdir+File.separator+"WiZ_NG");
            if(!desDir.exists())
                desDir.mkdir();
            while (enu.hasMoreElements()) {
                ZipEntry zipEntry = (ZipEntry) enu.nextElement();
                String name = zipEntry.getName();
                if(!name.contains(desDir.getAbsolutePath()))
                    name = desDir.getAbsolutePath()+File.separator+name;
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
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
