package com.nomus.staticmembers;

import java.util.List;
import java.util.Properties;

import com.nomus.m2m.dao.M2MDetailsDao;
import com.nomus.m2m.pojo.M2MDetails;

public class M2MProperties {
	static M2MDetails m2mdetails = null;
	static Properties m2mprops = null;

	public static Properties getM2MProperties()
	{
		//if(m2mprops == null) 
			loadM2MProperties(); 
		return m2mprops;
	}

	public static void loadM2MProperties() {
		// TODO Auto-generated method stub
		try
		{
			m2mprops = new Properties();
			M2MDetailsDao m2mdao = new M2MDetailsDao();
			List<M2MDetails> m2mdetlist = m2mdao.getM2MDetailsList();
			if(m2mdetlist.size() > 0)
			{
				M2MDetails m2mdetails = m2mdetlist.get(0);
				String port =m2mdetails.getPort()+""; 
				m2mprops.put("port",port);
				m2mprops.put("httpserverpath",m2mdetails.getHttpserverpath());
				m2mprops.put("tlsconfigspath",m2mdetails.getTlsconfigspath());
				m2mprops.put("firmwaredir",m2mdetails.getFirmwaredir());
				//m2mprops.put("certificatedir",m2mdetails.getCertificatedir());
				m2mprops.put("targetfilename",m2mdetails.getTargetfilename());
				m2mprops.put("versionfile",m2mdetails.getVersionfile());
				m2mprops.put("enabledebug",m2mdetails.getEnabledebug());
				m2mprops.put("readtimeout",m2mdetails.getReadtimeout()+"");
				m2mprops.put("daysforinactive",m2mdetails.getDaysforinactive()+"");
				m2mprops.put("username", m2mdetails.getUsername());
				m2mprops.put("password", m2mdetails.getPassword());
				m2mprops.put("snmptport", m2mdetails.getSmtptport());
				m2mprops.put("smtpserver", m2mdetails.getSmtpserver());
			}
			else
			{
				M2MDetails m2mdata = new M2MDetails();
				m2mdata.setPort(2222);
				String drivename = DrivesFactory.GetDriveName();
				m2mdata.setHttpserverpath(drivename.replace("\\","/")+"httpserver");
				m2mdata.setTlsconfigspath(drivename.replace("\\","/")+"tlsconfigs");
				m2mdata.setFirmwaredir(drivename.replace("\\","/")+"firmwares");
				//m2mdata.setCertificatedir(drivename.replace("\\","/")+"certificate");
				m2mdata.setTargetfilename("WiZ_NG.zip");
				m2mdata.setVersionfile("version.txt");
				m2mdata.setEnabledebug("no");
				m2mdata.setReadtimeout(10);
				m2mdata.setDaysforinactive(2);
				//m2mdata.setUsername("delhi@nomus.in");
				//m2mdata.setPassword("Nomuscomm@123");
				m2mdata.setSmtptport(587);
				m2mdao.addM2MDetails(m2mdata);
				m2mprops.put("port",m2mdata.getPort()+"");
				m2mprops.put("httpserverpath",m2mdata.getHttpserverpath());
				m2mprops.put("tlsconfigspath",m2mdata.getTlsconfigspath());
				m2mprops.put("firmwaredir",m2mdata.getFirmwaredir());
				m2mprops.put("targetfilename",m2mdata.getTargetfilename());
				m2mprops.put("versionfile",m2mdata.getVersionfile());
				m2mprops.put("enabledebug",m2mdata.getEnabledebug());
				m2mprops.put("readtimeout",m2mdata.getReadtimeout()+"");
				m2mprops.put("daysforinactive",m2mdata.getDaysforinactive()+"");
				m2mprops.put("username", m2mdata.getUsername());
				m2mprops.put("password", m2mdata.getPassword());
				m2mprops.put("snmptport", m2mdata.getSmtptport());
				m2mprops.put("smtpserver", m2mdata.getSmtpserver());
			}
		}
		catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}

	public static M2MDetails getM2MDetails()
	{
		if(m2mdetails != null)
			return m2mdetails;
		else 
			m2mdetails = loadM2MDetails();

		return m2mdetails;
	}
	private static M2MDetails loadM2MDetails() {
		// TODO Auto-generated method stub
		try
		{
			M2MDetailsDao m2mdao = new M2MDetailsDao();
			List<M2MDetails> m2mdetlist = m2mdao.getM2MDetailsList();
			if(m2mdetlist.size() > 0)
				return m2mdetlist.get(0);
		}
		catch (Exception e) {
			// TODO: handle exception
		}
		return null;
	}
}
