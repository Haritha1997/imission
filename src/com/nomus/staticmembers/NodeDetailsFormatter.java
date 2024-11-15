package com.nomus.staticmembers;

import java.util.ArrayList;

import com.nomus.m2m.pojo.IPSecData;
import com.nomus.m2m.pojo.NodeDetails;

public class NodeDetailsFormatter {


	public static IPSecData getIPSecData(NodeDetails nd)
	{
		IPSecData ipsecdata = new IPSecData();
		ArrayList<String> headers_al = new ArrayList<String>();
		ArrayList<ArrayList<String>> data_list = new ArrayList<ArrayList<String>>();
		if(nd == null)
		{
			headers_al.add("Instance Name");
			headers_al.add("Status");
			ipsecdata.setHeaders_list(headers_al);
			ipsecdata.setData_list(data_list);
			return ipsecdata;
		}
		if(nd.getFwversion().endsWith(Symbols.WiZV2) || nd.getFwversion().startsWith(Symbols.WiZV2))
		{
			headers_al.add("Instance Name");
			headers_al.add("Inteface");
			headers_al.add("Status");
		}
		else
		{
			headers_al.add("Instance Name");
			headers_al.add("Status");
		}
		ipsecdata.setHeaders_list(headers_al);
		try
		{
			String ipsec_arr[] = nd.getIpsecstats().split(" ");
			int pos =ipsec_arr[0].equals("TUNNELS")? 1:0;
			int length = Integer.parseInt(ipsec_arr[pos++]);

			for(int i=0;i<length;i++)
			{
				ArrayList<String> row = new ArrayList<String>();
				row.add(ipsec_arr[pos++]);
				row.add(ipsec_arr[pos++]);
				if(nd.getFwversion().endsWith(Symbols.WiZV2) || nd.getFwversion().startsWith(Symbols.WiZV2))
					row.add(ipsec_arr[pos++]);

				data_list.add(row);
			}

		}
		catch(Exception e)
		{

		}
		ipsecdata.setData_list(data_list);

		return ipsecdata;
	}
}
