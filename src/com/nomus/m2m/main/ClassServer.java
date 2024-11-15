package com.nomus.m2m.main;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.nio.file.attribute.BasicFileAttributes;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.TimeoutException;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;

import com.nomus.m2m.dao.DataUsageDao;
import com.nomus.m2m.dao.M2MNodeOtagesDao;
import com.nomus.m2m.dao.M2MlogsDao;
import com.nomus.m2m.dao.NodedetailsDao;
import com.nomus.m2m.dao.OrganizationDataDao;
import com.nomus.m2m.pojo.DataUsage;
import com.nomus.m2m.pojo.M2MNodeOtages;
import com.nomus.m2m.pojo.M2Mlogs;
import com.nomus.m2m.pojo.NodeDetails;
import com.nomus.m2m.pojo.OrganizationData;
import com.nomus.staticmembers.DateTimeUtil;
import com.nomus.staticmembers.M2MProperties;
import com.nomus.staticmembers.NodeStatus;
import com.nomus.staticmembers.Symbols;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


/*
 * ClassServer.java -- a simple file server that can serve
 * Http get request in both clear and secure channel
 */

public abstract class ClassServer implements Runnable {

	static Logger logger = Logger.getLogger(ClassServer.class.getName());
	private ServerSocket server = null;
	private long filelength = 0;
	//private String serialno;
	private String lastModifiedTime = "";
	public static final String NONE = "None";
	public static final String FIRMWARE_UPGRADE = "Firmware-Upgrade";
	public static final String REBOOT = "Reboot";
	public static final String REBOOT_CONFIRM="Reboot-Confirm";
	public static final String REBOOT_ACCEPTED="Reboot-Accepted";
	public static final String FIRWARE_UPGRADE_REQUEST="Firmware-Upgradation";
	public static final String ROOTFS_FILE = "rootfs.jffs2";
	public static final String UIMAGE_FILE = "uImage";
	public static final String MPC_FILE= "mpc8309twr.dtb";
	public static final String SUM_FILE= "sum.md5";
	public static final String DTBIILE = "at91-sama5d2_xplained.dtb";
	public static final String UBIIILE = "at91-sama5d2_xplained-ubifs-root.ubi";
	public static final String ZIMAGEFILE = "at91-sama5d2_xplained-ubifs-zImage";
	public static final String CHECKSUMFILE = "sum.sha256";
	public static final String NO_SPACE= "No-Space";
	public static final String FILE_STR="File:";
	public static final String EXPORT_STR="Export";
	public static final String EXPORT_CONFIG_STR="Export-Config";
	public static final String EXPORT_CONFIG_SUCCESS="Export-Config:Success";
	public static final String EXPORT_CONFIG_FAILED="Export-Config:Failed";
	private static final int PDET_CNT = 16;
	private static final int FAILED = 2;
	private static final int SUCCESS = 1;
	private static final int UPDATING = 3;
	private static final int NOSTATUS = 0;
	private static final String PROCEED_STR = "Proceed";
	private static final String SEND_CONFIG_STATUS = "Config-Status";
	private static final String EXPORT_STATUS = "Export-Status";
	private static final String STATUS_DETAILS = "Status-Details:";
	private static final String DIO_STATUS = "DIO-Events:";
	private static final String EVENT = "Events:";

	public static final String CONFIGURATION = "Configuration";
	public static final String BULK_UPDATE = "Bulk-Update";
	public static final String BULK_EDIT = "Bulk-Edit";
	public static final String ORG_UPDATE = "Organization";
	public static String targetfilename = "WiZ_NG.zip";

	//private boolean no_space = false; 
	private final static String YES_STR = "yes";
	private final static String NO_STR = "no";
	private static final String DOWNTIME_STR = "downtime";
	private static final String UPTIME_STR = "uptime";
	private static final String DELETED_STR = "deleted";
	NodedetailsDao mn;
	int read_timeout = 10;
	Properties props = null;
	private static  OrganizationDataDao orgdatadao = new OrganizationDataDao();
	List<String>  devicealarmlist = new ArrayList<String>();
	//private static Hashtable<K, V>

	/**
	 * Constructs a ClassServer based on <b>ss</b> and
	 * obtains a file's bytecodes using the method <b>getBytes</b>.
	 *
	 */
	protected ClassServer(ServerSocket ss)
	{
		server = ss;
		//checktime = Calendar.getInstance().getTime();
		mn = new NodedetailsDao();
		props = M2MProperties.getM2MProperties();
		try
		{
			read_timeout = props.getProperty("readtimeout")==null?read_timeout:Integer.parseInt(props.getProperty("readtimeout").trim());
		}
		catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		newListener();
	}

	/**
	 * Returns an array of bytes containing the bytes for
	 * the file represented by the argument <b>path</b>.
	 *
	 * @return the bytes for the file
	 * @exception FileNotFoundException if the file corresponding
	 * to <b>path</b> could not be loaded.
	 * @exception IOException if error occurs reading the class
	 */
	public abstract byte[] getBytes(String path)
			throws IOException, FileNotFoundException;

	/**
	 * The "listen" thread that accepts a connection to the
	 * server, parses the header to obtain the file name
	 * and sends back the bytes for the file (or error
	 * if the file is not found or the response was malformed).
	 */

	public void run()
	{
		Socket socket = null;

		// accept a connection
		try {
			socket =  server.accept();
			socket.setSoTimeout(read_timeout*60*1000);

			logger.warn("socket : "+socket+" is created");
		} catch (IOException e) {
			System.out.println("Class Server died: " + e.getMessage());
			e.printStackTrace();
			return;
		}

		// create a new thread to accept the next connection
		newListener();
		try {
			OutputStream rawOut = socket.getOutputStream();

			/*PrintWriter out = new PrintWriter(
					new BufferedWriter(
							new OutputStreamWriter(
									rawOut)));*/
			// get path to class file from header
			BufferedReader in =
					new BufferedReader(
							new InputStreamReader(socket.getInputStream()));

			doOperations(socket);
			//String path = getPath();
			/*getPath(in);
				String path = "";
				 retrieve bytecodes
				byte[] bytecodes = getBytes(path);
				// send bytecodes in response (assumes HTTP/1.0 or later)
				try {
					out.print("HTTP/1.0 200 OK\r\n");
                    out.print("Content-Length: " + bytecodes.length +
                                   "\r\n");
                    out.print("Content-Type: text/html\r\n\r\n");
                    out.flush();
					rawOut.write(bytecodes);
					rawOut.flush();
				} catch (IOException ie) {
					ie.printStackTrace();
					return;
				}

			} catch (Exception e) {
				e.printStackTrace();
				// write out error response
				out.println("HTTP/1.0 400 " + e.getMessage() + "\r\n");
				out.println("Content-Type: text/html\r\n\r\n");
				out.flush();
			}*/

		} catch (IOException | TimeoutException ex) {
			// eat exception (could log error to log file, but
			// write out to stdout for now).
			//System.out.println("error writing response: " + ex.getMessage());
			logger.warn("error writing response: " + ex.getMessage());
			ex.printStackTrace();

		} finally {
			try {
				logger.warn("the socket "+socket+" is closed.");
				setOutages(socket,DOWNTIME_STR);
				updateNodeStatus(socket,"down");
				//removeConnectedIP(socket);
				//socket.close();
				closeSocket(socket);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}


	private void removeConnectedIP(Socket socket) {
		// TODO Auto-generated method stub
		NodeDetails node = getNode("connectedip",socket.getRemoteSocketAddress().toString().trim().replace("/",""));
		if(node != null)
		{
			node.setConnectedip("");
			mn.updateNodeDetails(node);
		}
	}

	private NodeDetails getNode(String columnname,String value) {
		// TODO Auto-generated method stub
		NodeDetails ndobj = null;
		ndobj = mn.getNodeDetails(columnname, value);
		return ndobj;
	}

	/**
	 * Create a new thread to listen.
	 */
	private void newListener()
	{
		(new Thread(this)).start();
	}

	/**
	 * Returns the path to the file obtained from
	 * parsing the HTML header.
	 * @throws TimeoutException 
	 */
	private  void doOperations(Socket socket)
			throws IOException, TimeoutException
	{
		OutputStream rawout = socket.getOutputStream();
		InputStream rawin =socket.getInputStream();
		BufferedReader in =
				new BufferedReader(
						new InputStreamReader(rawin));
		String cmd;
		long lreadtime_millis = Calendar.getInstance().getTimeInMillis();

		long d_time_out = 10;
		/*
		 * if(props.get("readtimeout") != null) { d_time_out =
		 * Long.parseLong(props.getProperty("readtimeout")); }
		 */
		while ((cmd = in.readLine()) != null /*
		 * && !isReadTimeout(lreadtime_millis,Calendar.getInstance().
		 * getTimeInMillis(),d_time_out)
		 */)
		{
			lreadtime_millis = Calendar.getInstance().getTimeInMillis();
			//System.out.println("message from Client "+socket.getInetAddress().getAddress()+" is : "+cmd);
			logger.warn("message from Client "+socket.getRemoteSocketAddress().toString().trim().replace("/","")+" is : "+cmd);
			String path = "";
			// extract class from GET line
			if (cmd.startsWith("GET /")) {
				cmd = cmd.substring(5, cmd.length()-1).trim();
				int index = cmd.indexOf(' ');
				if (index != -1) {
					path = cmd.substring(0, index);
				}
			}

			else if(cmd.startsWith("Firmware-Upgrade:Failed"))
			{
		
				setLogs(socket,cmd,SeverityNames.WARNING);
				removeUpgradeActivity(socket,FAILED);
			}
			else if(cmd.startsWith("Firmware-Upgrade:Success"))
			{
				//setLogs(socket,cmd,SeverityNames.NORMAL);
				//removeUpgradeActivity(socket,SUCCESS);
				NodeDetails ndobj = getNode("connectedip",socket.getRemoteSocketAddress().toString().trim().replace("/",""));
				//mn.updateNodeDetails(ndobj,"Upgrade",getStatus(UPDATING));
				ndobj.setUpgradestatus(UPDATING);
				mn.updateNodeDetails(ndobj);
			}
			else if(cmd.startsWith("Configuration:Success"))
			{
				setLogs(socket,cmd,SeverityNames.NORMAL);
				updateNodeSendConfig(socket,SUCCESS);
				resetHttpIndex(socket);
			}
			else if(cmd.startsWith("Configuration:Failed"))
			{
				setLogs(socket,cmd,SeverityNames.WARNING);
				updateNodeSendConfig(socket,FAILED);
			}
			else if(cmd.startsWith(EXPORT_CONFIG_SUCCESS))
			{
				setLogs(socket,cmd,SeverityNames.NORMAL);
				updateNodeExport(socket,SUCCESS);
				resetHttpIndex(socket);
			}
			else if(cmd.startsWith(EXPORT_CONFIG_FAILED))
			{
				setLogs(socket,cmd,SeverityNames.WARNING);
				updateNodeExport(socket,FAILED);
			}
			else if(cmd.startsWith("Organization:Success"))
			{
				setLogs(socket,cmd,SeverityNames.NORMAL);
				updateNodeOrg(socket,SUCCESS);
				resetHttpIndex(socket);
			}
			else if(cmd.startsWith("Organization:Failed"))
			{
				setLogs(socket,cmd,SeverityNames.WARNING);
				updateNodeOrg(socket,FAILED);
			}
			else if(cmd.startsWith("Bulk-Edit:Success"))
			{
				setLogs(socket,cmd,SeverityNames.NORMAL);
				updateNodeBulkEdit(socket,SUCCESS);
				resetHttpIndex(socket);
			}
			else if(cmd.startsWith("Bulk-Edit:Failed"))
			{
				setLogs(socket,cmd,SeverityNames.WARNING);
				updateNodeBulkEdit(socket,FAILED);
			}
			else if(cmd.startsWith("Bulk-Config:Success"))
			{
				setLogs(socket,cmd,SeverityNames.NORMAL);
				updateNodeBulkConf(socket,SUCCESS);
				resetHttpIndex(socket);
			}
			else if(cmd.startsWith("Bulk-Config:Failed"))
			{
				setLogs(socket,cmd,SeverityNames.WARNING);
				updateNodeBulkConf(socket,FAILED);
			}

			else if(cmd.startsWith("Received:"))
			{
				try
				{
					long reclen = Long.parseLong(cmd.replace("Received:", ""));	

					if(filelength == reclen)
					{

						//System.out.println("File received by Client "+socket.getInetAddress().toString()+" Successfully...");
						logger.warn("File received by Client "+socket.getInetAddress().toString()+" Successfully...");
					}
				}
				catch (Exception e) {
					// TODO: handle exception
					//System.out.println("File received by Client "+socket.getInetAddress().toString()+"is falied...");
					logger.warn("File received by Client "+socket.getInetAddress().toString()+"is falied...");
				}
			}
			else if(cmd.startsWith("Primary-Details:"))//cellularip,imei,slno,nodename,location,swdate,swversion,loopbackip,routeruptime,sigstrength
			{
				String prime_data = cmd.replace("Primary-Details:","");
				if(prime_data.length() <2)
					return;
				String prime_data_arr[] = prime_data.split(",");
				String slnumber = prime_data_arr[2].trim();
				OrganizationData orgdata = orgdatadao.getOrganizationData(slnumber);
				if(orgdata != null && orgdata.getValidUpto().compareTo(DateTimeUtil.getOnlyDate(new Date())) >= 0)
					
					saveDetails(socket,prime_data,orgdata.getOrganization());
				else
				{
					setNodeDown(slnumber);
					closeSocket(socket);
				}
			}
			else if(cmd.startsWith(STATUS_DETAILS))
			{
				updateStatusDetails(socket,cmd.replace(STATUS_DETAILS,""));	
			}
			else if(cmd.startsWith(DIO_STATUS))
			{
				updateDioStatus(socket,cmd.replace(DIO_STATUS, ""));
			}
			else if(cmd.startsWith("Any-Pending"))
			{
				sendProceedOrAskStatus(socket,rawout);
			}
			else if(cmd.trim().equals("Receive-Config") || cmd.trim().equals("Bulk-Config") || cmd.trim().equals("Organization-Config") 
					|| cmd.trim().equals(EXPORT_CONFIG_STR) || cmd.trim().equals(BULK_EDIT))
			{
				sendConfigFile(socket,rawout,in);
			}
			else if(cmd.trim().equals("Send-Updates"))
			{
				String update = GetUpdates(socket);
				byte[] bytes = (update+"\n").getBytes();
				rawout.write(bytes);
				rawout.flush();
			}
			else if(cmd.trim().equals(FIRWARE_UPGRADE_REQUEST))
			{

			}
			else if(cmd.trim().equals(FILE_STR+ROOTFS_FILE))
			{
				sendFirwareFile(socket,rawout, in,ROOTFS_FILE);
			}
			else if(cmd.trim().equals(FILE_STR+UIMAGE_FILE))
			{
				sendFirwareFile(socket,rawout, in,UIMAGE_FILE);
			}
			else if(cmd.trim().equals(FILE_STR+MPC_FILE))
			{
				sendFirwareFile(socket,rawout, in,MPC_FILE);
			}
			else if(cmd.trim().equals(FILE_STR+SUM_FILE))
			{
				sendFirwareFile(socket,rawout, in,SUM_FILE);
			}
			else if(cmd.trim().equals(FILE_STR+DTBIILE))
			{
				sendFirwareFile(socket,rawout, in,DTBIILE);
			}
			else if(cmd.trim().equals(FILE_STR+UBIIILE))
			{
				sendFirwareFile(socket,rawout, in,UBIIILE);
			}
			else if(cmd.trim().equals(FILE_STR+ZIMAGEFILE))
			{
				sendFirwareFile(socket,rawout, in,ZIMAGEFILE);
			}
			else if(cmd.trim().equals(FILE_STR+CHECKSUMFILE))
			{
				sendFirwareFile(socket,rawout, in,CHECKSUMFILE);
			}
			
			else if(cmd.trim().equals(REBOOT_CONFIRM))
			{
				byte[] bytes = "yes\n".getBytes();
				rawout.write(bytes);
				rawout.flush();
			}
			else if(cmd.trim().equals(REBOOT_ACCEPTED))
			{
				setLogs(socket,cmd,SeverityNames.NORMAL);
				updateNodeReboot(socket,1);
			}

			/*else if(cmd.trim().equals("Check-Config"))
			{

				if(checkConfigExists(serialno))
				{
					byte[] bytes = "Config:yes \n".getBytes();
					rawout.write(bytes);
					rawout.flush();
				}
				else
				{
					byte[] bytes = "Config:no \n".getBytes();
					rawout.write(bytes);
					rawout.flush();
				}
			}*/

			else if(cmd.trim().equals("Send-Config"))
			{
				ReceiveConfigFile(socket,rawin,rawout);
				resetHttpIndex(socket);
			}
			else if(cmd.trim().equals("Data-Usage"))
			{
				ReceiveDataUsage(socket,rawin,rawout);
			}
			else if(cmd.trim().equals("Give-Data-Usage"))
			{
				sendDatausage(socket,rawout,in);
			}
			else if(cmd.trim().startsWith("Events:")) 
			{
				setDeviceAlarms(socket,cmd.replace(EVENT, "")); 
			}
			else
			{
				rawout.write("".getBytes());
				rawout.flush();
			}
			//setInactiveNodes();
		}	
	}

	private  synchronized void setDeviceAlarms(Socket socket, String devicealarminfo) {
		// TODO Auto-generated method stub
		NodeDetails ndobj = mn.getNodeDetails("connectedip", socket.getRemoteSocketAddress().toString().trim().replace("/",""));
		//NodeDetails node = mn.getNodeDetails("slnumber", ndobj.getSlnumber());
		if(ndobj == null || ndobj.getStatus().equals(DELETED_STR))
		{
			closeSocket(socket);
			return;
		}
		if(devicealarminfo.contains(","))
		{
			String mul_alaram_status_arr[] = devicealarminfo.split(",");
			boolean saved=true;
			for(int i=0;i<mul_alaram_status_arr.length-1;i++)
			{
				saved=setDeviceAlaramInfo(ndobj,mul_alaram_status_arr[i]);
				/*
				 * if(!saved) break;
				 */
			}
			
			String ack=mul_alaram_status_arr[mul_alaram_status_arr.length-1];
			//if(saved)
				sendMessage(socket,ack);
		}
		else
		{
			setDeviceAlaramInfo(ndobj,devicealarminfo);
		}
	}

	private boolean setDeviceAlaramInfo(NodeDetails ndobj,String alaraminfo) {
		// TODO Auto-generated method stub
		if(alaraminfo.trim().length()==0)
			return false; 
		try {
			M2MNodeOtagesDao outagedao =new M2MNodeOtagesDao();
			M2MNodeOtages outage=new M2MNodeOtages();
			M2MNodeOtages old_outage=null;
			outage.setNodeid(ndobj.getId());
			outage.setSlnumber(ndobj.getSlnumber());
			String alaraminfo_arr[]=alaraminfo.split(" ");
			outagedao.getM2MNodeOtages("slnumber", ndobj.getSlnumber());
			Date updatetime=DateTimeUtil.getTimeStampFormString(alaraminfo_arr[0].trim()+" "+alaraminfo_arr[1].trim());
			if(alaraminfo_arr[2].toLowerCase().endsWith("up") || alaraminfo_arr[2].toLowerCase().endsWith("down")||alaraminfo_arr[2].toLowerCase().equals("physical-link"))
			{
				String sts=alaraminfo_arr[4].toLowerCase().endsWith("up")?" Up":" Down";
				alaraminfo_arr[4]=sts.equals(" Down")?alaraminfo_arr[4].replace("-DOWN",""):alaraminfo_arr[4].replace("-UP","");
				if(alaraminfo_arr[2].toLowerCase().endsWith("up"))
				{
					sts=" Up";
					outage.setSeverity(SeverityNames.NORMAL);
					if(devicealarmlist.size()>0)
					{
						for(String info:devicealarmlist)
						{

							String info_arr[]=info.split(":");
							String coninfo_arr[]=info_arr[0].split(" ");
							if(coninfo_arr[0].equals(alaraminfo_arr[3])&&(coninfo_arr[1].equals(alaraminfo_arr[4])||coninfo_arr[1].equals("Connection-Lost")||coninfo_arr[1].equals("PHYSICAL-LINK")))
							{
								old_outage=outagedao.getLastDeviceAlaramOtage(ndobj.getSlnumber(),"alarminfo",info_arr[1]);
								if(old_outage!=null)
								{
									old_outage.setSeverity(SeverityNames.CLEARED);
									try
									{
										old_outage.setUptime(updatetime);
									}
									catch(Exception e)
									{
										old_outage.setUptime(Calendar.getInstance().getTime());
									}
									outagedao.updateM2MNodeOtage(old_outage);
								}
							}
						}
					}
				}
				else if(alaraminfo_arr[2].toLowerCase().endsWith("down")||alaraminfo_arr[2].toLowerCase().equals("physical-link"))
				{
					sts=" Down";
					outage.setSeverity(SeverityNames.MAJOR);
					if(alaraminfo_arr[2].equals("physical-link"))
						devicealarmlist.add(alaraminfo_arr[3]+" "+alaraminfo_arr[2]+":"+alaraminfo_arr[3] + sts +" ("+alaraminfo_arr[2]+")");
					else
						devicealarmlist.add(alaraminfo_arr[3]+" "+alaraminfo_arr[4]+":"+alaraminfo_arr[3] + sts +" ("+alaraminfo_arr[4]+")");
				}
				if(alaraminfo_arr[2].equals("physical-link"))
					outage.setAlarmInfo(alaraminfo_arr[3] + sts +" ("+alaraminfo_arr[2]+")");
				else
					outage.setAlarmInfo(alaraminfo_arr[3] + sts +" ("+alaraminfo_arr[4]+")");
			}
			else
			{
				outage.setSeverity(SeverityNames.WARNING);
				if(alaraminfo_arr[2].toLowerCase().equals("cold-start") ||alaraminfo_arr[2].toLowerCase().equals("warm-start"))
					outage.setAlarmInfo(alaraminfo_arr[2]);
				else
					outage.setAlarmInfo(alaraminfo_arr[2]+" "+alaraminfo_arr[3]+" "+alaraminfo_arr[4]);
			}
			try
			{
				outage.setUpdateTime(updatetime);
			}
			catch(Exception e)
			{
				outage.setUpdateTime(Calendar.getInstance().getTime());
			}
			if(!outagedao.isAlarmExists(outage,updatetime))
				outagedao.addM2MNodeOtages(outage);
		return true;
		}
		catch (Exception e) {
			// TODO: handle exception
			return false;
		}
		
	}

	private synchronized void setNodeDown(String slnumber) {
		// TODO Auto-generated method stub
		NodeDetails node = mn.getNodeDetails("slnumber", slnumber);
		M2MNodeOtagesDao outagedao = new M2MNodeOtagesDao();
		if(node != null && node.getStatus().equals(NodeStatus.UP))
		{
			node.setStatus(NodeStatus.DOWN);
			node.setUpgradestarttime(null);
			M2MNodeOtages lastoutage  = outagedao.getLastOutage(node.getId());
			if(lastoutage == null || lastoutage.getUptime() != null)
			{
				M2MNodeOtages outage  = new M2MNodeOtages();
				outage.setSlnumber(node.getSlnumber());
				outage.setNodeid(node.getId());
				Date date = Calendar.getInstance().getTime();
				outage.setDowntime(date);
				outage.setUpdateTime(date);
				outage.setAlarmInfo("Node is Down");
				outage.setSeverity(SeverityNames.CRITICAL);
				outagedao.addM2MNodeOtages(outage);
			}
			mn.updateNodeDetails(node);
		}
  	}
	private void updateDioStatus(Socket socket, String diostatusinfo)
	{
		NodeDetails ndobj = mn.getNodeDetails("connectedip", socket.getRemoteSocketAddress().toString().trim().replace("/",""));
		if(ndobj == null || ndobj.getStatus().equals(DELETED_STR))
		{
			closeSocket(socket);
			return;
		}
		String dio_status_arr[] = diostatusinfo.split(",");
		String old_dio1 = ndobj.getDi1();
		String old_dio2 = ndobj.getDi2();
		String old_dio3 = ndobj.getDi3();
		if(dio_status_arr.length >= 3)
		{
			ndobj.setDi1(dio_status_arr[0]);
			ndobj.setDi2(dio_status_arr[1]);
			ndobj.setDi3(dio_status_arr[2]);
			mn.updateNodeDetails(ndobj);
		}
		M2MNodeOtagesDao outagedao =new M2MNodeOtagesDao();
		M2MNodeOtages old_outage;
		if(old_dio1 != null && !old_dio1.equals(dio_status_arr[0]))
		{
			M2MNodeOtages outage = new M2MNodeOtages();
			Date date =new Date();
			outage.setNodeid(ndobj.getId());
			outage.setUpdateTime(date);
			outage.setSlnumber(ndobj.getSlnumber());
			if(dio_status_arr[0].equals("1"))
				outage.setSeverity(SeverityNames.MAJOR);
			else if(dio_status_arr[0].equals("2"))
			{
				outage.setSeverity(SeverityNames.WARNING);
				
			}
			else if(dio_status_arr[0].equals("0"))
			{
				outage.setSeverity(SeverityNames.NORMAL);
				old_outage = outagedao.getLastM2MDioOtage("slnumber", ndobj.getSlnumber(), "DI 1");
				if(old_outage != null)
				{
					old_outage.setSeverity(SeverityNames.CLEARED);
					outagedao.updateM2MNodeOtage(old_outage);
				}
			}
			outage.setAlarmInfo("DI 1 State Changed From "+(old_dio1.equals("0")?"Down":(old_dio1.equals("1")?"Up":"Disabled"))+" To "+(dio_status_arr[0].equals("0")?"Down":(dio_status_arr[0].equals("1")?"Up":"Disabled")));
			outagedao.addM2MNodeOtages(outage);
			
		}
		if(old_dio2 != null && !old_dio2.equals(dio_status_arr[1]))
		{
			M2MNodeOtages outage = new M2MNodeOtages();
			Date date =new Date();
			outage.setNodeid(ndobj.getId());
			outage.setUpdateTime(date);
			outage.setSlnumber(ndobj.getSlnumber());
			if(dio_status_arr[1].equals("1"))
				outage.setSeverity(SeverityNames.MAJOR);
			else if(dio_status_arr[1].equals("0"))
			{
				outage.setSeverity(SeverityNames.NORMAL);
				old_outage = outagedao.getLastM2MDioOtage("slnumber", ndobj.getSlnumber(), "DI 2");
				if(old_outage != null)
				{
					old_outage.setSeverity(SeverityNames.CLEARED);
					outagedao.updateM2MNodeOtage(old_outage);
				}
			}
			outage.setAlarmInfo("DI 2 State Changed From "+(old_dio2.equals("0")?"Down":(old_dio2.equals("1")?"Up":"Disabled"))+" To "+(dio_status_arr[1].equals("0")?"Down":(dio_status_arr[1].equals("1")?"Up":"Disabled")));
			outagedao.addM2MNodeOtages(outage);
			
		}
		if(old_dio3 != null && !old_dio3.equals(dio_status_arr[2]))
		{
			M2MNodeOtages outage = new M2MNodeOtages();
			Date date =new Date();
			outage.setNodeid(ndobj.getId());
			outage.setUpdateTime(date);
			outage.setSlnumber(ndobj.getSlnumber());
			if(dio_status_arr[2].equals("1"))
				outage.setSeverity(SeverityNames.MAJOR);
			else if(dio_status_arr[2].equals("0"))
			{
				outage.setSeverity(SeverityNames.NORMAL);
				old_outage = outagedao.getLastM2MDioOtage("slnumber", ndobj.getSlnumber(), "DI 3");
				if(old_outage != null )
				{
					old_outage.setSeverity(SeverityNames.CLEARED);
					outagedao.updateM2MNodeOtage(old_outage);
				}
			}
			outage.setAlarmInfo("DI 3 State Changed From "+(old_dio3.equals("0")?"Down":(old_dio3.equals("1")?"Up":"Disabled"))+" To "+(dio_status_arr[2].equals("0")?"Down":(dio_status_arr[2].equals("1")?"Up":"Disabled")));
			outagedao.addM2MNodeOtages(outage);
		}
	}
	private void updateStatusDetails(Socket socket, String statusinfo) {
		// TODO Auto-generated method stub
		NodeDetails ndobj = mn.getNodeDetails("connectedip", socket.getRemoteSocketAddress().toString().trim().replace("/",""));
		String slnumber = ndobj != null? ndobj.getSlnumber():null;
		OrganizationData orgdata = null;
		if(slnumber != null)
			orgdata = orgdatadao.getOrganizationData(slnumber);
		if(ndobj == null || ndobj.getStatus().equals(DELETED_STR))
		{
			closeSocket(socket);
			return;
		}
		else if(orgdata != null && orgdata.getValidUpto().compareTo(DateTimeUtil.getOnlyDate(new Date())) < 0)
		{
			setNodeDown(slnumber);
			closeSocket(socket);
			return;
		}
		
		String status_arr[] = statusinfo.split(","); 
		if(status_arr.length >= 12)
		{
			ndobj.setIpsecstats(status_arr[0].trim());
			ndobj.setWanip(status_arr[1].trim());
			ndobj.setWanstatus(status_arr[2].trim());
			ndobj.setWanuptime(status_arr[3].trim());
			ndobj.setCelip(status_arr[4].trim());
			ndobj.setCelstatus(status_arr[5].trim());
			ndobj.setCeluptime(status_arr[6].trim());
			ndobj.setConintf(status_arr[7].trim());
			String ethport_status[] = status_arr[8].split(" ");
			if(ethport_status.length == 4)
			{
				ndobj.setSwitch1(ethport_status[0].trim().equals("0")?"DOWN":ethport_status[0].trim().equals("9")?"NA":"UP");
				ndobj.setSwitch2(ethport_status[1].trim().equals("0")?"DOWN":ethport_status[1].trim().equals("9")?"NA":"UP");
				ndobj.setSwitch3(ethport_status[2].trim().equals("0")?"DOWN":ethport_status[2].trim().equals("9")?"NA":"UP");
				ndobj.setSwitch4(ethport_status[3].trim().equals("0")?"DOWN":ethport_status[3].trim().equals("9")?"NA":"UP");
			}
			ndobj.setSignalstrength(status_arr[9].trim());
			ndobj.setRouteruptime(status_arr[10].trim());
			ndobj.setActivesim(status_arr[11].trim());
			if(status_arr.length >= 13)
				ndobj.setLoopbackip(status_arr[12].trim());
		    try
		    {
	            if(status_arr.length >= 14)
	            {
				ndobj.setZtnwid(status_arr[13].trim());
				ndobj.setZerotierip(status_arr[14].trim());
				ndobj.setFallbacksts(status_arr[15].trim());
				ndobj.setOpenvpnstatus(status_arr[16]);
	            }
	            if(status_arr.length >= 17)
	            {
	            	status_arr[17]=status_arr[17].trim().equals("-")?"-":status_arr[17].trim();
	            	status_arr[18]=status_arr[17].trim().equals("-")?"-":status_arr[18].trim();
	            	status_arr[19]=status_arr[17].trim().equals("-")?"-":status_arr[19].trim();
	            	ndobj.setLoadAverage(status_arr[17].trim()+","+status_arr[18].trim()+","+status_arr[19].trim());
	            	ndobj.setTotalUsableMemoryRAM(status_arr[20].trim());
	            	ndobj.setUsedMemory(status_arr[21].trim());
	            	ndobj.setUnallocatedFreeMemory(status_arr[22].trim());
	            	ndobj.setMemoryAvailableForAllocation(status_arr[23].trim());
	            	ndobj.setCached(status_arr[24].trim());
	            }
		    }
		    catch (Exception e) {
				// TODO: handle exception
			}
			if(status_arr.length >= 16)
			{
				//ndobj.setDio1(status_arr[13].trim());
				//ndobj.setDio2(status_arr[14].trim());
				//ndobj.setDio3(status_arr[15].trim());
			}
			mn.updateNodeDetails(ndobj);
		}
	}

	private void sendDatausage(Socket socket, OutputStream rawout, BufferedReader in ) {
		// TODO Auto-generated method stub
		String srcfile = "status.json";
		sendFile(socket, rawout, in, srcfile); 
	}
	private void sendMessage(Socket socket,String msg)
	{
		try {
			OutputStream out = socket.getOutputStream();
			out.write(("EventAck:"+msg).getBytes());
			out.flush();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	private void sendProceedOrAskStatus(Socket socket ,OutputStream rawout) throws IOException {
		// TODO Auto-generated method stub
		NodeDetails ndobj = mn.getNodeDetails("connectedip", socket.getRemoteSocketAddress().toString().trim().replace("/",""));

		String send_str=PROCEED_STR+"\n";
		if(ndobj != null && !ndobj.getStatus().equals(DELETED_STR))
		{
			if(ndobj.getExport().equals(YES_STR) || ndobj.getBulkupdate() == 1)
			{
				send_str = EXPORT_STATUS+"\n";
			}
			else if(ndobj.getSendconfig().equals(YES_STR) || ndobj.getBulkedit()==1)
			{
				send_str = SEND_CONFIG_STATUS+"\n";
			}
		}
		else
		{
			closeSocket(socket);
		}
		rawout.write(send_str.getBytes());
		rawout.flush();
	}

	private void closeSocket(Socket socket) {
		// TODO Auto-generated method stub
		try {
		socket.getOutputStream().close();
		socket.getInputStream().close();
			socket.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	private void resetHttpIndex(Socket socket) {
		// TODO Auto-generated method stub
		NodeDetails ndobj = mn.getNodeDetails("connectedip", socket.getRemoteSocketAddress().toString().trim().replace("/",""));

		if(ndobj != null)
		{
			BufferedWriter bw = null;
			try {
				bw = new BufferedWriter(new FileWriter(props.getProperty("tlsconfigspath")+File.separator+ndobj.getSlnumber()+File.separator+"httpindex.txt"));
				bw.write("0");
			}
			catch (Exception e) {
				// TODO: handle exception
			}
			finally
			{
				try
				{
					if(bw != null)
						bw.close();
				}
				catch (Exception e) {
					// TODO: handle exception
				}
			}
		}
	}

	/*
	 * private boolean isReadTimeout(long lreadtime_millis, long
	 * curtimeInMillis,long d_time_out) { // TODO Auto-generated method stub
	 * 
	 * 
	 * if((curtimeInMillis-lreadtime_millis)/(1000*60) > d_time_out) {
	 * System.out.println("timeout"); return true; } else return false;
	 * 
	 * }
	 */

	private void setLogs(Socket socket, String info,String severity) {
		// TODO Auto-generated method stub
		NodeDetails ndobj = mn.getNodeDetails("connectedip", socket.getRemoteSocketAddress().toString().trim().replace("/",""));

		if(ndobj != null)
		{
			logger.warn("message from Client "+socket.getRemoteSocketAddress().toString().trim().replace("/","")+" which has serial number "+ndobj.getSlnumber()+"is : "+info);
			M2MlogsDao mnlogs = new M2MlogsDao();
			M2Mlogs log = new M2Mlogs();
			log.setSlnumber(ndobj.getSlnumber());
			log.setNodeid(ndobj.getId());
			log.setUpdatetime(Calendar.getInstance().getTime());
			log.setLoginfo(info);
			log.setSeverity(severity);
			mnlogs.addM2MLog(log);
		}
		else
			logger.warn("message from Client "+socket.getRemoteSocketAddress().toString().trim().replace("/","")+" is : "+info);
	}

	private synchronized boolean setOutages(Socket socket,String type) {
		// TODO Auto-generated method stub
		boolean updated = false;
		try
		{
			NodeDetails ndobj = mn.getNodeDetails("connectedip", socket.getRemoteSocketAddress().toString().trim().replace("/",""));
			if(ndobj != null)
			{
				M2MNodeOtages outage;
				M2MNodeOtagesDao mnoutageobj = new M2MNodeOtagesDao();
				outage = mnoutageobj.getLastM2MNodeOtage("slnumber", ndobj.getSlnumber());
				if(type.equals(UPTIME_STR))
				{
					if(outage != null)
					{
						Date date = new Date();
						outage.setUptime(date);
						outage.setUpdateTime(date);
						outage.setSeverity(SeverityNames.CLEARED);

						mnoutageobj.updateM2MNodeOtage(outage);
						outage  = new M2MNodeOtages();
						outage.setSlnumber(ndobj.getSlnumber());
						outage.setNodeid(ndobj.getId());
						outage.setUpdateTime(date);
						outage.setAlarmInfo("Node is Up");
						outage.setSeverity(SeverityNames.NORMAL);
						mnoutageobj.addM2MNodeOtages(outage);
					}
				}
				else
				{
					if(outage == null)
					{
						outage  = new M2MNodeOtages();
						outage.setSlnumber(ndobj.getSlnumber());
						outage.setNodeid(ndobj.getId());
						Date date = Calendar.getInstance().getTime();
						outage.setDowntime(date);
						outage.setUpdateTime(date);
						outage.setAlarmInfo("Node is Down");
						outage.setSeverity(SeverityNames.CRITICAL);
						mnoutageobj.addM2MNodeOtages(outage);
					}
				}
				updated =  true;
			}
		}
		catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return updated;
	}

	private void updateNodeBulkConf(Socket socket,int status) {
		// TODO Auto-generated method stub
		NodeDetails ndobj = getNode("connectedip",socket.getRemoteSocketAddress().toString().trim().replace("/",""));
		if(status==SUCCESS)
			ndobj.setLastexport(Calendar.getInstance().getTime());
		ndobj.setBulkupdate(0);
		ndobj.setExport("no");
		ndobj.setExportstatus(status);
		mn.updateNodeDetails(ndobj,"Export",getStatus(status));
	}
	private String getStatus(int status) {
		// TODO Auto-generated method stub
		String statusstr = "InProgress";

		switch(status)
		{
		case 1 :
			statusstr = "Success";
			break;
		case 2 : 
			statusstr = "Fail";
			break;
		case 3 :
			statusstr = "Updating";
			break;
		}
		return statusstr;
	}

	private void updateNodeBulkEdit(Socket socket,int status) {
		// TODO Auto-generated method stub
		NodeDetails ndobj = getNode("connectedip",socket.getRemoteSocketAddress().toString().trim().replace("/",""));
		if(status==SUCCESS)
			ndobj.setLastconfig(Calendar.getInstance().getTime());
		ndobj.setBulkedit(0);
		ndobj.setSendconfig("no");
		ndobj.setSendconfigstatus(status);
		mn.updateNodeDetails(ndobj,"Edit",getStatus(status));
	}
	private void updateNodeOrg(Socket socket,int status) {
		// TODO Auto-generated method stub
		NodeDetails ndobj = getNode("connectedip",socket.getRemoteSocketAddress().toString().trim().replace("/",""));
		ndobj.setOrgupdate(0);
		//ndobj.setExportstatus(status);
		mn.updateNodeDetails(ndobj);
	}

	protected void updateNodeReboot(Socket socket,int status)
	{
		NodeDetails ndobj = getNode("connectedip",socket.getRemoteSocketAddress().toString().trim().replace("/",""));
		if(status==SUCCESS)
			ndobj.setLastreboot(Calendar.getInstance().getTime());
		ndobj.setReboot("no");
		ndobj.setRebootstatus(status);

		mn.updateNodeDetails(ndobj,"Reboot",getStatus(status));
	}

	protected void setNodeReboot(Socket socket)
	{
		NodeDetails ndobj = getNode("connectedip",socket.getRemoteSocketAddress().toString().trim().replace("/",""));
		ndobj.setReboot("yes");
		mn.updateNodeDetails(ndobj);
	}

	private void removeUpgradeActivity(Socket socket,int status) {
		// TODO Auto-generated method stub

		NodeDetails ndobj = getNode("connectedip",socket.getRemoteSocketAddress().toString().trim().replace("/",""));
		if(status==SUCCESS)
			ndobj.setLastupgrade(Calendar.getInstance().getTime());
		ndobj.setUpgrade("no");
		ndobj.setUpgradestatus(status);
		ndobj.setUpgradeversion("");
		ndobj.setUpgradestarttime(null);

		mn.updateNodeDetails(ndobj,"Upgrade",getStatus(status));
	}

	private String GetUpdates(Socket socket) {
		// TODO Auto-generated method stub
		NodeDetails ndobj = getNode("connectedip",socket.getRemoteSocketAddress().toString().trim().replace("/",""));
		/*
		 * if(no_space) { no_space = false; return REBOOT; }
		 */
		if(ndobj.getReboot().equals(YES_STR))
		{
			return REBOOT;
		}
		else if(ndobj.getUpgrade().equals(YES_STR))
		{
			if(mn.getFwProgressCount()>9 && ndobj.getUpgradestarttime() == null)
				return "FW in Queue";
			else
			{
				Date curtime = Calendar.getInstance().getTime();
				if(ndobj.getUpgradestarttime()==null)
					ndobj.setUpgradestarttime(curtime);
				mn.updateNodeDetails(ndobj);
				return FIRMWARE_UPGRADE;
			}
		}		
		else if(ndobj.getBulkupdate()==1)
			
		{
			return BULK_UPDATE;
		}
		else if(ndobj.getOrgupdate() == 1)
		{
			return ORG_UPDATE;
		}
		else if(ndobj.getExport().equals(YES_STR))
		{
			return EXPORT_STR;
		}
		else if((ndobj.getSendconfig().equals(YES_STR) && ndobj.getBulkupdate() ==0) /*|| checkConfigExists(ndobj.getSlnumber())*/)
		{
			return ndobj.getBulkedit()==1?BULK_EDIT:CONFIGURATION;
		}
		else
		{
			return NONE;
		}
	}

	protected  boolean checkConfigExists(String serialno) {
		// TODO Auto-generated method stub

		String tlsconfigspath = props.getProperty("tlsconfigspath")==null?"":props.getProperty("tlsconfigspath");

		targetfilename = props.getProperty("targetfilename")==null?"":props.getProperty("targetfilename");

		File tlssldir =  new File(tlsconfigspath+"/"+serialno);
		if(!tlssldir.exists())
			return false;

		File configfile = new File (tlssldir+"/"+targetfilename);
		if(!configfile.exists())
			return false;
		NodedetailsDao mn = new NodedetailsDao();
		NodeDetails node = mn.getNodeDetails("slnumber", serialno);
		/*
		 * BasicFileAttributes fatr; try { fatr =
		 * Files.readAttributes(configfile.toPath(), BasicFileAttributes.class); return
		 * isFileModified(fatr.lastModifiedTime().toString()); } catch (IOException e) {
		 * // TODO Auto-generated catch block e.printStackTrace(); return false; }
		 */
		File versionfile = new File (tlssldir+"/version.txt");
		if(!versionfile.exists())
			return false;
		int version = getFileVersion(versionfile);
		//if(version > node.getCversion())
		if(version != node.getCversion())
		{
			node.setCversion(version);
			node.setSendconfig(YES_STR);
			mn.updateNodeDetails(node);
			return true;
		}
		else
			return false;
	}

	private int getFileVersion(File versionfile) {
		// TODO Auto-generated method stub
		int version = 0;
		FileReader fr = null;
		BufferedReader br = null;
		try {
			fr = new FileReader(versionfile);
			br = new BufferedReader(fr);
			String ver_str;
			while((ver_str=br.readLine()) != null)
			{
				if(ver_str.trim().length() > 0)
				{
					version = Integer.parseInt(ver_str.trim());
				}
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		finally {
			if(br != null)
				try {
					br.close();
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			if(fr != null)
				try {
					fr.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		}
		return version;
	}
	private void ReceiveDataUsage(Socket socket,InputStream rawin,OutputStream rawout)
	{
		// TODO Auto-generated method stub
		FileOutputStream out = null;
		BufferedOutputStream bout = null;
		File configfile = null;
		File tmpconfigfile = null;
		File tmpdir = null;
		boolean file_copied = false;
		try {

			BufferedReader in =
					new BufferedReader(
							new InputStreamReader(rawin));
			String line;
			String filename;
			//filename = in.readLine();
			//System.out.println("file name : "+filename);

			NodeDetails ndobj = getNode("connectedip",socket.getRemoteSocketAddress().toString().trim().replace("/",""));
			String tlsconfigspath = props.getProperty("tlsconfigspath")==null?"":props.getProperty("tlsconfigspath");
			String targetfilename = "Status.json";
			File tlssldir =  new File(tlsconfigspath+"/"+ndobj.getSlnumber());
			if(!tlssldir.exists())
				tlssldir.mkdir();

			long length = Long.parseLong(in.readLine().replace("length:", "").replace("Length:", ""));

			String cmd = in.readLine();

			if(cmd.equalsIgnoreCase("send:yes"))
			{
				configfile= new File(tlssldir.getAbsolutePath()+File.separator+"tmp"+File.separator+targetfilename);
				out = new FileOutputStream(configfile);
				bout = new BufferedOutputStream(out);

				int c = 0;

				byte[] buf;
				if(length > 8192)
					buf = new byte[8192];
				else
					buf = new byte[(int) length];
				int tot = 0;
				long tmplen=0;
				while((c = rawin.read(buf, 0, buf.length)) > 0)
				{
					//System.out.println(c);
					tot+=c;
					//System.out.println("total = "+tot);
					bout.write(buf, 0, c);
					bout.flush();
					tmplen += buf.length;
					if(length == tmplen)
					{
						file_copied = true;
						break;
					}
					if(length-tmplen < 8192)
					{
						buf = new byte[(int) (length-tmplen)];
					}
				}
				bout.close();
				out.close();
				if(configfile.length() >= length)
				{
					Files.copy(configfile.toPath(),new File(tlssldir.getAbsolutePath()+"/"+targetfilename).toPath(), StandardCopyOption.REPLACE_EXISTING);
					try
					{
					configfile.delete();
					}catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
				}
				rawout.write(("Sent:"+length+"\n").getBytes());
				rawout.flush();
				saveDataUsageToTable(ndobj);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally {
			try {
				if(bout != null)
					bout.close();
				if(out != null)
					out.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	private void saveDataUsageToTable(NodeDetails ndobj) throws IOException
	{
		DataUsageDao datadao = new DataUsageDao();
		String sim1dayupvalue = "";
			String sim1daydownvalue = "";
			String sim1daydatevalue = "";
			String sim1weekupvalue = "";
			String sim1weekdownvalue = "";
			String sim1weekdatevalue = "";
			String sim1monthupvalue = "";
			String sim1monthdownvalue = "";
			String sim1monthdatevalue = "";
			String sim2dayupvalue = "";
			String sim2daydownvalue = "";
			String sim2daydatevalue = "";
			String sim2weekupvalue = "";
			String sim2weekdownvalue = "";
			String sim2weekdatevalue = "";
			String sim2monthupvalue = "";
			String sim2monthdownvalue = "";
			String sim2monthdatevalue = "";
			JSONObject statusobj = null;
			BufferedReader jsonfile = null;
			StringBuffer jsonbuf = new StringBuffer("");
			if (ndobj.getSlnumber() != null && ndobj.getSlnumber().trim().length() > 0) {
				Properties m2mprops = M2MProperties.getM2MProperties();
				String slnumpath = m2mprops.getProperty("tlsconfigspath") + File.separator + ndobj.getSlnumber();
				try {
					jsonfile = new BufferedReader(new FileReader(new File(slnumpath + File.separator + "Status.json")));
				} catch (Exception e) {
					e.printStackTrace();
				}
				String jsonString = null;
				if (jsonfile != null) {
					while ((jsonString = jsonfile.readLine()) != null)
						jsonbuf.append(jsonString);
				}
				}
				if (jsonbuf != null && jsonbuf.length() > 0) {
				statusobj = JSONObject.fromObject(jsonbuf.toString());
				JSONObject datausgobj = statusobj.getJSONObject("STATUS").getJSONObject("DataUsage");
				//JSONObject dayusage = statusobj.getJSONObject("HEADINGDSIM1");
				JSONObject s1dayusage = datausgobj.getJSONObject("TABLEDSIM1");
				JSONObject s2dayusage = datausgobj.getJSONObject("TABLEDSIM2");
				JSONArray s1dayarr = s1dayusage.getJSONArray("arr");
				JSONArray s2dayarr = s2dayusage.getJSONArray("arr");
				for (int i = 0; i < s1dayarr.size(); i++) {
					JSONObject dayobj = s1dayarr.getJSONObject(i);
					sim1dayupvalue += dayobj.getString("Upload(KB)") + ",";
					sim1daydownvalue += dayobj.getString("Download(KB)") + ",";
					sim1daydatevalue += dayobj.getString("Date") + ",";
				}
				for (int i = 0; i < s2dayarr.size(); i++) {
					JSONObject dayobj = s2dayarr.getJSONObject(i);
					sim2dayupvalue += dayobj.getString("Upload(KB)") + ",";
					sim2daydownvalue += dayobj.getString("Download(KB)") + ",";
					sim2daydatevalue += dayobj.getString("Date") + ",";
				}

				for (int i = s1dayarr.size(); i < 7; i++) {
					sim1dayupvalue += "0.00,";
					sim1daydownvalue += "0.00,";
					sim1daydatevalue += " ,";
				}
				for (int i = s2dayarr.size(); i < 7; i++) {
					sim2dayupvalue += "0.00,";
					sim2daydownvalue += "0.00,";
					sim2daydatevalue += " ,";
				}
				//JSONObject weekusage = datausgobj.getJSONObject("HEADINGW");
				JSONObject s1weekusage = datausgobj.getJSONObject("TABLEWSIM1");
				JSONObject s2weekusage = datausgobj.getJSONObject("TABLEWSIM2");
				JSONArray s1weekarr = s1weekusage.getJSONArray("arr");
				JSONArray s2weekarr = s2weekusage.getJSONArray("arr");
				for (int i = 0; i < s1weekarr.size(); i++) {
					JSONObject weekobj = s1weekarr.getJSONObject(i);
					sim1weekupvalue += weekobj.getString("Upload(MB)") + ",";
					sim1weekdownvalue += weekobj.getString("Download(MB)") + ",";
					sim1weekdatevalue += weekobj.getString("Week") + ",";
				}
				for (int i = 0; i < s2weekarr.size(); i++) {
					JSONObject weekobj = s2weekarr.getJSONObject(i);
					sim2weekupvalue += weekobj.getString("Upload(MB)") + ",";
					sim2weekdownvalue += weekobj.getString("Download(MB)") + ",";
					sim2weekdatevalue += weekobj.getString("Week") + ",";
				}
				for (int i = s1weekarr.size(); i < 7; i++) {
					sim1weekupvalue += "0.00,";
					sim1weekdownvalue += "0.00,";
					sim1weekdatevalue += " ,";
				}
				for (int i = s2weekarr.size(); i < 7; i++) {
					sim2weekupvalue += "0.00,";
					sim2weekdownvalue += "0.00,";
					sim2weekdatevalue += " ,";
				}
				//JSONObject mthusage = datausgobj.getJSONObject("HEADINGM");
				JSONObject s1mthusage = datausgobj.getJSONObject("TABLEMSIM1");
				JSONObject s2mthusage = datausgobj.getJSONObject("TABLEMSIM2");
				JSONArray s1mtharr = s1mthusage.getJSONArray("arr");
				JSONArray s2mtharr = s2mthusage.getJSONArray("arr");
				for (int i = 0; i < s1mtharr.size(); i++) {
					JSONObject mthobj = s1mtharr.getJSONObject(i);
					sim1monthupvalue += mthobj.getString("Upload(MB)") + ",";
					sim1monthdownvalue += mthobj.getString("Download(MB)") + ",";
					sim1monthdatevalue += mthobj.getString("Month") + ",";
				}
				for (int i = 0; i < s2mtharr.size(); i++) {
					JSONObject mthobj = s2mtharr.getJSONObject(i);
					sim2monthupvalue += mthobj.getString("Upload(MB)") + ",";
					sim2monthdownvalue += mthobj.getString("Download(MB)") + ",";
					sim2monthdatevalue += mthobj.getString("Month") + ",";
				}
				for (int i = s1mtharr.size(); i < 7; i++) {
					sim1monthupvalue += "0.00,";
					sim1monthdownvalue += "0.00,";
					sim1monthdatevalue += " ,";
				}
				for (int i = s2mtharr.size(); i < 7; i++) {
					sim2monthupvalue += "0.00,";
					sim2monthdownvalue += "0.00,";
					sim2monthdatevalue += " ,";
				}
				sim1dayupvalue = sim1dayupvalue.length() > 0
						? sim1dayupvalue.substring(0, sim1dayupvalue.length() - 1)
						: sim1dayupvalue;
				sim1daydownvalue = sim1daydownvalue.substring(0, sim1daydownvalue.length() - 1);
				sim1daydatevalue = sim1daydatevalue.substring(0, sim1daydatevalue.length() - 1);
				sim1weekupvalue = sim1weekupvalue.substring(0, sim1weekupvalue.length() - 1);
				sim1weekdownvalue = sim1weekdownvalue.substring(0, sim1weekdownvalue.length() - 1);
				sim1weekdatevalue = sim1weekdatevalue.substring(0, sim1weekdatevalue.length() - 1);
				sim1monthupvalue = sim1monthupvalue.substring(0, sim1monthupvalue.length() - 1);
				sim1monthdownvalue = sim1monthdownvalue.substring(0, sim1monthdownvalue.length() - 1);
				sim1monthdatevalue = sim1monthdatevalue.substring(0, sim1monthdatevalue.length() - 1);

				sim2dayupvalue = sim2dayupvalue.length() > 0
						? sim2dayupvalue.substring(0, sim2dayupvalue.length() - 1)
						: sim2dayupvalue;
				sim2daydownvalue = sim2daydownvalue.substring(0, sim2daydownvalue.length() - 1);
				sim2daydatevalue = sim2daydatevalue.substring(0, sim2daydatevalue.length() - 1);
				sim2weekupvalue = sim2weekupvalue.substring(0, sim2weekupvalue.length() - 1);
				sim2weekdownvalue = sim2weekdownvalue.substring(0, sim2weekdownvalue.length() - 1);
				sim2weekdatevalue = sim2weekdatevalue.substring(0, sim2weekdatevalue.length() - 1);
				sim2monthupvalue = sim2monthupvalue.substring(0, sim2monthupvalue.length() - 1);
				sim2monthdownvalue = sim2monthdownvalue.substring(0, sim2monthdownvalue.length() - 1);
				sim2monthdatevalue = sim2monthdatevalue.substring(0, sim2monthdatevalue.length() - 1);
				}
				String[] s1daydatearr = sim1daydatevalue.split(",");
				String[] s1dayuparr = sim1dayupvalue.split(",");
				String[] s1daydownarr = sim1daydownvalue.split(",");
				String[] s1weekdatearr = sim1weekdatevalue.split(",");
				String[] s1weekuparr = sim1weekupvalue.split(",");
				String[] s1weekdownarr = sim1weekdownvalue.split(",");
				String[] s1monthdatearr = sim1monthdatevalue.split(",");
				String[] s1monthuparr = sim1monthupvalue.split(",");
				String[] s1monthdownarr = sim1monthdownvalue.split(",");
				String[] s2daydatearr = sim2daydatevalue.split(",");
				String[] s2dayuparr = sim2dayupvalue.split(",");
				String[] s2daydownarr = sim2daydownvalue.split(",");
				String[] s2weekdatearr = sim2weekdatevalue.split(",");
				String[] s2weekuparr = sim2weekupvalue.split(",");
				String[] s2weekdownarr = sim2weekdownvalue.split(",");
				String[] s2monthdatearr = sim2monthdatevalue.split(",");
				String[] s2monthuparr = sim2monthupvalue.split(",");
				String[] s2monthdownarr = sim2monthdownvalue.split(",");
		DataUsage usage = datadao.getDataUsage("slnumber", ndobj.getSlnumber());
		boolean is_exists = true;
		if(usage==null)
		{
			usage = new DataUsage();
			is_exists = false;
		}
		usage.setS1daydate1(s1daydatearr[0]);
		usage.setS1daydate2(s1daydatearr[1]);
		usage.setS1daydate3(s1daydatearr[2]);
		usage.setS1daydate4(s1daydatearr[3]);
		usage.setS1daydate5(s1daydatearr[4]);
		usage.setS1daydate6(s1daydatearr[5]);
		usage.setS1daydate7(s1daydatearr[6]);
		usage.setS1daydownload1(s1daydownarr[0]);
		usage.setS1daydownload2(s1daydownarr[1]);
		usage.setS1daydownload3(s1daydownarr[2]);
		usage.setS1daydownload4(s1daydownarr[3]);
		usage.setS1daydownload5(s1daydownarr[4]);
		usage.setS1daydownload6(s1daydownarr[5]);
		usage.setS1daydownload7(s1daydownarr[6]);
		usage.setS1dayupload1(s1dayuparr[0]);
		usage.setS1dayupload2(s1dayuparr[1]);
		usage.setS1dayupload3(s1dayuparr[2]);
		usage.setS1dayupload4(s1dayuparr[3]);
		usage.setS1dayupload5(s1dayuparr[4]);
		usage.setS1dayupload6(s1dayuparr[5]);
		usage.setS1dayupload7(s1dayuparr[6]);
		
		usage.setS2daydate1(s2daydatearr[0]);
		usage.setS2daydate2(s2daydatearr[1]);
		usage.setS2daydate3(s2daydatearr[2]);
		usage.setS2daydate4(s2daydatearr[3]);
		usage.setS2daydate5(s2daydatearr[4]);
		usage.setS2daydate6(s2daydatearr[5]);
		usage.setS2daydate7(s2daydatearr[6]);
		usage.setS2daydownload1(s2daydownarr[0]);
		usage.setS2daydownload2(s2daydownarr[1]);
		usage.setS2daydownload3(s2daydownarr[2]);
		usage.setS2daydownload4(s2daydownarr[3]);
		usage.setS2daydownload5(s2daydownarr[4]);
		usage.setS2daydownload6(s2daydownarr[5]);
		usage.setS2daydownload7(s2daydownarr[6]);
		usage.setS2dayupload1(s2dayuparr[0]);
		usage.setS2dayupload2(s2dayuparr[1]);
		usage.setS2dayupload3(s2dayuparr[2]);
		usage.setS2dayupload4(s2dayuparr[3]);
		usage.setS2dayupload5(s2dayuparr[4]);
		usage.setS2dayupload6(s2dayuparr[5]);
		usage.setS2dayupload7(s2monthuparr[6]);
		
		usage.setS1weekdate1(s1weekdatearr[0]);
		usage.setS1weekdate2(s1weekdatearr[1]);
		usage.setS1weekdate3(s1weekdatearr[2]);
		usage.setS1weekdate4(s1weekdatearr[3]);
		usage.setS1weekdate5(s1weekdatearr[4]);
		usage.setS1weekdate6(s1weekdatearr[5]);
		usage.setS1weekdate7(s1weekdatearr[6]);
		usage.setS1weekdownload1(s1weekdownarr[0]);
		usage.setS1weekdownload2(s1weekdownarr[1]);
		usage.setS1weekdownload3(s1weekdownarr[2]);
		usage.setS1weekdownload4(s1weekdownarr[3]);
		usage.setS1weekdownload5(s1weekdownarr[4]);
		usage.setS1weekdownload6(s1weekdownarr[5]);
		usage.setS1weekdownload7(s1weekdownarr[6]);
		usage.setS1weekupload1(s1weekuparr[0]);
		usage.setS1weekupload2(s1weekuparr[1]);
		usage.setS1weekupload3(s1weekuparr[2]);
		usage.setS1weekupload4(s1weekuparr[3]);
		usage.setS1weekupload5(s1weekuparr[4]);
		usage.setS1weekupload6(s1weekuparr[5]);
		usage.setS1weekupload7(s1weekuparr[6]);
		
		usage.setS2weekdate1(s2weekdatearr[0]);
		usage.setS2weekdate2(s2weekdatearr[1]);
		usage.setS2weekdate3(s2weekdatearr[2]);
		usage.setS2weekdate4(s2weekdatearr[3]);
		usage.setS2weekdate5(s2weekdatearr[4]);
		usage.setS2weekdate6(s2weekdatearr[5]);
		usage.setS2weekdate7(s2weekdatearr[6]);
		usage.setS2weekdownload1(s2weekdownarr[0]);
		usage.setS2weekdownload2(s2weekdownarr[1]);
		usage.setS2weekdownload3(s2weekdownarr[2]);
		usage.setS2weekdownload4(s2weekdownarr[3]);
		usage.setS2weekdownload5(s2weekdownarr[4]);
		usage.setS2weekdownload6(s2weekdownarr[5]);
		usage.setS2weekdownload7(s2weekdownarr[6]);
		usage.setS2weekupload1(s2weekuparr[0]);
		usage.setS2weekupload2(s2weekuparr[1]);
		usage.setS2weekupload3(s2weekuparr[2]);
		usage.setS2weekupload4(s2weekuparr[3]);
		usage.setS2weekupload5(s2weekuparr[4]);
		usage.setS2weekupload6(s2weekuparr[5]);
		usage.setS2weekupload7(s2weekuparr[6]);
		
		usage.setS1monthdate1(s1monthdatearr[0]);
		usage.setS1monthdate2(s1monthdatearr[1]);
		usage.setS1monthdate3(s1monthdatearr[2]);
		usage.setS1monthdate4(s1monthdatearr[3]);
		usage.setS1monthdate5(s1monthdatearr[4]);
		usage.setS1monthdate6(s1monthdatearr[5]);
		usage.setS1monthdate7(s1monthdatearr[6]);
		usage.setS1monthdownload1(s1monthdownarr[0]);
		usage.setS1monthdownload2(s1monthdownarr[1]);
		usage.setS1monthdownload3(s1monthdownarr[2]);
		usage.setS1monthdownload4(s1monthdownarr[3]);
		usage.setS1monthdownload5(s1monthdownarr[4]);
		usage.setS1monthdownload6(s1monthdownarr[5]);
		usage.setS1monthdownload7(s1monthdownarr[6]);
		usage.setS1monthupload1(s1monthuparr[0]);
		usage.setS1monthupload2(s1monthuparr[1]);
		usage.setS1monthupload3(s1monthuparr[2]);
		usage.setS1monthupload4(s1monthuparr[3]);
		usage.setS1monthupload5(s1monthuparr[4]);
		usage.setS1monthupload6(s1monthuparr[5]);
		usage.setS1monthupload7(s1monthuparr[6]);
		
		usage.setS2monthdate1(s2monthdatearr[0]);
		usage.setS2monthdate2(s2monthdatearr[1]);
		usage.setS2monthdate3(s2monthdatearr[2]);
		usage.setS2monthdate4(s2monthdatearr[3]);
		usage.setS2monthdate5(s2monthdatearr[4]);
		usage.setS2monthdate6(s2monthdatearr[5]);
		usage.setS2monthdate7(s2monthdatearr[6]);
		usage.setS2monthdownload1(s2monthdownarr[0]);
		usage.setS2monthdownload2(s2monthdownarr[1]);
		usage.setS2monthdownload3(s2monthdownarr[2]);
		usage.setS2monthdownload4(s2monthdownarr[3]);
		usage.setS2monthdownload5(s2monthdownarr[4]);
		usage.setS2monthdownload6(s2monthdownarr[5]);
		usage.setS2monthdownload7(s2monthdownarr[6]);
		usage.setS2monthupload1(s2monthuparr[0]);
		usage.setS2monthupload2(s2monthuparr[1]);
		usage.setS2monthupload3(s2monthuparr[2]);
		usage.setS2monthupload4(s2monthuparr[3]);
		usage.setS2monthupload5(s2monthuparr[4]);
		usage.setS2monthupload6(s2monthuparr[5]);
		usage.setS2monthupload7(s2monthuparr[6]);
		usage.setSlnumber(ndobj.getSlnumber());
		if(is_exists)
			datadao.updateDataUsage(usage);
		else
			datadao.addDataUsage(usage);
		if(jsonfile != null)
			jsonfile.close();
	}
	private  void ReceiveConfigFile(Socket socket,InputStream rawin,OutputStream rawout) {
		// TODO Auto-generated method stub

		FileOutputStream out = null;
		BufferedOutputStream bout = null;
		File configfile = null;
		File tmpconfigfile = null;
		File tmpdir = null;
		boolean file_copied = false;
		try {

			BufferedReader in =
					new BufferedReader(
							new InputStreamReader(rawin));
			String line;
			String filename;
			//filename = in.readLine();
			//System.out.println("file name : "+filename);
			NodeDetails ndobj = getNode("connectedip",socket.getRemoteSocketAddress().toString().trim().replace("/",""));
			String tlsconfigspath = props.getProperty("tlsconfigspath")==null?"":props.getProperty("tlsconfigspath");
			targetfilename = props.getProperty("targetfilename")==null?"":props.getProperty("targetfilename");
			File tlssldir =  new File(tlsconfigspath+"/"+ndobj.getSlnumber());
			tmpdir = new File(tlsconfigspath+"/"+ndobj.getSlnumber()+"/tmp");
			if(!tlssldir.exists())
				tlssldir.mkdir();
			if(!tmpdir.exists())
				tmpdir.mkdir();

			long length = Long.parseLong(in.readLine().replace("length:", "").replace("Length:", ""));

			String cmd = in.readLine();
			//logger.info("target file name is : "+targetfilename+" for receiveing WiZ_NG.zip is "+targetfilename);
			
			if(cmd.equalsIgnoreCase("send:yes"))
			{
				configfile= new File(tlssldir.getAbsolutePath()+File.separator+targetfilename);
				tmpconfigfile= new File(tmpdir.getAbsolutePath()+File.separator+targetfilename);
				System.out.println(tmpconfigfile.getAbsolutePath());
				out = new FileOutputStream(tmpconfigfile);
				bout = new BufferedOutputStream(out);

				int c = 0;

				byte[] buf;
				if(length > 8192)
					buf = new byte[8192];
				else
					buf = new byte[(int) length];
				int tot = 0;
				long tmplen=0;
				while((c = rawin.read(buf, 0, buf.length)) > 0)
				{
					//System.out.println(c);
					tot+=c;
					bout.write(buf, 0, c);
					bout.flush();
					tmplen += buf.length;
					if(length == tmplen)
					{
						file_copied = true;
						break;
					}
					if(length-tmplen < 8192)
					{
						buf = new byte[(int) (length-tmplen)];
					}
				}
				//System.out.println("File Copied..."+length+"  "+tmplen);
				rawout.write(("Sent:"+length+"\n").getBytes());
				rawout.flush();
				/*
				 * if(configfile != null) { BasicFileAttributes fatr =
				 * Files.readAttributes(configfile.toPath(), BasicFileAttributes.class); }
				 */
				String udate = GetUpdates(socket);
				if(file_copied && !udate.equals(BULK_UPDATE) && !udate.equals(ORG_UPDATE) && !udate.equals(EXPORT_STR) 
						&& !udate.equals(CONFIGURATION) && !udate.equals(BULK_EDIT))
					Files.copy(tmpconfigfile.toPath(), configfile.toPath(), StandardCopyOption.REPLACE_EXISTING);
				//tmpconfigfile.delete();
				//tmpdir.delete();
				try
				{
					tmpconfigfile.delete();
					if(tmpdir.exists())
						FileUtils.deleteDirectory(tmpdir);
				}
				catch(Exception e) {}
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally {
			try {
				if(bout != null)
					bout.close();
				if(out != null)
					out.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	protected  void sendFirwareFile(Socket socket,OutputStream rawOut ,BufferedReader in,String filename)
	{
		// TODO Auto-generated method stub
		FileInputStream fis = null;
		DataInputStream dis = null;


		NodeDetails nd = getNode("connectedip",socket.getRemoteSocketAddress().toString().trim().replace("/",""));
		try {
			String firmwaredir =  props.getProperty("firmwaredir")==null?"":props.getProperty("firmwaredir");

			File firmwareverdir =  new File(firmwaredir+"/"+nd.getUpgradeversion());
			if(firmwareverdir.exists())
			{
				File srcfile =  new File(firmwareverdir+File.separator+filename);
				if(srcfile.exists())
				{
					fis = new FileInputStream(srcfile);
					System.out.println("available file size is : "+fis.available()+" in bytes ");

					BasicFileAttributes fatr = Files.readAttributes(srcfile.toPath(), 
							BasicFileAttributes.class);
					if(fis.available() > 0)
					{
						filelength = fis.available();
						String len = "Length:"+fis.available()+"\n";
						/*
						 * byte lenbuff[] = new byte[len.getBytes().length]; InputStream is = new
						 * ByteArrayInputStream(len.getBytes(Charset.forName("UTF-8")));
						 * 
						 * DataInputStream dis1 = new DataInputStream(is); dis1.readFully(lenbuff);
						 */

						rawOut.write(len.getBytes());
						rawOut.flush();
						String cmd = in.readLine();
						while(cmd.equals(FILE_STR+filename))
						{							
							rawOut.write("".getBytes());
							rawOut.flush();
							cmd = in.readLine();
						}
						if(cmd.equalsIgnoreCase("receive:yes"))
						{
							byte buff[] = new byte[fis.available()];
							dis = new DataInputStream(fis);
							//dis.readFully(buff);
							
							//rawOut.write(buff);
							//rawOut.flush();
							
							int count;
							byte[] buffer = new byte[1460];
							while ((count = dis.read(buffer)) > 0)
							{
								rawOut.write(buffer, 0, count);
								rawOut.flush();
							}
							
						}
						else if(cmd.equalsIgnoreCase("receive:no"))
						{
							//no_space = true;
							setNodeReboot(socket);
						}
					}
					else
					{
						rawOut.write("Length:0\n".getBytes());
						rawOut.flush();
					}
				}
				else
				{
					rawOut.write("Length:0\n".getBytes());
					rawOut.flush();
				}
			}
			else
			{
				rawOut.write("Length:0\n".getBytes());
				rawOut.flush();
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally {
			if(dis != null)
				try {
					dis.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			if(fis != null)
				try {
					fis.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		}

	}
	protected  void sendConfigFile(Socket socket,OutputStream rawOut ,BufferedReader in) {
		targetfilename = props.getProperty("targetfilename")==null?"":props.getProperty("targetfilename");
		sendFile(socket,rawOut,in,targetfilename);
	}

	private void sendFile(Socket socket,OutputStream rawOut ,BufferedReader in,String targetfilename) {
		// TODO Auto-generated method stub

		// TODO Auto-generated method stub
		FileInputStream fis = null;
		DataInputStream dis = null;

		try {
			String tlsconfigspath = props.getProperty("tlsconfigspath")==null?"":props.getProperty("tlsconfigspath");

			NodeDetails ndobj = getNode("connectedip",socket.getRemoteSocketAddress().toString().trim().replace("/",""));
			File tlssldir =  new File(tlsconfigspath+"/"+ndobj.getSlnumber());
			if(tlssldir.exists())
			{
				File srcfile =  new File(tlssldir+"/"+targetfilename);
				if(srcfile.exists())
				{
					fis = new FileInputStream(srcfile);
					System.out.println("available file size is : "+fis.available()+" in bytes ");

					BasicFileAttributes fatr = Files.readAttributes(srcfile.toPath(), 
							BasicFileAttributes.class);
					if(fis.available() > 0 )
					{
						filelength = fis.available();
						String len = "Length:"+fis.available()+"\n";
						/*
						 * byte lenbuff[] = new byte[len.getBytes().length]; InputStream is = new
						 * ByteArrayInputStream(len.getBytes(Charset.forName("UTF-8")));
						 * 
						 * DataInputStream dis1 = new DataInputStream(is); dis1.readFully(lenbuff);
						 */

						rawOut.write(len.getBytes());
						rawOut.flush();
						String cmd = in.readLine();
						while(cmd.equals("Receive-Config"))
						{

							rawOut.write("".getBytes());
							rawOut.flush();
							cmd = in.readLine();
						}
						if(cmd.equalsIgnoreCase("receive:yes"))
						{
							byte buff[] = new byte[fis.available()];
							dis = new DataInputStream(fis);
							//dis.readFully(buff);
							//rawOut.write(buff);
							//rawOut.flush();
							
							int count;
							byte[] buffer = new byte[1460];
							while ((count = dis.read(buffer)) > 0)
							{
								rawOut.write(buffer, 0, count);
								rawOut.flush();
							}
						}
					}
					else
					{
						rawOut.write("Length:0\n".getBytes());
						rawOut.flush();
					}
				}
				else
				{
					rawOut.write("Length:0\n".getBytes());
					rawOut.flush();
				}
			}
			else
			{
				rawOut.write("Length:0\n".getBytes());
				rawOut.flush();
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally {
			if(dis != null)
				try {
					dis.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			if(fis != null)
				try {
					fis.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		}

	}

	/*
	 * protected boolean isFileModified(String serialno, String lastModifiedTime) {
	 * boolean isupdated = false; NodeDetails ndobj = mn.getNodeDetails("slnumber",
	 * serialno);
	 * 
	 * this.lastModifiedTime = lastModifiedTime; return isupdated; }
	 */

	protected void updateNodeSendConfig(Socket socket,int status)
	{
		NodeDetails ndobj = getNode("connectedip",socket.getRemoteSocketAddress().toString().trim().replace("/",""));
		if(status==SUCCESS)
			ndobj.setLastconfig(Calendar.getInstance().getTime());
		ndobj.setSendconfig("no");
		ndobj.setSendconfigstatus(status);
		mn.updateNodeDetails(ndobj);
	}
	protected void updateNodeExport(Socket socket,int status)
	{
		NodeDetails ndobj = getNode("connectedip",socket.getRemoteSocketAddress().toString().trim().replace("/",""));
		if(status==SUCCESS)
			ndobj.setLastexport(Calendar.getInstance().getTime());
		ndobj.setExport("no");
		ndobj.setExportstatus(status);
		mn.updateNodeDetails(ndobj);
	}
	protected boolean updateNodeStatus(Socket socket,String status)
	{
		NodeDetails ndobj = getNode("connectedip",socket.getRemoteSocketAddress().toString().trim().replace("/",""));

		if(ndobj !=null)
		{
			logger.warn("the Node with connectd ip "+socket.getRemoteSocketAddress().toString().trim().replace("/","")+" which has serial number "+ndobj.getSlnumber()+" is "+status);
			if(!ndobj.getStatus().equals("deleted"))
			{
				ndobj.setStatus(status);
				ndobj.setSeverity(SeverityNames.CRITICAL);
				Date date = Calendar.getInstance().getTime();
				ndobj.setDowntime(date);
				ndobj.setUptime(null);
				ndobj.setOutagecnt(ndobj.getOutagecnt()+1);
				ndobj.setConnectedip("");
				//ndobj.setUpgradestarttime(null);
				mn.updateNodeDetails(ndobj);
				mn.setTaskStatusFailed(ndobj);
				return true;
			}
		}
		return false;
	}
	private synchronized NodeDetails saveDetails(Socket socket,String line,String organization) throws IOException {
		// TODO Auto-generated method stub
		String[] nodedetails = line.split(",");
		ArrayList<String> nodedetarr= new ArrayList<String>();
		for(int i=0;i<nodedetails.length;i++)
			nodedetarr.add(nodedetails[i]);

		if(nodedetails.length < PDET_CNT)
		{
			for(int i = nodedetails.length; i<PDET_CNT; i++)
			{
				nodedetarr.add("");
			}
		}
		NodeDetails ndobj;
		boolean is_exists = true;

		NodedetailsDao mn = new NodedetailsDao();
		if(nodedetarr.get(2).trim().equals(""))
		{
			throw new IOException();
		}
		ndobj = mn.getNodeDetails("slnumber", nodedetarr.get(2).trim());
		String old_fw = null;
		String old_fw_date = null;
		if(ndobj == null)
		{
			ndobj = new NodeDetails();
			is_exists = false;
		}
		else if(ndobj.getStatus().equals(DELETED_STR))
		{
			throw new IOException();
		}
		else
		{
			old_fw = ndobj.getFwversion();
			old_fw_date = ndobj.getSwdate();
		}
		//cellularip,imei,slno,nodename,location,swdate,swversion,loopbackip,routeruptime,sigstrength,network,activesim, cputilization,memoryutil,modelnumber
		boolean is_down = ndobj.getStatus().equals("up")?false:true;
		ndobj.setStatus("up");
		ndobj.setOrganization(organization);
		ndobj.setIpaddress(nodedetarr.get(0).trim());
		ndobj.setImeinumber(nodedetarr.get(1).trim());
		ndobj.setSlnumber(nodedetarr.get(2).trim());
		ndobj.setNodelabel(nodedetarr.get(3).trim());
		ndobj.setLocation(nodedetarr.get(4).trim());
		ndobj.setSwdate(nodedetarr.get(5).trim());
		ndobj.setFwversion(nodedetarr.get(6).trim());
		
		ndobj.setLoopbackip(nodedetarr.get(7).trim());
		ndobj.setRouteruptime(nodedetarr.get(8).trim());
		ndobj.setSignalstrength(nodedetarr.get(9).trim());
		ndobj.setNetwork(nodedetarr.get(10).trim());
		ndobj.setActivesim(nodedetarr.get(11).trim());
		ndobj.setCpuutil(nodedetarr.get(12).trim());
		ndobj.setMemoryutil(nodedetarr.get(13).trim());
		ndobj.setModelnumber(nodedetarr.get(14).trim());
		if(nodedetarr.size() > 15)
			ndobj.setIpsecstats(nodedetarr.get(15).trim());
		if(nodedetarr.size() > 16)
		{
			ndobj.setSwitch1(nodedetarr.get(16).trim());
			ndobj.setSwitch2(nodedetarr.get(17).trim());
			ndobj.setSwitch3(nodedetarr.get(18).trim());
			ndobj.setSwitch4(nodedetarr.get(19).trim());
		}
		if(nodedetarr.size() > 20)
		{
			ndobj.setCellid(nodedetarr.get(20).trim());
			ndobj.setMhversion(nodedetarr.get(21).trim());
			ndobj.setDhversion(nodedetarr.get(22).trim());
			ndobj.setModulename(nodedetarr.get(23).trim());
			ndobj.setRevision(nodedetarr.get(24).trim());
		}
		if(nodedetarr.size() > 25)
		{
			ndobj.setNwband(nodedetarr.get(25).trim());
			ndobj.setIccid(nodedetarr.get(26).trim());
		}
		if(nodedetarr.size() > 26)
		{
			ndobj.setSim1usage(nodedetarr.get(27).trim());
			ndobj.setSim2usage(nodedetarr.get(28).trim());
		}

		ndobj.setConnectedip(socket.getRemoteSocketAddress().toString().trim().replace("/",""));
		
		/*if(!is_exists)
		{
			NodeDetails nd = mn.getNodeDetails("slnumber", nodedetarr.get(2).trim());
			if(nd != null)
			{
				is_exists = true;
				ndobj.setId(nd.getId());
			}
		}*/
		if(is_exists)
		{
			if(is_down)
			{
				ndobj.setUptime(Calendar.getInstance().getTime());
				ndobj.setSeverity(SeverityNames.CLEARED);
			}
			
			mn.updateNodeDetails(ndobj);
			if(old_fw != null)
			{
				if(ndobj.getUpgradestatus() == UPDATING)
				{
					if(!old_fw.equals(ndobj.getFwversion()))
					{
						setLogs(socket,"Firmware-Upgrade:Success",SeverityNames.NORMAL);
						removeUpgradeActivity(socket,SUCCESS);
					}
					else if(old_fw_date != null && !old_fw_date.equals(ndobj.getSwdate()))
					{
						setLogs(socket,"Firmware-Upgrade:Success",SeverityNames.NORMAL);
						removeUpgradeActivity(socket,SUCCESS);
					}
					else
					{
						setLogs(socket,"Firmware-Upgrade:Failed",SeverityNames.WARNING);
						removeUpgradeActivity(socket,FAILED);
					}
				}
			}
			
		}
		else
		{
			
			ndobj.setCreatedtime(Calendar.getInstance().getTime());
			OrganizationDataDao orgdatadao = new OrganizationDataDao();
			OrganizationData orgobj = orgdatadao.getOrganizationData(ndobj.getSlnumber());
			if(orgobj != null)
				ndobj.setOrganization(orgobj.getOrganization());
			int id = mn.addNodeDetails(ndobj);
			if(id > 0)
			{
				String almmsg = "Node "+ndobj.getSlnumber()+" is Discovered";
				M2MNodeOtages alarm = new M2MNodeOtages();
				alarm.setNodeid(ndobj.getId());
				//alarm.setAlarmInfo("Node "+ndobj.getSlnumber()+" is Discovered");
				alarm.setAlarmInfo(almmsg);
				alarm.setSeverity(SeverityNames.NORMAL);
				alarm.setUpdateTime(new Date());
				alarm.setSlnumber(ndobj.getSlnumber());
				M2MNodeOtagesDao aldao = new M2MNodeOtagesDao();
				aldao.addM2MNodeOtages(alarm);
			}
		}
		if(is_down)
			setOutages(socket,UPTIME_STR);

		return ndobj;
	}
}
