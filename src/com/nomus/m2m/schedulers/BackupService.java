package com.nomus.m2m.schedulers;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.log4j.Logger;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.taskdefs.optional.ssh.Scp;
import org.google.LicenseValidator;
import org.hibernate.cfg.Configuration;

import com.nomus.m2m.dao.BackUpDao;
import com.nomus.m2m.mail.MailSender;
import com.nomus.m2m.pojo.BackUp;
import com.nomus.staticmembers.DateTimeUtil;
import com.nomus.staticmembers.M2MProperties;

public class BackupService {

	static Logger logger = Logger.getLogger(BackupService.class.getName());
	String backup_filename="";
	public void takeBackUp()
	{
		try {
			BackUpDao dbdao=new BackUpDao();
			BackUp backup = null;
			List<BackUp> backuplist= dbdao.getBackupList();
			if(backuplist.size() > 0)
				backup = backuplist.get(0);
			Date curdate=Calendar.getInstance().getTime();
			if(backup == null||backup.getBackupSts().equals("No"))
				return;
			else
			{
				if(!timeToBackup(backup))
					return;
			}
			Configuration config = new Configuration().configure();
			String connectiourl = config.getProperty("connection.url");
			String[] parts = connectiourl.split(":");
			String host=null;
			String port=null;
			String dbName=null;
			Date lastbkp=backup.getLastBackupDate()==null?curdate:backup.getLastBackupDate();
			int bkpdays=backup.getBackupForEvery();
			if (parts.length > 2) {
				host=parts[2].replace("//", "");
				port=parts[3].split("/")[0];
				dbName=parts[3].split("/")[1];
			}
			File backup_dir = new File(backup.getBackupPath());

			if(!backup_dir.exists())
				backup_dir.mkdirs();
			Properties imission_m2m_props = M2MProperties.getM2MProperties();
			String s_username = imission_m2m_props.getProperty("username");
			String s_password = imission_m2m_props.getProperty("password");
			String msgbody="";
			boolean isLogin = false;
			if(createDatabaseBackup(dbName, "postgres", LicenseValidator.getDBpasword(), host, port, backup.getBackupPath()))
			{
				backup.setLastBackupDate(new Date());
				dbdao.updateBackup(backup);
				msgbody ="RMS BackUp has done today....\n\n";
				if(backup.getBackupType().equals("Remote"))
				{
					if(backup.getRemoteProtocol().equals("FTP"))
					{
						FTPClient ftpClient = new FTPClient();
						ftpClient.connect(backup.getIPaddress(), Integer.parseInt(backup.getPort()));
						isLogin =ftpClient.login(backup.getUsername(), backup.getPassword());
						if(isLogin)
						{
							ftpClient.enterLocalPassiveMode();
							ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
							//String backup_filename = "RMS"+DateTimeUtil.getDateString(new Date())+".backup";
							File locFile = new File(backup.getBackupPath()+File.separator+backup_filename);
							String remFile = backup_filename;
							InputStream instream = new FileInputStream(locFile);
							System.out.println("Start uploading file");
							OutputStream outputStream = ftpClient.storeFileStream(remFile);
							byte[] bytesIn = new byte[4096];
							int read = 0;

							while ((read = instream.read(bytesIn)) != -1) {
								outputStream.write(bytesIn, 0, read);
							}
							instream.close();
							outputStream.close();

							boolean completed = ftpClient.completePendingCommand();
							if (completed) {
								System.out.println("The file is uploaded successfully using FTP.");
								msgbody +="File Uploaded Successfully Using FTP.\n\n";
							}
							else
							{
								System.out.println("File Upload Failed");
								msgbody +="File Upload Failed using FTP.\n\n";
							}
						}
						else
						{
							System.out.println("FTP Server login Failed!!");
							msgbody += "FTP Server login Failed!!\n\n";
						}
					}
					if(backup.getRemoteProtocol().equals("SCP"))
					{
						if(Integer.parseInt(backup.getPort()) != 22)
						{
							System.out.println("SCP Server Login Failed!!");
							msgbody += "SCP Server Login Failed!!\n\n";
						}
						else
						{
							Scp scp = new Scp();
							scp.setPort(Integer.parseInt(backup.getPort()));
							scp.setLocalFile(backup.getBackupPath()+File.separator+backup_filename);
							scp.setTodir( backup.getUsername() + ":" + backup.getPassword() + "@" + backup.getIPaddress() + ":" + backup_filename );
							scp.setProject( new Project() );
							scp.setTrust( true );
							scp.execute();
							System.out.println("File Uploaded Successfully using SCP Protocol");
							msgbody += "File Uploaded Successfully using SCP Protocol.\n\n";
						}
					}
				}
			}
			else
				msgbody ="Backup failed....\n\n";
			if(backup.getSendMail().toLowerCase().equals("yes"))
			{
				try{
					msgbody +="\n\nRegards,\n"+s_username.substring(0,s_username.indexOf("@"));
					MailSender mail = new MailSender(s_username, s_password,backup.getReceiverMail() ,msgbody);
					mail.sendMailWithoutAttachFile();
				}
				catch (Exception e) {
					// TODO: handle exception
				}
			}
		}catch (Exception e) {
			// TODO: handle exception
			logger.error("Backup failed");
			logger.error(e.getMessage());
			logger.error("File Upload Failed");
		}

	}
	private static boolean timeToBackup(BackUp backup) {
		// TODO Auto-generated method stub
		if(backup.getLastBackupDate() != null)
		{
			int day=DateTimeUtil.getDaysDiff(backup.getLastBackupDate(),new Date()) ;
			return(day >= backup.getBackupForEvery());
		}
		else
			return false;
	}

	public boolean createDatabaseBackup(String dbName, String user, String password, String host, String port, String backuppath) {
		// Construct the pg_dump command
		boolean bkpdone=false;
		backup_filename = "RMS"+DateTimeUtil.getDateString(new Date())+".backup";
		String	command = String.format(
				"pg_dump -h %s -p %s -U %s -F c -b -v -f \"%s\" %s",
				host, port, user, backuppath+File.separator+backup_filename, dbName
				);
		ProcessBuilder processBuilder;
		String os = System.getProperty("os.name").toLowerCase();
		if (os.contains("win")) {
			processBuilder = new ProcessBuilder("cmd.exe", "/c", command);
		} else {
			processBuilder = new ProcessBuilder("bash", "-c", command);
		}
		processBuilder.redirectErrorStream(true);
		// Set environment variable for password
		//processBuilder.environment().put("PGPASSWORD", password);

		try {
			Process process = processBuilder.start();
			// Read the output stream of the process
			try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
			}
			// Read the error stream of the process
			try (BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()))) {
			}
			int exitCode = process.waitFor();
			if (exitCode == 0) {
				bkpdone=true;
			} else {
				bkpdone=false;
			}
		} catch (Exception e) {
			e.printStackTrace();
			bkpdone=false;
		}
		return bkpdone;
	}

}
