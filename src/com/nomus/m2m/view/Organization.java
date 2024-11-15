package com.nomus.m2m.view;

import java.util.Date;
import java.util.List;

public class Organization {
	
	String name;
	Date validUpTo;
	List<SuperAdmin> userlist;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public List<SuperAdmin> getUserlist() {
		return userlist;
	}
	public void setUserlist(List<SuperAdmin> userlist) {
		this.userlist = userlist;
	}
	public Date getValidUpTo() {
		return validUpTo;
	}
	public void setValidUpTo(Date validUpTo) {
		this.validUpTo = validUpTo;
	}
}
