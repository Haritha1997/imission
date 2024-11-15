package com.nomus.m2m.controller;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.nomus.m2m.dao.LicDao;
import com.nomus.m2m.dao.M2MlogsDao;
import com.nomus.m2m.dao.OrganizationDao;
import com.nomus.m2m.dao.UserDao;
import com.nomus.m2m.mail.MailSender;
import com.nomus.m2m.mail.ResetLinkGenerator;
import com.nomus.m2m.pojo.M2Mlogs;
import com.nomus.m2m.pojo.Organization;
import com.nomus.m2m.pojo.SlNumbersRange;
import com.nomus.m2m.pojo.User;
import com.nomus.m2m.pojo.UserColumns;
import com.nomus.staticmembers.DateTimeUtil;
import com.nomus.staticmembers.M2MProperties;
import com.nomus.staticmembers.Symbols;
import com.nomus.staticmembers.UserRole;

/**
 * Servlet implementation class UserController
 */
@WebServlet("/user/UserController")
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UserController() {
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
	protected synchronized void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		OrganizationDao orgdao = new OrganizationDao();
		HttpSession httpsession=request.getSession();
		User loggedinuser = (User) httpsession.getAttribute("loggedinuser");
		User user = new User();
		UserDao udao = new UserDao();
		int userid = -1;
		int underid = request.getParameter("under")==null?-1:Integer.parseInt(request.getParameter("under"));
		String action = request.getParameter("action");
		String oldpwdchk = request.getParameter("chkoldpwd");
		boolean chkoldpwd = false;
		boolean mailsend=false;
		if(oldpwdchk != null)
			chkoldpwd = oldpwdchk.equals("false")?false:true;

		String errmsg="";
		String link="";
		String body="";
		Properties imission_m2m_props = M2MProperties.getM2MProperties();
		String s_username = imission_m2m_props.getProperty("username");
		String s_password = imission_m2m_props.getProperty("password");
		User underbyuser=new User();
		String uname = request.getParameter("username");

		User olduser = udao.getUserByUsername(request.getParameter("username"));
		M2MlogsDao logdao = new M2MlogsDao();
		M2Mlogs log = new M2Mlogs();
		Date updatetime = new Date(new java.util.Date().getTime());
		java.util.Date pwdupdate=DateTimeUtil.getOnlyDate(updatetime);
	if(!action.equals("forgotPassword")&& loggedinuser != null &&!loggedinuser.getRole().equals(UserRole.MAINADMIN))
			log.setGeneratedBy(loggedinuser);

		if(action.equals("save"))
		{		
			if(olduser == null)
			{
				user.setUsername(request.getParameter("username").trim());
				user.setPassword(request.getParameter("pass1").trim());
				user.setOldPwd1(request.getParameter("pass1").trim());
				user.setLastPwdUpdate(pwdupdate);
				user.setEmail(request.getParameter("email").trim());
				user.setRole(request.getParameter("sel_role").trim());
				user.setStatus("active");
				
				int act_node_cap = new LicDao().getLicenseDetails().getNodeLimit();
				//user.setStartRange(request.getParameter("startrange"));
				//user.setEndRange(request.getParameter("endrange"));
				String orgname = "";
				if(user.getRole().equals(UserRole.SUPERADMIN))
					orgname= request.getParameter("org_name").trim();
				else
					orgname = loggedinuser.getOrganization().getName();
				Organization org = orgdao.getOrganization(orgname);
				 
				if(udao.isUserlimitReached(loggedinuser, user.getRole(),underid))
					errmsg = user.getRole()+" limit Exceeded";
				else
				{
					if(org == null)
					{
						if(user.getRole().equals(UserRole.SUPERADMIN))
						{
							if(orgname.trim().length() > 0)
							{
								int nodeslimit = Integer.parseInt(request.getParameter("nodes_limit"));
								int curnodecp  = orgdao.getCurrentNodeCapacity();
								int total_nodes = nodeslimit+curnodecp;
								if(act_node_cap < total_nodes)
									errmsg = "Nodes Limit Exceeded. Nodes Limit is "+act_node_cap+" and "+curnodecp+" are assiggned. Rmaining Nodes Limit is "+(act_node_cap-curnodecp);
								
								org = new Organization();					 
								org.setNodesLimit(Integer.parseInt(request.getParameter("nodes_limit")));
								org.setUserlimit(Integer.parseInt(request.getParameter("no_of_users")));
								org.setValidUpto(DateTimeUtil.getDate(request.getParameter("valid_upto")));
								org.setName(orgname);
								org.setStatus("active");      
							}
							int userlimit = Integer.parseInt(request.getParameter("no_of_users"));
							if(userlimit>5)
								errmsg = "User limit Cannot Exceeded 5";
						}
						else
						{
							org = loggedinuser.getOrganization();
						}
					}
					else if(loggedinuser.getRole().equals(UserRole.MAINADMIN))
						errmsg = "Organization Already Exists! ...";
					if(!loggedinuser.getRole().equals(UserRole.MAINADMIN))
						user.setOrganization(loggedinuser.getOrganization());
					else 
						user.setOrganization(org);
					
					if(!loggedinuser.getRole().equals(UserRole.MAINADMIN))
					{

						if(!user.getRole().equals(UserRole.ADMIN) && loggedinuser.getRole().equals(UserRole.SUPERADMIN))
						{
							int id = Integer.parseInt(request.getParameter("under").trim());
							underbyuser = udao.getUser(id);
							if(udao.isUserlimitReached(underbyuser, user.getRole(),underid))
								errmsg = user.getRole()+" limit Exceeded";
							else
							{
								user.setUnder(underbyuser);
								log.setLoginfo(" user "+user.getUsername()+" Created by "+loggedinuser.getUsername()+" under "+underbyuser.getUsername());
							}
						}
						else if(loggedinuser.getRole().equals(UserRole.SUPERADMIN) ||loggedinuser.getRole().equals(UserRole.ADMIN))
						{
							if(user.getUnder() == null)	
							{
								user.setUnder(loggedinuser);
								log.setLoginfo("user "+user.getUsername()+" Created by "+loggedinuser.getUsername());
							}
						} 
						user.setCreatedBy(loggedinuser);
						//log.setLoginfo("user "+user.getUsername()+" Created by "+loggedinuser.getUsername());
						
					} 
					if(errmsg.length()==0)
					{
					if(loggedinuser.getRole().equals(UserRole.MAINADMIN))
						body ="You have Successfully Created User "+ user.getUsername() +" Under Organization " + orgname +" ....\n\n";
					else if((loggedinuser.getRole().equals(UserRole.SUPERADMIN)&&user.getRole().equals(UserRole.ADMIN))||(loggedinuser.getRole().equals(UserRole.ADMIN)))
						body ="You have Successfully Created User "+ user.getUsername() +" By "+ loggedinuser.getUsername() +" Under Organization " + orgname +" ....\n\n";	
					else
						body ="You have Successfully Created User "+ user.getUsername() +" By "+ loggedinuser.getUsername() +" Under User "+underbyuser.getUsername() +" Under Organization " + orgname +" ....\n\n";									
					try{
						
						body +="\n\nRegards,\n"+s_username.substring(0,s_username.indexOf("@"));
						MailSender mail = new MailSender(s_username, s_password, user.getEmail(), body);
						mailsend = mail.sendMailWithoutAttachFile();
					}
					catch (Exception e) {
						// TODO: handle exception
					}
					log.setUpdatetime(updatetime);
					log.setOrganization(user.getOrganization().getName());
					log.setSeverity("normal");
					}
				}
			}
			else
				errmsg = "Username "+uname+" is already Exists...";
		}
		else if(action.equals("modify"))
		{
			userid = request.getParameter("userid")==null?-1:Integer.parseInt(request.getParameter("userid"));
			if(olduser!= null && (olduser.getId() != userid))
				errmsg = "Username "+uname+" is already Exists...";
			else
			{
				user = udao.getUser(userid);
				olduser = user;
				String oldrole = olduser.getRole();
				List<User> userlist = udao.getUsersList(user, "active");
				user.setUsername(request.getParameter("username").trim());
				
				if(user.getRole().equals(UserRole.SUPERADMIN)&&loggedinuser.getRole().equals(UserRole.MAINADMIN))
				{
					String newpwd=request.getParameter("pass1").trim();
					String oldpwd1=user.getOldPwd1()==null?user.getPassword():user.getOldPwd1();
					int nodeslimit = Integer.parseInt(request.getParameter("nodes_limit"));
					int curnodecp  = orgdao.getCurrentNodeCapacity(user.getOrganization());
					int total_nodes = nodeslimit+curnodecp;
					int act_node_cap = new LicDao().getLicenseDetails().getNodeLimit();
					if(act_node_cap < total_nodes)
						errmsg = "Nodes Limit Exceeded. Nodes Limit is "+act_node_cap+" and "+curnodecp+" are assiggned. Rmaining Nodes Limit is "+(act_node_cap-curnodecp); 
					if(!olduser.getPassword().equals(newpwd))
					{
						if(newpwd.equals(oldpwd1)||newpwd.equals(user.getOldPwd2())||newpwd.equals(user.getOldPwd3()))
						errmsg ="Password Should not be one of Last 3 Passwords!";
					else
						{
							user.setPassword(request.getParameter("pass1").trim());
							user.setOldPwd3(user.getOldPwd2());
							user.setOldPwd2(user.getOldPwd1());
							user.setOldPwd1(request.getParameter("pass1").trim());
							user.setLastPwdUpdate(pwdupdate);
						}
					}
				}
				user.setEmail(request.getParameter("email").trim());
				user.setRole(request.getParameter("sel_role").trim());
				//user.setStartRange(request.getParameter("startrange"));
				//user.setEndRange(request.getParameter("endrange"));

				String orgname = user.getOrganization().getName();
				if(loggedinuser.getRole().equals(UserRole.MAINADMIN) && orgname.trim().length() > 0)
				{
					Organization org = user.getOrganization();
					org.setNodesLimit(Integer.parseInt(request.getParameter("nodes_limit")));
					org.setUserlimit(Integer.parseInt(request.getParameter("no_of_users")));
					org.setValidUpto(DateTimeUtil.getDate(request.getParameter("valid_upto")));
					org.setName(orgname);
					if(org.getStatus() != null && org.getStatus().equals("expired") && !DateTimeUtil.isExpired(org.getValidUpto()))
						org.setStatus("active");
					if(DateTimeUtil.isExpired(org.getValidUpto())) {
						org.setStatus("expired");
					}
					user.setOrganization(org);
					int userlimit = Integer.parseInt(request.getParameter("no_of_users"));
					if(user.getRole().equals(UserRole.SUPERADMIN))
						if(userlimit>5)
							errmsg = "User limit Cannot Exceeded 5";
				}
				if(!loggedinuser.getRole().equals(UserRole.MAINADMIN))
				{
					//int id = Integer.parseInt(request.getParameter("under").trim());
					log.setLoginfo("user "+user.getUsername()+" Modified by "+loggedinuser.getUsername());
					if(userlist.size()>0 && !user.getRole().equals(UserRole.ADMIN)&& !user.getRole().equals(UserRole.SUPERADMIN))
					{
						errmsg ="Not able change the Role. Users exists under this Admin.";
					}
					else if(userid == underid && !user.getRole().equals(UserRole.ADMIN))
					{
						errmsg ="User and Under  should not be same";
					}

					else if(!user.getRole().equals(UserRole.ADMIN) && !user.getRole().equals(UserRole.SUPERADMIN) && loggedinuser.getRole().equals(UserRole.SUPERADMIN))
					{
						underbyuser = udao.getUser(underid);

						if(udao.isUserlimitReached(underbyuser,user.getRole(),underid) && !user.getRole().equals(oldrole))
							errmsg = user.getRole()+" limit Exceeded";
						else
							user.setUnder(underbyuser);
					}

					else if(!user.getRole().equals(UserRole.SUPERADMIN))
					{

						if(udao.isUserlimitReached(loggedinuser, user.getRole(),underid) && !user.getRole().equals(oldrole)) 
							errmsg =user.getRole()+" limit Exceeded";
						else
							user.setUnder(loggedinuser);
					}
				}
				log.setUpdatetime(updatetime);
				log.setOrganization(user.getOrganization().getName());
				log.setSeverity("normal");
				if(errmsg.length()==0)
				{
					if(loggedinuser.getRole().equals(UserRole.MAINADMIN))
						body ="User "+ user.getUsername() +" Modified Under Organization " + orgname +"....\n\n";
					else if((loggedinuser.getRole().equals(UserRole.SUPERADMIN)&&user.getRole().equals(UserRole.ADMIN))||(loggedinuser.getRole().equals(UserRole.ADMIN)))
						body ="User "+ user.getUsername() +" Modified By "+ loggedinuser.getUsername() +" ....\n\n";	
					else
						body ="User "+ user.getUsername() +" Modified By "+ loggedinuser.getUsername() +" Under User "+underbyuser.getUsername() +" ....\n\n";									
					try{
						body +="\n\nRegards,\n"+s_username.substring(0,s_username.indexOf("@"));
						MailSender mail = new MailSender(s_username, s_password, user.getEmail(), body);
						mailsend = mail.sendMailWithoutAttachFile();
					}
					catch (Exception e) {
						// TODO: handle exception
					}
				}
			}
		}
		else if(action.equals("recover"))
		{		
			userid = request.getParameter("userID")==null?-1:Integer.parseInt(request.getParameter("userID"));
			user = udao.getUser(userid);
			user.setStatus("active");
			user.setDeletedBy(null);
			if(!loggedinuser.getRole().equals(UserRole.MAINADMIN))
			{
				log.setLoginfo("user "+user.getUsername()+" Recovered by "+loggedinuser.getUsername());
				if((loggedinuser.getRole().equals(UserRole.SUPERADMIN)&&user.getRole().equals(UserRole.ADMIN)))
				{
					if(udao.isUserlimitReached(loggedinuser, user.getRole(),underid))
						errmsg = user.getRole()+" limit Exceeded";
				}
				else if(!user.getRole().equals(UserRole.ADMIN) && !user.getRole().equals(UserRole.SUPERADMIN) && (loggedinuser.getRole().equals(UserRole.SUPERADMIN)||loggedinuser.getRole().equals(UserRole.ADMIN)))
				{
					underbyuser = udao.getUser(user.getUnder().getId());
					if(udao.isUserlimitReached(underbyuser,user.getRole(),user.getUnder().getId())) 
						errmsg = user.getRole()+" limit Exceeded";

				}
			}
			log.setUpdatetime(updatetime);
			log.setOrganization(user.getOrganization().getName());
			log.setSeverity("normal");
			if(errmsg.length()==0)
			{
				if((loggedinuser.getRole().equals(UserRole.SUPERADMIN)&&user.getRole().equals(UserRole.ADMIN))||(loggedinuser.getRole().equals(UserRole.ADMIN)))
					body ="User "+ user.getUsername() +" Recovered By "+ loggedinuser.getUsername() +" ....\n\n";	
				else
					body ="User "+ user.getUsername() +" Recovered By "+ loggedinuser.getUsername() +" Under User "+underbyuser.getUsername() +" ....\n\n";									
				body +="\n\nRegards,\n"+s_username.substring(0,s_username.indexOf("@"));
				MailSender mail = new MailSender(s_username, s_password, user.getEmail(), body);
				mailsend = mail.sendMailWithoutAttachFile();
			}
		}
		else if(action.equals("delete"))
		{
			userid = request.getParameter("userID")==null?-1:Integer.parseInt(request.getParameter("userID"));
			user = udao.getUser(userid);
			List<User> userlist = udao.getUsersList(user, "active");
			if(user.getRole().equals(UserRole.MAINADMIN) && user.getRole().equals(UserRole.SUPERADMIN))
				errmsg = "User cannot be deleted.......";
			else
			{
				if(user.getRole().equals(UserRole.ADMIN) && userlist.size()>0)
					errmsg = user.getUsername()+" cannot be deleted as it contains Users.......";
				else 
				{
					user.setStatus("deleted");
					if(!loggedinuser.getRole().equals(UserRole.MAINADMIN))
					{
						log.setLoginfo("user "+user.getUsername()+" Deleted by "+loggedinuser.getUsername());
						user.setDeletedBy(loggedinuser);
					}
					log.setUpdatetime(updatetime);
					log.setOrganization(user.getOrganization().getName());
					log.setSeverity("normal");
					if(errmsg.length()==0)
					{
						if((loggedinuser.getRole().equals(UserRole.SUPERADMIN)&&user.getRole().equals(UserRole.ADMIN))||(loggedinuser.getRole().equals(UserRole.ADMIN)))
							body ="User "+ user.getUsername() +" Deleted By "+ loggedinuser.getUsername() +" ....\n\n";	
						else
							body ="User "+ user.getUsername() +" Deleted By "+ loggedinuser.getUsername() +" Under User "+underbyuser.getUsername() +" ....\n\n";									
						body +="\n\nRegards,\n"+s_username.substring(0,s_username.indexOf("@"));
						MailSender mail = new MailSender(s_username, s_password, user.getEmail(), body);
						mailsend = mail.sendMailWithoutAttachFile();
					}
				}
				//udao.updateUser(user);
			}			
		}	

		else if(action.equals("ChangePassword"))
		{		
			userid = request.getParameter("userid")==null?-1:Integer.parseInt(request.getParameter("userid"));
			user = udao.getUser(userid);
			String newpswd = request.getParameter("pass1").trim();
			String oldpswd = request.getParameter("old_pass").trim();
			String oldpwd1=user.getOldPwd1()==null?oldpswd:user.getOldPwd1();
			if(!oldpswd.equals(user.getPassword()))
				errmsg ="Invalid Old Password!";
			else if(newpswd.equals(oldpwd1)||newpswd.equals(user.getOldPwd2())||newpswd.equals(user.getOldPwd3()))
				errmsg ="Password Should not be one of Last 3 Passwords!";
			else
			{
				user.setPassword(request.getParameter("pass1").trim());
				user.setOldPwd3(user.getOldPwd2());
				user.setOldPwd2(user.getOldPwd1());
				user.setOldPwd1(request.getParameter("pass1").trim());
				user.setLastPwdUpdate(pwdupdate);
			}
			log.setLoginfo("The Password of User "+user.getUsername()+" Changed by "+loggedinuser.getUsername());
			log.setUpdatetime(updatetime);
			log.setSeverity("normal");
			if(errmsg.length()==0)
			{
				if((loggedinuser.getRole().equals(UserRole.SUPERADMIN)&&user.getRole().equals(UserRole.ADMIN))||(loggedinuser.getRole().equals(UserRole.ADMIN)))
					body ="The Password of User "+ user.getUsername() +" Changed By "+ loggedinuser.getUsername() +" ....\n\n";	
				else
					body ="The Password of User "+ user.getUsername() +" Changed By "+ loggedinuser.getUsername() +" Under User "+underbyuser.getUsername() +" ....\n\n";									
				body +="\n\nRegards,\n"+s_username.substring(0,s_username.indexOf("@"));
				MailSender mail = new MailSender(s_username, s_password, user.getEmail(), body);
				mailsend = mail.sendMailWithoutAttachFile();
			}
		}
		
		else if(action.equals("forgotPassword"))
		{
			user = udao.getUserByUsername(uname);
			String usermail=request.getParameter("email");
			if(user!=null &&user.getUsername().equals(uname))
			{
				//System.out.println(user.getStatus());
				if(!user.getEmail().equals(usermail))
					errmsg ="Email not matched";
				else  if(user.getStatus().equals("deleted")||DateTimeUtil.isExpired(user.getOrganization().getValidUpto()))
					errmsg ="Mail cannot Send to the deleted/expired user";
				else
				{
					ResetLinkGenerator rgen=new ResetLinkGenerator();
					//String cururl = request.getRequestURL().toString();
					String cururl=request.getScheme() + "://" +request.getServerName() + ":" + request.getServerPort();
					//String cururl=request.getScheme() + "://" +"183.82.49.19"+":" + request.getServerPort();
					link=rgen.getResetLink(user,cururl);
					if(link!=null)
					{
						body ="The following link to reset the password ..."+link+"\n\n";
						body +="\n\nRegards,\n"+s_username.substring(0,s_username.indexOf("@"));
						MailSender mail = new MailSender(s_username, s_password, user.getEmail(), body);
						mailsend = mail.sendMailWithoutAttachFile();
						if(mailsend)
						{
							user.setLinkGenon(pwdupdate);
							user.setLinkstatus("active");
						}
					}
				}
			}
			else
				errmsg ="Invalid Username";
		}
		
		else if(action.equals("ResetPassword"))
		{		
			String usridstr = request.getParameter("userid");
			userid = (usridstr==null || usridstr.trim().length()==0)?-1:Integer.parseInt(request.getParameter("userid"));
			user = udao.getUser(userid);
			user.setUsername(user.getUsername());
			
			String newpswd = request.getParameter("pass1").trim();
			String oldpwd1="";
			
			if(!chkoldpwd)
				oldpwd1 =user.getOldPwd1()==null?user.getPassword():user.getOldPwd1();
			if(chkoldpwd)
			{
				String oldpswd = request.getParameter("old_pass").trim();
				oldpwd1 =user.getOldPwd1()==null?oldpswd:user.getOldPwd1();
				if(!oldpswd.equals(user.getPassword()))
					errmsg ="Invalid Old Password!";
			}
			if(newpswd.equals(oldpwd1)||newpswd.equals(user.getOldPwd2())||newpswd.equals(user.getOldPwd3()))
				errmsg ="Password Should not be one of Last 3 Passwords!";
			else if(user.getUsername() !="" && newpswd.toLowerCase().startsWith(user.getUsername()))
				errmsg += "Password should not start with Username "+user.getUsername() +"!";
			else 
			{
				user.setPassword(request.getParameter("pass1").trim());
				user.setOldPwd3(user.getOldPwd2());
				user.setOldPwd2(user.getOldPwd1());
				user.setOldPwd1(request.getParameter("pass1").trim());
				user.setLastPwdUpdate(pwdupdate);
				if(!chkoldpwd)
					user.setLinkstatus("expired");
			}
			log.setLoginfo("The Password of User "+user.getUsername()+" Updated Successfully");
			log.setUpdatetime(updatetime);
			log.setSeverity("normal");
			if(errmsg.length()==0)
			{
				body ="The Password of User "+ user.getUsername() +" Updated Successfully...\n\n";	
				body +="\n\nRegards,\n"+s_username.substring(0,s_username.indexOf("@"));
				MailSender mail = new MailSender(s_username, s_password, user.getEmail(), body);
				mailsend = mail.sendMailWithoutAttachFile();
			}
		}
		if(errmsg.length() == 0)
		{
			if(!action.equals("recover") && !action.equals("delete") && !action.equals("ChangePassword")&& !action.equals("ResetPassword")&& !action.equals("forgotPassword")&& !user.getRole().equals(UserRole.SUPERADMIN))
			{
				List<String> arealist = new ArrayList<String>();
				List<String> slnumlist = new ArrayList<String>();
				String areastr = request.getParameter("selloc");
				String slnumsstr = request.getParameter("selslnums");
				String areaarr[] = new String[0];
				if(areastr !=null) {
					areaarr = areastr.split(Symbols.DELIMITER);
					/*for(String area : areaarr)
					{
						UserArea uarea = new UserArea();
						uarea.setArea(area);
						uarea.setUser(user);
						arealist.add(uarea);
					}*/
				}
				Collections.addAll(arealist, areaarr);
				String slnumsarr[] = new String[0];
				if(slnumsstr!=null)
				{
					slnumsarr = slnumsstr.split(Symbols.DELIMITER);
					/*for(String slnumber : slnumsarr)
					{
						UserSlnumber slnumobj = new UserSlnumber();
						slnumobj.setSlnumber(slnumber);
						slnumobj.setUser(user);
						slnumlist.add(slnumobj);
					}*/			
				}
				Collections.addAll(slnumlist, slnumsarr);
				user.setArealist(arealist);
				user.setSlnumberlist(slnumlist);
			}
			if(user.getUserColumnsList() == null || user.getUserColumnsList().size() == 0) 
			{
				UserColumns usercolobj;
				usercolobj= new UserColumns();
				List<UserColumns> pusercollist=null;
				if(!loggedinuser.getRole().equals(UserRole.MAINADMIN))
					pusercollist = loggedinuser.getUserColumnsList();
				if(pusercollist != null)
				{
					for(UserColumns ucolobj : pusercollist)
					{
						if(ucolobj.getTableName().equals("dashboard"))
						{
							usercolobj.setActivesim(ucolobj.getActivesim());
							usercolobj.setCellular_Wan_IP(ucolobj.getCellular_Wan_IP());
							usercolobj.setFwversion(ucolobj.getFwversion());
							usercolobj.setImeinumber(ucolobj.getImeinumber());
							usercolobj.setLocation(ucolobj.getLocation());
							usercolobj.setLoopbackip(ucolobj.getLoopbackip());
							usercolobj.setModelnumber(ucolobj.getModelnumber());
							usercolobj.setNetwork(ucolobj.getNetwork());
							usercolobj.setNodelabel(ucolobj.getNodelabel());
							usercolobj.setPort1(ucolobj.getPort1());
							usercolobj.setPort2(ucolobj.getPort2());
							usercolobj.setPort3(ucolobj.getPort3());
							usercolobj.setPort4(ucolobj.getPort4());
							usercolobj.setWAN(ucolobj.getWAN());
							usercolobj.setRouteruptime(ucolobj.getRouteruptime());
							usercolobj.setSignalstrength(ucolobj.getSignalstrength());
							usercolobj.setSlnumber(ucolobj.getSlnumber());
							usercolobj.setTableName(ucolobj.getTableName());
							break;
						}
					}
				}
				usercolobj.setTableName("dashboard");

				List<UserColumns> usercollist = new ArrayList<UserColumns>();
				usercolobj.setUser(user);
				usercollist.add(usercolobj);
				user.setUserColumnsList(usercollist);
			}
			int rangeind = Integer.parseInt(request.getParameter("addrange_rwcnt")==null?"0":request.getParameter("addrange_rwcnt").trim());

			HashMap<Integer, SlNumbersRange> slnumrangemap = new HashMap<Integer, SlNumbersRange>();
			List<SlNumbersRange> slnumrangelist = user.getSlNumRangeList();
			if(slnumrangelist == null)
				slnumrangelist = new ArrayList<SlNumbersRange>();
			for(SlNumbersRange rangeobj: slnumrangelist)
				slnumrangemap.put(rangeobj.getId(), rangeobj);	
			for(int i = 2;i<=rangeind;i++)
			{
				String srange = request.getParameter("startrange"+i);
				String erange = request.getParameter("endrange"+i);
				String rclsid = request.getParameter("rgclsid"+i);
				if(srange != null && erange != null && srange.trim().length() > 0 && erange.trim().length() > 0)
				{
					if(rclsid != null && rclsid.trim().length() > 0)
					{
						SlNumbersRange slrange= slnumrangemap.get(Integer.parseInt(rclsid.trim()));
						if(slrange != null)
						{
							slrange.setStartRange(srange.trim());
							slrange.setEndRange(erange.trim());
							slrange.setUsr(user);
							slnumrangemap.remove(Integer.parseInt(rclsid));
						}
					}
					else
					{
						SlNumbersRange slrange = new SlNumbersRange();
						slrange.setUsr(user);
						slrange.setEndRange(erange);
						slrange.setStartRange(srange);
						slnumrangelist.add(slrange);
					}
				}

			}
			for(int i=slnumrangelist.size()-1;i>=0;i--)
			{
				SlNumbersRange rangeobj = slnumrangelist.get(i);
				if(slnumrangemap.get(rangeobj.getId()) != null)
					slnumrangelist.remove(i);
			}
			user.setUserColumnsList(user.getUserColumnsList());
			user.setSlNumRangeList(slnumrangelist);
			if(action.equals("save"))
			{
				int id = udao.addUser(user);
				if(loggedinuser.getId() == user.getId())
					log.setGeneratedTo(loggedinuser);
				else
					log.setGeneratedTo(user);
				if(id != -1)
				{
					if(!loggedinuser.getRole().equals(UserRole.MAINADMIN))
						logdao.addM2MLog(log);
				}
			}
			else
			{
				udao.updateUser(user);
				if(loggedinuser!=null&&user.getId() == loggedinuser.getId())
					httpsession.setAttribute("loggedinuser", user);
				if(!user.getRole().equals(UserRole.SUPERADMIN))
				{
					if(loggedinuser.getId() == user.getId())
					{
						log.setGeneratedBy(user);
						log.setGeneratedTo(user);
					}else
						log.setGeneratedTo(user);

					if(!loggedinuser.getRole().equals(UserRole.MAINADMIN))
					{
						user.setOrganization(loggedinuser.getOrganization());
							logdao.addM2MLog(log);
					}
				}
				
			}
			if(action.equals("ChangePassword"))
			{
				if(loggedinuser.getId() == user.getId())
					response.sendRedirect("/imission/message.jsp?status=Password Updated Successfully ");
				else
					response.sendRedirect("/imission/account/Changepassword.jsp");
			}
				
			
			else if(action.equals("ResetPassword"))
			{
				if(httpsession.getAttribute("reseturl") != null)
					httpsession.removeAttribute("reseturl");
				response.sendRedirect("/imission/linkexpired.jsp?status=Password Updated Successfully ");
			}
			else if(action.equals("forgotPassword"))
			{
				if(mailsend)
					response.sendRedirect("/imission/linkexpired.jsp?status=Reset Link sent to mail Successfully..Check mail once..");
				else
					response.sendRedirect("/imission/linkexpired.jsp?status=Unable to send the mail");
			}
			else
				response.sendRedirect("list.jsp");
		}
		else
		{
			request.getSession().setAttribute("status", errmsg);
			if(action.equals("modify"))
				response.sendRedirect("modifyUser.jsp?userID="+userid);
			else if(action.equals("recover"))
				response.sendRedirect("list.jsp?fetchtype=inactive");
			else if(action.equals("delete"))
				response.sendRedirect("list.jsp");
			else if(action.equals("ChangePassword"))
				response.sendRedirect("/imission/account/newPassword.jsp?userid="+userid);
			
			else if(action.equals("ResetPassword"))
			{
				if(chkoldpwd)
					response.sendRedirect("/imission/resetpassword.jsp");
				else
				{
					String resturl = httpsession.getAttribute("reseturl").toString();
					response.sendRedirect(resturl.substring(resturl.indexOf("/imission")));
				}
			}
			else if(action.equals("forgotPassword"))
				response.sendRedirect("/imission/forgotpwd.jsp");
			else
				response.sendRedirect("newUser.jsp");
		}
	}
}
