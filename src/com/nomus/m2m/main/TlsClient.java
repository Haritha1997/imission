package com.nomus.m2m.main;

import java.net.*;
import java.io.*;
import javax.net.ssl.*;
import javax.security.cert.X509Certificate;
import java.security.KeyStore;

/*
 * This example shows how to set up a key manager to do client
 * authentication if required by server.
 *
 * This program assumes that the client is not inside a firewall.
 * The application can be modified to connect to a server outside
 * the firewall by following SSLSocketClientWithTunneling.java.
 */
public class TlsClient {

    public static void main(String[] args) throws Exception {
    	System.setProperty("javax.net.ssl.trustStore", "trustStore.jts");
    	System.setProperty("javax.net.ssl.trustStorePassword", "nomuscomm");
    	//System.setProperty("javax.net.ssl.trustStoreType","jts");
    	System.setProperty("javax.net.debug", "all");
    	//System.setProperty("https.cipherSuites","");
    	//System.setProperty("-Djava.net.preferIPv4Stack", "true");
        String host = "183.82.49.19";
        int port = 2222;
        String path = "";
		/*
		 * for (int i = 0; i < args.length; i++) System.out.println(args[i]);
		 * 
		 * if (args.length < 3) { System.out.println(
		 * "USAGE: java SSLSocketClientWithClientAuth " +
		 * "host port requestedfilepath"); System.exit(-1); }
		 * 
		 * try { host = args[0]; port = Integer.parseInt(args[1]); path = args[2]; }
		 * catch (IllegalArgumentException e) {
		 * System.out.println("USAGE: java SSLSocketClientWithClientAuth " +
		 * "host port requestedfilepath"); System.exit(-1); }
		 */
        try {

            /*
             * Set up a key manager for client authentication
             * if asked by the server.  Use the implementation's
             * default TrustStore and secureRandom routines.
             */
            SSLSocketFactory factory = null;
            try {
                SSLContext ctx;
                KeyManagerFactory kmf;
                KeyStore ks;
                char[] passphrase = "nomuscomm".toCharArray();

                ctx = SSLContext.getInstance("TLS");
                kmf = KeyManagerFactory.getInstance("SunX509");
                ks = KeyStore.getInstance("JKS");

                ks.load(new FileInputStream("keyStore.jks"), passphrase);

                kmf.init(ks, passphrase);
                ctx.init(kmf.getKeyManagers(), null, null);

                //ctx.init(null, null, null);
                factory = ctx.getSocketFactory();
            } catch (Exception e) {
                e.printStackTrace();
            }

            SSLSocket socket = (SSLSocket)factory.createSocket(host, port);

            /*
             * send http request
             *
             * See SSLSocketClient.java for more information about why
             * there is a forced handshake here when using PrintWriters.
             */
            socket.setEnabledProtocols(new String[]{"TLSv1.3"}); 
            socket.setEnabledCipherSuites(new String[] {"TLS_RSA_WITH_AES_256_CBC_SHA256"});
            socket.startHandshake();

            PrintWriter out = new PrintWriter(
                                  new BufferedWriter(
                                  new OutputStreamWriter(
                                  socket.getOutputStream())));
            //out.println("FILE " + path + " HTTP/1.0");
            out.println("FILE  " + path);
            //out.println("hello server");
            out.println();
            out.flush();
            Thread.sleep(30000);
            out.println("FILE  " + path);
            out.println();
            out.flush();
            Thread.sleep(30000);
            out.println("FILE  " + path);
            out.println();
            out.flush();
            Thread.sleep(30000);
            out.println("FILE  " + path);
            out.println();
            out.flush();
            Thread.sleep(30000);
            out.println("FILE  " + path);
            out.println();
            out.flush();
            /*
             * Make sure there were no surprises
             */
            if (out.checkError())
                System.out.println(
                    "SSLSocketClient: java.io.PrintWriter error");

            /* read response */
            BufferedReader in = new BufferedReader(
                                    new InputStreamReader(
                                    socket.getInputStream()));

            String inputLine;
            System.out.println("The response file data is : " );
            while ((inputLine = in.readLine()) != null)
                System.out.println(inputLine);               

            in.close();
            out.close();
            socket.close();

        } catch (Exception e) {
             e.printStackTrace();
        }
    }
}