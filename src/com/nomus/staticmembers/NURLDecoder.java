package com.nomus.staticmembers;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

public class NURLDecoder {
	
	public static String decode(String input)
	{
		
		String output = input.replace("%", "<percent>").replace("+", "<plus>");
		try {
			output = URLDecoder.decode(output,StandardCharsets.UTF_8.name());
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return output.replace( "<plus>", "+").replace("<percent>", "%");
	}
}
