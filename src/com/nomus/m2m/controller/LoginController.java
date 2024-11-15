package com.nomus.m2m.controller;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.Date;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.nomus.m2m.dao.OrganizationDao;
import com.nomus.m2m.dao.UserDao;
import com.nomus.m2m.pojo.Organization;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.DateTimeUtil;
import com.nomus.staticmembers.TripleDES;
import com.nomus.staticmembers.UserRole;

@WebServlet("/LoginController")
public class LoginController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public LoginController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		boolean account_suspended = false;
		boolean user_expired = false;
		boolean user_deleted= false;
		String username = request.getParameter("j_username");
		String password = request.getParameter("j_password");
		Properties props = new Properties();
		FileReader fr=null;
		HttpSession session= request.getSession();
		String url="login.jsp";
		UserDao udao=new UserDao();
		File propsfile = null;
		try
		{
			propsfile = new File("user.properties");
			fr = new FileReader(propsfile);
			props.load(fr);
		}
		catch(Exception e)
		{
			System.out.println("props file does not exists at: "+propsfile.getAbsolutePath());
			e.printStackTrace();
		}
		finally {
			if(fr != null)
				fr.close();
		}
		try {
			TripleDES tripledes= new TripleDES();
			String decuname = tripledes.decrypt(props.getProperty("username"));
			String decpwd = tripledes.decrypt(props.getProperty("password"));
			//String uname = decuname.substring(4);
			//String pword = decpwd.substring(4);
			User user = null;
			if(username.equals(decuname) && password.equals(decpwd))
			{
				user = new User();
				user.setRole(UserRole.MAINADMIN);
				user.setUsername(UserRole.MAINADMIN);
				user.setPassword("");
				url = "organizationTree";
			}
			else
			{
				user= udao.getuser(username, password);
				
				if(user != null)
				{
					Organization org = user.getOrganization();
					int days = 0;
					Date date = new Date();
					if(!user.getStatus().equals("suspended") || (user.getStatus().equals("suspended") && 
					(user.getFreezeStart() == null ||  date.compareTo(DateTimeUtil.addHours(user.getFreezeStart(), user.getFreezeTime())) >= 0)))
					{
						user.setPwdAttempts(0);
						user.setFreezeStart(null);
						user.setFreezeTime(0);
						if(user.getStatus().equals("suspended"))
							user.setStatus("active");
						udao.updateUser(user);
					}
					else
						account_suspended = true;
					if(user.getLastPwdUpdate()!=null)
						days = DateTimeUtil.getDaysAfterPwdSet(user.getLastPwdUpdate());
					if(DateTimeUtil.isExpired(user.getOrganization().getValidUpto()))
					{
						user_expired = true;
						OrganizationDao orgdao = new OrganizationDao();
						org.setStatus("expired");
						orgdao.updateOrganization(org);
						session.setAttribute("loginerror", "User Expired.");
						url = "login.jsp";
					}
					else if(days>=90)
					{
						request.getSession().setAttribute("resetuser",user);
						url = "redirectuserpassword.jsp";
					}
					else if(user.getStatus() != null && user.getStatus().equals("deleted"))
					{
						session.setAttribute("loginerror", "User "+user.getUsername()+" was Deleted .");
						user_deleted=true;
						url = "login.jsp";
					}
					else if(account_suspended)
					{
						Date freezstart=user.getFreezeStart();
						Date freezeendtime=freezstart == null? null :DateTimeUtil.addHours(freezstart,user.getFreezeTime());
						session.setAttribute("loginerror"," Account Suspended Until "+DateTimeUtil.getDateTimeStringWithAMPM(freezeendtime));
						url = "login.jsp";
					}
					else
					{
						url = "dashboard.jsp";
					}
					
				}
				else
				{
					user= udao.getUserByUsername(username);
					if(user == null) 
						session.setAttribute("loginerror","Invalid Username.");
					else if(user.getStatus().equals("deleted"))
					{
						session.setAttribute("loginerror", "User "+user.getUsername()+" was Deleted .");
						user_deleted=true;
						url = "login.jsp";
					}
					else if(DateTimeUtil.isExpired(user.getOrganization().getValidUpto()))
					{
						Organization org = user.getOrganization();
						OrganizationDao orgdao = new OrganizationDao();
						org.setStatus("expired");
						orgdao.updateOrganization(org);
						session.setAttribute("loginerror", "User Expired.");
						url = "login.jsp";
					}
					else 
					{
						Date curtime=new Date();
						int pwdattempts=user.getPwdAttempts()==null?0:user.getPwdAttempts();
						int freeztm=user.getFreezeTime()==null?0:user.getFreezeTime();
						Date freezstart=user.getFreezeStart();
						Date freezeendtime=freezstart == null? null :DateTimeUtil.addHours(freezstart,freeztm);
							
						if(user.getPwdAttempts()!=null&&user.getPwdAttempts()==3 && freezeendtime != null && curtime.compareTo(freezeendtime) >= 0)
							pwdattempts = 0;
						else if(user.getPwdAttempts()!=null&&user.getPwdAttempts()==3)
							account_suspended = true;
						if(!account_suspended)
						{
							user.setPwdAttempts(pwdattempts+1);
							Date curdate=new Date();
							if(user.getPwdAttempts()>=3)
							{          
								user.setFreezeTime((user.getFreezeTime()==null || user.getFreezeTime() <= 0) ?1:2*user.getFreezeTime());
								user.setFreezeStart(curdate);
								user.setStatus("suspended");
								session.setAttribute("loginerror"," Account Suspended for "+user.getFreezeTime()+" Hour"+(user.getFreezeTime()>1?"s":""));
							}
							else
								session.setAttribute("loginerror"," Invalid Password "+ (3-user.getPwdAttempts()) + " Attempt"+(user.getPwdAttempts()<2?"s":"")+"  left ...");
							udao.updateUser(user);
						}
						else
							session.setAttribute("loginerror"," Account Suspended Until "+DateTimeUtil.getDateTimeStringWithAMPM(freezeendtime));
					}
					url = "login.jsp";
				}
			}
			if(user != null && !user_expired && !account_suspended &&!user_deleted && !url.equals("login.jsp"))
			{
				session.setAttribute("loggedinuser",user);
			}
			response.sendRedirect(url);
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
		
}
