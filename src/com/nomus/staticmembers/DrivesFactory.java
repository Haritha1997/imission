package com.nomus.staticmembers;

import java.io.File;

import javax.swing.filechooser.FileSystemView;

public class DrivesFactory {

	public static String GetDriveName() {
		File[] paths;
		String drivename="D:/";
		try
		{
			FileSystemView fsv = FileSystemView.getFileSystemView();
			paths = File.listRoots();
			String osname =System.getProperty("os.name").toLowerCase();
			if(osname.contains("win"))
			{
				for(File path:paths)
				{
					if(fsv.getSystemTypeDescription(path).trim().contains("Local Disk") && !path.toString().trim().startsWith("C"))
					{
						drivename = path.toString();
						break;
					}
				}

			}
			//else if(osname.contains("nix") || osname.contains("nux") || osname.contains("aix"))
			//{
			//
			//}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return drivename;
	}	

	public static void main(String[] args) { 
		//System.out.println(GetDriveName());
	}

}
