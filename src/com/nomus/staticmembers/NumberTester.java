package com.nomus.staticmembers;

public class NumberTester {

	public static boolean isInteger(String input)
	{
		for(char ch : input.toCharArray())
		{
			if(!Character.isDigit(ch))
				return false;
		}
		return true;
	}
}
