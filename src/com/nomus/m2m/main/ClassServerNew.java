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
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;
import java.util.concurrent.TimeoutException;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;

import com.nomus.m2m.dao.M2MNodeOtagesDao;
import com.nomus.m2m.dao.M2MlogsDao;
import com.nomus.m2m.dao.NodedetailsDao;
import com.nomus.m2m.dao.OrganizationDataDao;
import com.nomus.m2m.pojo.M2MNodeOtages;
import com.nomus.m2m.pojo.M2Mlogs;
import com.nomus.m2m.pojo.NodeDetails;
import com.nomus.m2m.pojo.OrganizationData;
import com.nomus.staticmembers.DateTimeUtil;
import com.nomus.staticmembers.NodeStatus;


/*
 * ClassServer.java -- a simple file server that can serve
 * Http get request in both clear and secure channel
 */

public abstract class ClassServerNew implements Runnable {

	static Logger logger = Logger.getLogger(ClassServerNew.class.getName());
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
	private static final int NOSTATUS = 0;
	private static final String PROCEED_STR = "Proceed";
	private static final String SEND_CONFIG_STATUS = "Config-Status";
	private static final String EXPORT_STATUS = "Export-Status";
	private static final String STATUS_DETAILS = "Status-Details:";
	private static final String DIO_STATUS = "DIO-Events:";


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

	//private static Hashtable<K, V>

	/**
	 * Constructs a ClassServer based on <b>ss</b> and
	 * obtains a file's bytecodes using the method <b>getBytes</b>.
	 *
	 */
	protected ClassServerNew(ServerSocket ss)
	{
		server = ss;
		//checktime = Calendar.getInstance().getTime();
		mn = new NodedetailsDao();
		props = PropertiesManager.getM2MProperties();
		try
		{
			read_timeout = props.getProperty("readtimeout")==null?read_timeout:Integer.parseInt(props.getProperty("readtimeout").trim());
		}
		catch (Exception e) {
			// TODO: handle exception
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
				setLogs(socket,cmd,SeverityNames.NORMAL);
				removeUpgradeActivity(socket,SUCCESS);
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
				System.out.println("Send-Updates Response is : "+update +" at time "+new Date());
				byte[] bytes = (update+"\n").getBytes();
				rawout.write(bytes);
				rawout.flush();
				System.out.println("Send-Updates Response Sent Successfully at time "+new Date());
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
			else
			{
				rawout.write("".getBytes());
				rawout.flush();
			}
			//setInactiveNodes();
		}	
	}

	private void setNodeDown(String slnumber) {
		// TODO Auto-generated method stub
		NodeDetails node = mn.getNodeDetails("slnumber", slnumber);
		M2MNodeOtagesDao outagedao = new M2MNodeOtagesDao();
		if(node != null && node.getStatus().equals(NodeStatus.UP))
		{
			node.setStatus(NodeStatus.DOWN);
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
		if(ndobj == null || ndobj.getStatus().equals(DELETED_STR))
		{
			closeSocket(socket);
			return;
		}
		String status_arr[] = statusinfo.split(","); 
		if(status_arr.length >= 12)
		{
			ndobj.setIpsecstats(status_arr[0]);
			ndobj.setWanip(status_arr[1]);
			ndobj.setWanstatus(status_arr[2]);
			ndobj.setWanuptime(status_arr[3]);
			ndobj.setCelip(status_arr[4]);
			ndobj.setCelstatus(status_arr[5]);
			ndobj.setCeluptime(status_arr[6]);
			ndobj.setConintf(status_arr[7]);
			String ethport_status[] = status_arr[8].split(" ");
			if(ethport_status.length == 4)
			{
				ndobj.setSwitch1(ethport_status[0].equals("0")?"DOWN":"UP");
				ndobj.setSwitch2(ethport_status[1].equals("0")?"DOWN":"UP");
				ndobj.setSwitch3(ethport_status[2].equals("0")?"DOWN":"UP");
				ndobj.setSwitch4(ethport_status[3].equals("0")?"DOWN":"UP");
			}
			ndobj.setSignalstrength(status_arr[9]);
			ndobj.setRouteruptime(status_arr[10]);
			ndobj.setActivesim(status_arr[11]);
			if(status_arr.length >= 13)
				ndobj.setLoopbackip(status_arr[12]);
			if(status_arr.length >= 16)
			{
				//ndobj.setDio1(status_arr[13]);
				//ndobj.setDio2(status_arr[14]);
				//ndobj.setDio3(status_arr[15]);
			}
			mn.updateNodeDetails(ndobj);
		}
	}

	private void sendDatausage(Socket socket, OutputStream rawout, BufferedReader in ) {
		// TODO Auto-generated method stub
		String srcfile = "status.json";
		sendFile(socket, rawout, in, srcfile); 
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

	private boolean setOutages(Socket socket,String type) {
		// TODO Auto-generated method stub
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
			return true;
		}
		return false;
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
			return "Send-Updates:"+REBOOT;
		}
		else if(ndobj.getUpgrade().equals(YES_STR))
		{
			return "Send-Updates:"+FIRMWARE_UPGRADE;
		}		
		else if(ndobj.getBulkupdate()==1)
		{
			return "Send-Updates:"+BULK_UPDATE;
		}
		else if(ndobj.getOrgupdate() == 1)
		{
			return "Send-Updates:"+ORG_UPDATE;
		}
		else if(ndobj.getExport().equals(YES_STR))
		{
			return "Send-Updates:"+EXPORT_STR;
		}
		else if((ndobj.getSendconfig().equals(YES_STR) && ndobj.getBulkupdate() ==0) /*|| checkConfigExists(ndobj.getSlnumber())*/)
		{
			return ndobj.getBulkedit()==1?"Send-Updates:"+BULK_EDIT:"Send-Updates:"+CONFIGURATION;
		}
		else
		{
			return "Send-Updates:"+NONE;
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

			long length = Long.parseLong(in.readLine().replace("length:", "").replace("Data-Usage Length:", ""));
			rawout.write("send:yes\n".getBytes());
			rawout.flush();
			String cmd = in.readLine();

			if(cmd.equalsIgnoreCase("Sending Data-Usage file"))
			{
				System.out.println("send:yes for Data-Usage received successfully for serial number "+ndobj.getSlnumber()+" at time "+new Date());
				configfile= new File(tlssldir.getAbsolutePath()+File.separator+targetfilename);
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
				//Thread.sleep(9000);
				rawout.write(("Data-Usage Length:"+length+"\n").getBytes());
				rawout.flush();
				System.out.println("Sent:"+length+" for Data-Usage sent successfully for serial number "+ndobj.getSlnumber()+" at time "+new Date());
				/*
				 * if(configfile != null) { BasicFileAttributes fatr =
				 * Files.readAttributes(configfile.toPath(), BasicFileAttributes.class); }
				 */
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
			long length = Long.parseLong(in.readLine().replace("length:", "").replace("Send-Config Length:", ""));
			rawout.write("send:yes\n".getBytes());
			rawout.flush();
			String cmd = in.readLine();
			//logger.info("target file name is : "+targetfilename+" for receiveing WiZ_NG.zip is "+targetfilename);
			
			if(cmd.equalsIgnoreCase("Sending Send-Config file"))
			{
				configfile= new File(tlssldir.getAbsolutePath()+File.separator+targetfilename);
				tmpconfigfile= new File(tmpdir.getAbsolutePath()+File.separator+targetfilename);
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
				//Thread.sleep(9000);
				//System.out.println("File Copied..."+length+"  "+tmplen);
				rawout.write(("Send-Config Length:"+length+"\n").getBytes());
				rawout.flush();
				System.out.println("Sent:"+length+" for Send-Config is sent successfully for serial number "+ndobj.getSlnumber()+" at time "+new Date());
				/*
				 * if(configfile != null) { BasicFileAttributes fatr =
				 * Files.readAttributes(configfile.toPath(), BasicFileAttributes.class); }
				 */
				String udate = GetUpdates(socket);
				if(file_copied && !udate.equals("Send-Updates:"+BULK_UPDATE) && !udate.equals("Send-Updates:"+ORG_UPDATE) && !udate.equals("Send-Updates:"+EXPORT_STR) 
						&& !udate.equals("Send-Updates:"+CONFIGURATION) && !udate.equals("Send-Updates:"+BULK_EDIT))
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
						String len = FILE_STR+filename +" Length:"+fis.available()+"\n";
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
							dis.readFully(buff);
							rawOut.write(buff);
							rawOut.flush();
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
							dis.readFully(buff);
							rawOut.write(buff);
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
				mn.updateNodeDetails(ndobj);
				mn.setTaskStatusFailed(ndobj);
				return true;
			}
		}
		return false;
	}
	private NodeDetails saveDetails(Socket socket,String line,String organization) throws IOException {
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
		if(ndobj == null)
		{
			ndobj = new NodeDetails();
			is_exists = false;
		}
		else if(ndobj.getStatus().equals(DELETED_STR))
		{
			throw new IOException();
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
		
		if(is_exists)
		{
			if(is_down)
			{
				ndobj.setUptime(Calendar.getInstance().getTime());
				ndobj.setSeverity(SeverityNames.CLEARED);
			}
			mn.updateNodeDetails(ndobj);
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
				M2MNodeOtages alarm = new M2MNodeOtages();
				alarm.setNodeid(ndobj.getId());
				alarm.setAlarmInfo("Node "+ndobj.getSlnumber()+" is Discovered");
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
