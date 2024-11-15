package com.nomus.staticmembers;


import org.apache.commons.net.util.SubnetUtils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class InterfaceOverlaps {
	public static String GetNetwork(String ip,String subnet)
	{
	   if(ip.length() == 0)
		   return "0.0.0.0";
		String ipaddr[] = ip.split("\\.");
		String subn[] = subnet.split("\\.");
		String network = "";
		
		
		for(int i=0;i<ipaddr.length;i++)
		{
			network  += (Integer.parseInt(ipaddr[i]) & Integer.parseInt(subn[i]))+"";
			if(i<ipaddr.length-1)
				network +=".";
		}
		return network;
	}
	public static String GetBroadcast(String ip,String subnet)
	{
		 if(ip.length() == 0)
			   return "0.0.0.0";
		String ipaddr[] = ip.split("\\.");
		String subn[] = subnet.split("\\.");
		String network = "";
		
		
		for(int i=0;i<ipaddr.length;i++)
		{
			network  += (Integer.parseInt(ipaddr[i]) | (255-Integer.parseInt(subn[i])))+"";
			if(i<ipaddr.length-1)
				network +=".";
		}
		return network;
	}
	 public static boolean isIpInRange(String ipaddress,String startip,String endip)
	  {
		  if(startip.trim().length()==0 || endip.trim().length()== 0 || startip.equals("0.0.0.0") || endip.equals("0.0.0.0"))
			  return false;
		  
		   String nip = GetNetwork(startip,endip);
		   String bip = GetBroadcast(startip,endip);
		  
		   String ipadd[] = ipaddress.split("\\.");
		   String sip[] = nip.split("\\.");
		   String eip[] = bip.split("\\.");
		   for(int j=0;j<ipadd.length;j++)
		   {
			   for(int i=3;ipadd[j].length()<3;i--)
				   ipadd[j] = 0+ipadd[j];
		   }
		   for(int j=0;j<sip.length;j++)
		   {
			   for(int i=3;sip[j].length()<3;i--)
				   sip[j] = 0+sip[j];
		   }
		   for(int j=0;j<eip.length;j++)
		   {
			   for(int i=3;eip[j].length()<3;i--)
				   eip[j] = 0+eip[j];
		   }
		   if((Long.parseLong(ipadd[0]+ipadd[1]+ipadd[2]+ipadd[3]) > Long.parseLong(sip[0]+sip[1]+sip[2]+sip[3]))
			  && (Long.parseLong(ipadd[0]+ipadd[1]+ipadd[2]+ipadd[3]) < Long.parseLong(eip[0]+eip[1]+eip[2]+eip[3])))
			   return true; 
		   return false;
	  }
	 public static String getOVerlapingInterface(String ip,String pagename,JSONObject wizjsonnode,String overlapintf,String subnet)
	   {
		   overlapintf = "";
		   JSONObject lanobj = wizjsonnode.getJSONObject("network").getJSONObject("interface:lan");
		   JSONObject wanobj = wizjsonnode.getJSONObject("network").getJSONObject("interface:wan");
		   JSONObject loopbackobj = wizjsonnode.getJSONObject("network").getJSONObject("interface:loopback");
		   JSONObject m2mobj = wizjsonnode.getJSONObject("m2m").getJSONObject("m2m:m2m");
		   String version = m2mobj.getString("version");
		   String proto="";
		   if(version.equals(Symbols.WiZV2+Symbols.EL))
			   proto = wanobj.getString("proto");
		   JSONArray  laniparr = new JSONArray();
		   JSONArray  waniparr = new JSONArray();
		   JSONArray  loopiparr = new JSONArray();
		   if(lanobj.containsKey("ipaddr"))
			   laniparr = lanobj.getJSONArray("ipaddr");
		   if(wanobj.containsKey("ipaddr"))
			   waniparr = wanobj.getJSONArray("ipaddr");
		   if(loopbackobj.containsKey("ipaddr"))
			   loopiparr = loopbackobj.getJSONArray("ipaddr");
		   String cidr_lanip = "";
		   SubnetUtils lanutils= null;
		   String cidr_wanip = "";
		   SubnetUtils wanutils= null;
		   String cidr_loopip = "";
		   SubnetUtils looputils= null;
		   String lanipaddress=null;
		   String lannetmask = null;
		  String wanipaddress=null;
		   String wannetmask= null;
		   String lpipaddress=null;
		   String lpnetmask = null;
		   
		   if(pagename.equals("lanconfig")  && !ip.equals("0.0.0.0") && ip.length() > 0)
		   {
			 if(proto.equals("static") && version.equals(Symbols.WiZV2+Symbols.EL))
			 {
				 for(int i=0;i<waniparr.size();i++)
			      {   	 
					   cidr_wanip =  waniparr.getString(i);
					   wanutils = new SubnetUtils(cidr_wanip);
					   wanutils.setInclusiveHostCount(true);
					   wanipaddress=wanutils.getInfo().getAddress();
					   wannetmask=wanutils.getInfo().getNetmask();
						if (isIpInRange(GetNetwork(ip, subnet),wanipaddress,wannetmask) || isIpInRange(GetNetwork(wanipaddress, wannetmask),ip,subnet))
						{
							overlapintf += " WAN Network";
							break;
						}
			      }
			 }
			 for(int i=0;i<loopiparr.size();i++)
		      {   	 
				   cidr_loopip =  loopiparr.getString(i);
				   looputils = new SubnetUtils(cidr_loopip);
				   looputils.setInclusiveHostCount(true);
				   lpipaddress=looputils.getInfo().getAddress();
				   lpnetmask=looputils.getInfo().getNetmask();
				   if(isIpInRange(GetNetwork(ip, subnet),lpipaddress,lpnetmask) || isIpInRange(GetNetwork(lpipaddress, lpnetmask),ip,subnet))
				   {
						overlapintf += " Loopback Network";
						break;
					}
		      }
			 
		   }
		   else if(pagename.equals("wanconfig") && !ip.equals("0.0.0.0") && ip.length() > 0 && proto.equals("static") && version.equals(Symbols.WiZV2+Symbols.EL))
		   {
			   for(int i=0;i<laniparr.size();i++)
			      {   	 
					   cidr_lanip =  laniparr.getString(i);
					   lanutils = new SubnetUtils(cidr_lanip);
					   lanutils.setInclusiveHostCount(true);
					   lanipaddress=lanutils.getInfo().getAddress();
					   lannetmask=lanutils.getInfo().getNetmask();
					   if(isIpInRange(GetNetwork(ip, subnet),lanipaddress,lannetmask) || isIpInRange(GetNetwork(lanipaddress, lannetmask),ip,subnet))
					   {
						   overlapintf += " LAN Network";
						   break;
					   }
			      }
			   for(int i=0;i<loopiparr.size();i++)
			      {   	 
						   cidr_loopip =  loopiparr.getString(i);
						   looputils = new SubnetUtils(cidr_loopip);
						   looputils.setInclusiveHostCount(true);
						   lpipaddress=looputils.getInfo().getAddress();
						   lpnetmask=looputils.getInfo().getNetmask();
						   if(isIpInRange(GetNetwork(ip, subnet),lpipaddress,lpnetmask) || isIpInRange(GetNetwork(lpipaddress, lpnetmask),ip,subnet))
						   {
							   overlapintf += " Loopback Network";
							   break;
						   } 
			        }
		   }
		   else if(pagename.equals("loopback") && !ip.equals("0.0.0.0") && ip.length() > 0)
		   {
			   for(int i=0;i<laniparr.size();i++)
			      {   	 
					   cidr_lanip =  laniparr.getString(i);
					   lanutils = new SubnetUtils(cidr_lanip);
					   lanutils.setInclusiveHostCount(true);
					   lanipaddress=lanutils.getInfo().getAddress();
					   lannetmask=lanutils.getInfo().getNetmask();
					   if(isIpInRange(GetNetwork(ip, subnet),lanipaddress,lannetmask) || isIpInRange(GetNetwork(lanipaddress, lannetmask),ip,subnet))
					   {
						   overlapintf += " LAN Network";
						   break;
					   }
					   
			      }
		   		if(proto.equals("static") && version.equals(Symbols.WiZV2+Symbols.EL))
				 {
			   		 for(int i=0;i<waniparr.size();i++)
				      {   	 
						   cidr_wanip =  waniparr.getString(i);
						   wanutils = new SubnetUtils(cidr_wanip);
						   wanutils.setInclusiveHostCount(true);
						   wanipaddress=wanutils.getInfo().getAddress();
						   wannetmask=wanutils.getInfo().getNetmask();
						   if (isIpInRange(GetNetwork(ip, subnet),wanipaddress,wannetmask) || isIpInRange(GetNetwork(wanipaddress, wannetmask),ip,subnet))
						   {
								overlapintf += " WAN Network";
								break;
							}
				      }
				 }
		   }
		   
		   return overlapintf;
		}
	 public static String getIPNetworks(String ip,String pagename,JSONObject wizjsonnode,String overlapintf,String subnet,String activation)
	 {
		 overlapintf = "";
		 JSONObject lanobj = wizjsonnode.getJSONObject("network").getJSONObject("interface:lan");
		   JSONObject wanobj = wizjsonnode.getJSONObject("network").getJSONObject("interface:wan");
		   JSONObject loopbackobj = wizjsonnode.getJSONObject("network").getJSONObject("interface:loopback");
		   JSONObject m2mobj = wizjsonnode.getJSONObject("m2m").getJSONObject("m2m:m2m");
		   String version = m2mobj.getString("version");
		   String proto = "";
		   String wanact = "";
		   if(version.equals(Symbols.WiZV2+Symbols.EL))
		   {
			   proto = wanobj.getString("proto");
		   	   wanact= wanobj.getString("enabled");
		   }
		   String loopact = loopbackobj.getString("enabled");
		   JSONArray  laniparr = new JSONArray();
		   JSONArray  waniparr = new JSONArray();
		   JSONArray  loopiparr = new JSONArray();
		   if(lanobj.containsKey("ipaddr"))
			   laniparr = lanobj.getJSONArray("ipaddr");
		   if(wanobj.containsKey("ipaddr"))
			   waniparr = wanobj.getJSONArray("ipaddr");
		   if(loopbackobj.containsKey("ipaddr"))
			   loopiparr = loopbackobj.getJSONArray("ipaddr");
		   String cidr_lanip = "";
		   SubnetUtils lanutils= null;
		   String cidr_wanip = "";
		   SubnetUtils wanutils= null;
		   String cidr_loopip = "";
		   SubnetUtils looputils= null;
		   String lanipaddress=null;
		   String lannetmask = null;
		  String wanipaddress=null;
		   String wannetmask= null;
		   String lpipaddress=null;
		   String lpnetmask = null;
		   
		   if(pagename.equals("lanconfig")  && !ip.equals("0.0.0.0") && ip.length() > 0 && activation == null)
		   {
			   
			 if(proto.equals("static") && version.equals(Symbols.WiZV2+Symbols.EL) && wanact.equals("1"))
			 {
				 for(int i=0;i<waniparr.size();i++)
			      {   	 
					   cidr_wanip =  waniparr.getString(i);
					   wanutils = new SubnetUtils(cidr_wanip);
					   wanutils.setInclusiveHostCount(true);
					   wanipaddress=wanutils.getInfo().getAddress();
					   wannetmask=wanutils.getInfo().getNetmask();
						if (GetNetwork(ip, subnet).equals(GetNetwork(wanipaddress,wannetmask)))
						{
							overlapintf += "\'wan\' network";
							break;
						}
			      }
			 }
			 if(loopact.equals("1")) {
				 for(int i=0;i<loopiparr.size();i++)
			      {   	 
					   cidr_loopip =  loopiparr.getString(i);
					   looputils = new SubnetUtils(cidr_loopip);
					   looputils.setInclusiveHostCount(true);
					   lpipaddress=looputils.getInfo().getAddress();
					   lpnetmask=looputils.getInfo().getNetmask();
					   if(GetNetwork(ip, subnet).equals(GetNetwork(lpipaddress,lpnetmask)))
					   {
							overlapintf += "\'loopback\' network";
							break;
						}
			      }
				 
			   }
		   }
		   else if(pagename.equals("wanconfig") && !ip.equals("0.0.0.0") && ip.length() > 0 && proto.equals("static") && version.equals(Symbols.WiZV2+Symbols.EL))
		   {
			   if(activation != null)
			   {
			      for(int i=0;i<laniparr.size();i++)
			      {   	 
					   cidr_lanip =  laniparr.getString(i);
					   lanutils = new SubnetUtils(cidr_lanip);
					   lanutils.setInclusiveHostCount(true);
					   lanipaddress=lanutils.getInfo().getAddress();
					   lannetmask=lanutils.getInfo().getNetmask();
					   
				     
					   if(GetNetwork(ip, subnet).equals(GetNetwork(lanipaddress,lannetmask)))
					   {
						   overlapintf += "\'lan\' network";
						   break;
					   }
			      }
			   }
			   if(loopact.equals("1")) {
				   for(int i=0;i<loopiparr.size();i++)
				      {   	 
							   cidr_loopip =  loopiparr.getString(i);
							   looputils = new SubnetUtils(cidr_loopip);
							   looputils.setInclusiveHostCount(true);
							   lpipaddress=looputils.getInfo().getAddress();
							   lpnetmask=looputils.getInfo().getNetmask();
							   if(GetNetwork(ip, subnet).equals(GetNetwork(lpipaddress,lpnetmask)))
							   {
								   overlapintf += "\'loopback\' network";
								   break;
							   } 
				        }
			   }
		   }
		   else if(pagename.equals("loopback") && !ip.equals("0.0.0.0") && ip.length() > 0)
		   {
			   if(activation != null)
			   {
				   for(int i=0;i<laniparr.size();i++)
				      {   	 
						   cidr_lanip =  laniparr.getString(i);
						   lanutils = new SubnetUtils(cidr_lanip);
						   lanutils.setInclusiveHostCount(true);
						   lanipaddress=lanutils.getInfo().getAddress();
						   lannetmask=lanutils.getInfo().getNetmask();
						   if(GetNetwork(ip, subnet).equals(GetNetwork(lanipaddress,lannetmask)))
						   {
							   overlapintf += "\'lan\' network";
							   break;
						   }
						   
				      }
			   }
		   		if(proto.equals("static") && version.equals(Symbols.WiZV2+Symbols.EL) && wanact.equals("1"))
				 {
			   		 for(int i=0;i<waniparr.size();i++)
				      {   	 
						   cidr_wanip =  waniparr.getString(i);
						   wanutils = new SubnetUtils(cidr_wanip);
						   wanutils.setInclusiveHostCount(true);
						   wanipaddress=wanutils.getInfo().getAddress();
						   wannetmask=wanutils.getInfo().getNetmask();
						   if (GetNetwork(ip, subnet).equals(GetNetwork(wanipaddress,wannetmask)))
						   {
								overlapintf += "\'wan\' network";
								break;
							}
				      }
				 }
		   }
		 return overlapintf;
	 }
	 public static boolean IsSimsActive(JSONObject wizjsonnode)
	 {
		 JSONObject Sim1obj = wizjsonnode.getJSONObject("cellular").getJSONObject("SIM:sim1");
		 JSONObject Sim2obj = wizjsonnode.getJSONObject("cellular").getJSONObject("SIM:sim2");
		 String sim1act = null;
		 String sim2act = null;
		 if(Sim1obj.containsKey("enabled"))
			 sim1act = Sim1obj.getString("enabled");
		 if(Sim2obj.containsKey("enabled"))
			 sim2act = Sim2obj.getString("enabled");
		 if(sim1act.equals("1") && sim2act.equals("1"))
			 return false;
		 else
			 return true;
	 }
}
