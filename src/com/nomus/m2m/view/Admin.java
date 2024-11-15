package com.nomus.m2m.view;

import java.util.List;

import com.nomus.m2m.pojo.User;

public class Admin{
	User user;
	List<ChildUser> childlist;

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public List<ChildUser> getChildlist() {
		return childlist;
	}

	public void setChildlist(List<ChildUser> childlist) {
		this.childlist = childlist;
	}
	

}
