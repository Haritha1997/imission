package com.nomus.m2m.mail;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Calendar;

import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.TripleDES;

public class ResetLinkGenerator {
	public String getResetLink(User user,String baseurl)
	 {
		String link = null;
		TripleDES tdes;
		try {
			tdes = new TripleDES();
			long millis = Calendar.getInstance().getTimeInMillis();
			String encstr =  tdes.encrypt(user.getId()+"&"+millis);
			link = baseurl+"/imission/resetpassword.jsp?reset="+URLEncoder.encode(encstr,StandardCharsets.UTF_8.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    return link;
	 }
}
