package com.nomus.m2m.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.nomus.staticmembers.M2MProperties;

/**
 * Servlet implementation class DownloadConfigFile
 */
@WebServlet("/m2m/DownloadConfigFile")
public class DownloadConfigFile extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public DownloadConfigFile() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String slnumber = request.getParameter("slnumber");
		Properties props = M2MProperties.getM2MProperties();
		String targetfilename = props.getProperty("targetfilename")==null?"":props.getProperty("targetfilename");
		String tlsconfigspath = props.getProperty("tlsconfigspath")==null?"":props.getProperty("tlsconfigspath");
		File tlsdir = new File(tlsconfigspath+File.separator+slnumber);
		if(tlsdir.exists())
		{
			File downloadFile = new File(tlsdir+File.separator+targetfilename);
			if(downloadFile.exists())
			{
				//File  destfile = new File("Downloads"+File.separator+slnumber+File.separator+targetfilename);
				response.setContentType("application/octet-stream");
				response.setContentLength((int) downloadFile.length());

				// forces download
				String headerKey = "Content-Disposition";
				String headerValue = String.format("attachment; filename=\"%s\"", slnumber+".zip");
				response.setHeader(headerKey, headerValue);

				// obtains response's output stream
				ServletOutputStream outStream = response.getOutputStream();
				InputStream in = null;
				try
				{
					in = new FileInputStream(downloadFile);
					byte[] buffer = new byte[4096];
					int bytesRead = -1;

					while ((bytesRead = in.read(buffer)) != -1) {
						outStream.write(buffer, 0, bytesRead);
					}
				}
				catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}
				finally
				{
					if(in != null)
						in.close();
					if(outStream != null)
						outStream.close();
				}
			}
		}
	}

}
