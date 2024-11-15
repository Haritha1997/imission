package com.nomus.staticmembers;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.ProcessBuilder.Redirect;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Vector;

public class CertificatesGenerator {
	int validupto;
	String cn;
	public CertificatesGenerator(int validupto,String cn)
	{
		this.validupto = validupto;
		this.cn = cn;
	}

	/*
	 * public static void main(String[] args) { CertificatesGenerator certgen = new
	 * CertificatesGenerator(); certgen.generateCertificates(validupto, cn); }
	 */
	public CertificatesGenerator()
	{
	}

	public void excecuteCommand(String cmd)
	{
		//System.out.println(cmd);
		final ProcessBuilder processBuilder = new ProcessBuilder("cmd.exe", "/c", cmd);

		processBuilder.redirectError(Redirect.INHERIT);
		processBuilder.redirectOutput(Redirect.INHERIT);

		// if you don't want to show anything
		//processBuilder.redirectError(ProcessBuilder.Redirect.PIPE);
		//processBuilder.redirectOutput(ProcessBuilder.Redirect.PIPE);

		Process process = null;
		try {
			process = processBuilder.start();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		int exitCode=-1;
		try {
			exitCode = process.waitFor();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//System.out.println(exitCode);
	}
	public void generateCertificates(int valid_days, String cn)
	{
		//Properties m2mprops = M2MProperties.getM2MProperties();
		//String targetfilename = m2mprops.getProperty("targetfilename")==null?"":m2mprops.getProperty("targetfilename");
		Vector<String> cmds_vec = new Vector<>();
		sleep(1000);
		File certdir = new File("certs");
		if(!certdir.exists())
			certdir.mkdir();
		else
		{
			for(File delfile : certdir.listFiles())
				delfile.delete();
		}
		sleep(1000);
		try {
			//runtobj.exec(new String[] {"cmd","/C","Start","openssl req -newkey rsa:4096 -keyout ca-key.pem -out ca-cert.pem -subj '/C=IN/ST=TS/L=HYD/O=Nomus/OU=M2M/CN=gurupc/emailAddress=issuer@nomus.com\'"});
			//Scanner sc= new Scanner(System.in);
			//System.out.println("Enter how many days certificates are valid and the common name you want:");
			/*
			 * int valid_days = 365; String cn = "imission";
			 */
			//sc.close();
			//runtobj.exec("cmd.exe /c start batchfile.bat "+valid_days+" "+cn);
			//runtobj.exec("cmd.exe /c start cmd.exe /C \"openssl req -x509 -newkey rsa:4096 -days "+valid_days+" -passout pass:nomuscomm -keyout ca-key.pem -out ca-cert.pem -subj \"/C=IN/ST=TS/L=HYD/O=Nomus/OU=M2M/CN="+cn+"/emailAddress=issuer@nomus.com\" && openssl pkcs12 -export -inkey ca-key.pem -in ca-cert.pem -out ca.p12 -passin pass:nomuscomm -passout pass:nomuscomm && openssl req -newkey rsa:4096 -passout pass:nomuscomm -keyout client-key.pem -out client-req.pem -subj \"/C=IN/ST=TS/L=HYD/O=Nomus/OU=M2M/CN=localhost/emailAddress=client@nomus.com\" && openssl x509  -req -in client-req.pem -days "+valid_days+" -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem -passin pass:nomuscomm && openssl pkcs12 -export -out clientkeyStore.p12 -inkey client-key.pem -in client-cert.pem -passin pass:nomuscomm -passout pass:nomuscomm && openssl req -newkey rsa:4096 -passout pass:nomuscomm -keyout server-key.pem -out server-req.pem -subj \"/C=IN/ST=TS/L=HYD/O=Nomus/OU=M2M/CN="+cn+"/emailAddress=server@nomus.com\" && openssl x509 -req -in server-req.pem -days "+valid_days+" -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -passin pass:nomuscomm && openssl pkcs12 -export -out serverkeyStore.p12 -inkey server-key.pem -in server-cert.pem -passin pass:nomuscomm -passout pass:nomuscomm\"");
			cmds_vec.add("openssl req -x509 -newkey rsa:4096 -days "+valid_days+" -passout pass:nomuscomm -keyout "+certdir.getName()+File.separator+"ca-key.pem -out "+certdir.getName()+File.separator+"ca-cert.pem -subj \"/C=IN/ST=TS/L=HYD/O=Nomus/OU=M2M/CN="+cn+"/emailAddress=issuer@nomus.com\"");
			cmds_vec.add("openssl pkcs12 -export -inkey "+certdir.getName()+File.separator+"ca-key.pem -in "+certdir.getName()+File.separator+"ca-cert.pem -out "+certdir.getName()+File.separator+"ca.p12 -passin pass:nomuscomm -passout pass:nomuscomm");
			cmds_vec.add("openssl req -newkey rsa:4096 -passout pass:nomuscomm -keyout "+certdir.getName()+File.separator+"client-key.pem -out "+certdir.getName()+File.separator+"client-req.pem -subj \"/C=IN/ST=TS/L=HYD/O=Nomus/OU=M2M/CN=localhost/emailAddress=client@nomus.com\"");
			cmds_vec.add("openssl x509  -req -in "+certdir.getName()+File.separator+"client-req.pem -days "+valid_days+" -CA "+certdir.getName()+File.separator+"ca-cert.pem -CAkey "+certdir.getName()+File.separator+"ca-key.pem -CAcreateserial -out "+certdir.getName()+File.separator+"client-cert.pem -passin pass:nomuscomm");
			cmds_vec.add("openssl pkcs12 -export -out "+certdir.getName()+File.separator+"clientkeyStore.p12 -inkey "+certdir.getName()+File.separator+"client-key.pem -in "+certdir.getName()+File.separator+"client-cert.pem -passin pass:nomuscomm -passout pass:nomuscomm");
			//cmds_vec.add("openssl req -newkey rsa:4096 -passout pass:nomuscomm -keyout "+certdir.getName()+File.separator+"server-key.pem -out "+certdir.getName()+File.separator+"server-req.pem -subj \"/C=IN/ST=TS/L=HYD/O=Nomus/OU=M2M/CN="+cn+"/emailAddress=server@nomus.com\"");
			//cmds_vec.add("openssl x509 -req -in "+certdir.getName()+File.separator+"server-req.pem -days "+valid_days+" -CA "+certdir.getName()+File.separator+"ca-cert.pem -CAkey "+certdir.getName()+File.separator+"ca-key.pem -CAcreateserial -out "+certdir.getName()+File.separator+"server-cert.pem -passin pass:nomuscomm ");
			//cmds_vec.add("openssl pkcs12 -export -out "+certdir.getName()+File.separator+"serverkeyStore.p12 -inkey "+certdir.getName()+File.separator+"server-key.pem -in "+certdir.getName()+File.separator+"server-cert.pem -passin pass:nomuscomm -passout pass:nomuscomm");

			for(String cmd : cmds_vec)
				excecuteCommand(cmd);
			Path oldfile1 = Paths.get(certdir.getName()+File.separator+"ca.p12");
			Path newfile1 = Paths.get("trustStore.jts");
			Path oldfile2 = Paths.get(certdir.getName()+File.separator+"clientKeyStore.p12");
			Path newfile2 = Paths.get("clientKeyStore.jks");
			//Path oldfile3 = Paths.get(certdir.getName()+File.separator+"serverKeyStore.p12"); 
			//Path newfile3 = Paths.get("serverKeyStore.jks");
			Files.move(oldfile1, oldfile1.resolveSibling(newfile1), StandardCopyOption.REPLACE_EXISTING);
			Files.move(oldfile2, oldfile2.resolveSibling(newfile2), StandardCopyOption.REPLACE_EXISTING);
			//Files.move(oldfile3, oldfile3.resolveSibling(newfile3), StandardCopyOption.REPLACE_EXISTING);
			System.out.println("Certificates Created Successfully....");
			sleep(1000);
		} catch (Exception e) {
			System.out.println("Error occured while creating Certificaes!!!!");
			e.printStackTrace();
		}
	}
	private void printLog(Process proc)
	{
		int exitVal=-1;
		try {
			exitVal = proc.waitFor();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		InputStream stdIn = null;
		InputStreamReader isr = null;
		BufferedReader br = null;
		try
		{
			stdIn = proc.getInputStream();
			isr = new InputStreamReader(stdIn);
			br = new BufferedReader(isr);

			String line = null;

			while ((line = br.readLine()) != null)
			{
				//System.out.println(line);
			}
			br.close();
			isr.close();
			stdIn.close();

			stdIn = proc.getErrorStream();
			isr = new InputStreamReader(stdIn);
			br = new BufferedReader(isr);

			while ((line = br.readLine()) != null)
			{
				//System.out.println(line);
			}


			System.out.println("Process : "+exitVal);
			proc.destroyForcibly();
		}
		catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		finally {
			try {
				if(br != null)
					br.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				if(isr != null)
					isr.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				if(stdIn != null)
					stdIn.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	public void sleep(int millis)
	{
		try
		{
			Thread.sleep(millis);
		}
		catch (Exception e) {
			// TODO: handle exception
		}
	}
}
