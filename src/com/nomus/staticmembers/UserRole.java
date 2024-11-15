package com.nomus.staticmembers;

import java.util.LinkedHashMap;

import com.nomus.m2m.pojo.User;

public class UserRole {

	public static String MAINADMIN="hyperadmin";
	public static String SUPERADMIN="superadmin";
	public static String ADMIN="admin";
	public static String SUPERVISOR="supervisor";
	public static String MONITOR="monitor";
	
	public static LinkedHashMap<String,String> getRolesHM(User user)
	{
		LinkedHashMap<String,String> rolemp = new LinkedHashMap<String,String>();
		if(user.getRole().equals(MAINADMIN))
		{
			rolemp.put(SUPERADMIN,"Super Admin");
		}
		else if(user.getRole().equals(SUPERADMIN))
		{
			rolemp.put(ADMIN,"Admin");
			rolemp.put(SUPERVISOR,"Supervisor");
			rolemp.put(MONITOR,"Monitor");
		}
		else if(user.getRole().equals(ADMIN))
		{
			rolemp.put(SUPERVISOR,"Supervisor");
			rolemp.put(MONITOR,"Monitor");
		}
		return rolemp;
	}
	public static LinkedHashMap<String,String> getRolesHM(User user,User usertomodify)
	{
		LinkedHashMap<String,String> rolemp = new LinkedHashMap<String,String>();
		if(user.getRole().equals(MAINADMIN))
			rolemp.put(SUPERADMIN,"Super Admin");
		else if(usertomodify.getId() == user.getId())
		{
			if(user.getRole().equals(SUPERADMIN))
				rolemp.put(user.getRole(),"Super Admin");
			else if(user.getRole().equals(ADMIN))
				rolemp.put(user.getRole(),"Admin");
		}
		else if(user.getRole().equals(SUPERADMIN))
		{
			rolemp.put(ADMIN,"Admin");
			rolemp.put(SUPERVISOR,"Supervisor");
			rolemp.put(MONITOR,"Monitor");
		}
		else if(user.getRole().equals(ADMIN))
		{
			rolemp.put(SUPERVISOR,"Supervisor");
			rolemp.put(MONITOR,"Monitor");
		}
		return rolemp;
	}
	public static LinkedHashMap<String,String> getAllRoles()
	{
		LinkedHashMap<String,String> rolemp = new LinkedHashMap<String,String>();
		rolemp.put(MAINADMIN,"Hyper Admin");
		rolemp.put(SUPERADMIN,"Super Admin");
		rolemp.put(ADMIN,"Admin");
		rolemp.put(SUPERVISOR,"Supervisor");
		rolemp.put(MONITOR,"Monitor");
		return rolemp;
	}
}
