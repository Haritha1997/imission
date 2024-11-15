package com.nomus.staticmembers;

import com.nomus.m2m.pojo.NodeDetails;

public class NodeStatus {

	public static String UP = "up";
	public static String DOWN = "down";
	public static String INACTIVE = "inactive";
	public static String ALL = "all";
	public static String DELETED = "deleted";
	
	public static String getNodeStatusForTitle(NodeDetails nd)
	{
		String statusdet = "";
		if(nd.getStatus().equals(UP) && (nd.getDi1().equals("0") && nd.getDi2().equals("0") && nd.getDi3().equals("0")))
		{
			statusdet += "Normal"; 
		}
		else if(nd.getStatus().equals(UP))
		{
			int dioc = 0;
			if(nd.getDi1().equals("1"))
			{
				statusdet +=	"DI 1, ";
				dioc++;
			}
			if(nd.getDi2().equals("1"))
			{
				statusdet +=	"DI 2, ";
				dioc++;
			}
			if(nd.getDi3().equals("1"))
			{
				statusdet +=	"DI 3";
				dioc++;
			}
			if(statusdet.endsWith(","))
				statusdet = statusdet.substring(0,statusdet.length()-1);
			statusdet += (dioc > 1 ? " are ":" is ")+"down";
		}
		else if(nd.getStatus().equals(DOWN))
			statusdet += "Node is Down";
		else if(nd.getStatus().equals(INACTIVE))
			statusdet += "Node is Inactive";
		
		return statusdet;
	}
}
