package com.nomus.m2m.controller;

import java.io.IOException;
import java.util.Calendar;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.nomus.m2m.dao.BackUpDao;
import com.nomus.m2m.pojo.BackUp;
import com.nomus.m2m.schedulers.BackupService;

/**
 * Servlet implementation class DatabaseBackUpController
 */
@WebServlet("/SaveBackUpsettings")
public class SaveBackUpSettings extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SaveBackUpSettings() {
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
		HttpSession httpsession = request.getSession();
		String bkp_sts=request.getParameter("bkp_sts");
		int bkp_for_every=Integer.parseInt(request.getParameter("bkp_for_every"));
		String bkp_path=request.getParameter("bkp_path").trim();
		String send_mail=request.getParameter("send_mail");
		String receivermail=request.getParameter("receivermail").trim();
		
		String bkp_type=request.getParameter("bkp_type").trim();
		String remproto=request.getParameter("bkp_remopts");
		String username=request.getParameter("username").trim();
		String pwd=request.getParameter("pwd").trim();
		String ipaddr=request.getParameter("ipaddr").trim();
		String port=request.getParameter("port").trim();
		
		BackUpDao dbdao=new BackUpDao();
		BackUp backup=null;
		List<BackUp> backuplist = dbdao.getBackupList();
		if(backuplist.size() == 0)
			backup = new BackUp();
		else
			backup = backuplist.get(0);
		backup.setBackupSts(bkp_sts);
		backup.setBackupForEvery(bkp_for_every);
		backup.setBackupPath(bkp_path);
		backup.setSendMail(send_mail);
		backup.setReceiverMail(receivermail);
		backup.setBackupType(bkp_type);
		backup.setRemoteProtocol(remproto);
		backup.setUsername(username);
		backup.setPassword(pwd);
		backup.setIPaddress(ipaddr);
		backup.setPort(port);
		if(backuplist.size() == 0)
		{
			backup.setLastBackupDate(Calendar.getInstance().getTime());
			if(dbdao.addBackup(backup) == -1)
				httpsession.setAttribute("status", "Save Failed");
			else
				httpsession.setAttribute("status", "Save Success.");
		}
		else
		{
			if(!dbdao.updateBackup(backup))
				httpsession.setAttribute("status", "Update Failed");
			else
				httpsession.setAttribute("status", "Update Success.");
		}
		response.sendRedirect("backup.jsp");
	}
}
