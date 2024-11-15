package com.nomus.m2m.view;

import java.util.List;

import com.nomus.m2m.pojo.User;

public class SuperAdmin {
	User user;
	List<Admin> childlist;

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public List<Admin> getChildlist() {
		return childlist;
	}

	public void setChildlist(List<Admin> childlist) {
		this.childlist = childlist;
	}
	
}
