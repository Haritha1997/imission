package com.nomus.m2m.main;

import java.util.Properties;


import com.nomus.staticmembers.M2MProperties;

public class PropertiesManager {

	private static Properties props = null;
	public static Properties  getM2MProperties()
	{
		if(props == null)
			loadProperties();
		return props;
	}
	
	public static void loadProperties()
	{
		props = M2MProperties.getM2MProperties();
		
	}
}
