package com.nomus.staticmembers;

import com.nomus.m2m.pojo.User;

public class QueryGenerator {

	public static String UP = "up";
	public static String DOWN = "down";
	public static String INACTIVE = "inactive";
	public static String DELETED = "deleted";
	public static String ALL = "all";
	
	public String getNodesDetailsQuery(User user,String type)
	{
		
		return "";
	}
	public static String getLocationsStr(User user)
	{
		String query="";
		query += user.getareaListToString();
		if(query.length() > 0)
			query = " prefix.location in('"+query+"')";
		return query;
	}
	public static String getSlNumberStr(User user)
	{
		String query="";
		query += user.getSlnumberLIstToString();
		if(query.length() > 0)
			query = " prefix.slnumber in('"+query+"')";
		return query;
	}
}
