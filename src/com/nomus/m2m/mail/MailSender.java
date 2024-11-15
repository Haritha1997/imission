package com.nomus.m2m.mail;

import java.io.File;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import com.nomus.m2m.dao.M2MDetailsDao;
import com.nomus.m2m.pojo.M2MDetails;
import com.sun.mail.smtp.SMTPTransport;

public class MailSender {

	String from = "", username = "", to = "", password = "", reportname = "", msgbody = "";
	File attach_file = null;

	public MailSender(String username, String password, String toadd, File attach_file, String reportname) {
		this.username = username;
		this.password = password;
		this.to = toadd;
		this.attach_file = attach_file;
		this.reportname = reportname;
	}

	public MailSender(String username, String password, String toadd, String msgbody) {
		if(username.length()>0&&password.length()>0)
		{
			this.username = username;
			this.password = password;
			this.to = toadd;
			this.msgbody = msgbody;
		}
	}

	public boolean sendMail() {
		boolean mailsent = false;
		String host = "";
		from = username;
		if (from.toLowerCase().endsWith("@outlook.com"))
			host = "smtp.live.com";
		if (from.toLowerCase().endsWith("@gmail.com"))
			host = "smtp.gmail.com";
		if (from.toLowerCase().endsWith("@yahoo.com"))
			host = "smtp.mail.yahoo.com";

		// System.out.println("from : "+from+" To: "+to+" username : "+username+"
		// Password : "+password);
		Properties properties = System.getProperties();
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.smtp.starttls.enable", "true");
		properties.put("mail.smtp.host", host);
		properties.put("mail.smtp.port", "587");
		//properties.put("mail.smtp.ssl.trust", "smtp.gmail.com");

		Session session = Session.getInstance(properties, new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});

		try {
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(from));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
			message.setSubject("Schedule Reports-" + reportname);


			BodyPart bodypart1 = new MimeBodyPart();
			bodypart1.setText("Hi,\n    Please find the attachment. \n Regards,\nIMission.");
			SMTPTransport t = (SMTPTransport) session.getTransport("smtp");

			DataSource source = new FileDataSource(attach_file);
			BodyPart bodypart2 = new MimeBodyPart();
			bodypart2.setDataHandler(new DataHandler(source));
			bodypart2.setFileName(attach_file.getName());

			Multipart multipart = new MimeMultipart();
			multipart.addBodyPart(bodypart1);
			multipart.addBodyPart(bodypart2);

			message.setContent(multipart);
			t.connect(host, username, password);
			t.send(message, message.getAllRecipients());
			t.close();
			mailsent = true;
		} catch (MessagingException mx) {
			mx.printStackTrace();

		}
		return mailsent;
	}

	/*
	 * public static void main(String[] args) {
	 * 
	 * File tfile = new File("testingfile"); try { tfile.createNewFile(); } catch
	 * (IOException e) { // TODO Auto-generated catch block }
	 * 
	 * MailSender msender = new MailSender("nomusmailer@gmail.com",
	 * "hxgyegchcntpyjsb", "pallavireddychennuri@gmail.com", "HII I am Haritha");
	 * msender.sendMailWithoutAttachFile();
	 * System.out.println("Message sent successfully..."); }
	 */
	public boolean sendMailWithoutAttachFile() {
		boolean mailsent = false;
		//String host = "";
		//int port;
		if(username.length()>0&&password.length()>0)
		{
			//from = username;
			//if (from.toLowerCase().endsWith("@outlook.com"))
			//	host = "smtp.live.com";
			//if (from.toLowerCase().endsWith("@gmail.com"))
			//	host = "smtp.gmail.com";
			//if (from.toLowerCase().endsWith("@yahoo.com"))
			//	host = "smtp.mail.yahoo.com";
			//if (from.toLowerCase().endsWith("@nomus.in"))
			//	host = "smtp.office365.com";

			//Properties properties = System.getProperties();
			M2MDetailsDao m2mdao = new M2MDetailsDao();
			M2MDetails m2mdls = m2mdao.getM2MDetails(1);
			Properties properties = new Properties();
			properties.put("mail.smtp.auth", "true");
			properties.put("mail.smtp.starttls.enable", "true");
			//properties.put("mail.smtp.host", "smtp.office365.com");
			properties.put("mail.smtp.host", m2mdls.getSmtpserver());
			properties.put("mail.smtp.port", m2mdls.getSmtptport());
			//properties.put("mail.debug", "true");
			properties.put("mail.smtp.ssl.trust", m2mdls.getSmtpserver());
			//properties.put("mail.transport.protocol", "smtp");


			//properties.put("mail.smtp.ssl.trust", "smtp.gmail.com");
			Session session = Session.getInstance(properties, new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(username, password);
				}
			});
			try {
				Message message = new MimeMessage(session);
				message.setFrom(new InternetAddress(username));
				message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
				if(msgbody.contains("resetpassword.jsp"))
					message.setSubject("Reset Password Link");
				else if(msgbody.contains("Batch is About To Expire"))
					message.setSubject("Batch is About To Expire ");
				else if(msgbody.contains("RMS BackUp"))
					message.setSubject("RMS BackUp");
				
				else
					message.setSubject("UserInfo");

				BodyPart body = new MimeBodyPart();
				body.setText(msgbody);
				SMTPTransport t = (SMTPTransport) session.getTransport("smtp");
				Multipart multipart = new MimeMultipart();
				multipart.addBodyPart(body);
				message.setContent(multipart);
				t.connect(m2mdls.getSmtpserver(), username, password);
				t.send(message, message.getAllRecipients());
				t.close();
				mailsent = true;

			} catch (Exception e) {
				mailsent = false;
				e.printStackTrace();
			}
		}
		return mailsent;
	}

	/*
	 * public static void main(String[] args) { MailSender msend = new
	 * MailSender("delhi@nomus.in","Nomuscomm@123",
	 * "pallavichennuri11@gmail.com","Hi.. Mail sent from office365.com	");
	 * msend.sendMailWithoutAttachFile(); }
	 */

}
