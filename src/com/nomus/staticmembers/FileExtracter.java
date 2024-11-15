package com.nomus.staticmembers;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Enumeration;
import java.util.Properties;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;

public class FileExtracter {
	static Logger logger = Logger.getLogger(FileExtracter.class.getName());
	public static void extractAndCopyConfig(String slnumber) {
		// TODO Auto-generated method stub

		FileReader propsfr = null;
		InputStream is = null; 
		FileOutputStream fos = null;
		Properties m2mprops = new Properties();
		String zipFilePath=null;
		try {
			m2mprops = M2MProperties.getM2MProperties();
			String slnumpath = m2mprops.getProperty("tlsconfigspath") + File.separator + slnumber;
			zipFilePath = slnumpath + File.separator + m2mprops.getProperty("targetfilename");
			File desDir = new File(slnumpath + File.separator + "WiZ_NG");
			if (!desDir.exists())
				desDir.mkdir();
			else
				deleteOldCertificates(desDir);
			// Open the zip file
			ZipFile zipFile = new ZipFile(zipFilePath);
			Enumeration<?> enu = zipFile.entries();
			while (enu.hasMoreElements()) {
				ZipEntry zipEntry = (ZipEntry) enu.nextElement();

				String name = zipEntry.getName();
				if (!name.contains(desDir.getAbsolutePath()))
					name = desDir.getAbsolutePath() + File.separator + name;

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
				is = zipFile.getInputStream(zipEntry);
				fos = new FileOutputStream(file);
				byte[] bytes = new byte[1024];
				int length;
				while ((length = is.read(bytes)) >= 0) {
					fos.write(bytes, 0, length);
				}
				is.close();
				fos.close();

			}
			zipFile.close();
			File desfile = new File(slnumpath + File.separator + "Config.json");
			File srcfile = new File(desDir.getAbsolutePath() + File.separator + "Startup_Configurations"+ File.separator + "Config.json");
			Files.copy(srcfile.toPath(), desfile.toPath(), StandardCopyOption.REPLACE_EXISTING);
		} catch (IOException e) {
			//e.printStackTrace();
			logger.warn(zipFilePath+" is not exists");
		}
		finally
		{
			try {
				if (propsfr != null)
					propsfr.close();
				if (is != null)
					is.close();
				if (fos != null)
					fos.close();
			} catch (Exception e) {

			}
		}

	}
	private static void deleteOldCertificates(File desDir) {
		// TODO Auto-generated method stub
		File cert_dir = new File(desDir.getAbsolutePath()+File.separator+"Startup_Configurations"+File.separator+"certificates");
		try {
			FileUtils.deleteDirectory(cert_dir);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
