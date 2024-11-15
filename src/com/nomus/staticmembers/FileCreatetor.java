package com.nomus.staticmembers;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;

public class FileCreatetor {

	public static void createFile(File file)
	{
		if(file.exists())
			return;
		 Path filePath = file.toPath();
	        try {
	            if(filePath!= null) {
	                Files.createDirectories(filePath);
	            }

	        } catch (Exception e) {
	        	e.printStackTrace();
	        } 
	}
}
