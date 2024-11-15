package com.nomus.staticmembers;

public class SerialnumberValidator {
	public static boolean isInvalidSerialnumber(String slnumber) {
		// TODO Auto-generated method stub
		String[] slnumbervalsp=slnumber.split("-");
		boolean slnumbervalid=slnumbervalsp.length == 3&&slnumbervalsp[0].length()==3&&slnumbervalsp[1].length()>=5&&slnumbervalsp[2].length()==2&&NumberTester.isInteger(slnumber.replace("-", ""));
		return slnumbervalid;
	}
}
