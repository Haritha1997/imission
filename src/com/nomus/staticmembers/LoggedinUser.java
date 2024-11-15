package com.nomus.staticmembers;

import com.nomus.m2m.pojo.User;

public class LoggedinUser {

	static User user;
	
	public static void setUser(User user) {
		LoggedinUser.user = user;
	}
	public static User getUser() {
		return user;
	}
}
