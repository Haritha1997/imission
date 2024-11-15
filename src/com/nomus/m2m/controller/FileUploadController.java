package com.nomus.m2m.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.nomus.staticmembers.FileCopy;

/**
 * Servlet implementation class FileUploadController
 */
@WebServlet("/FileUploadController")
@MultipartConfig(fileSizeThreshold=1024*1024*20,
maxFileSize=1024*1024*100,      	
maxRequestSize=1024*1024*200)
public class FileUploadController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FileUploadController() {
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
		// TODO Auto-generated method stub
		// String delpath= request.getParameter("delpath");
		 String destination = request.getParameter("destination");
		 
		 String redirectto = request.getParameter("redirectto");
		 String slnumber = request.getParameter("slnumber");
		 String version = request.getParameter("version");
		 
		 
		 String insname = request.getParameter("name");
		 if(insname == null)
			 insname = request.getParameter("inst_name");
		 
		 Part bulkfilePart = null;
		 if(destination.endsWith("/openvpn"))
			 bulkfilePart = request.getPart("catabfile");
		 else if(destination.endsWith("/client"))
		 {
			 bulkfilePart = request.getPart("certtabfile");
			 if(request.getPart("certtabfile")==null)
				 bulkfilePart = request.getPart("keytabfile");
		 }
		 else if(destination.endsWith("/hmac"))
			 bulkfilePart = request.getPart("hmactabfile"); 
		 else if(destination.endsWith("/user"))
			 bulkfilePart = request.getPart("uptabfile"); 
		 else if(destination.endsWith("/psk"))
			 bulkfilePart = request.getPart("pasktabfile");
		 boolean file_copied = false;
			String filepath = bulkfilePart.getSubmittedFileName();
			try
			{
				if(bulkfilePart != null)
					file_copied = FileCopy.copyFile(bulkfilePart, destination+"/"+filepath);
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
			if(file_copied)
				response.sendRedirect("m2m/wizngv2/"+redirectto+"?name="+URLEncoder.encode(insname,StandardCharsets.UTF_8.toString())+"&slnumber="+slnumber+"&version="+version+"&status="+filepath+" Uploaded Successfully");
			else
				response.sendRedirect("m2m/wizngv2/"+redirectto+"?name="+URLEncoder.encode(insname,StandardCharsets.UTF_8.toString())+"&slnumber="+slnumber+"&version="+version+"&status="+filepath+" Upload failed");
			/*
			 * for(String key : paramsmap.keySet())
			 * System.out.println(key+" : "+paramsmap.get(key)[0]);
			 */
	}

}
