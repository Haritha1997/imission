package com.nomus.m2m.main;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.ServerSocket;
import java.security.KeyStore;
import java.util.Properties;

import javax.net.ServerSocketFactory;
import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLServerSocket;
import javax.net.ssl.SSLServerSocketFactory;

import org.apache.log4j.PropertyConfigurator;

import com.nomus.m2m.dao.M2MNodeOtagesDao;
import com.nomus.m2m.dao.NodedetailsDao;
import com.nomus.m2m.schedulers.ReportScheduler;
import com.nomus.staticmembers.FileCreatetor;
import com.nomus.staticmembers.M2MProperties;


/* ClassFileServer.java -- a simple file server that can server
 * Http get request in both clear and secure channel
 *
 * The ClassFileServer implements a ClassServer that
 * reads files from the file system. See the
 * doc for the "Main" method for how to run this
 * server.
 */

public class TlsServer extends ClassServer {

	private static TlsServer curserver;
    private static ServerSocket ss;

    private static int DefaultServerPort = 2222;

    /**
     * Constructs a ClassFileServer.
     *
     * @param path the path where the server locates files
     */
    public TlsServer(ServerSocket ss, String docroot) throws IOException
    {
        super(ss);
        curserver = this;
    }

    /**
     * Returns an array of bytes containing the bytes for
     * the file represented by the argument <b>path</b>.
     *
     * @return the bytes for the file
     * @exception FileNotFoundException if the file corresponding
     * to <b>path</b> could not be loaded.
     */
    public byte[] getBytes(String path)
        throws IOException
    {
        System.out.println("reading: " + path);
        //File f = new File(docroot + File.separator + path);
        File f = new File(path);
        int length = (int)(f.length());
        if (length == 0) {
            throw new IOException("File length is zero: " + path);
        } else {
            FileInputStream fin = new FileInputStream(f);
			DataInputStream in = new DataInputStream(fin);

            byte[] bytecodes = new byte[length];
            in.readFully(bytecodes);
            System.out.println(new String(bytecodes));
            return bytecodes;                
        }
    }

    /**
     * Main method to create the class server that reads
     * files. This takes two command line arguments, the
     * port on which the server accepts requests and the
     * root of the path. To start up the server: <br><br>
     *
     * <code>   java ClassFileServer <port> <path>
     * </code><br><br>
     *
     * <code>   new ClassFileServer(port, docroot);
     * </code>
     */
    public static void main(String args[])
    {
    	Properties props = PropertiesManager.getM2MProperties();
    	System.setProperty("javax.net.ssl.trustStore", "trustStore.jts");
    	//System.setProperty("javax.net.ssl.trustStorePassword", "NOMUS123");
    	//System.setProperty("javax.net.ssl.trustStore", "tlstruststore.jts");
    	System.setProperty("javax.net.ssl.trustStorePassword", "nomuscomm");
    	System.setProperty("-Djava.net.preferIPv4Stack", "true");
    	System.out.println("Enable debugs : "+props.getProperty("enabledebug")+" "+(props.getProperty("enabledebug") != null && props.getProperty("enabledebug").equals("yes")));
    	if(props.getProperty("enabledebug") != null && props.getProperty("enabledebug").equals("yes"))
    	System.setProperty("javax.net.debug", "all");
    	System.setProperty("jdk.tls.client.protocols","TLSv1,TLSv1.1,TLSv1.2,TLSv1.3");
    	//System.setProperty("https.cipherSuites","TLS_RSA_WITH_AES_256_CBC_SHA256");
    	PropertyConfigurator.configure("log4j.properties");
        System.out.println(
            "USAGE: java ClassFileServer port docroot [TLS [true]]");
        System.out.println(
            "If the third argument is TLS, it will start as\n" +
            "a TLS/SSL file server, otherwise, it will be\n" +
            "an ordinary file server. \n" +
            "If the fourth argument is true,it will require\n" +
            "client authentication as well.");
        
        int port = DefaultServerPort;
		String docroot = "";

        if (args.length >= 1) {
            port = Integer.parseInt(args[0]);
        }
        System.out.println("port is "+port);
        if (args.length >= 2) {
            docroot = args[1];
        }
        String type = "PlainSocket";
        if (args.length >= 3) {
            type = args[2];
        }
        try {
            ServerSocketFactory ssf =
                TlsServer.getServerSocketFactory(type);
            ss = ssf.createServerSocket(port);
            if (args.length >= 4 && args[3].equals("true")) {
                ((SSLServerSocket)ss).setNeedClientAuth(true);
            }
            NodedetailsDao mn = new NodedetailsDao();
            M2MNodeOtagesDao m2moutcontroller = new M2MNodeOtagesDao();
            m2moutcontroller.setAllUpNodesDown();
            mn.setNodesStatusOnStartup();
            ReportScheduler rschduler =new ReportScheduler();
            rschduler.doSchedule();
            System.out.println("TLS Server started...");
			
        } catch (IOException e) {
            System.out.println("Unable to start ClassServer: " +e.getMessage());
            e.printStackTrace();
        }
    }

    public static void startService()
    {
    	Properties props = M2MProperties.getM2MProperties();
    	createRequiredFolders(props);
    	System.setProperty("javax.net.ssl.trustStore", "trustStore.jts");
    	//System.setProperty("javax.net.ssl.trustStorePassword", "NOMUS123");
    	//System.setProperty("javax.net.ssl.trustStore", "tlstruststore.jts");
    	System.setProperty("javax.net.ssl.trustStorePassword", "nomuscomm");
    	System.setProperty("-Djava.net.preferIPv4Stack", "true");
    	System.out.println("Enable debugs : "+props.getProperty("enabledebug")+" "+(props.getProperty("enabledebug") != null && props.getProperty("enabledebug").equals("yes")));
    	if(props.getProperty("enabledebug") != null && props.getProperty("enabledebug").equals("yes"))
    	System.setProperty("javax.net.debug", "all");
    	System.setProperty("jdk.tls.client.protocols","TLSv1,TLSv1.1,TLSv1.2,TLSv1.3");
    	//System.setProperty("https.cipherSuites","TLS_RSA_WITH_AES_256_CBC_SHA256");
    	PropertyConfigurator.configure("log4j.properties");
        System.out.println(
            "USAGE: java ClassFileServer port docroot [TLS [true]]");
        System.out.println(
            "If the third argument is TLS, it will start as\n" +
            "a TLS/SSL file server, otherwise, it will be\n" +
            "an ordinary file server. \n" +
            "If the fourth argument is true,it will require\n" +
            "client authentication as well.");
        int port = Integer.parseInt(props.getProperty("port").trim());
        try {
            ServerSocketFactory ssf = TlsServer.getServerSocketFactory("TLS");
            ServerSocket ss = ssf.createServerSocket(port);
                ((SSLServerSocket)ss).setNeedClientAuth(true);
            NodedetailsDao mn = new NodedetailsDao();
            M2MNodeOtagesDao m2moutcontroller = new M2MNodeOtagesDao();
            m2moutcontroller.setAllUpNodesDown();
            mn.setNodesStatusOnStartup();
			mn.setTaskStatusFailed();
            ReportScheduler rschduler =new ReportScheduler();
            rschduler.doSchedule();
            System.out.println("TLS Server started...");
			
        } catch (Throwable e) {
            System.out.println("Unable to start ClassServer: " +e.getMessage());
            e.printStackTrace();
        }
        System.clearProperty("javax.net.ssl.trustStore");
    	System.clearProperty("javax.net.ssl.trustStorePassword");
    }
    private static void createRequiredFolders(Properties props) {
		// TODO Auto-generated method stub
    	try
    	{
    		File tlsconf_file = new File(props.getProperty("tlsconfigspath"));
    		FileCreatetor.createFile(tlsconf_file);
    		File fw_file = new File(props.getProperty("firmwaredir"));
    		FileCreatetor.createFile(fw_file);
    		File http_file = new File(props.getProperty("httpserverpath"));
    		FileCreatetor.createFile(http_file);
    	}
    	catch (Exception e) {
			// TODO: handle exception
		}
	}

	private static ServerSocketFactory getServerSocketFactory(String type) {
        if (type.equals("TLS")) {
            SSLServerSocketFactory ssf = null;
            try {
                // set up key manager to do server authentication
                SSLContext ctx;
                KeyManagerFactory kmf;
                KeyStore ks;
                //char[] passphrase = "NOMUS123".toCharArray();
                char[] passphrase = "nomuscomm".toCharArray();

                ctx = SSLContext.getInstance("TLS");
                kmf = KeyManagerFactory.getInstance("SunX509");
                ks = KeyStore.getInstance("JKS");
                
                ks.load(new FileInputStream("keyStore.jks"), passphrase);
                //ks.load(new FileInputStream("tlsserverkeystore.jks"), passphrase);
                kmf.init(ks, passphrase);
                ctx.init(kmf.getKeyManagers(), null, null);
                //System.out.println(ctx.getServerSessionContext().getSessionTimeout());
                //ctx.init(null, null, null);
                
                ssf = ctx.getServerSocketFactory();
                return ssf;
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            return ServerSocketFactory.getDefault();
        }
        return null;
    }

	public static void stopService() {
		// TODO Auto-generated method stub
		try {
			ss.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}

